Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46F0585302
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237664AbiG2PoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbiG2PoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:44:06 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8646012630
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:44:05 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T79fWY032223;
        Fri, 29 Jul 2022 08:43:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=1QQsOtP4ylEgLjhXVkPWnysp2bqIvKs760v5+UW0bdQ=;
 b=elpsw1HzBnWhDnbZcjrR1OOW9qySMQxRRA7z319xMvCJxoNBeX7Yka+P/uMjJQf4QZ5S
 mbw5WoYZ1BoZocM3zxR2y0nEEAesjzpFVmmOGWPoa5EpB8b/gLBONdy8sntW0YbMI+e9
 c4VWG26RN77G3bfCETHhz1lZVKxRIK9oSnvoHmCJdRl1rtITtdSJ18V+mUWVfol0zeLU
 deeM5eTw8i/SRocO0YOywE4559SGJmIluE3Zyrkva8Mjz9XI1bBwrMBmriaOrxQClFPS
 +GbW5coyFYA/TM+8IVFiES6WdatsNsHcKKaitE9LP1gXI7l7fmCdiBJ0guoSPAS3Hriu HA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hjyn8tsex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:43:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Jul
 2022 08:43:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 29 Jul 2022 08:43:55 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id EB8B33F707E;
        Fri, 29 Jul 2022 08:43:52 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net v3 PATCH 0/5] Octeontx2 AF driver fixes for NPC
Date:   Fri, 29 Jul 2022 21:13:45 +0530
Message-ID: <1659109430-31748-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zd82SUdK3gpfGWuxlWXTDb6Vfw0k9D00
X-Proofpoint-GUID: zd82SUdK3gpfGWuxlWXTDb6Vfw0k9D00
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_17,2022-07-28_02,2022-06-22_01
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


v3 changes:
As suggested by Jakub, 
  used request_firmware_direct() since no fallback is needed in patch 2.
  refactored code in patch 3 to avoid goto.

v2 changes:
Added the space which was missing between commit hash
and ("octeontx2-af for patch 4.

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
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 15 ++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 82 +++++++++++++++++-----
 5 files changed, 87 insertions(+), 23 deletions(-)

-- 
2.7.4

