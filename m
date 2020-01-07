Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44834132F1A
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgAGTOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:15 -0500
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728735AbgAGTOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sw338k4x+wzi6w7brHdmn8Iu/lJfRNJ0aNXv3u1Cz2yx7QZ5bsr2SHX0mlWu8xrejfKf4YCfFNgPW1Nwfl6TmFe+o4JuSBUN9JuLpY3y5jserIA142K/fQoe5vXWnjdgnRxe9sw/2BOO8Wp+0EeEu/HsvYkYT+chVZq7fLj0BSqOQ3hxbCCeof/A/J/PXyMWYXZfBdAygyTY2Q7+lwJ86eUtBi2TeMqpL98tzwDPdYL4lZAvgNRbUqSaHkR+zlzgSholOWEdCpx1BS4IutekFXEp5zQU7rGYM3FutQ5EROb/qcwi58rY9/n+d1pF47SQCgnckOB4UMbH/HhlowLXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFkZj5ArCSrjujSXtQdr1pho3D5rKvr2KsP49peHA0I=;
 b=WdRq1KSUAZFAhRJP92JiQlmEuXhTK49QCiOe+FlOeIpUQdz+BVyx1bdmAoI7EM8VqDNXjp1mx0d7R8nG5Klli0twFpb5F2AyLgEb6lcGodW6vb5ow7q8Z2dmUHJTW+aA+gN9O3fVV9rX55hTJewlzrGdk0e9W9kqxUs6zLhs0OYiRu+F5rpDa7usUQSt4+4X4yLCUTvhymJ9MqUMzcnBXivFfAhbiMTTFlHtqUmW0PzVFBAuW880a0MyFdfFAmZWtA1aY7PmDAt0UZW1jXzjYjTIerMUAUvLCBelo5BkrM28k7hqXi8LXz4VxgXU7qjnEkWM20TCV7MMnTSy7zT4Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFkZj5ArCSrjujSXtQdr1pho3D5rKvr2KsP49peHA0I=;
 b=cpAyFai+BKSSEfDWFDILkSYXTqyTgrqg/hRXh7TBp7nv7BryVg2Frh9tOnvt/kqFzM921Z+ojWrnCb1TNhJzCAukD7P8DbyZXyJ6lU3jJH72pEflwTWw8he48osp3XP8/5oj0jtpn0wmPFJoTqpOX+jKldpB07rcJZYraLpXfqg=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:10 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:10 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/13] net/mlx5e: Support accept action on nic table
Thread-Topic: [net-next 03/13] net/mlx5e: Support accept action on nic table
Thread-Index: AQHVxY6kQH3f8VYzwEyO/x68fn6/Mw==
Date:   Tue, 7 Jan 2020 19:14:10 +0000
Message-ID: <20200107191335.12272-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 1a247bb6-b0c6-4489-2123-08d793a5c677
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB54112D169A4ED82C2B504C5EBE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(6666004)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zOFAv1ja9a/AjYueFXiCqphcxrlyGObZaReZYlGo2funCl+q9rXcn6txc5NAbm47mq/htS/Vsli+/v33JSWvDC57EjQ7z2z7R/Z0ToQRkDUio1k39CIDkzWuA/nPOCBsT2DT39CUDhXUc7TasyWiX+9Gzn++On9zGI3fL08K4ODqC0AXlrGTMYj127Z20PfWmV3rlv9SlD1wYtpMn2U74gufIULslAmcpIhmEyUs0Vbk3OHDP4ahkg7t3b1PMD73QSl0qKh6yJ+zEmICuS7V7aNZ8k7HgSQMLYfZidTEsD6J/n+f51NuiN0fK7QHTr2+Gv0Yu6jbYOdw4SzvXuPQmT1eRk4mNACMvIJcse0Wz6R3oHMN8Z0MvukRTHwvV5wdBnc+hJyuWeUYJ2uqpDoxYTnueFM0dYprTDPVz24uysoPISdKnMXAdLmcJnHCDpSlOnWVJoC/ZSuO8wmajzNT0Nb9ERlXDmE7LIdCl48zT40xvgdSIUtbnDp9bwVrX+7SuuCmFX6N3ai3bgNuMll02c8oVY1vsv8gU9TR6zhmGKw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a247bb6-b0c6-4489-2123-08d793a5c677
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:10.6496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ehm/j3InmjT5FcBXwx8GRn9pFrZ8MeG3dFInJ0Z6KEbcDMwVhGRl6hqHt53+aG4X5QBzaMTjj6XhFIim6XNa5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

In one case, we may forward packets from one vport
to others, but only one packets flow will be accepted,
which destination ip was assign to VF.

+-----+     +-----+            +-----+
| VFn |     | VF1 |            | VF0 | accept
+--+--+     +--+--+  hairpin   +--^--+
   |           | <--------------- |
   |           |                  |
+--+-----------v-+             +--+-------------+
|   eswitch PF1  |             |   eswitch PF0  |
+----------------+             +----------------+

tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
	flower skip_sw action mirred egress redirect dev $VF0_REP
tc filter add dev $VF0 protocol ip  parent ffff: prio 1 handle 1 \
	flower skip_sw dst_ip $VF0_IP action pass
tc filter add dev $VF0 protocol all parent ffff: prio 2 handle 2 \
	flower skip_sw action mirred egress redirect dev $VF1

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 9b32a9c0f497..e8f2d0e4913d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2842,6 +2842,10 @@ static int parse_tc_nic_actions(struct mlx5e_priv *p=
riv,
=20
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
+		case FLOW_ACTION_ACCEPT:
+			action |=3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			break;
 		case FLOW_ACTION_DROP:
 			action |=3D MLX5_FLOW_CONTEXT_ACTION_DROP;
 			if (MLX5_CAP_FLOWTABLE(priv->mdev,
--=20
2.24.1

