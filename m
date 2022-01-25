Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE949AE35
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378869AbiAYIiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450881AbiAYIeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:34:21 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F03C067A65;
        Mon, 24 Jan 2022 23:06:36 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id z4so870524ilz.4;
        Mon, 24 Jan 2022 23:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XkEXtjfj5tnMePJhCr34XCaoEd1OT4vImrqiyvQGwjI=;
        b=HfwAH3hAOJweTswFlUQ/SNXg3BnH31JU1JBtiB8BAfd4rUcCbLOLC3DXHFZZSbTZIg
         6D8lBuy195UIs3UlvUyjzL56qAudRVdcXLhIODB8wL4IGb7k1yEUyrb77jLScF6q/Eef
         X8yqdHntE30WlgX4x9E+6IAST0MYSJptWdMSZrfHCIR/fQNWqcwrh15Us8o2oHr1GFm4
         sKZO7QvdIqUU5GGeXuyU2vjziCJHH08yTOEeWcQgVO+7TDiYs+tbyZKxYDPhm5/WLSzQ
         GcL6uDPnSAsL9vIJu7d+27IWEW8EQtbAaRvbmtd4em9xdZTvC0O0pKJkQgRna+00lNvZ
         RZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XkEXtjfj5tnMePJhCr34XCaoEd1OT4vImrqiyvQGwjI=;
        b=Eup7uEawU0mUV0VILF8Iiy4aLsyJIU6OPEVqFbHsk7rEPVVwfP0KWb6QbOEV3Vc/3J
         Jcr//cbpo0vnqcp3d5Cx0mp7cBWi6xE7nQP5VDVa3AmiBn+zkfb4fj8gBMoTWs5UWkDo
         /Easd+YRr9XB/aJnM6/fl1KNYDX0ka7d7LqGy+vEmkxEYf7BRb0V4kY7FC/oJrlraG44
         Zbd6J3S5FbXmMNQTLLcx/7tkp+Ul8YFqBZa02q6kyOexz4t2JKc7ZBjzcIE2gUZXA/qf
         HCP7bFA6mYKpTu5EwtNy/clJwY7RYz6GxPZWDXc0bCn89bLR0i5IGQv1KWj1JKuCQobB
         mw9w==
X-Gm-Message-State: AOAM533TzAy16bYCMa73pnYyFVKr37/rFnEzd4sZTlE43G0HBm0f3Zw0
        7MNzJpZkF5G+NZfnU48rzMw=
X-Google-Smtp-Source: ABdhPJx9w8Fz8i2yQXSJZnqRxlTcoTdTcYjAj2ZeMfBIR5za0cG2/bQFx+ms06APnXEHCIZeiPsA7Q==
X-Received: by 2002:a05:6e02:19cd:: with SMTP id r13mr10793858ill.89.1643094395674;
        Mon, 24 Jan 2022 23:06:35 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id d8sm7837025ilg.81.2022.01.24.23.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 23:06:35 -0800 (PST)
Date:   Mon, 24 Jan 2022 23:06:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <61efa17548a0_274ca2089c@john.notmuch>
In-Reply-To: <20220124151146.376446-4-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
 <20220124151146.376446-4-maximmi@nvidia.com>
Subject: RE: [PATCH bpf v2 3/4] bpf: Use EOPNOTSUPP in bpf_tcp_check_syncookie
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> When CONFIG_SYN_COOKIES is off, bpf_tcp_check_syncookie returns
> ENOTSUPP. It's a non-standard and deprecated code. The related function
> bpf_tcp_gen_syncookie and most of the other functions use EOPNOTSUPP if
> some feature is not available. This patch changes ENOTSUPP to EOPNOTSUPP
> in bpf_tcp_check_syncookie.
> 
> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

This came up in another thread? Or was it the same and we lost the context
in the commit msg. Either way I don't think we should start one-off
changing these user facing error codes. Its not the only spot we do this
and its been this way for sometime.

Is it causing a real problem?

> ---
>  net/core/filter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 780e635fb52a..2c9106704821 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6814,7 +6814,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>  
>  	return -ENOENT;
>  #else
> -	return -ENOTSUPP;
> +	return -EOPNOTSUPP;
>  #endif
>  }
>  
> -- 
> 2.30.2
> 
