Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32BEB8A073
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfHLOMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:12:07 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:48710
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727206AbfHLOMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 10:12:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHF4oG8TaSDZTRC0A3mhIFcEJ79nnG4BqIvKlAelkvTDV83P8Ons3WkiNoEl+TtygOHKKV6Jm3G06zlOm0ml9ipNzK84zIjye15glUd6Ysguv3J5SZnfsGmPsrVYUJLwsU2TVCX4mXn3WJCU6IimWD5Ibwf+MjE11UtCBnwAK+USTwxomslT7cCoFmzOg6ceTD3ri6RIVU61MTE1IVZCiHz2NEEoLGP+xepkK46SqlLhehaw1Mraq/Bwx/MMdfAmVPRoW7ZtCc+TrDPFBgLXCQ0ar0yTZ5NjwN7bfaRWDr7LB8qoQloOCSLLZPgcb5CEi37KHIEJ5kTC9DKBwKMozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYP9c8RY/yssNgCMGuATG1rtN7VxMxpkpAAtrPYKMFU=;
 b=RtD3HIX11sH3KocUyQvasrCdb35EKPi1T+QI2suiYOmsHMaBWnyCfd7R7TTH0W7DSH3Cj3YpF6jtkCY9TdZ79pmMF/ThaihO+COjzvPmiNzBPYxq7B9BA76zft4SlnEwFs6YA3IqnGpOXtU49lZZ4pfXgDX9QVpIUg3nl7TQMLp9s9Zpr66DAYwatP45wQuATHUGapEZd0+JdN6QpZgI8GhYLIo+xjQQ4npTotUgJjkTBBuUk0tRn0wEU5wb5LL+s28cnEOiVOdL6P2wxqGeUDB3h1ZmcdYOgG1+MNNr7Vfa1LKJwBNejSEcLxCIbfkVNP/vY+dbmlvJbO1MRUHYVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYP9c8RY/yssNgCMGuATG1rtN7VxMxpkpAAtrPYKMFU=;
 b=RATRZyPE8zjkOHDcCN7DpHqevJVCbyyjkQlZtNrDoPCnzsWvHsS57lN3hcC0UBXAMLq72vTiUL9ClHhQ9G1dXW2op4wijgQbEPVYu3HRdlO3LLS7Q6V5bQt1NHv/XwzRRSipB7edkWARWL1VEFS5HIs7ic5hEN2rRRJsVUkiHb0=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4832.eurprd05.prod.outlook.com (20.177.50.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Mon, 12 Aug 2019 14:11:57 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 14:11:57 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@resnulli.us>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v7 5/6] flow_offload: support get multi-subsystem
 block
Thread-Topic: [PATCH net-next v7 5/6] flow_offload: support get
 multi-subsystem block
