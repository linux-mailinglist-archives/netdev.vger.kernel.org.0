Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF81578FA5
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiGSBPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiGSBPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:11 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E0F60C1;
        Mon, 18 Jul 2022 18:15:10 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v16so19413610wrd.13;
        Mon, 18 Jul 2022 18:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8slgO2yeIuaKk16uW5SmfF0XwVi0tona7Qv+KwwosXU=;
        b=ajrAR6Wjk9ocqkcBbgmPIRbXrewFXUzpM31kA6hbEV3zdVKEVVzIlZoM2ZgM3r0U0B
         ZybrwC8+SujUnEd9FpJasMCNx1BCyOElPE728i4sdeyfCngPGTifX7aN2Yt0vMy7xATi
         kHAf3dr/YRCYJ6N+EINi0fQmV0pic8CNZJlJ6itmkzuhyPjTL+uxktAacgl9E7TPezCl
         GLhRj4GETjiWWizm0S/ErZSn/vetjiAmg4wYuNXty7DaMp6+D1FNZHuLFDHziVgIle3D
         UvDRy7xAjwEOoiIyJnULROESiuPm98MU3Yc6GkAUu8EqRxs8k8hb0pR1zqF3y50W4/3s
         uJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8slgO2yeIuaKk16uW5SmfF0XwVi0tona7Qv+KwwosXU=;
        b=24wJPegJJEvbWOTmThORjtbPfi5CGy23NxufQQO3C0NYZiDcFomxG88Njqp5xRzUB4
         Ut14pfdGw+f2MNdNoDoGtRP9R5YHeUqFtEt7d/IjIYDLkCDTnpL3XjTCzdLsrikJAtsA
         dxa1FapEyEdVhew3y50q+9/IeEW0bfqmHwKB0NhTIx8G4xlZoqxeMlS3N1wKc2jpKJgl
         xFc7mXoZxDbEYgRbk+YU6DEsRlUVY0o1Nrr5yNGMJU9kMqs9wQBl1s0wLr02L5w4NB7N
         uR5ZMvC1PyIvrgTEoE/1+R7d4mud1TtM4NuB16MpkFbApziQ99c99qYvr1PKiRJ64Zc4
         ZSeg==
X-Gm-Message-State: AJIora98gOaZfSHXo9f4WywVcahhoG1p/abjxTYsnviaokHFZLF2+wRp
        ZfKlF/C7+CG/ynmmwaXUe5M=
X-Google-Smtp-Source: AGRyM1u0TD1hqEOLqZOLe5/m2IixcHXmt9uuyqE8rCmrYVEG7Dcvnxdjyf63jg7oQ46tvoms0gzT7g==
X-Received: by 2002:a05:6000:10c1:b0:21d:76e0:c6de with SMTP id b1-20020a05600010c100b0021d76e0c6demr23992955wrx.623.1658193308400;
        Mon, 18 Jul 2022 18:15:08 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:08 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v2 01/15] net: dsa: qca8k: make mib autocast feature optional
Date:   Tue, 19 Jul 2022 02:57:11 +0200
Message-Id: <20220719005726.8739-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719005726.8739-1-ansuelsmth@gmail.com>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
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

Some switch may not support mib autocast feature and require the legacy
way of reading the regs directly.
Make the mib autocast feature optional and permit to declare support for
it using match_data struct.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k.c | 11 +++++++----
 drivers/net/dsa/qca/qca8k.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index 1cbb05b0323f..a57c53ce2f0c 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -2112,12 +2112,12 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
-	if (priv->mgmt_master &&
-	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
-		return;
-
 	match_data = of_device_get_match_data(priv->dev);
 
+	if (priv->mgmt_master && match_data->autocast_mib &&
+	    match_data->autocast_mib(ds, port, data) > 0)
+		return;
+
 	for (i = 0; i < match_data->mib_count; i++) {
 		mib = &ar8327_mib[i];
 		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
@@ -3260,16 +3260,19 @@ static const struct qca8k_match_data qca8327 = {
 	.id = QCA8K_ID_QCA8327,
 	.reduced_package = true,
 	.mib_count = QCA8K_QCA832X_MIB_COUNT,
+	.autocast_mib = qca8k_get_ethtool_stats_eth,
 };
 
 static const struct qca8k_match_data qca8328 = {
 	.id = QCA8K_ID_QCA8327,
 	.mib_count = QCA8K_QCA832X_MIB_COUNT,
+	.autocast_mib = qca8k_get_ethtool_stats_eth,
 };
 
 static const struct qca8k_match_data qca833x = {
 	.id = QCA8K_ID_QCA8337,
 	.mib_count = QCA8K_QCA833X_MIB_COUNT,
+	.autocast_mib = qca8k_get_ethtool_stats_eth,
 };
 
 static const struct of_device_id qca8k_of_match[] = {
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index ec58d0e80a70..c3df0a56cda4 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -328,6 +328,7 @@ struct qca8k_match_data {
 	u8 id;
 	bool reduced_package;
 	u8 mib_count;
+	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
 };
 
 enum {
-- 
2.36.1

