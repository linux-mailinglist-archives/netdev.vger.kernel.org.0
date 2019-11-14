Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DC1FBF04
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfKNFMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:12:44 -0500
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:48100
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbfKNFMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 00:12:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmVfHfjsuXe+iAiC6N0Bz57sX/KqBuWAEg8ekdA/Lt3SwcC0Bj+XZKR/XWPZ5oYriykXBJn5BGotmd6zKTu5XjrVPbaXulC0eY0z7StV3CFfCMq5iSPCLmth+N8przE6HMxg3nDKhaEswrvvdhKRcCOxiHJQSYbTua/U5PEL5CPAG1gBpC462ZZplYRgDKm46XU9rdTrvx3E0XpV9/KstsNuCele1KXhsV/BqXTyavc/foqFmyeTjpxry7agPeGDuKy2MjDT/PizOqTMVoWTYv4mSro5rrd6oegL0BkLWMQYEl9z2a+CZVZL2f/CZ1Z+Y8Ap6na3v2BBtN2xFpfjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NM3k5oxAQRi3Jm9Wa/3vpsaAvzp11ZPEUlEMQR1AyHI=;
 b=KAJuv7lPhGCJ+7Mr5NYCOQYeJJzHmxlnIShjS5LeONORaEnMNS8ssDMWG1MfQPTr+MoaKauahejWOufZwY70oT8xlrgScW6l/8C0QurF5be8uWtMG2Vkt67mlwILoee6ZzXiVCkeUkrR7QATv0t7qXdUCx7fmv1hEL3W68qTZmxb7IDiqXRKLAUtAsZp5ge70XBD7JqOqnjfVSR3DJnESfzabeBxFzVcinex1VqnG7skSa3ZPfg6oa2Mp1Y9aGFuXOhkmCAPhWhL6S8rzHZdxK76L/LixY4NvdL0HMZl++QBtuECi3YBG66l45yHHnIA3kQCcr0R75kP33sxnR+IvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NM3k5oxAQRi3Jm9Wa/3vpsaAvzp11ZPEUlEMQR1AyHI=;
 b=pikb03EWQk0BVkXTSglrWjH83DX1qtFFCeao2QzqMtS3DuCJGrPYYQyVOB/m5E41OL3sxj6Dzd4DTUWO87ci/eSpxJYPrwakdsiebZY2+BzdKjPNwym/BGdSTw0CBb9Byhk5SYHs/pCocVyrLPwQ3jSbQ7vPyj6hYnMr2Z0UL0o=
