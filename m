Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9604B1CA98E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgEHL0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:26:45 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:36290 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgEHL0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:26:45 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 048BQWHx080043;
        Fri, 8 May 2020 06:26:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588937192;
        bh=59VYB5TqRFxnmRNyD8u6HRAxzU/a6sf4iKSTn4oOQzA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=HCblZ/SSbdo4z7ACUnywHRQk9hZwl8xh8IAKwgMlb92rREXbgD/4+8OTaQHvbW74+
         94Pi4sXtL/EufgBOD68f52by7vsMdKJQKL13Cd2JX7/rV1uuZ6Poe1wp7GpxjXpW4R
         +2Eusl0qWBvv/bDqD7Dugwlybn7jgMkg3aFFFWcY=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 048BQWkj126699
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 8 May 2020 06:26:32 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 8 May
 2020 06:26:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 8 May 2020 06:26:31 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 048BQTEB060866;
        Fri, 8 May 2020 06:26:29 -0500
Subject: Re: [PATCH net-next v2] net: ethernet: ti: fix some return value
 check of cpsw_ale_create()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
References: <20200508021059.172001-1-weiyongjun1@huawei.com>
 <20200508100649.1112-1-weiyongjun1@huawei.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <da50aa53-a967-83b7-0737-701ab30228e4@ti.com>
Date:   Fri, 8 May 2020 14:26:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508100649.1112-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/05/2020 13:06, Wei Yongjun wrote:
> cpsw_ale_create() can return both NULL and PTR_ERR(), but all of
> the caller only check NULL for error handling. This patch convert
> it to only return PTR_ERR() in all error cases, all the caller using
> IS_ERR() install of NULL test.
> 
> Also fix a return negative error code from the cpsw_ale_create()
> error handling case instead of 0 in am65_cpsw_nuss_probe().
> 
> Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
> Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")

^ I do not think it can be back-ported so far back.
So, or drop second "Fixes: 4b41d3436796"
or split am65-cpsw-nuss.c changes

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
> v1 -> v2: fix cpsw_ale_create() to retuen PTR_ERR() in all places as Grygorii's suggest

Pls, do not send v2 as reply on v1.


> ---
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 ++-
>   drivers/net/ethernet/ti/cpsw_ale.c       | 2 +-
>   drivers/net/ethernet/ti/cpsw_priv.c      | 4 ++--
>   drivers/net/ethernet/ti/netcp_ethss.c    | 4 ++--
>   4 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 8cdbb2b9b13a..5530d7ef77a6 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -2074,8 +2074,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
>   	ale_params.nu_switch_ale = true;
>   
>   	common->ale = cpsw_ale_create(&ale_params);
> -	if (!common->ale) {
> +	if (IS_ERR(common->ale)) {
>   		dev_err(dev, "error initializing ale engine\n");
> +		ret = ERR_PTR(common->ale);

../include/linux/err.h:24:35: note: expected ‘long int’ but argument is of type ‘struct cpsw_ale *’
  static inline void * __must_check ERR_PTR(long error)
                                    ^~~~~~~
../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1900:7: warning: assignment makes integer from pointer without a cast [-Wint-conversion]
    ret = ERR_PTR(common->ale);
        ^


>   		goto err_of_clear;
>   	}
>   
> diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
> index 0374e6936091..8dc6be11b2ff 100644
> --- a/drivers/net/ethernet/ti/cpsw_ale.c
> +++ b/drivers/net/ethernet/ti/cpsw_ale.c
> @@ -955,7 +955,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
>   
>   	ale = devm_kzalloc(params->dev, sizeof(*ale), GFP_KERNEL);
>   	if (!ale)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>   
>   	ale->p0_untag_vid_mask =
>   		devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index 9d098c802c6d..d940628bff8d 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -504,9 +504,9 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
>   	ale_params.ale_ports		= CPSW_ALE_PORTS_NUM;
>   
>   	cpsw->ale = cpsw_ale_create(&ale_params);
> -	if (!cpsw->ale) {
> +	if (IS_ERR(cpsw->ale)) {
>   		dev_err(dev, "error initializing ale engine\n");
> -		return -ENODEV;
> +		return PTR_ERR(cpsw->ale);
>   	}
>   
>   	dma_params.dev		= dev;
> diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
> index 9d6e27fb710e..28093923a7fb 100644
> --- a/drivers/net/ethernet/ti/netcp_ethss.c
> +++ b/drivers/net/ethernet/ti/netcp_ethss.c
> @@ -3704,9 +3704,9 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
>   		ale_params.nu_switch_ale = true;
>   	}
>   	gbe_dev->ale = cpsw_ale_create(&ale_params);
> -	if (!gbe_dev->ale) {
> +	if (IS_ERR(gbe_dev->ale)) {
>   		dev_err(gbe_dev->dev, "error initializing ale engine\n");
> -		ret = -ENODEV;
> +		ret = PTR_ERR(gbe_dev->ale);
>   		goto free_sec_ports;
>   	} else {
>   		dev_dbg(gbe_dev->dev, "Created a gbe ale engine\n");
> 

-- 
Best regards,
grygorii
