Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9C6132F18
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgAGTOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:12 -0500
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728307AbgAGTOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l688MNzPTkymXHhNmofuhYi9JU9N4zjHkM7hTI+aqaa6rjOERuDOYfgiYYxFa8DWDC0U6XnDltd2wM3HF5TGsMamN9jg7iTFYMAQ9yYrw9qDgyDhANYOAOVaCiAAnl9IXvO4QGICA0R8V+XibMJdqclNGjr7Gr9qP0ZMqH0wRvHzh/BlYipRxX4RCk0aBTRv9xQu+XY2AY30aEgkqxasdH0asGo4Io9RGyXhZBB6Ai6rIscPK9bF7RKT+ROK4rs2DRSvQQflCRXkXobHL4u3Jl6SKk1XlYksHmVrtMS5W32ftNlkPEmdhhxYJoah7oY1RH+r4CSQ96g0xUhBSxfjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dH2yFRgMjQON1KULt7r5zNES7a4+dC7ygnAsgjBIDo=;
 b=UnyYcxgfLAHKIVdMUsmIv6/xOt5kq9fbdrQ+/KicUgklO/GkHYXeXE/dEg4RmMRLZZQtBhtwWSFi4k+ahLRkA0DPur+auNB5zhJxLPQHXMLUFs90CTgv6SEzrPmP3nJ0AEAqLxwGXexOXe2HiMyR398JBD2s8ZC0lVMbZRkfQzM50vTjhfnIzN2z8KnmiEJBjNSZsCmsAa4tTsnGrG4dViaUf52HwVL2CxYQAo3yLIypAd8jDXnJIX/D6PyWYmtdQI26HqdAfN2eia93Uv8aI/8B1cN5FVbJNjvjrTVE9x3RR2wMzgK7G59brwIPhAJDJjUf0rTxAtFQaOMZum6h0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dH2yFRgMjQON1KULt7r5zNES7a4+dC7ygnAsgjBIDo=;
 b=Jbi7Vg9Dt+YhbyRqQAGpDAePK7cmaA7zigm/ahVLdSVO8NdkheDlx6nRGekwj6sIXcXg1m9ji67TWPPTVUISfocFiSrbx5ljt8Ag09mPE5szSVALkB/elAxcUEVnZr+mBxZRLlWbjuXDBnS05CN56KG43nIxVEM6MYYMiNyWy/4=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:07 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:07 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/13] net/mlx5: limit the function in local scope
Thread-Topic: [net-next 01/13] net/mlx5: limit the function in local scope
Thread-Index: AQHVxY6h8pBaSetOc0yg3zNmK7hxOg==
Date:   Tue, 7 Jan 2020 19:14:07 +0000
Message-ID: <20200107191335.12272-2-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9e865a3e-80cf-4f82-6ea4-08d793a5c45b
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411A49E75C2536A47AA365FBE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7aB59DS05r48LOxEcD0/XrGypbj2icd5Nzqrrylzw+t73DopJQa8zw25Q3dfXYUve5BHBFPFK/HfZjGMv0R6tbHzEdspyhTgqzE6IlvJdYZ1Iph5IIcR02Cr5HGWpY1ohKJgRHpsBuXACxrLTFNtM8TwXr+W/Bzp2Qo5mjJuGGnFwoA4pFb8Cl9z4qL08I0c8GO6WlMniKujIftMYjqX1dYmPraMpM3wLV9lKHFa6Kkrz/ZZcx0lBSRilbCGYS9pEKbXEoZUYYVC7VhT1qX84ihRw7uZcmPh8ApH5TGeOGOcV/jaa/WSVoL3JVB4HrWLRFqEUOSevSFgtA/IHJ5Cj3jvj274iX+6M00CBlnFk0Z4WRwgObdsR73O6vBdnsTh4sT/baiZKjKIWd0yjWfi8GscsaYyWJ3zZkzunYXjC4E7icz6bO1bs6rM0JKcELlNvA3V3OAuDnXwaMoSzYEnIG4VmZzYZDSQQyB/PVosg2HgfpLwu6br6xEWIXdC5BhBLAFUEq3ZR5OYQaDSH9xt7dFpyAu4bRrQxXkAoabUn+M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e865a3e-80cf-4f82-6ea4-08d793a5c45b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:07.1746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YSquotchNLzDp119oln4oz2T/ilI9iha/H83Rm50bqeyTXlLPAaGnpsmEk1fpIwlBJkzkS2SItmd42hMdbdFRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <zyjzyj2000@gmail.com>

The function mlx5_buf_alloc_node is only used by the function in the
local scope. So it is appropriate to limit this function in the local
scope.

Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c | 4 ++--
 include/linux/mlx5/driver.h                     | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/alloc.c
index 549f962cd86e..42198e64a7f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -71,8 +71,8 @@ static void *mlx5_dma_zalloc_coherent_node(struct mlx5_co=
re_dev *dev,
 	return cpu_handle;
 }
=20
-int mlx5_buf_alloc_node(struct mlx5_core_dev *dev, int size,
-			struct mlx5_frag_buf *buf, int node)
+static int mlx5_buf_alloc_node(struct mlx5_core_dev *dev, int size,
+			       struct mlx5_frag_buf *buf, int node)
 {
 	dma_addr_t t;
=20
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 27200dea0297..59cff380f41a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -928,8 +928,6 @@ void mlx5_start_health_poll(struct mlx5_core_dev *dev);
 void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health)=
;
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev);
 void mlx5_trigger_health_work(struct mlx5_core_dev *dev);
-int mlx5_buf_alloc_node(struct mlx5_core_dev *dev, int size,
-			struct mlx5_frag_buf *buf, int node);
 int mlx5_buf_alloc(struct mlx5_core_dev *dev,
 		   int size, struct mlx5_frag_buf *buf);
 void mlx5_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf);
--=20
2.24.1

