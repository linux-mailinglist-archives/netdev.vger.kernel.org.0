Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736B1DFCD1
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfJVEpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:45:02 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:34154
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387544AbfJVEpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 00:45:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST3cRYFAnET51enmEHU/v3NkN9vJOvoCNpByZbb0OioDkbIVkBRzPqJp2Zb3Jf96cathMXLrrYQBb4s9RT+8RSaMCpkwWutZURtSAqUxu+Ni2UNR6i71bPyFwuL+tpBFpyZzBLsML4cs0GrE1Kck4vsKTjMZGaQT3MQfY/HqJZl3UePMLW6HI+A7c8y7aeXNezivtVWfRsz5VvDyd6bARib4/9oSOP9o0Eees4Mz7fdTo2o8rvJCkA2S55Ko26SXGkkq9DRXgpzPr8wG0aSsj+b4sIpQDVLaBE0IsH4/dpbdQU8wbhxOh1FjOCcR9K3xy55NW0P/i+FuvwFqr5ndIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31AncxE9U4nI/h7OS2vXoLsNfUZCFQnNB9/2+DEYzwo=;
 b=BCIUSb+PjRWn2qqb3TDECpMGgC3cBtYpyhiey2aFPHjFgH1U/g2YkdOHTvXUD8GQjQ/WKGNESy88bQHl1f5YTWeFfmVwlpkvwUuI6AXG9Xzisp8isAligua8DWwkGE+HN9uvjvg2oI1SOjDhUB6WGN+OfB/G7yZPVVzhdeZRFMZN6ML+5gNu7RybErQcup74YAldU5bnqInVAwBb2Ie94BG5KGF5hrgfoRvPZejYMSPH2uv08CxlwwLUYOS7U0Ac7XtMk3LiYYeM44W9qY0mmgXezVVTDGWnEhVHt6KqLfxAMayA0keh8ZpveRybjpFUb6eu24ObckBE+AE/mGB9Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31AncxE9U4nI/h7OS2vXoLsNfUZCFQnNB9/2+DEYzwo=;
 b=XqW9DY2QQ20Fp0xR0aGh2QVRGWlCSDTLVB6fyCxVH1MI+/vx+ovD55lsAiS0OjA6OKbm3peBTd5nMtIqvr8tt1xM2zudTeHgue9VBNc8HtP4ipQa0LScU+2CiFtD+ou3CxSgDlbwOH3MhpyTQWQc+f/RVaK4bvJfPwJLcHE80ME=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4272.eurprd05.prod.outlook.com (10.171.182.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Tue, 22 Oct 2019 04:44:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 04:44:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 4/4] net/mlx5e: Rx, Update page pool numa node when
 changed
Thread-Topic: [PATCH net-next 4/4] net/mlx5e: Rx, Update page pool numa node
 when changed
Thread-Index: AQHViJNhWsOQymWONUCS1Gl3KbrDPw==
Date:   Tue, 22 Oct 2019 04:44:26 +0000
Message-ID: <20191022044343.6901-5-saeedm@mellanox.com>
References: <20191022044343.6901-1-saeedm@mellanox.com>
In-Reply-To: <20191022044343.6901-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b58c221e-2b73-418e-8a65-08d756aa8446
x-ms-traffictypediagnostic: VI1PR05MB4272:|VI1PR05MB4272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4272BFF3900A9B48718CAF76BE680@VI1PR05MB4272.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(199004)(189003)(4326008)(81166006)(36756003)(316002)(110136005)(25786009)(14444005)(81156014)(256004)(15650500001)(8676002)(305945005)(7736002)(14454004)(54906003)(8936002)(478600001)(2906002)(1076003)(71200400001)(71190400001)(66476007)(50226002)(52116002)(6116002)(11346002)(6436002)(76176011)(3846002)(446003)(386003)(26005)(102836004)(86362001)(6506007)(6486002)(6512007)(5660300002)(186003)(66446008)(66946007)(486006)(99286004)(476003)(64756008)(66066001)(107886003)(2616005)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4272;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XnA5j67UGNgXlHv2SFMf3GzYZ1ZbK+pGhr4BN6CNu5JumOK9D9SLWxIP0+23XwUQTf6uJlXM2c1BoTRRxy7QGj0mzTT87sw9Oz+doi+fKhpOUDGClswVitjsAtFqs74oUCAjrmHQJEiLtAvNo2Eo+g/YpSepCOkfX9RvChcsbpN4qzW/EgQl2+k5hJHHwEguqeFmuu9mQ2CPgOp75fm8IMnRY8hSWKlB+9pmeeIyXlmC+yVLtCEDCT6d6HYjktL07SOoUcYY3dKUQRY0T9IAKYme77TSVEnxhVxsBx+j27/FRs5v01asucYswTOf56IR+X/6Uz4DxyL4zv8l9T+jxCd5cIJ3g2BGdH4icm3pHfU7jFGYKBhcFKHnetfy9i9QFjhGJBkMKDoAbNAu0v8gzQmHxgH0MvRJWsNpKl+uLYSlX5s7WoCoyyAosc7VXf9d
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58c221e-2b73-418e-8a65-08d756aa8446
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 04:44:26.1168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aNhK6QyUrBATNnaYPG7QXes2lstiKlLCfKyhD+nCBLXIUXihpWDjlNRjyH8POQ/4IVno/fzSi++kOdD7KI6I2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once every napi poll cycle, check if numa node is different than
the page pool's numa id, and update it using page_pool_update_nid().

Alternatively, we could have registered an irq affinity change handler,
but page_pool_update_nid() must be called from napi context anyways, so
the handler won't actually help.

Performance testing:
XDP drop/tx rate and TCP single/multi stream, on mlx5 driver
while migrating rx ring irq from close to far numa:

mlx5 internal page cache was locally disabled to get pure page pool
results.

CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)

XDP Drop/TX single core:
NUMA  | XDP  | Before    | After
---------------------------------------
Close | Drop | 11   Mpps | 10.8 Mpps
Far   | Drop | 4.4  Mpps | 5.8  Mpps

Close | TX   | 6.5 Mpps  | 6.5 Mpps
Far   | TX   | 4   Mpps  | 3.5  Mpps

Improvement is about 30% drop packet rate, 15% tx packet rate for numa
far test.
No degradation for numa close tests.

TCP single/multi cpu/stream:
NUMA  | #cpu | Before  | After
--------------------------------------
Close | 1    | 18 Gbps | 18 Gbps
Far   | 1    | 15 Gbps | 18 Gbps
Close | 12   | 80 Gbps | 80 Gbps
Far   | 12   | 68 Gbps | 80 Gbps

In all test cases we see improvement for the far numa case, and no
impact on the close numa case.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index d6a547238de0..3b6d55797c0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1386,6 +1386,9 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return 0;
=20
+	if (rq->page_pool)
+		page_pool_nid_changed(rq->page_pool, numa_mem_id());
+
 	if (rq->cqd.left)
 		work_done +=3D mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
=20
--=20
2.21.0

