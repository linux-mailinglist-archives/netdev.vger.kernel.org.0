Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63ABB59C9AA
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiHVULi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiHVUL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 16:11:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AD353D32
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:11:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pm13so3144435pjb.5
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=O5VnZ+lOi0bcNPXBayzq4uKMnrWOVSM8YLSt5Qe1iN0=;
        b=YUwTVg6PfPw7p4kdFUo+ZY/WHRWXrdh4qR0CTGBC7otsyrKyQC0XTvNACl4Xdn3ulw
         9ezu0u9muyo4EYSCvzK8ks/Q8t6KD4bw2ldyHxcA2fwSBjPCtfHdp+DolgBMnTUxrWhN
         kuRz7799juXfjMFCNqp0Ymo/RdW2pHWeWWif6fy5y2z2hfMwhrj/76mVeCKy5mcu1i/v
         0951jnx5OIUTSBYtG4xwr4c5BfFDJhqH04Ywlbre3F11GJE2nrT8I7pgBvT7zCAYkhlD
         VZfnShKsJWZ5hacZzyn4iqPEWyBCH/UbAwiAw18t4E0I2g36TZN7XDxIT6AZbmqXFwb4
         M+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=O5VnZ+lOi0bcNPXBayzq4uKMnrWOVSM8YLSt5Qe1iN0=;
        b=GJwleKByb9hqgffQ+O7qjELQ4HEHqQixbNqvmkSQAkR+f/dV1tqVGNQ0kv8AMGufKV
         VvomZQlNIrGRBNxyzcArRYkOEbcEAoyO6VSrz5nuWRz94kG6ZCo+wTST5PHuznzB0kta
         VO5qhPRE7BWsbRMISqPSBKks+lZqjpY9SnRQVjAMNAc6oLdQkOU96WQkVD/gy6cDdTUm
         ikM+RqXycsHuDLXuGEEkK81grgsnDr2F3kkz78XdJg39GmxTYHMPDPNWf+Xnodtk3m3d
         ljp/8DcQnqEbEVlXvAQFkuYdtxqwLStHZJhpLi/1nOjLmC5zTRaayJQtCi9Ug9LR5zDX
         uxeQ==
X-Gm-Message-State: ACgBeo2iLXSsctaa8CQVIO+IpTPT2J4VWnrvqY67wA7c4XkPqhvISpvR
        PmF+/eezmep0ZNWmgxqv/D7glxGTp0McwSLqt+VMeg==
X-Google-Smtp-Source: AA6agR4Pk+c5udP3H9GHpM2FKqlDT+qU8fjCEnkiEfMdOV8wcpI97AYfmxwcgC0bj26u+MObf67AyDezMEcAh0R7ERg=
X-Received: by 2002:a17:90b:4f8e:b0:1f4:ed30:d286 with SMTP id
 qe14-20020a17090b4f8e00b001f4ed30d286mr60251pjb.66.1661199084030; Mon, 22 Aug
 2022 13:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <095c6c01-d4dd-8275-19fc-f9fe1ea40ab8@rasmusvillemoes.dk> <20220819105700.5a226titio5m2uop@skbuf>
 <5c9aa2f3-689f-6dd7-ed26-de11e14f5ba0@rasmusvillemoes.dk> <20220819164157.hubjxqczaxnoltjy@skbuf>
