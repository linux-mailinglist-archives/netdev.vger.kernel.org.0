Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5CE226E57
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgGTSdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1802 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730570AbgGTSdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIHPpn023125;
        Mon, 20 Jul 2020 11:33:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=0DfHwEPeacE2y5vouRkahebq261aaS+AriFeMUbpDoY=;
 b=k2pHw9aN8c5Hup/xQ8ok8EPJ4FvUMm61632UxtdpW6p4ba+aomDCl0jkPB6ydXqbBaFv
 oX6xToIhwq32GuT3lhE8sqYLA9ihrAOhnnSmggRN3mXBZE+432a7N/zA4dOHa8BFe7+k
 Oo6/1ZdK7Qc8YOhMj7qLAo/oisU2zUYWe5vj9j54eZFXjMD1D2B9h/m5gcB91QV1+0ZX
 pNjKlv20O+FA/eNI2ceCQHn/d/NkFpDc6IBGAIaYp/KUkTxeKQo0XNnrMTbSz4ESYpd0
 ZtfcN+Gy8aeJLqWDwieyCUX1B16BelGZ5Tw5SHz/zKREV3GeQTz7Xc1z6+6KXqh7EziQ dw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkfb9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:33:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:33:12 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id F02EE3F703F;
        Mon, 20 Jul 2020 11:33:10 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 10/13] net: atlantic: use U32_MAX in aq_hw_utils.c
Date:   Mon, 20 Jul 2020 21:32:41 +0300
Message-ID: <20200720183244.10029-11-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces magic constant ~0U usage with U32_MAX in aq_hw_utils.c

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
index ae85c0a7d238..1921741f7311 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
@@ -41,9 +41,8 @@ u32 aq_hw_read_reg(struct aq_hw_s *hw, u32 reg)
 {
 	u32 value = readl(hw->mmio + reg);
 
-	if ((~0U) == value &&
-	    (~0U) == readl(hw->mmio +
-			   hw->aq_nic_cfg->aq_hw_caps->hw_alive_check_addr))
+	if (value == U32_MAX &&
+	    readl(hw->mmio + hw->aq_nic_cfg->aq_hw_caps->hw_alive_check_addr) == U32_MAX)
 		aq_utils_obj_set(&hw->flags, AQ_HW_FLAG_ERR_UNPLUG);
 
 	return value;
-- 
2.25.1

