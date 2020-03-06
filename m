Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DC117BDF2
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgCFNPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:15:51 -0500
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:32801
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgCFNPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:15:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZkl0w09khKLM3zJX2Saebnwk1f949LvPlXdCky5aTAOtzaQjvevzcLboZJUShsJIl9txLChHOv5KahXxg9ajmmWzbgSYzuutRT0MKyf3cvW40FEm4Xxn2UmRUlGJdGB8DvG9LxnJP8M8/e910zgrjFyPQMwLpOQ3JjDwOoIlsQxEC1zczUwJ35RYUQQubNiqfAx6TubCMX9UEQUtPIYAfgzAm8bJKKwv54TjS/v3ncmv5aAjEXtTdepZ0T6ZBDSasx2+xp0+7kgn/lKc0g/hKdY1c6Dw9VGhRHG1eHy60q3IZ0+PhhqiU1qWiUS2IkJeT8SFy7dRDL14xgh+Caxdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbwlpqCNv+wntYNHb1rDQUAb8W+k5JqaruXbCCKL0/U=;
 b=ZNGyxUBeDdr+s/1/EwdNvD0I1hoOwb++cW3vecvjBn8Ushb2v4xKsQi1rLShYhUlvJEYFs9ONSQ7cn1koANtSQccm8zwd/Z5tXoChLHeCax9BKlyZdntptQe4j89JFqvESD90GllDinQ/kPwHY3uJDEj6miKtyzeWqvSayrRoEMAjJH5zqVWFCblRKvZAQGMP6pU5EVBJEAhbXej3iRlnUSgPY32r3Jd85dnY0QyohVHhB3J8Qg8scF2BH4DVGFl5i36lomrrKYO/CS8NpwD+a607AgNiirYtiee3KcsreH6GGr5gjgkGs3cKjRl+e4y5/G0jR00RRG3Of9bpRpKMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbwlpqCNv+wntYNHb1rDQUAb8W+k5JqaruXbCCKL0/U=;
 b=KO0YbWN/1Jj5y89QA44mJ4JPSHcvfxxWl15uIsNz8ORAj9Yh5R82nIkv7lNQZo8+U+jg6rwxJFoUYTHYry78XXEJWCg1L+6opgv/yryKJTFHjtOa6wkKwoUC47EcCnFXEHNaNazfq+HShV99nQ1xvFpWoy2tTjSO0JWt5rwnMBg=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6527.eurprd04.prod.outlook.com (20.179.233.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Fri, 6 Mar 2020 13:15:21 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:15:21 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  5/9] net: enetc: add tc flower psfp offload driver
Date:   Fri,  6 Mar 2020 20:56:03 +0800
Message-Id: <20200306125608.11717-6-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:15:11 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9eab9414-09a3-41f5-3707-08d7c1d06c3f
X-MS-TrafficTypeDiagnostic: VE1PR04MB6527:|VE1PR04MB6527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB652743890714E7E2AB6C999092E30@VE1PR04MB6527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(189003)(199004)(16526019)(186003)(26005)(66476007)(6512007)(4326008)(36756003)(66556008)(7416002)(6666004)(86362001)(478600001)(1076003)(81156014)(8936002)(6506007)(316002)(30864003)(81166006)(956004)(5660300002)(8676002)(66946007)(2906002)(2616005)(6486002)(52116002)(142933001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6527;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZ57IIxcwbDIlrmv2QBsj5sL6vJf+WmztMek64Nw7o4iWM2dCnWaOwPoEGqsJ206pEUfEKI6AnxEf/tJrd3HpKeTn4Qlh84P3xitVdVQqQSHhyvcVKjnbNhTTk0MtT68O77ys58v5OBQpabIpa3vKebrZcMIi6jk6MxWFzVF7+feyg8uKEIcUu23SjyQBPglehhwYHAcsEdM3dpl55Hjy5HFXgjVCEbwlJDWaeTTdKEOyX5fguo+8zL8dIETgZH5qVsahsOjPUAtNS/YqFsZHGGgAsZbE0fAAKLHw76c/5SaenCVvpiWdl4hrITJEmKYvkGQ+ZbMIr+S6y8U04ntm/EPJDHYfpmc84i78TI3haGwPBMysq+nBFIYNf1DrRz5FnxgjWp9oLTQPgeLgovJOXJGR3Y6kg+zkljWXNooH+QSxRdpDXo2Y1zuB0VmhGYg+rFNf6q37ysbKHJdhKD3a02avKoY/KGuag6fc844Yoc=
X-MS-Exchange-AntiSpam-MessageData: p512XDazdqDO4DA+Dr/DFzuootGsHRgUBRRm5w9JKgCJe6wG3755EA/lNVwU8yHUeCrDbVA9J+ZbJ+Q25gQwkPXk9UXm3rKhePV2V5qCcMz2IV46vqRoioCzbEWpUSOvL48r6Cicn1cfkXU8uz6l0Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eab9414-09a3-41f5-3707-08d7c1d06c3f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:15:21.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3ErieM5xTmZb8xOd0qYOwLlYxMb9VVVxNSoiPwJT5cYQNwUmBUFgw1hfe/V/Jd+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add tc flower offload for the enetc IEEE 802.1Qci(PSFP)
function. There are four main feature parts to implement the flow
policing and filtering for ingress flow with IEEE 802.1Qci features.
They are stream identify(this is defined in the P802.1cb exactly but
needed for 802.1Qci), stream filtering, stream gate and flow metering.
Each function block includes many entries by index to assign parameters.
So for one frame would be filtered by stream identify first, then
flow into stream filter block by the same handle between stream identify
and stream filtering. Then flow into stream gate control which assigned
by the stream filtering entry. And then policing by the gate and limited
by the max sdu in the filter block(optional). At last, policing by the
flow metering block, index choosing at the fitering block.
So you can see that each entry of block may link to many upper entries
since they can be assigned same index means more streams want to share
the same feature in the stream filtering or stream gate or flow
metering.
To implement such features, each stream filtered by source/destination
mac address, some stream maybe also plus the vlan id value would be
treated as one flow chain. This would be identified by the chain_index
which already in the tc filter concept. Driver would maintain this chain
and also with gate modules. The stream filter entry create by the gate
index and flow meter(optional) entry id and also one priority value.
Offloading only transfer the gate action and flow filtering parameters.
Driver would create (or search same gate id and flow meter id and
 priority) one stream filter entry to set to the hardware. So stream
filtering do not need transfer by the action offloading.
This architecture is same with tc filter and actions relationship. tc
filter maintain the list for each flow feature by keys. And actions
maintain by the action list.

Below showing a example commands by tc:
> tc qdisc add dev eth0 ingress
> ip link set eth0 address 10:00:80:00:00:00
> tc filter add dev eth0 parent ffff: protocol ip chain 11 \
	flower skip_sw dst_mac 10:00:80:00:00:00 \
	action gate index 10 \
	sched-entry OPEN 200000000 -1 -1 \
	sched-entry CLOSE 100000000 -1 -1
(or just create one gate entry list to keep close)

That means to set the dst_mac 10:00:80:00:00:00 to index 11 of stream
identify module. And the set the gate index 10 of stream gate module.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  |   25 +-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   39 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  142 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |    4 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 1078 ++++++++++++++++-
 5 files changed, 1269 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index d810651317e1..df2e77619f64 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1520,6 +1520,8 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		return enetc_setup_tc_cbs(ndev, type_data);
 	case TC_SETUP_QDISC_ETF:
 		return enetc_setup_tc_txtime(ndev, type_data);
+	case TC_SETUP_BLOCK:
+		return enetc_setup_tc_psfp(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1572,17 +1574,23 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 static int enetc_set_psfp(struct net_device *ndev, int en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int err;
 
 	if (en) {
+		err = enetc_psfp_enable(priv);
+		if (err)
+			return err;
+
 		priv->active_offloads |= ENETC_F_QCI;
-		enetc_get_max_cap(priv);
-		enetc_psfp_enable(&priv->si->hw);
-	} else {
-		priv->active_offloads &= ~ENETC_F_QCI;
-		memset(&priv->psfp_cap, 0, sizeof(struct psfp_cap));
-		enetc_psfp_disable(&priv->si->hw);
+		return 0;
 	}
 
+	err = enetc_psfp_disable(priv);
+	if (err)
+		return err;
+
+	priv->active_offloads &= ~ENETC_F_QCI;
+
 	return 0;
 }
 
@@ -1590,14 +1598,15 @@ int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
+	int err = 0;
 
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
 
 	if (changed & NETIF_F_HW_TC)
-		enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
 
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index bcdade8f7b8a..f1a9a4cf1914 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -269,6 +269,11 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct net_device *ndev);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
 int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data);
