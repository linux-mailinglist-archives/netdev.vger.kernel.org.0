Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15274641F69
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 21:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiLDULn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 15:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLDULl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 15:11:41 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1253913D7E;
        Sun,  4 Dec 2022 12:11:41 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l11so13219267edb.4;
        Sun, 04 Dec 2022 12:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxW+nXtH/Bu1pmXCejglUQr3+EGy7RKL6bM1jakeHtY=;
        b=b8PED5rCcQFTQLRFIe5SMhVlbdnBO4PN1QoxWNyBHmJL5FLYj8sKppnNiluGA1Hfnp
         Tut0rnu7O4nAZ7iXCPcbRDtpJgez0c6NMgOf9nyBhtTQWdwYJvfWNZgzkKv2CpM5MJuh
         /f6rNWDUbsBWGdCkL6zhBQygSWfLT29dViP51L8KmgZ5/L1oJ1elfW8jw1b4BxEvT36/
         VzeWhYC0ynutGEYiau3HUGvAtnG/kAm5z5rchrhBUth1zAzdPqmbfJy90ufBu0NN6rCw
         F72ZwMuf83gu3KIA98Z4zBYu4TL/y71bKRjUQvzpuHGFBa4V9ibKKMVgSyis+6/f6sN0
         P18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxW+nXtH/Bu1pmXCejglUQr3+EGy7RKL6bM1jakeHtY=;
        b=RyY+vyHEhnc+zQZtABxPYAQ9XCztU+6kJ0ek88aHIBtd1bGDveU2zyj+9HOxYcNpKw
         8uTPTki5utZjyMzM84LVUoel0xke1XUPU6Av4fyVTUC97PpFL+ca1vArLTp+dZVIjIlm
         3rZbiEsT3l8hwSA2N/vBP5QasNUEyRDfLicOyZt76Q6plX5lINrZSE1M4mrr9MiseiPt
         PcA2WdWkhypB2ycvrD5YNs50Q5w0KwkSr9N2HCIddKorpC97XzuOiyZWg6E2d7VziwBk
         t/A+jH8advDdgpfWjtFesGHRHiVG4R6Wa0SaLNv31SQDuj55J75ju/lmFPCRX6f23Ro9
         BiCw==
X-Gm-Message-State: ANoB5pnfqlQMOEEF1zQPgO4uva3718wUVYwZXhTv3JvL13PVeVs1KZ3k
        fkgfpZIBpQkG7ucwbDnUK/s=
X-Google-Smtp-Source: AA0mqf5BYdX8L/TuXXKZpiczuQdJI3Vkk4Ex9lIvz3xVthSLKrQDUuLi7SKOQIgad2vbsB441au0Sw==
X-Received: by 2002:aa7:de08:0:b0:46a:e4e0:8407 with SMTP id h8-20020aa7de08000000b0046ae4e08407mr35265447edv.36.1670184699651;
        Sun, 04 Dec 2022 12:11:39 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709061da200b007b8a8fc6674sm5451680ejh.12.2022.12.04.12.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 12:11:39 -0800 (PST)
Date:   Sun, 4 Dec 2022 21:11:47 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/4] drivers/net/phy: Add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y4z/A5Yn39AX0yWm@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
 <Y4zgRthpe3ZtBC0x@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zgRthpe3ZtBC0x@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 07:00:38PM +0100, Andrew Lunn wrote:
> > On Sun, Dec 04, 2022 at 03:31:33AM +0100, Piergiorgio Beruto wrote:
> > > +static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
> > > +{
> > > +	const struct ncn26000_priv *const priv = phydev->priv;
> > > +	u16 events;
> > > +	int ret;
> > > +
> > > +	// read and aknowledge the IRQ status register
> > > +	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> > > +
> > > +	if (unlikely(ret < 0))
> > > +		return IRQ_NONE;
> > > +
> > > +	events = (u16)ret & priv->enabled_irqs;
> > > +	if (events == 0)
> > > +		return IRQ_NONE;
> > > +
> > > +	if (events & NCN26000_IRQ_LINKST_BIT) {
> > > +		ret = phy_read(phydev, MII_BMSR);
> > > +
> > > +		if (unlikely(ret < 0)) {
> > > +			phydev_err(phydev,
> > > +				   "error reading the status register (%d)\n",
> > > +				   ret);
> > > +
> > > +			return IRQ_NONE;
> > > +		}
> > > +
> > > +		phydev->link = ((u16)ret & BMSR_ANEGCOMPLETE) ? 1 : 0;
> 
> Hi Piergiorgio
> 
> Interrupt handling in PHY don't follow the usual model. Historically,
> PHYs were always polled once per second. The read_status() function
> gets called to report the current status of the PHY. Interrupt are
> just used to indicate that poll should happen now. All the handler
> needs to do is clear the interrupt line so it can be safely reenabled
> and not cause an interrupt storm, and call phy_trigger_machine() to
> trigger the poll.
To be honest, I sort of realized that. But I was confused again by the
read_status() function description. It looked to me it was not invoked
when AN is not supported, but I'm hearing this is not the case.
I'll rework this part.

Thanks
Piergiorgio
