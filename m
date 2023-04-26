Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976AE6EF070
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbjDZIs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjDZIs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:48:57 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BA92D74
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 01:48:55 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 858F65C0159;
        Wed, 26 Apr 2023 04:48:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 26 Apr 2023 04:48:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682498933; x=1682585333; bh=gwjktluHZ/jR1
        uCIP5SMwoOmTsqnk8uXOp1NhFmCIVg=; b=D377+L8miO6RFObZszaB4nFOOdkyq
        A32vCvbc6kzUPB6oyQCqaHWT5gQtqethQRkIjACjKsdTuDZUOhU+qMNHWXj38jxi
        vEB/QUaLfp/QRtbJxCq0EjCpyDSjJ2uYUO4halJGB4vVrndgNyTQ1ezaDzJ6zGZn
        tDqrH22/SCcOjl7jnWmwur4Jl+f5lqfqAhBUdtLbgAxvvSjCZvftOx0KAaI7NJkI
        wtcJ5OTsydTw9N9Z34KjHVOJqM7R9QhQjyCiog1ZfUn7P9X9kXZud7mATNRi26VI
        Vz2ZkdaGE/josBL1AWDYEXbpFQ316gKZYNsYDK5Ee4tKISzwENDBUI03w==
X-ME-Sender: <xms:deVIZBFU-dEcHDDBQf4Lu0WgU-u8qFMiNKwpbKW6E2Vt6cE4mVWFMQ>
    <xme:deVIZGUtUu5QVap_vKlIY5gztZjctyqkaitvmqnt6q3roI8NF_CgCMmin8yg6yOe1
    Bk1LZdje8L_ALI>
X-ME-Received: <xmr:deVIZDJqQrSXY0FWc7zLfqF2_9hnGQV5Vta3Phxrfu2n3Lwe1Md7KNe77cSdN77nL-IRk2EKeG3Q_xofKu9qGMfWEMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedugedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:deVIZHGPq_IoWLyCsGw8MimDSvS8SUHqkN7To16e9_2JvyqfOoJ9Gg>
    <xmx:deVIZHVdW-xrnS6YzZkWsbB6R_Uh6wWZptWpNm0kR5nmNIMjfGhBxA>
    <xmx:deVIZCOFoNdqlMIADxqbX-a0JecAGNWsPkJnNPd0ydOL-si4OYX4pQ>
    <xmx:deVIZJLfF2agJ9ushdFuKS5e2GRK3rbouPq2epmIUmbMsF5qp2Cpaw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Apr 2023 04:48:52 -0400 (EDT)
Date:   Wed, 26 Apr 2023 11:48:49 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net/sched: act_pedit: free pedit keys on bail
 from offset check
Message-ID: <ZEjlcUF/XhVFpkGb@shredder>
References: <20230425144725.669262-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425144725.669262-1-pctammela@mojatatu.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:47:25AM -0300, Pedro Tammela wrote:
> Ido Schimmel reports a memleak on a syzkaller instance:
>    BUG: memory leak
>    unreferenced object 0xffff88803d45e400 (size 1024):
>      comm "syz-executor292", pid 563, jiffies 4295025223 (age 51.781s)
>      hex dump (first 32 bytes):
>        28 bd 70 00 fb db df 25 02 00 14 1f ff 02 00 02  (.p....%........
>        00 32 00 00 1f 00 00 00 ac 14 14 3e 08 00 07 00  .2.........>....
>      backtrace:
>        [<ffffffff81bd0f2c>] kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
>        [<ffffffff81bd0f2c>] slab_post_alloc_hook mm/slab.h:772 [inline]
>        [<ffffffff81bd0f2c>] slab_alloc_node mm/slub.c:3452 [inline]
>        [<ffffffff81bd0f2c>] __kmem_cache_alloc_node+0x25c/0x320 mm/slub.c:3491
>        [<ffffffff81a865d9>] __do_kmalloc_node mm/slab_common.c:966 [inline]
>        [<ffffffff81a865d9>] __kmalloc+0x59/0x1a0 mm/slab_common.c:980
>        [<ffffffff83aa85c3>] kmalloc include/linux/slab.h:584 [inline]
>        [<ffffffff83aa85c3>] tcf_pedit_init+0x793/0x1ae0 net/sched/act_pedit.c:245
>        [<ffffffff83a90623>] tcf_action_init_1+0x453/0x6e0 net/sched/act_api.c:1394
>        [<ffffffff83a90e58>] tcf_action_init+0x5a8/0x950 net/sched/act_api.c:1459
>        [<ffffffff83a96258>] tcf_action_add+0x118/0x4e0 net/sched/act_api.c:1985
>        [<ffffffff83a96997>] tc_ctl_action+0x377/0x490 net/sched/act_api.c:2044
>        [<ffffffff83920a8d>] rtnetlink_rcv_msg+0x46d/0xd70 net/core/rtnetlink.c:6395
>        [<ffffffff83b24305>] netlink_rcv_skb+0x185/0x490 net/netlink/af_netlink.c:2575
>        [<ffffffff83901806>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6413
>        [<ffffffff83b21cae>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>        [<ffffffff83b21cae>] netlink_unicast+0x5be/0x8a0 net/netlink/af_netlink.c:1365
>        [<ffffffff83b2293f>] netlink_sendmsg+0x9af/0xed0 net/netlink/af_netlink.c:1942
>        [<ffffffff8380c39f>] sock_sendmsg_nosec net/socket.c:724 [inline]
>        [<ffffffff8380c39f>] sock_sendmsg net/socket.c:747 [inline]
>        [<ffffffff8380c39f>] ____sys_sendmsg+0x3ef/0xaa0 net/socket.c:2503
>        [<ffffffff838156d2>] ___sys_sendmsg+0x122/0x1c0 net/socket.c:2557
>        [<ffffffff8381594f>] __sys_sendmsg+0x11f/0x200 net/socket.c:2586
>        [<ffffffff83815ab0>] __do_sys_sendmsg net/socket.c:2595 [inline]
>        [<ffffffff83815ab0>] __se_sys_sendmsg net/socket.c:2593 [inline]
>        [<ffffffff83815ab0>] __x64_sys_sendmsg+0x80/0xc0 net/socket.c:2593
> 
> The recently added static offset check missed a free to the key buffer when
> bailing out on error.
> 
> Fixes: e1201bc781c2 ("net/sched: act_pedit: check static offsets a priori")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
