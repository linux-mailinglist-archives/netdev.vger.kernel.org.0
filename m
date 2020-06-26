Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628DC20B875
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgFZSkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:40:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43150 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgFZSks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:40:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIFwE5003673;
        Fri, 26 Jun 2020 11:40:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=TGctgOD9DyZmGdPNlnO/CIxhLmmycO8RuRwWoffYgPg=;
 b=euUFqvG6cHBffIWczTBeL4Y+IJc6B2UoSPsdVzRz0WcEJbOIMx8zEsSEdnHra+qsRtLe
 5nqE3G/ZFiphyer7+D2LDlr90pr45yLSPyqqrQs4rCXTHX7uaoFwEb2s5bsjHhtpsxwo
 cWhfiAPnGTKwP8CX8u0u3RmYfUMVYStbg3wT3o1f4WLfOW9dM2/PIoihKpn8iHnRF4vb
 Qc7srX1j7B8QYSweU3z3FKkXCsl8GMwv3q7zilnyVKaGLqVy7Y58cKNx4yFjObAIp1ag
 +iXlbvlbiH3lT20VltBxOpvbKDY4bLP2Nf6+/QXW5WhIDqtQFHowOHOhEywjyx9DTSvH Tg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh5u7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:40:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:47 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 552423F7040;
        Fri, 26 Jun 2020 11:40:45 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 2/8] net: atlantic: fix variable type in aq_ethtool_get_pauseparam
Date:   Fri, 26 Jun 2020 21:40:32 +0300
Message-ID: <20200626184038.857-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626184038.857-1-irusskikh@marvell.com>
References: <20200626184038.857-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

This patch fixes the type for variable which is assigned from enum,
as such it should have been int, not u32.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index f352b206b5cf..51dfc12a44be 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -716,13 +716,12 @@ static void aq_ethtool_get_pauseparam(struct net_device *ndev,
 				      struct ethtool_pauseparam *pause)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
-	u32 fc = aq_nic->aq_nic_cfg.fc.req;
+	int fc = aq_nic->aq_nic_cfg.fc.req;
 
 	pause->autoneg = 0;
 
 	pause->rx_pause = !!(fc & AQ_NIC_FC_RX);
 	pause->tx_pause = !!(fc & AQ_NIC_FC_TX);
-
 }
 
 static int aq_ethtool_set_pauseparam(struct net_device *ndev,
-- 
2.25.1

