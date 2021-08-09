Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09233E41E0
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhHIIxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:53:46 -0400
Received: from m12-12.163.com ([220.181.12.12]:37976 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhHIIxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 04:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=cLjD1
        QazKK6TLOJDaWUarO+saBlohSORuEDe9dMn5vE=; b=Vwz7LEDTbr6dcr/oifLzR
        AURQHSDY8hmSTPs6Ggdq560j4nYqkcbEms84YdbnlHptMzYSqT+Qjk6pxFN7KRZi
        Eks+gHQN2NNHmFNC78deV/PmFyeeEbXNmi2sLmGkTBg2+jqM+jt8242qzBe0OYq3
        tRjXmZHNvbi3JxsLTAm8qI=
Received: from asura.lan (unknown [182.149.135.186])
        by smtp8 (Coremail) with SMTP id DMCowADnNDrt7BBhQuZhTA--.28173S2;
        Mon, 09 Aug 2021 16:53:03 +0800 (CST)
From:   chaochao2021666@163.com
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chao Zeng <chao.zeng@siemens.com>
Subject: [PATCH 1/2] dt-bindings:dp83867:Add binding for the status led
Date:   Mon,  9 Aug 2021 16:52:13 +0800
Message-Id: <20210809085213.324129-1-chaochao2021666@163.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowADnNDrt7BBhQuZhTA--.28173S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFy3Cry3ZF1rJr1xAFWrXwb_yoW8KFW5pF
        sFvas7Gr12yF47JwsaqFn3Cr1fXw18Xr9FkFyq9w1qya98Aa1ftr4YgF4UXF48urZ5JFy7
        JFZ8Wr4UKF9Iyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jqT5dUUUUU=
X-Originating-IP: [182.149.135.186]
X-CM-SenderInfo: 5fkd0uhkdrjiasrwlli6rwjhhfrp/1tbi3w-pdWB0HGzM6wAAsP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chao Zeng <chao.zeng@siemens.com>

The phy status led of each of board maybe different.
Provide a method to custom phy status led behavior.

Datasheet:
http://www.ti.com/product/DP83867IR/datasheet

Signed-off-by: Chao Zeng <chao.zeng@siemens.com>
---
 .../devicetree/bindings/net/ti,dp83867.yaml    |  6 ++++++
 include/dt-bindings/net/ti-dp83867.h           | 18 ++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index 047d757e8d82..a46a437818f2 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -106,6 +106,12 @@ properties:
       Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h for applicable
       values.
 
+  ti,led-sel:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      This configure the status led. See dt-bindings/net/ti-dp83867.h
+      for different status led settings,select different configures
+
 required:
   - reg
 
diff --git a/include/dt-bindings/net/ti-dp83867.h b/include/dt-bindings/net/ti-dp83867.h
index 6fc4b445d3a1..de59c3a42c1e 100644
--- a/include/dt-bindings/net/ti-dp83867.h
+++ b/include/dt-bindings/net/ti-dp83867.h
@@ -48,6 +48,24 @@
 #define DP83867_CLK_O_SEL_CHN_C_TCLK		0xA
 #define DP83867_CLK_O_SEL_CHN_D_TCLK		0xB
 #define DP83867_CLK_O_SEL_REF_CLK		0xC
+
+/* Led configuration flag*/
+#define DP83867_LINK_ESTABLISHED				0x0
+#define DP83867_RECEIVE_TRANSMIT_ACTIVITY		0x1
+#define DP83867_TRANSMIT_ACTIVITY				0x2
+#define DP83867_RECEIVE_ACTIVITY				0x3
+#define DP83867_COLLISION_DETECTED				0x4
+#define DP83867_LINK_ESTABLISHED_1000BT			0x5
+#define DP83867_LINK_ESTABLISHED_100BTX			0x6
+#define DP83867_LINK_ESTABLISHED_10BT			0x7
+#define DP83867_LINK_ESTABLISHED_10_100_BT		0x8
+#define DP83867_LINK_ESTABLISHED_100_1000_BT	0x9
+#define DP83867_FULL_DUPLEX						0xA
+#define DP83867_LINK_ESTABLISHED_BLINK_TRANSMIT_RECEIVE 0xB
+#define DP83867_RESERVED						0xC
+#define DP83867_RECEIVE_TRANSMIT_ERROR			0xD
+#define DP83867_RECEIVE_ERROR					0xE
+
 /* Special flag to indicate clock should be off */
 #define DP83867_CLK_O_SEL_OFF			0xFFFFFFFF
 #endif
-- 
2.32.0


