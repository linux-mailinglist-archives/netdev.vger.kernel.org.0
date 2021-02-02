Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0053A30C2DB
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhBBPBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbhBBPAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:00:31 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D157EC061786
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 06:59:50 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id m20so11796436ilj.13
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 06:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cKDGkdAH6hnP9LDv3OSd/rUwsKO2Hnsk5XLdUyUcTiA=;
        b=ZTxCza8R+qKMO5AULHOV6aqYudyKoCq1ldvPSstkJUe++vlUm6kwA0NSIjetUWvwOr
         hIFujVH9L2DNpz8drDLj/rv4R4u7/hc79IUf6YfKXT6oZXygc3b2U9r28iB6aIcPKEjU
         PILiKxbjOVyXEJwzZKbfzJfSBRqk0rHMk6V4WuCLHeuzEPuLwDeEHN/zVlefRb0vETXR
         hW8Uu2zuCqz/lC+Q8toxwcmf3CL8x+lwD9JbTbxDiMoadqfik9UFDkpZy21GupRbKIe+
         iNCoDj7W3qVQOFdsx9vI9u+OjevzmoDAl7NZHeeCimBgM3KOBcgEhJEXekuXfSA5WJvC
         EY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cKDGkdAH6hnP9LDv3OSd/rUwsKO2Hnsk5XLdUyUcTiA=;
        b=sfzBg9gfTyy5TWTVXRXm9knypSeKdRmkzr4/l4JlGPlEZIXa0cQ3NGFasgpq0ISvwh
         QzFBZhImcRT4Sj9v08I/AbjC+0dD6hWx4TBbZ0I1zt91LbhJSkwtW2URN2ZA/1fsoWNF
         diV9B/q6cr4VwgUxEAB6wkXtVWPUZSqrlvEbSj1uGbZDDPry1jnsqXdXp8JaA4iCvShq
         SLXAMit58LDIdNIQa2PNgi/bkJ+dNW19QAIma2eJC2JKPFVVlASRf7StwU6VnzrM2enc
         GK/YiTd1qYDZ5ea9ETU7E32sOIlRgIM9fyV0GOeFHVbEAW5ECw1h5RkWcyIcvVjG2S6l
         22zA==
X-Gm-Message-State: AOAM531+OT2WDdiEcnJFgaOGzt0hBojr/YKAPd4j/bedQpfAGaD1d4Kz
        cD+ntTema9CYj/1WKIs3XwfCuBLcD8a512uwr2uPyQ==
X-Google-Smtp-Source: ABdhPJwlgQNiDbpOt8/s7/PtFHiU3OsbyGtG9ixXUuXmc8Hbf0GbL6accU63MRrf6/lEOgiXrCFgbvKRS3t/0TSABik=
X-Received: by 2002:a05:6e02:1a89:: with SMTP id k9mr17243624ilv.68.1612277990062;
 Tue, 02 Feb 2021 06:59:50 -0800 (PST)
MIME-Version: 1.0
References: <20210202135544.3262383-1-leon@kernel.org> <CANn89iL4jGbr_6rr11nsHxmdh7uz=kqXuMhRb0nakWO3rBZwsQ@mail.gmail.com>
 <20210202145724.GA3264866@unreal>
In-Reply-To: <20210202145724.GA3264866@unreal>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 2 Feb 2021 15:59:38 +0100
Message-ID: <CANn89iJ1WYEfS-Pgzvec+54+3JQHCPSNdCfYaFkGYAEk3sGwmA@mail.gmail.com>
Subject: Re: [PATCH net 0/4] Fix W=1 compilation warnings in net/* folder
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        coreteam@netfilter.org, Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>,
        LKML <linux-kernel@vger.kernel.org>, lvs-devel@vger.kernel.org,
        Matteo Croce <mcroce@redhat.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 3:57 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Feb 02, 2021 at 03:34:37PM +0100, Eric Dumazet wrote:
> > On Tue, Feb 2, 2021 at 2:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Hi,
> > >
> > > This short series fixes W=1 compilation warnings which I experienced
> > > when tried to compile net/* folder.
> > >
> >
> > Ok, but we never had a strong requirement about W=1, so adding Fixes:
> > tag is adding
>
> I added because Jakub has checker that looks for Fixes lines in "net"
> patches.

Send this to net-next

As I stated, we never enforce W=1 compilation rule.

I understand we might want that for _future_ kernels.

>
> > unnecessary burden to stable teams all around the world.
>
> It is automatic.

I do receive a copy of all backports in my mailbox, whenever I am tagged.

I can tell you there is a lot of pollution.

>
> Thanks
