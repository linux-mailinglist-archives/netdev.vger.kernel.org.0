Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EE03A09E
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 18:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfFHQNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 12:13:07 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38844 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfFHQNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 12:13:06 -0400
Received: by mail-wr1-f46.google.com with SMTP id d18so5046738wrs.5
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 09:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sev4hMxC0H40uFX6fqXVPnQ/E5MigNuBdNLKCpFrYz0=;
        b=GIifvCAMs+m2mMY78aAFZUmnCB/Iz5X3/a0S1/yonrsNLm7GpA+XWAI6faKLf1B3d2
         eCgOSh03A6o8tHbSpF7kv8+Umh0aiUIYLUhoPJwxTVrak//gMpj8OezcPy8CJwmXSdyw
         WhMk0iirVvf2Tf5bA1YImWic/Sg69D8bWKtEnRozMNI//sFtHFUOpgOPKGhSfHi2HBQi
         VV4GX5ojOz2GNwzod+WKa9vOchB62ejpBJfXemAJTAO9ZOknnKGPQi2D5xMBwrWeMI2k
         yl681gLcXTD9ZxpTl/Vc/DAcQZyYo1qDz6OwtwYbmV/AI+0lc6/fB/fZeY5xKzNcDwfX
         5q9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sev4hMxC0H40uFX6fqXVPnQ/E5MigNuBdNLKCpFrYz0=;
        b=qMdivTe3xhQzgx9uo5WSWZ/0XbuwCScrvPYt4N+yXwF7OXVgQIqaH/7JiBV2Oz7nar
         plJdoomY7Dn7tbEsaLpqawWSHp4TkhwpJkFl7h42MxXJbXza8aMEnUfWv9qBKbo/QoBd
         MPMWjyXPpQtUJpXW/7/7/XDZ19ctKVQfPaxZz7XKUrTG+MHX4KIWt/ra8LFxSnfqa5KU
         yN8di8rNOMFK/m1mjy7psWXtWp+XbS/0/99K7xqlelZhm0eAORiN89gqM/gVe9d7gAVs
         y8aHLZFh0WJ7+yrOwrtFR0PLAZT/v6pvSX3ts62Pxz8WnXh3xcKBhDTi1RReiP1Cr7BG
         4IWw==
X-Gm-Message-State: APjAAAUA0PO033Jb3c3D+CRczsPo0pewdu4zCRlIYDPM3cXYASJyVdcr
        QeVkm+oLf9Sk7QbDz3ybdETQTP82IEg=
X-Google-Smtp-Source: APXvYqzD+Xg+63s/2m00i2FdRs8tap1y9bqfT/uYa3/LSLPZv0org075ZMo2bZAvgP2AlTuUYc0k3A==
X-Received: by 2002:adf:afd5:: with SMTP id y21mr37242899wrd.12.1560010384378;
        Sat, 08 Jun 2019 09:13:04 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id l18sm3934221wrv.38.2019.06.08.09.13.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 09:13:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: sja1105: Remove duplicate rgmii_pad_mii_tx from regs
Date:   Sat,  8 Jun 2019 19:12:27 +0300
Message-Id: <20190608161228.5730-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608161228.5730-1-olteanv@gmail.com>
References: <20190608161228.5730-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pad_mii_tx registers point to the same memory region but were
unused. So convert to using these for RGMII I/O cell configuration, as
they bear a shorter name.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h          | 2 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c | 2 +-
 drivers/net/dsa/sja1105/sja1105_spi.c      | 6 ++----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index ed66d00eb394..a37ece1b94cf 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -35,8 +35,8 @@ struct sja1105_regs {
 	u64 ptptsclk;
 	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
+	u64 pad_mii_id[SJA1105_NUM_PORTS];
 	u64 cgu_idiv[SJA1105_NUM_PORTS];
-	u64 rgmii_pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 mii_tx_clk[SJA1105_NUM_PORTS];
 	u64 mii_rx_clk[SJA1105_NUM_PORTS];
 	u64 mii_ext_tx_clk[SJA1105_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 94bfe0ee50a8..5c7cea22b647 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -373,7 +373,7 @@ static int sja1105_rgmii_cfg_pad_tx_config(struct sja1105_private *priv,
 	sja1105_cfg_pad_mii_tx_packing(packed_buf, &pad_mii_tx, PACK);
 
 	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
-					   regs->rgmii_pad_mii_tx[port],
+					   regs->pad_mii_tx[port],
 					   packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index d7ff74259b31..feb9e0422a68 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -500,11 +500,10 @@ static struct sja1105_regs sja1105et_regs = {
 	.port_control = 0x11,
 	.config = 0x020000,
 	.rgu = 0x100440,
+	/* UM10944.pdf, Table 86, ACU Register overview */
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
 	.rmii_pll1 = 0x10000A,
 	.cgu_idiv = {0x10000B, 0x10000C, 0x10000D, 0x10000E, 0x10000F},
-	/* UM10944.pdf, Table 86, ACU Register overview */
-	.rgmii_pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
 	.mac = {0x200, 0x202, 0x204, 0x206, 0x208},
 	.mac_hl1 = {0x400, 0x410, 0x420, 0x430, 0x440},
 	.mac_hl2 = {0x600, 0x610, 0x620, 0x630, 0x640},
@@ -530,11 +529,10 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.port_control = 0x12,
 	.config = 0x020000,
 	.rgu = 0x100440,
+	/* UM10944.pdf, Table 86, ACU Register overview */
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
 	.rmii_pll1 = 0x10000A,
 	.cgu_idiv = {0x10000B, 0x10000C, 0x10000D, 0x10000E, 0x10000F},
-	/* UM10944.pdf, Table 86, ACU Register overview */
-	.rgmii_pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
 	.mac = {0x200, 0x202, 0x204, 0x206, 0x208},
 	.mac_hl1 = {0x400, 0x410, 0x420, 0x430, 0x440},
 	.mac_hl2 = {0x600, 0x610, 0x620, 0x630, 0x640},
-- 
2.17.1

