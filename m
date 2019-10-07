Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A803CDF40
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfJGK0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:26:18 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:41413 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727262AbfJGK0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 06:26:17 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97AKml6026153;
        Mon, 7 Oct 2019 12:25:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=cIh/B+QlT5Ufq0muAI8MFIZVmvtKiiVeIQjxYFeHv4U=;
 b=LqwFvsFeAgqwBt7UYWHD+Wuf+stCjxWldXnL+ZqqyTjv9PukoK6gjeJKuhHN9HtbFVk/
 qINdmJ8SJp4VZEqHmX8HX/OR77VCCUuep5iwlHbpCQWiz6LmXWlQaz8SRLbONPSU5q7f
 u5QLwVf799PJGBZoVV6fPP6+SEP+pv9mUyv98wqICqgKGn2A94yONlyyI7KdQFyNqdG8
 9zLr5o5ct1m4k2jtoSx/F0kDFB2tW9EcrQESlnfGgWY3iqekCks4uvtZvOsjgzpa0Zb9
 cyZF3E7mbm2nk9Ev6T7CqfrdURgjwdJhs5igOpnTtDmBAgj0UPQO5hiatsex1g1i1Gjl /g== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2vegxvhrn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 12:25:57 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id EB15210002A;
        Mon,  7 Oct 2019 12:25:56 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DC7722BFE0A;
        Mon,  7 Oct 2019 12:25:56 +0200 (CEST)
Received: from localhost (10.75.127.50) by SFHDAG3NODE2.st.com (10.75.127.8)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 7 Oct 2019 12:25:56
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
Subject: [PATCH 3/3] dt-bindings: regulator: Fix yaml verification for fixed-regulator schema
Date:   Mon, 7 Oct 2019 12:25:52 +0200
Message-ID: <20191007102552.19808-4-alexandre.torgue@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191007102552.19808-1-alexandre.torgue@st.com>
References: <20191007102552.19808-1-alexandre.torgue@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG6NODE1.st.com (10.75.127.16) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_02:2019-10-07,2019-10-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes an issue seen during yaml check ("make dt_binding_check").
Compatible didn't seem to be seen as a string.

Reported issue:
"properties:compatible:enum:0: {'const': 'regulator-fixed'}
is not of type 'string'"
And
"properties:compatible:enum:1: {'const': 'regulator-fixed-clock'}
is not of type 'string'"

Fixes: 9c86d003d620 ("dt-bindings: regulator: add regulator-fixed-clock binding")
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>

diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml b/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
index a78150c47aa2..7725cedf1538 100644
--- a/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
@@ -22,16 +22,20 @@ allOf:
 if:
   properties:
     compatible:
+      allOf:
+        - $ref: "/schemas/types.yaml#/definitions/string"
       contains:
-        const: regulator-fixed-clock
+        const: "regulator-fixed-clock"
   required:
     - clocks
 
 properties:
   compatible:
+    allOf:
+      - $ref: "/schemas/types.yaml#/definitions/string"
     enum:
-      - const: regulator-fixed
-      - const: regulator-fixed-clock
+      - "regulator-fixed"
+      - "regulator-fixed-clock"
 
   regulator-name: true
 
-- 
2.17.1

