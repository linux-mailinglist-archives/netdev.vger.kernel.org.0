Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2658C35B872
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 04:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhDLCPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 22:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbhDLCPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 22:15:17 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243CEC061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 19:15:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x4so13177497edd.2
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 19:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSe2YU2OOqXVNTZdd+uEc3tjOf9u0oQH7Mf/dnvIcj8=;
        b=kL43czx/RBVEWzr8G8sxGiQzo1XoO2lZTbZA6+bXQ/PTEjgtOsgZRBheKGkdzKZrCE
         UQOjYbSAxS/MCTyTua6rErG5CHZpROPxwyzWzrdsPUs5smXy1Q/ChGeE1xk8dC4fu+Cf
         dqie8tcI9EQBcOXpaq9VY8YiZW21l4RMlja+W4milmFMaRlzEx1a6vZhyb46z/FapiQu
         BcmKBcYPojY6hlCRrK6T6v59o7lYZG1kgfVWgt/23Bvzuu16m0nQat2zguL2L5VNOlja
         94IpitPYcl6tIVOVV458VZQQr40iJMnBBGbabAfy+dI79XCaF2NaUgPSEAe6KTJJm7VJ
         EmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSe2YU2OOqXVNTZdd+uEc3tjOf9u0oQH7Mf/dnvIcj8=;
        b=f83zO55Rd1GGGw9lQ94L0ZckkbYyJ9WJ/PimYwEpkQ2PQ50O76DDZ0LOeLEWtcmcQH
         mad9yZcas2tpeH0x1HrhK5EjbSw99oW8jopFz7JriV8RbhSewXAaxHDPxuYSe5WK6BVF
         /UaOL+zvBvMCfqzQXjb78u0UvKP3jjFUmLxB6gYY0f3+K72IUXSHTiAsDfmOHT6ps7ie
         G/fz9LnO5p3v2N3PG+JrXUA892KoDEAQ45OLbKQo/mWV2ncJpPJ4PPPpvnLk5ZOsNaOl
         d/0A1SxHa05+wd5Qk1nHccx5B+Rp5my6yXWaqR8R6z5YFQI6JCrIdwsSlMaCILVBqA+m
         NiMA==
X-Gm-Message-State: AOAM533LGfh8zmEAJHmZpLG2L7AVAQczhgzOqS6nViCCST7VzkfpE1xc
        QslTPckYqV0v/azEtwsrAtL9nWsFPy8=
X-Google-Smtp-Source: ABdhPJyEZCDHzJeU3eolBoas3hvXtKRZ6S8NSeoJ0SOFXtLwLMOxyy7N0AvDPioniXC4f+k2AC9dBw==
X-Received: by 2002:aa7:c7c5:: with SMTP id o5mr26991602eds.31.1618193698444;
        Sun, 11 Apr 2021 19:14:58 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id e11sm797730ejl.115.2021.04.11.19.14.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 19:14:57 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id 12so11247602wrz.7
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 19:14:56 -0700 (PDT)
X-Received: by 2002:adf:cc8d:: with SMTP id p13mr29483649wrj.50.1618193696460;
 Sun, 11 Apr 2021 19:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsajEU1_Ku3gzS4U4XdL8mQPWzUcgP4RmfhS2e5p=x6u8Q@mail.gmail.com>
In-Reply-To: <CACkBjsajEU1_Ku3gzS4U4XdL8mQPWzUcgP4RmfhS2e5p=x6u8Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 11 Apr 2021 22:14:19 -0400
X-Gmail-Original-Message-ID: <CA+FuTScez=L52DXAqU7S+2+Z5QnZyUYF1Y+MFgtBQODU3NNh+Q@mail.gmail.com>
Message-ID: <CA+FuTScez=L52DXAqU7S+2+Z5QnZyUYF1Y+MFgtBQODU3NNh+Q@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in __build_skb
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        linmiaohe <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 9:31 PM Hao Sun <sunhao.th@gmail.com> wrote:
>
> Hi
>
> When using Healer(https://github.com/SunHao-0/healer/tree/dev) to fuzz
> the Linux kernel, I found the following bug report, but I'm not sure
> about this.
> Sorry, I do not have a reproducing program for this bug.
> I hope that the stack trace information in the crash log can help you
> locate the problem.
>
> Here is the details:
> commit:   4ebaab5fb428374552175aa39832abf5cedb916a
> version:   linux 5.12
> git tree:    kmsan
>
> ==============================================
> RAX: ffffffffffffffda RBX: 000000000059c080 RCX: 000000000047338d
> RDX: 0000000000000010 RSI: 0000000020002400 RDI: 0000000000000003
> RBP: 00007fb6512c2c90 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000005
> R13: 00007fffbb36285f R14: 00007fffbb362a00 R15: 00007fb6512c2dc0
> BUG: unable to handle page fault for address: ffffa73d01c96a40
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 1810067 P4D 1810067 PUD 1915067 PMD 4b84067 PTE 0
> Oops: 0002 [#1] SMP
> CPU: 0 PID: 6273 Comm: syz-executor Not tainted 5.12.0-rc6+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:64
> Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6
> f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa
> 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
> RSP: 0018:ffff9f3d01c9b930 EFLAGS: 00010082
> RAX: ffffa73d01c96a00 RBX: 0000000000000020 RCX: 0000000000000020
> RDX: 0000000000000020 RSI: 0000000000000000 RDI: ffffa73d01c96a40
> RBP: ffff9f3d01c9b960 R08: ffffc2390000000f R09: ffffa73d01c96a40
> R10: 000000007dee4e6b R11: ffffffffb2000782 R12: 0000000000000000
> R13: 0000000000000020 R14: 0000000000000000 R15: ffff9f3d01c96a40
> FS:  00007fb6512c3700(0000) GS:ffff97407fa00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffa73d01c96a40 CR3: 0000000030087005 CR4: 0000000000770ef0
> PKRU: 55555554
> Call Trace:
>  kmsan_internal_unpoison_shadow+0x1d/0x70 mm/kmsan/kmsan.c:110
>  __msan_memset+0x64/0xb0 mm/kmsan/kmsan_instr.c:130
>  __build_skb_around net/core/skbuff.c:209 [inline]
>  __build_skb+0x34b/0x520 net/core/skbuff.c:243
>  netlink_alloc_large_skb net/netlink/af_netlink.c:1193 [inline]
>  netlink_sendmsg+0xdc1/0x14d0 net/netlink/af_netlink.c:1902
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg net/socket.c:674 [inline]

I don't have an idea what might be up, but some context:

This happens in __build_skb_around at

        memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));

on vmalloc'd memory in netloc_alloc_large_skb:

        data = vmalloc(size);
        if (data == NULL)
                return NULL;

        skb = __build_skb(data, size);
