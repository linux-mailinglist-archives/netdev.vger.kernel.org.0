Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93BD58884E
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 09:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbiHCHyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 03:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbiHCHy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 03:54:28 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265C022B20
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 00:54:28 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2735uGg3020610;
        Wed, 3 Aug 2022 00:54:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=iPuEaAAmo3frhqqcsJeut22yfGBnLVP7rW2ucRowpc4=;
 b=TZKptzz3Z5/n2YLxOhRrDckWAQtD90k6Sv0Dh7nsmLfS6QNnVBoOsv0ORmvQiZZ0rWlZ
 K4Cxz7+98m+qn8v/by+MBuPI0dP4oxrYjrpNLKvQmf6f/BGlTwGexTrxrqnp0fp+9RBu
 JFlrA7CLm3CFaiBgJ0kBiB5Bxw9VQuJqWyJDw50UIq2R/c7lVBPT44ySGad3aXE1eizM
 8T7KrtpA7EZygOPYQFjEY5PW2v1IkEhp47i9KzbhGS8TROC16wLI+TQ66RYWbhFTRIxh
 SKPtRrgJ12M8K6U3reiBPSikBir0E2dLOUsZmHnYQIXIXn1p6wtEF0/zVxbGVsnssnQL cA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hq19kvqe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 00:54:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 3 Aug
 2022 00:54:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Aug 2022 00:54:20 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id E6BAF3F7061;
        Wed,  3 Aug 2022 00:54:17 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net v4 PATCH 0/4] Octeontx2 AF driver fixes for NPC
Date:   Wed, 3 Aug 2022 13:24:11 +0530
Message-ID: <1659513255-28667-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tXWwXc9nzUtyKNBrUW71XxV_WAk-enl6
X-Proofpoint-GUID: tXWwXc9nzUtyKNBrUW71XxV_WAk-enl6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
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
Patch 3: This patch fixes a corner case where NIXLF is detached but
without freeing its mcam entries which results in resource leak.
Patch 4: SMAC is overlapped with DMAC mistakenly while installing
rules based on SMAC. This patch fixes that.


v4 changes:
As per Jakub's comment,
  removed one of the patches from v3 since it is not a fix

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

 drivers/net/ethernet/marvell/octeontx2/af/rvu.c        |  6 ++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 15 +++++++++++----
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

-- 
2.7.4

