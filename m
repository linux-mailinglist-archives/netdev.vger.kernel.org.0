Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94076B81E4
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 20:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjCMTyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 15:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCMTyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 15:54:44 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8CD30B18;
        Mon, 13 Mar 2023 12:54:42 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id cy23so53267291edb.12;
        Mon, 13 Mar 2023 12:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678737282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hTglOzPQxV2ZuftBtVzhxCqyC3HbKgEioLlxEWe4OF8=;
        b=JttE3gmIYlCcKby2+xgkbT/lIs9POUazUWd3uxDJGEB9Dx8dLmf2aR+BbgiM6/A552
         S2eMTPgQMcK2HBVbLD15dZ+agSY9Oi89Kt9h8s1KawGLE7rRS0rKgeGWmeLtEp6RsRK5
         F15ZbSUZgyrx7/NGApTktSKHlkWsseHpvxceEoIpSrv5qSJ4ICWdhmSSvnKnqBzFyx3X
         VPkT+iNISkCPyxobTIud1DRInQTEWfFu8yBB3e0TOa+It+WKNheLJsn/vWRLwAZB5nTd
         yipnKMAIn/yRWThYlUPpTyGVAZWmJXsd0V+CPdpkmocbqHdY0Lux9z7I+Ma63PYdQchc
         xxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678737282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTglOzPQxV2ZuftBtVzhxCqyC3HbKgEioLlxEWe4OF8=;
        b=aNYC2FrskWvvOFTaPAtklEZjh3bmDJeoKTa+Mt6ravTpMmEsmy90jUqSdxPEKbbUIo
         2iTqPpq8cS+m1H5s4Vm4n4czHouRqfj64wNq0mFISA+q7LTAHeY8KKqUAiQr8Y+OGgum
         Yqd7iCbu9S9AcwAq9a++ucs4O6AMeQe1ubl3ztB42EX/CGfPlQurorRbHWXCM5BKhLt0
         4BkbSkqP0rJdl8JhCfNXF8KX4Kbn9xtnm2+cc8EuEbb90WOcaRNhNChDOwtRvxOnO60x
         Bu7YPmZ+CgZuW5HgVd3eWmLS2fCT21A3dQ5jkbtRCr5zv28UcUHW/UVqewRbAWR56ZEn
         TbOQ==
X-Gm-Message-State: AO0yUKUMUkcZWr2tcmdlD3uWrcGWswOkjLkTM0q4Z8T6rl+hED4wK18J
        2MFOt48YSbEv3QIzqN9GfoA=
X-Google-Smtp-Source: AK7set+K12/AxM41nagz1zoXa7jEp5xLjOwzrSoHPukoLxiDyfAjCyQAQhmQZ/fLI0iE8JirjODBeg==
X-Received: by 2002:a17:906:b14f:b0:8b1:7de9:b38c with SMTP id bt15-20020a170906b14f00b008b17de9b38cmr32962382ejb.52.1678737281797;
        Mon, 13 Mar 2023 12:54:41 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id mh19-20020a170906eb9300b009200601ea12sm161969ejb.208.2023.03.13.12.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 12:54:41 -0700 (PDT)
Date:   Mon, 13 Mar 2023 21:54:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: dsa: mv88e6xxx: move call to
 mv88e6xxx_mdios_register()
Message-ID: <20230313195439.7yiwktvrgmcepv4n@skbuf>
References: <20230311203132.156467-1-klaus.kudielka@gmail.com>
 <20230311203132.156467-3-klaus.kudielka@gmail.com>
 <20230311224951.kqcihlralwehfvaj@skbuf>
 <98315424312f6f6abca771d27a78b2e41dcb6d6a.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98315424312f6f6abca771d27a78b2e41dcb6d6a.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 11:15:15AM +0100, Klaus Kudielka wrote:
> Just trying to reproduce this on the Omnia (with the whole series applied, plus some
> *** debug *** messages concerning timing). But all seems to be good here:

Thanks for testing.

So yeah, as I was saying, on Turris MOX with 3 DSA switches, your patch
set does not work as intended. We also need the patch below (placed as
patch 1/4) in order for that configuration to have internal PHY
interrupts after the driver unbind/bind procedure is applied to one of
the switches.

From my perspective you can pick up this patch, apply your sign off to
it, and send v3 right away.


From 46512c8033c931bc0e416cec7a14c310aac56a57 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 13 Mar 2023 21:24:08 +0200
Subject: [PATCH] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ mappings
 from mdiobus code

irq_find_mapping() does not need irq_dispose_mapping(), only
irq_create_mapping() does.

