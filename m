Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF07ECA98
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfKAV7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:12 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:44510
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726983AbfKAV7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKM2/e9CWiquXbgNPULy17aaDbwpMPRCP8GxLC9eNECb5iL+YnvJeCmRUozik0W94Mhi6hjjdlrrFwjDuUDY5Flgrz2VZXZ2wRXh21yD5IsRzg0yQP2mY0Xb4FZe7qRObCIT3wJW9eWydE/p48eNEFXdDMZONGxJ37G0ucTvpZUyfaLwyWbnnm7ddevL2ejNw4eukLzfgvX+cB/jc+1bPxY2gq51/eeQvNBBJ3Qwgss8+zUSp9OeIOeWCGi/8wioytsvmpiLPTGpQ8phiZ35Y2BrbPuGWjv4wT1pNNG+pSMBBxxHFqYyLGADFe52CtqfDxPnHQMCXfBeEeEcaqxlYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPuF+k1xk7yZSeJMUEAZB9OTzzltACQvZFTM9UW/Llk=;
 b=kf8G38Gg8rIyQPuiHaAYxybCcuRvsuAAGPUYhXMxv8oDeleQtR8nCRH7m5TsGp+Ca3lwpuFjBqXHMweg7rwJcoW6blTF+vAUZhLM8grxUYu+uIMlTt0LSBd+bNWnQvhg8835ROC9iALezyUFcdGb34PN3G+QoAAdF7qz6SqLBXz65UXdfKOMJqVu53LyJP7WKLbSYuanOTSSlj5yO9Iw7IZFRxJWBITL3OCra272yXiAf0j/XfS06dGsT+kC3uEoIbvMSh84EyC3F97cZ06CGRDdzwNJMpI/JjLAs/IyOfw5VIwVAZ9KXYsMOOKDD2+Q0Zw0aP1Xw3D535HHGRfswQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPuF+k1xk7yZSeJMUEAZB9OTzzltACQvZFTM9UW/Llk=;
 b=ZR+NCG8ioI76W7zOusG2rW5VPjr2gjvrJiki3x7/dTGr2PV87UoydmQxm+ygbcOzeODx5bXdcKD6yZs7CoE1y8i8+IHDX3hS1TDlUuECz7pc3c0JYYCjc9QeEvU2jvxrHQo5mBGIQ7C504Jb29973+dBpYN/cKEzTDw+CZy0QhU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6173.eurprd05.prod.outlook.com (20.178.123.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 21:59:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/15] net/mlx5e: Verify that rule has at least one
 fwd/drop action
Thread-Topic: [net-next 05/15] net/mlx5e: Verify that rule has at least one
 fwd/drop action
Thread-Index: AQHVkP+UcG65/DlPz0+MhctT0mftVQ==
Date:   Fri, 1 Nov 2019 21:59:05 +0000
Message-ID: <20191101215833.23975-6-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 76df1a95-4ea4-4f1b-7c55-08d75f16b63a
x-ms-traffictypediagnostic: VI1PR05MB6173:|VI1PR05MB6173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61734A5B609F20AF5C9CA1CFBE620@VI1PR05MB6173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(189003)(199004)(476003)(5660300002)(15650500001)(486006)(14454004)(107886003)(76176011)(7736002)(478600001)(66066001)(52116002)(2906002)(71190400001)(8676002)(71200400001)(6486002)(102836004)(81166006)(36756003)(81156014)(50226002)(6436002)(386003)(8936002)(6506007)(25786009)(66446008)(66476007)(6512007)(6116002)(3846002)(6916009)(26005)(99286004)(11346002)(66946007)(64756008)(86362001)(305945005)(54906003)(4326008)(316002)(1076003)(14444005)(186003)(446003)(2616005)(256004)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JUBIypVC25VV9e0y53FjtH/VSALD464F/NfcL6YNbXTMdmNVzRgxCorgKUAircSftke2ki70aI6UTYNucJMN1iQRDGUgMIJ+g3zA2Pzyl1kGw4R0XRkFXP1IGMzndd/Hx92f0fXITsUkHWN7Ak44DMqOx06Iiywxc53DArUw+xft+V8ViuhODiO86FgH7qdkHC8fqYaw9wITlK/XTsZX21y+nKdApC82Jb1r+WDzbcdPMfIBmFKqvRx2DpG5RfbfR5OqZ91ywauJz3kD3IPLSRZRVEJeVCLywIUjD9Na9d/+2Ey/tW83fFYzBfCKoNq1kOTF1eiVMxewBcWsoHIn4r6+HeObUKGybJLJ8dvjZ0qIXsQlIOaHcZnAwDDJ8IQiiwUbUd3mX8FxbnrBUq8eUMnq3+oXSh5R2cHRfD6B6zvTLlSKTD25C96NCT9CRtCO
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76df1a95-4ea4-4f1b-7c55-08d75f16b63a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:05.4675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y9e7Y3+bH6bF8YF5zkp7pxfBwuMTDKF8eIlBF+iYlhlRATAWkjur8X+6n26P5QnqdVNsBgVkmTufsfb3OIZSmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Currently, mlx5 tc layer doesn't verify that rule has at least one forward
or drop action which leads to following firmware syndrome when user tries
to offload such action:

[ 1824.860501] mlx5_core 0000:81:00.0: mlx5_cmd_check:753:(pid 29458): SET_=
FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), synd=
rome (0x144b7a)

Add check at the end of parse_tc_fdb_actions() that verifies that resulting
attribute has action fwd or drop flag set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 3e78a727f3e6..8c4bce940bfb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3423,6 +3423,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *p=
riv,
 		attr->action |=3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
=20
+	if (!(attr->action &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP)=
)) {
+		NL_SET_ERR_MSG(extack, "Rule must have at least one forward/drop action"=
);
+		return -EOPNOTSUPP;
+	}
+
 	if (attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "current firmware doesn't support split rule for port mirroring");
--=20
2.21.0

