Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC73690450
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfHPPEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:04:51 -0400
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:23475
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727217AbfHPPEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 11:04:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jdyjen95EUtmmLOk2OG2vQQqoxegx8QJavCLISajRQmyWKpVyqRIG+lsoJY/GFkPx4QCWv5y8T1JlNJLfeC0aCBy0MB5gkzmpgpdasAFgsHAlQL5rzxc9vf53c7bRMwOj0EC95zRizmYL3owHFJnadmH0NPB/zrnalmLw0aZCDq0TjJRkd6U3BPeCky7LEx7VvpsKbNoMFkhimOZPgbXEvRJOLEo7s/dnJrBpnUykFs16FJsGTjXUiMvbRrxVJpSly2Jd/tJ/Tf4jvizngSDygvqQWDOPlt4VBdy+ION74cTTTROuD/+zHmf3Gg8C6UrA9j0cya8wAYDA3QqGCr3hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Su/5V7rw+Jk8LFbn5MfyXJ9yVRaZUX8XMCH5s6RcXbU=;
 b=OGC4nMraMjWo2FTUw0NoAmkKN5iP8uOWK+dkenY4ATuhPTSKQlHyGlqzXCBydeh1v6pml53umFMOEKG4M+/IUgxdI4Q/bomF0lBnRSDr9nT71ggo2ylpGhD3Zb06+5ylZ9th25P+Uh5vTTul7MJ6TRhyTUK+YVlYd7sYcmuEcn1g7ClvBT+m4RBNGl1Y7xgP/bdh6dQ6xTr2PYHj/izxXNMAx+47Xdenn7fTSOvIxxyd6SmYxXBLj3xzydOU1F7K2xqgJZsUFY4I/9tORlZOUN+bgY8fXjGclwoaOY8VNNw0GTO1lReB0wPF2rJnqxpHlseXFHzMUow1EbjwxdyDsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Su/5V7rw+Jk8LFbn5MfyXJ9yVRaZUX8XMCH5s6RcXbU=;
 b=kR8xBByitTTO6Lp54sGWvN+RNVbZw0Auln3o9dDfzQNZICa4mTEv1sBzFElCUY2FqRvwIM5jPRQyftw+mVCJIgDaULaVXyDYuQsPnC4FLHsWE0z0/LhJusxq9iKR3adkCfQNlSqreQe7AWhW9M5algQcZ3yPj8TmHBvFpYYZkVg=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6013.eurprd05.prod.outlook.com (20.178.127.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 16 Aug 2019 15:04:44 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.016; Fri, 16 Aug 2019
 15:04:44 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v7 5/6] flow_offload: support get multi-subsystem
 block
Thread-Topic: [PATCH net-next v7 5/6] flow_offload: support get
 multi-subsystem block
Thread-Index: AQHVTL1pG2KieeISTEa5YG2C2+XO7qb3lk2AgAJmXYCAA/G0gA==
Date:   Fri, 16 Aug 2019 15:04:44 +0000
Message-ID: <vbfpnl55eyg.fsf@mellanox.com>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
 <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
 <vbfimr2o4ly.fsf@mellanox.com>
 <f28ddefe-a7d8-e5ad-e03e-08cfee4db147@ucloud.cn>
