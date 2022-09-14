Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537F75B7EAD
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 03:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiINBvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 21:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiINBvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 21:51:37 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322716B8E9;
        Tue, 13 Sep 2022 18:51:37 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t3so13653741ply.2;
        Tue, 13 Sep 2022 18:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date;
        bh=/WIYwNyx5Wu29EYSy/2Jrb2UOMIrmP6W19HsWBdfXxc=;
        b=WM5xtV3vceALBvE0lUoU4kpxV8MOOlvjjYHEozJeuKfrKLcGJIGIGrhYO6B+iq3K+n
         x6QkfRYxmfdZrtYOSmMPpGzsCcBCGHr8n++n8U7T1MHAeR5oJVoQjeOqQM1HcvKcixII
         rOXmZEna7jDPMbtcrMfH8Q+rAW+sV1MEm2kzzB9J3k4ivxtYV1GZh2plWT1IhL2q7REL
         B0KpMEFLtGeHeeg7k9A3P6lVaRyWqAPTuNXBrlRLbYdWi8K4A7g2iberUhz81cT4m68V
         xd/RxAIMb7vu0S9rj34yNNUL+3ZHXSn3HmTJcl1E9SB4/bA10zWlW7pHuSKiPD/Sj2sz
         06VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=/WIYwNyx5Wu29EYSy/2Jrb2UOMIrmP6W19HsWBdfXxc=;
        b=Muq3SbCGuCEZdHKQyvjUZQQh73OPq31r3lngqIh0++hQqSy9VfsLks76ndDdjVX7iR
         1XERgVeoN1h4xp8YJNH+TjxYe0zHTszqTQO1aVu65KmHz1IOsXgqvN2VKI+1nFamF4yP
         cRp/2oyaXTiouJTpRHtNs01qagswNHwRFRrBNedZNtoo/I34CiPc+xFfcumKAbYc8oEV
         A/WZ9pTPwXXniPj9dFpNdscSn2dsZTZrMKp5ehieN/odIKVhm+2hrcwjCSq/3aev+HxI
         MLqhMLNnd1zbMxR/QtonJ/FCnvgIPtStvDkUHVkn4dbaTxcA2m9upFl1ShBElUeTXqtU
         P19g==
X-Gm-Message-State: ACrzQf07Q6XrqWKYrLLnkvj+7wOLI44WOGzaE75Pfq0GEyb1mmg8ObGO
        EINlREKpcPnEyiteZ2P3txU=
X-Google-Smtp-Source: AMsMyM6g9yibw5BiATdzD4iYp2v8oqxw78nq7VZQH9hmv1lrA3BS03K/DL+KgFbpjre+EkNd3aVGrQ==
X-Received: by 2002:a17:90b:3c8a:b0:200:b874:804 with SMTP id pv10-20020a17090b3c8a00b00200b8740804mr2201323pjb.151.1663120296643;
        Tue, 13 Sep 2022 18:51:36 -0700 (PDT)
Received: from localhost.localdomain ([104.28.240.137])
        by smtp.gmail.com with ESMTPSA id s129-20020a625e87000000b00537b1aa9191sm8778989pfb.178.2022.09.13.18.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 18:51:36 -0700 (PDT)
From:   Qingfang DENG <dqfext@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: stmmac: fix invalid usage of irq_set_affinity_hint
Date:   Wed, 14 Sep 2022 09:51:20 +0800
Message-Id: <20220914015120.3023123-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The cpumask should not be a local variable, since its pointer is saved
to irq_desc and may be accessed from procfs.
To fix it, store cpumask to the heap.

Fixes: 8deec94c6040 ("net: stmmac: set IRQ affinity hint for multi MSI vectors")
Signed-off-by: Qingfang DENG <dqfext@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |  2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 ++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index bdbf86cb102a..720e9f2a40d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -77,6 +77,7 @@ struct stmmac_tx_queue {
 	dma_addr_t dma_tx_phy;
 	dma_addr_t tx_tail_addr;
 	u32 mss;
+	cpumask_t cpu_mask;
 };
 
 struct stmmac_rx_buffer {
@@ -114,6 +115,7 @@ struct stmmac_rx_queue {
 		unsigned int len;
 		unsigned int error;
 	} state;
+	cpumask_t cpu_mask;
 };
 
 struct stmmac_channel {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8418e795cc21..7b1c1be998e3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3469,7 +3469,6 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	enum request_irq_err irq_err;
-	cpumask_t cpu_mask;
 	int irq_idx = 0;
 	char *int_name;
 	int ret;
@@ -3580,9 +3579,10 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 			irq_idx = i;
 			goto irq_error;
 		}
-		cpumask_clear(&cpu_mask);
-		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
-		irq_set_affinity_hint(priv->rx_irq[i], &cpu_mask);
+		cpumask_set_cpu(i % num_online_cpus(),
+				&priv->dma_conf.rx_queue[i].cpu_mask);
+		irq_set_affinity_hint(priv->rx_irq[i],
+				      &priv->dma_conf.rx_queue[i].cpu_mask);
 	}
 
 	/* Request Tx MSI irq */
@@ -3605,9 +3605,10 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 			irq_idx = i;
 			goto irq_error;
 		}
-		cpumask_clear(&cpu_mask);
-		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
-		irq_set_affinity_hint(priv->tx_irq[i], &cpu_mask);
+		cpumask_set_cpu(i % num_online_cpus(),
+				&priv->dma_conf.tx_queue[i].cpu_mask);
+		irq_set_affinity_hint(priv->tx_irq[i],
+				      &priv->dma_conf.tx_queue[i].cpu_mask);
 	}
 
 	return 0;
-- 
2.34.1

