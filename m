Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985AD5B9D7A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 16:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiIOOjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 10:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiIOOio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 10:38:44 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6A79F759
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:37:13 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a2so6697286lfb.6
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=2k2YAuSCASBkcDuEfybUDrtg0/KrW+GCeb339u83RJk=;
        b=MRzYoLhI08v9nIRLfxNYD1kDHOKoIWMrcu7+YthGjpj4nn7fbiB5YwUU6ktESg6jVw
         0k+kZP7UospXF845bICdVO2kIyWXElS+lzXzDGgCFd6vPbFw/wsECzi3XFQZQ54rE+4G
         esyNuz8Tav+xuCzWdPj0VDk+VKZ/qDAUYIpNRZVfyCSaZuOvzwsfGrezIPdkUoZ4oG9M
         ffHJx1qBlISDF5t9PMhVQBZFVUDoSMVxGAyNhoakpdG1uhPlEiMt7kMf1WXJPU8FGUi0
         tFnck/ccYVPNhkeZp6l3hPF5KFFOUP/OkFcG1egq1w/04K/AQl1tAyLyj9ZGiXoPJKFS
         qz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2k2YAuSCASBkcDuEfybUDrtg0/KrW+GCeb339u83RJk=;
        b=vUCBRX5QX99nqXmUrfxPQgHuRVQzaDc91wt08MdmSkJtyseDlqMwukAyyAZRl/mEY7
         b1mERg3BD+hpz1prCyeVbUF3h4/Z7OVO/PERavFCU3RVvcatNTtyNKALZtbrwzNsXx0O
         k7yKeW9t7aXhXj7yz47IeU/7lSpaCWHzb9pln17+3VUMBmQM5EbINmQHOmywo90oubF4
         l7HCpkVd+YHtx7PIJoaLgmzK9uJ9tktEwuaRu4J2rRwCwuPe73BhHYln2LLCq4/qBKYE
         IE93oChMhkw/DJYiPBrdngKPaIwywCDMYm6DPvbPSmpLwbiSzlc88WmhdBJqkMZ2tyem
         sPmA==
X-Gm-Message-State: ACrzQf1fJnU02uVj72DnCX4mnOqEMsP52Y9tMLJRK4CwRapLnbpVUfVZ
        q39OxdnqYfsgTZB9mlNFz8hDBaQubrj2Kh22
X-Google-Smtp-Source: AMsMyM6ZeZg8QJQXSdNrf9/VCm6mGdTwWWRqU5hnyV1osnjIR+05b4b9DE3sgZ9LaEchKqPoWUcjgw==
X-Received: by 2002:a05:6512:158b:b0:499:f9b3:df87 with SMTP id bp11-20020a056512158b00b00499f9b3df87mr70275lfb.451.1663252629517;
        Thu, 15 Sep 2022 07:37:09 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id x15-20020ac259cf000000b004984ab5956dsm2995794lfn.202.2022.09.15.07.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 07:37:09 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com, Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v12 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
Date:   Thu, 15 Sep 2022 16:36:57 +0200
Message-Id: <20220915143658.3377139-6-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
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

