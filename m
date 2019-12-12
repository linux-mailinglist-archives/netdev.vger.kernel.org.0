Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B828011CC2B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfLLL1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:27:24 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34774 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfLLL1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 06:27:23 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so1442414lfc.1
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 03:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=g2q6I6OwUsDtgKJw//clPD/nQjEExuCDWbVJxVssMyE=;
        b=bliQn1b+/WulIWmuf61XGbF1bxqSEQO2x6kZBfCZThTPmlEMR3y8T1VIkxFWnEwJM8
         HENgr3XI0eSeOpA896qTaYtk2Ga4NEpMJ8adrwCGf/4lH1ctFrC/2yiJwQJkKVQdAtR4
         fP58rT2tLm/8GzW2KXhxsMCfJRCj018SyQcGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=g2q6I6OwUsDtgKJw//clPD/nQjEExuCDWbVJxVssMyE=;
        b=DF3B0RWiTIcOdU8hRqXdIa4p5xKTcdQ/tVnf8xS3IfLWQHVUmT4Gm+YyxHjTXEx78h
         mOHGYTpBrP9rURJ3ClCb+wvjaDU60a/o7pm7iCly1ziQcC8kpdd1YXFJiSqUPYBHWAOE
         ZCksHrz8PdEAvq/zSFjzM+9mV6egix+Oq0GFtgxKaeuxroE8PBRV0MHh1OjrAKctTcR3
         nKCGK5Dx0IELhylFTcmcospHnpc36J5bH+jYOs+TNSZuBGFrMJeDylx0HQNqDWez5gkx
         vhqtFReL76B55lfCDzWq96tHSEjDpWMdwHhxUZbAIHT0vy1m07WX8gSazo73BEFhnNGP
         jz5Q==
X-Gm-Message-State: APjAAAWgMviHMAq/XUzQqTjlPyb+HMxqUqI7Zp4wf7EXBRNXw/s0bp99
        ArDF9B1ZYnMqJRL74TAQ1h1Bzw==
X-Google-Smtp-Source: APXvYqzsUh7cimf9BLESTtA4BwyKb2HY2+DqvZkIk560/UxrkMaRsGeQ5WoBT7U4z9u2jZC6UcNZyg==
X-Received: by 2002:ac2:53a8:: with SMTP id j8mr5489538lfh.28.1576150041076;
        Thu, 12 Dec 2019 03:27:21 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id r18sm2807041lfa.6.2019.12.12.03.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 03:27:20 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-5-jakub@cloudflare.com> <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp> <87ftiaocp2.fsf@cloudflare.com> <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com> <87d0deo57q.fsf@cloudflare.com> <87sglsfdda.fsf@cloudflare.com> <20191211172051.clnwh5n5vdeovayy@kafai-mbp>
