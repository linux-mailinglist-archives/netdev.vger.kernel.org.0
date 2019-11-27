Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B0E10AD0E
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfK0J71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:59:27 -0500
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:49425
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfK0J7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:59:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkLXCxEmxuBpbOp0NsyWSDCGFyLbfvQ82UqmQCgtp+1i6GPeG/ZkPcxbUkIc70CAufnRFX7kuTb091r0x6SaC/07XcG5THZgR5Y8WwfAXduP4yYk41vvuo3zB/Ga7016YmD7QqLUIh48q7MDIAp/uwmezftip/7H67tUesVj0Cn5iFKwMOkUXuUCCa6Xztv8Ie4tGmMZzuURXIuQfLwwMjRr2J6tgj72Om8X70nXVASrUuzp3hUn1pYwNSHFQVdzci6bhYzN6F7y3OB3g1sl8eLhFzDpFf6Ggi67jV2js1ccMGBW8KiVzd5AZ9sfDfTWo1GCE8hPS7si6vsH2W0Zzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax5ip0Gz4qRVYMqCZAKlk80Bibi5TSi8tmYrudU2ZlQ=;
 b=EOMl5Z5ttI3mWiY0SgUzjADZn+Nw2uh6Z5A4yojqZSU7it8ZSmpX/WNRdjDpF5jA1kYvEA1uomc9yWNnB34x6fbfJdcW+2DszSNAvd8EjJEOJDWSEi80asqvNk/cb0llJFy8CKVptDcVl13u/9VRewRp772p51VcwqdYye1ySkF6LlvWOlPXfnGHcFUxWjAQF8BgGom2tzRQ/9eOkPoslyxd27CwtrnsTemw+NekhSzaRBmz4I52N4AO1Cp7YpL4/hum2KJ/Kg5Di4zQfQJmvC0f5pCZQ7u6oH3/wOpBkuzJw9KR7UebuPvW8q5zepQqmkaq2ESBHHpuy5TIJYCv1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax5ip0Gz4qRVYMqCZAKlk80Bibi5TSi8tmYrudU2ZlQ=;
 b=XXYlt58JEWCiXmBpqU1zm/hqp3SQtSnXAPgFo6Rv/0uA22F0l1KgavZ3vMKkDAdjgoyPge6dQsqLrBI5hE31J1esk1Q4v33FXTutuEZtChfITxJK6Cnx6COZeTjT0W2Ln96te5no4UvevgotkEBWWHF0oGr7Vwcs9jL75wgkGsk=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6558.eurprd04.prod.outlook.com (20.179.232.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Wed, 27 Nov 2019 09:59:19 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 09:59:19 +0000
From:   Po Liu <po.liu@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic
 classes
Thread-Topic: [v1,net-next, 1/2] ethtool: add setting frame preemption of
 traffic classes
Thread-Index: AQHVpQlV0arssjH64ECVUQFpoidQiQ==
Date:   Wed, 27 Nov 2019 09:59:18 +0000
Message-ID: <20191127094517.6255-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN4PR0601CA0003.namprd06.prod.outlook.com
 (2603:10b6:803:2f::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2160b3f7-8985-4516-1b52-08d7732077e1
x-ms-traffictypediagnostic: VE1PR04MB6558:|VE1PR04MB6558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB655843D1779B78D1B87C496792440@VE1PR04MB6558.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(6512007)(6436002)(6486002)(1076003)(102836004)(86362001)(386003)(6506007)(2501003)(5660300002)(66556008)(66946007)(66476007)(64756008)(66446008)(2616005)(2201001)(186003)(7416002)(305945005)(6116002)(3846002)(25786009)(7736002)(26005)(50226002)(8676002)(81156014)(478600001)(8936002)(2906002)(4326008)(52116002)(66066001)(14454004)(81166006)(36756003)(14444005)(110136005)(256004)(99286004)(54906003)(71200400001)(71190400001)(316002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6558;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /W2ViNLyXtcLa0rtn6lodSPQy09yXrklv1uee5xKSJ6NxKydaqhOaGJ8tw3qqfagsfxGeGTMmnaudg1INPghJALMmTSBkyJaswAVqliTM9Fxey5R+uxt0aO/dAMp+BTnctNm57lfiBuwiV1kh8Bgz6YhrX3jIrcO6NGgr36f9qYQZLITdO3LQWxby0gksOowk52vtANAEItI3+SBYajwgW2lDV+dtnkG5wQo/MT9SlAk2yuAtyrxZMXm5dVnryT+S8nyzmKQORvT7hXg65MMYkzxqdWb6R5nfnwDWtud3R3OaQTb64Virt8xlxj7dLjZsaArpCI4KsGw3qX54puHMVjqGdK87yHC0c3TEuZcnw4P5rqDm3Os3E/u8Q7ulXyErZ9d9UPFu8Ba6xttl4kzRcxvo35Q10CcSTWjhZIfxry7t5ebJYoGrTY7Yzz1qanm
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2160b3f7-8985-4516-1b52-08d7732077e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 09:59:18.8680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k7bo450X1j6zX6E6bmM3oW6JRtaPrA2wgyF6qym1gNJ0I4JzkX4Bz9iDCEyGbDRA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6558
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE Std 802.1Qbu standard defined the frame preemption of port
traffic classes. This patch introduce a method to set traffic
classes preemption. Add a parameter 'preemption' in struct
ethtool_link_settings. The value will be translated to a binary,
each bit represent a traffic class. Bit "1" means preemptable
traffic class. Bit "0" means express traffic class.  MSB represent
high number traffic class.

If hardware support the frame preemption, driver could set the
ethernet device with hw_features and features with NETIF_F_PREEMPTION
when initializing the port driver.

User can check the feature 'tx-preemption' by command 'ethtool -k
devname'. If hareware set preemption feature. The property would
be a fixed value 'on' if hardware support the frame preemption.
Feature would show a fixed value 'off' if hardware don't support
the frame preemption.

Command 'ethtool devname' and 'ethtool -s devname preemption N'
would show/set which traffic classes are frame preemptable.

Port driver would implement the frame preemption in the function
get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/linux/netdev_features.h | 5 ++++-
 include/uapi/linux/ethtool.h    | 5 ++++-
 net/core/ethtool.c              | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_feature=
s.h
index 4b19c544c59a..299750a8b414 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -80,6 +80,7 @@ enum {
=20
 	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
+	NETIF_F_HW_PREEMPTION_BIT,	/* Hardware TC frame preemption */
=20
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -150,6 +151,7 @@ enum {
 #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
 #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
+#define NETIF_F_PREEMPTION	__NETIF_F(HW_PREEMPTION)
=20
 /* Finds the next feature with the highest number of the range of start ti=
ll 0.
  */
@@ -175,7 +177,8 @@ static inline int find_next_netdev_feature(u64 feature,=
 unsigned long start)
 /* Features valid for ethtool to change */
 /* =3D all defined minus driver/device-class-related */
 #define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
-				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
+				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL | \
+				 NETIF_F_PREEMPTION)
=20
 /* remember that ((t)1 << t_BITS) is undefined in C99 */
 #define NETIF_F_ETHTOOL_BITS	((__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) | \
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index d4591792f0b4..12ffb34afbfa 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1776,6 +1776,8 @@ enum ethtool_reset_flags {
 };
 #define ETH_RESET_SHARED_SHIFT	16
=20
+/* Disable preemtion. */
+#define PREEMPTION_DISABLE     0x0
=20
 /**
  * struct ethtool_link_settings - link control and status
@@ -1886,7 +1888,8 @@ struct ethtool_link_settings {
 	__s8	link_mode_masks_nwords;
 	__u8	transceiver;
 	__u8	reserved1[3];
-	__u32	reserved[7];
+	__u32	preemption;
+	__u32	reserved[6];
 	__u32	link_mode_masks[0];
 	/* layout of link_mode_masks fields:
 	 * __u32 map_supported[link_mode_masks_nwords];
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index cd9bc67381b2..6ffcd8a602b8 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -111,6 +111,7 @@ static const char netdev_features_strings[NETDEV_FEATUR=
E_COUNT][ETH_GSTRING_LEN]
 	[NETIF_F_HW_TLS_RECORD_BIT] =3D	"tls-hw-record",
 	[NETIF_F_HW_TLS_TX_BIT] =3D	 "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT] =3D	 "tls-hw-rx-offload",
+	[NETIF_F_HW_PREEMPTION_BIT] =3D	 "tx-preemption",
 };
=20
 static const char
--=20
2.17.1

