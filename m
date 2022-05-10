Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3477D52135A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbiEJLR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 07:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240782AbiEJLRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 07:17:50 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A31D2A9764;
        Tue, 10 May 2022 04:13:53 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 696B95C01AC;
        Tue, 10 May 2022 07:13:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 10 May 2022 07:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652181232; x=1652267632; bh=v1AUMe2H5y
        jb10graXLGgnMmPSWt+Y9DqKU1OZcVoY8=; b=JCeLgAZQEVcWBB3Idj6rtS+tMy
        4KylvmewMli1Gq8aEubGF6JDHKdRSp1hAAqm2eAuephyXWhgJjEM+kXMQfWMM6IC
        u0PzPUWcWycwNT0ZkD49jmC7NE7P47IXl7XOSp3tP8wGpL4Wzn+4grj+Jh+npC5B
        gvuRldGztu8PFmQx4cpeVOexxrJm0yS9W0+GAr9ZxWNCTAqTC4ahjYik4066N1b3
        ko7KzIQvANT9MIbnmKmrsYGzrIoRVY/3gWrCE6pmvr3+KbHKCwLabwdTBQC0D/w2
        xT7VFbhTerd60gHe2+a5XqqWQZ1bQgWFsgZGG9B3Em8ohH3QFM8KFOSh2VVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652181232; x=
        1652267632; bh=v1AUMe2H5yjb10graXLGgnMmPSWt+Y9DqKU1OZcVoY8=; b=m
        NFYCg54VxqHfFgGwaSjaiIWIoBiWr9Li0nLsvqsmlgMjggyhf96qGlwvg8hXrZ/U
        lrn558kWikFNPb6kiOsSXECZF3wy5gYRdbdYo0tmfmFV3cL32lijrDl1mYSyeJSf
        3zELh058YbtSNDeE8/pHeW9sBGqzfS+dJFlqkv+rBod4BAFcpeeaCQ2zbGHqVzd9
        uCMqrodEJ6qfAmD6Z10FaAekSlnXTpJrUJXVv8QeqDiARauC5wwJt3Rua7Db3GD2
        IU+zhm/vRQtoJdmtFSoKP8+8RRjVm2nMJxgKJDb+5fLI1VUgchNDbg0QY1rcOZkQ
        s2YqtO29xyhl10GP/8kiQ==
X-ME-Sender: <xms:70h6YjysmPSRJiol8OsLgz7aceTPbNw63XptrSBmx_RWfzpGTGkusA>
    <xme:70h6YrRZBWdaPu_xNiLJni0d4nys8YIZ0LXM9Di86vHOWs8uM5l_MpiNyZEfv8Jkv
    MvMb8jJSw32ag>
X-ME-Received: <xmr:70h6YtVBL235KMe-1KaIFEboWy4CQ-9F-3bAIwQGANvRfDZLb2Ztll47bgxDzqB3pICODqPNYsj7Kwo3htGWskKVi8kZItpG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedugdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:70h6YtjRg51TipwwUT3JlUX54eqZkK-IY_KU1MBueTNRLXMIR3MjMw>
    <xmx:70h6YlAtDH_TPhGxRSMWNayMspNcgZwwBLc8vubfR4rq6Ic4EoCVJg>
    <xmx:70h6YmLHi68m-NffJ8oxTNcxpV4vdLQ2FXSo0GastGDGJ7Q1LOru1g>
    <xmx:8Eh6YnxqjzpOhifxrhkk1nlNHGJdetm4BU10MLGXlfIMqMu07EvTBQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 May 2022 07:13:51 -0400 (EDT)
Date:   Tue, 10 May 2022 13:13:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, vladbu@mellanox.com
Subject: Re: [PATCH 4.9.y] net: sched: prevent UAF on tc_ctl_tfilter when
 temporarily dropping rtnl_lock
