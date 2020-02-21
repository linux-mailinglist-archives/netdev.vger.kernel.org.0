Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C37C5168974
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgBUVqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:46:01 -0500
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:9220
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726683AbgBUVqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:46:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbiN9Baxx4jClsEYhMJB6rU/9Y7dol5AFhFZPg3SgDW9GLdJ4KHmYPKZuvg5abTlYc8hYbyQLZ864WmuafkFqTF/AJhzTq+r58MOukQIhau/gbVsE26UNPP4HAier13zUarPUsgSNlZMH+kMB/F2nUqo5s3iT9Qwu7sgzk/VfRgBAp3WbRJUGqw+1Ti5NdXosMPn8Q9Y/15oaLWMjnNLJSN8qSD+R+jBzUsWg6vV/f/zfaPaldNTuQ3cqnfs+phkDE+D369og/6COd8DbX6AvRmwdeJyT6Bm4ZaIh7DKe9VEk8QjD/COgoSgIBWevDso0er+/6qUX5oCC82SBcZREw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp3i1OAAaA81g2C3FfDJelt63tzEm6N3e10V9eBnU2E=;
 b=GJ5dZMq5dT1dFDdJLJWT0ULEMba2Rb7DHA60OCEpmZjBksGAhwI9RKw8EgcqEXJLLNMCrzMnE3GRurLPAvFYm/9TcKIEm0o2M0avDhXDbAW1uO8QvViOJuFkFdt95n5X+bow8+uDjbWXy+LSsk8DpDQq54GwwOi7Vvji6dtnn7E3O0sV0p/WayEOBFHiTkZQpSXcb3hsVtEFjeVSlm0biLJbscOsK8OUnzqkElpD7AGZbHN4bdM1xASNmUJQVcgiEDuT+8TwOoSNGcHBBXknNKbSKdGSGL5BN7QGakKjXtltAp3+VnuGiLe1+xK2yIZeTbSkeK9ZOqcuMcvH/izStw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp3i1OAAaA81g2C3FfDJelt63tzEm6N3e10V9eBnU2E=;
 b=IZNBs6ItzHaOafWcN9L10yUJaRsniaKSHiBvAd4idRt/6S+Ctip/MdmflaCwcolDX3he1PxXadTFxaJOmo6iSoRko9SVzyO4gdNO933YKp/BQdofI+TIwxwjJEuy/R57r1y4a8iKFlBkRPFibVtR+zD+s0Snbz1p4+exdVqtZYM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6927.eurprd05.prod.outlook.com (10.141.234.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 21 Feb 2020 21:45:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:45:56 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR16CA0021.namprd16.prod.outlook.com (2603:10b6:a03:1a0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 21:45:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next V2 0/7] mlxfw: Improve error reporting and FW
 reactivate support
Thread-Topic: [PATCH net-next V2 0/7] mlxfw: Improve error reporting and FW
 reactivate support
Thread-Index: AQHV6QBKHE0mIguPOk+tRVCWWvGzqA==
Date:   Fri, 21 Feb 2020 21:45:56 +0000
Message-ID: <20200221214536.20265-1-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 8fbde043-c730-43bd-1e99-08d7b7176d05
x-ms-traffictypediagnostic: VI1PR05MB6927:|VI1PR05MB6927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB692779997F7E5C271164B064BE120@VI1PR05MB6927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(186003)(6512007)(8936002)(54906003)(2616005)(316002)(16526019)(956004)(4326008)(478600001)(107886003)(6506007)(110136005)(52116002)(6486002)(26005)(86362001)(1076003)(66946007)(64756008)(66446008)(66476007)(81156014)(81166006)(5660300002)(8676002)(36756003)(71200400001)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6927;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gwlTK8XsLl8/IeeQsEQ2iiR2lxsr+50Z3sJHEevvdEoM2s/0ezO3PAH891s57MIqwww+WmJaoyixGrMVYYBM8szACFXL0MUco3sT1fpf3CE2ortFzFv2TqvhxjBTorxv74xfmvAy9FLFA0xTl2FlyM0mlzc5O3dCkANlC70R2YVSo0fNN/DvyVtKtYL19IG/L/OxoTxE/GsDKAi8XM1MuS7FdwkARQL7sbFERPYxQws3IHWTNt09ben8GKgTUmzlSm/4r9cY81DX8nDmtoUv1WjCo/XiEsSi9cQZt5hDlGrW7exKeg+rfYSf+jSZTbZ5W5uW2UMD9GeGy+vewIXApsV3kYGdwfC/WCJT553ZX/YLv/D52hMeVtOvuxxbG9V84uIKlVZXx8qdRlUBUEuHILYrEtGlQXdqsKd7/e+FByUp+5Yob7Sn/JRFJ7FMJkaQHx9ukbkwbXzcCu02xGC+ZDcAvI1bkTGLCFUC+JTkbMjASxXWdxNaqgkO1Cd0QUltIz3/y6ItfxCVFnaSr3Zh+3val+NipczA+atp9imPJG8=
x-ms-exchange-antispam-messagedata: LBJGbEilcWXjYVADv+3IszgXdttHRWAKv4lNbDEzrP5mB1i+UKuWB3qSxNodVbP9QbaGxIzXX/bL6Mafn2xKxmmVqCoEWv3J32anaDYQk4OEesx00uQVCTsA+GRsHS7xLhnq+A6966AsNK5NjesCbw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fbde043-c730-43bd-1e99-08d7b7176d05
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:45:56.2762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V86dsW3YM7rDqw30HLbiV60UUHhA8r4oqNJlYMvf7vh27neJNTBlqRcuk/bEZUklF01Dl7iYWPbcjhYBinaMNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6927
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves mlxfw error reporting to netlink and to
kernel log.

V2:
 - Use proper err codes, EBUSY/EIO instead of EALREADY/EREMOTEIO
 - Fix typo.

From Eran and me.

1) patch #1, Make mlxfw/mlxsw fw flash devlink status notify generic,
   and enable it for mlx5.

2) patches #2..#5 are improving mlxfw flash error messages by
reporting detailed mlxfw FSM error messages to netlink and kernel log.

3) patches #6,7 From Eran: Add FW reactivate flow to  mlxfw and mlx5

Thanks,
Saeed.

Eran Ben Elisha (2):
  net/mlxfw: Add reactivate flow support to FSM burn flow
  net/mlx5: Add fsm_reactivate callback support

Saeed Mahameed (5):
  net/mlxfw: Generic mlx FW flash status notify
  net/mlxfw: Improve FSM err message reporting and return codes
  net/mlxfw: More error messages coverage
  net/mlxfw: Convert pr_* to dev_* in mlxfw_fsm.c
  net/mlxfw: Use MLXFW_ERR_MSG macro for error reporting

 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  40 +++
 drivers/net/ethernet/mellanox/mlxfw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  50 ++-
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 296 ++++++++++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  17 +-
 5 files changed, 308 insertions(+), 96 deletions(-)

--=20
2.24.1

