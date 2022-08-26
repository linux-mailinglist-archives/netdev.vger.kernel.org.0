Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B081E5A20F4
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbiHZGih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244886AbiHZGi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:38:28 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10E0D11ED
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:38:26 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id s6so763609lfo.11
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=RxV0nDEAfKqC3x7raaUN+mLOW4U9IZpu1YewQ98T9Tc=;
        b=VcB0NLRAu5ws5MmPcc12ZQk36km0fAThnCwtcwX+pS+vqTVPNxkZj0M9x0uN4wmOF9
         5SgU4NxDZoIqtoMX1oEOhTPNkqwWy4UCcq/Isc04W4JkykjqHKVAPYCpBHWsPtLzA794
         3e1JEympoDzruDucdoF8Hf9Ydj5JQZ35+MX2F4IX8rq0Vc7fICARcxgbM6/N1Z05oqaK
         UCGfwtJDUb7V9cIxPXHHbz7sEKb7tbdmHZFucpzEduZjPUdBXjMbmNE8FKeBRGfpNaK5
         7Rzh2x2fXpo4dZ9T4FFeO/kH5SowXmEWQ3mk6xNMkKR58u/2XB7GUXgi3+6cev+AQPi8
         QI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=RxV0nDEAfKqC3x7raaUN+mLOW4U9IZpu1YewQ98T9Tc=;
        b=17yDHRVZdhBYPURM17fVWngoRJj3ZuU9LnSnPND7KMsHNpv5tRm/hzlBjCzkkWxqbC
         uUDQYNrq8XEohkho55OtBsiwaF4LD8UGnv5iTZ6Qo9liXLPDZgDJIhok08U3yr7HIixG
         JKMO3qHIT9W8iUMQuoJW5FC7qKJgQ9eInw8h6LukLDaTdNBTSNSUOpwtm0OclpJDU5Kt
         6N1mQZh4WWNwLKhySDJtk1wUkCWZJwOR2lL6rVJsf79ZTo5wfy4aAz3pLs7Q6CcQMki+
         8nSkFOWbNIBxqSUnLhy3RxiiIAKtAI1zwdqNSrY6gT8lMRz+6+V8xft5lwJ2G+uRmC0Z
         GSoA==
X-Gm-Message-State: ACgBeo3+Rndrrf2i1UaN0iR7iy1rJCa9OoWcYN+E1n4WZJ5iNRyN0gEl
        WNy/X0DbBzBpm6hC19o3mi1ojwfy7+BfWwLmBSE=
X-Google-Smtp-Source: AA6agR7uB2DPZ5GDLKWUhAdSS6HCMnOPEEu10JQs/nV1KkpZKW3rwPzmXMMef5eYJ40I+couD7pE3Q==
X-Received: by 2002:a05:6512:39c2:b0:492:d15f:d246 with SMTP id k2-20020a05651239c200b00492d15fd246mr2311656lfu.517.1661495905025;
        Thu, 25 Aug 2022 23:38:25 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id p6-20020a05651238c600b0048cc076a03dsm253161lft.237.2022.08.25.23.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 23:38:24 -0700 (PDT)
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
Subject: [PATCH net-next v2 3/3] rmon: Use RMU if available
Date:   Fri, 26 Aug 2022 08:38:16 +0200
Message-Id: <20220826063816.948397-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220826063816.948397-1-mattias.forsblad@gmail.com>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
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

If RMU is supported, use that interface to
collect rmon data.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4c0510abd875..0d0241ace708 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1226,16 +1226,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
 				     u16 bank1_select, u16 histogram)
 {
 	struct mv88e6xxx_hw_stat *stat;
+	int offset = 0;
+	u64 high;
 	int i, j;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
 		stat = &mv88e6xxx_hw_stats[i];
 		if (stat->type & types) {
-			mv88e6xxx_reg_lock(chip);
-			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
-							      bank1_select,
-							      histogram);
-			mv88e6xxx_reg_unlock(chip);
+			if (chip->rmu.ops && chip->rmu.ops->get_rmon &&
+			    !(stat->type & STATS_TYPE_PORT)) {
+				if (stat->type & STATS_TYPE_BANK1)
+					offset = 32;
+
+				data[j] = chip->ports[port].rmu_raw_stats[stat->reg + offset];
+				if (stat->size == 8) {
+					high = chip->ports[port].rmu_raw_stats[stat->reg + offset
+							+ 1];
+					data[j] += (high << 32);
+				}
+			} else {
+				mv88e6xxx_reg_lock(chip);
+				data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
+								      bank1_select, histogram);
+				mv88e6xxx_reg_unlock(chip);
+			}
 
 			j++;
 		}
@@ -1304,8 +1318,8 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
-					uint64_t *data)
+static void mv88e6xxx_get_ethtool_stats_mdio(struct dsa_switch *ds, int port,
+					     uint64_t *data)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret;
@@ -1319,7 +1333,20 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_get_stats(chip, port, data);
+}
 
+static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	/* If initialization of RMU isn't available
+	 * fall back to MDIO access.
+	 */
+	if (chip->rmu.ops && chip->rmu.ops->get_rmon)
+		chip->rmu.ops->get_rmon(chip, port, data);
+	else
+		mv88e6xxx_get_ethtool_stats_mdio(ds, port, data);
 }
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
-- 
2.25.1

