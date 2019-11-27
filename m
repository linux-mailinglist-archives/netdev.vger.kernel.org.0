Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C9610C01F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 23:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfK0WSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 17:18:48 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46359 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfK0WSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 17:18:48 -0500
Received: by mail-lj1-f194.google.com with SMTP id e9so26173403ljp.13
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 14:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=N9i7/kwHmsdrnsrzzGmT/NdLJq4ITCoOrsN4artmsBY=;
        b=Bt/1HKc6XEWiIz7FBmNJDCcEnGwSXYEJ9am4LLxnV2p7SK/x/wSvJ/aqBY++jpyWf3
         Oy0HtUYpY7L8yfS5MDmw6bRueTp5yT6Li9mUj0V/ezfOsaQsA5DqeVCyWaPKjhC2rvbp
         rHuXthQWuBrEiRzUALXkEBHhDje5lOtdt49X4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=N9i7/kwHmsdrnsrzzGmT/NdLJq4ITCoOrsN4artmsBY=;
        b=h9Ub7GqcGYAaveqeXr9hWl6l6hjnxnZVUXCYIwPT90xvdahfOSV1bCQk8t7n2ugpdL
         pj9tX+IaPl8llNBsQSHToyoxAvNFqCWTL4aoJ3StoPxQHZeYEMYo3FupI2L2wnxPUnax
         c6TSteWGN3CU82ljxXLVJN2PBKucaJ5MUwNeMOpSC8tAy1ai6sNkfnAi4QZSdKvFElwp
         7vKl0rKjvdKUTAoQWrHAiPT6FeblsPiBteJcWd4xb6r9YGtyLQqMRD4lk4kwo0gSREBQ
         Q9uKik8Z6sUq0UdCXkeQ/4/5nZulYpDZbLdkknuEKZHkvlv3sO/36X6z1OwZyqWd7Y/9
         40MQ==
X-Gm-Message-State: APjAAAUjSdQ17HOp5Mr0ekPrMfY3bYyjp4e4ewtsbLKIwjIlHf1p6CLl
        YghXVyqR7z/PzqGMo3lOR0MICA==
X-Google-Smtp-Source: APXvYqyW4l1cfzSiRkZcX/xmBe/xfLz6fj346OmuRkwEaBF7jXnfLOe99jcJQkGiGtv777yDnhD9iw==
X-Received: by 2002:a2e:8518:: with SMTP id j24mr29755410lji.13.1574893125662;
        Wed, 27 Nov 2019 14:18:45 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d4sm7455587lfi.32.2019.11.27.14.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 14:18:45 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-5-jakub@cloudflare.com> <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp> <87ftiaocp2.fsf@cloudflare.com> <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com> <5ddd7266c36aa_671a2b0b882605c04a@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin Lau <kafai@fb.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit psock or its ops on copy
