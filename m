Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4140C107A3F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKVVwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:52:01 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:24062
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKVVwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:52:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRccIhGuo/tee3WPRmQNjlPDJL2uOvzD7En6cv8QGWHudyEFs0V4nI8RX0eOayn9YSre0Y8Q/msTeQndp/t15+Nk+p8vUtcLz/zDvceKYPHG8VW+Pmy9iiEprEdVVmcWEB6M/8ReR70vMdFH845Iq03Pef2OEP/TmnCsBuQUEDXs8zJhtsZTIslhdETmGaylCwkcdo2YNlWQmInwR3Jhw5Od5s4xDKw3024A5S2ldjqkWTr716n5rTH3fiY0+sgTNGp7I//nP60XtwLnzygbMBejq6bDeuFHwL/adSpnLJRdOiy0JjzE4Ugf1UGX/Nr8J/1dVQhygXkrDspIjSbBBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWwFvEXi4mAVGieuFuy+vjmEqN+Qgd7tk+T7WfFcfvU=;
 b=J2y3JdUoi1Dtecu9laFXyQZ9wPwpHdPZwMVKDjKf6chm2XWAhLc5koQFHPM2ulR455pTAUUqa7K+a+eVPMEkgyCYnCdjquz6EQdYacxIMZbnSyeUijT4YpyGZadrpGB2KmrXgym8S9iCzQy7uxtwjm6BXCz6GGkhkbxy5LQcOmwZlmqLjDNDEHv5EPGbd36Gd+rgBovAh+PXCa6mfAa1e968m+GqzlF6MfDy9mPmsngXLp2tmKzlFZVrWh3jfkUmzmvtBpd1EXvUkGkNJJB822hJapyAD9pEV8VC3gOWLo7GVHf7VNLMuX402JWfx3UZsPrXBlUOzCElLyk713hNzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWwFvEXi4mAVGieuFuy+vjmEqN+Qgd7tk+T7WfFcfvU=;
 b=Mn1aT8vf48KRNsCsKYImvVhnbFF7IOpABGrYWGwApdEv6H9VecBtNYICpiBbY30wON3+N0RmCqZe9NlAloxfb7NIY26x++mHZKgGoYf4bySmaDZtZgu6jjEtd4cCiPvPIRsl7Kuk8n1n26SQkGIH0WHprz0YhkZkytfdd93pDAc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 21:51:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:51:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/6] net/mlxfw: Improve FSM err message reporting and
 return codes
Thread-Topic: [PATCH net-next 3/6] net/mlxfw: Improve FSM err message
 reporting and return codes