Use the Remote Management Unit for efficiently accessing
the RMON data.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 180 ++++++++++++++++++++-----------
 drivers/net/dsa/mv88e6xxx/chip.h |   3 +
 drivers/net/dsa/mv88e6xxx/smi.c  |   3 +
 3 files changed, 121 insertions(+), 65 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 294bf9bbaf3f..cba4f6a49647 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -984,65 +984,65 @@ static int mv88e6xxx_stats_snapshot(struct mv88e6xxx_chip *chip, int port)
 }
 
 static struct mv88e6xxx_hw_stat mv88e6xxx_hw_stats[] = {
-	{ "in_good_octets",		8, 0x00, STATS_TYPE_BANK0, },
-	{ "in_bad_octets",		4, 0x02, STATS_TYPE_BANK0, },
-	{ "in_unicast",			4, 0x04, STATS_TYPE_BANK0, },
-	{ "in_broadcasts",		4, 0x06, STATS_TYPE_BANK0, },
-	{ "in_multicasts",		4, 0x07, STATS_TYPE_BANK0, },
-	{ "in_pause",			4, 0x16, STATS_TYPE_BANK0, },
-	{ "in_undersize",		4, 0x18, STATS_TYPE_BANK0, },
-	{ "in_fragments",		4, 0x19, STATS_TYPE_BANK0, },
-	{ "in_oversize",		4, 0x1a, STATS_TYPE_BANK0, },
-	{ "in_jabber",			4, 0x1b, STATS_TYPE_BANK0, },
-	{ "in_rx_error",		4, 0x1c, STATS_TYPE_BANK0, },
-	{ "in_fcs_error",		4, 0x1d, STATS_TYPE_BANK0, },
-	{ "out_octets",			8, 0x0e, STATS_TYPE_BANK0, },
-	{ "out_unicast",		4, 0x10, STATS_TYPE_BANK0, },
-	{ "out_broadcasts",		4, 0x13, STATS_TYPE_BANK0, },
-	{ "out_multicasts",		4, 0x12, STATS_TYPE_BANK0, },
-	{ "out_pause",			4, 0x15, STATS_TYPE_BANK0, },
-	{ "excessive",			4, 0x11, STATS_TYPE_BANK0, },
-	{ "collisions",			4, 0x1e, STATS_TYPE_BANK0, },
-	{ "deferred",			4, 0x05, STATS_TYPE_BANK0, },
-	{ "single",			4, 0x14, STATS_TYPE_BANK0, },
-	{ "multiple",			4, 0x17, STATS_TYPE_BANK0, },
-	{ "out_fcs_error",		4, 0x03, STATS_TYPE_BANK0, },
-	{ "late",			4, 0x1f, STATS_TYPE_BANK0, },
-	{ "hist_64bytes",		4, 0x08, STATS_TYPE_BANK0, },
-	{ "hist_65_127bytes",		4, 0x09, STATS_TYPE_BANK0, },
-	{ "hist_128_255bytes",		4, 0x0a, STATS_TYPE_BANK0, },
-	{ "hist_256_511bytes",		4, 0x0b, STATS_TYPE_BANK0, },
-	{ "hist_512_1023bytes",		4, 0x0c, STATS_TYPE_BANK0, },
-	{ "hist_1024_max_bytes",	4, 0x0d, STATS_TYPE_BANK0, },
-	{ "sw_in_discards",		4, 0x10, STATS_TYPE_PORT, },
-	{ "sw_in_filtered",		2, 0x12, STATS_TYPE_PORT, },
-	{ "sw_out_filtered",		2, 0x13, STATS_TYPE_PORT, },
-	{ "in_discards",		4, 0x00, STATS_TYPE_BANK1, },
-	{ "in_filtered",		4, 0x01, STATS_TYPE_BANK1, },
-	{ "in_accepted",		4, 0x02, STATS_TYPE_BANK1, },
-	{ "in_bad_accepted",		4, 0x03, STATS_TYPE_BANK1, },
-	{ "in_good_avb_class_a",	4, 0x04, STATS_TYPE_BANK1, },
-	{ "in_good_avb_class_b",	4, 0x05, STATS_TYPE_BANK1, },
-	{ "in_bad_avb_class_a",		4, 0x06, STATS_TYPE_BANK1, },
-	{ "in_bad_avb_class_b",		4, 0x07, STATS_TYPE_BANK1, },
-	{ "tcam_counter_0",		4, 0x08, STATS_TYPE_BANK1, },
-	{ "tcam_counter_1",		4, 0x09, STATS_TYPE_BANK1, },
-	{ "tcam_counter_2",		4, 0x0a, STATS_TYPE_BANK1, },
-	{ "tcam_counter_3",		4, 0x0b, STATS_TYPE_BANK1, },
-	{ "in_da_unknown",		4, 0x0e, STATS_TYPE_BANK1, },
-	{ "in_management",		4, 0x0f, STATS_TYPE_BANK1, },
-	{ "out_queue_0",		4, 0x10, STATS_TYPE_BANK1, },
-	{ "out_queue_1",		4, 0x11, STATS_TYPE_BANK1, },
-	{ "out_queue_2",		4, 0x12, STATS_TYPE_BANK1, },
-	{ "out_queue_3",		4, 0x13, STATS_TYPE_BANK1, },
-	{ "out_queue_4",		4, 0x14, STATS_TYPE_BANK1, },
-	{ "out_queue_5",		4, 0x15, STATS_TYPE_BANK1, },
-	{ "out_queue_6",		4, 0x16, STATS_TYPE_BANK1, },
-	{ "out_queue_7",		4, 0x17, STATS_TYPE_BANK1, },
-	{ "out_cut_through",		4, 0x18, STATS_TYPE_BANK1, },
-	{ "out_octets_a",		4, 0x1a, STATS_TYPE_BANK1, },
-	{ "out_octets_b",		4, 0x1b, STATS_TYPE_BANK1, },
-	{ "out_management",		4, 0x1f, STATS_TYPE_BANK1, },
+	{ "in_good_octets",		8, 0x00, 0x00, STATS_TYPE_BANK0, },
+	{ "in_bad_octets",		4, 0x02, 0x00, STATS_TYPE_BANK0, },
+	{ "in_unicast",			4, 0x04, 0x00, STATS_TYPE_BANK0, },
+	{ "in_broadcasts",		4, 0x06, 0x00, STATS_TYPE_BANK0, },
+	{ "in_multicasts",		4, 0x07, 0x00, STATS_TYPE_BANK0, },
+	{ "in_pause",			4, 0x16, 0x00, STATS_TYPE_BANK0, },
+	{ "in_undersize",		4, 0x18, 0x00, STATS_TYPE_BANK0, },
+	{ "in_fragments",		4, 0x19, 0x00, STATS_TYPE_BANK0, },
+	{ "in_oversize",		4, 0x1a, 0x00, STATS_TYPE_BANK0, },
+	{ "in_jabber",			4, 0x1b, 0x00, STATS_TYPE_BANK0, },
+	{ "in_rx_error",		4, 0x1c, 0x00, STATS_TYPE_BANK0, },
+	{ "in_fcs_error",		4, 0x1d, 0x00, STATS_TYPE_BANK0, },
+	{ "out_octets",			8, 0x0e, 0x00, STATS_TYPE_BANK0, },
+	{ "out_unicast",		4, 0x10, 0x00, STATS_TYPE_BANK0, },
+	{ "out_broadcasts",		4, 0x13, 0x00, STATS_TYPE_BANK0, },
+	{ "out_multicasts",		4, 0x12, 0x00, STATS_TYPE_BANK0, },
+	{ "out_pause",			4, 0x15, 0x00, STATS_TYPE_BANK0, },
+	{ "excessive",			4, 0x11, 0x00, STATS_TYPE_BANK0, },
+	{ "collisions",			4, 0x1e, 0x00, STATS_TYPE_BANK0, },
+	{ "deferred",			4, 0x05, 0x00, STATS_TYPE_BANK0, },
+	{ "single",			4, 0x14, 0x00, STATS_TYPE_BANK0, },
+	{ "multiple",			4, 0x17, 0x00, STATS_TYPE_BANK0, },
+	{ "out_fcs_error",		4, 0x03, 0x00, STATS_TYPE_BANK0, },
+	{ "late",			4, 0x1f, 0x00, STATS_TYPE_BANK0, },
+	{ "hist_64bytes",		4, 0x08, 0x00, STATS_TYPE_BANK0, },
+	{ "hist_65_127bytes",		4, 0x09, 0x00, STATS_TYPE_BANK0, },
+	{ "hist_128_255bytes",		4, 0x0a, 0x00, STATS_TYPE_BANK0, },
+	{ "hist_256_511bytes",		4, 0x0b, 0x00, STATS_TYPE_BANK0, },
+	{ "hist_512_1023bytes",		4, 0x0c, 0x00, STATS_TYPE_BANK0, },
+	{ "hist_1024_max_bytes",	4, 0x0d, 0x00, STATS_TYPE_BANK0, },
+	{ "sw_in_discards",		4, 0x10, 0x81, STATS_TYPE_PORT, },
+	{ "sw_in_filtered",		2, 0x12, 0x85, STATS_TYPE_PORT, },
+	{ "sw_out_filtered",		2, 0x13, 0x89, STATS_TYPE_PORT, },
+	{ "in_discards",		4, 0x00, 0x00, STATS_TYPE_BANK1, },
+	{ "in_filtered",		4, 0x01, 0x00, STATS_TYPE_BANK1, },
+	{ "in_accepted",		4, 0x02, 0x00, STATS_TYPE_BANK1, },
+	{ "in_bad_accepted",		4, 0x03, 0x00, STATS_TYPE_BANK1, },
+	{ "in_good_avb_class_a",	4, 0x04, 0x00, STATS_TYPE_BANK1, },
+	{ "in_good_avb_class_b",	4, 0x05, 0x00, STATS_TYPE_BANK1, },
+	{ "in_bad_avb_class_a",		4, 0x06, 0x00, STATS_TYPE_BANK1, },
+	{ "in_bad_avb_class_b",		4, 0x07, 0x00, STATS_TYPE_BANK1, },
+	{ "tcam_counter_0",		4, 0x08, 0x00, STATS_TYPE_BANK1, },
+	{ "tcam_counter_1",		4, 0x09, 0x00, STATS_TYPE_BANK1, },
+	{ "tcam_counter_2",		4, 0x0a, 0x00, STATS_TYPE_BANK1, },
+	{ "tcam_counter_3",		4, 0x0b, 0x00, STATS_TYPE_BANK1, },
+	{ "in_da_unknown",		4, 0x0e, 0x00, STATS_TYPE_BANK1, },
+	{ "in_management",		4, 0x0f, 0x00, STATS_TYPE_BANK1, },
+	{ "out_queue_0",		4, 0x10, 0x00, STATS_TYPE_BANK1, },
+	{ "out_queue_1",		4, 0x11, 0x00, STATS_TYPE_BANK1, },
+	{ "out_queue_2",		4, 0x12, 0x00, STATS_TYPE_BANK1, },
+	{ "out_queue_3",		4, 0x13, 0x00, STATS_TYPE_BANK1, },
+	{ "out_queue_4",		4, 0x14, 0x00, STATS_TYPE_BANK1, },
+	{ "out_queue_5",		4, 0x15, 0x00, STATS_TYPE_BANK1, },
+	{ "out_queue_6",		4, 0x16, 0x00, STATS_TYPE_BANK1, },
+	{ "out_queue_7",		4, 0x17, 0x00, STATS_TYPE_BANK1, },
+	{ "out_cut_through",		4, 0x18, 0x00, STATS_TYPE_BANK1, },
+	{ "out_octets_a",		4, 0x1a, 0x00, STATS_TYPE_BANK1, },
+	{ "out_octets_b",		4, 0x1b, 0x00, STATS_TYPE_BANK1, },
+	{ "out_management",		4, 0x1f, 0x00, STATS_TYPE_BANK1, },
 };
 
 static uint64_t _mv88e6xxx_get_ethtool_stat(struct mv88e6xxx_chip *chip,
@@ -1229,9 +1229,41 @@ static int mv88e6xxx_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return count;
 }
 
