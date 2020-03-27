Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D56195875
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgC0OA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:00:27 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35854 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0OA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 10:00:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so11532455wrs.3
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 07:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=P3aHEHD9vrw915FwRHerVV7bDpQL8OQyLV/jjuDxzJE=;
        b=gcxXOwkItjJmk8lKkUzZzxA110mGVK08UYX6Bl/JZJPvrQUBVMe5+GExAWobLucVN0
         1VBBzO9HoPlE0dJU8cJSj3oehmLHdgdodxbbXM85X2+u0MJNR8RfMalDZC6qqldVE1Zz
         t3lPYgaQmIXeHEgVrxUurn41Ru8XQF1xg8NmHE/YBx411Vo5j8ozJXwRrnt/OXQHXdcd
         BYPb5ePvg7BxDh3S9q8hjfCOTrzr3A9h4Ao4KHqCvBydpD1ReWdjrEzZJOJTNfZDNA6G
         U0cdRsC6dHZuUPuDjFa6ZAk/Mn3Pjj8EZGhH/7h7hXjgBFKV7iRVdZwmxryebDt4jzrn
         4WHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P3aHEHD9vrw915FwRHerVV7bDpQL8OQyLV/jjuDxzJE=;
        b=EZ/afgBBX0CXnz1vJAWyv79rkBtGL5QYw/paWt/+Ou0GsrF7owRYzrski4qF3rkqBW
         Km/NmZKqo7quPKsoqG5d0pfwVIj+Ql5TM54EMFGyZFHKTVqLXXbxrRuv/jj/Sw2M20Rq
         HLksvIdQwu5uABAmT3YN3gMfioTPkwKYVs1nwCpxuxOkgr8YzfH1toeaiycyAqccPNYc
         XULhpaJaKzHjASjfRJm8T18rJkkQH/Ejisr52jmno2hTiwhL5c1Bcgxs60nrNcD4X3Fg
         mgNrSa/RUcS0rOgr2DPOGkgCt/RoQr0fAIblahwyCEAK1je/0FW6I5NDJ/zqCBTC/Vpu
         s2TQ==
X-Gm-Message-State: ANhLgQ0jfNUnp4HvoPZg2U3OlXsIr+zedpkZfpQ6TRHwnP3AMKYDEBXb
        KyVJBBavnGTd7tSAX06JsO04wYTtUv1fzA==
X-Google-Smtp-Source: ADFU+vtdhxo//uQ4P1/PJ6FBOi6ifONWSCSaiYof1xf/DEsHF9wcrqp7jVJcog7W7BNBdi1iW5IsyQ==
X-Received: by 2002:adf:c651:: with SMTP id u17mr16024521wrg.40.1585317624169;
        Fri, 27 Mar 2020 07:00:24 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id r17sm8435454wrx.46.2020.03.27.07.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 07:00:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: sja1105: show more ethtool statistics counters for P/Q/R/S
Date:   Fri, 27 Mar 2020 16:00:16 +0200
Message-Id: <20200327140016.629-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It looks like the P/Q/R/S series supports some more counters,
generically named "Ethernet statistics counter", which we were not
printing. Add them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h         |   1 +
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 133 +++++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_spi.c     |   1 +
 3 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 0e5b739b2fe8..d97d4699104e 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -60,6 +60,7 @@ struct sja1105_regs {
 	u64 mac[SJA1105_NUM_PORTS];
 	u64 mac_hl1[SJA1105_NUM_PORTS];
 	u64 mac_hl2[SJA1105_NUM_PORTS];
+	u64 ether_stats[SJA1105_NUM_PORTS];
 	u64 qlevel[SJA1105_NUM_PORTS];
 };
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index 064301cc7d5b..d742ffcbfce9 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -7,6 +7,7 @@
 #define SJA1105_SIZE_HL1_AREA		(0x10 * 4)
 #define SJA1105_SIZE_HL2_AREA		(0x4 * 4)
 #define SJA1105_SIZE_QLEVEL_AREA	(0x8 * 4) /* 0x4 to 0xB */
