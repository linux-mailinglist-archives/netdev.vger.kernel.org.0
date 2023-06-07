Return-Path: <netdev+bounces-8809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE66725DCC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E383828129E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161DC31EFA;
	Wed,  7 Jun 2023 11:57:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C25B7488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:57:44 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724B21BCB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:57:36 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <lgo@pengutronix.de>)
	id 1q6rmx-0000Fm-6e; Wed, 07 Jun 2023 13:57:19 +0200
Received: from [2a0a:edc0:0:1101:1d::39] (helo=dude03.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <lgo@pengutronix.de>)
	id 1q6rmu-005jFt-RW; Wed, 07 Jun 2023 13:57:16 +0200
Received: from lgo by dude03.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <lgo@pengutronix.de>)
	id 1q6rmu-00CTIM-4H; Wed, 07 Jun 2023 13:57:16 +0200
From: =?UTF-8?q?Leonard=20G=C3=B6hrs?= <l.goehrs@pengutronix.de>
To: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: kernel@pengutronix.de,
	=?UTF-8?q?Leonard=20G=C3=B6hrs?= <l.goehrs@pengutronix.de>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 4/8] dt-bindings: can: m_can: add termination-{gpios,ohms} properties
Date: Wed,  7 Jun 2023 13:55:03 +0200
Message-Id: <20230607115508.2964574-4-l.goehrs@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230607115508.2964574-1-l.goehrs@pengutronix.de>
References: <20230607115508.2964574-1-l.goehrs@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: lgo@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The termination-gpios property allows specifying a GPIO pin that
enables/disables a termination resistor on said CAN interface.
The termination-ohms property specifies the resistance of said resistor.

Signed-off-by: Leonard Göhrs <l.goehrs@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 67879aab623b5..106c79fa560c3 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -118,6 +118,9 @@ properties:
   phys:
     maxItems: 1
 
+  termination-gpios: true
+  termination-ohms: true
+
 required:
   - compatible
   - reg
-- 
2.39.2


