Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DE7109477
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfKYTw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:52:26 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46125 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfKYTw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:52:26 -0500
Received: by mail-lj1-f193.google.com with SMTP id e9so17322934ljp.13
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 11:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=s4fnOC/HelX8kkcQXxgtOwdLfvTBKXuX7btL8jxsC3o=;
        b=BjRAClmi1Br9nQTttgKLGWhCSEeqkhlGCoj8S2DElwGWVhZM4jMeD2McempXU1j9tC
         AaeMF1Fg9o5c4MO3mJyv5iPyQDidaI5ylo8T7Hcg3l98rNs9FlYJnzv3SecMo5VVHjjR
         jRnJnDHaTh5AKTglw6SpcTJRQaNJq3i1qaWb9FYfXMSUz/ZCzEa2KerolzDGXy1ygwoI
         UmeXPYVrznzkBay/5afc+omH/Jg5F8NGsl+bEk1aj5xxOw25axW9fbXEXqclGt6BVjio
         OCzhxg39jr+A/wiBzzOzbzHt3GaWlQ3lSLw5GrnmyvEq3VkFktlTVRqxKwcRUfdo2W3g
         NgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=s4fnOC/HelX8kkcQXxgtOwdLfvTBKXuX7btL8jxsC3o=;
        b=dk7Oc761pmBEdcrtMY/GasLiqu32xszDwtxfIWFt6fPl57kbQB4oojnN8sUNY7Zem2
         RZTt+dz4Cjcaxek5at6eTbNMnY/0O3adD8APAxwQb/G8/pQg0F/OFHDyOijGV4Zn77p4
         cCgGgoq8vZyL4Oi7dWQU0qBh/ajUsVqR5EbnPX0OOtgiMCWCxcjF9RGKIIDeU8eAvDR+
         fNFHmrirGr/U/x2h1ozP5Ma/TQ4sLa7jyANh1b+gLwwjR76F3yKcYhNk4CXngF38WguU
         Ygp+8Uyb95iEUdF0QIZFPQO4a+zk+uxDi+7aALPLVi6U48QQx4daRC4xv1he1ovYE70V
         L6wQ==
X-Gm-Message-State: APjAAAXotCHUNYHG2HKxzD5QGZwuIbnHrWMFKBwBot7zpfH8c4L2H8hy
        g5dMDFn7HQBUbMo9qULRoqWHWQ==
X-Google-Smtp-Source: APXvYqx8pD4B8KHddF+e/tYEtM83XHOGnxWv0NpjAiuDsdcYSeO9X/WjKlRniCKHkhxzQ8yaeX5Q0w==
X-Received: by 2002:a2e:9cc4:: with SMTP id g4mr21001376ljj.99.1574711544231;
        Mon, 25 Nov 2019 11:52:24 -0800 (PST)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y7sm4133259lfb.75.2019.11.25.11.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 11:52:23 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:52:10 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        netdev@vger.kernel.org,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Subject: Re: [RFC net] net/tls: clear SG markings on encryption error
Message-ID: <20191125115210.485b849d@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <5dd8a69936015_112a2b074679a5b83a@john-XPS-13-9370.notmuch>
References: <20191122214553.20982-1-jakub.kicinski@netronome.com>
        <5dd8a69936015_112a2b074679a5b83a@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the delay, this code is too tricky for me to handle while
applying patches :) Lemme quickly answer best I can and go back into
digging deeper.

On Fri, 22 Nov 2019 19:25:13 -0800, John Fastabend wrote:
> Jakub Kicinski wrote:
> > When tls_do_encryption() fails the SG lists are left with the
> > SG_END and SG_CHAIN marks in place. One could hope that once
> > encryption fails we will never see the record again, but that
> > is in fact not true. Commit d3b18ad31f93 ("tls: add bpf support
> > to sk_msg handling") added special handling to ENOMEM and ENOSPC
> > errors which mean we may see the same record re-submitted.
> > 
> > In all honesty I don't understand why we need the ENOMEM handling.
> > Waiting for socket memory without setting SOCK_NOSPACE on any
> > random memory allocation failure seems slightly ill advised.
> > 
> > Having said that, undoing the SG markings seems wise regardless.
> > 
> > Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
> > Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
> > Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > ---
> > John, I'm sending this mostly to ask if we can safely remove
> > the ENOMEM handling? :)
> >   
> What ENOMEM are you asking about here? The return code handling
> from bpf_exec_tx_verdict?
> 
> 
> 	ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
> 				  record_type, &copied,
> 				  msg->msg_flags);
> 	if (ret) {
> 		if (ret == -EINPROGRESS)
> 			num_async++;
> 		else if (ret == -ENOMEM)
> 			goto wait_for_memory;
> 		else if (ret == -ENOSPC)
> 			goto rollback_iter;
> 		else if (ret != -EAGAIN)
> 			goto send_end;
> 	}
> 
> I would want to run it through some of our tests but I don't think
> there is anything specific about BPF that needs it to be handled.
> I was just trying to handle the error case gracefully and
> wait_for_memory seems like the right behavior to me. What is ill
> advised here?

