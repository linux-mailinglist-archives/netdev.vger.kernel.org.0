Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B2D57EF45
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 15:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbiGWNox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 09:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236223AbiGWNov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 09:44:51 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BFE220CF;
        Sat, 23 Jul 2022 06:44:50 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id j22so12998194ejs.2;
        Sat, 23 Jul 2022 06:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=49amiazncfe+YGfCcsE1Umxq5UaZUxFQiGQFBx6ze1c=;
        b=GLIzSCflcbjXQKRTFNrUPUCwiNVLFsPGiGJTuboZnWUsmIuIflEZO+CT6K5TmH7rbn
         RCzLCwDXGvlTP9QmVPo3bhZjTFjnw/SlnMR3uqYCjusfuTisFXtgjvYyt2ZGulp8HT2Y
         d9fa7k1valp+ReEH69JJtiBLmn5fDHE1Ik89gedHUzegG2JyLzkrpHQ9bFP6j9qrukPy
         CoJMS8qw+MSB9+LSt20cGAS9do5ANXxYx47Y9pXZq3dQrE5YnNCBi0gLefo7XJTpTTm+
         QXCMZ7J1bsXPgvFdumg8YVyJAJEPNqeKR8e54kAhIAuZPjBEzyz+Qb318dbcFAsChVL7
         wEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=49amiazncfe+YGfCcsE1Umxq5UaZUxFQiGQFBx6ze1c=;
        b=vfupcyaKS0ShCjyPPiXfc3jw6dPaMMBhgM7gn61kqhJtkA0snBSjbhu5n+09nOlnlw
         zbOLA1JsLCutdN6PGUQLHdSinESFi2gOSKi8ymb4gUD8vL0w0vzY7yvy5seEuSBIfuPQ
         l4LoO8rpVI6Q7FQv29GaIbFikcGTQQGtS5nbVZIAOBbkRPgSyJXtZbvQSsUhmrgyo18Z
         yHUx8QJzG6mO9XZUHcLpWkOcGMnURkNP9g4esh8VRqI6hFTU3OMhAUyM3dQmXLvWMybv
         pO71jWQ4DteiQ7JwZ7XhCMM4a8rHs1a1K5qpbq5nYywlTsPBcJf9I2diOrCq+qjjZuNy
         m69g==
X-Gm-Message-State: AJIora+HKA2TI9TRDZ66VcS8n2D8f/YcJO/pUgvCW0d27QCoyEwFKP3H
        7YGCm0hVHuRcGynEIE2eU74=
X-Google-Smtp-Source: AGRyM1uVkPV5hLTPJLLcAQ9tlPKSclPGRO6ACvn74IDvvQ5HKYpLnh7Bs/psd8uUthI973Mvf4L3mQ==
X-Received: by 2002:a17:907:9608:b0:72f:4b13:c66c with SMTP id gb8-20020a170907960800b0072f4b13c66cmr3445161ejc.531.1658583888669;
        Sat, 23 Jul 2022 06:44:48 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 16-20020a170906301000b0072efb6c9697sm3171067ejz.101.2022.07.23.06.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 06:44:47 -0700 (PDT)
Date:   Sat, 23 Jul 2022 16:44:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220723134444.e65w3zq6pg43fcm4@skbuf>
References: <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
 <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
 <20220722165600.lldukpdflv7cjp4j@skbuf>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <20220722223932.poxim3sxz62lhcuf@skbuf>
 <YtufRO+oeQgmQi57@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtufRO+oeQgmQi57@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 08:12:04AM +0100, Russell King (Oracle) wrote:
> > > > Thanks for this explanation, if nothing else, it seems to support the
> > > > way in which I was interpreting managed = "in-band-status" to mean
> > > > "enable in-band autoneg", but to be clear, I wasn't debating something
> > > > about the way in which mvneta was doing things. But rather, I was
> > > > debating why would *other* drivers do things differently such as to come
> > > > to expect that a fixed-link master + an in-band-status CPU port, or the
> > > > other way around, may be compatible with each other.
> > > 
> > > Please note that phylink makes a DT specification including both a
> > > fixed-link descriptor and a managed in-band-status property illegal
> > > because these are two different modes of operating the link, and they
> > > conflict with each other.
> > 
> > Ok, thank you for this information which I already knew, what is the context?
> 
> FFS. You're the one who's writing emails to me that include *both*
> "fixed-link" and "in-band-status" together. I'm pointing out that
> specifying that in DT for a port together is not permitted.
> 
> And here I give up reading this email. Sorry, I'm too frustrated
> with this nitpicking, and too frustrated with spending hours writing a
> reply only to have it torn apart.

This is becoming toxic. You've imagined that when I was talking about
mixing fixed-link and managed = "in-band-status" I was referring to this
kind of DSA port OF node:

	port@N {
		managed = "in-band-status";

		fixed-link {
			speed = <1000>;
			full-duplex;
		};
	};

Now you're thinking I'm retarded because you've politely told me the above
is invalid, and you're wondering why I'm still talking despite of that.

Well guess what, I've never once mentioned this kind of invalid OF node,
I'm not the one who's writing emails to you that include
"both fixed-link and in-band-status together", yet in your mind the fact
that you may have misunderstood isn't even a possibility. What I'm
talking about is TWO OF nodes, one like this:

	master: ethernet@N: {
		managed = "in-band-status";
	};

	switch_cpu_port: port@N: {
		ethernet = <&master>;

		fixed-link {
			speed = <1000>;
			full-duplex;
		};
	};

It is *these* two that need to agree on in-band autoneg, when the "fixed-link"
of switch_cpu_port was created using software nodes, damn it. Andrew
said that it isn't specified whether in-band autoneg is used or not.
It was even repeated for the millionth time in the continuation of my
email, which you should have read instead of frustrating yourself for a
stupid reason again.

If you think I'm making this up and I *was* talking about in-band-status
and fixed-link together in the same node, go ahead and search back where
I've said that, or even implied that. But don't blame me when you'll get
frustrated again that you won't find it. I re-read what I said once
yesterday and once today.

That's where our communication problem is, you're politely trying to
tell your conversation partner that he's an idiot and he JUST DOESN'T
WANT TO UNDERSTAND, DAMN IT.

In any case, it looks like it's time to remove myself from this conversation.
I am going to propose a patch shortly which adds validation in DSA for
the OF nodes of DSA and CPU ports, and opts some drivers out of it.
I'm going to opt into validation as many drivers as reasonably possible.
You'll then have to work with the driver maintainers who opted out of
it. I'm not one of them, so you won't have to work with me. Beyond that,
I just don't care and I had enough. I have other things to do too.
