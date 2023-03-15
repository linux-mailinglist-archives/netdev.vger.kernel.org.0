Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5646BBA0A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjCOQl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjCOQlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:41:06 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF1E93;
        Wed, 15 Mar 2023 09:39:57 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so1688800wmq.1;
        Wed, 15 Mar 2023 09:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678898352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHCDDp3f7xSAExOpOr3eGZoTj0+tT1KskMeeSxr/wG0=;
        b=OqA3g4npinc8sGg+XBVsLBNx6JmNECKM49/UaeGlgugzCTiobtxtNY9tXsV4N0ANYB
         Bw5MqBLjrxNbiEjeRGYZs1GeIZIenfQo2xeif3s5wa3UXRoYqZbwp76QpKHCuqkg4lUp
         xv9xfDM5zdm1tQxPXmZqb6plDyZId5qljZz7RjrF8uktVc0wq2JTd6X9TZZ5pBYhRcvw
         6RV5QJy7++Q9+TJbU8Q+YNjAfUN4U+rJsKa34peRxkwaeQ1Cn3YOAeS9IjQS64K8LBxp
         3fIsywIB2tMvvA1K6AVI/nMznVsMTXRE4WFuTQd9+uS1s7WdPtr0NySLcUjYAjDj6x8k
         ZtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678898352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHCDDp3f7xSAExOpOr3eGZoTj0+tT1KskMeeSxr/wG0=;
        b=g3K+r4HV9Bl1GT6WMGFSvQAy+mHbJbG6l8uc+Mf0sKELkzYJtRwRiodbha464ce764
         3ptv+sUVHeLlDnHu1HfJV3eY8tPlVIbQNUftN+mm/ffNFd3z0ai8b8qophgf+B2a8Qe2
         /GXhzohMy8BKA5FhrZuj01syfZiyea2V3SZ3uJILs7cnP6LK0PmC174AtIIWF8g80wBS
         A7HjhI+jUC4T9aHANoJcmVQyXjU63svmvU0kbMuIZjO0qj2PuthnOnQg74Q8cyT+qc0r
         tJeD+nrPiQqUyP+U/QtUuc/7BUcsw1Xz/zjZeLK5/ulZgfsJ9EIulqcADjLGaA7I4sCu
         a3HA==
X-Gm-Message-State: AO0yUKV+IhqP5zAc2AcIRxMrf6fZtwRdiMGU7tl4qosnga6zSLFf5waP
        c+hkFOQgrX1OjnW8jMN8uzE=
X-Google-Smtp-Source: AK7set9Sl+5YnFS2lv4mGXN6tlvlzFeOo4NC6jnfRKgkGkeKBL3PQHiQO+RuHlUlS9Id0WrNOXpuTg==
X-Received: by 2002:a05:600c:45c6:b0:3eb:2e27:2d0c with SMTP id s6-20020a05600c45c600b003eb2e272d0cmr16252830wmo.1.1678898352158;
        Wed, 15 Mar 2023 09:39:12 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:839a:f879:3eb0:8b4e])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d4d11000000b002c5a1bd527dsm5039595wrt.96.2023.03.15.09.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 09:39:12 -0700 (PDT)
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
Subject: [PATCH net-next v4 1/4] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ mappings from mdiobus code
Date:   Wed, 15 Mar 2023 17:38:43 +0100
Message-Id: <20230315163846.3114-2-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315163846.3114-1-klaus.kudielka@gmail.com>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
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

Notes:
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

