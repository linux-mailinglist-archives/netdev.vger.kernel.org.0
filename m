Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8867EB828
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbfJaTzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:55:40 -0400
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:24827
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727044AbfJaTzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 15:55:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa0St3iGsSVCRJy5+Nq7dLSyc3uV05r/hXp1j9gew4NkbvaIJoPd85ntr3ZPLhwXcd96t6qwW2CJ3joqCDpM406+SDXP/CXlhDr2mtY8Cn0/nK7qVvHdQXuesN73+1FTz5hR16giJt/qUiyKegSSVduKB9guERP+HQvhId2Y1mFtiOD9DY72bvqqe+Zh/X4tXYKO+LadQ7TAFHPLu6tFLvlyFOyAAUW88BI52xr72ZhKOPfDc2LBmyGKxQxYvTFYENUqHX/IpociAyan6wkHOimtgRAQRcfNF/ijMjs7FTy0PxVHAuOg/8DoAtiY9nMOl8lHBITXZNkqKgylYpOaeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+p3+LHk1NmGmtoMKBqilysfaK34O9xeb4Mo61tT3D8=;
 b=oQXyhmpsi2bxyTWNSPZJDjMk+lN6SZzxe/o6lVdK+l3cUcvbImH8AhlIowMlMo9nz6zrgO5+e6MAr/BnwfqrWPZawmoVBZL9AUYn7wKGE3HicL1Ab54dmQ5ulOC+OJDzPjS/igEesFtQfXWz8CXjrHf9ysdhRaHVe/15IdP55pspJ6W9JIqENKwPUBg6i05cIpAYHEc6fk1CSPBflWH/HFARiX5uD+xZgC1JocR/ZIv91uMb793Jm3TUtRLa4HCpm/qfJrEDpEcg9LRsUCQQIWW2qOvBv1hnO4+2qxKL26E3XN4pAq+GVhV7/aUUcduFkQFd+5BElZYqpq8SO3AdoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+p3+LHk1NmGmtoMKBqilysfaK34O9xeb4Mo61tT3D8=;
 b=dvgTqS6MSi4aYlWPgLiaoiHFXmJ6PMdC6+fKQQgJBvG4GpHaSge1oYHA8/qNovs3ZerBryuve1y6I/mRvgHDkWbnDLS5fSwCP9UAf5S30S7k5vuDLaDIdevE6jlmOwilyjelBQJ04zoEbvmoadZHWrrfSuUmTmRomAb3bnlYOh0=
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com (10.170.245.27) by
 HE1PR05MB3324.eurprd05.prod.outlook.com (10.170.242.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Thu, 31 Oct 2019 19:55:33 +0000
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385]) by HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385%6]) with mapi id 15.20.2387.027; Thu, 31 Oct 2019
 19:55:33 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH iproute2-next v2 2/3] ip: Present the VF VLAN tagging mode
Thread-Topic: [PATCH iproute2-next v2 2/3] ip: Present the VF VLAN tagging
 mode
Thread-Index: AQHVkCUn7cfV8+M6+E+ETmN/S+VfTw==
Date:   Thu, 31 Oct 2019 19:55:33 +0000
Message-ID: <1572551722-9520-3-git-send-email-lariel@mellanox.com>
References: <1572551722-9520-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572551722-9520-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM3PR04CA0137.eurprd04.prod.outlook.com (2603:10a6:207::21)
 To HE1PR05MB3323.eurprd05.prod.outlook.com (2603:10a6:7:31::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c19b53b9-8b61-4397-a938-08d75e3c4a40
x-ms-traffictypediagnostic: HE1PR05MB3324:|HE1PR05MB3324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB33247200AE421CA787D4D450BA630@HE1PR05MB3324.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(189003)(199004)(76176011)(71190400001)(305945005)(186003)(66556008)(6512007)(7736002)(66476007)(66446008)(66946007)(3846002)(52116002)(14454004)(6486002)(6116002)(64756008)(316002)(4720700003)(26005)(5640700003)(71200400001)(2906002)(54906003)(256004)(14444005)(66066001)(6436002)(6506007)(86362001)(2501003)(99286004)(11346002)(486006)(5660300002)(8936002)(107886003)(386003)(446003)(1730700003)(36756003)(476003)(8676002)(2616005)(2351001)(81156014)(81166006)(478600001)(50226002)(6916009)(102836004)(25786009)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3324;H:HE1PR05MB3323.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TqupOlVmQf+zvkE9cVX/NTRSBtbW7wTkoyFlBvAOvm234SxuW8mcgHtQE4WyB3yhIO6sucJ0YYGFj+LyjYRA6s/PZAv+Sz45UOhg2mWQcdCvD1PY4P6ZLtilFb+/q7MqdKDJ9b3nnR/lgDlZGY3YQp1syJdbEDD6k56n72taJPF4VnYMzRBX/b4ERMwEgD2lnWehtSTfonOG3wbclGIonkPoPeem+irLcj0Ng3Lz0t/f853bK/tJJpUjmXmFwUe0+M8PhYXkfFBbrvKk0TviDDObazdUdJaRtYJCZ2B3QSP55MWNWqmfyJ3Nrl5egKmpAbeRuxEz2GOm0J6k14qqSUJW25iWzHolFbyWZO7P6Wzq5aQK6L4fx0DSuvdpHf3JnvyENSvnTnda7nvzlw7dhj6G8JyVzPKKY8mbswIeGTnwbKzmVM61pd8xEq1PCwmh
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19b53b9-8b61-4397-a938-08d75e3c4a40
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 19:55:33.5363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XD/Kj9t0C6Bt0cu8jLP+xsgdDPpBsJ5tw0EMvbjquSRXLrtKNyxPZTcN+Nh6vmiHtr3mF+mhYZpEXquf/auQdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The change prints the VLAN tagging mode per VF on
link query.

The possible modes are:
1) VGT - Virtual Guest tagging mode.
2) VST - Virtual Switch tagging mode.
3) Trunk - Guest tagging mode with specific allowed VLAN access list.

