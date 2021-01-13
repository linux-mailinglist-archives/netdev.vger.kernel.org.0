Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855652F4E65
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbhAMPVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:21:19 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26796 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727105AbhAMPVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:21:18 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DF54pY012940;
        Wed, 13 Jan 2021 07:20:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=88dwH/rdI8nsLHGYwDGUbJpwFmgrrLKRMOlWJLNOxWk=;
 b=jtVe1eSRvm1o0dhMKjFTqnCVk4wVG16sMBLUDCRs/eQbAyGFfo31wbI2EGV7b/nJL3lQ
 2qa7yXVSVyFxH9JCF9GQnx7b8VAv87VVQJVHyBBw+a2E3t/RPHo93rwxf7e/jWb7sT4+
 YNWxEfUX/WJ4Cf04ZjeegPU9e3ss475Ke3SII2dn7UCUUaCkO1cTMRx94iKIDvn10o8a
 Kvf2VePCt7wIdauf+m9MZgzGYgrUTlT1hIqaF3feoHP7sD2X6MszxywJriDpsec09tax
 siryD9jPDq2RwaU8Cp1/4n8kJuYUcxsaC6cL2ep6Ri0cdUou5p5AYzcNWpNKLWCYK7oI pw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvputyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 07:20:33 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 13 Jan
 2021 07:20:32 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 13 Jan
 2021 07:20:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 13 Jan 2021 07:20:31 -0800
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 733343F7044;
        Wed, 13 Jan 2021 07:20:28 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH net-next,0/3] Support for OcteonTX2 98xx CPT block.
Date:   Wed, 13 Jan 2021 20:50:04 +0530
Message-ID: <20210113152007.30293-1-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OcteonTX2 series of silicons have multiple variants, the
98xx variant has two crypto (CPT) blocks to double the crypto
performance. This patchset adds support for new CPT block(CPT1). 

Srujana Challa (3):
  octeontx2-af: Mailbox changes for 98xx CPT block
  octeontx2-af: Add support for CPT1 in debugfs
  octeontx2-af: Handle CPT function level reset

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   3 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 115 +++++++++++++++---
 .../marvell/octeontx2/af/rvu_debugfs.c        |  45 ++++---
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   8 ++
 6 files changed, 140 insertions(+), 35 deletions(-)

-- 
2.29.0

