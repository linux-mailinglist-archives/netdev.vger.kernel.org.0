Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4A610A424
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 19:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKZSoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 13:44:01 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37164 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfKZSoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 13:44:00 -0500
Received: by mail-il1-f193.google.com with SMTP id s5so18601881iln.4;
        Tue, 26 Nov 2019 10:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UO4J4J64zNFe8Ht0JHIJ/fcPkubJqXaSN9IflwgpGQk=;
        b=sr+zngb8iFL2MxuD+LT+62ACPfAMJkX9EdRr/sPUZeFusTHBzWuwv0RGqta1t6Tynr
         /p04jyeLnBgRKfA3lzJW9h5iOySxP+Omoelbug18blMKUKM8NxvDAjGNcuBloCoM5EZJ
         RxGGlYE4HAOYKiZz+pSOy/zAGt/Is8f8fEbkX2TVSvEUQ8RSo/oO+IWiioyGzf9merXS
         6XO6A3/zBxd8uvT3G9jlB5waiaCKkAMjvuqPfJPk/xIVF2tdKAiIiDkHBNA+JOT6sahy
         2Wz80+m2RZGW9uzBqbrAWL6BN1rWBkWgSldAXiia5fCCZbr6bLz0ZyFw7VDMbC2j6eIT
         fGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UO4J4J64zNFe8Ht0JHIJ/fcPkubJqXaSN9IflwgpGQk=;
        b=VyYrcGGUMBU3M04xglZ5q8s5ljSOyA8hS+RXJ9prUKzR84FHn4J2sz6XF6dbyGSon7
         wQPvT9Wdsv1/H7hEY5HxPU8Y+XKY1o/nJN/fkBWHJHv+u04aAaz78b34wCVf/wrEiH0q
         c0jC3e3Iq9Sq4tl/N6IAWHepKSD0dl7WA/SBfnKtPDthFHcit1TJ8yqSTBRr2ulxTwyp
         zhcpX8bjJfLXVFIz2Ek5QAB4nieBBX2sW1oqdpXW3n6KXGroPJnlyPFh1rnXS6+C5ZzN
         H1jDUiCpUJRkwI32dz/tg5ESlHVWH9a8VgekZ11NBn/2J2L5bMC0vTrQUO8T3H46u+rg
         TADw==
X-Gm-Message-State: APjAAAVRjSrxSN2Xm0kXYn2GjObLRSujSHY3rX/zypHCPkskZRND0mhQ
        bpWQldzE+tPbVVVvYoM0RaU=
X-Google-Smtp-Source: APXvYqz/ygr2hgH9hhkxSTZDegBz2uUxkNkGkNng+aYTUvcJiFnkKEz2isOO499cJeRgq8GCM1KRgQ==
X-Received: by 2002:a92:ca8d:: with SMTP id t13mr37980442ilo.58.1574793839650;
        Tue, 26 Nov 2019 10:43:59 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v27sm575033ill.17.2019.11.26.10.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 10:43:59 -0800 (PST)
