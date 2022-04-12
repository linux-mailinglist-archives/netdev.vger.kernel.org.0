Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628544FDD1B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352525AbiDLK4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359040AbiDLKyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:54:41 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0134B8A324;
        Tue, 12 Apr 2022 02:49:51 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23C9nfKe095086;
        Tue, 12 Apr 2022 04:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649756981;
        bh=+Po/OBwMzMNY+mde2GzDHYUOKX11dNsA5+yYDGz7VLc=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=V7TII7TZR4mvruoLKh3kAxvfLUKV6AL8PGcIARUFTc2n7xgH4hWFHtONJM3zzw/eM
         vxR6nEWEqZPFftuvUZs/YC+l1a7PAlWi39hhZu8bZ/wk4UobUk1aKwrjI4Jo4y78s2
         2yV6umjTqndL5TTy8rpNhg7Ab0Dbz/GJp8N5vbSE=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23C9nfBa023699
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Apr 2022 04:49:41 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Apr 2022 04:49:41 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 12 Apr 2022 04:49:41 -0500
Received: from [10.249.96.184] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23C9ncAZ101283;
        Tue, 12 Apr 2022 04:49:38 -0500
Message-ID: <78ec4bb7-b575-2554-9a29-e25c28022bdf@ti.com>
Date:   Tue, 12 Apr 2022 12:49:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: ethernet: ti: cpsw: using pm_runtime_resume_and_get
 instead of pm_runtime_get_sync
Content-Language: en-US
To:     <cgel.zte@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220412082847.2532584-1-chi.minghao@zte.com.cn>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
In-Reply-To: <20220412082847.2532584-1-chi.minghao@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/04/2022 11:28, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
> pm_runtime_put_noidle. This change is just to simplify the code, no
> actual functional changes.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---
>   drivers/net/ethernet/ti/cpsw.c | 36 ++++++++++++----------------------
>   1 file changed, 12 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 03575c017500..9f37b5b196a5 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -756,11 +756,9 @@ static int cpsw_ndo_open(struct net_device *ndev)
>   	int ret;
>   	u32 reg;
>   
> -	ret = pm_runtime_get_sync(cpsw->dev);
> -	if (ret < 0) {
> -		pm_runtime_put_noidle(cpsw->dev);
> +	ret = pm_runtime_resume_and_get(cpsw->dev);
> +	if (ret < 0)
>   		return ret;
> -	}
>   
>   	netif_carrier_off(ndev);
>   
> @@ -968,11 +966,9 @@ static int cpsw_ndo_set_mac_address(struct net_device *ndev, void *p)
>   	if (!is_valid_ether_addr(addr->sa_data))
>   		return -EADDRNOTAVAIL;
>   
> -	ret = pm_runtime_get_sync(cpsw->dev);
> -	if (ret < 0) {
> -		pm_runtime_put_noidle(cpsw->dev);
> +	ret = pm_runtime_resume_and_get(cpsw->dev);
> +	if (ret < 0)
>   		return ret;
> -	}
>   
>   	if (cpsw->data.dual_emac) {
>   		vid = cpsw->slaves[priv->emac_port].port_vlan;
> @@ -1052,11 +1048,9 @@ static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
>   	if (vid == cpsw->data.default_vlan)
>   		return 0;
>   
> -	ret = pm_runtime_get_sync(cpsw->dev);
> -	if (ret < 0) {
> -		pm_runtime_put_noidle(cpsw->dev);
> +	ret = pm_runtime_resume_and_get(cpsw->dev);
> +	if (ret < 0)
>   		return ret;
> -	}
>   
>   	if (cpsw->data.dual_emac) {
>   		/* In dual EMAC, reserved VLAN id should not be used for
> @@ -1090,11 +1084,9 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
>   	if (vid == cpsw->data.default_vlan)
>   		return 0;
>   
> -	ret = pm_runtime_get_sync(cpsw->dev);
> -	if (ret < 0) {
> -		pm_runtime_put_noidle(cpsw->dev);
> +	ret = pm_runtime_resume_and_get(cpsw->dev);
> +	if (ret < 0)
>   		return ret;
> -	}
>   
>   	if (cpsw->data.dual_emac) {
>   		int i;
> @@ -1567,11 +1559,9 @@ static int cpsw_probe(struct platform_device *pdev)
>   	/* Need to enable clocks with runtime PM api to access module
>   	 * registers
>   	 */
> -	ret = pm_runtime_get_sync(dev);
> -	if (ret < 0) {
> -		pm_runtime_put_noidle(dev);
> +	ret = pm_runtime_resume_and_get(dev);
> +	if (ret < 0)
>   		goto clean_runtime_disable_ret;
> -	}
>   
>   	ret = cpsw_probe_dt(&cpsw->data, pdev);
>   	if (ret)
> @@ -1734,11 +1724,9 @@ static int cpsw_remove(struct platform_device *pdev)
>   	struct cpsw_common *cpsw = platform_get_drvdata(pdev);
>   	int i, ret;
>   
> -	ret = pm_runtime_get_sync(&pdev->dev);
> -	if (ret < 0) {
> -		pm_runtime_put_noidle(&pdev->dev);
> +	ret = pm_runtime_resume_and_get(&pdev->dev);
> +	if (ret < 0)
>   		return ret;
> -	}
>   
>   	for (i = 0; i < cpsw->data.slaves; i++)
>   		if (cpsw->slaves[i].ndev)

Thank you.
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
Grygorii, Ukraine
