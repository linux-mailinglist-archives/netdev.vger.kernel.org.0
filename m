Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11306F090A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 18:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbjD0QDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 12:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243614AbjD0QDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 12:03:36 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B50910EF
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:03:33 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-316d901b2ecso456725ab.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682611412; x=1685203412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MIM9qOu3ph2UWWgWXSIl2+xFv4HBSStbDsRdrsnbtyw=;
        b=asDRxwhcFINudUe/zpm7FkVXa+BheR6+mAyPwYdkQbAoZAizVfPwdWrk1zjcnE6IZz
         XJFBQsDJtaBFSkbmue87tmHTsJmxCwe7LKWHtFgA3k8P/FV5+avhBWs65wH7i7+RGmLE
         Kct7vl9Up/a8zOmDK1+aqHcaXOeJJ0Puupf33sUKuBh9dALI/YdNsqfjNPybY728zLYc
         PdLaagzXGos0+KEFMZF4VN6xHqpAeT4auGsi9axaduasVb/HW1cSldT8oTPN7Wh2lZYu
         yc1hfiSlK7c8bdO1ugoUkakJt95EHDbUyKlZYD6bHu2t+efCSBX7k6nUXHG+rmOMQVDR
         DsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682611412; x=1685203412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MIM9qOu3ph2UWWgWXSIl2+xFv4HBSStbDsRdrsnbtyw=;
        b=jYJgoPHDtR49jMdQdC0KUQIWUUw45DGXWe8UQgL+jAA/+NjzHWZ6SuSJHt048tNtTM
         orDNSFbDmVY0wpi7P9IvDcjILQCHODjEIrUp8D6Jgo7IHcpvMH1Ml2yvXTeVLass056T
         Ky7o12AHG6Pfl5pMgmkVPMreJNMD1h63NqhCC6dWKmONfiU+STHMpHNlFpH8z/hassa1
         2rMwwA/24DRgMPnBBNa9RtbnrMY+pra2nbakLTgS+CTRe2/+xYTlDPeQssMIrXi531Ix
         Hj3Z4Td99ubS5NaEn0FthzKShIhdngaayhUD7R1vc+CgV52PGm71x0B67z4WKoI/CFw/
         Ht/Q==
X-Gm-Message-State: AC+VfDwwo+xWa/e9R073H6n1sZRLMzL+ri+k2Iv63pRJXUBsC+12uIXf
        Gh4MhXR4kclbn1X0ZLQnwdFJw17UNsrBMCcxC+MVLw==
X-Google-Smtp-Source: ACHHUZ6Cnd9YkpHzbk9RBaWEdLDLvDNTmDQ+JbR/9dAylhG2khmvrtqOS6gE1GbYo3Qo+0GAM7/qsBm8idkPloYyViM=
X-Received: by 2002:a05:6e02:1ca9:b0:325:d0d8:2ddb with SMTP id
 x9-20020a056e021ca900b00325d0d82ddbmr201108ill.15.1682611412229; Thu, 27 Apr
 2023 09:03:32 -0700 (PDT)
MIME-Version: 1.0
References: <5a2eae5c-9ad7-aca5-4927-665db946cfb2@gmail.com>
 <64499d0a996d1_23212b294b@willemb.c.googlers.com.notmuch> <c70000f6-baa4-4a05-46d0-4b3e0dc1ccc8@gmail.com>
 <71114ab1-fc2d-a3b3-cc15-68e848b6df46@gmail.com>
In-Reply-To: <71114ab1-fc2d-a3b3-cc15-68e848b6df46@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Apr 2023 18:03:20 +0200
Message-ID: <CANn89i+zyOgNV0JcCmwuqZOHJWq+F2a1jAvxggFjiPr75e0OnA@mail.gmail.com>
Subject: Re: kernel panics with Big TCP and Tx ZC with hugepages
To:     Eric Dumazet <erdnetdev@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
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