Thread-Index: AQHVoX8N4AspyosR40+G2Du/QSLxVg==
Date:   Fri, 22 Nov 2019 21:51:53 +0000
Message-ID: <20191122215111.21723-4-saeedm@mellanox.com>
References: <20191122215111.21723-1-saeedm@mellanox.com>
In-Reply-To: <20191122215111.21723-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec22fb52-91cc-477d-561a-08d76f962f9a
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB534183AE49347F1094B60466BE490@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(107886003)(8676002)(386003)(6506007)(3846002)(36756003)(6512007)(26005)(478600001)(1076003)(316002)(66476007)(2906002)(6116002)(66556008)(64756008)(66446008)(71200400001)(71190400001)(99286004)(66946007)(66066001)(25786009)(4326008)(14444005)(256004)(54906003)(50226002)(102836004)(446003)(7736002)(186003)(305945005)(6436002)(6486002)(8936002)(76176011)(11346002)(52116002)(6916009)(14454004)(81156014)(5660300002)(81166006)(2616005)(15650500001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BwSYNsTOo9taojHK7ug2wbMEF7+SzqQZDW4qLQssxlVAYMMPYYvjt37PBPaXy3UpbuVeVy9KYiLNOQ+4pniJSK69q1DA6p4EeqiOoZfqkQi5Oj30RihzEgeGOIzAIXmiPRV7uYGhHQKg/W2Bt/oKmswO6XORBB/C6OV/UzDI8JhMASR2KxGc2ZSvZko+I6W6Sfqjn9rWO+JNIBXim7dgerWJ/iG8v5QAVkIoPDo+Cu8w54+wGYITf09pZ72zx1fg/Hp3ACaCQa8C2HRWE7/zzH6Q+bcfSzSv5BXfQWJ3MUrENUmd6S+/rluL1cmk4uy5lydkhV1EgPG9JmBVSmG+NqSVLnkzxKQkcYXKZytiM5el4B9RzGs6ZQKuSL3yEa/zA+81M5Bd/KaOdSFVVqA3WAjlBJpi/BtpGv50XiHjZLnn/QUJ3pZNTocBxoneRR9P
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec22fb52-91cc-477d-561a-08d76f962f9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:51:53.4373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r9hkRv6UFKMvOommwbHnh6KJJj5DpkSd3GNEE9oEN0WhpmU+cfu2JjkyKnnBMignLgTtG4BN3htmSPfIQhdS6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
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
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 55 +++++++++++++++++--
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index afcdc579578c..ba1e5b276c54 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -39,6 +39,52 @@ static const char * const mlxfw_fsm_state_err_str[] =3D =
{
 		"unknown error"
 };
=20
+static int mlxfw_fsm_state_err(struct netlink_ext_ack *extack,
+			       enum mlxfw_fsm_state_err fsm_state_err)
+{
+#define MLXFW_ERR_PRFX "Firmware flash failed: "
+#define MLXFW_FSM_STATE_ERR_NL(extack, msg) \
+	NL_SET_ERR_MSG_MOD((extack), MLXFW_ERR_PRFX msg)
+
+	fsm_state_err =3D min_t(enum mlxfw_fsm_state_err, fsm_state_err,
+			      MLXFW_FSM_STATE_ERR_MAX);
+	pr_err(MLXFW_ERR_PRFX "%s\n", mlxfw_fsm_state_err_str[fsm_state_err]);
+	switch (fsm_state_err) {
+	case MLXFW_FSM_STATE_ERR_ERROR:
+		MLXFW_FSM_STATE_ERR_NL(extack, "general error");
+		return -EREMOTEIO;
+	case MLXFW_FSM_STATE_ERR_REJECTED_DIGEST_ERR:
+		MLXFW_FSM_STATE_ERR_NL(extack, "component hash mismatch");
+		return -EBADMSG;
+	case MLXFW_FSM_STATE_ERR_REJECTED_NOT_APPLICABLE:
+		MLXFW_FSM_STATE_ERR_NL(extack, "component not applicable");
+		return -ENOENT;
+	case MLXFW_FSM_STATE_ERR_REJECTED_UNKNOWN_KEY:
+		MLXFW_FSM_STATE_ERR_NL(extack, "unknown key");
+		return -ENOKEY;
+	case MLXFW_FSM_STATE_ERR_REJECTED_AUTH_FAILED:
+		MLXFW_FSM_STATE_ERR_NL(extack, "authentication failed");
+		return -EACCES;
+	case MLXFW_FSM_STATE_ERR_REJECTED_UNSIGNED:
+		MLXFW_FSM_STATE_ERR_NL(extack, "component was not signed");
+		return -EKEYREVOKED;
+	case MLXFW_FSM_STATE_ERR_REJECTED_KEY_NOT_APPLICABLE:
+		MLXFW_FSM_STATE_ERR_NL(extack, "key not applicable");
+		return -EKEYREJECTED;
+	case MLXFW_FSM_STATE_ERR_REJECTED_BAD_FORMAT:
+		MLXFW_FSM_STATE_ERR_NL(extack, "bad format");
+		return -ENOEXEC;
+	case MLXFW_FSM_STATE_ERR_BLOCKED_PENDING_RESET:
+		MLXFW_FSM_STATE_ERR_NL(extack, "pending reset");
+		return -EALREADY;
+	case MLXFW_FSM_STATE_ERR_OK: /* should never happen */
+	case MLXFW_FSM_STATE_ERR_MAX:
+		MLXFW_FSM_STATE_ERR_NL(extack, "unknown error");
+		return -EINVAL;
+	}
+	return -EINVAL;
+};
+
 static void mlxfw_status_notify(struct mlxfw_dev *mlxfw_dev,
 				const char *msg, const char *comp_name,
 				u32 done_bytes, u32 total_bytes)
@@ -63,12 +109,9 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw=
_dev, u32 fwhandle,
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

