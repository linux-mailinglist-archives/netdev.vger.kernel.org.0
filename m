Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83AB28C78F
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 05:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgJMDaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 23:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgJMDaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 23:30:22 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2366C0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 20:30:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c20so5183571pfr.8
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 20:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=veclwl1rWnO1PyZHw8dPBjATssIz1mruYYxnvO/JFq8=;
        b=sWqJ/y9JSkmPh1tUBls/oFgZXBBJAbrSQFTt+uSGq/Iu5Cll4SUFao4LHB8uZML9Nf
         suEOfzzkUGhoWi1X8PeH7GScXYHrF5xPgJwx1WDg8hdRc8vhZuVkpui0eXEtiy3SgcYi
         R8EIf7ncK1EhX/rdKQOmKglxFInKA3tnaF4Wbo4C5B1WXahadXjBgxv3YEPnUBjvo1yc
         K8QTIYwTPjSHxidx02iPEuML0hdy8P6WJiVz+ogJMp3NSuWMBYhN0PE6qUt/bP4AVwjj
         QhMuB7hqQXpc3ZNOYun05eTJ40dodrPHEW+oE0s1QGwBm8v+icuYsiWBseFF5z4khe6e
         RXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=veclwl1rWnO1PyZHw8dPBjATssIz1mruYYxnvO/JFq8=;
        b=YDS9cjAupnLtlIzlbwHxBh6QFRPwPmqW+AIa9nC69797fdU5hKbI7cQ3RY7zFugNsi
         AblX7Aj2Ec6JSAw1a9f703IFCiQ2mdZeu/B33XMq0HFA5Eevy2xHm2FgUa6DSMLS2Cbo
         kpZbxRpB9qQHVCvqUQDRYkEUzMOAXWRdHAQ/RPEiDR3InersGU+OOuGF3swINWVBkbRx
         ejvFlLi/urgUO/qKsSSCloOliYZj9S+Kv36XN0MesIE58RBtuO7GGEjEv+ZsOkE3XsNe
         4aEsWvd00HdG1XE2RWMO9B31DmB1vF8MWbVRfKaQfQCYmp9s246xAO2tzlopOIGdma+f
         HOUA==
X-Gm-Message-State: AOAM532OZo8PZjPdV3eAF5mems3ZD88CPA6a8+QkVxMaqZItimzQ5Dnb
        X2Lh1Ezel8R4hWSdGot/GK3ZCyhaAV++zPLXUIgXyQ==
X-Google-Smtp-Source: ABdhPJwv7AqyroJZItMRGC4vj7W3CzjTFTwAXQqOupPBrXsMxczQqLtTe8ycRtlelanR0nD4qp9ozIIPCE46a16q6f4=
X-Received: by 2002:a17:90a:b78b:: with SMTP id m11mr23945507pjr.13.1602559820309;
 Mon, 12 Oct 2020 20:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com> <CAM_iQpXLX1xXN02idk-yU1T=AGb9JmGiLkfRGCJOxjCw-OWpfQ@mail.gmail.com>
In-Reply-To: <CAM_iQpXLX1xXN02idk-yU1T=AGb9JmGiLkfRGCJOxjCw-OWpfQ@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 13 Oct 2020 11:29:44 +0800
Message-ID: <CAMZfGtWhnr9_m1HSnMt9QxcT_q8XCMvbsxv9ZgzXP9D8B0qLsQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Cong Wang <xiyou.wangcong@gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 5:47 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Oct 11, 2020 at 9:22 PM Muchun Song <songmuchun@bytedance.com> wr=
ote:
> >
> > On Mon, Oct 12, 2020 at 2:39 AM Cong Wang <xiyou.wangcong@gmail.com> wr=
ote:
> > >
> > > On Sat, Oct 10, 2020 at 3:39 AM Muchun Song <songmuchun@bytedance.com=
> wrote:
> > > >
> > > > The amount of memory allocated to sockets buffer can become signifi=
cant.
> > > > However, we do not display the amount of memory consumed by sockets
> > > > buffer. In this case, knowing where the memory is consumed by the k=
ernel
> > >
> > > We do it via `ss -m`. Is it not sufficient? And if not, why not addin=
g it there
> > > rather than /proc/meminfo?
> >
> > If the system has little free memory, we can know where the memory is v=
ia
> > /proc/meminfo. If a lot of memory is consumed by socket buffer, we cann=
ot
> > know it when the Sock is not shown in the /proc/meminfo. If the unaware=
 user
> > can't think of the socket buffer, naturally they will not `ss -m`. The
> > end result
>
> Interesting, we already have a few counters related to socket buffers,
> are you saying these are not accounted in /proc/meminfo either?

Yeah, these are not accounted for in /proc/meminfo.

> If yes, why are page frags so special here? If not, they are more
> important than page frags, so you probably want to deal with them
> first.
>
>
> > is that we still don=E2=80=99t know where the memory is consumed. And w=
e add the
> > Sock to the /proc/meminfo just like the memcg does('sock' item in the c=
group
> > v2 memory.stat). So I think that adding to /proc/meminfo is sufficient.
>
> It looks like actually the socket page frag is already accounted,
> for example, the tcp_sendmsg_locked():
>
>                         copy =3D min_t(int, copy, pfrag->size - pfrag->of=
fset);
>
>                         if (!sk_wmem_schedule(sk, copy))
>                                 goto wait_for_memory;
>

Yeah, it is already accounted for. But it does not represent real memory
usage. This is just the total amount of charged memory.

For example, if a task sends a 10-byte message, it only charges one
page to memcg. But the system may allocate 8 pages. Therefore, it
does not truly reflect the memory allocated by the page frag memory
allocation path.

>
> >
> > >
> > > >  static inline void __skb_frag_unref(skb_frag_t *frag)
> > > >  {
> > > > -       put_page(skb_frag_page(frag));
> > > > +       struct page *page =3D skb_frag_page(frag);
> > > > +
> > > > +       if (put_page_testzero(page)) {
> > > > +               dec_sock_node_page_state(page);
> > > > +               __put_page(page);
> > > > +       }
> > > >  }
> > >
> > > You mix socket page frag with skb frag at least, not sure this is exa=
ctly
> > > what you want, because clearly skb page frags are frequently used
> > > by network drivers rather than sockets.
> > >
> > > Also, which one matches this dec_sock_node_page_state()? Clearly
> > > not skb_fill_page_desc() or __skb_frag_ref().
> >
> > Yeah, we call inc_sock_node_page_state() in the skb_page_frag_refill().
>
> How is skb_page_frag_refill() possibly paired with __skb_frag_unref()?
>
> > So if someone gets the page returned by skb_page_frag_refill(), it must
> > put the page via __skb_frag_unref()/skb_frag_unref(). We use PG_private
> > to indicate that we need to dec the node page state when the refcount o=
f
> > page reaches zero.
>
> skb_page_frag_refill() is called on frags not within an skb, for instance=
,
> sk_page_frag_refill() uses it for a per-socket or per-process page frag.
> But, __skb_frag_unref() is specifically used for skb frags, which are
> supposed to be filled by skb_fill_page_desc() (page is allocated by drive=
r).
>
> They are different things you are mixing them up, which looks clearly
> wrong or at least misleading.

Yeah, it looks a little strange. I just want to account for page frag
allocations. So I have to use PG_private to distinguish the page
from page frag or others in the __skb_frag_unref(). If the page is
allocated from skb_page_frag_refill, we should decrease the
statistics.

Thanks.

>
> Thanks.



--=20
Yours,
Muchun
