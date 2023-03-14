Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81EB6B98E7
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjCNPYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjCNPYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:24:02 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329E448E38
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:23:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y11so16994401plg.1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678807430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32mKX8In1Zf0WmqBWIWW4kuY9TrKAAfpNDz5LyHiASM=;
        b=qfci/WnCIYy5VjIq44VzIfr8Ala4eBIJLcc+nVpsuS1oyiVmVfbdQNfjyRQVHx69r2
         7l2n2/MiPEhMm+VVpuXgAvsEsuO8FKIC4TMgIHrE1/xiHSOfxY+I3Du6Hh5BjcaCx4zi
         71zfCJK8N9Xcu9PLOuDiuhi2eXHWL9wVgRATh20nbfHvFrBpBbpBYrf/EQOZTAc+jY3I
         3eN4g5lx85QdvMo7EZcTItiWzx5x+X/lV34Zu+Ea/guNw6Gy/hNfoMrWLYQFO+WLi/kK
         s3YpypoKOYHL5voHfxOTVSYITzgbUg62ORWB+cJLbGUiMrR4Fa0fgnizfCtVK/KQlRnB
         daqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678807430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32mKX8In1Zf0WmqBWIWW4kuY9TrKAAfpNDz5LyHiASM=;
        b=NxP8X6jsrzsKjgfaKcOFjxeZKlNiZAbP2hnFN467aSNWUIdp0X6E0zqwSClf9IjYP2
         K0bb6YMJaSx6MbDRiCk61PwWOwqSQ/qkw+TcDPglw+hhTs9gDyd1ixvbw3xlGx6ZbzDC
         O4zq0T374XlbkO7JbcUqbk27hGmVjA+m8EfciN8DsDCphx7wxpPHOmOrzGSfanuydV9k
         mQeb0GH3DjTyyA/fWM9FBd7Vu9S2RRKndYSgXvsewQPQLCvWVY7lSPjAiBuXADEwTg39
         bCBqU9w/wmHTGlve0p7db7RjN8GTjBSty50EQiGxbc5sSURDAtcQZSE+RBXjwccnhBN/
         jFhA==
X-Gm-Message-State: AO0yUKWHlpvhC5IwSOQXmtpzpEQFgKW/Uavs2XhrduZm0kX0oCxr3NFa
        mbiERQsuVeP6mRp1ruMf9o2fFq9iciNYEZkIIBg=
X-Google-Smtp-Source: AK7set+SXJz/I0aR+P8LomY5S15BG+f0XMgO8C8/3ob7sLGhxiI2SHsHjFsG5LtbZ6sTalzZV47o3JNkT2NUBao/Q54=
X-Received: by 2002:a17:90a:6389:b0:236:6e4c:8a1e with SMTP id
 f9-20020a17090a638900b002366e4c8a1emr13685569pjj.1.1678807430208; Tue, 14 Mar
 2023 08:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAL87dS0sSsKQOcf22gcHuHu7PjG_j1uiOx-AfRKdT7rznVfJ6Q@mail.gmail.com>
 <20230310213804.26304-1-kuniyu@amazon.com> <CAL87dS3Brkkbi-j-_W3LYORWJ+VOXockpiBwNZQ84rWk+o8SXw@mail.gmail.com>
 <CANn89iK4+SoBG3QwvumauH+X8GOxWZyd8S7YC_bFC-3AW8H-aA@mail.gmail.com>
In-Reply-To: <CANn89iK4+SoBG3QwvumauH+X8GOxWZyd8S7YC_bFC-3AW8H-aA@mail.gmail.com>
From:   mingkun bian <bianmingkun@gmail.com>
Date:   Tue, 14 Mar 2023 23:23:38 +0800
Message-ID: <CAL87dS094GfbtDeYBkqXH6HWeDS4j6CZy1i5SSNQxew9f7W8-g@mail.gmail.com>
Subject: Re: [ISSUE]soft lockup in __inet_lookup_established() function which
 one sock exist in two hash buckets(tcp_hashinfo.ehash)
To:     Eric Dumazet <edumazet@google.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, kerneljasonxing@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 at 20:30, Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Mar 10, 2023 at 10:46=E2=80=AFPM mingkun bian <bianmingkun@gmail.=
com> wrote:
> >
> > Hi,
> >
> >     I am sorry that a newer kernel is not available to us for a period
> > of time for other reasons, this issue is still found in 4.19 of arm,
> > maybe this issue has nothing to do with kernel version, please tell me
> > if you find any patch about this issue.
> >
>
> The 'maybe' question needs to be answered by you...
>
> 4.19 is too vague.
>
> Also you mention arm, but your crash output refers to x86_64.
>
> What exact kernel version have you tried ?


    I am sorry my description is misleading=EF=BC=8Canalysis of these three
vmcores's kernel version is 4.18.0-147.el8(x86), and arm kernel has
the same problem, whose version is 4.19.36, arm's call stack is as
follow:

[65394.003809] Call trace:
[65394.003810]  dump_backtrace+0x0/0x198
[65394.003812]  show_stack+0x24/0x30
[65394.003813]  dump_stack+0xa4/0xcc
[65394.003817]  panic+0x12c/0x314
[65394.003818]  watchdog_timer_fn+0x3e4/0x3e8
[65394.003820]  __hrtimer_run_queues+0x114/0x358
[65394.003821]  hrtimer_interrupt+0x104/0x2d8
[65394.003823]  arch_timer_handler_phys+0x38/0x58
[65394.003825]  handle_percpu_devid_irq+0x90/0x248
[65394.003827]  generic_handle_irq+0x34/0x50
[65394.003828]  __handle_domain_irq+0x68/0xc0
[65394.003829]  gic_handle_irq+0x6c/0x170
[65394.003830]  el1_irq+0xb8/0x140
[65394.003832]  __inet_lookup_established+0x138/0x170
[65394.003833]  tcp_v4_early_demux+0xa8/0x158
[65394.003836]  ip_rcv_finish_core.isra.1+0x154/0x398
[65394.003837]  ip_rcv_finish+0x74/0xb0
[65394.003838]  ip_rcv+0x64/0xd0
[65394.003841]  __netif_receive_skb_one_core+0x68/0x90
[65394.003842]  __netif_receive_skb+0x28/0x80
[65394.003844]  netif_receive_skb_internal+0x54/0x100
[65394.003845]  napi_gro_receive+0xf8/0x170

    Today I analyzed several other different vmcore-dmesg.txt(x86,
some devices do not generate vocore, only generate vmcore-dmesg.txt),
I suspect all problems are caused by the same issue: a sock being used
is reused.
https://lore.kernel.org/netdev/CAL87dS2XjE2f0+HJ4DH4zzQwz1K-LYQx0rV0t=3Dsbs=
343pxar2Q@mail.gmail.com/

vmcore4:
[294533.784965] WARNING: CPU: 12 PID: 34340 at
./include/net/request_sock.h:112 sock_gen_put+0x98/0xb0
[294533.785014] RIP: 0010:sock_gen_put+0x98/0xb0
[294533.785016] Code: 00 e8 1c 3f b2 ff 48 8b 83 e0 00 00 00 48 89 de
5b 48 8b 78 08 e9 f8 3a b2 ff 48 89 df 5b e9 3f 1d 00 00 e8 9a c6 f6
ff eb d0 <0f> 0b 66 0f 1f 44 00 00
 eb 9b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00
