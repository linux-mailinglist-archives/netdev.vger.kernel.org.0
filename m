Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3293054F9
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhA0HtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:49:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231259AbhA0Hqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:46:51 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10R7eAh9007630;
        Tue, 26 Jan 2021 23:46:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=WTQnzh0LgcVf2rQ7+Ri9eZmLuRuXJoRJ90feaJxnOdI=;
 b=Khutz+PSbJdTiTKo/kUiHw2JH83WYZFhjeJldu1eQQI29oX+lEzOHaEZwoukOpyn8oGD
 V+KXUhrGGz/tCbtn70OGN1AuXvh6JgPCWk6aQjXKJpYbXxkAu3+ESP1UeP6Z2RU1oAak
 u/b1OXRMC/VfsR5HjsCCvvVsntQxOwPK5CiKt28EXtraO0F9RnNg+NVsZMZQfVzA1EoU
 qzRCNDLEjnfGa61p8jeMNuWgMQmymfyWTowk7wRuMoi5zKzmW+rstJH5YG/m5xyvv1Oo
 E4dgBSL6e/qUdDLXslYkDVntkaNXUEY9bxAPv/t+EfrkfV68UZ/mBFgymEwMiUfCBzvx Mw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36b1xpg9nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jan 2021 23:46:00 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Jan
 2021 23:45:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Jan 2021 23:45:58 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id DE6353F703F;
        Tue, 26 Jan 2021 23:45:55 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Hariprasad Kelam <hkelam@marvell.com>
Subject: [Patch v2 net-next 0/7]  ethtool support for fec and link configuration
Date:   Wed, 27 Jan 2021 13:15:45 +0530
Message-ID: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_03:2021-01-26,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for forward error correction(fec) and
physical link configuration. Patches 1&2 adds necessary mbox handlers for fec
mode configuration request and to fetch stats. Patch 3 registers driver
callbacks for fec mode configuration and display. Patch 4&5 adds support of mbox
handlers for configuring link parameters like speed/duplex and autoneg etc.
Patche 6&7 registers driver callbacks for physical link configuration.

Change-log:
v2:
-Fixed review comments
	- Corrected indentation issues
        - Return -ENOMEM incase of mbox allocation failure
	- added validation for input fecparams bitmask values
        - added more comments


Christina Jacob (6):
  octeontx2-af: forward error correction configuration
  octeontx2-pf: ethtool fec mode support
  octeontx2-af: Physical link configuration support
  octeontx2-af: advertised link modes support on cgx
  octeontx2-pf: ethtool physical link status
  octeontx2-pf: ethtool physical link configuration

Felix Manlunas (1):
  octeontx2-af: Add new CGX_CMD to get PHY FEC statistics

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 257 +++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  10 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  70 +++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  87 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  82 +++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 ++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 393 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
 10 files changed, 928 insertions(+), 7 deletions(-)

--
2.7.4
