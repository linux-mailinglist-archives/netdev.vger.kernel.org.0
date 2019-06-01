Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03CBF31B3F
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfFAKgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:36:31 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35452 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFAKga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:36:30 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x51AaSmc090174;
        Sat, 1 Jun 2019 05:36:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559385388;
        bh=shWkaHiI805do+UScyf+ZVyVOGJ/6uFSU3jC7FwgsqQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=hxDfOUbTxHfV9P7O2168bRlHcaNJa3/Kds0xQMv6S2kYWREhPmdGbWcbwZc3qRmbM
         wGniq9vlqnEJ4awYfI0I9igorDYESZeZRLRmU+NyjpfWH9GAyLlIWLuzF2pvypLIKj
         VMCkw42D15t6FsgaKnKqLjaCJPN4EvpHlDk/iYWI=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x51AaSrj117528
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 1 Jun 2019 05:36:28 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 1 Jun
 2019 05:36:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Sat, 1 Jun 2019 05:36:28 -0500
Received: from [10.250.96.121] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x51AaQnn041282;
        Sat, 1 Jun 2019 05:36:27 -0500
Subject: Re: [PATCH v2] net: ethernet: ti: cpsw_ethtool: fix ethtool ring
 param set
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, <davem@davemloft.net>
CC:     <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190531134725.2054-1-ivan.khoronzhuk@linaro.org>
From:   grygorii <grygorii.strashko@ti.com>
Message-ID: <3b1b0ac9-6165-6d59-d3f7-d484705119f2@ti.com>
Date:   Sat, 1 Jun 2019 13:36:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531134725.2054-1-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/05/2019 16:47, Ivan Khoronzhuk wrote:
> Fix ability to set RX descriptor number, the reason - initially
> "tx_max_pending" was set incorrectly, but the issue appears after
> adding sanity check, so fix is for "sanity" patch.
> 
> Fixes: 37e2d99b59c476 ("ethtool: Ensure new ring parameters are within bounds during SRINGPARAM")
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
> Based on net/master
> 
>   drivers/net/ethernet/ti/cpsw_ethtool.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
> index a4a7ec0d2531..6d1c9ebae7cc 100644
> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
> @@ -643,7 +643,7 @@ void cpsw_get_ringparam(struct net_device *ndev,
>   	struct cpsw_common *cpsw = priv->cpsw;
>   
>   	/* not supported */
> -	ering->tx_max_pending = 0;
> +	ering->tx_max_pending = cpsw->descs_pool_size - CPSW_MAX_QUEUES;
>   	ering->tx_pending = cpdma_get_num_tx_descs(cpsw->dma);
>   	ering->rx_max_pending = cpsw->descs_pool_size - CPSW_MAX_QUEUES;
>   	ering->rx_pending = cpdma_get_num_rx_descs(cpsw->dma);
> 

Thank you.
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