Thread-Index: AQHVTL1pG2KieeISTEa5YG2C2+XO7qb3lk2A
Date:   Mon, 12 Aug 2019 14:11:56 +0000
Message-ID: <vbfimr2o4ly.fsf@mellanox.com>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
 <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0209.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::29) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a421f3d-a275-49b9-6519-08d71f2f08df
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB4832;
x-ms-traffictypediagnostic: VI1PR05MB4832:
x-microsoft-antispam-prvs: <VI1PR05MB4832172D2DB446AC2307E457ADD30@VI1PR05MB4832.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(189003)(199004)(6486002)(66946007)(66476007)(25786009)(76176011)(229853002)(6436002)(5660300002)(2906002)(6512007)(316002)(66556008)(86362001)(64756008)(66446008)(6246003)(110136005)(54906003)(52116002)(4326008)(53936002)(2501003)(11346002)(305945005)(6506007)(186003)(81166006)(81156014)(8676002)(71200400001)(446003)(2616005)(102836004)(14454004)(476003)(7736002)(386003)(26005)(486006)(71190400001)(8936002)(99286004)(3846002)(6116002)(478600001)(14444005)(256004)(66066001)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4832;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ojyl5Dbz5oBQaQHo+UBnXcoriiwf0zNdBEyxmY0XfV/8LZ7YcjNeU9gzi5IUIgYkbn7NuNxwQn5bGVsUJh4ykathe26Pw3ZmnZyxR/FY3vLJ7rxvff7oA2HQIhjFKewfSh/jg/WHNckkRYe74uyrlp7o4SBKrtpy1j28CJgzJCFLD1URp83ET00V2dj+3Xkhqr0KWJji9gEQY717IPKJ87bAJXFsq07cHmr35D6ZaEjfdTlB1AzBvD0W+PCDrQDgnCv1a3OFzJNk7ppCQlRJhPwB6NGfg9bCtdEu3nOMmOSDi/X8qrWXSVBi2hL1dRCw6xqYnjKg5JosSHdAjXq/b+y6S8q3U6mSB64m549hK6W0HcqU+7Z2NJRx4MckcZiMrGzgS8PYAE+JGbu6+PUONhp69ZfzuZGlZiSdrivlmR8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a421f3d-a275-49b9-6519-08d71f2f08df
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 14:11:56.9956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zzyaw4eKWn5brGjQJSvKcXK04lYF/sZX8rhpWjCYL22KvjICCMYy0emrdP+FJTY3ZkiirTLod7ymZRnV+cGTDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4832
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 07 Aug 2019 at 04:13, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> It provide a callback list to find the blocks of tc
> and nft subsystems
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
> v7: add a mutex lock for add/del flow_indr_block_ing_cb
>
>  include/net/flow_offload.h | 10 ++++++++-
>  net/core/flow_offload.c    | 51 ++++++++++++++++++++++++++++++++++------=
------
>  net/sched/cls_api.c        |  9 +++++++-
>  3 files changed, 55 insertions(+), 15 deletions(-)
>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 46b8777..e8069b6 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -379,6 +379,15 @@ typedef void flow_indr_block_ing_cmd_t(struct net_de=
vice *dev,
>  					void *cb_priv,
>  					enum flow_block_command command);
> =20
> +struct flow_indr_block_ing_entry {
> +	flow_indr_block_ing_cmd_t *cb;
> +	struct list_head	list;
> +};
> +
> +void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry)=
;
> +
> +void flow_indr_del_block_ing_cb(struct flow_indr_block_ing_entry *entry)=
;
> +
>  int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>  				  flow_indr_block_bind_cb_t *cb,
>  				  void *cb_ident);
> @@ -395,7 +404,6 @@ void flow_indr_block_cb_unregister(struct net_device =
*dev,
>  				   void *cb_ident);
> =20
>  void flow_indr_block_call(struct net_device *dev,
> -			  flow_indr_block_ing_cmd_t *cb,
>  			  struct flow_block_offload *bo,
>  			  enum flow_block_command command);
> =20
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 4cc18e4..64c3d4d 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -3,6 +3,7 @@
>  #include <linux/slab.h>
>  #include <net/flow_offload.h>
>  #include <linux/rtnetlink.h>
> +#include <linux/mutex.h>
> =20
>  struct flow_rule *flow_rule_alloc(unsigned int num_actions)
>  {
> @@ -282,6 +283,8 @@ int flow_block_cb_setup_simple(struct flow_block_offl=
oad *f,
>  }
>  EXPORT_SYMBOL(flow_block_cb_setup_simple);
> =20
> +static LIST_HEAD(block_ing_cb_list);
> +
>  static struct rhashtable indr_setup_block_ht;
> =20
>  struct flow_indr_block_cb {
> @@ -295,7 +298,6 @@ struct flow_indr_block_dev {
>  	struct rhash_head ht_node;
>  	struct net_device *dev;
>  	unsigned int refcnt;
> -	flow_indr_block_ing_cmd_t  *block_ing_cmd_cb;
>  	struct list_head cb_list;
>  };
> =20
> @@ -389,6 +391,20 @@ static void flow_indr_block_cb_del(struct flow_indr_=
block_cb *indr_block_cb)
>  	kfree(indr_block_cb);
>  }
> =20
> +static void flow_block_ing_cmd(struct net_device *dev,
> +			       flow_indr_block_bind_cb_t *cb,
> +			       void *cb_priv,
> +			       enum flow_block_command command)
> +{
> +	struct flow_indr_block_ing_entry *entry;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &block_ing_cb_list, list) {
> +		entry->cb(dev, cb, cb_priv, command);
> +	}
> +	rcu_read_unlock();
> +}

Hi,

I'm getting following incorrect rcu usage warnings with this patch
caused by rcu_read_lock in flow_block_ing_cmd:

[  401.510948] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  401.510952] WARNING: suspicious RCU usage
[  401.510993] 5.3.0-rc3+ #589 Not tainted
[  401.510996] -----------------------------
[  401.511001] include/linux/rcupdate.h:265 Illegal context switch in RCU r=
ead-side critical section!
[  401.511004]
               other info that might help us debug this:

[  401.511008]
               rcu_scheduler_active =3D 2, debug_locks =3D 1
