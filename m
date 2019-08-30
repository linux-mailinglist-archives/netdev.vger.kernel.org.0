Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA479A315A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfH3Hmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:42:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727595AbfH3Hmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:42:32 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7U7dlu1026578;
        Fri, 30 Aug 2019 00:42:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=0tYOpfGAehBcuQ+sKmyutK0PWruLh41SBxSys4S7aLo=;
 b=CKuSFSNB88BAHX74sf8DfT/l/WYmr5599Wittrldu0heBK45yLfouXXfDlnYJK4B+OWm
 +dvqxUxzrTjWnxipF6cRtOfiQ8bX5ksZPYXnldYOGBomqYyeNgnJh6+81tP8w5efbdgw
 H4TxU/HQbgKESswG691moJ1JIpUMAmGxF4BBJ5vCzK4yMoA1SAnSb3ZA9y8obW4XujbE
 0H1Fz5BdecUfdOHM+o1hKeyq8V55iobSB6D9Gdrgg3pzDbbeC8ZsOcsgmgMUlZBRjf1T
 RMuD+psjwzEh4o5BC+TKMjSQETjvVNhgQBxq/OG0+h1Qa99zx+k17474nwuMQZ5k9e81 Mg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2upmepjc26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 00:42:31 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 00:42:30 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 00:42:30 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C8EAF3F7043;
        Fri, 30 Aug 2019 00:42:29 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7U7gTbJ008892;
        Fri, 30 Aug 2019 00:42:29 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7U7gT19008891;
        Fri, 30 Aug 2019 00:42:29 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 4/4] qede: Add support for dumping the grc data.
Date:   Fri, 30 Aug 2019 00:42:06 -0700
Message-ID: <20190830074206.8836-5-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190830074206.8836-1-skalluru@marvell.com>
References: <20190830074206.8836-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_03:2019-08-29,2019-08-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds driver support for configuring grc dump config flags, and
dumping the grc data via ethtool get/set-dump interfaces.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h         |  1 +
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 29 +++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 8f2adde..c303a92 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -181,6 +181,7 @@ enum qede_flags_bit {
 enum qede_dump_cmd {
 	QEDE_DUMP_CMD_NONE = 0,
 	QEDE_DUMP_CMD_NVM_CFG,
+	QEDE_DUMP_CMD_GRCDUMP,
 	QEDE_DUMP_CMD_MAX
 };
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 2359293..ec27a43 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -2001,6 +2001,10 @@ static int qede_set_dump(struct net_device *dev, struct ethtool_dump *val)
 		edev->dump_info.args[edev->dump_info.num_args] = val->flag;
 		edev->dump_info.num_args++;
 		break;
+	case QEDE_DUMP_CMD_GRCDUMP:
+		rc = edev->ops->common->set_grc_config(edev->cdev,
+						       val->flag, 1);
+		break;
 	default:
 		break;
 	}
@@ -2013,14 +2017,24 @@ static int qede_get_dump_flag(struct net_device *dev,
 {
 	struct qede_dev *edev = netdev_priv(dev);
 
+	if (!edev->ops || !edev->ops->common) {
+		DP_ERR(edev, "Edev ops not populated\n");
+		return -EINVAL;
+	}
+
 	dump->version = QEDE_DUMP_VERSION;
 	switch (edev->dump_info.cmd) {
 	case QEDE_DUMP_CMD_NVM_CFG:
 		dump->flag = QEDE_DUMP_CMD_NVM_CFG;
 		dump->len = QEDE_DUMP_NVM_BUF_LEN;
 		break;
-	default:
+	case QEDE_DUMP_CMD_GRCDUMP:
+		dump->flag = QEDE_DUMP_CMD_GRCDUMP;
+		dump->len = edev->ops->common->dbg_all_data_size(edev->cdev);
 		break;
+	default:
+		DP_ERR(edev, "Invalid cmd = %d\n", edev->dump_info.cmd);
+		return -EINVAL;
 	}
 
 	DP_VERBOSE(edev, QED_MSG_DEBUG,
@@ -2033,7 +2047,14 @@ static int qede_get_dump_data(struct net_device *dev,
 			      struct ethtool_dump *dump, void *buf)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	int rc;
+	int rc = 0;
+
+	if (!edev->ops || !edev->ops->common) {
+		DP_ERR(edev, "Edev ops not populated\n");
+		edev->dump_info.cmd = QEDE_DUMP_CMD_NONE;
+		edev->dump_info.num_args = 0;
+		return -EINVAL;
+	}
 
 	switch (edev->dump_info.cmd) {
 	case QEDE_DUMP_CMD_NVM_CFG:
@@ -2047,6 +2068,10 @@ static int qede_get_dump_data(struct net_device *dev,
 						      edev->dump_info.args[0],
 						      edev->dump_info.args[1]);
 		break;
+	case QEDE_DUMP_CMD_GRCDUMP:
+		memset(buf, 0, dump->len);
+		rc = edev->ops->common->dbg_all_data(edev->cdev, buf);
+		break;
 	default:
 		DP_ERR(edev, "Invalid cmd = %d\n", edev->dump_info.cmd);
 		rc = -EINVAL;
-- 
1.8.3.1

