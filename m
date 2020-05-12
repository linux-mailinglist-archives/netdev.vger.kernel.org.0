Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D771CF6D2
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgELOQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730403AbgELOQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:16:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FF3C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 07:16:19 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g14so9489506wme.1
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=00m82nDOdB7w4DfvWFlh1hGcYgkyp7ab4WeJRauL9Sk=;
        b=hKb1HPi4/i81LebncV5YcAQkLuE1ffnkJaHONoN5XhBrkRvaePWz9db0TV1D2ffRv/
         9+eLMqMHyFrC7DG8HWig8gYwalhgnrrY2AzyiM6LuK8E8FWSDAJtR3rLilcHqE81Qnh8
         CqvUDW1X2PnWrpEV6Kh+PnYqpSbIZFw2iBsEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=00m82nDOdB7w4DfvWFlh1hGcYgkyp7ab4WeJRauL9Sk=;
        b=AtaHFTKPqhPJiwDAKjnZK6pBVqcAU3+dkv30az958b95XKj3K0a9j+pewcUln5aNP5
         pI75yhD0X0Chn2FqKS1wcYzxKa/TEQa8yQOvPKKdN/Z0u9k6Guz2AUpvfQ0E4ShpQJ3W
         M3JOiZbmyqzlFUTZdQ5nN/1mRWINvRbh1b5jTn++EWNb8ulEzOjYxHC6RKB7C3nGItg+
         wd0EK10QBXMIFTj4dZcsXnzbdTYtiQoVxN0Jy8OmV5mLFsHC4kbstlqA9FyMmpRwGdmA
         4O+uqtX8JRj7zjKEu6piimcLlcJ8Ans88ug3D1waq9D3RFsqYdUFzfZkdAgiFXZnl16t
         n+4g==
X-Gm-Message-State: AOAM530dp1rwfPUd04prcLjl+JBY5wFPeVQrTEdfXgY7b15h6PdXDHtT
        NfoiXDqNRmp0M2MLvHqQ5Eyn+Q==
X-Google-Smtp-Source: ABdhPJzjdvrksXRpK2eWRlCFxWkk4xHHtZpeFUKesV87sor5NePaLxncbLN9MTMJiXmQjIGYYbH15w==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr2424914wmb.22.1589292977867;
        Tue, 12 May 2020 07:16:17 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id o2sm24394275wmc.21.2020.05.12.07.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 07:16:17 -0700 (PDT)
References: <20200506125514.1020829-1-jakub@cloudflare.com> <20200506125514.1020829-3-jakub@cloudflare.com> <20200508070638.pqe73q4v3paxpkq5@kafai-mbp.dhcp.thefacebook.com> <87a72ivh6t.fsf@cloudflare.com> <20200508183928.ofudkphlb3vgpute@kafai-mbp.dhcp.thefacebook.com> <877dxivny8.fsf@cloudflare.com> <20200511185914.4oma2wbia4ukpfdr@kafai-mbp.dhcp.thefacebook.com> <874ksmuvcl.fsf@cloudflare.com> <20200511205435.mgjbkfndpi2sds6z@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
In-reply-to: <20200511205435.mgjbkfndpi2sds6z@kafai-mbp.dhcp.thefacebook.com>
Date:   Tue, 12 May 2020 16:16:16 +0200
Message-ID: <87zhadtf0v.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 10:54 PM CEST, Martin KaFai Lau wrote:
> On Mon, May 11, 2020 at 09:26:02PM +0200, Jakub Sitnicki wrote:
>> On Mon, May 11, 2020 at 08:59 PM CEST, Martin KaFai Lau wrote:
>> > On Mon, May 11, 2020 at 11:08:15AM +0200, Jakub Sitnicki wrote:
>> >> On Fri, May 08, 2020 at 08:39 PM CEST, Martin KaFai Lau wrote:
>> >> > On Fri, May 08, 2020 at 12:45:14PM +0200, Jakub Sitnicki wrote:
>> >> >> On Fri, May 08, 2020 at 09:06 AM CEST, Martin KaFai Lau wrote:
>> >> >> > On Wed, May 06, 2020 at 02:54:58PM +0200, Jakub Sitnicki wrote:
>> >>
>> >> [...]
>> >>
>> >> >> >> +		return -ESOCKTNOSUPPORT;
>> >> >> >> +
>> >> >> >> +	/* Check if socket is suitable for packet L3/L4 protocol */
>> >> >> >> +	if (sk->sk_protocol != ctx->protocol)
>> >> >> >> +		return -EPROTOTYPE;
>> >> >> >> +	if (sk->sk_family != ctx->family &&
>> >> >> >> +	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
>> >> >> >> +		return -EAFNOSUPPORT;
>> >> >> >> +
>> >> >> >> +	/* Select socket as lookup result */
>> >> >> >> +	ctx->selected_sk = sk;
>> >> >> > Could sk be a TCP_ESTABLISHED sk?
>> >> >>
>> >> >> Yes, and what's worse, it could be ref-counted. This is a bug. I should
>> >> >> be rejecting ref counted sockets here.
>> >> > Agree. ref-counted (i.e. checking rcu protected or not) is the right check
>> >> > here.
>> >> >
>> >> > An unrelated quick thought, it may still be fine for the
>> >> > TCP_ESTABLISHED tcp_sk returned from sock_map because of the
>> >> > "call_rcu(&psock->rcu, sk_psock_destroy);" in sk_psock_drop().
>> >> > I was more thinking about in the future, what if this helper can take
>> >> > other sk not coming from sock_map.
>> >>
>> >> I see, psock holds a sock reference and will not release it until a full
>> >> grace period has elapsed.
>> >>
>> >> Even if holding a ref wasn't a problem, I'm not sure if returning a
>> >> TCP_ESTABLISHED socket wouldn't trip up callers of inet_lookup_listener
>> >> (tcp_v4_rcv and nf_tproxy_handle_time_wait4), that look for a listener
>> >> when processing a SYN to TIME_WAIT socket.
>> > Not suggesting the sk_assign helper has to support TCP_ESTABLISHED in TCP
>> > if there is no use case for it.
>>
>> Ack, I didn't think you were. Just explored the consequences.
>>
>> > Do you have a use case on supporting TCP_ESTABLISHED sk in UDP?
>> > From the cover letter use cases, it is not clear to me it is
>> > required.
>> >
>> > or both should only support unconnected sk?
>>
>> No, we don't have a use case for selecting a connected UDP socket.
>>
>> I left it as a possiblity because __udp[46]_lib_lookup, where BPF
>> sk_lookup is invoked from, can return one.
>>
>> Perhaps the user would like to connect the selected receiving socket
>> (for instance to itself) to ensure its not used for TX?
>>
>> I've pulled this scenario out of the hat. Happy to limit bpf_sk_assign
>> to select only unconnected UDP sockets, if returning a connected one
>> doesn't make sense.
> OTOH, my concern is:
> TCP's SK_LOOKUP can override the kernel choice on TCP_LISTEN sk.
> UDP's SK_LOOKUP can override the kernel choice on unconnected sk but
> not the connected sk.
>
> It could be quite confusing to bpf user if a bpf_prog was written to return
> both connected and unconnected UDP sk and logically expect both
> will be done before the kernel's choice.
>

That's a fair point. I've been looking at this from the PoV of in-kernel
callers of udp socket lookup, which now seems wrong.

I agree it would a be surprising if not confusing UAPI. Will limit it to
just unconnected UDP in v3.

Thanks for raising the concern,
Jakub