[  401.511012] 7 locks held by test-ecmp-add-v/7576:
[  401.511015]  #0: 00000000081d71a5 (sb_writers#4){.+.+}, at: vfs_write+0x=
166/0x1d0
[  401.511037]  #1: 000000002bd338c3 (&of->mutex){+.+.}, at: kernfs_fop_wri=
te+0xef/0x1b0
[  401.511051]  #2: 00000000c921c634 (kn->count#317){.+.+}, at: kernfs_fop_=
write+0xf7/0x1b0
[  401.511062]  #3: 00000000a19cdd56 (&dev->mutex){....}, at: sriov_numvfs_=
store+0x6b/0x130
[  401.511079]  #4: 000000005425fa52 (pernet_ops_rwsem){++++}, at: unregist=
er_netdevice_notifier+0x30/0x140
[  401.511092]  #5: 00000000c5822793 (rtnl_mutex){+.+.}, at: unregister_net=
device_notifier+0x35/0x140
[  401.511101]  #6: 00000000c2f3507e (rcu_read_lock){....}, at: flow_block_=
ing_cmd+0x5/0x130
[  401.511115]
               stack backtrace:
[  401.511121] CPU: 21 PID: 7576 Comm: test-ecmp-add-v Not tainted 5.3.0-rc=
3+ #589
[  401.511124] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0=
b 03/30/2017
[  401.511127] Call Trace:
[  401.511138]  dump_stack+0x85/0xc0
[  401.511146]  ___might_sleep+0x100/0x180
[  401.511154]  __mutex_lock+0x5b/0x960
[  401.511162]  ? find_held_lock+0x2b/0x80
[  401.511173]  ? __tcf_get_next_chain+0x1d/0xb0
[  401.511179]  ? mark_held_locks+0x49/0x70
[  401.511194]  ? __tcf_get_next_chain+0x1d/0xb0
[  401.511198]  __tcf_get_next_chain+0x1d/0xb0
[  401.511251]  ? uplink_rep_async_event+0x70/0x70 [mlx5_core]
[  401.511261]  tcf_block_playback_offloads+0x39/0x160
[  401.511276]  tcf_block_setup+0x1b0/0x240
[  401.511312]  ? mlx5e_rep_indr_setup_tc_cb+0xca/0x290 [mlx5_core]
[  401.511347]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
[  401.511359]  tc_indr_block_get_and_ing_cmd+0x11b/0x1e0
[  401.511404]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
[  401.511414]  flow_block_ing_cmd+0x7e/0x130
[  401.511453]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
[  401.511462]  __flow_indr_block_cb_unregister+0x7f/0xf0
[  401.511502]  mlx5e_nic_rep_netdevice_event+0x75/0xb0 [mlx5_core]
[  401.511513]  unregister_netdevice_notifier+0xe9/0x140
[  401.511554]  mlx5e_cleanup_rep_tx+0x6f/0xe0 [mlx5_core]
[  401.511597]  mlx5e_detach_netdev+0x4b/0x60 [mlx5_core]
[  401.511637]  mlx5e_vport_rep_unload+0x71/0xc0 [mlx5_core]
[  401.511679]  esw_offloads_disable+0x5b/0x90 [mlx5_core]
[  401.511724]  mlx5_eswitch_disable.cold+0xdf/0x176 [mlx5_core]
[  401.511759]  mlx5_device_disable_sriov+0xab/0xb0 [mlx5_core]
[  401.511794]  mlx5_core_sriov_configure+0xaf/0xd0 [mlx5_core]
[  401.511805]  sriov_numvfs_store+0xf8/0x130
[  401.511817]  kernfs_fop_write+0x122/0x1b0
[  401.511826]  vfs_write+0xdb/0x1d0
[  401.511835]  ksys_write+0x65/0xe0
[  401.511847]  do_syscall_64+0x5c/0xb0
[  401.511857]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  401.511862] RIP: 0033:0x7fad892d30f8
[  401.511868] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 =
f3 0f 1e fa 48 8d 05 25 96 0d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 60 c3 0f 1f 80 00 00 00 00 48 83
 ec 28 48 89
[  401.511871] RSP: 002b:00007ffca2a9fad8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000001
[  401.511875] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fad892=
d30f8
[  401.511878] RDX: 0000000000000002 RSI: 000055afeb072a90 RDI: 00000000000=
00001
[  401.511881] RBP: 000055afeb072a90 R08: 00000000ffffffff R09: 00000000000=
0000a
[  401.511884] R10: 000055afeb058710 R11: 0000000000000246 R12: 00000000000=
00002
[  401.511887] R13: 00007fad893a8780 R14: 0000000000000002 R15: 00007fad893=
a3740

I don't think it is correct approach to try to call these callbacks with
rcu protection because:

- Cls API uses sleeping locks that cannot be used in rcu read section
  (hence the included trace).

- It assumes that all implementation of classifier ops reoffload() don't
  sleep.

- And that all driver offload callbacks (both block and classifier
  setup) don't sleep, which is not the case.

I don't see any straightforward way to fix this, besides using some
other locking mechanism to protect block_ing_cb_list.

Regards,
Vlad
