Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA3F411460
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbhITM3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:29:25 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33806 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbhITM3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:29:14 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KCRV2w096304;
        Mon, 20 Sep 2021 07:27:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632140851;
        bh=Erojbu1vwKmzBzelkzrhStA2bExSaaOLLg+P/ih+xv0=;
        h=Subject:CC:References:From:Date:In-Reply-To;
        b=IPxqJTWKih5LqVW2TjpybjTnwXOz28SJoWMhyaXZiNoTLz5QT5p0iNNcZgMm2ZqDx
         CQU6s6fAye3vCYiZJ+VBaZ438pPVMlhmxOPD9FFdLLX2n7TYzabMNrM+2dTYPezIwG
         rh/f+6jXDTPVb4MOCnhatvacdUBU6YFrHiVQWoTo=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KCRUqA116059
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 07:27:30 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 07:27:30 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 07:27:30 -0500
Received: from [10.250.232.51] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KCRQeH092456;
        Mon, 20 Sep 2021 07:27:27 -0500
Subject: Re: [PATCH] can: m_can: m_can_platform: Fix iomap_read_fifo() and
 iomap_write_fifo()
CC:     Lokesh Vutla <lokeshvutla@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Kline <matt@bitbashing.io>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210920122610.570-1-a-govindraju@ti.com>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <2f34d1bf-48d1-ed6e-b789-b5930a8effaa@ti.com>
Date:   Mon, 20 Sep 2021 17:57:26 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920122610.570-1-a-govindraju@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On 20/09/21 5:56 pm, Aswath Govindraju wrote:
> The read an writes from the fifo are from a buffer with various fields and
> data at predefined offsets. So, they reads and writes should not be done to
> the same address(or port) in case of val_count greater than 1. Therefore,
> fix this by using iowrite32/ioread32 instead of ioread32_rep/iowrite32_rep.
> 
> Also, the write into fifo must be performed with an offset from the message
> ram base address. Therefore, fix the base address to mram_base.
> 
> Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---

Please ignore this patch sent it my mistake. Sorry for the inconvenience.

Thanks,
Aswath

>  drivers/net/can/m_can/m_can_platform.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
> index 308d4f2fff00..eee47bad0592 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -32,8 +32,13 @@ static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
>  static int iomap_read_fifo(struct m_can_classdev *cdev, int offset, void *val, size_t val_count)
>  {
>  	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
> +	void __iomem *src = priv->mram_base + offset;
>  
> -	ioread32_rep(priv->mram_base + offset, val, val_count);
> +	while (val_count--) {
> +		*(unsigned int *)val = ioread32(src);
> +		val += 4;
> +		src += 4;
> +	}
>  
>  	return 0;
>  }
> @@ -51,8 +56,13 @@ static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
>  			    const void *val, size_t val_count)
>  {
>  	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
> +	void __iomem *dst = priv->mram_base + offset;
>  
> -	iowrite32_rep(priv->base + offset, val, val_count);
> +	while (val_count--) {
> +		iowrite32(*(unsigned int *)val, dst);
> +		val += 4;
> +		dst += 4;
> +	}
>  
>  	return 0;
>  }
> 

