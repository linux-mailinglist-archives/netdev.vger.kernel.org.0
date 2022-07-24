Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B668757F772
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiGXWvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbiGXWvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:09 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD9FB4B7;
        Sun, 24 Jul 2022 15:51:08 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id va17so17581533ejb.0;
        Sun, 24 Jul 2022 15:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qstW+Qg+S9gNQTGK7khflNk1Z1N8MAj9afzYGf3Z1I0=;
        b=FGQDkQe2bg3I7wQsna+1SmBp7HtzdzZR3IuT+d1SyrWja96x9+rqfa2dRXHuO9jsY/
         eEPc7xWmJxa5V33uCdG5R2Gvd2ufpx+IXAbCdlzpoVZUQmjzusOUMbq7BX88sbIJylCP
         ClMBfBBO/JCWYHXl7A4Z39cIuxfFTFjeCjJWNd1j4zmi9ii7FAfEAUpR8/n5WlM/KluR
         oTU8hgMUXUoipORsHz+S9cfbTVd7ehRqHwLcjVn0Imn8OYfoyZ8NtV0oWijKFpIte3KT
         9UyNzH5EliELfon1uxH8oORLI68QxQgOJfDJiWBz+J5FwH2xPRdk6VFehqWL0C7fZLPw
         uUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qstW+Qg+S9gNQTGK7khflNk1Z1N8MAj9afzYGf3Z1I0=;
        b=V2PIRPBexS9DPPz31B6MvpFn+uw3R3pEiAFXXlPXYDo+fcAJZbT169uqy0QNDdKcLF
         PMORCmw6DR/mifzm+5ikTtXRdVIbSfj3JiUht6viXkxkl1S+j5aTfvCBGW4sUa04DT4u
         zCJP1DQ9IAtehP2W2qgaX6QAKog/JKV1YlLz4Y2Ex9qjpAouaFPN9AdHP+M0fkcXQyX2
         sO3ngZHTO5p1sY4gFRnG5BmzKMfoKILfBQyiyZEuKvyvRzcEPZJSCde3ouIFNOvKAx+n
         EoqND0fnHOfLb3LKuOAM4vP7iNuzri6db8UllqnzKZJFSINCJTsClwj3rHkbrCRFVbvY
         HZAA==
X-Gm-Message-State: AJIora/3N7zwFoXIuQVn4vDV8VGCSjdxBOgGK86k9MOWlx1o5YehIf85
        Vx9APU20rYODEnuBZKoIvQ0=
X-Google-Smtp-Source: AGRyM1u/X/vCukAS2qQS8cFvKW/ThenCu8o1jtG0uiH9+wOgp7YtFT5L6mbGLHkacxEw3yatclHfrA==
X-Received: by 2002:a17:906:4fd6:b0:70c:9284:cc01 with SMTP id i22-20020a1709064fd600b0070c9284cc01mr7801221ejw.553.1658703066889;
        Sun, 24 Jul 2022 15:51:06 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:06 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [net-next PATCH v4 02/14] net: dsa: qca8k: make mib autocast feature optional
Date:   Sun, 24 Jul 2022 22:19:26 +0200
Message-Id: <20220724201938.17387-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724201938.17387-1-ansuelsmth@gmail.com>
References: <20220724201938.17387-1-ansuelsmth@gmail.com>
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
index 212b284f9f73..5d3c3c95ef88 100644
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

