Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E63BB8A96
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 07:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408178AbfITFja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 01:39:30 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:13844 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390374AbfITFjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 01:39:03 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8K5ZtuG010148;
        Fri, 20 Sep 2019 07:38:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=zBiYi7dNOMJTLdbXRroWIi9Q7ObD9twJevRTLSNm5yg=;
 b=C6Q+iNzyqotehTXKNZSE9pEBOQM+iQbl8c9i7lD/bqnjB0hIbXDtwPy/SIk6soaLvyUb
 DiTrGe0CPXqXAvet8xrSyAi4ePiXpzlzscCZdc93QmiGHW5hYO6gzvB9KtYaMjc1WQnD
 Umnmfth2DPjB9g32x6phbZelR8Xs9rAe8mjr1uNH/gPBucmU7c+8RMJgMduat0ZyUf3y
 PWf38D5U5RraeXoGBZKml6QfpGHb2GqBvFgvfnRmXeXV/dUIVgL6OEkhEvrTn9h8MbLl
 RDvdr8cwCMo4BILmGQi5j3G/lQsSgLui/BDslVtQ3kD8PhPdBEb0gHaHZ/SIFXcQ04bE Kg== 
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
        by mx08-00178001.pphosted.com with ESMTP id 2v3va18qd0-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 20 Sep 2019 07:38:41 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 2EB8752;
        Fri, 20 Sep 2019 05:38:37 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DAFE42209BE;
        Fri, 20 Sep 2019 07:38:36 +0200 (CEST)
Received: from SAFEX1HUBCAS24.st.com (10.75.90.95) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 20 Sep
 2019 07:38:36 +0200
Received: from localhost (10.201.22.222) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 20 Sep 2019 07:38:36
 +0200
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH  2/5] net: ethernet: stmmac: fix warning when w=1 option is used during build
Date:   Fri, 20 Sep 2019 07:38:14 +0200
Message-ID: <20190920053817.13754-3-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190920053817.13754-1-christophe.roullier@st.com>
References: <20190920053817.13754-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-20_01:2019-09-19,2019-09-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fix the following warning:

warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
  int val, ret;

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 7e6619868cc1..167a5e99960a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -184,7 +184,7 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
 {
 	struct stm32_dwmac *dwmac = plat_dat->bsp_priv;
 	u32 reg = dwmac->mode_reg;
-	int val, ret;
+	int val;
 
 	switch (plat_dat->interface) {
 	case PHY_INTERFACE_MODE_MII:
@@ -220,8 +220,8 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
 	}
 
 	/* Need to update PMCCLRR (clear register) */
-	ret = regmap_write(dwmac->regmap, reg + SYSCFG_PMCCLRR_OFFSET,
-			   dwmac->ops->syscfg_eth_mask);
+	regmap_write(dwmac->regmap, reg + SYSCFG_PMCCLRR_OFFSET,
+		     dwmac->ops->syscfg_eth_mask);
 
 	/* Update PMCSETR (set register) */
 	return regmap_update_bits(dwmac->regmap, reg,
-- 
2.17.1

