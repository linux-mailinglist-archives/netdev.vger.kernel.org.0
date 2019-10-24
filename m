Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4056BE3C20
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406400AbfJXTjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:39:06 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:46757
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436879AbfJXTjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:39:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKAKkoE8c8hwijeA+q2zC0HaJRH1n79cI7s0hMJOLZ6S5Dyc3p2R7zcpl6cSB/gfXLz5FYh9yaeH1f3BTPm9MvkiLuaCvrGT+WgqbsBUn50vT9FG3PHWQfNZDB7pT7CMW4STjM4s6TpUmLctNa9MMazYfKBHBHILUnqX3uqWB58mmIKNBzWUBlUJv8k18YMGpFlgbi62ZZtVecX3o5MlnBQQC8T/9sdfiefd88IIFGqmjY+YdE2WtNXZ47bIz1ClAGgOYNKptGM6nDkkN+GX5X2xpmUNrY+C84GjNI96q4y+wEG+4aplmdUWtzXcK+2Loy53/LXGWa2+N8+EC8SzXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7hiFqZ2/LNMLNbSZu+cnde00+eYr81u5s5WCqc1RqE=;
 b=W1Nors+/YO0YXTe+yDIZFnLJe6rmwtN0YrrBWk1aSDaLE2rcrvNqvp1JP+9UNPKj+rg0VCFK4kQZE8vpMPaR1VfApVQ+XDngm8LtwC6EBasde64m/MFvyvLUhbx8VnIclJ+CbzyQYddlHk8SIlT9jEMlKQSL5Tojn59ZNlysu8iBalEK8vFZ71XWlrQarPqJWL4EOQ8Lu74Cd+gc+RhOEr3oNUitzaqIdCt8y7YSbC2ucqE6Me33C2O2IBt/qCkh8sQ0+p4jy8q9o6YVAHCcrOdURZW3kXuIasr3I/6ac3mD0CwZgegn1tNx7ji00dg8TG9IWDjXAu0QHRP8vPp3yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7hiFqZ2/LNMLNbSZu+cnde00+eYr81u5s5WCqc1RqE=;
 b=cXmuPDTNPVX0jkJX0LaJztkyIFaDj2RbEVNICMyPczc1iiDTVhju/DcuHJuDk4ABQFM2Aw9ebpUoWlYoLDJJc6qA/IxjC5IhBHCOItN4lf2dpRnVbG0yyyRbD5a+JHinjh9fOxRW3WbaJRnTlXI7Lhw7riS3QiljoW7LCamm0h4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/11] net/mlx5e: Don't store direct pointer to action's tunnel
 info
Thread-Topic: [net 08/11] net/mlx5e: Don't store direct pointer to action's
 tunnel info
