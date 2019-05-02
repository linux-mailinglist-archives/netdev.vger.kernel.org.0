Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53181233C
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfEBUZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:25:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37939 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfEBUYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:24:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id k16so5132904wrn.5;
        Thu, 02 May 2019 13:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lHD0gS/5osEvekJQTL1NzI+A0Q0Wtt6FRXgKJE0K+80=;
        b=K14v7w05uzoEwDEkHsJe1zyUWp9NDmYOGjoWN2O+31QGFe76NykBs4lElXzu7BoUqA
         WhIfREBqflcHRem32CdtXep1ZiP74+0+uMY1vYCTiKFRH+mkyw/F8Bm4zCTf+BkpsRo9
         APPzx9rbeGgHzBxhH2I98PYwVexiBQvrLfhqQJYnu//OvHXSC5RbfOHLcF+XzRBPsqkM
         X4fOnSrG/5c9GJ8c/h2e9K6Q+nlBbpitFVPVvQ8oMgpljbZzQmqwkFBnhFXHhyVylv47
         NUHHFDoWXL962sXw0iDY3Vlavqp9fZlxWR39bb5FCkYOpay8kKCVdMKVNjqLlqgB5Y2t
         7Q4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lHD0gS/5osEvekJQTL1NzI+A0Q0Wtt6FRXgKJE0K+80=;
        b=L6vs/IX9bgRjsDGK/yyl1MiSlWKPhu9/1xR5J7cvLAa0Yob+P9Sve0EjDltkAHSCio
         f38pZVtTdBc3qZPeox0yEmtN7A4kdMzxuDqxnDcEciCrPpriHH0/L80SyF0yDVEgaQx3
         VGfct9PBVk61LBk7fHYZMF8w5fXyRfPmc12CMNJX+I+apoIU+7ghl4m43X//StPmPOne
         uCj7j4bU8vrSGrxtS1D/K8h9U5NUEbrRuOPrxvzN7/HTlGAPTjac3I+pLg9ZaC2XeNCP
         20OgYDpOS0wbbAMIVFx0F4wUA8cYhKxry/PG+JEkwFRGbZ4q+wS07LT/jtPAaHYo8exs
         WXFw==
X-Gm-Message-State: APjAAAXvTM5RiKQTljb6S2F7fOOP1dwQg7X8C4zJd+WhGRvu17meMJVE
        qsCFbpjneHpotgcQkelQcJk=
X-Google-Smtp-Source: APXvYqzL+gDSuGWjBvYy7tGcd/FhWTNtbIq7ji3kx2iTzXrztIpQE/rf6L0MDf970lUuZuCywqs4EQ==
X-Received: by 2002:adf:edc8:: with SMTP id v8mr4309974wro.206.1556828685056;
        Thu, 02 May 2019 13:24:45 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s124sm217655wmf.42.2019.05.02.13.24.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:24:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v5 net-next 07/12] net: dsa: sja1105: Add support for ethtool port counters
Date:   Thu,  2 May 2019 23:23:35 +0300
Message-Id: <20190502202340.21054-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
Stripped blank lines at the end of files.

Changes in v4:
Replaced IS_ET and IS_PQRS macros with explicit device_id checking.
Added SJA1105 prefix to macro names.

Changes in v3:
None.

Changes in v2:
None functional. Moved the IS_ET() and IS_PQRS() device identification
macros here since they are not used in earlier patches.

 drivers/net/dsa/sja1105/Makefile          |   1 +
 drivers/net/dsa/sja1105/sja1105.h         |   7 +-
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 417 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c    |   3 +
 4 files changed, 427 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_ethtool.c

diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index d3237b313a4e..1c2b55fec959 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_NET_DSA_SJA1105) += sja1105.o
 sja1105-objs := \
     sja1105_spi.o \
     sja1105_main.o \
+    sja1105_ethtool.o \
     sja1105_clocking.o \
     sja1105_static_config.o \
     sja1105_dynamic_config.o \
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 87dee6794d98..38506bde83c6 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -117,8 +117,13 @@ typedef enum {
 int sja1105_clocking_setup_port(struct sja1105_private *priv, int port);
 int sja1105_clocking_setup(struct sja1105_private *priv);
 
-/* From sja1105_dynamic_config.c */
+/* From sja1105_ethtool.c */
+void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data);
+void sja1105_get_strings(struct dsa_switch *ds, int port,
+			 u32 stringset, u8 *data);
+int sja1105_get_sset_count(struct dsa_switch *ds, int port, int sset);
 
