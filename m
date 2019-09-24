Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A98CBC50D
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504326AbfIXJlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:41:51 -0400
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:4229
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504321AbfIXJlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:41:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DngUoLGbVxK8i5nP9qzFDTubxy99Mgn3QyOJhFar25ky+OK3tkQQLkzxrbyu0QYMo3TjMghVEfX8eFKFWDLZb/wNUXv+uKabcCnRSjKHGqB5wUsGL94rKQfpfPL0GME3MjHVFtAZXSaE0PGHwIIX9HFQ113JvYmlKLGAjJhIj9B67UDBQ100uYKzE3xSuFgzMo+42KIvVyX8DLZXrUbf1FecX10Lo07QHcNJ1b2OrGAOkfaOgxdOXIFqkk9/tDwFdyT/xBB5JUxNgb+Q7WH5P8VrImHLGtXERxVpZ4vqSKHWlDYvgBRuoH2MSg1hlRWL2qV2/glkLMJRL/GUf7bKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g39qJoCCM52sRWWRaROgysr3WI1aMpuE3qQtSy1OsCE=;
 b=R8IhxXDfpoMtnLVeRYhNPNs+ApceYgqWpc+JXSepMeq64XuEx1HfuZEumeVLFUYCZfBpqobW4A0DNGLrhTomVGrHsxsimmpovSApIbCr/AENzvpVMcZoZnHhUrRMLycrpLVKPuFUavJB5HQSvY9OFU1OsGOOBegjkNf4fVQc9Tg75DdYK4fOf3TBaekQE/hb2CwCbt9fko5KeDYEP1F+/5AECmRKFHmPUCc1euCTEPQJ0MTDo22enBC6mQRzvNMetRBPnu0yrqT30ojshfoC657KIaA2SxFMFRtouKa8s0Eiyt4U0kJxdwI2b6mMNEYWpPEIo/r/j8X2LrMDqy210A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g39qJoCCM52sRWWRaROgysr3WI1aMpuE3qQtSy1OsCE=;
 b=O1rZ4lOesgEU16AR9eqJKZQpF/Sc2n025UZ/j04DAMNFOnQOklhqOOeECL6NwKe5WPnoGjZsl+XP5eQxyDsiSJ2MlT4kkUlOGT13YG358vG+zqDf1ZDc6kNUj6jDZMc9QuD2MNRq2CM0FKrTPUadqp7Sc52D7htoltFMuQG3EhY=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2671.eurprd05.prod.outlook.com (10.172.14.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Tue, 24 Sep 2019 09:41:27 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:41:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/7] net/mlx5: DR, Remove redundant vport number from action
Thread-Topic: [net 2/7] net/mlx5: DR, Remove redundant vport number from
 action
Thread-Index: AQHVcrw8IxFpwQ0nUEWxlgrHQr/VVg==
Date:   Tue, 24 Sep 2019 09:41:26 +0000
Message-ID: <20190924094047.15915-3-saeedm@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
In-Reply-To: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b59d71e-298c-4a36-2c5f-08d740d35e77
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2671;
x-ms-traffictypediagnostic: VI1PR0501MB2671:|VI1PR0501MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB267130BF29BFFE4C7031645CBE840@VI1PR0501MB2671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(386003)(256004)(6512007)(186003)(6116002)(3846002)(50226002)(99286004)(36756003)(25786009)(107886003)(486006)(6436002)(102836004)(52116002)(26005)(76176011)(8676002)(4326008)(316002)(81156014)(81166006)(2616005)(54906003)(476003)(11346002)(6916009)(6506007)(86362001)(1076003)(5660300002)(66476007)(2906002)(66556008)(6486002)(66446008)(64756008)(66946007)(14454004)(478600001)(305945005)(7736002)(66066001)(71190400001)(446003)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2671;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: blMfTJ1xQFwRBBWj/pr7nSZcNtK6jMjQwKO+O8gDk2W1BhNJNcKbDagz2ERwJzwc9E+97+AyVg6+3DVi1OunbhkaSQIPcc01zl+wOhyj99Gb7nZZClrHU6JJs6Z6NPYgp4Pp2rsfqKkUMv6ptn+PyrfZoFIlaudKBt2otzFxl7R1klwHcLgsknp1JvpF3/g3TZJUqMGKMubyH/FBWdD5SKIytkVgSSbwjoig5a5HHNZ0Fz20CrwVWA+Fzj4pjAGe2HheDp2RK7DnBDPS71tv/qe0v3CRcs3LofEKw/JZnYW82wFYhDBOpDep7btEzcpdue1c2uLOtyU/kNHLjR6F1fLUWseeZn6B3lkJ4gadUPmdOMYZg5RQ/hYa9ccDR5ZCVEU0TNqNINxfoggUoBQhgkQgQdK424+GJj4cyzOjY3o=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b59d71e-298c-4a36-2c5f-08d740d35e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:41:26.9827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8QEpE2+kQNT4SS1AwIxJ5z9YgC7V5ciiA3zFeyplCtOVZc4cHEJTs8icjYodmRKFL7zesNtpLfqZKg1eGuixTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

The vport number is part of the vport_cap, there is no reason
to store in a separate variable on the vport.

Fixes: 9db810ed2d37 ("net/mlx5: DR, Expose steering action functionality")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h  | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 7d81a7735de5..b74b7d0f6590 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -615,7 +615,7 @@ static int dr_action_handle_cs_recalc(struct mlx5dr_dom=
ain *dmn,
 		 * that recalculates the CS and forwards to the vport.
 		 */
 		ret =3D mlx5dr_domain_cache_get_recalc_cs_ft_addr(dest_action->vport.dmn=
,
-								dest_action->vport.num,
+								dest_action->vport.caps->num,
 								final_icm_addr);
 		if (ret) {
 			mlx5dr_err(dmn, "Failed to get FW cs recalc flow table\n");
@@ -744,7 +744,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher =
*matcher,
 			dest_action =3D action;
 			if (rx_rule) {
 				/* Loopback on WIRE vport is not supported */
-				if (action->vport.num =3D=3D WIRE_PORT)
+				if (action->vport.caps->num =3D=3D WIRE_PORT)
 					goto out_invalid_arg;
=20
 				attr.final_icm_addr =3D action->vport.caps->icm_address_rx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index a37ee6359be2..78f899fb3305 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -745,7 +745,6 @@ struct mlx5dr_action {
 		struct {
 			struct mlx5dr_domain *dmn;
 			struct mlx5dr_cmd_vport_cap *caps;
-			u32 num;
 		} vport;
 		struct {
 			u32 vlan_hdr; /* tpid_pcp_dei_vid */
--=20
2.21.0

