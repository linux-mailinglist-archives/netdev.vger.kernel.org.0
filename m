Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A4057F574
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 16:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiGXORM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 10:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiGXORJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 10:17:09 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43C813CFB
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 07:17:07 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26OCwn9a023115;
        Sun, 24 Jul 2022 07:17:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1C9O0lsTO8dhn8X1jMZYXacZbeeZlorwx3eKSQYFLQ0=;
 b=B2SKy0Ct6Prn3HsfwMvar01w/rFDDFe2uus5SOqaPaIz0SnT265J5UtCHjp1RCMqtbb8
 cLqlXW4sI01omw1Ie5EMvP1PbqyiHU9Q+8kxivjVuyX4TCGSIYC6zImVxwSGQ+p6GD/2
 Ea43tgmtiBPqkCUUkqJORwR4M4pIN3gnjrZ881BfvIi0IXKWTG9+BpyXz4nQQb3qIrbE
 GZFQkYG14YT7rzPakqRnJxpit74tNzpZBd02awi5v86J2oK3fCP9L5jUDj8Fqg1qD0mj
 y9NKmeNbvp9ur33kF36+g9nt8TOAj+8vBbN1GNNHUIynbTdStdXIiW2aQqxsB5BATlqc ug== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hgebq32pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 07:17:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Jul
 2022 07:17:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Jul 2022 07:17:03 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id B75165E6871;
        Sun, 24 Jul 2022 07:16:56 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Harman Kalra <hkalra@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 2/5] octeontx2-af: suppress external profile loading warning
Date:   Sun, 24 Jul 2022 19:46:46 +0530
Message-ID: <1658672209-8837-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658672209-8837-1-git-send-email-sbhatta@marvell.com>
References: <1658672209-8837-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: TEn0jUrKxh9WAp0Qh30irH6eWVCQtxuM
X-Proofpoint-ORIG-GUID: TEn0jUrKxh9WAp0Qh30irH6eWVCQtxuM
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
index 3d99cb9..9404f86 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1650,7 +1650,7 @@ static void npc_load_kpu_profile(struct rvu *rvu)
 	 * Firmware database method.
 	 * Default KPU profile.
 	 */
-	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
+	if (!firmware_request_nowarn(&fw, kpu_profile, rvu->dev)) {
 		dev_info(rvu->dev, "Loading KPU profile from firmware: %s\n",
 			 kpu_profile);
 		rvu->kpu_fwdata = kzalloc(fw->size, GFP_KERNEL);
-- 
2.7.4