-static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
-				     uint64_t *data, int types,
-				     u16 bank1_select, u16 histogram)
+static int mv88e6xxx_state_get_stats_rmu(struct mv88e6xxx_chip *chip, int port,
+					 uint64_t *data, int types,
+					 u16 bank1_select, u16 histogram)
+{
+	const u64 *stats = chip->ports[port].rmu_raw_stats;
+	struct mv88e6xxx_hw_stat *stat;
+	int offset = 0;
+	u64 high;
+	int i, j;
+
+	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
+		stat = &mv88e6xxx_hw_stats[i];
+		if (stat->type & types) {
+			if (stat->type & STATS_TYPE_PORT) {
+				data[j] = stats[stat->rmu_reg];
+			} else {
+				if (stat->type & STATS_TYPE_BANK1)
+					offset = 32;
+
+				data[j] = stats[stat->reg + offset];
+				if (stat->size == 8) {
+					high = stats[stat->reg + offset + 1];
+					data[j] += (high << 32);
+				}
+			}
+
+			j++;
+		}
+	}
+	return j;
+}
+
+static int mv88e6xxx_stats_get_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+					  uint64_t *data, int types,
+					  u16 bank1_select, u16 histogram)
 {
 	struct mv88e6xxx_hw_stat *stat;
 	int i, j;
@@ -1251,6 +1283,18 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
 	return j;
 }
 