Thread-Index: AQHViqKt+Eicgu+NhkGQa5z2z6A4ug==
Date:   Thu, 24 Oct 2019 19:38:56 +0000
Message-ID: <20191024193819.10389-9-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b3a308a5-2bac-4c81-31ef-08d758b9cf62
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB46236B7E7CAF947FE80609F1BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(5024004)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(14444005)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(30864003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PlBh2Rxs1QdKdMPXbPFSqxgzd/IYMdiMMaiUsV3Uui63RxvmB9V8p1ssXJlT8y/kbVU+sV00w2tWZQgfEWiHCt9z+bJnAOwumEYV5edEMrbqIf66Tu+R1TIeJI1D/Oraiy7zdpF0W8ZCfSauIJMsRiLhgWJajW4fmLGnQUzk6+Dh540k06hfYw3Y6p/FpZFAe7LtbY63puR58igN4LDS0hcJ8StgyMlMCUsHiXdbLFB7bbY6rawrhGFM1GD+7kaAQCIRp6n8Y/qXa5Gm2swZt6PIzEgTKbHVhZIZ6mypFixYAp8LOUtuBnkb7HizEC1/W9uYuGv1K2W4EYrw+Q+WbReU6r/8EJBlfZMCV9Eqg1uyG1hk6IuOW8R0cAL6vihIf0GcKY3Iv+9uUsFxsUZdBuvCXevXvug+UNT1AGQ0zwYTJd/iZ4gGo1Zmn5WDhJRL
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a308a5-2bac-4c81-31ef-08d758b9cf62
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:56.9776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hL+HU+8hQuk3iNLv8M0wmhWbwm1/TBrbO6CbdbjHzj/xt9P5VX6ZXYb4y1p7+ZACuJLFDzV6iI0xAYkg5lbBGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Geneve implementation changed mlx5 tc to user direct pointer to tunnel_key
action's internal struct ip_tunnel_info instance. However, this leads to
use-after-free error when initial filter that caused creation of new encap
entry is deleted or when tunnel_key action is manually overwritten through
action API. Moreover, with recent TC offloads API unlocking change struct
flow_action_entry->tunnel point to temporal copy of tunnel info that is
deallocated after filter is offloaded to hardware which causes bug to
reproduce every time new filter is attached to existing encap entry with
following KASAN bug:

[  314.885555] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  314.886641] BUG: KASAN: use-after-free in memcmp+0x2c/0x60
[  314.886864] Read of size 1 at addr ffff88886c746280 by task tc/2682

