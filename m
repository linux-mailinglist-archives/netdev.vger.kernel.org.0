Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC0144D6BC
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhKKMpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 07:45:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhKKMpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636634565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fPafqF04Ml1+cJ00vdO1ANZXi9IE+FbvZdSrM9aGh+c=;
        b=Qs/9L9adBa/bHCqQTnT8OGOjpeWeU5LcMbsQl3ywXC4FaJVco2WlMMaMQTg6pozSnenI8s
        4kGcN9Snnony9YBQ5w5f7wld1tOJj4eZOn8PBDxadUe4oVdVfoy1IMR3/ED/7rAaPkv7Od
        VbnKhs3PS5BaS3FBsI1XWsp+NUbsTpY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-LM60xVgZMSKHncxwhwr8Wg-1; Thu, 11 Nov 2021 07:42:43 -0500
X-MC-Unique: LM60xVgZMSKHncxwhwr8Wg-1
Received: by mail-ed1-f72.google.com with SMTP id f4-20020a50e084000000b003db585bc274so5269092edl.17
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 04:42:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fPafqF04Ml1+cJ00vdO1ANZXi9IE+FbvZdSrM9aGh+c=;
        b=tmXFe0Nmzdbof6tCOZDQnyKLjN3tZAz7ktcq7Kh7ppmeL8BUsm1jVmlVQK1cUNi9nX
         B++W8H1wZEDuxdLofh4/L97ZrpS3qSZD9QpjW7h0lyNwwzoSJ5JYFu1TvQT8AQsXe4kA
         dt3YNM73hO2wAVfMqC6DeN5/U8xd3oEJQEcolYd3rNkFZ3J+0FAIdHHAPNv+PFqhJ3Jq
         Sj7g6M6icu74oLBob18SJ5ckZ3niSlNJRRyo+9Q96gE5a8oEERR39HysknAsNAnh197V
         vv6s+KatGaGnpgQL5S7jCtv3zgzrYqT4qbz2/9Aeg8cHRPOU3qk1b304gKDbOi6zwbin
         ghVQ==
X-Gm-Message-State: AOAM533eeOFSQzsenpBGzGgun0vKKm+a0gUE5xvQxMF6/4oZeh+xuZdx
        B3bMTZ+OdVN9Y9wM/C4kmZnut/XkgU3uQVUgUyxZn6l4Eh0y4qJe3yyQZX03FSsQRk8hUEafZ7m
        N0mhB78u5PRXe2UuC
X-Received: by 2002:aa7:d912:: with SMTP id a18mr9490825edr.16.1636634562713;
        Thu, 11 Nov 2021 04:42:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBz4UPE2DiWrJkHtRJYYPWa5Jbt6jA28ALpBK3qIxytn2EwGG+a7qWVKwOQNbYUmJdPEhZAg==
X-Received: by 2002:aa7:d912:: with SMTP id a18mr9490794edr.16.1636634562533;
        Thu, 11 Nov 2021 04:42:42 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-224-97.dyn.eolo.it. [146.241.224.97])
        by smtp.gmail.com with ESMTPSA id gn26sm1313530ejc.14.2021.11.11.04.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 04:42:42 -0800 (PST)
Message-ID: <716a0806cfa4a166e49e865f0b7cf1b18e2a7011.camel@redhat.com>
Subject: Re: [PATCH net] selftests/net: udpgso_bench_rx: fix port argument
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        Willem de Bruijn <willemb@google.com>
Date:   Thu, 11 Nov 2021 13:42:40 +0100
In-Reply-To: <20211111115717.1925230-1-willemdebruijn.kernel@gmail.com>
References: <20211111115717.1925230-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-11-11 at 06:57 -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The below commit added optional support for passing a bind address.
> It configures the sockaddr bind arguments before parsing options and
> reconfigures on options -b and -4.
> 
> This broke support for passing port (-p) on its own.
> 
> Configure sockaddr after parsing all arguments.
> 
> Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  tools/testing/selftests/net/udpgso_bench_rx.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
> index 76a24052f4b4..6a193425c367 100644
> --- a/tools/testing/selftests/net/udpgso_bench_rx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_rx.c
> @@ -293,19 +293,17 @@ static void usage(const char *filepath)
>  
>  static void parse_opts(int argc, char **argv)
>  {
> +	const char *bind_addr = NULL;
>  	int c;
>  
> -	/* bind to any by default */
> -	setup_sockaddr(PF_INET6, "::", &cfg_bind_addr);
>  	while ((c = getopt(argc, argv, "4b:C:Gl:n:p:rR:S:tv")) != -1) {
>  		switch (c) {
>  		case '4':
>  			cfg_family = PF_INET;
>  			cfg_alen = sizeof(struct sockaddr_in);
> -			setup_sockaddr(PF_INET, "0.0.0.0", &cfg_bind_addr);
>  			break;
>  		case 'b':
> -			setup_sockaddr(cfg_family, optarg, &cfg_bind_addr);
> +			bind_addr = optarg;
>  			break;
>  		case 'C':
>  			cfg_connect_timeout_ms = strtoul(optarg, NULL, 0);
> @@ -341,6 +339,11 @@ static void parse_opts(int argc, char **argv)
>  		}
>  	}
>  
> +	if (!bind_addr)
> +		bind_addr = cfg_family == PF_INET6 ? "::" : "0.0.0.0";
> +
> +	setup_sockaddr(cfg_family, bind_addr, &cfg_bind_addr);
> +
>  	if (optind != argc)
>  		usage(argv[0]);
>  
LGTM, thanks Willem,

Acked-by: Paolo Abeni <pabeni@redhat.com>

