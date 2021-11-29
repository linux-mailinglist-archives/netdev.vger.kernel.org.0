Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A500461675
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244715AbhK2Nfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:35:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64026 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237248AbhK2Ndg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:33:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ATBwiGW010651;
        Mon, 29 Nov 2021 05:30:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=oto/Lok+7REacPcOc/ZsFyV5VywctQ6XBMAHobZZ4H8=;
 b=gpJXC+eIjzSmCdhFSQ3dD0Qo/EwImR46rVPp1CIYh3SgHbDAjNnB8iIylzDqBMPZjHCv
 A0nqq99gQT7WeRxZXNfUTvSnXWm78mMygbLVolLA1LeNmOF0CZuEAkdGtHBEWoGAyHxa
 7jKXUxfiws/GmJW2d9ANfMKPrsYwYeIdsEHEmutIEjFwbx+0s4lftbBnFI130GfsrTze
 oZ845rYBMtiUY0kgEG1RT1mN0ZyTaNOcPJ74RKFVqL8d9gSFvcu2PpuXd3dG1oPLmTkY
 KVRdhTwysTmOtg8GIUIG1lmmCIezXOiFgV6pcbQftB21QIZ46tOqtTdDd0pRQJZXmn3p 6w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cmgkptk0j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 05:30:19 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Nov
 2021 05:30:17 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 29 Nov 2021 05:30:17 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1EEB23F70C0;
        Mon, 29 Nov 2021 05:30:17 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ATDUGbB016160;
        Mon, 29 Nov 2021 05:30:16 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ATDUD9A016159;
        Mon, 29 Nov 2021 05:30:13 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>,
        <dbezrukov@marvell.com>, Sameer Saurabh <ssaurabh@marvell.com>
Subject: [PATCH net 3/7] atlantic: Fix to display FW bundle version instead of FW mac version.
Date:   Mon, 29 Nov 2021 05:28:25 -0800
Message-ID: <20211129132829.16038-4-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211129132829.16038-1-skalluru@marvell.com>
References: <20211129132829.16038-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2nH5Scwf8skl401zu6GgkwrA2ejZ2X31
X-Proofpoint-GUID: 2nH5Scwf8skl401zu6GgkwrA2ejZ2X31
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameer Saurabh <ssaurabh@marvell.com>

The correct way to reflect firmware version is to use bundle version.
Hence populating the same instead of MAC fw version.

Fixes: c1be0bf092bd2 ("net: atlantic: common functions needed for basic A2 init/deinit hw_ops")
Signed-off-by: Sameer Saurabh <ssaurabh@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index b7a9b0ed6df3..e164ac5b55a8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -500,9 +500,9 @@ u32 hw_atl2_utils_get_fw_version(struct aq_hw_s *self)
 	hw_atl2_shared_buffer_read_safe(self, version, &version);
 
 	/* A2 FW version is stored in reverse order */
-	return version.mac.major << 24 |
-	       version.mac.minor << 16 |
-	       version.mac.build;
+	return version.bundle.major << 24 |
+	       version.bundle.minor << 16 |
+	       version.bundle.build;
 }
 
 int hw_atl2_utils_get_action_resolve_table_caps(struct aq_hw_s *self,
-- 
2.27.0