[  314.887179] CPU: 22 PID: 2682 Comm: tc Not tainted 5.3.0-rc7+ #703
[  314.887188] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0=
b 03/30/2017
[  314.887195] Call Trace:
[  314.887215]  dump_stack+0x9a/0xf0
[  314.887236]  print_address_description+0x67/0x323
[  314.887248]  ? memcmp+0x2c/0x60
[  314.887257]  ? memcmp+0x2c/0x60
[  314.887272]  __kasan_report.cold+0x1a/0x3d
[  314.887474]  ? __mlx5e_tc_del_fdb_peer_flow+0x100/0x1b0 [mlx5_core]
[  314.887484]  ? memcmp+0x2c/0x60
[  314.887509]  kasan_report+0xe/0x12
[  314.887521]  memcmp+0x2c/0x60
[  314.887662]  mlx5e_tc_add_fdb_flow+0x51b/0xbe0 [mlx5_core]
[  314.887838]  ? mlx5e_encap_take+0x110/0x110 [mlx5_core]
[  314.887902]  ? lockdep_init_map+0x87/0x2c0
[  314.887924]  ? __init_waitqueue_head+0x4f/0x60
[  314.888062]  ? mlx5e_alloc_flow.isra.0+0x18c/0x1c0 [mlx5_core]
[  314.888207]  __mlx5e_add_fdb_flow+0x2d7/0x440 [mlx5_core]
[  314.888359]  ? mlx5e_tc_update_neigh_used_value+0x6f0/0x6f0 [mlx5_core]
[  314.888374]  ? match_held_lock+0x2e/0x240
[  314.888537]  mlx5e_configure_flower+0x830/0x16a0 [mlx5_core]
[  314.888702]  ? __mlx5e_add_fdb_flow+0x440/0x440 [mlx5_core]
[  314.888713]  ? down_read+0x118/0x2c0
[  314.888728]  ? down_read_killable+0x300/0x300
[  314.888882]  ? mlx5e_rep_get_ethtool_stats+0x180/0x180 [mlx5_core]
[  314.888899]  tc_setup_cb_add+0x127/0x270
[  314.888937]  fl_hw_replace_filter+0x2ac/0x380 [cls_flower]
[  314.888976]  ? fl_hw_destroy_filter+0x1b0/0x1b0 [cls_flower]
[  314.888990]  ? fl_change+0xbcf/0x27ef [cls_flower]
[  314.889030]  ? fl_change+0xa57/0x27ef [cls_flower]
[  314.889069]  fl_change+0x16bd/0x27ef [cls_flower]
[  314.889135]  ? __rhashtable_insert_fast.constprop.0+0xa00/0xa00 [cls_flo=
wer]
[  314.889167]  ? __radix_tree_lookup+0xa4/0x130
[  314.889200]  ? fl_get+0x169/0x240 [cls_flower]
[  314.889218]  ? fl_walk+0x230/0x230 [cls_flower]
[  314.889249]  tc_new_tfilter+0x5e1/0xd40
[  314.889281]  ? __rhashtable_insert_fast.constprop.0+0xa00/0xa00 [cls_flo=
wer]
[  314.889309]  ? tc_del_tfilter+0xa30/0xa30
[  314.889335]  ? __lock_acquire+0x5b5/0x2460
[  314.889378]  ? find_held_lock+0x85/0xa0
[  314.889442]  ? tc_del_tfilter+0xa30/0xa30
[  314.889465]  rtnetlink_rcv_msg+0x4ab/0x5f0
[  314.889488]  ? rtnl_dellink+0x490/0x490
[  314.889518]  ? lockdep_hardirqs_on+0x260/0x260
[  314.889538]  ? netlink_deliver_tap+0xab/0x5a0
[  314.889550]  ? match_held_lock+0x1b/0x240
[  314.889575]  netlink_rcv_skb+0xd0/0x200
[  314.889588]  ? rtnl_dellink+0x490/0x490
[  314.889605]  ? netlink_ack+0x440/0x440
[  314.889635]  ? netlink_deliver_tap+0x161/0x5a0
[  314.889648]  ? lock_downgrade+0x360/0x360
[  314.889657]  ? lock_acquire+0xe5/0x210
[  314.889686]  netlink_unicast+0x296/0x350
[  314.889707]  ? netlink_attachskb+0x390/0x390
[  314.889726]  ? _copy_from_iter_full+0xe0/0x3a0
[  314.889738]  ? __virt_addr_valid+0xbb/0x130
[  314.889771]  netlink_sendmsg+0x394/0x600
[  314.889800]  ? netlink_unicast+0x350/0x350
[  314.889817]  ? move_addr_to_kernel.part.0+0x90/0x90
[  314.889852]  ? netlink_unicast+0x350/0x350
[  314.889872]  sock_sendmsg+0x96/0xa0
[  314.889891]  ___sys_sendmsg+0x482/0x520
[  314.889919]  ? copy_msghdr_from_user+0x250/0x250
[  314.889930]  ? __fput+0x1fa/0x390
[  314.889941]  ? task_work_run+0xb7/0xf0
[  314.889957]  ? exit_to_usermode_loop+0x117/0x120
[  314.889972]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  314.889982]  ? do_syscall_64+0x74/0xe0
[  314.889992]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  314.890012]  ? mark_lock+0xac/0x9a0
[  314.890028]  ? __lock_acquire+0x5b5/0x2460
[  314.890053]  ? mark_lock+0xac/0x9a0
[  314.890083]  ? __lock_acquire+0x5b5/0x2460
[  314.890112]  ? match_held_lock+0x1b/0x240
[  314.890144]  ? __fget_light+0xa1/0xf0
[  314.890166]  ? sockfd_lookup_light+0x91/0xb0
[  314.890187]  __sys_sendmsg+0xba/0x130
[  314.890201]  ? __sys_sendmsg_sock+0xb0/0xb0
[  314.890225]  ? __blkcg_punt_bio_submit+0xd0/0xd0
[  314.890264]  ? lockdep_hardirqs_off+0xbe/0x100
[  314.890274]  ? mark_held_locks+0x24/0x90
[  314.890286]  ? do_syscall_64+0x1e/0xe0
[  314.890308]  do_syscall_64+0x74/0xe0
[  314.890325]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  314.890336] RIP: 0033:0x7f00ca33d7b8
[  314.890348] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 =
f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 5
4
[  314.890356] RSP: 002b:00007ffea2983928 EFLAGS: 00000246 ORIG_RAX: 000000=
000000002e
[  314.890369] RAX: ffffffffffffffda RBX: 000000005d777d5b RCX: 00007f00ca3=
3d7b8
[  314.890377] RDX: 0000000000000000 RSI: 00007ffea2983990 RDI: 00000000000=
00003
[  314.890384] RBP: 0000000000000000 R08: 0000000000000001 R09: 00000000000=
00006
[  314.890392] R10: 0000000000404eda R11: 0000000000000246 R12: 00000000000=
00001
[  314.890400] R13: 000000000047f640 R14: 00007ffea2987b58 R15: 00000000000=
00021

