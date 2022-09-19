Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6524A5BCA47
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiISLJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiISLI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:08:59 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4265795A3
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:08:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id i26so46325975lfp.11
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MiAiqg8kMnnPs+t9JdAwgbU7eMmuujYZlpVgCm5v3Xs=;
        b=N3x955CmOTaECh2nCFFSBxUF8BARAdJAj826m3n2PCM5iKVbK9DuC8MBcGiu0awxy3
         Zv4wC+yaiJdEPy1GBPHlVmNjZJJunz/Cq7jWjMhHDojBesQLxW4e8fZ0zrvQbndylj6B
         rdXJuDhx4wHny/+zQsrrhV0UGGLmWThYlx858rgG+wqC5DkcggQFWW2RO/tCY2L0Vb/y
         lmfGBsiwR1QuvIMRFGSDJRJ4M+u67x+/1iL+uFk/yXWiPexOOsnsypPYZPCpIF8dZy7c
         6Dgp/T0FiOtmD2Y8Ee4Gj0ifMspBHtY/Fg73Wq2z+DOZnHTZnlWwiXzDQzLn+bqHLGF9
         Itzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MiAiqg8kMnnPs+t9JdAwgbU7eMmuujYZlpVgCm5v3Xs=;
        b=5r0xOlN3q71gqJtatOcPh5eLhoaeVKi0KLZ7LowE/1O3XYvw3GVr9xssx7PkdUfDQL
         fS37UFSCssVcaVx6k2XYzGfdcIYhT9IoPMN3pPDFZTkD5zV3IMgJGv7HVdMqYkArbrKn
         dFeyx8q+Ra7mKuF4C63ZGdNETbMcxAoAf2JETAUXnJ6x9I406r2DrGYRBUQYGv5YKlOC
         GuMNeNTqsmcatUoTArysnV0xqsBf3tyT0jr+0XAv8uAMnursgqlWiA5AIgQqlMf/r5UZ
         ISHLx+mFJCluVEiBCKAUdi2QkVo2yEg8zZy/C+5yEHlqRn2UVbjsJYtSUjd6tT+qwTvL
         6drw==
X-Gm-Message-State: ACrzQf1MMDlTqhgJ0VrzzsLF4ohx6RdiJVKjxdnZ5odYLtoVBIhLDlAT
        njlJ/wX9PkgJVoWp3gBlDcYNTxYzzxwoRg==
X-Google-Smtp-Source: AMsMyM5GGEczc3W2cRbLeQcmrSAPo8tEOaKfG75qS+jV/nl2DGahORu0G5pouH6CzQamWLZn4JEviA==
X-Received: by 2002:a05:6512:3c88:b0:499:c78:5bb1 with SMTP id h8-20020a0565123c8800b004990c785bb1mr5857472lfv.503.1663585735294;
        Mon, 19 Sep 2022 04:08:55 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id t13-20020a05651c204d00b00266d3f689e1sm4879261ljo.43.2022.09.19.04.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 04:08:55 -0700 (PDT)
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
Subject: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add functionality to get RMON
Date:   Mon, 19 Sep 2022 13:08:45 +0200
Message-Id: <20220919110847.744712-6-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220919110847.744712-1-mattias.forsblad@gmail.com>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
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

It's possible to access the RMON counters via RMU.
Add functionality to send DUMP_MIB frames.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 74 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  6 +++
 drivers/net/dsa/mv88e6xxx/rmu.c  | 53 +++++++++++++++++++++++
 3 files changed, 133 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 294bf9bbaf3f..5b22fe4b3284 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1229,6 +1229,80 @@ static int mv88e6xxx_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return count;
 }
 
