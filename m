Return-Path: <netdev+bounces-10143-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2817972C8A3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6752C1C20B2D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F185154BA;
	Mon, 12 Jun 2023 14:34:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34250525E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:34:08 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB531BE9;
	Mon, 12 Jun 2023 07:33:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-653fcd58880so3430753b3a.0;
        Mon, 12 Jun 2023 07:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686580416; x=1689172416;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nNXAs9HydHwmsXxu4M0TPC9uqDZfY6tekgQKCC23OZc=;
        b=Ft+e9h25J+ApfkTpN3as45AS7UwWutDchW0/xUxbJu8YN4S6bWF4pO47C7vH+JgWQZ
         BKHyKl1YCOkb44JWYJkB50Fk5bUF22UmougfQpTQqmPU+v3VCzaDzrdSXMJjiGwX1asv
         FFHhQH6Khq3GTbl3GX8cWCYQ+E+EmMt4aRTMcLKSCwkTxx01gCJ5qxof7HNQHiZ59kRE
         39B26RzRP85cALw2VN5V7p006Al7hxXI1AtLLl5KfpFe2i7YDyQmuWmZ61Km6EizHRLl
         ttTy2/FkZ4UVaGCVMmzdxFdw7QdG7AFHizFuKdb9zuB3pHl8MmdJiolhhvpesHTJ4sXC
         LCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686580416; x=1689172416;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nNXAs9HydHwmsXxu4M0TPC9uqDZfY6tekgQKCC23OZc=;
        b=AOwkdTepmugnrzvMLyuNuzE41d2eb5qU09gXHuxzm8AH7mAIEAGGXQpLFWUJ3z6Wy5
         5K/Oww5gaARmk3OfYzmtFtwLpWfEmtwVMdf3PjGFJrYnMBxTKt/+6T97TZn1SjCdvqZu
         xPwdRvEm4Rv5kHVGClgWJEXqgwMGlvxpMmz69aXoEDhVvzYmVgKc8zvSgojemWkboAxO
         Q8ZwATBe5z1bJmfGQYNLon9rzbso4qr0ubqBH2PjGMIQSaVyveXlxzXHkP1mkF/xZTHh
         3LFxN9t0Emn8t5VFyFviCm52ML7r+PRTcKeOeBEdyVQCQ4tZ0dNvNSXx0v6ifhzyweHG
         4wmA==
X-Gm-Message-State: AC+VfDyFs1yQmQEVfI3qEMdt7BN4R4SF/vRMtU7NLDvMk3MvV1P9pQOb
	+iJOOo1DxXwFsCY5nXqpCOaQ76WX1KsA/mRk
X-Google-Smtp-Source: ACHHUZ47gKkme4BlvMezN9DctFC6s/g8/MW9j8MZr/ozNk8h4akIH/CDSUWj2RKDMOrTQkGlPZVv6g==
X-Received: by 2002:a05:6a21:168b:b0:115:83f:fd0d with SMTP id np11-20020a056a21168b00b00115083ffd0dmr8894049pzb.18.1686580416006;
        Mon, 12 Jun 2023 07:33:36 -0700 (PDT)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id z24-20020a63c058000000b0051ba9d772f9sm7639626pgi.59.2023.06.12.07.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 07:33:35 -0700 (PDT)
From: Jianhui Zhao <zhaojh329@gmail.com>
To: andrew@lunn.ch
Cc: hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jianhui Zhao <zhaojh329@gmail.com>
Subject: [PATCH] net: phy: Assign the c45 id to phy_id property when matched.
Date: Mon, 12 Jun 2023 22:33:20 +0800
Message-Id: <20230612143320.2077-1-zhaojh329@gmail.com>
X-Mailer: git-send-email 2.34.1
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

If a phydevice use c45, its phy_id property is always 0 previously.
This change make the phy_id property has a valid value assigned from
c45 id.

Signed-off-by: Jianhui Zhao <zhaojh329@gmail.com>
---
 drivers/net/phy/phy_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
-- 
2.34.1


