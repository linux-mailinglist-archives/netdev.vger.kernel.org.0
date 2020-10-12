Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E260828AF63
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgJLHmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJLHms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:42:48 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F532C0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 00:42:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m17so16721485ioo.1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 00:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e5VG5wK84kKrdrvCjTeGkiyRx9C2ZrwL+s1ArEKKadQ=;
        b=gH4UHfk7+EsDB0g7VarNb/ZYNO10+OttrKc0yoGw5c7k6ayVzTN/IKevjdkPL+v3+3
         eh/Q+AOKbMEQKAQQakARO/UePJJMAtw0QYem95+ENlywE4f8Fx0Y3gMADb1DD7NTEWh0
         6XbiQVPMxB++vOsqCMibc/L8pVSSEvfiYVfzwVyX6OEscOdjkRbqtwtFr7bIybePTi39
         bIqPGRAqYvEcDJbc6QN92YPgTxwP/KhzU/XrsucqzJjAIIJws1Wmc2o7hiEsAXpXJYtu
         p3FFHPw53qWv8A0lKhKrMj9OuhINBpS9A81PZnFFCWd6tId/PSoAspOjwwSs+fBWTHDi
         mTPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e5VG5wK84kKrdrvCjTeGkiyRx9C2ZrwL+s1ArEKKadQ=;
        b=rUe/Pz9QkcDmqN6ehdatozeeCGfhry978E9xoy15N1GlxxwjnC3B75x9CSc4VitXT5
         je5P9nSagbLdleU6vAOONhhlE/KJv7Kt1kK6N0NoaYQ/hPFZErh9LYjVFWZsCgC/lFwy
         FB6B3WHPL7/nY5AkCYLRTqmgS9GJ26oap+QXdPTwaE1wHBXc84YOmRTGEZb+jmJGkwyp
         o7cYdLabSRAqCyLFhwlYUa/uvP+tWl9kx0S9jGcNw9LwM6BIE6M2i1eZEWtK8QS6ijYF
         913o37gOpEhco8MeQ8FTEil4ECam5NkWnNYILmaNxSfIsXjr+c16VgGZk+rYEh0LiJ9f
         ULkw==
X-Gm-Message-State: AOAM532Fyh/GGlYVStUKwagvr/dgx4+10xN+Vj6OMaX8oxoNHWAyPmiq
        4uIoRIBXJIfYfg13ZiJI0xd5g8kxvGNJDidqI9thDA==
X-Google-Smtp-Source: ABdhPJyLAEKXb/V0z8Sc1yAftRlthOIMiopejO4oj5Qv8BbgPH+8hwnRpR93RKKR1Wp3B/awtoePH7Xh2/hLRZBaHsQ=
X-Received: by 2002:a02:7350:: with SMTP id a16mr19138927jae.53.1602488567382;
 Mon, 12 Oct 2020 00:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com> <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
In-Reply-To: <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 12 Oct 2020 09:42:37 +0200
Message-ID: <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Muchun Song <songmuchun@bytedance.com>
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

On Mon, Oct 12, 2020 at 6:22 AM Muchun Song <songmuchun@bytedance.com> wrot=
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
> is that we still don=E2=80=99t know where the memory is consumed. And we =
add the
> Sock to the /proc/meminfo just like the memcg does('sock' item in the cgr=
oup
> v2 memory.stat). So I think that adding to /proc/meminfo is sufficient.
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
> So if someone gets the page returned by skb_page_frag_refill(), it must
> put the page via __skb_frag_unref()/skb_frag_unref(). We use PG_private
> to indicate that we need to dec the node page state when the refcount of
> page reaches zero.
>

Pages can be transferred from pipe to socket, socket to pipe (splice()
and zerocopy friends...)

 If you want to track TCP memory allocations, you always can look at
/proc/net/sockstat,
without adding yet another expensive memory accounting.
