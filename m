Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B41558E8B9
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiHJI2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiHJI2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:28:04 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E24661D95
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:28:02 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gb36so26333552ejc.10
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Fa0B6g0EONnRwq1uJtr20gDG6yuJ1sIx75+pqDLhzeI=;
        b=I8pM/ZQGXOTLqhm7ZLVLN3g0J86oxioIfucsaAVHk4UpCNoBb0Pqa5FBV9DDpOBmmR
         s0d8cKO0oAmPQ+gj9JCE6BR588HR7EepFFVSpdg1zNU5ui5dQAeLgJXJ+jYOMwJwy28i
         TQIImdkMsLVeCL0wjSSt41/egZ/cfpoakdTK18yZVF03o2F3Y80mEDvIkbZe9RDJqLJV
         6Wb8gv10n23/C2n6cZxZhgp6IDKTYURQg64vFwfjnbnPecyXKJS/IYAgfExNqhB5k6kc
         auczfZYUhm4ain8MuAy5iEX2tnC9cNp3vV6WGkYX8pfnc/9pXU/B9PHlL25fB9R6o7mw
         1sFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Fa0B6g0EONnRwq1uJtr20gDG6yuJ1sIx75+pqDLhzeI=;
        b=k4QpfJwaM02465XGrne5rAn8/+p+MAvFtL/W2Gkxm4Lro9xV8wGYXgGbon3I81s6io
         Xt4DQ52dz7QGMYQSqmS+X0QT6QRfQBvMbVp/6YkaviRuNEcoMDXqmBYLcCIiSjBnbZDR
         BKnG7KYq5wDlqYiFerg06Jf/R4UKZEfiKG6tP5/yyVc0q3gea9L3ffs9L2nPG12jrF7t
         LNApI+IB0ooMKbsRL7ZsIvwZQnpAM1o1cunN3iyuHtUNhbIs4MslvudLfLmiLQE4Y4ph
         MYRHdGoN32fqwGJJBEUyvfbGRY+J82DF4IfDJXEKuJPAB2kcWM1PgV2J5RB1BYE6tMPH
         qlqA==
X-Gm-Message-State: ACgBeo1ydwD3Zv2rcojTek/JXivddF/Taf1KWWOQLnxulRExYBNgjvhQ
        PGW7wf5uoUqCPJ8yuGJVNnHi4Tp734AQew==
X-Google-Smtp-Source: AA6agR4wvCHaekT+1arIbyXYz4OE4n5pZ8pQ4WguVpkZ+woRUx+6pf5S4DlPUQZsFrWFucvvuZnBLQ==
X-Received: by 2002:a17:906:ef8b:b0:730:d348:61b9 with SMTP id ze11-20020a170906ef8b00b00730d34861b9mr19520411ejb.350.1660120080881;
        Wed, 10 Aug 2022 01:28:00 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:f682:a160:7363:c1c9])
        by smtp.gmail.com with ESMTPSA id d25-20020aa7d699000000b0043cedad30a5sm7298383edr.21.2022.08.10.01.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 01:28:00 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] net: dsa: mv88e6060: report max mtu 1536
Date:   Wed, 10 Aug 2022 11:27:45 +0300
Message-Id: <20220810082745.1466895-1-saproj@gmail.com>
X-Mailer: git-send-email 2.32.0
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

This driver sets the MaxFrameSize bit to 1 during setup,
see GLOBAL_CONTROL_MAX_FRAME_1536 in mv88e6060_setup_global().
Thus MTU is always 1536.
Introduce mv88e6060_port_max_mtu() to report it back to system.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
CC: Vladimir Oltean <olteanv@gmail.com>
CC: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6060.c | 7 ++++++-
 drivers/net/dsa/mv88e6060.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
index a4c6eb9a52d0..c53734379b96 100644
--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -160,7 +160,6 @@ static int mv88e6060_setup_addr(struct mv88e6060_priv *priv)
 	u16 val;
 
 	eth_random_addr(addr);
-
 	val = addr[0] << 8 | addr[1];
 
 	/* The multicast bit is always transmitted as a zero, so the switch uses
@@ -212,6 +211,11 @@ static int mv88e6060_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static int mv88e6060_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return MV88E6060_MAX_MTU;
+}
+
 static int mv88e6060_port_to_phy_addr(int port)
 {
 	if (port >= 0 && port < MV88E6060_PORTS)
@@ -247,6 +251,7 @@ mv88e6060_phy_write(struct dsa_switch *ds, int port, int regnum, u16 val)
 static const struct dsa_switch_ops mv88e6060_switch_ops = {
 	.get_tag_protocol = mv88e6060_get_tag_protocol,
 	.setup		= mv88e6060_setup,
+	.port_max_mtu	= mv88e6060_port_max_mtu,
 	.phy_read	= mv88e6060_phy_read,
 	.phy_write	= mv88e6060_phy_write,
 };
diff --git a/drivers/net/dsa/mv88e6060.h b/drivers/net/dsa/mv88e6060.h
index 6c13c2421b64..382fe462fb2d 100644
--- a/drivers/net/dsa/mv88e6060.h
+++ b/drivers/net/dsa/mv88e6060.h
@@ -11,6 +11,7 @@
 #define __MV88E6060_H
 
 #define MV88E6060_PORTS	6
+#define MV88E6060_MAX_MTU	1536
 
 #define REG_PORT(p)		(0x8 + (p))
 #define PORT_STATUS		0x00
-- 
2.32.0

