Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E716445C3
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 15:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbiLFOfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 09:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiLFOfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 09:35:05 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AD821813;
        Tue,  6 Dec 2022 06:35:03 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id kw15so3215924ejc.10;
        Tue, 06 Dec 2022 06:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EzchpwuEta8aWE4H77gSMJ23xGLi6cuMRh/hqr7Hhzg=;
        b=PJlYuQu7DT20Nqtsx+U+ypBjUKndXcSYcotmtLnM2rbpcnQF3hOCRETPKWv44aDNsO
         I34EdmBmvfCyNtp8f5Raec1qfcw/80sQWgGiSnDFlpKmkiMtI4IT97vesVZxY0Zl/cp1
         JVuL4avU19GpqIVNJcn66YRPI/P4iwiWv33h7JtQNwS1gj0vJFUgOsWeKYk6iAI70bzb
         +DRU813exk/yoLvqLBd81Z5VGHPIoW7TjnIZFRuEiI6ZwftM/144e7/E4UmfL2qBANHS
         XqQhJaNkvQK/dLTKfCXuGvLqDhw7mlFYNpMlO3D7VH18KejQA+t+X9HiOFQBRLEPROMs
         YQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EzchpwuEta8aWE4H77gSMJ23xGLi6cuMRh/hqr7Hhzg=;
        b=nwK64y6wLlpsecLeh6vv7Kkr4Qd9AcENIEFoTF1xJqOhWyMJCZGHji9GPRBg8f5FaT
         q1ojc5+U6j6wNZPWWQhUit6ppFyWb/xird7mefKQlABaTpoMUhUIXN/sozQOXLYqN7Yv
         Z1FJw0FwzhO+BnH+/M21TGBC6wPcoz1lV5n4l2PbmbmMTkM9VeKG79NP1aaJZvijAFrx
         cZG6RHf/+lAsdHSP2U6UWjxenvkUGUxfWinnH+7DWu5HJ3DvDQZTVWj/hz/OJtqCEh01
         ejELf56PT0KGnEUq4tN9ltsbPVFvsYtN+DccDQ/EkuqVdPa8dW6bT+GnGx+n7LYIVLI3
         6BlA==
X-Gm-Message-State: ANoB5pn7OT+duH3eJJr6VwJBSMl4K5T/W1AgmkZl/60AG1UWrwKuBLHc
        5p4zk9rssRuyUJVAnxhqTInVioeUtnQN/41Q
X-Google-Smtp-Source: AA0mqf50vMd570dJRGajJ64lc4+GMS6qx3XGi9I9gbuBt1onOlLBoT30hOjQY87JLWf86OA8Q+XN0g==
X-Received: by 2002:a17:906:99d3:b0:78d:c7fd:f755 with SMTP id s19-20020a17090699d300b0078dc7fdf755mr10882905ejn.702.1670337301415;
        Tue, 06 Dec 2022 06:35:01 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402181a00b004618a89d273sm1059447edy.36.2022.12.06.06.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 06:34:59 -0800 (PST)
Date:   Tue, 6 Dec 2022 15:35:10 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y49THkXZdLBR6Mxv@gvm01>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
 <Y49IBR8ByMQH6oVt@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49IBR8ByMQH6oVt@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
thank you for your review. Please, see my answers below.

Thanks,
Piergiorgio

On Tue, Dec 06, 2022 at 02:47:49PM +0100, Andrew Lunn wrote:
> > +// module parameter: if set, the link status is derived from the PLCA status
> > +// default: false
> > +static bool link_status_plca;
> > +module_param(link_status_plca, bool, 0644);
> 
> No module parameters, they are considered a bad user interface.
OK, as you see I'm a bit "outdated" :-)
What would be the alternative? There is a bunch of vendor-specific PHY
features that I would like to expose at some point (e.g. regulation of
TX voltage levels). Thanks!
 
> > +static int ncn26000_get_features(struct phy_device *phydev)
> > +{
> > +	linkmode_zero(phydev->supported);
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, phydev->supported);
> > +
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> > +			 phydev->supported);
> > +
> > +	linkmode_copy(phydev->advertising, phydev->supported);
> 
> That should not be needed.
> 
> Also, look at PHY_BASIC_T1_FEATURES, and how it is used in
> microchip_t1.c.
In principle, I agree. But I have a problem with this specific chip, two
actually...

