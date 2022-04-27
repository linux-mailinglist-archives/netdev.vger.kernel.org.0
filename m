Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B14511D55
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbiD0PiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239789AbiD0PiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:38:07 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C7A5622F
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:34:52 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BD0F5C0242;
        Wed, 27 Apr 2022 11:34:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 27 Apr 2022 11:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651073689; x=
        1651160089; bh=mMYKroTBUO9hSuVVMMeoL+cmh7lfGJ7m0ucGPP4QTYM=; b=p
        WOxuvHV8Woq0q4VP83eiRMOYWbGGaZGAV5RS5m+MqMrYHC1dntLFN4anQcXf2vKI
        t89DTmN1HZwVvCaDLIvOVMKNHFdebrICw5UIvlnnDcYLKL4L/1fI66uZjjSKNe1u
        4Y0D+pSLwULb3PJTbGDYQ//YSI+pfomgpW4/T5djZCIpZHcv7mY4x+NBZn4QY/LT
        0o/y//U7OgeOYSkQoicl5cHFWADaHTQxdmDXPDBN8aQ+x0xz5BquBqJ/Ds7fa49S
        3G3K2tsHKYwkqQV8z5m5poDzjmim0tXi3ot6ELqrywnRMOZ0Fif5YYk58m4ke9yP
        5V4dWUXzPZ6MDnRGgmr4w==
X-ME-Sender: <xms:mGJpYqA_RcGLnREAqLbs_M8VpRqJA_ldvWLmb9DJnIoZ7gznemNnOA>
    <xme:mGJpYkjzGzFdiEAf4fRI2EyjO7hDWUEzbyrYLkQUy_iWzUqtN4N8DIo1YrXdROlcR
    OcgEaw7gymB3fU>
X-ME-Received: <xmr:mGJpYtmdObNYIOJXmS3hKmNj_ZyeFxqt4f8hUkUMMO5yvPhAhW03hxg4-5BEAgixsTaJPLKZSoKLMNUH7fmOkzaNYyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:mGJpYoyXSAoUl0QAprJEh_oBQ8Y1jL5LVyR2uSDfVSEEjpFvqETDBw>
    <xmx:mGJpYvQSZPL-94QIam2ysErZTGclHlo7Dh7wgPflbsdwmrFtdRljtA>
    <xmx:mGJpYjbmea8Pt2NCtQR4iUXVMJsZ4MylFBh6V0T-ao3q_j8qqKFZdQ>
    <xmx:mWJpYpecKAqbTimsrUSm663yGDUS9nCGoOBKqrNxuYXwMrd0UmndRg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Apr 2022 11:34:48 -0400 (EDT)
