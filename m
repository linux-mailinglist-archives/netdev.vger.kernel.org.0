Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D054613B647
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 00:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgANX7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 18:59:20 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:54247 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbgANX7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 18:59:20 -0500
Received: from [192.168.1.4] (unknown [116.235.56.174])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id EC69140F42;
        Wed, 15 Jan 2020 07:59:15 +0800 (CST)
Subject: Re: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta
 support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
 <c4d6fe12986bd2b21faf831eb76f0f472ef903d1.camel@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c6d4c563-f173-9ff6-83e5-95b246d90526@ucloud.cn>
Date:   Wed, 15 Jan 2020 07:58:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <c4d6fe12986bd2b21faf831eb76f0f472ef903d1.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTUhCS0tLS05DSkxPSkhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhQ6Dww4TTg0FjIKT0tLHUMr
        Lz1PCT5VSlVKTkxCS09NSE5MSUJLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE5VTk1VSkxPWVdZCAFZQUNITUo3Bg++
X-HM-Tid: 0a6fa67f44e92086kuqyec69140f42
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


  2020/1/15 4:46, Saeed Mahameed :
> Hi Wenxu,
>
> According to our regression Team, This commit is breaking vxlan offload
> CC'ed Paul, Roi and Vlad, they will assist you if you need any help.
>
> can you please investigate the following call trace ?

Hi Saeed & Paul,


This patch just check the meta key match with the filter_dev.  If this 
match failed,

The new flower install will failed and never allocate new mlx5_fs_ftes.

How can I reproduce this case? Can you provide the test case script?


BR

wenxu

