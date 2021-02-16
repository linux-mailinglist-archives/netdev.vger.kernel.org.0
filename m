Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9467B31C52E
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBPBu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhBPBuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:50:51 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046DCC061756;
        Mon, 15 Feb 2021 17:50:11 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id i8so4354214iog.7;
        Mon, 15 Feb 2021 17:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ibaZrC5YhkL37zLqQ++PrXbCLj3UBTvSngl+kvK1TaQ=;
        b=l/YkXXXaHCHlTic+y7jeQve257p0nwkbR9VQ4W9ruGhtK6AtleTLxmSemzDbo7oIhq
         5N63sRAoKdzjGP2IKsE7J/u0P8dVGLA8WixSKMTfU93n1ydCosB7nNXvTqFhQYzz/QhZ
         jtrueqxB083tNyGIkJ1GG7feidOyIQ3M8OJ2AEW0y77vgxSGFNXdJ09d0pAXzjUlXrvg
         JrrY2mU0bAl6VJCsCbKks97aXD5Wkh/rEbWF3ucGOvGmXitAvI5T5oOwcfQFGD4P+GH/
         5XVfazximm5KSj9lKhxvZKEvDBUUZTmjmi2ab2MTyWvBIcRanJTnhS435CZ74EEVDFOS
         668Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ibaZrC5YhkL37zLqQ++PrXbCLj3UBTvSngl+kvK1TaQ=;
        b=QCvOaGorv7az2UapJgjvLqrdz3oSBXnuSu2/Zt8Mw1pCA59yKhLZqaoEEp9PHfhk6u
         EG+XKRKdZZGAPEKl5AV62OBCrAUgXa5zyIapkqpfSub0PEONDmn0sXsS+X3hgaxweWOh
         XjhrxP+Bmyuf/qRFXDL7aqMnlFb8sIFuoWS12eYyPs+lvGv+uvtc+BhKUfczgmWQoLdj
         p3alCUaYCF6Izj+UCpl4GHy8bFHHp325MxdwEOMATbKm7IwYaK6EqnAMzlH/U8Woa2wf
         5AYUXVvSbvhufzjc6O5gzfg7IvsTBG6X+1RyEmsmkB2605lzm8wYhzjkJfnjUkUhDM2s
         JTNg==
X-Gm-Message-State: AOAM533F4/8yhULa6w3r46ue8zD4kIvK2ulddfoQSXXt9S1RROs+YtDj
        lLA3L2QdckH6wbZFFu2rVuc=
X-Google-Smtp-Source: ABdhPJw07ZsxhkX2U8VPxinCrd/go0vo72Yc27EWjvbt/FThsWPkFUEqtgAwS9LHxwlAL+9Iwik/Eg==
X-Received: by 2002:a05:6638:2251:: with SMTP id m17mr17260835jas.102.1613440210505;
        Mon, 15 Feb 2021 17:50:10 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id t18sm9760558ioi.33.2021.02.15.17.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 17:50:10 -0800 (PST)
Date:   Mon, 15 Feb 2021 17:50:02 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602b24ca1fdca_51bf220832@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWzRpfWwZHPK=+KWbu+nLxJ=GKRHNC+97NT2DoN0qRc2A@mail.gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com>
 <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
 <CAM_iQpWufy-YnQnBf_kk_otLaTikK8YxkhgjHh_eiu8MA=0Raw@mail.gmail.com>
 <602b0a7046969_3ed41208dc@john-XPS-13-9370.notmuch>
 <CAM_iQpUomzGXdyjdCU8Ox-JZgQc=iZPZqs1UjRo3wxomf67_+A@mail.gmail.com>
 <602b17b0492a8_3ed41208f2@john-XPS-13-9370.notmuch>
 <CAM_iQpWzRpfWwZHPK=+KWbu+nLxJ=GKRHNC+97NT2DoN0qRc2A@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, Feb 15, 2021 at 4:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Mon, Feb 15, 2021 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > For TCP case we can continue to use CB and not pay the price. For UDP
> > > > and AF_UNIX we can do the extra alloc.
> > >
> > > I see your point, but specializing TCP case does not give much benefit
> > > here, the skmsg code would have to check skb->protocol etc. to decide
> > > whether to use TCP_SKB_CB() or skb_ext:
> > >
> > > if (skb->protocol == ...)
> > >   TCP_SKB_CB(skb) = ...;
> > > else
> > >   ext = skb_ext_find(skb);
> > >
> > > which looks ugly to me. And I doubt skb->protocol alone is sufficient to
> > > distinguish TCP, so we may end up having more checks above.
> > >
> > > So do you really want to trade code readability with an extra alloc?
> >
> > Above is ugly. So I look at where the patch replaces things,
> >
> > sk_psock_tls_strp_read(), this is TLS specific read hook so can't really
> > work in generic case anyways.
> >
> > sk_psock_strp_read(), will you have UDP, AF_UNIX stream parsers? Do these
> > even work outside TCP cases.
> >
> > For these ones: sk_psock_verdict_apply(), sk_psock_verdict_recv(),
> > sk_psock_backlog(), can't we just do some refactoring around their
> > hook points so we know the context. For example sk_psock_tls_verdict_apply
> > is calling sk_psock_skb_redirect(). Why not have a sk_psock_unix_redirect()
> > and a sk_psock_udp_redirect(). There are likely some optimizations we can
> > deploy this way. We've already don this for tls and sk_msg types for example.
> >
> > Then the helpers will know their types by program type, just use the right
> > variants.
> >
> > So not suggestiong if/else the checks so much as having per type hooks.
> >
> 
> Hmm, but sk_psock_backlog() is still the only one that handles all three
> above cases, right? It uses TCP_SKB_CB() too and more importantly it
> is also why we can't use a per-cpu struct here (see bpf_redirect_info).

Right, but the workqueue is created at init time where we will know the 
socket type based on the program/map types so can build the redirect
backlog queue there based on the type needed. I also have a patch in
mind that would do more specific TCP things in that code anyways. I
can flush it out this week if anyone cares. The idea is we are wasting
lots of cycles using skb_send_sock_locked when we can just inject
the packet directlyy into the tcp stack.

Also on the original patch here, we can't just kfree_skb() on alloc
errors because that will look like a data drop. Errors need to be
handled gracefully without dropping data. At least in the TCP case,
but probably also in UDP and AF_UNIX cases as well. Original code
was pretty loose in this regard, but it caused users to write bug
reports and then I've been fixing most of them. If you see more
cases let me know.

> 
> Thanks.


