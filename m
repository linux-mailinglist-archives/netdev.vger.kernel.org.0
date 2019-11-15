Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7820FD368
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 04:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKODf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 22:35:26 -0500
Received: from mail-eopbgr10080.outbound.protection.outlook.com ([40.107.1.80]:53380
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727077AbfKODfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 22:35:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diAv0yUe63AwF4IXdPTU0QoSARmiIOw+dnRClbKsI1+eKd2Az7KkZMjIRE8HsJWU+H8OQ83cwAu/XkcoBzgYdG6DkBo0Rs/+sXyKx3WjoEYr2fVrvwFc+5FkgJWxr9mdSpjBndEN/aTvGrUlDex+AuA7MBzSnXeweWKG5Q4GwDLJWIM5+omjoYtoV2cNgYh5WNzhLiEjd5GJKY+4abQrRMK8PMQVxG6jtowP3rOLlD/cc2djMd/gertbTYJKQ2yfTTdBA+sMKX3xgDclL0Jr5r+O2eiUws33GuGFeRtZKNTQpkddepVzK2vpvOgI9Z7hUC1kT4YWcb5HauGE8iY9Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQn5u6lnZCXVMMbMsyHhMxK+bQ+N+9RuXlT/1ehgens=;
 b=WHd5L4/yeebFHGHq/6ztoIsWTMnndpMxREZoEUX0MSoCOqVRQ4fWi5lN3QN4N/Ti1ombnGQKC8WaKhk9zTEm5rTnioYwQZh5i4S3pDHJPYhtWv/BDMGw+t6fcU20bL9yZxllMuHsBg61Jas8XrsQzxZeH2z8phBCCQCOaB7Kqf/FcEaSE46oy56e6BiEl0Xti3tDtfjCePbzj3XGQHArOwz2OPSWPzCQp1NjyYt6siJ+/Tpbj8xhbYUTX7XZ633beWldfZgitj3fvpTX7NByZGi2FCo1AvPkC6tdd8ZKX9A+YguGjTA9G+ec8HtIQ99rQ4BbnHMkudkHlG1MWM38TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQn5u6lnZCXVMMbMsyHhMxK+bQ+N+9RuXlT/1ehgens=;
 b=JXfVZttXJ6yHZ7b88C3rdfOx9DU/tewKOuXB2qsyf7FycmOO9n4SQR8VlkmlB3vl+Ym/puKH/tKt2nmx57ghXRIM4Kq4CJVgFnyWFiNiQDAOVLdreG2TlrGSFFMrgtKRs7gIJga+9HSCwJeQov/AjVFkaXzZVy+TjBSs35746HE=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6541.eurprd04.prod.outlook.com (20.179.234.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Fri, 15 Nov 2019 03:33:41 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 03:33:41 +0000
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
Subject: [v4,net-next, 2/2] enetc: update TSN Qbv PSPEED set according to
 adjust link speed
Thread-Topic: [v4,net-next, 2/2] enetc: update TSN Qbv PSPEED set according to
 adjust link speed
Thread-Index: AQHVm2V5VG+7SfCv5UqGWZSi6hQVOg==
Date:   Fri, 15 Nov 2019 03:33:41 +0000
Message-ID: <20191115031846.4871-2-Po.Liu@nxp.com>
References: <20191114045833.18064-2-Po.Liu@nxp.com>
 <20191115031846.4871-1-Po.Liu@nxp.com>
In-Reply-To: <20191115031846.4871-1-Po.Liu@nxp.com>
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
x-ms-office365-filtering-correlation-id: e571654b-f992-40f4-f8ec-08d7697c9bfa
x-ms-traffictypediagnostic: VE1PR04MB6541:|VE1PR04MB6541:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6541A6C437F7F1D92169921992700@VE1PR04MB6541.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(199004)(189003)(25786009)(54906003)(76176011)(102836004)(52116002)(14454004)(2906002)(81166006)(316002)(478600001)(110136005)(36756003)(15650500001)(386003)(14444005)(305945005)(99286004)(2201001)(6116002)(3846002)(6506007)(7736002)(50226002)(8936002)(26005)(86362001)(1076003)(256004)(186003)(8676002)(81156014)(446003)(486006)(476003)(71190400001)(71200400001)(2501003)(2616005)(4326008)(6486002)(66066001)(66946007)(5660300002)(66476007)(11346002)(6436002)(6512007)(66556008)(66446008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6541;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ADJsSoQtt0vVnApB8+oA/vP3Om1YKWFnzKhD+PhwlJZrc7W2n5XxQRuy7hSAJAoseyefY9BeuUHi4Y/7/WijBZxQIZWeyvVA4Vzf/pBYt35/9GaxiSPgVmafZhq9PJ9j/hBcc3EviYQSZg3MvcfDfnoye73Q9H1k6L9teDZ/rN4W0cJvRr/lZponoyyy22RhuHcNdSIitZ78x7+1BDWiQdRW8WA7cTtzHvVvTA/nmb5uNZ2TYbFcow0EQQ8PHvqdG5d8qoPuGB7DmyiQNR+9SmCNjVbcTRFUY+6shDDSzD/yb4tFmPHzrVohl3MIIyt+U+BCAnoRkmilgaO/XzlLm6pKS1lktwheiEWs8SZkRRyJ/QYNt/y7UvNLhYgf/vlTtcN8LvNIXNBqlarRM6C0au3lHUgpfvAS71dafHkdByK19h+SZ+tLFFGi2v4MnW7Q
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e571654b-f992-40f4-f8ec-08d7697c9bfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 03:33:41.4779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EW+bT8hJDKZNRdky5u/tB6FFVXhNvTMpl1jtWMS8Bju4YwD6cCLIeoM4qPaVa0yl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6541
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
index 84c2ab98fae9..66a3da61ca16 100644
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

