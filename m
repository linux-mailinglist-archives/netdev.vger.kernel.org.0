Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBADFBF02
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfKNFMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:12:41 -0500
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:48100
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725440AbfKNFMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 00:12:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zots2xU0b7IVtbC3IGEcYlqbchWCEubzzUGD3jym5K+GIFp/0cj7nM9NRPka/C4L5/NRlKskDZ+ctlSfh7kwUvrSDNjtJ7xCI4pU94gaTEDY6u1/fFv7EDstVxVZy3t2leItRbINXFPbL6c6ewTzhLIXeJ+woox4bq/z8luvHg5gKBqhYJjpVDUQpker/MGc2FERkQJafquZSKy2dzdswk91lP6PWbws6kkkHTO8cuBBFWDrFlwH04b1w09RMGpSZxIvHWcY/7dEJM87wpkhXIGURZ3eRm2EN7WFg6UHagLaZsb3bFDCdGUvJrEHfxVosgCZOt5UvLLmnGKfkuu8EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD3+fp0J+SvIeRbqDFeHN2HiGO89gGPsHzsS8mdb0aI=;
 b=Fj6KXlaecP2RKFh9+7hMlFUcXevzq0XF9Kp8NRunFVWzDI56vziCMDW93P3AReOLXQfA+1a9CrkkMT+AcsVjxm+Eog6b/043cbsZpeYSFr6kzFLMd/i3Vz3j4s5lgpH3BEpHNB2jRzvmYLAloQ+0d0+1K8tvhpwgKHkY0yA8zaj0TqUNIfVlWoD2sFy6w6/116165pEzIJGHxNsArQPO/kXc3qglBB7A6pszqorjsayJUFzw+Oy98HTq689+GheAQKxVfkNeyaoDIv4UkiGv4JmcQ7fkfjP246DocINKk9d5ROJK5mNG7Hgc8QolVSvZFTfO1eyEGhusMEJRgJWnNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD3+fp0J+SvIeRbqDFeHN2HiGO89gGPsHzsS8mdb0aI=;
 b=mfvJuug8FT9lBFzmPk8XdBHSKUMvpB2m16cQRmvb2DKuJAaIlIjWxb6PrjhLG1eDFaZxTDw3bWXBcc/n0C1f5Hmx1XqS99HAIPHCUIQqjX3j5Sa26DfHfejKlryW/5DiF8iCVssqarrJt58LlGiHxJgK8CH5d/NElDyf5o8PBGg=
Received: from AM6PR04MB6487.eurprd04.prod.outlook.com (20.179.245.140) by
 AM6PR04MB4968.eurprd04.prod.outlook.com (20.177.33.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Thu, 14 Nov 2019 05:12:30 +0000
Received: from AM6PR04MB6487.eurprd04.prod.outlook.com
 ([fe80::978:51e9:71fa:c731]) by AM6PR04MB6487.eurprd04.prod.outlook.com
 ([fe80::978:51e9:71fa:c731%5]) with mapi id 15.20.2430.028; Thu, 14 Nov 2019
 05:12:30 +0000
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
Subject: [v3,net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Thread-Topic: [v3,net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Thread-Index: AQHVmqodI6VvPNZtW0WlYIXrm4gE3A==
Date:   Thu, 14 Nov 2019 05:12:30 +0000
Message-ID: <20191114045833.18064-1-Po.Liu@nxp.com>
References: <20191112082823.28998-2-Po.Liu@nxp.com>
In-Reply-To: <20191112082823.28998-2-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR03CA0126.apcprd03.prod.outlook.com
 (2603:1096:4:91::30) To AM6PR04MB6487.eurprd04.prod.outlook.com
 (2603:10a6:20b:f7::12)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e79a0dfb-e556-40a9-983b-08d768c13f85
x-ms-traffictypediagnostic: AM6PR04MB4968:|AM6PR04MB4968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB49689FCED93561649321D08C92710@AM6PR04MB4968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(305945005)(186003)(7736002)(6512007)(102836004)(386003)(6506007)(11346002)(446003)(14454004)(76176011)(6486002)(6116002)(6436002)(26005)(3846002)(50226002)(2616005)(66066001)(486006)(476003)(2906002)(478600001)(316002)(71190400001)(110136005)(54906003)(66946007)(81156014)(52116002)(66476007)(36756003)(64756008)(8676002)(81166006)(66556008)(8936002)(71200400001)(1076003)(99286004)(86362001)(4326008)(66446008)(5660300002)(2201001)(14444005)(256004)(30864003)(2501003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB4968;H:AM6PR04MB6487.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZyU3gMJPxva3SIBGY1Zd1ML7BRrCmcRVrJ/wXm/uAvcK41heE/5PK4l7vDySjXpRBXgrdwEUMkBDEgHbNkhdgjJOtuF/tPO5oIKfOdf3GBGloPc7Rur+zY4ULoQ6anjyMvlFrR64XII6kUEHZyAD8ZtkcB/SZlkEobf2rZP9s2ROXPdB9Q0+DRvpj6ZDW+sfTBjset5cuyW4lyvq5oqKTEevsWt+zasFn/MzPasVMUCFnjgAuGFzWIT5XTn4eWTN0C5Zx8Jj13akgEd+Hs83rqOGNa/QEkg+vMu8pVEzFxnv6fvXAsEQmc73rQSTIl6JHkrVrqjBLpZSDuJbJV4STR6nXLNdb63YpBluuMgzrTbK/Ztav7m5CeQ/AOGifNO5LPkULAQonthdYwiU/ngN2hoqL+2XnKWLaYODnmjT55O15OQOjTuHr0dBUmWymHxa
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79a0dfb-e556-40a9-983b-08d768c13f85
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 05:12:30.4448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z+o9rq/SkoLchdDADqpUjGg9UWue+lieZ4fk6niBkFPQW6OsxNYgNbz5XXRs80/X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4968
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

 drivers/net/ethernet/freescale/enetc/Kconfig  |  10 ++
 drivers/net/ethernet/freescale/enetc/Makefile |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.c  |  19 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   7 +
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |   5 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  84 ++++++++---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 134 ++++++++++++++++++
 7 files changed, 239 insertions(+), 22 deletions(-)
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
index 000000000000..9ce983c00201
--- /dev/null
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -0,0 +1,134 @@
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
+	if (admin_conf->cycle_time > (u32)~0 ||
+	    admin_conf->cycle_time_extension > (u32)~0)
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
+		 tge & (~ENETC_QBV_TGE));
+
+	usleep_range(10, 20);
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