+int mv88e6xxx_stats_get_sset_count_rmu(struct dsa_switch *ds, int port, int sset)
+{
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	return ARRAY_SIZE(mv88e6xxx_hw_stats);
+}
+
+void mv88e6xxx_stats_get_strings_rmu(struct dsa_switch *ds, int port,
+				     u32 stringset, uint8_t *data)
+{
+	struct mv88e6xxx_hw_stat *stat;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
+		stat = &mv88e6xxx_hw_stats[i];
+		memcpy(data + i * ETH_GSTRING_LEN, stat->string, ETH_GSTRING_LEN);
+	}
+}
+
+int mv88e6xxx_state_get_stats_rmu(struct mv88e6xxx_chip *chip, int port,
+				  __be32 *raw_cnt, int num_cnt, uint64_t *data)
+{
+	struct mv88e6xxx_hw_stat *stat;
+	int offset = 0;
+	u64 high;
+	int i, j;
+
+	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
+		stat = &mv88e6xxx_hw_stats[i];
+		offset = stat->reg;
+
+		if (stat->type & STATS_TYPE_PORT) {
+			/* The offsets for the port counters below
+			 * are different in the RMU packet.
+			 */
+			switch (stat->reg) {
+			case 0x10: /* sw_in_discards */
+				offset = 0x81;
+				break;
+			case 0x12: /* sw_in_filtered */
+				offset = 0x85;
+				break;
+			case 0x13: /* sw_out_filtered */
+				offset = 0x89;
+				break;
+			default:
+				dev_err(chip->dev,
+					"RMU: port %d wrong offset requested: %d\n",
+					port, stat->reg);
+				return j;
+			}
+		} else if (stat->type & STATS_TYPE_BANK1) {
+			offset += 32;
+		}
+
+		if (offset >= num_cnt)
+			continue;
+
+		data[j] = be32_to_cpu(raw_cnt[offset]);
+
+		if (stat->size == 8) {
+			high = be32_to_cpu(raw_cnt[offset + 1]);
+			data[j] += (high << 32);
+		}
+
+		j++;
+	}
+	return j;
+}
+
 static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
 				     uint64_t *data, int types,
 				     u16 bank1_select, u16 histogram)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 440e9b274df4..aca7cfef196e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -433,6 +433,7 @@ struct mv88e6xxx_bus_ops {
 	int (*read)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 	int (*write)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
 	int (*init)(struct mv88e6xxx_chip *chip);
+	void (*get_rmon)(struct mv88e6xxx_chip *chip, int port, uint64_t *data);
 };
 
 struct mv88e6xxx_mdio_bus {
@@ -822,4 +823,9 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
 
 int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
 
+int mv88e6xxx_state_get_stats_rmu(struct mv88e6xxx_chip *chip, int port,
+				  __be32 *raw_cnt, int num_cnt, uint64_t *data);
+int mv88e6xxx_stats_get_sset_count_rmu(struct dsa_switch *ds, int port, int sset);
+void mv88e6xxx_stats_get_strings_rmu(struct dsa_switch *ds, int port,
+				     u32 stringset, uint8_t *data);
 #endif /* _MV88E6XXX_CHIP_H */
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
index c5b3c156de40..129535777c4b 100644
--- a/drivers/net/dsa/mv88e6xxx/rmu.c
+++ b/drivers/net/dsa/mv88e6xxx/rmu.c
@@ -137,6 +137,50 @@ static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
 	return ret;
 }
 
+static void mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
+{
+	u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_SOHO,
+		       MV88E6XXX_RMU_REQ_PAD,
+		       MV88E6XXX_RMU_REQ_CODE_DUMP_MIB,
+		       MV88E6XXX_RMU_REQ_DATA};
+	struct mv88e6xxx_dump_mib_resp resp;
+	struct mv88e6xxx_port *p;
+	u8 resp_port;
+	int resp_len;
+	int num_mibs;
+	int ret;
+
+	/* Populate port number in request */
+	req[3] = FIELD_PREP(MV88E6XXX_RMU_REQ_DUMP_MIB_PORT_MASK, port);
+
+	resp_len = sizeof(resp);
+	ret = mv88e6xxx_rmu_send_wait(chip, req, sizeof(req),
+				      &resp, &resp_len);
+	if (ret) {
+		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %pe port %d\n",
+			ERR_PTR(ret), port);
+		return;
+	}
+
+	/* Got response */
+	ret = mv88e6xxx_rmu_validate_response(&resp.rmu_header, MV88E6XXX_RMU_RESP_CODE_DUMP_MIB);
+	if (ret)
+		return;
+
+	resp_port = FIELD_GET(MV88E6XXX_SOURCE_PORT, resp.portnum);
+	p = &chip->ports[resp_port];
+	if (!p) {
+		dev_err_ratelimited(chip->dev, "RMU: illegal port number in response: %d\n",
+				    resp_port);
+		return;
+	}
+
+	/* Update MIB for port */
+	num_mibs = (resp_len - offsetof(struct mv88e6xxx_dump_mib_resp, mib)) / sizeof(__be32);
+
+	mv88e6xxx_state_get_stats_rmu(chip, port, resp.mib, num_mibs, data);
+}
+
 static void mv88e6xxx_disable_rmu(struct mv88e6xxx_chip *chip)
 {
 	chip->smi_ops = chip->rmu.smi_ops;
@@ -255,6 +299,15 @@ int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
 	chip->rmu.smi_ops = chip->smi_ops;
 	chip->rmu.ds_ops = chip->ds->ops;
 
+	/* Change rmu ops with our own pointer */
+	chip->rmu.smi_rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
+	chip->rmu.smi_rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;
+
+	/* Also change get stats strings for our own */
+	chip->rmu.ds_rmu_ops = (struct dsa_switch_ops *)chip->ds->ops;
+	chip->rmu.ds_rmu_ops->get_sset_count = mv88e6xxx_stats_get_sset_count_rmu;
+	chip->rmu.ds_rmu_ops->get_strings = mv88e6xxx_stats_get_strings_rmu;
+
 	/* Start disabled, we'll enable RMU in master_state_change */
 	if (chip->info->ops->rmu_disable)
 		return chip->info->ops->rmu_disable(chip);
-- 
2.25.1

