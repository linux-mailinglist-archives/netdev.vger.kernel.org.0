Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A18BEA3F2
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfJ3TRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:17:39 -0400
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:46756
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbfJ3TRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 15:17:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDI3IH9RBLlnPOQNSIkiEw2C00bvmRZYByL387qo7O47MTX5ujNGGfAJufOD9my40IilKMonUf0+tKTvKGrCfTEh3+Surmnj7W8KpEn9aXCugDw75Cc3vj6c8RFecYuNLskAqVCiToP0HHItimzY5M9GyhSjxi4zp7y+g8ERGUuO+PScIMV+4/COEw8bIK/Abz1ji8G+azeiH9+3ZY56Ph6CZ+ZFMz0mz31YLxC2qKQAMUXN4uWbMboUvZDOsMgrFVDRDlKhiSuW9u7xGu7M7oyaccW0DmLLUjew8bQJdqDloHz5jYQiJWBT8c6oh1fdqeHr4OvS5w+lyImurvLkrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgmXPTzgM0DWUIPmo6jRs/kZTohE+JmCR0SBw5nbglQ=;
 b=VcBmyc7/P1ET+dyh5Q+8Z1u3Dy9vdC0FRleiCmCtGW8NgTZUqX/jkPQB2KDsb+DthNTY4dGE6CZGn8vyVAMS/zc/rI/VZn5lEiAnqVUVx4+TdHeJfCGcJhoV6HI/QkYEhtLdLET43MESHYt1V6Gg4n7mS0WAl6++VTmhrWP9P2K49eqLT0VVD0olbA+yHmTCkvTVQUBd6QpUkpnyfFZx6DlJfjOIfeKikGy9Q4Rc0t461s7+7SgX6vsg1JfnLgBcSqkQaWPrUlNNWr+CA2g1aHR3lpX/waH6xBBg2fOs2DJD/eWVgKFlXnpUsOP2xl3MZE97Ds9J6oZuNNqdFPzOIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgmXPTzgM0DWUIPmo6jRs/kZTohE+JmCR0SBw5nbglQ=;
 b=TNr83A/hcRfs3EwES8AEEL+s0OUrry17pQ/fl8vswNI5nFyGEJkKvU/AcTYXQS+tvuAxUi33Pl1oXgBu1tkK8zjzGvT6LmfNaBVV3O2G/37HpLAkm7jsLPaHUXvatmIkvIi5E0BMCzYk6NfAd7/5qIWPBdfC8vNxjK4qVxeIvVM=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3412.eurprd05.prod.outlook.com (10.171.188.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Wed, 30 Oct 2019 19:17:32 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 19:17:32 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH 2/3] ip: Present the VF VLAN tagging mode
Thread-Topic: [PATCH 2/3] ip: Present the VF VLAN tagging mode
Thread-Index: AQHVj1atGKLK/HH3t0eZWB1MYBrmoA==
Date:   Wed, 30 Oct 2019 19:17:32 +0000
Message-ID: <1572463033-26368-3-git-send-email-lariel@mellanox.com>
References: <1572463033-26368-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572463033-26368-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR02CA0072.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::49) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a0d917fd-6c8e-41a9-4893-08d75d6dd011
x-ms-traffictypediagnostic: AM4PR05MB3412:|AM4PR05MB3412:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3412F4BD2E1C5396D8142828BA600@AM4PR05MB3412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(476003)(486006)(66946007)(66446008)(14444005)(66476007)(2616005)(6116002)(11346002)(3846002)(2906002)(71190400001)(66556008)(71200400001)(446003)(5660300002)(4720700003)(64756008)(256004)(8676002)(66066001)(86362001)(2501003)(81156014)(8936002)(478600001)(76176011)(102836004)(6486002)(26005)(50226002)(6506007)(386003)(6436002)(52116002)(7736002)(5640700003)(186003)(1730700003)(81166006)(305945005)(25786009)(54906003)(6916009)(316002)(14454004)(4326008)(107886003)(99286004)(2351001)(6512007)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3412;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l23SoR09IHt+yB+a/H5D3vF9IxZ49Ff/otDAfE3nyxH5rR/I2KCgK3DAf75Eba3KXHqKAdDkptemCOjVptCloyb0tEH4wN7XQ7QcM34WKNvZXkjoxvmk73GikDJjhGHeDIwszJAE/0xNYmX1Mm2pjcnO1z3261UDo82K8grC4/VMBEiqOCzGQp1GtlRu4C2ne+Kt+DgQiKahn7vc2LCVyvzx3TEvGwnHWO9s64fkyOpcXBzrx2LRFGSC97iT8L5/CQ3SqN6xrFkzZZsS1Ejtz7cOh5enkKVE0UV1RiYX1DtwO5Sodpvo5IiyyFdfPOeOUENsE5qUvyCi2NOrsTFCfgccpd+z2CiiY6GNZmeN0cRk+fbMOPEai2l1N+3f9IlWaRROVq6DNJ6fQOGtfalbatzytWejbOMlRE43h0g0IxXpSqVukJWF43tI1vU6NIeZ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d917fd-6c8e-41a9-4893-08d75d6dd011
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 19:17:32.1305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ujXk57dRZBmXbBmxgxznZAI4VFVHaodOARKxQRNtRHy8JcwrtHsJTP+/wO5R2kJ2Voeffd09ZI87jaP9FhzBlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3412
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
 ip/ipaddress.c               | 21 ++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

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
index 0521fdc..a66ca02 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -357,7 +357,6 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *if=
i, struct rtattr *vfinfo)
 	struct ifla_vf_broadcast *vf_broadcast;
 	struct ifla_vf_tx_rate *vf_tx_rate;
 	struct rtattr *vf[IFLA_VF_MAX + 1] =3D {};
-
 	SPRINT_BUF(b1);
=20
 	if (vfinfo->rta_type !=3D IFLA_VF_INFO) {
@@ -404,6 +403,26 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *i=
fi, struct rtattr *vfinfo)
 					       b1, sizeof(b1)));
 	}
=20
+	if (vf[IFLA_VF_VLAN_MODE]) {
+		struct ifla_vf_vlan_mode *vlan_mode =3D RTA_DATA(vf[IFLA_VF_VLAN_MODE]);
+
+		if (vlan_mode->mode =3D=3D IFLA_VF_VLAN_MODE_TRUNK)
+			print_string(PRINT_ANY,
+				     "vlan-mode",
+				      ", vlan-mode %s",
+				      "trunk");
+		else if (vlan_mode->mode =3D=3D IFLA_VF_VLAN_MODE_VST)
+			print_string(PRINT_ANY,
+				     "vlan-mode",
+				     ", vlan_mode %s",
+				     "vst");
+		else if (vlan_mode->mode =3D=3D IFLA_VF_VLAN_MODE_VGT)
+			print_string(PRINT_ANY,
+				     "vlan-mode",
+				     ", vlan-mode %s",
+				     "vgt");
+	}
+
 	if (vf[IFLA_VF_VLAN_LIST]) {
 		struct rtattr *i, *vfvlanlist =3D vf[IFLA_VF_VLAN_LIST];
 		int rem =3D RTA_PAYLOAD(vfvlanlist);
--=20
1.8.3.1

