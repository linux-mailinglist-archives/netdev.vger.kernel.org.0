Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAE2140221
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 03:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389001AbgAQC7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 21:59:18 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41696 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388862AbgAQC7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 21:59:18 -0500
Received: by mail-yb1-f194.google.com with SMTP id z15so5571417ybm.8
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 18:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tE4RcTCOdy9r/c37ywp8VrJ8G05YUX6hM4fVE5bn9wk=;
        b=t78sQ1A94BMSu9SUwfWjoDIaiq5rYrd8JGmy7643qtfg+dkP47/dCF6u3tJzSKXYME
         sKB/bOXi3p9WfvZQNPyr2G6rRg/HXcITCYtT4MFF+RB+9UPeAMQuQcIRTS2IHNVxwhEF
         g4RxYdw/AoF5r6twsePFkQfRoaiVShn//xy3N4GFhSIdXNksN/cijwlVph+IfLHhTBil
         JYqDTM8D4kCaHiGmTseBhP5OUN3cf+24Ml3BN/8jiMLf7ZKh0acsJ8ieHLwnmb7njnbN
         ntYlp1asYd160pvmbius38b/xg2KDuZ8n17t8eG8ufq1ucLtdRg4n3ajupCiR3oGk8TV
         UrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tE4RcTCOdy9r/c37ywp8VrJ8G05YUX6hM4fVE5bn9wk=;
        b=NGz+LgCZYCUwDTBN2Kq4BCw0F9K1oXlRi8gPUjH2fckRtUiYr6wmBEJDtMxXWpWpvX
         eGkk6Z6gVnAgSRtjV6SLpuOeOoCI1jQfy11ueT5RxDIWKbv6gakD8Np9XQl/ENIwcXPd
         vVzKmQJVt3hxuN41PJGSKzsLOZgyu0+7z5O9Yziz/xBlDA1a9OzX7EkHZwhFjQ8G12Yr
         AQBgdCBTbIJXtVUKeZ4DG7KatJQzvdXkcuezJs43mjwleZm2+RF5XO3uzD+5cMlZmv1M
         Q+i9Mz7fRdi4CxQVWYKiHYhKb6kRXQJhT4gdw50C+pfvJDPbyAmDqDY0OTLS1pBxPDpF
         o2pQ==
X-Gm-Message-State: APjAAAWZ3MXdR9Vno3jQLYmfdS82gRPHFF7m6ukh+xwLmvvTlk8xvOHK
        khQqRA9fSIYly7T9nHbW0rRLWEh8NTWPFob/VY1MXg==
X-Google-Smtp-Source: APXvYqxivm3L4c2JBKkBcmWC3XyL0c/q9KAQ+JkK/qxS5w219GsyexH9hyYsZurMvoD6j9uTAsqVqHXRyioCt0jwlKU=
X-Received: by 2002:a05:6902:6c4:: with SMTP id m4mr29650958ybt.274.1579229956712;
 Thu, 16 Jan 2020 18:59:16 -0800 (PST)
MIME-Version: 1.0
References: <5cfa925ff7394e10bbbf5132e44cbea4@baidu.com>
In-Reply-To: <5cfa925ff7394e10bbbf5132e44cbea4@baidu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Jan 2020 18:59:04 -0800
Message-ID: <CANn89iKyw-xBP8Ao7TRZ0bE++0JP5g7dwkY8SL9JRYB4VY+waQ@mail.gmail.com>
Subject: Re: [RFC] tcp: remove BUG_ON in tcp_shifted_skb
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 6:03 PM Li,Rongqing <lirongqing@baidu.com> wrote:
>
> I think this BUG_ON in tcp_shifted_skb maybe be triggered if a GSO skb is
> sacked, but sack is faked, and not ack the whole mss length, only ack less
> than mss length
>
> Is it possible ?

I doubt it. Please provide a packetdrill test if you think otherwise.

>
> - Li RongQing <lirongqing@baidu.com>
>
> ---
>  net/ipv4/tcp_input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 1d1e3493965f..141bc85092b5 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1327,7 +1327,8 @@ static bool tcp_shifted_skb(struct sock *sk, struct sk_buff *prev,
>         TCP_SKB_CB(prev)->sacked |= (TCP_SKB_CB(skb)->sacked & TCPCB_EVER_RETRANS);
>
>         if (skb->len > 0) {
> -               BUG_ON(!tcp_skb_pcount(skb));

I understand people can be worried about BUG_ON(), but they serve to
spot bugs when a patch breaks something horribly.
