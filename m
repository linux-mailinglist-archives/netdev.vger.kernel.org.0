Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990CF5A2B71
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344166AbiHZPlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245401AbiHZPlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:41:02 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1035D985B1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:41:01 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-33dc345ad78so45649967b3.3
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1OeVCe7RaC1doJu8eezLP4PkgFav37cmMol81u4t9l0=;
        b=MmNYu02+TEx7oRzWlw+ehFBhs7toHqKt7pfFMKOKRkCWHoyj0Y/s6qC1e8CE/JnZiY
         hPtSEled9vImo8EDhazJXl9f8iX8B4+TZ8zmzARN2foW7NNOcE2CdXDHjt9HLUb/NvM2
         Ti7Ke7ucWlAzJr4UJ36P+lFfsL/DM4cciKV4YnQDPabmqsw+sqUfvf8dK31QW1Aqlp5A
         Ounvl8oZNElLyPqJCyKpa8bPzrkrRHeVAdAm1mZCXz3j+/FbLk+cZN4i7o703opbAT68
         1R9fW8BxF45+P8/2Ns30oQZvvi+fCtYklKi51GtFAn7R7MrrmmAqqZVR8B6tRmzi8Hrj
         RzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1OeVCe7RaC1doJu8eezLP4PkgFav37cmMol81u4t9l0=;
        b=cart/+SkTqzh3eiSg9eVUfqCoqnBTtntvPglYP2IRLsYhZiCUY0zBZGHRUvcrZvv72
         JT/+HrMmaKMKastqEqdqA0ViBf2lbkZex8+kFO5KH1Owu+l+PiH1wqPscQ5dG9buM141
         v+lBSeAOEqjbf+JzTmNPOVdfO+ZNnG/AQg7VghM0nhG0/SOvuF27s+WIbk1VIOEafsNb
         +gS4OBUiZkngytvr+Jy9X5ZcxjWVQZa+FyfbEwSf0092fnNNyq8azAbz3oobGFpNnj2s
         hW9UvTXb+iHbYhIb3k8ItWLLR+bI8yEmd8oBEFulyiZ6BdqoFrUg2GkWPNs7gFMb/Cg0
         YKww==
X-Gm-Message-State: ACgBeo0d8EXwUvXooTYA0TbsL2ElYur5FVRwvA/dX5/u9MwEd8DIx0LB
        r4u8MV9SSvK8oar72Cb8b98eYVVctOmeCzilFFMs3Q==
X-Google-Smtp-Source: AA6agR4I1vZ9aaSEGsy2SZ/FjScv9ilUOm+xccAKfebF59/l6wZY5nub/hAQqwvV1BFhnhGhnmcf87Yc2PEUxefCdzI=
X-Received: by 2002:a25:4291:0:b0:696:56f3:5934 with SMTP id
 p139-20020a254291000000b0069656f35934mr229910yba.55.1661528460963; Fri, 26
 Aug 2022 08:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220826000445.46552-1-kuniyu@amazon.com> <20220826000445.46552-7-kuniyu@amazon.com>
In-Reply-To: <20220826000445.46552-7-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 08:40:49 -0700
Message-ID: <CANn89iK0FeokqWLPrWY8iger7iYXU5fJQyxaGbGecTe11+8p7A@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 06/13] tcp: Set NULL to sk->sk_prot->h.hashinfo.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> We will soon introduce an optional per-netns ehash.
>
> This means we cannot use the global sk->sk_prot->h.hashinfo
> to fetch a TCP hashinfo.
>
> Instead, set NULL to sk->sk_prot->h.hashinfo for TCP and get
> a proper hashinfo from net->ipv4.tcp_death_row->hashinfo.
>
> Note that we need not use sk->sk_prot->h.hashinfo if DCCP is
> disabled.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/inet_hashtables.h   | 10 ++++++++++
>  net/ipv4/af_inet.c              |  2 +-
>  net/ipv4/inet_connection_sock.c |  6 +++---
>  net/ipv4/inet_hashtables.c      | 14 +++++++-------
>  net/ipv4/tcp_ipv4.c             |  2 +-
>  net/ipv6/tcp_ipv6.c             |  2 +-
>  6 files changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 44a419b9e3d5..2c866112433e 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -170,6 +170,16 @@ struct inet_hashinfo {
>         struct inet_listen_hashbucket   *lhash2;
>  };
>
> +static inline struct inet_hashinfo *inet_get_hashinfo(const struct sock *sk)
> +{
> +#if IS_ENABLED(CONFIG_IP_DCCP)
> +       return sk->sk_prot->h.hashinfo ? :
> +               sock_net(sk)->ipv4.tcp_death_row->hashinfo;
> +#else
> +       return sock_net(sk)->ipv4.tcp_death_row->hashinfo;
> +#endif
> +}
>

If the sk_prot->h.hashinfo must disappear, I would rather add a new
inet->hashinfo field

return inet_sk(sk)->hashinfo

Conceptually, the pointer no longer belongs to sk_prot, and not in struct net,
otherwise you should name this helper   tcp_or_dccp_get_hashinfo() to avoid
any temptation to use it for other inet protocol.