Message-ID: <YnpI7Pqp/PmgD8WW@kroah.com>
References: <20220502204924.3456590-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502204924.3456590-1-cascardo@canonical.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 05:49:24PM -0300, Thadeu Lima de Souza Cascardo wrote:
> When dropping the rtnl_lock for looking up for a module, the device may be
> removed, releasing the qdisc and class memory. Right after trying to load
> the module, cl_ops->put is called, leading to a potential use-after-free.
> 
> Though commit e368fdb61d8e ("net: sched: use Qdisc rcu API instead of
> relying on rtnl lock") fixes this, it involves a lot of refactoring of the
> net/sched/ code, complicating its backport.
> 
> This fix calls cl_ops->put before dropping rtnl_lock as it will be called
> either way, and zeroes it out so it won't be called again on the exit path.
> 
> This has been shown to stop the following KASAN report with the reproducer:
> 
> [  256.609111] ==================================================================
> [  256.609585] BUG: KASAN: use-after-free in cbq_put+0x20/0xd0 at addr ffff880021daaba0
> [  256.610078] Read of size 4 by task total_cbq/11184
> [  256.610380] CPU: 0 PID: 11184 Comm: total_cbq Not tainted 4.9.311 #78
> [  256.610778]  ffff8800215875a8 ffffffff96e18735 ffff880024803080 ffff880021daaa80
> [  256.611274]  ffff8800215875d0 ffffffff96334841 ffffed00043b5574 ffffed00043b5574
> [  256.611768]  ffff880024803080 ffff880021587658 ffffffff96334af8 0000000000000000
> [  256.612186] Call Trace:
> [  256.612344]  [<ffffffff96e18735>] dump_stack+0x6d/0x8b
> [  256.612632]  [<ffffffff96334841>] kasan_object_err+0x21/0x70
> [  256.612973]  [<ffffffff96334af8>] kasan_report.part.1+0x218/0x4f0
> [  256.613349]  [<ffffffff96c5a2e0>] ? cbq_put+0x20/0xd0
> [  256.613634]  [<ffffffff96333cd6>] ? kasan_unpoison_shadow+0x36/0x50
> [  256.613993]  [<ffffffff96335105>] kasan_report+0x25/0x30
> [  256.614288]  [<ffffffff96333701>] __asan_load4+0x61/0x80
> [  256.614580]  [<ffffffff96c5a2e0>] cbq_put+0x20/0xd0
> [  256.614862]  [<ffffffff96c53184>] tc_ctl_tfilter+0x4f4/0xb80
> [  256.615151]  [<ffffffff96c52c90>] ? tfilter_notify+0x140/0x140
> [  256.615478]  [<ffffffff960056ef>] ? do_syscall_64+0xef/0x190
> [  256.615799]  [<ffffffff96e28a8e>] ? entry_SYSCALL_64_after_swapgs+0x58/0xc6
> [  256.616190]  [<ffffffff96bce3f6>] ? sock_sendmsg+0x76/0x80
> [  256.616484]  [<ffffffff96bce53f>] ? sock_write_iter+0x13f/0x1f0
> [  256.616833]  [<ffffffff96367b02>] ? __vfs_write+0x262/0x3c0
> [  256.617152]  [<ffffffff96369dc9>] ? vfs_write+0xf9/0x260
> [  256.617451]  [<ffffffff9636c009>] ? SyS_write+0xc9/0x1b0
> [  256.617754]  [<ffffffff960decda>] ? ns_capable_common+0x5a/0xa0
> [  256.618067]  [<ffffffff960ded33>] ? ns_capable+0x13/0x20
> [  256.618334]  [<ffffffff96c9125d>] ? __netlink_ns_capable+0x6d/0x80
> [  256.618666]  [<ffffffff96c2750f>] rtnetlink_rcv_msg+0x1af/0x410
> [  256.618969]  [<ffffffff96c90d6b>] ? netlink_compare+0x5b/0x70
> [  256.619295]  [<ffffffff96c27360>] ? rtnl_newlink+0xc60/0xc60
> [  256.619587]  [<ffffffff96c94214>] ? __netlink_lookup+0x1a4/0x240
> [  256.619885]  [<ffffffff96c94070>] ? netlink_broadcast+0x20/0x20
> [  256.620179]  [<ffffffff96c97815>] netlink_rcv_skb+0x155/0x190
> [  256.620463]  [<ffffffff96c27360>] ? rtnl_newlink+0xc60/0xc60
> [  256.620748]  [<ffffffff96c1e758>] rtnetlink_rcv+0x28/0x30
> [  256.621015]  [<ffffffff96c96d11>] netlink_unicast+0x2f1/0x3b0
> [  256.621354]  [<ffffffff96c96a20>] ? netlink_attachskb+0x340/0x340
> [  256.621765]  [<ffffffff96c9733e>] netlink_sendmsg+0x56e/0x6f0
> [  256.622181]  [<ffffffff96c96dd0>] ? netlink_unicast+0x3b0/0x3b0
> [  256.622578]  [<ffffffff96c96dd0>] ? netlink_unicast+0x3b0/0x3b0
> [  256.622893]  [<ffffffff96bce3f6>] sock_sendmsg+0x76/0x80
> [  256.623157]  [<ffffffff96bce53f>] sock_write_iter+0x13f/0x1f0
> [  256.623440]  [<ffffffff96bce400>] ? sock_sendmsg+0x80/0x80
> [  256.623729]  [<ffffffff966a8032>] ? iov_iter_init+0x82/0xc0
> [  256.624006]  [<ffffffff96367b02>] __vfs_write+0x262/0x3c0
> [  256.624274]  [<ffffffff963678a0>] ? default_llseek+0x120/0x120
> [  256.624566]  [<ffffffff965e8c02>] ? common_file_perm+0x92/0x170
> [  256.624925]  [<ffffffff96369a58>] ? rw_verify_area+0x78/0x140
> [  256.625277]  [<ffffffff96369dc9>] vfs_write+0xf9/0x260
> [  256.625593]  [<ffffffff9636c009>] SyS_write+0xc9/0x1b0
> [  256.625891]  [<ffffffff9636bf40>] ? SyS_read+0x1b0/0x1b0
> [  256.626154]  [<ffffffff9636bf40>] ? SyS_read+0x1b0/0x1b0
> [  256.626422]  [<ffffffff960056ef>] do_syscall_64+0xef/0x190
> [  256.626697]  [<ffffffff96e28a8e>] entry_SYSCALL_64_after_swapgs+0x58/0xc6
> [  256.627033] Object at ffff880021daaa80, in cache kmalloc-512 size: 512
> [  256.627415] Allocated:
> [  256.627563] PID = 164
> [  256.627711]  save_stack_trace+0x1b/0x20
> [  256.627947]  save_stack+0x46/0xd0
> [  256.628151]  kasan_kmalloc+0xad/0xe0
> [  256.628362]  kmem_cache_alloc_trace+0xe8/0x1e0
> [  256.628637]  cbq_change_class+0x8b6/0xde0
> [  256.628896]  tc_ctl_tclass+0x56a/0x5b0
> [  256.629129]  rtnetlink_rcv_msg+0x1af/0x410
> [  256.629380]  netlink_rcv_skb+0x155/0x190
> [  256.629621]  rtnetlink_rcv+0x28/0x30
> [  256.629840]  netlink_unicast+0x2f1/0x3b0
> [  256.630066]  netlink_sendmsg+0x56e/0x6f0
> [  256.630263]  sock_sendmsg+0x76/0x80
> [  256.630456]  sock_write_iter+0x13f/0x1f0
> [  256.630698]  __vfs_write+0x262/0x3c0
> [  256.630918]  vfs_write+0xf9/0x260
> [  256.631123]  SyS_write+0xc9/0x1b0
> [  256.631327]  do_syscall_64+0xef/0x190
> [  256.631553]  entry_SYSCALL_64_after_swapgs+0x58/0xc6
> [  256.631827] Freed:
> [  256.631931] PID = 164
> [  256.632048]  save_stack_trace+0x1b/0x20
> [  256.632241]  save_stack+0x46/0xd0
> [  256.632408]  kasan_slab_free+0x71/0xb0
> [  256.632597]  kfree+0x8c/0x1a0
> [  256.632751]  cbq_destroy_class+0x85/0xa0
> [  256.632948]  cbq_destroy+0xfa/0x120
> [  256.633125]  qdisc_destroy+0xa1/0x140
> [  256.633309]  dev_shutdown+0x12d/0x190
> [  256.633497]  rollback_registered_many+0x43c/0x5b0
> [  256.633753]  unregister_netdevice_many+0x2c/0x130
> [  256.634041]  rtnl_delete_link+0xb3/0x100
> [  256.634283]  rtnl_dellink+0x19c/0x360
> [  256.634509]  rtnetlink_rcv_msg+0x1af/0x410
> [  256.634760]  netlink_rcv_skb+0x155/0x190
> [  256.635001]  rtnetlink_rcv+0x28/0x30
> [  256.635221]  netlink_unicast+0x2f1/0x3b0
> [  256.635463]  netlink_sendmsg+0x56e/0x6f0
> [  256.635700]  sock_sendmsg+0x76/0x80
> [  256.635915]  sock_write_iter+0x13f/0x1f0
> [  256.636156]  __vfs_write+0x262/0x3c0
> [  256.636376]  vfs_write+0xf9/0x260
> [  256.636580]  SyS_write+0xc9/0x1b0
> [  256.636787]  do_syscall_64+0xef/0x190
> [  256.637013]  entry_SYSCALL_64_after_swapgs+0x58/0xc6
> [  256.637316] Memory state around the buggy address:
> [  256.637610]  ffff880021daaa80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  256.638047]  ffff880021daab00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  256.638487] >ffff880021daab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  256.638924]                                ^
> [  256.639186]  ffff880021daac00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  256.639624]  ffff880021daac80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  net/sched/cls_api.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index c1a4b5d30814..330a2c9d1907 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -268,10 +268,13 @@ static int tc_ctl_tfilter(struct sk_buff *skb, struct nlmsghdr *n)
>  		err = -ENOENT;
>  		tp_ops = tcf_proto_lookup_ops(tca[TCA_KIND]);
>  		if (tp_ops == NULL) {
> -#ifdef CONFIG_MODULES
>  			struct nlattr *kind = tca[TCA_KIND];
>  			char name[IFNAMSIZ];
>  
> +			if (cl)
> +				cops->put(q, cl);
> +			cl = 0;
> +#ifdef CONFIG_MODULES
>  			if (kind != NULL &&
>  			    nla_strlcpy(name, kind, IFNAMSIZ) < IFNAMSIZ) {
>  				rtnl_unlock();
> -- 
> 2.32.0
> 

Now queued up, thanks.

greg k-h
