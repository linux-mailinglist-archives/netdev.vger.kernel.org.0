Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9113A147194
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 20:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAWTPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 14:15:33 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40232 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgAWTPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 14:15:33 -0500
Received: by mail-pg1-f193.google.com with SMTP id k25so1846845pgt.7;
        Thu, 23 Jan 2020 11:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vJ5FBWMJIxYKYBCn8qREWN52UD82V6JInSqMU+i/JaQ=;
        b=UbX7mxXh9JwaXrImJU+LIzqSndebY4UVUnYFbrXZY0r+xry7j0fwlZmIF6UuvYCZnC
         3Of7U4/7aa39rohHALhSOe0A04STQSV/17w4TTzoZj9KFc8FT7aUMLeAwCw4PyEt2j7U
         wlM3O0V+E2hCQ/03F06OwkR2phPpYOVmAlfXdc6avAagQJlxZeDU/Cq8IwMmP1p7vgTE
         M9/cBDVUyYh+K5Z/o2ZFkU+FYc0qiUOG/TdEM3KpSRBTyhuXdKbO1Gg/OiCGl5/YjKfc
         GupZb/FSstJg19g+ZOYF2mJInadmtD8wIrENlS3L4C7+k2FOy15V9gAoOQsWFSntqeRi
         W53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vJ5FBWMJIxYKYBCn8qREWN52UD82V6JInSqMU+i/JaQ=;
        b=E0jDW962SgaVwj2Y9BPCe+it79rtC8iQEsXAqrQtsFLxz8hclJRYApbYOAa1XCruK9
         T2UzMsaBhCmgh1yVjlidYcZpk6oigCNF7QVeWhmBkEvoES0KSmRWy7CfdxstVzslnhTm
         uo5TXGhGVFKOneOVo1rIT+hr6fiLiZ/OjZGUCzYyO6U+B5YPhFpcFj8cc2BnnGhtn8gw
         H1lT6U5IdLL9IscZ3DHVynP2/lJtoyvcK3ML+XauZCtTkajhpwXZmSckBEEPHogXQoJt
         VE2hrr4ZIA10BQX0dGCBXE+VW7zBGTjAzxCjr9nTiKPsN/f2naj57pOpfhRaIhMzSQEH
         /AIQ==
X-Gm-Message-State: APjAAAXfFnSy0t0uw+MpGiHqiwpq43gP7QjV2zcD7JG1Ths9JpKA3qkd
        3Ob51Ug60thCfgS3FOhMVGM=
X-Google-Smtp-Source: APXvYqwbaFb+W0ir3zyNtH0Xybo/lwUQ0AwDedzrEQ41id21Wr2vFbVoVbK1y9z7IVlVV0c1WDOWUQ==
X-Received: by 2002:a65:6842:: with SMTP id q2mr279024pgt.345.1579806931972;
        Thu, 23 Jan 2020 11:15:31 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b12sm3546320pfi.157.2020.01.23.11.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 11:15:31 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:15:22 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Message-ID: <5e29f0caaec93_5aac2ad03f6d65c09b@john-XPS-13-9370.notmuch>
In-Reply-To: <874kwm2e8a.fsf@cloudflare.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
 <20200123155534.114313-3-jakub@cloudflare.com>
 <a6bf279e-a998-84ab-4371-cd6c1ccbca5d@gmail.com>
 <874kwm2e8a.fsf@cloudflare.com>
Subject: Re: [PATCH bpf-next v4 02/12] net, sk_msg: Annotate lockless access
 to sk_prot on clone
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Thu, Jan 23, 2020 at 06:18 PM CET, Eric Dumazet wrote:
> > On 1/23/20 7:55 AM, Jakub Sitnicki wrote:
> >> sk_msg and ULP frameworks override protocol callbacks pointer in
> >> sk->sk_prot, while tcp accesses it locklessly when cloning the listening
> >> socket, that is with neither sk_lock nor sk_callback_lock held.
> >>
> >> Once we enable use of listening sockets with sockmap (and hence sk_msg),
> >> there will be shared access to sk->sk_prot if socket is getting cloned
> >> while being inserted/deleted to/from the sockmap from another CPU:

[...]

> >>  include/linux/skmsg.h | 3 ++-
> >>  net/core/sock.c       | 5 +++--
> >>  net/ipv4/tcp_bpf.c    | 4 +++-
> >>  net/ipv4/tcp_ulp.c    | 3 ++-
> >>  net/tls/tls_main.c    | 3 ++-
> >>  5 files changed, 12 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> >> index 41ea1258d15e..55c834a5c25e 100644
> >> --- a/include/linux/skmsg.h
> >> +++ b/include/linux/skmsg.h
> >> @@ -352,7 +352,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
> >>  	psock->saved_write_space = sk->sk_write_space;
> >>
> >>  	psock->sk_proto = sk->sk_prot;
> >> -	sk->sk_prot = ops;
> >> +	/* Pairs with lockless read in sk_clone_lock() */
> >> +	WRITE_ONCE(sk->sk_prot, ops);
> >
> >
> > Note there are dozens of calls like
> >
> > if (sk->sk_prot->handler)
> >     sk->sk_prot->handler(...);
> >
> > Some of them being done lockless.
> >
> > I know it is painful, but presumably we need

Correct.

> >
> > const struct proto *ops = READ_ONCE(sk->sk_prot);
> >
> > if (ops->handler)
> >     ops->handler(....);
> 
> Yikes! That will be quite an audit. Thank you for taking a look.
> 
> Now I think I understand what John had in mind when asking for pushing
> these annotations to the bpf tree as well [0].

Yep this is what I meant. But your patches don't make the situation
any worse its already there.

> 
> Considering these are lacking today, can I do it as a follow up?

In my opinion yes. I think pulling your patches in is OK and I started
doing this conversion already so we can have a fix shortly. I didn't
want to push it into rc7 though so I'll push it next week or into
net-next tree.

.John
