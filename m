Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F32D913841A
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgAKXir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:38:47 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35890 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731643AbgAKXiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:38:46 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so4867917iln.3;
        Sat, 11 Jan 2020 15:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=m8hySsS7iSwjJyeKoswQfatUDrXA5gwU1m6Vc0C7tyk=;
        b=peptKuCwgIYkcPlHFA0dw7c90Kf4cI0sRXEpRlTC73q7V+WQXZMFNTbr/mpsQ5t+Jl
         tSMaahfdlYposPr1/8wj0fxlhKPL4U0vGuda4nmaEglIiAhehuBRiW9DUGnYj1pefZ2Q
         Qzi17emtdfI5I0jMRbPzJ5k8hZAv/fLjvroxkR4HEJOhJOo8W+q8n9wOF7QhppZhMb9U
         XBnrxrMmgCd7QL3UlZaP2sagfjuoSJxhC3qh0/21UL+VGOHlIaI2Ea6wmr8UeD0T9y7f
         9gSZoH8iAAY+wraO9B7bhke0APm4nRU7oLYvwfIFCBgTW7JCV93GM5mlSX7CCE4faavo
         Bxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=m8hySsS7iSwjJyeKoswQfatUDrXA5gwU1m6Vc0C7tyk=;
        b=VwxUHzc6i5m/U51IZtx6dBu78pvWZ67QsmLugmjRBE0DkphAJsNpIUM3qppOiBPd6e
         eQ7JikX5gEx0sWfYjLeo8EkV3ipxbJg24Q0Zj3hKB+94A6FiUCwpS1rtfH+e7kLx4YtK
         uYZt+86PAEHNsSCFHoFLf30hl1XrgxF7WDUHP56w7DWY6OLelobEwgjefr7AQxby7Ga3
         OwREcd1877c00T2sL5jM2XqPiRAr7MiyDrPbqgpEqXOTEWcxAWzjjJJ92jMBALcNDgTx
         hq2ZezJg0mP9feSPcdrXj1IvhBD5DNPPmeulqUUzbYu/VPGZISvby1hu6Lb5E35n+EEQ
         dPlw==
X-Gm-Message-State: APjAAAVAwGAhtifEIUxfLlT8cp98TiksrRUj9SjQH+Aluo3SuTsrqDvM
        WTKcrBabqR6j6YKn+gOXJQ0=
X-Google-Smtp-Source: APXvYqwCuaOrhSPUJz4LPoA44OXjBMw3CLUCVk0JQOsX2fDJBDMHiGDRdwIEHR/zSBsYLSyKp2znuQ==
X-Received: by 2002:a92:838f:: with SMTP id p15mr8726614ilk.91.1578785925217;
        Sat, 11 Jan 2020 15:38:45 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a12sm1602205ion.73.2020.01.11.15.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 15:38:44 -0800 (PST)
Date:   Sat, 11 Jan 2020 15:38:35 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a5c7bb3cbd_1e7f2b0c859c45c0b4@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-4-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-4-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 03/11] net, sk_msg: Clear sk_user_data pointer
 on clone if tagged
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> sk_user_data can hold a pointer to an object that is not intended to be
> shared between the parent socket and the child that gets a pointer copy on
> clone. This is the case when sk_user_data points at reference-counted
> object, like struct sk_psock.
> 
> One way to resolve it is to tag the pointer with a no-copy flag by
> repurposing its lowest bit. Based on the bit-flag value we clear the child
> sk_user_data pointer after cloning the parent socket.
> 
> The no-copy flag is stored in the pointer itself as opposed to externally,
> say in socket flags, to guarantee that the pointer and the flag are copied
> from parent to child socket in an atomic fashion. Parent socket state is
> subject to change while copying, we don't hold any locks at that time.
> 
> This approach relies on an assumption that sk_user_data holds a pointer to
> an object aligned to 2 or more bytes. A manual audit of existing users of
> rcu_dereference_sk_user_data helper confirms it. Also, an RCU-protected
> sk_user_data is not likely to hold a pointer to a char value or a
> pathological case of "struct { char c; }". To be safe, warn when the
> flag-bit is set when setting sk_user_data to catch any future misuses.
> 
> It is worth considering why clearing sk_user_data unconditionally is not an
> option. There exist users, DRBD, NVMe, and Xen drivers being among them,
> that rely on the pointer being copied when cloning the listening socket.
> 
> Potentially we could distinguish these users by checking if the listening
> socket has been created in kernel-space via sock_create_kern, and hence has
> sk_kern_sock flag set. However, this is not the case for NVMe and Xen
> drivers, which create sockets without marking them as belonging to the
> kernel.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

LGTM.
Acked-by: John Fastabend <john.fastabend@gmail.com>

> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index e6ffdb47b619..f6c83747c71e 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -535,6 +535,10 @@ static void tcp_bpf_remove(struct sock *sk, struct sk_psock *psock)
>  {
>  	struct sk_psock_link *link;
>  
> +	/* Did a child socket inadvertently inherit parent's psock? */
> +	if (WARN_ON(sk != psock->sk))
> +		return;
> +

Not sure if this is needed. We would probably have hit problems before
we get here anyways for example if the parent sock was deleted while
the child is still around. I think I would just drop it.

>  	while ((link = sk_psock_link_pop(psock))) {
>  		sk_psock_unlink(sk, link);
>  		sk_psock_free_link(link);
> -- 
> 2.24.1
> 


