Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D75122FA7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfLQPGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:06:38 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41979 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfLQPGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:06:36 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so7196714lfp.8
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 07:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=EY4jLBMvLeQadan6EjqkhpxwO29/0R68SZ9o81QWu58=;
        b=uJYXeeWy4RYFOFqEf17xl7gnVK/0FgU+AhTHa2PKK69M8wC33ddO3IaM4waNUxcB1h
         8hOR0yPIkhHgkLTPAufPHrulROIclWok6hjHvHnIQ1bAsIBH/O0ZLGsLL5Y8ABBZTvIP
         2+xJdN5bz0i5sz7wKy8coKutJkhiTEfpXIn7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=EY4jLBMvLeQadan6EjqkhpxwO29/0R68SZ9o81QWu58=;
        b=MTtwpgyYAOpbw8rrBbt1TXTmk1spofNxvMmL8w6cjo2cDK+VE/z8qa0K3G9XmoGh4N
         pSZsWV7RgC49SBvZ0tOnX0WaKFVF51m5uEYlgofnQKDx73sxI2985t/1YqjOuBYj5RTQ
         hh3zaYArG1s6VvzFTc0Jx89arkUSpBZgn13wRNU1IzQQZkNfKgH26qAFM42RjOTiEZ/n
         G2yOFNIJnJWIJiST4Y15wHLFTjmEQ4QVFvo6ZccUKQhRzggUSu/X5zhIgp7gAUkh5m1D
         6Nr6Cffk2iGfoDMR8R6AXIsYskXDihntD2jVX/oHsb7VRYmDURqqwDdyVIpE4ConQTCY
         QwhA==
X-Gm-Message-State: APjAAAWM+oeTqVtqTA1COfkCVlmgjSEqk5fxvsT3nB4gHvQ+WdF7z9i9
        SUHz7d21KQXAq+e5rylfNvHmYQsDzYooaQ==
X-Google-Smtp-Source: APXvYqxF/+Ng+orHICPm7K+4KlpIt9y0iuxkDQbUEY4m5+eaJwNmzU/PPTc4L0ZLfWBx3JLHMNRJcA==
X-Received: by 2002:ac2:4834:: with SMTP id 20mr2791723lft.166.1576595193577;
        Tue, 17 Dec 2019 07:06:33 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id g6sm12889267lja.10.2019.12.17.07.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:06:32 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-5-jakub@cloudflare.com> <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp> <87ftiaocp2.fsf@cloudflare.com> <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com> <87d0deo57q.fsf@cloudflare.com> <87sglsfdda.fsf@cloudflare.com> <20191211172051.clnwh5n5vdeovayy@kafai-mbp> <87pngtg4x4.fsf@cloudflare.com> <20191212192354.umerwea5z4fpwbkq@kafai-mbp>
