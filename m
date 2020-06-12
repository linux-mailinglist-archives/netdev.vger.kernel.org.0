Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3631F7F5C
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 00:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFLWzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 18:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgFLWy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 18:54:59 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E052C03E96F;
        Fri, 12 Jun 2020 15:54:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b7so4613585pju.0;
        Fri, 12 Jun 2020 15:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Q2qobjuAF28bP+3u+Qy2o1ImH08surERhhHrzteCYZc=;
        b=UqvTO5L9J+u1FDsOiadMw01P8aSp5wcMpaA41Nv/N4FEuBJBCPiUVwANBejwnxPrHQ
         kWuqMCipvAz8bJTVPqjVNX6EFUo7KWZ1+h/xbDf8uEPDHPojJhDVmTfsSceJ4YHkp9kP
         ywQSQYdhEJ254HRC8T0jUKMj0jqg5eqA5ek9GvH5Tdq3CdDZsLmJnDKZ7CR/+5sSmFUQ
         +0f4pmoSv6L+xLOqsdgTjWwZmLESlmHbR6DwfreLtWqVz6F2UqYrRVwbb7x0r/dizR8+
         M8shcEo7UsoR9KZr6waHf0KOlMEW6jMWqeucMvmKoYK9swtqxIqB3w6qfO+GfTDuDgZr
         6J1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Q2qobjuAF28bP+3u+Qy2o1ImH08surERhhHrzteCYZc=;
        b=Tsi58mpLkeXtVZxRSwUmpLEERtXA13xWaGTxuWbeIiMDgh8Gjfzqv2PSQ5dDYeQmV2
         +WV3A6sc430Gb4il2BfXYgAofZuqvasAv7VIevVCtX+jRDkkxcrHw4O8NRscrJZ3w8zU
         vIopVPqn5qUC4MSJsEMa2psE5nAwfqrLHPYx3p7hJk12mJyRPepOg4K5JD5sUbO2riJf
         qjZjN/TIg12Pq/GftTesslpj0a8VGGi6IrdQU8cW7+fggRyFv+5Km0+BjRpNZDKKPU5N
         HnOJU68+D9T/RXTpv6397zKqXe070i9eQY6Nl8LlYj6LKEX4tOqSryR8SKVyolocKtGX
         O66A==
X-Gm-Message-State: AOAM5306tC5cxpgSxpvCxmdbfzNKv1h8KO9KVumr2cJbKDGIhwMf90tq
        lLcEe08ScaILHgeuscNpwGc=
X-Google-Smtp-Source: ABdhPJzaXEr+pFgrrJMcfhWdyDY3RvFohXLELfjWMAwZTO77uKfJEfCKF8REJ6eLscIDlm5x8s1gqA==
X-Received: by 2002:a17:90b:1013:: with SMTP id gm19mr1058904pjb.231.1592002498641;
        Fri, 12 Jun 2020 15:54:58 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b14sm6874708pft.23.2020.06.12.15.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 15:54:57 -0700 (PDT)
Date:   Fri, 12 Jun 2020 15:54:48 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5ee407b8ab7d6_489d2af902f845b4f5@john-XPS-13-9370.notmuch>
In-Reply-To: <20200612121750.0004c74d@toad>
References: <20200611172520.327602-1-lmb@cloudflare.com>
 <20200612121750.0004c74d@toad>
Subject: Re: [PATCH bpf] bpf: sockmap: don't attach programs to UDP sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Thu, 11 Jun 2020 18:25:20 +0100
> Lorenz Bauer <lmb@cloudflare.com> wrote:
> 
> > The stream parser infrastructure isn't set up to deal with UDP
> > sockets, so we mustn't try to attach programs to them.
> > 
> > I remember making this change at some point, but I must have lost
> > it while rebasing or something similar.
> > 
> > Fixes: 7b98cd42b049 ("bpf: sockmap: Add UDP support")
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  net/core/sock_map.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 00a26cf2cfe9..35cea36f3892 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -424,10 +424,7 @@ static int sock_map_get_next_key(struct bpf_map *map, void *key, void *next)
> >  	return 0;
> >  }
> >  
> > -static bool sock_map_redirect_allowed(const struct sock *sk)
> > -{
> > -	return sk->sk_state != TCP_LISTEN;
> > -}
> > +static bool sock_map_redirect_allowed(const struct sock *sk);
> >  
> >  static int sock_map_update_common(struct bpf_map *map, u32 idx,
> >  				  struct sock *sk, u64 flags)
> > @@ -508,6 +505,11 @@ static bool sk_is_udp(const struct sock *sk)
> >  	       sk->sk_protocol == IPPROTO_UDP;
> >  }
> >  
> > +static bool sock_map_redirect_allowed(const struct sock *sk)
> > +{
> > +	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
> > +}
> > +
> >  static bool sock_map_sk_is_suitable(const struct sock *sk)
> >  {
> >  	return sk_is_tcp(sk) || sk_is_udp(sk);
> 
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>

Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
