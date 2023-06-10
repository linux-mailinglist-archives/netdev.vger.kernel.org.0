Return-Path: <netdev+bounces-9834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFBE72AD34
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18C002816CA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1F41EA74;
	Sat, 10 Jun 2023 16:14:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03539C8E3
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:14:17 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B134130EC;
	Sat, 10 Jun 2023 09:13:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b039168ba0so17292255ad.3;
        Sat, 10 Jun 2023 09:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686413603; x=1689005603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ta22F9l3xXtWemH7GUvxbCwaqNuLLclQSlNm9Aop6Ho=;
        b=g949oMCRb8ABAci3jIbcf3kQQOO9u0LWhckP2m/E8S1n3TtnrYe06X3heujxydY5Kc
         5maSryM8ePWjRGoDtaL1S0KB5tdkqwGDlh0afvpekt5QB8RxI9xtWyTvaazZLhE+/hok
         DpqDFsdKxdhQ/Mu+qtd/lj8jZCQhPZCVmu8Mca3aA8ebOmDOF897h84YkJJRgYOwMoJE
         zcPKOPYYNBa3r/2dTMV0InYRrVaOJ2z9RDf9LXW9PEmTxg6buFLqNIG3N9CaDmafMVux
         /YUodFYy42mq1yRGYWzIcgAfcBwz4WgCLGJqw3IUHehwSK/sdDsLxnz5ZyOVkAOZogO8
         eWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413603; x=1689005603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ta22F9l3xXtWemH7GUvxbCwaqNuLLclQSlNm9Aop6Ho=;
        b=keuIfPa75bdrJh/LKTx3LaC9jvzRfqg5E7SsHX41ynxr4xgxzenTGuXhScVbZV+Aw3
         jOe9q0vIVvFd2/0OgqGRhInDs7yp5dCr2TWKSDfeckGdM5+nWqBGv9M3ekCR8vHysjXE
         7Jq3vKSAXZGLnMs57B0mDPtDxioqKGLge9QXMWNqIAGf6JssRPvIisgT51kDG4In0Eu2
         lwmZWGT4zWRLQw10Hlu+FKz1Pp09yB9UbShv8zD98wa7B7T1D9iw5RyuDa5eP7IvsGii
         GArJ4hDd1+nQTYnHqyFQQdJiI854fPXWpsRU2UkKqw8xYICUONDjjDgDtSDk0lDqMOZ6
         w7Lg==
X-Gm-Message-State: AC+VfDzhB4AbXM5u6u+0xMionQZNq1xcSnpg+5nXaP8iIzz6pNHY08u0
	OHCDqjEhJenDhyjzxDdNGXcri69zIzbt1yeZ
X-Google-Smtp-Source: ACHHUZ4lfpf7X9EWE5WyEhekTcfL6nHtIZFKHmWr1GB6Fqp9DBI7jdt7tkgP+cJgSFUBLHMsPwOkDA==
X-Received: by 2002:a17:902:e843:b0:1ac:7405:d3ba with SMTP id t3-20020a170902e84300b001ac7405d3bamr2323467plg.40.1686413603077;
        Sat, 10 Jun 2023 09:13:23 -0700 (PDT)
Received: from localhost.localdomain ([182.149.206.88])
        by smtp.gmail.com with ESMTPSA id jw14-20020a170903278e00b001ab1d23bf5dsm5160700plb.258.2023.06.10.09.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:13:22 -0700 (PDT)
From: Jianhui Zhao <zhaojh329@gmail.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jianhui Zhao <zhaojh329@gmail.com>
Subject: [PATCH] net: mdio: fix duplicate registrations for phy with c45 in __of_mdiobus_register()
Date: Sun, 11 Jun 2023 00:13:08 +0800
Message-Id: <20230610161308.3158-1-zhaojh329@gmail.com>
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

Maybe mdiobus_scan_bus_c45() is called in __mdiobus_register().
Thus it should skip already registered PHYs later.

Signed-off-by: Jianhui Zhao <zhaojh329@gmail.com>
---
 drivers/net/mdio/of_mdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 7eb32ebb846d..441973fce79e 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -186,6 +186,10 @@ int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
 			continue;
 		}
 
+		/* skip already registered PHYs */
+		if (mdiobus_is_registered_device(mdio, addr))
+			continue;
+
 		if (of_mdiobus_child_is_phy(child))
 			rc = of_mdiobus_register_phy(mdio, child, addr);
 		else
-- 
2.34.1


