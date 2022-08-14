Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C5C591E15
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 06:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiHNE0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 00:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiHNE0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 00:26:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7AD18383
        for <netdev@vger.kernel.org>; Sat, 13 Aug 2022 21:26:27 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oN5CU-0002Nu-2M; Sun, 14 Aug 2022 06:26:10 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oN5CS-0007qk-2t; Sun, 14 Aug 2022 06:26:08 +0200
Date:   Sun, 14 Aug 2022 06:26:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 07/10] net: dsa: microchip: warn about not
 supported synclko properties on KSZ9893 chips
Message-ID: <20220814042608.GC12534@pengutronix.de>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-8-o.rempel@pengutronix.de>
 <20220802113633.73rxlb2kmihivwpx@skbuf>
 <20220805115601.GB10667@pengutronix.de>
 <20220805134234.ps4qfjiachzm7jv4@skbuf>
 <20220813143215.GA12534@pengutronix.de>
 <Yve/MSMc/4klJPFL@lunn.ch>
 <20220813161850.GB12534@pengutronix.de>
 <YvgMnfSkEeD8jwIG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment
In-Reply-To: <YvgMnfSkEeD8jwIG@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ccing Rob Herring.

On Sat, Aug 13, 2022 at 10:42:05PM +0200, Andrew Lunn wrote:
> On Sat, Aug 13, 2022 at 06:18:50PM +0200, Oleksij Rempel wrote:
> > On Sat, Aug 13, 2022 at 05:11:45PM +0200, Andrew Lunn wrote:
> > > On Sat, Aug 13, 2022 at 04:32:15PM +0200, Oleksij Rempel wrote:
> > > > On Fri, Aug 05, 2022 at 04:42:34PM +0300, Vladimir Oltean wrote:
> > > > > On Fri, Aug 05, 2022 at 01:56:01PM +0200, Oleksij Rempel wrote:
> > > > > > Hm, if we will have any random not support OF property in the switch
> > > > > > node. We won't be able to warn about it anyway. So, if it is present
> > > > > > but not supported, we will just ignore it.
> > > > > > 
> > > > > > I'll drop this patch.
> > > > > 
> > > > > To continue, I think the right way to go about this is to edit the
> > > > > dt-schema to say that these properties are only applicable to certain
> > > > > compatible strings, rather than for all. Then due to the
> > > > > "unevaluatedProperties: false", you'd get the warnings you want, at
> > > > > validation time.
> > > > 
> > > > Hm, with "unevaluatedProperties: false" i have no warnings. Even if I
> > > > create examples with random strings as properties. Are there some new
> > > > json libraries i should use?
> > > 
> > > Try
> > > 
> > > additionalProperties: False
> > 
> > Yes, it works. But in this case I'll do more changes. Just wont to make
> > sure I do not fix not broken things.
> 
> I've been working on converting some old SoCs bindings from .txt to
> .yaml. My observations is that the yaml is sometimes more restrictive
> than what the drivers actually imposes. So you might need to change
> perfectly working .dts files to get it warning free. Or you just
> accept the warnings and move on. At lot will depend on the number of
> warnings and how easy it is to see real problems mixed in with
> warnings you never intend to fix.

Heh :) Currently with "unevaluatedProperties: false" restrictions do not
work at all. At least for me. For example with this change I have no
warnings:
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1e26d876d1463..da38ad98a152f 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -120,6 +120,7 @@ examples:
             ethernet-switch@1 {
                     reg = <0x1>;
                     compatible = "nxp,sja1105t";
+                    something-random-here;
 
                     ethernet-ports {
                             #address-cells = <1>;

make dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml

So the main question is, is it broken for all or just for me? If it is
just me, what i'm doing wrong?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
