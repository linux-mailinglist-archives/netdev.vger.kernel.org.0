Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49473131C78
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgAFXgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:36:50 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:32391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbgAFXgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:36:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnr+xXxQ6ssK+0rrpGzJi9FnUKTvgGpWuZ9e86bxDsqMKL0/MyM5TY/KMGW9Ff27z087WFBX0gqCiVlWc8o7aXhNUafK6QKtZPzIYZu04gzjs6HJkbpIhYZ6p8r12nYU1IQcqHtQCnhlLM2wEpgjgSbIeWE+xKGXyQBnCV67dZcINXEjJvV9VBdcBafmDDjnkGG9kNFrR3homFejVVIB2YPWXJ3SxMg610kbxyumgayFLGjg0e9gYvQB9YOOuoT9YdaT4Td7PUyKGHVc2pVCB9XesouyL6laH9SDn6lcwMz3aK8DjASA0A0zb3wAORVBaZlDd4uEGnFBJHjXzUulRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hphl934cmOfr5qY8knlIPDnMu3xeNnevABjLrbHmC1E=;
 b=Cyl+ohgmQbJj2Fvvzld+i6uWCQUTKluid1fklrJ8BPdlZkboxGV6Vxn078p0bVD4jdZm+ebk6gBQl/NMlr4GU9UHsyanDDCKNoC0Waph/Lqtl6wK+pPX6SNGOdEFBnMOPc6QU+t6TZZX0TOArN44Ri1ytYJn0W8xE0Ybu/GNAPihwElc0AdfX1A7jD+a5pGmO5MTW5crOcoNUvVULCqlSaPwhLyASOivj8nDK3MuN3QAIAOtOx4K+LGx+y9siPVuarDUowUPb3hdVSS105VE135Sx8S4wodQKWyb86POT+ClkdojIT8f595w2da2cfoCxruy5WD+r3KVFVN3/AAYOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hphl934cmOfr5qY8knlIPDnMu3xeNnevABjLrbHmC1E=;
 b=jT3f9oB1/WKzxSLa036kWTSrnBzwFb10NzlbXBWnlfBRbGC97nSRVLHJxFzlkmYIeDiyx6Y7xVmC0HBO0jW1ZF9EjRwuMqqvdRQUpD/40e5+nfbwafoCmtRK6o7OGWo12XjWfCqApfN9ztEebQBo6dt1DVHJ4xuyBg+UWJoQHxs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6397.eurprd05.prod.outlook.com (20.179.25.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 23:36:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 23:36:35 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.3 via Frontend Transport; Mon, 6 Jan 2020 23:36:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/7] net/mlx5: DR, Init lists that are used in rule's member
Thread-Topic: [net 7/7] net/mlx5: DR, Init lists that are used in rule's
 member
Thread-Index: AQHVxOoisjZKyKJBdUC/uF4204sXtQ==
Date:   Mon, 6 Jan 2020 23:36:35 +0000
Message-ID: <20200106233248.58700-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: cb2d3dd7-59a7-4029-b049-08d793014470
x-ms-traffictypediagnostic: VI1PR05MB6397:|VI1PR05MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6397AF916A9DF57CBAF6F714BE3C0@VI1PR05MB6397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(4744005)(4326008)(5660300002)(2616005)(956004)(6916009)(54906003)(8936002)(478600001)(6512007)(26005)(107886003)(81166006)(8676002)(71200400001)(81156014)(64756008)(66946007)(66446008)(66476007)(66556008)(52116002)(6486002)(6506007)(1076003)(86362001)(316002)(36756003)(16526019)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6397;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sW13x2erEooggFrZ7YaKD6i3CHqdjG6pPWl2bnl5t6yO5Wft0+fuvCgC4ogrDaW77qMp26YSVxzwxndKQ8JUUAOwU+2rYgyJblqQu1SjPOhtTyeB6FfHWz0vVLt2qSJw8sRYUOoW+LPAXHCbldkK6pIfKPFN3EqTFxOdGL4e1K6gch1VQ5RicMoZk5DrNUWexJh/ZwFtOFZxAzAi5vEip+n46xV64ES32Zn8+AnZ0tYcXhuoGX0wP7f0kt7npECdzejp7c4nr4B6d+M7w9KbjMx2ubjMNj6P+30pqofNsLNrdniooQLDEozLLBxNsXkx/I+PYvXswdQ9SfOWRt+p4QBmn84ELmZcG+NjPwjstyZKSZy+PWuvAv2FaCSoIXGfyohGOvfJy0GvdNEoVo2+wup3Q6dHvgna/VNUsX2HdxNL0SuHyAmxM4raioEph4jKu08iIySWPX0YLvLt0c5xUMC3F8OoxT5huSYGKlAxh1jnrHIM+Vu+g6EFgku0BdYCVXKX9gzKwrogUohixFhE0Z+4Kauf31RP4WB1ENutz74=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb2d3dd7-59a7-4029-b049-08d793014470
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 23:36:35.2488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JROJuF4yhBQC3XYzKghUYy/s1tR/x4BFYSajRzo0nYMd+ZaymtD6ZqDthEmoZ2C0kf1ZHe07fopddoAQBEH01g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

Whenever adding new member of rule object we attach it to 2 lists,
These 2 lists should be initialized first.

Fixes: 41d07074154c ("net/mlx5: DR, Expose steering rule functionality")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index f21bc1bc77d7..e4cff7abb348 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -638,6 +638,9 @@ static int dr_rule_add_member(struct mlx5dr_rule_rx_tx =
*nic_rule,
 	if (!rule_mem)
 		return -ENOMEM;
=20
+	INIT_LIST_HEAD(&rule_mem->list);
+	INIT_LIST_HEAD(&rule_mem->use_ste_list);
+
 	rule_mem->ste =3D ste;
 	list_add_tail(&rule_mem->list, &nic_rule->rule_members_list);
=20
--=20
2.24.1

