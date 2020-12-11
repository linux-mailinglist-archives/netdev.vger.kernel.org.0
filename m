Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADA22D7026
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 07:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391203AbgLKG06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 01:26:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59408 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389168AbgLKG02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 01:26:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BB6PbZX005950;
        Thu, 10 Dec 2020 22:25:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=/4HcnOXlrpMRHjusB7pCy+/peq/XG/WdaDpOkoqZKX4=;
 b=k3vCipjMAYtg1kifyE4TnfvpSgm26ZqS+l7nhcU8rLMgpq+oid3s9oIjuJHpIS9lm6QS
 qiXQsunfPf6I69CfRPR/lX97Voy8GyS07RR4zGg4IaNa7+BPG8uH7tB1sqBE5f3b8GKt
 xUWpzylq2QDxmsTYJ9wJPrEyoLjwN8Dgxog7mbGFKnl59OYFZq3dKhCXZycT80pO0cNN
 Sot9ugV6r7cq8JJGJq00Hi14LxWsnRDvedOUKvEh5xza7tvYkxUbtEg9GEssNMvgPrfi
 BarOVX8IPT954y1BeEMw0YsQzw0MsADYuRSxh3kAFZ0YfybXrW4yWplprGyzNX0lHkCm hw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 358akrhyvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 22:25:37 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 22:25:35 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 22:25:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Dec 2020 22:25:34 -0800
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 55B773F703F;
        Thu, 10 Dec 2020 22:25:27 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <george.cherian@marvell.com>, <willemdebruijn.kernel@gmail.com>,
        <saeed@kernel.org>, <jiri@resnulli.us>
Subject: [PATCHv6 net-next 0/3] Add devlink and devlink health reporters to 
Date:   Fri, 11 Dec 2020 11:55:23 +0530
Message-ID: <20201211062526.2302643-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic devlink and devlink health reporters.
Devlink health reporters are added for NPA block.

Address Jakub's comment to add devlink support for error reporting.
https://www.spinics.net/lists/netdev/msg670712.html

For now, I have dropped the NIX block health reporters. 
This series attempts to add health reporters only for the NPA block.
As per Jakub's suggestion separate reporters per event is used and also
got rid of the counters.

Change-log:
v6
 - Address Jakub comments
 - Add reporters per event for each block.
 - Remove the Sw counter.
 - Remove the mbox version from devlink info.

v5 
 - Address Jiri's comment
 - use devlink_fmsg_arr_pair_nest_start() for NIX blocks 

v4 
 - Rebase to net-next (no logic changes).
 
v3
 - Address Saeed's comments on v2.
 - Renamed the reporter name as hw_*.
 - Call devlink_health_report() when an event is raised.
 - Added recover op too.

v2
 - Address Willem's comments on v1.
 - Fixed the sparse issues, reported by Jakub.


George Cherian (3):
  octeontx2-af: Add devlink suppoort to af driver
  octeontx2-af: Add devlink health reporters for NPA
  docs: octeontx2: Add Documentation for NPA health reporters

 .../ethernet/marvell/octeontx2.rst            |  50 ++
 .../net/ethernet/marvell/octeontx2/Kconfig    |   1 +
 .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../marvell/octeontx2/af/rvu_devlink.c        | 770 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_devlink.h        |  55 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  23 +
 8 files changed, 912 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h

-- 
2.25.1

