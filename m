Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7973222119F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgGOPtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:49:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61606 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727043AbgGOPtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:49:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FFf123032713;
        Wed, 15 Jul 2020 08:49:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=pE/yc1u9tbBnLpY8dDHGbLYSYG7E7GuM8aEpfRg5vG8=;
 b=WLx2aa4nCoSXblDSJ2stQgiOyACLI9F9oQIRzzAylg0qn8H+lGRH4xWKUUbWnhKxC0l9
 PW2Kqdhp87AqCNPtQ4Q8PKHSQC9salydczxfHr4TskjrbhRsD/G1/y4htbS747evPZrb
 FCDKSitCkvV65RwNIpLPMbj4zZZ0avqFTGgjHJAqK21xE3g6fjXhfFqFW2xDz/4WFLg9
 5mpeQeAuOmxDp4tsORzwUrSml8H0ps/MWTKRAHYOWeHLkoSFkQcTtsWbSAvvKa8CNZtR
 U9ZW82S1KDIZ03OsUYMvO9IMlbDufd019FaY+nz8Zg9msPynA26Q89FVVwVmNkViFYPq dw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asnja56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 08:49:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:49:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 08:49:00 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 7C92D3F703F;
        Wed, 15 Jul 2020 08:48:58 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 01/10] net: atlantic: move FRAC_PER_NS to aq_hw.h
Date:   Wed, 15 Jul 2020 18:48:33 +0300
Message-ID: <20200715154842.305-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715154842.305-1-irusskikh@marvell.com>
References: <20200715154842.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch moves FRAC_PER_NS to aq_hw.h so that it can be used in both
hw_atl (A1) and hw_atl2 (A2) in the future.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  2 ++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 20 +++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index f2663ad22209..284ea943e8cd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -36,6 +36,8 @@ enum aq_tc_mode {
 			(AQ_RX_LAST_LOC_FVLANID - AQ_RX_FIRST_LOC_FVLANID + 1U)
 #define AQ_RX_QUEUE_NOT_ASSIGNED   0xFFU
 
+#define AQ_FRAC_PER_NS 0x100000000LL
+
 /* Used for rate to Mbps conversion */
 #define AQ_MBPS_DIVISOR         125000 /* 1000000 / 8 */
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index b023c3324a59..97672ff142a8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -54,8 +54,6 @@
 	.mac_regs_count = 88,		  \
 	.hw_alive_check_addr = 0x10U
 
-#define FRAC_PER_NS 0x100000000LL
-
 const struct aq_hw_caps_s hw_atl_b0_caps_aqc100 = {
 	DEFAULT_B0_BOARD_BASIC_CAPABILITIES,
 	.media_type = AQ_HW_MEDIA_TYPE_FIBRE,
@@ -1233,7 +1231,7 @@ static void hw_atl_b0_adj_params_get(u64 freq, s64 adj, u32 *ns, u32 *fns)
 	if (base_ns != nsi * NSEC_PER_SEC) {
 		s64 divisor = div64_s64((s64)NSEC_PER_SEC * NSEC_PER_SEC,
 					base_ns - nsi * NSEC_PER_SEC);
-		nsi_frac = div64_s64(FRAC_PER_NS * NSEC_PER_SEC, divisor);
+		nsi_frac = div64_s64(AQ_FRAC_PER_NS * NSEC_PER_SEC, divisor);
 	}
 
 	*ns = (u32)nsi;
@@ -1246,23 +1244,23 @@ hw_atl_b0_mac_adj_param_calc(struct hw_fw_request_ptp_adj_freq *ptp_adj_freq,
 {
 	s64 adj_fns_val;
 	s64 fns_in_sec_phy = phyfreq * (ptp_adj_freq->fns_phy +
-					FRAC_PER_NS * ptp_adj_freq->ns_phy);
+					AQ_FRAC_PER_NS * ptp_adj_freq->ns_phy);
 	s64 fns_in_sec_mac = macfreq * (ptp_adj_freq->fns_mac +
-					FRAC_PER_NS * ptp_adj_freq->ns_mac);
-	s64 fault_in_sec_phy = FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_phy;
-	s64 fault_in_sec_mac = FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_mac;
+					AQ_FRAC_PER_NS * ptp_adj_freq->ns_mac);
+	s64 fault_in_sec_phy = AQ_FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_phy;
+	s64 fault_in_sec_mac = AQ_FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_mac;
 	/* MAC MCP counter freq is macfreq / 4 */
 	s64 diff_in_mcp_overflow = (fault_in_sec_mac - fault_in_sec_phy) *
-				   4 * FRAC_PER_NS;
+				   4 * AQ_FRAC_PER_NS;
 
 	diff_in_mcp_overflow = div64_s64(diff_in_mcp_overflow,
 					 AQ_HW_MAC_COUNTER_HZ);
-	adj_fns_val = (ptp_adj_freq->fns_mac + FRAC_PER_NS *
+	adj_fns_val = (ptp_adj_freq->fns_mac + AQ_FRAC_PER_NS *
 		       ptp_adj_freq->ns_mac) + diff_in_mcp_overflow;
 
-	ptp_adj_freq->mac_ns_adj = div64_s64(adj_fns_val, FRAC_PER_NS);
+	ptp_adj_freq->mac_ns_adj = div64_s64(adj_fns_val, AQ_FRAC_PER_NS);
 	ptp_adj_freq->mac_fns_adj = adj_fns_val - ptp_adj_freq->mac_ns_adj *
-				    FRAC_PER_NS;
+				    AQ_FRAC_PER_NS;
 }
 
 static int hw_atl_b0_adj_sys_clock(struct aq_hw_s *self, s64 delta)
-- 
2.25.1

