Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3BD35A028
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhDINmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:42:03 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58138 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbhDINlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 09:41:53 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 139DfSeE113175;
        Fri, 9 Apr 2021 08:41:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1617975688;
        bh=le3waud/oZsy0bjjrzIzV4QRjPugTzWXU91AXlpRyds=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=rSd99R4nn3kCE8k1U++DzS7SlBRbPMoam5A2SNqiV4p/+FWH1i7PUj1KFu4bnxbrW
         cCRP4ZvmwZy4Lg4tjb5d3sVXEDgpdEJ/1SI4UO5Cu85ifVYX+ZT68/VwgLVugoulZ5
         TOZ8rSc7iAVPii7RF34sq/3QxyImOR3Q0R9VT64Y=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 139DfSaO027195
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 9 Apr 2021 08:41:28 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 9 Apr
 2021 08:41:27 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 9 Apr 2021 08:41:28 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 139Dewmc029277;
        Fri, 9 Apr 2021 08:41:23 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>
Subject: [PATCH 3/4] dt-bindings: net: can: Document transceiver implementation as phy
Date:   Fri, 9 Apr 2021 19:10:53 +0530
Message-ID: <20210409134056.18740-4-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210409134056.18740-1-a-govindraju@ti.com>
References: <20210409134056.18740-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

Some transceivers need a configuration step (for example, pulling the
standby or enable lines) for them to start sending messages. The
transceiver can be implemented as a phy with the configuration done in the
phy driver. The bit rate limitation can the be obtained by the driver using
the phy node.

Document the above implementation in the bosch mcan bindings

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 798fa5fb7bb2..2c01899b1a3e 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -109,6 +109,12 @@ properties:
   can-transceiver:
     $ref: can-transceiver.yaml#
 
+  phys:
+    minItems: 1
+
+  phy-names:
+    const: can_transceiver
+
 required:
   - compatible
   - reg
-- 
2.17.1

