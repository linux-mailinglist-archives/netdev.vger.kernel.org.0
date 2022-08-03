Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D517588850
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 09:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbiHCHyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 03:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237318AbiHCHye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 03:54:34 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE63133E3C
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 00:54:33 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27372uxF020683;
        Wed, 3 Aug 2022 00:54:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tli9JCW43/csm+kJbULfiNvILYIdNIL880ZnJQQH0Wc=;
 b=kCwjVp86xVaMX/PvurME1h4FkDVy3qFlLVmdBmAjFwzWtjggF5y8qKKg1AFA7am/9BC0
 jKUX3H6k65zF2YgqqU+PS043GyHFcD5jWTtqnN8OeVNNsT4WAuDLzIQ2zrvFXfCAJtrK
 NMzozXKFEZ+hVrllcTV+IqEb3tRNhSWUMj6SbP3lnRjIkvvwfADWG1sQGjMi9jfRwJOG
 WsQp41A6Mz1w1NaB4PM6y+wTCWLdWl2pJQsYCnvi8ipPYzpBFGRNrmpiDQGVZYeuj3s8
 wCl+dZSXhOaHX19fYALg6F+a53QhwIWsA9uy1T4Egu/uDXqXW5vyGCxnAtbH4RKCvpTz lg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hq19kvqep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 00:54:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Aug
 2022 00:54:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 3 Aug 2022 00:54:26 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 1F5623F705C;
        Wed,  3 Aug 2022 00:54:23 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>
CC:     Harman Kalra <hkalra@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net v4 PATCH 2/4] octeontx2-af: suppress external profile loading warning
Date:   Wed, 3 Aug 2022 13:24:13 +0530
Message-ID: <1659513255-28667-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1659513255-28667-1-git-send-email-sbhatta@marvell.com>
References: <1659513255-28667-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LnXJUplrgnKczQF-_fdTgSxFWg5yKDnN
X-Proofpoint-GUID: LnXJUplrgnKczQF-_fdTgSxFWg5yKDnN
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

From: Harman Kalra <hkalra@marvell.com>

The packet parser profile supplied as firmware may not
be present all the time and default profile is used mostly.
Hence suppress firmware loading warning from kernel due to
absence of firmware in kernel image.

Fixes: 3a7244152f9c ("octeontx2-af: add support for custom KPU entries")
Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 3d99cb9..10a4210 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1650,7 +1650,7 @@ static void npc_load_kpu_profile(struct rvu *rvu)
 	 * Firmware database method.
 	 * Default KPU profile.
 	 */
-	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
+	if (!request_firmware_direct(&fw, kpu_profile, rvu->dev)) {
 		dev_info(rvu->dev, "Loading KPU profile from firmware: %s\n",
 			 kpu_profile);
 		rvu->kpu_fwdata = kzalloc(fw->size, GFP_KERNEL);
-- 
2.7.4

