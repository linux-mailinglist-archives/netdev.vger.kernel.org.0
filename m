Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D7E2C569C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390104AbgKZODF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:03:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47170 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389434AbgKZODD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:03:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AQE0K5q028820;
        Thu, 26 Nov 2020 06:02:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=0lMQuVyeSLaCjUzlC/0+yjavvRfmhPNeL7CyRnFdi0I=;
 b=WywXpOSx+ju9aqH//zsTOHRswTK8cC8ZTBBMl7jq08q17/XrMJZzaATU4dfmEVMnuA2O
 dEHIZzDguyXVHKx3WE1MeNByvHB00AXqPuuxjO6yFooXCyUnXAU4bMwWfzbbM9IXoABg
 hIHnB8xcgmnx60w4jmZ8CXOHlFkCqmNQL/ivSIZySsaACHvD0mvAgJoHLLtmU19FiNlZ
 e7f0w7mPHf2IsbFwJgZdsP7OobzwjgBfNLwhw4RLzTy/pssCp4fw5+pQLNwzJRHzsT7Q
 zgqKvrYJBxTHqyrSvo6pjzZfGcVkzcnrnIOdM+/bcddt5wss5wI6wGCr94VyaKOkIMJP XA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39rhnvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 06:02:57 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Nov
 2020 06:02:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Nov 2020 06:02:55 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 482203F7041;
        Thu, 26 Nov 2020 06:02:52 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>,
        <willemdebruijn.kernel@gmail.com>, <saeed@kernel.org>,
        <jiri@resnulli.us>
Subject: [PATCHv5 net-next 0/3] Add devlink and devlink health reporters to 
Date:   Thu, 26 Nov 2020 19:32:48 +0530
Message-ID: <20201126140251.963048-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_04:2020-11-26,2020-11-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Add basic devlink and devlink health reporters.
Devlink health reporters are added for NPA and NIX blocks.
These reporters report the error count in respective blocks.

Address Jakub's comment to add devlink support for error reporting.
https://www.spinics.net/lists/netdev/msg670712.html

Change-log:
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
  octeontx2-af: Add devlink health reporters for NIX

 .../net/ethernet/marvell/octeontx2/Kconfig    |   1 +
 .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../marvell/octeontx2/af/rvu_devlink.c        | 978 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_devlink.h        |  82 ++
 .../marvell/octeontx2/af/rvu_struct.h         |  33 +
 7 files changed, 1107 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h

-- 
2.25.1

