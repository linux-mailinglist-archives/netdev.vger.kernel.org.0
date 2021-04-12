Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03A935CF92
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243730AbhDLRjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241512AbhDLRjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 13:39:07 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414C4C06174A
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 10:38:49 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id x8so9914236ybx.2
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 10:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xKqpB62SjNio2Vd56mEqjJEuhNSyfFYY6eHBB/193EQ=;
        b=p4PodsA1vpWv71j2yZJVbDvfmrbUTGbEFVb88ZbZhJ187WBM1ypqp2kVqBq6u5t+MQ
         WoW5s5KSbvgXMFRBVRd1ctEbA/hoZORBHjX2FROvw6VImed5q9Y55xCdupdd5byeMmUT
         U/vUHMhhJ/K1TaH7dZDwIiAo3RdrNTTp7bXWUIi8bie8ssHOjGtei0HSyWll5i04APXB
         nxRbm16fUlmD6MmBfQpz9aFAZPvVTg/G+lvKo4A2EwpNoH+2ZlmnsJe7VeU7ilSdY1K6
         1v9N5EV4/VUhV5sktr7Z8RUHjKCI1HVSsuUXTwmyTHBEeLb8QEsZSNjR7Lj6KWUfd1MD
         17oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xKqpB62SjNio2Vd56mEqjJEuhNSyfFYY6eHBB/193EQ=;
        b=XMnsLKwe1Hla2sLNBnrHI7cTraKpgJzvzQUoHrxIJmiM09Wa2K4U93aczeAQNMBbxr
         3K/RZKdzb/eAcb29dajIdiLepuRYn6vXOgjCYismLIUPr0DH+kUx+Uh365yfhOyaVW+L
         heLRr+GuxnD6Pvos/YCkxbi6kjVZg5U5w4wSsgEue987Y0KEHu1NZzGNvCOA+E8hH080
         /iqyMHzqHD4s7+iMTWK7O/Vkv/2X6beoMxELDwNffsE2tZ8n2bW1nvIesxc7hVty2l30
         e8b+KVM2zaRp/5kDB12e+FDE1XQywxIOm485SRmY+VGeIGFT6yyNh4SKqf1yl+bbQLQQ
         ECyQ==
X-Gm-Message-State: AOAM530BnEIePlc7JLiJZED3BCaGkEZtAtTBRUTywv4K9ooBXlgPeXUI
        nwfQaWPZ7VcwYBsMwZG0ItFgriBPhu6AEo9N76zjeg==
X-Google-Smtp-Source: ABdhPJy0EiYNU3fwxaO23AZhu4GaOvCjO3kSPlebWlyhQK9ZuPI9EKRW3Vu04v64PYdcqxw19cp07O8cMOhJ2J700QI=
X-Received: by 2002:a25:4244:: with SMTP id p65mr10489640yba.452.1618249128058;
 Mon, 12 Apr 2021 10:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net> <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com> <78c858ba-a847-884f-80c3-cb1eb84d4113@roeck-us.net>
In-Reply-To: <78c858ba-a847-884f-80c3-cb1eb84d4113@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 12 Apr 2021 19:38:36 +0200
Message-ID: <CANn89i+wQoaiFEe1Qi1k96d-ACLmAtJJQ36bs5Z5knYO1v+rOg@mail.gmail.com>
Subject: Re: Linux 5.12-rc7
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 7:31 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 4/12/21 9:31 AM, Eric Dumazet wrote:
> > On Mon, Apr 12, 2021 at 6:28 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >>>
> >>> Qemu test results:
> >>>         total: 460 pass: 459 fail: 1
> >>> Failed tests:
> >>>         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
> >>>
> >>> The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> >>> skb->head"). It is a spurious problem - the test passes roughly every other
> >>> time. When the failure is seen, udhcpc fails to get an IP address and aborts
> >>> with SIGTERM. So far I have only seen this with the "sh" architecture.
> >>
> >> Hmm. Let's add in some more of the people involved in that commit, and
> >> also netdev.
> >>
> >> Nothing in there looks like it should have any interaction with
> >> architecture, so that "it happens on sh" sounds odd, but maybe it's
> >> some particular interaction with the qemu environment.
> >
> > Yes, maybe.
> >
> > I spent few hours on this, and suspect a buggy memcpy() implementation
> > on SH, but this was not conclusive.
> >
>
> I replaced all memcpy() calls in skbuff.h with calls to
>
> static inline void __my_memcpy(unsigned char *to, const unsigned char *from,
>                                unsigned int len)
> {
>        while (len--)
>                *to++ = *from++;
> }
>
> That made no difference, so unless you have some other memcpy() in mind that
> seems to be unlikely.


Sure, note I also had :

diff --git a/net/core/dev.c b/net/core/dev.c
index af8c1ea040b9364b076e2d72f04dc3de2d7e2f11..4e05a32542dd606aaaaee8038017fea949939c0e
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5938,7 +5938,7 @@ static void gro_pull_from_frag0(struct sk_buff
*skb, int grow)

        BUG_ON(skb->end - skb->tail < grow);

-       memcpy(skb_tail_pointer(skb), NAPI_GRO_CB(skb)->frag0, grow);
+       memmove(skb_tail_pointer(skb), NAPI_GRO_CB(skb)->frag0, grow);

        skb->data_len -= grow;
        skb->tail += grow;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c421c8f809256f7b13a8b5a1331108449353ee2d..41796dedfa9034f2333cf249a0d81b7250e14d1f
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2278,7 +2278,7 @@ int skb_copy_bits(const struct sk_buff *skb, int
offset, void *to, int len)
                                              skb_frag_off(f) + offset - start,
                                              copy, p, p_off, p_len, copied) {
                                vaddr = kmap_atomic(p);
-                               memcpy(to + copied, vaddr + p_off, p_len);
+                               memmove(to + copied, vaddr + p_off, p_len);
                                kunmap_atomic(vaddr);
                        }


>
> > By pulling one extra byte, the problem goes away.
> >
> > Strange thing is that the udhcpc process does not go past sendto().
> >
>
> I have been trying to debug that one. Unfortunately gdb doesn't work with sh,
> so I can't use it to debug the problem. I'll spend some more time on this today.

Yes, I think this is the real issue here. This smells like some memory
corruption.

In my traces, packet is correctly received in AF_PACKET queue.

I have checked the skb is well formed.

But the user space seems to never call poll() and recvmsg() on this
af_packet socket.
