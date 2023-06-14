Return-Path: <netdev+bounces-10777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF1373043B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E6BB281403
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040771095C;
	Wed, 14 Jun 2023 15:53:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F4101DD
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:53:22 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDB0210B;
	Wed, 14 Jun 2023 08:53:17 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-310e6e6a8d4so811227f8f.2;
        Wed, 14 Jun 2023 08:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686757996; x=1689349996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bhq/y0fc8NtbiDoPoE9MBpAtCqUXLlZMCwX6567Us4w=;
        b=rplArsRTqX0QzO+acxEngNYJNMVt6u5lBMTiEmCMCN9MqpTtL0AOdInFSf3QEQLis6
         K5KkbNP4lva6SBLQxaan7MYME6CwT+/F/2PjeGakSkgz/g6LjoMls6tNrT93DmmuqUYp
         eM7vKCdL9B9IniqP7BNSdJ2M3pJGOhnw1kLHPVw0U3w8EiIf3SjvjswZAapm1gZkRGfB
         T1wShgwmoRF8B3ByF/Asxs2lnS1aXAzaJAm2Vi7W6UzoeBlnrUf5KQH7+EivQN0p4lpA
         6MF436FcsaG8uPOLPAmwDLyVZQlcRj4rpfJ61dbRO1SPl8NmSDSP3QDYR7JRmEdaASX4
         N3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686757996; x=1689349996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bhq/y0fc8NtbiDoPoE9MBpAtCqUXLlZMCwX6567Us4w=;
        b=YDnt+/I6+RnwSrZvOwcZ1c/hzZwA1azLdZCUlbtISdDRMsHrnj5I6vjujtnlN5bb+t
         H2IEKEEr/0uR3Cpb3fYH1MsoOKQmr+iYbPdSRAfQAstyUkXwWeKfB1ccFyUQmRNrlA7q
         9kv8Fk6xVTYGKI7PDDUT9GytPA+RbKHO2qt4y6NEUNiYw96Z3uKPVPfcx8u77u8GkKDG
         GUPw3Phy2hjzZWVfK7GULL8jE++bqkNTGlIeDZq3OtPH326ZXJg3cJ+0bzfyZLT3B47u
         HYmg6eu1w2nEjJMSc0t4pb+nhCd8zIPBgk44VmrY+McpbBRyN2td577mO2BKW0uAq4ue
         qglQ==
X-Gm-Message-State: AC+VfDzxRLYB2iqJHL6ebXF4pz91VmF//8jwkBg9lfW37Lim+pL5MRE3
	evmNB3N1Js45yomOIAJOyEc=
X-Google-Smtp-Source: ACHHUZ4bgrLvAW+bLWRMhNWCLyEUy8rjxDhrz/ugqbtaLYWSlkDAiCpdxMZXxKqgVabsYT+IRO3eww==
X-Received: by 2002:adf:f5d2:0:b0:30f:d0e7:ef31 with SMTP id k18-20020adff5d2000000b0030fd0e7ef31mr3459559wrp.44.1686757996142;
        Wed, 14 Jun 2023 08:53:16 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id m6-20020a5d6246000000b0030e52d4c1bcsm18752199wrv.71.2023.06.14.08.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 08:53:15 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Christian Marangi <ansuelsmth@gmail.com>,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	stable@vger.kernel.org
Subject: [net PATCH v2] net: ethernet: stmicro: stmmac: fix possible memory leak in __stmmac_open
Date: Wed, 14 Jun 2023 11:17:14 +0200
Message-Id: <20230614091714.15912-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fix a possible memory leak in __stmmac_open when stmmac_init_phy fails.
It's also needed to free everything allocated by stmmac_setup_dma_desc
and not just the dma_conf struct.

Drop free_dma_desc_resources from __stmmac_open and correctly call
free_dma_desc_resources on each user of __stmmac_open on error.

Reported-by: Jose Abreu <Jose.Abreu@synopsys.com>
Fixes: ba39b344e924 ("net: ethernet: stmicro: stmmac: generate stmmac dma conf before open")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org
---

Changes v2:
- Move free_dma_desc_resources to each user of __stmmac_open

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fa07b0d50b46..5c645b6d5660 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3877,7 +3877,6 @@ static int __stmmac_open(struct net_device *dev,
 
 	stmmac_hw_teardown(dev);
 init_error:
-	free_dma_desc_resources(priv, &priv->dma_conf);
 	phylink_disconnect_phy(priv->phylink);
 init_phy_error:
 	pm_runtime_put(priv->device);
@@ -3895,6 +3894,9 @@ static int stmmac_open(struct net_device *dev)
 		return PTR_ERR(dma_conf);
 
 	ret = __stmmac_open(dev, dma_conf);
+	if (ret)
+		free_dma_desc_resources(priv, dma_conf);
+
 	kfree(dma_conf);
 	return ret;
 }
@@ -5637,12 +5639,15 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 		stmmac_release(dev);
 
 		ret = __stmmac_open(dev, dma_conf);
-		kfree(dma_conf);
 		if (ret) {
+			free_dma_desc_resources(priv, dma_conf);
+			kfree(dma_conf);
 			netdev_err(priv->dev, "failed reopening the interface after MTU change\n");
 			return ret;
 		}
 
+		kfree(dma_conf);
+
 		stmmac_set_rx_mode(dev);
 	}
 
-- 
2.40.1


