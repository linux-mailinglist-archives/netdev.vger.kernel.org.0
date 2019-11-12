Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F59F8ADD
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 09:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfKLInL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 03:43:11 -0500
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:44739
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbfKLInK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 03:43:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9tJgy04xt3La4AP1mXHTxC1Vl+W/CreGWSmB1ECWBebbDQsQrn7uC7KM0EpBxn4DsE0r1VcjBwsiOhTd9oj0u/FONkY2TbV9MQ1w1Zs5yHU6IxsAEKZVLMkn5Z1CYx0oz81Oo7MFuio2aXxeAp5aPlqqKneAN3jrpNiO/JyV/dTbj5UqumbbPwDPp9cIoNAQumnMc/JfxWsMNPKoeTmrYG3evbxfZjJ/2f+Seucug1JRvFRc2wslnbev04+YylW2KA511s0QCZ0lba2XHvZkIeV6kcavLby+EW4yhaIC1qML28wUg9G/K0RKqe55WJXX2qeG2H/PhcThlNlmqD3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLCUeW86bmT9LIsIWflZcKQaVCkAK7mxyAV/hZ3/t6I=;
 b=M2nL6saE1QnmI05bCqVDS/wc9MPwejyf5sw4EBxpRGV8hwce6deeKhF7PInkbCCy9ZZCDZDXqnB3NLQB5iaVVOyAnFPpVPMibVVRTQksCUoemo+BTAzKfVeLMv0OFZChAEe2TunCGNhKcEHL706BjTKjONOXszsSQeyWqM3oI+hXXpH/l3FCjCzlMPQXO6AlbNkdS0NGHVgetbNrd4aNtjZhRhlwDBzvihVKHC/a9zsTopESmZiRoj8j25esOUVoUGCY6xknB3APDt4fMAxn2SpDXf9gpHcZoCxNWGDt1Pw671Chh3etH55f35FMfmpH0XIZBJjAQ/crnMll+nwcdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLCUeW86bmT9LIsIWflZcKQaVCkAK7mxyAV/hZ3/t6I=;
 b=A9ncjOVNs1XUCADmDCVID6lDakYsdIlnarS5MzwdDUbNqfvz5XvsnftmHqmkNoyUEKZUgWoV1/evqiEPIjTEDK0hX6fWEMxFbSYeOfYkAsaelyo4UohyRhqvHp3G134pzpjKcuSA1qlZN0XEH7B/7837ThL8yqQcvN0aL48+Ca0=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6736.eurprd04.prod.outlook.com (20.179.235.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Tue, 12 Nov 2019 08:42:55 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 08:42:55 +0000
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
Subject: [v2,net-next, 2/2] enetc: update TSN Qbv PSPEED set according to
 adjust link speed
Thread-Topic: [v2,net-next, 2/2] enetc: update TSN Qbv PSPEED set according to
 adjust link speed
Thread-Index: AQHVmTUtMkdohiEMlkqOH7ZaTdnzow==
Date:   Tue, 12 Nov 2019 08:42:55 +0000
Message-ID: <20191112082823.28998-2-Po.Liu@nxp.com>
References: <20191111042715.13444-2-Po.Liu@nxp.com>
 <20191112082823.28998-1-Po.Liu@nxp.com>
In-Reply-To: <20191112082823.28998-1-Po.Liu@nxp.com>
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
x-ms-office365-filtering-correlation-id: f4e35799-90a9-49d1-4459-08d7674c5006
x-ms-traffictypediagnostic: VE1PR04MB6736:|VE1PR04MB6736:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB67363F8D8FE453756F61D17E92770@VE1PR04MB6736.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(199004)(189003)(14454004)(6486002)(52116002)(76176011)(6436002)(478600001)(7736002)(54906003)(316002)(36756003)(2501003)(110136005)(81166006)(81156014)(66446008)(64756008)(66556008)(66476007)(66946007)(305945005)(2906002)(3846002)(1076003)(11346002)(446003)(86362001)(99286004)(6116002)(8936002)(66066001)(2616005)(476003)(2201001)(15650500001)(6506007)(386003)(5660300002)(25786009)(486006)(4326008)(26005)(102836004)(50226002)(6512007)(256004)(14444005)(71190400001)(186003)(8676002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6736;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1MNm/CDmw2Pghsk9bYa/Y6OqBsoaSEtftWiUlwEKwm6VwzhoMicvJAqFJSnEuJRY+44dZuPHbOmO/YPjZgazSM+On8VQmMHPDs1caZxxy3cWniINp8imL6tLjMELZkhcxmnoGhgqPH1nbkyZZiAddeCr9eVub8sE1eI6BQ+PAHbj9gZmywAKpIIHI6B1OZGVYskj+NDDgt72Sod2hHqlWvx8IF7gtHkMgWrtWu7R8SzZ8SHmC5d9IWMPFvEwFBA+mfpUkF71B85fxZ79XkLR7e1G2GJLvESiQWsI0J/Cs/6/ri2bmXDs70RqvWQRVAFl3pwnHw0luMiKLk47TPFd8SGp1siQpAxk3llNocYSwmJ7pkorCRuP/JuuZv5I2IIjVk4pAATmcph9HW2K6cPXn/BuTWc8rYc0Y1H/IVscN9PouWLJi2y+qFoCsQA7aZlv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e35799-90a9-49d1-4459-08d7674c5006
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 08:42:55.7246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuCupn8KlOXNnR/lUILCMRUX88+f7QXsAHXj7/JqPJb5qqEH++tO2miBMEk4f+j9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6736
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
changes:
- fix for enetc_sched_speed_set() define for different config.

 drivers/net/ethernet/freescale/enetc/enetc.c  | 13 +++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  8 +++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  3 ++
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 34 +++++++++++++++++++
 4 files changed, 56 insertions(+), 2 deletions(-)

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

