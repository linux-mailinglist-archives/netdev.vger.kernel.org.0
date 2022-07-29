Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35736585306
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbiG2PoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbiG2PoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:44:09 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E2012630
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:44:08 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T5jieK018129;
        Fri, 29 Jul 2022 08:44:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tli9JCW43/csm+kJbULfiNvILYIdNIL880ZnJQQH0Wc=;
 b=XuGkMNzkOmAl0Ixl6n9zekhELQ7goUcZ93ehRTPJhlbV3jucJI7Kme7Y2qBB7DOyjHY+
 5FbAgY9SPYXRHMJkQv1XuUoAOaBmY9JbuXhbB/TJTeEvRzmpd4qkyTbygEq8c1W59Qlk
 wr3cmjXMWR7No0kFE3Q0gMRfxO+z3J+3I4R08vgLXYF8xZJOnDFO9kJ45nVTVNpv0RWC
 mUQVauqi5OeGqXVgXVhUWfefmUvsCAIszJVJmd3SSnX+9Z0bL/T0hF+Bqz00yokFzu1u
 /SpAUBFuPn+46Cb/OjHmy+Eachu44I4HVJO9LXawE1mi91iPCkkZzJ9tFOHSxc14QR+e KQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hkyq13t6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:44:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Jul
 2022 08:44:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 29 Jul 2022 08:44:01 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 89E713F7082;
        Fri, 29 Jul 2022 08:43:58 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Harman Kalra <hkalra@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net v3 PATCH 2/5] octeontx2-af: suppress external profile loading warning
Date:   Fri, 29 Jul 2022 21:13:47 +0530
Message-ID: <1659109430-31748-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1659109430-31748-1-git-send-email-sbhatta@marvell.com>
References: <1659109430-31748-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: WhcPn_eZ3bHk1l90-yeFRyux3b2r2bzg
X-Proofpoint-ORIG-GUID: WhcPn_eZ3bHk1l90-yeFRyux3b2r2bzg
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

