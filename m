Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66404F0B5
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFUWT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:19:26 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36152 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfFUWTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:19:25 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so192913ioh.3
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 15:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GUIYc3BMgWTMshibkat/P6qVD73AEtGAiNbNZGy+94A=;
        b=hUH8lXLIDuRbx+H0zOsupgKeLPpRhairMWi/eIU7M2OS0kktnkva2P2PsETD66Jxu1
         ZnWk1myyNeq5SIwl3wFYDmTwFXtGM167MbxDM9gnLmmwuB+ab/yRl/9kz7mG7ou2qLWj
         WhIIDQvw+sYujRuqvpd50E77357I2SOAvPY4UqSf5jdjtFdZJ7BKpRiBUHqJzIj6L8d/
         7g4nSdqMKAf0rAzGpbpfJ4szu7UA1s7duqdMhfuPVN6CXm3xdmlmaw1zfPrHGe0EChh2
         mhPXq6WEmjgZPySEPXCdS4U3yRiG4jYaPKaoR5eSe00jMAUq4zZ6lpuCuux9Mlj/Zezx
         Y9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GUIYc3BMgWTMshibkat/P6qVD73AEtGAiNbNZGy+94A=;
        b=fqjTYWOewESLlieqMeBxijp3Wb4K79BhUA6ziWRI85Pf8C82sX9lQEAn7Xh5zb9Zm2
         PYPZgmf0tzCjEsUy8gAgpQAIiwKj5CHw2WZiUy15Z1uQKVUOWHYbGxCbQxX91GzBD+uM
         ohverYDtgh4gQt5MXf2kCCWe5WGSeAnxunNqfQHZwEztMB8G/PtnOswWvxnMt8wHVxkA
         Vgh29z18lG8jtj3BO6oYAzydnupCEEHdnC3PD3/0iNdsjvcglfcHB/v8nfJR3Ke2FNWQ
         1QKkq139wRGiLQelG24eUQkBq3dI3PKI2T4TCQr3THNpm8SjKG+i8Eq+ORtmTG+bXAB1
         LSdg==
X-Gm-Message-State: APjAAAX4YLOjLOVik9eAdFCDHrR3O51bwyLGVfuiYEn+FptjaOQipdsS
        Z3hH51YFk7AIDqDN0+6sB73devUl
X-Google-Smtp-Source: APXvYqxJylcNQFRiq5Pn9FX86/PMYRKc+X9Q10tZTCJCSdtR4HGshx2Iakk4vV/ONOw9ZDnQ0W1kFQ==
X-Received: by 2002:a02:ac09:: with SMTP id a9mr28752202jao.48.1561155564602;
        Fri, 21 Jun 2019 15:19:24 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:563:6fa4:e349:a2f8? ([2601:284:8200:5cfb:563:6fa4:e349:a2f8])
        by smtp.googlemail.com with ESMTPSA id l11sm4910408ioj.32.2019.06.21.15.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 15:19:23 -0700 (PDT)
Subject: Re: [PATCH net-next v7 04/11] ipv4: Dump route exceptions if
 requested
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1561131177.git.sbrivio@redhat.com>
 <8d3b68cd37fb5fddc470904cdd6793fcf480c6c1.1561131177.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <542d653a-37c8-66b3-df34-71a0e0273f8b@gmail.com>
Date:   Fri, 21 Jun 2019 16:19:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <8d3b68cd37fb5fddc470904cdd6793fcf480c6c1.1561131177.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/19 9:45 AM, Stefano Brivio wrote:
> Since commit 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions."), cached
> exception routes are stored as a separate entity, so they are not dumped
> on a FIB dump, even if the RTM_F_CLONED flag is passed.
> 
> This implies that the command 'ip route list cache' doesn't return any
> result anymore.
> 
> If the RTM_F_CLONED is passed, and strict checking requested, retrieve
> nexthop exception routes and dump them. If no strict checking is
> requested, filtering can't be performed consistently: dump everything in
> that case.
> 
> With this, we need to add an argument to the netlink callback in order to
> track how many entries were already dumped for the last leaf included in
> a partial netlink dump.
> 
> A single additional argument is sufficient, even if we traverse logically
> nested structures (nexthop objects, hash table buckets, bucket chains): it
> doesn't matter if we stop in the middle of any of those, because they are
> always traversed the same way. As an example, s_i values in [], s_fa
> values in ():
> 
>   node (fa) #1 [1]
>     nexthop #1
>     bucket #1 -> #0 in chain (1)
>     bucket #2 -> #0 in chain (2) -> #1 in chain (3) -> #2 in chain (4)
>     bucket #3 -> #0 in chain (5) -> #1 in chain (6)
> 
>     nexthop #2
>     bucket #1 -> #0 in chain (7) -> #1 in chain (8)
>     bucket #2 -> #0 in chain (9)
>   --
>   node (fa) #2 [2]
>     nexthop #1
>     bucket #1 -> #0 in chain (1) -> #1 in chain (2)
>     bucket #2 -> #0 in chain (3)
> 
> it doesn't matter if we stop at (3), (4), (7) for "node #1", or at (2)
> for "node #2": walking flattens all that.
> 
> It would even be possible to drop the distinction between the in-tree
> (s_i) and in-node (s_fa) counter, but a further improvement might
> advise against this. This is only as accurate as the existing tracking
> mechanism for leaves: if a partial dump is restarted after exceptions
> are removed or expired, we might skip some non-dumped entries.

...

> 
> Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  include/net/route.h |  4 +++
>  net/ipv4/fib_trie.c | 44 +++++++++++++++++++--------
>  net/ipv4/route.c    | 73 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 108 insertions(+), 13 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


