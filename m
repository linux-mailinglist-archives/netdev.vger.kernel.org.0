Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCF94A5130
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 22:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240849AbiAaVMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 16:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiAaVMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 16:12:39 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7664C061714;
        Mon, 31 Jan 2022 13:12:38 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p63so17801855iod.11;
        Mon, 31 Jan 2022 13:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=eQEG6jy9BWsAyEBx6ILTdnPSlhitzjQY3ldZv0CPhSs=;
        b=JwS6KvijBayJNJWezyT0f01VGikWNDxlGbXPXW37fcY/o54qU8cDHSY6lION88HWh6
         PZQ5KmzpJz6AHwfv7KinMO8uitdFwlwR7okw3rK/gAaG3y97JHthCMXd6SFLVLL//vCm
         I2iUZwk03vfZNGY8glmJwyZLJMWvKEwbEAGbQ0uasOwcvUE6tCDdWbsRBSq9nay0gKQM
         81b9HRopOQuoG0WzuOm1lgyQWcxqfbuEGZmCNwA2e54+YpTsTK+310Vsbz3Ppo8+meb3
         EipVtNmAoR3P93ix47S2+ZSfhe8oAzamgtgfRCPg8adai6GTdTFekaHwzBTH1u1vYxuq
         6cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=eQEG6jy9BWsAyEBx6ILTdnPSlhitzjQY3ldZv0CPhSs=;
        b=i5JofJaLwsdhFctA3ICV92c0SvDxUWrzVC9Z4LPJlMU6Oj3hkyD0tjqd6IBD8Z7GkH
         tBdmn2BCRXtNcbxPs7ZEB0HLDtgvLC34ufiqlZ6OX713l8UVv3nTvD94XJmugs/YJi9H
         P9yv8HfpfE9DeYe+MsCYurgTcTjgx8e+s/OP3ye7oENmHOr4DZjzXBCs5tWhCOXt2N6t
         V1COVVqi+K94Ko538VHmcE/lZlCLt7KBTGnyJUG989fQdtgxW8LJOQK7tjf4ywH/0TJ6
         SdpKdBqUy3mh5Ic0RNJ4/waPfv5R51fHEQ1gu126csRqqpSgMzLyT4T/W7ESt9x2IGKC
         gVLA==
X-Gm-Message-State: AOAM533OGbCM/PP207ozSJp5MEpQrkyRpl2mQg1RLMJ6bIOiy+0wF4X7
        /FCT4RbQEEBVxr14xNcU2Wc=
X-Google-Smtp-Source: ABdhPJykFC5jvO3y/XCzG6ZE7Zalauh8LaHb1hosmbb8FUM3Lo3ZJXFq27bUazQFvFnvrzP49ZqCnQ==
X-Received: by 2002:a05:6638:3781:: with SMTP id w1mr10382789jal.26.1643663558195;
        Mon, 31 Jan 2022 13:12:38 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id y22sm186808iow.2.2022.01.31.13.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 13:12:37 -0800 (PST)
Date:   Mon, 31 Jan 2022 13:12:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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
        Florian Westphal <fw@strlen.de>
Message-ID: <61f850bdf1b23_8597208f8@john.notmuch>
In-Reply-To: <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
 <61efacc6980f4_274ca2083e@john.notmuch>
 <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> On 2022-01-25 09:54, John Fastabend wrote:
> > Maxim Mikityanskiy wrote:
> >> The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
> >> to generate SYN cookies in response to TCP SYN packets and to check
> >> those cookies upon receiving the first ACK packet (the final packet of
> >> the TCP handshake).
> >>
> >> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
> >> listening socket on the local machine, which allows to use them together
> >> with synproxy to accelerate SYN cookie generation.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> >> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> >> ---
> > 
> > [...]
> > 
> >> +
> >> +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
> >> +	   struct tcphdr *, th, u32, th_len)
> >> +{
> >> +#ifdef CONFIG_SYN_COOKIES
> >> +	u32 cookie;
> >> +	int ret;
> >> +
> >> +	if (unlikely(th_len < sizeof(*th)))
> >> +		return -EINVAL;
> >> +
> >> +	if (!th->ack || th->rst || th->syn)
> >> +		return -EINVAL;
> >> +
> >> +	if (unlikely(iph_len < sizeof(struct iphdr)))
> >> +		return -EINVAL;
> >> +
> >> +	cookie = ntohl(th->ack_seq) - 1;
> >> +
> >> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
> >> +	 * same offset so we can cast to the shorter header (struct iphdr).
> >> +	 */
> >> +	switch (((struct iphdr *)iph)->version) {
> >> +	case 4:
> > 
> > Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?
> 
> No, I didn't, I just implemented it consistently with 
> bpf_tcp_check_syncookie, but let's consider it.
> 
> I can't just pass a pointer from BPF without passing the size, so I 
> would need some wrappers around __cookie_v{4,6}_check anyway. The checks 
> for th_len and iph_len would have to stay in the helpers. The check for 
> TCP flags (ACK, !RST, !SYN) could be either in the helper or in BPF. The 
> switch would obviously be gone.

I'm not sure you would need the len checks in helper, they provide
some guarantees I guess, but the void * is just memory I don't see
any checks on its size. It could be the last byte of a value for
example?

> 
> The bottom line is that it would be the same code, but without the 
> switch, and repeated twice. What benefit do you see in this approach? 

The only benefit would be to shave some instructions off the program.
XDP is about performance so I figure we shouldn't be adding arbitrary
stuff here. OTOH you're already jumping into a helper so it might
not matter at all.

>  From my side, I only see the ability to drop one branch at the expense 
> of duplicating the code above the switch (th_len and iph_len checks).

Just not sure you need the checks either, can you just assume the user
gives good data?

> 
> > My code at least has already run the code above before it would ever call
> > this helper so all the other bits are duplicate.
> 
> Sorry, I didn't quite understand this part. What "your code" are you 
> referring to?

Just that the XDP code I maintain has a if ipv4 {...} else ipv6{...}
structure in it so could use a v4_check... and v6_check... then call
the correct version directly, removing the switch from the helper.

Do you think there could be a performance reason to drop out those
instructions or is it just hid by the hash itself. Also it seems
a bit annoying if user is calling multiple helpers and they keep
doing the same checks over and over.
