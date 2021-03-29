Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A051A34DC4E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhC2XLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhC2XKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 19:10:55 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2B6C061764;
        Mon, 29 Mar 2021 16:10:55 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id d2so12604299ilm.10;
        Mon, 29 Mar 2021 16:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jv6PFKAUucHpBFhrF9VSZO543xfBl579pmmIAwDQX4M=;
        b=W5d7bH6by0mcK4Di6+HSdvaoRiA22KAsBP6sjLlaeb+/EdJprLKRGUeIY0leMLfVX9
         Xi1ICNpmALbL1O5cOfkPzbDOJGgsNab0zx+JhuIk0QPcc9fRlx6qCXAJ4T090oiV15mN
         HZ4QobRXLbO0os8y8KSrOZS/tAva4kl0C9OLcTaUcp4KizMdspIdx4mZ7zRchVNiucsu
         D2WNp3h8jZvsDcvm7L1EETXKcwFNV1kXcWTZpPe6oHGATJSSpsj92ib7+Oe/ZRHDKIcc
         qOtRP18BlPIT+0OXFw1zndZ0Nbhl/NWSTmWIf2tjMXxomG2ERywo0GwohYr0aSWvyrf0
         2JvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jv6PFKAUucHpBFhrF9VSZO543xfBl579pmmIAwDQX4M=;
        b=iCn0D6GfoZ2luiGLJEHAf5+8p8KTODN6LB+1LHdjH4U+x9tW6lYbCrgmbq2L5paGIi
         HNYd7DYSvjFfOeK3ftCC9TipkxIIb7XuZuumZp58kQi3NKPAayHwVHHRChFyrN9YD89M
         oJn37WziLrTjGEu5HaLvM2++ISEmH5EQEwd1Kv+b7a57CwRjI1khFGy68pU6o3vx8dDu
         vCRuxQrv/cfcJtO0wdiMiBbOxaCTXv6LKrpBNfzvbsAt6hOVSZIyHWti4LjCNhBdhKkN
         aQ4smiS0v9696Q+JPTpqmgaQaQxWtuS7hSTI25qIOrBaQur4FFUJZnfOEcvDRYa/02zi
         2Qrg==
X-Gm-Message-State: AOAM531GE6rc5Ur31ylvPuBvKZwAMDOPpzVrTmEujLAl5z/+F9f82g8t
        4kiLEvmB/gxVkfXKfkDFrB8=
X-Google-Smtp-Source: ABdhPJxzPzHzeMM3qv+l6WUHcs6tp2vVnjBC+cbLf2vrGzRNeoIRzr9+h/GXbowGdYRHwJaFqwzhvw==
X-Received: by 2002:a05:6e02:14c2:: with SMTP id o2mr23377235ilk.91.1617059454721;
        Mon, 29 Mar 2021 16:10:54 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id n11sm10098465ioa.34.2021.03.29.16.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 16:10:54 -0700 (PDT)
Date:   Mon, 29 Mar 2021 16:10:47 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60625e778b72_401fb2084b@john-XPS-13-9370.notmuch>
In-Reply-To: <20210328202013.29223-13-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-13-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v7 12/13] sock_map: update sock type checks for
 UDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Now UDP supports sockmap and redirection, we can safely update
> the sock type checks for it accordingly.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/core/sock_map.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index d04b98fc8104..9ed040c7d9e7 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
>  
>  static bool sock_map_redirect_allowed(const struct sock *sk)
>  {
> -	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
> +	if (sk_is_tcp(sk))
> +		return sk->sk_state != TCP_LISTEN;
> +	else
> +		return sk->sk_state == TCP_ESTABLISHED;
>  }
>  
>  static bool sock_map_sk_is_suitable(const struct sock *sk)
> -- 
> 2.25.1
> 

I think its a bit odd for TCP_ESTABLISHED to work with !tcp, but
thats not your invention so LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
