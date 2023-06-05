Return-Path: <netdev+bounces-8125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A929722D65
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D37F1280A70
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFFDDDD0;
	Mon,  5 Jun 2023 17:12:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFAB6FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:12:31 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA0B99
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:12:29 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f7359a3b78so5265e9.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 10:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685985148; x=1688577148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5i8759VvdBb33cZoQHB760rmEICyfYogRQ3PCyuk04=;
        b=fA9wBYTmZs9iyUYMBkc7qZw76uaXuB+lfDySKs9sQSyL+kPhxfsnt6fdPxM0K6UsYE
         ePR7hljjdbySt82Q8YOOoXdN8yny7efAiMZQRdMoIj0JfIRGet1R64IN4yGjhgrzsWhW
         0oR6zJGQ3FothC+tdv52ZwGutBRHXQQH0PyGPxWbMypDuVQMTChlSF1Uk+Md+kfSO+KY
         okXhqFtKuD5PYCAPSC39cWfDHoCH89O3ivDrEunIgSlXzelDetTqa3Lmkwij6Vgy44RR
         8vvTi10qvJNP5Qt21ss5PNL/pNtPQ5Nsi0j5JChN6ekHDCrIw5VI1wGSi6ZosYaiIL1F
         nx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685985148; x=1688577148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5i8759VvdBb33cZoQHB760rmEICyfYogRQ3PCyuk04=;
        b=J8ebghpkL/d9Qz+yjSB61xsJ6QBX2AoV1Xw8O/Z/DLHDzHQlY9hJBko6iXuhRzaW4E
         Pu7tUdWyZBjjPcORz7xPbsyAiTcGterR4T2nNWWJ9pNRtptwr0yl/A69LAGUHZzFYGhB
         6eIcFILNr0rsQW9idfP0Pxd5pMU0lfQe092sNfvmcYFDVHa4XIO3knUs42V3JRNp9vHb
         ISzqZUnXwoWu653kqrrKBA4jBZgtRnC9UpEw+ege5Glkx8DJGsiVd4e3TpiTLqFeOcwU
         iU5Lf8VMeEUqY/oY57b1OLzHAorsGWMUqNpTWIWppcygfXzdeMph4/kNDs5z6pJbx4ko
         w1Jg==
X-Gm-Message-State: AC+VfDzwiMX5Zek/dB+KGHDEP4Wj951EoXKS262OeEvy2hTQm+rBa3gV
	VZj8w/cUO8qCVjWJmCAGFrPx3MXvN9T/xtvxPize2g==
X-Google-Smtp-Source: ACHHUZ6TZL4bQrWxn1GmjggUG3b1NpcFd231IEWDOja0Mgzzk22lL4IEGWJaHh+/ClttcJDwZJ8rXY4Ziq08UG3Mzoo=
X-Received: by 2002:a05:600c:8088:b0:3f7:e463:a0d6 with SMTP id
 ew8-20020a05600c808800b003f7e463a0d6mr1303wmb.0.1685985147692; Mon, 05 Jun
 2023 10:12:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKLzwi47D7eteEmG7ehpy3fQ6dvkGnPrF+wpWNXbk0+Eg@mail.gmail.com>
 <20230605164824.56791-1-kuniyu@amazon.com>
In-Reply-To: <20230605164824.56791-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 5 Jun 2023 19:12:15 +0200
Message-ID: <CANn89iLboLwLrHXeHJucAqBkEL_S0rJFog68t7wwwXO-aNf5Mg@mail.gmail.com>
Subject: Re: [PATCH v1 net] ipv6: rpl: Fix Route of Death.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: alex.aring@gmail.com, davem@davemloft.net, dsahern@kernel.org, 
	kuba@kernel.org, kuni1840@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 6:48=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon, 5 Jun 2023 18:27:46 +0200
> > On Mon, Jun 5, 2023 at 4:41=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon=
.com> wrote:
> > >
> > > A remote DoS vulnerability of RPL Source Routing is assigned CVE-2023=
-2156.
> > >
> > > The Source Routing Header (SRH) has the following format:
> > >
> > >   0                   1                   2                   3
> > >   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
> > >   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > >   |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
> > >   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > >   | CmprI | CmprE |  Pad  |               Reserved                |
> > >   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > >   |                                                               |
> > >   .                                                               .
> > >   .                        Addresses[1..n]                        .
> > >   .                                                               .
> > >   |                                                               |
> > >   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > >
> > > The originator of an SRH places the first hop's IPv6 address in the I=
Pv6
> > > header's IPv6 Destination Address and the second hop's IPv6 address a=
s
> > > the first address in Addresses[1..n].
> > >
> > > The CmprI and CmprE fields indicate the number of prefix octets that =
are
> > > shared with the IPv6 Destination Address.  When CmprI or CmprE is not=
 0,
> > > Addresses[1..n] are compressed as follows:
> > >
> > >   1..n-1 : (16 - CmprI) bytes
> > >        n : (16 - CmprE) bytes
> > >
> > > Segments Left indicates the number of route segments remaining.  When=
 the