In-Reply-To: <f28ddefe-a7d8-e5ad-e03e-08cfee4db147@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0085.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::25) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1317def-ca4e-4055-d580-08d7225b125c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6013;
x-ms-traffictypediagnostic: VI1PR05MB6013:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB60137AA3BF1206A0A1F6E474ADAF0@VI1PR05MB6013.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(53546011)(3846002)(14454004)(5660300002)(478600001)(4326008)(25786009)(14444005)(6916009)(6486002)(386003)(256004)(6506007)(26005)(66556008)(64756008)(66066001)(6436002)(11346002)(66446008)(446003)(476003)(66946007)(86362001)(186003)(486006)(66476007)(7736002)(52116002)(81156014)(71200400001)(71190400001)(36756003)(316002)(305945005)(6512007)(54906003)(53936002)(81166006)(2616005)(6246003)(99286004)(8676002)(229853002)(102836004)(8936002)(6116002)(2906002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6013;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JykHtvVdiE30Rpvuopdl8UN3BjZqcFW2YeWs75u7/tFXpUuqIwMM2vLHB9Nylp5seSDYW03BKIOjspfxYe9Y3uMbncElDPNobJukYfRJbuJZkFeH36yhtJ1ITYnnxvB7dfrrf9AjAF8Qfyef9llEAVTFuceQ1yq1UxY3kV4ebgHXZEb0FNkq1TtQHGO8IpKV7p13p3whcCFBaMpOAfbDFGuZ2cinCLW7DhprNZl3zDE5Hfs0TZp5UQEaFQo7caxFr5e26UFATzOjNPkanGmgQVL2DiFj5BTwRztaIVaHSio/I41sViM0X25x8dIzyEciun9bmvwB/uDdlOZmWo96/ZlLxgkfQA9TVgk+pODdL3r6iLEhcSpy5VUGxxUb/TkA3i1COEZjx+b+KlvT09fdJ1ck8RyYXngYcb2eqbw21UE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1317def-ca4e-4055-d580-08d7225b125c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 15:04:44.4305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KXorlaTrXIz7eVIQZtZzc7EYSQb9rtDVgWZ420F0vbsYqfF+N2GfkQ8rYRdx6CKpsxajAKZSIYGn84ogo7rcMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6013
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 14 Aug 2019 at 05:50, wenxu <wenxu@ucloud.cn> wrote:
> On 8/12/2019 10:11 PM, Vlad Buslov wrote:
>>
>>> +static void flow_block_ing_cmd(struct net_device *dev,
>>> +			       flow_indr_block_bind_cb_t *cb,
>>> +			       void *cb_priv,
>>> +			       enum flow_block_command command)
>>> +{
>>> +	struct flow_indr_block_ing_entry *entry;
>>> +
>>> +	rcu_read_lock();
>>> +	list_for_each_entry_rcu(entry, &block_ing_cb_list, list) {
>>> +		entry->cb(dev, cb, cb_priv, command);
>>> +	}
>>> +	rcu_read_unlock();
>>> +}
>> Hi,
>>
>> I'm getting following incorrect rcu usage warnings with this patch
>> caused by rcu_read_lock in flow_block_ing_cmd:
>>
>> [  401.510948] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [  401.510952] WARNING: suspicious RCU usage
>> [  401.510993] 5.3.0-rc3+ #589 Not tainted
>> [  401.510996] -----------------------------
>> [  401.511001] include/linux/rcupdate.h:265 Illegal context switch in RC=
U read-side critical section!
>> [  401.511004]
>>                other info that might help us debug this:
>>
>> [  401.511008]
>>                rcu_scheduler_active =3D 2, debug_locks =3D 1
>> [  401.511012] 7 locks held by test-ecmp-add-v/7576:
>> [  401.511015]  #0: 00000000081d71a5 (sb_writers#4){.+.+}, at: vfs_write=
+0x166/0x1d0
>> [  401.511037]  #1: 000000002bd338c3 (&of->mutex){+.+.}, at: kernfs_fop_=
write+0xef/0x1b0
>> [  401.511051]  #2: 00000000c921c634 (kn->count#317){.+.+}, at: kernfs_f=
op_write+0xf7/0x1b0
>> [  401.511062]  #3: 00000000a19cdd56 (&dev->mutex){....}, at: sriov_numv=
fs_store+0x6b/0x130
>> [  401.511079]  #4: 000000005425fa52 (pernet_ops_rwsem){++++}, at: unreg=
ister_netdevice_notifier+0x30/0x140
>> [  401.511092]  #5: 00000000c5822793 (rtnl_mutex){+.+.}, at: unregister_=
netdevice_notifier+0x35/0x140
>> [  401.511101]  #6: 00000000c2f3507e (rcu_read_lock){....}, at: flow_blo=
ck_ing_cmd+0x5/0x130
>> [  401.511115]
>>                stack backtrace:
>> [  401.511121] CPU: 21 PID: 7576 Comm: test-ecmp-add-v Not tainted 5.3.0=
-rc3+ #589
>> [  401.511124] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS =
2.0b 03/30/2017
>> [  401.511127] Call Trace:
>> [  401.511138]  dump_stack+0x85/0xc0
>> [  401.511146]  ___might_sleep+0x100/0x180
>> [  401.511154]  __mutex_lock+0x5b/0x960
>> [  401.511162]  ? find_held_lock+0x2b/0x80
>> [  401.511173]  ? __tcf_get_next_chain+0x1d/0xb0
>> [  401.511179]  ? mark_held_locks+0x49/0x70
>> [  401.511194]  ? __tcf_get_next_chain+0x1d/0xb0
>> [  401.511198]  __tcf_get_next_chain+0x1d/0xb0
>> [  401.511251]  ? uplink_rep_async_event+0x70/0x70 [mlx5_core]
>> [  401.511261]  tcf_block_playback_offloads+0x39/0x160
>> [  401.511276]  tcf_block_setup+0x1b0/0x240
>> [  401.511312]  ? mlx5e_rep_indr_setup_tc_cb+0xca/0x290 [mlx5_core]
>> [  401.511347]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
>> [  401.511359]  tc_indr_block_get_and_ing_cmd+0x11b/0x1e0
>> [  401.511404]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
>> [  401.511414]  flow_block_ing_cmd+0x7e/0x130
>> [  401.511453]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
>> [  401.511462]  __flow_indr_block_cb_unregister+0x7f/0xf0
>> [  401.511502]  mlx5e_nic_rep_netdevice_event+0x75/0xb0 [mlx5_core]
>> [  401.511513]  unregister_netdevice_notifier+0xe9/0x140
>> [  401.511554]  mlx5e_cleanup_rep_tx+0x6f/0xe0 [mlx5_core]
>> [  401.511597]  mlx5e_detach_netdev+0x4b/0x60 [mlx5_core]
>> [  401.511637]  mlx5e_vport_rep_unload+0x71/0xc0 [mlx5_core]
>> [  401.511679]  esw_offloads_disable+0x5b/0x90 [mlx5_core]
>> [  401.511724]  mlx5_eswitch_disable.cold+0xdf/0x176 [mlx5_core]
>> [  401.511759]  mlx5_device_disable_sriov+0xab/0xb0 [mlx5_core]
>> [  401.511794]  mlx5_core_sriov_configure+0xaf/0xd0 [mlx5_core]
>> [  401.511805]  sriov_numvfs_store+0xf8/0x130
>> [  401.511817]  kernfs_fop_write+0x122/0x1b0
>> [  401.511826]  vfs_write+0xdb/0x1d0
>> [  401.511835]  ksys_write+0x65/0xe0
>> [  401.511847]  do_syscall_64+0x5c/0xb0
>> [  401.511857]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  401.511862] RIP: 0033:0x7fad892d30f8
>> [  401.511868] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 =
00 f3 0f 1e fa 48 8d 05 25 96 0d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 =
<48> 3d 00 f0 ff ff 77 60 c3 0f 1f 80 00 00 00 00 48 83
>>  ec 28 48 89
>> [  401.511871] RSP: 002b:00007ffca2a9fad8 EFLAGS: 00000246 ORIG_RAX: 000=
0000000000001
>> [  401.511875] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fad=
892d30f8
>> [  401.511878] RDX: 0000000000000002 RSI: 000055afeb072a90 RDI: 00000000=
00000001
>> [  401.511881] RBP: 000055afeb072a90 R08: 00000000ffffffff R09: 00000000=
0000000a
>> [  401.511884] R10: 000055afeb058710 R11: 0000000000000246 R12: 00000000=
00000002
>> [  401.511887] R13: 00007fad893a8780 R14: 0000000000000002 R15: 00007fad=
893a3740
>>
>> I don't think it is correct approach to try to call these callbacks with
>> rcu protection because:
>>
>> - Cls API uses sleeping locks that cannot be used in rcu read section
>>   (hence the included trace).
>>
>> - It assumes that all implementation of classifier ops reoffload() don't
>>   sleep.
>>
>> - And that all driver offload callbacks (both block and classifier
>>   setup) don't sleep, which is not the case.
>>
>> I don't see any straightforward way to fix this, besides using some
>> other locking mechanism to protect block_ing_cb_list.
>>
>> Regards,
>> Vlad
>
> Maybe get the  mutex flow_indr_block_ing_cb_lock for both lookup, add, de=
lete?=20
>
> the callbacks_lists. the add and delete is work only on modules init case=
. So the
>
> lookup is also not frequently(ony [un]register) and can protect with the =
locks.

That should do the job. I'll send the patch.