+static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
+				     uint64_t *data, int types,
+				     u16 bank1_select, u16 histogram)
+{
+	if (mv88e6xxx_rmu_available(chip))
+		return mv88e6xxx_state_get_stats_rmu(chip, port, data, types,
+						     bank1_select, histogram);
+	else
+		return mv88e6xxx_stats_get_stats_mdio(chip, port, data, types,
+						      bank1_select, histogram);
+}
+
 static int mv88e6095_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
 				     uint64_t *data)
 {
@@ -1312,10 +1356,9 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
-					uint64_t *data)
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret;
 
 	mv88e6xxx_reg_lock(chip);
@@ -1327,7 +1370,14 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_get_stats(chip, port, data);
+}
+
+static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
 
+	chip->smi_ops->get_rmon(chip, port, data);
 }
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index ea1789feeacf..ea86532f0bd9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -742,6 +742,7 @@ struct mv88e6xxx_hw_stat {
 	char string[ETH_GSTRING_LEN];
 	size_t size;
 	int reg;
+	int rmu_reg;
 	int type;
 };
 
@@ -809,6 +810,8 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
 		       int bit, int val);
 struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip);
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data);
 
 static inline void mv88e6xxx_reg_lock(struct mv88e6xxx_chip *chip)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index a990271b7482..ae805c449b85 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -83,6 +83,7 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_direct_ops = {
 	.read = mv88e6xxx_smi_direct_read,
 	.write = mv88e6xxx_smi_direct_write,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 static int mv88e6xxx_smi_dual_direct_read(struct mv88e6xxx_chip *chip,
@@ -100,6 +101,7 @@ static int mv88e6xxx_smi_dual_direct_write(struct mv88e6xxx_chip *chip,
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_dual_direct_ops = {
 	.read = mv88e6xxx_smi_dual_direct_read,
 	.write = mv88e6xxx_smi_dual_direct_write,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 /* Offset 0x00: SMI Command Register
@@ -166,6 +168,7 @@ static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_indirect_ops = {
 	.read = mv88e6xxx_smi_indirect_read,
 	.write = mv88e6xxx_smi_indirect_write,
 	.init = mv88e6xxx_smi_indirect_init,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
-- 
2.25.1

