Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F45449C157
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbiAZCab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbiAZCab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:30:31 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CE8C06161C;
        Tue, 25 Jan 2022 18:30:30 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id s5so35167443ejx.2;
        Tue, 25 Jan 2022 18:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x79rzXXTHBgOsXBjkeB1wHbZQHGb1pLifmwYG6i89Z4=;
        b=eOJzseNBdufi6hmKCoAY2brormzMtk1Dh5va9jpTk82VBmCbSQZO60H7e9r8UYMogA
         2XNoGTxKxRQug+NObU1SenjgwP0CJ6ZkIuVLc7Zng2mCPMsuk9gv4o+nqG9qNY31oOrW
         JTZviKuI5vCDbCqCiW5JQGpYWuZFrRqhkoT4CIhMoh3ZoMUZpOSygkV0G1CLv22nWjKu
         tMnaps4LrWqUrkXHuxbKsbXG4f6BCgXBmkjzW5SfpHkkQ5xHg9c+UmhMNSdtTkAY6UHm
         2TPXlolrgcm4SrjrL7y5as5t+On76F8xk2Yv1JmQcYZOg3+36qVcVUBRjyEHuhtnICy+
         zepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x79rzXXTHBgOsXBjkeB1wHbZQHGb1pLifmwYG6i89Z4=;
        b=AwZ9m0zShd1jIPWuXylyl0q5wNcIom2evfcwWxl+dfV+1qorE5NG/nvktI22bHv3o9
         pSqmCmnIkpDJGTqAtw4W7TjwfhxkWdkH1nQUayj85iWPBJ6P8os4lGodeUsua0jbvYwI
         aHy/dvrqpZvqhK52ixRWGm8/wdwzshz6Eu25EfF88A81TNSCMaXdzwZz5jBMJImVUl8H
         4+wBEqNG2OATzUr/egxfCGPRXNqxj17SzQkT3yjzvp4qkdFY7uL+k2yYNIxBmotk2If7
         v3OjmYNtfqiVxKJRqHLQ4OoHUrIXJwBEKTtACONuoIM2jo8NnonG+tJ1qxFFGC3bDgSU
         XEqQ==
X-Gm-Message-State: AOAM532UBvBYJe9xELD0oHsOJbS/0XgtYmPtjaSiLCrU9ZGNy4GLCgb4
        Y8wEJhmfsQIIMaE3exiVp1i4xu4JkYdtrrd3e1Q=
X-Google-Smtp-Source: ABdhPJzyWMrREgA3Nehm1ZII8CnRmp+4+hFgOb83EIvL2/ceDuCiG0gk5lRaWuwD4CwDXyBzPqVCflbheWZSkPYHpmw=
X-Received: by 2002:a17:907:3f24:: with SMTP id hq36mr15796903ejc.439.1643164229255;
 Tue, 25 Jan 2022 18:30:29 -0800 (PST)
MIME-Version: 1.0
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-3-imagedong@tencent.com> <b7834377-eb0f-f5df-f3b6-10525de7afca@gmail.com>
In-Reply-To: <b7834377-eb0f-f5df-f3b6-10525de7afca@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 26 Jan 2022 10:26:00 +0800
Message-ID: <CADxym3ZYPmNCf=bpgZCxU2Hnj37VgqR6fdf_S9yiTcY3Od2O7A@mail.gmail.com>
Subject: Re: [PATCH net-next 2/6] net: ipv4: use kfree_skb_reason() in ip_rcv_core()
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Paolo Abeni <pabeni@redhat.com>,
        talalahmad@google.com, haokexin@gmail.com,
        Kees Cook <keescook@chromium.org>, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 10:10 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
> > @@ -478,7 +483,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
> >                      IPSTATS_MIB_NOECTPKTS + (iph->tos & INET_ECN_MASK),
> >                      max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
> >
> > -     if (!pskb_may_pull(skb, iph->ihl*4))
> > +     if (!pskb_may_pull(skb, iph->ihl * 4))
>
> unrelated cleanup
>

Haha, you got me :/

> >               goto inhdr_error;
> >
> >       iph = ip_hdr(skb);
> > @@ -490,7 +495,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
> >       if (skb->len < len) {
> >               __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
> >               goto drop;
> > -     } else if (len < (iph->ihl*4))
> > +     } else if (len < (iph->ihl * 4))
>
> ditto
>
> >               goto inhdr_error;
> >
> >       /* Our transport medium may have padded the buffer out. Now we know it
>
