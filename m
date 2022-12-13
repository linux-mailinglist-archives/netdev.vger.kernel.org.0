Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468BD64AD00
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 02:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiLMB10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 20:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiLMB1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 20:27:25 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3565A13F32;
        Mon, 12 Dec 2022 17:27:23 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NWLRy1yYWzRptt;
        Tue, 13 Dec 2022 09:26:22 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 13 Dec
 2022 09:27:21 +0800
Subject: Re: [PATCH net-next v2] hns: use strscpy() to instead of strncpy()
To:     <yang.yang29@zte.com.cn>, <salil.mehta@huawei.com>
References: <202212091533253334827@zte.com.cn>
CC:     <yisen.zhuang@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <brianvv@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>
From:   Hao Lan <lanhao@huawei.com>
Message-ID: <a3c3481f-e552-86c9-2b81-e07f91cc3df9@huawei.com>
Date:   Tue, 13 Dec 2022 09:27:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <202212091533253334827@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/9 15:33, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL terminated strings.
> 
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>
> ---
> change for v2
>  - change the prefix and subject: replace ethtool with hns,
> and replace linux-next with net-next.
> ---
>  drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> index 54faf0f2d1d8..b54f3706fb97 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> @@ -644,18 +644,15 @@ static void hns_nic_get_drvinfo(struct net_device *net_dev,
>  {
>  	struct hns_nic_priv *priv = netdev_priv(net_dev);
> 
> -	strncpy(drvinfo->version, HNAE_DRIVER_VERSION,
> +	strscpy(drvinfo->version, HNAE_DRIVER_VERSION,
>  		sizeof(drvinfo->version));
> -	drvinfo->version[sizeof(drvinfo->version) - 1] = '\0';
> 
> -	strncpy(drvinfo->driver, HNAE_DRIVER_NAME, sizeof(drvinfo->driver));
> -	drvinfo->driver[sizeof(drvinfo->driver) - 1] = '\0';
> +	strscpy(drvinfo->driver, HNAE_DRIVER_NAME, sizeof(drvinfo->driver));
> 
> -	strncpy(drvinfo->bus_info, priv->dev->bus->name,
> +	strscpy(drvinfo->bus_info, priv->dev->bus->name,
>  		sizeof(drvinfo->bus_info));
> -	drvinfo->bus_info[ETHTOOL_BUSINFO_LEN - 1] = '\0';
> 
> -	strncpy(drvinfo->fw_version, "N/A", ETHTOOL_FWVERS_LEN);
> +	strscpy(drvinfo->fw_version, "N/A", ETHTOOL_FWVERS_LEN);
>  	drvinfo->eedump_len = 0;
>  }
> 
Reviewed-by: Hao Lan <lanhao@huawei.com>