+#define SJA1105_SIZE_ETHER_AREA		(0x17 * 4)
 
 struct sja1105_port_status_mac {
 	u64 n_runt;
@@ -63,10 +64,37 @@ struct sja1105_port_status_hl2 {
 	u64 qlevel[8];     /* Only for P/Q/R/S */
 };
 
+struct sja1105_port_status_ether {
+	u64 n_drops_nolearn;
+	u64 n_drops_noroute;
+	u64 n_drops_ill_dtag;
+	u64 n_drops_dtag;
+	u64 n_drops_sotag;
+	u64 n_drops_sitag;
+	u64 n_drops_utag;
+	u64 n_tx_bytes_1024_2047;
+	u64 n_tx_bytes_512_1023;
+	u64 n_tx_bytes_256_511;
+	u64 n_tx_bytes_128_255;
+	u64 n_tx_bytes_65_127;
+	u64 n_tx_bytes_64;
+	u64 n_tx_mcast;
+	u64 n_tx_bcast;
+	u64 n_rx_bytes_1024_2047;
+	u64 n_rx_bytes_512_1023;
+	u64 n_rx_bytes_256_511;
+	u64 n_rx_bytes_128_255;
+	u64 n_rx_bytes_65_127;
+	u64 n_rx_bytes_64;
+	u64 n_rx_mcast;
+	u64 n_rx_bcast;
+};
+
 struct sja1105_port_status {
 	struct sja1105_port_status_mac mac;
 	struct sja1105_port_status_hl1 hl1;
 	struct sja1105_port_status_hl2 hl2;
+	struct sja1105_port_status_ether ether;
 };
 
 static void
@@ -158,6 +186,58 @@ sja1105pqrs_port_status_qlevel_unpack(void *buf,
 	}
 }
 
+static void
+sja1105pqrs_port_status_ether_unpack(void *buf,
+				     struct sja1105_port_status_ether *status)
+{
+	/* Make pointer arithmetic work on 4 bytes */
+	u32 *p = buf;
+
+	sja1105_unpack(p + 0x16, &status->n_drops_nolearn,      31, 0, 4);
+	sja1105_unpack(p + 0x15, &status->n_drops_noroute,      31, 0, 4);
+	sja1105_unpack(p + 0x14, &status->n_drops_ill_dtag,     31, 0, 4);
+	sja1105_unpack(p + 0x13, &status->n_drops_dtag,         31, 0, 4);
+	sja1105_unpack(p + 0x12, &status->n_drops_sotag,        31, 0, 4);
+	sja1105_unpack(p + 0x11, &status->n_drops_sitag,        31, 0, 4);
+	sja1105_unpack(p + 0x10, &status->n_drops_utag,         31, 0, 4);
+	sja1105_unpack(p + 0x0F, &status->n_tx_bytes_1024_2047, 31, 0, 4);
+	sja1105_unpack(p + 0x0E, &status->n_tx_bytes_512_1023,  31, 0, 4);
+	sja1105_unpack(p + 0x0D, &status->n_tx_bytes_256_511,   31, 0, 4);
+	sja1105_unpack(p + 0x0C, &status->n_tx_bytes_128_255,   31, 0, 4);
+	sja1105_unpack(p + 0x0B, &status->n_tx_bytes_65_127,    31, 0, 4);
+	sja1105_unpack(p + 0x0A, &status->n_tx_bytes_64,        31, 0, 4);
+	sja1105_unpack(p + 0x09, &status->n_tx_mcast,           31, 0, 4);
+	sja1105_unpack(p + 0x08, &status->n_tx_bcast,           31, 0, 4);
+	sja1105_unpack(p + 0x07, &status->n_rx_bytes_1024_2047, 31, 0, 4);
+	sja1105_unpack(p + 0x06, &status->n_rx_bytes_512_1023,  31, 0, 4);
+	sja1105_unpack(p + 0x05, &status->n_rx_bytes_256_511,   31, 0, 4);
+	sja1105_unpack(p + 0x04, &status->n_rx_bytes_128_255,   31, 0, 4);
+	sja1105_unpack(p + 0x03, &status->n_rx_bytes_65_127,    31, 0, 4);
+	sja1105_unpack(p + 0x02, &status->n_rx_bytes_64,        31, 0, 4);
+	sja1105_unpack(p + 0x01, &status->n_rx_mcast,           31, 0, 4);
+	sja1105_unpack(p + 0x00, &status->n_rx_bcast,           31, 0, 4);
+}
+
+static int
+sja1105pqrs_port_status_get_ether(struct sja1105_private *priv,
+				  struct sja1105_port_status_ether *ether,
+				  int port)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u8 packed_buf[SJA1105_SIZE_ETHER_AREA] = {0};
+	int rc;
+
+	/* Ethernet statistics area */
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->ether_stats[port],
+			      packed_buf, SJA1105_SIZE_ETHER_AREA);
+	if (rc < 0)
+		return rc;
+
+	sja1105pqrs_port_status_ether_unpack(packed_buf, ether);
+
+	return 0;
+}
+
 static int sja1105_port_status_get_mac(struct sja1105_private *priv,
 				       struct sja1105_port_status_mac *status,
 				       int port)