Calling irq_dispose_mapping() from mv88e6xxx_g2_irq_mdio_free() and from
the error path of mv88e6xxx_g2_irq_mdio_setup() effectively means that
the mdiobus logic (for internal PHY interrupts) is disposing of a
hwirq->virq mapping which it is not responsible of (but instead, the
function pair mv88e6xxx_g2_irq_setup() + mv88e6xxx_g2_irq_free() is).

With the current code structure, this isn't such a huge problem, because
mv88e6xxx_g2_irq_mdio_free() is called relatively close to the real
owner of the IRQ mappings:

mv88e6xxx_remove()
-> mv88e6xxx_unregister_switch()
-> mv88e6xxx_mdios_unregister()
   -> mv88e6xxx_g2_irq_mdio_free()
-> mv88e6xxx_g2_irq_free()

and the switch isn't 'live' in any way such that it would be able of
generating interrupts at this point (mv88e6xxx_unregister_switch() has
been called).

However, there is a desire to split mv88e6xxx_mdios_unregister() and
mv88e6xxx_g2_irq_free() such that mv88e6xxx_mdios_unregister() only gets
called from mv88e6xxx_teardown(). This is much more problematic, as can
be seen below.

In a cross-chip scenario (say 3 switches d0032004.mdio-mii:10,
d0032004.mdio-mii:11 and d0032004.mdio-mii:12 which form a single DSA
tree), it is possible to unbind the device driver from a single switch
(say d0032004.mdio-mii:10).

When that happens, mv88e6xxx_remove() will be called for just that one
switch, and this will call mv88e6xxx_unregister_switch() which will tear
down the entire tree (calling mv88e6xxx_teardown() for all 3 switches).

Assuming mv88e6xxx_mdios_unregister() was moved to mv88e6xxx_teardown(),
at this stage, all 3 switches will have called irq_dispose_mapping() on
their mdiobus virqs.

When we bind again the device driver to d0032004.mdio-mii:10,
mv88e6xxx_probe() is called for it, which calls dsa_register_switch().
The DSA tree is now complete again, and mv88e6xxx_setup() is called for
all 3 switches.

Also assuming that mv88e6xxx_mdios_register() is moved to
mv88e6xxx_setup() (the 2 assumptions go together), at this point,
d0032004.mdio-mii:11 and d0032004.mdio-mii:12 don't have an IRQ mapping
for the internal PHYs anymore, as they've disposed of it in
mv88e6xxx_teardown(). Whereas switch d0032004.mdio-mii:10 has re-created
it, because its code path comes from mv88e6xxx_probe().

Simply put, this change prepares the driver to handle the movement of
mv88e6xxx_mdios_register() to mv88e6xxx_setup() for cross-chip DSA trees.

Also, the code being deleted was partially wrong anyway (in a way which
may have hidden this other issue). mv88e6xxx_g2_irq_mdio_setup()
populates bus->irq[] starting with offset chip->info->phy_base_addr, but
the teardown path doesn't apply that offset too. So it disposes of virq
0 for phy = [ 0, phy_base_addr ).

All switch families have phy_base_addr = 0, except for MV88E6141 and
MV88E6341 which have it as 0x10. I guess those families would have
happened to work by mistake in cross-chip scenarios too.

I'm deleting the body of mv88e6xxx_g2_irq_mdio_free() but leaving its
call sites and prototype in place. This is because, if we ever need to
add back some teardown procedure in the future, it will be perhaps
error-prone to deduce the proper call sites again. Whereas like this,
no extra code should get generated, it shouldn't bother anybody.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/global2.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index ed3b2f88e783..a26546d3d7b5 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -1176,31 +1176,19 @@ int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
 int mv88e6xxx_g2_irq_mdio_setup(struct mv88e6xxx_chip *chip,
 				struct mii_bus *bus)
 {
-	int phy, irq, err, err_phy;
+	int phy, irq;
 
 	for (phy = 0; phy < chip->info->num_internal_phys; phy++) {
 		irq = irq_find_mapping(chip->g2_irq.domain, phy);
-		if (irq < 0) {
-			err = irq;
-			goto out;
-		}
+		if (irq < 0)
+			return irq;
+
 		bus->irq[chip->info->phy_base_addr + phy] = irq;
 	}
 	return 0;
-out:
-	err_phy = phy;
-
-	for (phy = 0; phy < err_phy; phy++)
-		irq_dispose_mapping(bus->irq[phy]);
-
-	return err;
 }
 
 void mv88e6xxx_g2_irq_mdio_free(struct mv88e6xxx_chip *chip,
 				struct mii_bus *bus)
 {
-	int phy;
-
-	for (phy = 0; phy < chip->info->num_internal_phys; phy++)
-		irq_dispose_mapping(bus->irq[phy]);
 }
-- 
2.34.1

