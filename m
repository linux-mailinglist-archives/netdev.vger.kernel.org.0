Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49D36F10F6
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 06:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345238AbjD1ETc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 00:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjD1ETb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 00:19:31 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD402736
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:19:29 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-316d901b2ecso545165ab.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682655569; x=1685247569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PInjEZunl2fGYCH0IGrVQdaiDv0nfyEUcHVtz2u9AY=;
        b=oHUWOTP1pjlYlg8wtxXE/JvjsvRsguy0KZVGhidCefz6JoTfJegGNMHZRhociDuQBs
         jDwZKRW59xb2EpXoRo/gq3QIQL4Lv1WmLJhGJsgwaBK6yTqE88nDTg8TNeaBuoFPUa4z
         zxRlwQHW78Rzze2j/LoFGVWQGA/Go0RIusRsVzTlobX/WvuxslKnYUIWWkCkruqS0aft
         CvTvVdeVYco7N6CT0E6shjrAvz7TRKUXhU5cDl0UU8vZEWHZEUxyOvr7OT69PqUhpNye
         RW8jvQt7j9rSz9P3sDL/meUXrxYr7sZ00mtb1AE2aZG5f/9K0MDFeXH8lk3x3rRzEod/
         RZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682655569; x=1685247569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6PInjEZunl2fGYCH0IGrVQdaiDv0nfyEUcHVtz2u9AY=;
        b=D2xqj93LuQfDg1xVbaViWAmOmme9e2enMLlhHUjpDLxvQqeAfirlfsBpNjLwyNy1qK
         sIAm9roNnnI9lgdihWNb0JFIjDqQd9mUdVvHDV7S6KY1BOC40Vap30IP2x7N6eHd/W+w
         U4keM7alVYtj7ckM2JM8jWZcYxp+Vku8DshiXCirEijTK2fOXxouBW/WCyKysdkSh/Ak
         vMjpsb/4vaWKvgFSGrqLFDEXRtXu0kUC8G7R4b2b8ZAPO+UWmsdsHNvzKiTqGITXdfYF
         Yqt4Xpzmgn8YAU17neMEm/TAnWXJKwOdN4UqumviVvcvSR0LWiKiNNHyCfSoLD201fhW
         v2hQ==
X-Gm-Message-State: AC+VfDyANJS3mSMLuy8xnpg6Ivv8lrAO9pUv0Oy7Jnf38RTQZjTDiHx7
        RtyfdBKiP8od0YHzrjgeg7FdJjB0sBxna3x5yEezPA==
X-Google-Smtp-Source: ACHHUZ6+89nQmz+6T3JhZhAn5R95RBzzhMs5kIm7GUcR6oeXd0fNUm/9CxayWQRKuCv17NtuIeIcFBS6+k1v2q+8lQQ=
X-Received: by 2002:a05:6e02:1a02:b0:32b:1332:3d08 with SMTP id
 s2-20020a056e021a0200b0032b13323d08mr194338ild.0.1682655568688; Thu, 27 Apr
 2023 21:19:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230427192404.315287-1-edumazet@google.com> <0fa1d0a7-172e-12ca-99c5-d4cf25f2bfef@kernel.org>
 <644ae750da711_26f41f294eb@willemb.c.googlers.com.notmuch> <CADvbK_eX0t9KGuhdERweue3BkefVtzZx-ZQBVhfe8jb1aO6eZw@mail.gmail.com>
In-Reply-To: <CADvbK_eX0t9KGuhdERweue3BkefVtzZx-ZQBVhfe8jb1aO6eZw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 28 Apr 2023 06:19:16 +0200
Message-ID: <CANn89i+Q4=Jk_FWY=Y7sgkJ=ezRi659FfCjffkEKiUhcRUpsug@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix skb_copy_ubufs() vs BIG TCP
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Willem de Bruijn <willemb@google.com>,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 2:40=E2=80=AFAM Xin Long <lucien.xin@gmail.com> wro=
te:
>
>
>
> On Thu, Apr 27, 2023 at 5:21=E2=80=AFPM Willem de Bruijn <willemdebruijn.=
kernel@gmail.com> wrote:
>>
>> David Ahern wrote:
>> > On 4/27/23 1:24 PM, Eric Dumazet wrote:
>> > > David Ahern reported crashes in skb_copy_ubufs() caused by TCP tx ze=
rocopy
>> > > using hugepages, and skb length bigger than ~68 KB.
>> > >
>> > > skb_copy_ubufs() assumed it could copy all payload using up to
>> > > MAX_SKB_FRAGS order-0 pages.
>> > >
>> > > This assumption broke when BIG TCP was able to put up to 512 KB per =
skb.
>> >
>> > Just an FYI - the problem was triggered at 128kB.
>> >
>> > >
>> > > We did not hit this bug at Google because we use CONFIG_MAX_SKB_FRAG=
S=3D45
>> > > and limit gso_max_size to 180000.
>> > >
>> > > A solution is to use higher order pages if needed.
>> > >
>> > > Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
>> > > Reported-by: David Ahern <dsahern@kernel.org>
>> > > Link: https://lore.kernel.org/netdev/c70000f6-baa4-4a05-46d0-4b3e0dc=
1ccc8@gmail.com/T/
>> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
>> > > Cc: Xin Long <lucien.xin@gmail.com>
>> > > Cc: Willem de Bruijn <willemb@google.com>
>> > > Cc: Coco Li <lixiaoyan@google.com>
>> > > ---
>> > >  net/core/skbuff.c | 20 ++++++++++++++------
>> > >  1 file changed, 14 insertions(+), 6 deletions(-)
>> > >
>> >
>> >
>> > Reviewed-by: David Ahern <dsahern@kernel.org>
>> > Tested-by: David Ahern <dsahern@kernel.org>
>>
>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>
>
> I just ran David's test scripts in a metal machine:
>
> There seem memleak with this patch, and the performance is impaired too:

Oops, it seems I forgot __GFP_COMP

I will test the following on top of V1

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 891ecca40b29af1e15a89745f7fc630b19ea0202..26a586007d8b1ae39ab7a09eecf=
8575e04dadfeb
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1777,7 +1777,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mas=
k)

        new_frags =3D (__skb_pagelen(skb) + psize - 1) >> (PAGE_SHIFT + ord=
er);
        for (i =3D 0; i < new_frags; i++) {
-               page =3D alloc_pages(gfp_mask, order);
+               page =3D alloc_pages(gfp_mask | __GFP_COMP, order);
                if (!page) {
                        while (head) {
                                struct page *next =3D (struct page
*)page_private(head);



>
> # free -h
>               total        used        free      shared  buff/cache   ava=
ilable
> Mem:           31Gi       999Mi        30Gi        12Mi       303Mi      =
  30Gi
>
> 1 =3D>
> # ./src/iperf3 -c 172.16.253.2 --zc_api
> with zerocopy
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  23.0 GBytes  19.8 Gbits/sec   18             sen=
der
> [  5]   0.00-10.00  sec  23.0 GBytes  19.8 Gbits/sec                  rec=
eiver
>
> # free -h
>               total        used        free      shared  buff/cache   ava=
ilable
> Mem:           31Gi        12Gi        18Gi        12Mi       277Mi      =
  18Gi
>
> 2 =3D>
> # ./src/iperf3 -c 172.16.253.2 --zc_api
> with zerocopy
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  8.50 GBytes  7.30 Gbits/sec  14986             s=
ender
> [  5]   0.00-10.00  sec  8.50 GBytes  7.30 Gbits/sec                  rec=
eiver
>
> # free -h
>               total        used        free      shared  buff/cache   ava=
ilable
> Mem:           31Gi        16Gi        15Gi       5.0Mi       216Mi      =
  14Gi
>
> 3 =3D>
> # ./src/iperf3 -c 172.16.253.2 --zc_api
> with zerocopy
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.03  sec  8.19 GBytes  7.02 Gbits/sec  92410             s=
ender
> [  5]   0.00-10.03  sec  8.19 GBytes  7.02 Gbits/sec                  rec=
eiver
>
> # free -h
>               total        used        free      shared  buff/cache   ava=
ilable
> Mem:           31Gi        16Gi        15Gi       4.0Mi        94Mi      =
  14Gi
>
>
> I could also see some call trace:
>
> [  271.416989] warn_alloc: 640 callbacks suppressed
> [  271.417006] lt-iperf3: page allocation failure: order:1, mode:0x820(GF=
P_ATOMIC), nodemask=3D(null),cpuset=3D/,mems_allowed=3D0-1

Seems orthogonal to the patch, right ?

I have not changed gfp flags, so a memory allocation error triggers
this trace, no matter the order of page allocations.

We might add GFP_NOWARN to silence this.

> [  271.432684] CPU: 1 PID: 2218 Comm: lt-iperf3 Tainted: G S             =
    6.3.0.net0 #10
> [  271.440783] Hardware name: Supermicro X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F=
/iTF/iF, BIOS 3.2  06/04/2015
> [  271.449831] Call Trace:
> [  271.452276]  <IRQ>
> [  271.454286]  dump_stack_lvl+0x36/0x50
> [  271.457953]  warn_alloc+0x11b/0x190
> [  271.461445]  __alloc_pages_slowpath.constprop.119+0xcb9/0xd40
> [  271.467192]  __alloc_pages+0x32d/0x340
> [  271.470944]  skb_copy_ubufs+0x11b/0x630
> [  271.474781]  ? ip_protocol_deliver_rcu+0x40/0x2d0
> [  271.479488]  __netif_receive_skb_core+0xcb0/0x1060
> [  271.484280]  ? ip_local_deliver+0x6e/0x120
> [  271.488371]  ? ip_rcv_finish_core.isra.22+0x438/0x480
> [  271.493424]  ? ip_rcv+0x53/0x100
> [  271.496657]  __netif_receive_skb_one_core+0x3c/0xa0
> [  271.501537]  process_backlog+0xb7/0x160
> [  271.505375]  __napi_poll+0x2b/0x1b0
> [  271.508860]  net_rx_action+0x25a/0x340
> [  271.512612]  ? __note_gp_changes+0x15f/0x170
> [  271.516884]  __do_softirq+0xb8/0x2a7
> [  271.520478]  do_softirq+0x5b/0x70
> [  271.523800]  </IRQ>
> [  271.525897]  <TASK>
> [  271.527995]  __local_bh_enable_ip+0x5f/0x70
> [  271.532174]  __dev_queue_xmit+0x34c/0xcc0
> [  271.536186]  ? eth_header+0x2a/0xd0
> [  271.539678]  ip_finish_output2+0x183/0x530
> [  271.543771]  ip_output+0x75/0x110
> [  271.547089]  ? __pfx_ip_finish_output+0x10/0x10
> [  271.551620]  __ip_queue_xmit+0x175/0x410
> [  271.555546]  __tcp_transmit_skb+0xa91/0xbf0
> [  271.559724]  ? kmalloc_reserve+0x8e/0xf0
> [  271.563652]  tcp_write_xmit+0x229/0x12c0
> [  271.567578]  __tcp_push_pending_frames+0x36/0x100
> [  271.572282]  tcp_sendmsg_locked+0x48c/0xc80
> [  271.576474]  ? sock_has_perm+0x7c/0xa0
> [  271.580223]  tcp_sendmsg+0x2b/0x40
> [  271.583629]  sock_sendmsg+0x8f/0xa0
> [  271.587120]  ? sockfd_lookup_light+0x12/0x70
> [  271.591392]  __sys_sendto+0xfe/0x170
> [  271.594964]  ? _copy_to_user+0x26/0x40
> [  271.598716]  ? poll_select_finish+0x123/0x220
> [  271.603075]  ? kern_select+0xc4/0x110
> [  271.606734]  __x64_sys_sendto+0x28/0x30
> [  271.610574]  do_syscall_64+0x3e/0x90
> [  271.614153]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  271.619205] RIP: 0033:0x7ff965530871
> [  271.622784] Code: 00 00 00 00 0f 1f 44 00 00 f3 0f 1e fa 48 8d 05 b5 4=
e 29 00 41 89 ca 8b 00 85 c0 75 1c 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <=
48> 3d 00 f0 ff ff 77 67 c3 66 0f 1f 44 00 00 41 56 41 89 ce 41 55
> [  271.641521] RSP: 002b:00007fffcde17878 EFLAGS: 00000246 ORIG_RAX: 0000=
00000000002c
> [  271.649088] RAX: ffffffffffffffda RBX: 0000000000fde620 RCX: 00007ff96=
5530871
> [  271.656211] RDX: 0000000000020000 RSI: 00007ff965200000 RDI: 000000000=
0000005
> [  271.663336] RBP: 0000000000000005 R08: 0000000000000000 R09: 000000000=
0000000
> [  271.670474] R10: 0000000004000000 R11: 0000000000000246 R12: 000000000=
0000000
> [  271.677602] R13: 0000000000000009 R14: 0000000000000000 R15: 000000000=
0fdd2a0
> [  271.684727]  </TASK>
> [  271.686921] Mem-Info:
> [  271.689211] active_anon:319 inactive_anon:23067 isolated_anon:0
> [  271.689211]  active_file:22074 inactive_file:21543 isolated_file:0
> [  271.689211]  unevictable:0 dirty:0 writeback:0
> [  271.689211]  slab_reclaimable:10462 slab_unreclaimable:40073
> [  271.689211]  mapped:14400 shmem:1348 pagetables:2320
> [  271.689211]  sec_pagetables:0 bounce:0
> [  271.689211]  kernel_misc_reclaimable:0
> [  271.689211]  free:3955680 free_pcp:3032 free_cma:0
>
>
> Just as a comparison:
> With no zc_api:
> # ./src/iperf3 -c 172.16.253.2
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  50.0 GBytes  42.9 Gbits/sec    0             sen=
der
>
> With my improper patch:

Your patch is not what we want, as it would involve very high-order
allocation, bound to fail ?

Thanks.


> # ./src/iperf3 -c 172.16.253.2 --zc_api
> with zerocopy
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  31.8 GBytes  27.3 Gbits/sec   40             sen=
der
>
> After running a couple of times, both have no memleak and call trace foun=
d.
>
> Thanks.
