Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D44131C72
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgAFXga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:36:30 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:32391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726858AbgAFXga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:36:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/rWyvQIiaHKYbDHtRCnXhH85JYXptr44K+jbrX7KaV/vZfS2PVH3KBltnKReCc+mKXUbdSg2v7IM2NM3VmZ+wUCzNJzOQwNFqGOubXuU2RDmrl73qYCMDZ88LPPBkv6+UQWlaS1FQlf+72Wt/IE0ZMZu0lNYccoPEb9V28yyEw0xJLh1g1ts1KUntPMjS5L6c2Vd+VBPq3a7DkLiMc7hmFnosjiC1o+WbivG0kwSiVeHIP7iKW+UA3cPiGC3hOrythnl3tjPs2S5IMMWexb0AkVIkSPqhLrFDJBFC5ESiSGS9EMBXnvUgPdVV7jxqQEwFXqEC2u6Eaq1RNG/pPwAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sy8MCBq5hEuoK6Yf3hkHPhkNkpwzTDGCwCfP/NjiDkw=;
 b=AMD3IQoyeb9yK53ciUOgmTjwk6uUyCQKLxPUuXfEtuS+D8gXA4CxCrQpRQXnPSv2wrmH0pzSmN+5Qi/04GhXz7AbFmMFTjYNIFbvr/hLrmqRRXS8JuDvDUuPBQGC9F7rpP/P8QEAbnQ7n6dIpdSGF5CnrYnNt8MgoYHhO8id6Qv7oGgLVjY3emnGtVDrWiDJHbGzZE5T+3oA6ZhcNwvby6W9wGW5W9G4vzUfVXoNNLWXVRjqCQGShj0WWEbGJklxRomgrZAJ2p9JygeLH0PTcTfIbGfk7bF3wHJkEQVBqouiYRBFW8vA4tdLFzz3uD8ap6Xhe+HXofuITViIG6aGMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sy8MCBq5hEuoK6Yf3hkHPhkNkpwzTDGCwCfP/NjiDkw=;
 b=Gd2aKAzK74l81kpZ4MKZ5n4mjsHOanCsbW0g9F3+hL6iqsEDyFy1QUZzhpJfjkXk71kgbBPo5QYBBW85CP6F396ZxvI0+sWdKLmpGgKQe2Ye8Bdp+UDmCFMBevi7XdwBcaMwwB0FxYSGnSJp28zU35cCV8cKhQ2e8ZfPFaX9Xwk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6397.eurprd05.prod.outlook.com (20.179.25.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 23:36:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 23:36:24 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.3 via Frontend Transport; Mon, 6 Jan 2020 23:36:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/7] net/mlx5e: Avoid duplicating rule destinations
Thread-Topic: [net 1/7] net/mlx5e: Avoid duplicating rule destinations
Thread-Index: AQHVxOobgdPsZ5iF7Ua0cAUjCFZOhQ==
Date:   Mon, 6 Jan 2020 23:36:24 +0000
Message-ID: <20200106233248.58700-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 76a875a1-a079-4e38-f675-08d793013dd6
x-ms-traffictypediagnostic: VI1PR05MB6397:|VI1PR05MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6397B07C8641AB75C457D6B2BE3C0@VI1PR05MB6397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(4326008)(5660300002)(2616005)(956004)(6916009)(54906003)(8936002)(478600001)(6512007)(26005)(107886003)(81166006)(8676002)(71200400001)(81156014)(64756008)(66946007)(66446008)(66476007)(66556008)(52116002)(6486002)(6506007)(1076003)(86362001)(316002)(36756003)(16526019)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6397;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qOgTSTJHMxEbvspglMurzWzFS6DvEEmdO8Ln3/7Ykq8tX7fZqgCqI8A9SapG2GmKrkUwu/1MbRWrFrxDtHLZPXSyGMYOfTQS93gsCM2yTttJYVHCS+0NKs/u9RqHgllBr/yQjwwfqOygsnZ+iH3CVzosl3CgLLI+uz2EGMrPV8yYI0fxjQL19SL5GmLn2NZWPjiV9hbnQh9ClwTCtTrAWF/cYTVZ774gMMnCH6zlZH/PiVedjaRr1S8fXXjvj8kyb2OCcvercod291A9QJpdFXupKEqa61F9KdjfmzZxakjrihWdLkSJhk3eI91XQhlf5MteCEADAe0qklMSwqZmTh0YOgjHzVs+mAJnvYSofkwQj7MT3ahsiHMOUgf72BuTZkj9mH79gjGp7IpwiL8QtCBGOd9Cx8eQ5yPrYiSBgRGtKhhieG/FiQsllk7WYscrnz5mJv/vW7om+g8YXMktDNroFPCR1g6s291AkfEdXJqoaK7IgjjllIIYHj0iUeD/teWEAuEInDAIhRLXaGXj5qj8W0rdomANHjFw8aRjZ/s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76a875a1-a079-4e38-f675-08d793013dd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 23:36:24.1770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UNWpaAsXO340pkCzMDyNTwx+PlG3SWUwUjaIIRsqwhhPIjnO1K9FxZaRQc3kPP05Ounobu2wYlWajaN+CjllUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Following scenario easily break driver logic and crash the kernel:
1. Add rule with mirred actions to same device.
2. Delete this rule.
In described scenario rule is not added to database and on deletion
driver access invalid entry.
Example:

 $ tc filter add dev ens1f0_0 ingress protocol ip prio 1 \
       flower skip_sw \
       action mirred egress mirror dev ens1f0_1 pipe \
       action mirred egress redirect dev ens1f0_1
 $ tc filter del dev ens1f0_0 ingress protocol ip prio 1