[294533.785017] RSP: 0018:ffffb8e3e0f1ba58 EFLAGS: 00010206
[294533.785018] RAX: 0000000000000003 RBX: ffff921b7d8e9e30 RCX:
ffffffffa79951c0
[294533.785018] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
ffff921b7d8e9e30
[294533.785019] RBP: 0000000000000003 R08: 0000000000000048 R09:
ffff91edc0429d38
[294533.785020] R10: ffff92183bc78e00 R11: ffffe14193d13c00 R12:
ffff91f7ab6e73d8
[294533.785020] R13: 0000000000000001 R14: 0000000000000000 R15:
ffff921b7d8e9e30
[294533.785021] FS:  00007f05ab7fe700(0000) GS:ffff9204a0b00000(0000)
knlGS:0000000000000000
[294533.785022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[294533.785023] CR2: 00007f05ab7fc968 CR3: 00000017c9d9c006 CR4:
00000000007606e0
[294533.785024] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[294533.785025] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[294533.785025] PKRU: 55555554
[294533.785026] Call Trace:
[294533.785033]  inet_diag_dump_icsk+0x1fe/0x560 [inet_diag]
[294533.785055]  __inet_diag_dump+0x41/0x80 [inet_diag]
[294533.785057]  inet_diag_dump_compat+0xba/0xe0 [inet_diag]
[294533.785059]  netlink_dump+0x2a9/0x380
[294533.785061]  netlink_recvmsg+0x241/0x3e0
[294533.785064]  ___sys_recvmsg+0xda/0x1f0
[294533.785073]  __sys_recvmsg+0x55/0xa0
[294533.785077]  do_syscall_64+0x5b/0x1b0
[294533.785080]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[294533.785082] RIP: 0033:0x7f05b4e6ec7d
[294533.785083] Code: c5 20 00 00 75 10 b8 2f 00 00 00 0f 05 48 3d 01
f0 ff ff 73 31 c3 48 83 ec 08 e8 ce f7 ff ff 48 89 04 24 b8 2f 00 00
00 0f 05 <48> 8b 3c 24 48 89 c2 e8
 17 f8 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[294533.785084] RSP: 002b:00007f05ab7fc960 EFLAGS: 00000293 ORIG_RAX:
000000000000002f
[294533.785086] RAX: ffffffffffffffda RBX: 00007f05ab7fde08 RCX:
00007f05b4e6ec7d
[294533.785087] RDX: 0000000000000000 RSI: 00007f05ab7fc9a0 RDI:
000000000000000e
[294533.785087] RBP: 00007f05ab7fc9a0 R08: 0000000000000000 R09:
00007f05b183e354
[294533.785088] R10: 000000002318f258 R11: 0000000000000293 R12:
000000000000000e
[294533.785089] R13: 00007f05ab7fc980 R14: 00007f05ab7fc990 R15:
0000000000000000
[294533.785091] ---[ end trace 88fc755f0bfa4358 ]---

1. this means that req->rsk_refcnt is not zero

static inline void reqsk_free(struct request_sock *req)
{
/* temporary debugging */
WARN_ON_ONCE(refcount_read(&req->rsk_refcnt) !=3D 0);
req->rsk_ops->destructor(req);
if (req->rsk_listener)
sock_put(req->rsk_listener);
kfree(req->saved_syn);
kmem_cache_free(req->rsk_ops->slab, req);
}

'refcount_dec_and_test(&sk->sk_refcnt)' has checked that sk->sk_refcnt
is zero, then
program can be executed to =E2=80=98reqsk_free(inet_reqsk(sk))=E2=80=99, bu=
t
reqsk_free check the req->rsk_refcnt is not zero(maybe the sock is
reusing here).

void sock_gen_put(struct sock *sk)
{
if (!refcount_dec_and_test(&sk->sk_refcnt))
return;

if (sk->sk_state =3D=3D TCP_TIME_WAIT)
inet_twsk_free(inet_twsk(sk));
else if (sk->sk_state =3D=3D TCP_NEW_SYN_RECV)
reqsk_free(inet_reqsk(sk));
else
sk_free(sk);
}

[294533.826402] IPv4: Attempt to release TCP socket in state 10 00000000843=
67c12
2. this means that a sock will be freed but its tcp_state is not
TCP_CLOSE.(sock pointer is illegal, I do not know why sk->sk_state can
be print 10, for other vmcore logs, sock pointers are all illegal and
tcp_state are 10 when printing error log like this.)

[294535.309290] BUG: unable to handle kernel paging request at 000000000002=
7807
[294535.309385] PGD 0 P4D 0
[294535.309560] CPU: 9 PID: 8909 Comm: ss
[294535.309752] RIP: 0010:inet_diag_dump_icsk+0x434/0x560 [inet_diag]
[294535.309844] Code: 8d 2c 18 48 89 ef e8 1b 93 77 e6 4c 8b 6d 08 4d
85 ed 74 41 49 83 ed 68 45 31 e4 eb 0d 4d 8b 6d 68 4d 85 ed 74 2f 49
83 ed 68 <49> 3b 5d 30 75 ed 45 39
 e7 7f 13 48 8b 44 24 20 0f b6 00 84 c0 74
[294535.309952] RSP: 0018:ffffb8e3f795fac0 EFLAGS: 00010206
[294535.310041] RAX: 0000000000000000 RBX: ffffffffa79951c0 RCX:
ffffb8e3f795fa60
[294535.310133] RDX: ffffb8e3f795fa5c RSI: 0000000000000000 RDI:
ffff9203dc656180
[294535.310228] RBP: ffffffffa829dc70 R08: 0000000000000000 R09:
ffff91fe3a8bcb60
[294535.310323] R10: ffff91edc7c06600 R11: 00000000000001b0 R12:
0000000000000099
[294535.310414] R13: 00000000000277d7 R14: 0000000000000017 R15:
000000000000007d
[294535.310823] FS:  00007f963cbc2840(0000) GS:ffff9204a0a40000(0000)
knlGS:0000000000000000
[294535.311538] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[294535.311945] CR2: 0000000000027807 CR3: 0000001340cb0004 CR4:
00000000007606e0
[294535.312658] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[294535.313367] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[294535.314093] PKRU: 55555554
[294535.314495] Call Trace:
[294535.316724]  __inet_diag_dump+0x41/0x80 [inet_diag]
[294535.317086]  netlink_dump+0x2a9/0x380
[294535.317477]  netlink_recvmsg+0x241/0x3e0
[294535.318264]  ___sys_recvmsg+0xda/0x1f0
[294535.320247]  __sys_recvmsg+0x55/0xa0
[294535.320647]  do_syscall_64+0x5b/0x1b0
[294535.321053]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[294535.321454] RIP: 0033:0x7f963c4bcf40

3. after two second, sock_net(sk) encountered Illegal pointer, which
sk is 0000000000027807

void inet_diag_dump_icsk() {
...
next_chunk:
num =3D 0;
accum =3D 0;
spin_lock_bh(lock);
sk_nulls_for_each(sk, node, &head->chain) {
int state;

if (!net_eq(sock_net(sk), net))
continue;
}



vmcoe5:
[4587539.575521] IPv4: Attempt to release TCP socket in state 10
00000000f7fb3e79
[4587542.086643] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000990
[4587542.087134] RIP: 0010:tcp_md5_do_lookup+0x5/0x120
[4587542.087227] Code: 00 00 00 00 00 f0 ff 8f 80 00 00 00 0f 88 a4 2b
0d 00 74 01 c3 e9 fb fc f4 ff 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00 00 <48> 8b 87 90 09 00 00 4
8 85 c0 0f 84 01 01 00 00 48 8b 38 48 85 ff
[4587542.087343] RSP: 0000:ffff981cdfb43b40 EFLAGS: 00010282
[4587542.087434] RAX: ffff981523893000 RBX: ffff9814ca5c3100 RCX:
0000000013c00000
[4587542.087529] RDX: 0000000000000002 RSI: ffff98152389305a RDI:
0000000000000000
[4587542.087623] RBP: ffffffff8b5951c0 R08: 0000000000000001 R09:
0000000000000001
[4587542.087717] R10: 0000000000000008 R11: ffff981cc6f6d600 R12:
0000000000000000
[4587542.087811] R13: ffff981523893062 R14: ffff98152389304e R15:
ffff98152389305a
[4587542.088216] FS:  00007fd717914fc0(0000) GS:ffff981cdfb40000(0000)
knlGS:0000000000000000
[4587542.088954] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[4587542.089351] CR2: 0000000000000990 CR3: 00000016f1d7c003 CR4:
00000000007606e0
[4587542.090065] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[4587542.090788] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[4587542.091513] PKRU: 55555554
[4587542.091899] Call Trace:
[4587542.092294]  <IRQ>
[4587542.092688]  tcp_v4_inbound_md5_hash+0x57/0x1b0
[4587542.093084]  tcp_v4_rcv+0x4df/0xae0
[4587542.093481]  ? __wake_up_common+0x8f/0x160
[4587542.093886]  ip_local_deliver_finish+0x69/0x1f0
[4587542.094290]  ip_local_deliver+0x6b/0xe0
[4587542.094690]  ? ip_rcv_finish+0x430/0x430
[4587542.095090]  ip_rcv+0x27c/0x380
[4587542.095490]  __netif_receive_skb_core+0x9e9/0xac0
[4587542.095892]  ? inet_gro_receive+0x21b/0x2d0
[4587542.096284]  netif_receive_skb_internal+0x42/0xf0
[4587542.096640]  napi_gro_receive+0xbf/0xe0
[4587542.097025]  mlx5e_handle_rx_cqe_mpwrq+0xd0/0x170 [mlx5_core]
[4587542.097404]  mlx5e_poll_rx_cq+0xe0/0x960 [mlx5_core]
[4587542.097784]  mlx5e_napi_poll+0xb3/0xc40 [mlx5_core]
[4587542.098192]  net_rx_action+0x2a5/0x400
[4587542.098597]  __do_softirq+0xe2/0x2d7
[4587542.098992]  irq_exit+0xec/0x100
[4587542.099383]  do_IRQ+0x54/0xe0
[4587542.099784]  common_interrupt+0xf/0xf
[4587542.100180]  </IRQ>
[4587542.100574] RIP: 0033:0x563d63ef7cd8

the wrong point is that tp is 0000000000000990, which is set by
req->rsk_listener in tcp_v4_rcv.

struct tcp_md5sig_key *tcp_md5_do_lookup(const struct sock *sk,
const union tcp_md5_addr *addr,
int family)
{
const struct tcp_sock *tp =3D tcp_sk(sk);
struct tcp_md5sig_key *key;
const struct tcp_md5sig_info *md5sig;
__be32 mask;
struct tcp_md5sig_key *best_match =3D NULL;
bool match;

/* caller either holds rcu_read_lock() or socket lock */
md5sig =3D rcu_dereference_check(tp->md5sig_info,
       lockdep_sock_is_held(sk));
...
}

int tcp_v4_rcv(struct sk_buff *skb)
{
    ...
if (sk->sk_state =3D=3D TCP_NEW_SYN_RECV) {
struct request_sock *req =3D inet_reqsk(sk);
bool req_stolen =3D false;
struct sock *nsk;

sk =3D req->rsk_listener;
if (unlikely(tcp_v4_inbound_md5_hash(sk, skb))) {
sk_drops_add(sk, skb);
reqsk_put(req);
goto discard_it;
}

    Although there are many types of crashes, the proportion of
crashes is still very low.
Another point, our devices has a lot of TIME_WAIT. My analysis feels a
bit confused, but it may be pointed to the same issue about sk reuse,
can you give me some ideas?

   Thanks.


>
>
> > Thanks.
> >
> > On Sat, 11 Mar 2023 at 05:38, Kuniyuki Iwashima <kuniyu@amazon.com> wro=
te:
> > >
> > > From:   mingkun bian <bianmingkun@gmail.com>
> > > Date:   Fri, 10 Mar 2023 22:51:31 +0800
> > > > Hi,
> > > >
> > > >     I am sorry to submit the same post, because the format of the
> > > > previous post is wrong.
> > > >
> > > >     I have encountered the same issue which causes loop in
> > > > __inet_lookup_established for 22 seconds, then kernel crash,
> > > > similarly, we have thousands of devices with heavy network traffic,
> > > > but only a few of them crash every day due to this reason.
> > > >
> > > >  https://lore.kernel.org/lkml/CAL+tcoDAY=3DQ5pohEPgkBTNghxTb0AhmbQD=
58dPDghyxmrcWMRQ@mail.gmail.com/T/#mb7b613de68d86c9a302ccf227292ac273cbe7f7=
c
> > > >
> > > >     Kernel version is 4.18.0, I analyzed the vmcore and find the po=
int
> > >
> > > Thanks for the report, but you should not use 4.18.0 at least, which
> > > is no longer supported.  Could you try reproducing it on the net-next
> > > tree or another stable versions listed below ?
> > >
> > > https://www.kernel.org/category/releases.html
> > >
> > > Thanks,
> > > Kuniyuki
> > >
> > >
> > > > of infinite loop is that one sock1 pointers exist in two hash
> > > > buckets(tcp_hashinfo.ehash),
> > > >
> > > >     tcp_hashinfo.ehash is as following:
> > > >     buckets0:
> > > >     buckets1:->sock1*->0x31(sock1->sk_nulls_node.next =3D 0x31, whi=
ch
> > > > means that sock1* is the end of buckets1), sock1* should not be her=
e
> > > > at buckets1,the real vmcore also has only one sock* in buckets1.
> > > >     buckets2:
> > > >     buckets3:->sock1*->0x31, sock1* is in the correct position at b=
uckets3
> > > >     buckets4:->sock2*
> > > >     ...
> > > >     buckets:N->sockn*
> > > >
> > > >     then a skb(inet_ehashfn=3D0x1) came, it matched to buckets1, an=
d the
> > > > condition validation(sk->sk_hash !=3D hash) failed, then entered
> > > > condition validation(get_nulls_value(node) !=3D slot) ,
> > > >     get_nulls_value(node) =3D 3
> > > >     slot =3D 1
> > > >     finally, go to begin, and infinite loop.
> > > >
> > > >     begin:
> > > >     sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > > >     if (sk->sk_hash !=3D hash)
> > > >         continue;
> > > >     }
> > > >     ...
> > > >     if (get_nulls_value(node) !=3D slot)
> > > >         goto begin;
> > > >
> > > >    why does sock1 can exist in two hash buckets, are there some
> > > > scenarios where the sock is not deleted from the tcp_hashinfo.ehash
> > > > before sk_free?
> > > >
> > > >
> > > >   The detailed three vmcore information is as follow=EF=BC=9A
> > > >   vmcore1' info:
> > > >   1. print the skb, skb is 0xffff94824975e000 which stored in stack=
.
> > > >
> > > >    crash> p *(struct tcphdr *)(((struct
> > > > sk_buff*)0xffff94824975e000)->head + ((struct
> > > > sk_buff*)0xffff94824975e000)->transport_header)
> > > >   $4 =3D {
> > > >   source =3D 24125,
> > > >   dest =3D 47873,
> > > >   seq =3D 4005063716,
> > > >   ack_seq =3D 1814397867,
> > > >   res1 =3D 0,
> > > >   doff =3D 8,
> > > >   fin =3D 0,
> > > >   syn =3D 0,
> > > >   rst =3D 0,
> > > >   psh =3D 1,
> > > >   ack =3D 1,
> > > >   urg =3D 0,
> > > >   ece =3D 0,
> > > >   cwr =3D 0,
> > > >   window =3D 33036,
> > > >   check =3D 19975,
> > > >   urg_ptr =3D 0
> > > > }
> > > >
> > > > 2. print the sock1, tcp is in TIME_WAIT,the detailed analysis proce=
ss
> > > > is as follows:
> > > > a. R14 is 0xffffad2e0dc8a210, which is &hashinfo->ehash[slot].
> > > >
> > > > crash> p *((struct inet_ehash_bucket*)0xffffad2e0dc8a210)
> > > > $14 =3D {
> > > >   chain =3D {
> > > >     first =3D 0xffff9483ba400f48
> > > >   }
> > > > }
> > > >
> > > > b. sock* =3D 0xffff9483ba400f48 - offset(sock, sk_nulls_node) =3D 0=
xffff9483ba400ee0
> > > >
> > > > we can see sock->sk_nulls_node is:
> > > >   skc_nulls_node =3D {
> > > >         next =3D 0x4efbf,
> > > >         pprev =3D 0xffffad2e0dd2cef8
> > > >       }
> > > >
> > > > c. skb inet_ehashfn is 0x13242 which is in R15.
> > > >
> > > > sock->skc_node is 0x4efbf, then its real slot is 0x4efbf >> 1 =3D 0=
x277df
> > > > then bukets[0x277df] is (0x277df - 0x13242) * 8 + 0xffffad2e0dc8a21=
0 =3D
> > > > 0xFFFFAD2E0DD2CEF8
> > > >
> > > > d. print bukets[0x277df], find 0xffff9483ba400f48 is the same  as
> > > > bukets[0x13242]
> > > >
> > > > crash> p *((struct inet_ehash_bucket*)0xFFFFAD2E0DD2CEF8)
> > > > $32 =3D {
> > > >   chain =3D {
> > > >     first =3D 0xffff9483ba400f48
> > > >   }
> > > > }
> > > >
> > > > crash> p *((struct inet_timewait_sock*)0xffff9483ba400ee0)
> > > > $5 =3D {
> > > >   __tw_common =3D {
> > > >     {
> > > >       skc_addrpair =3D 1901830485687183552,
> > > >       {
> > > >         skc_daddr =3D 442804416,
> > > >         skc_rcv_saddr =3D 442804416
> > > >       }
> > > >     },
> > > >     {
> > > >       skc_hash =3D 2667739103,
> > > >       skc_u16hashes =3D {30687, 40706}
> > > >     },
> > > >     {
> > > >       skc_portpair =3D 3817294857,
> > > >       {
> > > >         skc_dport =3D 19465,
> > > >         skc_num =3D 58247
> > > >       }
> > > >     },
> > > >     skc_family =3D 2,
> > > >     skc_state =3D 6 '\006',
> > > >     skc_reuse =3D 0 '\000',
> > > >     skc_reuseport =3D 0 '\000',
> > > >     skc_ipv6only =3D 0 '\000',
> > > >     skc_net_refcnt =3D 0 '\000',
> > > >     skc_bound_dev_if =3D 0,
> > > >     {
> > > >       skc_bind_node =3D {
> > > >         next =3D 0x0,
> > > >         pprev =3D 0xffff9492a8950538
> > > >       },
> > > >       skc_portaddr_node =3D {
> > > >         next =3D 0x0,
> > > >         pprev =3D 0xffff9492a8950538
> > > >       }
> > > >     },
> > > >     skc_prot =3D 0xffffffff9b9a9840,
> > > >     skc_net =3D {
> > > >       net =3D 0xffffffff9b9951c0
> > > >     },
> > > >     skc_v6_daddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D
> > > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > > >         u6_addr32 =3D {0, 0, 0, 0}
> > > >       }
> > > >     },
> > > >     skc_v6_rcv_saddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D
> > > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > > >         u6_addr32 =3D {0, 0, 0, 0}
> > > >       }
> > > >     },
> > > >     skc_cookie =3D {
> > > >       counter =3D 0
> > > >     },
> > > >     {
> > > >       skc_flags =3D 18446744072025102208,
> > > >       skc_listener =3D 0xffffffff9b995780,
> > > >       skc_tw_dr =3D 0xffffffff9b995780
> > > >     },
> > > >     skc_dontcopy_begin =3D 0xffff9483ba400f48,
> > > >     {
> > > >       skc_node =3D {
> > > >         next =3D 0x4efbf,
> > > >         pprev =3D 0xffffad2e0dd2cef8
> > > >       },
> > > >       skc_nulls_node =3D {
> > > >         next =3D 0x4efbf,
> > > >         pprev =3D 0xffffad2e0dd2cef8
> > > >       }
> > > >     },
> > > >     skc_tx_queue_mapping =3D 0,
> > > >     skc_rx_queue_mapping =3D 0,
> > > >     {
> > > >       skc_incoming_cpu =3D -1680142171,
> > > >       skc_rcv_wnd =3D 2614825125,
> > > >       skc_tw_rcv_nxt =3D 2614825125
> > > >     },
> > > >     skc_refcnt =3D {
> > > >       refs =3D {
> > > >         counter =3D 3
> > > >       }
> > > >     },
> > > >     skc_dontcopy_end =3D 0xffff9483ba400f64,
> > > >     {
> > > >       skc_rxhash =3D 320497927,
> > > >       skc_window_clamp =3D 320497927,
> > > >       skc_tw_snd_nxt =3D 320497927
> > > >     }
> > > >   },
> > > >   tw_mark =3D 0,
> > > >   tw_substate =3D 6 '\006',
> > > >   tw_rcv_wscale =3D 10 '\n',
> > > >   tw_sport =3D 34787,
> > > >   tw_kill =3D 0,
> > > >   tw_transparent =3D 0,
> > > >   tw_flowlabel =3D 0,
> > > >   tw_pad =3D 0,
> > > >   tw_tos =3D 0,
> > > >   tw_timer =3D {
> > > >     entry =3D {
> > > >       next =3D 0xffff9483ba401d48,
> > > >       pprev =3D 0xffff9481680177f8
> > > >     },
> > > >     expires =3D 52552264960,
> > > >     function =3D 0xffffffff9ad67ba0,
> > > >     flags =3D 1339031587,
> > > >     rh_reserved1 =3D 0,
> > > >     rh_reserved2 =3D 0,
> > > >     rh_reserved3 =3D 0,
> > > >     rh_reserved4 =3D 0
> > > >   },
> > > >   tw_tb =3D 0xffff9492a8950500
> > > > }
> > > > 3.call stack
> > > > [48256841.222682]  panic+0xe8/0x25c
> > > > [48256841.222766]  ? secondary_startup_64+0xb6/0xc0
> > > > [48256841.222853]  watchdog_timer_fn+0x209/0x210
> > > > [48256841.222939]  ? watchdog+0x30/0x30
> > > > [48256841.223027]  __hrtimer_run_queues+0xe5/0x260
> > > > [48256841.223117]  hrtimer_interrupt+0x122/0x270
> > > > [48256841.223209]  ? sched_clock+0x5/0x10
> > > > [48256841.223296]  smp_apic_timer_interrupt+0x6a/0x140
> > > > [48256841.223384]  apic_timer_interrupt+0xf/0x20
> > > > [48256841.223471] RIP: 0010:__inet_lookup_established+0xe9/0x170
> > > > [48256841.223562] Code: f6 74 33 44 3b 62 a4 75 3d 48 3b 6a 98 75 3=
7
> > > > 8b 42 ac 85 c0 75 24 4c 3b 6a c8 75 2a 5b 5d 41 5c 41 5d 41 5e 48 8=
9
> > > > f8 41 5f c3 <48> d1 ea 49 39 d7 0f 85 5a ff ff ff 31 ff eb e2 39 44=
 24
