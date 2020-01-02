Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9781412E271
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 05:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgABE7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 23:59:30 -0500
Received: from mail-eopbgr10041.outbound.protection.outlook.com ([40.107.1.41]:62315
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726234AbgABE7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jan 2020 23:59:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5SRiR3GDxUzZ4TmLbl2qQmRehx+eMtl0+xIfKtPVeNIPLPRiJq9IEh7nXmwkWqRhlAGsqJKt/yhZiOfa3n3KsxMIbXzbzrvt+/bQRbt7nvMSqmqVxx47BXLmsAVPDm20Rq+p8JYkpprV6AXxZwYKUu7mebIrBITXbDLGrCwToXo4m44qYJJkFWA83D2zuwvmk8DluKU0+QjSs+jJJzr9I3uncpJaTXjdZ0A+75YsotnI3s4V0E9uqRtaCKbJiBeJbZIWlG5zpaD6y0VJB0eehOF/Dw2u7ov0jIWCXGB1zBvNxmjIFBSK5SG+OXxlzL7o78q8o3jQIhVWzJeO6QBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH+Q2jUtZObAtd5ZgFVyHje4pkVJqVeN9cIHu1VFick=;
 b=AlqIp1BUXuM1FeBQy0hi4n3cg1F4BkzhRuJfPcs8VTVst6ZPD6l2g/mkIGHhxaO1ZcyuWCF5VcVjP4cmE1oR5eWeIg3lZOGUE8Of6nBuDTVl3gWCsz1TRVATgkueptZT4DerhN+FkIS8ylax0zV2Uydfs56Qu5VhJVNUGuxEhJgDzDqaETdLpU/fIDOX0T0i2W80FNePyBFxemQ7Mfa3TsLSInXioUYV5jHQu/5mJgquK59gQ6dti1E/lg+gAflmfwCAQrokrnwcs4c9pW1B6nWB2cG5T7eaFKpS05B5hQeC5s0aUU1BQj5PDJdlnrwSVMdUHDEkE7gjEVhDyEESdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH+Q2jUtZObAtd5ZgFVyHje4pkVJqVeN9cIHu1VFick=;
 b=C+sp5pTnYawSwCTNuBawNBndcKfnBVDDsg9YuDmP8UVy/YiJ14vUBZcY2D87Y5EY1MTo8GQFLpID7oOtCDLERwpxPLDJXV3wnrYHH4QLbo452VlzcmjkfuckSirFiTRcI/ukpVeQwmD3GwtMGTA+5dHK7itST3VvBAiBkueRd+8=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6495.eurprd04.prod.outlook.com (20.179.233.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Thu, 2 Jan 2020 04:59:25 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc%3]) with mapi id 15.20.2581.014; Thu, 2 Jan 2020
 04:59:24 +0000
