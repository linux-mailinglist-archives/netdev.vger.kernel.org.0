Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155F857EF7A
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbiGWOTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237506AbiGWOTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:30 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3364186E4;
        Sat, 23 Jul 2022 07:19:28 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r1-20020a05600c35c100b003a326685e7cso5590611wmq.1;
        Sat, 23 Jul 2022 07:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=37/7ePh/T5++KXXD1fvoH1H5M1HaiK+Edb8PgQNZiY0=;
        b=ZDaCqk/oPuNFaMRQ/CYuRou+nyJk14sCULDdWsS2k8w5Pb9as5cJem/bCwdk2cf017
         0BzG2ElxCsje58PDRrddB6f31QeZj7KlvM7R2Kiy4id9DOF4IaqWwfL5PO1bIky8/DzY
         WowjXA39iDdqyz7w3h8064dmBO4vFD8VYS5kvp2eJdNn/JbRcxPx85p8FOru+2YN/8u1
         ytAp7M3BSr3a/oP3X7S2SOJkeHvCOzXVNJJ+H8UqFWjLYxGln/H6DF4bbMpe/vwk+mcL
         vDD4aeBnZrrshcetzyynY+yVQqoE4nK4R1q2LpUij9AMqBkdFeqAI0tGuVwbOq2TYtJJ
         t5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37/7ePh/T5++KXXD1fvoH1H5M1HaiK+Edb8PgQNZiY0=;
        b=fjd6kVxTSkR5TekQmuCXJbE4gAekKvwDX3VK0CwhqNp2znfmjq4UG0KRBU3c0SXK2C
         DIDyqCfxHNEwLNQy+l5lF9Nsgj2TrHfTKJha7OqdQ2jbw2EDz7bIvgjUna0Tlr3QXHul
         nx5EeSmVmBDABpfmTIJBm0PffU1e9GMUC8cOL9rMYDDzkWWwSIRm7+SA5w9W/Dx5MgII
         XZoNsZtWuwWc51BSer/Zc2rXoiSv9w3ehIAhBcIzgq35xgBkIyCgRTT7MmdVK7rNE+pO
         uSlXmW1tza+r7nA4iGmDcjAUzVMznK7WpVjkfx4q5XYAxZl8MSNPJJJW30AVlScDHwh0
         Sjfw==
X-Gm-Message-State: AJIora9WVgCb3oQB+NXXnxi+qQ25q4I9WFdn/kU0cqOaWBcRCaM+1KHb
        MrS8ANSrSEpxyoEbYi0csAVoaTB28BI=
X-Google-Smtp-Source: AGRyM1u41bt3CG6a7gh61xaRSux525fBvW5dwEDVXFbxfw8xSU79evOoUT1RJvXLk2bEG0+w94iA4g==
X-Received: by 2002:a05:600c:35c7:b0:3a3:2612:f823 with SMTP id r7-20020a05600c35c700b003a32612f823mr3087301wmq.33.1658585967094;
        Sat, 23 Jul 2022 07:19:27 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:26 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v3 02/14] net: dsa: qca8k: make mib autocast feature optional
Date:   Sat, 23 Jul 2022 16:18:33 +0200
Message-Id: <20220723141845.10570-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220723141845.10570-1-ansuelsmth@gmail.com>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
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
it using match_data struct in a dedicated qca8k_info_ops struct.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k.c | 11 +++++++++--
 drivers/net/dsa/qca/qca8k.h |  5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index 212b284f9f73..9820c5942d2a 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -2104,8 +2104,8 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
-	if (priv->mgmt_master &&
-	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
+	if (priv->mgmt_master && priv->info->ops.autocast_mib &&
+	    priv->info->ops.autocast_mib(ds, port, data) > 0)
 		return;
 
 	for (i = 0; i < priv->info->mib_count; i++) {
@@ -3248,20 +3248,27 @@ static int qca8k_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 			 qca8k_suspend, qca8k_resume);
 
+static const struct qca8k_info_ops qca8xxx_ops = {
+	.autocast_mib = qca8k_get_ethtool_stats_eth,
+};
+
 static const struct qca8k_match_data qca8327 = {
 	.id = QCA8K_ID_QCA8327,
 	.reduced_package = true,
 	.mib_count = QCA8K_QCA832X_MIB_COUNT,
+	.ops = qca8xxx_ops,
 };
 
 static const struct qca8k_match_data qca8328 = {
 	.id = QCA8K_ID_QCA8327,
 	.mib_count = QCA8K_QCA832X_MIB_COUNT,
+	.ops = qca8xxx_ops,
 };
 
 static const struct qca8k_match_data qca833x = {
 	.id = QCA8K_ID_QCA8337,
 	.mib_count = QCA8K_QCA833X_MIB_COUNT,
+	.ops = qca8xxx_ops,
 };
 
 static const struct of_device_id qca8k_of_match[] = {
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 0b990b46890a..7b4a698f092a 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -324,10 +324,15 @@ enum qca8k_mid_cmd {
 	QCA8K_MIB_CAST = 3,
 };
 
+struct qca8k_info_ops {
+	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
+};
+
 struct qca8k_match_data {
 	u8 id;
 	bool reduced_package;
 	u8 mib_count;
+	struct qca8k_info_ops ops;
 };
 
 enum {
-- 
2.36.1

