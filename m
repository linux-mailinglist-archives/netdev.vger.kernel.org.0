Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77352B9DF7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKSXKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgKSXKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 18:10:01 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D82C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:10:01 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id l14so6817454ybq.3
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iBfd+tlooPrLaeehxHIKJ1u8OEErsouszEIy8ewVhcM=;
        b=Qca1plPbvZtgNeORPQ2kD2DqCgTdfBGwLPpZ9uiHbBJzEWVCi3YBgiNfKjrAyAQFCv
         vnlyre3S9Fw+ES0dPQ/Phak6rmsPe9qlrdpbpiJsRvnCQbRXSx9BIykDUQhQ1OaLTotr
         ryiZErEr1Sw7lqWcYEzfeYe1wrx64mrRmeVc3786MKkPFGNE5b12qpF2dgOKQmjwq06L
         efd7FS1/3nrpxyqcLgxAYGOjvd6b5bbSvtQ46TE30SIDLI6H0e642T9LNsQRisTgM8hx
         CrhVqIe0eQ+JOeVsjO8yyIu4nxeZhtoUHd5aTDyaYr/2oTEFtodKGW499JJR3qu84eN0
         1jGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iBfd+tlooPrLaeehxHIKJ1u8OEErsouszEIy8ewVhcM=;
        b=oYztWD1N76Up9+z1w7Y7U7EZbvJz575kLRGHnPIHPQCTEyVbkk7ZhV5ZHdIN/9OphA
         DRbzxpLlLL5bKEJ/dklkNbIDLnkC7LuXsDatuk3p0Mwuj5IG2XqIiqriGNsDHiZfxAi4
         ko0JamMwE0etoKKEN/VEAQwltWUcvxwW6Eb57soqpbIJV1CTjXvV8WTYUZPaxW/NiL4k
         2Q51BkCjItXtYyZRGwpALFdVKyocjji3n5sNlbiOu0vAg1ubwtKBsd0srP6GqCtVkdBe
         i7+9Wl77Vuvgd0iOijy7TmPMhhwMNJ8Ssw5QWP+2PRHMC/VQuadaBAvjJcoFtsvdcDNn
         434w==
X-Gm-Message-State: AOAM532+NsxNxw4BPw1JYJufE8e4QHJRVLTtbsW/qAB0d/4ROnfAhoMH
        rKllQ2vGD+kUo8lIY4AvzcSUnWsv5NR6cyWiZlu13Q==
X-Google-Smtp-Source: ABdhPJwntx5yxZFlr+ABHZAtWno7pcNjvqssQwbKMZxMPeu/afiw8yhs6p5yIima6cX9q0Fjcs5qah3HyoAS42uPGV4=
X-Received: by 2002:a25:ac19:: with SMTP id w25mr21816652ybi.278.1605827400532;
 Thu, 19 Nov 2020 15:10:00 -0800 (PST)
MIME-Version: 1.0
References: <160582070138.66684.11785214534154816097.stgit@localhost.localdomain>
 <160582103106.66684.9841738004971200231.stgit@localhost.localdomain>
In-Reply-To: <160582103106.66684.9841738004971200231.stgit@localhost.localdomain>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 19 Nov 2020 15:09:48 -0800
Message-ID: <CAEA6p_BTAit9Y2h-9XaTTBdV6h6X4g0Ct5mOy1ZHfJiLD3y_Ww@mail.gmail.com>
Subject: Re: [net PATCH 1/2] tcp: Allow full IP tos/IPv6 tclass to be
 reflected in L3 header
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        Martin KaFai Lau <kafai@fb.com>, kernel-team@fb.com,
        Eric Dumazet <edumazet@google.com>, brakmo@fb.com,
        alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 1:23 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> An issue was recently found where DCTCP SYN/ACK packets did not have the
> ECT bit set in the L3 header. A bit of code review found that the recent
> change referenced below had gone though and added a mask that prevented the
> ECN bits from being populated in the L3 header.
>
> This patch addresses that by rolling back the mask so that it is only
> applied to the flags coming from the incoming TCP request instead of
> applying it to the socket tos/tclass field. Doing this the ECT bits were
> restored in the SYN/ACK packets in my testing.
>
> One thing that is not addressed by this patch set is the fact that
> tcp_reflect_tos appears to be incompatible with ECN based congestion
> avoidance algorithms. At a minimum the feature should likely be documented
> which it currently isn't.
>
> Fixes: ac8f1710c12b ("tcp: reflect tos value received in SYN to the socket")

Acked-by: Wei Wang <weiwan@google.com>

Thanks for catching this. I was under the wrong impression that the
ECT bits were marked in tos after the tcp layer. Upon a closer look,
it seems right now, it only gets marked in inet_sock(sk)->tos from
tcp_init_congestion_control() once.
I will submit a follow-up fix to make sure we include the lower 2 bits
in the reflection case as well.

> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  net/ipv4/tcp_ipv4.c |    5 +++--
>  net/ipv6/tcp_ipv6.c |    6 +++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index c2d5132c523c..c5f8b686aa82 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -981,7 +981,8 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
>         skb = tcp_make_synack(sk, dst, req, foc, synack_type, syn_skb);
>
>         tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
> -                       tcp_rsk(req)->syn_tos : inet_sk(sk)->tos;
> +                       tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
> +                       inet_sk(sk)->tos;
>
>         if (skb) {
>                 __tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
> @@ -990,7 +991,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
>                 err = ip_build_and_send_pkt(skb, sk, ireq->ir_loc_addr,
>                                             ireq->ir_rmt_addr,
>                                             rcu_dereference(ireq->ireq_opt),
> -                                           tos & ~INET_ECN_MASK);
> +                                           tos);
>                 rcu_read_unlock();
>                 err = net_xmit_eval(err);
>         }
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 8db59f4e5f13..3d49e8d0afee 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -530,12 +530,12 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
>                 rcu_read_lock();
>                 opt = ireq->ipv6_opt;
>                 tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
> -                               tcp_rsk(req)->syn_tos : np->tclass;
> +                               tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
> +                               np->tclass;
>                 if (!opt)
>                         opt = rcu_dereference(np->opt);
>                 err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt,
> -                              tclass & ~INET_ECN_MASK,
> -                              sk->sk_priority);
> +                              tclass, sk->sk_priority);
>                 rcu_read_unlock();
>                 err = net_xmit_eval(err);
>         }
>
>