On Thu, Apr 27, 2023 at 5:32=E2=80=AFPM Eric Dumazet <erdnetdev@gmail.com> =
wrote:
>
>
> On 4/27/23 00:24, David Ahern wrote:
> > On 4/26/23 3:52 PM, Willem de Bruijn wrote:
> >> David Ahern wrote:
> >>> This has been on the back burner for too long now and with v6.3 relea=
sed
> >>> we should get it resolved before reports start rolling in. I am throw=
ing
> >>> this data dump out to the mailing list hoping someone else can provid=
e
> >>> more insights.
> >>>
> >>> Big TCP (both IPv6 and IPv4 versions are affected) can cause a variet=
y
> >>> of panics when combined with the Tx ZC API and buffers backed by
> >>> hugepages. I have seen this with mlx5, a driver under development and
> >>> veth, so it seems to be a problem with the core stack.
> >>>
> >>> A quick reproducer:
> >>>
> >>> #!/bin/bash
> >>> #
> >>> # make sure ip is from top of tree iproute2
> >>>
> >>> ip netns add peer
> >>> ip li add eth0 type veth peer eth1
> >>> ip li set eth0 mtu 3400 up
> >>> ip addr add dev eth0 172.16.253.1/24
> >>> ip addr add dev eth0 2001:db8:1::1/64
> >>>
> >>> ip li set eth1 netns peer mtu 3400 up
> >>> ip -netns peer addr add dev eth1 172.16.253.2/24
> >>> ip -netns peer addr add dev eth1 2001:db8:1::2/64
> >>>
> >>> ip netns exec peer iperf3 -s -D
> >>>
> >>> ip li set dev eth0 gso_ipv4_max_size $((510*1024)) gro_ipv4_max_size
> >>> $((510*1024)) gso_max_size $((510*1024)) gro_max_size  $((510*1024))
> >>>
> >>> ip -netns peer li set dev eth1 gso_ipv4_max_size $((510*1024))
> >>> gro_ipv4_max_size  $((510*1024)) gso_max_size $((510*1024)) gro_max_s=
ize
> >>>   $((510*1024))
> >>>
> >>> sysctl -w vm.nr_hugepages=3D2
> >>>
> >>> cat <<EOF
> >>> Run either:
> >>>
> >>>      iperf3 -c 172.16.253.2 --zc_api
> >>>      iperf3 -c 2001:db8:1::2 --zc_api
> >>>
> >>> where iperf3 is from https://github.com/dsahern/iperf mods-3.10
> >>> EOF
> >>>
> >>> iperf3 in my tree has support for buffers using hugepages when using =
the
> >>> Tx ZC API (--zc_api arg above).
> >>>
> >>> I have seen various backtraces based on platform and configuration, b=
ut
> >>> skb_release_data is typically in the path. This is a common one for t=
he
> >>> veth reproducer above (saw it with both v4 and v6):
> >>>
> >>> [   32.167294] general protection fault, probably for non-canonical
> >>> address 0xdd8672069ea377b2: 0000 [#1] PREEMPT SMP
> >>> [   32.167569] CPU: 5 PID: 635 Comm: iperf3 Not tainted 6.3.0+ #4
> >>> [   32.167742] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BI=
OS
> >>> 1.13.0-1ubuntu1.1 04/01/2014
> >>> [   32.168039] RIP: 0010:skb_release_data+0xf4/0x180
> >>> [   32.168208] Code: 7e 57 48 89 d8 48 c1 e0 04 4d 8b 64 05 30 41 f6 =
c4
> >>> 01 75 e1 41 80 7e 76 00 4d 89 e7 79 0c 4c 89 e7 e8 90 f
> >>> [   32.168869] RSP: 0018:ffffc900001a4eb0 EFLAGS: 00010202
> >>> [   32.169025] RAX: 00000000000001c0 RBX: 000000000000001c RCX:
> >>> 0000000000000000
> >>> [   32.169265] RDX: 0000000000000102 RSI: 000000000000068f RDI:
> >>> 00000000ffffffff
> >>> [   32.169475] RBP: ffffc900001a4ee0 R08: 0000000000000000 R09:
> >>> ffff88807fd77ec0
> >>> [   32.169708] R10: ffffea0000173430 R11: 0000000000000000 R12:
> >>> dd8672069ea377aa
> >>> [   32.169915] R13: ffff8880069cf100 R14: ffff888011910ae0 R15:
> >>> dd8672069ea377aa
> >>> [   32.170126] FS:  0000000001720880(0000) GS:ffff88807fd40000(0000)
> >>> knlGS:0000000000000000
> >>> [   32.170398] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [   32.170586] CR2: 00007f0f04400000 CR3: 0000000004caa000 CR4:
> >>> 0000000000750ee0
> >>> [   32.170796] PKRU: 55555554
> >>> [   32.170888] Call Trace:
> >>> [   32.170975]  <IRQ>
> >>> [   32.171039]  skb_release_all+0x2e/0x40
> >>> [   32.171152]  napi_consume_skb+0x62/0xf0
> >>> [   32.171281]  net_rx_action+0xf6/0x250
> >>> [   32.171394]  __do_softirq+0xdf/0x2c0
> >>> [   32.171506]  do_softirq+0x81/0xa0
> >>> [   32.171608]  </IRQ>
> >>>
> >>>
> >>> Xin came up with this patch a couple of months ago that resolves the
> >>> panic but it has a big impact on performance:
> >>>
> >>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>> index 0fbd5c85155f..6c2c8d09fd89 100644
> >>> --- a/net/core/skbuff.c
> >>> +++ b/net/core/skbuff.c
> >>> @@ -1717,7 +1717,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t
> >>> gfp_mask)
> >>>   {
> >>>          int num_frags =3D skb_shinfo(skb)->nr_frags;
> >>>          struct page *page, *head =3D NULL;
> >>> -       int i, new_frags;
> >>> +       int i, new_frags, pagelen;
> >>>          u32 d_off;
> >>>
> >>>          if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
> >>> @@ -1733,7 +1733,16 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t
> >>> gfp_mask)
> >>>                  return 0;
> >>>          }
> >>>
> >>> -       new_frags =3D (__skb_pagelen(skb) + PAGE_SIZE - 1) >> PAGE_SH=
IFT;
> >>> +       pagelen =3D __skb_pagelen(skb);
> >>> +       if (pagelen > GSO_LEGACY_MAX_SIZE) {
> >>> +               /* without hugepages, skb frags can only hold 65536 d=
ata. */
> >> This is with CONFIG_MAX_SKB_FRAGS 17 I suppose.
> > correct, I did not enable that config so it defaults to 17.
> >
> >> So is the issue just that new_frags ends up indexing out of bounds
> >> in frags[MAX_SKB_FRAGS]?
> > yes, I see nr_frags at 32 which is clearly way out of bounds and it
> > seems to be the skb_copy_ubufs function causing it.
>
>
> Solution is to sense which page order is necessary in order to fit the
> skb length into MAX_SKB_FRAGS pages. alloc_page() -> alloc_pages(order);
> alloc_skb_with_frags() has a similar strategy (but different goals)
>
> I can prepare a patch.
>

I will test the following:

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2112146092bfe24061b24b9e4684bcc031a045b9..891ecca40b29af1e15a89745f7f=
c630b19ea0202
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1758,7 +1758,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mas=
k)
 {
        int num_frags =3D skb_shinfo(skb)->nr_frags;
        struct page *page, *head =3D NULL;
-       int i, new_frags;
+       int i, order, psize, new_frags;
        u32 d_off;

        if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
@@ -1767,9 +1767,17 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_ma=
sk)
        if (!num_frags)
                goto release;

