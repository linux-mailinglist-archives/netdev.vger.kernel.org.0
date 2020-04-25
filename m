Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D0E1B898C
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 23:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgDYVRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 17:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgDYVRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 17:17:36 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9D3C09B04D;
        Sat, 25 Apr 2020 14:17:36 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id w6so12962577ilg.1;
        Sat, 25 Apr 2020 14:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=DMTOydMpRriyk5poOOa/mWXO2SbWr0zgXFb+fmKpOOk=;
        b=aTc2WkqEkWRoJQ9XHZfrTRixADF+C0aie+v+pbxuGDyfDSKn/3Z+tpLJpXPD9Mk7UZ
         ZXAZSZ0SFkQ28v24pEz3HBEzHe+m1TnK9T10tOmFpLLBHx0BVG4G+13x4Ew8b56wrw0I
         W6hq6VkgyopKknJCtko/zs9ontu4d1gOghpuL/syCnhwLGOwRe0+B8ZL9v0BO20Z0YgX
         auJYSPlHUs0Cq8PrzF3MD1TsT67coPyFJUTCAVRfB3FgoAavQDDBh9W+kIqCaGbXwoam
         +2oBT83FjcMM54vRFL8CTW428ET2ZXpq5grTNeC7eAv/ER1dGRXEjbDm7rp7N9azOaU7
         av7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=DMTOydMpRriyk5poOOa/mWXO2SbWr0zgXFb+fmKpOOk=;
        b=Hs2WQ6JIXYLucuJOzCPREEnhB/2aGv4KkhdPM1VYm4DjoolMfCASp/G0kF6maJGdf5
         P7bZ8an66BSswr2+Iz9hN0aL8laprcwPbDnxMgO/UrMJN7QfVmySIL0JbHppjfZxdMME
         S0EK3yw1ZeXgof9mO8n+AalMlkilGTx7hiyNUi2lWyuRNZ+6KvsDqkB8cTE5cdQxu+QN
         dcgZVjlXc2meTD/ooN8Ta/5dzkSc99n6h2rwVzdsoUKgV8MMhZvNmyVEoK+Wr/DkxJc7
         mKzj77pFVOKHWmeIzUasQMq1qgvY4tAChganT2U+D22auQklpNVoi9Ci/oMYUXyWVETd
         pXnw==
X-Gm-Message-State: AGi0PuaxQaMuMQBKXd7Hpv4GnV6YQXnrLW3ATEpyAIo4SIet0awgRdyQ
        5JQqsQFgm7VO4vl6B5Sixsk=
X-Google-Smtp-Source: APiQypIGaKeQReVRW/j+PBEZREDTmR+YStA/ggA2K3eUkrKf0p/XvBt+0FYftodip/86Le1RgKBRaQ==
X-Received: by 2002:a92:5c57:: with SMTP id q84mr15092593ilb.203.1587849455802;
        Sat, 25 Apr 2020 14:17:35 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m22sm1141877iow.35.2020.04.25.14.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2020 14:17:34 -0700 (PDT)
Date:   Sat, 25 Apr 2020 14:17:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xin Tan <tanxin.ctf@gmail.com>
Message-ID: <5ea4a8e6c0482_144b2b0bbf3245c4b@john-XPS-13-9370.notmuch>
In-Reply-To: <87lfmjve1f.fsf@cloudflare.com>
References: <1587819040-38793-1-git-send-email-xiyuyang19@fudan.edu.cn>
 <87lfmjve1f.fsf@cloudflare.com>
Subject: Re: [PATCH] bpf: Fix sk_psock refcnt leak when receiving message
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Sat, Apr 25, 2020 at 02:50 PM CEST, Xiyu Yang wrote:
> > tcp_bpf_recvmsg() invokes sk_psock_get(), which returns a reference of
> > the specified sk_psock object to "psock" with increased refcnt.
> >
> > When tcp_bpf_recvmsg() returns, local variable "psock" becomes invalid,
> > so the refcount should be decreased to keep refcount balanced.
> >
> > The reference counting issue happens in several exception handling paths
> > of tcp_bpf_recvmsg(). When those error scenarios occur such as "flags"
> > includes MSG_ERRQUEUE, the function forgets to decrease the refcnt
> > increased by sk_psock_get(), causing a refcnt leak.
> >
> > Fix this issue by calling sk_psock_put() when those error scenarios
> > occur.
> >
> > Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> > Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> > ---

Thanks Xiyu and Xin. Please add a Fixes tag,

Fixes: e7a5f1f1cd000 ("bpf/sockmap: Read psock ingress_msg before sk_receive_queue")

> >  net/ipv4/tcp_bpf.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > index 5a05327f97c1..feb6b90672c1 100644
> > --- a/net/ipv4/tcp_bpf.c
> > +++ b/net/ipv4/tcp_bpf.c
> > @@ -265,11 +265,15 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
> >  	psock = sk_psock_get(sk);
> >  	if (unlikely(!psock))
> >  		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> > -	if (unlikely(flags & MSG_ERRQUEUE))
> > +	if (unlikely(flags & MSG_ERRQUEUE)) {
> > +		sk_psock_put(sk, psock);
> >  		return inet_recv_error(sk, msg, len, addr_len);
> > +	}
> >  	if (!skb_queue_empty(&sk->sk_receive_queue) &&
> > -	    sk_psock_queue_empty(psock))
> > +	    sk_psock_queue_empty(psock)) {
> > +		sk_psock_put(sk, psock);
> >  		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> > +	}
> >  	lock_sock(sk);
> >  msg_bytes_ready:
> >  	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
> 
> Thanks for the fix.
> 
> We can pull up the error queue read handling, that is the `flags &
> MSG_ERRQUEUE` branch, so that it happens before we grab a psock ref.
> 
> The effect is the same because now, if we hit the !psock branch,
> tcp_recvmsg will first check if user wants to read the error queue
> anyway.
> 
> That would translate to something like below, in addition to your
> changes.
> 
> WDYT?

Sure that seems slightly nicer to me. Xiyu do you mind sending a
v2 with that change.

Thanks again,
John

> 
> ---8<---
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 5a05327f97c1..99aa57bd1901 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -262,14 +262,17 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  	struct sk_psock *psock;
>  	int copied, ret;
> 
> +	if (unlikely(flags & MSG_ERRQUEUE))
> +		return inet_recv_error(sk, msg, len, addr_len);
> +
>  	psock = sk_psock_get(sk);
>  	if (unlikely(!psock))
>  		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> -	if (unlikely(flags & MSG_ERRQUEUE))
> -		return inet_recv_error(sk, msg, len, addr_len);
>  	if (!skb_queue_empty(&sk->sk_receive_queue) &&
>  	    sk_psock_queue_empty(psock))
> 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);


