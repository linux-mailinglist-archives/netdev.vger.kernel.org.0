Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2DC146208
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAWGjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:39:47 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:52999
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgAWGjp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjDjBYdeHlbxeuYQg+ElND+CFj7vK/lJ4J7e1BxGvasuVLx6g4ftD5fPiRR++whFX1FduaqZhrwiyCWaLpBN/4CwRCdcsY+nxQJds4/e/vTL67oXbHkelg4EQxpsm9kfaLckbr1yc6NExZrthM8hoYdvYyI34snP34U4io9Zm74wNdAwrFtd6I/7hBBUH+hxJJ+6SgJ3NiTJHfyiwWNzUCu3sr2WPMa4VPmdSN2oz+XlYQVZ6X6zdrzpTQSc4G9DQu1Ldof29eOHxu+9EINk3o6AHQQeiV/4YBbTe4g8UVrWvL2eQ8YtG5aeJMzblmqw8N+bHYAV1emZq5mVit5SXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AsBkQxZogsvKTtrd5USG9HtEaH4Me4Jb1a2jbM9S3o=;
 b=cdOALG4zGVtsxvlDRLJbXjP2MrJtjkeECfREOEZ+UTe+j/aHlsZnPFNBtTGB7RDcjhqu/mDGyMkfnbo9vdjS6EiHOKR6wBVxn/GmGvTHYMe602l1iwG+YvAYvhELYYOt8EXNClnpqceTJ3TNuQboZgmU+PqCmrdqzyioqcEUL1lkJOsqC3uUdmgrbxtkaVWtVFHMZ6uoOrp19+v4DQd8lm1c+Y4pr28ORrBWAEXBLqDxsbVjWuK5cZrYlvNj6hT6mMsMdrxF66Z0c0Jmn3aykcGAROTm1vsJQEzFNK/e806jr9Kvdk+tQnIYl58RT7/SHIBfE/UeyNVtVGozEQlysQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AsBkQxZogsvKTtrd5USG9HtEaH4Me4Jb1a2jbM9S3o=;
 b=d4jRPMajt9uHR0x5AH0D7O1NKsxU5UYHAIzp1Z5gBWxwtsdqwWgC4mX5/3d4kTPaUUUmclVYsW40rTPKktahoG1PHkSPr89w2XX4aRTBN/o5a5h+h7uPBzvsfL1d1OrUkYeBrB9QP0rGICwT7UpCofhKaby8M6vD1XWwi5UrAsc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:41 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chen Wandun <chenwandun@huawei.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/15] net/mlx5: make the symbol 'ESW_POOLS' static
Thread-Topic: [net-next 03/15] net/mlx5: make the symbol 'ESW_POOLS' static
Thread-Index: AQHV0bfjkmAJXSZc60OXV7GLz6jFMQ==
Date:   Thu, 23 Jan 2020 06:39:41 +0000
Message-ID: <20200123063827.685230-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c22d9dc3-5953-49ec-cd43-08d79fcf064c
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49416F47DFEDA0950485BE24BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(6666004)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: orrEP4QRjdHsAce229ujkM35GWiqpIDXN8GrHtCyA9JkSlDU6WnlGRc49xEnxPztPZhThIjYQMZ5DM5f5/GwNLI+zT4e/wMIrWLOlCCMBxSAT8Fx1bQuUfMAKWoc/ik6hmPg+RP1WIvbdKu0tEvvtbsbd0KhfFiy28Y3pB+I3TlB0/cn7W6UwPrY4z1pWhn178gpQGQdQ60af7zJtfaYpjHrFTdBLb8S096e+Gcq2C6XTqcxl9XLNAgzriJc1gK14CMQaKwy77jqVUp450umQJSVZtT07mLsCPbP4u4468E0GTSwKqoyb9dLuDWnfLTwTBhQ3hYJQA1zxCFktrM8nvLftPpVr1tLT+daccn3OhHO8sCaBp+DmLlaxd18Rwcdrghp911uGkbUufj+zF27t/Nnk7yow4NpJ9oi2YiPKE2qYScwXK2hexGlrEcOJQr+XgoWgP6/0I4KxsFvAVo71NCO8eNs+N3+4kohW4K9fvq5d36biCuRnd5tiRyrsnZ7ZGLpcLlD1+cYXc00g1npc5+Vo3CcGpd1xSb8UnBW3d0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22d9dc3-5953-49ec-cd43-08d79fcf064c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:41.2525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FtoBusfqRX/WV0q2vrH6d0h1Hf0KBMH6xWOdH62Q6QebCFnGNMfDrZbbyAgFkuOGaeQtfDwJomiHpAYH/WhR5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>

Fix the following sparse warning:
drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c:35:20: wa=
rning: symbol 'ESW_POOLS' was not declared. Should it be static?

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Acked-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chain=
s.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 3a60eb5360bd..c5a446e295aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -32,10 +32,10 @@
  * pools.
  */
 #define ESW_SIZE (16 * 1024 * 1024)
-const unsigned int ESW_POOLS[] =3D { 4 * 1024 * 1024,
-				   1 * 1024 * 1024,
-				   64 * 1024,
-				   4 * 1024, };
+static const unsigned int ESW_POOLS[] =3D { 4 * 1024 * 1024,
+					  1 * 1024 * 1024,
+					  64 * 1024,
+					  4 * 1024, };
=20
 struct mlx5_esw_chains_priv {
 	struct rhashtable chains_ht;
--=20
2.24.1