+int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+			    void *cb_priv);
+int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data);
+int enetc_psfp_init(struct enetc_ndev_priv *priv);
+int enetc_psfp_clean(struct enetc_ndev_priv *priv);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
@@ -288,33 +293,59 @@ static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 	priv->psfp_cap.max_psfp_meter = reg & ENETC_PFMCAPR_MSK;
 }
 
-static inline void enetc_psfp_enable(struct enetc_hw *hw)
+static inline int enetc_psfp_enable(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
+	int err;
+
+	enetc_get_max_cap(priv);
+
+	err = enetc_psfp_init(priv);
+	if (err)
+		return err;
+
 	enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR)
 		 | ENETC_PPSFPMR_PSFPEN | ENETC_PPSFPMR_VS
 		 | ENETC_PPSFPMR_PVC | ENETC_PPSFPMR_PVZC);
+
+	return 0;
 }
 
-static inline void enetc_psfp_disable(struct enetc_hw *hw)
+static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
+	int err;
+
+	err = enetc_psfp_clean(priv);
+	if (err)
+		return err;
+
 	enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR)
 		 & ~ENETC_PPSFPMR_PSFPEN & ~ENETC_PPSFPMR_VS
 		 & ~ENETC_PPSFPMR_PVC & ~ENETC_PPSFPMR_PVZC);
+
+	memset(&priv->psfp_cap, 0, sizeof(struct psfp_cap));
+
+	return 0;
 }
+
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(ndev) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
 #define enetc_setup_tc_txtime(ndev, type_data) -EOPNOTSUPP
+#define enetc_setup_tc_psfp(ndev, type_data) -EOPNOTSUPP
+#define enetc_setup_tc_block_cb NULL
+
 #define enetc_get_max_cap(p)		\
 	memset(&((p)->psfp_cap), 0, sizeof(struct psfp_cap))
 
-static inline void enetc_psfp_enable(struct enetc_hw *hw)
+static inline int enetc_psfp_enable(struct enetc_hw *hw)
 {
 	return 0;
 }
 