Received: from localhost.localdomain (119.31.174.73) by SN6PR16CA0052.namprd16.prod.outlook.com (2603:10b6:805:ca::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Thu, 2 Jan 2020 04:59:17 +0000
From:   Po Liu <po.liu@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        Po Liu <po.liu@nxp.com>
Subject: [v3,net-next] enetc: add support time specific departure base on the
 qos etf
Thread-Topic: [v3,net-next] enetc: add support time specific departure base on
 the qos etf
Thread-Index: AQHVwSlnww15nN+qGkyfsmt/WTIGog==
Date:   Thu, 2 Jan 2020 04:59:24 +0000
Message-ID: <20200102044300.29951-1-Po.Liu@nxp.com>
References: <20191227025547.4452-1-Po.Liu@nxp.com>
In-Reply-To: <20191227025547.4452-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN6PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:805:ca::29) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66419aad-13c8-44d0-25a4-08d78f408933
x-ms-traffictypediagnostic: VE1PR04MB6495:|VE1PR04MB6495:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB649599BF472ABEA4B153363692200@VE1PR04MB6495.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(189003)(199004)(110136005)(478600001)(66556008)(66476007)(66446008)(6486002)(6666004)(66946007)(316002)(4326008)(54906003)(8676002)(81156014)(81166006)(6512007)(64756008)(5660300002)(86362001)(71200400001)(6506007)(186003)(26005)(36756003)(16526019)(69590400006)(8936002)(1076003)(2906002)(956004)(2616005)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6495;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RqlSyhtZbyLe5D8z6AhRJ245mk2W/OpfSPQOAshLmb8XRg++eneBvVXmTPsR2JgNvjm8eZuafmUAsasaP5oeAP7diEdQPecXLAOA6JqbAYBdtamugf0pHIkCE+it3KH3dsege+3w26nxs0Z9odZ1x0b6M7Nfo4TUtLJktwgcAvAOCNDyWLcKBoGzSFWY6/E1EbIzQaPVzRwYWtpsWI85YWefeuvNHHJLdMlx7i9Hm/PlZdKP/+cFgMEhMXgMJC/o1/z+kgCfKK9jb3VwmFybAxXSbn3qQCNW4pJvxGR5KcK8RIeBHIwo9cwfRZ9OdlLTrGcPeFAXYZpSSFGyqWB+84MCv9tSlwWCo82dyXJvkgeqcsqTWOGDA8i/tndRFgmK1fTmS5ahQv8tw2himQG31q1VResT0Git0EDlG2tGO5/beIIoV1/8jaZ08+jB80IPPMq9qgvwHdH/Kn4kMf9slaH2lO37fAu6r0U+y1lytR0tNyk7/qLyiPg7kGvGK+dt
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66419aad-13c8-44d0-25a4-08d78f408933
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2020 04:59:24.7478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xs8jY6Omz27uR5CE5cr66p+jwV5N2Og2VM56au7726U+OSrtqhlOCsWJNJEHhiBM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6495
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENETC implement time specific departure capability, which enables
the user to specify when a frame can be transmitted. When this
capability is enabled, the device will delay the transmission of
the frame so that it can be transmitted at the precisely specified time.
The delay departure time up to 0.5 seconds in the future. If the
departure time in the transmit BD has not yet been reached, based
on the current time, the packet will not be transmitted.

This driver was loaded by Qos driver ETF. User could load it by tc
commands. Here are the example commands:

tc qdisc add dev eth0 root handle 1: mqprio \
	   num_tc 8 map 0 1 2 3 4 5 6 7 hw 1
tc qdisc replace dev eth0 parent 1:8 etf \
	   clockid CLOCK_TAI delta 30000  offload

These example try to set queue mapping first and then set queue 7
with 30us ahead dequeue time.

Then user send test frame should set SO_TXTIME feature for socket.

There are also some limitations for this feature in hardware:
- Transmit checksum offloads and time specific departure operation
are mutually exclusive.
- Time Aware Shaper feature (Qbv) offload and time specific departure
operation are mutually exclusive.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes v2-v3:
- Avoid tx checking sum offload when setting TXTIME offload. This is
not support in hardware.

 drivers/net/ethernet/freescale/enetc/enetc.c  | 12 +++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 ++
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 10 +++++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 35 +++++++++++++++++++
 4 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index 2ee4a2cd4780..1f79e36116a3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -149,11 +149,21 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ri=
ng, struct sk_buff *skb,
=20
 	if (enetc_tx_csum(skb, &temp_bd))
 		flags |=3D ENETC_TXBD_FLAGS_CSUM | ENETC_TXBD_FLAGS_L4CS;
+	else if (tx_ring->tsd_enable)
+		flags |=3D ENETC_TXBD_FLAGS_TSE | ENETC_TXBD_FLAGS_TXSTART;
=20
 	/* first BD needs frm_len and offload flags set */
 	temp_bd.frm_len =3D cpu_to_le16(skb->len);
 	temp_bd.flags =3D flags;
