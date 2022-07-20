Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534A357C03A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 00:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiGTWoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 18:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGTWox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 18:44:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DA1491C6;
        Wed, 20 Jul 2022 15:44:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e15so171040edj.2;
        Wed, 20 Jul 2022 15:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ct/iLYoKm72/DfhaeEt2u4sR7x6ULpY5sDqkV7W4748=;
        b=Wjuo1LA2j5Lvu+MusadB1CSwVuBZt99+k2xwxyR2ASPnHVJvFMStOqwxT+NT8krTVl
         /gu6jsPiF2wTqLapMOWvQkzv/E4da6ONG00nkWBbRfnOwPIibw3nI9ICJo8/oZILfFiY
         vGn3p//uU6q7Pk/nmELueDFrxul6Aao9gonq2gLcE86BxLGEXaJmPJ/HlOBEmXX2RvSW
         54XskEOFXmlIiogrueC5oZO481Gdyxej6DrZDRpOBL6OYRiWrHueaX0+JNQJ9+H4kS7c
         LbFebX7kOUecwZF7P1XRMWFWQryjZTX2SXeMGEWR2UGxmLUfZBjdKgid7e8UDB8Z/PRt
         PABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ct/iLYoKm72/DfhaeEt2u4sR7x6ULpY5sDqkV7W4748=;
        b=SOOTyBM7HwcwJ1kbKxBkMUsbvhmwWPXHreKbmsgWYOsaGGBQzxMzv3VKaRxARzcYks
         IQaqV7bX+J5lnRsRft66ICxllnqQd6ynEH2QURYadyXPgagtWVSgQZWgdS3egKQbPaCP
         Zz85KMOgAtjUVhPzsQlvdBOX9VpgEBnlz/DbKFlPHxHbTa2SFbBNUr/Uda2BPflVPlOG
         +J+1/EE4yDWlPk2dTn8WhUaBU0f6JqP9Mj1FTPLJqkBLtjYD2zz7lExGruaIFau4rjfN
         hNBdz+09ubjX05CDmM3nxN6GR9QV+nGGlHXHDfFNpIl9aPVRr5iCJtcA47lC90nZk74d
         4Vzw==
X-Gm-Message-State: AJIora/BeSb78/U3F9QR0I0j72Dh6bCm04Lx3FdrCup+TUlcXdWBN91j
        2IFxQtP97kzvx6aQ4W8jzPY=
X-Google-Smtp-Source: AGRyM1vMjLYa4KJBKuoZ3VrnudTHejnE3aEB/ZOYLPSzbKDr2CbtfeK5JoT+rtjtarlWmBfNIBXwXQ==
X-Received: by 2002:a05:6402:f2a:b0:43a:9d53:e0e6 with SMTP id i42-20020a0564020f2a00b0043a9d53e0e6mr54302800eda.394.1658357091241;
        Wed, 20 Jul 2022 15:44:51 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id s17-20020aa7cb11000000b0043aa5c2ce17sm126831edt.35.2022.07.20.15.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 15:44:50 -0700 (PDT)
Date:   Thu, 21 Jul 2022 01:44:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220720224447.ygoto4av7odsy2tj@skbuf>
References: <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <20220715172444.yins4kb2b6b35aql@skbuf>
 <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
 <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
 <20220716105711.bjsh763smf6bfjy2@skbuf>
 <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
 <20220716123608.chdzbvpinso546oh@skbuf>
 <YtUec3GTWTC59sky@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtUec3GTWTC59sky@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 09:48:51AM +0100, Russell King (Oracle) wrote:
> > But drivers could also have their CPU port working simply because those
> > are internal to an SoC and don't need any software configuration to pass
> > traffic. In their case, there is no breakage caused by the phylink_pcs
> > conversion, but breakage caused by sudden registration of phylink is
> > plausible, if phylink doesn't get the link parameters right.
> > 
> > And that breakage is preventable. Gradually more drivers could be
> > converted to create a fixed-link software node by printing a warning
> > that they should, and still keep the logic to avoid phylink registration
> > and putting the respective port down. Driver authors might not be very
> > responsive to RFC patch sets, but they do look at new warnings in dmesg
> > and try to see what they're about.
> 
> Are you going to do that conversion then? Good luck trying to find all
> the drivers, sending out series of patches, trying to get people to test
> the changes.

Not sure if that's a rhetorical question and if it is, what it's trying
to prove. Of course I'm not going to do any conversion, that's literally
my whole point, I'd rather err on the side of letting sleeping dogs cry
than force-converting everyone at once.

If there is a breakage report and the driver maintainer won't respond,
then yeah, maybe I'll consider looking at that particular issue and
converting if it helps, but that's kind of why I'm here.

Otherwise, we may end up pushing phylink to drivers which have some
wacky link speeds on the CPU port (like 2000, see b53_force_port_config),
which the software node auto-creation logic absolutely won't get right.
I know Florian said that "we won't see a regression since we do not use
the NATP accelerator which would be the reason to run the port at
2Gbits/sec", but frankly I'm not entirely sure what that even means or
what Florian counts as "regression". Lower overall termination throughput
counts or not? Still not worth risking if this isn't the only instance
of a non-standard speed.

> > What I'm missing is the proof that the phylink_pcs conversion has broken
> > those kinds of switches, and that it's therefore pointless to keep the
> > existing logic for them. Sorry, but you didn't provide it.
> 
> I don't have evidence that existing drivers have broken because I don't
> have the hardware to test. I only have Marvell DSA switch hardware and
> that is it.
> 
> Everything else has to be based on theory because no one bothers to
> respond to my patches, so for 99% of the DSA drivers I'm working in the
> dark - and that makes development an utter shitpile of poo in hell.
> 
> As I've said many times, we have NO CLUE which DSA drivers make use of
> this defaulting behaviour - the only one I'm aware of that does is
> mv88e6xxx. It all depends on the firmware description, driver behaviour
> and hardware behaviour. There is not enough information in the kernel 
> to be able to derive this.
> 
> If there was a reported regression, then I would be looking to get this
> into the NET tree not the NET-NEXT tree.

I think there are authors who weren't even aware they were opting into
this interesting DSA feature when they wrote their driver, but didn't
have the inspiration at the time to validate strict DT bindings either.

We have no proof that they don't have DT blobs using the defaulting
feature somewhere out there, but we don't have any proof that they do,
either. The whole problem could become more manageable if we would let
maintainers say to a user "hey, for my driver this feature was never
intended to work, so sorry if by accident it did, it was a marginal and
undocumented condition and now it's broken, so please use something that
was documented".

The ocelot driver is in this exact state, in fact. I really wish there
was a ready-made helper for validating phylink's OF node; I mentioned this
already, it needs to cater for all of fixed-link/phy-handle/managed/sfp.
The more drivers would be calling this (I think the vast majority of
post-phylink drivers would do it), the more we'd minimize the spectrum
of unforeseen breakage. In turn this would make the issue more tractable.