Dmesg output:

[  376.634396] mlx5_core 0000:82:00.0: mlx5_cmd_check:756:(pid 3439): DESTR=
OY_FLOW_GROUP(0x934) op_mod(0x0) failed, status bad resource state(0x9), sy=
ndrome (0x563e2f)
[  376.654983] mlx5_core 0000:82:00.0: del_hw_flow_group:567:(pid 3439): fl=
ow steering can't destroy fg 89 of ft 3145728
[  376.673433] kasan: CONFIG_KASAN_INLINE enabled
[  376.683769] kasan: GPF could be caused by NULL-ptr deref or user memory =
access
[  376.695229] general protection fault: 0000 [#1] PREEMPT SMP KASAN PTI
[  376.705069] CPU: 7 PID: 3439 Comm: tc Not tainted 5.4.0-rc5+ #76
[  376.714959] Hardware name: Supermicro SYS-2028TP-DECTR/X10DRT-PT, BIOS 2=
.0a 08/12/2016
[  376.726371] RIP: 0010:mlx5_del_flow_rules+0x105/0x960 [mlx5_core]
[  376.735817] Code: 01 00 00 00 48 83 eb 08 e8 28 d9 ff ff 4c 39 e3 75 d8 =
4c 8d bd c0 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <0f=
> b6 04 02 84 c0 74 08 3c 03 0f 8e 84 04 00 00 48 8d 7d 28 8b 9 d
[  376.761261] RSP: 0018:ffff888847c56db8 EFLAGS: 00010202
[  376.770054] RAX: dffffc0000000000 RBX: ffff8888582a6da0 RCX: ffff888847c=
56d60
[  376.780743] RDX: 0000000000000058 RSI: 0000000000000008 RDI: 00000000000=
00282
[  376.791328] RBP: 0000000000000000 R08: fffffbfff0c60ea6 R09: fffffbfff0c=
60ea6
[  376.802050] R10: fffffbfff0c60ea5 R11: ffffffff8630752f R12: ffff8888582=
a6da0
[  376.812798] R13: dffffc0000000000 R14: ffff8888582a6da0 R15: 00000000000=
002c0
[  376.823445] FS:  00007f675f9a8840(0000) GS:ffff88886d200000(0000) knlGS:=
0000000000000000
[  376.834971] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  376.844179] CR2: 00000000007d9640 CR3: 00000007d3f26003 CR4: 00000000001=
606e0
[  376.854843] Call Trace:
[  376.868542]  __mlx5_eswitch_del_rule+0x49/0x300 [mlx5_core]
[  376.877735]  mlx5e_tc_del_fdb_flow+0x6ec/0x9e0 [mlx5_core]
[  376.921549]  mlx5e_flow_put+0x2b/0x50 [mlx5_core]
[  376.929813]  mlx5e_delete_flower+0x5b6/0xbd0 [mlx5_core]
[  376.973030]  tc_setup_cb_reoffload+0x29/0xc0
[  376.980619]  fl_reoffload+0x50a/0x770 [cls_flower]
[  377.015087]  tcf_block_playback_offloads+0xbd/0x250
[  377.033400]  tcf_block_setup+0x1b2/0xc60
[  377.057247]  tcf_block_offload_cmd+0x195/0x240
[  377.098826]  tcf_block_offload_unbind+0xe7/0x180
[  377.107056]  __tcf_block_put+0xe5/0x400
[  377.114528]  ingress_destroy+0x3d/0x60 [sch_ingress]
[  377.122894]  qdisc_destroy+0xf1/0x5a0
[  377.129993]  qdisc_graft+0xa3d/0xe50
[  377.151227]  tc_get_qdisc+0x48e/0xa20
[  377.165167]  rtnetlink_rcv_msg+0x35d/0x8d0
[  377.199528]  netlink_rcv_skb+0x11e/0x340
[  377.219638]  netlink_unicast+0x408/0x5b0
[  377.239913]  netlink_sendmsg+0x71b/0xb30
[  377.267505]  sock_sendmsg+0xb1/0xf0
[  377.273801]  ___sys_sendmsg+0x635/0x900
[  377.312784]  __sys_sendmsg+0xd3/0x170
[  377.338693]  do_syscall_64+0x95/0x460
[  377.344833]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  377.352321] RIP: 0033:0x7f675e58e090

