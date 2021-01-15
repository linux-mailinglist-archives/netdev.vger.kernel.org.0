Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4CB2F857E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbhAOTak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:30:40 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:38106 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388463AbhAOTak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:30:40 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FJT14L067846;
        Fri, 15 Jan 2021 13:29:02 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610738942;
        bh=a4WKsfBoOdvu5pp5r1p8Yye/NFAUVUGkrv5Ii2OAPJk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Ec/XUrM7KqjOW+cpjHfyQ8uV1Qr1rnpi09gQVdKEHW/Jlne6TiwwWHIheV8AhQJrI
         ZQl7f8kkQHHkd4xvzocBMPE462Ot+qyM5/p7IcnrVhbxojL1Gh4H3Ky18CAx8kRCg1
         XC81tpSJNjApyjILk5BREQsB8W6bocaXp/0TQSyw=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FJT1m0025469
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 13:29:01 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 13:29:01 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 13:29:01 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FJT0cC006836;
        Fri, 15 Jan 2021 13:29:01 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [net-next 1/6] dt-binding: ti: am65x-cpts: add assigned-clock and power-domains props
Date:   Fri, 15 Jan 2021 21:28:48 +0200
Message-ID: <20210115192853.5469-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210115192853.5469-1-grygorii.strashko@ti.com>
References: <20210115192853.5469-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPTS clock is usually a clk-mux which allows to select CPTS reference
clock by using 'assigned-clock-parents', 'assigned-clocks' DT properties.
Also depending on integration the power-domains has to be specified to
enable CPTS IP.

Hence add 'assigned-clock-parents', 'assigned-clocks' and 'power-domains'
properties to the CPTS DT bindings to avoid dtbs_check warnings:
 cpts@310d0000: 'assigned-clock-parents', 'assigned-clocks' do not match any of the regexes: 'pinctrl-[0-9]+'
 cpts@310d0000: 'power-domains' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../devicetree/bindings/net/ti,k3-am654-cpts.yaml          | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index 9b7117920d90..ce43a1c58a57 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -73,6 +73,13 @@ properties:
     items:
       - const: cpts
 
+  assigned-clock-parents: true
+
+  assigned-clocks: true
+
+  power-domains:
+    maxItems: 1
+
   ti,cpts-ext-ts-inputs:
     $ref: /schemas/types.yaml#/definitions/uint32
     maximum: 8
-- 
2.17.1

