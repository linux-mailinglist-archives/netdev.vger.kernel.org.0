Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4666C422DBA
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhJEQUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhJEQUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 12:20:18 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B05EC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 09:18:28 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x27so87776391lfa.9
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 09:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9pR87ZxffODNYHX3y8wIUUlOXsoFep7W3KkITUWQQdA=;
        b=TpNQeD0xD3/3W2Huts2s1yHnNDHO08/TvqGsxKknqz53fnCGeGEUqEVbfpYl1NdwF4
         xJpyZzE3P+DphdGWSaAERkfy6zE0yQxVQJzxFtwf2PG26X4bXpACjDTFkKxp99R+RSkM
         OtWyX3w8eTxmkzyy/0NhGAMfrer3tnjCwq++I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9pR87ZxffODNYHX3y8wIUUlOXsoFep7W3KkITUWQQdA=;
        b=nWqd6a9+aEdZN9/BqCY5TzyX2gsarEHCJ+rWxieukDNWWksvl8hgif0Fn/xyd5ITd5
         HQluRWwQBSVQjOtzl/Nvkrpctra38BWmvSLeA3uIqyPA0eB9eUacXmKl9byax99SWhnM
         HUBH5ROuy1RAThDKB9AnMU6lWrZGuMJ3Q6q3m8RyLC4T1UrhuqFkRxRFnsEePYpIuK2V
         CntHp5SW++ciePjFmIa/7lh18lGCIVnES73rX0H0xnv82CRvUGEYCceobWWF3Yy9TiU9
         T9R6M0h6zH6uTf8f18pmVTFW4C5Hw7sWig40QKkI51UvdOIzm4WGkbUA5G5AgLevZGfn
         FCig==
X-Gm-Message-State: AOAM532EaTDii2WGMqHCmxGoOrOxSFD1szyJMwlNnGxlhjqGgVrgv9+t
        Ug6rjPRx4KLZDTqDtBZf0Ut80JLOzj2KnmUx
X-Google-Smtp-Source: ABdhPJwPA8skLDHeE++NqOgFbv9DxU+yQbCX+WoIZR+DoeZDnbQUtJ+VlKJoXGXe3IYUSumSdqgYlQ==
X-Received: by 2002:a05:6512:3212:: with SMTP id d18mr4148329lfe.306.1633450706119;
        Tue, 05 Oct 2021 09:18:26 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id h17sm1993882lfg.258.2021.10.05.09.18.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:18:23 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id g41so88215256lfv.1
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 09:18:21 -0700 (PDT)
X-Received: by 2002:a05:6512:b8e:: with SMTP id b14mr4429467lfv.655.1633450701008;
 Tue, 05 Oct 2021 09:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211005094728.203ecef2@gandalf.local.home>
In-Reply-To: <20211005094728.203ecef2@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Oct 2021 09:18:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj0AJAv9o2sW7ReCFRaD+TatSiLMYjK=FzG9-X=q5ZWwA@mail.gmail.com>
Message-ID: <CAHk-=wj0AJAv9o2sW7ReCFRaD+TatSiLMYjK=FzG9-X=q5ZWwA@mail.gmail.com>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 6:47 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Also had to update a lot of the function pointer initialization in the
> networking code, as a function address must be passed as an argument in
> RCU_INIT_POINTER() and not just the function name, otherwise the following
> error occurs:

Ugh.

I think this is a sign of why we did it the way we did with that odd
"typeof(*p)*" thing in the first place.

The thing is, in any normal C, the function name should just stand in
for the pointer to the function, so having to add a '&' to get the
function pointer is somehow odd..

So I think you should just expose your type to anybody who uses a pointer to it.

               Linus
