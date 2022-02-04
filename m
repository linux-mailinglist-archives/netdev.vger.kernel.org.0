Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D814A9273
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 03:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356702AbiBDCuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 21:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356697AbiBDCuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 21:50:50 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C063C06173B;
        Thu,  3 Feb 2022 18:50:50 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id m2so3731078ilg.11;
        Thu, 03 Feb 2022 18:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=AIfPgcmH73UTSzW0sWNz2twIRmbviYhmxxkZu3SSGkc=;
        b=YpuXcpsP/pYn2sW64Wi6CzN16bLv6j9IjCw2/lp/RzLEO/BwzFSZSZSpBWmoKmhJaO
         4oj6ZG/BDx3JoBVIFsX4k1baIwByGTNC500zPCzKAQDGCFTaxVO9H4J6y9B5qA2p/L5e
         9GBq+CfZ9D7bmkrmdFhQx+tDB9GfEFIhXdEyW9MedU8kZEWg18frp8PGb3Y9/OdA5nwi
         Uyea86Jv82UCDCcdlDdnBYmN0fsil3I3H4CANxBdWKeKySsL5J0KBsWD8k6ZN547Ly3D
         iaKPGHw/nQhWhEapq9yaw0vIf0ZgMa7X5nHbLdPWjEycxgIKdtzlGbmRLT8VzCdvl6dY
         sluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=AIfPgcmH73UTSzW0sWNz2twIRmbviYhmxxkZu3SSGkc=;
        b=ttr7WiL3Ojp06uw+ltM3O0XiujCsN+VduCZtpWprKrPTn5IVjkIq6ImjyB/npuoJlC
         39nGVJrHlFzl7aWA+vPTSGPAwRYta/niPxfGRShWNibQ+EHwyrkNnE5k3bRuVgdE7nZm
         o+7Q+qcaZlof1FJpHbhQJwOb8yNai3sdpyY4nxuEbayMlY6Fos8ZhlJnGa6qhka2nD7V
         IRnwTk+pHs2l6CrFGpgSIC1Vcd/N+7kSLmvHbfQkRagX1oP5ZvvDl4YJBhKd6arZI9Ru
         LDCBp/cjgAT+z/sDyEjvs1uDNETCvWvm+0kFGId4kdT6CySqG7QtMU7Mnt9ytfhHCnfu
         tE1g==
X-Gm-Message-State: AOAM532rEXwjP2NHBHHTxWRE5mgta5Ka22+9+cJR/ZA1LisFvi1CmZY7
        eyAR6cn2S7PROD1ElIV2OL0=
X-Google-Smtp-Source: ABdhPJyIi3zGENlLbHWfZw0p4SICcoePzVfSRWHAGMAZRW71RRIUH7SrNoSAA3kx1qweBiGsY+atYw==
X-Received: by 2002:a05:6e02:1a47:: with SMTP id u7mr477623ilv.33.1643943049996;
        Thu, 03 Feb 2022 18:50:49 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id d16sm352618iow.13.2022.02.03.18.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 18:50:49 -0800 (PST)
