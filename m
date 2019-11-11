Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F84F6D9F
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 05:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfKKElq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 23:41:46 -0500
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:8930
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbfKKElq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 23:41:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWLrgx4dNgMNRX99UBg8IoBIFPrZeIwD/ASRpCptiG+n4YCiPjIGa0N95bUIXl13bTiKny7B8/JziXZJq6UFQcDHhdqG2nYerDDQUUuNOABGFGBhjhv2t7JXdXEkk3ScenrXD/s0q7A2QRw2gtBuhycYWFkulTLP3EwzcK6wxvRj9KgPJckwaBHFLBSIIXxeD8YmuEcYGahIwuuW1KAdKIiRi8/jqFz3ubHaP8zBUPAeAFXpvGDJmogas4C+HqBsApX02cEGpGXBWl2Q0o6eRc3QLWTQ3en0OEoE4aP/FC4G1tW6ixUSK1W3ESrDj1twR7PMJ5ArzuO/LdqTVtnQ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+sOHd6zr9k/lgfKuim+ygUwgFs9BGni6360vNVdXCU=;
 b=hXpVwvom3eewdIRWoC5q2XchrR3OxjYoRHXLsgoZNEboh0/oq4KYBsMlWy5jwCRA4vOAeQ1k+xEMQyIjip8kOYJI3cZEto3r7JahsOAUypjH1PSf79dTnbyIUsqlM/e+y9v4V+u0sEaCmHM3db/Lip3G5v8GiUk4Mjcv52ahUzDAX59V+vQxkn02ZQIRHfSdiCgNfutPNz18tjRKuoq4nWy6M5YhZ/a3gx0DuOoW/Zr0yjTIznAB0tCN0Ho/a1IDdm/omF1TqY1K2rX92w2Fw/q6cWmo7TIXNLIKwikeMN3dl9harY2offHDv9GUEb6lsguLqbF9x80ov1oAM0ZFig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+sOHd6zr9k/lgfKuim+ygUwgFs9BGni6360vNVdXCU=;
 b=CdcvaZ5nsFv7PrCA78EwYzCJJIi9Lxe+lhEa9zKzHMBXL0nNNoLXuk2pCBIciJoG8EebHTZd5OVpqXZt1dVEbEesTTW7klaSB+pERqvLGaDc50q9K8q1OW6GkK0DEa8nG8HdrUXt1BGAW2zIUC4UE1Z6/vPE6i5584RiBokU5e8=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6704.eurprd04.prod.outlook.com (20.179.235.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Mon, 11 Nov 2019 04:41:39 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 04:41:39 +0000
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
Subject: [net-next, 2/2] enetc: update TSN Qbv PSPEED set according to adjust
 link speed
Thread-Topic: [net-next, 2/2] enetc: update TSN Qbv PSPEED set according to
 adjust link speed
Thread-Index: AQHVmEpO2cKBb2NFk0Clba5j/tGCPg==
Date:   Mon, 11 Nov 2019 04:41:39 +0000
Message-ID: <20191111042715.13444-2-Po.Liu@nxp.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
In-Reply-To: <20191111042715.13444-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN2PR01CA0034.prod.exchangelabs.com (2603:10b6:804:2::44)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f0ed30c6-8759-4f2e-1e43-08d76661710f
x-ms-traffictypediagnostic: VE1PR04MB6704:|VE1PR04MB6704:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6704D08290FD2552F97A357D92740@VE1PR04MB6704.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(189003)(199004)(486006)(52116002)(6436002)(76176011)(2616005)(4326008)(476003)(25786009)(14454004)(305945005)(26005)(86362001)(71190400001)(71200400001)(5660300002)(66946007)(6506007)(66446008)(64756008)(99286004)(6512007)(256004)(66476007)(11346002)(14444005)(6486002)(66066001)(386003)(1076003)(66556008)(446003)(102836004)(3846002)(6116002)(54906003)(50226002)(186003)(81166006)(8676002)(81156014)(8936002)(2501003)(478600001)(316002)(36756003)(7736002)(2201001)(2906002)(110136005)(15650500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6704;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9WrIroRjUhf6J2AWK/sMxbwYlpvOeO+jNskJAVTcho7ws7Wcb0QB0MEslpS2Lh8IhnI1EvJq1+c393+0P1onvLgDB2GpTW+9isKYhY6jJKXCsLex+xGEmSbUDpEEVEj8b9mbHxbktgqxfN0WPrH5MDiqOOFqzh9BGXnIqAmP8p+0U8QSlzU6zc228a2ebNoP9bR+d/D+t/vhLUd4vP1ufuB6OyxKCpRvSosqpCBp86QqdzG+vDPJw0MtKAnY4VuBFCmnK45xGOgHqAm+OQVMvzgGKz5NMn6DoTVQ5mboIvTe4HNlEdqEfa2GGHn/fV9yZQvFVJy/OefXdrkQ3f/UxiF432jLRDUKXm3FFxdtkHtRqsNkThx5tIawkCLjrtwTo3q++F1kCgio4q7F26hsTOAg04YHXF/7jempm6IXmYvJ7Vv5XOpeRovRtvmPKDiw
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ed30c6-8759-4f2e-1e43-08d76661710f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 04:41:39.5538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xsppl36zKz99Y/sI4KhD/8Xn0+VccdAWSOVE8VB/df+sAouF6ru8J12RtlIYCbMd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6704
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
Singed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 13 +++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  7 ++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  3 ++
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 34 +++++++++++++++++++
 4 files changed, 55 insertions(+), 2 deletions(-)

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
index 8676631041d5..e85e5301c578 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -118,6 +118,8 @@ enum enetc_errata {
 	ENETC_ERR_UCMCSWP	=3D BIT(2),
 };
=20
+#define ENETC_SI_F_QBV  (1<<0)
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
@@ -246,3 +252,4 @@ int enetc_get_rss_table(struct enetc_si *si, u32 *table=
, int count);
 int enetc_set_rss_table(struct enetc_si *si, const u32 *table, int count);
 int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd);
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
+void enetc_sched_speed_set(struct net_device *ndev);
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
index 036bb39c7a0b..801104dd2ba6 100644
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