Date:   Tue, 26 Nov 2019 10:43:50 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin Lau <kafai@fb.com>, Jakub Sitnicki <jakub@cloudflare.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5ddd7266c36aa_671a2b0b882605c04a@john-XPS-13-9370.notmuch>
In-Reply-To: <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-5-jakub@cloudflare.com>
 <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp>
 <87ftiaocp2.fsf@cloudflare.com>
 <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit
 psock or its ops on copy
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau wrote:
> On Tue, Nov 26, 2019 at 04:54:33PM +0100, Jakub Sitnicki wrote:
> > On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
> > > On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
> > > [ ... ]
> > >
> > >> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct sock *sk,
> > >>  			sk->sk_prot = psock->sk_proto;
> > >>  		psock->sk_proto = NULL;
> > >>  	}
> > >> +
> > >> +	if (psock->icsk_af_ops) {
> > >> +		icsk->icsk_af_ops = psock->icsk_af_ops;
> > >> +		psock->icsk_af_ops = NULL;
> > >> +	}
> > >>  }
> > >
> > > [ ... ]
> > >
> > >> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
> > >> +					  struct sk_buff *skb,
> > >> +					  struct request_sock *req,
> > >> +					  struct dst_entry *dst,
> > >> +					  struct request_sock *req_unhash,
> > >> +					  bool *own_req)
> > >> +{
> > >> +	const struct inet_connection_sock_af_ops *ops;
> > >> +	void (*write_space)(struct sock *sk);
> > >> +	struct sk_psock *psock;
> > >> +	struct proto *proto;
> > >> +	struct sock *child;
> > >> +
> > >> +	rcu_read_lock();
> > >> +	psock = sk_psock(sk);
> > >> +	if (likely(psock)) {
> > >> +		proto = psock->sk_proto;
> > >> +		write_space = psock->saved_write_space;
> > >> +		ops = psock->icsk_af_ops;
> > > It is not immediately clear to me what ensure
> > > ops is not NULL here.
> > >
> > > It is likely I missed something.  A short comment would
> > > be very useful here.
> > 
> > I can see the readability problem. Looking at it now, perhaps it should
> > be rewritten, to the same effect, as:
> > 
> > static struct sock *tcp_bpf_syn_recv_sock(...)
> > {
> > 	const struct inet_connection_sock_af_ops *ops = NULL;
> >         ...
> > 
> >     rcu_read_lock();
> > 	psock = sk_psock(sk);
> > 	if (likely(psock)) {
> > 		proto = psock->sk_proto;
> > 		write_space = psock->saved_write_space;
> > 		ops = psock->icsk_af_ops;
> > 	}
> > 	rcu_read_unlock();
> > 
> >         if (!ops)
> > 		ops = inet_csk(sk)->icsk_af_ops;
> >         child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
> > 
> > If psock->icsk_af_ops were NULL, it would mean we haven't initialized it
> > properly. To double check what happens here:
> I did not mean the init path.  The init path is fine since it init
> eveything on psock before publishing the sk to the sock_map.
> 
> I was thinking the delete path (e.g. sock_map_delete_elem).  It is not clear
> to me what prevent the earlier pasted sk_psock_restore_proto() which sets
> psock->icsk_af_ops to NULL from running in parallel with
> tcp_bpf_syn_recv_sock()?  An explanation would be useful.
> 

I'll answer. Updates are protected via sk_callback_lock so we don't have
parrallel updates in-flight causing write_space and sk_proto to be out
of sync. However access should be OK because its a pointer write we
never update the pointer in place, e.g.

static inline void sk_psock_restore_proto(struct sock *sk,
					  struct sk_psock *psock)
{
+       struct inet_connection_sock *icsk = inet_csk(sk);
+
	sk->sk_write_space = psock->saved_write_space;

	if (psock->sk_proto) {
		struct inet_connection_sock *icsk = inet_csk(sk);
		bool has_ulp = !!icsk->icsk_ulp_data;

		if (has_ulp)
			tcp_update_ulp(sk, psock->sk_proto);
		else
			sk->sk_prot = psock->sk_proto;
		psock->sk_proto = NULL;
	}

+
+       if (psock->icsk_af_ops) {
+               icsk->icsk_af_ops = psock->icsk_af_ops;
+               psock->icsk_af_ops = NULL;
+       }
}

In restore case either psock->icsk_af_ops is null or not. If its
null below code catches it. If its not null (from init path) then
we have a valid pointer.

        rcu_read_lock();
	psock = sk_psock(sk);
 	if (likely(psock)) {
 		proto = psock->sk_proto;
 		write_space = psock->saved_write_space;
 		ops = psock->icsk_af_ops;
 	}
 	rcu_read_unlock();
 
        if (!ops)
		ops = inet_csk(sk)->icsk_af_ops;
        child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);


We should do this with proper READ_ONCE/WRITE_ONCE to make it clear
what is going on and to stop compiler from breaking these assumptions. I
was going to generate that patch after this series but can do it before
as well. I didn't mention it here because it seems a bit out of scope
for this series because its mostly a fix to older code.

Also I started to think that write_space might be out of sync with ops but
it seems we never actually remove psock_write_space until after
rcu grace period so that should be OK as well and always point to the
previous write_space.

Finally I wondered if we could remove the ops and then add it back
quickly which seems at least in theory possible, but that would get
hit with a grace period because we can't have conflicting psock
definitions on the same sock. So expanding the rcu block to include
the ops = inet_csk(sk)->icsk_af_ops would fix that case.

So in summary I think we should expand the rcu lock here to include the
ops = inet_csk(sk)->icsk_af_ops to ensure we dont race with tear
down and create. I'll push the necessary update with WRITE_ONCE and
READ_ONCE to fix that up. Seeing we have to wait until the merge
window opens most likely anyways I'll send those out sooner rather
then later and this series can add the proper annotations as well.