Date:   Wed, 27 Apr 2022 18:34:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
Message-ID: <YmlilMi5MmApVqTX@shredder>
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422201237.416238-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 01:12:37PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Logic added in commit f35f821935d8 ("tcp: defer skb freeing after socket
> lock is released") helped bulk TCP flows to move the cost of skbs
> frees outside of critical section where socket lock was held.
> 
> But for RPC traffic, or hosts with RFS enabled, the solution is far from
> being ideal.
> 
> For RPC traffic, recvmsg() has to return to user space right after
> skb payload has been consumed, meaning that BH handler has no chance
> to pick the skb before recvmsg() thread. This issue is more visible
> with BIG TCP, as more RPC fit one skb.
> 
> For RFS, even if BH handler picks the skbs, they are still picked
> from the cpu on which user thread is running.
> 
> Ideally, it is better to free the skbs (and associated page frags)
> on the cpu that originally allocated them.
> 
> This patch removes the per socket anchor (sk->defer_list) and
> instead uses a per-cpu list, which will hold more skbs per round.
> 
> This new per-cpu list is drained at the end of net_action_rx(),
> after incoming packets have been processed, to lower latencies.
> 
> In normal conditions, skbs are added to the per-cpu list with
> no further action. In the (unlikely) cases where the cpu does not
> run net_action_rx() handler fast enough, we use an IPI to raise
> NET_RX_SOFTIRQ on the remote cpu.
> 
> Also, we do not bother draining the per-cpu list from dev_cpu_dead()
> This is because skbs in this list have no requirement on how fast
> they should be freed.
> 
> Note that we can add in the future a small per-cpu cache
> if we see any contention on sd->defer_lock.
> 
> Tested on a pair of hosts with 100Gbit NIC, RFS enabled,
> and /proc/sys/net/ipv4/tcp_rmem[2] tuned to 16MB to work around
> page recycling strategy used by NIC driver (its page pool capacity
> being too small compared to number of skbs/pages held in sockets
> receive queues)
> 
> Note that this tuning was only done to demonstrate worse
> conditions for skb freeing for this particular test.
> These conditions can happen in more general production workload.

[...]

> Signed-off-by: Eric Dumazet <edumazet@google.com>

Eric, with this patch I'm seeing memory leaks such as these [1][2] after
boot. The system is using the igb driver for its management interface
[3]. The leaks disappear after reverting the patch.

Any ideas?

Let me know if you need more info. I can easily test a patch.

Thanks

[1]
# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff888170143740 (size 216):
  comm "softirq", pid 0, jiffies 4294825261 (age 95.244s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 17 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff82571fc0>] napi_skb_cache_get+0xf0/0x180
    [<ffffffff8257206a>] __napi_build_skb+0x1a/0x60
    [<ffffffff8257b0f3>] napi_build_skb+0x23/0x350
    [<ffffffffa0469592>] igb_poll+0x2b72/0x5880 [igb]
    [<ffffffff825f9584>] __napi_poll.constprop.0+0xb4/0x480
    [<ffffffff825f9d5a>] net_rx_action+0x40a/0xc60
    [<ffffffff82e00295>] __do_softirq+0x295/0x9fe
    [<ffffffff81185bcc>] __irq_exit_rcu+0x11c/0x180
    [<ffffffff8118622a>] irq_exit_rcu+0xa/0x20
    [<ffffffff82bbed39>] common_interrupt+0xa9/0xc0
    [<ffffffff82c00b5e>] asm_common_interrupt+0x1e/0x40
    [<ffffffff824a186e>] cpuidle_enter_state+0x27e/0xcb0
    [<ffffffff824a236f>] cpuidle_enter+0x4f/0xa0
    [<ffffffff8126a290>] do_idle+0x3b0/0x4b0
    [<ffffffff8126a869>] cpu_startup_entry+0x19/0x20
    [<ffffffff810f4725>] start_secondary+0x265/0x340

[2]
# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff88810ce3aac0 (size 216):
  comm "softirq", pid 0, jiffies 4294861408 (age 64.607s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 c0 7b 07 81 88 ff ff 00 00 00 00 00 00 00 00  ..{.............
  backtrace:
    [<ffffffff82575539>] __alloc_skb+0x229/0x360
    [<ffffffff8290bd3c>] __tcp_send_ack.part.0+0x6c/0x760
    [<ffffffff8291a062>] tcp_send_ack+0x82/0xa0
    [<ffffffff828cb6db>] __tcp_ack_snd_check+0x15b/0xa00
    [<ffffffff828f17fe>] tcp_rcv_established+0x198e/0x2120
    [<ffffffff829363b5>] tcp_v4_do_rcv+0x665/0x9a0
    [<ffffffff8293d8ae>] tcp_v4_rcv+0x2c1e/0x32f0
    [<ffffffff828610b3>] ip_protocol_deliver_rcu+0x53/0x2c0
    [<ffffffff828616eb>] ip_local_deliver+0x3cb/0x620
    [<ffffffff8285e66f>] ip_sublist_rcv_finish+0x9f/0x2c0
    [<ffffffff82860895>] ip_list_rcv_finish.constprop.0+0x525/0x6f0
    [<ffffffff82861f88>] ip_list_rcv+0x318/0x460
    [<ffffffff825f5e61>] __netif_receive_skb_list_core+0x541/0x8f0
    [<ffffffff825f8043>] netif_receive_skb_list_internal+0x763/0xdc0
    [<ffffffff826c3025>] napi_gro_complete.constprop.0+0x5a5/0x700
    [<ffffffff826c44ed>] dev_gro_receive+0xf2d/0x23f0
unreferenced object 0xffff888175e1afc0 (size 216):
  comm "sshd", pid 1024, jiffies 4294861424 (age 64.591s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 c0 7b 07 81 88 ff ff 00 00 00 00 00 00 00 00  ..{.............
  backtrace:
    [<ffffffff82575539>] __alloc_skb+0x229/0x360
    [<ffffffff8258201c>] alloc_skb_with_frags+0x9c/0x720
    [<ffffffff8255f333>] sock_alloc_send_pskb+0x7b3/0x940
    [<ffffffff82876af4>] __ip_append_data+0x1874/0x36d0
    [<ffffffff8287f283>] ip_make_skb+0x263/0x2e0
    [<ffffffff82978afa>] udp_sendmsg+0x1c8a/0x29d0
    [<ffffffff829af94e>] inet_sendmsg+0x9e/0xe0
    [<ffffffff8255082d>] __sys_sendto+0x23d/0x360
    [<ffffffff82550a31>] __x64_sys_sendto+0xe1/0x1b0
    [<ffffffff82bbde05>] do_syscall_64+0x35/0x80
    [<ffffffff82c00068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

[3]
# ethtool -i enp8s0
driver: igb
version: 5.18.0-rc3-custom-91743-g481c1b
firmware-version: 3.25, 0x80000708, 1.1824.0
expansion-rom-version: 
bus-info: 0000:08:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
