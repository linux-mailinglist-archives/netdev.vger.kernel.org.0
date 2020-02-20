Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71690165500
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgBTCZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:25:50 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:32566
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbgBTCZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:25:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hzy+fiYlMHodi47H2XUIjsl710QWlEQ1uVjhxpe5RpbFwQEQaKTlm0whFeAmQtzp37+9jt2C2/j5J9UKLqS+4X/7QDB94rmuCpglKtBGYLRvKF8869PDlwErEmzNopuGU6vMkj9bvc7qi2JXyfPQXIZq6lUMJ+Ge5MGqj7YzvnT02z5axZeu9UovD3OJ5yemVY5c0l/yF+IwhlOxb4cOUb3cuw3hPLhAi+PjbRqP6j+mIfs0w/klfebg3X1jHNYwwQwOEiBsWxxMNetdFsUnXQYIIQQQVtprQ8dqv3+O+SGq4z+lXMKbUG+mE80dyEh7M/UFk5JZfVOfA610ZE8nQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDuHlKO/HnDBQqgC3GVgCiJMeyp7wbbVn45ftllrnrI=;
 b=KgZpGfz97UNKw4/aptX/2ckrwbyaBSPjppxSqHboFzEG611+Ui6IoAHWOkdOqtG/Uc9YVq04Z4MtYbpqdSa0cmArmWDnUlHfYXtef0izWGi3TZ810njdto9m/BNpPoki0kPAbEm/z0hqVjS9406+9h3qkHEDNfBPMjxQl6+5ZVgEUyD8n4aEUyCYEjMClMgSLd02ibxExExoqBXfYUKLgoBm1RS8HV8ZTWgyREaBHsptsazWT6C4xSdg/84JTtjzZG9aDG4PvGLv9AkmWbML1QNsiiWUGzXgDe/smBL8nZXsIs0OQCxXqVyBoy3lq+w0haXwwOH4wZLFehbTT9xtrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDuHlKO/HnDBQqgC3GVgCiJMeyp7wbbVn45ftllrnrI=;
 b=eDpJ78sql0ozagqGm/7qYVUe/KuokcdGyqQX661ukyZeFkSR5AB6bsrPxEwY//GaZwwTR0EeAbNXG/ABFcWeFClpLFrBl4qzODs4+FpYD3EP53j1SfLTGdb51Aj1WB0Y5bJTYfcWK7XiqgM7bSaiL9isZkIX7qkZIpusxHy7YzA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4173.eurprd05.prod.outlook.com (52.134.122.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Thu, 20 Feb 2020 02:25:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:25:43 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0022.namprd20.prod.outlook.com (2603:10b6:a03:1f4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 20 Feb 2020 02:25:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/7] net/mlxfw: Improve FSM err message reporting and
 return codes
Thread-Topic: [PATCH net-next 2/7] net/mlxfw: Improve FSM err message
 reporting and return codes
