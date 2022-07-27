Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66E858259F
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiG0Lfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiG0Lfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:35:44 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDAA22BF6;
        Wed, 27 Jul 2022 04:35:43 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id va17so31025478ejb.0;
        Wed, 27 Jul 2022 04:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sNqTA0oWi6iXoa/GYh8KRNnexiAM13SjCjf2PvKtOAY=;
        b=JQaMVrQW+baii0uiMpWfRXUyB/PPyyP5stykeJ9P/xIx67RYEVPCsVFibvYuj20/PA
         S8Ac5xY4wvzIz6MPoa40L4tbMRu+B1jd9DogoE0Hc8rAmM7CdjB3L0wuVRDF8HE0VjQh
         As3PqqAlLp9axp6aUIQSAzaq7S95ka5hqUngj2ezofkrhQci8eu8Vvyf5Oo16eDoHzxO
         VCKumYwJDcymB3JSeAE2bnp0AxA/z6RiiIkkkZg+CyioZ1IdohF40Z4X5Sm05rVrAkX7
         1E2I7il4ZiGOqv8jdGC+c2TunZNsY5ligSf9ELPmSBgFx9x5k548SmyoXHKlL4wuo0UQ
         I7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sNqTA0oWi6iXoa/GYh8KRNnexiAM13SjCjf2PvKtOAY=;
        b=TSqdeZjKXZxqqqYyj0SAZ8QJEZULoo0/fvpFGkXLlPsBDGnmrIkMMyZjrZxafkAKNt
         Pk3FgZNFKBTR77w7KsBXza363aQMlJxOrsBqMv3iuNLth6t4D50HN8atvey8ummvRz4k
         3nqLoc9pg6ujV243jCb6nRh8ekbfuD62NxnH9oOiAd/MR/5jzJp79lrWy0AUXXP1EETB
         8kIgDhCkP80DNKjYpvTnOsatp+d10FEHh6cUGkFNx5e7ON41j78v3i501PO7A+poUbxZ
         kiA1wMpjeWWADQc1sU+KSx5GXsd5ypuwK9aeYhgGAfKRPf0pPWTlpFcv+miYaWBPKIIL
         vSaA==
X-Gm-Message-State: AJIora9IiaHM8LVnM2XG9v3x/gxoNs5cQP/QqHX43HnovxDHT01BypVX
        k7hiskY9NcV5HaFVvsp9hd8=
X-Google-Smtp-Source: AGRyM1vhgjZmeYKXxUUdqX7cHswmriGf/ZPxPxrN+LhCM1ZWIsLeFC8KhiuXf48SzXUyLtzxgjFK1w==
X-Received: by 2002:a17:907:2856:b0:72b:8e8e:3d9 with SMTP id el22-20020a170907285600b0072b8e8e03d9mr17455860ejc.0.1658921741920;
        Wed, 27 Jul 2022 04:35:41 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:41 -0700 (PDT)
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
Subject: [net-next PATCH v5 02/14] net: dsa: qca8k: make mib autocast feature optional
Date:   Wed, 27 Jul 2022 13:35:11 +0200
Message-Id: <20220727113523.19742-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727113523.19742-1-ansuelsmth@gmail.com>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
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
index 64524a721221..02a4765f267e 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -2104,8 +2104,8 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
-	if (priv->mgmt_master &&
-	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
+	if (priv->mgmt_master && priv->info->ops->autocast_mib &&
+	    priv->info->ops->autocast_mib(ds, port, data) > 0)
 		return;
 
 	for (i = 0; i < priv->info->mib_count; i++) {
@@ -3243,20 +3243,27 @@ static int qca8k_resume(struct device *dev)
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
+	.ops = &qca8xxx_ops,
 };
 
 static const struct qca8k_match_data qca8328 = {
 	.id = QCA8K_ID_QCA8327,
 	.mib_count = QCA8K_QCA832X_MIB_COUNT,
+	.ops = &qca8xxx_ops,
 };
 
 static const struct qca8k_match_data qca833x = {
 	.id = QCA8K_ID_QCA8337,
 	.mib_count = QCA8K_QCA833X_MIB_COUNT,
+	.ops = &qca8xxx_ops,
 };
 
 static const struct of_device_id qca8k_of_match[] = {
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 0b990b46890a..377ce8c72914 100644
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
+	const struct qca8k_info_ops *ops;
 };
 
 enum {
-- 
2.36.1

