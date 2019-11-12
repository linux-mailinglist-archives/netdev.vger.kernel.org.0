Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF7F8ADF
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 09:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfKLInJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 03:43:09 -0500
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:44739
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbfKLInI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 03:43:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST0hfn0Rs2w18YzLRfX+f+WPrfV8SEp82W+D3xNGoz/bZW3paemSaOdXUehUo6rBiH/OMZODdUfjnMn4S4CDfF3uYVAL6gVOE/o+Kr8ZBqe/z+CWKoj7MjBPe4RXiOxPsVwksFegFnxj1rJmKDAh9Q5dyer1YeEUIutyikXdZftNvMyeSCjVAXXDJI4/BD2bApRGkHh8XwrV79p68wRv2FRXgBXbHGt13HGavi1StV724U5zF5Npjg2AbegfSB1KoG4cTiXdfWEU3ynVgrlpaYHRcMPwsub+HjAZO1NPzqVA3uskw6aIOSrkbZLD1JgF00BNp8IUvFhYl04uXu7ysw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WoGWLniZfRVMzwss0X6Sdy54iQ4ybgGcR3eKxDSUQk=;
 b=jgSgPVfqQWaeGcH08yX3ym1Ioy+aIpYRuNwLMj/aZVZmE2/lEQhOUg2GY4WPGRWyjaJXYRdYFGy8iSzrQMaZmehOurD6NyzfFfjRldnlm00jRcQ4dSj77E3Sq7OHw312l6YfHlAUGJZ74LtAl9lkbWq7gQJQMPR0fJvQswHHmyeaHZmHYhgwiAGYtCEH1fdx+4vg4kbXET7Eg0DXh24WJwum3cu7hJpOrXm7w7tivfnghAnBjfNp6xbEpbh/FxTfa7+sS3fLMCrgQRV1NhjHvXHjqEfRmCj9F9T9BwDApkTo8zXN6BrdMFPq3CGD25bwaExfAUM8WC2lavj+6v3j0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WoGWLniZfRVMzwss0X6Sdy54iQ4ybgGcR3eKxDSUQk=;
 b=r8K53i3wos0bRwnm40tbw+fW3IpaPQYQMvP1RRdACmFJUrucVJU6UNKkaHwx6hsROQgBK1piyOjbLqAO4RqOC2ovdfGKgg7HjEfa/SBawSBZPrsZMLI5Eq9OitoU4Bgn6uGH0Fc+jl9FJF2XBU+UVlKke4nT+kZR1smdYZAx680=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6736.eurprd04.prod.outlook.com (20.179.235.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Tue, 12 Nov 2019 08:42:50 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 08:42:50 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
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
Subject: [v2,net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Thread-Topic: [v2,net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Thread-Index: AQHVmTUqXYApGTOw3EOm7mArykD/fw==
Date:   Tue, 12 Nov 2019 08:42:49 +0000
Message-ID: <20191112082823.28998-1-Po.Liu@nxp.com>
References: <20191111042715.13444-2-Po.Liu@nxp.com>
In-Reply-To: <20191111042715.13444-2-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR01CA0105.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::31) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d042707-6d73-4ad5-f587-08d7674c4c84
x-ms-traffictypediagnostic: VE1PR04MB6736:|VE1PR04MB6736:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB673665DA180BAF4CEEC23DD192770@VE1PR04MB6736.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(199004)(189003)(14454004)(6486002)(52116002)(76176011)(6436002)(478600001)(7736002)(54906003)(316002)(36756003)(2501003)(110136005)(81166006)(81156014)(66446008)(64756008)(66556008)(66476007)(66946007)(305945005)(2906002)(3846002)(1076003)(11346002)(446003)(86362001)(99286004)(6116002)(8936002)(66066001)(2616005)(476003)(2201001)(6506007)(386003)(5660300002)(25786009)(486006)(4326008)(26005)(102836004)(50226002)(6512007)(256004)(14444005)(71190400001)(30864003)(186003)(8676002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6736;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SrYRY6hB0OlC/7QxNQfLF3b4DxQYpmMicl0WhgMc5Zp5IEy9+Orp9PwYWcjByUa5LCiHZ/XCtzquOHvILbxgfg+oZmsXiBynzqs6hOZ09mrTTReukSis/xWJt6ICAXg4NVXFcmxGdu0ba8tDG9DVR9h/2wrHOrLMO96u2lxRKYcplp+3rZS8Y4yjEtwJQ1iRlvuKNCeaafv/d7UKdr0MobEkHKaImjsq+RWSF1XYt13Bns4bMm27tXNbfSSdP7HdVEh/RIZ9Ad6f267f26FLJM1RoUiYXiq9ejJ3P5c3T+B9HVALr+deiSJkcBrgYdii2sNM1hQNkDto2h84O5y+9D+uVpL0tObaoJbdtFpYvUIvHlwbJIHb72FvC8kW2j14qir4W20GfGmwH78c9uLBUhEtyIq7gEoGTWpLmlbS8sww5pwYcyOyXAOmnbSIC4Wu
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d042707-6d73-4ad5-f587-08d7674c4c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 08:42:50.0139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wpbuOepAW92In+1WDnlESWaB4v+b9E2CAm8Q2qdTqYsta0AHGL8o4cZLuRHx4lLq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6736
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
- introduce a local define CONFIG_FSL_ENETC_QOS to fix the various
  configurations will result in link errors.
  Since the CONFIG_NET_SCH_TAPRIO depends on many Qos configs. Not
  to use it directly in driver. Add it to CONFIG_FSL_ENETC_QOS depends
  on list, so only CONFIG_NET_SCH_TAPRIO enabled, user can enable this
  tsn feature, or else, return not support.

 drivers/net/ethernet/freescale/enetc/Kconfig  |  10 ++
 drivers/net/ethernet/freescale/enetc/Makefile |   1 +
 drivers/net/ethernet/freescale/enetc/enetc.c  |  19 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   7 +
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |   5 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 150 ++++++++++++++++--
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 130 +++++++++++++++
 7 files changed, 300 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_qos.c

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/eth=
ernet/freescale/enetc/Kconfig
index c219587bd334..017ade2d0e50 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -50,3 +50,13 @@ config FSL_ENETC_HW_TIMESTAMPING
 	  allocation has not been supported and it is too expensive to use
 	  extended RX BDs if timestamping is not used, this option enables
 	  extended RX BDs in order to support hardware timestamping.
+
+config FSL_ENETC_QOS
+	bool "ENETC hardware Time-sensitive Network support"
+	depends on FSL_ENETC && NET_SCH_TAPRIO
+	help
+	  There are Time-Sensitive Network(TSN) capabilities(802.1Qbv/802.1Qci
+	  /802.1Qbu etc.) supported by ENETC. These TSN capabilities can be set
+	  enable/disable from user space via Qos commands(tc). In the kernel
+	  side, it can be loaded by Qos driver. Currently, it is only support
+	  taprio(802.1Qbv).
diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/et=
hernet/freescale/enetc/Makefile
index d200c27c3bf6..7a80680a7634 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -5,6 +5,7 @@ common-objs :=3D enetc.o enetc_cbdr.o enetc_ethtool.o
 obj-$(CONFIG_FSL_ENETC) +=3D fsl-enetc.o
 fsl-enetc-y :=3D enetc_pf.o enetc_mdio.o $(common-objs)
 fsl-enetc-$(CONFIG_PCI_IOV) +=3D enetc_msg.o
+fsl-enetc-$(CONFIG_FSL_ENETC_QOS) +=3D enetc_qos.o
=20
 obj-$(CONFIG_FSL_ENETC_VF) +=3D fsl-enetc-vf.o
 fsl-enetc-vf-y :=3D enetc_vf.o $(common-objs)
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
index 88276299f447..75a7c0f1f8ce 100644
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
@@ -148,6 +149,12 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PORT_BASE		0x10000
 #define ENETC_PMR		0x0000
 #define ENETC_PMR_EN	GENMASK(18, 16)
+#define ENETC_PMR_PSPEED_MASK GENMASK(11, 8)
+#define ENETC_PMR_PSPEED_10M 0x000
+#define ENETC_PMR_PSPEED_100M 0x100
+#define ENETC_PMR_PSPEED_1000M 0x200
+#define ENETC_PMR_PSPEED_2500M 0x400
+
 #define ENETC_PSR		0x0004 /* RO */
 #define ENETC_PSIPMR		0x0018
 #define ENETC_PSIPMR_SET_UP(n)	BIT(n) /* n =3D SI index */
@@ -440,22 +447,6 @@ union enetc_rx_bd {
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
@@ -554,3 +545,130 @@ static inline void enetc_set_bdr_prio(struct enetc_hw=
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
+	union {
+		struct {
+			u8	res1[4];
+			__le16	acl_len;
+			u8	res2[2];
+		};
+		struct {
+			u32 cctl;
+			u32 ccth;
+		};
+	};
+};
+
+#define ENETC_CBDR_SGL_IOMEN	BIT(0)
+#define ENETC_CBDR_SGL_IPVEN	BIT(3)
+#define ENETC_CBDR_SGL_GTST	BIT(4)
+#define ENETC_CBDR_SGL_IPV_MASK 0xe
+
+/* gate control list entry */
+struct gce {
+	u32	period;
+	u8	gate;
+	u8	res[3];
+};
+
+/* tgs_gcl_conf address point to this data space */
+struct tgs_gcl_data {
+	u32	btl;
+	u32	bth;
+	u32	ct;
+	u32	cte;
+};
+
+/* class 5, command 1 */
+struct tgs_gcl_query {
+		u8	res[12];
+		union {
+			struct {
+				__le16	acl_len; /* admin list length */
+				__le16	ocl_len; /* operation list length */
+			};
+			struct {
+				u16 admin_list_len;
+				u16 oper_list_len;
+			};
+		};
+};
+
+/* tgs_gcl_query command response data format */
+struct tgs_gcl_resp {
+	u32 abtl;	/* base time */
+	u32 abth;
+	u32 act;	/* cycle time */
+	u32 acte;	/* cycle time extend */
+	u32 cctl;	/* config change time */
+	u32 ccth;
+	u32 obtl;	/* operation base time */
+	u32 obth;
+	u32 oct;	/* operation cycle time */
+	u32 octe;	/* operation cycle time extend */
+	u32 ccel;	/* config change error */
+	u32 cceh;
+};
+
+struct enetc_cbd {
+	union{
+		struct {
+			__le32	addr[2];
+			union {
+				__le32	opt[4];
+				struct tgs_gcl_conf	gcl_conf;
+				struct tgs_gcl_query	gcl_query;
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
+#define ENETC_PTCFPR(n)		(0x1910 + (n) * 4) /* n =3D [0 ..7] */
+#define ENETC_FPE		BIT(31)
+
+/* Port capability register 0 */
+#define ENETC_PCAPR0_PSFPM	BIT(10)
+#define ENETC_PCAPR0_PSFP	BIT(9)
+#define ENETC_PCAPR0_TSN	BIT(4)
+#define ENETC_PCAPR0_QBU	BIT(3)
+
+/* port time gating control register */
+#define ENETC_QBV_PTGCR_OFFSET		0x11a00
+#define ENETC_QBV_TGE			0x80000000
+#define ENETC_QBV_TGPE			BIT(30)
+#define ENETC_QBV_TGDROP_DISABLE	BIT(29)
+
+/* Port time gating capability register */
+#define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
+#define ENETC_QBV_MAX_GCL_LEN_MASK	0xffff
+
+/* Port time gating admin gate list status register */
+#define ENETC_QBV_PTGAGLSR_OFFSET	0x11a10
+#define ENETC_QBV_CFG_PEND_MASK	0x00000002
+
+#define ENETC_TGLSTR			0xa200
+#define ENETC_TGS_MIN_DIS_MASK		0x80000000
+#define ENETC_MIN_LOOKAHEAD_MASK	0xffff
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net=
/ethernet/freescale/enetc/enetc_qos.c
new file mode 100644
index 000000000000..036bb39c7a0b
--- /dev/null
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -0,0 +1,130 @@
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
+	u32 temp;
+	int i;
+
+	gcl_len =3D admin_conf->num_entries;
+	if (gcl_len > enetc_get_max_gcl_len(&priv->si->hw))
+		return -EINVAL;
+
+	if (admin_conf->enable) {
+		enetc_wr(&priv->si->hw,
+			 ENETC_QBV_PTGCR_OFFSET,
+			 temp & (~ENETC_QBV_TGE));
+		usleep_range(10, 20);
+		enetc_wr(&priv->si->hw,
+			 ENETC_QBV_PTGCR_OFFSET,
+			 temp | ENETC_QBV_TGE);
+	} else {
+		enetc_wr(&priv->si->hw,
+			 ENETC_QBV_PTGCR_OFFSET,
+			 temp & (~ENETC_QBV_TGE));
+		return 0;
+	}
+
+	/* Configure the (administrative) gate control list using the
+	 * control BD descriptor.
+	 */
+	gcl_config =3D &cbd.gcl_conf;
+
+	data_size =3D sizeof(struct tgs_gcl_data) + gcl_len * sizeof(struct gce);
+
+	gcl_data =3D kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
+	if (!gcl_data)
+		return -ENOMEM;
+
+	gce =3D (struct gce *)(gcl_data + 1);
+
+	/* Since no initial state config in taprio, set gates open as default.
+	 */
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
+		temp_gce->gate =3D cpu_to_le32(temp_entry->gate_mask);
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
+
+	/* Updated by ENETC on completion of the configuration
+	 * command. A zero value indicates success.
+	 */
+	cbd.status_flags =3D 0;
+
+	enetc_send_cmd(priv->si, &cbd);
+
+	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
+	kfree(gcl_data);
+
+	return 0;
+}
+
+int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
+{
+	struct tc_taprio_qopt_offload *taprio =3D type_data;
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	int i;
+
+	for (i =3D 0; i < priv->num_tx_rings; i++)
+		enetc_set_bdr_prio(&priv->si->hw,
+				   priv->tx_ring[i]->index,
+				   taprio->enable ? i : 0);
+
+	return enetc_setup_taprio(ndev, taprio);
+}
--=20
2.17.1

