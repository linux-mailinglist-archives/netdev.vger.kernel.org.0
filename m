Return-Path: <netdev+bounces-5425-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A31BC7113A5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5354E1C20F4E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737DD22607;
	Thu, 25 May 2023 18:26:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F701101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:26:26 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F9218D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Content-Disposition:In-Reply-To:References;
	bh=lKbod3jjMQM1iFrLbm4sg5gKfW8QoCk5Rktnul5VbTM=; b=5RCWPhtAPyxJYNPykKfKCcp/aC
	ZIzFC2E787a7jcrDcS3/fjsjq871FCuEWASxGlzCMuOjGHug0bf8tU0Wd+pUaVMcndYL3F2gVMjOs
	zGYT0nwJlm7LheoaY6PTG+t7NxTIDIjJEWwm2/QgNVRcPpGxsPmFFWNpo53jvCkzKeuw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q2FfA-00Dv94-J5; Thu, 25 May 2023 20:26:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: shawnguo@kernel.org
Cc: s.hauer@pengutronix.de,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	arm@kernel.org,
	netdev <netdev@vger.kernel.org>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2] ARM: dts: vf610: ZII: Add missing phy-mode and fixed links
Date: Thu, 25 May 2023 20:26:06 +0200
Message-Id: <20230525182606.3317923-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The DSA framework has got more picky about always having a phy-mode
for the CPU port. The Vybrid FEC is a Fast Ethrnet using RMII.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Lastly, for DSA links between switches, add a fixed-link node
indicating the expected speed/duplex of the link.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---

v2: Blank line before fixed-link

arch/arm/boot/dts/vf610-zii-cfu1.dts      |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts | 12 ++++++++-
 arch/arm/boot/dts/vf610-zii-scu4-aib.dts  | 32 ++++++++++++++++++++++-
 arch/arm/boot/dts/vf610-zii-spb4.dts      |  2 +-
 arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts  |  2 +-
 arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts |  2 +-
 7 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/vf610-zii-cfu1.dts b/arch/arm/boot/dts/vf610-zii-cfu1.dts
index 96495d965163..1a19aec8957b 100644
--- a/arch/arm/boot/dts/vf610-zii-cfu1.dts
+++ b/arch/arm/boot/dts/vf610-zii-cfu1.dts
@@ -202,7 +202,7 @@ port@5 {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
+					phy-mode = "rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
index 6280c5e86a12..6071eb6b33a0 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
@@ -75,7 +75,7 @@ fixed-link {
 
 					port@6 {
 						reg = <6>;
-						label = "cpu";
+						phy-mode = "rmii";
 						ethernet = <&fec1>;
 
 						fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
index c00d39562a10..6f9878f124c4 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
@@ -44,7 +44,7 @@ ports {
 
 					port@0 {
 						reg = <0>;
-						label = "cpu";
+						phy-mode = "rmii";
 						ethernet = <&fec1>;
 
 						fixed-link {
@@ -82,6 +82,11 @@ switch0port10: port@10 {
 						label = "dsa";
 						phy-mode = "xaui";
 						link = <&switch1port10>;
+
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 
@@ -174,6 +179,11 @@ switch1port10: port@10 {
 						label = "dsa";
 						phy-mode = "xaui";
 						link = <&switch0port10>;
+
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 				mdio {
diff --git a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
index 7b3276cd470f..df1335492a19 100644
--- a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
+++ b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
@@ -59,7 +59,7 @@ ports {
 
 					port@0 {
 						reg = <0>;
-						label = "cpu";
+						phy-mode = "rmii";
 						ethernet = <&fec1>;
 
 						fixed-link {
@@ -115,6 +115,11 @@ switch0port10: port@10 {
 						link = <&switch1port10
 							&switch3port10
 							&switch2port10>;
+
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 			};
@@ -156,6 +161,11 @@ switch1port9: port@9 {
 						phy-mode = "xgmii";
 						link = <&switch3port10
 							&switch2port10>;
+
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 
 					switch1port10: port@10 {
@@ -163,6 +173,11 @@ switch1port10: port@10 {
 						label = "dsa";
 						phy-mode = "xgmii";
 						link = <&switch0port10>;
+
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 			};
@@ -246,6 +261,11 @@ switch2port10: port@10 {
 						link = <&switch3port9
 							&switch1port9
 							&switch0port10>;
+
+						fixed-link {
+							speed = <2500>;
+							full-duplex;
+						};
 					};
 				};
 			};
@@ -295,6 +315,11 @@ switch3port9: port@9 {
 						label = "dsa";
 						phy-mode = "2500base-x";
 						link = <&switch2port10>;
+
+						fixed-link {
+							speed = <2500>;
+							full-duplex;
+						};
 					};
 
 					switch3port10: port@10 {
@@ -303,6 +328,11 @@ switch3port10: port@10 {
 						phy-mode = "xgmii";
 						link = <&switch1port9
 							&switch0port10>;
+
+						fixed-link {
+							speed = <10000>;
+							full-duplex;
+						};
 					};
 				};
 			};
diff --git a/arch/arm/boot/dts/vf610-zii-spb4.dts b/arch/arm/boot/dts/vf610-zii-spb4.dts
index 180acb0795b9..1461804ecaea 100644
--- a/arch/arm/boot/dts/vf610-zii-spb4.dts
+++ b/arch/arm/boot/dts/vf610-zii-spb4.dts
@@ -140,7 +140,7 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
+					phy-mode = "rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
index 73fdace4cb42..463c2452b9b7 100644
--- a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
+++ b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
@@ -129,7 +129,7 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
+					phy-mode = "rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
index 20beaa8433b6..f5ae0d5de315 100644
--- a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
+++ b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
@@ -154,7 +154,7 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
+					phy-mode = "rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
-- 
2.40.1