For the full VLAN ids list in Trunk mode, it is required to
query the specific VF.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
---
 include/uapi/linux/if_link.h | 14 ++++++++++++++
 ip/ipaddress.c               | 18 +++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d39017b..6304add 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -697,6 +697,7 @@ enum {
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
 	IFLA_VF_BROADCAST,	/* VF broadcast */
+	IFLA_VF_VLAN_MODE,	/* vlan tagging mode */
 	__IFLA_VF_MAX,
 };
=20
@@ -711,6 +712,19 @@ struct ifla_vf_broadcast {
 	__u8 broadcast[32];
 };
=20
+enum {
+	IFLA_VF_VLAN_MODE_UNSPEC,
+	IFLA_VF_VLAN_MODE_VGT,
+	IFLA_VF_VLAN_MODE_VST,
+	IFLA_VF_VLAN_MODE_TRUNK,
+	__IFLA_VF_VLAN_MODE_MAX,
+};
+
+struct ifla_vf_vlan_mode {
+	__u32 vf;
+	__u32 mode; /* The VLAN tagging mode */
+};
+
 struct ifla_vf_vlan {
 	__u32 vf;
 	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 0521fdc..9c04cee 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -351,13 +351,19 @@ static void print_af_spec(FILE *fp, struct rtattr *af=
_spec_attr)
=20
 static void print_vf_stats64(FILE *fp, struct rtattr *vfstats);
=20
+static const char *vlan_modes[] =3D {
+	[IFLA_VF_VLAN_MODE_UNSPEC] =3D "n/a",
+	[IFLA_VF_VLAN_MODE_VGT] =3D "vgt",
+	[IFLA_VF_VLAN_MODE_VST] =3D "vst",
+	[IFLA_VF_VLAN_MODE_TRUNK] =3D "trunk",
+};
+
 static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *v=
finfo)
 {
 	struct ifla_vf_mac *vf_mac;
 	struct ifla_vf_broadcast *vf_broadcast;
 	struct ifla_vf_tx_rate *vf_tx_rate;
 	struct rtattr *vf[IFLA_VF_MAX + 1] =3D {};
-
 	SPRINT_BUF(b1);
=20
 	if (vfinfo->rta_type !=3D IFLA_VF_INFO) {
@@ -404,6 +410,16 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *i=
fi, struct rtattr *vfinfo)
 					       b1, sizeof(b1)));
 	}
=20
+	if (vf[IFLA_VF_VLAN_MODE]) {
+		struct ifla_vf_vlan_mode *vlan_mode =3D RTA_DATA(vf[IFLA_VF_VLAN_MODE]);
+
+		if (vlan_mode->mode >=3D ARRAY_SIZE(vlan_modes))
+			print_int(PRINT_ANY, "vlan_mode", ", vlan_mode %d ", vlan_mode->mode);
+		else
+			print_string(PRINT_ANY, "vlan_mode", ", vlan_mode %s",
+			     	     vlan_modes[vlan_mode->mode]);
+	}
+
 	if (vf[IFLA_VF_VLAN_LIST]) {
 		struct rtattr *i, *vfvlanlist =3D vf[IFLA_VF_VLAN_LIST];
 		int rem =3D RTA_PAYLOAD(vfvlanlist);
--=20
1.8.3.1

