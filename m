Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2535E9551
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiIYSJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiIYSI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:08:57 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A8F2F66D
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 11:08:50 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id y2so2955903qtv.5
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 11:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=FZeP2hBHQ+JoGT3e+26y2+gKX1v0IzLqvvHSZwLU46s=;
        b=ZOIIKkzMJClf8P3iPAGYtc6euj6w3CiXJO2gHszxckEIN2XtvvCMUkRxZnFaHjlBWK
         g8MGbHunzNW15qAAlb1z3AhubPouIpgSCG8ARkfAcq8mL5VfHkGgJqqXev0EdsCZS12R
         y7eh0b3UcvY4kFWOAVXNRks8TPd6a8CBrk9PEtep3glsksQB/7ISqpuovDvA2oxOp0Hl
         rom300hm9/RS3NwYddE/XhEMX+pPGXzXIz/gjN4jyAkdDZTsH9s9HsgF/o0e1Kgn6BUp
         YEbZd+96UfMd7ZRqy1zUxsUYqFI+gzEprkzo1w1IW0uDzA+Ya/jxuImGJ78HL1InoUwJ
         6gmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=FZeP2hBHQ+JoGT3e+26y2+gKX1v0IzLqvvHSZwLU46s=;
        b=N45NLJLbXrUMNzXnlAWtLlwYTo4767WmMVlmgll2CBabYPZ38Otvw6wG2aA7Tsic+/
         +Sx+FjF8ZmWlL1g6plCLzHd1EOWfhVO+i5ma6SxkdZoBhxlRbmIpx5UTM7z6Yv5zcB06
         Mofg8U/fuh1V3BMsx/X0h4bwNMa/9Db/F7BlNGa8U2+pFyj/epfU9UtxCQrgCbt6LefB
         /gfENeiLnBJg8Yt5dvENxTzdPYjAi6CdBXgzyA6q4cUEenL2Hool8cBdGD7EE+NqJ+Uk
         3hLS/5LC1Wyln6gAvYvp/gkYMkZLAkaaVGUHU/LQMCftFOui/34FKrIJRQWAZYTk9r2X
         b7oA==
X-Gm-Message-State: ACrzQf0JtfDP6FHR6fNWKTmi6nZJqZgsrH3IaXAOCpfehBNhAYU1/On1
        6eSRg1khflCyPA1tuucB48j4hBvzovg=
X-Google-Smtp-Source: AMsMyM5fQIaWP3HkrUL+hjvXlcUpCmrnE9UI5GBKICgl9htkZjXrgNuuHV3GFrNhA5w97oy3RGYybQ==
X-Received: by 2002:a05:622a:11c1:b0:35c:b761:55ed with SMTP id n1-20020a05622a11c100b0035cb76155edmr15118459qtk.324.1664129329765;
        Sun, 25 Sep 2022 11:08:49 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:9061:9095:558c:ce69])
        by smtp.gmail.com with ESMTPSA id t3-20020a37ea03000000b006ce5ba64e30sm9860312qkj.136.2022.09.25.11.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 11:08:49 -0700 (PDT)
Date:   Sun, 25 Sep 2022 11:08:48 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        wizhao@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: act_mirred: use the backlog for mirred
 ingress
