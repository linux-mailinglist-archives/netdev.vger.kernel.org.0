Return-Path: <netdev+bounces-10749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5058973017A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA12C281498
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E05DDDC1;
	Wed, 14 Jun 2023 14:16:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527F1DDAF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:16:57 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713B31BC6;
	Wed, 14 Jun 2023 07:16:49 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f8ca80e889so6766425e9.3;
        Wed, 14 Jun 2023 07:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686752208; x=1689344208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zXrtZVNtigeKgJSwA8SW/6hEN8pGZI7BArpmacufnTg=;
        b=ZvlIhWO+UbdEXvtjkfHV7Na2P16yHMVjdBcJ4rDysGC7/aPhxMv4zaZSiGm/ZhK2td
         UwCJg/2ARuYuOw3iMAbcyZ+es5K4mrPdWEah974xwoTL51Jj7Z5nu0QlR23j2ZuQDsUJ
         e8P/44csh3nSZRI+/nZBtYpVh3jCekSF28BWITcHCUTcFvMJJSWpgyZul8+XTPZepgSl
         zXZZ5vAg+ylHT6Mgpke+nVaAOQuRqhkQwrT458KV0vM0lTORfTeVnTu7HM77N/lJOnVR
         3ws8iybDCDLn/yh6cBw11r+FD2XeoxcT9eFPbqlmki5v9CsHchOL4bk7498MqGGoD62s
         GbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686752208; x=1689344208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zXrtZVNtigeKgJSwA8SW/6hEN8pGZI7BArpmacufnTg=;
        b=CYO8DHMG0DJK1lQd/ZHt8efq8mI3ckMewOg37JDkniPa4W5ErPlp2GE+ck4Wg2wj2Z
         3UszdzJ7Bj3qglwLjqDN9vYidLr96go6NTC6jdR5xhdSF0vZ+HoRATPdQflwgDn1LJhv
         3XALIhpfzLxjea8IxNUHwCdv4iODhAfQVrNKRaTsFkteL/jY20nw7TEUvVzuZDRUU2UY
         4lB2didL34i7A05D9cjrcDU7qSX6dWHlOMxYv3FReV0ZRQuVXbQ/OBgWVVLA41QpM8QG
         mc0IKQu78GIEA4DbPN3bqF1d4DJ2baVMrS1Ui8Z13o4F63HnGUX9HgikkxFueGRzr1VS
         ykug==
X-Gm-Message-State: AC+VfDxvH/hygvm2+vEVC/dZ4HOoQVxoQ6NkLoqGmEttb1HUdS2fWELB
	wut5V0/Qq/Gr5sd6i2NJCGE=
X-Google-Smtp-Source: ACHHUZ7u0M9cZqByWtISOn1h1jPvoZT7oi+IfoTVD0JOaPtyqavnoW4rP3x4WqugXE0GnbkR+7oAuw==
X-Received: by 2002:a5d:480f:0:b0:30f:ca3f:64d4 with SMTP id l15-20020a5d480f000000b0030fca3f64d4mr4131734wrq.47.1686752207571;
        Wed, 14 Jun 2023 07:16:47 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id v13-20020adfebcd000000b00309382eb047sm18509045wrn.112.2023.06.14.07.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 07:16:46 -0700 (PDT)
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
Subject: [net PATCH] net: ethernet: stmicro: stmmac: fix possible memory leak in __stmmac_open
Date: Wed, 14 Jun 2023 09:32:41 +0200
Message-Id: <20230614073241.6382-1-ansuelsmth@gmail.com>
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

Correctly call free_dma_desc_resources on the new dma_conf passed to
__stmmac_open on error.

Reported-by: Jose Abreu <Jose.Abreu@synopsys.com>
Fixes: ba39b344e924 ("net: ethernet: stmicro: stmmac: generate stmmac dma conf before open")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fa07b0d50b46..0966ab86fde2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3877,10 +3877,10 @@ static int __stmmac_open(struct net_device *dev,
 
 	stmmac_hw_teardown(dev);
 init_error:
-	free_dma_desc_resources(priv, &priv->dma_conf);
 	phylink_disconnect_phy(priv->phylink);
 init_phy_error:
 	pm_runtime_put(priv->device);
+	free_dma_desc_resources(priv, dma_conf);
 	return ret;
 }
 
-- 
2.40.1