=20
+	if (flags & ENETC_TXBD_FLAGS_TSE) {
+		u32 temp;
+
+		temp =3D (skb->skb_mstamp_ns >> 5 & ENETC_TXBD_TXSTART_MASK)
+			| (flags << ENETC_TXBD_FLAGS_OFFSET);
+		temp_bd.txstart =3D cpu_to_le32(temp);
+	}
+
 	if (flags & ENETC_TXBD_FLAGS_EX) {
 		u8 e_flags =3D 0;
 		*txbd =3D temp_bd;
@@ -1505,6 +1515,8 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_s=
etup_type type,
 		return enetc_setup_tc_taprio(ndev, type_data);
 	case TC_SETUP_QDISC_CBS:
 		return enetc_setup_tc_cbs(ndev, type_data);
+	case TC_SETUP_QDISC_ETF:
+		return enetc_setup_tc_txtime(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/eth=
ernet/freescale/enetc/enetc.h
index 7ee0da6d0015..dd4a227ffc7a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -72,6 +72,7 @@ struct enetc_bdr {
 	struct enetc_ring_stats stats;
=20
 	dma_addr_t bd_dma_base;
+	u8 tsd_enable; /* Time specific departure */
 } ____cacheline_aligned_in_smp;
=20
 static inline void enetc_bdr_idx_inc(struct enetc_bdr *bdr, int *i)
@@ -256,8 +257,10 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_c=
bd *cbd);
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct net_device *ndev);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
+int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data);
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(ndev) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
+#define enetc_setup_tc_txtime(ndev, type_data) -EOPNOTSUPP
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/=
ethernet/freescale/enetc/enetc_hw.h
index 51f543ef37a8..8375cd886dba 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -358,6 +358,7 @@ union enetc_tx_bd {
 				u8 l4_csoff;
 				u8 flags;
 			}; /* default layout */
+			__le32 txstart;
 			__le32 lstatus;
 		};
 	};
@@ -378,11 +379,14 @@ union enetc_tx_bd {
 };
=20
 #define ENETC_TXBD_FLAGS_L4CS	BIT(0)
+#define ENETC_TXBD_FLAGS_TSE	BIT(1)
 #define ENETC_TXBD_FLAGS_W	BIT(2)
 #define ENETC_TXBD_FLAGS_CSUM	BIT(3)
+#define ENETC_TXBD_FLAGS_TXSTART BIT(4)
 #define ENETC_TXBD_FLAGS_EX	BIT(6)
 #define ENETC_TXBD_FLAGS_F	BIT(7)
-
+#define ENETC_TXBD_TXSTART_MASK GENMASK(24, 0)
+#define ENETC_TXBD_FLAGS_OFFSET 24
 static inline void enetc_clear_tx_bd(union enetc_tx_bd *txbd)
 {
 	memset(txbd, 0, sizeof(*txbd));
@@ -615,3 +619,7 @@ struct enetc_cbd {
 /* Port time gating capability register */
 #define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
 #define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
+
+/* Port time specific departure */
+#define ENETC_PTCTSDR(n)	(0x1210 + 4 * (n))
+#define ENETC_TSDE		BIT(31)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net=
/ethernet/freescale/enetc/enetc_qos.c
index 9190ffc9f6b2..e910aaf0f5ec 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -156,6 +156,11 @@ int enetc_setup_tc_taprio(struct net_device *ndev, voi=
d *type_data)
 	int err;
 	int i;
=20
+	/* TSD and Qbv are mutually exclusive in hardware */
+	for (i =3D 0; i < priv->num_tx_rings; i++)
+		if (priv->tx_ring[i]->tsd_enable)
+			return -EBUSY;
+
 	for (i =3D 0; i < priv->num_tx_rings; i++)
 		enetc_set_bdr_prio(&priv->si->hw,
 				   priv->tx_ring[i]->index,
@@ -297,3 +302,33 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *=
type_data)
=20
 	return 0;
 }
+
+int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	struct tc_etf_qopt_offload *qopt =3D type_data;
+	u8 tc_nums =3D netdev_get_num_tc(ndev);
+	int tc;
+
+	if (!tc_nums)
+		return -EOPNOTSUPP;
+
+	tc =3D qopt->queue;
+
+	if (tc < 0 || tc > priv->num_tx_rings)
+		return -EINVAL;
+
+	/* Do not support TXSTART and TX CSUM offload simutaniously */
+	if (ndev->features & NETIF_F_CSUM_MASK)
+		return -EBUSY;
+
+	/* TSD and Qbv are mutually exclusive in hardware */
+	if (enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+		return -EBUSY;
+
+	priv->tx_ring[tc]->tsd_enable =3D qopt->enable;
+	enetc_port_wr(&priv->si->hw, ENETC_PTCTSDR(tc),
+		      qopt->enable ? ENETC_TSDE : 0);
+
+	return 0;
+}
--=20
2.17.1

