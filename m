Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FB942571C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242042AbhJGPy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:54:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52192 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241993AbhJGPyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:54:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197E1Vax012178;
        Thu, 7 Oct 2021 08:52:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0220;
 bh=6ioPN4uo+K4hsAg7R8Z942Zzjq+nqlKg+G+8OgsM8qc=;
 b=kw6oHNf9FZNcDgcmRIcIW/+WVDtHpGFjP1Rl+YvyLUFWNpn0a5GUejpstblj2cpFXKVY
 u6sUJh10TUpWbrl1QxSNdrbBenl1Ax8hVYiU2E36B2UkehQdW8oP4EXAXU6UUHAsbxkr
 bzc9XRm7Aan/o9UTeM3tYIXWNowT1cCT86xcJK9SIzgO+9k4pDoqYm+RGvyZtAXFV6SQ
 I0au/8U5je2H5253asB0ApoBpDfBUCF0FUsDZZVoX0paYFcr6dg4O+JrhKumQLd5vTaZ
 IJOZaExj/OM6w/iR/bxk1e0QoRiOHiX2KbUjhXO0GBDO9ChS/JGTWpQGTgFZF8+Egas2 qw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bhrg2axrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:52:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 7 Oct
 2021 08:52:53 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Thu, 7 Oct 2021 08:52:50 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <naresh.kamboju@linaro.org>, Omkar Kulkarni <okulkarni@marvell.com>
Subject: [PATCH][v2] qed: Fix compilation for CONFIG_QED_SRIOV undefined scenario
Date:   Thu, 7 Oct 2021 18:52:38 +0300
Message-ID: <20211007155238.4487-1-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: rPUOTMY9-Gjcy6lJiXUb21cr9pxpkxvN
X-Proofpoint-ORIG-GUID: rPUOTMY9-Gjcy6lJiXUb21cr9pxpkxvN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_02,2021-10-07_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes below compliation error in case CONFIG_QED_SRIOV not
defined.
drivers/net/ethernet/qlogic/qed/qed_dev.c: In function
‘qed_fw_err_handler’:
drivers/net/ethernet/qlogic/qed/qed_dev.c:2390:3: error: implicit
declaration of function ‘qed_sriov_vfpf_malicious’; did you mean
‘qed_iov_vf_task’? [-Werror=implicit-function-declaration]
   qed_sriov_vfpf_malicious(p_hwfn, &data->err_data);
   ^~~~~~~~~~~~~~~~~~~~~~~~
   qed_iov_vf_task
drivers/net/ethernet/qlogic/qed/qed_dev.c: In function
‘qed_common_eqe_event’:
drivers/net/ethernet/qlogic/qed/qed_dev.c:2410:10: error: implicit
declaration of function ‘qed_sriov_eqe_event’; did you mean
‘qed_common_eqe_event’? [-Werror=implicit-function-declaration]
   return qed_sriov_eqe_event(p_hwfn, opcode, echo, data,
          ^~~~~~~~~~~~~~~~~~~
          qed_common_eqe_event

Fixes: fe40a830dcde ("qed: Update qed_hsi.h for fw 8.59.1.0")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
This patch is targeted for the repo
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git

Changes for v2:
  - Fixed patchwork's netdev/verify_fixes "error".


 drivers/net/ethernet/qlogic/qed/qed_sriov.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index 1edf9c44dc67..f448e3dd6c8b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -478,6 +478,18 @@ static inline int qed_sriov_disable(struct qed_dev *cdev, bool pci_enabled)
 static inline void qed_inform_vf_link_state(struct qed_hwfn *hwfn)
 {
 }
+
+static inline void qed_sriov_vfpf_malicious(struct qed_hwfn *p_hwfn,
+					    struct fw_err_data *p_data)
+{
+}
+
+static inline int qed_sriov_eqe_event(struct qed_hwfn *p_hwfn, u8 opcode,
+				      __le16 echo, union event_ring_data *data,
+				      u8  fw_return_code)
+{
+	return 0;
+}
 #endif
 
 #define qed_for_each_vf(_p_hwfn, _i)			  \
-- 
2.24.1

