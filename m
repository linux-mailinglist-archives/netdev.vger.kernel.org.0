Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF094661F49
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbjAIHgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbjAIHgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:36:17 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F551F00
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 23:36:16 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 308KUlvx008041;
        Sun, 8 Jan 2023 23:36:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=A3/H62BDChbbNJAqpDOqg50XIcEpnh7p68D1jQuvFns=;
 b=E6pwJhM5jDgDMiSGMOI0ohrFj+hfwTB9pdyEQAqIMBKxaOWxdyzTPGORsTB11FenpEma
 L1G99SYB/KNf2gu0NKuW50697b9IOQEQ1sMML32TdCxw7w6HHQ+FZIhsouk3fXfd3Cgc
 hn+SRP75BJw1uZ6tKtiomLvv0yZykA5VGQO5VbLPOWSvn9Skwbkos45uHmQrvP7BIHgP
 my6fLgYRF6+PT+4ysA6NMx3jBbMUhj4HjTkjldLxAoABi2EVSLVjXmzo4CSo8lmk1kUh
 zGo1dr6gCUAQ4LQX3KD/DGLFkaGVm1gUm4QQKN+3sqkk84INOeIoLMkaH06Ud6G7UDoN zw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3my94tmmm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 08 Jan 2023 23:36:09 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 8 Jan
 2023 23:36:07 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Sun, 8 Jan 2023 23:36:07 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 9DC233F7057;
        Sun,  8 Jan 2023 23:36:04 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH net-next 0/9] octeontx2-af: Miscellaneous changes for CPT
Date:   Mon, 9 Jan 2023 13:05:54 +0530
Message-ID: <20230109073603.861043-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: L5-2qSztxZdpnDULjTAwObOupyld2ZMN
X-Proofpoint-GUID: L5-2qSztxZdpnDULjTAwObOupyld2ZMN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_02,2023-01-06_01,2022-06-22_01
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
- Adds a new mailbox to retuen CPT FLT Interrupt info.

Dave Kleikamp (1):
  octeontx2-af: Fix interrupt name strings completely

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
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 308 +++++++++++++-----
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  46 ++-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   2 +
 6 files changed, 323 insertions(+), 92 deletions(-)

-- 
2.25.1

