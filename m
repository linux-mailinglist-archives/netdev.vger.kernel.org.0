Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2065A445E
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiH2H67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiH2H66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:58:58 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AC04F652
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:58:55 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w19so14056496ejc.7
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=VDW53dUTabO6yQ6wAXd+7jBDhWYB2/UyA39woChSuWc=;
        b=Zbd/NOUvFBtQ+yHltr+mx+DxXi4bAAxqU6lAJR6d3VoiUVhHiiw48a5r/exl3jskzW
         k6dOjrVEDB+YvFLDttalfYvF3Hiq5uM/k08IZnvuMkhfzfkrHXjZtnqlVtIrilJqrPaT
         WyG2dR5XLw00PfsUupqr/MaAbVe6sYu6oVWKAqlL8l9i4P7C9DpCykVuNalxGSVKtbF3
         0VzH9iNi2+54SdqLPIsXs0QxLLoOa/l2lY3bSyyH2HbjLWiNT8lb9no3Mh4ubuzBMdBp
         BeWbXuC77U5BnSh/aHKVyGYNAcmYs5vlgDGdsl3NOfB0F4KoeYTrVIa3sLLfvql6JWMG
         VFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=VDW53dUTabO6yQ6wAXd+7jBDhWYB2/UyA39woChSuWc=;
        b=jjpzTN62/2ZqRSFUdbhIJ6pj6e5Uwtj0WzrV0wCmDvDF7poHyzNhALp99SSi5q/dfe
         LOufvCK68DkP+q/97t3oPAksnEzT2LqPzfVsbxHdH8UbAdK03IsizV4EHDtLm5TD6txR
         kkGreGCzFzYptTpveCbjJXSAuUVZHGeLjpk1G9Pua5RYdTmC+ee4POFY2PQawF34uG8x
         EcATUUt7Hqb3C/QixVViptO1cuFAzRS4GH6+mNFv22H8fxNXmMFyiBi/JztVwXKfhy4M
         eGpErHkHYN4yRxnyX320qDcFIkgH+QPzCN5R+M9rcw99Xx0a9f9btlgVVPGQI95i6LVV
         y5gQ==
X-Gm-Message-State: ACgBeo3oMif6V+8tgNh8n09X+7pAbyI11SQMD1+ABSZPmWFD71rHZ0iU
        erIs8IsYneuzHiz/Dj3cpC//YQ==
X-Google-Smtp-Source: AA6agR4zMqBl612ELqFbNPPvTmCgJU5b2wiJWGSxzF+PhUUWmX9CSfBFWg/iJtQf1rB435HVPFAHyg==
X-Received: by 2002:a17:907:2cd4:b0:73c:9fa8:3ddc with SMTP id hg20-20020a1709072cd400b0073c9fa83ddcmr4042891ejc.40.1661759933462;
        Mon, 29 Aug 2022 00:58:53 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bc17-20020a056402205100b00445e1489313sm5286285edb.94.2022.08.29.00.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 00:58:52 -0700 (PDT)
Date:   Mon, 29 Aug 2022 09:58:51 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <galpress@amazon.com>,
        Roi Dayan <roid@nvidia.com>, maord@nvidia.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: Re: [patch net-next] net: devlink: add RNLT lock assertion to
 devlink_compat_switch_id_get()
Message-ID: <Ywxxu1CXJVXDNxuh@nanopsycho>
References: <20220825112923.1359194-1-jiri@resnulli.us>
 <YwseIKn+mhGcnDZa@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwseIKn+mhGcnDZa@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Aug 28, 2022 at 09:49:52AM CEST, leon@kernel.org wrote:
>On Thu, Aug 25, 2022 at 01:29:23PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Similar to devlink_compat_phys_port_name_get(), make sure that
>> devlink_compat_switch_id_get() is called with RTNL lock held. Comment
>> already says so, so put this in code as well.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  net/core/devlink.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 6854f574e3ae..3b4dc64eaaae 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -12339,6 +12339,8 @@ int devlink_compat_switch_id_get(struct net_device *dev,
>>  	 * devlink_port instance cannot disappear in the middle. No need to take
>>  	 * any devlink lock as only permanent values are accessed.
>>  	 */
>> +	ASSERT_RTNL();
>> +
>
>This generates a lot of warnings in mlx5.

Fine. So it already caught a bug :)

