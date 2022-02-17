Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C52D4BA899
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244589AbiBQSoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:44:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244579AbiBQSoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:44:00 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA421DA64;
        Thu, 17 Feb 2022 10:43:45 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21HFRgIJ025670;
        Thu, 17 Feb 2022 10:43:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=TzcLRrTJGvTR4fQ3NRsGIormP+RfPOcpKrwfSXCbHgQ=;
 b=eQK6VbhKj4vVh0vz7RKV/hp3nPsFbhntfkHeoWhDfLvEWs/0DKKg5O3gfyJj8nu3CpRq
 BczIV+roDo4ok6pR9Wxorj6nQaYf4hyIfC7Qv89PH+ZNZf0dx5QA0KTBFrKY/326zlJ+
 dCgURgwIRxqFkXL/MSUh0nc5Gcyd8xVtRMj5DYnvFVyY7BXw2VlUgUjZp/oJGUW7J6wV
 bkIfqoNo9tDCljAcMusVDD0/ck1E8ewusVez1yydM0T/ShqBL3Fa49SSRpgARRWX/AJu
 /fXGGaCG9jMqzM9Md8BRkgc5ZTMHpmS+t02h0rEMhjDDrKRVvSgcR4A8gC3pF9FTruAr dQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e9kktt9jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 10:43:41 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Feb
 2022 10:07:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 17 Feb 2022 10:07:42 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 63D063F70D6;
        Thu, 17 Feb 2022 10:04:59 -0800 (PST)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Rakesh Babu Saladi <rsaladi2@marvell.com>
Subject: [net-next PATCH 0/3] RVU AF and NETDEV drivers' PTP updates.
Date:   Thu, 17 Feb 2022 23:34:47 +0530
Message-ID: <20220217180450.21721-1-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ybBV4Q043bvrvBhlqbUZn7qkAMyMUbpN
X-Proofpoint-GUID: ybBV4Q043bvrvBhlqbUZn7qkAMyMUbpN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_07,2022-02-17_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch series contains the workarounds and new features that
are added to RVU AF and NETDEV drivers w.r.t PTP.

Patch 1: This patch introduces timestamp counter so that subsequent
PTP_CLOCK_HI can be obtained directly instead of processing a mbox
request.
Patch 2: Add suppot such that RVU drivers support new timestamp format.
Patch 3: This patch adds workaround for PTP errata.

Harman Kalra (1):
  octeontx2-af: Sending tsc value to the userspace

Naveen Mamindlapalli (2):
  octeontx2-pf: cn10k: add support for new ptp timestamp format
  octeontx2-af: cn10k: add workaround for ptp errata

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   2 +
 .../net/ethernet/marvell/octeontx2/af/ptp.c   | 154 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/ptp.h   |   2 +
 .../marvell/octeontx2/nic/otx2_common.h       |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.c |   8 +
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.h |  15 ++
 .../marvell/octeontx2/nic/otx2_txrx.c         |   6 +-
 7 files changed, 178 insertions(+), 12 deletions(-)

--
2.17.1
