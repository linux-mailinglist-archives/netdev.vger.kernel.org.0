Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B787E35DB0E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245643AbhDMJYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbhDMJYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:24:53 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D1FC061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:24:32 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id l14so11151949ybf.11
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eilsWJ436y5EpMfON6Wru7/wZHB3hyKVpK6txyWMaEk=;
        b=U2AR7ZhsvlKFUL9UAI2j57eVY4R8TZJ57Rex9pkWTeCtEVT6wD9V2k0XQiFOio+ZSl
         WrT9bj4HyAST2TmN2iAVLrOTZK1xBOqZCA1t5/p/RxgAzH67MfqXxLNxbORiqnzonhrl
         fhPj8199fGlyld+3rlYneaGjU5AjMFjytQJb30bI5INbjkWUc47dXI8kW2KWQF41qTfy
         pwanSzKipCKygspEAru7pzJTal7FO9htNYplaofaJjcyojbDR9BMuNIJYK1q/HOXrhmY
         +ISjULw85tVhgI7ErWMduza7zTsZE1MRAcGFiGaVUjUJBgl048aa02JgXlJI3R3fgxa1
         adOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eilsWJ436y5EpMfON6Wru7/wZHB3hyKVpK6txyWMaEk=;
        b=jlUMNE5eyUTdHfOYsFXnMCqHXh2Io9zkGL/Ls7k5x6vJtpyCPXwnLhCZoDcwu9MLsN
         o8wjkIbfaOZKBgpCdg8kqsoqusw3s7P6sy6zlE4FDpG0TSuB+QjTGdhjH5a746kAm4I2
         pOfNzOKGcVGym8PNnNTR67PllttXjxj+MfNSUqMAigJ7VF6O/hk0VQAv92XoCmcsalrr
         /pV1LCfdc426aJsVvCtor8E6SKOOQ8PZDmySH9yWpjdzMZPYhZ05ZJYn1tBuIytGoWqT
         qKUGRB4EGFcU0E2KO1nKYBklZYW3vH1YgqSsC85tcE3vQiW6swd275XM3npHpM6I4jS0
         upTw==
X-Gm-Message-State: AOAM532tQLVHRr0TOyTGxg5lc59bokv/MPLru+hkujINRJ4jvfdyDKc6
        uQ6NcIVhzfkuSeP4tfrhRFLLwa03ls5EQ5EYmcU2JQ==
X-Google-Smtp-Source: ABdhPJwNxYSRQPQPqbHv6ObXbGvShQMUCY0Y74AJPbb0xgQNMVttsb9i97F8rFlNrlZWwreruBAxg9HW4gr5GrjDNAk=
X-Received: by 2002:a25:b906:: with SMTP id x6mr41172495ybj.504.1618305871573;
 Tue, 13 Apr 2021 02:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net> <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
 <78c858ba-a847-884f-80c3-cb1eb84d4113@roeck-us.net> <CANn89i+wQoaiFEe1Qi1k96d-ACLmAtJJQ36bs5Z5knYO1v+rOg@mail.gmail.com>
 <ec5a2822-02b8-22e8-b2e2-23a942506a94@roeck-us.net>
In-Reply-To: <ec5a2822-02b8-22e8-b2e2-23a942506a94@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 13 Apr 2021 11:24:20 +0200
Message-ID: <CANn89iKDytTucZfCPKLfiv8FdWYSvs4JzgkN452PrH7qDfPbkg@mail.gmail.com>
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

On Mon, Apr 12, 2021 at 10:05 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 4/12/21 10:38 AM, Eric Dumazet wrote:
> [ ... ]
>
> > Yes, I think this is the real issue here. This smells like some memory
> > corruption.
> >
> > In my traces, packet is correctly received in AF_PACKET queue.
> >
> > I have checked the skb is well formed.
> >
> > But the user space seems to never call poll() and recvmsg() on this
> > af_packet socket.
> >
>
> After sprinkling the kernel with debug messages:
>
> 424   00:01:33.674181 sendto(6, "E\0\1H\0\0\0\0@\21y\246\0\0\0\0\377\377\377\377\0D\0C\00148\346\1\1\6\0\246\336\333\v\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0RT\0\
> 424   00:01:33.693873 close(6)          = 0
> 424   00:01:33.694652 fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
> 424   00:01:33.695213 clock_gettime64(CLOCK_MONOTONIC, 0x7be18a18) = -1 EFAULT (Bad address)
> 424   00:01:33.695889 write(2, "udhcpc: clock_gettime(MONOTONIC) failed\n", 40) = -1 EFAULT (Bad address)
> 424   00:01:33.697311 exit_group(1)     = ?
> 424   00:01:33.698346 +++ exited with 1 +++
>
> I only see that after adding debug messages in the kernel, so I guess there must be
> a heisenbug somehere.
>
> Anyway, indeed, I see (another kernel debug message):
>
> __do_sys_clock_gettime: Returning -EFAULT on address 0x7bacc9a8
>
> So udhcpc doesn't even try to read the reply because it crashes after sendto()
> when trying to read the current time. Unless I am missing something, that means
> that the problem happens somewhere on the send side.
>
> To make things even more interesting, it looks like the failing system call
> isn't always clock_gettime().
>
> Guenter


I think GRO fast path has never worked on SUPERH. Probably SUPERH has
never used a fast NIC (10Gbit+)

The following hack fixes the issue.


diff --git a/net/core/dev.c b/net/core/dev.c
index af8c1ea040b9364b076e2d72f04dc3de2d7e2f11..91ba89a645ff91d4cd4f3d8dc8a009bcb67da344
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5916,13 +5916,16 @@ static struct list_head
*gro_list_prepare(struct napi_struct *napi,

 static void skb_gro_reset_offset(struct sk_buff *skb)
 {
+#if !defined(CONFIG_SUPERH)
        const struct skb_shared_info *pinfo = skb_shinfo(skb);
        const skb_frag_t *frag0 = &pinfo->frags[0];
+#endif

        NAPI_GRO_CB(skb)->data_offset = 0;
        NAPI_GRO_CB(skb)->frag0 = NULL;
        NAPI_GRO_CB(skb)->frag0_len = 0;

+#if !defined(CONFIG_SUPERH)
        if (!skb_headlen(skb) && pinfo->nr_frags &&
            !PageHighMem(skb_frag_page(frag0))) {
                NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
@@ -5930,6 +5933,7 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
                                                    skb_frag_size(frag0),
                                                    skb->end - skb->tail);
        }
+#endif
 }

 static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
