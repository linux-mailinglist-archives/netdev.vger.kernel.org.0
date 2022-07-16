Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0CD57707D
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 19:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiGPRuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 13:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiGPRue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 13:50:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDFD1D0CF;
        Sat, 16 Jul 2022 10:50:33 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l68so4597006wml.3;
        Sat, 16 Jul 2022 10:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7vXchobVIzGaJEwUA2pO21OnxTUgLKN30nvg+mcRjk0=;
        b=SFu6tqywaCfksRFRQ5EAGzJTWXnROYEVJipLaKK59mo761gyWyVjQatNxL3Ir3sQxj
         YEXVWUJo/VY4HTV+0nCjSxIgC7YKhENcqXTW2MRdI6LgJeoBApDdci00HG8QBJe9maCp
         lo249tMW1Aq2Zv9PALEM42IO08jVUokbhy4jVMcpJeZkDE+HKWIqgn7xtEYPVf7f9YUX
         DOyFchEvsz1P/J65tCn8HGrDDb/UZgrCDsMjSSK7Dmwz0gjwTJFyzgRSaOUmzOODgRfm
         t1tWd80V19Alc1M61zAD8HH2lKX1CifR25ObaX/yXYEJE/aShEjkVSy8Oo8mGZG+8gnH
         4Jig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7vXchobVIzGaJEwUA2pO21OnxTUgLKN30nvg+mcRjk0=;
        b=xEAHNmWdY0B2/wPwLc2AAD7yKoUrB3CqH3TA1lWefws7abP9FZFfuwp59gKHDP64jP
         9PRzzkv1fmUhJG1HrOL8zT1+e8WhHd/rUa+JBa3hvWyfR7HomcfV+lxDHEBGhb3koygQ
         Akn/G5qiLl8LM7GAbACsniuxaiYkHdIaEG0suv75okIIoVlQg4qjOahqNxisWmZeI+CA
         dQI9Yh6MWzTz50/L7mIMU4ONN5TiIt5oebtTsynHax54JUnRsy/nuYfCMgw3Tsjipcm3
         ZoZAVG2utFZO90rVRTiQ0+3FFKaBwpNKB9ltMUtNyTut9ibTg/zJx8EtuBDHmVmUGjQP
         3AJQ==
X-Gm-Message-State: AJIora9dOhm44nknZGE3ymZx5I3GCa3FuZeEgCIUX7Wui9PCecXoFFF6
        DjC2Yq2rkQ97XHVJ5wm63C8=
X-Google-Smtp-Source: AGRyM1vvtjE1Sm1TAeNm1gZFpK46VoPUbQ4q9T3zk5HUcODZdrLGweV8UAd1kBuosyuwK7ErAY/Jrw==
X-Received: by 2002:a7b:cb05:0:b0:3a1:8add:aaa5 with SMTP id u5-20020a7bcb05000000b003a18addaaa5mr25287615wmj.13.1657993831865;
        Sat, 16 Jul 2022 10:50:31 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id s6-20020adfecc6000000b0021d74906683sm6836108wro.28.2022.07.16.10.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 10:50:31 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next RFC PATCH 3/4] net: dsa: qca8k: rework mib autocast handling
Date:   Sat, 16 Jul 2022 19:49:57 +0200
Message-Id: <20220716174958.22542-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220716174958.22542-1-ansuelsmth@gmail.com>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
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

In preparation for code split, move the autocast mib function used to
receive mib data from eth packet in priv struct and use that in
get_ethtool_stats instead of referencing the function directly. This is
needed as the get_ethtool_stats function will be moved to a common file.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k.c | 7 +++++--
 drivers/net/dsa/qca/qca8k.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index fd738d718cd6..e527d15d5065 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -2109,8 +2109,8 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
-	if (priv->mgmt_master &&
-	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
+	if (priv->mgmt_master && priv->autocast_mib &&
+	    priv->autocast_mib(ds, port, data) > 0)
 		return;
 
 	match_data = of_device_get_match_data(priv->dev);
@@ -3177,6 +3177,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	mutex_init(&priv->mib_eth_data.mutex);
 	init_completion(&priv->mib_eth_data.rw_done);
 
+	/* Assign autocast_mib function as it's supported by this switch */
+	priv->autocast_mib = &qca8k_get_ethtool_stats_eth;
+
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
 	priv->ds->priv = priv;
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 22ece14e06dc..a306638a7100 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -403,6 +403,7 @@ struct qca8k_priv {
 	struct qca8k_mdio_cache mdio_cache;
 	struct qca8k_pcs pcs_port_0;
 	struct qca8k_pcs pcs_port_6;
+	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
 };
 
 struct qca8k_mib_desc {
-- 
2.36.1

