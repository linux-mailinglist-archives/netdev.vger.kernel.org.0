Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049B7415D04
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240653AbhIWLtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238930AbhIWLtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 07:49:08 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F37C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 04:47:37 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id f130so20970175qke.6
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 04:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5q4Q0naikJ3U5wGiMvQKb9E4gch+MACgCJ4ofFGfM0=;
        b=CEH2FkNz7FYz8p9aGi3j4nq9KkH7fQWudfbUsWh3XWNrD1EXDnPuz74TC8yoAu2XVO
         NnQSYCO//oyWdM/a5Dm/aNX31E6SlKEQjMOC3KXQZ0JIMmSZCTCCzpwMjQqKDOylxL3+
         Gy7yUqcjdaOAUXjnv+s7608EgRwji7aKg35yxWswRHMAQEK3YhJghchL8h5c056GPCqx
         TAo6i2rwVPZTz8BCAy5NcFT3aE19GxfDy8IcdHkxcH7NCgOfXpFnxwuzqmn4JEcmemrQ
         j8+DSincvKzfd3Sq1KwQ25KpCoY33lJAHMp80jedyervndLDH9pS/H3yN5/3z8BZCKPi
         SSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f5q4Q0naikJ3U5wGiMvQKb9E4gch+MACgCJ4ofFGfM0=;
        b=pnJq9Tkuj6n2AAM/Qb9rv9Uxmygt1BAhUAkkwpqCftAP9a1WRREjPwUArVngvupXfZ
         0+/OGyZYnMsK4NZmJbKRc/vq23q/5Odxub0M6RUNHxtSrEk67U2XFnYqg4aDS8gJ8IfV
         XicMc7VpetBqFTA+ivdu4R8/mdEBcOjhKAgpHdOBGtk6qqozaIQOFsKujv25sAj0b6BZ
         E3cu/WdXqWyq9vPEcuGacvhda+YgYcei1el1YfxBRTiol3AuPlkN0cf9LDkOeBQefIcm
         Vw83Fm6ZVy0vMUo/eXQ2hh4urJxBocv6se2+Fw16Q8ub12GgGNg+aGt+YiBQtdUxW1U9
         JbTw==
X-Gm-Message-State: AOAM5326hblpFyC8goX4FzPx/Xbzx6na+I5LCrUYOwF6Hu1weTGIbhIO
        3iKSUPjc/oOc+nVXPFP1m1VzT8TNuNUVWihLkPmdYw==
X-Google-Smtp-Source: ABdhPJwLLqnUaFZAORZ5Q3MAjaFmeajoEHsSPv22Q1Lx23MGL0NOtHPTqJryA3AIJc+i2XNlqHoRGi0UFbEiX9YEXlk=
X-Received: by 2002:a25:2f48:: with SMTP id v69mr5031072ybv.339.1632397656362;
 Thu, 23 Sep 2021 04:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-4-linyunsheng@huawei.com> <YUw78q4IrfR0D2/J@apalos.home>
 <b2779d81-4cb3-5ccc-8e36-02cd633383f3@huawei.com>
In-Reply-To: <b2779d81-4cb3-5ccc-8e36-02cd633383f3@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 23 Sep 2021 14:47:00 +0300
Message-ID: <CAC_iWj+yv8+=MaxtqLFkQh1Qb75vNZw30xcz2VTD-m37-RVp8A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/7] pool_pool: avoid calling compound_head() for
 skb frag page
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linuxarm@openeuler.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, memxor@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sept 2021 at 14:24, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/9/23 16:33, Ilias Apalodimas wrote:
> > On Wed, Sep 22, 2021 at 05:41:27PM +0800, Yunsheng Lin wrote:
> >> As the pp page for a skb frag is always a head page, so make
> >> sure skb_pp_recycle() passes a head page to avoid calling
> >> compound_head() for skb frag page case.
> >
> > Doesn't that rely on the driver mostly (i.e what's passed in skb_frag_set_page() ?
> > None of the current netstack code assumes bv_page is the head page of a
> > compound page.  Since our page_pool allocator can will allocate compound
> > pages for order > 0,  why should we rely on it ?
>
> As the page pool alloc function return 'struct page *' to the caller, which
> is the head page of a compound pages for order > 0, so I assume the caller
> will pass that to skb_frag_set_page().

Yea that's exactly the assumption I was afraid of.
Sure not passing the head page might seem weird atm and the assumption
stands, but the point is we shouldn't blow up the entire network stack
if someone does that eventually.

>
> For non-pp page, I assume it is ok whether the page is a head page or tail
> page, as the pp_magic for both of them are not set with PP_SIGNATURE.

Yea that's true, although we removed the checking for coalescing
recyclable and non-recyclable SKBs,   the next patch first checks the
signature before trying to do anything with the skb.

>
> Or should we play safe here, and do the trick as skb_free_head() does in
> patch 6?

I don't think the &1 will even be measurable,  so I'd suggest just
dropping this and play safe?

Cheers
/Ilias
>
> >
> > Thanks
> > /Ilias
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >>  include/linux/skbuff.h | 2 +-
> >>  net/core/page_pool.c   | 2 --
> >>  2 files changed, 1 insertion(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >> index 6bdb0db3e825..35eebc2310a5 100644
> >> --- a/include/linux/skbuff.h
> >> +++ b/include/linux/skbuff.h
> >> @@ -4722,7 +4722,7 @@ static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
> >>  {
> >>      if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
> >>              return false;
> >> -    return page_pool_return_skb_page(virt_to_page(data));
> >> +    return page_pool_return_skb_page(virt_to_head_page(data));
> >>  }
> >>
> >>  #endif      /* __KERNEL__ */
> >> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >> index f7e71dcb6a2e..357fb53343a0 100644
> >> --- a/net/core/page_pool.c
> >> +++ b/net/core/page_pool.c
> >> @@ -742,8 +742,6 @@ bool page_pool_return_skb_page(struct page *page)
> >>  {
> >>      struct page_pool *pp;
> >>
> >> -    page = compound_head(page);
> >> -
> >>      /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> >>       * in order to preserve any existing bits, such as bit 0 for the
> >>       * head page of compound page and bit 1 for pfmemalloc page, so
> >> --
> >> 2.33.0
> >>
> > .
> >
