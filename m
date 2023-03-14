Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD96C6B9E53
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCNS2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjCNS2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:28:30 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C1F974B2;
        Tue, 14 Mar 2023 11:27:59 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k25-20020a7bc419000000b003ed23114fa7so5125478wmi.4;
        Tue, 14 Mar 2023 11:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678818478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpdp6mwTYG7IePlpnlQJFBmoOMjhOjLp24K1zGTlFNU=;
        b=PUyr3fxaz+N2AaTQqZJwFy0FE7SsS3jZslC3BdyWDqeErYGkt/MwJmIdPGcLRrOG7I
         gMorSoOmo9InY4V5wlN+zdNKZeRNRtoRee05cjXae+IIwUQ+0hfdp8bdX8QkaA4RHmAm
         UjU9sZL36pz0DkkiFGGd4DsYPH749C26gNoUjr5SXjuOXbkTIlgkw6WX+HAyWNwLGkHZ
         VDQPX7o8fL0clrI+meexl5Ly82Gjdu6xIBMI3HBxWW2+AJzrlq7rSdUMQpEizOXmMk0W
         DOyrRJeslVYRyOCOX9CLD3CAXU4IovjHkt7p+14nkuSttZkVKAkc58YsvMRaQyrOrTwx
         FfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678818478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cpdp6mwTYG7IePlpnlQJFBmoOMjhOjLp24K1zGTlFNU=;
        b=a/butNyufmCOZs9AW1iCCWAsMFwcacrOFscxqdj2OW2nbPp9iF+j7fGitxLHLb9Jdv
         mnhdg0dnQMD6Qh/6eqwA3TVwDopLZFaHy5sf0WTRmTmtYoEvlBIZuvZa72iwEdSPeHOY
         74ijwxlCir5Agi0JZ0laH+4bp01QALG6c8Q/F9uclQuoO9pDdfZOg6BVrNhDr/LbeCLs
         eDftRaCvHq4YoTq8Et+l4mG1D4mOFROVZ3TUOJZubYZV6i/JesoorRuGt5iZHjc2iLE0
         vxobRbLsCNbA3xiy0X8lHLr9huGRQWDlE+RQAwzdUvyX2YYDIzigssPYgRPN/zXyplxn
         p0sg==
X-Gm-Message-State: AO0yUKVKrmpTMgmnywnNoZd82x+Dk0UtQ/4Dj/kxOYC5OMNJ0Falk7VA
        uHFYfS0jRM2fbPP0Blrm3Nw=
X-Google-Smtp-Source: AK7set/jTU7svTZhwhdiK+tgNSXGJxZjnnVjtXqRDa48RGioubUkxtWbU9aRxu1dOgylpE+qTFxI5A==
X-Received: by 2002:a05:600c:1c17:b0:3ed:2f7b:daf with SMTP id j23-20020a05600c1c1700b003ed2f7b0dafmr1431749wms.10.1678818477625;
        Tue, 14 Mar 2023 11:27:57 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:5862:40de:7045:5e1b])
        by smtp.gmail.com with ESMTPSA id u7-20020a7bc047000000b003e206cc7237sm3443490wmc.24.2023.03.14.11.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 11:27:57 -0700 (PDT)
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Klaus Kudielka <klaus.kudielka@gmail.com>
Subject: [PATCH] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ mappings from mdiobus code
Date:   Tue, 14 Mar 2023 19:26:56 +0100
Message-Id: <20230314182659.63686-2-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314182659.63686-1-klaus.kudielka@gmail.com>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
---
v3: Patch is new

 drivers/net/dsa/mv88e6xxx/global2.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index ed3b2f88e7..a26546d3d7 100644
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
2.39.2

