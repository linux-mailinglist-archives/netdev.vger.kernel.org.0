Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF510887A
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 06:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfKYF5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 00:57:06 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:35236
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725468AbfKYF5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 00:57:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1E52IlMCsnwwDXVH8/Ga1W5G7RzjJiVnuXDDZehfNQnhtuqC6xB/yGzAMdq53gchEZCnGWPSYjceg6tb4eUmYoPj0vhYBqEpFcLAvlLPmuZ+okD4ezjXfIUWFw1ocX1B73nVhGw810FS/Mhkb/jWgwbTd7z4n+rDChZmwoBvPT7QFMdk2+Vv3cJdFJkEihKSqYkhypogYyyZTREGQeIhNmyP47U4O3z94Doalqk4FMjmdEVLEjfHmgYuJQ+DNNCldLyoureQBdpCP8wf30afNE6EIU1D7UWft1X0R2Qg2+spcSTRHsiUcW5qu8Ch0v2blxQzrzQ9qbccBbC/why8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hOalfh0kMwfeGSdATO/oSbf+hFXbh9NSW9y/rwYFcs=;
 b=kib90nbwUhieWS9qEXbvmbaYriQbeg0PcTM4P2stvpbxirpuYgwBMAwLL64SU1xpmZzvl0QCetUzIzq6f+qw8qZQ5le2oACM9Cr2Abfc2BuArjhNqfnu2Uz5sAhibX9xlxb6+0TKY4nRvBXVOcCH1ub3H4qt3GRfC6Pxx6GWQRBdu0PCxGOaskjG8ndcdeCxhh11qrUeJ7GF9xXsPXQ8Ed6bjnG6b8NrqqN/BJZRKdutNbETRQC2brPSAXmIz5OPm+wMaaSEudWyTctljZDtnLxvgCwTKqWg2+YmxAAf92xFnxxRo+H3ZNS+vTZyCVzWh2QCWsgfMpNUmuK6aGw/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hOalfh0kMwfeGSdATO/oSbf+hFXbh9NSW9y/rwYFcs=;
 b=rIkKi+0gZZc51dCs/YvSleO/y2mrgysginqTm4/j8K6FHOEWshKqmIcAb48kOJiyHKS5kXgKtY88dCmpGbX8MlzmT4hFmORi1YcGu7iiwFz8wCT4natTIGbl5bnh0Db22BZPvHaTEo9uZRrj4Rm+9my56yOFmdwnJMxUwBpUOE0=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6382.eurprd04.prod.outlook.com (20.179.234.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Mon, 25 Nov 2019 05:56:57 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 05:56:57 +0000
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
        Po Liu <po.liu@nxp.com>
Subject: [v2,net-next] enetc: add support Credit Based Shaper(CBS) for
 hardware offload
Thread-Topic: [v2,net-next] enetc: add support Credit Based Shaper(CBS) for
 hardware offload
Thread-Index: AQHVo1UlGPgqH1H6/kKo1eQYE8sXjQ==
Date:   Mon, 25 Nov 2019 05:56:56 +0000
Message-ID: <20191125054300.31346-1-Po.Liu@nxp.com>
References: <20191122070321.20915-1-Po.Liu@nxp.com>
In-Reply-To: <20191122070321.20915-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN1PR12CA0063.namprd12.prod.outlook.com
 (2603:10b6:802:20::34) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 39f45977-b732-4eea-6317-08d7716c4747
x-ms-traffictypediagnostic: VE1PR04MB6382:|VE1PR04MB6382:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB63822E0B4087415FA7B30BFC924A0@VE1PR04MB6382.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(189003)(199004)(4326008)(6116002)(186003)(8676002)(76176011)(36756003)(7736002)(305945005)(52116002)(66946007)(66446008)(64756008)(66556008)(3846002)(6512007)(8936002)(2201001)(81156014)(81166006)(71190400001)(66066001)(2501003)(71200400001)(386003)(26005)(6506007)(102836004)(66476007)(50226002)(316002)(54906003)(1076003)(2616005)(6486002)(2906002)(6436002)(99286004)(478600001)(256004)(14444005)(11346002)(446003)(25786009)(14454004)(5660300002)(86362001)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6382;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nf7swg+AuZMZq6zKDAn7r/TnyPgNIW+/pcXVuwg6zm6c8fXSL0XqXAJebWhGaz/b8dKxNEZBq76PbikOnN3pX7DsEbMFAbK9Hn7cDb37Ss8XlRMZnYti02jiQNE2qa5hWPFuGzBP+w/r6kXavPIvaIqWny3hZ3jiqv26xLP2GV0FcSwOG8vLHb6A5KGJ1PpvduCwPAjyTQg5Vh034Pl5NV8TeF6zCPcg0K6jkShAX0dIXwp5Z9IeuEBN84KGhNlgTfmOUm99pfiQfVqJoPm+4UMTPRU/WrdaLpiol70RXqZDCSPhAgSNiB176dw9A4Cf7I3z/NzU69eMvrQ8uiBi5Bc9nnvuAbAJORLWb5cdsN0qukmy6Kma4jPRWKvgmCy5u1HprXUIewTcT0DVBWi+HFmdVJz1n3m2uQ7u1p/tcqR0u5NDImr5qdGXRAP+6RiO
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f45977-b732-4eea-6317-08d7716c4747
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 05:56:56.8348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rfF4f88OKAiP/16qBZNCAFxXZzJn6DKN+jXhlMe6TNhp+Yon5qlyoVkX/mbtIblN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ENETC hardware support the Credit Based Shaper(CBS) which part
of the IEEE-802.1Qav. The CBS driver was loaded by the sch_cbs
interface when set in the QOS in the kernel.

Here is an example command to set 20Mbits bandwidth in 1Gbits port
for taffic class 7:

tc qdisc add dev eth0 root handle 1: mqprio \
	   num_tc 8 map 0 1 2 3 4 5 6 7 hw 1

tc qdisc replace dev eth0 parent 1:8 cbs \
	   locredit -1470 hicredit 30 \
	   sendslope -980000 idleslope 20000 offload 1

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
changes:
v2:
- replace with div_u64() for division suggested by Jakub Kicinski.

 drivers/net/ethernet/freescale/enetc/Kconfig  |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.h  |   2 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 128 ++++++++++++++++++
 5 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/eth=
ernet/freescale/enetc/Kconfig
index 491659fe3e35..edad4ca46327 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -53,10 +53,10 @@ config FSL_ENETC_HW_TIMESTAMPING
=20
 config FSL_ENETC_QOS
 	bool "ENETC hardware Time-sensitive Network support"
-	depends on (FSL_ENETC || FSL_ENETC_VF) && NET_SCH_TAPRIO
+	depends on (FSL_ENETC || FSL_ENETC_VF) && (NET_SCH_TAPRIO || NET_SCH_CBS)
 	help
 	  There are Time-Sensitive Network(TSN) capabilities(802.1Qbv/802.1Qci
 	  /802.1Qbu etc.) supported by ENETC. These TSN capabilities can be set
 	  enable/disable from user space via Qos commands(tc). In the kernel
 	  side, it can be loaded by Qos driver. Currently, it is only support
-	  taprio(802.1Qbv).
+	  taprio(802.1Qbv) and Credit Based Shaper(802.1Qbu).
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index 27f6fd1708f0..9db1b96ed9b9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1496,6 +1496,8 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_s=
etup_type type,
 		return enetc_setup_tc_mqprio(ndev, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return enetc_setup_tc_taprio(ndev, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return enetc_setup_tc_cbs(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/eth=
ernet/freescale/enetc/enetc.h
index 89f23156f330..7ee0da6d0015 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -255,7 +255,9 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_cb=
d *cbd);
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct net_device *ndev);
+int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(ndev) (void)0
+#define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/=
ethernet/freescale/enetc/enetc_hw.h
index 924ddb6d358a..51f543ef37a8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -185,6 +185,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSICFGR0_SIVC(bmp)	(((bmp) & 0xff) << 24) /* VLAN_TYPE */
=20
 #define ENETC_PTCCBSR0(n)	(0x1110 + (n) * 8) /* n =3D 0 to 7*/
+#define ENETC_CBSE		BIT(31)
+#define ENETC_CBS_BW_MASK	GENMASK(6, 0)
 #define ENETC_PTCCBSR1(n)	(0x1114 + (n) * 8) /* n =3D 0 to 7*/
 #define ENETC_RSSHASH_KEY_SIZE	40
 #define ENETC_PRSSK(n)		(0x1410 + (n) * 4) /* n =3D [0..9] */
@@ -603,6 +605,8 @@ struct enetc_cbd {
 	u8 status_flags;
 };
=20
+#define ENETC_CLK  400000000ULL
+
 /* port time gating control register */
 #define ENETC_QBV_PTGCR_OFFSET		0x11a00
 #define ENETC_QBV_TGE			BIT(31)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net=
/ethernet/freescale/enetc/enetc_qos.c
index 66a3da61ca16..2e99438cb1bf 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -4,6 +4,7 @@
 #include "enetc.h"
=20
 #include <net/pkt_sched.h>
+#include <linux/math64.h>
=20
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 {
@@ -170,3 +171,130 @@ int enetc_setup_tc_taprio(struct net_device *ndev, vo=
id *type_data)
=20
 	return err;
 }
+
+static u32 enetc_get_cbs_enable(struct enetc_hw *hw, u8 tc)
+{
+	return enetc_port_rd(hw, ENETC_PTCCBSR0(tc)) & ENETC_CBSE;
+}
+
+static u8 enetc_get_cbs_bw(struct enetc_hw *hw, u8 tc)
+{
+	return enetc_port_rd(hw, ENETC_PTCCBSR0(tc)) & ENETC_CBS_BW_MASK;
+}
+
+int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	struct tc_cbs_qopt_offload *cbs =3D type_data;
+	u32 port_transmit_rate =3D priv->speed;
+	u8 tc_nums =3D netdev_get_num_tc(ndev);
+	struct enetc_si *si =3D priv->si;
+	u32 hi_credit_bit, hi_credit_reg;
+	u32 max_interference_size;
+	u32 port_frame_max_size;
+	u32 tc_max_sized_frame;
+	u8 tc =3D cbs->queue;
+	u8 prio_top, prio_next;
+	int bw_sum =3D 0;
+	u8 bw;
+
+	prio_top =3D netdev_get_prio_tc_map(ndev, tc_nums - 1);
+	prio_next =3D netdev_get_prio_tc_map(ndev, tc_nums - 2);
+
+	/* Support highest prio and second prio tc in cbs mode */
+	if (tc !=3D prio_top && tc !=3D prio_next)
+		return -EOPNOTSUPP;
+
+	if (!cbs->enable) {
+		/* Make sure the other TC that are numerically
+		 * lower than this TC have been disabled.
+		 */
+		if (tc =3D=3D prio_top &&
+		    enetc_get_cbs_enable(&si->hw, prio_next)) {
+			dev_err(&ndev->dev,
+				"Disable TC%d before disable TC%d\n",
+				prio_next, tc);
+			return -EINVAL;
+		}
+
+		enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), 0);
+		enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), 0);
+
+		return 0;
+	}
+
+	if (cbs->idleslope - cbs->sendslope !=3D port_transmit_rate * 1000L ||
+	    cbs->idleslope < 0 || cbs->sendslope > 0)
+		return -EOPNOTSUPP;
+
+	port_frame_max_size =3D ndev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	bw =3D cbs->idleslope / (port_transmit_rate * 10UL);
+
+	/* Make sure the other TC that are numerically
+	 * higher than this TC have been enabled.
+	 */
+	if (tc =3D=3D prio_next) {
+		if (!enetc_get_cbs_enable(&si->hw, prio_top)) {
+			dev_err(&ndev->dev,
+				"Enable TC%d first before enable TC%d\n",
+				prio_top, prio_next);
+			return -EINVAL;
+		}
+		bw_sum +=3D enetc_get_cbs_bw(&si->hw, prio_top);
+	}
+
+	if (bw_sum + bw >=3D 100) {
+		dev_err(&ndev->dev,
+			"The sum of all CBS Bandwidth can't exceed 100\n");
+		return -EINVAL;
+	}
+
+	tc_max_sized_frame =3D enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
+
+	/* For top prio TC, the max_interfrence_size is maxSizedFrame.
+	 *
+	 * For next prio TC, the max_interfrence_size is calculated as below:
+	 *
+	 *      max_interference_size =3D M0 + Ma + Ra * M0 / (R0 - Ra)
+	 *
+	 *	- RA: idleSlope for AVB Class A
+	 *	- R0: port transmit rate
+	 *	- M0: maximum sized frame for the port
+	 *	- MA: maximum sized frame for AVB Class A
+	 */
+
+	if (tc =3D=3D prio_top) {
+		max_interference_size =3D port_frame_max_size * 8;
+	} else {
+		u32 m0, ma, r0, ra;
+
+		m0 =3D port_frame_max_size * 8;
+		ma =3D enetc_port_rd(&si->hw, ENETC_PTCMSDUR(prio_top)) * 8;
+		ra =3D enetc_get_cbs_bw(&si->hw, prio_top) *
+			port_transmit_rate * 10000ULL;
+		r0 =3D port_transmit_rate * 1000000ULL;
+		max_interference_size =3D m0 + ma +
+			(u32)div_u64((u64)ra * m0, r0 - ra);
+	}
+
+	/* hiCredit bits calculate by:
+	 *
+	 * maxSizedFrame * (idleSlope/portTxRate)
+	 */
+	hi_credit_bit =3D max_interference_size * bw / 100;
+
+	/* hiCredit bits to hiCredit register need to calculated as:
+	 *
+	 * (enetClockFrequency / portTransmitRate) * 100
+	 */
+	hi_credit_reg =3D (u32)div_u64((ENETC_CLK * 100ULL) * hi_credit_bit,
+				     port_transmit_rate * 1000000ULL);
+
+	enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
+
+	/* Set bw register and enable this traffic class */
+	enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
+
+	return 0;
+}
--=20
2.17.1

