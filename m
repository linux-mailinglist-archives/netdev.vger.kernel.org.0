Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620DE2BAAA
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 21:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfE0TZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 15:25:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44442 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfE0TZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 15:25:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id c5so7355991pll.11
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 12:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ADq52HlWjgRi4sYxqWzMlDdD0toRS6e9vCP0txycWVw=;
        b=iKjdvtK2J4s7w4ofFeBzUghPStF+Nllw16ywGv/SROn6jSaSKEHckOcOkXDG9oO7a/
         xQ+Wu9pU8FvGaqzkneUmYMjc9KeitWAkxYxgbe3PFLxelRQzIwF30dLR132E6Ko+UG+b
         n7CvZneW4faLdFeBs9e0aPIXXMDomXAENgWEOqjS8RFdC8FsPcTWrmO1wUwKNkkOzaF0
         4dLPEKz+iv2fRzaFFllrPch3zWQpMLlZPTnw/nAN5Jd/iGHlL7s0SzmStr23nGmjBzeJ
         Wb4f3daSdcWPpsxyVECvOrQTiOeISCQXItYkvMuhbqkD6ml5zmvtL1txZbBH4ysjrCPy
         1x4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ADq52HlWjgRi4sYxqWzMlDdD0toRS6e9vCP0txycWVw=;
        b=SElNsKnrMVALTSW54KR17rErEDIl/mjUh0jXcPrL5gdoSolD3rpXDfH/CK6JseVx3m
         fKz/xc3sUjo24JI94cSVBswg7X1Gww+zkWNx2Wlnx5c0B2AbtO8nXY/uAB7z014G3N+8
         wNHwC1YQJNhL4ruvVf+vN8RCjIHvZn2qcn+wKjvxlMNHlYl352MDTBqed3SgNbWJb6W8
         EBvtuwEYae+r/NNEEyKwwXKpZQ6pFXYyq2k2K2rrZk97CtpnAzly8HGrlYk7sWc0PnoD
         vAOMd77KzmRTF9pDFcAshYGDkXnyVUfMmCqdgW/VSCEWyTCsB26LHhOqeS/ERWEcGTVE
         tbRg==
X-Gm-Message-State: APjAAAXfCbYrM3rDTULnCttcHFWAu/iGklIp6uoLRFZ56lv8Em4bS1Uk
        buADFCq30aQiPQwvxbCEEKOi7KC5
X-Google-Smtp-Source: APXvYqygeYUhrZ4cU7mYdPvxF0Rvk33x5mHjTpwFylTtyNbPFAcGzuIcAetpuTy3l+ZF+/NvH7ymyQ==
X-Received: by 2002:a17:902:1021:: with SMTP id b30mr28000396pla.324.1558985144195;
        Mon, 27 May 2019 12:25:44 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id z32sm9466590pgk.25.2019.05.27.12.25.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 12:25:43 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] net: phy: add callback for custom interrupt
 handler to struct phy_driver
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
 <9929ba89-5ca0-97bf-7547-72c193866051@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <64456292-42c8-c322-93bc-ab88d1f18329@gmail.com>
Date:   Mon, 27 May 2019 12:25:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9929ba89-5ca0-97bf-7547-72c193866051@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2019 11:28 AM, Heiner Kallweit wrote:
> The phylib interrupt handler handles link change events only currently.
> However PHY drivers may want to use other interrupt sources too,
> e.g. to report temperature monitoring events. Therefore add a callback
> to struct phy_driver allowing PHY drivers to implement a custom
> interrupt handler.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> ---
>  drivers/net/phy/phy.c | 9 +++++++--
>  include/linux/phy.h   | 3 +++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 20955836c..8030d0a97 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -774,8 +774,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>  	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
>  		return IRQ_NONE;
>  
> -	/* reschedule state queue work to run as soon as possible */
> -	phy_trigger_machine(phydev);
> +	if (phydev->drv->handle_interrupt) {
> +		if (phydev->drv->handle_interrupt(phydev))

If Russell is okay with such a model where the PHY state machine still
manages the interrupts at large, and only calls a specific callback for
specific even handling, that's fine. We might have to allow PHY drivers
to let them specify what they want to get passed to
request_threaded_irq(), or leave it to them to do it.
-- 
Florian
