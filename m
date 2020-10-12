Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFAC28C446
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgJLVrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730022AbgJLVrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 17:47:03 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A060CC0613D0;
        Mon, 12 Oct 2020 14:47:03 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l8so19172577ioh.11;
        Mon, 12 Oct 2020 14:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h+F8apYj2Plr5dGtsp4Sn87icM0Gt/ZYiDUCGu5uXTA=;
        b=sYImlSuWHY/0f/jfbP/5+gVgcuqOAtQjUMnXMHXED5umjtE3LPslOSL7etCXMHOofP
         OCpa+2Sz42CDxUNykjUuDhWyt5vFu1VQ2q4mLxaSnkvM0BeJYsRX2yVIf69oRTE9T67o
         HRSY3XMYMW81cX286ZryHP3m3P/6kZ5ItQS7iUkubm19T+mUJGaXaGWyUNZdJtMqQgmL
         zSpO8tHo17YhrEljp7eptvHzAhmOHFf/hJvg/N0IaJaR5HkeDupWi3U14lijEclKn9qq
         MEwXGSOFD9iX8EgjReyyv2j7VDxt6rk3rEUTRz5EOYXiuvy4JelYIs/WB2F89KX73aVI
         Mp9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h+F8apYj2Plr5dGtsp4Sn87icM0Gt/ZYiDUCGu5uXTA=;
        b=bw4nJYFsH3L6LXwBI0dvBAu3GG/YkGgk2gSymw9Jm2G8SbKXb0pDY69YJSD3b0XObx
         7Q79hcTiYmydzI+UJa7vP95O1ZYRHwQNGeTQ3ak6iSQkbpkZGJ8C9R4hyUgP9X/rJGtK
         XrcA4V4GVIWgv9rg2fneiEijdkQhejhtWD/GnEQrqt1+oPgNoeTFDXgu2uY7hCtmk6AS
         Q8WrM4KMdHzLKRAobosryi60chagneE+Uedi3xrAi3uITKErio06oFfyd25WnRJdpStv
         gQuFmpUCrKcDkVOLrZcJrR38TphVDNmsZelza0YEel1QJPDoSUqrhNiXL7ZxiAwkNkmz
         uTAQ==
X-Gm-Message-State: AOAM532ts66YoeTI3X4kC+fMw0c/khNRe5tnLbHMVznDUFdh0nqzbbvB
        dNg/QN1JjD3RwT3SFKGzHqgEh9oPqhGqeL1KuIo=
X-Google-Smtp-Source: ABdhPJz+y8paHziZjzqkLnzbjCoDFkO2pq2nRDQe31YPP796UzqDxRo9ZdyGommWTE6TqDzyP+Mz9TyqV84szZZPZVw=
X-Received: by 2002:a02:94cd:: with SMTP id x71mr20173978jah.124.1602539222864;
 Mon, 12 Oct 2020 14:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com> <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
In-Reply-To: <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 12 Oct 2020 14:46:51 -0700
Message-ID: <CAM_iQpXLX1xXN02idk-yU1T=AGb9JmGiLkfRGCJOxjCw-OWpfQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shakeel Butt <shakeelb@google.com>,
        Will Deacon <will@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Neil Brown <neilb@suse.de>,
        rppt@kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Florian Westphal <fw@strlen.de>, gustavoars@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>, decui@microsoft.com,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 9:22 PM Muchun Song <songmuchun@bytedance.com> wrot=
e:
>
> On Mon, Oct 12, 2020 at 2:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrot=
e:
> >
> > On Sat, Oct 10, 2020 at 3:39 AM Muchun Song <songmuchun@bytedance.com> =
wrote:
> > >
> > > The amount of memory allocated to sockets buffer can become significa=
nt.
> > > However, we do not display the amount of memory consumed by sockets
> > > buffer. In this case, knowing where the memory is consumed by the ker=
nel
> >
> > We do it via `ss -m`. Is it not sufficient? And if not, why not adding =
it there
> > rather than /proc/meminfo?
>
> If the system has little free memory, we can know where the memory is via
> /proc/meminfo. If a lot of memory is consumed by socket buffer, we cannot
> know it when the Sock is not shown in the /proc/meminfo. If the unaware u=
ser
> can't think of the socket buffer, naturally they will not `ss -m`. The
> end result

Interesting, we already have a few counters related to socket buffers,
are you saying these are not accounted in /proc/meminfo either?
If yes, why are page frags so special here? If not, they are more
important than page frags, so you probably want to deal with them
first.


> is that we still don=E2=80=99t know where the memory is consumed. And we =
add the
> Sock to the /proc/meminfo just like the memcg does('sock' item in the cgr=
oup
> v2 memory.stat). So I think that adding to /proc/meminfo is sufficient.

It looks like actually the socket page frag is already accounted,
for example, the tcp_sendmsg_locked():

                        copy =3D min_t(int, copy, pfrag->size - pfrag->offs=
et);

                        if (!sk_wmem_schedule(sk, copy))
                                goto wait_for_memory;


>
> >
> > >  static inline void __skb_frag_unref(skb_frag_t *frag)
> > >  {
> > > -       put_page(skb_frag_page(frag));
> > > +       struct page *page =3D skb_frag_page(frag);
> > > +
> > > +       if (put_page_testzero(page)) {
> > > +               dec_sock_node_page_state(page);
> > > +               __put_page(page);
> > > +       }
> > >  }
> >
> > You mix socket page frag with skb frag at least, not sure this is exact=
ly
> > what you want, because clearly skb page frags are frequently used
> > by network drivers rather than sockets.
> >
> > Also, which one matches this dec_sock_node_page_state()? Clearly
> > not skb_fill_page_desc() or __skb_frag_ref().
>
> Yeah, we call inc_sock_node_page_state() in the skb_page_frag_refill().

How is skb_page_frag_refill() possibly paired with __skb_frag_unref()?

> So if someone gets the page returned by skb_page_frag_refill(), it must
> put the page via __skb_frag_unref()/skb_frag_unref(). We use PG_private
> to indicate that we need to dec the node page state when the refcount of
> page reaches zero.

skb_page_frag_refill() is called on frags not within an skb, for instance,
sk_page_frag_refill() uses it for a per-socket or per-process page frag.
But, __skb_frag_unref() is specifically used for skb frags, which are
supposed to be filled by skb_fill_page_desc() (page is allocated by driver)=
.

They are different things you are mixing them up, which looks clearly
wrong or at least misleading.

Thanks.
