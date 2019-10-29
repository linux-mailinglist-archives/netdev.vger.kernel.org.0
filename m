Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBFFE853C
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbfJ2KPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:15:15 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41290 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729103AbfJ2KPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:15:14 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9TACP6q028928;
        Tue, 29 Oct 2019 11:14:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=PasrWJUoa3UFwSs+GtbCxK+KUm1QgPk+g2vbUrQXP80=;
 b=FaBdUv57y2vIVqgAyO2sXIwozDMRCvsLzM0TXQKXDJoT1Cptg0fz2pAU10BlNxDpc+0d
 HADIpOfQC4v3F/LWfbaQ1lss4ijlmxSxUOt9g1RyFZ+Xh84JYwORg3oxnHdKQ8fgErgC
 IwN9AdJfvAvViTYfVEgOKkFMCfsHPYnmeH0BxFzT7lXZ4IxRFNZjImyXEUZ+yCwFBSrY
 eGRw+EKNfWbnTEmPL1VkO0ZUAFwdHRNemxCAiOvPZ2kVje7AmeDOtVXN2702lvJZtCSH
 m6onYVHiPZ+bcLqfy28eye11ruevmnaLmJr3XuIjCbB74a3i+/aCKwXYov7JESqdwDtU XQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vvd1gpp0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 11:14:57 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2DB25100039;
        Tue, 29 Oct 2019 11:14:56 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 206492B28DA;
        Tue, 29 Oct 2019 11:14:56 +0100 (CET)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 29 Oct
 2019 11:14:55 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 29 Oct 2019 11:14:55
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [net: ethernet: stmmac: some fixes and optimizations 5/5] ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power mode on stm32mp157c
Date:   Tue, 29 Oct 2019 11:14:41 +0100
Message-ID: <20191029101441.17290-6-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191029101441.17290-1-christophe.roullier@st.com>
References: <20191029101441.17290-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-29_03:2019-10-28,2019-10-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When there is no activity on ethernet phy link, the ETH_GTX_CLK is cut

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 arch/arm/boot/dts/stm32mp157c.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index f13c2348d130..8df2986dd452 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -1334,6 +1334,7 @@
 			st,syscon = <&syscfg 0x4>;
 			snps,mixed-burst;
 			snps,pbl = <2>;
+			snps,en-tx-lpi-clockgating;
 			snps,axi-config = <&stmmac_axi_config_0>;
 			snps,tso;
 			status = "disabled";
-- 
2.17.1

