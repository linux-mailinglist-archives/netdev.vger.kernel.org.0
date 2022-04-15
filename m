Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1618C50288D
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349151AbiDOK6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352460AbiDOK5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:57:35 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6289A997E;
        Fri, 15 Apr 2022 03:55:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t25so9531311edt.9;
        Fri, 15 Apr 2022 03:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UUtTcqZyJwTdSzX5eM/u3FCZPLdu3PueAl2mLvqky+A=;
        b=Hk/dooej2THMRuDz/XHpl8tN3a/98thg7292OnwN82tYBrC8bdky2FS5hKAQV41EJ+
         KGndc61G7SYNGPTqBevzKlMEClgCFI2BE15kNy//uDDY/FR6SyTA7X42CIc6bWznde4c
         mSCarlFDSDzdgiX52bjRG9P5S71USb2K816HKEKNnOpzahJ556qoiuBDBfShKpQi+fQs
         iya+wdKsMWO6l3928C6lR33eLtoZDAEbzbzv3Bklh3Sy2tBXw6hStyKjxTO6dSQrkNiv
         T/KiF7W3UnaV6c/wJhCH6zNTzf3O0IDedbCVLosCpRZzIzTmOn17OtF+X9Sb7V2rh8Z9
         on0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UUtTcqZyJwTdSzX5eM/u3FCZPLdu3PueAl2mLvqky+A=;
        b=GmfXnfVXkHwE9SzHyV6i0aUEdYMXGrPeY7dNIB3ZD78uunZC/HRf83B2NwZe6p3Ghe
         jHQJ62M9vBBEb+S9VV5HSFXkBA/0NadG2qozX3mNCALwWCEXiNzWOOLLiWt7PmcTqPC+
         wyMHcf1+QjvEpxt53u9+GFEwSma/jZfydOUqVGSSiImh1kWhYLMkoobZ0cFLepbBsVcL
         9BRNe5s/gtfSUFu66PlqTg7R8RjeJ7SEMuXHCtcPOWvIyyq0Je3EmyfgW6s/TuaLSC39
         urTAhXh0jq+/+s++o6Pt8I0ExTscuGQIaD+JskovlPploI9E3DwfnMgVrJq54Eq6yIfK
         QNSw==
X-Gm-Message-State: AOAM531sn/JeguaMDvlgaNOsRztrKHCR0ggnAXN87VTui/mECVs6RhMg
        QXdfdHFaRMVElYlg8Lcsx3g=
X-Google-Smtp-Source: ABdhPJyMhX3xvAA8R6o3gdopJREKWoYcIV0cEbauhIguwnYIOMDzmL4cEzVs6yJp290IVHYkTw4D/Q==
X-Received: by 2002:a05:6402:2881:b0:41d:8c32:917 with SMTP id eg1-20020a056402288100b0041d8c320917mr7718756edb.328.1650020106098;
        Fri, 15 Apr 2022 03:55:06 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id i22-20020a1709063c5600b006e8a8a48baesm1591913ejg.99.2022.04.15.03.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 03:55:05 -0700 (PDT)
Date:   Fri, 15 Apr 2022 13:55:03 +0300
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
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415105503.ztl4zhoyua2qzelt@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
 <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
 <20220415113453.1a076746@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415113453.1a076746@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 11:34:53AM +0200, Clément Léger wrote:
> Le Thu, 14 Apr 2022 17:47:09 +0300,
> Vladimir Oltean <olteanv@gmail.com> a écrit :
> > > later (vlan, etc).
> > > 
> > > Suggested-by: Laurent Gonzales <laurent.gonzales@non.se.com>
> > > Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> > > Suggested-by: Phil Edworthy <phil.edworthy@renesas.com>  
> > 
> > Suggested? What did they suggest? "You should write a driver"?
> > We have a Co-developed-by: tag, maybe it's more appropriate here?
> 
> This driver was written from scratch but some ideas (port isolation
> using pattern matcher) was inspired from a previous driver. I thought it
> would be nice to give them credit for that.
> 
> [...]

Ok, in that case I don't really know how to mark sources of inspiration
in the commit message, maybe your approach is fine.

> > >  obj-y				+= hirschmann/
> > >  obj-y				+= microchip/
> > > diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> > > new file mode 100644
> > > index 000000000000..5bee999f7050
> > > --- /dev/null
> > > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > > @@ -0,0 +1,676 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Copyright (C) 2022 Schneider-Electric
> > > + *
> > > + * Clément Léger <clement.leger@bootlin.com>
> > > + */
> > > +
> > > +#include <linux/clk.h>
> > > +#include <linux/etherdevice.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of.h>
> > > +#include <linux/of_mdio.h>
> > > +#include <net/dsa.h>
> > > +#include <uapi/linux/if_bridge.h>  
> > 
> > Why do you need to include this header?
> 
> It defines BR_STATE_* but I guess linux/if_bridge.h does include it.

