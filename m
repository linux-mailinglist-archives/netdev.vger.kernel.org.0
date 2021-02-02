Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A8430C3D0
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbhBBPaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:30:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62472 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235379AbhBBP2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:28:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 112FPvFP001034;
        Tue, 2 Feb 2021 07:27:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=JMlancbKR9HiWzA8N3qZJ131xz9HwAK44kZqzdxEHAk=;
 b=FXCrhhAGlmdaXu52RpnoSwdUJfti87CYqkPJB5++MZ2MEXy/yFHvCujigdMpVbSZ59dx
 K7JUgpaSJrSTvQ8xANqi80oRtN+8aCgdxhkRAAYgoQQOYz/PDbfwdCzQMQNqJ4dH54oo
 eiMbwwCrdKTWx4321ALY4KBS62jY+nj1pLxCltRgQBjyLnm5EYZRdwdtqjL3mBQbsE27
 K7d43wkuBviGX73o13vsrXALP1J1FK+WYVIL+Q8VZN3Z7P5+y63us8EYjU1alp2UYCjx
 knBo/qTdxqu45BEJCF9caMsN3vk2oaR78Ru35CIu3dHoaquzOz4y8jCUFFlTfKojcRVZ sg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq7hn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 07:27:36 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 07:27:34 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 07:27:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Feb 2021 07:27:33 -0800
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 96F0C3F703F;
        Tue,  2 Feb 2021 07:27:30 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH v2,net-next,0/3] Support for OcteonTX2 98xx CPT block.
Date:   Tue, 2 Feb 2021 20:57:06 +0530
Message-ID: <20210202152709.20450-1-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_07:2021-02-02,2021-02-02 signatures=0
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
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   9 ++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 130 +++++++++++++++---
 .../marvell/octeontx2/af/rvu_debugfs.c        |  86 ++++++------
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   8 ++
 6 files changed, 178 insertions(+), 60 deletions(-)

-- 
2.29.0