> > > > 38 74 d6
> > > > [48256841.224242] RSP: 0018:ffff9497e0e83bf8 EFLAGS: 00000202
> > > > ORIG_RAX: ffffffffffffff13
> > > > [48256841.224904] RAX: ffffad2e0dbf1000 RBX: 0000000088993242 RCX:
> > > > 0000000034d20a82
> > > > [48256841.225576] RDX: 000000000004efbf RSI: 00000000527c6da0 RDI:
> > > > 0000000000000000
> > > > [48256841.226268] RBP: 1e31b4763470e11b R08: 0000000001bb5e3d R09:
> > > > 00000000000001bb
> > > > [48256841.226969] R10: 0000000000005429 R11: 0000000000000000 R12:
> > > > 0000000001bb5e3d
> > > > [48256841.227646] R13: ffffffff9b9951c0 R14: ffffad2e0dc8a210 R15:
> > > > 0000000000013242
> > > > [48256841.228330]  ? apic_timer_interrupt+0xa/0x20
> > > > [48256841.228714]  ? __inet_lookup_established+0x3f/0x170
> > > > [48256841.229097]  tcp_v4_early_demux+0xb0/0x170
> > > > [48256841.229487]  ip_rcv_finish+0x17c/0x430
> > > > [48256841.229865]  ip_rcv+0x27c/0x380
> > > > [48256841.230242]  __netif_receive_skb_core+0x9e9/0xac0
> > > > [48256841.230623]  ? inet_gro_receive+0x21b/0x2d0
> > > > [48256841.230999]  ? recalibrate_cpu_khz+0x10/0x10
> > > > [48256841.231378]  netif_receive_skb_internal+0x42/0xf0
> > > > [48256841.231777]  napi_gro_receive+0xbf/0xe0
> > > >
> > > >
> > > > vmcore2' info:
> > > >  1. print the skb
> > > > crash> p *(struct tcphdr *)(((struct
> > > > sk_buff*)0xffff9d60c008b500)->head + ((struct
> > > > sk_buff*)0xffff9d60c008b500)->transport_header)
> > > > $28 =3D {
> > > >   source =3D 35911,
> > > >   dest =3D 20480,
> > > >   seq =3D 1534560442,
> > > >   ack_seq =3D 0,
> > > >   res1 =3D 0,
> > > >   doff =3D 10,
> > > >   fin =3D 0,
> > > >   syn =3D 1,
> > > >   rst =3D 0,
> > > >   psh =3D 0,
> > > >   ack =3D 0,
> > > >   urg =3D 0,
> > > >   ece =3D 0,
> > > >   cwr =3D 0,
> > > >   window =3D 65535,
> > > >   check =3D 56947,
> > > >   urg_ptr =3D 0
> > > > }
> > > > 2. print the sock1, tcp is in TIME_WAIT, but the sock is ipv4, I do
> > > > not know why skc_v6_daddr and rh_reserved is not zero, maybe memory
> > > > out of bounds?
> > > > crash> p *((struct inet_timewait_sock*)0xFFFF9D6F1997D540)
> > > > $29 =3D {
> > > >   __tw_common =3D {
> > > >     {
> > > >       skc_addrpair =3D 388621010873919680,
> > > >       {
> > > >         skc_daddr =3D 426027200,
> > > >         skc_rcv_saddr =3D 90482880
> > > >       }
> > > >     },
> > > >     {
> > > >       skc_hash =3D 884720419,
> > > >       skc_u16hashes =3D {49955, 13499}
> > > >     },
> > > >     {
> > > >       skc_portpair =3D 156018620,
> > > >       {
> > > >         skc_dport =3D 42940,
> > > >         skc_num =3D 2380
> > > >       }
> > > >     },
> > > >     skc_family =3D 2,
> > > >     skc_state =3D 6 '\006',
> > > >     skc_reuse =3D 1 '\001',
> > > >     skc_reuseport =3D 0 '\000',
> > > >     skc_ipv6only =3D 0 '\000',
> > > >     skc_net_refcnt =3D 0 '\000',
> > > >     skc_bound_dev_if =3D 0,
> > > >     {
> > > >       skc_bind_node =3D {
> > > >         next =3D 0xffff9d8993851448,
> > > >         pprev =3D 0xffff9d89c3510458
> > > >       },
> > > >       skc_portaddr_node =3D {
> > > >         next =3D 0xffff9d8993851448,
> > > >         pprev =3D 0xffff9d89c3510458
> > > >       }
> > > >     },
> > > >     skc_prot =3D 0xffffffff9c7a9840,
> > > >     skc_net =3D {
> > > >       net =3D 0xffffffff9c7951c0
> > > >     },
> > > >     skc_v6_daddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D "$P=EE=A4=86\325\001\354M\213D\021p\323\337\n"=
,
> > > >         u6_addr16 =3D {20516, 42222, 54662, 60417, 35661, 4420, 541=
28, 2783},
> > > >         u6_addr32 =3D {2767081508, 3959543174, 289704781, 182440816=
}
> > > >       }
> > > >     },
> > > >     skc_v6_rcv_saddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D "=CB=B2\231=C2=AA\212*pzf\212\277\325\065=D8=
=84",
> > > >         u6_addr16 =3D {45771, 49817, 35498, 28714, 26234, 49034, 13=
781, 34008},
> > > >         u6_addr32 =3D {3264852683, 1881836202, 3213518458, 22287620=
69}
> > > >       }
> > > >     },
> > > >     skc_cookie =3D {
> > > >       counter =3D 0
> > > >     },
> > > >     {
> > > >       skc_flags =3D 18446744072039782272,
> > > >       skc_listener =3D 0xffffffff9c795780,
> > > >       skc_tw_dr =3D 0xffffffff9c795780
> > > >     },
> > > >     skc_dontcopy_begin =3D 0xffff9d6f1997d5a8,
> > > >     {
> > > >       skc_node =3D {
> > > >         next =3D 0x78647,
> > > >         pprev =3D 0xffffb341cddea918
> > > >       },
> > > >       skc_nulls_node =3D {
> > > >         next =3D 0x78647,
> > > >         pprev =3D 0xffffb341cddea918
> > > >       }
> > > >     },
> > > >     skc_tx_queue_mapping =3D 51317,
> > > >     skc_rx_queue_mapping =3D 9071,
> > > >     {
> > > >       skc_incoming_cpu =3D -720721118,
> > > >       skc_rcv_wnd =3D 3574246178,
> > > >       skc_tw_rcv_nxt =3D 3574246178
> > > >     },
> > > >     skc_refcnt =3D {
> > > >       refs =3D {
> > > >         counter =3D 3
> > > >       }
> > > >     },
> > > >     skc_dontcopy_end =3D 0xffff9d6f1997d5c4,
> > > >     {
> > > >       skc_rxhash =3D 2663156681,
> > > >       skc_window_clamp =3D 2663156681,
> > > >       skc_tw_snd_nxt =3D 2663156681
> > > >     }
> > > >   },
> > > >   tw_mark =3D 0,
> > > >   tw_substate =3D 6 '\006',
> > > >   tw_rcv_wscale =3D 10 '\n',
> > > >   tw_sport =3D 19465,
> > > >   tw_kill =3D 0,
> > > >   tw_transparent =3D 0,
> > > >   tw_flowlabel =3D 201048,
> > > >   tw_pad =3D 1,
> > > >   tw_tos =3D 0,
> > > >   tw_timer =3D {
> > > >     entry =3D {
> > > >       next =3D 0xffff9d6f1997d4c8,
> > > >       pprev =3D 0xffff9d6f1997c6f8
> > > >     },
> > > >     expires =3D 52813074277,
> > > >     function =3D 0xffffffff9bb67ba0,
> > > >     flags =3D 1313865770,
> > > >     rh_reserved1 =3D 14775289730400096190,
> > > >     rh_reserved2 =3D 10703603942626563734,
> > > >     rh_reserved3 =3D 17306812468345150807,
> > > >     rh_reserved4 =3D 9531906593543422642
> > > >   },
> > > >   tw_tb =3D 0xffff9d897232a500
> > > > }
> > > >
> > > > vmcore3' info:
> > > > 1. print the skbcrash> p *(struct tcphdr *)(((struct
> > > > sk_buff*)0xffffa039e93aaf00)->head + ((struct
> > > > sk_buff*)0xffffa039e93aaf00)->transport_header)
> > > > $6 =3D {
> > > >   source =3D 9269,
> > > >   dest =3D 47873,
> > > >   seq =3D 147768854,
> > > >   ack_seq =3D 1282978926,
> > > >   res1 =3D 0,
> > > >   doff =3D 5,
> > > >   fin =3D 0,
> > > >   syn =3D 0,
> > > >   rst =3D 0,
> > > >   psh =3D 0,
> > > >   ack =3D 1,
> > > >   urg =3D 0,
> > > >   ece =3D 0,
> > > >   cwr =3D 0,
> > > >   window =3D 47146,
> > > >   check =3D 55446,
> > > >   urg_ptr =3D 0
> > > > }
> > > > 2. print the sock1, tcp is in TIME_WAIT
> > > > crash> p *((struct inet_timewait_sock*)0xFFFFA0444BAADBA0)
> > > > $7 =3D {
> > > >   __tw_common =3D {
> > > >     {
> > > >       skc_addrpair =3D 2262118455826491584,
> > > >       {
> > > >         skc_daddr =3D 392472768,
> > > >         skc_rcv_saddr =3D 526690496
> > > >       }
> > > >     },
> > > >     {
> > > >       skc_hash =3D 382525308,
> > > >       skc_u16hashes =3D {57212, 5836}
> > > >     },
> > > >     {
> > > >       skc_portpair =3D 1169509385,
> > > >       {
> > > >         skc_dport =3D 19465,
> > > >         skc_num =3D 17845
> > > >       }
> > > >     },
> > > >     skc_family =3D 2,
> > > >     skc_state =3D 6 '\006',
> > > >     skc_reuse =3D 0 '\000',
> > > >     skc_reuseport =3D 0 '\000',
> > > >     skc_ipv6only =3D 0 '\000',
> > > >     skc_net_refcnt =3D 0 '\000',
> > > >     skc_bound_dev_if =3D 0,
> > > >     {
> > > >       skc_bind_node =3D {
> > > >         next =3D 0x0,
> > > >         pprev =3D 0xffffa0528fefba98
> > > >       },
> > > >       skc_portaddr_node =3D {
> > > >         next =3D 0x0,
> > > >         pprev =3D 0xffffa0528fefba98
> > > >       }
> > > >     },
> > > >     skc_prot =3D 0xffffffffa33a9840,
> > > >     skc_net =3D {
> > > >       net =3D 0xffffffffa33951c0
> > > >     },
> > > >     skc_v6_daddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D
> > > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > > >         u6_addr32 =3D {0, 0, 0, 0}
> > > >       }
> > > >     },
> > > >     skc_v6_rcv_saddr =3D {
> > > >       in6_u =3D {
> > > >         u6_addr8 =3D
> > > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > > >         u6_addr32 =3D {0, 0, 0, 0}
> > > >       }
> > > >     },
> > > >     skc_cookie =3D {
> > > >       counter =3D 20818915981
> > > >     },
> > > >     {
> > > >       skc_flags =3D 18446744072153028480,
> > > >       skc_listener =3D 0xffffffffa3395780,
> > > >       skc_tw_dr =3D 0xffffffffa3395780
> > > >     },
> > > >     skc_dontcopy_begin =3D 0xffffa0444baadc08,
> > > >     {
> > > >       skc_node =3D {
> > > >         next =3D 0x9bef9,
> > > >         pprev =3D 0xffffb36fcde60be0
> > > >       },
> > > >       skc_nulls_node =3D {
> > > >         next =3D 0x9bef9,
> > > >         pprev =3D 0xffffb36fcde60be0
> > > >       }
> > > >     },
> > > >     skc_tx_queue_mapping =3D 0,
> > > >     skc_rx_queue_mapping =3D 0,
> > > >     {
> > > >       skc_incoming_cpu =3D -2041214926,
> > > >       skc_rcv_wnd =3D 2253752370,
> > > >       skc_tw_rcv_nxt =3D 2253752370
> > > >     },
> > > >     skc_refcnt =3D {
> > > >       refs =3D {
> > > >         counter =3D 3
> > > >       }
> > > >     },
> > > >     skc_dontcopy_end =3D 0xffffa0444baadc24,
> > > >     {
> > > >       skc_rxhash =3D 653578381,
> > > >       skc_window_clamp =3D 653578381,
> > > >       skc_tw_snd_nxt =3D 653578381
> > > >     }
> > > >   },
> > > >   tw_mark =3D 0,
> > > >   tw_substate =3D 6 '\006',
> > > >   tw_rcv_wscale =3D 10 '\n',
> > > >   tw_sport =3D 46405,
> > > >   tw_kill =3D 0,
> > > >   tw_transparent =3D 0,
> > > >   tw_flowlabel =3D 0,
> > > >   tw_pad =3D 0,
> > > >   tw_tos =3D 0,
> > > >   tw_timer =3D {
> > > >     entry =3D {
> > > >       next =3D 0xffffa0444baac808,
> > > >       pprev =3D 0xffffa0388b5477f8
> > > >     },
> > > >     expires =3D 33384532933,
> > > >     function =3D 0xffffffffa2767ba0,
> > > >     flags =3D 1313865761,
> > > >     rh_reserved1 =3D 0,
> > > >     rh_reserved2 =3D 0,
> > > >     rh_reserved3 =3D 0,
> > > >     rh_reserved4 =3D 0
> > > >   },
> > > >   tw_tb =3D 0xffffa05cc8322d40
> > > > }
