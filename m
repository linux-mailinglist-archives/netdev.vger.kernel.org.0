Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA244EE290
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 15:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfKDOcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 09:32:10 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:63246 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727838AbfKDOcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 09:32:10 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA4ER8QN006158;
        Mon, 4 Nov 2019 15:31:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=CMrndWG+ZiADLifRh/ny34DDuov8Fnz6puAWI7fXAts=;
 b=d62Wn1Tn8/n1Q+HCfMMOW1vPAEGj8o1xlvb4fjMyFue9RYFMh4zaBqkSSHgCOvih+rXS
 FN3sIzNOZVUjSDkTC5NFCiXPx5tm4FmBsuVMG6KIqXb0H5Wm+OZ0Mshalnjb+oTRj5WI
 x5l6Tq8GpnK/rkUlAuY7Q2x5Pq96SqzJhvfx5KIwGazhzn59g0qDv2iAhBJa1+gq7r3a
 BkuC6k/hB5v9IYxRD2kwWaDkg63LLeV551lPij11CSE0uvGeUG126bUJMIodwdEj7GQq
 D0tBCrZ7BuYZNg4t2TamaEHCbUDx8sf+HQHD1sqh1votSZzfkl+/W70YHtp3MuY1XFLQ Ng== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2w1054hx1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 15:31:51 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 7161E100034;
        Mon,  4 Nov 2019 15:31:50 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 603772D3776;
        Mon,  4 Nov 2019 15:31:50 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019
 15:31:50 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019 15:31:49
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH  1/1] ARM: dts: stm32: Fix CAN RAM mapping on stm32mp157c
Date:   Mon, 4 Nov 2019 15:31:45 +0100
Message-ID: <20191104143145.7053-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-04_08:2019-11-04,2019-11-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the 10Kbytes CAN message RAM to be able to use simultaneously
FDCAN1 and FDCAN2 instances.
First 5Kbytes are allocated to FDCAN1 and last 5Kbytes are used for
FDCAN2. To do so, set the offset to 0x1400 in mram-cfg for FDCAN2.

Fixes: d44d6e021301 ("ARM: dts: stm32: change CAN RAM mapping on stm32mp157c")
Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 arch/arm/boot/dts/stm32mp157c.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index 9b11654a0a39..f98e0370c0bc 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -932,7 +932,7 @@
 			interrupt-names = "int0", "int1";
 			clocks = <&rcc CK_HSE>, <&rcc FDCAN_K>;
 			clock-names = "hclk", "cclk";
-			bosch,mram-cfg = <0x1400 0 0 32 0 0 2 2>;
+			bosch,mram-cfg = <0x0 0 0 32 0 0 2 2>;
 			status = "disabled";
 		};
 
@@ -945,7 +945,7 @@
 			interrupt-names = "int0", "int1";
 			clocks = <&rcc CK_HSE>, <&rcc FDCAN_K>;
 			clock-names = "hclk", "cclk";
-			bosch,mram-cfg = <0x0 0 0 32 0 0 2 2>;
+			bosch,mram-cfg = <0x1400 0 0 32 0 0 2 2>;
 			status = "disabled";
 		};
 
-- 
2.17.1

