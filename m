Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2C65090C3
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381858AbiDTTzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 15:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239428AbiDTTzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 15:55:06 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D913D27FEB;
        Wed, 20 Apr 2022 12:52:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g18so5661851ejc.10;
        Wed, 20 Apr 2022 12:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SZrgLLDQ7PgoSi/7g5Obv5jfV72dMP0nKyqFwVpsbBs=;
        b=m5W2J6jCd0XixCAf8PenQ6GaqE1jzdwvhN3tZklypsvNiipXZ3wuxlqFPH3OVmLgxU
         UdtPp7c6U2La8eMu87S7ADwQ2OYUjlFJ9WTZXuoxd49Yuvy4mRi/dx8sUoKPQLGxx6SR
         GAes2X62JqgjT446TUjEnkchn1YkABqhn0W/2LZYXf5fPlWDBSZ25ozlJY9/aHwLrn3R
         OIXNsRWqDF9mq6z62++Mxn40cJgOvNdaHsw+RU9XT3HX0pSdue/UFYH4HQ6WhFAu9ZlE
         7wOZDx12rIlDl+Y1s7+AG2M/8TYNMKFL7KLE9BcJuDY5s7E9ILj4bX9T0jZ48m18gyy/
         PPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SZrgLLDQ7PgoSi/7g5Obv5jfV72dMP0nKyqFwVpsbBs=;
        b=RIiSkXO7kof+XLlxtHFPTuD3ZbT+yQl79svsXy49mvAe4jrjsstCL8pRWdd0NSj6Y9
         hToljAVKywEO2KCYSpJ1HadlZPhazRmdvTG7C9psvgjHHVGEUPdCCXmIMQcqV75yohq5
         tgiVUlsjd4Uhna0BApJ/h1QrCsiwzWmI7gl4pGScFR7k9JJjCUXLrOVcRHsFt+n73mn7
         SnrohoTTHTVczoLgPZxGUm7Ya6Du2po//mf6Sn7aQnlBF2lo7pqpgn2hYaDwglTrvl6O
         B4fw8AYznsd0tVUed1rEaVaJDCZyqg31CGty775Vq3FM/NLSby6gd3F/WPvpVrIWs0oI
         iECg==
X-Gm-Message-State: AOAM5338jb+RksDizd8WZEXUamKY8HGEfEVG3lF0KPdjLOUuljP1o4AW
        fnx1J2Orv7winjnP7DQ92vQ=
X-Google-Smtp-Source: ABdhPJwuwg37hWZfP+nzyVodKRQj2bvQGOzMYrc0cUeVqZjR744WW0PEf9w5IghNIi9OoCftj3065w==
X-Received: by 2002:a17:907:6e8a:b0:6ef:76b8:3379 with SMTP id sh10-20020a1709076e8a00b006ef76b83379mr20741261ejc.457.1650484337397;
        Wed, 20 Apr 2022 12:52:17 -0700 (PDT)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id gl2-20020a170906e0c200b006a767d52373sm7006713ejb.182.2022.04.20.12.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 12:52:16 -0700 (PDT)
Date:   Wed, 20 Apr 2022 22:52:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/12] net: dsa: rzn1-a5psw: add FDB support
Message-ID: <20220420195214.dnekbfhha53trbke@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-9-clement.leger@bootlin.com>
 <20220414175140.p2vyy7f7yk6vlomi@skbuf>
 <20220420101648.7aa973b2@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220420101648.7aa973b2@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 10:16:48AM +0200, Clément Léger wrote:
> Le Thu, 14 Apr 2022 20:51:40 +0300,
> Vladimir Oltean <olteanv@gmail.com> a écrit :
> 
> > > +
> > > +static int a5psw_port_fdb_add(struct dsa_switch *ds, int port,
> > > +			      const unsigned char *addr, u16 vid,
> > > +			      struct dsa_db db)  
> > 
> > This isn't something that is documented because I haven't had time to
> > update that, but new drivers should comply to the requirements for FDB
> > isolation (not ignore the passed "db" here) and eventually set
> > ds->fdb_isolation = true. Doing so would allow your switch to behave
> > correctly when
> > - there is more than one bridge spanning its ports,
> > - some ports are standalone and some ports are bridged
> > - standalone ports are looped back via an external cable with bridged
> >   ports
> > - unrecognized upper interfaces (bond, team) are used, and those are
> >   bridged directly with some other switch ports
> > 
> > The most basic thing you need to do to satisfy the requirements is to
> > figure out what mechanism for FDB partitioning does your hardware have.
> > If the answer is "none", then we'll have to use VLANs for that: all
> > standalone ports to share a VLAN, each VLAN-unaware bridge to share a
> > VLAN across all member ports, each VLAN of a VLAN-aware bridge to
> > reserve its own VLAN. Up to a total of 32 VLANs, since I notice that's
> > what the limit for your hardware is.
> 
> Ok, I see the idea. In the mean time, could we make a first step with a
> single bridge and without VLAN support ? This is expected to come later
> anyway.
> 
> > 
> > But I see this patch set doesn't include VLAN functionality (and also
> > ignores the "vid" from FDB entries), so I can't really say more right now.
> > But if you could provide more information about the hardware
> > capabilities we can discuss implementation options.
> 
> That's indeed the problem. The FDB table does not seems to have
> partitionning at all (except for ports) and entries (such as seen below)
> do not contain any VLAN information.
> 
> > > diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> > > index b34ea549e936..37aa89383e70 100644
> > > --- a/drivers/net/dsa/rzn1_a5psw.h
> > > +++ b/drivers/net/dsa/rzn1_a5psw.h
> > > @@ -167,6 +167,22 @@
> > >  #define A5PSW_CTRL_TIMEOUT		1000
> > >  #define A5PSW_TABLE_ENTRIES		8192
> > >  
> > > +struct fdb_entry {  
> > 
> > Shouldn't this contain something along the lines of a VID, FID, something?
> 
> This is extracted directly from the datasheet [1]. The switch FDB table
> does not seems to store the VID with the entries (See page 300).
> 
> [1]
> https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-group-users-manual-r-engine-and-ethernet-peripherals

Thanks for the link. I see that the switch has a non-partitionable
lookup table, not even by VLAN. A shame.

This is also in contrast with the software bridge driver, where FDB and
MDB entries can have independent destinations per VID.

So there's nothing you can do beyond limiting to a single offloaded
bridge and hoping for the best w.r.t. per-VLAN forwarding destinations.

Note that if you limit to a single bridge does not mean that you can
declare ds->fdb_isolation = true. Declaring that would opt you into
unicast and multicast filtering towards the CPU, i.o.w. a method for
software to only receive the addresses it has expressed an interest in,
rather than all packets received on standalone ports. The way that is
implemented in DSA is by adding FDB and MDB entries on the management
port, and it would break a lot of things without a partitioning scheme
for the lookup table.