Date:   Thu, 03 Feb 2022 18:50:43 -0800
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
Message-ID: <61fc9483dfbe7_1d27c208e7@john.notmuch>
In-Reply-To: <9cef58de-1f84-5988-92f8-fcdd3c61f689@nvidia.com>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
 <61efacc6980f4_274ca2083e@john.notmuch>
 <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
 <61f850bdf1b23_8597208f8@john.notmuch>
 <61f852711e15a_92e0208ac@john.notmuch>
 <9cef58de-1f84-5988-92f8-fcdd3c61f689@nvidia.com>
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
> On 2022-01-31 23:19, John Fastabend wrote:
> > John Fastabend wrote:
> >> Maxim Mikityanskiy wrote:
> >>> On 2022-01-25 09:54, John Fastabend wrote:
> >>>> Maxim Mikityanskiy wrote:
> >>>>> The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
> >>>>> to generate SYN cookies in response to TCP SYN packets and to check
> >>>>> those cookies upon receiving the first ACK packet (the final packet of
> >>>>> the TCP handshake).
> >>>>>
> >>>>> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
> >>>>> listening socket on the local machine, which allows to use them together
> >>>>> with synproxy to accelerate SYN cookie generation.
> >>>>>
> >>>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> >>>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> >>>>> ---
> >>>>
> >>>> [...]
> >>>>
> >>>>> +
> >>>>> +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
> >>>>> +	   struct tcphdr *, th, u32, th_len)
> >>>>> +{
> >>>>> +#ifdef CONFIG_SYN_COOKIES
> >>>>> +	u32 cookie;
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	if (unlikely(th_len < sizeof(*th)))
> >>>>> +		return -EINVAL;
> >>>>> +
> >>>>> +	if (!th->ack || th->rst || th->syn)
> >>>>> +		return -EINVAL;
> >>>>> +
> >>>>> +	if (unlikely(iph_len < sizeof(struct iphdr)))
> >>>>> +		return -EINVAL;
> >>>>> +
> >>>>> +	cookie = ntohl(th->ack_seq) - 1;
> >>>>> +
> >>>>> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
> >>>>> +	 * same offset so we can cast to the shorter header (struct iphdr).
> >>>>> +	 */
> >>>>> +	switch (((struct iphdr *)iph)->version) {
> >>>>> +	case 4:
> >>>>
> >>>> Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?
> >>>
> >>> No, I didn't, I just implemented it consistently with
> >>> bpf_tcp_check_syncookie, but let's consider it.
> >>>
> >>> I can't just pass a pointer from BPF without passing the size, so I
> >>> would need some wrappers around __cookie_v{4,6}_check anyway. The checks
> >>> for th_len and iph_len would have to stay in the helpers. The check for
> >>> TCP flags (ACK, !RST, !SYN) could be either in the helper or in BPF. The
> >>> switch would obviously be gone.
> >>
> >> I'm not sure you would need the len checks in helper, they provide
> >> some guarantees I guess, but the void * is just memory I don't see
> >> any checks on its size. It could be the last byte of a value for
> >> example?
> 
> The verifier makes sure that the packet pointer and the size come 
> together in function parameters (see check_arg_pair_ok). It also makes 
> sure that the memory region defined by these two parameters is valid, 
> i.e. in our case it belongs to packet data.
> 
> Now that the helper got a valid memory region, its length is still 
> arbitrary. The helper has to check it's big enough to contain a TCP 
> header, before trying to access its fields. Hence the checks in the helper.
> 
> > I suspect we need to add verifier checks here anyways to ensure we don't
> > walk off the end of a value unless something else is ensuring the iph
> > is inside a valid memory block.
> 
> The verifier ensures that the [iph; iph+iph_len) is valid memory, but 
> the helper still has to check that struct iphdr fits into this region. 
> Otherwise iph_len could be too small, and the helper would access memory 
> outside of the valid region.

Thanks for the details this all makes sense. See response to
other mail about adding new types. Replied to the wrong email
but I think the context is not lost.

> 
> >>
> >>>
> >>> The bottom line is that it would be the same code, but without the
> >>> switch, and repeated twice. What benefit do you see in this approach?
> >>
> >> The only benefit would be to shave some instructions off the program.
> >> XDP is about performance so I figure we shouldn't be adding arbitrary
> >> stuff here. OTOH you're already jumping into a helper so it might
> >> not matter at all.
> >>
> >>>   From my side, I only see the ability to drop one branch at the expense
> >>> of duplicating the code above the switch (th_len and iph_len checks).
> >>
> >> Just not sure you need the checks either, can you just assume the user
> >> gives good data?
> 
> No, since the BPF program would be able to trick the kernel into reading 
> from an invalid location (see the explanation above).
> 
> >>>
> >>>> My code at least has already run the code above before it would ever call
> >>>> this helper so all the other bits are duplicate.
> >>>
> >>> Sorry, I didn't quite understand this part. What "your code" are you
> >>> referring to?
> >>
> >> Just that the XDP code I maintain has a if ipv4 {...} else ipv6{...}
> >> structure
> 
> Same for my code (see the last patch in the series).
> 
> Splitting into two helpers would allow to drop the extra switch in the 
> helper, however:
> 
> 1. The code will be duplicated for the checks.

See response wrt PTR_TO_IP, PTR_TO_TCP types.

> 
> 2. It won't be consistent with bpf_tcp_check_syncookie (and all other 
> existing helpers - as far as I see, there is no split for IPv4/IPv6).

This does seem useful to me.

> 
> 3. It's easier to misuse, e.g., pass an IPv6 header to the IPv4 helper. 
> This point is controversial, since it shouldn't pose any additional 
> security threat, but in my opinion, it's better to be foolproof. That 
> means, I'd add the IP version check even to the separate helpers, which 
> defeats the purpose of separating them.

Not really convinced that we need to guard against misuse. This is
down in XDP space its not a place we should be adding extra insns
to stop developers from hurting themselves, just as a general
rule.

> 
> Given these points, I'd prefer to keep it a single helper. However, if 
> you have strong objections, I can split it.

I think (2) is the strongest argument combined with the call is
heavy operation and saving some cycles maybe isn't terribly
important, but its XDP land again and insns matter IMO. I'm on
the fence maybe others have opinions?

Sorry for diverging the thread a bit there with the two replies.

Thanks,
John
