Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7079FF215E
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732663AbfKFWFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:05:44 -0500
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:38020
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726957AbfKFWFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 17:05:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYE1tR6pDwXPPGZTpSemWQT0gzy6nHFbxzVgK4WVQFUwYMpcvvLZ8JsRLCPLcF+plhrZOwIAKb2RTKGQYkiKl5vPDxb5bYT9PbpqNrMKJ8c8NHbRyoWNfON7NIQqBT4e8nkh2XZSfU9oddJ/xQQJSU8Mmn5y9+S/FQretQROq3RsZL3beUaIYczZkvOtviBNH76FmaEcUOMMP4jwGyDQLsj0oKe5z1wnVzJji+AwFfJNqaoGavxtkMlwcMKJVxXRjhG4/z4uvOq9f67dOl8q4XJHz8K1IikQ5KB9WLXTnqiDiCHw3TjQ73GSGxjsCUs4fZJuo02W3nTcP5BaNuns0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dhU0kicfw+TYomq5Ae7jEMGQgH1qDQ7imwDlOhF1sQ=;
 b=HPjGsqHio4wlzLUeqfit6QFxSHEwGh+Q30drKu3v7d/Z+rrKnyWQTg6sTb6c2oCPS2oxeXkQJ93VhIEO1L9/OTPFCfiojJhqfHMd1WqklUQAz8dgpisecktbCKlEEG1gsdKIQQf4doJE8NTCyHv16SdrZlL9zINELB21q0VWSGzOEYc96GsKJ8lJfuSJsVjqmH3BCUkpMsK/7iIMB+Sl/jz5btXxjASPfRxnJmOm4zKyaQDsnHPKf9oAAlEp4pp6rYMhK0gz7DXCW8LEq+jE34zsa8Eu3fqNCBj72vCQllMhXG0ToMcGLOIAH61hPPSzVwBcHVYb5BC613hixgHZJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dhU0kicfw+TYomq5Ae7jEMGQgH1qDQ7imwDlOhF1sQ=;
 b=TgWgTBZsz21gVp6kEyb5uJ5GXHHyUHTh0duG2IWyAqDZUrKYj8qYfmGD7mHE/cTzZ7u7Ahe7Rqz8Nm0kaPpa0mflvcjSaF1AdonJ9B+3/+KnzRloo6q9+OLBURwabjvWmU6+LkRMmFKVfk1vOuFWCusZCqeZGeQBOUAZZrjYzvs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5549.eurprd05.prod.outlook.com (20.177.203.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 22:05:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 22:05:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/4] net/mlx5e: Fix eswitch debug print of max fdb flow
Thread-Topic: [net 1/4] net/mlx5e: Fix eswitch debug print of max fdb flow
Thread-Index: AQHVlO5TgTDZHPzIsUC4dsNNzkxCZw==
Date:   Wed, 6 Nov 2019 22:05:40 +0000
Message-ID: <20191106220523.18855-2-saeedm@mellanox.com>
References: <20191106220523.18855-1-saeedm@mellanox.com>
In-Reply-To: <20191106220523.18855-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 537e50d7-3079-4b28-70c4-08d7630575cf
x-ms-traffictypediagnostic: VI1PR05MB5549:|VI1PR05MB5549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB554919330599F529B7D54175BE790@VI1PR05MB5549.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(199004)(189003)(66066001)(71200400001)(6512007)(6486002)(316002)(476003)(25786009)(305945005)(36756003)(14444005)(86362001)(66476007)(66556008)(52116002)(64756008)(256004)(66946007)(2616005)(11346002)(4326008)(446003)(386003)(26005)(186003)(7736002)(50226002)(107886003)(478600001)(6506007)(102836004)(8936002)(1076003)(66446008)(14454004)(99286004)(81166006)(5660300002)(6916009)(486006)(8676002)(81156014)(54906003)(6436002)(6116002)(3846002)(2906002)(76176011)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5549;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zdxv0IDatJbXUU1E26rtZ/K2mvu9NnsHpkgqTsViSnfkOa4AB+wOlsDMIgZsqSQaRO3hXJR8ABbdJ0g6SfOslRTRFAviA7MmrYkPHrTigHUbijmSbdrsQgvrbAt2X5KBlm0U7o6tyNumm2m0zDjGeqdzIvLWfySv2xSZy/mTxSa0ZB2OWGotB7Z/xogtte3Uz8g6FEw4b4+6NJ3/b5oVRWEMATvBSrC8oPHpF7KeAVHUGyIjY2kf/5kX2RHQwhEY5B8c4VuloV9C20BXX8SYhJqRd/Xx4jnTGz78oJDURQQihAMngTYZEmqyCYl56ZExJ0b/N7w0Ya0Ah+5EDTlmeZDY3EwuzUyLiDB1MxnBblQtPpi8M1x6zMlIWoBDVvcOVw/P4Tw89ypl0h1MNaZcZUQ2l7TiTdGS3Fi1a1pTJhaKJtFhx9CY1etS6+Ft5g6p
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 537e50d7-3079-4b28-70c4-08d7630575cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 22:05:40.1648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zdTgK+JI5JBJ2X12cH5xySz2GsS+/gxaiNJtyxJFV3zMMqFkNQERGCCO4Q0vZ/ctqrDBLgtBzA9xx+xrOc8ZvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

The value is already the calculation so remove the log prefix.

Fixes: e52c28024008 ("net/mlx5: E-Switch, Add chains and priorities")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 369499e88fe8..9004a07e457a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1079,7 +1079,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5=
_eswitch *esw, int nvports)
 			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
 	fdb_max =3D 1 << MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size);
=20
-	esw_debug(dev, "Create offloads FDB table, min (max esw size(2^%d), max c=
ounters(%d), groups(%d), max flow table size(2^%d))\n",
+	esw_debug(dev, "Create offloads FDB table, min (max esw size(2^%d), max c=
ounters(%d), groups(%d), max flow table size(%d))\n",
 		  MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size),
 		  max_flow_counter, ESW_OFFLOADS_NUM_GROUPS,
 		  fdb_max);
--=20
2.21.0

