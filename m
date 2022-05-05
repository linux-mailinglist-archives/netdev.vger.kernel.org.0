Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C9851C1A9
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380298AbiEEN7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380319AbiEEN7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:59:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0BB6255;
        Thu,  5 May 2022 06:55:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dk23so8893006ejb.8;
        Thu, 05 May 2022 06:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jGlMaGnRuy7SzW1gLK1rbP4ej3ug9RnCTQFRGlHRyo=;
        b=UUjXmrWy0gc/YOU7UeZa/CBI2LHDiPBYI52bgE+CbxJBhcB5C29lQYCzJli3U7TlfI
         VSIZSLABxigpDo0RK/fTgnO11zb2Hxbg3dpSIYqdXFuy1HyLNlLCPsVM3/4p7ChNQraL
         ip5Kp/VrhE6bSHlbuvdOYCniW3gznAqfI6urKJ7S6u3wV93iQ+MRNtObs9iBk+/4eZcr
         eDjAKYbd3TbhgERHeDSzzliH5C2D9f5OE6DqXm7BTHHND2xq2F99vOTp4Rt9kIFtB3CY
         3TZb+4+EbCQrFdFzj987cHw2xs19Y7zrWXG9LJwsL3+w5oTI5TWjGTNui7nbsnwk6MSk
         713Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jGlMaGnRuy7SzW1gLK1rbP4ej3ug9RnCTQFRGlHRyo=;
        b=ec/ANootBarMcCrn6AST1ddkdEtPC8hJfVW1Q1JLW19g9LTVy1DVx58hTWUjj6oML6
         UeOi4OL/C60M4/QaQ5Wnyl7P1R2906Dl0MARLnzS5LHOasWsjCcAKrWGBLWoRhZ8vAXn
         cK+LnHHVVInNiQbY+hImvhkTYY5Pc7w9wFOPzIq7As49GIx6XGvFkvkTqdRwAUd7E1Lc
         qCDOnweV4YCDBJAFXkq+ZI3e18As0fmYomVe3sfh248Qam+xX29ygC2bq2Lv/ZgE/WoP
         r6kxdvJAHl/+KJf7ldSR8RDe/YnaLeQLK6kWyBcZ+b5xMZDaRSwDPXqOSUAIicn0+2e9
         kZtw==
X-Gm-Message-State: AOAM533QrMng/kxdCE9AH7tMlQL7+nXfLux/1gPnV3D/wnnSUfLxL2bX
        zYJqigA+G31vzstS1VvbWwY=
X-Google-Smtp-Source: ABdhPJwRXqicutb+lLbMz0m+5wqMzInuLtPPN4SwqVojZi82lcp2HvixDpRomdqZLM07KxrlmZbQVw==
X-Received: by 2002:a17:907:6e2a:b0:6f4:69bb:7ef6 with SMTP id sd42-20020a1709076e2a00b006f469bb7ef6mr17152406ejc.0.1651758922083;
        Thu, 05 May 2022 06:55:22 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e15-20020a50e44f000000b0042617ba63c7sm877949edm.81.2022.05.05.06.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:55:21 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, ansuelsmth@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RESEND 1/5] dt-bindings: net: add bitfield defines for Ethernet speeds
Date:   Thu,  5 May 2022 15:55:08 +0200
Message-Id: <20220505135512.3486-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220505135512.3486-1-zajec5@gmail.com>
References: <20220505135512.3486-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This allows specifying multiple Ethernet speeds in a single DT uint32
value.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 include/dt-bindings/net/eth.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 include/dt-bindings/net/eth.h

diff --git a/include/dt-bindings/net/eth.h b/include/dt-bindings/net/eth.h
new file mode 100644
index 000000000000..89caff09179b
--- /dev/null
+++ b/include/dt-bindings/net/eth.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Device Tree constants for the Ethernet
+ */
+
+#ifndef _DT_BINDINGS_ETH_H
+#define _DT_BINDINGS_ETH_H
+
+#define SPEED_UNSPEC		0
+#define SPEED_10		(1 << 0)
+#define SPEED_100		(1 << 1)
+#define SPEED_1000		(1 << 2)
+#define SPEED_2000		(1 << 3)
+#define SPEED_2500		(1 << 4)
+#define SPEED_5000		(1 << 5)
+#define SPEED_10000		(1 << 6)
+#define SPEED_14000		(1 << 7)
+#define SPEED_20000		(1 << 8)
+#define SPEED_25000		(1 << 9)
+#define SPEED_40000		(1 << 10)
+#define SPEED_50000		(1 << 11)
+#define SPEED_56000		(1 << 12)
+#define SPEED_100000		(1 << 13)
+#define SPEED_200000		(1 << 14)
+#define SPEED_400000		(1 << 15)
+
+#endif
-- 
2.34.1

