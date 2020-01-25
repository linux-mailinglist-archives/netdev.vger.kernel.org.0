Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2E149372
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgAYFLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:49 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbgAYFLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dI6ro9QIcAjzjYLvx5nHhO8ickaAPijO1o0Vwv8V046SIBqQz/Y8262U3Zp/yy2Who74LxMRxPu7GRAXz91xF72aCBafG/5jEvIzz1eceDgWs001VXPhijdbv9DX89FyNduxmLKgenvxqFjNQjZQMIFKzR2inHYvjb4M7cCAk+3qVTB+o4dbKGoEqb3Eup4Ohh/VIbh5bpLbhe4860UXjPnK+rAA6xZK38iUqekxnmfI3MfqN/EIARMMQIOq4PUcRWcYPoagwp/IVzOw7YM9b/xsnSNMXw6f6z7BQ4i+6Nste+nPORfaH33JA2WWvp9DXN4UpkP77+5R2gmNjZHToA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3x2pFfyESIyobL1mJ9/Mp6CQ82E4j5XbiQdvAjGnA0=;
 b=ISqB20mahRq5HWuSgOdKSq4dp2q+69JpzDi8/4U780KW9B9zV5HRgyvwDBJHlPwK5sifpYKxtHXRGjRazVS+9jUMv9++rpJUaMbirr7zZ45V0uXw9zwKFLfkREL/jXCuZ5u3Ys8/tY5PmCkCQR2Ec/Nc1UrRDs79AW84EASttSPQKR6YnWRHXZph4opbpRrWx0EHe4z9T8PIb9tKhKGmzH6K0Rxtk7LdasCLokUUEg8TljXI0UnAIVHWJR1bePqVoqY5chGvynNXAb2ayyeuLapoLOfI5s+UVF2cj4Gb5fHSF/KcM7Xt6S3+g5c7QopEzSpp1WpFrGeWnjwFu4+XDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3x2pFfyESIyobL1mJ9/Mp6CQ82E4j5XbiQdvAjGnA0=;
 b=nRI8iXz7SmspusQXDcAvf9AsN6DVAWgWMsOjfV+/uOhNPrdCDMRMrmvKs6CnSHkMwNK+LJOwvteOy5dtbaM3i/EQOAdtWREV9hibhvnw4Pvjon+7la+pxQnZmETylcDSoEGTmGcLQXK4dNDmRi3fb1NskKX4qA2TRGY5i8BB6AY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:37 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 08/14] net/mlx5e: Enforce setting of a single FEC mode
Thread-Topic: [net-next V2 08/14] net/mlx5e: Enforce setting of a single FEC
 mode
Thread-Index: AQHV0z3raliyRThgWUSp5/oj+XnLxA==
Date:   Sat, 25 Jan 2020 05:11:37 +0000
Message-ID: <20200125051039.59165-9-saeedm@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
In-Reply-To: <20200125051039.59165-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 78e91f5a-50a1-4c32-403e-08d7a1550d31
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB03945750005B0E8AF64F1151BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(4744005)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oa0eJpwWd0y3g/UWn+PhqooxaGAdrFy/ED4X9FNfOAwsl3XzV0OFYbKUclSbMde9k/ENH/TFf1DQ6KBnxc9N1W08UPW08v/2DOYNgB1lVhYt4V3qpcLEffRRZNiYwI0tHtgUtH/1/n5ap24sjfA0O/raIXF0tZkPaOL6HyiQrHSiLdkm3HHgabfet4UTylmFdrbpyQW36QE117lZCdB8dE7G/CbX5yWqB3U4En4edfwSZ+sxN6klw98uxqYir/PBzTFKe8oCMN/vF8AlHK2hxs2GwVmxfGjshj3ARxjdZzCIS2LLPEUspIQ9RZmxptFSFFRcSEyxd97fZyGKyMUafm+QL5TAjTqHJNN4Tp+98CaYkpIzMs6OWPksburss/FtcOqePQ5RWrhEKcg/4uBFolKkbrg1B/P4GfmhXseKqQ+HvO7ixpGOyz/QTmT+dXCE7uO3A8hmWvShSqpVbGqKxrGluqSC9vFY/AkAr0uo4Zg/A5DsxBtO4LRJog4B3DBXVVyXKlZYWvWzzDiYQLbk8M1T1DwxnvqPym0leZFQtSU=
x-ms-exchange-antispam-messagedata: IH4J3IiGOP4HVW6On8oCospsEJ0TdggvQjxvp2zMmzoLQtpMxsVj0Ou/eff69cw4PzIgQLQUhhYclkU91BwIsqMIuRCQwNPI1EYh4NalSl1OOQB0ZAKtLX9WWuqFikR1ZCzGcVlPPbx2dM+HRXfcOA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e91f5a-50a1-4c32-403e-08d7a1550d31
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:37.0553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aYBDgHMt9GJZPdWWMWgFJ/J5lc/0v4orrsZxYsmOiOoNcas/zIlsKQyX75KSVosVi2heyPIRfhu4zm/Pi4OMJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Ethtool command allow setting of several FEC modes in a single set
command. The driver can only set a single FEC mode at a time. With this
patch driver will reply not-supported on setting several FEC modes.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d674cb679895..d1664ff1772b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1541,6 +1541,10 @@ static int mlx5e_set_fecparam(struct net_device *net=
dev,
 	int mode;
 	int err;
=20
+	if (bitmap_weight((unsigned long *)&fecparam->fec,
+			  ETHTOOL_FEC_BASER_BIT + 1) > 1)
+		return -EOPNOTSUPP;
+
 	for (mode =3D 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
 		if (!(pplm_fec_2_ethtool[mode] & fecparam->fec))
 			continue;
--=20
2.24.1