Thread-Index: AQHV55UMvLBd8iCINkaFAwYKMRa0IA==
Date:   Thu, 20 Feb 2020 02:25:42 +0000
Message-ID: <20200220022502.38262-3-saeedm@mellanox.com>
References: <20200220022502.38262-1-saeedm@mellanox.com>
In-Reply-To: <20200220022502.38262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d1b93b69-b94c-4394-f4d6-08d7b5ac2ed9
x-ms-traffictypediagnostic: VI1PR05MB4173:|VI1PR05MB4173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB41738812DDCB97AC1D0CCAE5BE130@VI1PR05MB4173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(199004)(189003)(54906003)(5660300002)(2906002)(26005)(478600001)(71200400001)(6486002)(6512007)(16526019)(110136005)(52116002)(316002)(186003)(86362001)(6506007)(4326008)(956004)(2616005)(1076003)(107886003)(64756008)(15650500001)(81156014)(81166006)(66946007)(66556008)(8936002)(66476007)(8676002)(36756003)(66446008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cILQ3Vj28hs2578Bwcn7VqsafBmDdYwHMjQIBqZY0DORysnQLuVDflOQe4RV6LDuMhTw0+l9vb2xROsBCKCVAnWmxROOjauu8rTxVqJQm7w8xCwRHlWZqV1orKtuGpuuTpBW7RGNXFT5Fnw47xa7w9gWKsIhXvsgc4npOPbdkDldwsp9Y4FphHwHLCyg9AW9ORCQIaDrQFWXvWtt99wNQp2zlE6h3epGY1/LUG5g6ZypPl97i4a9ZRwiBNInubmR1MaNZjP/BTw/2cBJwTEC0l56Zfo4Pn8rhGdZ7w6Te42ac3kOe1AM+WBAIvSIop5cXHYlno4XNvT8JBXxveLYGZmuEWtKjaMsiqxF36Ib7Zb+UkrSamc1Pwo5z78MZs2TjvRrW2/k/baTpNVi9QpRbuQe4YwQyfJl1EzF0p7vxQFA6cMVnGIRtFaokYYiKmV0rWw1R/qGuUKGhuipvGdTDq/YupDzBbOGaCUoee9+GybjQSeanR4xmHeWI42o8urEgNWrPuT2MJbDvCrz7MeBucuGTEbNucwA7tmvU5BcOu0=
x-ms-exchange-antispam-messagedata: jOAPsMojmXvTB9/lQ9CaOBocfs2m0Ea57vljco6KpEYu6+6eXSgB8WbDT55rw/IqU0YoTi5pBa/D/DRGkW+VryUnfLMBJELDX6PHPlqrDs12mWHzYQQehfT1clHBgpMQxPaZsHLE85TsUYu6Iyj/0w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b93b69-b94c-4394-f4d6-08d7b5ac2ed9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:25:42.9498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XDE+THC+g3RrdzMnvdL7DTdb08Q3O9gZuorX1awMYkmuH4G/Na7F2HAgwkzG2KIZFgEJQi7y7qcYTR06/Z2MBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report unique and standard error codes corresponding to the specific
FW flash error. In addition, add a more detailed error messages to
netlink.

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
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 94 +++++++++++++------
 1 file changed, 65 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 55211ad1c39d..3701f7f0d4d9 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -16,27 +16,68 @@
 	(MLXFW_FSM_STATE_WAIT_TIMEOUT_MS / MLXFW_FSM_STATE_WAIT_CYCLE_MS)
 #define MLXFW_FSM_MAX_COMPONENT_SIZE (10 * (1 << 20))
=20
-static const char * const mlxfw_fsm_state_err_str[] =3D {
-	[MLXFW_FSM_STATE_ERR_ERROR] =3D
-		"general error",
-	[MLXFW_FSM_STATE_ERR_REJECTED_DIGEST_ERR] =3D
-		"component hash mismatch",
-	[MLXFW_FSM_STATE_ERR_REJECTED_NOT_APPLICABLE] =3D
-		"component not applicable",
-	[MLXFW_FSM_STATE_ERR_REJECTED_UNKNOWN_KEY] =3D
-		"unknown key",
-	[MLXFW_FSM_STATE_ERR_REJECTED_AUTH_FAILED] =3D
-		"authentication failed",
-	[MLXFW_FSM_STATE_ERR_REJECTED_UNSIGNED] =3D
-		"component was not signed",
-	[MLXFW_FSM_STATE_ERR_REJECTED_KEY_NOT_APPLICABLE] =3D
-		"key not applicable",
-	[MLXFW_FSM_STATE_ERR_REJECTED_BAD_FORMAT] =3D
-		"bad format",
-	[MLXFW_FSM_STATE_ERR_BLOCKED_PENDING_RESET] =3D
-		"pending reset",
-	[MLXFW_FSM_STATE_ERR_MAX] =3D
-		"unknown error"
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
+#define MLXFW_ERR_PRFX "Firmware flash failed: "
+#define MLXFW_ERR_MSG(extack, msg, err) do { \
+	pr_err("%s, err (%d)\n", MLXFW_ERR_PRFX msg, err); \
+	NL_SET_ERR_MSG_MOD(extack, MLXFW_ERR_PRFX msg); \
+} while (0)
+
+static int mlxfw_fsm_state_err(struct netlink_ext_ack *extack,
+			       enum mlxfw_fsm_state_err err)
+{
+	enum mlxfw_fsm_state_err fsm_state_err;
+
+	fsm_state_err =3D min_t(enum mlxfw_fsm_state_err, err,
+			      MLXFW_FSM_STATE_ERR_MAX);
+
+	switch (fsm_state_err) {
+	case MLXFW_FSM_STATE_ERR_ERROR:
+		MLXFW_ERR_MSG(extack, "general error", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_REJECTED_DIGEST_ERR:
+		MLXFW_ERR_MSG(extack, "component hash mismatch", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_REJECTED_NOT_APPLICABLE:
+		MLXFW_ERR_MSG(extack, "component not applicable", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_REJECTED_UNKNOWN_KEY:
+		MLXFW_ERR_MSG(extack, "unknown key", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_REJECTED_AUTH_FAILED:
+		MLXFW_ERR_MSG(extack, "authentication failed", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_REJECTED_UNSIGNED:
+		MLXFW_ERR_MSG(extack, "component was not signed", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_REJECTED_KEY_NOT_APPLICABLE:
+		MLXFW_ERR_MSG(extack, "key not applicable", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_REJECTED_BAD_FORMAT:
+		MLXFW_ERR_MSG(extack, "bad format", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_BLOCKED_PENDING_RESET:
+		MLXFW_ERR_MSG(extack, "pending reset", err);
+		break;
+	case MLXFW_FSM_STATE_ERR_OK: /* fall through */
+	case MLXFW_FSM_STATE_ERR_MAX:
+		MLXFW_ERR_MSG(extack, "unknown error", err);
+		break;
+	};
+
+	return mlxfw_fsm_state_errno[fsm_state_err];
 };
=20
 static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
@@ -55,14 +96,9 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_=
dev, u32 fwhandle,
 	if (err)
 		return err;
=20
-	if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK) {
-		fsm_state_err =3D min_t(enum mlxfw_fsm_state_err,
-				      fsm_state_err, MLXFW_FSM_STATE_ERR_MAX);
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
2.24.1

