Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D9F52C5F0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiERWFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiERWEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:04:30 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC35D5DBCB;
        Wed, 18 May 2022 15:01:20 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id wh22so6243652ejb.7;
        Wed, 18 May 2022 15:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4MA9rL+NU5i49GzNZ6NnsLkOYe+sC2puAxmvZM/H6Yo=;
        b=mVD+sNrl71aKSE4n8i+Ev8RM54Adnlcz6sWuA9ZFr2FZZkDEt5uuWMhBO9gzTlBw2h
         yz0oTx5CQQwEAJ09Dg4NsmTbNRmtUBc2CucdYj2JrkPCwJEZ08jZ7owIDy3Jclw8qwjQ
         mqenCkXcmiXo7I2H/65PDRzG9Ud3KeHzsK7voIqPsiA/lnCyV4TpNAC471OpP8dWLXUY
         g7YabD5WF5D4ygteuHCl32aH3+h3kpu65Tp+He6Vxs8F+jKp2K0LxOgA3SbxfrhpmN2o
         bm60TghigV1VYQRPkJoyQtOW6Evs6Ic8bOL0WYx8RQW/NU2uLQHV7vwMNTuOFks0TmVx
         P09g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4MA9rL+NU5i49GzNZ6NnsLkOYe+sC2puAxmvZM/H6Yo=;
        b=g+9MaF0W++i7ZCeRPhhmzIQJDumLft1WFofJFFOOpFx2XGmnB7p+jUKThNct3PxHm3
         J3HjmLGVYThuEqYIC7EA0MXaVyGRkdWwCFiO2E/sWUo4OGlQROsrsIebYnJ2PAOMb00T
         rkP9G0zIGGlqkXXP7JVDw/+ILG1VYGfXLwKEF2jYIR2oXvfKZ5yn1WkXFpFxveHm9Ctr
         HkhYtJeDTNMx5PkUbKUV5mMYRN0jzh51HYUr60XqsafmTE8nPbAI3yAYhpBjGLRsNy/3
         jmUYuxkuzXEOzVcqBg08psU+U2u11ESkBPYtdr1RPzMtEuFfnF1jhIsE2/R+OByYPXOB
         gHxQ==
X-Gm-Message-State: AOAM533BFozW+dN2MDxoIK3GeUvpY3Z/LXXYQJNko32/7DQTidR7oVNW
        GZhqJXNRQvD4in8OH3LBG2TXduhiHDg=
X-Google-Smtp-Source: ABdhPJxnGdDumOEIBOGw/tZktEKPXF/kbNT9UxING++0zGZRedYLoleFQNqtdgW+LV4a4oXxe+QcMg==
X-Received: by 2002:a17:907:6d82:b0:6f4:d62e:8168 with SMTP id sb2-20020a1709076d8200b006f4d62e8168mr1506638ejc.374.1652911279202;
        Wed, 18 May 2022 15:01:19 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-118-099-170.95.118.pool.telefonica.de. [95.118.99.170])
        by smtp.googlemail.com with ESMTPSA id ot2-20020a170906ccc200b006f3ef214dd0sm1478885ejb.54.2022.05.18.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 15:01:18 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH net-next v2 1/2] net: dsa: lantiq_gswip: Fix start index in gswip_port_fdb()
Date:   Thu, 19 May 2022 00:00:50 +0200
Message-Id: <20220518220051.1520023-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518220051.1520023-1-martin.blumenstingl@googlemail.com>
References: <20220518220051.1520023-1-martin.blumenstingl@googlemail.com>
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

The first N entries in priv->vlans are reserved for managing ports which
are not part of a bridge. Use priv->hw_info->max_ports to consistently
access per-bridge entries at index 7. Starting at
priv->hw_info->cpu_port (6) is harmless in this case because
priv->vlan[6].bridge is always NULL so the comparison result is always
false (which results in this entry being skipped).

Fixes: 58c59ef9e930c4 ("net: dsa: lantiq: Add Forwarding Database access")
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 12c15da55664..0c313db23451 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1360,7 +1360,7 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 	struct net_device *bridge = dsa_port_bridge_dev_get(dsa_to_port(ds, port));
 	struct gswip_priv *priv = ds->priv;
 	struct gswip_pce_table_entry mac_bridge = {0,};
-	unsigned int cpu_port = priv->hw_info->cpu_port;
+	unsigned int max_ports = priv->hw_info->max_ports;
 	int fid = -1;
 	int i;
 	int err;
@@ -1368,7 +1368,7 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 	if (!bridge)
 		return -EINVAL;
 
-	for (i = cpu_port; i < ARRAY_SIZE(priv->vlans); i++) {
+	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
 		if (priv->vlans[i].bridge == bridge) {
 			fid = priv->vlans[i].fid;
 			break;
-- 
2.36.1

