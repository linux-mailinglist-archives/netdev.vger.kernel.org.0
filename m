Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B7527C120
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgI2J2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:28:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727960AbgI2J2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:28:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T9OkpO010934;
        Tue, 29 Sep 2020 02:28:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=Md7jn6SiKtIiwFQzm4t6b4gzPPmbDMm+KJCXYfcRJrM=;
 b=AtQyCFi/q1CvwUSzyP8HVngEig5DzawZwCex413KpdJih/ObY9TiuWELSzUxZrvsoe3M
 wmhFbPJGKQ3KmkQg6aC1KqGq4/0WyhjFxWRpkmiD1RfLhl4pnN7W2oLqgKTQogNgK79c
 UBUuVqQVxA8DT1u20uTKdNIi3hkN+tX+0DdaJPExs5fJxASCiHrWV+DXjep8JjEU5hC+
 Qex2bQfoNLA/bmSyHLGjooH7FGguqhugfHJMZ14A8pgifk+UR52uBhFLZ0Tbrvb0zjL8
 QznbpW3udOvJM1eXFq6fVdCELt9+RKUft1LmzA7qIcQzWijp2nLadub3yCw33vBjVTuX mg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemb7y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:28:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 02:28:48 -0700
Received: from yoga.marvell.com (unknown [10.95.131.226])
        by maili.marvell.com (Postfix) with ESMTP id C07803F703F;
        Tue, 29 Sep 2020 02:28:46 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Vidhya Vidhyaraman <vraman@marvell.com>
Subject: [PATCH net-next 5/7] octeontx2-af: Add IPv6 fields to default MKEX
Date:   Tue, 29 Sep 2020 11:28:18 +0200
Message-ID: <20200929092820.22487-6-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200929092820.22487-1-skardach@marvell.com>
References: <20200929092820.22487-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vidhya Vidhyaraman <vraman@marvell.com>

Added some IPv6 protocol fields to the default MKEX profile.
They include everything from the beginning of IP header and up to
source address. The pattern occupies full KW2 in MCAM entry.
Only one out of two LD registers for this protocol is used.

Signed-off-by: Vidhya Vidhyaraman <vraman@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 55264a8a25a3..5f71d3ccd6c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -13391,6 +13391,11 @@ static const struct npc_mcam_kex npc_mkex_default = {
 				/* TOS: 1 byte, KW1[63:56] */
 				KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf),
 			},
+			/* Layer C: IPv6 */
+			[NPC_LT_LC_IP6] = {
+				/* Everything up to SADDR: 8 bytes, KW2[63:0] */
+				KEX_LD_CFG(0x07, 0x0, 0x1, 0x0, 0x10),
+			},
 		},
 		[NPC_LID_LD] = {
 			/* Layer D:UDP */
-- 
2.20.1

