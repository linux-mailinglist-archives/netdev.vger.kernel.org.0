Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A1C168983
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgBUVqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:46:22 -0500
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:9220
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728656AbgBUVqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:46:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZ6t2vklue2JfzTUVfVFzq44Lvd2hhNpQ1xNgYVrYP/Hm+0Vm1fwdpEWYro+5S76BUZaEtmiw7al8cF79d9VIssXuPE514pWuJrXk03kUD+M0epFFCn3zl11fBhIF+fHYGZ3+JI3fXo25FmRRRTwQA0PVBAwZ6eWAD953VfBPk/iENPz2ejD3Dh8sPzfL8KCMRDcEjtp0vuQKZxNdegLqqscuJgCZpfgjRLymQcHXvrI9jbI8qreTyD4WNRQOzU0ETR69rJB6I3uSEmPHylEeAyy2BmSopOyZJorbat+0tlRjGOWQxpGhqPeurN+93uYIqJQwQ0bMPy3OakNLIgTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbMSmFJ1Lrh+pH/eHA8X5ffyROg8/SwkhRV2VAduC/4=;
 b=XbkAC/3L9nWK98eSr6iX6RQsP19jGBQwHns7M3vzSHKlePKSaZNz3j2xS3RPuwg/Vvi7KAUXBtxsXm794aZ0n0fVTZY+UePxcpGgGybQ4Juc6yVMKRcYYQE9oJiFNy42ul4cXTMBG9NMyL03US8dwX3HICXRfFsv2YEWoParcXOi/Vin4bCDQ48emfFqKl2cdcvGrgIB6IdFY+L+KNWpDUocn8yHaaP+0LYMol0dEX0j3UB3doD9UB3FOeV/GF7Q2jlbdyEjK/jeF0EB2u6KTO94UzdFrFrPIfLRe8MTz8iFaCoXkU9C/UYIUQtPZklsLCwZtIimD4kIRBpF9A/l4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbMSmFJ1Lrh+pH/eHA8X5ffyROg8/SwkhRV2VAduC/4=;
 b=Vplm9ATX7gWt0R/Nhwp9wF0Qwhe04uRIoJaPS8XTVKAm29eK4uOGsoSreuu7wyzgW1PL5KUeWthWE6OGsciJ23G2ZkEjVon5ZPlD6njo1coYXyuBy2robrSGV+tm1H/7dWrQ9SS005BCBix+fxr9jLg2WY1s3eyjV5FV64fl6xA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6927.eurprd05.prod.outlook.com (10.141.234.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 21 Feb 2020 21:46:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:46:12 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR16CA0021.namprd16.prod.outlook.com (2603:10b6:a03:1a0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 21:46:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next V2 7/7] net/mlx5: Add fsm_reactivate callback support
Thread-Topic: [PATCH net-next V2 7/7] net/mlx5: Add fsm_reactivate callback
 support
Thread-Index: AQHV6QBVa7ZVW4SdFUiFoPu73QJowA==
Date:   Fri, 21 Feb 2020 21:46:12 +0000
Message-ID: <20200221214536.20265-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 06f132c0-ae53-41ed-9d48-08d7b717775b
x-ms-traffictypediagnostic: VI1PR05MB6927:|VI1PR05MB6927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6927AF5A52A22DC13CDB956FBE120@VI1PR05MB6927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(186003)(6512007)(8936002)(54906003)(2616005)(316002)(16526019)(956004)(4326008)(478600001)(107886003)(6506007)(110136005)(52116002)(6486002)(26005)(86362001)(1076003)(66946007)(64756008)(66446008)(66476007)(81156014)(81166006)(5660300002)(8676002)(6666004)(36756003)(71200400001)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6927;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oFccuPVuZnX5vsEiwp4PBBhPHGDpzAL2j2EAxwCjJPEi7J2fv1ZO4zNu6SGsaUNWXdGEfjOFsAi4inkjhfU8AuiEau1CrIxamfWhNIedxVTrqnj8b6dIA7Mqfdszwfm7bstPdnkXzUCv2cL56YRsWVAuwkMSij2fCxZ6yZuQxwQGcrp1DjPQF9Mg1nQhN9RUOLFwQSBTK0mKdOiDAY5xHXYLYcsBTpGKDRLU+oAFQLOi7IndVWPTWb91lZ35HHlayfl8fqUHLE/2aVjtaoRNJV2daq1thlMNR76dr5stRbJorqFxHFpKMIlLctsBUTqERx5jb2srEiKoxxkFPIL3idbxi9Ru6QMBx2i6hQubBCf3CaxndC4miUt/jfu8xJMt/9bpC7PjSZtYGu05u/YMT6NuJTigxQ4Ts1MxF+bKs3xGdrIdeSxaS62ZfPVoRVM6bs7AIO6P8vSOwyZtQV4pj6uFRqOqUEEHlmwW30L7ItEJxBA8oFuYiECLwvVLuW6tqKNVSJGzTjFzFqZvv8m6NC2W03BLThfjZJ9QUGD2Hm0=
x-ms-exchange-antispam-messagedata: SRQ1/tmEpTdD2r10Ldz7QGiLJ/gDzXlrWDRqMD81vh+gygPan7GRzxgdia3BQj1WJUdsenQPlwvMKNeTp9evJLC4eT+Z51MH5jRnoLGNSLzKuIE1Jd4NMEBdvdSSBW9FeTeWg9rUFHHsgTM+BD7XXg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f132c0-ae53-41ed-9d48-08d7b717775b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:46:12.5759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rFtvMopbrs3D+eHT+1Q9hKCA1bBC0yeL44aM+LlEtRR5LkIafS3330fXUZlBM318XaTHx4rxLcDQVIDaoUBSOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6927
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Add support for fsm reactivate via MIRC (Management Image Re-activation
Control) set and query commands.
For re-activation flow, driver shall first run MIRC set, and then wait
until FW is done (via querying MIRC status).

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 39 ++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/fw.c
index 4250fd6de6d7..90e3d0233101 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -613,6 +613,44 @@ static void mlx5_fsm_release(struct mlxfw_dev *mlxfw_d=
ev, u32 fwhandle)
 			 fwhandle, 0);
 }
