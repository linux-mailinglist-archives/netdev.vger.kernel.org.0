Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEED4BD736
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 08:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345965AbiBUHVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 02:21:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345967AbiBUHVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 02:21:15 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790B9C29;
        Sun, 20 Feb 2022 23:20:52 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21L77WYl017047;
        Sun, 20 Feb 2022 23:20:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=D9POKauQ93JR861ujroYZUErV9faV0QUX3Fz8jQG0GE=;
 b=AJ0foANETjuHon2jo5/t0lzcjGAiBrao/7qleO078CrhcZOu+edA9MCjBzaLB/Tde1VG
 nn48U+nB7IA0EL1WA8bAIUv8OAeFe+Wa/rUMDHP9WNoi7n11LGMiAm+QpxGTb3VdtJlH
 F9F7Q93tcOhIGYWIIx2mmbDDP7jSt/oMimFDSRvKQi0Si+6qiG499nk/sz3agN2geXSs
 j1MosPTqzB762WpYs2SesWxxxaCP+8ybHf6sNyRTjCdJwgjOjlT++j+ZqjO2RRnBCb/q
 xolrPwNpEZv9qadkBGbbMPBJJMcugdaEd99Ngst4Jao1IyZDu+6QW0awAqDhYQGHgScm +g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ebpvntcwt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 20 Feb 2022 23:20:49 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 23:21:09 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 20 Feb 2022 23:21:09 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6DA6C65E8B7;
        Sun, 20 Feb 2022 22:45:12 -0800 (PST)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <rsaladi2@marvell.com>
Subject: [net-next PATCH v2 0/2] RVU AF and NETDEV drivers' PTP updates.
Date:   Mon, 21 Feb 2022 12:15:06 +0530
Message-ID: <20220221064508.19148-1-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tnQ12jtt_tgGgionotusy7iwWjsPVS7g
X-Proofpoint-GUID: tnQ12jtt_tgGgionotusy7iwWjsPVS7g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_02,2022-02-18_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Add suppot such that RVU drivers support new timestamp format.
Patch 2: This patch adds workaround for PTP errata.

Changes made from  v1 to v2
1. CC'd Richard Cochran to review PTP related patches.
2. Removed a patch from the old patch series. Will submit the removed patch
separately.

Naveen Mamindlapalli (2):
  octeontx2-pf: cn10k: add support for new ptp timestamp format
  octeontx2-af: cn10k: add workaround for ptp errata

 .../net/ethernet/marvell/octeontx2/af/ptp.c   | 131 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/ptp.h   |   2 +
 .../marvell/octeontx2/nic/otx2_common.h       |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.c |   8 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.h |  15 ++
 .../marvell/octeontx2/nic/otx2_txrx.c         |   6 +-
 6 files changed, 155 insertions(+), 10 deletions(-)

--
2.17.1
