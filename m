Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EFE4DB4EC
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiCPPcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350654AbiCPPcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:32:39 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C386CA73
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:31:23 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w7so4359287lfd.6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WZYQAsSvahIFcNUXr8FqEhHgPkYsNvYPksAc//voMGg=;
        b=q18e4QvGDkHF/1fdSZDP5UiJx5pYie0Za9ek4OhAFEG9/hcd2K0qiy74Lh3i6IITKK
         DBPCbfAnUeBH2Pc0qv7tUHKnATP/qxxEdBYy3C/IUD0YjzJPpt4LKxeYMImP3UErP+Al
         qB1KVeds9sTFiGhJ03bGA9uleSJQefSwDg+qmaVPNfBMLp0dCsfhAeu8BMEI2pknspDC
         sOBUOfAlqNfWhdkseREk2nXlwjA3sixyFt1SnaEU1IMggrhamCHifrWx8UVNjxbRc7Bj
         FsZz8PGpNKySbUA2YvmjXpdZ21xu8YSi5g9EZ+umsBmzarsB/DkIupfSJHW52fUgiM41
         kgWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WZYQAsSvahIFcNUXr8FqEhHgPkYsNvYPksAc//voMGg=;
        b=kCLSWbHCcA9FLZVgOeGI5LtzWEkFTxWkG6sb/UsnKrMGCRB9lce6whvCh07CIfFSHa
         uAp8QvGjAQUXlPhm6x5qFikYSSyw8f7ixbYjqS7wA6Mh9bgPq3l7VopJLdOwUoGLPZD6
         PiQ7AOitFzw9azyUFtIeELN3/3qz2hhd0Uu7MKGvjyrAKqh9sVsceigD/owmsQAFUBNb
         hEI8VcnuhDMJQAmqr0GEIS0W8KDy+If1n85CqIIdfVDjxFT0LOrqXoaDROw7MX37rxun
         8T1UrXdMzbFy1/WrSVk9pKIsCtkSOw5yise9nyVAei8CGAuqdJarbeNMFlZGgRm6lxBF
         utGg==
X-Gm-Message-State: AOAM533OkbAoGBiV9nMwh9toLUJhZ7C17UfXAMFrKJIOUG0OQ2bjGohU
        jhdW/30zAnU2SZQX+a3CtcCU0NJa3uegp1UN
X-Google-Smtp-Source: ABdhPJzhX6yhf7z0M05ajzpIT+xJ9WVp9xNFNvw9lj2Fibsx9KW7Gb2NWwLUV7lEJAIPeocH8CyUrw==
X-Received: by 2002:a19:6a0e:0:b0:443:3b15:4345 with SMTP id u14-20020a196a0e000000b004433b154345mr144313lfu.388.1647444680898;
        Wed, 16 Mar 2022 08:31:20 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id bu9-20020a056512168900b004489c47d241sm205870lfb.32.2022.03.16.08.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:31:19 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
X-Google-Original-From: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: [PATCH v2 net-next 4/5] mv88e6xxx: Offload the flood flag
Date:   Wed, 16 Mar 2022 16:30:58 +0100
Message-Id: <20220316153059.2503153-5-mattias.forsblad+netdev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316153059.2503153-1-mattias.forsblad+netdev@gmail.com>
References: <20220316153059.2503153-1-mattias.forsblad+netdev@gmail.com>
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

Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
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

