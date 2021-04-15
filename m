Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7212360E19
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhDOPJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:09:45 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39968 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbhDOPHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:07:11 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13FF6dsx105271;
        Thu, 15 Apr 2021 10:06:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618499199;
        bh=BC7NZaFwou0Qy/69BHgGrbZVOjCGaSW7Bk5Vk/gujgA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=QbLcGhZR2wJhGIwnDutDkFJIStspfT7QXW+o1+cvBojtDLyjTL4PgFfquwLbIKIwh
         nGxRBfx2j/pCu6rt0WYb9Z5nZoYBpLdx7SIv5flt36EziYlR+/1uc7sgxVUtB5eICu
         DoegcwJiLBUrXakLKayg+2TpQpLab3FTeJG3+nIA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13FF6d5U018302
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Apr 2021 10:06:39 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 15
 Apr 2021 10:06:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 15 Apr 2021 10:06:38 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13FF6TGI129989;
        Thu, 15 Apr 2021 10:06:35 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>
Subject: [PATCH 1/2] dt-bindings: net: can: Document transceiver implementation as phy
Date:   Thu, 15 Apr 2021 20:36:28 +0530
Message-ID: <20210415150629.5417-2-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210415150629.5417-1-a-govindraju@ti.com>
References: <20210415150629.5417-1-a-govindraju@ti.com>
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
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 798fa5fb7bb2..25f74db46bae 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -109,6 +109,9 @@ properties:
   can-transceiver:
     $ref: can-transceiver.yaml#
 
+  phys:
+    maxItems: 1
+
 required:
   - compatible
   - reg
-- 
2.17.1

