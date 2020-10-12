Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E38328B076
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgJLIkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgJLIkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:40:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE30CC0613CE
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 01:40:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id i2so13572094pgh.7
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 01:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nTI2YVEwOfgh9p+oFG+z1qgnrhBmz+BUoqQKcix3EZ0=;
        b=vqGvXRZVq1jW4sgEi8S0/sHNxlcmL0ZqERj4Pwa/WZ/ql0G1AeXGVR3f0CADFyveGx
         yE4XNBUehdPzqu2tIoeidrSoNM+0p+0j7cD6/4C60mkXbuwx65n9284S00AVMuCMxpzo
         uqC2OXUTVpLHQgjMfUzNeNti7tYU4VRki29c2wScgRT6DVhDhxHhld/yLPfdsOhNpiIT
         HjAcfMVzJE3T9Kbg0UMlUJz+JCT5AHgArYOkj2SUDhQXJV/3KxaCC79zC7ZAP/nVi9uH
         jN9YsFuUeBuLNATPATZ0u25+bWi/vJ+VL/CNOz+ep9qFyHAmUYLN9mhb4C6/FxmKGN2v
         G5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nTI2YVEwOfgh9p+oFG+z1qgnrhBmz+BUoqQKcix3EZ0=;
        b=TDybqCD20Y/+OScsPnUer1JE+1ji7yBHFu876eZQDFuSaJe5KZqVGBJBIB3PdiM/qy
         UToIoYfYNOfyEyleZZS3kBoxB1NU/pLuo8VQppyCUrYNsPKJd8mbgHC2V3JPkPiaT8hS
         NUQakXenCXMgEtjV5KAg/R0ZFbhiQXtauDI+by302m3br6RAQdKqoFOkAiGt4RYdFIez
         OXmSXkUEkUZ5FB/EXHB9qrFuIzb/NvHZsP3zKJuSnySPYTHjMqs+IjDY+hquW1fkpL2O
         1s/tel7jbnSUjQoXTqTKz6T1lmSGDYcvR4/wXR1yGUYiI6RUaxi/N6BkPsZy0RWYmz0m
         IIpQ==
X-Gm-Message-State: AOAM532tR+88mqQ47inQ1yB8hPJiYmKyPeQWwdqbgB8WkDXtPx82nqrt
        AXe7Zj1by3QYPX2Wk0CzTzcyThbadektw4hhR5xfiA==
X-Google-Smtp-Source: ABdhPJzNls6dEzlTfEwkc2JEA15IrxS4rfGeYvT3I9xltofknhxcsIMWp8gAk9p3+kZn0WPzJWpnMpGcH9se0bk2XaE=
X-Received: by 2002:a63:fd0a:: with SMTP id d10mr12237891pgh.273.1602492005028;
 Mon, 12 Oct 2020 01:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com> <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
In-Reply-To: <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Mon, 12 Oct 2020 16:39:28 +0800
Message-ID: <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Eric Dumazet <edumazet@google.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
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
        rppt@kernel.org, Sami Tolvanen <samitolvanen@google.com>,
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

On Mon, Oct 12, 2020 at 3:42 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Oct 12, 2020 at 6:22 AM Muchun Song <songmuchun@bytedance.com> wr=
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
> > is that we still don=E2=80=99t know where the memory is consumed. And w=
e add the
> > Sock to the /proc/meminfo just like the memcg does('sock' item in the c=
group
> > v2 memory.stat). So I think that adding to /proc/meminfo is sufficient.
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
> > So if someone gets the page returned by skb_page_frag_refill(), it must
> > put the page via __skb_frag_unref()/skb_frag_unref(). We use PG_private
> > to indicate that we need to dec the node page state when the refcount o=
f
> > page reaches zero.
> >
>
> Pages can be transferred from pipe to socket, socket to pipe (splice()
> and zerocopy friends...)
>
>  If you want to track TCP memory allocations, you always can look at
> /proc/net/sockstat,
> without adding yet another expensive memory accounting.

The 'mem' item in the /proc/net/sockstat does not represent real
memory usage. This is just the total amount of charged memory.

For example, if a task sends a 10-byte message, it only charges one
page to memcg. But the system may allocate 8 pages. Therefore, it
does not truly reflect the memory allocated by the above memory
allocation path. We can see the difference via the following message.

cat /proc/net/sockstat
  sockets: used 698
  TCP: inuse 70 orphan 0 tw 617 alloc 134 mem 13
  UDP: inuse 90 mem 4
  UDPLITE: inuse 0
  RAW: inuse 1
  FRAG: inuse 0 memory 0

cat /proc/meminfo | grep Sock
  Sock:              13664 kB

The /proc/net/sockstat only shows us that there are 17*4 kB TCP
memory allocations. But apply this patch, we can see that we truly
allocate 13664 kB(May be greater than this value because of per-cpu
stat cache). Of course the load of the example here is not high. In
some high load cases, I believe the difference here will be even
greater.

--=20
Yours,
Muchun
