Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E25665B48
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjAKMYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjAKMYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:24:01 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291956376
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:24:01 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30B15u6w024740;
        Wed, 11 Jan 2023 04:23:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=EgMTpDPS/aUxHv+052Wosji40nDkHXXG6wCPzQ5R1KY=;
 b=D1kxFkTO2Jh94d/rmLH4Se0HaPQZmPNWadW719e9QNXjRqFFj7cQc6xLTDVyvh33BZGi
 2IxFKVJU3IIXYIlxyHe6upsilzda2m+SK7OXneoQIIBpzCv+mqN8iRMVbiTlXblMo5eZ
 8o9rBZwh3MOI3O91ytuSoWPv/XIKRDvt9fyR0cI5r8E5PTw79ehB66aNTLWp8NUBxmQj
 9HNuAb5fX8OgQ0809f1KI+zz5qiVRJ5WUw7hYwH/bFhLr/6OvEqu//UdyWFrSUbdmxr6
 tW/TJpNF5fOsRgxd2Lk8oy6UEIOYwyTbTXSSnkHy4Z04Y7LldgvYutyFbBatImiva/zu KQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k55hgtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 04:23:49 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 11 Jan
 2023 04:23:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 11 Jan 2023 04:23:48 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 9E4E63F704A;
        Wed, 11 Jan 2023 04:23:44 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v2 net-next,0/8] octeontx2-af: Miscellaneous changes for CPT
Date:   Wed, 11 Jan 2023 17:53:35 +0530
Message-ID: <20230111122343.928694-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: bN9gHoWv4gvNQ6OdwFE30_0oLv3DKY9Y
X-Proofpoint-ORIG-GUID: bN9gHoWv4gvNQ6OdwFE30_0oLv3DKY9Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_05,2023-01-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset consists of miscellaneous changes for CPT.
- Adds a new mailbox to reset the requested CPT LF.
- Modify FLR sequence as per HW team suggested.
- Adds support to recover CPT engines when they gets fault.
- Updates CPT inbound inline IPsec configuration mailbox,
  as per new generation of the OcteonTX2 chips.
- Adds a new mailbox to return CPT FLT Interrupt info.

---
v2:
- Addressed a review comment.
v1:
- Dropped patch "octeontx2-af: Fix interrupt name strings completely"
  to submit to net.
---

Nithin Dabilpuram (1):
  octeontx2-af: restore rxc conf after teardown sequence

Srujana Challa (7):
  octeontx2-af: recover CPT engine when it gets fault
  octeontx2-af: add mbox for CPT LF reset
  octeontx2-af: modify FLR sequence for CPT
  octeontx2-af: optimize cpt pf identification
  octeontx2-af: update CPT inbound inline IPsec config mailbox
  octeontx2-af: add ctx ilen to cpt lf alloc mailbox
  octeontx2-af: add mbox to return CPT_AF_FLT_INT info

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  33 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   8 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  18 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 309 +++++++++++++-----
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  46 ++-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   2 +
 6 files changed, 324 insertions(+), 92 deletions(-)

-- 
2.25.1

