Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1C428A824
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbgJKQBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387799AbgJKQBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 12:01:01 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A01EC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 09:01:01 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so11618819pgb.10
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 09:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZeFjw3qLweAjOU35zoRBA8nXBOKUeG2GljXb+HxWSOw=;
        b=wAfLQMktP3vX4gsrlyNS7bbn9fQ5HRsy2aJNNdt6ka30g9Ko/FJhQwWyAHrLsBd1W9
         7AiJ5IaRRvN+HySKCHGDPwiC0KkE+cFhqzlUT4+q4MXFanvmSVhk/kzTw908Gp1DWunj
         zrQDcro6Gcwx4ETnK2/bI3WREkoPuUKNxqbhUDblGB+RWrRA87LcKUVozSjTa0x3aNMe
         TUQIZ6CB0bnK1Tsxxg9Y/KgqK9yXkn32E64iseUZsCkqK97b9VQugRYctPXTC92FZ3is
         k77wtpura5vda4j29hm2YPSItLsBTdPUa81UMEMC4p8nkdaVpbPPm3RHrSzFWPa5Tayd
         a3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZeFjw3qLweAjOU35zoRBA8nXBOKUeG2GljXb+HxWSOw=;
        b=aaCIZvOfR5JiWYyTcvem75vZyJmlQYIm9LGtNWi3AGdNxHVMRD04ynWduX4h0zu61J
         cPvSv7oCDFPB/QKMtelUHDW7QumXDcY6Z//shO6+wUTJkadM0oCWbRJCeEzWwKVCa+At
         i3XOcRwztuRLvue8tuvDbSiYet+bOrMXR9u2ynchIK1zPNfJ6jlXRmgNuwOSWi9jTXuj
         2OgDoQLQ3b1rZQLXtEpgxCrzTXBKdKlwHnOWyzmNggW7NV0i6CxsGHXFKQVkVL+A5sCU
         DDrEaphDhmfPZ0kizkPaASEXNR0c+On/p0g2r3zqHoJZJXtXtOu4QnW56s62ubu9Hwb5
         lVHQ==
X-Gm-Message-State: AOAM5322roSbUoxPFjUIajeoeoOEjhwLZcVPnLvQB2iVmrxZibFaxhE8
        w8mLm2yf/P+QLsp9kRTV77nVXmxhpKSuF5DadtKzAQ==
X-Google-Smtp-Source: ABdhPJx+35KZugbZDuYuwDppg2jtVfNyVvGyDLkEevimfuHCyJp9HQAuTr44pyJ85kH6+5R+ijtE2LOzbIG0aYnD3qI=
X-Received: by 2002:a17:90a:4749:: with SMTP id y9mr2820055pjg.229.1602432060784;
 Sun, 11 Oct 2020 09:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com> <20201011135244.GC4251@kernel.org>
In-Reply-To: <20201011135244.GC4251@kernel.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Mon, 12 Oct 2020 00:00:24 +0800
Message-ID: <CAMZfGtVgiZ-dg=t0Vsc5mt+UgEA+W2RjZ8sd9TFdEUB4iPPxXw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        adobriyan@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, Shakeel Butt <shakeelb@google.com>,
        Will Deacon <will@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, neilb@suse.de,
        Sami Tolvanen <samitolvanen@google.com>,
        kirill.shutemov@linux.intel.com, feng.tang@intel.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, fw@strlen.de,
        gustavoars@kernel.org, pablo@netfilter.org, decui@microsoft.com,
        jakub@cloudflare.com, Peter Zijlstra <peterz@infradead.org>,
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

On Sun, Oct 11, 2020 at 9:53 PM Mike Rapoport <rppt@kernel.org> wrote:
>
> On Sat, Oct 10, 2020 at 06:38:54PM +0800, Muchun Song wrote:
> > The amount of memory allocated to sockets buffer can become significant.
> > However, we do not display the amount of memory consumed by sockets
> > buffer. In this case, knowing where the memory is consumed by the kernel
> > is very difficult. On our server with 500GB RAM, sometimes we can see
> > 25GB disappear through /proc/meminfo. After our analysis, we found the
> > following memory allocation path which consumes the memory with page_owner
> > enabled.
>
> I have a high lelel question.
> There is accounting of the socket memory for memcg that gets called from
> the networking layer. Did you check if the same call sites can be used
> for the system-wide accounting as well?

I also think about this. But we did not pass the `struct page` parameter to
the sock accounting memcg API. So we did not know the NUMA node
which allocated the socket buffer memory and cannot do node-level
statistics. In addition, there is another problem. If the user sends a 4096-byte
message, we only charge one page to the memcg but the system allocates 8
pages. So if we reuse the same call sites for the system-wide accounting,
the statistical count we get is always smaller than the actual situation.

>
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
>
> Is virtio-net the only dirver that requred an update?

Yeah, only virtio-net needs an update. Because only it uses the
skb_page_frag_refill() API.

>
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
> >



-- 
Yours,
Muchun
