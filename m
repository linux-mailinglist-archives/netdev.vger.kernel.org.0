Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C909531C4B7
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 01:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBPAy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 19:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBPAy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 19:54:57 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FD0C061574;
        Mon, 15 Feb 2021 16:54:17 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id o7so6993570ils.2;
        Mon, 15 Feb 2021 16:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ph3mOwHVPpKXEXZYhL56mG1mmUzrL9T3oJOTEWUtwdo=;
        b=iDzH8yMWgijAdlmH98Yb5n1DTfRleSNgV0jWDwd4HIC9Fwwx41+5sxC8dDXs7HMpc5
         2QElIhdWyEpff5E5bZfO+dDWlge7avf634PA2NXdvmKRlukykzCoNoMHAi+k3fom6C2z
         TMgOIJpiDYFJlCLXnsREqNmovs06hBwll0qUx5xz6EuBCc8apHCkQ3AFfQ9MA2p99kMp
         e6Jfh7p+4zm7iXZ13mcT4q+LRqSt3aBHZQx3Qn7CMKHVQ8mdY90dPYmsnOOd7jKi+e6U
         /fZ3e4wU7zyMveys4g+bhXIbaP1jr5K/6XhiXolLPr0CmHhBxBHAGTABfFg9Cra4waH/
         bQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ph3mOwHVPpKXEXZYhL56mG1mmUzrL9T3oJOTEWUtwdo=;
        b=n3EI+1uxoRkbrGOdgIEgw+k5P9AtmbNiKfF/2744/T0LDh3tA6QgG15/iqMbVuRmLY
         10dM3Am1J8w5cGEwXHx9rTngrTvFg7cMkZ3OK9SWz+gC0Jgvcq6RUqhpduXlNE+npfPO
         EomUmGqB49EjRefAGZ2X9+m+4ESAlGlGRIlOZ6FqdICht6R5nEHXb5bo+3pJconAADHV
         zAItAY8byhDEnkUK1z6yLMPf3iYBGmyn2GkoU/wB3AB3vOfYMme0fOY82DR1xDZrl1Q7
         2udjwkR0e68HVOZ2TY6lVG02PrJmu8PfcvCwPfFeTapmg/3jeI2w/crkkQ5eiTnHN6Vc
         USuQ==
X-Gm-Message-State: AOAM531vRWaY2eT74CgMxYb7bLG/CTRIYravfDc7xBo2nuNUxkJdPcMr
        pfY04GAvPgvOhTFY09aNKNs=
X-Google-Smtp-Source: ABdhPJzRYTiQJiPh49EZTMUPugBscyAJd4Hu8AkMIT5PYmcRxWdJxytNpA2xHQcbPYQy1DFu5q/whg==
X-Received: by 2002:a92:c7c7:: with SMTP id g7mr16310533ilk.304.1613436856514;
        Mon, 15 Feb 2021 16:54:16 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id k4sm32459ion.29.2021.02.15.16.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 16:54:15 -0800 (PST)
Date:   Mon, 15 Feb 2021 16:54:08 -0800
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
Message-ID: <602b17b0492a8_3ed41208f2@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpUomzGXdyjdCU8Ox-JZgQc=iZPZqs1UjRo3wxomf67_+A@mail.gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com>
 <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
 <CAM_iQpWufy-YnQnBf_kk_otLaTikK8YxkhgjHh_eiu8MA=0Raw@mail.gmail.com>
 <602b0a7046969_3ed41208dc@john-XPS-13-9370.notmuch>
 <CAM_iQpUomzGXdyjdCU8Ox-JZgQc=iZPZqs1UjRo3wxomf67_+A@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, Feb 15, 2021 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > For TCP case we can continue to use CB and not pay the price. For UDP
> > and AF_UNIX we can do the extra alloc.
> 
> I see your point, but specializing TCP case does not give much benefit
> here, the skmsg code would have to check skb->protocol etc. to decide
> whether to use TCP_SKB_CB() or skb_ext:
> 
> if (skb->protocol == ...)
>   TCP_SKB_CB(skb) = ...;
> else
>   ext = skb_ext_find(skb);
> 
> which looks ugly to me. And I doubt skb->protocol alone is sufficient to
> distinguish TCP, so we may end up having more checks above.
> 
> So do you really want to trade code readability with an extra alloc?

Above is ugly. So I look at where the patch replaces things,

sk_psock_tls_strp_read(), this is TLS specific read hook so can't really
work in generic case anyways.

sk_psock_strp_read(), will you have UDP, AF_UNIX stream parsers? Do these
even work outside TCP cases.

For these ones: sk_psock_verdict_apply(), sk_psock_verdict_recv(),
sk_psock_backlog(), can't we just do some refactoring around their
hook points so we know the context. For example sk_psock_tls_verdict_apply
is calling sk_psock_skb_redirect(). Why not have a sk_psock_unix_redirect()
and a sk_psock_udp_redirect(). There are likely some optimizations we can
deploy this way. We've already don this for tls and sk_msg types for example.

Then the helpers will know their types by program type, just use the right
variants.

So not suggestiong if/else the checks so much as having per type hooks.

> 
> >
> > The use in tcf_classify_ingress is a miss case so not the common path. If
> > it is/was in the common path I would suggest we rip it out.
> >
> 
> Excellent point, what about nf_bridge_unshare()? It is a common path
> for bridge netfilter, which is also probably why skb ext was introduced
> (IIRC). secpath_set() seems on a common path for XFRM too.

Yeah not nice, but we don't use nf_bridge so doesn't bother me.

> 
> Are you suggesting to remove them all? ;)

From the hotpath where I care about perfromance yes. 

> 
> Thanks.


