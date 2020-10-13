Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1337A28C7B4
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 05:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731396AbgJMDxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 23:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgJMDxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 23:53:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E10EC0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 20:53:05 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j18so3274632pfa.0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 20:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I976gwN/15KL+QNMsgGgqLZsKsiYJk1WAAkrJcvqpXg=;
        b=Jvs6pDvj0IsDRmKV94si7Hmy7rSC+vZBw6IORU+6GuiBz6nFVyhqIqcqJDs0PDrtGr
         nXgB5Gg3YnIhlpunv6ok32b0qmXBGoCwLNqj8YhtpNO34HbUEe0fj0rk5j4aFEsdLznp
         VoXOaX98Lakuk83ySfZj3iYVBGQSYWKOXyIXuOrEyRswmVxiaN0fpvQLOEbiBPlkB0f0
         SaQzLf6nCGYW1cdweYZEMOz6t3FkN6D8ke5ashIIre24atnH4a15lepW6k2kSOlNz9zr
         SS6NCvPuDVbJ/UO8vSYODHhBG1Za37JNzNmmpoq6Rj8IhJ3hedl5GM6iDMNEd51QrfKm
         Hzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I976gwN/15KL+QNMsgGgqLZsKsiYJk1WAAkrJcvqpXg=;
        b=J42GhwQVLozJ4Oa9ArS6yOqAuZS2VYi9qRZg9b17jIMp4aN+DOK7+xfetRQ91XfWUl
         K5A9v1QWgR25vOpJtzOenqmaV8MEqYq3OukY/32w26qixOUCk2DGJQ5QxoLfVPatbxi7
         XrOaQue9rhdGT9kM7kmyNrdxeU2JRm9S8eTc3GfTbBXRd92z9YR9xjrx7KoUAQq1HWpH
         wgzl7m4SrCWjeY6K6+2Mrhwit+gxe9JS7xqzLCWt9vX4kCAoyCDDXWJsvhYvCFgvFVUJ
         HQ6RuImj+f62B5aArNDV+PWuz04d5ARzf4lsBtNPYNDDRePDNRweKNUj2Lb+aZYTznwA
         WrTQ==
X-Gm-Message-State: AOAM531YLoGdAf7mde2ZEZN/ITL0vO2IAKpLZ5tWwUI00mXA66cZQjJw
        529A6XFCE353iK/eRIkyVxsJL88wRuLdLSzxAqhQlA==
X-Google-Smtp-Source: ABdhPJxTj1LpD8Fj5IklJNe6tlIaSL6h8M3LDjY1NdFgvnmFbpO9hutDnYHrS/qSHLk7UFCnLzxPbWYodXJxV9DZ0fk=
X-Received: by 2002:a17:90a:4749:: with SMTP id y9mr10977409pjg.229.1602561184587;
 Mon, 12 Oct 2020 20:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
 <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
 <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com>
 <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com> <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
 <CAM_iQpUgy7MDka8A44U=pLGDOwqn8YhXMp8rgs8LCJBHb5DXYA@mail.gmail.com>
In-Reply-To: <CAM_iQpUgy7MDka8A44U=pLGDOwqn8YhXMp8rgs8LCJBHb5DXYA@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 13 Oct 2020 11:52:28 +0800
Message-ID: <CAMZfGtUgX2JNVHW8F4cJ7rY2T-8DNkouQh8O0-j6CAfd4+TCew@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shakeel Butt <shakeelb@google.com>,
        Will Deacon <will@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Neil Brown <neilb@suse.de>,
        Mike Rapoport <rppt@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Florian Westphal <fw@strlen.de>, gustavoars@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, dave@stgolabs.net,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>, chenqiwu@xiaomi.com,
        christophe.leroy@c-s.fr, Minchan Kim <minchan@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 6:12 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Oct 12, 2020 at 2:53 AM Muchun Song <songmuchun@bytedance.com> wrote:
> > We are not complaining about TCP using too much memory, but how do
> > we know that TCP uses a lot of memory. When I firstly face this problem,
> > I do not know who uses the 25GB memory and it is not shown in the /proc/meminfo.
> > If we can know the amount memory of the socket buffer via /proc/meminfo, we
> > may not need to spend a lot of time troubleshooting this problem. Not everyone
> > knows that a lot of memory may be used here. But I believe many people
> > should know /proc/meminfo to confirm memory users.
>
> Well, I'd bet networking people know `ss -m` better than /proc/meminfo,

I agree with you. But if someone(not networking people) faces the same
problem. He may suspect that there is a memory leak or think that a certain
driver allocates memory but has no statistics. He only saw the memory
disappeared via /proc/meminfo.

> generally speaking.
>
> The practice here is that if you want some networking-specific counters,
> add it to where networking people know better, that is, `ss -m` or /proc/net/...
>
> Or maybe the problem you described is not specific to networking at all,
> there must be some other places where pages are allocated but not charged.

Yeah, it is not charged. The allocation path is as follows. This allocation
consumes 25GB memory on our server. And it belongs to the network core.

Thanks.

   __alloc_pages_nodemask+0x11d/0x290
   skb_page_frag_refill+0x68/0xf0
   sk_page_frag_refill+0x19/0x70
   tcp_sendmsg_locked+0x2f4/0xd10
   tcp_sendmsg+0x29/0xa0
   sock_sendmsg+0x30/0x40
   sock_write_iter+0x8f/0x100
   __vfs_write+0x10b/0x190
   vfs_write+0xb0/0x190
   ksys_write+0x5a/0xd0
   do_syscall_64+0x5d/0x110
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

> If so, adding a general mm counter in /proc/meminfo makes sense, but
> it won't be specific to networking.
>
> Thanks.



-- 
Yours,
Muchun
