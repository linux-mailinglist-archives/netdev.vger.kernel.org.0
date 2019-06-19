Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B281E4C417
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 01:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbfFSXZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 19:25:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43197 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfFSXZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 19:25:29 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so1319929ios.10
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 16:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zK1mBFGFSIEUT6yEnOKa5a8Rj/3QRywxbfnHokzPPhA=;
        b=tINeIAiWkiPJnUrv1Qn0AmopyBtnb9vxVhQ75d9oGc2LKOjFef6gfZJMvkY/zdUHki
         APitifZY0YM1RcV3eJQeVo/4iT4PPbUSXEk27v3mFp4YaCh30kgFsUHqblwb7gf176Yt
         24kFDMyI6q7kxWg5o4f1cwF3fo8q5Eg61i8P/DqoVL6k/QpE5Ce78fMDOsVpz8VZqPgv
         kY+CaziXQWkqTnn2X4G0VaLhsdPTegXtXyPT98miiYsJU1BDCrgM8aTYrZAm59pirJEH
         ooC6pYPDU6Jy/yDi1HZw7wDn9mQVCcd4dMp0DbS93KQA/rL4+qU0/+LRoVfdQr9pmZWR
         wmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zK1mBFGFSIEUT6yEnOKa5a8Rj/3QRywxbfnHokzPPhA=;
        b=gJmwxEwz6tsLMHXWI5jslFXTfVcOWO2NytIbvmk3PmRIFA/EyZJwUzSrumKnA0HmPL
         q7w1gZTyHBPSHA8NEpt8TJ1R3Wu9eDg6EvsFByKCPYMJhSqxJ1HBO47GDt2sOc7JiJ5v
         ALdj1/CE7n1TMR18gqV37+exd4Xg5karW3V7mYtuuLlIoqVYXjcfXG/EBEJmbzRLZvPm
         SIn4zQZ0bhQSnjqq32mPk2BNV5k2Jep0WW27TOHlBluRD57ZTV7MKJZjo1xrq6hU50SX
         rb4HeDqvN4Eg80wC6IVHaEMsXWrO0EzocjyNG5lC7+mDYSBqdy/UPzU7TvHKMt1XDxL3
         ClnQ==
X-Gm-Message-State: APjAAAUX77Er5NKUCmUDBOn8ka4sQVNr4p3htAleHSpFz8BuYdadcyg2
        f0pJFY8zRbfwQn9qzH5FpiW30wDrYH+Z9gELYziVEA==
X-Google-Smtp-Source: APXvYqytSpJcHvNqN549d2CsqIWmiaX2S9JY8MawQQeTwSQiYgaShv1pqjOfLiPMGv000VzQ+7sxRVF3h70Ap2N0S8Q=
X-Received: by 2002:a6b:cb07:: with SMTP id b7mr15583927iog.7.1560986728189;
 Wed, 19 Jun 2019 16:25:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190619223158.35829-1-tracywwnj@gmail.com> <20190619223158.35829-4-tracywwnj@gmail.com>
 <857851ee-c610-0b19-b5b1-1948bebe84ab@gmail.com>
In-Reply-To: <857851ee-c610-0b19-b5b1-1948bebe84ab@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 19 Jun 2019 16:25:16 -0700
Message-ID: <CAEA6p_AeFQb6H3+43_NgSEYTyo+9QePYG4OkjNih+LuAWs2GFg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/5] ipv6: honor RT6_LOOKUP_F_DST_NOREF in
 rule lookup logic
To:     David Ahern <dsahern@gmail.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 4:12 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/19/19 4:31 PM, Wei Wang wrote:
> > diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> > index bcfae13409b5..d22b6c140f23 100644
> > --- a/net/ipv6/fib6_rules.c
> > +++ b/net/ipv6/fib6_rules.c
> > @@ -113,14 +113,15 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
> >               rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
> >               if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
> >                       return &rt->dst;
> > -             ip6_rt_put(rt);
> > +             ip6_rt_put_flags(rt, flags);
> >               rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> >               if (rt->dst.error != -EAGAIN)
> >                       return &rt->dst;
> > -             ip6_rt_put(rt);
> > +             ip6_rt_put_flags(rt, flags);
> >       }
> >
> > -     dst_hold(&net->ipv6.ip6_null_entry->dst);
> > +     if (!(flags & RT6_LOOKUP_F_DST_NOREF))
> > +             dst_hold(&net->ipv6.ip6_null_entry->dst);
> >       return &net->ipv6.ip6_null_entry->dst;
> >  }
> >
>
> What about the fib6_rule_lookup when CONFIG_IPV6_MULTIPLE_TABLES is
> configured off? If caller passes in RT6_LOOKUP_F_DST_NOREF that version
> is still taking a reference in the error path and does a put after the
> lookup.

True. I missed that part. Thanks for catching it. Will update.