[  314.890529] Allocated by task 2687:
[  314.890684]  save_stack+0x1b/0x80
[  314.890694]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[  314.890705]  __kmalloc_track_caller+0x102/0x340
[  314.890721]  kmemdup+0x1d/0x40
[  314.890730]  tc_setup_flow_action+0x731/0x2c27
[  314.890743]  fl_hw_replace_filter+0x23b/0x380 [cls_flower]
[  314.890756]  fl_change+0x16bd/0x27ef [cls_flower]
[  314.890765]  tc_new_tfilter+0x5e1/0xd40
[  314.890776]  rtnetlink_rcv_msg+0x4ab/0x5f0
[  314.890786]  netlink_rcv_skb+0xd0/0x200
[  314.890796]  netlink_unicast+0x296/0x350
[  314.890805]  netlink_sendmsg+0x394/0x600
[  314.890815]  sock_sendmsg+0x96/0xa0
[  314.890825]  ___sys_sendmsg+0x482/0x520
[  314.890834]  __sys_sendmsg+0xba/0x130
[  314.890844]  do_syscall_64+0x74/0xe0
[  314.890854]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[  314.890937] Freed by task 2687:
[  314.891076]  save_stack+0x1b/0x80
[  314.891086]  __kasan_slab_free+0x12c/0x170
[  314.891095]  kfree+0xeb/0x2f0
[  314.891106]  tc_cleanup_flow_action+0x69/0xa0
[  314.891119]  fl_hw_replace_filter+0x2c5/0x380 [cls_flower]
[  314.891132]  fl_change+0x16bd/0x27ef [cls_flower]
[  314.891140]  tc_new_tfilter+0x5e1/0xd40
[  314.891151]  rtnetlink_rcv_msg+0x4ab/0x5f0
[  314.891161]  netlink_rcv_skb+0xd0/0x200
[  314.891170]  netlink_unicast+0x296/0x350
[  314.891180]  netlink_sendmsg+0x394/0x600
[  314.891190]  sock_sendmsg+0x96/0xa0
[  314.891200]  ___sys_sendmsg+0x482/0x520
[  314.891208]  __sys_sendmsg+0xba/0x130
[  314.891218]  do_syscall_64+0x74/0xe0
[  314.891228]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[  314.891315] The buggy address belongs to the object at ffff88886c746280
                which belongs to the cache kmalloc-96 of size 96
[  314.891762] The buggy address is located 0 bytes inside of
                96-byte region [ffff88886c746280, ffff88886c7462e0)
[  314.892196] The buggy address belongs to the page:
[  314.892387] page:ffffea0021b1d180 refcount:1 mapcount:0 mapping:ffff8883=
5d00ef80 index:0x0
[  314.892398] flags: 0x57ffffc0000200(slab)
[  314.892413] raw: 0057ffffc0000200 ffffea00219e0340 0000000800000008 ffff=
88835d00ef80
[  314.892423] raw: 0000000000000000 0000000080200020 00000001ffffffff 0000=
000000000000
[  314.892430] page dumped because: kasan: bad access detected

[  314.892515] Memory state around the buggy address:
[  314.892707]  ffff88886c746180: fb fb fb fb fb fb fb fb fb fb fb fb fc fc=
 fc fc
