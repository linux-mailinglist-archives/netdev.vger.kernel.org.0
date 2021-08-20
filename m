Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8D83F369A
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 00:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhHTWpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 18:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHTWo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 18:44:59 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD62C061575;
        Fri, 20 Aug 2021 15:44:20 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ia27so826381ejc.10;
        Fri, 20 Aug 2021 15:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8xxy+rb/0UXRGn9LhNMBRVQ4TRxH5r6ohNvoniNZoSE=;
        b=HupoTaphiqd22RZXV507AeEotp4JF/6cRTEQkkboKwfZR7q3e7xGG/5WnrMNY8UtGn
         m4kABm1tej6qClTYkD98kN2iNiJoYG61fsH4VcWJulJjY0DXsym/040rRinV4viqm6jV
         JO0tWawkA49OnMt8ItqW8A8co2DNgpFuMfDZIuMLtN3uNq3T0XnUxbZwDGHqHrrN/sxF
         GoHe1Tfs6Xg5B5VaNQEJePdHC+9t1svKiXS/EOC8ndQhhAtNLvGDE0AalbyxUersGmbT
         qdxcWfs5Sxxw9vvReGuxlekBJeQK+C5ciL0YKgrpRB0yjUVpHUR5KVL+hYoO6SWoRnd0
         isWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8xxy+rb/0UXRGn9LhNMBRVQ4TRxH5r6ohNvoniNZoSE=;
        b=fjOBKvBzwxmgkjiRT7+gZRUyMI/Td44pyIvf5XknliieT2YJRamy3fI+MCFmmT+TuC
         xAVITrjEChC8xhVDQuNAEkbQB3290YLgm97hKk9ACEHXno5m01n5HjakUn3bpEzijD34
         c24xBVs7rq5jfs31hyglGpDHAbZa+lpJ/gfgew80z0O7okD/jE5AJ3xlNO4+mr5qqRp3
         YU3XJPhlfIGcyRJr5j0TIRhbWOom4Te2pe8TrlXrOgdSDceTZ53cY6wP6kZ7iOI8oLeV
         TLBbuJln3xOOqkUstt32kUH/DSFd5uQ4cWD8tBkMinwXRwNEyGCBBRKmTQxpXhdmIalS
         iILA==
X-Gm-Message-State: AOAM531EG5dtP/tHKiiXqCSygzQvq8myX71mAabjCV2IhQaDjCKW5uEt
        WS7ImSjL7t2XzCz9PwomB6rDH6vREq3SGako4Uo=
X-Google-Smtp-Source: ABdhPJxaHruY0vD4Q4UdFQ/EOWd216KAiiDnRzbIpwUGchl17sVPD8y/k38SAMZ0Tjhgl2JtTPlvJrAAL5z3jVeWOaU=
X-Received: by 2002:a17:907:7718:: with SMTP id kw24mr24681485ejc.316.1629499458837;
 Fri, 20 Aug 2021 15:44:18 -0700 (PDT)
MIME-Version: 1.0
References: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
 <cover.1628235065.git.vvs@virtuozzo.com> <77f3e358-c75e-b0bf-ca87-6f8297f5593c@virtuozzo.com>
 <CALMXkpaay1y=0tkbnskr4gf-HTMjJJsVryh4Prnej_ws-hJvBg@mail.gmail.com>
In-Reply-To: <CALMXkpaay1y=0tkbnskr4gf-HTMjJJsVryh4Prnej_ws-hJvBg@mail.gmail.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Fri, 20 Aug 2021 15:44:08 -0700
Message-ID: <CALMXkpa4RqwssO2QNKMjk=f8pGWDMtj4gpQbAYWbGDRfN4J6DQ@mail.gmail.com>
Subject: Re: [PATCH NET v4 3/7] ipv6: use skb_expand_head in ip6_xmit
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(resend without html - thanks gmail web-interface...)

