Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2367262CF54
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiKQAH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiKQAH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:07:27 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623E01275E;
        Wed, 16 Nov 2022 16:07:26 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id n12so1057732eja.11;
        Wed, 16 Nov 2022 16:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2KqcLex0Wna/k+uOkprAwQoj9V7FF00fZktU/+rB1GY=;
        b=T+fR62zE0KCocOrum4DWcoefvDrvh0N2JJeN9EXKQGrVqAo3hg1MuXNYrD02QhYQ3N
         eoJuU2B3qUj5YAsG8SQnolki4YP/jd/M2f61giHWkB8WQfnL6AwymXqppQh7Dq8YLlrj
         2UVfQtX65YxG81SQ3CueXFc3Nkz6f7x7W2Z7Y1DAoP5RCM3SBlKp7R205an1bdUsU424
         7PEPyPSL4hHLELFbVinpqx7Gb6zEJsFo6iR1wgyIPYRlHOJxcFO6zP3GrtvqqK7aH7Zf
         JUGC8HQ2ZaFZW3iGarUU0EB7BOILI/Y3XUp8n7KGtV/MmyP11p4Vv27cI/G6iNz3YpL9
         uL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2KqcLex0Wna/k+uOkprAwQoj9V7FF00fZktU/+rB1GY=;
        b=SIvPw9Zp3BFTZXMAjI5gVG+Z3KCF/wZhyI342VHtBjSrLbkquP02ShFwv0qX0Iso7w
         E0bEq/thJPk5mVigTy4TRGHvpgltMprMn4ArJF7HRBImLc6EoxTl4A++ez0YAUvS6HyL
         bFUxteNd2au40bg0ipshdta8SrM+TBFX43jV7pk2+dSs0O2ZDVrJqeSbxp3A3jLSo1qI
         MQRgE0bfunuH6Zjgjs8awnAFNKbM/3m8u4lwbzagulpI+flOK6nJYN73wL0LPfOUTwHY
         9wAvrH6Kn1xLPQjIUpJiBr1ugA8W5/j+6sjMitUo86Y7nRPL5cqulXurHSfEhOBCWOGe
         pvSw==
X-Gm-Message-State: ANoB5pkJA090uK1jElBTuiuhMWlVPZl7C4iTNBn+q+9yydq8vsbYk+8+
        QNM5LDXealqg1YzU+gFGgWTaxVnzEW6e6OiLjVQ=
X-Google-Smtp-Source: AA0mqf5dfpdvFIp+6KRsDt+gvFaE4dtHWa0UCWkbmPOAb+HH7ZOIhuyWNTBMa7itWmmZ+WkyX5olAIdjNIGEPEuFQOA=
X-Received: by 2002:a17:906:b794:b0:7ae:6450:c620 with SMTP id
 dt20-20020a170906b79400b007ae6450c620mr171304ejb.270.1668643644136; Wed, 16
 Nov 2022 16:07:24 -0800 (PST)
MIME-Version: 1.0
References: <20221116222805.64734-1-kuniyu@amazon.com> <20221116222805.64734-3-kuniyu@amazon.com>
In-Reply-To: <20221116222805.64734-3-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 16 Nov 2022 16:07:13 -0800
Message-ID: <CAJnrk1b-hHSp6n89uC+0dDZKm+bmVm1fRVmwP2oYqKSea9phKQ@mail.gmail.com>
Subject: Re: [PATCH v2 net 2/4] dccp/tcp: Remove NULL check for prev_saddr in inet_bhash2_update_saddr().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        dccp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 2:29 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> When we call inet_bhash2_update_saddr(), prev_saddr is always non-NULL.
> Let's remove the unnecessary test.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Acked-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  net/ipv4/inet_hashtables.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 033bf3c2538f..d745f962745e 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -877,13 +877,10 @@ int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct soc
>
>         head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
>
> -       if (prev_saddr) {
> -               spin_lock_bh(&prev_saddr->lock);
> -               __sk_del_bind2_node(sk);
> -               inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep,
> -                                         inet_csk(sk)->icsk_bind2_hash);
> -               spin_unlock_bh(&prev_saddr->lock);
> -       }
> +       spin_lock_bh(&prev_saddr->lock);
> +       __sk_del_bind2_node(sk);
> +       inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
> +       spin_unlock_bh(&prev_saddr->lock);
>
>         spin_lock_bh(&head2->lock);
>         tb2 = inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
> --
> 2.30.2
>
