Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEF110A046
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 15:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfKZObC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 09:31:02 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35647 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfKZObB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 09:31:01 -0500
Received: by mail-lf1-f65.google.com with SMTP id r15so11344412lff.2
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 06:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=m3VAzC04REtvRdC4NTMI5NgyS7VT/ppSQlPo/w6Lqfo=;
        b=NKRVAm2Q1VyiF3kshjtGC/+hVwXaouzTP62fz7E1vsIox+cuMyjvuYcFlQRRbfiWsO
         utwAUBc1mxzDXEpVRB9tRNKIm+lfRl45w6L8ymJjNrkd2aEXY6D5TeTGV/yjLDMQS3wZ
         qXSrCFLPX3zgT/FGazI4PQT+esLyTrLeYwzyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=m3VAzC04REtvRdC4NTMI5NgyS7VT/ppSQlPo/w6Lqfo=;
        b=EM+6ln2gjUBINIDGxpjmwJ3R6aURCeZTZONBe/oSegBmEk7t/osNzxm4DgpptfZnsO
         jz8OIjhbTAd+tKpIjv0haRfufX58FAN47XvBUZPm5vIputBlMt0ZHdYYZAEwDFAFvZSE
         Wy87c0HAaUtqMPQMFz/tiurcayKyHWXbO39RTma2J7GRml/PGYxgzAwhOb/r2a/b6Oe8
         STbj0zRWqNFjBgvK2yi08iz1EV5FvJQ8QtJCebc6ow1uoW6fPFfVqSmCzcnM7MXE6A94
         TqTrN9pOIt6UDXHC1U40Tiv7JtA4q19v1vOe89ChjjddW8CI9dljigK1XnKM37Cj9mlB
         +SLQ==
X-Gm-Message-State: APjAAAUM7v5TwFFBf/xCUA3i4//d6xHup2rwC/jJMy03yiszoWLEJBN4
        D4r13xIIKELLloIr7T+bJ+KUrw==
X-Google-Smtp-Source: APXvYqx5IIP8DVI3N/hQkkcjT8+IAdTi7AhBt+GhTzWMl17+OYbh+EEStU0hOx0zsJygHJCGCACJQw==
X-Received: by 2002:a19:6b04:: with SMTP id d4mr25434926lfa.10.1574778658815;
        Tue, 26 Nov 2019 06:30:58 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id s4sm5397414lfd.34.2019.11.26.06.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 06:30:58 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-6-jakub@cloudflare.com> <20191125012440.crbufwpokttx67du@ast-mbp.dhcp.thefacebook.com> <5ddb55c87d06c_79e12b0ab99325bc69@john-XPS-13-9370.notmuch> <87o8x0nsra.fsf@cloudflare.com> <20191125220709.jqywizwbr3xwsazi@kafai-mbp>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: Allow selecting reuseport socket from a SOCKMAP
In-reply-to: <20191125220709.jqywizwbr3xwsazi@kafai-mbp>
Date:   Tue, 26 Nov 2019 15:30:57 +0100
Message-ID: <87imn6ogke.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 11:07 PM CET, Martin Lau wrote:
> On Mon, Nov 25, 2019 at 11:40:41AM +0100, Jakub Sitnicki wrote:
>> On Mon, Nov 25, 2019 at 05:17 AM CET, John Fastabend wrote:
>> > Alexei Starovoitov wrote:
>> >> On Sat, Nov 23, 2019 at 12:07:48PM +0100, Jakub Sitnicki wrote:
>> >> > SOCKMAP now supports storing references to listening sockets. Nothing keeps
>> >> > us from using it as an array of sockets to select from in SK_REUSEPORT
>> >> > programs.
>> >> >
>> >> > Whitelist the map type with the BPF helper for selecting socket. However,
>> >> > impose a restriction that the selected socket needs to be a listening TCP
>> >> > socket or a bound UDP socket (connected or not).
>> >> >
>> >> > The only other map type that works with the BPF reuseport helper,
>> >> > REUSEPORT_SOCKARRAY, has a corresponding check in its update operation
>> >> > handler.
>> >> >
>> >> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >> > ---
>> >
>> > [...]
>> >
>> >> > diff --git a/net/core/filter.c b/net/core/filter.c
>> >> > index 49ded4a7588a..e3fb77353248 100644
>> >> > --- a/net/core/filter.c
>> >> > +++ b/net/core/filter.c
>> >> > @@ -8723,6 +8723,8 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
>> >> >  	selected_sk = map->ops->map_lookup_elem(map, key);
>> >> >  	if (!selected_sk)
>> >> >  		return -ENOENT;
>> >> > +	if (!sock_flag(selected_sk, SOCK_RCU_FREE))
>> >> > +		return -EINVAL;
> If I read it correctly,
> this is to avoid the following "if (!reuse)" to return -ENOENT,
> and instead returns -EINVAL for non TCP_LISTEN tcp_sock.
> It should at least only be done under the "if (!reuse)" then.

