Return-Path: <netdev+bounces-6826-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A80AF71858A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37C5D1C20EC2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA541642F;
	Wed, 31 May 2023 15:04:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5216423
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:04:00 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9793412B;
	Wed, 31 May 2023 08:03:58 -0700 (PDT)
Received: from arisu.mtl.collabora.ca (mtl.collabora.ca [66.171.169.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id 9DBB26606EB1;
	Wed, 31 May 2023 16:03:55 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685545437;
	bh=ZwlXPYQPfk+GWd3QIJF4+YV66sRpXFI0cOCa/2Pkr1c=;
	h=From:To:Cc:Subject:Date:From;
	b=gJv5lCZCo9TpspztOoSp2+J7yKGfADEev9Peyk9pHP7lLl4bXSMcO45nu0OzA5AqA
	 tg+zuNhlup2nWOeoe+1TGtwT97dGLvVmolwotYkCXOsdXoEwxLIAX6AuAUFTkjtr1f
	 jVnkYEzZs/PraQjzYXfz3UpDNg8ZPbs2TH2Yi8KXAiQu888SPZ8sdF5iUt97+ohnXM
	 j6XHJqmJvzugy/w5VxFSHrd6jdO5CT/kCq3FNjG5VSVRMpiE+KbiryXuLVKpIfeSWr
	 SkNj24+b3ct8s/fR05oSjtFKD7aoinOrzpUK/b3uP6+QzO4m3BCIJR0NuJklenbgI+
	 J2ck/yqQlZBlw==
From: Detlev Casanova <detlev.casanova@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	Detlev Casanova <detlev.casanova@collabora.com>
Subject: [PATCH 1/2] dt-bindings: net: phy: Support external PHY xtal
Date: Wed, 31 May 2023 11:03:39 -0400
Message-Id: <20230531150340.522994-1-detlev.casanova@collabora.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Ethernet PHYs can have external an clock that needs to be activated before
probing the PHY.

Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
---
 .../devicetree/bindings/net/ethernet-phy.yaml          | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 4f574532ee13..e83a33c2aa59 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -93,6 +93,16 @@ properties:
       the turn around line low at end of the control phase of the
       MDIO transaction.
 
+  clock-names:
+    items:
+      - const: xtal
+
+  clocks:
+    maxItems: 1
+    description:
+      External clock connected to the PHY. If not specified it is assumed
+      that the PHY uses a fixed crystal or an internal oscillator.
+
   enet-phy-lane-swap:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
-- 
2.39.3


