Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF6827D2F6
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgI2Pls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728241AbgI2Pls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:41:48 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B91BC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:41:48 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id s66so4892638otb.2
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yaa9h46cTrUOj1B05FKBBMkizl7+B2+dQpyHaM5ODkw=;
        b=EcG9U4vSytVNMtCzy1YCurTx/PYY9nsdaRzFdTNZy9p3i9YqpqL4gSaon1p156JK47
         sVd6evHEDTwoPXCrfset17004p54mctco6W/gJ6cvG6fqfr+x/rBBw5NbqYkbPXBeaSz
         PQV1WNuHZYtzcHviJftNf4XB+GoM47jG116wXKCRmaSkAHvBQR19Dyuzy6yorW3YmlHE
         lPn4LzrNca9nMscz0cCui2w7JCJSDpq7Ke5iQtNQdpHYGdf9Iy2ne/j9ybSfScfnI5ql
         vdDnfkuZAUJelZ5D0tytIg3fUMBxllgYuAp5WqQ6D2s23gNeY8zSoUGvl34qgDg9V3v2
         tfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yaa9h46cTrUOj1B05FKBBMkizl7+B2+dQpyHaM5ODkw=;
        b=PfhXZ8wJEnpdRs6JVUtD93SZgS8fBXX2eg9Tl+33w3oZMC13bY1uS/RRonxBj0Ggsi
         k2mlWKfEUkD98emVZk2vesSql/nB6kZ8PyzS0GjyCiVNlkKHRVFdl7oGNIk6lkAeJSow
         h+isPWt4k9d/uTJHK7M+9RONJzzru4rla2CdSL+2Wuw/+U9YDljUNgU5eGWGYtyn/jHq
         6zneZrJfZssGCLZerKV4sQG9raaRhg87j/+0Nh4oZft+emGtP7aNhya8tmYyBBlhJ5QU
         WXwJ8Nbgf+VZFQmiVBZmat5dqIpVJTVaWQ9IkKbtlqgMO2mFo1rrlAjZPy1OkqXlSyeM
         DNEg==
X-Gm-Message-State: AOAM533ihxBREEbQlL+P0qI7LoT/7qNWL6jDdzqG80KpdZhGip7dL87/
        Z707EojqxYz+d81BCEEVfGk=
X-Google-Smtp-Source: ABdhPJy4qd0h6OuwlRez6pDwqMh9Nx/IULsvwZM4zlDDb476qjPNlH8jbYwbUJrkPfI/rtEli7paVw==
X-Received: by 2002:a9d:1:: with SMTP id 1mr3195595ota.81.1601394107437;
        Tue, 29 Sep 2020 08:41:47 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j26sm2947414oor.21.2020.09.29.08.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 08:41:46 -0700 (PDT)
Date:   Tue, 29 Sep 2020 08:41:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, ast@kernel.org
Cc:     netdev@vger.kernel.org, jakub@cloudflare.com, lmb@cloudflare.com
Message-ID: <5f7355b42318_98732082d@john-XPS-13-9370.notmuch>
In-Reply-To: <2046cb78-ac23-05c2-6802-40332495d959@iogearbox.net>
References: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower>
 <160109442512.6363.1622656051946413257.stgit@john-Precision-5820-Tower>
 <2046cb78-ac23-05c2-6802-40332495d959@iogearbox.net>
Subject: Re: [bpf-next PATCH 1/2] bpf, sockmap: add skb_adjust_room to pop
 bytes off ingress payload
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 9/26/20 6:27 AM, John Fastabend wrote:
> > This implements a new helper skb_adjust_room() so users can push/pop
> > extra bytes from a BPF_SK_SKB_STREAM_VERDICT program.
> > 
> > Some protocols may include headers and other information that we may
> > not want to include when doing a redirect from a BPF_SK_SKB_STREAM_VERDICT
> > program. One use case is to redirect TLS packets into a receive socket
> > that doesn't expect TLS data. In TLS case the first 13B or so contain the
> > protocol header. With KTLS the payload is decrypted so we should be able
> > to redirect this to a receiving socket, but the receiving socket may not
> > be expecting to receive a TLS header and discard the data. Using the
> > above helper we can pop the header off and put an appropriate header on
> > the payload. This allows for creating a proxy between protocols without
> > extra hops through the stack or userspace.
> > 
> > So in order to fix this case add skb_adjust_room() so users can strip the
> > header. After this the user can strip the header and an unmodified receiver
> > thread will work correctly when data is redirected into the ingress path
> > of a sock.
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >   net/core/filter.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 51 insertions(+)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 4d8dc7a31a78..d232358f1dcd 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -76,6 +76,7 @@
> >   #include <net/bpf_sk_storage.h>
> >   #include <net/transp_v6.h>
> >   #include <linux/btf_ids.h>
> > +#include <net/tls.h>
> >   
> >   static const struct bpf_func_proto *
> >   bpf_sk_base_func_proto(enum bpf_func_id func_id);
> > @@ -3218,6 +3219,53 @@ static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> >   			  SKB_MAX_ALLOC;
> >   }
> >   
> > +BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
> > +	   u32, mode, u64, flags)
> > +{
> > +	unsigned int len_diff_abs = abs(len_diff);
> 
> small nit: u32

Sure.

> 
> > +	bool shrink = len_diff < 0;
> > +	int ret = 0;
> > +
> > +	if (unlikely(flags))
> > +		return -EINVAL;
> 
> Parameter 'mode' is not used here, I guess we need to reject anything non-zero?

Probably its not used.

> 
> Similarly, any interaction wrt bpf_csum_level() that was needed back then for the
> bpf_skb_adjust_room()?

I don't believe so because we are above csum checks at this point.
Either we will put the skb data in the receive_queue for the socket
or redirect it into sendpage.

> 
> > +	if (unlikely(len_diff_abs > 0xfffU))
> > +		return -EFAULT;
> > +
> > +	if (!shrink) {
> > +		unsigned int grow = len_diff;
> 
> nit: u32 or just directly len_diff?

Just use len_diff missed when I cleaned this up.

> 
> > +		ret = skb_cow(skb, grow);
> > +		if (likely(!ret)) {
> > +			__skb_push(skb, len_diff_abs);
> > +			memset(skb->data, 0, len_diff_abs);
> > +		}
> > +	} else {
> > +		/* skb_ensure_writable() is not needed here, as we're
> > +		 * already working on an uncloned skb.
> > +		 */
> > +		if (unlikely(!pskb_may_pull(skb, len_diff_abs)))
> > +			return -ENOMEM;
> > +		__skb_pull(skb, len_diff_abs);
> > +	}
> > +	bpf_compute_data_end_sk_skb(skb);
> > +	if (tls_sw_has_ctx_rx(skb->sk)) {
> > +		struct strp_msg *rxm = strp_msg(skb);
> > +
> > +		rxm->full_len += len_diff;
> 
> If skb_cow() failed, we still adjust rxm->full_len?

Thanks. Will just return above on error like in the else
branch. I'll send a v2 shortly.
