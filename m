Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2706D4114A1
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbhITMiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:38:14 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58674 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbhITMiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:38:13 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KCaX7h059943;
        Mon, 20 Sep 2021 07:36:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632141393;
        bh=VG1KVcz3GSfRISR4WxwHrhgZOlkDTvXLPDBDHCoKw1E=;
        h=Subject:CC:References:From:Date:In-Reply-To;
        b=Ixpx+xOyWA/pfavocAesc4Dti/V8cdAKvs+lhDjelRI8tkJdJtGO6KgcElxRsXUzL
         jdLhhCDiSD7cgDYr88fvV5F36LIRRaOWRjj8xkQrGhl/I3mKrgqhvlwoh5HQuhJ4kl
         11idu5B298dm28f0oS5lkBKbD5M2x2x+Rh09Q2p4=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KCaXks015872
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 07:36:33 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 07:36:33 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 07:36:33 -0500
Received: from [10.250.232.51] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KCaTVn024063;
        Mon, 20 Sep 2021 07:36:30 -0500
Subject: Re: [PATCH] can: m_can: m_can_platform: Fix the base address in
 iomap_write_fifo()
CC:     Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Kline <matt@bitbashing.io>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210916112151.26494-1-a-govindraju@ti.com>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <2d069fd4-fc98-f1ce-7f26-c3e2569e7efa@ti.com>
Date:   Mon, 20 Sep 2021 18:06:28 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916112151.26494-1-a-govindraju@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On 16/09/21 4:51 pm, Aswath Govindraju wrote:
> The write into fifo must be performed with an offset from the message ram
> base address. Therefore, fix the base address to mram_base.
> 
> Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---

This change along with some more fixes are squashed and posted in,

https://patchwork.kernel.org/project/netdevbpf/patch/20210920123344.2320-1-a-govindraju@ti.com/

Thanks,
Aswath

>  drivers/net/can/m_can/m_can_platform.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
> index 308d4f2fff00..08eac03ebf2a 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -52,7 +52,7 @@ static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
>  {
>  	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
>  
> -	iowrite32_rep(priv->base + offset, val, val_count);
> +	iowrite32_rep(priv->mram_base + offset, val, val_count);
>  
>  	return 0;
>  }
> 

