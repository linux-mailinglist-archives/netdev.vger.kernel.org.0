Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F23163AC7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgBSDGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:06:36 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:65095
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728266AbgBSDGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:06:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENI9MoFZaxdKbEq6e2JRCubiNmQtLuyo366Gb0Maazq8Zbzpoz02FZgVMkUSf06jJGfhkUCLO4NDunkAjPnZoNy+vpVIykW+WtvLUnaoKXx5qXsJHRqaL6mWd7PI172QAmshQBMcFWWhYp5RN+n6Xmk0eihiJ8+XnzA79sp+Pp8Wm/qVjNX53p6zcqV3m1WK7RgQuguPEKtqZ7A+sHvHTrxo0I1C970TzhDlXq/N4nEJJ8j/Kw77wJ+dPZWMR99KBhlf1ay93kuAA3jCKN+Ya8ba42WFdCtdkJ4AWu96io2gQh4NEvKOCvf7clOuMuZpJi6SdBX71cYFP0cWDXM0gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr76w6UiiRn2gQZF9CU8w7zBgUSa7ZEaE7D7+0LUj8Q=;
 b=kf87c19guf3U1unsek98l/jadFPuBCZIz8fCGs9vWRRSsZwWm31qlO6m688VNlI+1OAsv3b+zapY8JbvZ61gJ+shEDQG2WkzcWDX+ab15IqUZgZy5UVyiHk5/4FtLtc0nbboDQgmgKm0NBNQzqwsDYbrIiYipqk7BjVii7TY6KwlPkY6AP7mhzfL+NFDeeggTlXDOFtDf5o5kYiVEZvlixNnQ6iwqLIWaHf4iCtktOUxQCRYH77BEftlCXYyYbaWcquTVDt4OuB7FViIWLs1nkBNj/4xBpeDUj6sQx+vvnhReSgdn60GPmPkacBUasVIzNapDldsQpeos9LAw2Xvcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr76w6UiiRn2gQZF9CU8w7zBgUSa7ZEaE7D7+0LUj8Q=;
 b=qfwxaZnJjfMOykzhjkgQKYx0la5eGNAbzl+fq0KH3GrdRilmE7jwjol3gO96S1T+OF7Wvg+/9gVz/bRx54+SD38w/73kmfbbf1RA98VAGdfR7QiNgdR1UNfnqB2WNYCajl4tSoYmOy9sy8mdWJ+bjO7cT1pCsbno674m+TTLkr4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 03:06:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:06:33 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0089.namprd05.prod.outlook.com (2603:10b6:a03:e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Wed, 19 Feb 2020 03:06:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/7] net/mlx5: DR, Fix matching on vport gvmi
Thread-Topic: [net 4/7] net/mlx5: DR, Fix matching on vport gvmi
Thread-Index: AQHV5tGWaN0CXCkVQEujPgXCXYi3ww==
Date:   Wed, 19 Feb 2020 03:06:33 +0000
Message-ID: <20200219030548.13215-5-saeedm@mellanox.com>
References: <20200219030548.13215-1-saeedm@mellanox.com>
In-Reply-To: <20200219030548.13215-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 367289fa-8731-4b65-463f-08d7b4e8b931
x-ms-traffictypediagnostic: VI1PR05MB5853:|VI1PR05MB5853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5853F82B7BDF1B5D8CCFCB58BE100@VI1PR05MB5853.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(956004)(2616005)(5660300002)(26005)(16526019)(81166006)(52116002)(4326008)(110136005)(316002)(6506007)(186003)(81156014)(2906002)(8936002)(66476007)(8676002)(54906003)(1076003)(64756008)(6512007)(71200400001)(478600001)(66556008)(66446008)(86362001)(36756003)(6486002)(107886003)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5853;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51UeSiB72w9I8YH3cYPhGVg5tZ6HwFfm35smtRJSq3QQOOxZXFhGhCZX23MPg71YJSSdZYSA/czCjEnXPmI+BkkspNwAFapF0EV04VkJJkzk4hrDXNY1dlUDv7eq6oifdb8ClJaCHyPBJofP4Wf/p5E1X2Dou1wPhhJOrk3LbO+yrHrzf+wlPfK5FyWpyoUmPL7K3LO8ZLMQQVdwYjxUhCW8xUjcU1Lzg2m3z7PVYW1WWj0mGSS+vqkWO2OTb8CYHUl1r6Cwzo8gpKrhn3d425WaEEhKCkH4U4CoDhe3BZUObIEeV/W1kQWaZmheQYaMqiTVdQ/tQkXB+eFbdjHIK+0KirXctyOsmdUPeyKsUew/mjiDCpfMWAH5ImN5InNwP4+tbTQhSkbhghd7sC9ay3HOr/ekWcAfxu1HVTi66O6qQSKUyhJhU+Y61GH6YTWsxCRefC2stc1Fj5Tul2lFvP7l+NwG3a6J2Eo/gL1HZNcZWr9w9hSA0JREZjMoUu3wA9tBAybZc3sDz3Ms9FNn5GvM3OO7epInt32VedhkuK8=
x-ms-exchange-antispam-messagedata: GF6hSL0iVs0Hn/lsyHDn3gFNFT4lI+sSzrX7QSLC/9Ck9Gv3azo5MFX6AaxQKbpIMyzLtS1sY8aS1xNklp0T4WBeZz4+zS3BsBN+qANJmpMlb6WCqKABuWmrbfIR9dZwoQNuzpwg8Zwk+gp+kKhz7w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367289fa-8731-4b65-463f-08d7b4e8b931
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:06:33.0639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3pXj1OxUPzdNHhaCVUTrXADB6REwGBFGVhXhBRB6DhreK6CFMo/EKF9fndv5/6XMhp+zBO0cpcxOvz+rRbC1sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

Set vport gvmi in the tag, only when source gvmi is set in the bit mask.

Fixes: 26d688e3 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index c6c7d1defbd7..aade62a9ee5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -2307,7 +2307,9 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5d=
r_match_param *value,
 	struct mlx5dr_cmd_vport_cap *vport_cap;
 	struct mlx5dr_domain *dmn =3D sb->dmn;
 	struct mlx5dr_cmd_caps *caps;
+	u8 *bit_mask =3D sb->bit_mask;
 	u8 *tag =3D hw_ste->tag;
+	bool source_gvmi_set;
=20
 	DR_STE_SET_TAG(src_gvmi_qp, tag, source_qp, misc, source_sqn);
=20
@@ -2328,7 +2330,8 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5d=
r_match_param *value,
 	if (!vport_cap)
 		return -EINVAL;
=20
-	if (vport_cap->vport_gvmi)
+	source_gvmi_set =3D MLX5_GET(ste_src_gvmi_qp, bit_mask, source_gvmi);
+	if (vport_cap->vport_gvmi && source_gvmi_set)
 		MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
=20
 	misc->source_eswitch_owner_vhca_id =3D 0;
--=20
2.24.1