User-agent: mu4e 1.1.0; emacs 26.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit psock or its ops on copy
In-reply-to: <20191212192354.umerwea5z4fpwbkq@kafai-mbp>
Date:   Tue, 17 Dec 2019 16:06:31 +0100
Message-ID: <87k16vf0ug.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 08:23 PM CET, Martin Lau wrote:
> On Thu, Dec 12, 2019 at 12:27:19PM +0100, Jakub Sitnicki wrote:
>> On Wed, Dec 11, 2019 at 06:20 PM CET, Martin Lau wrote:
>> > On Tue, Dec 10, 2019 at 03:45:37PM +0100, Jakub Sitnicki wrote:
>> >> John, Martin,
>> >>
>> >> On Tue, Nov 26, 2019 at 07:36 PM CET, Jakub Sitnicki wrote:
>> >> > On Tue, Nov 26, 2019 at 06:16 PM CET, Martin Lau wrote:
>> >> >> On Tue, Nov 26, 2019 at 04:54:33PM +0100, Jakub Sitnicki wrote:
>> >> >>> On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
>> >> >>> > On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
>> >> >>> > [ ... ]
>> >> >>> >
>> >> >>> >> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>> >> >>> >>  			sk->sk_prot = psock->sk_proto;
>> >> >>> >>  		psock->sk_proto = NULL;
>> >> >>> >>  	}
>> >> >>> >> +
>> >> >>> >> +	if (psock->icsk_af_ops) {
>> >> >>> >> +		icsk->icsk_af_ops = psock->icsk_af_ops;
>> >> >>> >> +		psock->icsk_af_ops = NULL;
>> >> >>> >> +	}
>> >> >>> >>  }
>> >> >>> >
>> >> >>> > [ ... ]
>> >> >>> >
>> >> >>> >> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
>> >> >>> >> +					  struct sk_buff *skb,
>> >> >>> >> +					  struct request_sock *req,
>> >> >>> >> +					  struct dst_entry *dst,
>> >> >>> >> +					  struct request_sock *req_unhash,
>> >> >>> >> +					  bool *own_req)
>> >> >>> >> +{
>> >> >>> >> +	const struct inet_connection_sock_af_ops *ops;
>> >> >>> >> +	void (*write_space)(struct sock *sk);
>> >> >>> >> +	struct sk_psock *psock;
>> >> >>> >> +	struct proto *proto;
>> >> >>> >> +	struct sock *child;
>> >> >>> >> +
>> >> >>> >> +	rcu_read_lock();
>> >> >>> >> +	psock = sk_psock(sk);
>> >> >>> >> +	if (likely(psock)) {
>> >> >>> >> +		proto = psock->sk_proto;
>> >> >>> >> +		write_space = psock->saved_write_space;
>> >> >>> >> +		ops = psock->icsk_af_ops;
>> >> >>> > It is not immediately clear to me what ensure
>> >> >>> > ops is not NULL here.
>> >> >>> >
>> >> >>> > It is likely I missed something.  A short comment would
>> >> >>> > be very useful here.
>> >> >>>
>> >> >>> I can see the readability problem. Looking at it now, perhaps it should
>> >> >>> be rewritten, to the same effect, as:
>> >> >>>
>> >> >>> static struct sock *tcp_bpf_syn_recv_sock(...)
>> >> >>> {
>> >> >>> 	const struct inet_connection_sock_af_ops *ops = NULL;
>> >> >>>         ...
>> >> >>>
>> >> >>>         rcu_read_lock();
>> >> >>> 	psock = sk_psock(sk);
>> >> >>> 	if (likely(psock)) {
>> >> >>> 		proto = psock->sk_proto;
>> >> >>> 		write_space = psock->saved_write_space;
>> >> >>> 		ops = psock->icsk_af_ops;
>> >> >>> 	}
>> >> >>> 	rcu_read_unlock();
>> >> >>>
>> >> >>>         if (!ops)
>> >> >>> 		ops = inet_csk(sk)->icsk_af_ops;
>> >> >>>         child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
>> >> >>>
>> >> >>> If psock->icsk_af_ops were NULL, it would mean we haven't initialized it
>> >> >>> properly. To double check what happens here:
>> >> >> I did not mean the init path.  The init path is fine since it init
>> >> >> eveything on psock before publishing the sk to the sock_map.
>> >> >>
>> >> >> I was thinking the delete path (e.g. sock_map_delete_elem).  It is not clear
>> >> >> to me what prevent the earlier pasted sk_psock_restore_proto() which sets
>> >> >> psock->icsk_af_ops to NULL from running in parallel with
>> >> >> tcp_bpf_syn_recv_sock()?  An explanation would be useful.
>> >> >
>> >> > Ah, I misunderstood. Nothing prevents the race, AFAIK.
>> >> >
>> >> > Setting psock->icsk_af_ops to null on restore and not checking for it
>> >> > here was a bad move on my side.  Also I need to revisit what to do about
>> >> > psock->sk_proto so the child socket doesn't end up with null sk_proto.
>> >> >
>> >> > This race should be easy enough to trigger. Will give it a shot.
>> >>
>> >> I've convinced myself that this approach is racy beyond repair.
>> >>
>> >> Once syn_recv_sock() has returned it is too late to reset the child
>> >> sk_user_data and restore its callbacks. It has been already inserted
>> >> into ehash and ingress path can invoke its callbacks.
>> >>
>> >> The race can be triggered with with a reproducer where:
>> >>
>> >> thread-1:
>> >>
>> >>         p = accept(s, ...);
>> >>         close(p);
>> >>
>> >> thread-2:
>> >>
>> >> 	bpf_map_update_elem(mapfd, &key, &s, BPF_NOEXIST);
>> >> 	bpf_map_delete_elem(mapfd, &key);
>> >>
>> >> This a dead-end because we can't have the parent and the child share the
>> >> psock state. Even though psock itself is refcounted, and potentially we
>> >> could grab a reference before cloning the parent, link into the map that
>> >> psock holds is not.
>> >>
>> >> Two ways out come to mind. Both involve touching TCP code, which I was
>> >> hoping to avoid:
>> >>
>> >> 1) reset sk_user_data when initializing the child
>> >>
>> >>    This is problematic because tcp_bpf callbacks are not designed to
>> >>    handle sockets with no psock _and_ with overridden sk_prot
>> >>    callbacks. (Although, I think they could if the fallback was directly
>> >>    on {tcp,tcpv6}_prot based on socket domain.)
>> >>
>> >>    Also, there are other sk_user_data users like DRBD which rely on
>> >>    sharing the sk_user_data pointer between parent and child, if I read
>> >>    the code correctly [0]. If anything, clearing the sk_user_data on
>> >>    clone would have to be guarded by a flag.
>> > Can the copy/not-to-copy sk_user_data decision be made in
>> > sk_clone_lock()?
>>
>> Yes, this could be pushed down to sk_clone_lock(), where we do similar
>> work (reset sk_reuseport_cb and clone bpf_sk_storage):
> aha.  I missed your eariler "clearing the sk_user_data on clone would have
> to be guarded by a flag..." part.  It turns out we were talking the same
> thing on (1).  sock_flag works better if there is still bit left (and it
> seems there is one),  although I was thinking more like adding
> something (e.g. a func ptr) to 'struct proto' to mangle sk_user_data
> before returning newsk....but not sure this kind of logic
> belongs to 'struct proto'

Sorry for late reply.

We have 4 bits left by my count. The multi-line comment for SOCK_NOFCS
is getting in the way of counting them line-for-bit.

A callback invoked on socket clone is something I was considering too.
I'm not sure either where it belongs. At risk of being too use-case
specific, perhaps it could live together with sk_user_data and sk_prot,
which it would mangle on sk_clone_lock():

struct sock {
        ...
	void			*sk_user_data;
	void			(*sk_clone)(struct sock *sk,
					    struct sock *newsk);
        ...
}

But, I feel adding a new sock field just for this wouldn't be justified.
I can get by with a sock flag. Unless we have other uses for it?

>
>>
>> 	/* User data can hold reference. Child must not
>> 	 * inherit the pointer without acquiring a reference.
>> 	 */
>> 	if (sock_flag(sk, SOCK_OWNS_USER_DATA)) {
>> 		sock_reset_flag(newsk, SOCK_OWNS_USER_DATA);
>> 		RCU_INIT_POINTER(newsk->sk_user_data, NULL);
>> 	}
>>
>> I belive this would still need to be guarded by a flag.  Do you see
>> value in clearing child sk_user_data on clone as opposed to dealying
>> that work until accept() time?
> It seems to me clearing things up front at the very beginning is more
> straight forward, such that it does not have to worry about the
> sk_user_data may be used in a wrong way before it gets a chance
> to be cleared in accept().
>
> Just something to consider, if it is obvious that there is no hole in
> clearing it in accept(), it is fine too.

Just when I thought I could get away with lazily clearing the
sk_user_data at accept() time, it occurred to me that it is not enough.

Listening socket could get deleted from sockmap before a child socket
that inherited a copy of sk_user_data pointer gets accept()'ed. In such
scenario the pointer would not get NULL'ed on accept(), because
listening socket would have it's sk_prot->accept restored by then.

I will need that flag after all...

-jkbs

>
>> >>
>> >> 2) Restore sk_prot callbacks on clone to {tcp,tcpv6}_prot
>> >>
>> >>    The simpler way out. tcp_bpf callbacks never get invoked on the child
>> >>    socket so the copied psock reference is no longer a problem. We can
>> >>    clear the pointer on accept().
>> >>
>> >>    So far I wasn't able poke any holes in it and it comes down to
>> >>    patching tcp_create_openreq_child() with:
>> >>
>> >> 	/* sk_msg and ULP frameworks can override the callbacks into
>> >> 	 * protocol. We don't assume they are intended to be inherited
>> >> 	 * by the child. Frameworks can re-install the callbacks on
>> >> 	 * accept() if needed.
>> >> 	 */
>> >> 	WRITE_ONCE(newsk->sk_prot, sk->sk_prot_creator);
>> >>
>> >>    That's what I'm going with for v2.
>> >>
>> >> Open to suggestions.
>> >>
>> >> Thanks,
>> >> Jakub
>> >>
>> >> BTW. Reading into kTLS code, I noticed it has been limited down to just
>> >> established sockets due to the same problem I'm struggling with here:
>> >>
>> >> static int tls_init(struct sock *sk)
>> >> {
>> >> ...
>> >> 	/* The TLS ulp is currently supported only for TCP sockets
>> >> 	 * in ESTABLISHED state.
>> >> 	 * Supporting sockets in LISTEN state will require us
>> >> 	 * to modify the accept implementation to clone rather then
>> >> 	 * share the ulp context.
>> >> 	 */
>> >> 	if (sk->sk_state != TCP_ESTABLISHED)
>> >> 		return -ENOTCONN;
>> >>
>> >> [0] https://urldefense.proofpoint.com/v2/url?u=https-3A__elixir.bootlin.com_linux_v5.5-2Drc1_source_drivers_block_drbd_drbd-5Freceiver.c-23L682&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=z2Cz1gEcqiw-8YqVOluxlUHh_CBs6PJWQN2vgirOyFk&s=WAiM0asZN0OkqrW02xm2mCMIzWhKQCc3KiY7pzMKNg4&e=