=20
+#define MLX5_FSM_REACTIVATE_TOUT 5000 /* msecs */
+static int mlx5_fsm_reactivate(struct mlxfw_dev *mlxfw_dev, u8 *status)
+{
+	unsigned long exp_time =3D jiffies + msecs_to_jiffies(MLX5_FSM_REACTIVATE=
_TOUT);
+	struct mlx5_mlxfw_dev *mlx5_mlxfw_dev =3D
+		container_of(mlxfw_dev, struct mlx5_mlxfw_dev, mlxfw_dev);
+	struct mlx5_core_dev *dev =3D mlx5_mlxfw_dev->mlx5_core_dev;
+	u32 out[MLX5_ST_SZ_DW(mirc_reg)];
+	u32 in[MLX5_ST_SZ_DW(mirc_reg)];
+	int err;
+
+	if (!MLX5_CAP_MCAM_REG2(dev, mirc))
+		return -EOPNOTSUPP;
+
+	memset(in, 0, sizeof(in));
+
+	err =3D mlx5_core_access_reg(dev, in, sizeof(in), out,
+				   sizeof(out), MLX5_REG_MIRC, 0, 1);
+	if (err)
+		return err;
+
+	do {
+		memset(out, 0, sizeof(out));
+		err =3D mlx5_core_access_reg(dev, in, sizeof(in), out,
+					   sizeof(out), MLX5_REG_MIRC, 0, 0);
+		if (err)
+			return err;
+
+		*status =3D MLX5_GET(mirc_reg, out, status_code);
+		if (*status !=3D MLXFW_FSM_REACTIVATE_STATUS_BUSY)
+			return 0;
+
+		msleep(20);
+	} while (time_before(jiffies, exp_time));
+
+	return 0;
+}
+
 static const struct mlxfw_dev_ops mlx5_mlxfw_dev_ops =3D {
 	.component_query	=3D mlx5_component_query,
 	.fsm_lock		=3D mlx5_fsm_lock,
@@ -620,6 +658,7 @@ static const struct mlxfw_dev_ops mlx5_mlxfw_dev_ops =
=3D {
 	.fsm_block_download	=3D mlx5_fsm_block_download,
 	.fsm_component_verify	=3D mlx5_fsm_component_verify,
 	.fsm_activate		=3D mlx5_fsm_activate,
+	.fsm_reactivate		=3D mlx5_fsm_reactivate,
 	.fsm_query_state	=3D mlx5_fsm_query_state,
 	.fsm_cancel		=3D mlx5_fsm_cancel,
 	.fsm_release		=3D mlx5_fsm_release
--=20
2.24.1

