Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB6428A572
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 06:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgJKEnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 00:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJKEnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 00:43:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5966EC0613D0
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 21:43:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n9so10857993pgf.9
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 21:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TW9KMm6OrgwSQSQ2ZasuwFiv2daX2uTGOG3qcoUMv5w=;
        b=AnJ2qoD5K4gRsDV2GJqxk0P/F2E7jo8rtGu952jzmVjnBt2KP9bl3aJ9JTFYGg7rqR
         SetWwDLPKamShb8Gwhchi78tPzG491wTQ4L/NdMLdd7bgL9/koS1faeeDbJH7HUjmO0L
         2wO5oym9VV5mc8kQB0OYBN97GqdTqlZ6dyniakEy4obZPAXAf5w6redGYXQuYQD7vQ1t
         Mz0by5XxDlUiaD4z1KZFMaMLyc86ETL6ks6p/zjkXpmix0MvTummVGOamE17jD2RlBTx
         qYNf8xEl39T7D879PWYx6fO0ImO2wg/s1cVCK/yj2N5kLY15fBJtTKalwrrL4oiY1wiS
         2BBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TW9KMm6OrgwSQSQ2ZasuwFiv2daX2uTGOG3qcoUMv5w=;
        b=IwPs+E8S33IdnhzyP1UALEFWTwL11dte4xeeoCdpu1fM3eH3nHDlV7NnxlPiUwMUa0
         Ymeeu3M2J93UNudSq+p20IvRDA5Q7sGf2yhG6REqOJNnzvoAdyGBBWPpf/z7vBWLZuno
         N5LaHokZSLpDK2FagROyjZ0jGjnYwxBquj2onu4qhAXDm3vLFDFP+J0MStbkYI0953G4
         kRwRFWaZGWwHlZE3lz/ZYiSW2964nQgJo9eQNdRHwZ+tkIGxvlB4liADzQlofS9fZnUb
         pCYtfdLtQzb2hVzDnHQ3omn3LyTLUI3GRBbISeSvYp0hMbB4EBW88E7vPwardzppCxIJ
         0D+Q==
X-Gm-Message-State: AOAM531BmTiRgGPdqjXPppaczBww63tz4ZzMMNY/aJCPssx+fxpuvOf3
        KrQQ8+Mb/VjwVD80XUihOI2Z9R4pd93L2CTzCfsWfg==
X-Google-Smtp-Source: ABdhPJyX5zE5edIE4wAqcFOL3tIX1HCwgBxHGADIZGwbL/1HpgjGMf2Sb1l/deaG+f2s3p39mIbnOHH/kLvxzOrAV+E=
X-Received: by 2002:a17:90a:890f:: with SMTP id u15mr13407412pjn.147.1602391393656;
 Sat, 10 Oct 2020 21:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com> <f6dfa37f-5991-3e96-93b8-737f60128151@infradead.org>
In-Reply-To: <f6dfa37f-5991-3e96-93b8-737f60128151@infradead.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Sun, 11 Oct 2020 12:42:37 +0800
Message-ID: <CAMZfGtWo0m+6zxG-XWh5fxcV3d4k77P-e37ZAj1f5oDhvZGqUQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        adobriyan@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, Shakeel Butt <shakeelb@google.com>,
        Will Deacon <will@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, neilb@suse.de, rppt@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>,
        kirill.shutemov@linux.intel.com, feng.tang@intel.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        fw@strlen.de, gustavoars@kernel.org, pablo@netfilter.org,
        decui@microsoft.com, jakub@cloudflare.com,
        Peter Zijlstra <peterz@infradead.org>,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        Thomas Gleixner <tglx@linutronix.de>, dave@stgolabs.net,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>, chenqiwu@xiaomi.com,
        christophe.leroy@c-s.fr, minchan@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, linmiaohe@huawei.com,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Networking <netdev@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 12:37 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi,
>
> On 10/10/20 3:38 AM, Muchun Song wrote:
> > The amount of memory allocated to sockets buffer can become significant.
> > However, we do not display the amount of memory consumed by sockets
> > buffer. In this case, knowing where the memory is consumed by the kernel
> > is very difficult. On our server with 500GB RAM, sometimes we can see
> > 25GB disappear through /proc/meminfo. After our analysis, we found the
> > following memory allocation path which consumes the memory with page_owner
> > enabled.
> >
> >   849698 times:
> >   Page allocated via order 3, mask 0x4052c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP)
> >    __alloc_pages_nodemask+0x11d/0x290
> >    skb_page_frag_refill+0x68/0xf0
> >    sk_page_frag_refill+0x19/0x70
> >    tcp_sendmsg_locked+0x2f4/0xd10
> >    tcp_sendmsg+0x29/0xa0
> >    sock_sendmsg+0x30/0x40
> >    sock_write_iter+0x8f/0x100
> >    __vfs_write+0x10b/0x190
> >    vfs_write+0xb0/0x190
> >    ksys_write+0x5a/0xd0
> >    do_syscall_64+0x5d/0x110
> >    entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  drivers/base/node.c      |  2 ++
> >  drivers/net/virtio_net.c |  3 +--
> >  fs/proc/meminfo.c        |  1 +
> >  include/linux/mmzone.h   |  1 +
> >  include/linux/skbuff.h   | 43 ++++++++++++++++++++++++++++++++++++++--
> >  kernel/exit.c            |  3 +--
> >  mm/page_alloc.c          |  7 +++++--
> >  mm/vmstat.c              |  1 +
> >  net/core/sock.c          |  8 ++++----
> >  net/ipv4/tcp.c           |  3 +--
> >  net/xfrm/xfrm_state.c    |  3 +--
> >  11 files changed, 59 insertions(+), 16 deletions(-)
>
> Thanks for finding that.
>
> Please update Documentation/filesystems/proc.rst "meminfo" section also.

Will do. Thanks for your suggestions.

>
> --
> ~Randy
>


-- 
Yours,
Muchun
