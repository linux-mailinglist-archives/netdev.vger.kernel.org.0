Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C332A6445
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgKDM2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:28:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30662 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726344AbgKDM2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:28:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4CFYdF003064;
        Wed, 4 Nov 2020 04:28:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=06ZFklaZlFlEyXXVGhlAwXoIGkGPWoumDBv6Dc62Z2w=;
 b=KIOamuWlitMlCZ4W1ip46yXA5jcFWXWwt1kwM8KTaAj2VRfIIKmrxfCD47LhN+06jQ3k
 Heb3lA+GqzvfP8+emr5PSvmtJl6oihtqPGdkhynoOe9PQmyeo2cULRbXfLqou/+sn9i2
 FOmk3zyVpm8FoKkoJK03PpxKHHMcfWfWvxSUN3kLuy49M+1yiTO/dHTf6jGjfh8fJBdV
 yadhtv7hdj1tpHfQhujem3sxQ1py3/4dui2hSv5gzNWcRFzRpnkb7g9T6W98YlkXPimY
 FucsPgL9IOfW9bSwONSx1se2P8cS8AT6Lw0l8Kt35x5AKllT2RdaEpcblVc23zvS+qum qA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59n2udg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 04:28:05 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Nov
 2020 04:28:04 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Nov
 2020 04:28:04 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 4 Nov 2020 04:28:04 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 29CF23F703F;
        Wed,  4 Nov 2020 04:27:57 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>,
        <willemdebruijn.kernel@gmail.com>
Subject: [PATCH v2 net-next 0/3] Add devlink and devlink health reporters to
Date:   Wed, 4 Nov 2020 17:57:52 +0530
Message-ID: <20201104122755.753241-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_08:2020-11-04,2020-11-04 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic devlink and devlink health reporters.
Devlink health reporters are added for NPA and NIX blocks.
These reporters report the error count in respective blocks.

Address Jakub's comment to add devlink support for error reporting.
https://www.spinics.net/lists/netdev/msg670712.html

Change-log:
- Address Willem's comments on v1.
- Fixed the sparse issues, reported by Jakub.

George Cherian (3):
  octeontx2-af: Add devlink suppoort to af driver
  octeontx2-af: Add devlink health reporters for NPA
  octeontx2-af: Add devlink health reporters for NIX

 .../net/ethernet/marvell/octeontx2/Kconfig    |   1 +
 .../ethernet/marvell/octeontx2/af/Makefile    |   3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../marvell/octeontx2/af/rvu_devlink.c        | 860 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_devlink.h        |  67 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  33 +
 7 files changed, 975 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h

-- 
2.25.4