[  314.892976]  ffff88886c746200: fb fb fb fb fb fb fb fb fb fb fb fb fc fc=
 fc fc
[  314.893251] >ffff88886c746280: fb fb fb fb fb fb fb fb fb fb fb fb fc fc=
 fc fc
[  314.893522]                    ^
[  314.893657]  ffff88886c746300: fb fb fb fb fb fb fb fb fb fb fb fb fc fc=
 fc fc
[  314.893924]  ffff88886c746380: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc=
 fc fc
[  314.894189] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Fix the issue by duplicating tunnel info into per-encap copy that is
deallocated with encap structure. Also, duplicate tunnel info in flow parse
attribute to support cases when flow might be attached asynchronously.

Fixes: 1f6da30697d0 ("net/mlx5e: Geneve, Keep tunnel info as pointer to the=
 original struct")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 34 +++++++++++++++----
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 3e78a727f3e6..3b34b19e02d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1278,8 +1278,10 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv =
*priv,
 	mlx5_eswitch_del_vlan_action(esw, attr);
=20
 	for (out_index =3D 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
-		if (attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP)
+		if (attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP) {
 			mlx5e_detach_encap(priv, flow, out_index);
+			kfree(attr->parse_attr->tun_info[out_index]);
+		}
 	kvfree(attr->parse_attr);
=20
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
@@ -1559,6 +1561,7 @@ static void mlx5e_encap_dealloc(struct mlx5e_priv *pr=
iv, struct mlx5e_encap_entr
 			mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
 	}
=20
+	kfree(e->tun_info);
 	kfree(e->encap_header);
 	kfree_rcu(e, rcu);
 }
@@ -2972,6 +2975,13 @@ mlx5e_encap_get(struct mlx5e_priv *priv, struct enca=
p_key *key,
 	return NULL;
 }
=20
+static struct ip_tunnel_info *dup_tun_info(const struct ip_tunnel_info *tu=
n_info)
+{
+	size_t tun_size =3D sizeof(*tun_info) + tun_info->options_len;
+
+	return kmemdup(tun_info, tun_size, GFP_KERNEL);
+}
+
 static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow,
 			      struct net_device *mirred_dev,
@@ -3028,13 +3038,15 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pr=
iv,
 	refcount_set(&e->refcnt, 1);
 	init_completion(&e->res_ready);
=20
+	tun_info =3D dup_tun_info(tun_info);
+	if (!tun_info) {
+		err =3D -ENOMEM;
+		goto out_err_init;
+	}
 	e->tun_info =3D tun_info;
 	err =3D mlx5e_tc_tun_init_encap_attr(mirred_dev, priv, e, extack);
-	if (err) {
-		kfree(e);
-		e =3D NULL;
-		goto out_err;
-	}
+	if (err)
+		goto out_err_init;
=20
 	INIT_LIST_HEAD(&e->flows);
 	hash_add_rcu(esw->offloads.encap_tbl, &e->encap_hlist, hash_key);
@@ -3075,6 +3087,12 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pri=
v,
 	if (e)
 		mlx5e_encap_put(priv, e);
 	return err;
+
+out_err_init:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	kfree(tun_info);
+	kfree(e);
+	return err;
 }
=20
 static int parse_tc_vlan_action(struct mlx5e_priv *priv,
@@ -3295,7 +3313,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *pr=
iv,
 			} else if (encap) {
 				parse_attr->mirred_ifindex[attr->out_count] =3D
 					out_dev->ifindex;
-				parse_attr->tun_info[attr->out_count] =3D info;
+				parse_attr->tun_info[attr->out_count] =3D dup_tun_info(info);
+				if (!parse_attr->tun_info[attr->out_count])
+					return -ENOMEM;
 				encap =3D false;
 				attr->dests[attr->out_count].flags |=3D
 					MLX5_ESW_DEST_ENCAP;
--=20
2.21.0

