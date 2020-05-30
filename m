Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954AC1E9265
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgE3Pvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 11:51:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49037 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728927AbgE3Pvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 11:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590853901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T0Lu+lmTMR1GonhEKL4kTfNnILEmWnuXbiCGc9IKu1o=;
        b=LFauSk/mGGIKfvRZhRds2XYApu14k0s486X7amORZidpJ68YMyNIm52dxW9VI5AGQew4gY
        Kw1wMBjym5B0D9B0C9dv0P/ZwOVkWCW55j56U4qXL88uOK31sLUOxc5yHNuxSUIL+z2hk7
        j9/QKuiJT2cdF8EiRuK9hi9Af1b7hzI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-mPGdDA2FMOO5Sgatl7T6VQ-1; Sat, 30 May 2020 11:51:40 -0400
X-MC-Unique: mPGdDA2FMOO5Sgatl7T6VQ-1
Received: by mail-wm1-f72.google.com with SMTP id s15so1625729wmc.8
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 08:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T0Lu+lmTMR1GonhEKL4kTfNnILEmWnuXbiCGc9IKu1o=;
        b=rSZp2QH1FNpdQHZtK+lwiWDRQHeyUm0wYIeG234MXeszCEanCGPHPLnmdtWu/p+LZZ
         bSYhWNwmPMLJaD3oiUH3ytL/YUFiHiwZ7zaQcu4RFMjg565NCZAcFdsZMXwuQ4UU2+lo
         0Bo2+8t+U+RdRha5aqVzg30Q+l259F2KqN8eTxRDq47KtnArQ33mXdCG0uX1+CzK9aC9
         I0Dv6v9/AXd3TT2N2buzNkeIzZNXfg6XNtK1yDF6hmNE1oYG/lspEsONrAH3Nt2htRF4
         2XNnPuOIeqnCJIEgYpElo6je5bgzr0uHpqR748XwCsLdGw7yeVTEdtQaGEtMm1wIf/K9
         RQyQ==
X-Gm-Message-State: AOAM531XBGLzphWZNRPbRQoIq9rdnEgrvslQ7ogWbsPa1A2pD80BQZt3
        HNT3PCwADj/xHNd9A7OXD4Bp82IhO/5rX5BhUUlb64KOd0rKx1f9YRy4UfdusVg4Jrtf76xDwxo
        bLZqq0lG3qasW4cDT
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr13338133wru.194.1590853899103;
        Sat, 30 May 2020 08:51:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIayqCnq1HFd4eXHCYr76m1nhJFdgaM+ickdPUSPCiNQxWvhJLM14kvS0e9RzDtWJSEg0rkg==
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr13338120wru.194.1590853898937;
        Sat, 30 May 2020 08:51:38 -0700 (PDT)
Received: from pc-3.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id a124sm4435553wmh.4.2020.05.30.08.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 08:51:38 -0700 (PDT)
Date:   Sat, 30 May 2020 17:51:36 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        James Chapman <jchapman@katalix.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] l2tp: add sk_family checks to l2tp_validate_socket
Message-ID: <20200530155136.GA31596@pc-3.home>
References: <20200529183225.150288-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529183225.150288-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 11:32:25AM -0700, Eric Dumazet wrote:
> syzbot was able to trigger a crash after using an ISDN socket
> and fool l2tp.
> 
> Fix this by making sure the UDP socket is of the proper family.
> 
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1458,6 +1458,9 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
>  	if (sk->sk_type != SOCK_DGRAM)
>  		return -EPROTONOSUPPORT;
>  
> +	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
> +		return -EPROTONOSUPPORT;
> +
>  	if ((encap == L2TP_ENCAPTYPE_UDP && sk->sk_protocol != IPPROTO_UDP) ||
>  	    (encap == L2TP_ENCAPTYPE_IP && sk->sk_protocol != IPPROTO_L2TP))
>  		return -EPROTONOSUPPORT;
> 
Thanks a lot!

Acked-by: Guillaume Nault <gnault@redhat.com>

