Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C24FD361
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 04:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfKODdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 22:33:43 -0500
Received: from mail-eopbgr10080.outbound.protection.outlook.com ([40.107.1.80]:53380
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726491AbfKODdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 22:33:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAC0u9bnNXcyQNrnSYsa9VE4A/dQ7nlv3plLrVpB+KM0ybdAPjsbclGBEKaTTT7rilVqfwVXtvmc1PaZRLZUSyBCnM31jNq0JJs75UuH3tLuVqxIgfcqEUjPpgylJlbHZY5s6A1u/Q6eU9pvFRMe7ACa5GJQAiWXeKM/LGc/0+I247p2NP6h91bCCI0BYaQXTHrcKMyEkGdz+7+4+a5vfIut9IHEMrWBp49HjTTk4rWlSGvsiW0okyUEP7tMTqU80xPOIORFkY560/VX4wOX1kdx8ktGPDyp2dEmOGHNmXl2t56evf0tqmuUVZGJNKPdhfS3dq27Oj4GW5HYGGK51w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7v6UYY8YgScCDm4482BV3P80YiV+xi8Yt1iN7h+r/Q=;
 b=VsFdzu3HHokodPpd8svtlfHaWBmKNOveum6/gwByYakOphnhGhBbLUYAFTbd32cgPxCquGfOusvtt53uJlAAXrI9jeMVgEgQc9tXZkGqPJJJRUxm2I4CdjdvZ1gWh08R21HuXe5MZvNIQPfiE6QMA0fGs82V/CEycH03v9Ysu6sMfHm8ZulO6uWBU2j+BdMpt+2+DdiACX0058pzfCJbOQOxGKmFBvOi4Jivsu9XbRqyxKM+0lPxkLILDhHO4yrGu8TcqAl8zyffyDsDr03NomLKSfL0aYXzM1aAUOl8a6H4eFjqOVcWODlXtLtnBNUE5QH16hchN6EryvDLRIC9Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7v6UYY8YgScCDm4482BV3P80YiV+xi8Yt1iN7h+r/Q=;
 b=jf9uU0iK6cy7zv7tyO4KlpQ0S5zVNQm+LcJswm7kCGo6TKVypV0wtMfEaYzrvsI9EOkvE7ecUXyRYPJazymivvL1GNNJnBp01DGb5/C//10FJJW7svy0jXA1OqeITXAouAb3FzVcVXaJGXEz25bA0ZRX8bB4IeN6MqmJlgNbJWo=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6541.eurprd04.prod.outlook.com (20.179.234.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Fri, 15 Nov 2019 03:33:34 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 03:33:34 +0000
From:   Po Liu <po.liu@nxp.com>
To:     "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [v4,net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Thread-Topic: [v4,net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Thread-Index: AQHVm2V14vDnU8CWZUm2exPFIrQalw==
Date:   Fri, 15 Nov 2019 03:33:33 +0000
Message-ID: <20191115031846.4871-1-Po.Liu@nxp.com>
References: <20191114045833.18064-2-Po.Liu@nxp.com>
In-Reply-To: <20191114045833.18064-2-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN6PR01CA0009.prod.exchangelabs.com (2603:10b6:805:b6::22)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a293c8d-875d-4dcf-8961-08d7697c9756
x-ms-traffictypediagnostic: VE1PR04MB6541:|VE1PR04MB6541:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6541CD1F9F2BAE5DDBD5421C92700@VE1PR04MB6541.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(199004)(189003)(25786009)(54906003)(76176011)(102836004)(52116002)(14454004)(2906002)(81166006)(316002)(478600001)(110136005)(36756003)(386003)(14444005)(305945005)(99286004)(2201001)(6116002)(3846002)(6506007)(7736002)(50226002)(8936002)(26005)(86362001)(1076003)(256004)(186003)(8676002)(81156014)(446003)(486006)(30864003)(476003)(71190400001)(71200400001)(2501003)(2616005)(4326008)(6486002)(66066001)(66946007)(5660300002)(66476007)(11346002)(6436002)(6512007)(66556008)(66446008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6541;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QSaBrQFUjTGBjQvKKEXnJT4ec+4eMg8slWt6XoNmYSqn5Lu1GTfN/GsxsfPvm+c5DAb1hsClaxSLPYGUE8AROCVUTIPCSuhbxr2DUjgB9qxLcuOORB+BVtlBOQfA9zqYt0elzLI682EGX50gqsaKTO0l4ajgPd4v7bIC7DoYCnMK419HAGHqeDW+gAzcUrOUft/zPoLFxbDq0JfmQ8SaHL+mufg+CTvGSFNQieskRTS3bvmbHbJQVhCiM2wsOjK5N8tIXOQu1kgmcUk7gwXjNrFqi0186t+H1AiKRFhEPn1Y7IExfcNfpTkl66KssnMonwROu7c2PWqde67Y4SLyVqVXmNYG5wDIai8doPIErC/vR1Zpa0TCGlxooWA72f2Bi/YjvKmCGwCd2+XTDQETs6GZvHG3dEPI/OdXrD45lJacSGvZsZnwogsw0Ilm4oLp
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a293c8d-875d-4dcf-8961-08d7697c9756
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 03:33:34.0221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fTxww0LHGB4FSc4a01rmBrCheaFyGq71/m+Q1bxSo4dV4owL+S+2jLTRVCvfy8P0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENETC supports in hardware for time-based egress shaping according
to IEEE 802.1Qbv. This patch implement the Qbv enablement by the
hardware offload method qdisc tc-taprio method.
Also update cbdr writeback to up level since control bd ring may
writeback data to control bd ring.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
changes:
v2:
- introduce a local define CONFIG_FSL_ENETC_QOS to fix the various
  configurations will result in link errors.
  Since the CONFIG_NET_SCH_TAPRIO depends on many Qos configs. Not
  to use it directly in driver. Add it to CONFIG_FSL_ENETC_QOS depends
  on list, so only CONFIG_NET_SCH_TAPRIO enabled, user can enable this
  tsn feature, or else, return not support.
v3:
- fix the compiling vf module failure issue:
  ERROR: "enetc_sched_speed_set" [drivers/net/ethernet/freescale/enetc/fsl-=
enetc-vf.ko] undefined!
  ERROR: "enetc_setup_tc_taprio" [drivers/net/ethernet/freescale/enetc/fsl-=
enetc-vf.ko] undefined!
- remove defines not used in this patch
- fix hardware endian issue
- make the qbv set code more rubust with some error condition may occur.
v4:
- delete hardware qbv disable before enable it
- fix when enetc_setup_taprio() return error condition, restore priority
set.

 drivers/net/ethernet/freescale/enetc/Kconfig  |  10 ++
 drivers/net/ethernet/freescale/enetc/Makefile |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.c  |  19 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   7 +
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |   5 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  84 +++++++++--
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 138 ++++++++++++++++++
 7 files changed, 243 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_qos.c

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/eth=
ernet/freescale/enetc/Kconfig
index c219587bd334..491659fe3e35 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -50,3 +50,13 @@ config FSL_ENETC_HW_TIMESTAMPING
 	  allocation has not been supported and it is too expensive to use
 	  extended RX BDs if timestamping is not used, this option enables
 	  extended RX BDs in order to support hardware timestamping.
+
+config FSL_ENETC_QOS
+	bool "ENETC hardware Time-sensitive Network support"
+	depends on (FSL_ENETC || FSL_ENETC_VF) && NET_SCH_TAPRIO
+	help
+	  There are Time-Sensitive Network(TSN) capabilities(802.1Qbv/802.1Qci
+	  /802.1Qbu etc.) supported by ENETC. These TSN capabilities can be set
+	  enable/disable from user space via Qos commands(tc). In the kernel
+	  side, it can be loaded by Qos driver. Currently, it is only support
+	  taprio(802.1Qbv).
diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/et=
hernet/freescale/enetc/Makefile
index d200c27c3bf6..d0db33e5b6b7 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -5,9 +5,11 @@ common-objs :=3D enetc.o enetc_cbdr.o enetc_ethtool.o
 obj-$(CONFIG_FSL_ENETC) +=3D fsl-enetc.o
 fsl-enetc-y :=3D enetc_pf.o enetc_mdio.o $(common-objs)
 fsl-enetc-$(CONFIG_PCI_IOV) +=3D enetc_msg.o
+fsl-enetc-$(CONFIG_FSL_ENETC_QOS) +=3D enetc_qos.o
=20
 obj-$(CONFIG_FSL_ENETC_VF) +=3D fsl-enetc-vf.o
 fsl-enetc-vf-y :=3D enetc_vf.o $(common-objs)
+fsl-enetc-vf-$(CONFIG_FSL_ENETC_QOS) +=3D enetc_qos.o
=20
 obj-$(CONFIG_FSL_ENETC_MDIO) +=3D fsl-enetc-mdio.o
 fsl-enetc-mdio-y :=3D enetc_pci_mdio.o enetc_mdio.o
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index 3e8f9819f08c..d58dbc2c4270 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1427,8 +1427,7 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
=20
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data)
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio =3D type_data;
@@ -1436,9 +1435,6 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_s=
etup_type type,
 	u8 num_tc;
 	int i;
=20
-	if (type !=3D TC_SETUP_QDISC_MQPRIO)
-		return -EOPNOTSUPP;
-
 	mqprio->hw =3D TC_MQPRIO_HW_OFFLOAD_TCS;
 	num_tc =3D mqprio->num_tc;
=20
@@ -1483,6 +1479,19 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_=
setup_type type,
 	return 0;
 }
