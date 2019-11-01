Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7494ECAA8
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfKAV7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:32 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:20086
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727316AbfKAV7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCp5ESSbx9r5msz3UQh8wjt0RH4rsmdIzPI49Tw+FQlbXDXyYu1Xc97lw4IMEY1fTM5x62kJlagUdjeA6s8zvO+6zehUTK1UN5TfQ2zKmOYvHw1RP+0vjeWa3PWoRgdCeD3fMonsk5UQnjaGcb+mvvNPlbcGRjLcve+lv6uIyiA3TY1CdM4H9LptT3QcX8h9sUuAtZeXbGNn/HfyP7d2HP4bHCD73+IB0kauhfR0IP17SQ2qwWR8qHRd/whk4xbQAt2a4uzGOvdv+O5TuJn1lgRixygqsQrQdUyYJzk2adC4OlYDLKnS6VvTG1GyFo30DSpJTsWxWt+9i96Tzll4ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkLOLvw212IuN51QflcADcdOYb7h8bDbCUIfn0Ywb+Q=;
 b=DF/0oRaRDz0HDIWb/coqvEH7Ol/2bWGpDZAYhoFonjjY37HHp8w6F73coMm/CoZ0thN/yMEOSBRqTti/H87lpPzOeoUoyXug1OwCXCXO0PI7ydaL26wu+1LDnmp3w0XbGMrjyF9xvsTpsP0BIBIACwH8nc/oQ/sv9pZj89ZTAUXStEND/JN6SHXCdhNcnlxIr/5Gz5qQ7Goe8MOuK7L6F71uXEvbUjng4m5R8xcB4kdsWRk15LRHo17bO1ltRJvYSN22Axnd6YYWXOkacGM0StAnPC557rn0XBVeSc18DyIbfyPCS5TkB+yTb+ki+yB5akspZQ2RcMhsDeX89QSagQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkLOLvw212IuN51QflcADcdOYb7h8bDbCUIfn0Ywb+Q=;
 b=cMvk0wNieidy8zwuDLpsgGwgdibtJviJQBM7G65kweP2WawqcrwNwdr5na3wiXWHeea86hw6KUA0rHeJfyst5OGby26Tspp+H/7CEixIeRQPAx2+asvnN4s3L3+dX//xnXNbrOuDSqBL6qnNZaJj+0Lx7PIns36J9ZNIq7G07MQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5679.eurprd05.prod.outlook.com (20.178.121.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 21:59:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Li Rongqing <lirongqing@baidu.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/15] net/mlx5: rate limit alloc_ent error messages
Thread-Topic: [net-next 12/15] net/mlx5: rate limit alloc_ent error messages
Thread-Index: AQHVkP+c/NrYxf7smE63xa1+syOCLQ==
Date:   Fri, 1 Nov 2019 21:59:18 +0000
Message-ID: <20191101215833.23975-13-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 691cb064-625c-4572-e597-08d75f16be5a
x-ms-traffictypediagnostic: VI1PR05MB5679:|VI1PR05MB5679:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5679F5C33D8321D085B83C68BE620@VI1PR05MB5679.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(4326008)(99286004)(316002)(2616005)(2906002)(6116002)(476003)(6512007)(3846002)(1076003)(36756003)(66946007)(14454004)(25786009)(54906003)(66066001)(66556008)(64756008)(486006)(11346002)(446003)(81156014)(6916009)(76176011)(305945005)(7736002)(26005)(66476007)(66446008)(86362001)(5660300002)(102836004)(386003)(6506007)(15650500001)(50226002)(6486002)(6436002)(81166006)(71190400001)(71200400001)(478600001)(8676002)(256004)(8936002)(14444005)(107886003)(52116002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5679;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l4pcK2h33QNCwkWW/GJSSQAH+WmEPAPIt/aJG7woDqX3wenXMuL3w28d7STp9GjGmFMjgZDZ08APuP8bpXWL158kLxFayMmMD/QvO3IC/gIjNHRORjup+7by7IonCobSe4HRiFeznC9aFRUWAhSUSl9ja0mCfL1HWBjSkQwlb30OjPUwlN9h630cSN8pBq+BaowgOiFPmYgnNtwwRK7pja0heThj7KQ/puD5R4rudSD8zbrYvsN4r+6lpLRBNZNo73hmmJEqkrvunqp60yiyTZDKT39MvDAF1gbKtDwhQ8c/XY4+l6Gw3MHUZN6X3Lchd6151wmxcD/73slOkArDbE8PDwoUCJOP/yeD3QhrDF33R4FUEj60M7MmQNwhYLcI2SLSKgS8XsfvJ4BnoqL2j2TlKXzkA40/h3qypXjeLbo0OYeZKHJE/cqitHJTry9o
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691cb064-625c-4572-e597-08d75f16be5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:18.7299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FBM73qAskE/t1IWHsTZqqyofMOuCtKG0gBoWTWCM+9pgYPQBDpCJKbMrqW1MnH+bfBK9+oW61yut4GECqD6Urw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

when debug a bug, which triggers TX hang, and kernel log is
spammed with the following info message

    [ 1172.044764] mlx5_core 0000:21:00.0: cmd_work_handler:930:(pid 8):
    failed to allocate command entry

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/et=
hernet/mellanox/mlx5/core/cmd.c
index ea934cd02448..34cba97f7bf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -866,7 +866,7 @@ static void cmd_work_handler(struct work_struct *work)
 	if (!ent->page_queue) {
 		alloc_ret =3D alloc_ent(cmd);
 		if (alloc_ret < 0) {
-			mlx5_core_err(dev, "failed to allocate command entry\n");
+			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
 			if (ent->callback) {
 				ent->callback(-EAGAIN, ent->context);
 				mlx5_free_cmd_msg(dev, ent->out);
--=20
2.21.0

