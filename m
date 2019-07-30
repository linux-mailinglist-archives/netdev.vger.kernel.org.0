Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB77A598
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732379AbfG3KGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:06:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41228 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbfG3KGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:06:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so61877976wrm.8;
        Tue, 30 Jul 2019 03:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UEcJqLpqdxHugh4FbCpqHOccSMWmtWE+74vZ1X+ixP4=;
        b=OPoUT9BalTsSlqwWeigYMwb34ZoCBtcARK9YTsUWnuTww7Pgs+q+sEoLKrxR+LVzfW
         QGVVA9LQ+speC/ahB1CcFHBd7b9yIQG6K4lKYvBXAV54pT2fPQ0rc2Ru+ql0xpd4Sued
         zHJh3uTUxOKAxTJLP8aYpun/WGf6jPi/+kOSmYjZLIUfVXYkc0H9XA0t+5Dx11a+6A2d
         e3V5A1tmScfnwY0ea6kZqp4Twj7SF3dhERL7cl88/ioQfkoABghOC4zNW4bVJT9dP86E
         VL/Bt0+b32wr+++vvcPfO0k8yI0/Qwdhmf/uBEE7BXwe9GEBnAqSYxea4H4/zDEQSlHJ
         wq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UEcJqLpqdxHugh4FbCpqHOccSMWmtWE+74vZ1X+ixP4=;
        b=Yx/9RwrFRmPEDYZNCwJcckkfpys5XH9lyrd5+xkGluIES/gX41n/L1jEp8VW0S9qbM
         gyxXRL0utwIIMwhpV4Vh06qr73GyRcS35BiYApwNcJ9gIS7eYHZ6VO8nPGYFP7py3ZZx
         PR9Q9mWY4Nzz5nCmRI8JKSe5B1RZcm3YdBWCeFfcPvRSXaF0s+mbYoe7Isu+ywVuxKai
         tAtX8ardnrExY8M0qk5h262ZbKnn9sL8TAD+ghcDu21npzCFz29O6ACB2YM2qd6BuYaF
         KIAUTitxZ4KLSEdF0xPVxmiChnHvJ0Mg+8xAqiI2D5NEXUQYuW6Nkh9jwBLg6doUqAIB
         xkMw==
X-Gm-Message-State: APjAAAVqW77fjiXl9ogJdJq0uaPeVGejZPR2YPKVGufvyffLkloPxCBM
        vY/oqxxk8Hk+h7R4HV9LwOpgz+ZBONs=
X-Google-Smtp-Source: APXvYqygSvOCoJZVpItyoofLlvPQGGZYG7h5++9O4ATiM0PUYGEcxhR62K3CqifMLOOpYvn6R5Oa7g==
X-Received: by 2002:a5d:494d:: with SMTP id r13mr53013044wrs.152.1564481158990;
        Tue, 30 Jul 2019 03:05:58 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id n9sm108236322wrp.54.2019.07.30.03.05.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:05:58 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 1/4] net: dsa: mv88e6xxx: add support for MV88E6220
Date:   Tue, 30 Jul 2019 12:04:26 +0200
Message-Id: <20190730100429.32479-2-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190730100429.32479-1-h.feurstein@gmail.com>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
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
index 6b17cd961d06..c4982ced908e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4283,6 +4283,31 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ops = &mv88e6240_ops,
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
 	[MV88E6250] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6250,
 		.family = MV88E6XXX_FAMILY_6250,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 4646e46d47f2..6eb13f269366 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -58,6 +58,7 @@ enum mv88e6xxx_model {
 	MV88E6190X,
 	MV88E6191,
 	MV88E6240,
+	MV88E6220,
 	MV88E6250,
 	MV88E6290,
 	MV88E6320,
@@ -77,7 +78,7 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6097,	/* 6046 6085 6096 6097 */
 	MV88E6XXX_FAMILY_6165,	/* 6123 6161 6165 */
 	MV88E6XXX_FAMILY_6185,	/* 6108 6121 6122 6131 6152 6155 6182 6185 */
-	MV88E6XXX_FAMILY_6250,	/* 6250 */
+	MV88E6XXX_FAMILY_6250,	/* 6220, 6250 */
 	MV88E6XXX_FAMILY_6320,	/* 6320 6321 */
 	MV88E6XXX_FAMILY_6341,	/* 6141 6341 */
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 8d5a6cd6fb19..141df2988cd1 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -118,6 +118,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6191	0x1910
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6185	0x1a70
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6240	0x2400
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6220	0x2200
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6250	0x2500
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6290	0x2900
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6321	0x3100
-- 
2.22.0