-static inline void enetc_psfp_disable(struct enetc_hw *hw)
+static inline int enetc_psfp_disable(struct enetc_hw *hw)
 {
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 99d520207069..640099f48a0d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -570,6 +570,9 @@ enum bdcr_cmd_class {
 	BDCR_CMD_RFS,
 	BDCR_CMD_PORT_GCL,
 	BDCR_CMD_RECV_CLASSIFIER,
+	BDCR_CMD_STREAM_IDENTIFY,
+	BDCR_CMD_STREAM_FILTER,
+	BDCR_CMD_STREAM_GCL,
 	__BDCR_CMD_MAX_LEN,
 	BDCR_CMD_MAX_LEN = __BDCR_CMD_MAX_LEN - 1,
 };
@@ -601,13 +604,152 @@ struct tgs_gcl_data {
 	struct gce	entry[];
 };
 
+/* class 7, command 0, Stream Identity Entry Configuration */
+struct streamid_conf {
+	__le32	stream_handle;	/* init gate value */
+	__le32	iports;
+		u8	id_type;
+		u8	oui[3];
+		u8	res[3];
+		u8	en;
+};
+
+#define ENETC_CBDR_SID_VID_MASK 0xfff
+#define ENETC_CBDR_SID_VIDM BIT(12)
+#define ENETC_CBDR_SID_TG_MASK 0xc000
+/* streamid_conf address point to this data space */
+struct streamid_data {
+	union {
+		u8 dmac[6];
+		u8 smac[6];
+	};
+	u16     vid_vidm_tg;
+};
+
+#define ENETC_CBDR_SFI_PRI_MASK 0x7
+#define ENETC_CBDR_SFI_PRIM		BIT(3)
+#define ENETC_CBDR_SFI_BLOV		BIT(4)
+#define ENETC_CBDR_SFI_BLEN		BIT(5)
+#define ENETC_CBDR_SFI_MSDUEN	BIT(6)
+#define ENETC_CBDR_SFI_FMITEN	BIT(7)
+#define ENETC_CBDR_SFI_ENABLE	BIT(7)
+/* class 8, command 0, Stream Filter Instance, Short Format */
+struct sfi_conf {
+	__le32	stream_handle;
+		u8	multi;
+		u8	res[2];
+		u8	sthm;
+	/* Max Service Data Unit or Flow Meter Instance Table index.
+	 * Depending on the value of FLT this represents either Max
+	 * Service Data Unit (max frame size) allowed by the filter
+	 * entry or is an index into the Flow Meter Instance table
+	 * index identifying the policer which will be used to police
+	 * it.
+	 */
+	__le16	fm_inst_table_index;
+	__le16	msdu;
+	__le16	sg_inst_table_index;
+		u8	res1[2];
+	__le32	input_ports;
+		u8	res2[3];
+		u8	en;
+};
+
+/* class 8, command 2 stream Filter Instance status query short format
+ * command no need structure define
+ * Stream Filter Instance Query Statistics Response data
+ */
+struct sfi_counter_data {
+	u32 matchl;
+	u32 matchh;
+	u32 msdu_dropl;
+	u32 msdu_droph;
+	u32 stream_gate_dropl;
+	u32 stream_gate_droph;
+	u32 flow_meter_dropl;
+	u32 flow_meter_droph;
+};
+
+#define ENETC_CBDR_SGI_OIPV_MASK 0x7
+#define ENETC_CBDR_SGI_OIPV_EN	BIT(3)
+#define ENETC_CBDR_SGI_CGTST	BIT(6)
+#define ENETC_CBDR_SGI_OGTST	BIT(7)
+#define ENETC_CBDR_SGI_CFG_CHG  BIT(1)
+#define ENETC_CBDR_SGI_CFG_PND  BIT(2)
+#define ENETC_CBDR_SGI_OEX		BIT(4)
+#define ENETC_CBDR_SGI_OEXEN	BIT(5)
+#define ENETC_CBDR_SGI_IRX		BIT(6)
+#define ENETC_CBDR_SGI_IRXEN	BIT(7)
+#define ENETC_CBDR_SGI_ACLLEN_MASK 0x3
+#define ENETC_CBDR_SGI_OCLLEN_MASK 0xc
+#define	ENETC_CBDR_SGI_EN		BIT(7)
+/* class 9, command 0, Stream Gate Instance Table, Short Format
+ * class 9, command 2, Stream Gate Instance Table entry query write back
+ * Short Format
+ */
+struct sgi_table {
+	u8	res[8];
+	u8	oipv;
+	u8	res0[2];
+	u8	ocgtst;
+	u8	res1[7];
+	u8	gset;
+	u8	oacl_len;
+	u8	res2[2];
+	u8	en;
+};
+
+#define ENETC_CBDR_SGI_AIPV_MASK 0x7
+#define ENETC_CBDR_SGI_AIPV_EN	BIT(3)
+#define ENETC_CBDR_SGI_AGTST	BIT(7)
+
+/* class 9, command 1, Stream Gate Control List, Long Format */
+struct sgcl_conf {
+	u8	aipv;
+	u8	res[2];
+	u8	agtst;
+	u8	res1[4];
+	union {
+		struct {
+			u8 res2[4];
+			u8 acl_len;
+			u8 res3[3];
+		};
+		u8 cct[8]; /* Config change time */
+	};
+};
+
+#define ENETC_CBDR_SGL_IOMEN	BIT(0)
+#define ENETC_CBDR_SGL_IPVEN	BIT(3)
+#define ENETC_CBDR_SGL_GTST		BIT(4)
+#define ENETC_CBDR_SGL_IPV_MASK 0xe
+/* Stream Gate Control List Entry */
+struct sgce {
+	u32	interval;
+	u8	msdu[3];
+	u8	multi;
+};
+
+/* stream control list class 9 , cmd 1 data buffer */
+struct sgcl_data {
+	u32		btl;
+	u32		bth;
+	u32		ct;
+	u32		cte;
+	struct sgce	sgcl[0];
+};
+
 struct enetc_cbd {
 	union{
+		struct sfi_conf sfi_conf;
+		struct sgi_table sgi_table;
 		struct {
 			__le32	addr[2];
 			union {
 				__le32	opt[4];
 				struct tgs_gcl_conf	gcl_conf;
+				struct streamid_conf	sid_set;
+				struct sgcl_conf	sgcl_conf;
 			};
 		};	/* Long format */
 		__le32 data[6];
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index d880cbdc0d2e..a19095ab7b41 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -740,12 +740,10 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	if (si->hw_features & ENETC_SI_F_QBV)
 		priv->active_offloads |= ENETC_F_QBV;
 
-	if (si->hw_features & ENETC_SI_F_PSFP) {
+	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
 		ndev->features |= NETIF_F_HW_TC;
 		ndev->hw_features |= NETIF_F_HW_TC;
-		enetc_get_max_cap(priv);
-		enetc_psfp_enable(&si->hw);
 	}
 
 	/* pick up primary MAC address from SI */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 0c6bf3a55a9a..3ef46190d71d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -5,6 +5,8 @@
 
 #include <net/pkt_sched.h>
 #include <linux/math64.h>
+#include <net/pkt_cls.h>
+#include <net/tc_act/tc_gate.h>
 
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 {
@@ -108,13 +110,13 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);
 
 	for (i = 0; i < gcl_len; i++) {
-		struct tc_taprio_sched_entry *temp_entry;
+		struct tc_taprio_sched_entry *to;
 		struct gce *temp_gce = gce + i;
 
-		temp_entry = &admin_conf->entries[i];
+		to = &admin_conf->entries[i];
 
-		temp_gce->gate = (u8)temp_entry->gate_mask;
-		temp_gce->period = cpu_to_le32(temp_entry->interval);
+		temp_gce->gate = (u8)to->gate_mask;
+		temp_gce->period = cpu_to_le32(to->interval);
 	}
 
 	cbd.length = cpu_to_le16(data_size);
@@ -331,3 +333,1071 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 
 	return 0;
 }
+
+enum streamid_type {
+	STREAMID_TYPE_RESERVED = 0,
+	STREAMID_TYPE_NULL,
+	STREAMID_TYPE_SMAC,
+};
+
+enum streamid_vlan_tagged {
+	STREAMID_VLAN_RESERVED = 0,
+	STREAMID_VLAN_TAGGED,
+	STREAMID_VLAN_UNTAGGED,
+	STREAMID_VLAN_ALL,
+};
+
+#define ENETC_PSFP_WILDCARD -1
+#define HANDLE_OFFSET 100
+
+enum forward_type {
+	FILTER_ACTION_TYPE_PSFP = BIT(0),
+	FILTER_ACTION_TYPE_ACL = BIT(1),
+	FILTER_ACTION_TYPE_BOTH = GENMASK(1, 0),
+};
+
+/* This is for limit output type for input actions */
+struct actions_fwd {
+	u64 actions;
+	u64 keys;	/* include the must needed keys */
+	enum forward_type output;
+};
+
+struct psfp_streamfilter_counters {
+	u64 matching_frames_count;
+	u64 passing_frames_count;
+	u64 not_passing_frames_count;
+	u64 passing_sdu_count;
+	u64 not_passing_sdu_count;
+	u64 red_frames_count;
+};
+
+struct enetc_streamid {
+	u32 index;
+	union {
+		u8 src_mac[6];
+		u8 dst_mac[6];
+	};
+	u8 filtertype;
+	u16 vid;
+	u8 tagged;
+	s32 handle;
+};
+
+struct enetc_psfp_filter {
+	u32 index;
+	s32 handle;
+	s8 prio;
+	u32 gate_id;
+	s32 meter_id;
+	u32 refcount;
+	struct hlist_node node;
+};
+
+struct enetc_psfp_gate {
+	u32 index;
+	s8 init_ipv;
+	u64 basetime;
+	u64 cycletime;
+	u64 cycletimext;
+	u32 num_entries;
+	u32 refcount;
+	struct hlist_node node;
+	struct action_gate_entry entries[0];
+};
+
+struct enetc_stream_filter {
+	struct enetc_streamid sid;
+	u32 sfi_index;
+	u32 sgi_index;
+	struct flow_stats stats;
+	struct hlist_node node;
+};
+
+struct enetc_psfp {
+	unsigned long dev_bitmap;
+	unsigned long *psfp_sfi_bitmap;
+	struct hlist_head stream_list;
+	struct hlist_head psfp_filter_list;
+	struct hlist_head psfp_gate_list;
+	spinlock_t psfp_lock; /* spinlock for the struct enetc_psfp r/w */
+};
+
+struct actions_fwd enetc_act_fwd[] = {
+	{
+		BIT(FLOW_ACTION_GATE),
+		BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS),
+		FILTER_ACTION_TYPE_PSFP
+	},
+	/* example for ACL actions */
+	{
+		BIT(FLOW_ACTION_DROP),
+		0,
+		FILTER_ACTION_TYPE_ACL
+	}
+};
+
+static struct enetc_psfp epsfp = {
+	.psfp_sfi_bitmap = NULL,
+};
+
+static LIST_HEAD(enetc_block_cb_list);
+
+static inline int enetc_get_port(struct enetc_ndev_priv *priv)
+{
+	return priv->si->pdev->devfn & 0x7;
+}
+
+/* Stream Identity Entry Set Descriptor */
+static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
+				 struct enetc_streamid *sid,
+				 u8 enable)
+{
+	struct enetc_cbd cbd = {.cmd = 0};
+	struct streamid_data *si_data;
+	struct streamid_conf *si_conf;
+	u16 data_size;
+	dma_addr_t dma;
+	int err;
+
+	if (sid->index >= priv->psfp_cap.max_streamid)
+		return -EINVAL;
+
+	if (sid->filtertype != STREAMID_TYPE_NULL &&
+	    sid->filtertype != STREAMID_TYPE_SMAC)
+		return -EOPNOTSUPP;
+
+	/* Disable operation before enable */
+	cbd.index = cpu_to_le16((u16)sid->index);
+	cbd.cls = BDCR_CMD_STREAM_IDENTIFY;
+	cbd.status_flags = 0;
+
+	data_size = sizeof(struct streamid_data);
+	si_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
+	cbd.length = cpu_to_le16(data_size);
+
+	dma = dma_map_single(&priv->si->pdev->dev, si_data,
+			     data_size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
+		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
+		kfree(si_data);
+		return -ENOMEM;
+	}
+
+	cbd.addr[0] = lower_32_bits(dma);
+	cbd.addr[1] = upper_32_bits(dma);
+	memset(si_data->dmac, 0xff, ETH_ALEN);
+	si_data->vid_vidm_tg =
+		cpu_to_le16(ENETC_CBDR_SID_VID_MASK
+			    + ((0x3 << 14) | ENETC_CBDR_SID_VIDM));
+
+	si_conf = &cbd.sid_set;
+	/* Only one port supported for one entry, set itself */
+	si_conf->iports = 1 << enetc_get_port(priv);
+	si_conf->id_type = 1;
+	si_conf->oui[2] = 0x0;
+	si_conf->oui[1] = 0x80;
+	si_conf->oui[0] = 0xC2;
+
+	err = enetc_send_cmd(priv->si, &cbd);
+	if (err)
+		return -EINVAL;
+
+	if (!enable) {
+		kfree(si_data);
+		return 0;
+	}
+
+	/* Enable the entry overwrite again incase space flushed by hardware */
+	memset(&cbd, 0, sizeof(cbd));
+
+	cbd.index = cpu_to_le16((u16)sid->index);
+	cbd.cmd = 0;
+	cbd.cls = BDCR_CMD_STREAM_IDENTIFY;
+	cbd.status_flags = 0;
+
+	si_conf->en = 0x80;
+	si_conf->stream_handle = cpu_to_le32(sid->handle);
+	si_conf->iports = 1 << enetc_get_port(priv);
+	si_conf->id_type = sid->filtertype;
+	si_conf->oui[2] = 0x0;
+	si_conf->oui[1] = 0x80;
+	si_conf->oui[0] = 0xC2;
+
+	memset(si_data, 0, data_size);
+
+	cbd.length = cpu_to_le16(data_size);
+
+	cbd.addr[0] = lower_32_bits(dma);
+	cbd.addr[1] = upper_32_bits(dma);
+
+	/* VIDM default to be 1.
+	 * VID Match. If set (b1) then the VID must match, otherwise
+	 * any VID is considered a match. VIDM setting is only used
+	 * when TG is set to b01.
+	 */
+	if (si_conf->id_type == STREAMID_TYPE_NULL) {
+		ether_addr_copy(si_data->dmac, sid->dst_mac);
+		si_data->vid_vidm_tg =
+		cpu_to_le16((sid->vid & ENETC_CBDR_SID_VID_MASK) +
+			    ((((u16)(sid->tagged) & 0x3) << 14)
+			     | ENETC_CBDR_SID_VIDM));
+	} else if (si_conf->id_type == STREAMID_TYPE_SMAC) {
+		ether_addr_copy(si_data->smac, sid->src_mac);
+		si_data->vid_vidm_tg =
+		cpu_to_le16((sid->vid & ENETC_CBDR_SID_VID_MASK) +
+			    ((((u16)(sid->tagged) & 0x3) << 14)
+			     | ENETC_CBDR_SID_VIDM));
+	}
+
+	err = enetc_send_cmd(priv->si, &cbd);
+	kfree(si_data);
+
+	return err;
+}
+
+/* Stream Filter Instance Set Descriptor */
+static int enetc_streamfilter_hw_set(struct enetc_ndev_priv *priv,
+				     struct enetc_psfp_filter *sfi,
+				     u8 enable)
+{
+	struct enetc_cbd cbd = {.cmd = 0};
+	struct sfi_conf *sfi_config;
+
+	cbd.index = cpu_to_le16(sfi->index);
+	cbd.cls = BDCR_CMD_STREAM_FILTER;
+	cbd.status_flags = 0x80;
+	cbd.length = cpu_to_le16(1);
+
+	sfi_config = &cbd.sfi_conf;
+	if (!enable)
+		goto exit;
+
+	sfi_config->en = 0x80;
+
+	if (sfi->handle >= 0) {
+		sfi_config->stream_handle =
+			cpu_to_le32(sfi->handle);
+		sfi_config->sthm |= 0x80;
+	}
+
+	sfi_config->sg_inst_table_index = cpu_to_le16(sfi->gate_id);
+	sfi_config->input_ports = 1 << enetc_get_port(priv);
+
+	/* The priority value which may be matched against the
+	 * frame’s priority value to determine a match for this entry.
+	 */
+	if (sfi->prio >= 0)
+		sfi_config->multi |= (sfi->prio & 0x7) | 0x8;
+
+	/* Filter Type. Identifies the contents of the MSDU/FM_INST_INDEX
+	 * field as being either an MSDU value or an index into the Flow
+	 * Meter Instance table.
+	 * TODO: no limit max sdu
+	 */
+
+	if (sfi->meter_id >= 0) {
+		sfi_config->fm_inst_table_index = cpu_to_le16(sfi->meter_id);
+		sfi_config->multi |= 0x80;
+	}
+
+exit:
+	return enetc_send_cmd(priv->si, &cbd);
+}
+
+static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
+				      u32 index,
+				      struct psfp_streamfilter_counters *cnt)
+{
+	struct enetc_cbd cbd = { .cmd = 2 };
+	struct sfi_counter_data *data_buf;
+	dma_addr_t dma;
+	u16 data_size;
+	int err;
+
+	cbd.index = cpu_to_le16((u16)index);
+	cbd.cmd = 2;
+	cbd.cls = BDCR_CMD_STREAM_FILTER;
+	cbd.status_flags = 0;
+
+	data_size = sizeof(struct sfi_counter_data);
+	data_buf = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
+	if (!data_buf)
+		return -ENOMEM;
+
+	dma = dma_map_single(&priv->si->pdev->dev, data_buf,
+			     data_size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
+		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
+		err = -ENOMEM;
+		goto exit;
+	}
+	cbd.addr[0] = lower_32_bits(dma);
+	cbd.addr[1] = upper_32_bits(dma);
+
+	cbd.length = cpu_to_le16(data_size);
+
+	err = enetc_send_cmd(priv->si, &cbd);
+	if (err)
+		goto exit;
+
+	cnt->matching_frames_count =
+			((u64)le32_to_cpu(data_buf->matchh) << 32)
+			+ data_buf->matchl;
+
+	cnt->not_passing_sdu_count =
+			((u64)le32_to_cpu(data_buf->msdu_droph) << 32)
+			+ data_buf->msdu_dropl;
+
+	cnt->passing_sdu_count = cnt->matching_frames_count
+				- cnt->not_passing_sdu_count;
+
+	cnt->not_passing_frames_count =
+		((u64)le32_to_cpu(data_buf->stream_gate_droph) << 32)
+		+ le32_to_cpu(data_buf->stream_gate_dropl);
+
+	cnt->passing_frames_count = cnt->matching_frames_count
+				- cnt->not_passing_sdu_count
+				- cnt->not_passing_frames_count;
+
+	cnt->red_frames_count =
+		((u64)le32_to_cpu(data_buf->flow_meter_droph) << 32)
+		+ le32_to_cpu(data_buf->flow_meter_dropl);
+
+exit:
+	kfree(data_buf);
+	return err;
+}
+
+static int get_start_ns(struct enetc_ndev_priv *priv, u64 cycle, u64 *start)
+{
+	u64 now_lo, now_hi, now, n;
+
+	now_lo = enetc_rd(&priv->si->hw, ENETC_SICTR0);
+	now_hi = enetc_rd(&priv->si->hw, ENETC_SICTR1);
+	now = now_lo | now_hi << 32;
+
+	if (WARN_ON(!cycle))
+		return -EFAULT;
+
+	n = div64_u64(now, cycle);
+
+	*start = (n + 1) * cycle;
+
+	return 0;
+}
+
+/* Stream Gate Instance Set Descriptor */
+static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
+				   struct enetc_psfp_gate *sgi,
+				   u8 enable)
+{
+	struct enetc_cbd cbd = { .cmd = 0 };
+	struct sgi_table *sgi_config;
+	struct sgcl_conf *sgcl_config;
+	struct sgcl_data *sgcl_data;
+	struct sgce *sgce;
+	dma_addr_t dma;
+	u16 data_size;
+	int err, i;
+
+	cbd.index = cpu_to_le16(sgi->index);
+	cbd.cmd = 0;
+	cbd.cls = BDCR_CMD_STREAM_GCL;
+	cbd.status_flags = 0x80;
+
+	/* disable */
+	if (!enable)
+		return enetc_send_cmd(priv->si, &cbd);
+
+	/* enable */
+	sgi_config = &cbd.sgi_table;
+
+	/* Keep open before gate list start */
+	sgi_config->ocgtst = 0x80;
+
+	sgi_config->oipv = (sgi->init_ipv < 0) ?
+				0x0 : ((sgi->init_ipv & 0x7) | 0x8);
+
+	sgi_config->en = 0x80;
+
+	/* Basic config */
+	err = enetc_send_cmd(priv->si, &cbd);
+	if (err)
+		return -EINVAL;
+
+	if (!sgi->num_entries)
+		return 0;
+
+	if (sgi->num_entries > priv->psfp_cap.max_psfp_gatelist ||
+	    !sgi->cycletime)
+		return -EINVAL;
+
+	memset(&cbd, 0, sizeof(cbd));
+
+	cbd.index = cpu_to_le16(sgi->index);
+	cbd.cmd = 1;
+	cbd.cls = BDCR_CMD_STREAM_GCL;
+	cbd.status_flags = 0;
+
+	sgcl_config = &cbd.sgcl_conf;
+
+	sgcl_config->acl_len = (sgi->num_entries - 1) & 0x3;
+
+	data_size = struct_size(sgcl_data, sgcl, sgi->num_entries);
+
+	sgcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
+	if (!sgcl_data)
+		return -ENOMEM;
+
+	cbd.length = cpu_to_le16(data_size);
+
+	dma = dma_map_single(&priv->si->pdev->dev,
+			     sgcl_data, data_size,
+			     DMA_FROM_DEVICE);
+	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
+		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
+		kfree(sgcl_data);
+		return -ENOMEM;
+	}
+
+	cbd.addr[0] = lower_32_bits(dma);
+	cbd.addr[1] = upper_32_bits(dma);
+
+	sgce = &sgcl_data->sgcl[0];
+
+	sgcl_config->agtst = 0x80;
+
+	sgcl_data->ct = cpu_to_le32(sgi->cycletime);
+	sgcl_data->cte = cpu_to_le32(sgi->cycletimext);
+
+	if (sgi->init_ipv >= 0)
+		sgcl_config->aipv = (sgi->init_ipv & 0x7) | 0x8;
+
+	for (i = 0; i < sgi->num_entries; i++) {
+		struct action_gate_entry *from = &sgi->entries[i];
+		struct sgce *to = &sgce[i];
+
+		if (from->gate_state)
+			to->multi |= 0x10;
+
+		if (from->ipv >= 0)
+			to->multi |= ((from->ipv & 0x7) << 5) | 0x08;
+
+		if (from->maxoctets)
+			to->multi |= 0x01;
+
+		to->interval = cpu_to_le32(from->interval);
+		to->msdu[0] = from->maxoctets & 0xFF;
+		to->msdu[1] = (from->maxoctets >> 8) & 0xFF;
+		to->msdu[2] = (from->maxoctets >> 16) & 0xFF;
+	}
+
+	/* If basetime is 0, calculate start time */
+	if (!sgi->basetime) {
+		u64 start;
+
+		err = get_start_ns(priv, sgi->cycletime, &start);
+		if (err)
+			goto exit;
+		sgcl_data->btl = cpu_to_le32(lower_32_bits(start));
+		sgcl_data->bth = cpu_to_le32(upper_32_bits(start));
+	} else {
+		u32 hi, lo;
+
+		hi = upper_32_bits(sgi->basetime);
+		lo = lower_32_bits(sgi->basetime);
+		sgcl_data->bth = cpu_to_le32(hi);
+		sgcl_data->btl = cpu_to_le32(lo);
+	}
+
+	err = enetc_send_cmd(priv->si, &cbd);
+
+exit:
+	kfree(sgcl_data);
+
+	return err;
+}
+
+static struct enetc_stream_filter *enetc_get_stream_by_index(u32 index)
+{
+	struct enetc_stream_filter *f;
+
+	hlist_for_each_entry(f, &epsfp.stream_list, node)
+		if (f->sid.index == index)
+			return f;
+
+	return NULL;
+}
+
+static struct enetc_psfp_gate *enetc_get_gate_by_index(u32 index)
+{
+	struct enetc_psfp_gate *g;
+
+	hlist_for_each_entry(g, &epsfp.psfp_gate_list, node)
+		if (g->index == index)
+			return g;
+
+	return NULL;
+}
+
+static struct enetc_psfp_filter *enetc_get_filter_by_index(u32 index)
+{
+	struct enetc_psfp_filter *s;
+
+	hlist_for_each_entry(s, &epsfp.psfp_filter_list, node)
+		if (s->index == index)
+			return s;
+
+	return NULL;
+}
+
+static struct enetc_psfp_filter
+	*enetc_psfp_check_sfi(struct enetc_psfp_filter *sfi)
+{
+	struct enetc_psfp_filter *s;
+
+	hlist_for_each_entry(s, &epsfp.psfp_filter_list, node)
+		if (s->gate_id == sfi->gate_id &&
+		    s->prio == sfi->prio &&
+		    s->meter_id == sfi->meter_id)
+			return s;
+
+	return NULL;
+}
+
+static int enetc_get_free_index(struct enetc_ndev_priv *priv)
+{
+	u32 max_size = priv->psfp_cap.max_psfp_filter;
+	unsigned long index;
+
+	index = find_first_zero_bit(epsfp.psfp_sfi_bitmap, max_size);
+	if (index == max_size)
+		return -1;
+
+	return index;
+}
+
+static void reduce_ref_sfi(struct enetc_ndev_priv *priv, u32 index)
+{
+	struct enetc_psfp_filter *sfi;
+
+	sfi = enetc_get_filter_by_index(index);
+	WARN_ON(!sfi);
+	sfi->refcount--;
+
+	if (!sfi->refcount) {
+		enetc_streamfilter_hw_set(priv, sfi, false);
+		hlist_del(&sfi->node);
+		kfree(sfi);
+		clear_bit(sfi->index, epsfp.psfp_sfi_bitmap);
+	}
+}
+
+static void reduce_ref_sgi(struct enetc_ndev_priv *priv, u32 index)
+{
+	struct enetc_psfp_gate *sgi;
+
+	sgi = enetc_get_gate_by_index(index);
+	WARN_ON(!sgi);
+	sgi->refcount--;
+
+	if (!sgi->refcount) {
+		enetc_streamgate_hw_set(priv, sgi, false);
+		hlist_del(&sgi->node);
+		kfree(sgi);
+	}
+}
+
+static void remove_one_chain(struct enetc_ndev_priv *priv,
+			     struct enetc_stream_filter *filter)
+{
+	reduce_ref_sgi(priv, filter->sgi_index);
+	reduce_ref_sfi(priv, filter->sfi_index);
+
+	hlist_del(&filter->node);
+	kfree(filter);
+}
+
+static int enetc_psfp_hw_set(struct enetc_ndev_priv *priv,
+			     struct enetc_streamid *sid,
+			     struct enetc_psfp_filter *sfi,
+			     struct enetc_psfp_gate *sgi)
+{
+	int err;
+
+	err = enetc_streamid_hw_set(priv, sid, true);
+	if (err)
+		return err;
+
+	if (sfi) {
+		err = enetc_streamfilter_hw_set(priv, sfi, true);
+		if (err)
+			goto revert_sid;
+	}
+
+	err = enetc_streamgate_hw_set(priv, sgi, true);
+	if (err)
+		goto revert_sfi;
+
+	return 0;
+
+revert_sfi:
+	if (sfi && !sfi->refcount)
+		enetc_streamfilter_hw_set(priv, sfi, false);
+revert_sid:
+	enetc_streamid_hw_set(priv, sid, false);
+	return err;
+}
+
+struct actions_fwd *enetc_check_flow_actions(u64 acts, unsigned int inputkeys)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(enetc_act_fwd); i++)
+		if (acts == enetc_act_fwd[i].actions &&
+		    inputkeys & enetc_act_fwd[i].keys)
+			return &enetc_act_fwd[i];
+
+	return NULL;
+}
+
+static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
+				      struct flow_cls_offload *f)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct enetc_stream_filter *filter, *old_filter;
+	struct enetc_psfp_filter *sfi, *old_sfi;
+	struct enetc_psfp_gate *sgi, *old_sgi;
+	struct flow_action_entry *entry;
+	struct action_gate_entry *e;
+	u8 sfi_overwrite = 0;
+	int entries_size;
+	int i, err;
+
+	if (f->common.chain_index >= priv->psfp_cap.max_streamid) {
+		NL_SET_ERR_MSG_MOD(extack, "No Stream identify resource!");
+		return -ENOSPC;
+	}
+
+	flow_action_for_each(i, entry, &rule->action)
+		if (entry->id == FLOW_ACTION_GATE)
+			break;
+
+	if (entry->id != FLOW_ACTION_GATE)
+		return -EINVAL;
+
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	if (!filter)
+		return -ENOMEM;
+
+	filter->sid.index = f->common.chain_index;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(rule, &match);
+
+		if (!is_zero_ether_addr(match.mask->dst)) {
+			ether_addr_copy(filter->sid.dst_mac, match.key->dst);
+			filter->sid.filtertype = STREAMID_TYPE_NULL;
+		}
+
+		if (!is_zero_ether_addr(match.mask->src)) {
+			ether_addr_copy(filter->sid.src_mac, match.key->src);
+			filter->sid.filtertype = STREAMID_TYPE_SMAC;
+		}
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported, must ETH_ADDRS");
+		return -EINVAL;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		if (match.mask->vlan_priority) {
+			if (match.mask->vlan_priority !=
+			    (VLAN_PRIO_MASK >> VLAN_PRIO_SHIFT)) {
+				NL_SET_ERR_MSG_MOD(extack, "Only full mask is supported for VLAN priority");
+				err = -EINVAL;
+				goto free_filter;
+			}
+		}
+
+		if (match.mask->vlan_tpid) {
+			if (match.mask->vlan_tpid != VLAN_VID_MASK) {
+				NL_SET_ERR_MSG_MOD(extack, "Only full mask is supported for VLAN id");
+				err = -EINVAL;
+				goto free_filter;
+			}
+
+			filter->sid.vid = match.key->vlan_tpid;
+			if (!filter->sid.vid)
+				filter->sid.tagged = STREAMID_VLAN_UNTAGGED;
+			else
+				filter->sid.tagged = STREAMID_VLAN_TAGGED;
+		}
+	} else {
+		filter->sid.tagged = STREAMID_VLAN_ALL;
+	}
+
+	/* parsing gate action */
+	if (entry->gate.index >= priv->psfp_cap.max_psfp_gate) {
+		NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
+		err = -ENOSPC;
+		goto free_filter;
+	}
+
+	if (entry->gate.num_entries >= priv->psfp_cap.max_psfp_gatelist) {
+		NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
+		err = -ENOSPC;
+		goto free_filter;
+	}
+
+	entries_size = struct_size(sgi, entries, entry->gate.num_entries);
+	sgi = kzalloc(entries_size, GFP_KERNEL);
+	if (!sgi) {
+		err = -ENOMEM;
+		goto free_filter;
+	}
+
+	sgi->index = entry->gate.index;
+	sgi->init_ipv = entry->gate.prio;
+	sgi->basetime = entry->gate.basetime;
+	sgi->cycletime = entry->gate.cycletime;
+	sgi->num_entries = entry->gate.num_entries;
+
+	e = sgi->entries;
+	for (i = 0; i < entry->gate.num_entries; i++) {
+		e[i].gate_state = entry->gate.entries[i].gate_state;
+		e[i].interval = entry->gate.entries[i].interval;
+		e[i].ipv = entry->gate.entries[i].ipv;
+		e[i].maxoctets = entry->gate.entries[i].maxoctets;
+	}
+
+	filter->sgi_index = sgi->index;
+
+	sfi = kzalloc(sizeof(*sfi), GFP_KERNEL);
+	if (!sfi) {
+		err = -ENOMEM;
+		goto free_gate;
+	}
+
+	sfi->gate_id = sgi->index;
+
+	/* flow meter not support yet */
+	sfi->meter_id = ENETC_PSFP_WILDCARD;
+
+	/* prio ref the filter prio */
+	if (f->common.prio && f->common.prio <= BIT(3))
+		sfi->prio = f->common.prio - 1;
+	else
+		sfi->prio = ENETC_PSFP_WILDCARD;
+
+	old_sfi = enetc_psfp_check_sfi(sfi);
+	if (!old_sfi) {
+		int index;
+
+		index = enetc_get_free_index(priv);
+		if (sfi->handle < 0) {
+			NL_SET_ERR_MSG_MOD(extack, "No Stream Filter resource!");
+			err = -ENOSPC;
+			goto free_sfi;
+		}
+
+		sfi->index = index;
+		sfi->handle = index + HANDLE_OFFSET;
+		/* Update the stream filter handle also */
+		filter->sid.handle = sfi->handle;
+		filter->sfi_index = sfi->index;
+		sfi_overwrite = 0;
+	} else {
+		filter->sfi_index = old_sfi->index;
+		filter->sid.handle = old_sfi->handle;
+		sfi_overwrite = 1;
+	}
+
+	err = enetc_psfp_hw_set(priv, &filter->sid,
+				sfi_overwrite ? NULL : sfi, sgi);
+	if (err)
+		goto free_sfi;
+
+	spin_lock(&epsfp.psfp_lock);
+	old_sgi = enetc_get_gate_by_index(filter->sgi_index);
+	if (old_sgi) {
+		sgi->refcount = old_sgi->refcount;
+		hlist_del(&old_sgi->node);
+		kfree(old_sgi);
+	}
+
+	sgi->refcount++;
+	hlist_add_head(&sgi->node, &epsfp.psfp_gate_list);
+
+	if (!old_sfi) {
+		hlist_add_head(&sfi->node, &epsfp.psfp_filter_list);
+		set_bit(sfi->index, epsfp.psfp_sfi_bitmap);
+		sfi->refcount++;
+	} else {
+		kfree(sfi);
+		old_sfi->refcount++;
+	}
+
+	old_filter = enetc_get_stream_by_index(filter->sid.index);
+	if (old_filter)
+		remove_one_chain(priv, old_filter);
+
+	filter->stats.lastused = jiffies;
+	hlist_add_head(&filter->node, &epsfp.stream_list);
+
+	spin_unlock(&epsfp.psfp_lock);
+
+	return 0;
+
+free_sfi:
+	kfree(sfi);
+free_gate:
+	kfree(sgi);
+free_filter:
+	kfree(filter);
+
+	return err;
+}
+
+static int enetc_config_clsflower(struct enetc_ndev_priv *priv,
+				  struct flow_cls_offload *cls_flower)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls_flower);
+	struct netlink_ext_ack *extack = cls_flower->common.extack;
+	struct flow_dissector *dissector = rule->match.dissector;
+	struct flow_action *action = &rule->action;
+	struct flow_action_entry *entry;
+	struct actions_fwd *fwd;
+	u64 actions = 0;
+	int i, err;
+
+	if (!flow_action_has_entries(action)) {
+		NL_SET_ERR_MSG_MOD(extack, "At least one action is needed");
+		return -EINVAL;
+	}
+
+	flow_action_for_each(i, entry, action)
+		actions |= BIT(entry->id);
+
+	fwd = enetc_check_flow_actions(actions, dissector->used_keys);
+	if (!fwd) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported filter type!");
+		return -EOPNOTSUPP;
+	}
+
+	if (fwd->output & FILTER_ACTION_TYPE_PSFP) {
+		err = enetc_psfp_parse_clsflower(priv, cls_flower);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Invalid PSFP inputs");
+			return err;
+		}
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported actions");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int enetc_psfp_destroy_clsflower(struct enetc_ndev_priv *priv,
+					struct flow_cls_offload *f)
+{
+	struct enetc_stream_filter *filter;
+	struct netlink_ext_ack *extack = f->common.extack;
+	int err;
+
+	if (f->common.chain_index >= priv->psfp_cap.max_streamid) {
+		NL_SET_ERR_MSG_MOD(extack, "No Stream identify resource!");
+		return -ENOSPC;
+	}
+
+	filter = enetc_get_stream_by_index(f->common.chain_index);
+	if (!filter)
+		return -EINVAL;
+
+	err = enetc_streamid_hw_set(priv, &filter->sid, false);
+	if (err)
+		return err;
+
+	remove_one_chain(priv, filter);
+
+	return 0;
+}
+
+static int enetc_destroy_clsflower(struct enetc_ndev_priv *priv,
+				   struct flow_cls_offload *f)
+{
+	return enetc_psfp_destroy_clsflower(priv, f);
+}
+
+static int enetc_psfp_get_stats(struct enetc_ndev_priv *priv,
+				struct flow_cls_offload *f)
+{
+	struct psfp_streamfilter_counters counters = {};
+	struct enetc_stream_filter *filter;
+	struct flow_stats stats = {};
+	int err;
+
+	filter = enetc_get_stream_by_index(f->common.chain_index);
+	if (!filter)
+		return -EINVAL;
+
+	err = enetc_streamcounter_hw_get(priv, filter->sfi_index, &counters);
+	if (err)
+		return -EINVAL;
+
+	spin_lock(&epsfp.psfp_lock);
+	stats.pkts = counters.matching_frames_count - filter->stats.pkts;
+	stats.dropped = counters.not_passing_frames_count -
+					filter->stats.dropped;
+	stats.lastused = filter->stats.lastused;
+	filter->stats.pkts += stats.pkts;
+	filter->stats.dropped += stats.dropped;
+
+	spin_unlock(&epsfp.psfp_lock);
+
+	flow_stats_update(&f->stats, 0x0, stats.pkts, stats.lastused,
+			  stats.dropped);
+
+	return 0;
+}
+
+static int enetc_setup_tc_cls_flower(struct enetc_ndev_priv *priv,
+				     struct flow_cls_offload *cls_flower)
+{
+	switch (cls_flower->command) {
+	case FLOW_CLS_REPLACE:
+		return enetc_config_clsflower(priv, cls_flower);
+	case FLOW_CLS_DESTROY:
+		return enetc_destroy_clsflower(priv, cls_flower);
+	case FLOW_CLS_STATS:
+		return enetc_psfp_get_stats(priv, cls_flower);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static inline void clean_psfp_sfi_bitmap(void)
+{
+	bitmap_free(epsfp.psfp_sfi_bitmap);
+	epsfp.psfp_sfi_bitmap = NULL;
+}
+
+static void clean_stream_list(void)
+{
+	struct enetc_stream_filter *s;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(s, tmp, &epsfp.stream_list, node) {
+		hlist_del(&s->node);
+		kfree(s);
+	}
+}
+
+static void clean_sfi_list(void)
+{
+	struct enetc_psfp_filter *sfi;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(sfi, tmp, &epsfp.psfp_filter_list, node) {
+		hlist_del(&sfi->node);
+		kfree(sfi);
+	}
+}
+
+static void clean_sgi_list(void)
+{
+	struct enetc_psfp_gate *sgi;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(sgi, tmp, &epsfp.psfp_gate_list, node) {
+		hlist_del(&sgi->node);
+		kfree(sgi);
+	}
+}
+
+static void clean_psfp_all(void)
+{
+	/* Disable all list nodes and free all memory */
+	clean_sfi_list();
+	clean_sgi_list();
+	clean_stream_list();
+	epsfp.dev_bitmap = 0;
+	clean_psfp_sfi_bitmap();
+}
+
+int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+			    void *cb_priv)
+{
+	struct net_device *ndev = cb_priv;
+
+	if (!tc_can_offload(ndev))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return enetc_setup_tc_cls_flower(netdev_priv(ndev), type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int enetc_psfp_init(struct enetc_ndev_priv *priv)
+{
+	if (epsfp.psfp_sfi_bitmap)
+		return 0;
+
+	epsfp.psfp_sfi_bitmap = bitmap_zalloc(priv->psfp_cap.max_psfp_filter,
+					      GFP_KERNEL);
+	if (!epsfp.psfp_sfi_bitmap)
+		return -ENOMEM;
+
+	spin_lock_init(&epsfp.psfp_lock);
+
+	if (list_empty(&enetc_block_cb_list))
+		epsfp.dev_bitmap = 0;
+
+	return 0;
+}
+
+int enetc_psfp_clean(struct enetc_ndev_priv *priv)
+{
+	if (!list_empty(&enetc_block_cb_list))
+		return -EBUSY;
+
+	clean_psfp_all();
+
+	return 0;
+}
+
+int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct flow_block_offload *f = type_data;
+	int err;
+
+	err = flow_block_cb_setup_simple(f, &enetc_block_cb_list,
+					 enetc_setup_tc_block_cb,
+					 ndev, ndev, true);
+	if (err)
+		return err;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		set_bit(enetc_get_port(priv), &epsfp.dev_bitmap);
+		break;
+	case FLOW_BLOCK_UNBIND:
+		clear_bit(enetc_get_port(priv), &epsfp.dev_bitmap);
+		if (!epsfp.dev_bitmap)
+			clean_psfp_all();
+		break;
+	}
+
+	return 0;
+}
-- 
2.17.1

