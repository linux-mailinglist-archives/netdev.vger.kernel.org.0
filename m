Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B322A57F572
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 16:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiGXORG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 10:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGXORE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 10:17:04 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B736012D29
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 07:17:03 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26OD0KS3025155;
        Sun, 24 Jul 2022 07:17:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=4PnfVbEDiI30kLA+xOaOPp1dyxqm93y1T7Zg6Wg0txI=;
 b=WHS7BaPkwmQNUBLAtx/edknF2s6dMwpr8p5cVk5yCVSZLmj5FR63jRYRIZ/rJw+NmiwD
 H1UfebU0T8ocNRwpoGJVix/E+NIv0vOh7lFvBit/dlryIV8HH1hh0m4IXihv3hhYUH97
 rLyrTNyFL06xHwWnpXfgCNTr+6gxVqlexoO6I4Oe/va9DxrEmcm9xdFFbZQHYvT32Ges
 TzyLjlzF1HviouF4u1FktkmxTbHT73t7xJlKUWSdsl+8DWBiSOp7Ys8xBrHDEo3WCKVW
 vv9VHnb88KHZyDlBn8nn2vduaAfEKn3rUuQLEH9aSiORRRfvWRyprvGzdYno3UR2gx0k Cg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hgebq32pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 07:17:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Jul
 2022 07:16:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Jul 2022 07:16:59 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id F14CB5E68AD;
        Sun, 24 Jul 2022 07:16:51 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 0/5] Octeontx2 AF driver fixes for NPC
Date:   Sun, 24 Jul 2022 19:46:44 +0530
Message-ID: <1658672209-8837-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: YEHLHGUTffZco7hZSN2Omc2URJqPEDI5
X-Proofpoint-ORIG-GUID: YEHLHGUTffZco7hZSN2Omc2URJqPEDI5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-23_02,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes AF driver fixes wrt packet parser NPC.
Following are the changes:

Patch 1: The parser nibble configuration must be same for
TX and RX interfaces and if not fix up is applied. This fixup was
applied only for default profile currently and it has been fixed
to apply for all profiles.
Patch 2: Firmware image may not be present all times in the kernel image
and default profile is used mostly hence suppress the warning.
Patch 3: Custom profiles may not extract DMAC into the match key
always. Hence fix the driver to allow profiles without DMAC extraction.
Patch 4: This patch fixes a corner case where NIXLF is detached but
without freeing its mcam entries which results in resource leak.
Patch 5: SMAC is overlapped with DMAC mistakenly while installing
rules based on SMAC. This patch fixes that.

Thanks,
Sundeep


Harman Kalra (1):
  octeontx2-af: suppress external profile loading warning

Stanislaw Kardach (1):
  octeontx2-af: Apply tx nibble fixup always

Subbaraya Sundeep (2):
  octeontx2-af: Fix mcam entry resource leak
  octeontx2-af: Fix key checking for source mac

Suman Ghosh (1):
  octeontx2-af: Allow mkex profiles without dmac.

 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  6 ++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  6 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 15 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 85 +++++++++++++++++-----
 5 files changed, 90 insertions(+), 23 deletions(-)

-- 
2.7.4

