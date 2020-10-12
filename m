Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4A628ACC2
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 06:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgJLEWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 00:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbgJLEWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 00:22:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051C8C0613D1
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 21:22:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b26so12378521pff.3
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 21:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=86h9GnvGBi5wC9xCp0mEaMT6C/YP6RZUf0IR+KiY+mM=;
        b=n5A3l84IVanhAXQ+RpWAMhL2/paRrC+kBPfk32SkjMJ3AMIe+3jVIqh5wck4Qd64RH
         OJ1A23lm7sibahUbKhN34W8lVpaxR2Sth1OKPcLb6ZGuB6MapkRU9HNBC3XkRM4rrB/L
         qkKvRFLA1BpjbDhEJv4NzLXFuijYW2r+o17N5n+k4+ZaLNoO3bpDGymp68ohPmNCfJ3Z
         33n6gE3eMLl3UD9fIFLUFcSbulpMADG+sOEVBQazltObrafBDS+pVXURv2NVG3AWKyVq
         BavLV2VLLjgz1sFHY7rqtk/5uidIKHx52b48F5hLddg4pbIQX6HpruoRh2OA+Ep8QMyS
         KNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=86h9GnvGBi5wC9xCp0mEaMT6C/YP6RZUf0IR+KiY+mM=;
        b=HA4B3VxhAToRr9MJoIyZqHkgQD8jtQWlGDEnFGnup0DZzHzV9UOWPAeiL3vwJWgQrZ
         pJKs23bMHM0nGcvez+IM50UKiKsqS/G2nEiIM53z2GikWSXP1y+2wIm/p5Y0bUUU/gf7
         xIZSJeRM0ShwMu6moBfmRBiU7GIQ82OzoZwj74mYDlQalkbgwi1RLTZwptJAJBKEk86z
         mvHfIitcrXMKbG+o+QXQ4CerRq7wnbN1DfRJXSNwBkdrzAGXWSSqCCH6VmhwqA9oTPKA
         3hwsYVOJQ5hjARIIH3jjyT/BNeMV8diAzhqVhoiUdL9TQAQycDzWze69Rymi/PSFEkpw
         1Jlw==
X-Gm-Message-State: AOAM533lvR6pdVRB8DooqqKEivTBPE8WT6CaBEvTtt4Pf/0IKd7vDVx5
        8nI92iCfR0tdkqyvonG9fJZouoPZ+crIl4WRkHU26w==
X-Google-Smtp-Source: ABdhPJxHHIJDJzppxANA9QNUbZw/HickM6E0AFMSiV9107EW+Zh0ghm7JqhHQ8xdMJzxoaSvB20+kIMEP4lWGOY6O1g=
X-Received: by 2002:a17:90a:890f:: with SMTP id u15mr18101013pjn.147.1602476572410;
 Sun, 11 Oct 2020 21:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com> <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Mon, 12 Oct 2020 12:22:16 +0800
Message-ID: <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
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

On Mon, Oct 12, 2020 at 2:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Oct 10, 2020 at 3:39 AM Muchun Song <songmuchun@bytedance.com> wr=
ote:
> >
> > The amount of memory allocated to sockets buffer can become significant=
.
> > However, we do not display the amount of memory consumed by sockets
> > buffer. In this case, knowing where the memory is consumed by the kerne=
l
>
> We do it via `ss -m`. Is it not sufficient? And if not, why not adding it=
 there
> rather than /proc/meminfo?

If the system has little free memory, we can know where the memory is via
/proc/meminfo. If a lot of memory is consumed by socket buffer, we cannot
know it when the Sock is not shown in the /proc/meminfo. If the unaware use=
r
can't think of the socket buffer, naturally they will not `ss -m`. The
end result
is that we still don=E2=80=99t know where the memory is consumed. And we ad=
d the
Sock to the /proc/meminfo just like the memcg does('sock' item in the cgrou=
p
v2 memory.stat). So I think that adding to /proc/meminfo is sufficient.

>
> >  static inline void __skb_frag_unref(skb_frag_t *frag)
> >  {
> > -       put_page(skb_frag_page(frag));
> > +       struct page *page =3D skb_frag_page(frag);
> > +
> > +       if (put_page_testzero(page)) {
> > +               dec_sock_node_page_state(page);
> > +               __put_page(page);
> > +       }
> >  }
>
> You mix socket page frag with skb frag at least, not sure this is exactly
> what you want, because clearly skb page frags are frequently used
> by network drivers rather than sockets.
>
> Also, which one matches this dec_sock_node_page_state()? Clearly
> not skb_fill_page_desc() or __skb_frag_ref().

Yeah, we call inc_sock_node_page_state() in the skb_page_frag_refill().
So if someone gets the page returned by skb_page_frag_refill(), it must
put the page via __skb_frag_unref()/skb_frag_unref(). We use PG_private
to indicate that we need to dec the node page state when the refcount of
page reaches zero.

Thanks.

>
> Thanks.



--=20
Yours,
Muchun