On Fri, Aug 20, 2021 at 3:41 PM Christoph Paasch
<christoph.paasch@gmail.com> wrote:
>
> Hello,
>
> On Fri, Aug 6, 2021 at 1:18 AM Vasily Averin <vvs@virtuozzo.com> wrote:
> >
> > Unlike skb_realloc_headroom, new helper skb_expand_head
> > does not allocate a new skb if possible.
> >
> > Additionally this patch replaces commonly used dereferencing with varia=
bles.
> >
> > Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> > ---
> >  net/ipv6/ip6_output.c | 27 +++++++++++----------------
> >  1 file changed, 11 insertions(+), 16 deletions(-)
> >
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index 7d2ec25..f91d13a 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
> > @@ -249,6 +249,8 @@ int ip6_xmit(const struct sock *sk, struct sk_buff =
*skb, struct flowi6 *fl6,
> >         const struct ipv6_pinfo *np =3D inet6_sk(sk);
> >         struct in6_addr *first_hop =3D &fl6->daddr;
> >         struct dst_entry *dst =3D skb_dst(skb);
> > +       struct net_device *dev =3D dst->dev;
> > +       struct inet6_dev *idev =3D ip6_dst_idev(dst);
> >         unsigned int head_room;
> >         struct ipv6hdr *hdr;
> >         u8  proto =3D fl6->flowi6_proto;
> > @@ -256,22 +258,16 @@ int ip6_xmit(const struct sock *sk, struct sk_buf=
f *skb, struct flowi6 *fl6,
> >         int hlimit =3D -1;
> >         u32 mtu;
> >
> > -       head_room =3D sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dst->d=
ev);
> > +       head_room =3D sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dev);
> >         if (opt)
> >                 head_room +=3D opt->opt_nflen + opt->opt_flen;
> >
> > -       if (unlikely(skb_headroom(skb) < head_room)) {
> > -               struct sk_buff *skb2 =3D skb_realloc_headroom(skb, head=
_room);
> > -               if (!skb2) {
> > -                       IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
> > -                                     IPSTATS_MIB_OUTDISCARDS);
> > -                       kfree_skb(skb);
> > +       if (unlikely(head_room > skb_headroom(skb))) {
> > +               skb =3D skb_expand_head(skb, head_room);
> > +               if (!skb) {
> > +                       IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARD=
S);
>
>
> this change introduces a panic on my syzkaller instance:
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1832 at net/core/skbuff.c:5412 skb_try_coalesce+0x10=
19/0x12c0 net/core/skbuff.c:5412
> Modules linked in:
> CPU: 0 PID: 1832 Comm: syz-executor.0 Not tainted 5.14.0-rc4ab492b0cda378=
661ae004e2fd66cfd1be474438d #102
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-=
gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> RIP: 0010:skb_try_coalesce+0x1019/0x12c0 net/core/skbuff.c:5412
> Code: 24 20 bf 01 00 00 00 8b 40 20 44 0f b7 f0 44 89 f6 e8 ab 41 c0 fe 4=
1 83 ee 01 0f 85 01 f3 ff ff e9 42 f6 ff ff e8 07 3c c0 fe <0f> 0b e9 7b f9=
 ff ff e8 fb 3b c0 fe 48 8b 44 24 40 48 8d 70 ff 4c
> RSP: 0018:ffffc90002d97530 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000e00 RCX: 0000000000000000
> RDX: ffff88810a27bc00 RSI: ffffffff8276b6c9 RDI: 0000000000000003
> RBP: ffff88810a17f9e0 R08: 0000000000000e00 R09: 0000000000000000
> R10: ffffffff8276b042 R11: 0000000000000000 R12: ffff88810a17f760
> R13: ffff888108fc6ac0 R14: 0000000000001000 R15: ffff88810a17f7d6
> FS:  00007f6be8546700(0000) GS:ffff88811b400000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010a4f0005 CR4: 0000000000170ef0
> Call Trace:
>  tcp_try_coalesce net/ipv4/tcp_input.c:4642 [inline]
>  tcp_try_coalesce+0x312/0x870 net/ipv4/tcp_input.c:4621
>  tcp_queue_rcv+0x73/0x670 net/ipv4/tcp_input.c:4905
>  tcp_data_queue+0x11e5/0x4af0 net/ipv4/tcp_input.c:5016
>  tcp_rcv_established+0x83a/0x1d30 net/ipv4/tcp_input.c:5928
>  tcp_v6_do_rcv+0x438/0x1380 net/ipv6/tcp_ipv6.c:1517
>  sk_backlog_rcv include/net/sock.h:1024 [inline]
>  __release_sock+0x1ad/0x310 net/core/sock.c:2669
>  release_sock+0x54/0x1a0 net/core/sock.c:3193
>  tcp_sendmsg+0x36/0x40 net/ipv4/tcp.c:1462
>  inet6_sendmsg+0xb5/0x140 net/ipv6/af_inet6.c:646
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg net/socket.c:724 [inline]
>  ____sys_sendmsg+0x3b5/0x970 net/socket.c:2403
>  ___sys_sendmsg+0xff/0x170 net/socket.c:2457
>  __sys_sendmmsg+0x192/0x440 net/socket.c:2543
>  __do_sys_sendmmsg net/socket.c:2572 [inline]
>  __se_sys_sendmmsg net/socket.c:2569 [inline]
>  __x64_sys_sendmmsg+0x98/0x100 net/socket.c:2569
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f6be7e55469
> Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 8b 0d ff 49 2b 00 f7 d8 64 89 01 48
> RSP: 002b:00007f6be8545da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 0000000000000133 RCX: 00007f6be7e55469
> RDX: 0000000000000003 RSI: 00000000200008c0 RDI: 0000000000000003
> RBP: 0000000000000133 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000040044040 R11: 0000000000000246 R12: 000000000069bf8c
> R13: 00007ffe013f968f R14: 00007f6be8526000 R15: 0000000000000003
> ---[ end trace 60453d9d261151ca ]---
>
> (syzkaller-reproducer at the end of this email)
>
> AFAICS, this is because pskb_expand_head (called from skb_expand_head) is=
 not adjusting skb->truesize when skb->sk is set (which I guess is the case=
 in this particular scenario). I'm not sure what the proper fix would be th=
ough...
>
>
> Reproducer:
>
> # {Threaded:true Collide:true Repeat:true RepeatTimes:0 Procs:1 Slowdown:=
1 Sandbox:none Fault:false FaultCall:-1 FaultNth:0 Leak:false NetInjection:=
true NetDevices:true NetReset:true Cgroups:true BinfmtMisc:true CloseFDs:tr=
ue KCSAN:false DevlinkPCI:false USB:false VhciInjection:false Wifi:false IE=
EE802154:false Sysctl:true UseTmpDir:true HandleSegv:true Repro:false Trace=
:false}
> r0 =3D socket$inet6_tcp(0xa, 0x1, 0x0)
> bind$inet6(r0, &(0x7f0000000080)=3D{0xa, 0x4e22, 0x0, @loopback}, 0x1c)
> sendmmsg$inet6(r0, &(0x7f0000002940)=3D[{{&(0x7f00000000c0)=3D{0xa, 0x4e2=
2, 0x0, @empty}, 0x1c, 0x0}}], 0x36, 0x20000145)
> r1 =3D socket$inet6_icmp_raw(0xa, 0x3, 0x3a)
> r2 =3D socket$inet_tcp(0x2, 0x1, 0x0)
> ioctl$sock_SIOCGIFINDEX(r2, 0x8933, 0x0)
> setsockopt$inet6_mreq(r1, 0x29, 0x1b, 0x0, 0x0)
> sendmmsg$inet6(r0, &(0x7f00000008c0)=3D[{{0x0, 0x0, &(0x7f0000000240)=3D[=
{&(0x7f0000000040)=3D"11c2e854", 0x4}, {0x0}], 0x2}}, {{0x0, 0x0, &(0x7f000=
0000580)=3D[{0x0}, {&(0x7f0000001800)=3D"bcfad31884cb1c6226004dd6ed929a7fa3=
08da79249cdfcf5447732df714b21f9fa725d49453be964002a469aff676404855809cf7d7f=
8fad8ff26c30a9aa692c5ba1c3bf622d795da6efd5425e52f43e8a01e98fec8c4079d0f711b=
7b02666cc4046eed001f62377a14142ee1004708bc6b57ed028e4a0f8af459fa89ec7cd3098=
c32cbe69625cd654a3aca8814c9426a817da1b631828f40c0ba2227e8030aabba4eeaeea561=
7df6fbc54918905137032bb60cb86a7ebd4b8b1f8428085bfc5749a3a986dfca6f0e40b2cc3=
2121cdd53ab4815cdf32dca5d1ee64d0e11894d07ad78f5ee5e7701f4803c49d6fdf927a0c1=
03cf5ba9293e232ebd5661fb950f1cacef864673b79c7a180010889f0a8c9d69a97e3f6a88a=
9180fcc61631ffa42332f68a8ae78982b5e232decca2a4259a05e96c7fae309468a364798b7=
343354bdddfe1d81c3393556ced79b92f7c8f9455c1e4deb7cac7d81fdc3d72f201b711a253=
c2bf4df9f9bcb0ebe51edd3bb62a9440c0c88dc0b7ed6aaa2fdadd868845865cf6c40ba2122=
2123894323fdd0ae8f8fc896a1c4b77431655d77750578db7e6d01380a7b5f5326cd8dd0091=
ac0a5526b9d1e9318dbfd2ac7227b1779674167c23fa8c59fcc44ab0c117788aa6a1c2baa0f=
a314093cfa79474e26b09d305c4b20d8f20150feb861ab750f1dbd7c4081ede2b245c14f715=
2f46352db5b0e4a3e676d23a76ea6363f97a35b3df2ced972f9daec0a5f6f13d5093250a93b=
31f4fafb1fa783cd99504ba8ac5fbfb4af9ff108a891e3786964ae5f00bc52496db9cf162b0=
efaded2459a3c1c1fbc60182b62a430a8eef93c6673db2596256f2b85f41975a31908dfd27e=
ced4b169c99fbe79f59e61c8d3aef4e23f3bb665a0f25a09ce19a15f47734b817b1451f3241=
8b1d9d801c64339b4fa2147e794dec9909569abcabeb9785991e32eb9835da449617c9c0500=
00cf83fc6297e908d3708784a9c0599d3df55055123ef6037c5f8223acbeb0413610af57390=
4069b64057d73a95e76f53939d6a144b411d73b7ae09bddc8c28e2484e03f781cce9df821c7=
27facfd7d158a63f466d183e7be32c921176f574258d252bf2c15f1bcb6498ef252315a360c=
cd4ce7e5388d66462c51885a04211ed9ab097f66e31f6bb704902b74d6afd96f05b7a5de5ea=
a9d6ba4c700e7ad2e686b7241cf57358937e1b526f34d8522b761ca596b77e74ebae352ffbc=
9ee9d98b40ea1b1f7e24b3037d0630cd3ede29d4cd960fe0c17102c06e0a7f993b99f961384=
698dfd82c813cb862779d68fd8f6828a7c6e0bc8f9e3798ca7c3d5f287f8b63b65f6db8fa70=
6e8a378166486b8c8fadfa06a4f0a21e8d6dc8ed230c8b5cde27a48742700b43ba4dce5e3da=
897b2bf1fc5832d07ac3482a9834b30c0371f517b9f0ae0706a12b87dcb3555e08df00cc0a8=
3d7060c06edd7b8b8c6199398ee6bea33a4690e8f9455f54a6ef9d4b69d39c55a69d6fed3d7=
a376ceb51bd032b9b76a08ce48c5a2af8702922163a57835133e9968f8a1e4401479ec8a83a=
42f1c425840cdcd52483d8432c897ae75e8f68df55e5a5c8c16b4d071e92be22eb23f35d58c=
b86cc1b0c494e96723f5c50e441b81a7f1fca08faaefec8003fddb967381c542c5ac6c18cc7=
e4f4e61c8aae4ae90f157ae283a9fe8d02b9f52dc7bbf80e47cc6e3e2e6ee9008e8b82cb7ee=
672b11be1a3874aa63586fb242378f59251990cd8d944d8e46d84e76cfe9dbffe2562d29ed9=
4f5a314062fc8f496bdb38a426f2ab0525418625727f329ca1cb8cd30ae9013829136c02589=
2c2614d1fa0edf019c8e7f3a9ef50ec0483f3d70daec362b603a89b6a7049310b4776e1bb88=
4f8d44a74b2a3da056e3ba8f3425f7a4628f3f140aa12fcd779ea01e22eff2c670759971ed8=
e11570813835401484537c0075e897863ae690c420b1c4d90ea4e90d84b220511bbba8e2186=
9610e4ff8d2130b09a40a0cf49715275a01ecc438d6fcdfcb189d602d964a1a39ee375067d8=
2c63dc409fab9715ee86cbbf5cdc9b906b66b40e4d2180cd1d03229bd42b2ea6359d8a127d6=
156d19cc638e4811b55871c39b370121bc0da9b29d3be162572f672f3f1cb9aac5dba4cb9f5=
7062a27b95f5db96b7ea16beb7df8d5642ca2695aa0dccec99bc1b4efbdbe4ceb7febca4b18=
46b1486ee11383ca9c802428a9a8ac308bfa106dd8a5c87cceb4e1a700626a7ceb074d5628a=
6be3a96ff59851f797e375f42c7c452d66232f076f5c0045d06f5ee1e39f48b1b4285e569e5=
74136de2d3412dc6f24e5e7024739f1fc5aa71c41e8eaa88c0094ca7ae5b96a20beaec44223=
d2df1cf650ef924b58e71f7ddf82b18a7d13d8eccfaea41e17ba7c65923d6dea3a7834113f4=
46eaac407c371dc80841a85a4aa0ef2f4d49a204f626ed1c4921d61c50f6bd938359e8fec4e=
7d03dd6edb0b29437e3e121b65852d5cda472a99a29de0a56db2aa6aca87a9d6bcf1bbe6783=
735b67807c42a399b0757390d872a26e73244df25b5a6870b2da91e45e5168f8993cf7ca209=
df04c49cfb6eed24cfc343864cfb997490ac5b0b39d2e3bfa453d54d36546cd034d542ba38f=
66fe87cd4f89d08ca059e721272648c550481d952a0a47fd15d8fbe4a23303978b813011dee=
f566317f71d9b18a7cb2283c44be2ed1a05ca9c3daf6c28f782f6c3593536d48253243a8995=
e8b9a30d83b7733bc166d4791bfd1555dcdf44c297ef726aaa47cbebdeae8a7288e20fae87b=
92fa44c78158501526afc5a7e0041b48c55881f9031d2ae4f482b8f44ce5297113bbd217d08=
1162b26811b4d08f0fb9d76d5f179e5af344f73d62742bf871920121e26796eb67d059b49f5=
850475e02723c9e84a5578d5610f1cb3b1055b6333d59df391dbf67f6660f2d3aaa9a601d44=
cec1bb4199b1130d373a5a53ca81e16c374400976b39967bc7310ba801a225e44da319744a1=
e7e2b2261dedcbb31dda7105de586baf881f88bc7e0069b42fb3ebae8fa63e39609a1f596ba=
219da2ef61d69976d3175e47769bc1ba2b3cd064db3ff4d7ed0d87ee7054aa7e111aae93592=
dd6203e11e87bcaf8c43cd803282d0d25ba9b043ea8cbe26f585643d504d6f4f66848c881c0=
66e9f10057e2c773b1e5abf2e56a4f07d35fc29f7fe98dc5fc26507406ca2901ebfae6e6871=
5f6ca4d73555dea5f6ec77661ab9cd7335276eda1f28606e8dbd9b04fe17f53ffc3bedab5d8=
00860f1a2c8bd4909f3b98cc7e7bda7a7e46deeff86c756e3b7d40067ca35f867bb5456ea61=
599e95916397f72404b2bac726dd5c1a5042eed92bd2988365405d17dde91c214c12263e976=
356d6131a2a5269cdfb1aefa6dc60b9f522ec2a619b2cc58baf8fadd52f43892d12d2749802=
3e18390db603a3fe5e2f3e14491c1aed2ddaf47e717decfa6877aeed9fea0c575223cb062ce=
ab83a20e99b49a0581e0fb25ba1eae88d5b229eb5320d888652acae4955c3bbe94de43fa994=
76c9058250847381ee4d85e079c190fadfa0776318ed00f7019a4010f2eb8777c7499456b87=
48991d4d4c6590cf903a237a81c0af16c4cec87ac49bc7787c2c05ea56501c9cddc2c4ba884=
ab26a51639e4b77fa5a2488ab842b8ef6d0fb1d3bea710ad1528a1e78a18e37b4a0ed803ba2=
9d9ddf1ca7e8bd56d1588dbb9e3995493959adaa334acd611ac8d266a3199b2ecb9958366d7=
85946722bc9507ab420d447dfadd0274a8e2a25d290c598d65145956c1c8542d07bc0a15efa=
0a9daed2f2fe71f60b4b657b34a3e897749a49bd85c2a0d915af6a38e8de62df1fcb4e991d0=
4ce4c43eef97c4b3e9de11d528eb9cb923115efc681d0a2a0a714ad923086961c07335e152e=
c83b65ddb43b8865984c36de76f19bdb6e96566b741fb1c755d012c5377b196bed875e9a08b=
b7d4fd3160fddc71b9bb55a7199183529cda7a3624077a77b3a2b0367845d23e42dbc4130dc=
ef4cc855556f833b94794b1a4d28d7503113ed4f8ec7b3578b418640d49b01e6a75b4569443=
77a8d892eab38037705e010e32cf7074784dd42f42a92d18c0c26eb4c23a12c1697215aaa41=
ca92dd59f9816168bc7c9275c256cc689c03809f40125a1c17063a7696ab30dc32d8dcddf8e=
4e2983a883f11d64b485310c71e5533399d928da94b4ce9a8178517477345bc26b6ba838dfc=
0b0d9f8542f93183f68e4660e17a8bc92dea290bb718f1d0e89e385ad8ac2f3cc9ad8dfa08e=
62501b3bd6597574f98bfa39b901daa1e8c56dcddf87d49cf4b1345ae352b1aa72ca62fdeb3=
9abcad462c4045fa1daaba17047d1b91bec23145d4090a7eca6f1510d88beab5a2625fdf773=
f16293b77eec703bdc13504550f8d74546b89ac056419fb12ded672a2cd4efee157689a704e=
b8511fab3c12d29e025184b6f329fe4b6226f187b0c009e1b5cfc249791a6c96bee7766276f=
7e90163f0c11f6c1d04a32e3128d1e3eb95e167f0bdf4b927b775d7fe01aa2174d43a8fb7b8=
ae4b5c1e6c7e7b7a6bc7f19a70f7ef107a6406e69cb60047aee0d3d0ed4b1a6605bc1eba9ea=
2664edf145d2422dcc47e26c6f000071a15cbd62c16983bf8a5fef08aeea48d6a477654aacd=
ada917efee28a79897a7b9280025a370d2ccbadd639c3314a7e3cc12298da71e2ca40833f1b=
88d44e6693049baee1b0789a619815aee3707703963e296be3171854411f874a01f1c6c9f9b=
b6e4932e13b791280aed0cca54c3dd77033a8c3836a0306e13dabfdfa96ddcb9fa1de806419=
c1eaac65d7b601417b011ce50fd6257ae97f883faacfc2ce7a5fec477793f2bfa24f51d542f=
7d5d4828e7efc455af4f4d4e60f72c6598b72751dc058169e5d13b14b91b5849463f688c10d=
9d4a8f566ee18620a4541dce68411d3746b8b4ef4f891c87cbc536e8e99b828c23732fb1484=
fd03e23bc0affde95d7c0c6fc0407d1990b55296c4e32f8c0387b965ee20482d9e666f3caa2=
167218d6a48305b37430835e839b62960fab96ec61e5b49c345fe8c07f7b71ba3b82bef5701=
de404461a1aaa01331913dc03e27ed36c7f14f0c82057f477b73e9ee20621a5c70df091a2da=
470db9602aa17f281a15f644a2a85534040dba67d2a6473503453e133098205fb53a3c20fda=
fa508a82e9c8d172b2eed24afb1c47890ace2eb48ee9e2bc2488e47bf18e69676b32087e7ab=
f3d1b918bd9ac24338d5ae54c0f2c95b0f969f44edac2b552b611ae2b415cfed467ec989e7a=
139a72b0d3c68e20dd307500bbd7f4e079f6c1486bdb31f648c50c1c4b58e6be618ac6257dd=
b2558af9f24be2ae415e8edc50197dda4a1178ea4de53bbd66e819173574fecaaa554018953=
8762f472bd562f1d87f64fc39008d4a3f85cd1b3f01508a42a3047976f6f1dcd4c1d9423499=
67dfd633a6e56de55a5e0f2ad68847e7f1e3a08813dc7483db90cf417e7388aab6e4806628e=
6b9ab980a12b9ca6b345845f043d9b31cfbba9a17517cb0d421e2db467e991c2584f625dd18=
84126261e3f455c4f44c15380d43dc7e3e8fc69086395d9535f094432115b3d1b643178aadc=
f0919d85c3faddbf631ddd50c322a3e489310de21ec2c3026721f9301a34acfe9d65326f7f7=
ad54b6ad6eaa978b739407105d2d4eb869fff3e2de7585a7fed747493bd65537120cac03e3b=
48458ddbdbc5ba3382b6040d4863f4d3fd783276e01a3a9a5f05067d1d101ec424e6fb179cf=
9bcad8f5536b63dd63248ee411ce4b79b70fa7e8a619714646ff2fd557", 0x1000}, {0x0}=
, {0x0}], 0x4}}, {{0x0, 0x0, 0x0}}], 0x3, 0x40044040)
> setsockopt$inet6_IPV6_HOPOPTS(r0, 0x29, 0x36, &(0x7f0000000640)=3D{0x0, 0=
x11, '\x00', [@calipso=3D{0x7, 0x40, {0x0, 0xe, 0xb, 0x101, [0x5, 0x4ebd, 0=
x5d, 0x3, 0x80, 0x7, 0x8]}}, @calipso=3D{0x7, 0x10, {0x0, 0x2, 0x6, 0x0, [0=
x0]}}, @calipso=3D{0x7, 0x28, {0x2, 0x8, 0x9, 0x6, [0x0, 0x80000001, 0x5d53=
, 0x9]}}, @calipso=3D{0x7, 0x8, {0x2, 0x0, 0x3, 0x5}}]}, 0x90)
>
>
>
> Christoph
>
