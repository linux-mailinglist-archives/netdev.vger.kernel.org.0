Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E64CDF43
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfJGK0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:26:25 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51126 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726010AbfJGK0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 06:26:16 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97AL5S7020066;
        Mon, 7 Oct 2019 12:25:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=M74aio4f0hcIb5CStKqLwZ4Znh93MbF0U0WtdJoeBBo=;
 b=Q2KN9UBXXxl2ohKocVXHND/laavGfATGspsUy9pU0HAcSp3+DeRmBYXG++qFT6I8EWta
 TVHFeTG0EScwA25a3e+YQgWsQrIbsntu9C1rPLjPjoyx5eawmNn3WbFzgkkkr8iXOxjz
 jw5XD82oPppZiW8SgbaaBxw3y5FRE63xXNobM/bgpbu66ySDwi/Y2Qie6+Abjic9f45z
 xqP6bbvHhr0V5VrskG1Kh/sSjJQIqETDYokF+mAjcC3PCC05WjCqK24MSigXbWWCH3ff
 wa0FMTbXuxNmdL3ynz439jX6yPRu1LN05zOXg52LnrDmzVraEhqf/ZxPMVmpppcsQyXB tQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vej2p1s5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 12:25:56 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 476A7100034;
        Mon,  7 Oct 2019 12:25:56 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2F2572BFE0A;
        Mon,  7 Oct 2019 12:25:56 +0200 (CEST)
Received: from localhost (10.75.127.51) by SFHDAG3NODE2.st.com (10.75.127.8)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 7 Oct 2019 12:25:55
 +0200
From:   Alexandre Torgue <alexandre.torgue@st.com>
To:     Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC:     <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 2/3] dt-bindings: net: adi: Fix yaml verification issue
Date:   Mon, 7 Oct 2019 12:25:51 +0200
Message-ID: <20191007102552.19808-3-alexandre.torgue@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191007102552.19808-1-alexandre.torgue@st.com>
References: <20191007102552.19808-1-alexandre.torgue@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG6NODE1.st.com (10.75.127.16) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_02:2019-10-07,2019-10-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes an issue seen during yaml check ("make dt_binding_check").
Each enum were not declared as uint32.

"Documentation/devicetree/bindings/net/adi,adin.yaml:
properties:adi,rx-internal-delay-ps:
..., 'enum': [1600, 1800, 2000, 2200, 2400], 'default': 2000}
is not valid under any of the given schemas"

Fixes: 767078132ff9 ("dt-bindings: net: add bindings for ADIN PHY driver")
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index d95cc691a65f..23e8597acda6 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -17,6 +17,8 @@ allOf:
 
 properties:
   adi,rx-internal-delay-ps:
+    allOf:
+      - $ref: "/schemas/types.yaml#/definitions/uint32"
     description: |
       RGMII RX Clock Delay used only when PHY operates in RGMII mode with
       internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
@@ -24,6 +26,8 @@ properties:
     default: 2000
 
   adi,tx-internal-delay-ps:
+    allOf:
+      - $ref: "/schemas/types.yaml#/definitions/uint32"
     description: |
       RGMII TX Clock Delay used only when PHY operates in RGMII mode with
       internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
@@ -31,6 +35,8 @@ properties:
     default: 2000
 
   adi,fifo-depth-bits:
+    allOf:
+      - $ref: "/schemas/types.yaml#/definitions/uint32"
     description: |
       When operating in RMII mode, this option configures the FIFO depth.
     enum: [ 4, 8, 12, 16, 20, 24 ]
-- 
2.17.1

