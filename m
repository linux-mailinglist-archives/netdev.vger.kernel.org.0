Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57E1A4FB9
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbfIBHXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:42 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:57541
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729725AbfIBHXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyzMHYusS6+8aiknXccow70GJvyLnJ4/7Mg73nDujuF3/1Hw1x3V4AXIqO3VP3Upzii5sjC4PojDRtNP5bO+WuYZg4b3CsPXkAcdX+WEHq5kWClK7EKNDKaMqlwGzDaAleyUUHODo9F6ebfP+11HX9Wu2vEWlsVumTfT156f/BZ2mYzyq9zFWUlfvwAlc+hXcb+tXMydjv/7mdr/fHvDDMgf37R+4v1bsruYHyhlm+vVHWZHBrbbxEvphM4IRHZs8pn0zvPc2sqUqWDChUiyYj0mxp1Apj5D6PX0Psw0F15g7Btg3wtHsVenKA+KB315fdwImy4lephBxqNrWQZfJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VA6NXS3mevjNmHqvw5uMp8+Q8TWjmgZ4KZw/e79mfGE=;
 b=Dcx2kR15KoQSTWBbFcAnaaByYtm4QkndaGaaUtHtjhsC7ngfQ1IN3Rce2i48NjHI4msuGOmA7HcTEEIhw1/WJMyfAQv+zeZRsrGrEksgHjY7UlsQsMpxJ0V4nXBEgEO7YMhtuxh0LCpzMH97MqbMx4doFtJ0S9UOMTXmg5SaqpA7+sXPD9+QlKvG4UKmR6DxFb49NNJ3w+OUbZP5MsqJJZXxxCl9xtFP4zKTzn5IIqW0DyhcPouB0isXFIybMxG2Amlt6m0HM9nGa/9rRm2yfc/QP5yprM5dQElVyG8r5Gt50jrFTAkIMAiTzy5b89DABToeN0kh9zGdB5WNLXk26w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VA6NXS3mevjNmHqvw5uMp8+Q8TWjmgZ4KZw/e79mfGE=;
 b=NOyLcC9T+6IdF4TamnDqeH42aJ69pKxKyteyl/hnkUlyQhZhjvubXWkN+MdE77osqWv/2LFqJygrqO7H06bwLasxVZrFvxE9BXucIARkffPrax591+0p5MjXXibsAO3nT0I5IBxMawAZa7Hz8viiLgy97isqznnR0x/awd2saMk=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:23:13 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/18] net/mlx5: DR, Expose steering action functionality
Thread-Topic: [net-next 10/18] net/mlx5: DR, Expose steering action
 functionality
Thread-Index: AQHVYV9H78s41f3IVUOVKKt3XKgjmQ==
Date:   Mon, 2 Sep 2019 07:23:13 +0000
Message-ID: <20190902072213.7683-11-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 692a4016-957f-43d1-319e-08d72f766a0b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2259D933569485F8A90A9FB4BEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(30864003)(102836004)(386003)(6506007)(2906002)(26005)(14444005)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(53946003)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4GBcuor2N/AEH47cwkpU0s/3dnBv7oYMXDYOIM1VA8fbnYUkBWH4p1jGJmsMl7a4rZksbLEwwr8x+NklktB3uZUl8tAiRddkOD++7lUTPX/D3gL19H7ABmVkqb/MsVQ+ZO/wt6BlyWQr/2OSNAaIlk3N8JK1Mn55UIIsND21Rc864Zdbd7CBY2bG7MvA48UvBMB5JHGrLmkJoiT+s8j4CScTyjQYAM0y+7w9/7IFfkq3kCjphLeZbsWrQn+DyAfRJa1YOZDcJ9nzHB/0cXjjvDd0nKNtum7zZSLBicCMYLAsxxVJzlPFZfOfWdRIqUEhabhIR+lB6/TIZyERkX+qTp4tpCNKDlk3wyX5NBir/Il/BeIa67ZCVkZeAzP7maNQtimuXWOd3zTkgmUBFvJh+nyVYC29QWIviyFoFCZQyEA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 692a4016-957f-43d1-319e-08d72f766a0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:13.1168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 824Mo6C8J9t3Z0eGMiU4imK3wx/kxRGueiMC+4plIj+tiDGA/q6+nicZxK754A2KoG7H88HXP7sbzOQUxwkkAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

On rule creation a set of actions can be provided, the actions describe
what to do with the packet in case of a match. It is possible to provide
a set of actions which will be done by order.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 1588 +++++++++++++++++
 1 file changed, 1588 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_act=
