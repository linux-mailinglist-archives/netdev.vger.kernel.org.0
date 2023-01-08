Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12946661B3B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 00:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjAHX5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 18:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjAHX5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 18:57:08 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F3A26C0;
        Sun,  8 Jan 2023 15:57:07 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id ay40so5142548wmb.2;
        Sun, 08 Jan 2023 15:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u4A0bDRa/R2/JRiiWr/AsAmLFcd2KvFBs/zLsNWm1MM=;
        b=F/g7Hns+kfqSmM7vvlFrL7oFLXkIID/T2XfN+KPJzdjmhN++ek1jakL6SKaefXNFxy
         00becfZRkraXZOsVn6D8+ynJUm0O0W3ae84p33xxgRNj0uqps/z5h5qluaU42byVBbOv
         R8f7LYLU60vsXG5wvcEMtF7nBPFpgavXWFPjIei5ip0LFgc7RYRTIJfcASKO9U/17ZQF
         34NI9d0qtCSvuMIe/RADYEqxI+ZdZ8PBznatUaR2kHz0zPhWFWz/hf+K0eCxteid1BAC
         +yfwMsHM+2yoqkcKvDBEzlzLJEUWICKSZdDHba/NRuMa4ABhudUzQYN2MK4IhItUO73g
         HYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u4A0bDRa/R2/JRiiWr/AsAmLFcd2KvFBs/zLsNWm1MM=;
        b=qTY032qaEa3u8WG9W0K7GNTb/ryr1ZCtG+P9mO7D0y6OGt7r/Jd7TwCKQCiVX8qjsg
         GFc/rjt8OCr19dc75dY5KNdUs4Q5/DO+NTzY3GUS/YS55+F/mtip6dL6va0IcWiEfxGD
         wb5S2XmI4Py+5Zm8Vv1+eSxAsE0joOmMpBlQG8hCdsi5d6Wnf6eTNPepQhTWuIi/CUpM
         PPZtXj4e1PexeDw/sRP/m6nUGbGQDS6udtXqVwGX94ZCZJD8UyV5zPW1cRELCbdNhudV
         oWrhDXbnOLKo7YW4GZF7/Vx7MnGxcChLeaLIcANGoZ0zvIPvTXo5rDDvo1v7eqEuvJ+H
         +vKg==
X-Gm-Message-State: AFqh2kroMTNFyGjDkUT3LV7M57m08Foxe14nT4L7xHKntFWIptXzQNSg
        pRE8BTzkZ8Pg5rQKE3GInBoDr5unX/tGF1vF
X-Google-Smtp-Source: AMrXdXtPEa0PcXKfkWY5zUULTzE5RRVQ8+osdLMCC1JPN4+N1eImhuBUXw8tVLCbped4Le0gL9zbaA==
X-Received: by 2002:a05:600c:4f93:b0:3d9:e5f9:984c with SMTP id n19-20020a05600c4f9300b003d9e5f9984cmr3671476wmq.2.1673222225675;
        Sun, 08 Jan 2023 15:57:05 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id j18-20020a05600c191200b003d9dee823a3sm9309598wmq.5.2023.01.08.15.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 15:57:05 -0800 (PST)
Date:   Mon, 9 Jan 2023 00:57:03 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y7tYT8lkgCugZ7kP@gvm01>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <b15b3867233c7adf33870460ea442ff9a4f6ad41.1673030528.git.piergiorgio.beruto@gmail.com>
 <Y7m4v8nLEc4bVBDf@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7m4v8nLEc4bVBDf@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 07:23:59PM +0100, Andrew Lunn wrote:
> > +++ b/drivers/net/phy/Kconfig
> > @@ -264,6 +264,13 @@ config NATIONAL_PHY
> >  	help
> >  	  Currently supports the DP83865 PHY.
> >  
> > +config NCN26000_PHY
> > +	tristate "onsemi 10BASE-T1S Ethernet PHY"
> > +	help
> > +	  Adds support for the onsemi 10BASE-T1S Ethernet PHY.
> > +	  Currently supports the NCN26000 10BASE-T1S Industrial PHY
> > +	  with MII interface.
> > +
> >  config NXP_C45_TJA11XX_PHY
> >  	tristate "NXP C45 TJA11XX PHYs"
> 
> These are actually sorted by the tristate string, which is what you
> see when you use
> 
> make menuconfig
> 
> So 'onsemi' should be after 'NXP TJA11xx PHYs support'. Also, all the
> other entries capitalise the first word.
As for the order I fixed it. Thanks for noticing.

Regarding the capitalization, I have a little problem here. 'onsemi' is a
brand and according to company rules it MUST be written all in
lowercase. I know we're not obliged to follow any company directive here, but 
as wierd as it might sound, I'd rather keep it lowercase just not to get 
comments later on trying to fix this, if you agree...

> 
> >  	depends on PTP_1588_CLOCK_OPTIONAL
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index f7138d3c896b..b5138066ba04 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -77,6 +77,7 @@ obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
> >  obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
> >  obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
> >  obj-$(CONFIG_NATIONAL_PHY)	+= national.o
> > +obj-$(CONFIG_NCN26000_PHY)	+= ncn26000.o
> >  obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
> >  obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
> >  obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
> 
> This is sorted by CONFIG_ symbol, so is correct.
> 
> > +
> > +// driver callbacks --------------------------------------------------------- //
> 
> Comments like this don't really add any value.
Sure, I can remove it.
> 
> > +static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
> > +{
> > +	int ret;
> > +
> > +	// read and aknowledge the IRQ status register
> > +	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> > +
> > +	// check only link status changes
> > +	if (unlikely(ret < 0) || (ret & NCN26000_REG_IRQ_STATUS) == 0)
> > +		return IRQ_NONE;
> 
> More usage of unlikely(). If this was on the hot path, handling 10M
> frames a second, then maybe unlikley() could be justified. But how
> often do you get PHY interrupts? Once a day?
Right, it is my instinct to use unlikely on any sanity check which is
effectively unlikely to happen. But I understand it is not needed here.

> 
>       Andrew
