Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4F3A3158
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbfH3Hm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:42:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727681AbfH3Hm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:42:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7U7dltx026578;
        Fri, 30 Aug 2019 00:42:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=fYCX6gTwJlDfqkcoRyf49ghtKXpAkog9HvcfqWFMLwc=;
 b=HpPe/jJsKdqDvFCGiAJ+mQgMiUeIIzLyeKG+OkEEWxLHtJVl40v/w9MbvWJxkjrFL+UL
 zkcr8uS5EHMiNdCft5jGeA8R0W7U8lbvzTF/pLvROjpKRy0s0R0YRX5fAM9Er//vnBBR
 77h1W8y00iTgEJsr8GzTWTZ5BuHoLyEhULKoEwqTCT9dtrPR22PjMTl7txsQz6kgBZHx
 ywvGZfgsbUB72hbi8KrVcYkT5MDLjYt1vOSK2h6gzWuvgJM7kP00KhbE+c2SP7Ujm/Ts
 D4F3ShYX7s31nb6shQDYABWfw9t1qIlD3c66xFByPvk52NZwKzGTQF6Y/Bbu1GB3KDeU Zg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2upmepjc1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 00:42:25 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 00:42:23 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 00:42:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 65B283F7043;
        Fri, 30 Aug 2019 00:42:23 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7U7gNcb008884;
        Fri, 30 Aug 2019 00:42:23 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7U7gN7C008883;
        Fri, 30 Aug 2019 00:42:23 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 2/4] qede: Add support for reading the config id attributes.
Date:   Fri, 30 Aug 2019 00:42:04 -0700
Message-ID: <20190830074206.8836-3-skalluru@marvell.com>
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

Add driver support for dumping the config id attributes via ethtool dump
interfaces.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h         | 14 ++++
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 89 +++++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 0e931c0..8f2adde 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -177,6 +177,19 @@ enum qede_flags_bit {
 	QEDE_FLAGS_TX_TIMESTAMPING_EN
 };
 
+#define QEDE_DUMP_MAX_ARGS 4
+enum qede_dump_cmd {
+	QEDE_DUMP_CMD_NONE = 0,
+	QEDE_DUMP_CMD_NVM_CFG,
+	QEDE_DUMP_CMD_MAX
+};
+
+struct qede_dump_info {
+	enum qede_dump_cmd cmd;
+	u8 num_args;
+	u32 args[QEDE_DUMP_MAX_ARGS];
+};
+
 struct qede_dev {
 	struct qed_dev			*cdev;
 	struct net_device		*ndev;
@@ -262,6 +275,7 @@ struct qede_dev {
 	struct qede_rdma_dev		rdma_info;
 
 	struct bpf_prog *xdp_prog;
+	struct qede_dump_info		dump_info;
 };
 
 enum QEDE_STATE {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index abcee47..2359293 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -48,6 +48,9 @@
 	 {QEDE_RQSTAT_OFFSET(stat_name), QEDE_RQSTAT_STRING(stat_name)}
 
 #define QEDE_SELFTEST_POLL_COUNT 100
+#define QEDE_DUMP_VERSION	0x1
+#define QEDE_DUMP_NVM_BUF_LEN	32
+#define QEDE_DUMP_NVM_ARG_COUNT	2
 
 static const struct {
 	u64 offset;
@@ -1973,6 +1976,89 @@ static int qede_get_module_eeprom(struct net_device *dev,
 	return rc;
 }
 
+static int qede_set_dump(struct net_device *dev, struct ethtool_dump *val)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	int rc = 0;
+
+	if (edev->dump_info.cmd == QEDE_DUMP_CMD_NONE) {
+		if (val->flag > QEDE_DUMP_CMD_MAX) {
+			DP_ERR(edev, "Invalid command %d\n", val->flag);
+			return -EINVAL;
+		}
+		edev->dump_info.cmd = val->flag;
+		edev->dump_info.num_args = 0;
+		return 0;
+	}
+
+	if (edev->dump_info.num_args == QEDE_DUMP_MAX_ARGS) {
+		DP_ERR(edev, "Arg count = %d\n", edev->dump_info.num_args);
+		return -EINVAL;
+	}
+
+	switch (edev->dump_info.cmd) {
+	case QEDE_DUMP_CMD_NVM_CFG:
+		edev->dump_info.args[edev->dump_info.num_args] = val->flag;
+		edev->dump_info.num_args++;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+static int qede_get_dump_flag(struct net_device *dev,
+			      struct ethtool_dump *dump)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+
+	dump->version = QEDE_DUMP_VERSION;
+	switch (edev->dump_info.cmd) {
+	case QEDE_DUMP_CMD_NVM_CFG:
+		dump->flag = QEDE_DUMP_CMD_NVM_CFG;
+		dump->len = QEDE_DUMP_NVM_BUF_LEN;
+		break;
+	default:
+		break;
+	}
+
+	DP_VERBOSE(edev, QED_MSG_DEBUG,
+		   "dump->version = 0x%x dump->flag = %d dump->len = %d\n",
+		   dump->version, dump->flag, dump->len);
+	return 0;
+}
+
+static int qede_get_dump_data(struct net_device *dev,
+			      struct ethtool_dump *dump, void *buf)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	int rc;
+
+	switch (edev->dump_info.cmd) {
+	case QEDE_DUMP_CMD_NVM_CFG:
+		if (edev->dump_info.num_args != QEDE_DUMP_NVM_ARG_COUNT) {
+			DP_ERR(edev, "Arg count = %d required = %d\n",
+			       edev->dump_info.num_args,
+			       QEDE_DUMP_NVM_ARG_COUNT);
+			return -EINVAL;
+		}
+		rc =  edev->ops->common->read_nvm_cfg(edev->cdev, (u8 **)&buf,
+						      edev->dump_info.args[0],
+						      edev->dump_info.args[1]);
+		break;
+	default:
+		DP_ERR(edev, "Invalid cmd = %d\n", edev->dump_info.cmd);
+		rc = -EINVAL;
+		break;
+	}
+
+	edev->dump_info.cmd = QEDE_DUMP_CMD_NONE;
+	edev->dump_info.num_args = 0;
+
+	return rc;
+}
+
 static const struct ethtool_ops qede_ethtool_ops = {
 	.get_link_ksettings = qede_get_link_ksettings,
 	.set_link_ksettings = qede_set_link_ksettings,
@@ -2014,6 +2100,9 @@ static int qede_get_module_eeprom(struct net_device *dev,
 	.get_tunable = qede_get_tunable,
 	.set_tunable = qede_set_tunable,
 	.flash_device = qede_flash_device,
+	.get_dump_flag = qede_get_dump_flag,
+	.get_dump_data = qede_get_dump_data,
+	.set_dump = qede_set_dump,
 };
 
 static const struct ethtool_ops qede_vf_ethtool_ops = {
-- 
1.8.3.1