ion.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
new file mode 100644
index 000000000000..a02f87f85c17
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -0,0 +1,1588 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "dr_types.h"
+
+enum dr_action_domain {
+	DR_ACTION_DOMAIN_NIC_INGRESS,
+	DR_ACTION_DOMAIN_NIC_EGRESS,
+	DR_ACTION_DOMAIN_FDB_INGRESS,
+	DR_ACTION_DOMAIN_FDB_EGRESS,
+	DR_ACTION_DOMAIN_MAX,
+};
+
+enum dr_action_valid_state {
+	DR_ACTION_STATE_ERR,
+	DR_ACTION_STATE_NO_ACTION,
+	DR_ACTION_STATE_REFORMAT,
+	DR_ACTION_STATE_MODIFY_HDR,
+	DR_ACTION_STATE_MODIFY_VLAN,
+	DR_ACTION_STATE_NON_TERM,
+	DR_ACTION_STATE_TERM,
+	DR_ACTION_STATE_MAX,
+};
+
+static const enum dr_action_valid_state
+next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP=
_MAX] =3D {
+	[DR_ACTION_DOMAIN_NIC_INGRESS] =3D {
+		[DR_ACTION_STATE_NO_ACTION] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_QP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_TAG]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_TNL_L2_TO_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_TNL_L3_TO_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_POP_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+		},
+		[DR_ACTION_STATE_REFORMAT] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_QP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_TAG]		=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_POP_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+		},
+		[DR_ACTION_STATE_MODIFY_HDR] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_QP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_TAG]		=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_MODIFY_HDR,
+		},
+		[DR_ACTION_STATE_MODIFY_VLAN] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_QP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_TAG]		=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_POP_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+		},
+		[DR_ACTION_STATE_NON_TERM] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_QP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_TAG]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_TNL_L2_TO_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_TNL_L3_TO_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_POP_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+		},
+		[DR_ACTION_STATE_TERM] =3D {
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_TERM,
+		},
+	},
+	[DR_ACTION_DOMAIN_NIC_EGRESS] =3D {
+		[DR_ACTION_STATE_NO_ACTION] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_PUSH_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+		},
+		[DR_ACTION_STATE_REFORMAT] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_REFORMAT,
+		},
+		[DR_ACTION_STATE_MODIFY_HDR] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_PUSH_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+		},
+		[DR_ACTION_STATE_MODIFY_VLAN] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	=3D DR_ACTION_STATE_REFORMAT,
+		},
+		[DR_ACTION_STATE_NON_TERM] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_PUSH_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+		},
+		[DR_ACTION_STATE_TERM] =3D {
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_TERM,
+		},
+	},
+	[DR_ACTION_DOMAIN_FDB_INGRESS] =3D {
+		[DR_ACTION_STATE_NO_ACTION] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_TNL_L2_TO_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_TNL_L3_TO_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_POP_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_REFORMAT] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_POP_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_MODIFY_HDR] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_MODIFY_VLAN] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_POP_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+		},
+		[DR_ACTION_STATE_NON_TERM] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_TNL_L2_TO_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_TNL_L3_TO_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_POP_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_TERM] =3D {
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_TERM,
+		},
+	},
+	[DR_ACTION_DOMAIN_FDB_EGRESS] =3D {
+		[DR_ACTION_STATE_NO_ACTION] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_PUSH_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_REFORMAT] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_MODIFY_HDR] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_PUSH_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_MODIFY_VLAN] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_PUSH_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_NON_TERM] =3D {
+			[DR_ACTION_TYP_DROP]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		=3D DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_NON_TERM,
+			[DR_ACTION_TYP_MODIFY_HDR]	=3D DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	=3D DR_ACTION_STATE_REFORMAT,
+			[DR_ACTION_TYP_PUSH_VLAN]	=3D DR_ACTION_STATE_MODIFY_VLAN,
+			[DR_ACTION_TYP_VPORT]		=3D DR_ACTION_STATE_TERM,
+		},
+		[DR_ACTION_STATE_TERM] =3D {
+			[DR_ACTION_TYP_CTR]		=3D DR_ACTION_STATE_TERM,
+		},
+	},
+};
+
+struct dr_action_modify_field_conv {
+	u16 hw_field;
+	u8 start;
+	u8 end;
+	u8 l3_type;
+	u8 l4_type;
+};
+
+static const struct dr_action_modify_field_conv dr_action_conv_arr[] =3D {
+	[MLX5_ACTION_IN_FIELD_OUT_SMAC_47_16] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L2_1, .start =3D 16, .end =3D 47=
,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SMAC_15_0] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L2_1, .start =3D 0, .end =3D 15,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_ETHERTYPE] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L2_2, .start =3D 32, .end =3D 47=
,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DMAC_47_16] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L2_0, .start =3D 16, .end =3D 47=
,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DMAC_15_0] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L2_0, .start =3D 0, .end =3D 15,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IP_DSCP] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_1, .start =3D 0, .end =3D 5,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_FLAGS] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start =3D 48, .end =3D 56=
,
+		.l4_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_SPORT] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start =3D 0, .end =3D 15,
+		.l4_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start =3D 16, .end =3D 31=
,
+		.l4_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IP_TTL] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_1, .start =3D 8, .end =3D 15,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_1, .start =3D 8, .end =3D 15,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_UDP_SPORT] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start =3D 0, .end =3D 15,
+		.l4_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L4_UDP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_UDP_DPORT] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start =3D 16, .end =3D 31=
,
+		.l4_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L4_UDP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_3, .start =3D 32, .end =3D 63=
,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_3, .start =3D 0, .end =3D 31,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_4, .start =3D 32, .end =3D 63=
,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_4, .start =3D 0, .end =3D 31,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_0, .start =3D 32, .end =3D 63=
,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_0, .start =3D 0, .end =3D 31,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_2, .start =3D 32, .end =3D 63=
,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_2, .start =3D 0, .end =3D 31,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV4] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_0, .start =3D 0, .end =3D 31,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV4] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L3_0, .start =3D 32, .end =3D 63=
,
+		.l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_A] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_METADATA, .start =3D 0, .end =3D=
 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_B] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_METADATA, .start =3D 32, .end =
