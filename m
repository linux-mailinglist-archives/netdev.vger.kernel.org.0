Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CEC27978E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 09:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgIZHjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 03:39:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7188 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726311AbgIZHjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 03:39:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q7aDUW021201;
        Sat, 26 Sep 2020 00:39:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=IQnOUkZ6sLFlChrlEDseyysiBRMTlCYP3aJO6xT3wBU=;
 b=jvMDzzsA2j1SBRn1Bm4AvGatVmBfSPF3qX3jCdXri0656u8dH90LaeYFX77ri8F42hzH
 ayFDklMpy7paURvQdeDsK0MXjfdKKbqtkAJLInmIoEOVy7f3Qu+i5VVcIaLIsc+Vzuaj
 B+V7S3GChEhWmA4yiyJBuSn4jaOEYevyLN44uU7tE9c6BML/brQaXc3LCvELAYRkFE32
 /n+O+QSPfrep496shxrr8FQ4WZrg3iQPJnbi1lbXknknhzKKeW+l/Kr4CKM+wIWNNHW2
 29qslK4x/kvqh7EcbT4kNGl8WkBdj6VTGMFA3+AQnMqLPs2pD6RPWMOg8B4myUIjpYKr Tw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgnye63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 00:39:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 26 Sep
 2020 00:39:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 26 Sep
 2020 00:39:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 26 Sep 2020 00:39:14 -0700
Received: from cavium.com.marvell.com (unknown [10.29.8.35])
        by maili.marvell.com (Postfix) with ESMTP id 449643F7040;
        Sat, 26 Sep 2020 00:39:12 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <jerinj@marvell.com>, <davem@davemloft.net>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net PATCH] octeontx2-pf: Fix TCP/UDP checksum 
Date:   Sat, 26 Sep 2020 12:33:30 +0530
Message-ID: <1601103810-1723-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For TCP/UDP checksum offload feature in Octeontx2
expects L3TYPE to be set irrespective of IP header
checksum is being offloaded or not. Currently for
IPv6 frames L3TYPE is not being set resulting in
packet drop with checksum error. This patch fixes
this issue.

Fixes: 3ca6c4c88
("octeontx2-pf: Add packet transmission support")

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 3a5b34a..e46834e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -524,6 +524,7 @@ static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 			sqe_hdr->ol3type = NIX_SENDL3TYPE_IP4_CKSUM;
 		} else if (skb->protocol == htons(ETH_P_IPV6)) {
 			proto = ipv6_hdr(skb)->nexthdr;
+			sqe_hdr->ol3type = NIX_SENDL3TYPE_IP6;
 		}
 
 		if (proto == IPPROTO_TCP)
-- 
2.7.4

