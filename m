Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565014A5151
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 22:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380295AbiAaVTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 16:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241083AbiAaVTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 16:19:53 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C696EC061714;
        Mon, 31 Jan 2022 13:19:53 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id q11so4417992ild.11;
        Mon, 31 Jan 2022 13:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=t0175Lm8mMbynWtshXAUEfEgWHreUPOFNsxJ/whVe/Q=;
        b=EYefvrwPEe9vcvvOz7RMeHMUQQ/hB8FFVwd2r2QfmL2AnwFvrZa2UCmcbS5V2NaFyB
         Ey74FrLe6atOj6IeQxXUDyMceMEzrBmOblGsUMSOB8ydGs0Mk7J1aaPomYcHaPdPunkj
         E818YwV2n0zWffPF9xJQuGs9ObmY/b0mKbWyJg/w9XlFISYllT5+UY2SCGfkWw38Bk3k
         ru3xAvttGCyyfgMbitRw5AyLyC4hZOV054AHXrg74pulY7wVIPPnspH1aHfjfl1enQah
         DYL50l5Rdy7PbJb8j9wA+5Efp7KRdjRw+guNMfc58U1uHTbjtxOfSloJqi4VQvN+8q/7
         thQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=t0175Lm8mMbynWtshXAUEfEgWHreUPOFNsxJ/whVe/Q=;
        b=zxB8Y5Ps58d6uP57QcA6+MuJltHielEGfFCaIuvbdVtoIcYDH4OOISUAC4AF/8p309
         VeFp2PPSyV7D/qA4fcQ2zgf2YQLO9PnoyLufLbhspMoBuUfQVmT3AujSYva4mPRrbjaJ
         YdBsZTQwEIYEsdx7wBaPt1yoxTgenXdxSBUYLqEDDuS1hA0RQxD32beZOaTlND0EgXYD
         OdtJPnWqATFQKAKlNxMICS6UpTFONL+hZomYKApTIssriqDyFCGroGf55dHnt7ndPcLw
         81FFZs6E98JM/h+TPbRH8S+ypXE+jiR+ojbyX4ykWugfjxBI4lEjFVnjLYRzDr0K6Q6X
         XXSA==
X-Gm-Message-State: AOAM531JPOPSjPgRnduwZQvlNpoKhKH9KYPVNzU3GYf8eMoVN9Ej8Mre
        37IlEwE3eA6ndUSUur1w9OU=
X-Google-Smtp-Source: ABdhPJzRMrTMPm1nOkS5QX+RyykwMwFKsTRXiGbLKsNzaTetIPrhSJ+PD6q14kFoOc8LFm83wGeJgA==
X-Received: by 2002:a05:6e02:20e9:: with SMTP id q9mr13536638ilv.30.1643663993258;
        Mon, 31 Jan 2022 13:19:53 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id i22sm18491766ila.85.2022.01.31.13.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 13:19:52 -0800 (PST)
Date:   Mon, 31 Jan 2022 13:19:45 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
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
Message-ID: <61f852711e15a_92e0208ac@john.notmuch>
In-Reply-To: <61f850bdf1b23_8597208f8@john.notmuch>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
 <61efacc6980f4_274ca2083e@john.notmuch>
 <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
 <61f850bdf1b23_8597208f8@john.notmuch>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Maxim Mikityanskiy wrote:
> > On 2022-01-25 09:54, John Fastabend wrote:
> > > Maxim Mikityanskiy wrote:
> > >> The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
> > >> to generate SYN cookies in response to TCP SYN packets and to check
> > >> those cookies upon receiving the first ACK packet (the final packet of
> > >> the TCP handshake).
> > >>
> > >> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
> > >> listening socket on the local machine, which allows to use them together
> > >> with synproxy to accelerate SYN cookie generation.
> > >>
> > >> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > >> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > >> ---
> > > 
> > > [...]
> > > 
> > >> +
> > >> +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
> > >> +	   struct tcphdr *, th, u32, th_len)
> > >> +{
> > >> +#ifdef CONFIG_SYN_COOKIES
> > >> +	u32 cookie;
> > >> +	int ret;
> > >> +
> > >> +	if (unlikely(th_len < sizeof(*th)))
> > >> +		return -EINVAL;
> > >> +
> > >> +	if (!th->ack || th->rst || th->syn)
> > >> +		return -EINVAL;
> > >> +
> > >> +	if (unlikely(iph_len < sizeof(struct iphdr)))
> > >> +		return -EINVAL;
> > >> +
> > >> +	cookie = ntohl(th->ack_seq) - 1;
> > >> +
> > >> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
> > >> +	 * same offset so we can cast to the shorter header (struct iphdr).
> > >> +	 */
> > >> +	switch (((struct iphdr *)iph)->version) {
> > >> +	case 4:
> > > 
> > > Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?
> > 
> > No, I didn't, I just implemented it consistently with 
> > bpf_tcp_check_syncookie, but let's consider it.
> > 
> > I can't just pass a pointer from BPF without passing the size, so I 
> > would need some wrappers around __cookie_v{4,6}_check anyway. The checks 
> > for th_len and iph_len would have to stay in the helpers. The check for 
> > TCP flags (ACK, !RST, !SYN) could be either in the helper or in BPF. The 
> > switch would obviously be gone.
> 
> I'm not sure you would need the len checks in helper, they provide
> some guarantees I guess, but the void * is just memory I don't see
> any checks on its size. It could be the last byte of a value for
> example?

I suspect we need to add verifier checks here anyways to ensure we don't
walk off the end of a value unless something else is ensuring the iph
is inside a valid memory block.

> 
> > 
> > The bottom line is that it would be the same code, but without the 
> > switch, and repeated twice. What benefit do you see in this approach? 
> 
> The only benefit would be to shave some instructions off the program.
> XDP is about performance so I figure we shouldn't be adding arbitrary
> stuff here. OTOH you're already jumping into a helper so it might
> not matter at all.
> 
> >  From my side, I only see the ability to drop one branch at the expense 
> > of duplicating the code above the switch (th_len and iph_len checks).
> 
> Just not sure you need the checks either, can you just assume the user
> gives good data?
> 
> > 
> > > My code at least has already run the code above before it would ever call
> > > this helper so all the other bits are duplicate.
> > 
> > Sorry, I didn't quite understand this part. What "your code" are you 
> > referring to?
> 
> Just that the XDP code I maintain has a if ipv4 {...} else ipv6{...}
> structure in it so could use a v4_check... and v6_check... then call
> the correct version directly, removing the switch from the helper.
> 
> Do you think there could be a performance reason to drop out those
> instructions or is it just hid by the hash itself. Also it seems
> a bit annoying if user is calling multiple helpers and they keep
> doing the same checks over and over.


