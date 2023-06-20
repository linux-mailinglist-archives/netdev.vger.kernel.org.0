Return-Path: <netdev+bounces-12206-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC6D736B27
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B62151C20BD7
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756F814A9C;
	Tue, 20 Jun 2023 11:41:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633C9101F0
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:41:01 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A0810F4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:40:59 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f871c93a5fso2798431e87.2
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1687261257; x=1689853257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNFZpEh4/cl7s83JmJ5khDQ6aml5OmK6AW+M363aFjU=;
        b=biDDrOKTzHLYitPYod0RIO44Z1JCB7Vq+G/s+gIYRJ2XB3b8jr5tsk0/Ye8+Kzh0LE
         Eh+8lJrPZvu97GzuuyWh78xXH1gh8GVwXM9ymXeSG3xrnPYwkR20MrEBXlcBtDrp2gUD
         pmxc6LeLO/SoMTCZtrJz2gDxUEYFN7NpO4t9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687261257; x=1689853257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZNFZpEh4/cl7s83JmJ5khDQ6aml5OmK6AW+M363aFjU=;
        b=YkApRPmlMSJQh55eB/kZemH9exrPSVFaI2pMWxn4GNM7jmXBxoRME0A6DYKMH1YAih
         O5/xnjgIlKqt0z8/+ULZb7b4loCJ+cWikYDY4HiKDV1rlkhuSZtyoPaJ4dUmVvEyMXRm
         Mrx1Jo8wdKOEQ6cyxh+gUhZsHsO50a3qrLwZtha+13Pt1jaJcSL5O/JGwlrP6Ty2mgiC
         ny1mIaRN9YCE8MeJnsHFBxiJosguwC9GCMk9qWaF90lCqoYeC4cpSJxjZnvS9mI5fAtI
         h9FPrq/v6Xls4SibPpRZWriY59qb3A9FDozUWVqHa3tIW2qfqsZNZ2XzEIuGB5YasAeQ
         ht1w==
X-Gm-Message-State: AC+VfDz57xPc1yp4rvnVMuAc6VaaEofTpWIpuaXhOifPjYBrrkA7MQH6
	m+ndu2FygK6ypRpeIkR+Ler1Gw==
X-Google-Smtp-Source: ACHHUZ7q/79IAx2fL0zq/CrCtVLiuxKFTR+X1CC55xo2T25ZTgPLBk21UNhluCFwBxX9meKQmLwfHg==
X-Received: by 2002:a05:6512:3284:b0:4f8:692a:6492 with SMTP id p4-20020a056512328400b004f8692a6492mr4413487lfe.32.1687261256749;
        Tue, 20 Jun 2023 04:40:56 -0700 (PDT)
Received: from localhost.localdomain ([87.54.42.112])
        by smtp.gmail.com with ESMTPSA id d12-20020ac2544c000000b004f84162e08bsm329879lfn.185.2023.06.20.04.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:40:56 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Woojung Huh <woojung.huh@microchip.com>,
	UNGLinuxDriver@microchip.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: dsa: microchip: simplify ksz_prmw8()
Date: Tue, 20 Jun 2023 13:38:52 +0200
Message-Id: <20230620113855.733526-2-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230620113855.733526-1-linux@rasmusvillemoes.dk>
References: <20230620113855.733526-1-linux@rasmusvillemoes.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement ksz_prmw8() in terms of ksz_rmw8(), just as all the other
ksz_pX are implemented in terms of ksz_X. No functional change.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/dsa/microchip/ksz_common.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a66b56857ec6..2453c43c48a5 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -578,17 +578,8 @@ static inline int ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 static inline int ksz_prmw8(struct ksz_device *dev, int port, int offset,
 			    u8 mask, u8 val)
 {
-	int ret;
-
-	ret = regmap_update_bits(ksz_regmap_8(dev),
-				 dev->dev_ops->get_port_addr(port, offset),
-				 mask, val);
-	if (ret)
-		dev_err(dev->dev, "can't rmw 8bit reg 0x%x: %pe\n",
-			dev->dev_ops->get_port_addr(port, offset),
-			ERR_PTR(ret));
-
-	return ret;
+	return ksz_rmw8(dev, dev->dev_ops->get_port_addr(port, offset),
+			mask, val);
 }
 
 static inline void ksz_regmap_lock(void *__mtx)
-- 
2.37.2


