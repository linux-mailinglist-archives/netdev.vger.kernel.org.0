Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6416D67BCA9
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbjAYUfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjAYUfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:35:30 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFDC59B58;
        Wed, 25 Jan 2023 12:35:28 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so3040402wmq.1;
        Wed, 25 Jan 2023 12:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=gXJuscVXtoom2L5eIz6fHi/T4TIx0FROKAOr5k8KwcM=;
        b=S+KVg3ZQW7Zf3o2SBsaMm/CUFBvQTpO4N/jg6buCYAXYcSAUwEnGynQUs8xLSnHsfV
         mo67XZMrfv/biOYiTdAeK+O+2mXpkE42UhmKDonYK0RAd2ko3Iq5vSpbAOg0IZIBU1kL
         PiILJvnXf9TEiGunfCwj7wCxNNgzmrVYCM7qgMdc59SomnhjpOtfIKTs4sQQz8UB44Tv
         okr6G/px3nr9TGrx2opdnvERXLf6lvFOspiy5+AtyTU3OPHbqHhHoPyawYPk9irv2Qk3
         MPaUSzrhW7MtrUFryteZnJetiYu2LQ6Kogt7mq/L7zALK33CEid9cELvvDKvdEpxf4Y9
         cXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gXJuscVXtoom2L5eIz6fHi/T4TIx0FROKAOr5k8KwcM=;
        b=jhdzdTeuzjdvdz1MTsiT6ERT9WBsHor9BVzRqUWLnCm83xmynSDrpejYmHM6zBpWXa
         rhzf6yZiT3eIzwqSv34NxKIISOfpEgEoYUB35dCeSNAhSkSbpIVfk6OV70XNzSoUJ5By
         lUllk8AyEWfB0NoAJBz2FP5gs2uM65Oh+bTsp+3tIY+O/9g0M75bcJYZOxSkkZiocf9e
         yQ5sUKl612cAJptJu395lAruKcZh9xHUIfFBYX0eyNYTHe8K2Pelln7x/LK/4gj3Qwvz
         IVfv4gT66BfPnUajNNwec8i5ChdcsSUAbpRYsqqZNfhH2j2H7+OmXTSLRwPdHJLcub+m
         jwng==
X-Gm-Message-State: AFqh2kqMn8YrgaFdK2sCU8Bfhl5iQQU6V/Hz4TuG3bpmKhDV017XnR2s
        tqP8ssZG1sLL8XrVgpIZFKI=
X-Google-Smtp-Source: AMrXdXv9OT7EqK5hm7khekO8qQqvwWVRXPEad2q7oGi2S7IcgEAPNBytZIDIvEB6hxhSvd/oGSBL8A==
X-Received: by 2002:a05:600c:4fc6:b0:3dc:d5c:76d9 with SMTP id o6-20020a05600c4fc600b003dc0d5c76d9mr8354190wmq.0.1674678927223;
        Wed, 25 Jan 2023 12:35:27 -0800 (PST)
Received: from localhost.localdomain (93-34-89-61.ip49.fastwebnet.it. [93.34.89.61])
        by smtp.googlemail.com with ESMTPSA id x26-20020a1c7c1a000000b003db01178b62sm2733566wmc.40.2023.01.25.12.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:35:26 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v3 1/2] net: dsa: qca8k: add QCA8K_ATU_TABLE_SIZE define for fdb access
Date:   Wed, 25 Jan 2023 21:35:16 +0100
Message-Id: <20230125203517.947-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Add and use QCA8K_ATU_TABLE_SIZE instead of hardcoding the ATU size with
a pure number and using sizeof on the array.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---

v3:
- Add patch

 drivers/net/dsa/qca/qca8k-common.c | 10 ++++++----
 drivers/net/dsa/qca/qca8k.h        |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index fb45b598847b..2f82a8dae9ff 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -150,11 +150,12 @@ static int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 
 static int qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 {
-	u32 reg[3];
+	u32 reg[QCA8K_ATU_TABLE_SIZE];
 	int ret;
 
 	/* load the ARL table into an array */
-	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg,
+			      QCA8K_ATU_TABLE_SIZE * sizeof(u32));
 	if (ret)
 		return ret;
 
@@ -178,7 +179,7 @@ static int qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 static void qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask,
 			    const u8 *mac, u8 aging)
 {
-	u32 reg[3] = { 0 };
+	u32 reg[QCA8K_ATU_TABLE_SIZE] = { 0 };
 
 	/* vid - 83:72 */
 	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
@@ -195,7 +196,8 @@ static void qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask,
 	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
 
 	/* load the array into the ARL table */
-	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg,
+			 QCA8K_ATU_TABLE_SIZE * sizeof(u32));
 }
 
 static int qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd,
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 03514f7a20be..593a882ec43c 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -148,6 +148,8 @@
 #define QCA8K_REG_IPV4_PRI_ADDR_MASK			0x474
 
 /* Lookup registers */
+#define QCA8K_ATU_TABLE_SIZE				3 /* 12 bytes wide table / sizeof(u32) */
+
 #define QCA8K_REG_ATU_DATA0				0x600
 #define   QCA8K_ATU_ADDR2_MASK				GENMASK(31, 24)
 #define   QCA8K_ATU_ADDR3_MASK				GENMASK(23, 16)
-- 
2.38.1

