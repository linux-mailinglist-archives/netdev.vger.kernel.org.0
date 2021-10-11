Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F459428A45
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 12:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbhJKKCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 06:02:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5016 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235602AbhJKKCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 06:02:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19AMXtO9018930;
        Mon, 11 Oct 2021 03:00:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=9onzqfpaY468Xd6+pmA8sUG3EXDNvBXqGu3D7GAIfms=;
 b=N2+cj64nrW6vivCXW8m5laEPnw7G78Cc4ae24eCa1KMzuTz6zoJ9uqGl55xOs0BVvZiE
 4BQ1Io0yo9A7vrrrvxwn6fViyASFdexYudxEZLgeHXZZ/Qzn50jNd5FzkI/8Y5MrhoYp
 w6fem/UXS4piNOYsjYSxAJKN1AprFcfH/N3JLNBAbKAUjC75IJmrmu5tpUfNZ72VXvfm
 /3KKmzV1Kwor/6AliBc6w8AU9HI0TlI2BuMR67bnfyboymQCAoPzDNomsrgA2PxWRERz
 bKZbA3VBEVEK2NyT0FnDhk/6Z8Fn7WBeejNi0d063xscZ9IJG3gaNTRaRzmUI+ojkAzv +w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bm1s0asbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 03:00:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 11 Oct
 2021 03:00:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 11 Oct 2021 03:00:48 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 0B4B63F707E;
        Mon, 11 Oct 2021 03:00:44 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next 0/3] octeontx2-af: Miscellaneous changes for CPT
Date:   Mon, 11 Oct 2021 15:30:40 +0530
Message-ID: <20211011100043.1657733-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: eQrSRz24j5uE403aVRBRB01ZibSGo-wK
X-Proofpoint-GUID: eQrSRz24j5uE403aVRBRB01ZibSGo-wK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_03,2021-10-07_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset consists of miscellaneous changes for CPT.
First patch enables the CPT HW interrupts, second patch
adds support for CPT LF teardown in non FLR path and 
final patch does CPT CTX flush in FLR handler.

Nithin Dabilpuram (1):
  octeontx2-af: Perform cpt lf teardown in non FLR path

Srujana Challa (2):
  octeontx2-af: Enable CPT HW interrupts
  octeontx2-af: Add support to flush full CPT CTX cache

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  12 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  16 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   7 +-
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 464 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  11 +
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   2 +
 .../marvell/octeontx2/af/rvu_struct.h         |  18 +
 7 files changed, 515 insertions(+), 15 deletions(-)

-- 
2.25.1

