Return-Path: <netdev+bounces-10131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7232A72C6DD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0D111C20B1C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC17B19E6B;
	Mon, 12 Jun 2023 14:04:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06DF19BCE
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:04:40 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E5C1AC;
	Mon, 12 Jun 2023 07:04:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-655d1fc8ad8so3574106b3a.1;
        Mon, 12 Jun 2023 07:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686578679; x=1689170679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MNr/jBTfwb38UZJfOzDqH21JXJSz0BDAQ1jmu5vvAs=;
        b=TOFsy9ySuSQyAa+Hlj94ZUNT9AZgQwXBasadtQqCLeXrcmJJNCrDbQGXseiaAoI+oF
         LR8soiYWttEOUGfYxpxcNTULQmJTbRfA08pZT1TeWUophmUinlpk4IEAcRKOwRc0tj1A
         2Ezlxvf77TzsxbHmI6SvhVPTI0EjVGSnu+xIXO3bIcxL1H/I/rnoCtAOpU9TLC/r0Kl7
         KoMRD9apljZ120ZifI1cGEJUK2X6qZprK4+tCwelETKFO2vYGDFyhZIxHinOLAp745Xl
         zTjumE1oMEZ4XEuds3LbhX8/siuFuaGEw5Wxtc283js+HAqMOud5m0tkqqkAL+NRZJPx
         RCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686578679; x=1689170679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MNr/jBTfwb38UZJfOzDqH21JXJSz0BDAQ1jmu5vvAs=;
        b=fyJOlPwOpaYFb/G8Rh7I2EnzbsmPM5G0xRfwqTws2cU9xpwYNazrvo78mnmtdYAPrC
         B6opMRYIYK3Rn2fqTBRWG63wsMGHJyPFmN3BaiHc+7JQF3dStFhTdJ5irHJavZF5mEGH
         DzouKMPScGj+XiFO0fEoAdAR6GZWW2VLGMZBDd7o2u/PIe5eLv1oUl/eyLSIFODzLT4T
         is8YbKcifougYd2h4I7Ou3VC5ZnO59wsNXHf/Q2JGdZ2dXVow+r6YTkx0lqOZ+ikVmsj
         Qjij+0l4XwxPyqRPKSu4WgyMIKmO5ZikouKnm+RDn9U+Lqs7ML13khBSveGU5g7LRVgm
         7UqA==
X-Gm-Message-State: AC+VfDxKsgAQEUBaLwy2JpCc2uAdl5mK5Eu6KON6IqR4oKh0E438qu5c
	DjLZzT8FC8zzzLhmJTR3vJsop08ZOXdbA/Kn
X-Google-Smtp-Source: ACHHUZ4Pogi8HWKz4xscrSILXggCgY7ZVK9Hz0ZkcrbdfV/zPK1AaQDhFcMwkWNDR2lpex6GSLLpVQ==
X-Received: by 2002:a05:6a20:734c:b0:10c:2fce:96cc with SMTP id v12-20020a056a20734c00b0010c2fce96ccmr10938748pzc.34.1686578678834;
        Mon, 12 Jun 2023 07:04:38 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id q4-20020a63e944000000b0053f06d09725sm7573318pgj.32.2023.06.12.07.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 07:04:38 -0700 (PDT)
From: Jianhui Zhao <zhaojh329@gmail.com>
To: zhaojh329@gmail.com
Cc: andrew@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	hkallweit1@gmail.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux@armlinux.org.uk,
	netdev@vger.kernel.org,
	pabeni@redhat.com
Subject: [PATCH] net: phy: Add sysfs attribute for PHY c45 identifiers.
Date: Mon, 12 Jun 2023 22:04:26 +0800
Message-Id: <20230612140426.1648-1-zhaojh329@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230611152743.2158-1-zhaojh329@gmail.com>
References: <20230611152743.2158-1-zhaojh329@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 17d0d0555a79..81a4bc043ee2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -541,8 +541,10 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 
 			if ((phydrv->phy_id & phydrv->phy_id_mask) ==
 			    (phydev->c45_ids.device_ids[i] &
-			     phydrv->phy_id_mask))
+			     phydrv->phy_id_mask)) {
+				phydev->phy_id = phydev->c45_ids.device_ids[i];
 				return 1;
+			}
 		}
 		return 0;
 	} else {

How about modifying it like this?

