Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B43107AC6
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfKVWmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:42:04 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:57606
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbfKVWmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:42:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0fNN9ROOTsOdvGpFdOBlwJg/ITzzjxiPEChGWo3VWlzzb0Coy7BY7pfPiLXD4wt4gnJSelgGPj3V2ezolyB0Hh+a4AI/ps2S7zu3fgvRGuI0EK5v1BcYTTaHUM7DTUsJovitWQIqHUhkHxQdqCAc3tdK7mkWeo7jiNH390EyHjtD9rTTBPiBV8u1FfEHYnS5WGuW8SZrhxM0tKP+vGpK4r5c+kX9OzJdHFZETyU1d679BZOMhr2FecZc2bi96fZYE2I8SzKef9j8m/le75EEH8t/NHJUI8pTrx6kxkXSwStuLSWS2n8v6VngzEHuNJj/exG0DstKjfCi5XSW9/NvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yp2cM5BNRPMVARXRJloCiNNGLSJPVkpzGSLG55XE2NI=;
 b=VfsnXxQv4G17Ps2wbl1ExIq1jeJ9LSppFJScnXWCm7nhA6l08ErjHHrJRBWXBI+VAQ8lXb+q/1PPCp+QRzIRG3zdi2RpSrILZC8OIs64tJMONJyulRro0zHPLbYxZg0R74BrmmsDbj2e5587PKoM96HQ13hyJByfb7x62fZCch4RHpzWxxtU/1Rkc+vwXfoaRxLzfu0m+Ji6UZ2wYhnlckzuTc9NuP+H9d3mYwDJTapVZ1dC/MTxCT5TRAAkYTSpIKYB886p73Nux8hj//gtYxqguo90u85vp/GwYDHYDnR+7p98LOJ0X4nUtObMG4pW0QAnolu+I4LQGtriHyjSrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yp2cM5BNRPMVARXRJloCiNNGLSJPVkpzGSLG55XE2NI=;
 b=SMYdd5BsdSu6IX3jk1zOXnYmjyECs0D/KC9C5yl8fLvsyy73cqI8p9FoNvUpkuyihoox8W75coJJBzgMu9lo+2eRe4iuDQoTPp0HYVC3UABvAdkTH4AzU7qVnvp5z9aCU3e+Xc859hb2BVf+lLX50SBvYbZO9P9v3PsBJ9kzOUs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6718.eurprd05.prod.outlook.com (10.186.162.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 22:41:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 22:41:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH V2 net-next 3/6] net/mlxfw: Improve FSM err message reporting
 and return codes
Thread-Topic: [PATCH V2 net-next 3/6] net/mlxfw: Improve FSM err message
 reporting and return codes
Thread-Index: AQHVoYYHtDjA+td0wka9J4buZSVBFw==
Date:   Fri, 22 Nov 2019 22:41:50 +0000
Message-ID: <20191122224126.24847-4-saeedm@mellanox.com>
References: <20191122224126.24847-1-saeedm@mellanox.com>
In-Reply-To: <20191122224126.24847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8607f3cf-b872-436b-e16c-08d76f9d2a5e
x-ms-traffictypediagnostic: VI1PR05MB6718:|VI1PR05MB6718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6718DBDD64166BE2CA9BF3BABE490@VI1PR05MB6718.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:466;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(189003)(199004)(14454004)(66946007)(64756008)(66556008)(1076003)(66066001)(66476007)(4326008)(6486002)(66446008)(14444005)(8936002)(6512007)(6916009)(7736002)(6506007)(26005)(256004)(305945005)(386003)(186003)(3846002)(102836004)(6116002)(11346002)(2616005)(446003)(107886003)(2906002)(478600001)(99286004)(8676002)(25786009)(52116002)(81156014)(36756003)(81166006)(76176011)(316002)(6436002)(54906003)(86362001)(50226002)(5660300002)(15650500001)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6718;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y26UA4//bha3C15TzaEioQwou0gqj4XSq5OS5jj9Zmg405t66RY2LGf/4T8uf3+Vo5aJ1hgg75zitg58/vtvcjZzy7bgyjwpFybvc+6W8KZGF5bMwRGDlsCAN/27J9MsmSeeOjtEzZB+1gdlceqPbR7kEBiEQ6hiclTv8pN5BgRY5Kfc4puQg3ZaXV4Nz9w1z0dF7VdgtoytW4QaB+PQWRHUIG92A6o0dEae+b71mGCrYTRBh7fZPFIdAviJtiC+PWYuYpXDWieR3WYBfOl6unuexCTSkSK8fJ4urv+c73hhTR8G9zbGpl0vA7QFGGVRFZD4jWy8R+vBLkA/hHaxyfr2fdThnDT/09P+EIbL0YLIdwlXcyU0OC2l3PM9KGOCKrMRiN9PhnwjWxOqPXVEQ/2Eoq/Ze0XqZC6Ht3H7bdOa/2gs6Z52hu8rJe/shmQ8
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8607f3cf-b872-436b-e16c-08d76f9d2a5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:41:50.9013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9/gAfFTlMUBfDFNvDrkWG+MPmmArm3SE4NeyV+VhKM133DoLX9E/W8wJOCdaigK21y1Nosh9rDxSxcXpbVhh9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report unique and standard error codes corresponding to the specific
FW flash error and report more detailed error messages to netlink.

