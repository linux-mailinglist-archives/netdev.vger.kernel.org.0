Return-Path: <netdev+bounces-9185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C36727D2E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B26772816AF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9BEC2D1;
	Thu,  8 Jun 2023 10:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A87A3D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:50:23 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F07E6C;
	Thu,  8 Jun 2023 03:50:22 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3587nH4x023576;
	Thu, 8 Jun 2023 03:50:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=BMVJmJ9Wwi6DDocbr4R9KPClTDmv0/mHZ1/q6UzlCfI=;
 b=QurfP6dYARjjkKu5KfT8RXzOYC4Z8wfDYrAkuG9SSCKUw0ZQ+sJ6Tg68o0+TtdlZX6PS
 pJ8/sVezW8dGekRdmwoDXpHzDKEmTCP1RbkOo86/1qpLMjS36PiGqgRbZ0bwFz5sc//p
 UuksD7xgc9EPQjvYWNzoHlag6QVKJy6+8Bk2s8B2nBj6HJVuGy0UtnnktwTRg0ry6cXQ
 PGNJpcuqL29kTMzkkx5AmT106a2Xneu0Gwdpgo5ha1w4VNsbdsegOILeHsdbwqHpnkSA
 MoE74ZZCyW31saG+xeVTIP5D0UFcrqvL/ZaR4YdO8pE5D0xUbJ3NIimRRWb0GcVCsbE+ 8w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3r329c2c2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 03:50:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 8 Jun
 2023 03:50:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 8 Jun 2023 03:50:12 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id E39EC3F707C;
	Thu,  8 Jun 2023 03:50:09 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 0/6] RVU NIX AF driver updates 
Date: Thu, 8 Jun 2023 16:20:01 +0530
Message-ID: <20230608105007.26924-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 0E6211XKDvYHVOopBTFzgbz-lCOZVwPz
X-Proofpoint-ORIG-GUID: 0E6211XKDvYHVOopBTFzgbz-lCOZVwPz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_07,2023-06-08_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch series includes a few enhancements and other updates to the
RVU NIX AF driver.

The first patch adds devlink option to configure NPC MCAM high priority
zone entries reservation. This is useful when the requester needs more
high priority entries than default reserved entries.

The second patch adds support for RSS hash computation using L3 SRC or
DST only, or L4 SRC or DST only.

The third patch updates DWRR MTU configuration for CN10KB silicon. HW uses 
the DWRR MTU to compute DWRR weight.

Patch 4 configures the LBK link in TL3_TL2 configuration only when switch
mode is enabled.

Patch 5 adds an option in the mailbox request to enable/disable DROP_RE bit
which drops packets with L2 errors when set.

Patch 6 updates SMQ flush mechanism to stop other child nodes from
enqueuing any packets while SMQ flush is active. Otherwise SMQ flush may
timeout.

Kiran Kumar K (1):
  octeontx2-af: extend RSS supported offload types

Naveen Mamindlapalli (2):
  octeontx2-af: Add devlink option to adjust mcam high prio zone entries
  octeontx2-af: Set XOFF on other child transmit schedulers during SMQ
    flush

Nithin Dabilpuram (1):
  octeontx2-af: add option to toggle DROP_RE enable in rx cfg

Subbaraya Sundeep (1):
  octeontx2-af: Enable LBK links only when switch mode is on.

Sunil Goutham (1):
  octeontx2-af: cn10k: Set NIX DWRR MTU for CN10KB silicon

 .../ethernet/marvell/octeontx2/af/common.h    |   7 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  11 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  20 ++
 .../marvell/octeontx2/af/rvu_devlink.c        |  74 +++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 247 ++++++++++++++++--
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   3 +-
 .../marvell/octeontx2/af/rvu_switch.c         |  18 ++
 .../marvell/octeontx2/nic/otx2_common.c       |  18 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   1 +
 9 files changed, 379 insertions(+), 20 deletions(-)

-- 
2.39.0.198.ga38d39a4c5

0000-cover-letter.patch
0001-octeontx2-af-Add-devlink-option-to-adjust-mcam-high-.patch
0002-octeontx2-af-extend-RSS-supported-offload-types.patch
0003-octeontx2-af-cn10k-Set-NIX-DWRR-MTU-for-CN10KB-silic.patch
0004-octeontx2-af-Enable-LBK-links-only-when-switch-mode-.patch
0005-octeontx2-af-add-option-to-toggle-DROP_RE-enable-in-.patch
0006-octeontx2-af-Set-XOFF-on-other-child-transmit-schedu.patch