> > > value is not zero, the SRH is forwarded to the next hop.  Its address
> > > is extracted from Addresses[n - Segment Left + 1] and swapped with IP=
v6
> > > Destination Address.
> > >
> > > When Segment Left is greater than or equal to 2, the size of SRH is n=
ot
> > > changed because Addresses[1..n-1] are decompressed and recompressed w=
ith
> > > CmprI.
> > >
> > > OTOH, when Segment Left changes from 1 to 0, the new SRH could have a
> > > different size because Addresses[1..n-1] are decompressed with CmprI =
and
> > > recompressed with CmprE.
> > >
> > > Let's say CmprI is 15 and CmprE is 0.  When we receive SRH with Segme=
nt
> > > Left >=3D 2, Addresses[1..n-1] have 1 byte for each, and Addresses[n]=
 has
> > > 16 bytes.  When Segment Left is 1, Addresses[1..n-1] is decompressed =
to
> > > 16 bytes and not recompressed.  Finally, the new SRH will need more r=
oom
> > > in the header, and the size is (16 - 1) * (n - 1) bytes.
> > >
> > > Here the max value of n is 255 as Segment Left is u8, so in the worst=
 case,
> > > we have to allocate 3825 bytes in the skb headroom.  However, now we =
only
> > > allocate a small fixed buffer that is IPV6_RPL_SRH_WORST_SWAP_SIZE (1=
6 + 7
> > > bytes).  If the decompressed size overflows the room, skb_push() hits=
 BUG()
> > > below [0].
> > >
> > > Instead of allocating the fixed buffer for every packet, let's alloca=
te
> > > enough headroom only when we receive SRH with Segment Left 1.
> > >
> > > [0]:
> > > skbuff: skb_under_panic: text:ffffffff81c9f6e2 len:576 put:576 head:f=
fff8880070b5180 data:ffff8880070b4fb0 tail:0x70 end:0x140 dev:lo
> > > kernel BUG at net/core/skbuff.c:200!
> > > invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > > CPU: 0 PID: 154 Comm: python3 Not tainted 6.4.0-rc4-00190-gc308e9ec00=
47 #7
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.=
0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> > > RIP: 0010:skb_panic (net/core/skbuff.c:200)
> > > Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00 50 ff b7 c8 00 =
00 00 4c 8b 8f c0 00 00 00 48 c7 c7 80 6e 77 82 e8 ad 8b 60 ff <0f> 0b 66 6=
6 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> > > RSP: 0018:ffffc90000003da0 EFLAGS: 00000246
> > > RAX: 0000000000000085 RBX: ffff8880058a6600 RCX: 0000000000000000
> > > RDX: 0000000000000000 RSI: ffff88807dc1c540 RDI: ffff88807dc1c540
> > > RBP: ffffc90000003e48 R08: ffffffff82b392c8 R09: 00000000ffffdfff
> > > R10: ffffffff82a592e0 R11: ffffffff82b092e0 R12: ffff888005b1c800
> > > R13: ffff8880070b51b8 R14: ffff888005b1ca18 R15: ffff8880070b5190
> > > FS:  00007f4539f0b740(0000) GS:ffff88807dc00000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000055670baf3000 CR3: 0000000005b0e000 CR4: 00000000007506f0
> > > PKRU: 55555554
> > > Call Trace:
> > >  <IRQ>
> > >  skb_push (net/core/skbuff.c:210)
> > >  ipv6_rthdr_rcv (./include/linux/skbuff.h:2880 net/ipv6/exthdrs.c:634=
 net/ipv6/exthdrs.c:718)
