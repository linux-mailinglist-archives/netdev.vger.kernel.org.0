Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1185D65FFEB
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjAFMD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjAFMDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:03:47 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F787676FD
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:03:44 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r2so1075506wrv.7
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYUQAOG5AcSttRnZWL6LGLkyBXkKg1iwgPNCoFkiDJw=;
        b=nsqRMnNXhaU4HfM6ka80UqEFWZb3NrULKcPkysyk3QR0murd5N3pJOnqyiMocjXCGj
         gM/lyk13hPROahXMOpnteRqkxaQxf0EEV2/J5S7ysLMxWwEBq13XLx9WDH793ECCpX+j
         tno17YXwm106d045QxB4pPbRy6epyTRlLxJg9fUQYFIptzn0RI7URZL8HgLPiMIFDJdN
         dCVuFx84DW3LrJYjME6Ekwqki2wveNO0eUjzEKyLy9V3nI/j/WdqpqOlpTO5WKmEjafd
         7nWSnx9mSQu4TCW8P+UOaqGj06YSHxvODfx2tUOTtyuhuocg+E6bMv35qudsTZlc5xIJ
         tBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dYUQAOG5AcSttRnZWL6LGLkyBXkKg1iwgPNCoFkiDJw=;
        b=D2E3YCeQLw6aGHU7l81AiBGs/ecY7qugce87F9r9brrumUvM4tgMOaoMCF0siiwpKT
         2vrLlBySy7jH2WFFaK73Ann8i4sEbYPiQrRws7mTR1FOKEtuXbxCGeve0y2MW1RCy+4q
         bKiYe63XUp0nbj9xB1E6eU/6v969WPkpGqs2tVX1lC3yxIoFwhUtjka6xD1m+F9r0WWm
         q+4soXgzO8e95qYgO8BgLBSqVBIIb2vzjP7Z+VTFoYNP0NhG0ntchD4OEPl64cVesnEk
         TQghYpcxTaK6uj4T0XmCbGD/QOftj5FoeHDV+ETk3QDq1YOHYPyrx8i8qkOgGFE7eEuS
         INqw==
X-Gm-Message-State: AFqh2kqaRI5rXv3w1E+QNkP6UiZMxjtNS4HHmHal2KqGKZiA9j6xOp8i
        MvRMRMg4Pgr7DOUaC4yCZwgyZGEC5yGFPFcHPfROa46OctT1mYoP
X-Google-Smtp-Source: AMrXdXsj1BNL7QLeQFp3ZsWmWzlKRguZMc7MrFab6XsH2tN0X76nYFUoB9YWg7qQPdJHO7X8kZzRdetyTTXAo14ZWCs=
X-Received: by 2002:a05:6000:1f98:b0:2ae:e70f:4c20 with SMTP id
 bw24-20020a0560001f9800b002aee70f4c20mr347961wrb.615.1673006622891; Fri, 06
 Jan 2023 04:03:42 -0800 (PST)
MIME-Version: 1.0
References: <20230104174744.22280-1-rrameshbabu@nvidia.com>
 <CAKErNvojEx1jeWfqoo+CA3iSJpc2URVbUvmdc=QtVEuif4_YNQ@mail.gmail.com> <878rihplfy.fsf@nvidia.com>
In-Reply-To: <878rihplfy.fsf@nvidia.com>
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Fri, 6 Jan 2023 14:03:16 +0200
Message-ID: <CAKErNvqDfnQM03Npj7Z2dfz_ATcPPuwvSng6MqqX1q=g2z8AWQ@mail.gmail.com>
Subject: Re: [PATCH net] sch_htb: Fix prematurely activating netdev during htb_destroy_class_offload
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Jan 2023 at 08:03, Rahul Rameshbabu <rrameshbabu@nvidia.com> wrot=
e:
>
> Maxim Mikityanskiy <maxtram95@gmail.com> writes:
>
> > On Wed, 4 Jan 2023 at 19:53, Rahul Rameshbabu <rrameshbabu@nvidia.com> =
wrote:
> >>
> >> When the netdev qdisc is updated correctly with the new qdisc before
> >> destroying the old qdisc, the netdev should not be activated till clea=
nup
> >> is completed. When htb_destroy_class_offload called htb_graft_helper, =
the
> >> netdev may be activated before cleanup is completed.
> >
> > Oh, so that's what was happening! Now I get the full picture:
> >
> > 1. The user does RTM_DELQDISC.
> > 2. qdisc_graft calls dev_deactivate, which sets dev_queue->qdisc to
> > NULL, but keeps dev_queue->qdisc_sleeping.
> > 3. The loop in qdisc_graft calls dev_graft_qdisc(dev_queue, new),
> > where new is NULL, for each queue.
> > 4. Then we get into htb_destroy_class_offload, and it's important
> > whether dev->qdisc is still HTB (before Eric's patch) or noop_qdisc
> > (after Eric's patch).
> > 5. If dev->qdisc is noop_qdisc, and htb_graft_helper accidentally
> > activates the netdev, attach_default_qdiscs will be called, and
> > dev_queue->qdisc will no longer be NULL for the rest of the queues,
> > hence the WARN_ON triggering.
> >
> > Nice catch indeed, premature activation of the netdev wasn't intended.
> >
> >> The new netdev qdisc
> >> may be used prematurely by queues before cleanup is done. Call
> >> dev_graft_qdisc in place of htb_graft_helper when destroying the htb t=
o
> >> prevent premature netdev activation.
> >>
> >> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
> >> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> >> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> >> Cc: Eric Dumazet <edumazet@google.com>
> >> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> >> ---
> >>  net/sched/sch_htb.c | 8 +++++---
> >>  1 file changed, 5 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> >> index 2238edece1a4..f62334ef016a 100644
> >> --- a/net/sched/sch_htb.c
> >> +++ b/net/sched/sch_htb.c
> >> @@ -1557,14 +1557,16 @@ static int htb_destroy_class_offload(struct Qd=
isc *sch, struct htb_class *cl,
> >>
> >>         WARN_ON(!q);
> >>         dev_queue =3D htb_offload_get_queue(cl);
> >> -       old =3D htb_graft_helper(dev_queue, NULL);
> >> -       if (destroying)
> >> +       if (destroying) {
> >> +               old =3D dev_graft_qdisc(dev_queue, NULL);
> >>                 /* Before HTB is destroyed, the kernel grafts noop_qdi=
sc to
> >>                  * all queues.
> >>                  */
> >>                 WARN_ON(!(old->flags & TCQ_F_BUILTIN));
> >
> > Now regarding this WARN_ON, I have concerns about its correctness.
> >
> > Can the user replace the root qdisc from HTB to something else with a
> > single command? I.e. instead of `tc qdisc del dev eth2 root handle 1:`
> > do `tc qdisc replace ...` or whatever that causes qdisc_graft to be
> > called with new !=3D NULL? If that is possible, then:
> >
> > 1. `old` won't be noop_qdisc, but rather the new qdisc (if it doesn't
> > support the attach callback) or the old one left from HTB (old =3D=3D q=
,
> > if the new qdisc supports the attach callback). WARN_ON should
> > trigger.
> >
> > 2. We shouldn't even call dev_graft_qdisc in this case (if destroying
> > is true). Likewise, we shouldn't try to revert it on errors or call
> > qdisc_put on it.
> >
> > Could you please try to reproduce this scenario of triggering WARN_ON?
> > I remember testing it, and something actually prevented me from doing
> > a replacement, but maybe I just missed something back then.
> >
>
> Reproduction steps
>
>   ip link set dev eth2 up
>   ip link set dev eth2 up
>   ip addr add 194.237.173.123/16 dev eth2
>   tc qdisc add dev eth2 clsact
>   tc qdisc add dev eth2 root handle 1: htb default 1 offload
>   tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil 22=
500.0mbit burst 450000kbit cburst 450000kbit
>   tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst 899=
00kbit cburst 89900kbit
>   tc qdisc replace dev eth2 root pfifo
>
> The warning is indeed triggered because the new root is pfifo rather
> than noop_qdisc. I agree with both points you brought up in the patch.
> When I saw the ternary in qdisc_graft for the rcu_assign_pointer call, I
> was worried about the case when new was defined as a new qdisc rather
> than defaulting to noop_qdisc but assumed there were some guaratees for
> htb.

OK, so that means my WARN_ON relies on false guarantees.

> However, I see a number of functions, not
> just offload related ones, in the htb implementation that seem to depend
> on the assumption that the old qdisc can safely be accessed with helpers
> such as htb_graft_helper. One such example is htb_change_class.

htb_graft_helper is only used by the offload, you can see that all
usages are guarded by if (q->offload).

> The
> trivial solution I see is to change qdisc_graft to first do a
> rcu_assign_pointer with noop_qdisc, call notify_and_destroy, and only
> afterwards call rcu_assign_pointer with the new qdisc if defined. Let me
> know your thoughts on this.

I don't think it's a good idea to introduce such a change to generic
code just to fix HTB offload. It would basically remove the ability to
replace the qdisc atomically, and there will be periods of time when
all packets are dropped.

> I believe the correct fix for a robust implementation of
> htb_destroy_class_offload would be to not depend on functions that
> retrieve the top level qdisc.

This is actually the case. The source of truth is internal data
structures of HTB, specifically cl->leaf.q points to the queue qdisc,
and cl->leaf.offload_queue points to the queue itself (the latter is
very useful when the qdisc is noop_qdisc, and we can't retrieve
dev_queue from the qdisc itself). Whenever we take a qdisc from the
netdev_queue itself, it should be only to check consistency with the
source of truth (please tell me if you spotted some places where it's
used for something else).

What I suggest to do to fix this particular bug:

1. Remove the WARN_ON check for noop_qdisc on destroy, it's simply
invalid. Rephrase the comment to explain why you WARN_ON(old !=3D q)
only when !destroying.

2. Don't graft anything on destroy, the kernel has already replaced
the qdisc with the right one (noop_qdisc on delete, the new qdisc on
replace).

3. qdisc_put down below shouldn't be called when destroying, because
we didn't graft anything ourselves. We should still call
qdisc_put(old) when err =3D=3D 0 to drop the ref (we hold one ref for
cl->leaf.q and the other ref for dev_queue->qdisc, which is normally
the same qdisc). And we should still graft old back on errors, but not
when destroying (we ignore all errors on destroy and just go on, we
can't fail).

>
>   [  384.474535] ------------[ cut here ]------------
>   [  384.476685] WARNING: CPU: 2 PID: 1038 at net/sched/sch_htb.c:1561 ht=
b_destroy_class_offload+0x179/0x430 [sch_htb]
>   [  384.481217] Modules linked in: sch_htb sch_ingress xt_conntrack xt_M=
ASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_=
netfilter overlay rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi rd=
ma_cm iw_cm ib_umad ib_ipoib ib_cm mlx5_ib ib_uverbs ib_core fuse mlx5_core
>   [  384.487081] CPU: 2 PID: 1038 Comm: tc Not tainted 6.1.0-rc2_for_upst=
ream_min_debug_2022_10_24_15_44 #1
>   [  384.488414] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>   [  384.489987] RIP: 0010:htb_destroy_class_offload+0x179/0x430 [sch_htb=
]
>   [  384.490937] Code: 2b 04 25 28 00 00 00 0f 85 cb 02 00 00 48 83 c4 48=
 44 89 f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 f6 45 10 01 0f 85 26 ff ff ff=
 <0f> 0b e9 1f ff ff ff 4d 3b 7e 40 0f 84 d9 fe ff ff 0f 0b e9 d2 fe
>   [  384.493495] RSP: 0018:ffff88815162b840 EFLAGS: 00010246
>   [  384.494358] RAX: 000000000000002a RBX: ffff88810e040000 RCX: 0000000=
021800002
>   [  384.495461] RDX: 0000000021800000 RSI: 0000000000000246 RDI: ffff888=
10e0404c0
>   [  384.496581] RBP: ffff888151ea0c00 R08: 0000000100006174 R09: fffffff=
f82897070
>   [  384.497684] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000=
000000001
>   [  384.498923] R13: ffff88810b189200 R14: ffff88810b189a00 R15: ffff888=
110060a00
>   [  384.500044] FS:  00007f7a2e7a3800(0000) GS:ffff88852cc80000(0000) kn=
lGS:0000000000000000
>   [  384.501390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [  384.502339] CR2: 0000000000487598 CR3: 0000000151f41003 CR4: 0000000=
000370ea0
>   [  384.503458] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
>   [  384.504581] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
>   [  384.505699] Call Trace:
>   [  384.506231]  <TASK>
>   [  384.506691]  ? tcf_block_put+0x74/0xa0
>   [  384.507365]  htb_destroy+0x142/0x3c0 [sch_htb]
>   [  384.508131]  ? hrtimer_cancel+0x11/0x40
>   [  384.508832]  ? rtnl_is_locked+0x11/0x20
>   [  384.509522]  ? htb_reset+0xe3/0x1a0 [sch_htb]
>   [  384.510293]  qdisc_destroy+0x3b/0xd0
>   [  384.510943]  qdisc_graft+0x40b/0x590
>   [  384.511600]  tc_modify_qdisc+0x577/0x870
>   [  384.512309]  rtnetlink_rcv_msg+0x2a2/0x390
>   [  384.513031]  ? rtnl_calcit.isra.0+0x120/0x120
>   [  384.513806]  netlink_rcv_skb+0x54/0x100
>   [  384.514495]  netlink_unicast+0x1f6/0x2c0
>   [  384.515190]  netlink_sendmsg+0x237/0x490
>   [  384.515890]  sock_sendmsg+0x33/0x40
>   [  384.516556]  ____sys_sendmsg+0x1d1/0x1f0
>   [  384.517265]  ___sys_sendmsg+0x72/0xb0
>   [  384.517942]  ? ___sys_recvmsg+0x7c/0xb0
>   [  384.518631]  __sys_sendmsg+0x51/0x90
>   [  384.519289]  do_syscall_64+0x3d/0x90
>   [  384.519943]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>   [  384.520794] RIP: 0033:0x7f7a2eaccc17
>   [  384.521449] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f=
 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05=
 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
>   [  384.524306] RSP: 002b:00007ffd8c62fe78 EFLAGS: 00000246 ORIG_RAX: 00=
0000000000002e
>   [  384.525568] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7=
a2eaccc17
>   [  384.526703] RDX: 0000000000000000 RSI: 00007ffd8c62fee0 RDI: 0000000=
000000003
>   [  384.527828] RBP: 0000000063b66264 R08: 0000000000000001 R09: 00007f7=
a2eb8da40
>   [  384.528962] R10: 0000000000405aeb R11: 0000000000000246 R12: 0000000=
000000001
>   [  384.530097] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000485400
>   [  384.531221]  </TASK>
>   [  384.531689] ---[ end trace 0000000000000000 ]---
>
> >> -       else
> >> +       } else {
> >> +               old =3D htb_graft_helper(dev_queue, NULL);
> >>                 WARN_ON(old !=3D q);
> >> +       }
> >>
> >>         if (cl->parent) {
> >>                 _bstats_update(&cl->parent->bstats_bias,
> >> --
> >> 2.36.2
> >>