@@ -241,7 +321,11 @@ static int sja1105_port_status_get(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 
-	return 0;
+	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+	    priv->info->device_id == SJA1105T_DEVICE_ID)
+		return 0;
+
+	return sja1105pqrs_port_status_get_ether(priv, &status->ether, port);
 }
 
 static char sja1105_port_stats[][ETH_GSTRING_LEN] = {
@@ -308,6 +392,30 @@ static char sja1105pqrs_extra_port_stats[][ETH_GSTRING_LEN] = {
 	"qlevel_5",
 	"qlevel_6",
 	"qlevel_7",
+	/* Ether Stats */
+	"n_drops_nolearn",
+	"n_drops_noroute",
+	"n_drops_ill_dtag",
+	"n_drops_dtag",
+	"n_drops_sotag",
+	"n_drops_sitag",
+	"n_drops_utag",
+	"n_tx_bytes_1024_2047",
+	"n_tx_bytes_512_1023",
+	"n_tx_bytes_256_511",
+	"n_tx_bytes_128_255",
+	"n_tx_bytes_65_127",
+	"n_tx_bytes_64",
+	"n_tx_mcast",
+	"n_tx_bcast",
+	"n_rx_bytes_1024_2047",
+	"n_rx_bytes_512_1023",
+	"n_rx_bytes_256_511",
+	"n_rx_bytes_128_255",
+	"n_rx_bytes_65_127",
+	"n_rx_bytes_64",
+	"n_rx_mcast",
+	"n_rx_bcast",
 };
 
 void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
@@ -376,6 +484,29 @@ void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 		data[k++] = status.hl2.qlevel_hwm[i];
 		data[k++] = status.hl2.qlevel[i];
 	}
+	data[k++] = status.ether.n_drops_nolearn;
+	data[k++] = status.ether.n_drops_noroute;
+	data[k++] = status.ether.n_drops_ill_dtag;
+	data[k++] = status.ether.n_drops_dtag;
+	data[k++] = status.ether.n_drops_sotag;
+	data[k++] = status.ether.n_drops_sitag;
+	data[k++] = status.ether.n_drops_utag;
+	data[k++] = status.ether.n_tx_bytes_1024_2047;
+	data[k++] = status.ether.n_tx_bytes_512_1023;
+	data[k++] = status.ether.n_tx_bytes_256_511;
+	data[k++] = status.ether.n_tx_bytes_128_255;
+	data[k++] = status.ether.n_tx_bytes_65_127;
+	data[k++] = status.ether.n_tx_bytes_64;
+	data[k++] = status.ether.n_tx_mcast;
+	data[k++] = status.ether.n_tx_bcast;
+	data[k++] = status.ether.n_rx_bytes_1024_2047;
+	data[k++] = status.ether.n_rx_bytes_512_1023;
+	data[k++] = status.ether.n_rx_bytes_256_511;
+	data[k++] = status.ether.n_rx_bytes_128_255;
+	data[k++] = status.ether.n_rx_bytes_65_127;
+	data[k++] = status.ether.n_rx_bytes_64;
+	data[k++] = status.ether.n_rx_mcast;
+	data[k++] = status.ether.n_rx_bcast;
 }
 
 void sja1105_get_strings(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index fef2c50cd3f6..04bdb72ae6b6 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -482,6 +482,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.mac = {0x200, 0x202, 0x204, 0x206, 0x208},
 	.mac_hl1 = {0x400, 0x410, 0x420, 0x430, 0x440},
 	.mac_hl2 = {0x600, 0x610, 0x620, 0x630, 0x640},
+	.ether_stats = {0x1400, 0x1418, 0x1430, 0x1448, 0x1460},
 	/* UM11040.pdf, Table 114 */
 	.mii_tx_clk = {0x100013, 0x100019, 0x10001F, 0x100025, 0x10002B},
 	.mii_rx_clk = {0x100014, 0x10001A, 0x100020, 0x100026, 0x10002C},
-- 
2.17.1