Before:
$ devlink dev flash pci/0000:05:00.0 file ...
Error: mlxfw: Firmware flash failed.
devlink answers: Invalid argument

After:
$ devlink dev flash pci/0000:05:00.0 file ...
Error: mlxfw: Firmware flash failed: pending reset.
devlink answers: Operation already in progress

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 35 +++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 663eac994a5c..803152ab6914 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -39,6 +39,32 @@ static const char * const mlxfw_fsm_state_err_str[] =3D =
{
 		"unknown error"
 };
=20
+static const int mlxfw_fsm_state_errno[] =3D {
+	[MLXFW_FSM_STATE_ERR_ERROR] =3D -EREMOTEIO,
+	[MLXFW_FSM_STATE_ERR_REJECTED_DIGEST_ERR] =3D -EBADMSG,
+	[MLXFW_FSM_STATE_ERR_REJECTED_NOT_APPLICABLE] =3D -ENOENT,
+	[MLXFW_FSM_STATE_ERR_REJECTED_UNKNOWN_KEY] =3D -ENOKEY,
+	[MLXFW_FSM_STATE_ERR_REJECTED_AUTH_FAILED] =3D -EACCES,
+	[MLXFW_FSM_STATE_ERR_REJECTED_UNSIGNED] =3D -EKEYREVOKED,
+	[MLXFW_FSM_STATE_ERR_REJECTED_KEY_NOT_APPLICABLE] =3D -EKEYREJECTED,
+	[MLXFW_FSM_STATE_ERR_REJECTED_BAD_FORMAT] =3D -ENOEXEC,
+	[MLXFW_FSM_STATE_ERR_BLOCKED_PENDING_RESET] =3D -EALREADY,
+	[MLXFW_FSM_STATE_ERR_MAX] =3D -EINVAL
+};
+
+static int mlxfw_fsm_state_err(struct netlink_ext_ack *extack,
+			       enum mlxfw_fsm_state_err fsm_state_err)
+{
+#define MLXFW_ERR_PRFX "Firmware flash failed: "
+
+	fsm_state_err =3D min_t(enum mlxfw_fsm_state_err, fsm_state_err,
+			      MLXFW_FSM_STATE_ERR_MAX);
+	pr_err(MLXFW_ERR_PRFX "%s\n", mlxfw_fsm_state_err_str[fsm_state_err]);
+	NL_SET_ERR_MSG_MOD(extack, MLXFW_ERR_PRFX "%s",
+			   mlxfw_fsm_state_err_str[fsm_state_err]);
+	return mlxfw_fsm_state_errno[fsm_state_err];
+};
+
 static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 				enum mlxfw_fsm_state fsm_state,
 				struct netlink_ext_ack *extack)
@@ -55,12 +81,9 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_=
dev, u32 fwhandle,
 	if (err)
 		return err;
=20
-	if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK) {
-		pr_err("Firmware flash failed: %s\n",
-		       mlxfw_fsm_state_err_str[fsm_state_err]);
-		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
-		return -EINVAL;
-	}
+	if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK)
+		return mlxfw_fsm_state_err(extack, fsm_state_err);
+
 	if (curr_fsm_state !=3D fsm_state) {
 		if (--times =3D=3D 0) {
 			pr_err("Timeout reached on FSM state change");
--=20
2.21.0