Message-ID: <YzCZMHYmk53mQ+HK@pop-os.localdomain>
References: <33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 05:11:12PM +0200, Davide Caratti wrote:
> William reports kernel soft-lockups on some OVS topologies when TC mirred
> "egress-to-ingress" action is hit by local TCP traffic. Indeed, using the
> mirred action in egress-to-ingress can easily produce a dmesg splat like:
> 
>  ============================================
>  WARNING: possible recursive locking detected
>  6.0.0-rc4+ #511 Not tainted
>  --------------------------------------------
>  nc/1037 is trying to acquire lock:
>  ffff950687843cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160
> 
>  but task is already holding lock:
>  ffff950687846cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160
> 
>  other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(slock-AF_INET/1);
>    lock(slock-AF_INET/1);
> 
>   *** DEADLOCK ***
> 
>   May be due to missing lock nesting notation
> 
>  12 locks held by nc/1037:
>   #0: ffff950687843d40 (sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_sendmsg+0x19/0x40
>   #1: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: __ip_queue_xmit+0x5/0x610
>   #2: ffffffff9be072e0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0xaa/0xa10
>   #3: ffffffff9be072e0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x72/0x11b0
>   #4: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: netif_receive_skb+0x181/0x400
>   #5: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: ip_local_deliver_finish+0x54/0x160
>   #6: ffff950687846cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160
>   #7: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: __ip_queue_xmit+0x5/0x610
>   #8: ffffffff9be072e0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0xaa/0xa10
>   #9: ffffffff9be072e0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x72/0x11b0
>   #10: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: netif_receive_skb+0x181/0x400
>   #11: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: ip_local_deliver_finish+0x54/0x160
> 
>  stack backtrace:
>  CPU: 1 PID: 1037 Comm: nc Not tainted 6.0.0-rc4+ #511
>  Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7353+9de0a3cc 04/01/2014
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x44/0x5b
>   __lock_acquire.cold.76+0x121/0x2a7
>   lock_acquire+0xd5/0x310
>   _raw_spin_lock_nested+0x39/0x70
>   tcp_v4_rcv+0x1023/0x1160
>   ip_protocol_deliver_rcu+0x4d/0x280
>   ip_local_deliver_finish+0xac/0x160
>   ip_local_deliver+0x71/0x220
>   ip_rcv+0x5a/0x200
>   __netif_receive_skb_one_core+0x89/0xa0
>   netif_receive_skb+0x1c1/0x400
>   tcf_mirred_act+0x2a5/0x610 [act_mirred]
>   tcf_action_exec+0xb3/0x210
>   fl_classify+0x1f7/0x240 [cls_flower]
>   tcf_classify+0x7b/0x320
>   __dev_queue_xmit+0x3a4/0x11b0
>   ip_finish_output2+0x3b8/0xa10
>   ip_output+0x7f/0x260
>   __ip_queue_xmit+0x1ce/0x610
>   __tcp_transmit_skb+0xabc/0xc80
>   tcp_rcv_state_process+0x669/0x1290
>   tcp_v4_do_rcv+0xd7/0x370
>   tcp_v4_rcv+0x10bc/0x1160
>   ip_protocol_deliver_rcu+0x4d/0x280
>   ip_local_deliver_finish+0xac/0x160
>   ip_local_deliver+0x71/0x220
>   ip_rcv+0x5a/0x200
>   __netif_receive_skb_one_core+0x89/0xa0
>   netif_receive_skb+0x1c1/0x400
>   tcf_mirred_act+0x2a5/0x610 [act_mirred]
>   tcf_action_exec+0xb3/0x210
>   fl_classify+0x1f7/0x240 [cls_flower]
>   tcf_classify+0x7b/0x320
>   __dev_queue_xmit+0x3a4/0x11b0
>   ip_finish_output2+0x3b8/0xa10
>   ip_output+0x7f/0x260
>   __ip_queue_xmit+0x1ce/0x610
>   __tcp_transmit_skb+0xabc/0xc80
>   tcp_write_xmit+0x229/0x12c0
>   __tcp_push_pending_frames+0x32/0xf0
>   tcp_sendmsg_locked+0x297/0xe10
>   tcp_sendmsg+0x27/0x40
>   sock_sendmsg+0x58/0x70
>   __sys_sendto+0xfd/0x170
>   __x64_sys_sendto+0x24/0x30
>   do_syscall_64+0x3a/0x90
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  RIP: 0033:0x7f11a06fd281
>  Code: 00 00 00 00 0f 1f 44 00 00 f3 0f 1e fa 48 8d 05 e5 43 2c 00 41 89 ca 8b 00 85 c0 75 1c 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 67 c3 66 0f 1f 44 00 00 41 56 41 89 ce 41 55
>  RSP: 002b:00007ffd17958358 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
>  RAX: ffffffffffffffda RBX: 0000555c6e671610 RCX: 00007f11a06fd281
>  RDX: 0000000000002000 RSI: 0000555c6e73a9f0 RDI: 0000000000000003
>  RBP: 0000555c6e6433b0 R08: 0000000000000000 R09: 0000000000000000
>  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000002000
>  R13: 0000555c6e671410 R14: 0000555c6e671410 R15: 0000555c6e6433f8
>   </TASK>
> 
> that is very similar to those observed by William in his setup.
> By using netif_rx() for mirred ingress packets, packets are queued in the
> backlog, like it's done in the receive path of "loopback" and "veth", and
> the deadlock is not visible anymore. Also add a selftest that can be used
> to reproduce the problem / verify the fix.

Which also means we can no longer know the RX path status any more,
right? I mean if we have filters on ingress, we can't know whether they
drop this packet or not, after this patch? To me, this at least breaks
users' expectation.

BTW, have you thought about solving the above lockdep warning in TCP
layer?

Thanks.
