Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B425A42B636
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 07:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhJMF6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 01:58:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4782 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhJMF6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 01:58:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CMf9MV022235;
        Tue, 12 Oct 2021 22:56:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=F1WWg0azO0/2uVqPI2BGNQyv5hN+ngaXIUzY8ubdzBw=;
 b=V45b1dkFnrnI52LEX4IdFfJcFPv+IYKkXVeg/tOfSNsv/edU/ebvtJmXEbAIuNOZxyG0
 iYhpDiVd9GZ3onflQob1r5sNz7c5kTIrq+DvkZsZWg08Cyc2UQVhWxG7N0n8PudoTmS7
 Q3VhpQvTwpe0/AOsu4VCZhY/5lZ4v6lgKqg9rvaTBdNZqOjeAB9K19A1FjIuItSq/u1t
 N7NCzfrHUrPa6MZmFnBKfHdxAw/n5qAQvUqSHl/rabjXnXgpEdSauncV0AbIF7DkNY9/
 GVlNRN6/97vPlNDEN7rffrRXbP1CjuboW0npw2WScovl/NOLIi01pGp7oOM6//1+x8Ee aQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bnkcchhnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 22:56:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 22:56:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 22:56:25 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id B40373F708C;
        Tue, 12 Oct 2021 22:56:22 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v2 net-next 0/3] octeontx2-af: Miscellaneous changes for CPT
Date:   Wed, 13 Oct 2021 11:26:18 +0530
Message-ID: <20211013055621.1812301-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ihdg6EqvgSdQnetwVqG7gQK3PME0s5Hk
X-Proofpoint-GUID: ihdg6EqvgSdQnetwVqG7gQK3PME0s5Hk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_01,2021-10-13_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset consists of miscellaneous changes for CPT.
First patch enables the CPT HW interrupts, second patch
adds support for CPT LF teardown in non FLR path and 
final patch does CPT CTX flush in FLR handler.

v2:
- Fixed a warning reported by kernel test robot.

Nithin Dabilpuram (1):
  octeontx2-af: Perform cpt lf teardown in non FLR path

Srujana Challa (2):
  octeontx2-af: Enable CPT HW interrupts
  octeontx2-af: Add support to flush full CPT CTX cache

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  12 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  16 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   7 +-
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 466 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  11 +
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   2 +
 .../marvell/octeontx2/af/rvu_struct.h         |  18 +
 7 files changed, 517 insertions(+), 15 deletions(-)

-- 
2.25.1

