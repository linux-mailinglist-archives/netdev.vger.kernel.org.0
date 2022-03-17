Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A964DBFA7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiCQGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiCQGwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:52:01 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598ABABF49
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:45 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id bn33so6009411ljb.6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BhW5SBNBTPctrelIzld1iwNsFgR0rLG9u9qtdpPA1+I=;
        b=FpZ6XcG09qFtWy5BzGJky+7dKtAoomHFiOgkSFCqMKisiNz/8MMb9tiyLrjNXFRgeC
         KJ569QKgC9TaqYZ8txeBqBZ+9cVAfp3KjeJaOBO2jAt891s6avwE54IKtDjYMP8UPV/C
         iB8qp9O/cD0orC2LgO9NgzkI58RmpuGgZA3oOFKel3DKfKMnjouqErt6w/CZTgX0M2x5
         1zDpGn/115jgMHWqOZ8RD0q4mj9xwPbzyzjAGucYHeM0XsABDDOktg1LJId1pNWeW1pT
         mxp2pFZLPmLoaJfnCbs41JJ8TTPR4EJbfMLlNn9jDUxpKIzjxZPdcOCsZwE/B6uL1KMF
         zLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BhW5SBNBTPctrelIzld1iwNsFgR0rLG9u9qtdpPA1+I=;
        b=LWuGYyEttTmQ3te5UgQsqzg8oE7DBlLratxtsPkSeje7/YD32fhxHZxhHIQD2Iq/2L
         UTTUs0XRfQZLot7RGCVTAIBZs8sdWtWmzCDvmqz8H+Rf4xtpXz/m8rTMl1xvmGVa64Ga
         KBEfrpmBj8b4QtbT8Ms8IfEpXoLuaVWyiUeVRGR43UzynXcEBZW4i1UNbfTNfUobjptA
         q8inTFCYDsmxYWL2DjPNhOAtKWh0FRnF3jNSpBb/yp4UiVBgQP1wUzpH5d49TmqC6f0H
         UjFfI5jpE3c5DzCi2axYPXZbpY//OfQk41HUptAX4xQPBOJ/g2GGhEyO035O/Uh9M0i/
         SO/g==
X-Gm-Message-State: AOAM533sy5JO6oBVBxxHoMQern6ry0Que5nOfCBXBeqt+byyzQIAhCOg
        LRikTLqdAv6/E3cDSIJ855/sNkBcHsahwRe2
X-Google-Smtp-Source: ABdhPJwFmI0org6dsLCB3WhSk3/Vq7cmvBrhgwFseN5U0rS8eZol2Giu9ick8e5AZ9TLa/iy1bh6Yw==
X-Received: by 2002:a05:651c:1541:b0:248:de2a:862d with SMTP id y1-20020a05651c154100b00248de2a862dmr2132848ljp.10.1647499843468;
        Wed, 16 Mar 2022 23:50:43 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l25-20020ac25559000000b0044825a2539csm362215lfk.59.2022.03.16.23.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 23:50:42 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH 4/5] mv88e6xxx: Offload the flood flag
Date:   Thu, 17 Mar 2022 07:50:30 +0100
Message-Id: <20220317065031.3830481-5-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the port vlan table to restrict ingressing traffic to the
CPU port if the flood flags are cleared.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 45 ++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 84b90fc36c58..39347a05c3a5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1384,6 +1384,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp, *other_dp;
+	bool flood = true;
 	bool found = false;
 	u16 pvlan;
 
@@ -1425,6 +1426,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 
 	pvlan = 0;
 
+	if (dp->bridge)
+		flood = br_flood_enabled(dp->bridge->dev);
+
 	/* Frames from standalone user ports can only egress on the
 	 * upstream port.
 	 */
@@ -1433,10 +1437,11 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 
 	/* Frames from bridged user ports can egress any local DSA
 	 * links and CPU ports, as well as any local member of their
-	 * bridge group.
+	 * as well as any local member of their bridge group. However, CPU ports
+	 * are omitted if flood is cleared.
 	 */
 	dsa_switch_for_each_port(other_dp, ds)
-		if (other_dp->type == DSA_PORT_TYPE_CPU ||
+		if ((other_dp->type == DSA_PORT_TYPE_CPU && flood) ||
 		    other_dp->type == DSA_PORT_TYPE_DSA ||
 		    dsa_port_bridge_same(dp, other_dp))
 			pvlan |= BIT(other_dp->index);
@@ -2718,6 +2723,41 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 	mv88e6xxx_reg_unlock(chip);
 }
 
+static int mv88e6xxx_set_flood(struct dsa_switch *ds, int port, struct net_device *br,
+			       unsigned long mask, unsigned long val)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct dsa_bridge *bridge;
+	struct dsa_port *dp;
+	bool found = false;
+	int err;
+
+	if (!netif_is_bridge_master(br))
+		return 0;
+
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if (dp->ds == ds && dp->index == port) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return 0;
+
+	bridge = dp->bridge;
+	if (!bridge)
+		return 0;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_bridge_map(chip, *bridge);
+
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
 static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
 {
 	if (chip->info->ops->reset)
@@ -6478,6 +6518,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.set_eeprom		= mv88e6xxx_set_eeprom,
 	.get_regs_len		= mv88e6xxx_get_regs_len,
 	.get_regs		= mv88e6xxx_get_regs,
+	.set_flood		= mv88e6xxx_set_flood,
 	.get_rxnfc		= mv88e6xxx_get_rxnfc,
 	.set_rxnfc		= mv88e6xxx_set_rxnfc,
 	.set_ageing_time	= mv88e6xxx_set_ageing_time,
-- 
2.25.1