>
>
> [  363.789805] #####################################
>   [  363.791150] ## TEST test-vxlan-port-offload.sh ##
>   [  363.792499] #####################################
>   [  364.916862] :test: Test adding vxlan rule after creating vxlan
> interface and reloading modules
>   [  364.926877] :test: - create vxlan interface
>   [  364.938976] :test: - reload modules
>   [  365.689825] mlx5_core 0000:00:08.3 enp0s8f3: Link down
>   [  365.790063] mlx5_core 0000:00:08.2 enp0s8f2: Link down
>   [  366.040167] mlx5_core 0000:00:08.6 enp0s8f6: Link down
>   [  370.399771] mlx5_core 0000:00:08.1: E-Switch: Disable:
> mode(OFFLOADS), nvfs(1), active vports(2)
>   [  371.006097] mlx5_core 0000:00:08.1: E-Switch: cleanup
>   [  371.581179] mlx5_core 0000:00:08.1: driver left SR-IOV enabled
> after remove
>   [  371.585021] mlx5_core 0000:00:08.0: E-Switch: Disable:
> mode(OFFLOADS), nvfs(3), active vports(4)
>   [  371.743029]
> =======================================================================
> ======
>   [  371.746917] BUG mlx5_fs_ftes (Not tainted): Objects remaining in
> mlx5_fs_ftes on __kmem_cache_shutdown()
>   [  371.751265] -----------------------------------------------------
> ------------------------
>   [  371.751265]
>   [  371.754662] Disabling lock debugging due to kernel taint
>   [  371.755672] INFO: Slab 0x00000000c3fc424e objects=27 used=1
> fp=0x00000000b711cbdf flags=0x8000000000010200
>   [  371.757523] CPU: 0 PID: 13112 Comm: modprobe Tainted:
> G    B             5.5.0-rc4-J8553-G8b261307a8b0 #1
>   [  371.759458] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>   [  371.761692] Call Trace:
>   [  371.762378]  dump_stack+0x50/0x70
>   [  371.763168]  slab_err+0xb7/0xdc
>   [  371.763936]  ? slub_cpu_dead+0x10/0xa0
>   [  371.764873]  ? on_each_cpu_cond_mask+0x7a/0xa0
>   [  371.765919]  ? __kmalloc+0x19f/0x1f0
>   [  371.766749]  __kmem_cache_shutdown.cold+0x1b/0x12f
>   [  371.767769]  kmem_cache_destroy+0x45/0xe0
>   [  371.768669]  mlx5_cleanup_fs+0x12c/0x150 [mlx5_core]
>   [  371.769753]  mlx5_unload+0x1e/0x70 [mlx5_core]
>   [  371.770744]  mlx5_unload_one+0x49/0xb0 [mlx5_core]
>   [  371.771772]  remove_one+0x38/0x80 [mlx5_core]
>   [  371.772724]  pci_device_remove+0x36/0xa0
>   [  371.773625]  device_release_driver_internal+0xe1/0x1b0
>   [  371.774731]  driver_detach+0x3f/0x79
>   [  371.775532]  bus_remove_driver+0x58/0xcc
>   [  371.776407]  pci_unregister_driver+0x2d/0x90
>   [  371.777436]  cleanup+0x11/0x254 [mlx5_core]
>   [  371.778376]  __x64_sys_delete_module+0x11b/0x1f0
>   [  371.779358]  ? exit_to_usermode_loop+0xac/0xb0
>   [  371.780314]  do_syscall_64+0x42/0x130
>   [  371.781129]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   [  371.782305] RIP: 0033:0x7f0496589ae7
>   [  371.783107] Code: 73 01 c3 48 8b 0d 99 a3 2b 00 f7 d8 64 89 01 48
> 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00
> 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 69 a3 2b 00 f7 d8 64 89 01
> 48
>   [  371.786595] RSP: 002b:00007ffd14aff778 EFLAGS: 00000206 ORIG_RAX:
> 00000000000000b0
>   [  371.788122] RAX: ffffffffffffffda RBX: 000055e5a261bf70 RCX:
> 00007f0496589ae7
>   [  371.799948] RDX: 0000000000000000 RSI: 0000000000000800 RDI:
> 000055e5a261bfd8
>   [  371.801336] RBP: 000055e5a261bf70 R08: 00007ffd14afe721 R09:
> 0000000000000000
>   [  371.802773] R10: 00007f04965f81e0 R11: 0000000000000206 R12:
> 000055e5a261bfd8
>   [  371.804182] R13: 000055e5a261c8e0 R14: 000055e5a261bc38 R15:
> 00007ffd14b00b98
>   [  371.805633] INFO: Object 0x0000000057a96e69 @offset=9000
>   [  371.806851] kmem_cache_destroy mlx5_fs_ftes: Slab cache still has
> objects
>   [  371.808330] CPU: 0 PID: 13112 Comm: modprobe Tainted:
> G    B             5.5.0-rc4-J8553-G8b261307a8b0 #1
>   [  371.810311] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>
>
>>   1 file changed, 39 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 9b32a9c..33d1ce5 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -1805,6 +1805,40 @@ static void *get_match_headers_value(u32
>> flags,
>>   			     outer_headers);
>>   }
>>   
>> +static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
>> +				   struct flow_cls_offload *f)
>> +{
>> +	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
>> +	struct netlink_ext_ack *extack = f->common.extack;
>> +	struct net_device *ingress_dev;
>> +	struct flow_match_meta match;
>> +
>> +	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META))
>> +		return 0;
>> +
>> +	flow_rule_match_meta(rule, &match);
>> +	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex
>> mask");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ingress_dev = __dev_get_by_index(dev_net(filter_dev),
>> +					 match.key->ingress_ifindex);
>> +	if (!ingress_dev) {
>> +		NL_SET_ERR_MSG_MOD(extack,
>> +				   "Can't find the ingress port to
>> match on");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (ingress_dev != filter_dev) {
>> +		NL_SET_ERR_MSG_MOD(extack,
>> +				   "Can't match on the ingress filter
>> port");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int __parse_cls_flower(struct mlx5e_priv *priv,
>>   			      struct mlx5_flow_spec *spec,
>>   			      struct flow_cls_offload *f,
>> @@ -1825,6 +1859,7 @@ static int __parse_cls_flower(struct mlx5e_priv
>> *priv,
>>   	u16 addr_type = 0;
>>   	u8 ip_proto = 0;
>>   	u8 *match_level;
>> +	int err;
>>   
>>   	match_level = outer_match_level;
>>   
>> @@ -1868,6 +1903,10 @@ static int __parse_cls_flower(struct
>> mlx5e_priv *priv,
>>   						    spec);
>>   	}
>>   
>> +	err = mlx5e_flower_parse_meta(filter_dev, f);
>> +	if (err)
>> +		return err;
>> +
>>   	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
>>   		struct flow_match_basic match;
>>   