It's probably too strong of an expression :)

I was not seeing a clear relationship between ENOMEM and socket being
out of memory. The ENOMEM is likely because of a slab allocation
failure (quick look doesn't really reveal send_pages returning ENOMEM
if socket is full). So the wait is equivalent to a msleep, no?

I was a little worried about this error handling, it seems to make
assumptions about the reasons for errors. I heard a report of user
seeing ENOSPC coming out of a crypto accelerator, which didn't end well.

> > I was going to try the sockmap tests myself, but looks like the current
> > LLVM 10 build I get from their debs just segfaults when trying to build
> > selftest :/
> > 
> > Also there's at least one more bug in this piece of code, TLS 1.3
> > can't assume there's at least one free SG entry.  
> 
> There should always be one free SG entry at the end of the ring
> that is used for chaining.
> 
> From sk_msg_sg{}
> 
> 	/* The extra element is used for chaining the front and sections when
> 	 * the list becomes partitioned (e.g. end < start). The crypto APIs
> 	 * require the chaining.
> 	 */
> 	struct scatterlist		data[MAX_MSG_FRAGS + 1];
> 
> Can we use that element in that case? Otherwise probably can
> add an extra element there if needed, data[MAX_MSG_FRAGS + 2].

If sg really is a circular buffer we'd need to shift all entries to
make sure the hole is in the right place. Then we have a chain entry 
in the middle of the ring, and that's not good, right now the range
of [0, MAX_MSG_FRAGS) is assumed to contain data pages :S

> >  net/tls/tls_sw.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > index 24161750a737..4a0ea87b20cf 100644
> > --- a/net/tls/tls_sw.c
> > +++ b/net/tls/tls_sw.c
> > @@ -737,6 +737,19 @@ static int tls_push_record(struct sock *sk, int flags,
> >  	if (rc < 0) {
> >  		if (rc != -EINPROGRESS) {
> >  			tls_err_abort(sk, EBADMSG);
> > +
> > +			i = msg_pl->sg.end;
> > +			if (prot->version == TLS_1_3_VERSION) {
> > +				sg_mark_end(sk_msg_elem(msg_pl, i));
> > +				sg_unmark_end(sk_msg_elem(msg_pl, i));
> > +			}
> > +			sk_msg_iter_var_prev(i);
> > +			sg_unmark_end(sk_msg_elem(msg_pl, i));
> > +
> > +			i = msg_en->sg.end;
> > +			sk_msg_iter_var_prev(i);
> > +			sg_unmark_end(sk_msg_elem(msg_en, i));
> > +
> >  			if (split) {
> >  				tls_ctx->pending_open_record_frags = true;
> >  				tls_merge_open_record(sk, rec, tmp, orig_end);
>
> Can you copy the tls_push_record() error handling from BPF side instead of
> embedding more into tls_push_record itself?
> 
> 	err = tls_push_record(sk, flags, record_type);
> 	if (err < 0) {
> 		*copied -= sk_msg_free(sk, msg);
> 		tls_free_open_rec(sk);
> 		goto out_err;
> 	}
> 
> If the BPF program is not installed I guess you can skip the copied part
> because you wont have the 'more_data' case.
> 
> So something like (untested/compiled/etc)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 141da093ff04..0469eb73bc88 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -771,8 +771,14 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
>  
>  	policy = !(flags & MSG_SENDPAGE_NOPOLICY);
>  	psock = sk_psock_get(sk);
> -	if (!psock || !policy)
> -		return tls_push_record(sk, flags, record_type);
> +	if (!psock || !policy) {
> +		err = tls_push_record(sk, flags, record_type);
> +		if (err) {
> +			sk_msg_free(sk, msg);
> +			tls_free_open_rec(sk); // might not be needed in noBPF
> +		}
> +		return err;
> +	}
>  more_data:
>  	enospc = sk_msg_full(msg);
>  	if (psock->eval == __SK_NONE) {

Ah, that's a great suggestion, I missed the copied count is passed by
reference into bpf_exec_tx_verdict() and thought more surgery would be
required to handle it like that.
