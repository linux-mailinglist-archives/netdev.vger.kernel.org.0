Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE27210AD08
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfK0J65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:58:57 -0500
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:31820
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfK0J65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:58:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEFAxHW9kywDnmmC/U2U53i8MMWh+02WkVLX6dkcy8p43Akd2LA9Sr73pfdN6z858hvc9YvuwdHLc7yVhSu1gXIDHqUscO3zT/P8HXgw+fLWTYkTvuNQLhenxnMPhXqakmP+bZe1CngZE15lJLX/Fu3ccmNZl3rlzMOEz2r6zkLn8JiOCuBm7GcScrKkTlElJ9xoSN+8CKSk+t2JMpC5sGX5SWyTtlSZDHt5re8loqrVoByHPbFRCLu4AXobbmylte1ikdRqgw1pOqZDpWzC9WqHgPQPiNt+G81IunOahdFxllQOuOfv6GoOraEq09dmIJETfT2LnrzjjDw367HgJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YU+9E8WtVWYm+66Xvraclj7KT8TV2cdIzndd3kbMKE=;
 b=DQri6tM5jI+Lpa45SIy5LKY2heqnUbjxss1dkS522ePINYkSzdymoUCrp4znf5Gpif5WlsEQy+kWY1R5Z37Gnp54WnoJTy4G1aR3MwpwTBaND8voSvgu1iiPR3SuDY3KfkEYVYe5ckbr0ryOYUfvZCeITf+fU7EDgPFEnQ9PrsD1qoTr8Z1jHIGu99ieG0ozxuyQWsMpBV5PdMxn/AhcNVezwY4Vq35QeWDI4AaNONJB3REuv8lkH2tVvjKNaqP6VnwG+rwq5gnnZEZGP/zukAmBgzHkZ/DX1WVoDHjjJa/fklLz8GkFKiXQGKpRdqILtEUz592sd4erDEhiNL9gbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YU+9E8WtVWYm+66Xvraclj7KT8TV2cdIzndd3kbMKE=;
 b=nLFxoOPuVgUQris2Ib++eRWfJQy52IaS/SKpStWSISY5ojdvBK5I0jPq4J4YgEny42MeK3YXpLs68rNgLcv1WvfPbagu2IVJBOueXRVZK64ldNHHUjOEJD4YZii5JA0zsyS2vRpvgBAXuusE8dhc46ofiflwZ4P5Gv8V3VoINXE=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6768.eurprd04.prod.outlook.com (10.255.118.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 27 Nov 2019 09:58:53 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 09:58:53 +0000
From:   Po Liu <po.liu@nxp.com>
To:     "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "netdev-owner@vger.kernel.org" <netdev-owner@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [v1,ethtool] ethtool: add setting frame preemption of traffic classes
Thread-Topic: [v1,ethtool] ethtool: add setting frame preemption of traffic
 classes
Thread-Index: AQHVpQlG0mLACJAUKU+wtr9rXyf5og==
Date:   Wed, 27 Nov 2019 09:58:52 +0000
Message-ID: <20191127094448.6206-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN4PR0501CA0129.namprd05.prod.outlook.com
 (2603:10b6:803:42::46) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 59e7fb93-2c1e-46bd-2b27-08d773206877
x-ms-traffictypediagnostic: VE1PR04MB6768:|VE1PR04MB6768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6768094E20046A6FD22AC85392440@VE1PR04MB6768.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(189003)(199004)(66946007)(66446008)(66556008)(6436002)(8936002)(50226002)(25786009)(71200400001)(66476007)(86362001)(64756008)(6116002)(3846002)(305945005)(14454004)(7736002)(36756003)(81156014)(5660300002)(478600001)(66066001)(2501003)(1076003)(2906002)(4326008)(6486002)(8676002)(14444005)(256004)(71190400001)(2616005)(186003)(54906003)(99286004)(110136005)(6506007)(2201001)(26005)(6512007)(81166006)(102836004)(52116002)(386003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6768;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aa3q2uLBVi4YSSUSChZzyVwE3zRSc7yYcZpJZrXeO4Dyg5C/zN3qdzJY+heMHLamWlKNqmbJARiH6C+LoQoR3wncvDMFp8wIbcwBFHAC7uR2SYnz5xMS6JVwMO6KXibSupNLUSxZImqYecLBfAfOvAcrVKctZ3BQ7k3NEcJrKAQ2oUDhh+i15Mw5EU66JNm+LHKTYkyE38cJsVGR7UUWCznkKBDMZHCqR+KOHOyva9m18ucFw/2xAx47EZmB5SJcGcejhB7SBSq8Hbyl6hK7nGG+WCaThzUdOW5g+Bbt046hsVtbluvAXqZYfkFy0i19JfaCOIZ8HWvrP9aoQ9M1qFjvxjvEdd2jAYV/o3xsG3zE/ghFJuvcc7bPHdXt2hEZ5sI+PgoNtXshaMWc0AqsoV6wcZg2Mt1N9BtAipkezB7K8GXrCvloU9wWFCEJkpcs
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e7fb93-2c1e-46bd-2b27-08d773206877
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 09:58:52.9280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1zIqxSnjOY9JMh5ZHu6V1Q+MkD+PYYsLPusXxzA7RxwUU+AwH0hc0dCE6b77q4Y4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE Std 802.1Qbu standard defined the frame preemption of port
trffic classes. User can set a value to hardware. The value will
be translated to a binary, each bit represent a traffic class.
Bit "1" means preemptable traffic class. Bit "0" means express
traffic class.  MSB represent high number traffic class.

ethtool -k devname

This command would show if the tx-preemption feature is available.
If hareware set preemption feature. The property would be a fixed
value 'on' if hardware support the frame preemption. Feature would
show a fixed value 'off' if hardware don't support the frame preemption.

ethtool devname

This command would show include an item 'preemption'. A following
value '0' means all traffic classes are 'express'. A value none zero
means traffic classes preemption capabilities. The value will be
translated to a binary, each bit represent a traffic class. Bit '1'
means preemptable traffic class. Bit '0' means express traffic class.
MSB represent high number traffic class.

ethtool -s devname preemption N

This command would set which traffic classes are frame preemptable.
The value will be translated to a binary, each bit represent a
traffic class. Bit '1' means preemptable traffic class. Bit '0'
means express traffic class. MSB represent high number traffic class.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 ethtool-copy.h |  6 +++++-
 ethtool.8.in   |  8 ++++++++
 ethtool.c      | 18 ++++++++++++++++++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/ethtool-copy.h b/ethtool-copy.h
index 9afd2e6..e04bdf3 100644
--- a/ethtool-copy.h
+++ b/ethtool-copy.h
@@ -1662,6 +1662,9 @@ static __inline__ int ethtool_validate_duplex(__u8 du=
plex)
 #define AUTONEG_DISABLE		0x00
 #define AUTONEG_ENABLE		0x01
=20
+/* Disable preemtion. */
+#define PREEMPTION_DISABLE	0x0
+
 /* MDI or MDI-X status/control - if MDI/MDI_X/AUTO is set then
  * the driver is required to renegotiate link
  */
@@ -1878,7 +1881,8 @@ struct ethtool_link_settings {
 	__s8	link_mode_masks_nwords;
 	__u8	transceiver;
 	__u8	reserved1[3];
-	__u32	reserved[7];
+	__u32	preemption;
+	__u32	reserved[6];
 	__u32	link_mode_masks[0];
 	/* layout of link_mode_masks fields:
 	 * __u32 map_supported[link_mode_masks_nwords];
diff --git a/ethtool.8.in b/ethtool.8.in
index 062695a..7d612b2 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -236,6 +236,7 @@ ethtool \- query or control network driver and hardware=
 settings
 .B2 autoneg on off
 .BN advertise
 .BN phyad
+.BN preemption
 .B2 xcvr internal external
 .RB [ wol \ \*(WO]
 .RB [ sopass \ \*(MA]
@@ -703,6 +704,13 @@ lB	l	lB.
 .BI phyad \ N
 PHY address.
 .TP
+.BI preemption \ N
+Set preemptable traffic classes by bits.
+.B A
+value will be translated to a binary, each bit represent a traffic class.
+Bit "1" means preemptable traffic class. Bit "0" means express traffic cla=
ss.
+MSB represent high number traffic class.
+.TP
 .A2 xcvr internal external
 Selects transceiver type. Currently only internal and external can be
 specified, in the future further types might be added.
diff --git a/ethtool.c b/ethtool.c
index acf183d..d5240f8 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -928,6 +928,12 @@ dump_link_usettings(const struct ethtool_link_usetting=
s *link_usettings)
 		}
 	}
=20
+	if (link_usettings->base.preemption =3D=3D PREEMPTION_DISABLE)
+		fprintf(stdout, "	Preemption: 0x0 (off)\n");
+	else
+		fprintf(stdout, "	Preemption: 0x%x\n",
+			link_usettings->base.preemption);
+
 	return 0;
 }
=20
@@ -2869,6 +2875,7 @@ static int do_sset(struct cmd_context *ctx)
 	int port_wanted =3D -1;
 	int mdix_wanted =3D -1;
 	int autoneg_wanted =3D -1;
+	int preemption_wanted =3D -1;
 	int phyad_wanted =3D -1;
 	int xcvr_wanted =3D -1;
 	u32 *full_advertising_wanted =3D NULL;
@@ -2957,6 +2964,12 @@ static int do_sset(struct cmd_context *ctx)
 			} else {
 				exit_bad_args();
 			}
+		} else if (!strcmp(argp[i], "preemption")) {
+			gset_changed =3D 1;
+			i +=3D 1;
+			if (i >=3D argc)
+				exit_bad_args();
+			preemption_wanted =3D get_u32(argp[i], 16);
 		} else if (!strcmp(argp[i], "advertise")) {
 			gset_changed =3D 1;
 			i +=3D 1;
@@ -3094,6 +3107,9 @@ static int do_sset(struct cmd_context *ctx)
 			}
 			if (autoneg_wanted !=3D -1)
 				link_usettings->base.autoneg =3D autoneg_wanted;
+			if (preemption_wanted !=3D -1)
+				link_usettings->base.preemption
+					=3D preemption_wanted;
 			if (phyad_wanted !=3D -1)
 				link_usettings->base.phy_address =3D phyad_wanted;
 			if (xcvr_wanted !=3D -1)
@@ -3186,6 +3202,8 @@ static int do_sset(struct cmd_context *ctx)
 				fprintf(stderr, "  not setting transceiver\n");
 			if (mdix_wanted !=3D -1)
 				fprintf(stderr, "  not setting mdix\n");
+			if (preemption_wanted !=3D -1)
+				fprintf(stderr, "  not setting preemption\n");
 		}
 	}
=20
--=20
2.17.1

