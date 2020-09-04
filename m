Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA8025DE7D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgIDPuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgIDPql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:46:41 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C87CC061260;
        Fri,  4 Sep 2020 08:46:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id np15so5351459pjb.0;
        Fri, 04 Sep 2020 08:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=P3kdadb7or6VPI0n3EicueQkmOf+NTRhMs4WyoKsTS8=;
        b=L9UuAZYO63fn3JLL3ywvMMoxd5eBh4vocJvzFlIQy7Yi6HkPZ/GWG+zV6gRFlo30NR
         Oo8jbDoT7O79MrMbZEIolZphNLuZz1On53t9ny3aM1Y0bS8j5H84Drbb/7Nnn3nIHAU8
         mdxI2/l/klXwEua8206/fBJ0KSgzvHb72285Wk43WKUmni2z971vbJQHM1LzktI6mHEE
         yqQWjEmZZC3mIeJ3qqpE3giesqVMLgyb2f4qSBjmb09h1Irn0OUOF9QqLzQowG+fFGBQ
         dMjS3ogIMJD3vNAhSgNg1ylLQo4LiTdtiJGoOXK8SBobMltqBvSX1v7sUACll9BdXgha
         tM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=P3kdadb7or6VPI0n3EicueQkmOf+NTRhMs4WyoKsTS8=;
        b=MvaK4glYDuxGWF8t3TxtTlucTBZSBUEWwTNiAgKmGT0ti/YxQJYsVHA5qk6qUd3grX
         sjSZuowlX/gu6IhwI5nf/7O1fh2JkIdfkVAtIBG7Y+JnzxZIGAJYTYQL9HW7nmI0oFRg
         Cj+qMo065wWr+ERiEDyJK5ozacB6YXGioyM8Goubl/bJda4yLL4Ftn+AcwfDnxyVAjb/
         f5RZgC51pAsAZeNR7Y1f213D5/rt+Y8qezps91ZpErsimm8cbgMz4gyFd5RF4ZhYSFhe
         ORZqrRm/gmtQGwM38Uvn5AkVyj53dCy20Y0naiiAUiew3ped4H/AV56n3lniuHd6y94d
         DoHw==
X-Gm-Message-State: AOAM533htVjxTmr+9j31B5PJywrG+HZPvbwAO0XPpF4fckm76xVAwbF2
        ADDZO59CIm9z8dvEut6WyEc=
X-Google-Smtp-Source: ABdhPJy9bZWz1Upu/lBNU9Hd4PEA0NL8q01xlyoQkFXBRcT4qQARIH8TVQAKJIFKthZf3xrCUhu7tg==
X-Received: by 2002:a17:90b:4d10:: with SMTP id mw16mr8744069pjb.100.1599234395499;
        Fri, 04 Sep 2020 08:46:35 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y128sm6726949pfy.74.2020.09.04.08.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 08:46:34 -0700 (PDT)
Date:   Fri, 04 Sep 2020 08:46:27 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?TGF1cmEgR2FyY8OtYSBMacOpYmFuYQ==?= <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Message-ID: <5f5261535a32a_1932208c8@john-XPS-13-9370.notmuch>
In-Reply-To: <CAF90-WgMiJkFsZaGBJQVVrmQz9==cq22NErpcWuE7z-Q+A8PzQ@mail.gmail.com>
References: <cover.1598517739.git.lukas@wunner.de>
 <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
 <5f49527acaf5d_3ca6d208e3@john-XPS-13-9370.notmuch>
 <5f5078705304_9154c2084c@john-XPS-13-9370.notmuch>
 <CAF90-WgMiJkFsZaGBJQVVrmQz9==cq22NErpcWuE7z-Q+A8PzQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Laura Garc=C3=ADa Li=C3=A9bana wrote:
> Hi,
> =

> On Thu, Sep 3, 2020 at 7:00 AM John Fastabend <john.fastabend@gmail.com=
> wrote:
> >
> [...]
> >
> > I don't think it actualy improves performance at least I didn't obser=
ve
> > that. From the code its not clear why this would be the case either. =
As
> > a nit I would prefer that line removed from the commit message.
> >
> =

> It hasn't been proven to be untrue either.

huh? Its stated in the commit message with no reason for why it might
be the case and I can't reproduce it. Also the numbers posted show such a=

slight increase (~1%) its likely just random system noise.

Sorry maybe that was a joke? Just poured some coffee so might be missing =
it.

> =

> =

> [...]
> >
> > Do you have plans to address the performance degradation? Otherwise
> > if I was building some new components its unclear why we would
> > choose the slower option over the tc hook. The two suggested
> > use cases security policy and DSR sound like new features, any
> > reason to not just use existing infrastructure?
> >
> =

> Unfortunately, tc is not an option as it is required to interact with
> nft objects (sets, maps, chains, etc), more complex than just a drop.
> Also, when building new features we try to maintain the application
> stack as simple as possible, not trying to do ugly integrations.

We have code that interacts with iptables as well. How I read the
above is in your case you have a bunch of existing software and you
want something slightly faster. Even if its not as fast the 10%
overhead is OK in your case and/or you believe the overhead of all
the other components is much higher so it will be lost in the noise.

> I understand that you measure performance with a drop, but using this
> hook we reduce the datapath consistently for these use cases and
> hence, improving traffic performance.

I measured drops because it was the benchmark provided in the patch
series. Also it likely looks a lot like any DDOS that might be put
there. You mentioned security policies which should probably include
DDOS so I would expect drop performance to be at least a useful
metric even if its not the only or most important in your case.

Lets post a selftest that represents the use case so folks like
myself can understand and benchmark correctly. This gives the extra
benefit of ensuring we don't regress going forward and can add it
to CI.

> =

> Thank you for your time!=
