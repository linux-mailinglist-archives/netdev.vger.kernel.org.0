Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589594A9251
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 03:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356491AbiBDCaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 21:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbiBDCaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 21:30:04 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA11C061714;
        Thu,  3 Feb 2022 18:30:04 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id s18so5689602ioa.12;
        Thu, 03 Feb 2022 18:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OTrC/ChFFDlMeg9wabFJuljEVHThOgwhDVJ2eQe+sqM=;
        b=CrVP0fW+Lt59T5PVfRminhPlGN8XqmzojbqDgLwNUDQO9j7eZFBKy6CTKNYSLY4btB
         yuS4tDqIoeJeevZVez8tidunOLm0Bp6RX2JTliuabS+4wQPKUDHDwUxkA+jUSD/7zqkC
         Ehjylvrw6yzP4ET4u0HQHdTMpoYUMUYzGNvGENls8hH6klBktezlmwOgWzkEJnkA2aUu
         mn3vEE1kAyWMVttKVG4GzJDsMxFZIS64w4g4sC0PecRI7qdAK/KoFAmJ139WU8iSNjXg
         t9vr+qBAgdNxRXmd6YAA6+mWh0DbEaCCOTa8llPsObvFevyPIeif9hUiBLkaRdqcQysA
         mLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OTrC/ChFFDlMeg9wabFJuljEVHThOgwhDVJ2eQe+sqM=;
        b=NM+6zZPPQEvYZ1qvV/1mtm+sZxG7UtPlfR1Q761U6hNa/Cnp/qm1v4BYd4cDwynavI
         0IWlk4nK+z4Yxby4HIMZvYP5qV+QXY9hfT+ZASPOJ8Eh4W0VqYAh0Vzp3T9nVQYbVs02
         FD4NB9zMYlylwA7KXs4CMyTIJxQUAZP+kXbDT+hlq4KEGAplIIL3jGxCgPI2qPP39h1E
         5bQmyD/vVVvi4DKBXQMbBeFPqOGNwFLxlkcXhBV2d3mBI8gG+ezoAG7GmWOy011bSFBT
         +4VA0Wj2pSLcyPlL1j5Phlwrl7pLJT16WxNMVFqWFGp2JTBr2FThlHCHYmLcipSAD0RG
         tNXw==
X-Gm-Message-State: AOAM532OV3g6WdYfv8F0kdq1/OK+1hy3ZilQh8H6vHiOLf09OyQPqYap
        yyAIxfdBhigrMYqGUk9tTJY=
X-Google-Smtp-Source: ABdhPJyxhUID65AugHMBuJX/lLO28PohlHd+nmy1/xOzcP960jmL7ToObemZEu2FQb9yIq0Nr8tsQQ==
X-Received: by 2002:a6b:f218:: with SMTP id q24mr358856ioh.55.1643941803044;
        Thu, 03 Feb 2022 18:30:03 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id ay35sm305821iob.3.2022.02.03.18.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 18:30:02 -0800 (PST)
Date:   Thu, 03 Feb 2022 18:29:55 -0800
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
Message-ID: <61fc8fa39a5e6_1d27c20836@john.notmuch>
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

[...]

>> > 
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

For consideration... those duplicate checks in the runtime that we
already could know from verifier side are bothering me.

We could have some new mem types, PTR_TO_IPV4, PTR_TO_IPv6, and PTR_TO_TCP.
Then we simplify the helper signatures to just,

  bpf_tcp_raw_check_syncookie_v4(iph, tcph);
  bpf_tcp_raw_check_syncookie_v6(iph, tcph);

And the verifier "knows" what a v4/v6 header is and does the mem
check at verification time instead of run time.

Then the code becomes very straightforward,

 BPF_CALL_2(bpf_tcp_raw_check_syncookie_v4, void *, iph, void *, th)
{
   u16 mss = tcp_parse_mss_option(th, 0) ?: TCP_MSS_DEFAULT;   
   return  __cookie_v4_init_sequence(iph, th, &mss);
}

We don't need length checks because we are guaranteed by conmpiler
to have valid lengths, assume code is smart enough to understand
syn, ack, rst because any real program likely already knows this.
And v4/v6 is likely also known by real program already.

If we push a bit more on this mss with PTR_TO_TCP and PTR_TO_IP
we can simply mark tcp_parse_mss_option and __cookie_v4_init_sequence
and let BPF side call them.

Curious what others think here.

> 
> The bottom line is that it would be the same code, but without the 
> switch, and repeated twice. What benefit do you see in this approach? 
>  From my side, I only see the ability to drop one branch at the expense 
> of duplicating the code above the switch (th_len and iph_len checks).
> 
> > My code at least has already run the code above before it would ever call
> > this helper so all the other bits are duplicate.
> 
> Sorry, I didn't quite understand this part. What "your code" are you 
> referring to?

Just the XDP parsers we have already switch early on based on v4/v6
and I imagine that most progs also know this. So yes we are arguing
about a simple switch, but instruction here and instruction there
add up over time. Also passing the size through the helper bothers
me slightly given the verifier should know the size already.
