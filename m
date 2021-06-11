Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136073A3F43
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhFKJoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:44:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56782 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230212AbhFKJoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:44:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B9fNnC001006;
        Fri, 11 Jun 2021 02:42:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=k8EeLRgkKpZtRyXtWoRsHLE3yIXvOiT1e/G+GKfhDFE=;
 b=brZw25T35xqSkkCu+Hhe0gyqGOhC7ON1DOGGkv1yGfck52F0gu9b/gAY9T4n1SLiVB5K
 9D3+SAWGXvZxUYUTcyaQwAvYoOnGnd/D4/ltxrD89JBDSqYSoPve1XLpY7+GPjdhVKre
 necMD0I4Mc996tlOto7/8Vc7YdMAwr+QzXDl7nmp3otgRwJ1eKyrzjmOHPM7A+ZWusUl
 l4KhhObCWwvnA0O0SFIUGD6Rma2Rpm4FsLBe9wqvC01cQ+G0iEOaVTChVWxurBNWn7cM
 60MOkgMLyLCC30QV40zVa0EOw6iRCpiOoOd3AE/0v0rLq2OUVp/0uxfzmWtlqnAuXZ/B Gw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 393x92hgmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 02:42:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Jun
 2021 02:42:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Jun 2021 02:42:19 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id A26E83F7084;
        Fri, 11 Jun 2021 02:42:16 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH net-next 0/4] Add trusted VF support
Date:   Fri, 11 Jun 2021 15:12:01 +0530
Message-ID: <20210611094205.28230-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: KJXGdw_KCZDjQwCStaGJsreWNfY36Ox7
X-Proofpoint-GUID: KJXGdw_KCZDjQwCStaGJsreWNfY36Ox7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_03:2021-06-11,2021-06-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for trusted VF. The trusted VF support
allows VFs to perform priviliged operations such as setting VF
interface in promiscuous mode, all-multicast mode and also
changing the VF MAC address even if it was asssigned by PF.

Patches #1 and #2 provides the necessary functionality for supporting
promiscuous and multicast packets on both the PF and VF.

Patches #3 and #4 enable trusted VF configuration support.

Hariprasad Kelam (2):
  octeontx2-af: add new mailbox to configure VF trust mode
  octeontx2-pf: add support for ndo_set_vf_trust

Naveen Mamindlapalli (2):
  octeontx2-af: add support for multicast/promisc packet replication
    feature
  octeontx2-nicvf: add ndo_set_rx_mode support for multicast & promisc

 drivers/net/ethernet/marvell/octeontx2/af/common.h |   5 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  14 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  42 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  55 +++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   5 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 270 ++++++++++++++----
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 308 ++++++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  21 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 132 +++++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  58 +++-
 12 files changed, 729 insertions(+), 190 deletions(-)

-- 
2.16.5