Yes.

> > > +static void a5psw_port_pattern_set(struct a5psw *a5psw, int port, int pattern,
> > > +				   bool enable)
> > > +{
> > > +	u32 rx_match = 0;
> > > +
> > > +	if (enable)
> > > +		rx_match |= A5PSW_RXMATCH_CONFIG_PATTERN(pattern);
> > > +
> > > +	a5psw_reg_rmw(a5psw, A5PSW_RXMATCH_CONFIG(port),
> > > +		      A5PSW_RXMATCH_CONFIG_PATTERN(pattern), rx_match);
> > > +}
> > > +
> > > +static void a5psw_port_mgmtfwd_set(struct a5psw *a5psw, int port, bool enable)  
> > 
> > Some explanation on what "management forward" means/does?
> 
> I'll probably rename that cpu_port_forward to match the dsa naming.
> It'll actually isolate the port from other ports by only forwarding the
> packets to the CPU port.

You could probably do without a rename by just adding a comment that
says that it enables forwarding only towards the management port.

> > Please implement .shutdown too, it's non-optional.
> 
> Hum, platform_shutdown does seems to check for the .shutdown callback:
> 
> static void platform_shutdown(struct device *_dev)
> {
> 	struct platform_device *dev = to_platform_device(_dev);
> 	struct platform_driver *drv;
> 
> 	if (!_dev->driver)
> 		return;
> 
> 	drv = to_platform_driver(_dev->driver);
> 	if (drv->shutdown)
> 		drv->shutdown(dev);
> }
> 
> Is there some documentation specifying that this is mandatory ?
> If so, should I just set it to point to an empty shutdown function then
> ?

I meant that for a DSA switch driver is mandatory to call dsa_switch_shutdown()
from your ->shutdown method, otherwise subtle things break, sorry for being unclear.

Please blindly copy-paste the odd pattern that all other DSA drivers use
in ->shutdown and ->remove (with the platform_set_drvdata(dev, NULL) calls),
like a normal person :)

> > > + * @reg_lock: Lock for register read-modify-write operation  
> > 
> > Interesting concept. Generally we see higher-level locking schemes
> > (i.e. a rmw lock won't really ensure much in terms of consistency of
> > settings if that's the only thing that serializes concurrent thread
> > accesses to some register).
> 
> Agreed, this does not guarantee consistency of settings but guarantees
> that rmw modifications are atomic between devices. I wasn't sure about
> the locking guarantee that I could have. After looking at other
> drivers, I guess I will switch to something more common such as using
> a global mutex for register accesses.

LOL, that isn't better...

Ideally locking would be done per functionality that the hardware can
perform independently (like lookup table access, VLAN table access,
forwarding domain control, PTP block, link state control, etc).
You don't want to artificially serialize unrelated stuff.
A "read-modify-write" lock would similarly artificially serialize
unrelated stuff for you, even if you intend it to only serialize
something entirely different.

Most things as seen by a DSA switch driver are implicitly serialized by
the rtnl_mutex anyway. Some things aren't (->port_fdb_add, ->port_fdb_del).
There is a point to be made about adding locks for stuff that is
implicitly serialized by the rtnl_mutex, since you can't really test
their effectiveness. This makes it more difficult for the driver writer
to make the right decision about locking, since in some cases, the
serialization given by the rtnl_mutex isn't something fundamental and
may be removed, to reduce contention on that lock. In that case, it is
always a nice surprise to find a backup locking scheme in converted
drivers. With the mention that said backup locking scheme was never
really tested, so it may be that it needs further work anyway.

> > The selftests don't cover nearly enough, but just to make sure that they
> > pass for your switch, when you use 2 switch ports as h1 and h2 (hosts),
> > and 2 ports as swp1 and swp2? There's surprisingly little that you do on
> > .port_bridge_join, I need to study the code more.
> 
> Port isolation is handled by using a pattern matcher which is enabled
> for each port at setup. If set, the port packet will only be forwarded
> to the CPU port. When bridging is needed, the pattern matching is
> disabled and thus, the packets are forwarded between all the ports that
> are enabled in the bridge.

Is there some public documentation for this pattern matcher?
