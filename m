Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3C33F74F4
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbhHYMTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:19:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41470 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240829AbhHYMTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:19:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6euWh015422;
        Wed, 25 Aug 2021 05:18:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=/64RlDMUiNVeCPX2jhsoJeFWrtWSy3JoUDHWe9MXIOo=;
 b=SByUNIeVObarw8xPwcGkgO2fNc6gurG0HZs0aiaE4CHh04PYvrNmTAcgAMsAbAVuj1ku
 V3ekEZj+5JYbLt1e/SPqOLyF+nL4jzdCDXoqxXXHlSP0gTK98nDyaZ/LxOn46sZEFFtp
 tskeMSvhHeiL64Kj+dS1TK4MchtJ1lVcRRqxLlUCZIgHNTUG8TIoRQ7b1FjEfOMpj+Pk
 QFc4n9MApFUX2+GzGJx3zmtMYPjWNG9orySoZ7iYFAIuCeYvauIylvNloaoFsWyh0VjX
 fA8LyMUmARy9Bo2FiRF55u21xwTkzvEtjhWx+xq67YE7TuqPqAWJkz3C2VfCkfKjwi// Sg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt017n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 05:18:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 25 Aug
 2021 05:18:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 25 Aug 2021 05:18:51 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id A81BA3F7067;
        Wed, 25 Aug 2021 05:18:49 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 0/9] Octeontx2: Traffic shaping and SDP link config support
Date:   Wed, 25 Aug 2021 17:48:37 +0530
Message-ID: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WRt6eie74mYBhLRtmLD-0vdbXmi7opCm
X-Proofpoint-GUID: WRt6eie74mYBhLRtmLD-0vdbXmi7opCm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_05,2021-08-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for traffic shaping configuration
on all silicons available after 96xx C0. And also adds SDP link
related configuration needed when Octeon is connected as an end-point
and traffic needs to flow from end-point to host and vice versa.

Series also has other changes like
- New mbox messages in admin function driver for PF/VF drivers
  to retrieve available HW resource count. HW resources like block LFs,
  bandwidth profiles etc are covered.
- Added PTP device ID for new CN10K and 95O silicons.
- etc

George Cherian (1):
  octeontx2-af: Add free rsrc count mbox msg

Harman Kalra (1):
  octeontx2-af: nix and lbk in loop mode in 98xx

Jerin Jacob (1):
  octeontx2-af: Allow to configure flow tag LSB byte as RSS adder

Nithin Dabilpuram (1):
  octeontx2-af: enable tx shaping feature for 96xx C0

Radha Mohan Chintakuntla (1):
  octeontx2-af: Add SDP interface support

Subbaraya Sundeep (2):
  octeontx2-pf: cleanup transmit link deriving logic
  octeontx2-af: Add PTP device id for CN10K and 95O silcons

Sunil Goutham (2):
  octeontx2-af: Remove channel verification while installing MCAM rules
  octeontx2-af: Add mbox to retrieve bandwidth profile free count

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  80 +++-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |  43 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 113 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  45 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 437 +++++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  55 +--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   5 -
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_sdp.c    | 108 +++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 13 files changed, 757 insertions(+), 165 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c

-- 
2.7.4