=3D 63,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_0] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_REG_0, .start =3D 32, .end =3D 6=
3,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_1] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_REG_0, .start =3D 0, .end =3D 31=
,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_2] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_REG_1, .start =3D 32, .end =3D 6=
3,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_3] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_REG_1, .start =3D 0, .end =3D 31=
,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_4] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_REG_2, .start =3D 32, .end =3D 6=
3,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_5] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_REG_2, .start =3D 0, .end =3D 31=
,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L4_1, .start =3D 32, .end =3D 63=
,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L4_1, .start =3D 0, .end =3D 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_FIRST_VID] =3D {
+		.hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_L2_2, .start =3D 0, .end =3D 15,
+	},
+};
+
+#define MAX_VLANS 2
+struct dr_action_vlan_info {
+	int	count;
+	u32	headers[MAX_VLANS];
+};
+
+struct dr_action_apply_attr {
+	u32	modify_index;
+	u16	modify_actions;
+	u32	decap_index;
+	u16	decap_actions;
+	u8	decap_with_vlan:1;
+	u64	final_icm_addr;
+	u32	flow_tag;
+	u32	ctr_id;
+	u16	gvmi;
+	u16	hit_gvmi;
+	u32	reformat_id;
+	u32	reformat_size;
+	struct	dr_action_vlan_info vlans;
+};
+
+static int
+dr_action_reformat_to_action_type(enum mlx5dr_action_reformat_type reforma=
t_type,
+				  enum mlx5dr_action_type *action_type)
+{
+	switch (reformat_type) {
+	case DR_ACTION_REFORMAT_TYP_TNL_L2_TO_L2:
+		*action_type =3D DR_ACTION_TYP_TNL_L2_TO_L2;
+		break;
+	case DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L2:
+		*action_type =3D DR_ACTION_TYP_L2_TO_TNL_L2;
+		break;
+	case DR_ACTION_REFORMAT_TYP_TNL_L3_TO_L2:
+		*action_type =3D DR_ACTION_TYP_TNL_L3_TO_L2;
+		break;
+	case DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L3:
+		*action_type =3D DR_ACTION_TYP_L2_TO_TNL_L3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void dr_actions_init_next_ste(u8 **last_ste,
+				     u32 *added_stes,
+				     enum mlx5dr_ste_entry_type entry_type,
+				     u16 gvmi)
+{
+	(*added_stes)++;
+	*last_ste +=3D DR_STE_SIZE;
+	mlx5dr_ste_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE, entry_type, gvmi=
);
+}
+
+static void dr_actions_apply_tx(struct mlx5dr_domain *dmn,
+				u8 *action_type_set,
+				u8 *last_ste,
+				struct dr_action_apply_attr *attr,
+				u32 *added_stes)
+{
+	bool encap =3D action_type_set[DR_ACTION_TYP_L2_TO_TNL_L2] ||
+		action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3];
+
+	/* We want to make sure the modify header comes before L2
+	 * encapsulation. The reason for that is that we support
+	 * modify headers for outer headers only
+	 */
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+		mlx5dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+		mlx5dr_ste_set_rewrite_actions(last_ste,
+					       attr->modify_actions,
+					       attr->modify_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_PUSH_VLAN]) {
+		int i;
+
+		for (i =3D 0; i < attr->vlans.count; i++) {
+			if (i || action_type_set[DR_ACTION_TYP_MODIFY_HDR])
+				dr_actions_init_next_ste(&last_ste,
+							 added_stes,
+							 MLX5DR_STE_TYPE_TX,
+							 attr->gvmi);
+
+			mlx5dr_ste_set_tx_push_vlan(last_ste,
+						    attr->vlans.headers[i],
+						    encap);
+		}
+	}
+
+	if (encap) {
+		/* Modify header and encapsulation require a different STEs.
+		 * Since modify header STE format doesn't support encapsulation
+		 * tunneling_action.
+		 */
+		if (action_type_set[DR_ACTION_TYP_MODIFY_HDR] ||
+		    action_type_set[DR_ACTION_TYP_PUSH_VLAN])
+			dr_actions_init_next_ste(&last_ste,
+						 added_stes,
+						 MLX5DR_STE_TYPE_TX,
+						 attr->gvmi);
+
+		mlx5dr_ste_set_tx_encap(last_ste,
+					attr->reformat_id,
+					attr->reformat_size,
+					action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]);
+		/* Whenever prio_tag_required enabled, we can be sure that the
+		 * previous table (ACL) already push vlan to our packet,
+		 * And due to HW limitation we need to set this bit, otherwise
+		 * push vlan + reformat will not work.
+		 */
+		if (MLX5_CAP_GEN(dmn->mdev, prio_tag_required))
+			mlx5dr_ste_set_go_back_bit(last_ste);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_CTR])
+		mlx5dr_ste_set_counter_id(last_ste, attr->ctr_id);
+}
+
+static void dr_actions_apply_rx(u8 *action_type_set,
+				u8 *last_ste,
+				struct dr_action_apply_attr *attr,
+				u32 *added_stes)
+{
+	if (action_type_set[DR_ACTION_TYP_CTR])
+		mlx5dr_ste_set_counter_id(last_ste, attr->ctr_id);
+
+	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
+		mlx5dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+		mlx5dr_ste_set_rx_decap_l3(last_ste, attr->decap_with_vlan);
+		mlx5dr_ste_set_rewrite_actions(last_ste,
+					       attr->decap_actions,
+					       attr->decap_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2])
+		mlx5dr_ste_set_rx_decap(last_ste);
+
+	if (action_type_set[DR_ACTION_TYP_POP_VLAN]) {
+		int i;
+
+		for (i =3D 0; i < attr->vlans.count; i++) {
+			if (i ||
+			    action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2] ||
+			    action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2])
+				dr_actions_init_next_ste(&last_ste,
+							 added_stes,
+							 MLX5DR_STE_TYPE_RX,
+							 attr->gvmi);
+
+			mlx5dr_ste_set_rx_pop_vlan(last_ste);
+		}
+	}
+
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+		if (mlx5dr_ste_get_entry_type(last_ste) =3D=3D MLX5DR_STE_TYPE_MODIFY_PK=
T)
+			dr_actions_init_next_ste(&last_ste,
+						 added_stes,
+						 MLX5DR_STE_TYPE_MODIFY_PKT,
+						 attr->gvmi);
+		else
+			mlx5dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+
+		mlx5dr_ste_set_rewrite_actions(last_ste,
+					       attr->modify_actions,
+					       attr->modify_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_TAG]) {
+		if (mlx5dr_ste_get_entry_type(last_ste) =3D=3D MLX5DR_STE_TYPE_MODIFY_PK=
T)
+			dr_actions_init_next_ste(&last_ste,
+						 added_stes,
+						 MLX5DR_STE_TYPE_RX,
+						 attr->gvmi);
+
+		mlx5dr_ste_rx_set_flow_tag(last_ste, attr->flow_tag);
+	}
+}
+
+/* Apply the actions on the rule STE array starting from the last_ste.
+ * Actions might require more than one STE, new_num_stes will return
+ * the new size of the STEs array, rule with actions.
+ */
+static void dr_actions_apply(struct mlx5dr_domain *dmn,
+			     enum mlx5dr_ste_entry_type ste_type,
+			     u8 *action_type_set,
+			     u8 *last_ste,
+			     struct dr_action_apply_attr *attr,
+			     u32 *new_num_stes)
+{
+	u32 added_stes =3D 0;
+
+	if (ste_type =3D=3D MLX5DR_STE_TYPE_RX)
+		dr_actions_apply_rx(action_type_set, last_ste, attr, &added_stes);
+	else
+		dr_actions_apply_tx(dmn, action_type_set, last_ste, attr, &added_stes);
+
+	last_ste +=3D added_stes * DR_STE_SIZE;
+	*new_num_stes +=3D added_stes;
+
+	mlx5dr_ste_set_hit_gvmi(last_ste, attr->hit_gvmi);
+	mlx5dr_ste_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+}
+
+static enum dr_action_domain
+dr_action_get_action_domain(enum mlx5dr_domain_type domain,
+			    enum mlx5dr_ste_entry_type ste_type)
+{
+	switch (domain) {
+	case MLX5DR_DOMAIN_TYPE_NIC_RX:
+		return DR_ACTION_DOMAIN_NIC_INGRESS;
+	case MLX5DR_DOMAIN_TYPE_NIC_TX:
+		return DR_ACTION_DOMAIN_NIC_EGRESS;
+	case MLX5DR_DOMAIN_TYPE_FDB:
+		if (ste_type =3D=3D MLX5DR_STE_TYPE_RX)
+			return DR_ACTION_DOMAIN_FDB_INGRESS;
+		return DR_ACTION_DOMAIN_FDB_EGRESS;
+	default:
+		WARN_ON(true);
+		return DR_ACTION_DOMAIN_MAX;
+	}
+}
+
+static
+int dr_action_validate_and_get_next_state(enum dr_action_domain action_dom=
ain,
+					  u32 action_type,
+					  u32 *state)
+{
+	u32 cur_state =3D *state;
+
+	/* Check action state machine is valid */
+	*state =3D next_action_state[action_domain][cur_state][action_type];
+
+	if (*state =3D=3D DR_ACTION_STATE_ERR)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int dr_action_handle_cs_recalc(struct mlx5dr_domain *dmn,
+				      struct mlx5dr_action *dest_action,
+				      u64 *final_icm_addr)
+{
+	int ret;
+
+	switch (dest_action->action_type) {
+	case DR_ACTION_TYP_FT:
+		/* Allow destination flow table only if table is a terminating
+		 * table, since there is an *assumption* that in such case FW
+		 * will recalculate the CS.
+		 */
+		if (dest_action->dest_tbl.is_fw_tbl) {
+			*final_icm_addr =3D dest_action->dest_tbl.fw_tbl.rx_icm_addr;
+		} else {
+			mlx5dr_dbg(dmn,
+				   "Destination FT should be terminating when modify TTL is used\n");
+			return -EINVAL;
+		}
+		break;
+
+	case DR_ACTION_TYP_VPORT:
+		/* If destination is vport we will get the FW flow table
+		 * that recalculates the CS and forwards to the vport.
+		 */
+		ret =3D mlx5dr_domain_cache_get_recalc_cs_ft_addr(dest_action->vport.dmn=
,
+								dest_action->vport.num,
+								final_icm_addr);
+		if (ret) {
+			mlx5dr_err(dmn, "Failed to get FW cs recalc flow table\n");
+			return ret;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+#define WITH_VLAN_NUM_HW_ACTIONS 6
+
+int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
+				 struct mlx5dr_matcher_rx_tx *nic_matcher,
+				 struct mlx5dr_action *actions[],
+				 u32 num_actions,
+				 u8 *ste_arr,
+				 u32 *new_hw_ste_arr_sz)
+{
+	struct mlx5dr_domain_rx_tx *nic_dmn =3D nic_matcher->nic_tbl->nic_dmn;
+	bool rx_rule =3D nic_dmn->ste_type =3D=3D MLX5DR_STE_TYPE_RX;
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	u8 action_type_set[DR_ACTION_TYP_MAX] =3D {};
+	struct mlx5dr_action *dest_action =3D NULL;
+	u32 state =3D DR_ACTION_STATE_NO_ACTION;
+	struct dr_action_apply_attr attr =3D {};
+	enum dr_action_domain action_domain;
+	bool recalc_cs_required =3D false;
+	u8 *last_ste;
+	int i, ret;
+
+	attr.gvmi =3D dmn->info.caps.gvmi;
+	attr.hit_gvmi =3D dmn->info.caps.gvmi;
+	attr.final_icm_addr =3D nic_dmn->default_icm_addr;
+	action_domain =3D dr_action_get_action_domain(dmn->type, nic_dmn->ste_typ=
e);
+
+	for (i =3D 0; i < num_actions; i++) {
+		struct mlx5dr_action *action;
+		int max_actions_type =3D 1;
+		u32 action_type;
+
+		action =3D actions[i];
+		action_type =3D action->action_type;
+
+		switch (action_type) {
+		case DR_ACTION_TYP_DROP:
+			attr.final_icm_addr =3D nic_dmn->drop_icm_addr;
+			break;
+		case DR_ACTION_TYP_FT:
+			dest_action =3D action;
+			if (!action->dest_tbl.is_fw_tbl) {
+				if (action->dest_tbl.tbl->dmn !=3D dmn) {
+					mlx5dr_dbg(dmn,
+						   "Destination table belongs to a different domain\n");
+					goto out_invalid_arg;
+				}
+				if (action->dest_tbl.tbl->level <=3D matcher->tbl->level) {
+					mlx5dr_dbg(dmn,
+						   "Destination table level should be higher than source table\n");
+					goto out_invalid_arg;
+				}
+				attr.final_icm_addr =3D rx_rule ?
+					action->dest_tbl.tbl->rx.s_anchor->chunk->icm_addr :
+					action->dest_tbl.tbl->tx.s_anchor->chunk->icm_addr;
+			} else {
+				struct mlx5dr_cmd_query_flow_table_details output;
+				int ret;
+
+				/* get the relevant addresses */
+				if (!action->dest_tbl.fw_tbl.rx_icm_addr) {
+					ret =3D mlx5dr_cmd_query_flow_table(action->dest_tbl.fw_tbl.mdev,
+									  action->dest_tbl.fw_tbl.ft->type,
+									  action->dest_tbl.fw_tbl.ft->id,
+									  &output);
+					if (!ret) {
+						action->dest_tbl.fw_tbl.tx_icm_addr =3D
+							output.sw_owner_icm_root_1;
+						action->dest_tbl.fw_tbl.rx_icm_addr =3D
+							output.sw_owner_icm_root_0;
+					} else {
+						mlx5dr_dbg(dmn,
+							   "Failed mlx5_cmd_query_flow_table ret: %d\n",
+							   ret);
+						return ret;
+					}
+				}
+				attr.final_icm_addr =3D rx_rule ?
+					action->dest_tbl.fw_tbl.rx_icm_addr :
+					action->dest_tbl.fw_tbl.tx_icm_addr;
+			}
+			break;
+		case DR_ACTION_TYP_QP:
+			mlx5dr_info(dmn, "Domain doesn't support QP\n");
+			goto out_invalid_arg;
+		case DR_ACTION_TYP_CTR:
+			attr.ctr_id =3D action->ctr.ctr_id +
+				action->ctr.offeset;
+			break;
+		case DR_ACTION_TYP_TAG:
+			attr.flow_tag =3D action->flow_tag;
+			break;
+		case DR_ACTION_TYP_TNL_L2_TO_L2:
+			break;
+		case DR_ACTION_TYP_TNL_L3_TO_L2:
+			attr.decap_index =3D action->rewrite.index;
+			attr.decap_actions =3D action->rewrite.num_of_actions;
+			attr.decap_with_vlan =3D
+				attr.decap_actions =3D=3D WITH_VLAN_NUM_HW_ACTIONS;
+			break;
+		case DR_ACTION_TYP_MODIFY_HDR:
+			attr.modify_index =3D action->rewrite.index;
+			attr.modify_actions =3D action->rewrite.num_of_actions;
+			recalc_cs_required =3D action->rewrite.modify_ttl;
+			break;
+		case DR_ACTION_TYP_L2_TO_TNL_L2:
+		case DR_ACTION_TYP_L2_TO_TNL_L3:
+			attr.reformat_size =3D action->reformat.reformat_size;
+			attr.reformat_id =3D action->reformat.reformat_id;
+			break;
+		case DR_ACTION_TYP_VPORT:
+			attr.hit_gvmi =3D action->vport.caps->vhca_gvmi;
+			dest_action =3D action;
+			if (rx_rule) {
+				/* Loopback on WIRE vport is not supported */
+				if (action->vport.num =3D=3D WIRE_PORT)
+					goto out_invalid_arg;
+
+				attr.final_icm_addr =3D action->vport.caps->icm_address_rx;
+			} else {
+				attr.final_icm_addr =3D action->vport.caps->icm_address_tx;
+			}
+			break;
+		case DR_ACTION_TYP_POP_VLAN:
+			max_actions_type =3D MAX_VLANS;
+			attr.vlans.count++;
+			break;
+		case DR_ACTION_TYP_PUSH_VLAN:
+			max_actions_type =3D MAX_VLANS;
+			if (attr.vlans.count =3D=3D MAX_VLANS)
+				return -EINVAL;
+
+			attr.vlans.headers[attr.vlans.count++] =3D action->push_vlan.vlan_hdr;
+			break;
+		default:
+			goto out_invalid_arg;
+		}
+
+		/* Check action duplication */
+		if (++action_type_set[action_type] > max_actions_type) {
+			mlx5dr_dbg(dmn, "Action type %d supports only max %d time(s)\n",
+				   action_type, max_actions_type);
+			goto out_invalid_arg;
+		}
+
+		/* Check action state machine is valid */
+		if (dr_action_validate_and_get_next_state(action_domain,
+							  action_type,
+							  &state)) {
+			mlx5dr_dbg(dmn, "Invalid action sequence provided\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	*new_hw_ste_arr_sz =3D nic_matcher->num_of_builders;
+	last_ste =3D ste_arr + DR_STE_SIZE * (nic_matcher->num_of_builders - 1);
+
+	/* Due to a HW bug, modifying TTL on RX flows will cause an incorrect
+	 * checksum calculation. In this case we will use a FW table to
+	 * recalculate.
+	 */
+	if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB &&
+	    rx_rule && recalc_cs_required && dest_action) {
+		ret =3D dr_action_handle_cs_recalc(dmn, dest_action, &attr.final_icm_add=
r);
+		if (ret) {
+			mlx5dr_dbg(dmn,
+				   "Failed to handle checksum recalculation err %d\n",
+				   ret);
+			return ret;
+		}
+	}
+
+	dr_actions_apply(dmn,
+			 nic_dmn->ste_type,
+			 action_type_set,
+			 last_ste,
+			 &attr,
+			 new_hw_ste_arr_sz);
+
+	return 0;
+
+out_invalid_arg:
+	return -EINVAL;
+}
+
+#define CVLAN_ETHERTYPE 0x8100
+#define SVLAN_ETHERTYPE 0x88a8
+#define HDR_LEN_L2_ONLY 14
+#define HDR_LEN_L2_VLAN 18
+#define REWRITE_HW_ACTION_NUM 6
+
+static int dr_actions_l2_rewrite(struct mlx5dr_domain *dmn,
+				 struct mlx5dr_action *action,
+				 void *data, size_t data_sz)
+{
+	struct mlx5_ifc_l2_hdr_bits *l2_hdr =3D data;
+	u64 ops[REWRITE_HW_ACTION_NUM] =3D {};
+	u32 hdr_fld_4b;
+	u16 hdr_fld_2b;
+	u16 vlan_type;
+	bool vlan;
+	int i =3D 0;
+	int ret;
+
+	vlan =3D (data_sz !=3D HDR_LEN_L2_ONLY);
+
+	/* dmac_47_16 */
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_length, 0);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_0);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_left_shifter, 16);
+	hdr_fld_4b =3D MLX5_GET(l2_hdr, l2_hdr, dmac_47_16);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 inline_data, hdr_fld_4b);
+	i++;
+
+	/* smac_47_16 */
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_length, 0);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_1);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_left_shifter, 16);
+	hdr_fld_4b =3D (MLX5_GET(l2_hdr, l2_hdr, smac_31_0) >> 16 |
+		      MLX5_GET(l2_hdr, l2_hdr, smac_47_32) << 16);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 inline_data, hdr_fld_4b);
+	i++;
+
+	/* dmac_15_0 */
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_length, 16);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_0);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_left_shifter, 0);
+	hdr_fld_2b =3D MLX5_GET(l2_hdr, l2_hdr, dmac_15_0);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 inline_data, hdr_fld_2b);
+	i++;
+
+	/* ethertype + (optional) vlan */
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_2);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_left_shifter, 32);
+	if (!vlan) {
+		hdr_fld_2b =3D MLX5_GET(l2_hdr, l2_hdr, ethertype);
+		MLX5_SET(dr_action_hw_set, ops + i, inline_data, hdr_fld_2b);
+		MLX5_SET(dr_action_hw_set, ops + i, destination_length, 16);
+	} else {
+		hdr_fld_2b =3D MLX5_GET(l2_hdr, l2_hdr, ethertype);
+		vlan_type =3D hdr_fld_2b =3D=3D SVLAN_ETHERTYPE ? DR_STE_SVLAN : DR_STE_=
CVLAN;
+		hdr_fld_2b =3D MLX5_GET(l2_hdr, l2_hdr, vlan);
+		hdr_fld_4b =3D (vlan_type << 16) | hdr_fld_2b;
+		MLX5_SET(dr_action_hw_set, ops + i, inline_data, hdr_fld_4b);
+		MLX5_SET(dr_action_hw_set, ops + i, destination_length, 18);
+	}
+	i++;
+
+	/* smac_15_0 */
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_length, 16);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_1);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 destination_left_shifter, 0);
+	hdr_fld_2b =3D MLX5_GET(l2_hdr, l2_hdr, smac_31_0);
+	MLX5_SET(dr_action_hw_set, ops + i,
+		 inline_data, hdr_fld_2b);
+	i++;
+
+	if (vlan) {
+		MLX5_SET(dr_action_hw_set, ops + i,
+			 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
+		hdr_fld_2b =3D MLX5_GET(l2_hdr, l2_hdr, vlan_type);
+		MLX5_SET(dr_action_hw_set, ops + i,
+			 inline_data, hdr_fld_2b);
+		MLX5_SET(dr_action_hw_set, ops + i,
+			 destination_length, 16);
+		MLX5_SET(dr_action_hw_set, ops + i,
+			 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_2);
+		MLX5_SET(dr_action_hw_set, ops + i,
+			 destination_left_shifter, 0);
+		i++;
+	}
+
+	action->rewrite.data =3D (void *)ops;
+	action->rewrite.num_of_actions =3D i;
+	action->rewrite.chunk->byte_size =3D i * sizeof(*ops);
+
+	ret =3D mlx5dr_send_postsend_action(dmn, action);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Writing encapsulation action to ICM failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct mlx5dr_action *
+dr_action_create_generic(enum mlx5dr_action_type action_type)
+{
+	struct mlx5dr_action *action;
+
+	action =3D kzalloc(sizeof(*action), GFP_KERNEL);
+	if (!action)
+		return NULL;
+
+	action->action_type =3D action_type;
+	refcount_set(&action->refcount, 1);
+
+	return action;
+}
+
+struct mlx5dr_action *mlx5dr_action_create_drop(void)
+{
+	return dr_action_create_generic(DR_ACTION_TYP_DROP);
+}
+
+struct mlx5dr_action *
+mlx5dr_action_create_dest_table(struct mlx5dr_table *tbl)
+{
+	struct mlx5dr_action *action;
+
+	refcount_inc(&tbl->refcount);
+
+	action =3D dr_action_create_generic(DR_ACTION_TYP_FT);
+	if (!action)
+		goto dec_ref;
+
+	action->dest_tbl.tbl =3D tbl;
+
+	return action;
+
+dec_ref:
+	refcount_dec(&tbl->refcount);
+	return NULL;
+}
+
+struct mlx5dr_action *
+mlx5dr_create_action_dest_flow_fw_table(struct mlx5_flow_table *ft,
+					struct mlx5_core_dev *mdev)
+{
+	struct mlx5dr_action *action;
+
+	action =3D dr_action_create_generic(DR_ACTION_TYP_FT);
+	if (!action)
+		return NULL;
+
+	action->dest_tbl.is_fw_tbl =3D 1;
+	action->dest_tbl.fw_tbl.ft =3D ft;
+	action->dest_tbl.fw_tbl.mdev =3D mdev;
+
+	return action;
+}
+
+struct mlx5dr_action *
+mlx5dr_action_create_flow_counter(u32 counter_id)
+{
+	struct mlx5dr_action *action;
+
+	action =3D dr_action_create_generic(DR_ACTION_TYP_CTR);
+	if (!action)
+		return NULL;
+
+	action->ctr.ctr_id =3D counter_id;
+
+	return action;
+}
+
+struct mlx5dr_action *mlx5dr_action_create_tag(u32 tag_value)
+{
+	struct mlx5dr_action *action;
+
+	action =3D dr_action_create_generic(DR_ACTION_TYP_TAG);
+	if (!action)
+		return NULL;
+
+	action->flow_tag =3D tag_value & 0xffffff;
+
+	return action;
+}
+
+static int
+dr_action_verify_reformat_params(enum mlx5dr_action_type reformat_type,
+				 struct mlx5dr_domain *dmn,
+				 size_t data_sz,
+				 void *data)
+{
+	if ((!data && data_sz) || (data && !data_sz) || reformat_type >
+		DR_ACTION_TYP_L2_TO_TNL_L3) {
+		mlx5dr_dbg(dmn, "Invalid reformat parameter!\n");
+		goto out_err;
+	}
+
+	if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB)
+		return 0;
+
+	if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_RX) {
+		if (reformat_type !=3D DR_ACTION_TYP_TNL_L2_TO_L2 &&
+		    reformat_type !=3D DR_ACTION_TYP_TNL_L3_TO_L2) {
+			mlx5dr_dbg(dmn, "Action reformat type not support on RX domain\n");
+			goto out_err;
+		}
+	} else if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_TX) {
+		if (reformat_type !=3D DR_ACTION_TYP_L2_TO_TNL_L2 &&
+		    reformat_type !=3D DR_ACTION_TYP_L2_TO_TNL_L3) {
+			mlx5dr_dbg(dmn, "Action reformat type not support on TX domain\n");
+			goto out_err;
+		}
+	}
+
+	return 0;
+
+out_err:
+	return -EINVAL;
+}
+
+#define ACTION_CACHE_LINE_SIZE 64
+
+static int
+dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
+				 size_t data_sz, void *data,
+				 struct mlx5dr_action *action)
+{
+	u32 reformat_id;
+	int ret;
+
+	switch (action->action_type) {
+	case DR_ACTION_TYP_L2_TO_TNL_L2:
+	case DR_ACTION_TYP_L2_TO_TNL_L3:
+	{
+		enum mlx5dr_action_type rt;
+
+		if (action->action_type =3D=3D DR_ACTION_TYP_L2_TO_TNL_L2)
+			rt =3D MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
+		else
+			rt =3D MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL;
+
+		ret =3D mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, data_sz, data,
+						     &reformat_id);
+		if (ret)
+			return ret;
+
+		action->reformat.reformat_id =3D reformat_id;
+		action->reformat.reformat_size =3D data_sz;
+		return 0;
+	}
+	case DR_ACTION_TYP_TNL_L2_TO_L2:
+	{
+		return 0;
+	}
+	case DR_ACTION_TYP_TNL_L3_TO_L2:
+	{
+		/* Only Ethernet frame is supported, with VLAN (18) or without (14) */
+		if (data_sz !=3D HDR_LEN_L2_ONLY && data_sz !=3D HDR_LEN_L2_VLAN)
+			return -EINVAL;
+
+		action->rewrite.chunk =3D mlx5dr_icm_alloc_chunk(dmn->action_icm_pool,
+							       DR_CHUNK_SIZE_8);
+		if (!action->rewrite.chunk)
+			return -ENOMEM;
+
+		action->rewrite.index =3D (action->rewrite.chunk->icm_addr -
+					 dmn->info.caps.hdr_modify_icm_addr) /
+					 ACTION_CACHE_LINE_SIZE;
+
+		ret =3D dr_actions_l2_rewrite(dmn, action, data, data_sz);
+		if (ret) {
+			mlx5dr_icm_free_chunk(action->rewrite.chunk);
+			return ret;
+		}
+		return 0;
+	}
+	default:
+		mlx5dr_info(dmn, "Reformat type is not supported %d\n", action->action_t=
ype);
+		return -EINVAL;
+	}
+}
+
+struct mlx5dr_action *mlx5dr_action_create_pop_vlan(void)
+{
+	return dr_action_create_generic(DR_ACTION_TYP_POP_VLAN);
+}
+
+struct mlx5dr_action *mlx5dr_action_create_push_vlan(struct mlx5dr_domain =
*dmn,
+						     __be32 vlan_hdr)
+{
+	u32 vlan_hdr_h =3D ntohl(vlan_hdr);
+	u16 ethertype =3D vlan_hdr_h >> 16;
+	struct mlx5dr_action *action;
+
+	if (ethertype !=3D SVLAN_ETHERTYPE && ethertype !=3D CVLAN_ETHERTYPE) {
+		mlx5dr_dbg(dmn, "Invalid vlan ethertype\n");
+		return NULL;
+	}
+
+	action =3D dr_action_create_generic(DR_ACTION_TYP_PUSH_VLAN);
+	if (!action)
+		return NULL;
+
+	action->push_vlan.vlan_hdr =3D vlan_hdr_h;
+	return action;
+}
+
+struct mlx5dr_action *
+mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
+				     enum mlx5dr_action_reformat_type reformat_type,
+				     size_t data_sz,
+				     void *data)
+{
+	enum mlx5dr_action_type action_type;
+	struct mlx5dr_action *action;
+	int ret;
+
+	refcount_inc(&dmn->refcount);
+
+	/* General checks */
+	ret =3D dr_action_reformat_to_action_type(reformat_type, &action_type);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Invalid reformat_type provided\n");
+		goto dec_ref;
+	}
+
+	ret =3D dr_action_verify_reformat_params(action_type, dmn, data_sz, data)=
;
+	if (ret)
+		goto dec_ref;
+
+	action =3D dr_action_create_generic(action_type);
+	if (!action)
+		goto dec_ref;
+
+	action->reformat.dmn =3D dmn;
+
+	ret =3D dr_action_create_reformat_action(dmn,
+					       data_sz,
+					       data,
+					       action);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Failed creating reformat action %d\n", ret);
+		goto free_action;
+	}
+
+	return action;
+
+free_action:
+	kfree(action);
+dec_ref:
+	refcount_dec(&dmn->refcount);
+	return NULL;
+}
+
+static const struct dr_action_modify_field_conv *
+dr_action_modify_get_hw_info(u16 sw_field)
+{
+	const struct dr_action_modify_field_conv *hw_action_info;
+
+	if (sw_field >=3D ARRAY_SIZE(dr_action_conv_arr))
+		goto not_found;
+
+	hw_action_info =3D &dr_action_conv_arr[sw_field];
+	if (!hw_action_info->end && !hw_action_info->start)
+		goto not_found;
+
+	return hw_action_info;
+
+not_found:
+	return NULL;
+}
+
+static int
+dr_action_modify_sw_to_hw(struct mlx5dr_domain *dmn,
+			  __be64 *sw_action,
+			  __be64 *hw_action,
+			  const struct dr_action_modify_field_conv **ret_hw_info)
+{
+	const struct dr_action_modify_field_conv *hw_action_info;
+	u8 offset, length, max_length, action;
+	u16 sw_field;
+	u8 hw_opcode;
+	u32 data;
+
+	/* Get SW modify action data */
+	action =3D MLX5_GET(set_action_in, sw_action, action_type);
+	length =3D MLX5_GET(set_action_in, sw_action, length);
+	offset =3D MLX5_GET(set_action_in, sw_action, offset);
+	sw_field =3D MLX5_GET(set_action_in, sw_action, field);
+	data =3D MLX5_GET(set_action_in, sw_action, data);
+
+	/* Convert SW data to HW modify action format */
+	hw_action_info =3D dr_action_modify_get_hw_info(sw_field);
+	if (!hw_action_info) {
+		mlx5dr_dbg(dmn, "Modify action invalid field given\n");
+		return -EINVAL;
+	}
+
+	max_length =3D hw_action_info->end - hw_action_info->start + 1;
+
+	switch (action) {
+	case MLX5_ACTION_TYPE_SET:
+		hw_opcode =3D MLX5DR_ACTION_MDFY_HW_OP_SET;
+		/* PRM defines that length zero specific length of 32bits */
+		if (!length)
+			length =3D 32;
+
+		if (length + offset > max_length) {
+			mlx5dr_dbg(dmn, "Modify action length + offset exceeds limit\n");
+			return -EINVAL;
+		}
+		break;
+
+	case MLX5_ACTION_TYPE_ADD:
+		hw_opcode =3D MLX5DR_ACTION_MDFY_HW_OP_ADD;
+		offset =3D 0;
+		length =3D max_length;
+		break;
+
+	default:
+		mlx5dr_info(dmn, "Unsupported action_type for modify action\n");
+		return -EOPNOTSUPP;
+	}
+
+	MLX5_SET(dr_action_hw_set, hw_action, opcode, hw_opcode);
+
+	MLX5_SET(dr_action_hw_set, hw_action, destination_field_code,
+		 hw_action_info->hw_field);
+
+	MLX5_SET(dr_action_hw_set, hw_action, destination_left_shifter,
+		 hw_action_info->start + offset);
+
+	MLX5_SET(dr_action_hw_set, hw_action, destination_length,
+		 length =3D=3D 32 ? 0 : length);
+
+	MLX5_SET(dr_action_hw_set, hw_action, inline_data, data);
+
+	*ret_hw_info =3D hw_action_info;
+
+	return 0;
+}
+
+static int
+dr_action_modify_check_field_limitation(struct mlx5dr_domain *dmn,
+					const __be64 *sw_action)
+{
+	u16 sw_field;
+	u8 action;
+
+	sw_field =3D MLX5_GET(set_action_in, sw_action, field);
+	action =3D MLX5_GET(set_action_in, sw_action, action_type);
+
+	/* Check if SW field is supported in current domain (RX/TX) */
+	if (action =3D=3D MLX5_ACTION_TYPE_SET) {
+		if (sw_field =3D=3D MLX5_ACTION_IN_FIELD_METADATA_REG_A) {
+			if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_NIC_TX) {
+				mlx5dr_dbg(dmn, "Unsupported field %d for RX/FDB set action\n",
+					   sw_field);
+				return -EINVAL;
+			}
+		}
+
+		if (sw_field =3D=3D MLX5_ACTION_IN_FIELD_METADATA_REG_B) {
+			if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_NIC_RX) {
+				mlx5dr_dbg(dmn, "Unsupported field %d for TX/FDB set action\n",
+					   sw_field);
+				return -EINVAL;
+			}
+		}
+	} else if (action =3D=3D MLX5_ACTION_TYPE_ADD) {
+		if (sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_IP_TTL &&
+		    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT &&
+		    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM &&
+		    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM) {
+			mlx5dr_dbg(dmn, "Unsupported field %d for add action\n", sw_field);
+			return -EINVAL;
+		}
+	} else {
+		mlx5dr_info(dmn, "Unsupported action %d modify action\n", action);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static bool
+dr_action_modify_check_is_ttl_modify(const u64 *sw_action)
+{
+	u16 sw_field =3D MLX5_GET(set_action_in, sw_action, field);
+
+	return sw_field =3D=3D MLX5_ACTION_IN_FIELD_OUT_IP_TTL;
+}
+
+static int dr_actions_convert_modify_header(struct mlx5dr_domain *dmn,
+					    u32 max_hw_actions,
+					    u32 num_sw_actions,
+					    __be64 sw_actions[],
+					    __be64 hw_actions[],
+					    u32 *num_hw_actions,
+					    bool *modify_ttl)
+{
+	const struct dr_action_modify_field_conv *hw_action_info;
+	u16 hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_RESERVED;
+	u32 l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_NONE;
+	u32 l4_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L4_NONE;
+	int ret, i, hw_idx =3D 0;
+	__be64 *sw_action;
+	__be64 hw_action;
+
+	*modify_ttl =3D false;
+
+	for (i =3D 0; i < num_sw_actions; i++) {
+		sw_action =3D &sw_actions[i];
+
+		ret =3D dr_action_modify_check_field_limitation(dmn, sw_action);
+		if (ret)
+			return ret;
+
+		if (!(*modify_ttl))
+			*modify_ttl =3D dr_action_modify_check_is_ttl_modify(sw_action);
+
+		/* Convert SW action to HW action */
+		ret =3D dr_action_modify_sw_to_hw(dmn,
+						sw_action,
+						&hw_action,
+						&hw_action_info);
+		if (ret)
+			return ret;
+
+		/* Due to a HW limitation we cannot modify 2 different L3 types */
+		if (l3_type && hw_action_info->l3_type &&
+		    hw_action_info->l3_type !=3D l3_type) {
+			mlx5dr_dbg(dmn, "Action list can't support two different L3 types\n");
+			return -EINVAL;
+		}
+		if (hw_action_info->l3_type)
+			l3_type =3D hw_action_info->l3_type;
+
+		/* Due to a HW limitation we cannot modify two different L4 types */
+		if (l4_type && hw_action_info->l4_type &&
+		    hw_action_info->l4_type !=3D l4_type) {
+			mlx5dr_dbg(dmn, "Action list can't support two different L4 types\n");
+			return -EINVAL;
+		}
+		if (hw_action_info->l4_type)
+			l4_type =3D hw_action_info->l4_type;
+
+		/* HW reads and executes two actions at once this means we
+		 * need to create a gap if two actions access the same field
+		 */
+		if ((hw_idx % 2) && hw_field =3D=3D hw_action_info->hw_field) {
+			/* Check if after gap insertion the total number of HW
+			 * modify actions doesn't exceeds the limit
+			 */
+			hw_idx++;
+			if ((num_sw_actions + hw_idx - i) >=3D max_hw_actions) {
+				mlx5dr_dbg(dmn, "Modify header action number exceeds HW limit\n");
+				return -EINVAL;
+			}
+		}
+		hw_field =3D hw_action_info->hw_field;
+
+		hw_actions[hw_idx] =3D hw_action;
+		hw_idx++;
+	}
+
+	*num_hw_actions =3D hw_idx;
+
+	return 0;
+}
+
+static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
+					  size_t actions_sz,
+					  __be64 actions[],
+					  struct mlx5dr_action *action)
+{
+	struct mlx5dr_icm_chunk *chunk;
+	u32 max_hw_actions;
+	u32 num_hw_actions;
+	u32 num_sw_actions;
+	__be64 *hw_actions;
+	bool modify_ttl;
+	int ret;
+
+	num_sw_actions =3D actions_sz / DR_MODIFY_ACTION_SIZE;
+	max_hw_actions =3D mlx5dr_icm_pool_chunk_size_to_entries(DR_CHUNK_SIZE_16=
);
+
+	if (num_sw_actions > max_hw_actions) {
+		mlx5dr_dbg(dmn, "Max number of actions %d exceeds limit %d\n",
+			   num_sw_actions, max_hw_actions);
+		return -EINVAL;
+	}
+
+	chunk =3D mlx5dr_icm_alloc_chunk(dmn->action_icm_pool, DR_CHUNK_SIZE_16);
+	if (!chunk)
+		return -ENOMEM;
+
+	hw_actions =3D kcalloc(1, max_hw_actions * DR_MODIFY_ACTION_SIZE, GFP_KER=
NEL);
+	if (!hw_actions) {
+		ret =3D -ENOMEM;
+		goto free_chunk;
+	}
+
+	ret =3D dr_actions_convert_modify_header(dmn,
+					       max_hw_actions,
+					       num_sw_actions,
+					       actions,
+					       hw_actions,
+					       &num_hw_actions,
+					       &modify_ttl);
+	if (ret)
+		goto free_hw_actions;
+
+	action->rewrite.chunk =3D chunk;
+	action->rewrite.modify_ttl =3D modify_ttl;
+	action->rewrite.data =3D (u8 *)hw_actions;
+	action->rewrite.num_of_actions =3D num_hw_actions;
+	action->rewrite.index =3D (chunk->icm_addr -
+				 dmn->info.caps.hdr_modify_icm_addr) /
+				 ACTION_CACHE_LINE_SIZE;
+
+	ret =3D mlx5dr_send_postsend_action(dmn, action);
+	if (ret)
+		goto free_hw_actions;
+
+	return 0;
+
+free_hw_actions:
+	kfree(hw_actions);
+free_chunk:
+	mlx5dr_icm_free_chunk(chunk);
+	return ret;
+}
+
+struct mlx5dr_action *
+mlx5dr_action_create_modify_header(struct mlx5dr_domain *dmn,
+				   u32 flags,
+				   size_t actions_sz,
+				   __be64 actions[])
+{
+	struct mlx5dr_action *action;
+	int ret =3D 0;
+
+	refcount_inc(&dmn->refcount);
+
+	if (actions_sz % DR_MODIFY_ACTION_SIZE) {
+		mlx5dr_dbg(dmn, "Invalid modify actions size provided\n");
+		goto dec_ref;
+	}
+
+	action =3D dr_action_create_generic(DR_ACTION_TYP_MODIFY_HDR);
+	if (!action)
+		goto dec_ref;
+
+	action->rewrite.dmn =3D dmn;
+
+	ret =3D dr_action_create_modify_action(dmn,
+					     actions_sz,
+					     actions,
+					     action);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Failed creating modify header action %d\n", ret);
+		goto free_action;
+	}
+
+	return action;
+
+free_action:
+	kfree(action);
+dec_ref:
+	refcount_dec(&dmn->refcount);
+	return NULL;
+}
+
+struct mlx5dr_action *
+mlx5dr_action_create_dest_vport(struct mlx5dr_domain *dmn,
+				u32 vport, u8 vhca_id_valid,
+				u16 vhca_id)
+{
+	struct mlx5dr_cmd_vport_cap *vport_cap;
+	struct mlx5dr_domain *vport_dmn;
+	struct mlx5dr_action *action;
+	u8 peer_vport;
+
+	peer_vport =3D vhca_id_valid && (vhca_id !=3D dmn->info.caps.gvmi);
+	vport_dmn =3D peer_vport ? dmn->peer_dmn : dmn;
+	if (!vport_dmn) {
+		mlx5dr_dbg(dmn, "No peer vport domain for given vhca_id\n");
+		return NULL;
+	}
+
+	if (vport_dmn->type !=3D MLX5DR_DOMAIN_TYPE_FDB) {
+		mlx5dr_dbg(dmn, "Domain doesn't support vport actions\n");
+		return NULL;
+	}
+
+	vport_cap =3D mlx5dr_get_vport_cap(&vport_dmn->info.caps, vport);
+	if (!vport_cap) {
+		mlx5dr_dbg(dmn, "Failed to get vport %d caps\n", vport);
+		return NULL;
+	}
+
+	action =3D dr_action_create_generic(DR_ACTION_TYP_VPORT);
+	if (!action)
+		return NULL;
+
+	action->vport.dmn =3D vport_dmn;
+	action->vport.caps =3D vport_cap;
+
+	return action;
+}
+
+int mlx5dr_action_destroy(struct mlx5dr_action *action)
+{
+	if (refcount_read(&action->refcount) > 1)
+		return -EBUSY;
+
+	switch (action->action_type) {
+	case DR_ACTION_TYP_FT:
+		if (!action->dest_tbl.is_fw_tbl)
+			refcount_dec(&action->dest_tbl.tbl->refcount);
+		break;
+	case DR_ACTION_TYP_TNL_L2_TO_L2:
+		refcount_dec(&action->reformat.dmn->refcount);
+		break;
+	case DR_ACTION_TYP_TNL_L3_TO_L2:
+		mlx5dr_icm_free_chunk(action->rewrite.chunk);
+		refcount_dec(&action->reformat.dmn->refcount);
+		break;
+	case DR_ACTION_TYP_L2_TO_TNL_L2:
+	case DR_ACTION_TYP_L2_TO_TNL_L3:
+		mlx5dr_cmd_destroy_reformat_ctx((action->reformat.dmn)->mdev,
+						action->reformat.reformat_id);
+		refcount_dec(&action->reformat.dmn->refcount);
+		break;
+	case DR_ACTION_TYP_MODIFY_HDR:
+		mlx5dr_icm_free_chunk(action->rewrite.chunk);
+		refcount_dec(&action->rewrite.dmn->refcount);
+		break;
+	default:
+		break;
+	}
+
+	kfree(action);
+	return 0;
+}
--=20
2.21.0