=20
+int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+		   void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return enetc_setup_tc_taprio(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/eth=
ernet/freescale/enetc/enetc.h
index 541b4e2073fe..8ca2f97050c8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -244,3 +244,10 @@ int enetc_set_fs_entry(struct enetc_si *si, struct ene=
tc_cmd_rfse *rfse,
 void enetc_set_rss_key(struct enetc_hw *hw, const u8 *bytes);
 int enetc_get_rss_table(struct enetc_si *si, u32 *table, int count);
 int enetc_set_rss_table(struct enetc_si *si, const u32 *table, int count);
+int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd);
+
+#ifdef CONFIG_FSL_ENETC_QOS
+int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
+#else
+#define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
+#endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/ne=
t/ethernet/freescale/enetc/enetc_cbdr.c
index de466b71bf8f..201cbc362e33 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -32,7 +32,7 @@ static int enetc_cbd_unused(struct enetc_cbdr *r)
 		r->bd_count;
 }
=20
-static int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
+int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
 {
 	struct enetc_cbdr *ring =3D &si->cbd_ring;
 	int timeout =3D ENETC_CBDR_TIMEOUT;
@@ -66,6 +66,9 @@ static int enetc_send_cmd(struct enetc_si *si, struct ene=
tc_cbd *cbd)
 	if (!timeout)
 		return -EBUSY;
=20
+	/* CBD may writeback data, feedback up level */
+	*cbd =3D *dest_cbd;
+
 	enetc_clean_cbdr(si);
=20
 	return 0;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/=
ethernet/freescale/enetc/enetc_hw.h
index 88276299f447..df6b35dc3534 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -18,6 +18,7 @@
 #define ENETC_SICTR0	0x18
 #define ENETC_SICTR1	0x1c
 #define ENETC_SIPCAPR0	0x20
+#define ENETC_SIPCAPR0_QBV	BIT(4)
 #define ENETC_SIPCAPR0_RSS	BIT(8)
 #define ENETC_SIPCAPR1	0x24
 #define ENETC_SITGTGR	0x30
@@ -440,22 +441,6 @@ union enetc_rx_bd {
 #define EMETC_MAC_ADDR_FILT_RES	3 /* # of reserved entries at the beginnin=
g */
 #define ENETC_MAX_NUM_VFS	2
=20
-struct enetc_cbd {
-	union {
-		struct {
-			__le32 addr[2];
-			__le32 opt[4];
-		};
-		__le32 data[6];
-	};
-	__le16 index;
-	__le16 length;
-	u8 cmd;
-	u8 cls;
-	u8 _res;
-	u8 status_flags;
-};
-
 #define ENETC_CBD_FLAGS_SF	BIT(7) /* short format */
 #define ENETC_CBD_STATUS_MASK	0xf
=20
@@ -554,3 +539,70 @@ static inline void enetc_set_bdr_prio(struct enetc_hw =
*hw, int bdr_idx,
 	val |=3D ENETC_TBMR_SET_PRIO(prio);
 	enetc_txbdr_wr(hw, bdr_idx, ENETC_TBMR, val);
 }
+
+enum bdcr_cmd_class {
+	BDCR_CMD_UNSPEC =3D 0,
+	BDCR_CMD_MAC_FILTER,
+	BDCR_CMD_VLAN_FILTER,
+	BDCR_CMD_RSS,
+	BDCR_CMD_RFS,
+	BDCR_CMD_PORT_GCL,
+	BDCR_CMD_RECV_CLASSIFIER,
+	__BDCR_CMD_MAX_LEN,
+	BDCR_CMD_MAX_LEN =3D __BDCR_CMD_MAX_LEN - 1,
+};
+
+/* class 5, command 0 */
+struct tgs_gcl_conf {
+	u8	atc;	/* init gate value */
+	u8	res[7];
+	struct {
+		u8	res1[4];
+		__le16	acl_len;
+		u8	res2[2];
+	};
+};
+
+/* gate control list entry */
+struct gce {
+	__le32	period;
+	u8	gate;
+	u8	res[3];
+};
+
+/* tgs_gcl_conf address point to this data space */
+struct tgs_gcl_data {
+	__le32		btl;
+	__le32		bth;
+	__le32		ct;
+	__le32		cte;
+	struct gce	entry[0];
+};
+
+struct enetc_cbd {
+	union{
+		struct {
+			__le32	addr[2];
+			union {
+				__le32	opt[4];
+				struct tgs_gcl_conf	gcl_conf;
+			};
+		};	/* Long format */
+		__le32 data[6];
+	};
+	__le16 index;
+	__le16 length;
+	u8 cmd;
+	u8 cls;
+	u8 _res;
+	u8 status_flags;
+};
+
+/* port time gating control register */
+#define ENETC_QBV_PTGCR_OFFSET		0x11a00
+#define ENETC_QBV_TGE			BIT(31)
+#define ENETC_QBV_TGPE			BIT(30)
+
+/* Port time gating capability register */
+#define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
+#define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net=
/ethernet/freescale/enetc/enetc_qos.c
new file mode 100644
index 000000000000..84c2ab98fae9
--- /dev/null
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2019 NXP */
+
+#include "enetc.h"
+
+#include <net/pkt_sched.h>
+
+static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
+{
+	return enetc_rd(hw, ENETC_QBV_PTGCAPR_OFFSET)
+		& ENETC_QBV_MAX_GCL_LEN_MASK;
+}
+
+static int enetc_setup_taprio(struct net_device *ndev,
+			      struct tc_taprio_qopt_offload *admin_conf)
+{
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	struct enetc_cbd cbd =3D {.cmd =3D 0};
+	struct tgs_gcl_conf *gcl_config;
+	struct tgs_gcl_data *gcl_data;
+	struct gce *gce;
+	dma_addr_t dma;
+	u16 data_size;
+	u16 gcl_len;
+	u32 tge;
+	int err;
+	int i;
+
+	if (admin_conf->num_entries > enetc_get_max_gcl_len(&priv->si->hw))
+		return -EINVAL;
+	gcl_len =3D admin_conf->num_entries;
+
+	tge =3D enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET);
+	if (!admin_conf->enable) {
+		enetc_wr(&priv->si->hw,
+			 ENETC_QBV_PTGCR_OFFSET,
+			 tge & (~ENETC_QBV_TGE));
+		return 0;
+	}
+
+	if (admin_conf->cycle_time > U32_MAX ||
+	    admin_conf->cycle_time_extension > U32_MAX)
+		return -EINVAL;
+
+	/* Configure the (administrative) gate control list using the
+	 * control BD descriptor.
+	 */
+	gcl_config =3D &cbd.gcl_conf;
+
+	data_size =3D struct_size(gcl_data, entry, gcl_len);
+	gcl_data =3D kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
+	if (!gcl_data)
+		return -ENOMEM;
+
+	gce =3D (struct gce *)(gcl_data + 1);
+
+	/* Set all gates open as default */
+	gcl_config->atc =3D 0xff;
+	gcl_config->acl_len =3D cpu_to_le16(gcl_len);
+
+	if (!admin_conf->base_time) {
+		gcl_data->btl =3D
+			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
+		gcl_data->bth =3D
+			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));
+	} else {
+		gcl_data->btl =3D
+			cpu_to_le32(lower_32_bits(admin_conf->base_time));
+		gcl_data->bth =3D
+			cpu_to_le32(upper_32_bits(admin_conf->base_time));
+	}
+
+	gcl_data->ct =3D cpu_to_le32(admin_conf->cycle_time);
+	gcl_data->cte =3D cpu_to_le32(admin_conf->cycle_time_extension);
+
+	for (i =3D 0; i < gcl_len; i++) {
+		struct tc_taprio_sched_entry *temp_entry;
+		struct gce *temp_gce =3D gce + i;
+
+		temp_entry =3D &admin_conf->entries[i];
+
+		temp_gce->gate =3D (u8)temp_entry->gate_mask;
+		temp_gce->period =3D cpu_to_le32(temp_entry->interval);
+	}
+
+	cbd.length =3D cpu_to_le16(data_size);
+	cbd.status_flags =3D 0;
+
+	dma =3D dma_map_single(&priv->si->pdev->dev, gcl_data,
+			     data_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
+		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
+		kfree(gcl_data);
+		return -ENOMEM;
+	}
+
+	cbd.addr[0] =3D lower_32_bits(dma);
+	cbd.addr[1] =3D upper_32_bits(dma);
+	cbd.cls =3D BDCR_CMD_PORT_GCL;
+	cbd.status_flags =3D 0;
+
+	enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET,
+		 tge | ENETC_QBV_TGE);
+
+	err =3D enetc_send_cmd(priv->si, &cbd);
+	if (err)
+		enetc_wr(&priv->si->hw,
+			 ENETC_QBV_PTGCR_OFFSET,
+			 tge & (~ENETC_QBV_TGE));
+
+	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
+	kfree(gcl_data);
+
+	return err;
+}
+
+int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
+{
+	struct tc_taprio_qopt_offload *taprio =3D type_data;
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	int err;
+	int i;
+
+	for (i =3D 0; i < priv->num_tx_rings; i++)
+		enetc_set_bdr_prio(&priv->si->hw,
+				   priv->tx_ring[i]->index,
+				   taprio->enable ? i : 0);
+
+	err =3D enetc_setup_taprio(ndev, taprio);
+
+	if (err)
+		for (i =3D 0; i < priv->num_tx_rings; i++)
+			enetc_set_bdr_prio(&priv->si->hw,
+					   priv->tx_ring[i]->index,
+					   taprio->enable ? 0 : i);
+
+	return err;
+}
--=20
2.17.1

