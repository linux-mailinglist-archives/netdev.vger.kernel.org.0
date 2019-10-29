Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CC0E854A
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbfJ2KPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:15:34 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41458 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730034AbfJ2KPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:15:33 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9TACQqB029013;
        Tue, 29 Oct 2019 11:14:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=STMicroelectronics;
 bh=2+X7n8kYh+eyI478R9QoZl24SqMf0i4AANekeGpV2V0=;
 b=bo1IIq9EpbnkuyFLVKyyKelvOegHh+jMBkCnJYrALmj5rXUptONPwJPkUiSbJNfxvbqW
 b3bAvPbmSTpdwI55NOzN6Ai8GA8kdT9pLpDx5sRz59UnspekXsF8Z/iyGUtoGNA9C/Pl
 DsghnDfiT2lvQjRTpKzMyV1Hf6AUbEqszlMLrkwSgvY+TOiGR3riJAfemo2LhqrhWwbF
 TLtSL5If407AEum3azpX+o5704/raW/XvSCuQYKGHJsqYsehftECe1gi3uSdp1xv3Nmj
 A5edU4met2LnAgatEGmkG7xO5CXMezOdFUI0MYkOuBSMOxdPZEFq430gm6Kh84razTLI Lw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vvd1gpp0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 11:14:52 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 90C0A100034;
        Tue, 29 Oct 2019 11:14:50 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7783D2B28D8;
        Tue, 29 Oct 2019 11:14:50 +0100 (CET)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 29 Oct
 2019 11:14:50 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 29 Oct 2019 11:14:49
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH 0/5] net: ethernet: stmmac: some fixes and optimizations
Date:   Tue, 29 Oct 2019 11:14:36 +0100
Message-ID: <20191029101441.17290-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-29_03:2019-10-28,2019-10-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some improvements (manage syscfg as optional clock, update slew rate of
ETH_MDIO pin, Enable gating of the MAC TX clock during TX low-power mode)
Fix warning build message when W=1

Christophe Roullier (5):
  net: ethernet: stmmac: Add support for syscfg clock
  net: ethernet: stmmac: fix warning when w=1 option is used during
    build
  ARM: dts: stm32: remove syscfg clock on stm32mp157c ethernet
  ARM: dts: stm32: adjust slew rate for Ethernet
  ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power
    mode on stm32mp157c

 arch/arm/boot/dts/stm32mp157-pinctrl.dtsi     |  9 +++-
 arch/arm/boot/dts/stm32mp157c.dtsi            |  7 ++--
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 42 ++++++++++++-------
 3 files changed, 38 insertions(+), 20 deletions(-)

-- 
2.17.1