In-Reply-To: <20220819164157.hubjxqczaxnoltjy@skbuf>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 22 Aug 2022 13:11:11 -0700
Message-ID: <CAJ+vNU0Up2tcpRuU2Erq+Y7HfiPigpzvCTKcEvyJohcRCKVEyg@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?UTF-8?B?QWx2aW4g4pS8w6FpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 9:42 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Fri, Aug 19, 2022 at 01:47:51PM +0200, Rasmus Villemoes wrote:
> > > To give you an idea of how things work for user ports. If a user port
> > > has a phy-handle, DSA will connect to that, irrespective of what OF-based
> > > MDIO bus that is on. If not, DSA looks at whether ds->slave_mii_bus is
> > > populated with a struct mii_bus by the driver. If it is, it connects in
> > > a non-OF based way to a PHY address equal to the port number. If
> > > ds->slave_mii_bus doesn't exist but the driver provides
> > > ds->ops->phy_read and ds->ops->phy_write, DSA automatically creates
> > > ds->slave_mii_bus where its ops are the driver provided phy_read and
> > > phy_write, and it then does the same thing of connecting to the PHY in
> > > that non-OF based way.
> >
> > Thanks, that's quite useful. From quick grepping, it seems that ksz9567
> > currently falls into the latter category?
>
> So it would appear.
>
> > No, but it's actually easier for me to just do that rather than carry an
> > extra patch until the mainline fix hits 5.19.y.
>
> Whatever suits you best.
>
> > > there is something to be said about U-Boot compatibility. In U-Boot,
> > > with DM_DSA, I don't intend to support any unnecessary complexity and
> > > alternative ways of describing the same thing, so there, phy-mode and
> > > one of phy-handle or fixed-link are mandatory for all ports.
> >
> > OK. I suppose that means the linux driver for the ksz9477 family  should
> > learn to check if there's an "mdio" subnode and if so populate
> > ds->slave_mii_bus, but unlike lan937x, absence of that node should not
> > be fatal?
>
> Yes.
>
> > > U-Boot can pass its own device tree to Linux, it means Linux DSA drivers
> > > might need to gradually gain support for OF-based phy-handle on user
> > > ports as well. So see what Tim Harvey has done in drivers/net/ksz9477.c
> > > in the U-Boot source code, and try to work with his device tree format,
> > > as a starting point.
> >
> > Hm. It does seem like that driver has the mdio bus optional (as in,
> > probe doesn't fail just because the subnode isn't present). But I'm
> > curious why ksz_probe_mdio() looks for a subnode called "mdios" rather
> > than "mdio". Tim, just a typo?
>
> No, definitely not a typo. I have to explain this for what seems like
> the millionth time already, but the idea with an "mdios" container was
> copied from the sja1105 driver, where there are actually multiple MDIO
> buses. Documentation/devicetree/bindings/net/mdio.yaml wants the $nodename
> to have the "^mdio(@.*)?" pattern, and:
> - if you use "mdio" you can have a single node
> - if you don't put the MDIO nodes under a container with an
>   #address-cells != 0, you can't use the "mdio@something" syntax
>
> https://lore.kernel.org/all/20210621234930.espjau5l2t5dr75y@skbuf/T/#me43cf6b1976a3c3aec8357f19ab967f98eea1f73
>
> What I'm actually less clear about is whether ksz9477 actually needs this.
> Luckily U-Boot should have less compatibility issues to worry about,
> since the DT is appended to the bootloader image, so some corrections
> can be made if necessary.

Vladimir,

The linux ksz9477 driver does not need the 'mdios' subnode or
phy-handle's to function properly. I added these nodes to the U-Boot
dts for imx8mm-venice-gw7901.dts and imx8mp-venice-gw74xx.dts in order
for the U-Boot ksz9477 driver to work properly. So now I have
out-of-sync dts files for those that will cause an issue the next time
someone sync's dts from Linux back to U-Boot:

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts b/arch/arm64
/boot/dts/freescale/imx8mp-venice-gw74xx.dts
index 8469d5ddf960..f0bd67f12bad 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
@@ -500,6 +500,7 @@ ports {
                        lan1: port@0 {
                                reg = <0>;
                                label = "lan1";
+                               phy-handle = <&sw_phy0>;
                                phy-mode = "internal";
                                local-mac-address = [00 00 00 00 00 00];
                        };
@@ -507,6 +508,7 @@ lan1: port@0 {
                        lan2: port@1 {
                                reg = <1>;
                                label = "lan2";
+                               phy-handle = <&sw_phy1>;
                                phy-mode = "internal";
                                local-mac-address = [00 00 00 00 00 00];
                        };
@@ -514,6 +516,7 @@ lan2: port@1 {
                        lan3: port@2 {
                                reg = <2>;
                                label = "lan3";
+                               phy-handle = <&sw_phy2>;
                                phy-mode = "internal";
                                local-mac-address = [00 00 00 00 00 00];
                        };
@@ -521,6 +524,7 @@ lan3: port@2 {
                        lan4: port@3 {
                                reg = <3>;
                                label = "lan4";
+                               phy-handle = <&sw_phy3>;
                                phy-mode = "internal";
                                local-mac-address = [00 00 00 00 00 00];
                        };
@@ -528,6 +532,7 @@ lan4: port@3 {
                        lan5: port@4 {
                                reg = <4>;
                                label = "lan5";
+                               phy-handle = <&sw_phy4>;
                                phy-mode = "internal";
                                local-mac-address = [00 00 00 00 00 00];
                        };
@@ -544,6 +549,38 @@ fixed-link {
                                };
                        };
                };
+
+               mdios {
+                       #address-cells = <1>;
+                       #size-cells = <0>;
+
+                       mdio@0 {
+                               reg = <0>;
+                               compatible = "microchip,ksz-mdio";
+                               #address-cells = <1>;
+                               #size-cells = <0>;
+
+                               sw_phy0: ethernet-phy@0 {
+                                       reg = <0x0>;
+                               };
+
+                               sw_phy1: ethernet-phy@1 {
+                                       reg = <0x1>;
+                               };
+
+                               sw_phy2: ethernet-phy@2 {
+                                       reg = <0x2>;
+                               };
+
+                               sw_phy3: ethernet-phy@3 {
+                                       reg = <0x3>;
+                               };
+
+                               sw_phy4: ethernet-phy@4 {
+                                       reg = <0x4>;
+                               };
+                       };
+               };
        };
 };

I believe you are still of the opinion that support for parsing the
mdios node above be added to the Linux DSA drivers and dt-bindings or
were you suggesting just the bindings be added? I don't think bindings
would get ack'd unless there was code actually using them for
something and its not clear to me exactly what you were asking for.

Best Regards,

Tim