Received: from AM6PR04MB6487.eurprd04.prod.outlook.com (20.179.245.140) by
 AM6PR04MB4968.eurprd04.prod.outlook.com (20.177.33.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Thu, 14 Nov 2019 05:12:36 +0000
Received: from AM6PR04MB6487.eurprd04.prod.outlook.com
 ([fe80::978:51e9:71fa:c731]) by AM6PR04MB6487.eurprd04.prod.outlook.com
 ([fe80::978:51e9:71fa:c731%5]) with mapi id 15.20.2430.028; Thu, 14 Nov 2019
 05:12:36 +0000
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
Subject: [v3,net-next, 2/2] enetc: update TSN Qbv PSPEED set according to
 adjust link speed
Thread-Topic: [v3,net-next, 2/2] enetc: update TSN Qbv PSPEED set according to
 adjust link speed
Thread-Index: AQHVmqogYM3CfCNRQUGY3F/oUSkAZA==
Date:   Thu, 14 Nov 2019 05:12:35 +0000
Message-ID: <20191114045833.18064-2-Po.Liu@nxp.com>
References: <20191112082823.28998-2-Po.Liu@nxp.com>
 <20191114045833.18064-1-Po.Liu@nxp.com>
In-Reply-To: <20191114045833.18064-1-Po.Liu@nxp.com>
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
x-ms-office365-filtering-correlation-id: 3afac0b0-f24b-41ea-9fa7-08d768c142e7
x-ms-traffictypediagnostic: AM6PR04MB4968:|AM6PR04MB4968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB496881789DF101BD094C992F92710@AM6PR04MB4968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(305945005)(186003)(7736002)(6512007)(102836004)(386003)(6506007)(11346002)(446003)(14454004)(76176011)(6486002)(6116002)(6436002)(26005)(3846002)(50226002)(2616005)(66066001)(486006)(476003)(2906002)(478600001)(15650500001)(316002)(71190400001)(110136005)(54906003)(66946007)(81156014)(52116002)(66476007)(36756003)(64756008)(8676002)(81166006)(66556008)(8936002)(71200400001)(1076003)(99286004)(86362001)(4326008)(66446008)(5660300002)(2201001)(14444005)(256004)(2501003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB4968;H:AM6PR04MB6487.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gR6xRlf5So4BT1ZB0ssvk4iRQyO0K0i/IH0Vda2S+kICyZ1+lXTEkj9SKetglbrqLzgjOjzq//EnuQq6nT8NiS7mbiOd6TQ+dciwqw9FpV0h84NJiYABjMRCAnCU56PdnlwlwRVvjJbZ1UppPu/o8fYTqQFcG/udNxs626iCwq2TaoNbwRcDUUTeMijfD3tsZZLvj7orCzLpr9I10v6w7unNt+OojLxs4NSnBj/ueHsb8qthMTP48RVEjr9TB+Dls6r3W1Q4rVmlaN9xUVA9vyAxjMG8DHm19xamZGnQc/tJ7k66PaVVg2v8zYEaCi/ehrR+bjs15ZL6fob4wKhAXRT5I2a5ag7p0lQZtZ5zgmFaE5EGbiKdoohaonO7Ulm5ZlIN/Yg15nH/kWFsotPE3pfnSzz4yK4Nc9FjnTLlj9awywKWmpL1A94Aq02YkiC0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3afac0b0-f24b-41ea-9fa7-08d768c142e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 05:12:35.9465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dg7SZX3PncIk7JuOAWtgQjyw+oMNul85cOe56hlNaQYYrGg/vB0+XVyFU8BUuW9D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENETC has a register PSPEED to indicate the link speed of hardware.
It is need to update accordingly. PSPEED field needs to be updated
with the port speed for QBV scheduling purposes. Or else there is
chance for gate slot not free by frame taking the MAC if PSPEED and
phy speed not match. So update PSPEED when link adjust. This is
implement by the adjust_link.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 13 +++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  8 +++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  5 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  3 ++
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 34 +++++++++++++++++++
 5 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index d58dbc2c4270..f6b00c68451b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -742,9 +742,14 @@ void enetc_get_si_caps(struct enetc_si *si)
 	si->num_rss =3D 0;
 	val =3D enetc_rd(hw, ENETC_SIPCAPR0);
 	if (val & ENETC_SIPCAPR0_RSS) {
-		val =3D enetc_rd(hw, ENETC_SIRSSCAPR);
-		si->num_rss =3D ENETC_SIRSSCAPR_GET_NUM_RSS(val);
+		u32 rss;
+
+		rss =3D enetc_rd(hw, ENETC_SIRSSCAPR);
+		si->num_rss =3D ENETC_SIRSSCAPR_GET_NUM_RSS(rss);
 	}
+
+	if (val & ENETC_SIPCAPR0_QBV)
+		si->hw_features |=3D ENETC_SI_F_QBV;
 }
=20
 static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
@@ -1314,8 +1319,12 @@ static void enetc_disable_interrupts(struct enetc_nd=
ev_priv *priv)
=20
 static void adjust_link(struct net_device *ndev)
 {
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
 	struct phy_device *phydev =3D ndev->phydev;
=20
+	if (priv->active_offloads & ENETC_F_QBV)
+		enetc_sched_speed_set(ndev);
+
 	phy_print_status(phydev);
 }
=20
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/eth=
ernet/freescale/enetc/enetc.h
index 8ca2f97050c8..89f23156f330 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -118,6 +118,8 @@ enum enetc_errata {
 	ENETC_ERR_UCMCSWP	=3D BIT(2),
 };
=20
+#define ENETC_SI_F_QBV BIT(0)
+
 /* PCI IEP device data */
 struct enetc_si {
 	struct pci_dev *pdev;
@@ -133,6 +135,7 @@ struct enetc_si {
 	int num_fs_entries;
 	int num_rss; /* number of RSS buckets */
 	unsigned short pad;
+	int hw_features;
 };
=20
 #define ENETC_SI_ALIGN	32
@@ -173,6 +176,7 @@ struct enetc_cls_rule {
 enum enetc_active_offloads {
 	ENETC_F_RX_TSTAMP	=3D BIT(0),
 	ENETC_F_TX_TSTAMP	=3D BIT(1),
+	ENETC_F_QBV             =3D BIT(2),
 };
=20
 struct enetc_ndev_priv {
@@ -188,6 +192,8 @@ struct enetc_ndev_priv {
 	u16 msg_enable;
 	int active_offloads;
=20
+	u32 speed; /* store speed for compare update pspeed */
+
 	struct enetc_bdr *tx_ring[16];
 	struct enetc_bdr *rx_ring[16];
=20
@@ -248,6 +254,8 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_cb=
d *cbd);
=20
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
+void enetc_sched_speed_set(struct net_device *ndev);
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
+#define enetc_sched_speed_set(ndev) (void)0
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/=
ethernet/freescale/enetc/enetc_hw.h
index df6b35dc3534..924ddb6d358a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -149,6 +149,11 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PORT_BASE		0x10000
 #define ENETC_PMR		0x0000
 #define ENETC_PMR_EN	GENMASK(18, 16)
+#define ENETC_PMR_PSPEED_MASK GENMASK(11, 8)
+#define ENETC_PMR_PSPEED_10M	0
+#define ENETC_PMR_PSPEED_100M	BIT(8)
+#define ENETC_PMR_PSPEED_1000M	BIT(9)
+#define ENETC_PMR_PSPEED_2500M	BIT(10)
 #define ENETC_PSR		0x0004 /* RO */
 #define ENETC_PSIPMR		0x0018
 #define ENETC_PSIPMR_SET_UP(n)	BIT(n) /* n =3D SI index */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/=
ethernet/freescale/enetc/enetc_pf.c
index 7da79b816416..e7482d483b28 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -742,6 +742,9 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, =
struct net_device *ndev,
=20
 	ndev->priv_flags |=3D IFF_UNICAST_FLT;
=20
+	if (si->hw_features & ENETC_SI_F_QBV)
+		priv->active_offloads |=3D ENETC_F_QBV;
+
 	/* pick up primary MAC address from SI */
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net=
/ethernet/freescale/enetc/enetc_qos.c
index 9ce983c00201..f804da639dd3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -11,6 +11,40 @@ static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 		& ENETC_QBV_MAX_GCL_LEN_MASK;
 }
=20
+void enetc_sched_speed_set(struct net_device *ndev)
+{
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	struct phy_device *phydev =3D ndev->phydev;
+	u32 old_speed =3D priv->speed;
+	u32 speed, pspeed;
+
+	if (phydev->speed =3D=3D old_speed)
+		return;
+
+	speed =3D phydev->speed;
+	switch (speed) {
+	case SPEED_1000:
+		pspeed =3D ENETC_PMR_PSPEED_1000M;
+		break;
+	case SPEED_2500:
+		pspeed =3D ENETC_PMR_PSPEED_2500M;
+		break;
+	case SPEED_100:
+		pspeed =3D ENETC_PMR_PSPEED_100M;
+		break;
+	case SPEED_10:
+	default:
+		pspeed =3D ENETC_PMR_PSPEED_10M;
+		netdev_err(ndev, "Qbv PSPEED set speed link down.\n");
+	}
+
+	priv->speed =3D speed;
+	enetc_port_wr(&priv->si->hw, ENETC_PMR,
+		      (enetc_port_rd(&priv->si->hw, ENETC_PMR)
+		      & (~ENETC_PMR_PSPEED_MASK))
+		      | pspeed);
+}
+
 static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
--=20
2.17.1