User-agent: mu4e 1.1.0; emacs 26.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit psock or its ops on copy
In-reply-to: <20191211172051.clnwh5n5vdeovayy@kafai-mbp>
Date:   Thu, 12 Dec 2019 12:27:19 +0100
Message-ID: <87pngtg4x4.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 06:20 PM CET, Martin Lau wrote:
> On Tue, Dec 10, 2019 at 03:45:37PM +0100, Jakub Sitnicki wrote:
>> John, Martin,
>>
>> On Tue, Nov 26, 2019 at 07:36 PM CET, Jakub Sitnicki wrote:
>> > On Tue, Nov 26, 2019 at 06:16 PM CET, Martin Lau wrote:
>> >> On Tue, Nov 26, 2019 at 04:54:33PM +0100, Jakub Sitnicki wrote:
>> >>> On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
>> >>> > On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
>> >>> > [ ... ]
>> >>> >
>> >>> >> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>> >>> >>  			sk->sk_prot = psock->sk_proto;
>> >>> >>  		psock->sk_proto = NULL;
>> >>> >>  	}
>> >>> >> +
>> >>> >> +	if (psock->icsk_af_ops) {
>> >>> >> +		icsk->icsk_af_ops = psock->icsk_af_ops;
>> >>> >> +		psock->icsk_af_ops = NULL;
>> >>> >> +	}
>> >>> >>  }
>> >>> >
>> >>> > [ ... ]
>> >>> >
>> >>> >> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
>> >>> >> +					  struct sk_buff *skb,
>> >>> >> +					  struct request_sock *req,
>> >>> >> +					  struct dst_entry *dst,
>> >>> >> +					  struct request_sock *req_unhash,
>> >>> >> +					  bool *own_req)
>> >>> >> +{
>> >>> >> +	const struct inet_connection_sock_af_ops *ops;
>> >>> >> +	void (*write_space)(struct sock *sk);
>> >>> >> +	struct sk_psock *psock;
>> >>> >> +	struct proto *proto;
>> >>> >> +	struct sock *child;
>> >>> >> +
>> >>> >> +	rcu_read_lock();
>> >>> >> +	psock = sk_psock(sk);
>> >>> >> +	if (likely(psock)) {
>> >>> >> +		proto = psock->sk_proto;
>> >>> >> +		write_space = psock->saved_write_space;
>> >>> >> +		ops = psock->icsk_af_ops;
>> >>> > It is not immediately clear to me what ensure
>> >>> > ops is not NULL here.
>> >>> >
>> >>> > It is likely I missed something.  A short comment would
>> >>> > be very useful here.
>> >>>
>> >>> I can see the readability problem. Looking at it now, perhaps it should
>> >>> be rewritten, to the same effect, as:
>> >>>
>> >>> static struct sock *tcp_bpf_syn_recv_sock(...)
>> >>> {
>> >>> 	const struct inet_connection_sock_af_ops *ops = NULL;
>> >>>         ...
>> >>>
>> >>>         rcu_read_lock();
>> >>> 	psock = sk_psock(sk);
>> >>> 	if (likely(psock)) {
>> >>> 		proto = psock->sk_proto;
>> >>> 		write_space = psock->saved_write_space;
>> >>> 		ops = psock->icsk_af_ops;
>> >>> 	}
>> >>> 	rcu_read_unlock();
>> >>>
>> >>>         if (!ops)
>> >>> 		ops = inet_csk(sk)->icsk_af_ops;
>> >>>         child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
>> >>>
>> >>> If psock->icsk_af_ops were NULL, it would mean we haven't initialized it
>> >>> properly. To double check what happens here:
>> >> I did not mean the init path.  The init path is fine since it init
>> >> eveything on psock before publishing the sk to the sock_map.
>> >>
>> >> I was thinking the delete path (e.g. sock_map_delete_elem).  It is not clear
>> >> to me what prevent the earlier pasted sk_psock_restore_proto() which sets
>> >> psock->icsk_af_ops to NULL from running in parallel with
>> >> tcp_bpf_syn_recv_sock()?  An explanation would be useful.
>> >
>> > Ah, I misunderstood. Nothing prevents the race, AFAIK.
>> >
>> > Setting psock->icsk_af_ops to null on restore and not checking for it
>> > here was a bad move on my side.  Also I need to revisit what to do about
>> > psock->sk_proto so the child socket doesn't end up with null sk_proto.
>> >
>> > This race should be easy enough to trigger. Will give it a shot.
>>
>> I've convinced myself that this approach is racy beyond repair.
>>
>> Once syn_recv_sock() has returned it is too late to reset the child
>> sk_user_data and restore its callbacks. It has been already inserted
>> into ehash and ingress path can invoke its callbacks.
>>
>> The race can be triggered with with a reproducer where:
>>
>> thread-1:
>>
>>         p = accept(s, ...);
>>         close(p);
>>
>> thread-2:
>>
>> 	bpf_map_update_elem(mapfd, &key, &s, BPF_NOEXIST);
>> 	bpf_map_delete_elem(mapfd, &key);
>>
>> This a dead-end because we can't have the parent and the child share the
>> psock state. Even though psock itself is refcounted, and potentially we
>> could grab a reference before cloning the parent, link into the map that
>> psock holds is not.
>>
>> Two ways out come to mind. Both involve touching TCP code, which I was
>> hoping to avoid:
>>
>> 1) reset sk_user_data when initializing the child
>>
>>    This is problematic because tcp_bpf callbacks are not designed to
>>    handle sockets with no psock _and_ with overridden sk_prot
>>    callbacks. (Although, I think they could if the fallback was directly
>>    on {tcp,tcpv6}_prot based on socket domain.)
>>
>>    Also, there are other sk_user_data users like DRBD which rely on
>>    sharing the sk_user_data pointer between parent and child, if I read
>>    the code correctly [0]. If anything, clearing the sk_user_data on
>>    clone would have to be guarded by a flag.
> Can the copy/not-to-copy sk_user_data decision be made in
> sk_clone_lock()?

Yes, this could be pushed down to sk_clone_lock(), where we do similar
work (reset sk_reuseport_cb and clone bpf_sk_storage):

	/* User data can hold reference. Child must not
	 * inherit the pointer without acquiring a reference.
	 */
	if (sock_flag(sk, SOCK_OWNS_USER_DATA)) {
		sock_reset_flag(newsk, SOCK_OWNS_USER_DATA);
		RCU_INIT_POINTER(newsk->sk_user_data, NULL);
	}

I belive this would still need to be guarded by a flag.  Do you see
value in clearing child sk_user_data on clone as opposed to dealying
that work until accept() time?

-Jakub

>
>>
>> 2) Restore sk_prot callbacks on clone to {tcp,tcpv6}_prot
>>
>>    The simpler way out. tcp_bpf callbacks never get invoked on the child
>>    socket so the copied psock reference is no longer a problem. We can
>>    clear the pointer on accept().
>>
>>    So far I wasn't able poke any holes in it and it comes down to
>>    patching tcp_create_openreq_child() with:
>>
>> 	/* sk_msg and ULP frameworks can override the callbacks into
>> 	 * protocol. We don't assume they are intended to be inherited
>> 	 * by the child. Frameworks can re-install the callbacks on
>> 	 * accept() if needed.
>> 	 */
>> 	WRITE_ONCE(newsk->sk_prot, sk->sk_prot_creator);
>>
>>    That's what I'm going with for v2.
>>
>> Open to suggestions.
>>
>> Thanks,
>> Jakub
>>
>> BTW. Reading into kTLS code, I noticed it has been limited down to just
>> established sockets due to the same problem I'm struggling with here:
>>
>> static int tls_init(struct sock *sk)
>> {
>> ...
>> 	/* The TLS ulp is currently supported only for TCP sockets
>> 	 * in ESTABLISHED state.
>> 	 * Supporting sockets in LISTEN state will require us
>> 	 * to modify the accept implementation to clone rather then
>> 	 * share the ulp context.
>> 	 */
>> 	if (sk->sk_state != TCP_ESTABLISHED)
>> 		return -ENOTCONN;
>>
>> [0] https://urldefense.proofpoint.com/v2/url?u=https-3A__elixir.bootlin.com_linux_v5.5-2Drc1_source_drivers_block_drbd_drbd-5Freceiver.c-23L682&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=z2Cz1gEcqiw-8YqVOluxlUHh_CBs6PJWQN2vgirOyFk&s=WAiM0asZN0OkqrW02xm2mCMIzWhKQCc3KiY7pzMKNg4&e=
