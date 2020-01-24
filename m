Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92597149083
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAXVzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:25 -0500
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:49114
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbgAXVzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAYH7qldzm4Um5DaI7z9jR+NrjPN9eCNBe9xebsgWMPIotuEkHWjuH25YQQwC9Y4RLkmOBHgTBXkaJHUqm7w75ROThI47siwyRBQLq3BdarrRjedpwt+iLX8J/a5EvBCz/YMKlHlObrrRYJNRClt14YNeWWSxYL4wC7gZoj+qMjy46Onn1J+m/LAKE3+aTKmqUr+4EjwsjNbt8xXghaOr2Q8X2e3gOPpxJD9D/LXsJFHgx9g2dRUq2wWlZj+BY4g4IEvVOQini8ghGLGxt8whTUbK9j/WdsWtdHgdBjc6ipnV7OY9qN41gho5guK6U6yl8xIPIBIOy6kfjZvZFYXbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3x2pFfyESIyobL1mJ9/Mp6CQ82E4j5XbiQdvAjGnA0=;
 b=V6XjUzrg2DGQkAKcON+03kikT9iOYtzOGom2i6Cj5Ae135mL09LoE2KJpCxx7dQ3J6BrAunD/hrxm4gg35STRfeHJBdcSXp11Yy5YpcPtbkogdwu1ppyrgUq7+jpZjzF86vxTzcku2t0tsnV7bJbUW/zVF4SpA0FLWz8oZxnNz4dVq14DvNAoy6QHsfBdVGimqAandLm9Oe3bATbpzdLvmbYDu1R/BQ8Jg5xerDLN9QVLjFMX7GtzZqOGGJAJTxWbQaQqZCznxmbOwN9VbLRq0sUzzVuszXq1rc/Optk8nGNrgaXtzl/c5u7eHfK/Oo0JJO0FWHrkPIoCI/Xhk/4Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3x2pFfyESIyobL1mJ9/Mp6CQ82E4j5XbiQdvAjGnA0=;
 b=A1FAacmI2k/1Rn1JwAxaPvgkZLLOhSH8wG1yD9JW9kaFXz3RTGigqthOgmSxVh2mUrOMztmkCmhdOL8mDi2UbIDBcfJFy5ZZIL3pLuaI7BPfRtcjlXI+WUq5fKXKOh+xY+Q2XiJLXI9SMQAfHZScMR6Rl/jPnSy2sQdrPJqq8nU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:10 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/14] net/mlx5e: Enforce setting of a single FEC mode
Thread-Topic: [net-next 08/14] net/mlx5e: Enforce setting of a single FEC mode
Thread-Index: AQHV0wDzUfOAResrikytAQEoSbuMsg==
Date:   Fri, 24 Jan 2020 21:55:10 +0000
Message-ID: <20200124215431.47151-9-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
In-Reply-To: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d5ea733-7871-4883-7c7e-08d7a118153b
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54566552A9704EBC0D974414BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(6666004)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(4744005)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JerIoE3jRw1iMaNZeWvVZBmyDzAAITd/F1T+VLo4dvz4ojEkEqHrgRqjYYqdtsDVA1Q3aqsX149aqIeZQeUfvYIhc6r3VVohTEbaaNKfs3p2Zy+1owMrsx8pHa8ZhgijMt5D/bIV8qGxcgPAc3wBcJIfhXS7lSTmcvxCEagIzgOKUx7VX/1qBMV7mNeZLWKDbGY6PC3sXr2D43fcXsZsZvqkbEJrx8CMk6vTWA0ghd9mJLAxz+k3vjLgWvrpKW7h6cz+ljpAycGK611XbBcLp6hPzwCzlkIUx0EzDraMO482zqF/LQ05g3v+eC8oseaEKcBhIEhcC4e7gdUf2cMFVj3iIyxkZsbiuGky+7h5XxbXTrdu65t005lGGuWtuL4IgfaLWDtyf1G4HbOiHrorbvRbevFiERSngjCS6P4Wg55SDPztMq4WKyiAaUXAe52kbU6/dZIrm5cWiCWxGOhy9mP6DxMJMYECE+D42Fa2Way4ArVirhcf2+wLsTUGypyt/qc45QdZr4nFakOKwOomBZorfJCDgGd/M+zPnk6cqPg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5ea733-7871-4883-7c7e-08d7a118153b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:10.8049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wsZWGgnriEO8u96SyhESS7YQ0H1Lb1mScJSx4U8KNP8IBlO3qAbgg3CsBj/ei+kxU8rNR82+fq24NWh8pwcTpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
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