>
> [  680.548565] ------------[ cut here ]------------
> [  680.549293] RTNL: assertion failed at net/core/devlink.c (12508)
> [  680.550254] WARNING: CPU: 9 PID: 11000 at net/core/devlink.c:12508 devlink_compat_switch_id_get+0xb6/0xc0
> [  680.552017] Modules linked in: act_csum act_pedit act_tunnel_key geneve act_skbedit act_vlan act_mirred nfnetlink_cttimeout act_gact cls_flower sch_ingress openvswitch nsh mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter overlay ib_umad ib_ipoib rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_uverbs ib_core fuse [last unloaded: mlx5_core]
> [  680.558720] CPU: 9 PID: 11000 Comm: handler5 Tainted: G        W          6.0.0-rc2_net_next_07d3d25 #1
> [  680.560408] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> [  680.562152] RIP: 0010:devlink_compat_switch_id_get+0xb6/0xc0
> [  680.562689] Code: 87 e6 36 37 00 41 83 e4 01 75 81 ba dc 30 00 00 48 c7 c6 c0 6b 61 82 48 c7 c7 58 d1 59 82 c6 05 e1 a4 11 01 01 e8 74 60 2d 00 <0f> 0b e9 5b ff ff ff cc cc cc 0f 1f 44 00 00 85 f6 41 55 41 54 55
> [  680.564302] RSP: 0018:ffff8881339134b8 EFLAGS: 00010286
> [  680.564798] RAX: 0000000000000000 RBX: ffff888133913536 RCX: ffff88852ccab808
> [  680.565435] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff88852ccab800
> [  680.566083] RBP: ffff888167ad8000 R08: ffffffff83c23a60 R09: 0000000000000001
> [  680.566722] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> [  680.567362] R13: 0000000000000001 R14: ffff888128b00000 R15: 0000000000000000
> [  680.568030] FS:  00007f2423dfe700(0000) GS:ffff88852cc80000(0000) knlGS:0000000000000000
> [  680.568788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  680.569326] CR2: 00000000004e1448 CR3: 0000000127b4a006 CR4: 0000000000370ea0
> [  680.569970] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  680.570607] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  680.571249] Call Trace:
> [  680.571546]  <TASK>
> [  680.571814]  dev_get_port_parent_id+0x99/0x160
> [  680.572300]  netdev_port_same_parent_id+0x7e/0xe0
> [  680.572770]  tc_act_can_offload_mirred+0x138/0x210 [mlx5_core]
> [  680.573461]  parse_tc_actions+0x159/0x5b0 [mlx5_core]
> [  680.574021]  __mlx5e_add_fdb_flow+0x29b/0x4c0 [mlx5_core]
> [  680.574588]  mlx5e_configure_flower+0x913/0x18c0 [mlx5_core]
> [  680.575175]  ? lock_acquire+0xce/0x2d0
> [  680.575569]  ? tc_setup_cb_add+0x5b/0x200
> [  680.576030]  tc_setup_cb_add+0xd7/0x200
> [  680.576615]  fl_hw_replace_filter+0x14c/0x1f0 [cls_flower]
> [  680.577266]  fl_change+0xbbe/0x1730 [cls_flower]
> [  680.577748]  tc_new_tfilter+0x3e9/0xd60
> [  680.578167]  ? tc_del_tfilter+0x810/0x810
> [  680.578576]  rtnetlink_rcv_msg+0x40e/0x5a0
> [  680.578995]  ? netlink_deliver_tap+0x7a/0x4b0
> [  680.579438]  ? if_nlmsg_stats_size+0x2b0/0x2b0
> [  680.579917]  netlink_rcv_skb+0x4e/0xf0
> [  680.580317]  netlink_unicast+0x190/0x250
> [  680.580732]  netlink_sendmsg+0x243/0x4b0
> [  680.581141]  sock_sendmsg+0x33/0x40
> [  680.581513]  ____sys_sendmsg+0x1d1/0x1f0
> [  680.581926]  ___sys_sendmsg+0x72/0xb0
> [  680.582319]  ? lock_acquire+0xce/0x2d0
> [  680.582708]  ? find_held_lock+0x2b/0x80
> [  680.583103]  ? __fget_files+0xb9/0x190
> [  680.583501]  ? __fget_files+0xd3/0x190
> [  680.583930]  __sys_sendmsg+0x51/0x90
> [  680.584315]  do_syscall_64+0x3d/0x90
> [  680.584699]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  680.585188] RIP: 0033:0x7f2429aa877d
> [  680.585581] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 ba ee ff ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 ee ee ff ff 48
> [  680.587164] RSP: 002b:00007f2423db15a0 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> [  680.587909] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f2429aa877d
> [  680.588550] RDX: 0000000000000000 RSI: 00007f2423db1640 RDI: 0000000000000036
> [  680.589189] RBP: 00007f2423db2368 R08: 0000000000000000 R09: 00007f2414000080
> [  680.589842] R10: 00007f2423db24b0 R11: 0000000000000293 R12: 00007f23f0001550
> [  680.590508] R13: 0000000000000000 R14: 00007f23f0001550 R15: 00007f2423db1640
> [  680.591183]  </TASK>
> [  680.591471] irq event stamp: 1589
> [  680.591844] hardirqs last  enabled at (1599): [<ffffffff811e0ee7>] __up_console_sem+0x67/0x70
> [  680.592702] hardirqs last disabled at (1612): [<ffffffff811e0ecc>] __up_console_sem+0x4c/0x70
> [  680.593498] softirqs last  enabled at (736): [<ffffffff81175f40>] __irq_exit_rcu+0x90/0xc0
> [  680.594277] softirqs last disabled at (703): [<ffffffff81175f40>] __irq_exit_rcu+0x90/0xc0
> [  680.595048] ---[ end trace 0000000000000000 ]---
>
>
>>  	devlink_port = netdev_to_devlink_port(dev);
>>  	if (!devlink_port || !devlink_port->switch_port)
>>  		return -EOPNOTSUPP;
>> -- 
>> 2.37.1
>> 