-       new_frags =3D (__skb_pagelen(skb) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+       /* We might have to allocate high order pages, so compute what mini=
mum
+        * page order is needed.
+        */
+       order =3D 0;
+       while ((PAGE_SIZE << order) * MAX_SKB_FRAGS < __skb_pagelen(skb))
+               order++;
+       psize =3D (PAGE_SIZE << order);
+
+       new_frags =3D (__skb_pagelen(skb) + psize - 1) >> (PAGE_SHIFT + ord=
er);
        for (i =3D 0; i < new_frags; i++) {
-               page =3D alloc_page(gfp_mask);
+               page =3D alloc_pages(gfp_mask, order);
                if (!page) {
                        while (head) {
                                struct page *next =3D (struct page
*)page_private(head);
@@ -1796,11 +1804,11 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_m=
ask)
                        vaddr =3D kmap_atomic(p);

                        while (done < p_len) {
-                               if (d_off =3D=3D PAGE_SIZE) {
+                               if (d_off =3D=3D psize) {
                                        d_off =3D 0;
                                        page =3D (struct page
*)page_private(page);
                                }
-                               copy =3D min_t(u32, PAGE_SIZE - d_off,
p_len - done);
+                               copy =3D min_t(u32, psize - d_off, p_len - =
done);
                                memcpy(page_address(page) + d_off,
                                       vaddr + p_off + done, copy);
                                done +=3D copy;
@@ -1816,7 +1824,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mas=
k)

        /* skb frags point to kernel buffers */
        for (i =3D 0; i < new_frags - 1; i++) {
-               __skb_fill_page_desc(skb, i, head, 0, PAGE_SIZE);
+               __skb_fill_page_desc(skb, i, head, 0, psize);
                head =3D (struct page *)page_private(head);
        }
        __skb_fill_page_desc(skb, new_frags - 1, head, 0, d_off);
