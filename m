Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F93F3F2D
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhHVMDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25974 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231571AbhHVMDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MB0KTb005798;
        Sun, 22 Aug 2021 05:02:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qzToyglDQMprVvtHMsjaHZSxNkpUas3nIBGCae6uXo8=;
 b=Ze7Vy2iSEnt1WZn5s2UzEhVxtMo/WUcDX+dBiRkznJBup26grr1oYQ9QfRFJX6NpDjYT
 XDA/Mrr7JtbfwXHUxEQpajF4DX9FLWElZTWkvApksRNw9ZEwIbFSAi5ttp4w1mIYsfnR
 3Q9P+ipIS0cLEKzLoE0UNyFK3T6kLPDRolm7oCTmHWDQW0/M6quEoiRhY/QY33WhSsi+
 k0Kxy2V0ZODE5W5JoOEJCcCV9laLCSGnbMiU+RCTlSzyhOAxs1LYqXCXnTtaZ+wQ6sNP
 STlzcuNiMUHcpYIaj1NbmWKOQQq3fR/FLTMk33JQYxwvxNPVsXrhchmKkVRhnk1/Mz2T Ew== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr63-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:50 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 82F7B3F7060;
        Sun, 22 Aug 2021 05:02:48 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 05/10] octeontx2-pf: send correct vlan priority mask to npc_install_flow_req
Date:   Sun, 22 Aug 2021 17:32:22 +0530
Message-ID: <1629633747-22061-6-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: zn6vbldWQcrRLCCOqQWsly3JBCUT6i1w
X-Proofpoint-ORIG-GUID: zn6vbldWQcrRLCCOqQWsly3JBCUT6i1w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

This patch corrects the erroneous vlan priority mask field that was
send to npc_install_flow_req.

Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on ingress traffic")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 972b202..32d5c62 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -485,8 +485,8 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 				   match.key->vlan_priority << 13;
 
 			vlan_tci_mask = match.mask->vlan_id |
-					match.key->vlan_dei << 12 |
-					match.key->vlan_priority << 13;
+					match.mask->vlan_dei << 12 |
+					match.mask->vlan_priority << 13;
 
 			flow_spec->vlan_tci = htons(vlan_tci);
 			flow_mask->vlan_tci = htons(vlan_tci_mask);
-- 
2.7.4

