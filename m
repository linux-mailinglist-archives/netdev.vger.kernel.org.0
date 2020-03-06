Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B78017C1A6
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCFPZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:25:44 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:44578 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgCFPZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:25:43 -0500
Received: by mail-pg1-f172.google.com with SMTP id n24so1215549pgk.11;
        Fri, 06 Mar 2020 07:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=U0f7F5SJ5+QRDlAY1wTE5bYTykTqGGdr3VIDJvfMX9U=;
        b=td1xiA8vNOG/zx1dA/9Svjes7a/vUU/L+C1MrQ9paZNHbMmIIvzK1CIUffxUlR/N9m
         vuMRkdgTtceI34WKAhyQZThOH+j+GpOuGjSEav3MctVCUkHWiUG9Vx4xGNE+C0C/9IRb
         bjgFi/EnuLcnhuVAhOZqP/3mzS8h/JPgM1r5bAxkuIJJpt5OrZWHUMFQwhuwMictEsnR
         D1lrKqjdBm8PuCu0KsrZf+t4/rw/2fXSfI077UtQXy2i3m0kxngHOEs5bqXkvuy/uHD5
         A1WfuMCosqPUMkNRcY64tfLmO3vTkwzNa3KI6A7G8UvHXv7tpd6Y9FR7vOFVgrSV+BDD
         u2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=U0f7F5SJ5+QRDlAY1wTE5bYTykTqGGdr3VIDJvfMX9U=;
        b=SYBxsXW4+OskEd1ab4gwux/83pPCEa8rRHDttz0lXwxgUYnnFRCjDgYg0akvr9STRU
         xEVRWRegxS7a1/eCNMg2ATeB9wvWB18waK2kSeOu0GfbYchLYCyTb0FZuylfzNhqP/Tw
         qixgrtI5QKSurIVeYJOJf+LaYFoBCBlpcxM2YzMnpjvOnAT91AzUHQtrcYsDZvh1KIci
         skj8/FlCj6KrIpSNMWnVwFZz7wjLx0KFZFA2eZP/g39IAgYbIUnbz5FgVhNOfbx4rsU5
         oDAzLEz78vB+laVGUQbwl9pdVIY0giPoUkhTSZV7BIfAOWJPc+N4Htji5Gzu41fxoeNU
         2RgA==
X-Gm-Message-State: ANhLgQ3FM2WvDGnDfPJDdZnOYx9MMfCAcVdgDQLNNhwABG7VdIQOhipo
        HULrhddpANfwC+GLQlpoo/s=
X-Google-Smtp-Source: ADFU+vvFswTWSOFzoCgpKWpMnxUox1t9/PId67LHlatzi8Z2lX+XDaSQ7Z/XqGooyrLO0Zbwo0Iq1Q==
X-Received: by 2002:a63:1459:: with SMTP id 25mr3941888pgu.427.1583508341870;
        Fri, 06 Mar 2020 07:25:41 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q187sm35905013pfq.185.2020.03.06.07.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:25:40 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:25:32 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e626b6c364eb_17502acca07205b427@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-4-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-4-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 03/12] bpf: tcp: move assertions into
 tcp_bpf_get_proto
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> We need to ensure that sk->sk_prot uses certain callbacks, so that
> code that directly calls e.g. tcp_sendmsg in certain corner cases
> works. To avoid spurious asserts, we must to do this only if
> sk_psock_update_proto has not yet been called. The same invariants
> apply for tcp_bpf_check_v6_needs_rebuild, so move the call as well.
> 
> Doing so allows us to merge tcp_bpf_init and tcp_bpf_reinit.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Small nit if you update it just carry the acks through.

Acked-by: John Fastabend <john.fastabend@gmail.com>
 
>  	skb_verdict = READ_ONCE(progs->skb_verdict);
> @@ -191,18 +191,14 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
>  			ret = -ENOMEM;
>  			goto out_progs;
>  		}
> -		sk_psock_is_new = true;
>  	}
>  
>  	if (msg_parser)
>  		psock_set_prog(&psock->progs.msg_parser, msg_parser);
> -	if (sk_psock_is_new) {
> -		ret = tcp_bpf_init(sk);
> -		if (ret < 0)
> -			goto out_drop;
> -	} else {
> -		tcp_bpf_reinit(sk);
> -	}
> +
> +	ret = tcp_bpf_init(sk);
> +	if (ret < 0)
> +		goto out_drop;
>  
>  	write_lock_bh(&sk->sk_callback_lock);
>  	if (skb_progs && !psock->parser.enabled) {
> @@ -239,12 +235,9 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
>  	if (IS_ERR(psock))
>  		return PTR_ERR(psock);
>  
> -	if (psock) {
> -		tcp_bpf_reinit(sk);
> -		return 0;
> -	}
> +	if (!psock)
> +		psock = sk_psock_init(sk, map->numa_node);
>  
> -	psock = sk_psock_init(sk, map->numa_node);
>  	if (!psock)
>  		return -ENOMEM;

also small nit this reads,

 if (!psock)
    psock = ...
 if (!psock)
    return -ENOMEM

how about,

 if (!psock) {
   psock = ...
   if (!psock) return -ENOMEM;
 }
