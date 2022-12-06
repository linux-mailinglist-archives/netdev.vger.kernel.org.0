Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD06644ACA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiLFSF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLFSFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:05:55 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E2A37207;
        Tue,  6 Dec 2022 10:05:53 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c66so15138535edf.5;
        Tue, 06 Dec 2022 10:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sohc/zRaRTqav4RQHNdtoi5gvQOfb1wdHDNBf897pn8=;
        b=FWPrMTJbrbqTVJbF7sMesUIossLBZlIIFHOkuIkQyTuJdSUSySW6JovFUXer9TFEDj
         uyGDeZVp+tcSuOkaEjzqaNeWvQSBAw/ysrWVfgx53fYcJ0wW8j603job3g354QpwZQmk
         3Q+I/NwzI5HDHVNrbGwbmXzmdCEAy72VwOKfBrWuZoQAxbpROMxk3LauZzk497DsoTR/
         sspyBjpgAeFeryguTxJgPTh4+t1+cuh+WtBJleQNiG9bWKw8pIhih2uWIvVKJaxoK4vZ
         CHUqrAOAgmjFFatwUomDx9YyRnLf65wnbdbQ0SSkqWCsDPqzlkTNYI59i5K5moKcRgG3
         CF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sohc/zRaRTqav4RQHNdtoi5gvQOfb1wdHDNBf897pn8=;
        b=7O9rgBX5JF1J3FwEEYAhGOZlPNovsLZeseVxSCujiXrBiheYlVTrIG6TRaVmP5KJiZ
         TfkMPSGbErycUu9Bk34CBUJnMGXVFP4ooRuYrsEgXUL/iDEjULIbuHl7894C0Nh0SDeN
         ywlzpIilaUO6bOZygICN5aWkZcybljnvGLQZcn9cISGidINGljOM5iRelDdL0iVaaVVh
         BsHVlro2HiF4aTB/T30ymPSmR3XvJRGhJfT6/4TLtfINRIduNpvF2BjEciRhlW9h0Yik
         iO1EmOk12+G3Tnitmqrn9eJsiUqSrSi6tF2JO8dzd+1av8Q+7Dvnm+/v9lfNisbc5CR4
         /fgw==
X-Gm-Message-State: ANoB5pl1EIngJBiqeMwOyJX1OmdHhOBRNPWgyToRtKaS7AGiq/gNKnd/
        xNrBfI0wbEisfyNg9ZQZExo=
X-Google-Smtp-Source: AA0mqf59PKndTCyH52fJ89lLaqCTgsUnjxUMmQX1tqSED0A3O1MyB32N8WKziur1XHq6+qQqTT3IHw==
X-Received: by 2002:a05:6402:2912:b0:46a:c132:8a25 with SMTP id ee18-20020a056402291200b0046ac1328a25mr46431327edb.205.1670349952189;
        Tue, 06 Dec 2022 10:05:52 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id g2-20020a170906538200b0078d9cd0d2d6sm7789623ejo.11.2022.12.06.10.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:05:51 -0800 (PST)
Date:   Tue, 6 Dec 2022 19:06:02 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y4+Eigd6PZ3tgFzG@gvm01>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
 <Y49IBR8ByMQH6oVt@lunn.ch>
 <Y49THkXZdLBR6Mxv@gvm01>
 <Y49YQOOhAslQQ9zt@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49YQOOhAslQQ9zt@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 02:57:04PM +0000, Russell King (Oracle) wrote:
> On Tue, Dec 06, 2022 at 03:35:10PM +0100, Piergiorgio Beruto wrote:
> > On Tue, Dec 06, 2022 at 02:47:49PM +0100, Andrew Lunn wrote:
> > > > +static int ncn26000_read_status(struct phy_device *phydev)
> > > > +{
> > > > +	// The NCN26000 reports NCN26000_LINK_STATUS_BIT if the link status of
> > > > +	// the PHY is up. It further reports the logical AND of the link status
> > > > +	// and the PLCA status in the BMSR_LSTATUS bit. Thus, report the link
> > > > +	// status by testing the appropriate BMSR bit according to the module's
> > > > +	// parameter configuration.
> > > > +	const int lstatus_flag = link_status_plca ?
> > > > +		BMSR_LSTATUS : NCN26000_BMSR_LINK_STATUS_BIT;
> > > > +
> > > > +	int ret;
> > > > +
> > > > +	ret = phy_read(phydev, MII_BMSR);
> > > > +	if (unlikely(ret < 0))
> > > > +		return ret;
> > > > +
> > > > +	// update link status
> > > > +	phydev->link = (ret & lstatus_flag) ? 1 : 0;
> > > 
> > > What about the latching behaviour of LSTATUS?
> > See further down.
> > 
> > > 
> > > https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L2289
> > > 
> > > > +
> > > > +	// handle more IRQs here
> > > 
> > > You are not in an IRQ handler...
> > Right, this is just a left-over when I moved the code from the ISR to
> > this functions. Fixed.
> > 
> > > You should also be setting speed and duplex. I don't think they are
> > > guaranteed to have any specific value if you don't set them.
> > Ah, I got that before, but I removed it after comment from Russell
> > asking me not to do this. Testing on my HW, this seems to work, although
> > I'm not sure whether this is correct or it is working 'by chance' ?
> 
> I asked you to get rid of them in the config function, which was
> setting them to "unknown" values. I thought I explained why it was
> wrong to set them there - but again...
> 
> If you force the values in the config function, then when userspace
> does a read-modify-write of the settings via ethtool, you will end
> up wiping out the PHYs link settings, despite maybe nothing having
> actually been changed. It is also incorrect to set them in the
> config function, because those writes to those variables can race
> with users reading them - the only place they should be set by a
> PHY driver is in the .read_status method.
Ok, I must have misunderstood what the problem was. This is clear to me
now, I'm going to add this back in the read_status() method.

Thanks,
Piergiorgio
