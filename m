Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F234BE8545
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfJ2KPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:15:14 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:11892 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729093AbfJ2KPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:15:13 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9TACYMr029429;
        Tue, 29 Oct 2019 11:14:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=zBiYi7dNOMJTLdbXRroWIi9Q7ObD9twJevRTLSNm5yg=;
 b=T5hv/RHE9G72p/h2wm+cxxQ88edMTRYoaVaHpL3wGo0zYYb9ssrGajg5UwABOANwSqbH
 F7i/+2fXCm/2H5mJun87sWsRhN4F3VIyKPKRnb1Duxn0RQ9m0fsMZQQmhtFGqp8yonL4
 HOXT5ac4oXredrj3uf2ZJkzhHNY5Kv6wtZuMycuGn5amcOzToQS6vlrx33AVDrJAakhy
 PTaPGxbyun4PhlhuHBS5dRTO/LS//bjmYjQyTVxumx4fSZ1BTxZI3oR/AnWQyHwea6H/
 q1HWDrz6SrlVxEGcyJJZRFMc7OSxOnuLOV9KkWTNeOVARScu123YB6wUqXS/5SGe+J4Y Cw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vvb98f4ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 11:14:54 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A9ACC10002A;
        Tue, 29 Oct 2019 11:14:52 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9C14B2B28D8;
        Tue, 29 Oct 2019 11:14:52 +0100 (CET)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 29 Oct
 2019 11:14:52 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 29 Oct 2019 11:14:51
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [net: ethernet: stmmac: some fixes and optimizations 2/5] net: ethernet: stmmac: fix warning when w=1 option is used during build
Date:   Tue, 29 Oct 2019 11:14:38 +0100
Message-ID: <20191029101441.17290-3-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191029101441.17290-1-christophe.roullier@st.com>
References: <20191029101441.17290-1-christophe.roullier@st.com>
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

