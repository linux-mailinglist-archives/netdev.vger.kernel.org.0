Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02E1583E7E
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 14:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbiG1MRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 08:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbiG1MRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 08:17:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBEB691D0;
        Thu, 28 Jul 2022 05:17:07 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SA4n5n032223;
        Thu, 28 Jul 2022 05:17:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+BixbfkLRoEVSlMXKnuj4O4Z7KmNTMJZZpE1nhzCvQ0=;
 b=fvuvuK+Mdo6RCYpAle6aT1GKo3qpLVGTq4lrrzpHyfIC8XEATabrrc/nb3c/mrm+zn6j
 rHXZIwnluBzDop4B546MeLyrQgy4m02+DTn1dXrSV5gMdtt8Z3wri7QhKpl1Jkok7nkI
 TmAC1KLMzMNcQRYc6XPEybu+r7YY9/ArPkLxtp9jLPIIzWApr8rDvCJwNn6fHfC5Xfdd
 49l0mN9UBo6nlZfjdkZRWU4+Msps3ar48ad59foirD8+2W4Y+vxJB0fGabSAdWtZYgYK
 fbYy5EWXF6whzsmBJWtOsjQZopqamXyfRChkW/vYL8KBwCXJe7NGdOlbY5NFPTGPwyMw Zg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hjyn8nm2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 05:17:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 28 Jul
 2022 05:16:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 28 Jul 2022 05:16:59 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id BEB2A3F703F;
        Thu, 28 Jul 2022 05:16:56 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 4/4] octeontx2-af: Initialize PTP_SEC_ROLLOVER register properly
Date:   Thu, 28 Jul 2022 17:46:38 +0530
Message-ID: <20220728121638.17989-5-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20220728121638.17989-1-naveenm@marvell.com>
References: <20220728121638.17989-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tR-aVwKvL_35yGz4GRUWM3dH3Ns0YvoF
X-Proofpoint-GUID: tR-aVwKvL_35yGz4GRUWM3dH3Ns0YvoF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_05,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the reset value of PTP_SEC_ROLLOVER is incorrect on
CNF10KB silicon, the ptp timestamps are inaccurate. This
patch initializes the PTP_SEC_ROLLOVER register properly
for the CNF10KB silicon.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 01f7dbad6b92..3411e2e47d46 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -52,12 +52,18 @@
 #define PTP_CLOCK_COMP				0xF18ULL
 #define PTP_TIMESTAMP				0xF20ULL
 #define PTP_CLOCK_SEC				0xFD0ULL
+#define PTP_SEC_ROLLOVER			0xFD8ULL
 
 #define CYCLE_MULT				1000
 
 static struct ptp *first_ptp_block;
 static const struct pci_device_id ptp_id_table[];
 
+static bool is_ptp_dev_cnf10kb(struct ptp *ptp)
+{
+	return (ptp->pdev->subsystem_device == PCI_SUBSYS_DEVID_CNF10K_B_PTP) ? true : false;
+}
+
 static bool is_ptp_dev_cn10k(struct ptp *ptp)
 {
 	return (ptp->pdev->device == PCI_DEVID_CN10K_PTP) ? true : false;
@@ -290,6 +296,10 @@ void ptp_start(struct ptp *ptp, u64 sclk, u32 ext_clk_freq, u32 extts)
 	/* sclk is in MHz */
 	ptp->clock_rate = sclk * 1000000;
 
+	/* Program the seconds rollover value to 1 second */
+	if (is_ptp_dev_cnf10kb(ptp))
+		writeq(0x3b9aca00, ptp->reg_base + PTP_SEC_ROLLOVER);
+
 	/* Enable PTP clock */
 	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
 
-- 
2.16.5

