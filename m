Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EC348146B
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 16:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240537AbhL2P0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 10:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237016AbhL2PZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 10:25:59 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70227C06173F
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 07:25:59 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t26so45085772wrb.4
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 07:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2LvQ3YDK+pFh21ErisGgun4OyhM+EJQfNWms49Mzu18=;
        b=QazW7x7A1LVXE3A5B4XJKAhIKBjmlp7kQI2Y9xZZlNGeathz2ZlE+WdERJpBhFmlE1
         ookyUDRPX7TaIfQ0MgGECz758RDpieowomh5RjPYgBVSEhBp4T41qkR+voCuLqboYpur
         bfIVhl6a6fRfihstRU6g1dpyK79vKxn5uScYxAYErpRLDVxWUXV8k2Q3ZIajOdMjvQ2f
         eBYBBuFaYmQwunIxN/L3rWvp3jaDDtC3sxECWKp8BCjGCsh3JpCLsJ6EXZs1uopj8gtC
         d9ARZwck2YNNftwSLmrUls5pbdi/rOjwEEKx3Mkm0yk0SEg5eXkiGXGrCtGQ05Yb92C1
         mQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2LvQ3YDK+pFh21ErisGgun4OyhM+EJQfNWms49Mzu18=;
        b=WklT2N7bCJQpFrnrTS0+NBqtsbaaW7ZraB1EP3qsplS0kpQ6559KuhVzUhS8CVfRkA
         7TPn8WftakwRleuxoPn2tUzNGlOimR3E1TeiHJL734K5qLsaRS1PXTicpRxFHPR7lrOh
         tScvaNsreKY8TzoCiVdpviK/aAkOMg4N1uSWCR+gnRp3qpbaJJ49c/1eLTTFS0FnCcAE
         pr2ZimwRfCucKbatV9xIQXKqRJA32oB3ESPN7LrIzbx2EPQAKdrUZK88S3PyHv+sXS2u
         Ak1S9LqtknkFG2aMcb4Zdhn/mwzcm6m0MpoRTYpM1bF46hSEDtWoBL/vs/yjBnv8+z1G
         /P1A==
X-Gm-Message-State: AOAM531UsrFA41RaCn8uPhy7uP8qVjlfJHOpagaNkcs5T5R9MOK7LhkQ
        3up/Be5xW1EbI3gXkjkEkx72qg==
X-Google-Smtp-Source: ABdhPJyE4O+tlUmmtK6EFlUaGWRLKF3S++iTvVhixbPeoCZ5COQ1aSWej4mCtXIfdW0yQCdSw1AQlg==
X-Received: by 2002:adf:d843:: with SMTP id k3mr22067929wrl.303.1640791557959;
        Wed, 29 Dec 2021 07:25:57 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id h14sm21273126wrz.31.2021.12.29.07.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 07:25:57 -0800 (PST)
Date:   Wed, 29 Dec 2021 15:25:55 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 08/13] mfd: add interface to check whether a
 device is mfd
Message-ID: <Ycx+A4KNKiVmH2PJ@google.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-9-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211218214954.109755-9-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Dec 2021, Colin Foster wrote:

> Some drivers will need to create regmaps differently based on whether they
> are a child of an MFD or a standalone device. An example of this would be
> if a regmap were directly memory-mapped or an external bus. In the
> memory-mapped case a call to devm_regmap_init_mmio would return the correct
> regmap. In the case of an MFD, the regmap would need to be requested from
> the parent device.
> 
> This addition allows the driver to correctly reason about these scenarios.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/mfd/mfd-core.c   |  5 +++++
>  include/linux/mfd/core.h | 10 ++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 684a011a6396..905f508a31b4 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -33,6 +33,11 @@ static struct device_type mfd_dev_type = {
>  	.name	= "mfd_device",
>  };
>  
> +int device_is_mfd(struct platform_device *pdev)
> +{
> +	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
> +}
> +

Why is this device different to any other that has ever been
mainlined?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
