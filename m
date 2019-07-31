Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470667BB96
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfGaIZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:25:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45384 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbfGaIZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:25:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so68616796wre.12;
        Wed, 31 Jul 2019 01:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=24bkq8J7wgwVnYVCp6wxwpRgDGNMlXKQR1CYDUXv7oI=;
        b=XNTkFfQei7YLePpH1ZaW2jxiGH3/mx0yT9HaUAOHmWRT9E+XnuZmhbkWHbOJYURbP0
         jiI9xLhEwZBM+VsgHcpyjtexnPTo3tjR/Mq0WRDTOOgYlA8rX2QQGtr4y1SmRfPxoAee
         5Oh3ca+kONCyKQXaT4tPrPfCKf2mdE/0eDxQsQ2YtVxBCEa7nkELjbLwdX3zT2qCgN68
         wAhrJW2ySeXmgMSGB+jeyoAbTACnUDuzle6fV4CmVZPxhjVO9bZjBTWnOnFju0HXzoe3
         0ADWelffY/1GPrnU56huQt39Kn2XAb43ZW+Hu/JZwNHmjRhQAjGnKqCu9zSfjqLx+JTI
         YxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24bkq8J7wgwVnYVCp6wxwpRgDGNMlXKQR1CYDUXv7oI=;
        b=YjhpXLN9gbT3a+fI6JR/gc8ZbzlQIeDHIQ2c0oNbUOsQ9e69t8uOB2436fHtnPnR60
         4Tcdz3kaDQ4uG2B5GI3bXRZFHq957wl9KKNhBbygolQ6JQz3lbppWX9lWzWw+Uf1avea
         DSiQBocv85z4De/FV07IQOWD4xkKp3P9riOQiibEBsPr4j4zBRpUQBQZtgPFS6nvWkGr
         ZotdbTCnkXwrdkq3y6JrUK3cJmIN1eF1VgTyHoSDlvDj4wYalTns8R+pfaNDYZgmZpXf
         DbWoWy/jZTYlnb4Doz5zjMCOOEJUfaTHYNQh63DOAj7ffoT1Tshg7EFUOR5VbeaKh9NB
         pD3g==
X-Gm-Message-State: APjAAAU+T3sJ2aXGKyVKu4pRCgX1AihidmVtjGCyatFKVnLgtTuYQBT4
        AmjnUQiKM/wdgphJWBuEvWl1E7VLp0k=
X-Google-Smtp-Source: APXvYqw/MqF3OE/vhSTw8Pae16d+zJOtPyiRNcBSv54zzuFrLLiZggKDIqdjS0+EiD8n0rPw+UYH/A==
X-Received: by 2002:adf:c508:: with SMTP id q8mr550542wrf.148.1564561544629;
        Wed, 31 Jul 2019 01:25:44 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c78sm93223959wmd.16.2019.07.31.01.25.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 01:25:44 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 1/6] net: dsa: mv88e6xxx: add support for MV88E6220
Date:   Wed, 31 Jul 2019 10:23:46 +0200
Message-Id: <20190731082351.3157-2-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731082351.3157-1-h.feurstein@gmail.com>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV88E6220 is almost the same as MV88E6250 except that the ports 2-4 are
not routed to pins. So the usable ports are 0, 1, 5 and 6.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++-
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6b17cd961d06..c8c176da0f1c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4259,6 +4259,31 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ops = &mv88e6191_ops,
 	},
 
+	[MV88E6220] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6220,
+		.family = MV88E6XXX_FAMILY_6250,
+		.name = "Marvell 88E6220",
+		.num_databases = 64,
+
+		/* Ports 2-4 are not routed to pins
+		 * => usable ports 0, 1, 5, 6
+		 */
+		.num_ports = 7,
+		.num_internal_phys = 2,
+		.max_vid = 4095,
+		.port_base_addr = 0x08,
+		.phy_base_addr = 0x00,
+		.global1_addr = 0x0f,
+		.global2_addr = 0x07,
+		.age_time_coeff = 15000,
+		.g1_irqs = 9,
+		.g2_irqs = 10,
+		.atu_move_port_mask = 0xf,
+		.dual_chip = true,
+		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ops = &mv88e6250_ops,
+	},
+
 	[MV88E6240] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6240,
 		.family = MV88E6XXX_FAMILY_6352,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 4646e46d47f2..2cc508a1cc32 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -57,6 +57,7 @@ enum mv88e6xxx_model {
 	MV88E6190,
 	MV88E6190X,
 	MV88E6191,
+	MV88E6220,
 	MV88E6240,
 	MV88E6250,
 	MV88E6290,
@@ -77,7 +78,7 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6097,	/* 6046 6085 6096 6097 */
 	MV88E6XXX_FAMILY_6165,	/* 6123 6161 6165 */
 	MV88E6XXX_FAMILY_6185,	/* 6108 6121 6122 6131 6152 6155 6182 6185 */
-	MV88E6XXX_FAMILY_6250,	/* 6250 */
+	MV88E6XXX_FAMILY_6250,	/* 6220 6250 */
 	MV88E6XXX_FAMILY_6320,	/* 6320 6321 */
 	MV88E6XXX_FAMILY_6341,	/* 6141 6341 */
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 8d5a6cd6fb19..ceec771f8bfc 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -117,6 +117,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6190	0x1900
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6191	0x1910
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6185	0x1a70
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6220	0x2200
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6240	0x2400
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6250	0x2500
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6290	0x2900
-- 
2.22.0

