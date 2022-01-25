Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A9049AF08
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454335AbiAYI67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453435AbiAYI4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:56:22 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D3EC068081;
        Mon, 24 Jan 2022 23:54:54 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id u5so16101813ilq.9;
        Mon, 24 Jan 2022 23:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2W+udFU5NsZtns60icl5F/GlK0QBOVQF6hcovdrLxX8=;
        b=E5e8bl5jXV8NiVC489HE9pxffzjl4oHV/Hx5fCC7CuSgnQyUNFVKxsfDG3K2JUppt5
         yv06XmVVuXhMuRXC9krGhH13ar8lGO6+FcEx4ZkCy36M4eGuhvtADyXRGCBxjyALyoP3
         TtMGVn2hYDjwANi4PkpSM+NO/0AQM/jYDymYYiAEwfaJCJ2okIZfaM4DudDj2uMS1Sx2
         KuL2AhA33Nk5MFl10B/Y+2E4GE6N1nXViUUfnqGS8FAJcRIOOG9fvq4okML3o+A2CU90
         TLu9xY3QPeATrSJPoVnQSwMprtisr1qf9gC+OUbGTLFfVMeQv3BUW4MO4FgyyJ8wTmem
         mAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2W+udFU5NsZtns60icl5F/GlK0QBOVQF6hcovdrLxX8=;
        b=4rS05UJWKcWUC1OpT/PLCVlGdvHPCpDrb+lazuNFqEAjWimUBKulW5pDZ+6UU4uYJh
         zBuyvoTYyfG2r0qts9iwqSFrXRTBCGu/1J/EdeYXZHzCL/0lzOwbdjHwi9GiemsPVuyQ
         ElqRuyFaWFMaC6cF/2OsfvZhJkCpvr6PZJ0PXuheJPUaM8Q3mi6dNGB/OanH3CBZu4Ri
         kIEuf0Y9g4LhhxVncOVYYOLrjNNg/MFhfv0Mkk9y9CK/LIvm3Ev4cjTctR7A+65ThTCx
         Fivx4/nKfZ9VRrt8hQoLLRA52qVSWQ2kZINN4BOPUALOzDFKCehkbzA3/fYVCxkVlNY6
         tyWA==
X-Gm-Message-State: AOAM532avYLYXgznL204HaogVylp8jRkfT2q+cjnjDoZQ21Su/UetxXm
        19u+ZNYTJvE1kxCQVJN8ujE=
X-Google-Smtp-Source: ABdhPJwes1JpWvcuHgBR6aD8tWy0/yv0ixxqO9OSQ0um+y8EsVzOwbhXNhkAeoBZWWofEr8M4afGzQ==
X-Received: by 2002:a92:cda6:: with SMTP id g6mr9254017ild.211.1643097293676;
        Mon, 24 Jan 2022 23:54:53 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id o11sm9279959ilu.36.2022.01.24.23.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 23:54:53 -0800 (PST)
Date:   Mon, 24 Jan 2022 23:54:46 -0800
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
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <61efacc6980f4_274ca2083e@john.notmuch>
In-Reply-To: <20220124151340.376807-3-maximmi@nvidia.com>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
Subject: RE: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
> to generate SYN cookies in response to TCP SYN packets and to check
> those cookies upon receiving the first ACK packet (the final packet of
> the TCP handshake).
> 
> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
> listening socket on the local machine, which allows to use them together
> with synproxy to accelerate SYN cookie generation.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---

[...]

> +
> +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
> +	   struct tcphdr *, th, u32, th_len)
> +{
> +#ifdef CONFIG_SYN_COOKIES
> +	u32 cookie;
> +	int ret;
> +
> +	if (unlikely(th_len < sizeof(*th)))
> +		return -EINVAL;
> +
> +	if (!th->ack || th->rst || th->syn)
> +		return -EINVAL;
> +
> +	if (unlikely(iph_len < sizeof(struct iphdr)))
> +		return -EINVAL;
> +
> +	cookie = ntohl(th->ack_seq) - 1;
> +
> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
> +	 * same offset so we can cast to the shorter header (struct iphdr).
> +	 */
> +	switch (((struct iphdr *)iph)->version) {
> +	case 4:

Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?
My code at least has already run the code above before it would ever call
this helper so all the other bits are duplicate. The only reason to build
it this way, as I see it, is either code can call it blindly without doing 
4/v6 switch. or to make it look and feel like 'tc' world, but its already
dropped the ok so its a bit different already and ifdef TC/XDP could
hanlde the different parts.


> +		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
> +		break;
> +
> +#if IS_BUILTIN(CONFIG_IPV6)
> +	case 6:
> +		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> +			return -EINVAL;
> +
> +		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
> +		break;
> +#endif /* CONFIG_IPV6 */
> +
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	if (ret > 0)
> +		return 0;
> +
> +	return -EACCES;
> +#else
> +	return -EOPNOTSUPP;
> +#endif
> +}
