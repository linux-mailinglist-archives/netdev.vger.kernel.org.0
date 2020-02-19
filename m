Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5915A163B14
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgBSDX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:28 -0500
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:43238
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726766AbgBSDX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHR484iN65L9ZeyxxtyJp7xkzA90atAfnOKvSITLpdR8kwAD6+1Th9TVSVXrOQYS49qvvBlvA/77yQ3ldkyBm4+DPAXAlGB3NKWCynDv+2CWp3LbIlL4DtWuec/O1C0kcgVqU375/9kBSx77vWqVgsGjyhS4vC1//R2Hll/ncDNM4x0D33jG5V/gaMXCN8f+TQCGpVCMzRfc1CbLnggA6TyE9idyjK1lWcQY5JeeMSU95JBog7R8nZfy5cPQWn4/RYkznNiZBusM2/cV5+JHrASMGLAtV6gVXYfumqrvl/69D/WDdFcGV+GkOiZlMt/Tdnb++l2PuU+q7tt1weTsTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpHOCo3LvYlrruwUU2a2YVWASxjLX6K9oM8DKgJwdLM=;
 b=Y20cG67H285LnITXY6NM2NFZInC1o0pzlthkFbJvo/Yn9KtjuYRO0Cdy0ZMoFIBxiYYHf9G7eC1ThtCWiz7FKOP7LfCT6bphCC0saXJL26TM9sspJC1ZTj7pbS/+h4ta/0CbR4L4XrImc6ko+Yqe8IZhIEPu6/7uifUyU92GlSOJT8qbob/XJXMGeYEWNl86LkJVUKxjR1EUmtEeyozZttghvdtzTXEBEbrxkgoSyQ17QnodyvhW09iNpULQQ9uz6cHXFjaQjWDidIGnk1xha5W4f8om9lfg5ukeNBesOYHGCxajVGGzgZuyXTFIn5NOhU6cRc3rnxD4FPqHWwVP0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpHOCo3LvYlrruwUU2a2YVWASxjLX6K9oM8DKgJwdLM=;
 b=GJpbIeXenjnQiBW9I1vRHIJ18xA0JhsRSsdRN2Gf2ZtwmdyhXa/JxoU8BmjltaMG2medT0hA83UPUqHdtkBmeLgZCgzkR/Ub+NoMSN66RkDkT1LgBAbtvpqZ+kH57/IrZUppuUayHBg/ShdDAFH2R6araf9FRM5q+CCImLSNuuQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5791.eurprd05.prod.outlook.com (20.178.122.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Wed, 19 Feb 2020 03:23:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:23 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 11/13] ethtool: Add support for low latency RS FEC
Thread-Topic: [net-next V4 11/13] ethtool: Add support for low latency RS FEC
Thread-Index: AQHV5tPwbyhbFLDxEEi9FsbDxs6HTw==
Date:   Wed, 19 Feb 2020 03:23:22 +0000
Message-ID: <20200219032205.15264-12-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9f4bc66c-d270-49d3-1569-08d7b4eb130b
x-ms-traffictypediagnostic: VI1PR05MB5791:|VI1PR05MB5791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5791C983637E2E012FBACF9ABE100@VI1PR05MB5791.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(189003)(199004)(110136005)(54906003)(1076003)(186003)(8676002)(16526019)(316002)(66946007)(52116002)(6506007)(5660300002)(36756003)(66446008)(64756008)(66556008)(66476007)(81166006)(8936002)(86362001)(81156014)(71200400001)(4326008)(19627235002)(2906002)(26005)(107886003)(6486002)(478600001)(6512007)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5791;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nelcL3akOXwD3g72DRrWhhvltjI47hcVjb9UIvCVEb1yMWyKgltpc+blm20MhNp0JtZyCLpzIgjH3hqm+nuwRhggWCSTRATsnAMuhkC1tO8iPD5WMUCuTFIh8hcxN/BArfee1kLMzk7S8NHgAQrJAr3p0CN7oXUv7NjRn2wGv85T0jFYK2XQoMr3KgH6TBeDXc1LsTdcQccbbX64L41Jl/hLHvVduQfTtRCIcdRLP+DJ0dkvf1WY+H2oBAT7CublUFjjNcz6E2kOAAWitMYUXlGi81c8MH7T3H71MwkmmjHHFpQWOk83TBzFFJIdzPAdlqiaUwTD+VCOtMbBA/7RLWJgizQ1fWEE7fEOgb5j02LAWAhtwu+dT5FetBUou4m3XQ3qRA5oiE5+ubu7izDS/lKyi4ovxs9y01vWA6prkxZccALIhNT6aN6tNNtfCNh5N8BgSoDctY+NqujefNiAyiHLvn34ijTkBcwnKtDb20EZeGtXWTjC8+EDZv6Gqds6/dIc/hwtgGOMviAS7gr+1vk9r9WwCB4t3QJsCLgTUjA=
x-ms-exchange-antispam-messagedata: mtYPcQBbmDFeZydjCjb9cRW4Z7tDn6QXcOzW9uqKE6lD2RBZ5vG2gCFIFD+CjRkuOsnHOFiJYkwC+9dOR3GT9Bq0DD3dL7FJvHGPZAK0bJk5rzHgp8GtycGAZse6KbedLCbXBURHhrTYIKBkZq6QiQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4bc66c-d270-49d3-1569-08d7b4eb130b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:22.9630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MmakxOEUsRE+28VHdazv/RSXZd4Fn9YGNpcJsnTWI35upcsRFYLBi9Y1BdnZVxqGr5XRURlqhgR80W/EOyaYkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for low latency Reed Solomon FEC as LLRS.

The LL-FEC is defined by the 25G/50G ethernet consortium,
in the document titled "Low Latency Reed Solomon Forward Error Correction"

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
CC: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy-core.c   | 2 +-
 include/uapi/linux/ethtool.h | 4 +++-
 net/ethtool/common.c         | 1 +
 net/ethtool/linkmodes.c      | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index a4d2d59fceca..e083e7a76ada 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
=20
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 74,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 75,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 4295ebfa2f91..d586ee5e10a1 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1330,6 +1330,7 @@ enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_OFF_BIT,
 	ETHTOOL_FEC_RS_BIT,
 	ETHTOOL_FEC_BASER_BIT,
+	ETHTOOL_FEC_LLRS_BIT,
 };
=20
 #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
@@ -1337,6 +1338,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
 #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
 #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
+#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
=20
 /* CMDs currently supported */
 #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
@@ -1521,7 +1523,7 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT =3D 71,
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 =3D 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 =3D 73,
-
+	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 =3D 74,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 636ec6d5110e..7b6969af5ae7 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -168,6 +168,7 @@ const char link_mode_names[][ETH_GSTRING_LEN] =3D {
 	__DEFINE_LINK_MODE_NAME(400000, LR8_ER8_FR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, DR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, CR8, Full),
+	__DEFINE_SPECIAL_MODE_NAME(FEC_LLRS, "LLRS"),
 };
 static_assert(ARRAY_SIZE(link_mode_names) =3D=3D __ETHTOOL_LINK_MODE_MASK_=
NBITS);
=20
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 96f20be64553..f049b97072fe 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -237,6 +237,7 @@ static const struct link_mode_info link_mode_params[] =
=3D {
 	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
 };
=20
 static const struct nla_policy
--=20
2.24.1

