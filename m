Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65012131C73
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgAFXgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:36:32 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:32391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbgAFXgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:36:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eINkSEN/2pzGhtFpxF3hTbtgPaM7EycWW55ckvr1y8kdCe42ONx8lZj/FR108WrbHgsFfpZZZsIjMduy0zhLWzLh0zksqFDg0f8Td5uSTG26RfOpWMC05pmVeOQC7bflYBmL01TbklGy7E6hWa7a+ZsPGDiKhNuNM4X2/8m2xXbh6PgE2nLHhCuw/a9o1qV+3cIt51AZf+1uvFe7w81zdhcPdBomOsWRADIBoc3s7N22DRs0uvc9aCQ6/Lz5MWgdgKbODiKloTz+5o6AxVUyPJRfUCdsbMlTWvO9YUv9qMYWZ7ACbCnWnc55DRm/oXmU3tY4e2Aucscftaa5Qg5Yhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtWK9I9DxN46hJvUPW4Qe5ZgI2mYBb9HKUPFAIkZ67U=;
 b=br/WeLk2NMlraDL523EkcWj5BsK2roHYqnHE0S3GSyLSxlgFt7bdxSZHMuhQ0gkDlOCzD6JM52SF3c2S816WbH9Cr3YnfLZ0LLOe5EA1FoEAe5JVXRjDTXhoMXUIAq8zmVLfr9AU1+m6dslxo1fg4x1MBnXodq9A7Xqw/2MUuMnLOdb6eK0N1gM1oDwOx6qPc1xwPidfD9wqLKgxxrp1ADLc5ISzIM/HLgV6XjBPhR+3stX/h3ugxfRANE7/Z5wRu6BoDI+q9JNGtVUgxs9V0g8OZbMBu7rv7znkQ2r0httsvU6xo+3WIiljyoSJBlaTGhDIxX1j/QWoEAp1rssJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtWK9I9DxN46hJvUPW4Qe5ZgI2mYBb9HKUPFAIkZ67U=;
 b=n9WyAO3acCVxFW9RO6wEcE8vVUK4c93ulIansW4rcIzfR8/azurYKN5v20U2wu4zOVfIiSUPkIuQYzFb3TyLgttPxc3pCZh8adaRzDHdwl7KcDJhmgqPM0cSAWSN7h+vJLJmQKp7UGapkD0qi3NlDUHC701vooKhM8Jnhj7eLQs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6397.eurprd05.prod.outlook.com (20.179.25.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 23:36:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 23:36:25 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.3 via Frontend Transport; Mon, 6 Jan 2020 23:36:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/7] net/mlx5e: Always print health reporter message to dmesg
Thread-Topic: [net 2/7] net/mlx5e: Always print health reporter message to
 dmesg
Thread-Index: AQHVxOocTWuiZ9rToEWqDbI8TNvpoA==
Date:   Mon, 6 Jan 2020 23:36:25 +0000
Message-ID: <20200106233248.58700-3-saeedm@mellanox.com>
References: <20200106233248.58700-1-saeedm@mellanox.com>
In-Reply-To: <20200106233248.58700-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2d74251f-de4f-4be0-e455-08d793013ee4
x-ms-traffictypediagnostic: VI1PR05MB6397:|VI1PR05MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB63973B175C2AE2E40ACCBBB8BE3C0@VI1PR05MB6397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(4326008)(5660300002)(2616005)(956004)(6916009)(54906003)(8936002)(478600001)(6512007)(26005)(107886003)(81166006)(8676002)(71200400001)(81156014)(64756008)(66946007)(66446008)(66476007)(66556008)(52116002)(6486002)(15650500001)(6506007)(1076003)(86362001)(316002)(36756003)(16526019)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6397;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 23ze1NvwFzabBlEq4+RFsV23jy+jbPhgiM9bOw6WnUsAZZWl+63JrOab5JlM4wEE7iMUE0wtvogle+6K0fAyHruE1uhzyzkwf/z8llxD4AtoVzZ1KwQtF+5JtWJXVTokJqur//pTzfhu71v6e5O1IwgVUwuoufmqevrpvuEyo+EgfPHv1HxcOIEXNSRo5z0V5lsHk/98SHW0unb1JIy7sXM8l+YvAHdIFh/qGAL3zegfaapc2Cbd3OjhHRsbZAtAw0p8gQlDmo8LHyqHgdMPSvmZlTHOYe77cguswX5Z+vdg6Q5cjkvxotlgDFMQ9PBp/iCODWFmn4wxmN59LdC135ei671GETYuw/AdY/ltCTgORMgrHnGkje7evlQ7AEqAbpaXBqyymqAqKLO9bStGBbQsVOApgf/31gqmkafMNRu8gu9Zu07CifpnTULb6ie0KuPpqOSaVtol6wwRZZCB2xY/9PHut+7qJi2gbBdlAB3ESQsh5bB/BLKe0HNmnsELNMpDiWsRPzZLCKDGHRZQuGG9KY7OljPPhmM6G4goaoc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d74251f-de4f-4be0-e455-08d793013ee4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 23:36:25.7711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wlGWxeMgIVti3icHHTRHHwxpsiqHXIG3JHHNz7XB6oawqPs6SSKEq0209db5Clf9togj+4/lw6qyY7ibqsbxuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

In case a reporter exists, error message is logged only to the devlink
tracer. The devlink tracer is a visibility utility only, which user can
choose not to monitor.
After cited patch, 3rd party monitoring tools that tracks these error
message will no longer find them in dmesg, causing a regression.

With this patch, error messages are also logged into the dmesg.

Fixes: c50de4af1d63 ("net/mlx5e: Generalize tx reporter's functionality")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 1d6b58860da6..3a975641f902 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -197,9 +197,10 @@ int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
 			struct mlx5e_err_ctx *err_ctx)
 {
-	if (!reporter) {
-		netdev_err(priv->netdev, err_str);
+	netdev_err(priv->netdev, err_str);
+
+	if (!reporter)
 		return err_ctx->recover(&err_ctx->ctx);
-	}
+
 	return devlink_health_report(reporter, err_str, err_ctx);
 }
--=20
2.24.1

