Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB36A2EC997
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 05:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbhAGEqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 23:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbhAGEqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 23:46:12 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBC2C0612F3
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 20:45:32 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id s23so1848971uaq.10
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 20:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FqBU0DzyxHE7rFaChTOl0+T3ooasosngTw/QRkuqug=;
        b=CZXxilFUsoVBDX44Kjfrzt9xXAty5ZhWzDyCfu4kVQ1Qo7a3UIOFlzJNPFs95RNjS0
         ZN10TTyBRYb1pGd42ZVV5Ye/gKqpiI1F1/ZYRe4zpZCRwURUzeK/vVrMEj3gTkBcL6UG
         X8k18HXjmGb6OQ8yhG0ja6Jihr8cO+X/QbbJ0GHHnz01kf020ABkEMGfVWK4uYwWeqg9
         S7jayEzgXB0rMOb4Zp1b+MDVvEVnFQSS6EWBjOqwPcp3GGDOxvZ2lVleaeKv0/UwwZSs
         tNS0H6biAIo1Z8ias28x1iHdU4MjG9lBmQ6jUuAqTA38xOKplbSbO4nFVyA9eamm66or
         hE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FqBU0DzyxHE7rFaChTOl0+T3ooasosngTw/QRkuqug=;
        b=gPCgb88F57FlZSIrdF4D5phEkJZaVlwvbPGu8uHpgWVHAFGHSo3DSnyNoootuqryJK
         cFI0MGPFMb/xz1Y/d9bDTuXJyC0Dyi1HVfhnb35lUJ8yScRTQ5CKOZjeTepeY0hcpnuI
         k26Bk5c1LpQe+G8dL8bkbFPmDtNCZN0rYBpOgzw9b+DG403hkV7RgfWm0Bx0SpbQEYn5
         9gClN1NAxdoAqLFKsGJFavYrgh8LIcQEaLvAp74XoIKlDTOHGJVhXVqBJDVY/JnQHqXS
         HwJzfKJwy39htUaCPy1tilLITnPpaYMXKFBXJ7+HQp/53L8TACwv8hxlby5jwC90hJr+
         949Q==
X-Gm-Message-State: AOAM531ja9FHCZT132JXjFBn8C+n474Sruc0B2CroHyrKj6VsQU3qNBY
        rxGgoHbxHBhNfbXNjEbrc3fTgXsL/VZ/tc1rETpwdw==
X-Google-Smtp-Source: ABdhPJyDMe9TseuG/qIjyrE/SGPXVQo4rz/hxHrw+SPyifPGylrTHwJJ73DrnQGq6u9/vLT5zVMzVyS5VSmNBVCTiGk=
X-Received: by 2002:ab0:7386:: with SMTP id l6mr6184246uap.141.1609994731526;
 Wed, 06 Jan 2021 20:45:31 -0800 (PST)
MIME-Version: 1.0
References: <20201118194838.753436396@linutronix.de> <20201118204007.169209557@linutronix.de>
 <20210106180132.41dc249d@gandalf.local.home> <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
 <20210106174917.3f8ad0d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CA+FuTSevLSxZkNLdJPHqRRksxZmnPc1qFBYJeBx26WsA4A1M7A@mail.gmail.com>
In-Reply-To: <CA+FuTSevLSxZkNLdJPHqRRksxZmnPc1qFBYJeBx26WsA4A1M7A@mail.gmail.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Wed, 6 Jan 2021 23:44:54 -0500
Message-ID: <CA+FuTScQ9afdnQ3E1mqdeyJ-sOq=2Dm9c1XDN8mnzbEig8iMXA@mail.gmail.com>
Subject: Re: [BUG] from x86: Support kmap_local() forced debugging
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 9:11 PM Willem de Bruijn <willemb@google.com> wrote:
>
> On Wed, Jan 6, 2021 at 8:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 6 Jan 2021 17:03:48 -0800 Linus Torvalds wrote:
> > > I wonder whether there is other code that "knows" about kmap() only
> > > affecting PageHighmem() pages thing that is no longer true.
> > >
> > > Looking at some other code, skb_gro_reset_offset() looks suspiciously
> > > like it also thinks highmem pages are special.
> > >
> > > Adding the networking people involved in this area to the cc too.

But there are three other kmap_atomic callers under net/ that do not
loop at all, so assume non-compound pages. In esp_output_head,
esp6_output_head and skb_seq_read. The first two directly use
skb_page_frag_refill, which can allocate compound (but not
__GFP_HIGHMEM) pages, and the third can be inserted with
netfilter xt_string in the path of tcp transmit skbs, which can also
have compound pages. I think that these could similarly access
data beyond the end of the kmap_atomic mapped page. I'll take
a closer look.
