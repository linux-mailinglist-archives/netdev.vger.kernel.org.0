Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A0C3168F3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 15:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhBJOSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 09:18:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17774 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231255AbhBJOSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 09:18:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11AEGPNB027370;
        Wed, 10 Feb 2021 06:17:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Lqq2GoXikNbD9if+1vmtyV2d/RVUrpvTAizpBSHm1Dw=;
 b=GbQsQU2U+UGdhHy1w3Bt9yrB2uZ+hMjp0NE/UgeFdj7mdWif1KC+NGCY0V/cEqoEhKIL
 D2reRZyDEhnFdqH/hemh3Ad0rdqgAFytfkuvhvaUmUZQ5Wgedeb964sHjNIB1DdWL0Bs
 oAtaOaKJkQwdkCbkmhoeLanhK2ul7myf2fMjWbFzQtX1gD3RSaLxM6TZqu0UbtEMlPqz
 wOE4D1T60kiofl0q11eYLxzbQE19PZQsVn3WhHYDUFClQjewq7L35TA6jZJDCbCMrFCg
 Wokq6ZS6fn3yoJIlXdzfgEdvdpJlN3FWrLbE3yJh5OFdieeAicm+h8pUNOjs7DHu9xR3 xw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrm1xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 06:17:42 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 06:17:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 06:17:40 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id AA9CE3F7040;
        Wed, 10 Feb 2021 06:17:37 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <lironh@marvell.com>
Subject: [net-next] net: mvpp2: add an entry to skip parser
Date:   Wed, 10 Feb 2021 16:17:13 +0200
Message-ID: <1612966633-11064-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_05:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This entry used when skipping the parser needed,
for example, the custom header pretended to ethernet header.

Suggested-by: Liron Himi <liron@marvell.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 15 +++++++++++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h |  3 ++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 0b2ff08..b968a20 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1173,6 +1173,21 @@ static void mvpp2_prs_mh_init(struct mvpp2 *priv)
 	/* Update shadow table and hw entry */
 	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_MH);
 	mvpp2_prs_hw_write(priv, &pe);
+
+	/* Set MH entry that skip parser */
+	pe.index = MVPP2_PE_MH_SKIP_PRS;
+	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_MH);
+	mvpp2_prs_sram_shift_set(&pe, MVPP2_MH_SIZE,
+				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
+	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
+
+	/* Mask all ports */
+	mvpp2_prs_tcam_port_map_set(&pe, 0);
+
+	/* Update shadow table and hw entry */
+	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_MH);
+	mvpp2_prs_hw_write(priv, &pe);
 }
 
 /* Set default entires (place holder) for promiscuous, non-promiscuous and
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
index 4b68dd3..c16e5b9 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
@@ -103,10 +103,11 @@
 #define MVPP2_PE_MAC_RANGE_START	(MVPP2_PE_MAC_RANGE_END - \
 						MVPP2_PRS_MAC_RANGE_SIZE + 1)
 /* VLAN filtering range */
-#define MVPP2_PE_VID_FILT_RANGE_END     (MVPP2_PRS_TCAM_SRAM_SIZE - 31)
+#define MVPP2_PE_VID_FILT_RANGE_END     (MVPP2_PRS_TCAM_SRAM_SIZE - 32)
 #define MVPP2_PE_VID_FILT_RANGE_START   (MVPP2_PE_VID_FILT_RANGE_END - \
 					 MVPP2_PRS_VLAN_FILT_RANGE_SIZE + 1)
 #define MVPP2_PE_LAST_FREE_TID          (MVPP2_PE_MAC_RANGE_START - 1)
+#define MVPP2_PE_MH_SKIP_PRS		(MVPP2_PRS_TCAM_SRAM_SIZE - 31)
 #define MVPP2_PE_IP6_EXT_PROTO_UN	(MVPP2_PRS_TCAM_SRAM_SIZE - 30)
 #define MVPP2_PE_IP6_ADDR_UN		(MVPP2_PRS_TCAM_SRAM_SIZE - 29)
 #define MVPP2_PE_IP4_ADDR_UN		(MVPP2_PRS_TCAM_SRAM_SIZE - 28)
-- 
1.9.1

