Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5373E4C8BA5
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiCAMcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiCAMcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:32:00 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E3F9287F
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 04:31:19 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id l12so9783880ljh.12
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 04:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OAX0hXOgh+IkX9h/muRq+NDc2OAWMYC8P5Twh1jkg9k=;
        b=QWyNpNd70xIdIlW40+gZMFtu1/i0GFifmjeaqGBDBJG3YK8972gIJxFI3FdZNiPBVp
         CmebE+Kzq/yK82TkqvI6Ieg+a9t7phqpQN9UWt4WOmWHkWOKUpo+1xdnyHewAEnw4LYB
         KwGd9x1UtvWqZo2WTY6GDFdpvjiVNTTLN2IpdRo2HEcOMzkd0qhdXrmcENRysyxSf+ND
         7IHdWD8JJTZvI4/23TqIbnfmQoB0FSQ9GEONXrjCnUUHTUykFyAMGyDcttmF9CUlzlV/
         J1t6Vz+42s3Gbj2aLTNhRvcAPuWPskgY9fMG5Sf0rKDRShn3Slnk7vcxc6N6F17aO6uW
         AjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OAX0hXOgh+IkX9h/muRq+NDc2OAWMYC8P5Twh1jkg9k=;
        b=r/Yqb9kAQyGqJwGBB7uuWxslHEomO1xNh0YZ3yrodIVkEQfSagRnM71uv4/kYgxQDn
         ckWmPaOXsnTIGaKAjkDGHL0/eE8US6FcKwq8lfj+WGMn1jexPO5qbInVQOd2sA8uBh/N
         KHhcYH4c33Hyfwb77hL987hc6f8SDiAN87uRrmYc4M9zFTRDA0MyB7rfDymyMb1thJfc
         l3SydgoyuKc5H7fL48X7KIAUeetMIKITBgtA7LQ61L9wieJ/oVXigThZFjlkiwOjBO3r
         xEkAiQgsfvX/g0IaG7DdGJTCmIkuanz0o5yxHjRHu/S3lKvtK3x2GQhlmhf0ktGMTgUR
         9vcQ==
X-Gm-Message-State: AOAM532NyuOxoK8YvUQpt5uc/JT6jg1hJFmUkV+WGSIVmPGU4ABeKxal
        1Yfq+rL8X7U3Fnn+1eVXQATJTb1avjaivWcgPXc=
X-Google-Smtp-Source: ABdhPJxeLGBQ9i7EQgrAFPulDsqCMeYEI5b8OM+MdNI5TA2FnCDONA4+nETEBm4RMY4X/83hwXI2ig==
X-Received: by 2002:a2e:8890:0:b0:23d:1f76:aa with SMTP id k16-20020a2e8890000000b0023d1f7600aamr16900300lji.222.1646137878066;
        Tue, 01 Mar 2022 04:31:18 -0800 (PST)
Received: from wse-c0089.westermo.com (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id i8-20020a0565123e0800b0044312b4112dsm1470459lfv.52.2022.03.01.04.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:31:17 -0800 (PST)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
X-Google-Original-From: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: [PATCH 3/3] mv88e6xxx: Offload the local_receive flag
Date:   Tue,  1 Mar 2022 13:31:04 +0100
Message-Id: <20220301123104.226731-4-mattias.forsblad+netdev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
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
CPU port if the local_receive flag is cleared.

Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 45 ++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 84b90fc36c58..d5616c7ca46e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1384,6 +1384,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp, *other_dp;
+	int local_receive = 1;
 	bool found = false;
 	u16 pvlan;
 
@@ -1425,6 +1426,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 
 	pvlan = 0;
 
+	if (dp->bridge)
+		local_receive = br_local_receive_enabled(dp->bridge->dev);
+
 	/* Frames from standalone user ports can only egress on the
 	 * upstream port.
 	 */
@@ -1433,10 +1437,11 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 
 	/* Frames from bridged user ports can egress any local DSA
 	 * links and CPU ports, as well as any local member of their
-	 * bridge group.
+	 * as well as any local member of their bridge group. However, CPU ports
+	 * are omitted if local_receive is reset.
 	 */
 	dsa_switch_for_each_port(other_dp, ds)
-		if (other_dp->type == DSA_PORT_TYPE_CPU ||
+		if ((other_dp->type == DSA_PORT_TYPE_CPU && local_receive) ||
 		    other_dp->type == DSA_PORT_TYPE_DSA ||
 		    dsa_port_bridge_same(dp, other_dp))
 			pvlan |= BIT(other_dp->index);
@@ -2718,6 +2723,41 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 	mv88e6xxx_reg_unlock(chip);
 }
 
+static int mv88e6xxx_set_local_receive(struct dsa_switch *ds, int port, struct net_device *br,
+				       bool enable)
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
+	.set_local_receive      = mv88e6xxx_set_local_receive,
 	.get_rxnfc		= mv88e6xxx_get_rxnfc,
 	.set_rxnfc		= mv88e6xxx_set_rxnfc,
 	.set_ageing_time	= mv88e6xxx_set_ageing_time,
-- 
2.25.1

