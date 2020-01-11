Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB3213841D
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbgAKXsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:48:52 -0500
Received: from mail-io1-f46.google.com ([209.85.166.46]:44194 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731713AbgAKXsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:48:51 -0500
Received: by mail-io1-f46.google.com with SMTP id b10so5883690iof.11;
        Sat, 11 Jan 2020 15:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vs9lHo/KQbsS1DreZMBHmW2Oy9iZh7JjqeyUwst+YS8=;
        b=ZIfUjj+TouJgGsnOQOKrwsSYpyqFWEgA56RHQgCuVKTm5S+WtxHiUHYMIzzplOrt7q
         yB1XV9LqDT8S3wAdB9nr5nTrbA6TY0G0mjL4qBMTFcVWZvcURUF1JBj8Kpearhhv2apj
         1W3hqS3Pm+wFWojb4GSi4pAaDFaNz5fo/2QS2HLg8+rXdFB+AH8LWyedPCaeheJbbDil
         EmTKKNeSVHBshF+Lln4iuovhytRMoGQkH8DnYxNRjV8K0+XfOum6duRW1ekPy2tF9X65
         DOOUGGFl+brrGDVuYoFaz5qT5gvWwocEt9sGEG3SaaLUzGgOkz6hhUJFd6+3E7RWR5NV
         8Aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vs9lHo/KQbsS1DreZMBHmW2Oy9iZh7JjqeyUwst+YS8=;
        b=YMTwSS02VAKUFCF69jQcmE2tGZ8GCOjAiDhdieBjhcK+hLRes1+vqDJwuGdzyu4zDL
         GSLSAplU4h+U3Pf+8AM8J0lox/1RsOtIpWZ44QpKmNWL8B6BRlRmhaONdYsRMWd/KHQ6
         HZ7z8BTjx3CYY8E0BaYFsurgITN1a9vJWFmrlxbjoVOKBffFJH5MjVpl/OQXX11+vaYp
         6kAT/XWnHJ7lIOZrk7ZBqhxelLG35c73zDqOjEnX/5mZO97doa+rcLTNRmCPt6z8X64C
         yN1qEAUhiXTh6BpHlCUmGYuudkNJ4nw3MauVEc2d9HLEZYvTrn4o8m5ECcSlzj/cOZci
         XP4Q==
X-Gm-Message-State: APjAAAW+9UXcjFDpP5Or9beUAeigOJjwb40/Eqxg4NfUaeoc49dMG+3q
        2WZ5sQLam/LeuGrYYcCjxQ4=
X-Google-Smtp-Source: APXvYqyE2qTOdaOMdeYP4NGS18IC+HxCIlH4OMmNN/ULmEo4Gdknj3r3a9ot9FZduilzxmVjG+UBWw==
X-Received: by 2002:a6b:5b0e:: with SMTP id v14mr7393315ioh.154.1578786531299;
        Sat, 11 Jan 2020 15:48:51 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a3sm1603674iot.87.2020.01.11.15.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 15:48:50 -0800 (PST)
Date:   Sat, 11 Jan 2020 15:48:41 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a5ed97885d_1e7f2b0c859c45c0d7@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-5-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-5-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 04/11] tcp_bpf: Don't let child socket inherit
 parent protocol ops on copy
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Prepare for cloning listening sockets that have their protocol callbacks
> overridden by sk_msg. Child sockets must not inherit parent callbacks that
> access state stored in sk_user_data owned by the parent.
> 
> Restore the child socket protocol callbacks before the it gets hashed and
> any of the callbacks can get invoked.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/net/tcp.h        |  1 +
>  net/ipv4/tcp_bpf.c       | 13 +++++++++++++
>  net/ipv4/tcp_minisocks.c |  2 ++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 9dd975be7fdf..7cbf9465bb10 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2181,6 +2181,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  		    int nonblock, int flags, int *addr_len);
>  int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>  		      struct msghdr *msg, int len, int flags);
> +void tcp_bpf_clone(const struct sock *sk, struct sock *child);
>  
>  /* Call BPF_SOCK_OPS program that returns an int. If the return value
>   * is < 0, then the BPF op failed (for example if the loaded BPF
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index f6c83747c71e..6f96320fb7cf 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -586,6 +586,19 @@ static void tcp_bpf_close(struct sock *sk, long timeout)
>  	saved_close(sk, timeout);
>  }
>  
> +/* If a child got cloned from a listening socket that had tcp_bpf
> + * protocol callbacks installed, we need to restore the callbacks to
> + * the default ones because the child does not inherit the psock state
> + * that tcp_bpf callbacks expect.
> + */
> +void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
> +{
> +	struct proto *prot = newsk->sk_prot;
> +
> +	if (prot->recvmsg == tcp_bpf_recvmsg)
> +		newsk->sk_prot = sk->sk_prot_creator;
> +}
> +

^^^^ probably needs to go into tcp.h wrapped in ifdef NET_SOCK_MSG with
a stub for ifndef NET_SOCK_MSG case.

Looks like build bot also caught this.
