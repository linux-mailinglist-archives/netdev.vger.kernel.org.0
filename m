Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5F143C7AD
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 12:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbhJ0Kdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:33:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11732 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231643AbhJ0Kdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 06:33:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6I3r9032296;
        Wed, 27 Oct 2021 03:31:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=aLyWbOR+kLA5ZiYjECxHdHnKIsucTeuLNqngKF+cCDo=;
 b=Y2tvIttEa7osk4AxtNBYfgfsKE+Wm+4zpDYwsi9vY1hrq5dGGoJUjPvu+R+/KwskSkS4
 Cp6ruciuBpbtFPghwhnh74zxdi3azsUp/oiO0MuBY8Ur7qxiEAX8qWZm4rFlkaz3OqSC
 9JCMHgn7/PJZORGr9WZgJVMwsIN3N2Ty0AT/das61QZ5/3sI3eALGX7UEgsyDb/N4jJ3
 dGyNN4uNgzmv0NzrFyD6VKIcCQH4/ooTqD1N6ITa4ldRr31UCk1URif/gsLd4m77zrwf
 45jaWW3G3gpGmMfOnIXkvaFedOyj4DrJfZwakdEo/lWSTLB18D1Y5uePygNe1dcM7c4K VA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1ca8xnx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 03:31:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 03:31:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 03:31:19 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id B630D3F7070;
        Wed, 27 Oct 2021 03:31:17 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 0/2] Add a devlink param and documentation
Date:   Wed, 27 Oct 2021 16:01:13 +0530
Message-ID: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: UCHe8Bm917-64MJ9gFh15uygs36wFS2c
X-Proofpoint-ORIG-GUID: UCHe8Bm917-64MJ9gFh15uygs36wFS2c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds a new devlink parameter serdes_link
which is used in cases where physical link/SerDes needs to
be re-initialized. The existing interface up and down
sequence do not toggle SerDes configuration since PF and
all its VF share same physical link. Also documentation for
octeontx2 devlink parameters is missing hence documentation for
the implemented params is also added.

Patch 1 - Adds new serdes_link devlink parameter
Patch 2 - Adds documentation for all implemented devlink params


Thanks,
Sundeep

Rakesh Babu (1):
  octeontx2-pf: Add devlink param to init and de-init serdes

Subbaraya Sundeep (1):
  devlink: add documentation for octeontx2 driver

 Documentation/networking/devlink/index.rst         |  1 +
 Documentation/networking/devlink/octeontx2.rst     | 47 ++++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 11 +++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  7 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 24 +++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 20 +++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  | 29 +++++++++++++
 9 files changed, 141 insertions(+)
 create mode 100644 Documentation/networking/devlink/octeontx2.rst

-- 
2.7.4

