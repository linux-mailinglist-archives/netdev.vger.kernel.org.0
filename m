Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92AB483B01
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiADDfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiADDfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:35:38 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCECC061761;
        Mon,  3 Jan 2022 19:35:38 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id z9so73108363edm.10;
        Mon, 03 Jan 2022 19:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AuIuosmbbidkYClwyU4ykEf47p3eRp+JjfbfXY0TohU=;
        b=A/m+VR/Xhpl7be79AB6FrgPtrRayR5efg0jb4lsqknlTCcSinhoW9BixHm8+41Immy
         gcUGAZPKd7EG8+TW5kRa+58nlcIc5RxP8pEDo/QATzzWHQuGyeVXXsRXSHOpCRuO9iAN
         SlofQJzdA08XO54Z26EucUDQ3wv0XdzTFFB++B0pyOEvU2lZ7J7roUC6Pxq4B1OXy5yU
         Xl48xtz87SFyVCrkp31VZud3+X/vsBE+UVHyPKmbgUod8s+KJgexNduN5RrTUQUTliYg
         4UWgRwgDFk3JB//5fsvFWjbmoSp4lunsvC2Zrgdj/h3GcY/Yl9Bv8HleQt2EP7SJ8gQe
         9M9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AuIuosmbbidkYClwyU4ykEf47p3eRp+JjfbfXY0TohU=;
        b=ffB+MEQMB5xgTSwd5elZ8JzjgbQPOc3h5bwJA2ycFO2e3c6QQ3TZr8tSKPBC7VnFR9
         IrvQkozDjWdeRlIY7bu75/dwf9Drb7WnlArVKDPNCYjJrNPt5zhz/NjrVJ0H1B0F+FHT
         5GoWnIkQtCOy4hkWXyV3/ZIv0S2oDCcinbf0Gkg3OvAZguZbBN3xAZvS2Fd0wmVubVQ3
         wMZt0JrUSdifs4IAldP8cqKhXxFV1n14RBzBlpPKuU8Cw2lxQZhFf69EB4mWQtMnD0Mi
         t2XV4IKvb7RuiE5HPvwefRzcQdpNcfyangQK4BtIkjvBE3/0eoHSN80uRrYYjvxacPaB
         tlyQ==
X-Gm-Message-State: AOAM530pDo3kiytMk5XRaAeTk6Wgs524/ByjQ8TzA6Ybjr0AgPM8glrp
        0/zfDwD/OsQ2h/wwsXhZ896XhvsOF2FPXaVf11g=
X-Google-Smtp-Source: ABdhPJwSNrtBb+JNBS+ecbLQjAGlxEXAKSO9H72Ly8Ag8YrgENAswKor0vrKQuRUgyK9xWcDDC9ZqBb9bv6nDReOJPg=
X-Received: by 2002:a17:907:7e9e:: with SMTP id qb30mr36648397ejc.348.1641267336994;
 Mon, 03 Jan 2022 19:35:36 -0800 (PST)
MIME-Version: 1.0
References: <20211230093240.1125937-1-imagedong@tencent.com>
 <YdOnTcSBq8z961da@pop-os.localdomain> <810dd93c-c6a2-6f8b-beb9-a2119c1876fb@gmail.com>
 <YdO6fL24CpHs6ByL@pop-os.localdomain>
In-Reply-To: <YdO6fL24CpHs6ByL@pop-os.localdomain>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 4 Jan 2022 11:32:21 +0800
Message-ID: <CADxym3avO5N55mmEmqyaQaZyxsPrc7hnG9XhqwMC8Y0OwOMshA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/3] net: skb: introduce kfree_skb_with_reason()
 and use it for tcp and udp
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Ahern <dsahern@kernel.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        jonathan.lemon@gmail.com, alobakin@pm.me,
        Kees Cook <keescook@chromium.org>,
        Paolo Abeni <pabeni@redhat.com>, talalahmad@google.com,
        haokexin@gmail.com, Menglong Dong <imagedong@tencent.com>,
        atenart@kernel.org, bigeasy@linutronix.de,
        Wei Wang <weiwan@google.com>, arnd@arndb.de, vvs@virtuozzo.com,
        Cong Wang <cong.wang@bytedance.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, mungerjiang@tencent.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 11:09 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Jan 03, 2022 at 07:01:30PM -0700, David Ahern wrote:
> > On 1/3/22 6:47 PM, Cong Wang wrote:
> > > On Thu, Dec 30, 2021 at 05:32:37PM +0800, menglong8.dong@gmail.com wrote:
> > >> From: Menglong Dong <imagedong@tencent.com>
> > >>
> > >> In this series patch, the interface kfree_skb_with_reason() is
> > >> introduced(), which is used to collect skb drop reason, and pass
> > >> it to 'kfree_skb' tracepoint. Therefor, 'drop_monitor' or eBPF is
> > >> able to monitor abnormal skb with detail reason.
> > >>
> > >
> > > We already something close, __dev_kfree_skb_any(). Can't we unify
> > > all of these?
> >
> > Specifically?
> >
> > The 'reason' passed around by those is either SKB_REASON_CONSUMED or
> > SKB_REASON_DROPPED and is used to call kfree_skb vs consume_skb. i.e.,
> > this is unrelated to this patch set and goal.
>
> What prevents you extending it?
>

I think extending kfree_skb() with kfree_skb_reason() is more reasonable,
considering the goal of kfree_skb() and __dev_kfree_skb_any().

> >
> > >
> > >
> > >> In fact, this series patches are out of the intelligence of David
> > >> and Steve, I'm just a truck man :/
> > >>
> > >
> > > I think there was another discussion before yours, which I got involved
> > > as well.
> > >
> > >> Previous discussion is here:
> > >>
> > >> https://lore.kernel.org/netdev/20211118105752.1d46e990@gandalf.local.home/
> > >> https://lore.kernel.org/netdev/67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com/
> > >>
> > >> In the first patch, kfree_skb_with_reason() is introduced and
> > >> the 'reason' field is added to 'kfree_skb' tracepoint. In the
> > >> second patch, 'kfree_skb()' in replaced with 'kfree_skb_with_reason()'
> > >> in tcp_v4_rcv(). In the third patch, 'kfree_skb_with_reason()' is
> > >> used in __udp4_lib_rcv().
> > >>
> > >
> > > I don't follow all the discussions here, but IIRC it would be nice
> > > if we can provide the SNMP stat code (for instance, TCP_MIB_CSUMERRORS) to
> > > user-space, because those stats are already exposed to user-space, so
> > > you don't have to invent new ones.
> >
> > Those SNMP macros are not unique and can not be fed into a generic
> > kfree_skb_reason function.
>
> Sure, you also have the skb itself, particularly skb protocol, with
> these combined, it should be unique.

I thought about it before, but it's hard to use the reason in SNMP
directly. First,
the stats of SNMP are grouped, and the same skb protocol can use stats in
different groups, which makes it hard to be unique. Second, SNMP is used to
do statistics, not only drop statistics, which is a little different
from the goal here.
Third, it's not flexible enough to extend the new drop reason.

Thanks!
Menglong Dong

>
> Thanks.
