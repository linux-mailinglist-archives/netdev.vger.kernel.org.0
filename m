Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05143667E1
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbhDUJYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:24:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1618 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238090AbhDUJXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:23:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L9L8QF029714;
        Wed, 21 Apr 2021 02:23:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=hi9leK4dUzqA8CsGa1d12TiclISeJgVlYLTZIbiY8sE=;
 b=A9fJbhZRGvr2W7bd+7GMSN+s5VTYNyzokDNSH4l7SrJnj/cpsbBCyhCRgbNEq6Vnx/EJ
 KWWbLvEZwqXyhN/gwDGzapCwEzgI/yYTSqBY5jIosYgDgvUc1oGOao0+DPU6Qy9WqtPy
 w+in3Q6ODR3wZLVnDym5K+FXwSbDKFKDw6Wa4VhC4xb8+xDtfw24QjXQG+cnxI1MFNtO
 H9zgXYGE9JcPo3uBeOw17HQqYUR/PgZfo7R1vA3K4b43J6GqmhZkhBlSWn6qzcAKZ4Vx
 aZMV/FWq6NzBbMkyiyGQMJn7eAHfXDYVBk4cBpRd8TtPdqINDqRK6N8moaEY7ZjsUv5o gA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3828x6hext-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 02:23:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 02:23:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 02:23:15 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id E24993F7040;
        Wed, 21 Apr 2021 02:23:11 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <pathreya@marvell.com>, "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH v2 net-next 0/3] Add support for CN10K CPT block
Date:   Wed, 21 Apr 2021 14:52:59 +0530
Message-ID: <20210421092302.22402-1-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: lUNtJ6A8vRvKvw3g0GpVImPq71B0BXxb
X-Proofpoint-ORIG-GUID: lUNtJ6A8vRvKvw3g0GpVImPq71B0BXxb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-21,2021-04-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OcteonTX3 (CN10K) silicon is a Marvell next-gen silicon. CN10K CPT
introduces new features like reassembly support and some feature
enhancements.
This patchset adds new mailbox messages and some minor changes to
existing mailbox messages to support CN10K CPT.

v1-v2
Fixed sparse warnings.

Srujana Challa (3):
  octeontx2-af: cn10k: Mailbox changes for CN10K CPT
  octeontx2-af: cn10k: Add mailbox to configure reassembly timeout
  octeontx2-af: Add mailbox for CPT stats

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  61 ++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 192 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  21 ++
 3 files changed, 266 insertions(+), 8 deletions(-)

-- 
2.25.1

