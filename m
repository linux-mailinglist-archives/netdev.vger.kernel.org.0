Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12C0314D51
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhBIKnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:43:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10290 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231136AbhBIKhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:37:02 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119ATsdg022161;
        Tue, 9 Feb 2021 02:35:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=NE8OZ2nAUlw7+Ol9F9vkFyX/ZpxL08BPpyUncWAdA5k=;
 b=YcIWk+rhFjh7YeIGgOvsk5SMnwc2we1cFu4gNEQEOmwE3JykwtlM9k5DGTx0rzK1bZe+
 98X+al/i87wEYk8tKcmsS4NbQtdZYTtkYtIKqGzwvR0DvD7BoNHagVCjtpDzKWnqKG48
 EmGd3iaxcVHg8Zbn986d+Ij848U0kZ/XHP444xk43wUlSt38O6oYUCAUQQ1FtTK/8X/m
 teQUcfHpeRJ6Nz5nqcGH7fQyfpSfjvY4xg8LaX/v4VnnV1xviTvxIF5k1DG2Lm4AcLnk
 0g97ZFbovLZbjt9z3qQk4G3ShniCxov534srcYWMjsQs00IniXC9tcJbh7x3Uy+FspSk AA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrg12d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 02:35:38 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 02:35:37 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 02:35:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 02:35:37 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 829403F7041;
        Tue,  9 Feb 2021 02:35:33 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v4 net-next 0/7] ethtool support for fec and link configuration
Date:   Tue, 9 Feb 2021 16:05:24 +0530
Message-ID: <1612866931-79299-1-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
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
	- Fixed review comments
	- Corrected indentation issues
        - Return -ENOMEM incase of mbox allocation failure
	- added validation for input fecparams bitmask values
        - added more comments

V3:
	- Removed inline functions
        - Make use of ethtool helpers APIs to display supported
          advertised modes
        - corrected indentation issues
        - code changes such that return early in case of failure
          to aid branch prediction
v4:
	- Corrected indentation issues
	- Use FEC_OFF if user requests for FEC_AUTO mode
	- Do not clear fec stats in case of user changes
	  fec mode
	- dont hide fec stats depending on interface mode
	  selection


Christina Jacob (6):
  octeontx2-af: forward error correction configuration
  octeontx2-pf: ethtool fec mode support
  octeontx2-af: Physical link configuration support
  octeontx2-af: advertised link modes support on cgx
  octeontx2-pf: ethtool physical link status
  octeontx2-pf: ethtool physical link configuration

Felix Manlunas (1):
  octeontx2-af: Add new CGX_CMD to get PHY FEC statistics

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 258 +++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  10 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  70 +++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  89 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  82 +++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  20 ++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 381 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
 10 files changed, 917 insertions(+), 6 deletions(-)

--
2.7.4
