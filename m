Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D263148F41
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404311AbgAXUVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:21:09 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404257AbgAXUVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:21:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ssj4/qdvfHXEEf691ZL1FqETFuSNzQrIGyfZTXFc82BiWAhsJfAC5zfS1cnMrrYQtey8NZ+ZlAzidl/MLpEPIMV1fgi3APttf2p13tDN7XZ94Ru1Uykg7YDQyMxiOC8aIR+W6e4cWtZaU+Kb9B0H01ed4iirgYzbTkMsynu1BMR1Cng6FmarfF7Je/o0FCsVeXcCOurGGUDCd8HUGGc5ECtA6F40BAWZ7KS5VHVpOaXvN2L3cF8T5k08S9Ct4k6DdsgT7tM/b5PxUJRQVTbBFbuQHyi9W+nu/a8jJ5gffPkbuuG3lh8RuruuG42+uquD46lxZDfdEaALuoeBw6V4Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTwX4Nabm/YboXaDwAj/B6QUd/M3zYT6zHVHBFluezI=;
 b=VYsZHqkhK0SOp4lyg1qn/F+Wn28sqEY3idSFB/Gqrd/ugcs+XUW3wQylrdnW1K1ttajNsHLdzJymbLEXatZCaWRfUPaa166FU8XQD+2FkoQTjSZthxaolRiZMG51c5D/27VXzrqvNR0QU1GAns9fLzs2m5QgHmn7DDGySJVToelVzNk2QjFcDc0C9NMVw1QD783WphdOSAmxnOYXSGHh9G+hWd5THG53jjhV5rL4X1sreASxRFOupTwk2L+PWB7upvDzBnQuBMdyn+UTIgxleTzbC5edKOn9fPv23KQOqJbu7IjAinpIZlVXhAGEpmnBevAkYx4tMLKIw5yuZzI+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTwX4Nabm/YboXaDwAj/B6QUd/M3zYT6zHVHBFluezI=;
 b=sZmn8uJB3u8yLCXZJEcBAulJD8IbFlYoV3qAD6/QATqw7ibJKWlkjw1ZnhKDWf3aRydT8QJk6nxNcMqEIaYveuEpiIYhp0cY5vkZTYo/mL6SRyr4mkO9ex+DNUz2C1f86ir7NxKaQZfhS00+OfxEmjd2ux/JdtP3Ce1hInXrxgg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:20:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:20:59 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:20:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/9] net/mlx5: DR, use non preemptible call to get the current
 cpu number
Thread-Topic: [net 5/9] net/mlx5: DR, use non preemptible call to get the
 current cpu number
Thread-Index: AQHV0vPKI30eb7+3UEW5gWbcGxtoLQ==
Date:   Fri, 24 Jan 2020 20:20:58 +0000
Message-ID: <20200124202033.13421-6-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d5a23f6d-1df9-4205-a599-08d7a10aec9c
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB555203A012E9F8F26553A4A3BE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(54420400002)(15583001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OiqYUMYGoWgwHX52Nz+sZ4zFpA6T7Gft6AH83Hi+a3qsqohKxMpViraYaB8Ww0VU8PYgCqj2rEvY7NXELug6AhTM1M8+uouq4bLBVKoFAH3rk8cVNq5xyLqkkHaj7vjcbgVEY+IFty/0W6BRlQm1z79G7EEZoMEA8EQdl0HaSXfJkcc2l9pO1MPkfVDvHdjHkzubltQnql2cFgEwUzXSH1B4GRBo8AxaEa1QPR42TW/ITGC37pOjIo5VAUtCJTfxEWlplXFHdWiWj4xVzTnU0IMzdn2tbGA6E7xuk0MgBT64jn7z/Rd1eSqXj7scTyNCDUT5Lj+2nxUeKFbwossmFrhOI6AM/tulsMJkhm9TXR5rd7fGKU5O5s7ZmaSTGKm/pSo6Oe/PLNe52DtsvjITBAyyDkY+1eKd2ZRUiVVAr5hAl6yOzyov7gHydadRBUx8kYBggNVcWRlrSBoXpTSaH1GtCiOZi1RBiAFkHeZyX3knk5+7JLY1f3q1zHwwXCsZH1hUaNHmPvo0bjoLlVUB6qXUpa4lGypEKYof8UTdBJ8uYxiVzXWrVyVym1tK3Yda
x-ms-exchange-antispam-messagedata: oLKb3Ob5bCUNYX2iBjAJ1w9/qjQFL+Uns2b0+kQeCPi3wnJX7EGqEVq5Wda9Ght6Y9riX53WByP/9Xy2xwj+RNdwvqqCvKE24os4W5HJgfzEv4Ul4akkqeIg94Vec2AIrl+wsNF0ebIfm5mZLO55Tw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a23f6d-1df9-4205-a599-08d7a10aec9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:20:59.0046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6HJ1MrnR9oszVN/s1yg5rziQ+yqWltGSJ3FXcaV3AEfr4YDG14aDTcOHbb9npujtDmvdQq3Au2HNyYdi5ub/EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

Use raw_smp_processor_id instead of smp_processor_id() otherwise we will
get the following trace in debug-kernel:
	BUG: using smp_processor_id() in preemptible [00000000] code: devlink
	caller is dr_create_cq.constprop.2+0x31d/0x970 [mlx5_core]
	Call Trace:
	dump_stack+0x9a/0xf0
	debug_smp_processor_id+0x1f3/0x200
	dr_create_cq.constprop.2+0x31d/0x970
	genl_family_rcv_msg+0x5fd/0x1170
	genl_rcv_msg+0xb8/0x160
	netlink_rcv_skb+0x11e/0x340

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA op=
erations")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 51803eef13dd..c7f10d4f8f8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2019 Mellanox Technologies. */
=20
+#include <linux/smp.h>
 #include "dr_types.h"
=20
 #define QUEUE_SIZE 128
@@ -729,7 +730,7 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_=
dev *mdev,
 	if (!in)
 		goto err_cqwq;
=20
-	vector =3D smp_processor_id() % mlx5_comp_vectors_count(mdev);
+	vector =3D raw_smp_processor_id() % mlx5_comp_vectors_count(mdev);
 	err =3D mlx5_vector2eqn(mdev, vector, &eqn, &irqn);
 	if (err) {
 		kvfree(in);
--=20
2.24.1