To avoid this, for every mirred action check if output device was
already processed. If so - drop rule with EOPNOTSUPP error.

Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 58 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 9b32a9c0f497..fe83886f5435 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2999,6 +2999,25 @@ static struct ip_tunnel_info *dup_tun_info(const str=
uct ip_tunnel_info *tun_info
 	return kmemdup(tun_info, tun_size, GFP_KERNEL);
 }
=20
+static bool is_duplicated_encap_entry(struct mlx5e_priv *priv,
+				      struct mlx5e_tc_flow *flow,
+				      int out_index,
+				      struct mlx5e_encap_entry *e,
+				      struct netlink_ext_ack *extack)
+{
+	int i;
+
+	for (i =3D 0; i < out_index; i++) {
+		if (flow->encaps[i].e !=3D e)
+			continue;
+		NL_SET_ERR_MSG_MOD(extack, "can't duplicate encap action");
+		netdev_err(priv->netdev, "can't duplicate encap action\n");
+		return true;
+	}
+
+	return false;
+}
+
 static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow,
 			      struct net_device *mirred_dev,
@@ -3034,6 +3053,12 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pri=
v,
=20
 	/* must verify if encap is valid or not */
 	if (e) {
+		/* Check that entry was not already attached to this flow */
+		if (is_duplicated_encap_entry(priv, flow, out_index, e, extack)) {
+			err =3D -EOPNOTSUPP;
+			goto out_err;
+		}
+
 		mutex_unlock(&esw->offloads.encap_tbl_lock);
 		wait_for_completion(&e->res_ready);
=20
@@ -3220,6 +3245,26 @@ bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_pri=
v *priv,
 	       same_hw_devs(priv, netdev_priv(out_dev));
 }
=20
+static bool is_duplicated_output_device(struct net_device *dev,
+					struct net_device *out_dev,
+					int *ifindexes, int if_count,
+					struct netlink_ext_ack *extack)
+{
+	int i;
+
+	for (i =3D 0; i < if_count; i++) {
+		if (ifindexes[i] =3D=3D out_dev->ifindex) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "can't duplicate output to same device");
+			netdev_err(dev, "can't duplicate output to same device: %s\n",
+				   out_dev->name);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct flow_action *flow_action,
 				struct mlx5e_tc_flow *flow,
@@ -3231,11 +3276,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *=
priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr =3D attr->parse_attr;
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 	const struct ip_tunnel_info *info =3D NULL;
+	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	bool ft_flow =3D mlx5e_is_ft_flow(flow);
 	const struct flow_action_entry *act;
+	int err, i, if_count =3D 0;
 	bool encap =3D false;
 	u32 action =3D 0;
-	int err, i;
=20
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
@@ -3312,6 +3358,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *p=
riv,
 				struct net_device *uplink_dev =3D mlx5_eswitch_uplink_get_proto_dev(es=
w, REP_ETH);
 				struct net_device *uplink_upper;
=20
+				if (is_duplicated_output_device(priv->netdev,
+								out_dev,
+								ifindexes,
+								if_count,
+								extack))
+					return -EOPNOTSUPP;
+
+				ifindexes[if_count] =3D out_dev->ifindex;
+				if_count++;
+
 				rcu_read_lock();
 				uplink_upper =3D
 					netdev_master_upper_dev_get_rcu(uplink_dev);
--=20
2.24.1