Yes, exactly. For an established TCP socket in SOCKMAP we would get
-ENOENT because sk_reuseport_cb is not set. Which is a bit confusing
since the map entry exists.

Returning -EINVAL matches the REUSEPORT_SOCKARRAY update operation
semantics for established TCP sockets.

But this is just about returning an informative error so you're
completely right that this should be done under "if (!reuse)" branch to
avoid the extra cost on the happy path.

> Checking SOCK_RCU_FREE to imply TCP_LISTEN is not ideal.
> It is not immediately obvious.  Why not directly check
> TCP_LISTEN?

I agree, it's not obvious. When I first saw this check in
reuseport_array_update_check it got me puzzled too. I should have added
an explanatory comment there.

Thing is we're not matching on just TCP_LISTEN. REUSEPORT_SOCKARRAY
allows selecting a connected UDP socket as a target as well. It takes
some effort to set up but it's possible even if obscure.

> Note that the SOCK_RCU_FREE check at the 'slow-path'
> reuseport_array_update_check() is because reuseport_array does depend on
> call_rcu(&sk->sk_rcu,...) to work, e.g. the reuseport_array
> does not hold the sk_refcnt.

Oh, so it's not only about socket state like I thought.

This raises the question - does REUSEPORT_SOCKARRAY allow storing
connected UDP sockets by design or is it a happy accident? It doesn't
seem particularly useful.

Either way, thanks for the explanation.

>
>> >>
>> >> hmm. I wonder whether this breaks existing users...
>> >
>> > There is already this check in reuseport_array_update_check()
>> >
>> > 	/*
>> > 	 * sk must be hashed (i.e. listening in the TCP case or binded
>> > 	 * in the UDP case) and
>> > 	 * it must also be a SO_REUSEPORT sk (i.e. reuse cannot be NULL).
>> > 	 *
>> > 	 * Also, sk will be used in bpf helper that is protected by
>> > 	 * rcu_read_lock().
>> > 	 */
>> > 	if (!sock_flag(nsk, SOCK_RCU_FREE) || !sk_hashed(nsk) || !nsk_reuse)
>> > 		return -EINVAL;
>> >
>> > So I believe it should not cause any problems with existing users. Perhaps
>> > we could consolidate the checks a bit or move it into the update paths if we
>> > wanted. I assume Jakub was just ensuring we don't get here with SOCK_RCU_FREE
>> > set from any of the new paths now. I'll let him answer though.
>>
>> That was exactly my thinking here.
>>
>> REUSEPORT_SOCKARRAY can't be populated with sockets that don't have
>> SOCK_RCU_FREE set. This makes the flag check in sk_select_reuseport BPF
>> helper redundant for this map type.
>>
>> SOCKMAP, OTOH, allows storing established TCP sockets, which don't have
>> SOCK_RCU_FREE flag and shouldn't be used as reuseport targets. The newly
>> added check protects us against it.
>>
>> I have a couple tests in the last patch for it -
>> test_sockmap_reuseport_select_{listening,connected}. Admittedly, UDP is
>> not covered.
>>
>> Not sure how we could go about moving the checks to the update path for
>> SOCKMAP. At update time we don't know if the map will be used with a
>> reuseport or a sk_{skb,msg} program.
> or make these checks specific to the sockmap's lookup path.
>
> digress a little from this patch,
> will the upcoming patches/examples show the use case to have both
> TCP_LISTEN and TCP_ESTABLISHED sk in the same sock_map?

No, we have no use for a map instance that mixes listening and
established TCP sockets that I know of.

I'm guessing you would like to avoid adding a new check on the fast-path
(at socket selection time) by filering out sockets in invalid state on
map update, like SOCKARRAY does.

I could imagine setting a flag at map creation time to put SOCKMAP in a
a certain mode. Storing just listening or just established sockets.

OTOH why restrict the user? If you are okay with not adding extra checks
on the happy path in sk_select_reuseport, I would opt for that.

Thanks,
Jakub
