Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF35F48BB
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 19:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJDRlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 13:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiJDRkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 13:40:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD9631FF
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 10:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664905231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ULxQFbuCAwyt4xCTVls3KLkLPtU4PF2MV4GysgDgtvE=;
        b=ValyZAHpzx6ZSl3gswTIMG3dIKpi31zUBJGj0WT7kg4m3RuCTI7bjw5tHUNti2rkssNd0K
        rEPeMKYiMU43MuJDGmvwB4EMgNS9iHip3zsh7enWn7CjAtsesSYxu4EtCfJJrS7QvoPNDe
        psYEGQCGZne9A77VNkzyFY3p6bjLfyY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-253-gSPtupapMoGVaQS0UW6L-Q-1; Tue, 04 Oct 2022 13:40:30 -0400
X-MC-Unique: gSPtupapMoGVaQS0UW6L-Q-1
Received: by mail-ej1-f71.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso5279964ejb.14
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 10:40:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ULxQFbuCAwyt4xCTVls3KLkLPtU4PF2MV4GysgDgtvE=;
        b=kf3A9RxWDM4eT5MTO4zgugWHF2BNB66JUTCW1iZn0y2tsOodjKl3RUsPPh1rf0ykae
         B+wzSGoGeyAnRppT8WIl1X7VlSbss8As7RBkCDyKLCpv8nf3eKqrMfiBGwRJ03GrzsZb
         Z6S02Yqbv4PKFCQqxsgdYACbguy2XyQVGrJsHpppYZvluUVXhGISNzz21xBZeOhfc/cZ
         Oo6cCtvXpB8Fcugj6AITNve7n6Kd4H4jin69pkeSBwJVYcmfe7j3BHnrM0tKqoZyeCGt
         2Vgc0ejgT0xDj8JB9ESk09vr2sdsPu7NSASa6z/e9DcmEN13crEtl4/BANymFC7OjONY
         iBcA==
X-Gm-Message-State: ACrzQf1kq/Em9y86Gh+tam87aMDWLmY+b+Db/sYmbN7GrC9pjCwWD1nv
        ptdpv0wMx5LxwVTRBsyNqOeL8v4YcW9Duzv4n/uCHZYc8dojRAo/j53BVxorXJoMQLX2BhWFCoj
        pS7w4O20AsYMqsLky
X-Received: by 2002:a05:6402:428a:b0:42e:8f7e:1638 with SMTP id g10-20020a056402428a00b0042e8f7e1638mr24577744edc.228.1664905228952;
        Tue, 04 Oct 2022 10:40:28 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM48meecWvYQG5X9uqsz1GXj/nSC2i59cHlSdS+Ua0zRzzrDnixdBLLyRAadNUEcQDRJGxOBcw==
X-Received: by 2002:a05:6402:428a:b0:42e:8f7e:1638 with SMTP id g10-20020a056402428a00b0042e8f7e1638mr24577723edc.228.1664905228649;
        Tue, 04 Oct 2022 10:40:28 -0700 (PDT)
Received: from localhost (net-37-117-136-211.cust.vodafonedsl.it. [37.117.136.211])
        by smtp.gmail.com with ESMTPSA id bt8-20020a170906b14800b0073dd1ac2fc8sm7379632ejb.195.2022.10.04.10.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 10:40:28 -0700 (PDT)
Date:   Tue, 4 Oct 2022 19:40:27 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        wizhao@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: act_mirred: use the backlog for mirred
 ingress
Message-ID: <YzxwCy7R0MdWZuO4@dcaratti.users.ipa.redhat.com>
References: <33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com>
 <YzCZMHYmk53mQ+HK@pop-os.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzCZMHYmk53mQ+HK@pop-os.localdomain>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Cong, thanks for looking at this!

On Sun, Sep 25, 2022 at 11:08:48AM -0700, Cong Wang wrote:
> On Fri, Sep 23, 2022 at 05:11:12PM +0200, Davide Caratti wrote:
> > William reports kernel soft-lockups on some OVS topologies when TC mirred
> > "egress-to-ingress" action is hit by local TCP traffic. Indeed, using the
> > mirred action in egress-to-ingress can easily produce a dmesg splat like:
> > 
> >  ============================================
> >  WARNING: possible recursive locking detected

[...]

> >  6.0.0-rc4+ #511 Not tainted
> >  --------------------------------------------
> >  nc/1037 is trying to acquire lock:
> >  ffff950687843cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160
> > 
> >  but task is already holding lock:
> >  ffff950687846cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160

FTR, this is:

2091         sk_incoming_cpu_update(sk);
2092
2093         bh_lock_sock_nested(sk); <--- the lock reported in the splat
2094         tcp_segs_in(tcp_sk(sk), skb);
2095         ret = 0;
2096         if (!sock_owned_by_user(sk)) {

> BTW, have you thought about solving the above lockdep warning in TCP
> layer?

yes, but that doesn't look like a trivial fix at all - and I doubt it's
worth doing it just to make mirred and TCP "friends". Please note:
on current kernel this doesn't just result in a lockdep warning: using
iperf3 on unpatched kernels it's possible to see a real deadlock, like:

WARRNING: possible circular locking dependency detected
 6.0.0-rc4+ #511 Not tainted
 ------------------------------------------------------
 iperf3/1021 is trying to acquire lock:
 ffff976005c5a630 (slock-AF_INET6/1){+...}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160

 but task is already holding lock:
 ffff97607b06e0b0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (slock-AF_INET/1){+.-.}-{2:2}:
        lock_acquire+0xd5/0x310
        _raw_spin_lock_nested+0x39/0x70
        tcp_v4_rcv+0x1023/0x1160
        ip_protocol_deliver_rcu+0x4d/0x280
        ip_local_deliver_finish+0xac/0x160
        ip_local_deliver+0x71/0x220
        ip_rcv+0x5a/0x200
        __netif_receive_skb_one_core+0x89/0xa0
        netif_receive_skb+0x1c1/0x400
        tcf_mirred_act+0x2a5/0x610 [act_mirred]
        tcf_action_exec+0xb3/0x210
        fl_classify+0x1f7/0x240 [cls_flower]
        tcf_classify+0x7b/0x320
        __dev_queue_xmit+0x3a4/0x11b0
        ip_finish_output2+0x3b8/0xa10
        ip_output+0x7f/0x260
        __ip_queue_xmit+0x1ce/0x610
        __tcp_transmit_skb+0xabc/0xc80
        tcp_rcv_established+0x284/0x810
        tcp_v4_do_rcv+0x1f3/0x370
        tcp_v4_rcv+0x10bc/0x1160
        ip_protocol_deliver_rcu+0x4d/0x280
        ip_local_deliver_finish+0xac/0x160
        ip_local_deliver+0x71/0x220
        ip_rcv+0x5a/0x200
        __netif_receive_skb_one_core+0x89/0xa0
        netif_receive_skb+0x1c1/0x400
        tcf_mirred_act+0x2a5/0x610 [act_mirred]
        tcf_action_exec+0xb3/0x210
        fl_classify+0x1f7/0x240 [cls_flower]
        tcf_classify+0x7b/0x320
        __dev_queue_xmit+0x3a4/0x11b0
        ip_finish_output2+0x3b8/0xa10
        ip_output+0x7f/0x260
        __ip_queue_xmit+0x1ce/0x610
        __tcp_transmit_skb+0xabc/0xc80
        tcp_write_xmit+0x229/0x12c0
        __tcp_push_pending_frames+0x32/0xf0
        tcp_sendmsg_locked+0x297/0xe10
        tcp_sendmsg+0x27/0x40
        sock_sendmsg+0x58/0x70
        sock_write_iter+0x9a/0x100
        vfs_write+0x481/0x4f0
        ksys_write+0xc2/0xe0
        do_syscall_64+0x3a/0x90
        entry_SYSCALL_64_after_hwframe+0x63/0xcd

 -> #0 (slock-AF_INET6/1){+...}-{2:2}:
        check_prevs_add+0x185/0xf50
        __lock_acquire+0x11eb/0x1620
        lock_acquire+0xd5/0x310
        _raw_spin_lock_nested+0x39/0x70
        tcp_v4_rcv+0x1023/0x1160
        ip_protocol_deliver_rcu+0x4d/0x280
        ip_local_deliver_finish+0xac/0x160
        ip_local_deliver+0x71/0x220
        ip_rcv+0x5a/0x200
        __netif_receive_skb_one_core+0x89/0xa0
        netif_receive_skb+0x1c1/0x400
        tcf_mirred_act+0x2a5/0x610 [act_mirred]
        tcf_action_exec+0xb3/0x210
        fl_classify+0x1f7/0x240 [cls_flower]
        tcf_classify+0x7b/0x320
        __dev_queue_xmit+0x3a4/0x11b0
        ip_finish_output2+0x3b8/0xa10
        ip_output+0x7f/0x260
        __ip_queue_xmit+0x1ce/0x610
        __tcp_transmit_skb+0xabc/0xc80
        tcp_rcv_established+0x284/0x810
        tcp_v4_do_rcv+0x1f3/0x370
        tcp_v4_rcv+0x10bc/0x1160
        ip_protocol_deliver_rcu+0x4d/0x280
        ip_local_deliver_finish+0xac/0x160
        ip_local_deliver+0x71/0x220
        ip_rcv+0x5a/0x200
        __netif_receive_skb_one_core+0x89/0xa0
        netif_receive_skb+0x1c1/0x400
        tcf_mirred_act+0x2a5/0x610 [act_mirred]
        tcf_action_exec+0xb3/0x210
        fl_classify+0x1f7/0x240 [cls_flower]
        tcf_classify+0x7b/0x320
        __dev_queue_xmit+0x3a4/0x11b0
        ip_finish_output2+0x3b8/0xa10
        ip_output+0x7f/0x260
        __ip_queue_xmit+0x1ce/0x610
        __tcp_transmit_skb+0xabc/0xc80
        tcp_write_xmit+0x229/0x12c0
        __tcp_push_pending_frames+0x32/0xf0
        tcp_sendmsg_locked+0x297/0xe10
        tcp_sendmsg+0x27/0x40
        sock_sendmsg+0x42/0x70
        sock_write_iter+0x9a/0x100
        vfs_write+0x481/0x4f0
        ksys_write+0xc2/0xe0
        do_syscall_64+0x3a/0x90
        entry_SYSCALL_64_after_hwframe+0x63/0xcd

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(slock-AF_INET/1);
                                lock(slock-AF_INET6/1);
                                lock(slock-AF_INET/1);
   lock(slock-AF_INET6/1);

  *** DEADLOCK ***

 12 locks held by iperf3/1021:
  #0: ffff976005c5a6c0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: tcp_sendmsg+0x19/0x40
  #1: ffffffffbca07320 (rcu_read_lock){....}-{1:2}, at: __ip_queue_xmit+0x5/0x610
  #2: ffffffffbca072e0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0xaa/0xa10
  #3: ffffffffbca072e0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x72/0x11b0
  #4: ffffffffbca07320 (rcu_read_lock){....}-{1:2}, at: netif_receive_skb+0x181/0x400
  #5: ffffffffbca07320 (rcu_read_lock){....}-{1:2}, at: ip_local_deliver_finish+0x54/0x160
  #6: ffff97607b06e0b0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160
  #7: ffffffffbca07320 (rcu_read_lock){....}-{1:2}, at: __ip_queue_xmit+0x5/0x610
  #8: ffffffffbca072e0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0xaa/0xa10
  #9: ffffffffbca072e0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x72/0x11b0
  #10: ffffffffbca07320 (rcu_read_lock){....}-{1:2}, at: netif_receive_skb+0x181/0x400
  #11: ffffffffbca07320 (rcu_read_lock){....}-{1:2}, at: ip_local_deliver_finish+0x54/0x160

 [...]

 kernel:watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [swapper/1:0]

Moreover, even if we improve TCP locking in order to avoid lockups for
this simple topology, I suspect that TCP will experience some packet
losses: when mirred detects 4 nested calls of tcf_mirred_act(), the kernel
will protect against excessive stack growth and drop the skb (that can
also be a full TSO packet). Probably the protocol can recover, but the
performance will be certainly non-optimal.

> Which also means we can no longer know the RX path status any more,
> right? I mean if we have filters on ingress, we can't know whether they
> drop this packet or not, after this patch? To me, this at least breaks
> users' expectation.

Fair point! Then maybe we don't need to change the whole TC mirred ingress:
since the problem only affects egress to ingress, we can preserve the call
to netif_recive_skb() on ingress->ingress, and just use the backlog in the
egress->ingress direction _ that has been broken since the very beginning
and got similar fixes in the past [1]. Something like:

-- >8 --
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -205,12 +205,14 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
        return err;
 }

-static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
+static int tcf_mirred_forward(bool want_ingress, bool at_ingress, struct sk_buff *skb)
 {
        int err;

        if (!want_ingress)
                err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
+       else if (!at_ingress)
+               err = netif_rx(skb);
        else
                err = netif_receive_skb(skb);

@@ -306,7 +308,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
                /* let's the caller reinsert the packet, if possible */
                if (use_reinsert) {
                        res->ingress = want_ingress;
-                       err = tcf_mirred_forward(res->ingress, skb);
+                       err = tcf_mirred_forward(res->ingress, at_ingress, skb);
                        if (err)
                                tcf_action_inc_overlimit_qstats(&m->common);
                        __this_cpu_dec(mirred_rec_level);
@@ -314,7 +316,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
                }
        }

-       err = tcf_mirred_forward(want_ingress, skb2);
+       err = tcf_mirred_forward(want_ingress, at_ingress, skb2);
        if (err) {
 out:
                tcf_action_inc_overlimit_qstats(&m->common);
-- >8 --

WDYT? Any feedback appreciated, thanks!

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=f799ada6bf2397c351220088b9b0980125c77280

-- 
davide

