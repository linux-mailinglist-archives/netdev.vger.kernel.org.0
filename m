Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA17A14620C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAWGkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:00 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726376AbgAWGj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naVsxZuCx665OjpTemR5eknjVkH4vajTIewDz9XpY8eEnDZ4Hs6dH5VK1WgMfMTwyfIt02CoUQuK0PBxrVxlrfLmmZpZpb7yQ3rNGJm3JzEhoytTX2iiBiNIbWHHBh4i6+mFnR1LghODvLgB5vLyVVvqKtbeZZYGwLfK3NP5JphKWaWfi6GzSZVV77MwrWzH6PhkEGMCdxGAlr+HkAFXHh73u0ZwFOE1slrGukGWExe2Kb3bnGzOE+dLcl5SZTYHwZUdYSlGZ75fkUBI1EqHJ/S3dKF/iWPA+/J29GJd6wp2GqbB1VxExDXfcF28R1PcOqkjQa+4RQ9nffnONjQi4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=be4mN7UFgLz47s0OCUrX4K/BpWWV0MClktcQLjficzs=;
 b=YyCSYf5kgzeIHrdVBzJY6VPn8XEdeTG/iOK2ljkqjJ2mt6bfVHV2jebCaLy68dmogQuCAHBnxN9onqPjAEx/YXInVWE3wg74LNBTQMsHJwUG1PIaI94YlYDjWqRCbXVOTnS2saEd1U5wukCquT+7pQM8Wk/F6GhzPd43AKfkyi3AySeiH7vRpqiNwvoeRIKd9bV+YzL3N2zag70L7//0aXOyxMn7124s8V2mHMxfZI4tk9WHjowgGF6q8nobBpwcOqbORL0Xy74I4CaWaqnv9vBoiut8MYgShRrDHFcCD5oStpJZ1XAJck9aw1wMS1luqsQjV1IDI1oRM0ninOgysw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=be4mN7UFgLz47s0OCUrX4K/BpWWV0MClktcQLjficzs=;
 b=E/Pd9q2KkpGm5J+SEnJ7Be6Nc49GsSKXreqKyoEZBUXKWtnQhXYynwHm2oXXukkzlxPr/q5JwNDi2RUs/ITz5Clo0yL3GhFjFzWSxVS7I407rUsq3a4gTCLv4RVwz2quE/ZIgtTn9kXyoEjFmyE49zPjmmPBcRpjgLKZ0c+RJ1E=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:49 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/15] net/mlx5: DR, Allow connecting flow table to a
 lower/same level table
Thread-Topic: [net-next 07/15] net/mlx5: DR, Allow connecting flow table to a
 lower/same level table
Thread-Index: AQHV0bfoFMjiG54rbEmCoI9qhNr/Jg==
Date:   Thu, 23 Jan 2020 06:39:49 +0000
Message-ID: <20200123063827.685230-8-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 713086f8-61c4-403c-3f1e-08d79fcf0b59
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4941E11CC3D18DBBE79FC2DDBE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tV7iA/3ILzVAVuOssJwiZhT6WqK+c6HmSrfhfZgfSOzQzjh8CkKUp1Amzcoxg/gboTBtXPT0MCMjwvtK8NBYn5uLefQ7uJw5Z2JcQwBpXMo8nvdzRSq6XDni4ZrpJS5BsSTgOzyLQfQujPNUMA0dF0ft58igKTTXd5Ezj0w8UVVlQlXTi0Qkgxeiv8LXXwziTu7Y9g+4Fp/u2IaNVgG+jXURUCNzDGMznE7aaElzqiomrVgqtNWu+52+F8DTQiC6bo5zGy/lpmGwrUZpnN/TfsNhdZUUvS7by2HAB6R49V2u5U+erHVsWRIaykI9378Srz1QFSblpmOqbUTpdGOVw1puXBQB8aJewGEwzlRQnyuBxDrFa8Z4ABboklwzGPl22X0yhJ1ETsunzJEYr2oOQHsLba4vnAzDKUYTUpZJO6p1ejlo5qdjo6MrqGSkxU/WG4fPeNNLQe2cWc+BayyN+JNsiSooNFpAvfFvz/1QoyMBOoUNe8g/GYHQq8JTH3gs5DUw+JNFqq9zSkQjld220+wjdKwC/R27PdCw7DMx3TQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713086f8-61c4-403c-3f1e-08d79fcf0b59
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:49.4978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nwEtTvQmJYL3ABpTKawajjcto8yPixl8B/ZcRpUZe8Y9D9PdAPfr1O9g+FeBNrCHTtnG26TF+A+5/WSdbJcLSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@mellanox.com>

Allow connecting SW steering source table to a lower/same level
destination table.
Lifting this limitation is required to support Connection Tracking.

Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c   | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 286fcec5eff2..6dec2a550a10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -677,9 +677,12 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher=
 *matcher,
 					goto out_invalid_arg;
 				}
 				if (action->dest_tbl.tbl->level <=3D matcher->tbl->level) {
+					mlx5_core_warn_once(dmn->mdev,
+							    "Connecting table to a lower/same level destination table\n");
 					mlx5dr_dbg(dmn,
-						   "Destination table level should be higher than source table\n");
-					goto out_invalid_arg;
+						   "Connecting table at level %d to a destination table at level %d\=
n",
+						   matcher->tbl->level,
+						   action->dest_tbl.tbl->level);
 				}
 				attr.final_icm_addr =3D rx_rule ?
 					action->dest_tbl.tbl->rx.s_anchor->chunk->icm_addr :
--=20
2.24.1