In-reply-to: <5ddd7266c36aa_671a2b0b882605c04a@john-XPS-13-9370.notmuch>
Date:   Wed, 27 Nov 2019 23:18:44 +0100
Message-ID: <87a78hnet7.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 07:43 PM CET, John Fastabend wrote:
> Martin Lau wrote:
>> On Tue, Nov 26, 2019 at 04:54:33PM +0100, Jakub Sitnicki wrote:
>> > On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
>> > > On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
>> > > [ ... ]
>> > >
>> > >> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>> > >>  			sk->sk_prot = psock->sk_proto;
>> > >>  		psock->sk_proto = NULL;
>> > >>  	}
>> > >> +
>> > >> +	if (psock->icsk_af_ops) {
>> > >> +		icsk->icsk_af_ops = psock->icsk_af_ops;
>> > >> +		psock->icsk_af_ops = NULL;
>> > >> +	}
>> > >>  }
>> > >
>> > > [ ... ]
>> > >
>> > >> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
>> > >> +					  struct sk_buff *skb,
>> > >> +					  struct request_sock *req,
>> > >> +					  struct dst_entry *dst,
>> > >> +					  struct request_sock *req_unhash,
>> > >> +					  bool *own_req)
>> > >> +{
>> > >> +	const struct inet_connection_sock_af_ops *ops;
>> > >> +	void (*write_space)(struct sock *sk);
>> > >> +	struct sk_psock *psock;
>> > >> +	struct proto *proto;
>> > >> +	struct sock *child;
>> > >> +
>> > >> +	rcu_read_lock();
>> > >> +	psock = sk_psock(sk);
>> > >> +	if (likely(psock)) {
>> > >> +		proto = psock->sk_proto;
>> > >> +		write_space = psock->saved_write_space;
>> > >> +		ops = psock->icsk_af_ops;
>> > > It is not immediately clear to me what ensure
>> > > ops is not NULL here.
>> > >
>> > > It is likely I missed something.  A short comment would
>> > > be very useful here.
>> >
>> > I can see the readability problem. Looking at it now, perhaps it should
>> > be rewritten, to the same effect, as:
>> >
>> > static struct sock *tcp_bpf_syn_recv_sock(...)
>> > {
>> > 	const struct inet_connection_sock_af_ops *ops = NULL;
>> >         ...
>> >
>> >     rcu_read_lock();
>> > 	psock = sk_psock(sk);
>> > 	if (likely(psock)) {
>> > 		proto = psock->sk_proto;
>> > 		write_space = psock->saved_write_space;
>> > 		ops = psock->icsk_af_ops;
>> > 	}
>> > 	rcu_read_unlock();
>> >
>> >         if (!ops)
>> > 		ops = inet_csk(sk)->icsk_af_ops;
>> >         child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
>> >
>> > If psock->icsk_af_ops were NULL, it would mean we haven't initialized it
>> > properly. To double check what happens here:
>> I did not mean the init path.  The init path is fine since it init
>> eveything on psock before publishing the sk to the sock_map.
>>
>> I was thinking the delete path (e.g. sock_map_delete_elem).  It is not clear
>> to me what prevent the earlier pasted sk_psock_restore_proto() which sets
>> psock->icsk_af_ops to NULL from running in parallel with
>> tcp_bpf_syn_recv_sock()?  An explanation would be useful.
>>
>
> I'll answer. Updates are protected via sk_callback_lock so we don't have
> parrallel updates in-flight causing write_space and sk_proto to be out
> of sync. However access should be OK because its a pointer write we
> never update the pointer in place, e.g.
>
> static inline void sk_psock_restore_proto(struct sock *sk,
> 					  struct sk_psock *psock)
> {
> +       struct inet_connection_sock *icsk = inet_csk(sk);
> +
> 	sk->sk_write_space = psock->saved_write_space;
>
> 	if (psock->sk_proto) {
> 		struct inet_connection_sock *icsk = inet_csk(sk);
> 		bool has_ulp = !!icsk->icsk_ulp_data;
>
> 		if (has_ulp)
> 			tcp_update_ulp(sk, psock->sk_proto);
> 		else
> 			sk->sk_prot = psock->sk_proto;
> 		psock->sk_proto = NULL;
> 	}
>
> +
> +       if (psock->icsk_af_ops) {
> +               icsk->icsk_af_ops = psock->icsk_af_ops;
> +               psock->icsk_af_ops = NULL;
> +       }
> }
>
> In restore case either psock->icsk_af_ops is null or not. If its
> null below code catches it. If its not null (from init path) then
> we have a valid pointer.
>
>         rcu_read_lock();
> 	psock = sk_psock(sk);
>  	if (likely(psock)) {
>  		proto = psock->sk_proto;
>  		write_space = psock->saved_write_space;
>  		ops = psock->icsk_af_ops;
>  	}
>  	rcu_read_unlock();
>
>         if (!ops)
> 		ops = inet_csk(sk)->icsk_af_ops;
>         child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
>
>
> We should do this with proper READ_ONCE/WRITE_ONCE to make it clear
> what is going on and to stop compiler from breaking these assumptions. I
> was going to generate that patch after this series but can do it before
> as well. I didn't mention it here because it seems a bit out of scope
> for this series because its mostly a fix to older code.

+1, looking forward to your patch. Also, as I've recently learned, that
should enable KTSAN to reason about the psock code [0].

> Also I started to think that write_space might be out of sync with ops but
> it seems we never actually remove psock_write_space until after
> rcu grace period so that should be OK as well and always point to the
> previous write_space.
>
> Finally I wondered if we could remove the ops and then add it back
> quickly which seems at least in theory possible, but that would get
> hit with a grace period because we can't have conflicting psock
> definitions on the same sock. So expanding the rcu block to include
> the ops = inet_csk(sk)->icsk_af_ops would fix that case.

I see, ops = inet_csk(sk)->icsk_af_ops might read out a re-overwritten
ops after sock_map_unlink, followed by sock_map_link. Ouch.

> So in summary I think we should expand the rcu lock here to include the
> ops = inet_csk(sk)->icsk_af_ops to ensure we dont race with tear
> down and create. I'll push the necessary update with WRITE_ONCE and
> READ_ONCE to fix that up. Seeing we have to wait until the merge
> window opens most likely anyways I'll send those out sooner rather
> then later and this series can add the proper annotations as well.

Or I could leave psock->icsk_af_ops set in restore_proto, like we do for
write_space as you noted. Restoring it twice doesn't seem harmful, it
has no side-effects. Less state changes to think about?

I'll still have to apply what you suggest for saving psock->sk_proto,
though.

Thanks,
Jakub

[0] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE
