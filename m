Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B31F1AD051
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgDPT02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728664AbgDPT01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:26:27 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944A1C061A0C;
        Thu, 16 Apr 2020 12:26:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id i3so2122887pgk.1;
        Thu, 16 Apr 2020 12:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gEIm/a/amIudYpXaFTgOzFwljTFoVGowEhKLDfwtbSc=;
        b=rIgtAFJKoGra7EIe4/jhtS16/eFGryhXNIzTdUfJ/CFm6RydeSs+8NknPM6H4V+fz7
         j8oO5iCHl+jWZS0z0iX+pN7tKvbheyjJmbzJJx33Y1JQHxmz6Rj3TwhomyfuwbVpB/+k
         +63hryw7687z+duoE8UYV5JeTLyr1P/z+gDNs9JqaqosrwpkFUk7fRhhquyUWF44HpAI
         shkxjKR4luUFqeApTMO2DhvUwrKeENDAn5jIs6EcqBU38d8kjf4TRSZbDTzWTk8lnrDV
         VfNss3zurWUZR45GEMaVaNm8dHsVtTT+fprCaf4d1oX9J8cRNp+6xHKT9dBYqBPPXcF2
         X9Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gEIm/a/amIudYpXaFTgOzFwljTFoVGowEhKLDfwtbSc=;
        b=GIYADRSASwAbOoe/1rFSsiou6TIvxvo0f7mlfdgtVbk72kI4McmB9f0fKMISVlc7Hn
         YoGJOJ5N6UwOFTXt5Mo/a6wbOBlxmY8v4LStS1eZx/BeLrO1FSRvADbxkfNovWauAetR
         9loDyrQGqkV+nQdBgZzZdw5KrOLLP7gbp/cyrEZkBuUdBJIOD4O2CsrF7C8/em/vmPyJ
         cGp0SbGcaqR/4t5XnPnK6iEfRVefdx2S6Jsdr2sQTcODKKFPhN9nsauN/C7NVA8kACvG
         vRgMjkH++0L5JGZQkn+5Ct7+QvVfdhIDrVppZ0yJSu37t5/t/zPnEPVutMFdWyuJTtEI
         4WqA==
X-Gm-Message-State: AGi0PuYW7vgRh+EsTnsmMS2XArKz+c/wPZLgtTlxn8cNW1U/KRYx4Feg
        7Y0uUuhMHiiBlU2kv4fWxV0=
X-Google-Smtp-Source: APiQypKzMYTBGunhXRk8Oqqf4CGoHLjWjRE3fS4slXzpGdswHwt+JibGD0bT8b1zaDclGtFyzLbi1g==
X-Received: by 2002:aa7:9297:: with SMTP id j23mr5696294pfa.15.1587065186090;
        Thu, 16 Apr 2020 12:26:26 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h66sm16613044pgc.42.2020.04.16.12.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 12:26:25 -0700 (PDT)
Subject: Re: [PATCH 5/5] net: macb: Add WoL interrupt support for MACB type of
 Ethernet controller
To:     nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        harini.katakam@xilinx.com
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        pthombar@cadence.com, sergio.prado@e-labworks.com,
        antoine.tenart@bootlin.com, linux@armlinux.org.uk, andrew@lunn.ch,
        michal.simek@xilinx.com
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
 <3c9db82da283abd7faf248985d21155a48554bdf.1587058078.git.nicolas.ferre@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c3abc339-ccfa-6ca1-a27c-af2808d89d98@gmail.com>
Date:   Thu, 16 Apr 2020 12:26:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <3c9db82da283abd7faf248985d21155a48554bdf.1587058078.git.nicolas.ferre@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/2020 10:44 AM, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Handle the Wake-on-Lan interrupt for the Cadence MACB Ethernet
> controller.
> As we do for the GEM version, we handle of WoL interrupt in a
> specialized interrupt handler for MACB version that is positionned
> just between suspend() and resume() calls.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> ---
>   drivers/net/ethernet/cadence/macb_main.c | 38 +++++++++++++++++++++++-
>   1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 71e6afbdfb47..6d535e3e803c 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1513,6 +1513,34 @@ static void macb_tx_restart(struct macb_queue *queue)
>   	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>   }
>   
> +static irqreturn_t macb_wol_interrupt(int irq, void *dev_id)
> +{
> +	struct macb_queue *queue = dev_id;
> +	struct macb *bp = queue->bp;
> +	u32 status;
> +
> +	status = queue_readl(queue, ISR);
> +
> +	if (unlikely(!status))
> +		return IRQ_NONE;
> +
> +	spin_lock(&bp->lock);
> +
> +	if (status & MACB_BIT(WOL)) {
> +		queue_writel(queue, IDR, MACB_BIT(WOL));
> +		macb_writel(bp, WOL, 0);
> +		netdev_vdbg(bp->dev, "MACB WoL: queue = %u, isr = 0x%08lx\n",
> +			    (unsigned int)(queue - bp->queues),
> +			    (unsigned long)status);
> +		if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> +			queue_writel(queue, ISR, MACB_BIT(WOL));
> +	}

Likewise, this would need a call to pm_wakeup_event() to record the 
wake-up event associated with this device.
-- 
Florian