> > >  ? raw6_local_deliver (net/ipv6/raw.c:207)
> > >  ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:437 (discriminator 5)=
)
> > >  ip6_input_finish (./include/linux/rcupdate.h:805 net/ipv6/ip6_input.=
c:483)
> > >  __netif_receive_skb_one_core (net/core/dev.c:5494)
> > >  process_backlog (./include/linux/rcupdate.h:805 net/core/dev.c:5934)
> > >  __napi_poll (net/core/dev.c:6496)
> > >  net_rx_action (net/core/dev.c:6565 net/core/dev.c:6696)
> > >  __do_softirq (./arch/x86/include/asm/jump_label.h:27 ./include/linux=
/jump_label.h:207 ./include/trace/events/irq.h:142 kernel/softirq.c:572)
> > >  do_softirq (kernel/softirq.c:472 kernel/softirq.c:459)
> > >  </IRQ>
> > >  <TASK>
> > >  __local_bh_enable_ip (kernel/softirq.c:396)
> > >  __dev_queue_xmit (net/core/dev.c:4272)
> > >  ip6_finish_output2 (./include/net/neighbour.h:544 net/ipv6/ip6_outpu=
t.c:134)
> > >  rawv6_sendmsg (./include/net/dst.h:458 ./include/linux/netfilter.h:3=
03 net/ipv6/raw.c:656 net/ipv6/raw.c:914)
> > >  sock_sendmsg (net/socket.c:724 net/socket.c:747)
> > >  __sys_sendto (net/socket.c:2144)
> > >  __x64_sys_sendto (net/socket.c:2156 net/socket.c:2152 net/socket.c:2=
152)
> > >  do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80=
)
> > >  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> > > RIP: 0033:0x7f453a138aea
> > > Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 =
89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 05 <48> 3d 00 f=
0 ff ff 77 7e c3 0f 1f 44 00 00 41 54 48 83 ec 30 44 89
> > > RSP: 002b:00007ffcc212a1c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002=
c
> > > RAX: ffffffffffffffda RBX: 00007ffcc212a288 RCX: 00007f453a138aea
> > > RDX: 0000000000000060 RSI: 00007f4539084c20 RDI: 0000000000000003
> > > RBP: 00007f4538308e80 R08: 00007ffcc212a300 R09: 000000000000001c
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > R13: ffffffffc4653600 R14: 0000000000000001 R15: 00007f4539712d1b
> > >  </TASK>
> > > Modules linked in:
> > >
> > > Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> > > Reported-by: Max VA
> > > Closes: https://www.interruptlabs.co.uk/articles/linux-ipv6-route-of-=
death
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > > To maintainers:
> > > Please complement the Reported-by address from the security@ mailing =
list
> > > if possible, which checkpatch will complain about.
> > > ---
> > >  include/net/rpl.h  |  3 ---
> > >  net/ipv6/exthdrs.c | 26 ++++++++------------------
> > >  2 files changed, 8 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/include/net/rpl.h b/include/net/rpl.h
> > > index 308ef0a05cae..30fe780d1e7c 100644
> > > --- a/include/net/rpl.h
> > > +++ b/include/net/rpl.h
> > > @@ -23,9 +23,6 @@ static inline int rpl_init(void)
> > >  static inline void rpl_exit(void) {}
> > >  #endif
> > >
> > > -/* Worst decompression memory usage ipv6 address (16) + pad 7 */
> > > -#define IPV6_RPL_SRH_WORST_SWAP_SIZE (sizeof(struct in6_addr) + 7)
> > > -
> > >  size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
> > >                          unsigned char cmpre);
> > >
> > > diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> > > index a8d961d3a477..bc413961f564 100644
> > > --- a/net/ipv6/exthdrs.c
> > > +++ b/net/ipv6/exthdrs.c
> > > @@ -569,24 +569,6 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
> > >                 return -1;
> > >         }
> > >
> > > -       if (skb_cloned(skb)) {
> > > -               if (pskb_expand_head(skb, IPV6_RPL_SRH_WORST_SWAP_SIZ=
E, 0,
> > > -                                    GFP_ATOMIC)) {
> > > -                       __IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb=
)),
> > > -                                       IPSTATS_MIB_OUTDISCARDS);
> > > -                       kfree_skb(skb);
> > > -                       return -1;
> > > -               }
> > > -       } else {
> > > -               err =3D skb_cow_head(skb, IPV6_RPL_SRH_WORST_SWAP_SIZ=
E);
> > > -               if (unlikely(err)) {
> > > -                       kfree_skb(skb);
> > > -                       return -1;
> > > -               }
> > > -       }
> > > -
> > > -       hdr =3D (struct ipv6_rpl_sr_hdr *)skb_transport_header(skb);
> > > -
> > >         if (!pskb_may_pull(skb, ipv6_rpl_srh_size(n, hdr->cmpri,
> > >                                                   hdr->cmpre))) {
> > >                 kfree_skb(skb);
> > > @@ -630,6 +612,14 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
> > >         skb_pull(skb, ((hdr->hdrlen + 1) << 3));
> > >         skb_postpull_rcsum(skb, oldhdr,
> > >                            sizeof(struct ipv6hdr) + ((hdr->hdrlen + 1=
) << 3));
> > > +       if (unlikely(!hdr->segments_left) &&
> > > +           pskb_expand_head(skb, sizeof(struct ipv6hdr) + ((chdr->hd=
rlen + 1) << 3), 0,
> > > +                            GFP_ATOMIC)) {
> > > +               __IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)), IPST=
ATS_MIB_OUTDISCARDS);
> > > +               kfree_skb(skb);
> > > +               kfree(buf);
> > > +               return -1;
> > > +       }
> > >         skb_push(skb, ((chdr->hdrlen + 1) << 3) + sizeof(struct ipv6h=
dr));
> > >         skb_reset_network_header(skb);
> > >         skb_mac_header_rebuild(skb);
> >
> > Your patch is not complete.
> >
> > Any pskb_maypull() or pskb_expand_head() can change skb->head
> >
> > So @oldhdr will point to freed memory and this will trigger another bug=
 report.
> >
> > memmove(ipv6_hdr(skb), oldhdr, sizeof(struct ipv6hdr)); // crash
>
> Yes, I assumed your series would fix it.  At least after the new
> pskb_expand_head(), we don't touch the hdr.
>
> If it's the best option, could you take my patch into your v2 ?
>

I think the existing calls do not change skb->head, because the caller norm=
ally
already pulled the needed data.

Essentially I think your patch should be standalone.

Later we can cleanup things.

