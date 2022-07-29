Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D45584E03
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbiG2JZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiG2JZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:25:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6015F51;
        Fri, 29 Jul 2022 02:25:12 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T6qABj032226;
        Fri, 29 Jul 2022 02:25:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=MUsZPYus2r48GMLBKtxWVkUeqxyL4L3SV3qJsWq6K28=;
 b=Gg1GpR7lfhmVLKpw/AyujD0ZGHwUYB+Ck/Rl/4iJfFddl46HxWSsiF1rFSLToKtRZ/Hr
 btv+9rTA9Kl7vl3/h1yC3va/u9zBcTbK+rxHSTypAr92JN+Ev6XedOIMI0IQ1uPxig8g
 zQpQdyAv1oFyrK5fjbFLzEypvSAYwFybS+NDgpL9rvyZL9UPmsoS6+NF/xaEsFmcj5LF
 EXgBb38D1kWgScbu3yDj/tkvy7/HJ/hmeGlNldvRy4Qyq4kaMBU2pL1I+d185xnYYe0S
 9ABnSRbmYfXZ6C0KKkp3ZPF4LV5yE+g5E2wKzkPeHIev6x7931M/gjIahMkCcgr7181H KA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hjyn8snkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 02:25:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Jul
 2022 02:25:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 29 Jul 2022 02:25:03 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 8FCD43F706A;
        Fri, 29 Jul 2022 02:25:00 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net PATCH v2] octeontx2-pf: Reduce minimum mtu size to 60
Date:   Fri, 29 Jul 2022 14:54:57 +0530
Message-ID: <20220729092457.3850-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: EiYM7sgwECUVfi05LDXqw9v0qu9g1aBS
X-Proofpoint-GUID: EiYM7sgwECUVfi05LDXqw9v0qu9g1aBS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

PTP messages like SYNC, FOLLOW_UP, DELAY_REQ are of size 58 bytes.
Using a minimum packet length as 64 makes NIX to pad 6 bytes of
zeroes while transmission. This is causing latest ptp4l application to
emit errors since length in PTP header and received packet are not same.
Padding upto 3 bytes is fine but more than that makes ptp4l to assume
the pad bytes as a TLV. Hence reduce the size to 60 from 64.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---

v2:
   no code changes, added PTP maintainer also.

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index c88e8a436029..fbe62bbfb789 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -21,7 +21,7 @@
 #define OTX2_HEAD_ROOM		OTX2_ALIGN
 
 #define	OTX2_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN)
-#define	OTX2_MIN_MTU		64
+#define	OTX2_MIN_MTU		60
 
 #define OTX2_MAX_GSO_SEGS	255
 #define OTX2_MAX_FRAGS_IN_SQE	9
-- 
2.16.5

