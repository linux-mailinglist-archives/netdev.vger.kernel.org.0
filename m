Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48D42F74E5
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbhAOJHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:07:11 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2206 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbhAOJHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:07:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10F8xcJ0013563;
        Fri, 15 Jan 2021 01:06:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vV5ZH/mzyRj1yVyCgZC+VvWBQs2yrBz3oAPXgy5DEbs=;
 b=UfXUDIqL5qDEe463qHyZggC3ry01sNmD8+KkjTRRyEqLkbX1EzugPdd7R4sLC8rPYRlA
 W1u3/gT60ew8itxGOQyIZRm0VhyKTlcLSbrUBOSm5jvdpals+io8FadnasxFyF4Y48/y
 1iCJvZM7xec7IfFGeAMjp6q3FmwyaaudrU23FX+MC0G895HNA6Ga5yWrucuOY/OO2XvD
 EVEYFiJZ/bq0EZGwzNBi+HWys41KdBQqVIGJLexODCcX2uQ6JlhLNyKz5RuvMW4wHtw6
 i1t+uZtENcPqxFpuQDVuGhVPQ1uJu4yQjTUuOsCz1cnTYxWs2oaiG8YshEJwtgOIGFrr +g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvq2311-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 01:06:26 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 01:06:24 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 01:06:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Jan 2021 01:06:22 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id 51CA03F7044;
        Fri, 15 Jan 2021 01:06:22 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <bupadhaya@marvell.com>
Subject: [PATCH net-next 3/3] qede: set default per queue rx/tx usecs coalescing parameters
Date:   Fri, 15 Jan 2021 01:06:10 -0800
Message-ID: <1610701570-29496-4-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
References: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_06:2021-01-15,2021-01-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we do the initialization of coalescing values on load.
Although the default device values are the same - explicit
config is better visible.

Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h         | 1 +
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 3 +--
 drivers/net/ethernet/qlogic/qede/qede_main.c    | 4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index ac12e5beb596..5270c9226b8b 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -581,6 +581,7 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 			    struct flow_cls_offload *f);
 
 void qede_forced_speed_maps_init(void);
+int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal);
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 void qede_poll_controller(struct net_device *dev);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 522736968496..e094a6ef299c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -819,8 +819,7 @@ static int qede_get_coalesce(struct net_device *dev,
 	return rc;
 }
 
-static int qede_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qede_fastpath *fp;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 2ff6c49de745..3eb821f55ccb 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -2337,6 +2337,7 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 		     bool is_locked)
 {
 	struct qed_link_params link_params;
+	struct ethtool_coalesce coal = {};
 	u8 num_tc;
 	int rc;
 
@@ -2399,6 +2400,9 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 
 	edev->state = QEDE_STATE_OPEN;
 
+	coal.rx_coalesce_usecs = QED_DEFAULT_RX_USECS;
+	coal.tx_coalesce_usecs = QED_DEFAULT_TX_USECS;
+	qede_set_coalesce(edev->ndev, &coal);
 	DP_INFO(edev, "Ending successfully qede load\n");
 
 	goto out;
-- 
2.17.1

