Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF96A5B1C02
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiIHL6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiIHL6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:58:46 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8203611C7EC
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:58:45 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u18so15021747lfo.8
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 04:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=JgN2FF1Ci4Ij0PM8WpmHKSnHghjpw3iCMjtlqpJR2Ug=;
        b=OxViWfnMVJM3CzYCrwUDSkiDqujrPd7q/czmVxfp1iRj+AdQK8b54CfnhMzXDpMGzU
         +Rr319gRv2wGSkBRM3Et8Jh757EbjH6y1FtiaAsn8zM7c7RhSHE3agKiDsMvfTIkAWxr
         e5rQBVUFBcGAIjJKbgY8n57Y9B+HUe3TN+w6KKIvMRG/k0Szgpc47gXbx5/erGkcV62p
         Oyui6Xra7iNVtbN3qxcSc4+DYg4RVaHZ789b0MQLwWr3pjRRG3OFsHYOGIU/Z0bqyrrA
         zsEQ04D6tin/x+8myp0+Fqx45O4l5jhzr4B14lD+E7TyLkCEZCZy2voc05MFFGQu8Saw
         XQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=JgN2FF1Ci4Ij0PM8WpmHKSnHghjpw3iCMjtlqpJR2Ug=;
        b=vnFH+Ig25q8UFdRfLSm05tflEmuJspF2LMsXb9aX5tOsVwpYIg39jA+zo148rO2hk+
         75tqv2OhoeltpvYmUBs2e2lU7v/jtTuTPtLQjE7W2Pe/rzbyUH5xNcGeuTlue26PEfxO
         TjKC3ORMwdlmpM8AP6UmilvgL7Ue4g9AtI4vSQYKyKwNnsO+ZRsO+/P9J2lAeHQVvRMz
         x4DItYEYxpZ/TeGJuJ1K31RAXbns6lHDLuARMGSRguyGWC8Iy5WfNf9wTZjXLi3vt8Qt
         ft4CLgZQ+zREysz/pD41G0xaI+acOF46sgzihT3RNC7lLO9wd48j7Jx7wzUUy4IU2BTi
         XC/A==
X-Gm-Message-State: ACgBeo2MeCrHkzEpcA6VyiAEQf0bR9H/Fm6Ylu7a5iY4YUdTF1Kx2iX3
        nsTQADMCeD8Nr8pZNKrN+MNYFZc74QzOfIoK
X-Google-Smtp-Source: AA6agR57zL86pK9aGZESy5apG2Tl7Ob2IX+r9pXKDeci1kbxnBpcjaIJrkMDuMD1EA6TUXFsDax0ow==
X-Received: by 2002:a05:6512:22ce:b0:497:499e:c966 with SMTP id g14-20020a05651222ce00b00497499ec966mr2493177lfu.402.1662638323487;
        Thu, 08 Sep 2022 04:58:43 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id s10-20020a2e81ca000000b0026acfbbcb7esm833595ljg.12.2022.09.08.04.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 04:58:43 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v6 1/6] net: dsa: mv88e6xxx: Add RMU enable for select switches.
Date:   Thu,  8 Sep 2022 13:58:30 +0200
Message-Id: <20220908115835.3205487-2-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908115835.3205487-1-mattias.forsblad@gmail.com>
References: <20220908115835.3205487-1-mattias.forsblad@gmail.com>
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

Add RMU enable functionality for some Marvell SOHO switches.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  6 +++
 drivers/net/dsa/mv88e6xxx/chip.h    |  1 +
 drivers/net/dsa/mv88e6xxx/global1.c | 66 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  3 ++
 4 files changed, 76 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6f4ea39ab466..46e12b53a9e4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4098,6 +4098,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.ppu_disable = mv88e6185_g1_ppu_disable,
 	.reset = mv88e6185_g1_reset,
 	.rmu_disable = mv88e6085_g1_rmu_disable,
+	.rmu_enable = mv88e6085_g1_rmu_enable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
@@ -4181,6 +4182,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6085_g1_rmu_disable,
+	.rmu_enable = mv88e6085_g1_rmu_enable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6095_phylink_get_caps,
@@ -5300,6 +5302,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.rmu_enable = mv88e6352_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
@@ -5367,6 +5370,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
@@ -5434,6 +5438,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
@@ -5504,6 +5509,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..7ce3c41f6caf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -637,6 +637,7 @@ struct mv88e6xxx_ops {
 
 	/* Remote Management Unit operations */
 	int (*rmu_disable)(struct mv88e6xxx_chip *chip);
+	int (*rmu_enable)(struct mv88e6xxx_chip *chip, int port);
 
 	/* Precision Time Protocol operations */
 	const struct mv88e6xxx_ptp_ops *ptp_ops;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 5848112036b0..c5bb414f4291 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -466,18 +466,84 @@ int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 				      MV88E6085_G1_CTL2_RM_ENABLE, 0);
 }
 
+int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
+{
+	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
+
+	switch (upstream_port) {
+	case 9:
+		val = MV88E6085_G1_CTL2_RM_ENABLE;
+		break;
+	case 10:
+		val = MV88E6085_G1_CTL2_RM_ENABLE | MV88E6085_G1_CTL2_P10RM;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6085_G1_CTL2_P10RM |
+				      MV88E6085_G1_CTL2_RM_ENABLE, val);
+}
+
 int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
 				      MV88E6352_G1_CTL2_RMU_MODE_DISABLED);
 }
 
+int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
+{
+	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
+
+	switch (upstream_port) {
+	case 4:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_4;
+		break;
+	case 5:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_5;
+		break;
+	case 6:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_6;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
+			val);
+}
+
 int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK,
 				      MV88E6390_G1_CTL2_RMU_MODE_DISABLED);
 }
 
+int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
+{
+	int val = MV88E6390_G1_CTL2_RMU_MODE_DISABLED;
+
+	switch (upstream_port) {
+	case 0:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_0;
+		break;
+	case 1:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_1;
+		break;
+	case 9:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_9;
+		break;
+	case 10:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_10;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK,
+			val);
+}
+
 int mv88e6390_g1_stats_set_histogram(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_HIST_MODE_MASK,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 65958b2a0d3a..29c0c8acb583 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -313,8 +313,11 @@ int mv88e6250_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_set_cascade_port(struct mv88e6xxx_chip *chip, int port);
 
 int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port);
 int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port);
 int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port);
 
 int mv88e6xxx_g1_set_device_number(struct mv88e6xxx_chip *chip, int index);
 
-- 
2.25.1

