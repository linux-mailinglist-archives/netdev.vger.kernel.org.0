Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF75E168976
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgBUVqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:46:07 -0500
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:9220
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726683AbgBUVqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:46:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKjfh9BUVju7Qk5syoBY4CwWXABT/eo4Zm7jk1FG/maR1ythhZoIcZOnixw+iEoNHQIu6JbWMgGXwcpXDfXo79t2Fqof4Xgup0pKx8XTACuGw2lZbHzolxDUDntrR+c4ifJd6WEv3iuD8Q0WoettLnW22weJEfURlA/rSs4MxhMKGI/IB4DfPHotMRcri635xpU95lFIW3iYziArR5Ic3UQZmzxvbMz3C7xA3n8LiaFNA6RsHvcJ9KLffwkOYXphc+I8SrbvXwX9N1zIK6xR+ymj8Nml+lbV8EFbcbjGda9Aan9JbhVvQy98POwD8RdMQ/IQAADQF0/o+tYav0tMWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsAjWLTxIkCSglEV1abhAJq7T4O/DDtXer1CG/x67rw=;
 b=W9gYvYQyboA6ldJU2VeBrCek3fFNvMBKqViTkZmtJBcQEmiYGZBAr8cuf34bpkuwaBgGNuzCL7doEuOgO++MkYe3E7HbpuvjgF35w0h/Io9m3ctA5JLg4wpxPhDPR6VJJr7GH/2YFmBefhT+eZC3z4kWKYnFZxyOBetetnX7KZLh2eqMREZBkVWqI5BwQpyinPHmSOQT467VNfvla3Wj6hpyg6I/U3j/h46vf5V4MOoIMVvzXU9GMZEFmh6qql/kQ4KZwW04jZxiqh5GeUhqGMQhwfvC+eyFaQsN5ce/Mpc5Jc9zMcuLrlSNyELB4mF9BQImTpCimo7C4xgIEQqvHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsAjWLTxIkCSglEV1abhAJq7T4O/DDtXer1CG/x67rw=;
 b=A8SQy8wh/UKmOIyGBjeP03Bipc1b4yOZWDkUuvJNZ5zG0YULRmCvNIFHHJYqcKdimAzHqLQZBrgcPvR6cMqDvzxEyieEXxckWkQRY0HZo1v+dv3V7JOe03wPGhCYiPtyz/T3zEjaCzrcFneTk5jg3LRD1UABryeHe7b5XOQlafY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6927.eurprd05.prod.outlook.com (10.141.234.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 21 Feb 2020 21:46:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:45:59 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR16CA0021.namprd16.prod.outlook.com (2603:10b6:a03:1a0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 21:45:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next V2 2/7] net/mlxfw: Improve FSM err message reporting
 and return codes
Thread-Topic: [PATCH net-next V2 2/7] net/mlxfw: Improve FSM err message
 reporting and return codes
Thread-Index: AQHV6QBO03R6ivB8CUCxH6CPRN/CCw==
Date:   Fri, 21 Feb 2020 21:45:59 +0000
Message-ID: <20200221214536.20265-3-saeedm@mellanox.com>
References: <20200221214536.20265-1-saeedm@mellanox.com>
In-Reply-To: <20200221214536.20265-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: afe97bbe-100a-4f4e-c0c1-08d7b717708d
x-ms-traffictypediagnostic: VI1PR05MB6927:|VI1PR05MB6927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB69277BFF737DC5C6FB69C233BE120@VI1PR05MB6927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:236;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(186003)(6512007)(8936002)(54906003)(2616005)(316002)(16526019)(956004)(4326008)(478600001)(107886003)(6506007)(110136005)(52116002)(6486002)(26005)(86362001)(1076003)(66946007)(64756008)(66446008)(66476007)(81156014)(81166006)(5660300002)(8676002)(15650500001)(36756003)(71200400001)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6927;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EspeT3sPMR4qvQuf1Bd2dhPT8xNYqe/k38VUW5g1cXqf8Ul9eFJx9EDUwyZnSghLjz1VVnXSAirrUpB8crKkAGORlRLUfrvI56OYRfjdcBAfHRiZn2bUfa3eFxB9rQTk1DpeMauomFDmXjJ7+N9XaIS3E4gJnFSHH1Um2lJDli3uQECVKvlF4VX1v5GZ8SvuFAj+SkdjRYrpsCITpn4l71/P/RuQLl1B/i64tO1vj9iXqxl0JTzsXMjGmUVSX/vup6oH7ChjUM+sidHPEg9FGREBww4rg2a02gZ1xLbSOA8Mp2mMm6B31H0lBe082eB2tJccImftCDQ1wHSS1SwRgNjZTJrs9liQI8o0VfIzRTGXgJz5eiAewGuLS7nItg65v4hUBwi4mXWVAJOKLPXLpQZ7BxGtaVieWd7E2HW7dh3y9PvbfvW5qi1AZZxRWZXc/2lfdRYgkks9vXFpaBJZjJsahNr8/gXm4Mo1uT9oUJeYYLbEjwTuuGcQjmxjzrbhgUVJzy6oy8z1QYvGTfYUBptXsQaT7vSR/3L6WZLuNAM=
x-ms-exchange-antispam-messagedata: jwU+lB54RFLL+FwACJSjZ2kyxxpK+vCTdfCDOzD81RGBYgDZ9JE3e7nrjUGFmc22WCw2ShT4NH4oqORh+YOMFt7BKz1doXg5cdvCd2gMADyRfb/4KaxUQjyEctwVf5uO0EGGCh00QfTm0ZFyOOjyfw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe97bbe-100a-4f4e-c0c1-08d7b717708d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:45:59.9152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGUJyDM0VWjgl5ymQoeSkRBNk+RjfZvaORgb2EsxnQbO2giDS4U6SpOOQo8hlelPBeEOSIyIpTEEykiMvV8GVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6927
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
devlink answers: Device busy

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 94 +++++++++++++------
 1 file changed, 65 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 55211ad1c39d..cc5ea5ffdbba 100644
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
+	[MLXFW_FSM_STATE_ERR_ERROR] =3D -EIO,
+	[MLXFW_FSM_STATE_ERR_REJECTED_DIGEST_ERR] =3D -EBADMSG,
+	[MLXFW_FSM_STATE_ERR_REJECTED_NOT_APPLICABLE] =3D -ENOENT,
+	[MLXFW_FSM_STATE_ERR_REJECTED_UNKNOWN_KEY] =3D -ENOKEY,
+	[MLXFW_FSM_STATE_ERR_REJECTED_AUTH_FAILED] =3D -EACCES,
+	[MLXFW_FSM_STATE_ERR_REJECTED_UNSIGNED] =3D -EKEYREVOKED,
+	[MLXFW_FSM_STATE_ERR_REJECTED_KEY_NOT_APPLICABLE] =3D -EKEYREJECTED,
+	[MLXFW_FSM_STATE_ERR_REJECTED_BAD_FORMAT] =3D -ENOEXEC,
+	[MLXFW_FSM_STATE_ERR_BLOCKED_PENDING_RESET] =3D -EBUSY,
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