1. The chip does -not- set the MDIO_PMA_EXTABLE while it should. This
has been fixed in new versions of the chip, but for now, the bit is 0
so genphy_c45_baset1_able() reports 'false'.

2. This PHY is one of the PHYs that emulates AN (we discussed about this
earlier), but it does not actually implement it.

Therefore, I thought to just force the capabilities. In the future, I
could read the chip ID/version and make a decision based on that (force
or use the standard c45 functions).

Doe it make sense to you?

> > +static int ncn26000_read_status(struct phy_device *phydev)
> > +{
> > +	// The NCN26000 reports NCN26000_LINK_STATUS_BIT if the link status of
> > +	// the PHY is up. It further reports the logical AND of the link status
> > +	// and the PLCA status in the BMSR_LSTATUS bit. Thus, report the link
> > +	// status by testing the appropriate BMSR bit according to the module's
> > +	// parameter configuration.
> > +	const int lstatus_flag = link_status_plca ?
> > +		BMSR_LSTATUS : NCN26000_BMSR_LINK_STATUS_BIT;
> > +
> > +	int ret;
> > +
> > +	ret = phy_read(phydev, MII_BMSR);
> > +	if (unlikely(ret < 0))
> > +		return ret;
> > +
> > +	// update link status
> > +	phydev->link = (ret & lstatus_flag) ? 1 : 0;
> 
> What about the latching behaviour of LSTATUS?
See further down.

> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L2289
> 
> > +
> > +	// handle more IRQs here
> 
> You are not in an IRQ handler...
Right, this is just a left-over when I moved the code from the ISR to
this functions. Fixed.

> You should also be setting speed and duplex. I don't think they are
> guaranteed to have any specific value if you don't set them.
Ah, I got that before, but I removed it after comment from Russell
asking me not to do this. Testing on my HW, this seems to work, although
I'm not sure whether this is correct or it is working 'by chance' ?

> > +
> > +	return 0;
> > +}
> > +
> > +static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
> > +{
> > +	const struct ncn26000_priv *const priv = phydev->priv;
> > +	int ret;
> > +
> > +	// clear the latched bits in MII_BMSR
> > +	phy_read(phydev, MII_BMSR);
> 
> Why?
That was my ugly handling of the status double-read...
See the pacth below! I copied part of the code you suggested.

> 
> > +
> > +	// read and aknowledge the IRQ status register
> > +	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> > +
> > +	if (unlikely(ret < 0) || (ret & priv->enabled_irqs) == 0)
> 
> How does NCN26000_REG_IRQ_STATUS work? Can it have bits set which are
> not in NCN26000_REG_IRQ_CTL ? That does happen sometimes, but is
> pretty unusual. If not, you don't need to track priv->enabled_irqs,
> just ensure ret is not 0.
It has a single bit that is not maskable. That would be the reset event
bit, which is triggered if the chip goes through a spurious reset. Since
I did not want to handle this in this first version of the driver, I
just masked it this way.
Thoughts?


diff --git a/drivers/net/phy/ncn26000.c b/drivers/net/phy/ncn26000.c
index 9e02c5c55244..198539b7ee66 100644
--- a/drivers/net/phy/ncn26000.c
+++ b/drivers/net/phy/ncn26000.c
@@ -92,15 +92,27 @@ static int ncn26000_read_status(struct phy_device *phydev)

        int ret;

+       /* The link state is latched low so that momentary link
+        * drops can be detected. Do not double-read the status
+        * in polling mode to detect such short link drops except
+        * the link was already down.
+        */
+       if (!phy_polling_mode(phydev) || !phydev->link) {
+               ret = phy_read(phydev, MII_BMSR);
+               if (ret < 0)
+                       return ret;
+               else if (ret & lstatus_flag)
+                       goto upd_link;
+       }
+
        ret = phy_read(phydev, MII_BMSR);
        if (unlikely(ret < 0))
                return ret;

+upd_link:
        // update link status
        phydev->link = (ret & lstatus_flag) ? 1 : 0;

-       // handle more IRQs here
-
        return 0;
 }

@@ -109,9 +121,6 @@ static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
        const struct ncn26000_priv *const priv = phydev->priv;
        int ret;

-       // clear the latched bits in MII_BMSR
-       phy_read(phydev, MII_BMSR);
-
        // read and aknowledge the IRQ status register
        ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
