Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F92293372
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390958AbgJTDIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390952AbgJTDII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 23:08:08 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788E0C0613CE;
        Mon, 19 Oct 2020 20:08:08 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id z2so463632ilh.11;
        Mon, 19 Oct 2020 20:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5lJyEo7KXPKHiht9CRtCwqcK3OQPKIQh4fHOIgIHyHc=;
        b=iyPVc69cqmP0czajK3Hq3x+RmDDxnmk1Ej3KSQPkdDFS9XWHUHmrvTYcSXI9oX+h3t
         7j2kvYmYxFAWNqFX1AKocy71n5vRsnt8LwKnoZmFL6LHFxIKzHpDw9WvZ5SQ+pCunH7i
         ymfuvDuf9qDaIeHprKQDnq15Ez6xgcLJwFxu7onY6SrMUwuf6GNdCHKhLhObxDrhg6Hc
         0Tk5g5DzfoybFN9DYWzxwWOAdnQ3Sjy/6Y8FUXpbY0kmPpm3/VvuWUaiOfnPy2XOg6i6
         wf14JXl3NPk2K2etAlDOZD1YbUEOU9qQD0zw6Rmk+ls3oOyHG3TmcpJK34jg82f2WZJY
         63DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5lJyEo7KXPKHiht9CRtCwqcK3OQPKIQh4fHOIgIHyHc=;
        b=JmSdZJ1C6fdi4hIw8djH+vgLI+oMYEmFTeRPIM8SFQjbjFZvsYqQmO4YyUf9bIoQeM
         ZUALn4uwSsyiQQUhjYTeU9loqKtmZiqx7us9NxGB6bPN5PJkCc6sFaXUfDTnmnUuLa4c
         CuECletVuq6ONcHAxGw75e6XVyGCvQPYM8aC0dVTp0JTbz5tmja9gDz46WyaT0cRn0vS
         +TZu8GdJWr9/TdvovQbYufRtFMtaiB+s1va5nPDHvNg27OvCC6uQdiU+IJL57z2EyxV1
         FYO8ndl7rIcUAwWAyFwVLUFQ6e8QSLPyepryeRkR4IVxw0sVhyQWZHucwIWKyDDrZXWP
         wAQw==
X-Gm-Message-State: AOAM533v2HNyfNVgRFiR/ub7Bbe/G2ZPvI6uo/DSHAomdVM8bGoQRFcT
        TaL8bVs8BxldmktbZRvLEqyxcvz/WNg=
X-Google-Smtp-Source: ABdhPJzzH2CsAZPEu4Qnz69GkJXvw2Dw7h/JvfoFjiw//3jdDBJRDaKPGQAR7NLWECizCh8hndROZw==
X-Received: by 2002:a92:d390:: with SMTP id o16mr398197ilo.213.1603163287803;
        Mon, 19 Oct 2020 20:08:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9d8a:40ec:eef5:44b4])
        by smtp.googlemail.com with ESMTPSA id z15sm535615ioj.22.2020.10.19.20.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 20:08:07 -0700 (PDT)
Subject: Re: [PATCH bpf 1/2] bpf_redirect_neigh: Support supplying the nexthop
 as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160312349392.7917.6673239142315191801.stgit@toke.dk>
 <160312349501.7917.13131363910387009253.stgit@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <77ba3525-acde-97e0-77b8-057d31f0c40a@gmail.com>
Date:   Mon, 19 Oct 2020 21:08:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <160312349501.7917.13131363910387009253.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 10:04 AM, Toke Høiland-Jørgensen wrote:
> @@ -4906,6 +4910,16 @@ struct bpf_fib_lookup {
>  	__u8	dmac[6];     /* ETH_ALEN */
>  };
>  
> +struct bpf_redir_neigh {
> +	/* network family for lookup (AF_INET, AF_INET6) */
> +	__u8	nh_family;

Define every byte. This is a 3-byte hole that should have unused's and
the helper verifies they are set to 0.

> +	/* network address of nexthop; skips fib lookup to find gateway */
> +	union {
> +		__be32		ipv4_nh;
> +		__u32		ipv6_nh[4];  /* in6_addr; network order */
> +	};
> +};
> +
>  enum bpf_task_fd_type {
>  	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
>  	BPF_FD_TYPE_TRACEPOINT,		/* tp name */


