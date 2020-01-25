Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6237214937A
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgAYFMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:12:19 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729255AbgAYFMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:12:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYZ//Pie+0jck73HstbUbTBak2DJgOHU5zu3rB0dreqWfOxNYH51XvzfTcn9+UhckWf0gRK/R3VjUATG1bN6Zw5q4bYKVO0nVuVOg4FSC7ViPQTfdKpGvaCVEbBTWIOMnAbjhjpdCoomkPT+m0x9ANOQWH1hdXp1YRUnkBRE3NKSs1OfDmhRCHKrJs5gKXiXDbzvvQFg2ZDbf9vZLV7uq+OUbv6JZH0mQDApJe8X1dmghyd4U83EEoCca+Oa6YmU01XCT4OpbB6fZsCieT8IkGlOPQX+ZvjDb3XLxSB1tDt1+ildAkZfUAKN798isUFdFgUPEcGTIkGNct7frgT3Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WuHPmnXiQaUwNh5Inz6nFjAZBag46v+DqDSkkQV0Lo=;
 b=OCEeptwS2xTAuhaYAqXhdATc9OMgP4mlGGu08A1Rh6nYeH2vqPRcxhDCx/CHLwgDQYLE5OW3fJqo4v+Qa9r5umaca0il3DEt8KEn88UdJXM3WTkgZTn9vCXnTLMKsBRm7MCzCoSsl5J3/aaI/UxFSo280LkLyrgoBxvoKdvxbNR28vz1vlB+O2m2JoCVN70j/E8GP5Y0DQr4o2/BMzBm49KUdnCsVsBWRHan/vwRORwr49ehNK80h4HhPJu7BXpThuH74gNEH1CljMmzXKVuMxZfUDGaev7j47Fzvw9zmZQcsKPuTI+kjIQPq1ezebvqSvo97j32XTtNUcxS6y6p8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WuHPmnXiQaUwNh5Inz6nFjAZBag46v+DqDSkkQV0Lo=;
 b=tw1cX7U+S2LvQ62VYL9hSzFmwTzoO2OJp4VWzKvgovwr+4hhPbp9RK9DOtK9cQrziK2IhKbFGUVNA7T/qllI2IHtdHARZvEZwfDSMeGFedMSz4dpNwUSd15PuA2wsz4Q8exSt99pyFKN+tKr77dtQ/62kNZvWqoQrPCdqLTzLsA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:59 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 13/14] net/mlx5: DR, Handle reformat capability over
 sw-steering tables
Thread-Topic: [net-next V2 13/14] net/mlx5: DR, Handle reformat capability
 over sw-steering tables
Thread-Index: AQHV0z34xXWrLjvP/kaGOLJhX4Tj7w==
Date:   Sat, 25 Jan 2020 05:11:58 +0000
Message-ID: <20200125051039.59165-14-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 64f2c4f1-f51f-4f4c-7539-08d7a1551917
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0394EAF37C2370A761EC33B4BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N3mT/tTmkJec0VFjO2W0axJm91Z618E5lZ+Q3AADanKVTRb7/Yt43/e9auBMRzvColdzuUceuPXAx8VlWdLzRjhtEwKekHLrjtYUmjzUOVViUOKgLqmSwaEbOY6B0iEqByXLdNWbrDng+g8hvrLpVeqPVaIDmNldpOY9LQRjvqtwphRka46RCkGzlRi9c3mxcenyPRY3NuXdFgX6La4tp1+GDG4EP0VH5pYbeHZzWUeINKT+4uiPZiCHDrfpt1btsd3Gx4bagVFdRHICQ0okbkJGr663mIw9hg1+4xTMh5qslkvfl7DIDZZVVMtglUf0+WKd0Esly1pHXtHEFQhP2Ha4cGdhDJ9sPPM/EYi9rVfXVJLvI2O9OwdRiOwkAWliHFXDkKIXXT1EMhWGAHjR08KMmSuu9olPpT364KR+/AqZbcMsOGR7nq25A4hIIcq19vGi97GyqQfdm4j0QIMd+DHkicYkTYzrZJgXynmc7ssLSzpkGv+NFPFEghKd2lBbIf32QGG6t3089aBHYigTV0OEU+geojWzT9/vdeOJ88o=
x-ms-exchange-antispam-messagedata: Nq3fT6BeSmH3U8DzP0k2o35eUVlJoOjSGMA6hzsquCz9gpw+F9k/TZy8fuMCTjbL3gD9N/nE3wutBh3O+wANLpXsuvtZDxWTwXxNvJTZbyZzq3V6HfAT6KwHiIBU20aUmSC9lARn7sbwBNbjyDJSbw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f2c4f1-f51f-4f4c-7539-08d7a1551917
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:59.0637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4UWphmJTN0hLLKgvAoaj4d2OXjBDMCdYVDC5h3+1KFHbOE1kdsMG+OCXV8j0A0/r8Reb7X+DORny3KW2dV4bxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

On flow table creation, send the relevant flags according to what the FW
currently supports.
When FW doesn't support reformat option over SW-steering managed table,
the driver shouldn't pass this.

Fixes: 988fd6b32d07 ("net/mlx5: DR, Pass table flags at creation to lower l=
ayer")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index b43275cde8bf..5e277cc81054 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -66,15 +66,20 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_fl=
ow_root_namespace *ns,
 					 struct mlx5_flow_table *next_ft)
 {
 	struct mlx5dr_table *tbl;
+	u32 flags;
 	int err;
=20
 	if (mlx5_dr_is_fw_table(ft->flags))
 		return mlx5_fs_cmd_get_fw_cmds()->create_flow_table(ns, ft,
 								    log_size,
 								    next_ft);
+	flags =3D ft->flags;
+	/* turn off encap/decap if not supported for sw-str by fw */
+	if (!MLX5_CAP_FLOWTABLE(ns->dev, sw_owner_reformat_supported))
+		flags =3D ft->flags & ~(MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
+				      MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
=20
-	tbl =3D mlx5dr_table_create(ns->fs_dr_domain.dr_domain,
-				  ft->level, ft->flags);
+	tbl =3D mlx5dr_table_create(ns->fs_dr_domain.dr_domain, ft->level, flags)=
;
 	if (!tbl) {
 		mlx5_core_err(ns->dev, "Failed creating dr flow_table\n");
 		return -EINVAL;
--=20
2.24.1