+/* From sja1105_dynamic_config.c */
 int sja1105_dynamic_config_read(struct sja1105_private *priv,
 				enum sja1105_blk_idx blk_idx,
 				int index, void *entry);
diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
new file mode 100644
index 000000000000..46d22be31309
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -0,0 +1,417 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#include "sja1105.h"
+
+#define SJA1105_SIZE_MAC_AREA		(0x02 * 4)
+#define SJA1105_SIZE_HL1_AREA		(0x10 * 4)
+#define SJA1105_SIZE_HL2_AREA		(0x4 * 4)
+#define SJA1105_SIZE_QLEVEL_AREA	(0x8 * 4) /* 0x4 to 0xB */
+
+struct sja1105_port_status_mac {
+	u64 n_runt;
+	u64 n_soferr;
+	u64 n_alignerr;
+	u64 n_miierr;
+	u64 typeerr;
+	u64 sizeerr;
+	u64 tctimeout;
+	u64 priorerr;
+	u64 nomaster;
+	u64 memov;
+	u64 memerr;
+	u64 invtyp;
+	u64 intcyov;
+	u64 domerr;
+	u64 pcfbagdrop;
+	u64 spcprior;
+	u64 ageprior;
+	u64 portdrop;
+	u64 lendrop;
+	u64 bagdrop;
+	u64 policeerr;
+	u64 drpnona664err;
+	u64 spcerr;
+	u64 agedrp;
+};
+
+struct sja1105_port_status_hl1 {
+	u64 n_n664err;
+	u64 n_vlanerr;
+	u64 n_unreleased;
+	u64 n_sizeerr;
+	u64 n_crcerr;
+	u64 n_vlnotfound;
+	u64 n_ctpolerr;
+	u64 n_polerr;
+	u64 n_rxfrmsh;
+	u64 n_rxfrm;
+	u64 n_rxbytesh;
+	u64 n_rxbyte;
+	u64 n_txfrmsh;
+	u64 n_txfrm;
+	u64 n_txbytesh;
+	u64 n_txbyte;
+};
+
+struct sja1105_port_status_hl2 {
+	u64 n_qfull;
+	u64 n_part_drop;
+	u64 n_egr_disabled;
+	u64 n_not_reach;
+	u64 qlevel_hwm[8]; /* Only for P/Q/R/S */
+	u64 qlevel[8];     /* Only for P/Q/R/S */
+};
+
+struct sja1105_port_status {
+	struct sja1105_port_status_mac mac;
+	struct sja1105_port_status_hl1 hl1;
+	struct sja1105_port_status_hl2 hl2;
+};
+
+static void
+sja1105_port_status_mac_unpack(void *buf,
+			       struct sja1105_port_status_mac *status)
+{
+	/* Make pointer arithmetic work on 4 bytes */
+	u32 *p = buf;
+
+	sja1105_unpack(p + 0x0, &status->n_runt,       31, 24, 4);
+	sja1105_unpack(p + 0x0, &status->n_soferr,     23, 16, 4);
+	sja1105_unpack(p + 0x0, &status->n_alignerr,   15,  8, 4);
+	sja1105_unpack(p + 0x0, &status->n_miierr,      7,  0, 4);
+	sja1105_unpack(p + 0x1, &status->typeerr,      27, 27, 4);
+	sja1105_unpack(p + 0x1, &status->sizeerr,      26, 26, 4);
+	sja1105_unpack(p + 0x1, &status->tctimeout,    25, 25, 4);
+	sja1105_unpack(p + 0x1, &status->priorerr,     24, 24, 4);
+	sja1105_unpack(p + 0x1, &status->nomaster,     23, 23, 4);
+	sja1105_unpack(p + 0x1, &status->memov,        22, 22, 4);
+	sja1105_unpack(p + 0x1, &status->memerr,       21, 21, 4);
+	sja1105_unpack(p + 0x1, &status->invtyp,       19, 19, 4);
+	sja1105_unpack(p + 0x1, &status->intcyov,      18, 18, 4);
+	sja1105_unpack(p + 0x1, &status->domerr,       17, 17, 4);
+	sja1105_unpack(p + 0x1, &status->pcfbagdrop,   16, 16, 4);
+	sja1105_unpack(p + 0x1, &status->spcprior,     15, 12, 4);
+	sja1105_unpack(p + 0x1, &status->ageprior,     11,  8, 4);
+	sja1105_unpack(p + 0x1, &status->portdrop,      6,  6, 4);
+	sja1105_unpack(p + 0x1, &status->lendrop,       5,  5, 4);
+	sja1105_unpack(p + 0x1, &status->bagdrop,       4,  4, 4);
+	sja1105_unpack(p + 0x1, &status->policeerr,     3,  3, 4);
+	sja1105_unpack(p + 0x1, &status->drpnona664err, 2,  2, 4);
+	sja1105_unpack(p + 0x1, &status->spcerr,        1,  1, 4);
+	sja1105_unpack(p + 0x1, &status->agedrp,        0,  0, 4);
+}
+
+static void
+sja1105_port_status_hl1_unpack(void *buf,
+			       struct sja1105_port_status_hl1 *status)
+{
+	/* Make pointer arithmetic work on 4 bytes */
+	u32 *p = buf;
+
+	sja1105_unpack(p + 0xF, &status->n_n664err,    31,  0, 4);
+	sja1105_unpack(p + 0xE, &status->n_vlanerr,    31,  0, 4);
+	sja1105_unpack(p + 0xD, &status->n_unreleased, 31,  0, 4);
+	sja1105_unpack(p + 0xC, &status->n_sizeerr,    31,  0, 4);
+	sja1105_unpack(p + 0xB, &status->n_crcerr,     31,  0, 4);
+	sja1105_unpack(p + 0xA, &status->n_vlnotfound, 31,  0, 4);
+	sja1105_unpack(p + 0x9, &status->n_ctpolerr,   31,  0, 4);
+	sja1105_unpack(p + 0x8, &status->n_polerr,     31,  0, 4);
+	sja1105_unpack(p + 0x7, &status->n_rxfrmsh,    31,  0, 4);
+	sja1105_unpack(p + 0x6, &status->n_rxfrm,      31,  0, 4);
+	sja1105_unpack(p + 0x5, &status->n_rxbytesh,   31,  0, 4);
+	sja1105_unpack(p + 0x4, &status->n_rxbyte,     31,  0, 4);
+	sja1105_unpack(p + 0x3, &status->n_txfrmsh,    31,  0, 4);
+	sja1105_unpack(p + 0x2, &status->n_txfrm,      31,  0, 4);
+	sja1105_unpack(p + 0x1, &status->n_txbytesh,   31,  0, 4);
+	sja1105_unpack(p + 0x0, &status->n_txbyte,     31,  0, 4);
+	status->n_rxfrm  += status->n_rxfrmsh  << 32;
+	status->n_rxbyte += status->n_rxbytesh << 32;
+	status->n_txfrm  += status->n_txfrmsh  << 32;
+	status->n_txbyte += status->n_txbytesh << 32;
+}
+
+static void
+sja1105_port_status_hl2_unpack(void *buf,
+			       struct sja1105_port_status_hl2 *status)
+{
+	/* Make pointer arithmetic work on 4 bytes */
+	u32 *p = buf;
+
+	sja1105_unpack(p + 0x3, &status->n_qfull,        31,  0, 4);
+	sja1105_unpack(p + 0x2, &status->n_part_drop,    31,  0, 4);
+	sja1105_unpack(p + 0x1, &status->n_egr_disabled, 31,  0, 4);
+	sja1105_unpack(p + 0x0, &status->n_not_reach,    31,  0, 4);
+}
+
+static void
+sja1105pqrs_port_status_qlevel_unpack(void *buf,
+				      struct sja1105_port_status_hl2 *status)
+{
+	/* Make pointer arithmetic work on 4 bytes */
+	u32 *p = buf;
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		sja1105_unpack(p + i, &status->qlevel_hwm[i], 24, 16, 4);
+		sja1105_unpack(p + i, &status->qlevel[i],      8,  0, 4);
+	}
+}
+
+static int sja1105_port_status_get_mac(struct sja1105_private *priv,
+				       struct sja1105_port_status_mac *status,
+				       int port)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u8 packed_buf[SJA1105_SIZE_MAC_AREA] = {0};
+	int rc;
+
+	/* MAC area */
+	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->mac[port],
+					 packed_buf, SJA1105_SIZE_MAC_AREA);
+	if (rc < 0)
+		return rc;
+
+	sja1105_port_status_mac_unpack(packed_buf, status);
+
+	return 0;
+}
+
+static int sja1105_port_status_get_hl1(struct sja1105_private *priv,
+				       struct sja1105_port_status_hl1 *status,
+				       int port)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u8 packed_buf[SJA1105_SIZE_HL1_AREA] = {0};
+	int rc;
+
+	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->mac_hl1[port],
+					 packed_buf, SJA1105_SIZE_HL1_AREA);
+	if (rc < 0)
+		return rc;
+
+	sja1105_port_status_hl1_unpack(packed_buf, status);
+
+	return 0;
+}
+
+static int sja1105_port_status_get_hl2(struct sja1105_private *priv,
+				       struct sja1105_port_status_hl2 *status,
+				       int port)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u8 packed_buf[SJA1105_SIZE_QLEVEL_AREA] = {0};
+	int rc;
+
+	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->mac_hl2[port],
+					 packed_buf, SJA1105_SIZE_HL2_AREA);
+	if (rc < 0)
+		return rc;
+
+	sja1105_port_status_hl2_unpack(packed_buf, status);
+
+	/* Code below is strictly P/Q/R/S specific. */
+	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+	    priv->info->device_id == SJA1105T_DEVICE_ID)
+		return 0;
+
+	rc = sja1105_spi_send_packed_buf(priv, SPI_READ, regs->qlevel[port],
+					 packed_buf, SJA1105_SIZE_QLEVEL_AREA);
+	if (rc < 0)
+		return rc;
+
+	sja1105pqrs_port_status_qlevel_unpack(packed_buf, status);
+
+	return 0;
+}
+
+static int sja1105_port_status_get(struct sja1105_private *priv,
+				   struct sja1105_port_status *status,
+				   int port)
+{
+	int rc;
+
+	rc = sja1105_port_status_get_mac(priv, &status->mac, port);
+	if (rc < 0)
+		return rc;
+	rc = sja1105_port_status_get_hl1(priv, &status->hl1, port);
+	if (rc < 0)
+		return rc;
+	rc = sja1105_port_status_get_hl2(priv, &status->hl2, port);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+static char sja1105_port_stats[][ETH_GSTRING_LEN] = {
+	/* MAC-Level Diagnostic Counters */
+	"n_runt",
+	"n_soferr",
+	"n_alignerr",
+	"n_miierr",
+	/* MAC-Level Diagnostic Flags */
+	"typeerr",
+	"sizeerr",
+	"tctimeout",
+	"priorerr",
+	"nomaster",
+	"memov",
+	"memerr",
+	"invtyp",
+	"intcyov",
+	"domerr",
+	"pcfbagdrop",
+	"spcprior",
+	"ageprior",
+	"portdrop",
+	"lendrop",
+	"bagdrop",
+	"policeerr",
+	"drpnona664err",
+	"spcerr",
+	"agedrp",
+	/* High-Level Diagnostic Counters */
+	"n_n664err",
+	"n_vlanerr",
+	"n_unreleased",
+	"n_sizeerr",
+	"n_crcerr",
+	"n_vlnotfound",
+	"n_ctpolerr",
+	"n_polerr",
+	"n_rxfrm",
+	"n_rxbyte",
+	"n_txfrm",
+	"n_txbyte",
+	"n_qfull",
+	"n_part_drop",
+	"n_egr_disabled",
+	"n_not_reach",
+};
+
+static char sja1105pqrs_extra_port_stats[][ETH_GSTRING_LEN] = {
+	/* Queue Levels */
+	"qlevel_hwm_0",
+	"qlevel_hwm_1",
+	"qlevel_hwm_2",
+	"qlevel_hwm_3",
+	"qlevel_hwm_4",
+	"qlevel_hwm_5",
+	"qlevel_hwm_6",
+	"qlevel_hwm_7",
+	"qlevel_0",
+	"qlevel_1",
+	"qlevel_2",
+	"qlevel_3",
+	"qlevel_4",
+	"qlevel_5",
+	"qlevel_6",
+	"qlevel_7",
+};
+
+void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_port_status status = {0};
+	int rc, i, k = 0;
+
+	rc = sja1105_port_status_get(priv, &status, port);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to read port %d counters: %d\n",
+			port, rc);
+		return;
+	}
+	memset(data, 0, ARRAY_SIZE(sja1105_port_stats) * sizeof(u64));
+	data[k++] = status.mac.n_runt;
+	data[k++] = status.mac.n_soferr;
+	data[k++] = status.mac.n_alignerr;
+	data[k++] = status.mac.n_miierr;
+	data[k++] = status.mac.typeerr;
+	data[k++] = status.mac.sizeerr;
+	data[k++] = status.mac.tctimeout;
+	data[k++] = status.mac.priorerr;
+	data[k++] = status.mac.nomaster;
+	data[k++] = status.mac.memov;
+	data[k++] = status.mac.memerr;
+	data[k++] = status.mac.invtyp;
+	data[k++] = status.mac.intcyov;
+	data[k++] = status.mac.domerr;
+	data[k++] = status.mac.pcfbagdrop;
+	data[k++] = status.mac.spcprior;
+	data[k++] = status.mac.ageprior;
+	data[k++] = status.mac.portdrop;
+	data[k++] = status.mac.lendrop;
+	data[k++] = status.mac.bagdrop;
+	data[k++] = status.mac.policeerr;
+	data[k++] = status.mac.drpnona664err;
+	data[k++] = status.mac.spcerr;
+	data[k++] = status.mac.agedrp;
+	data[k++] = status.hl1.n_n664err;
+	data[k++] = status.hl1.n_vlanerr;
+	data[k++] = status.hl1.n_unreleased;
+	data[k++] = status.hl1.n_sizeerr;
+	data[k++] = status.hl1.n_crcerr;
+	data[k++] = status.hl1.n_vlnotfound;
+	data[k++] = status.hl1.n_ctpolerr;
+	data[k++] = status.hl1.n_polerr;
+	data[k++] = status.hl1.n_rxfrm;
+	data[k++] = status.hl1.n_rxbyte;
+	data[k++] = status.hl1.n_txfrm;
+	data[k++] = status.hl1.n_txbyte;
+	data[k++] = status.hl2.n_qfull;
+	data[k++] = status.hl2.n_part_drop;
+	data[k++] = status.hl2.n_egr_disabled;
+	data[k++] = status.hl2.n_not_reach;
+
+	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+	    priv->info->device_id == SJA1105T_DEVICE_ID)
+		return;
+
+	memset(data + k, 0, ARRAY_SIZE(sja1105pqrs_extra_port_stats) *
+			sizeof(u64));
+	for (i = 0; i < 8; i++) {
+		data[k++] = status.hl2.qlevel_hwm[i];
+		data[k++] = status.hl2.qlevel[i];
+	}
+}
+
+void sja1105_get_strings(struct dsa_switch *ds, int port,
+			 u32 stringset, u8 *data)
+{
+	struct sja1105_private *priv = ds->priv;
+	u8 *p = data;
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < ARRAY_SIZE(sja1105_port_stats); i++) {
+			strlcpy(p, sja1105_port_stats[i], ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+		if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+		    priv->info->device_id == SJA1105T_DEVICE_ID)
+			return;
+		for (i = 0; i < ARRAY_SIZE(sja1105pqrs_extra_port_stats); i++) {
+			strlcpy(p, sja1105pqrs_extra_port_stats[i],
+				ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+		break;
+	}
+}
+
+int sja1105_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	int count = ARRAY_SIZE(sja1105_port_stats);
+	struct sja1105_private *priv = ds->priv;
+
+	if (sset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
+
+	if (priv->info->device_id == SJA1105PR_DEVICE_ID ||
+	    priv->info->device_id == SJA1105QS_DEVICE_ID)
+		count += ARRAY_SIZE(sja1105pqrs_extra_port_stats);
+
+	return count;
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f7b1525b388a..28b11c7a81e7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1253,6 +1253,9 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
 	.adjust_link		= sja1105_adjust_link,
+	.get_strings		= sja1105_get_strings,
+	.get_ethtool_stats	= sja1105_get_ethtool_stats,
+	.get_sset_count		= sja1105_get_sset_count,
 	.port_fdb_dump		= sja1105_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
 	.port_fdb_del		= sja1105_fdb_del,
-- 
2.17.1

