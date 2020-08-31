Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67A42576C3
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgHaJoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:44:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14176 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgHaJol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 05:44:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07V9NDa1013670;
        Mon, 31 Aug 2020 02:44:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=xBc/b7MlULJeQkITKlogoIeCeUWYTBUbK6NFxu4fUFA=;
 b=ZVwsR/eIQ1wjHNzZ5oCxRNJs5wCIbU0HqAa6a4n5fHK5ZPSNlHFuPfnu/bfxjctUN6yX
 osODJlVqoFfsTntnnkJUkcWxVTwe1bebZXcmjMOwHvG5ROTP9sV/FvBmprrmpoiIN6KR
 MHnt3DgXjqpRQnSA1wbuSXrdNttZkdyoahC78KrEQsc7w8sE5tydPGm3M/zIE6aJ3Nda
 PbPkJG8Le9ngl1v2G0f7Z4LGD0/PLfBdmbj8jPj1kbj8R9nGzW1TTbxtTOJ/6GiQpOD1
 AOADXGzOrNFc7P+2bxtaM3vFMHso/tCPXZNEVH+cEWs75gJXtmRKSmuxyaQ4tPjIG+Mk Kg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phprc4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 02:44:37 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 Aug
 2020 02:44:36 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 Aug
 2020 02:44:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 Aug 2020 02:44:36 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.39.17])
        by maili.marvell.com (Postfix) with ESMTP id 114F53F703F;
        Mon, 31 Aug 2020 02:44:33 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v2 net 3/3] net: qed: RDMA personality shouldn't fail VF load
Date:   Mon, 31 Aug 2020 12:43:29 +0300
Message-ID: <a356c374d4b5456947242d27d325831f339fd569.1597833340.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <cover.1597833340.git.dbogdanov@marvell.com>
References: <cover.1597833340.git.dbogdanov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_01:2020-08-31,2020-08-31 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the assert during VF driver installation when the personality is iWARP

Fixes: 1fe614d10f45 ("qed: Relax VF firmware requirements")
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index f1f75b6d0421..b8dc5c4591ef 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -71,6 +71,7 @@ static int qed_sp_vf_start(struct qed_hwfn *p_hwfn, struct qed_vf_info *p_vf)
 		p_ramrod->personality = PERSONALITY_ETH;
 		break;
 	case QED_PCI_ETH_ROCE:
+	case QED_PCI_ETH_IWARP:
 		p_ramrod->personality = PERSONALITY_RDMA_AND_ETH;
 		break;
 	default:
-- 
2.17.1

