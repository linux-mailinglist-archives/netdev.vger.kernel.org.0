Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486D349AEF0
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453966AbiAYI4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453152AbiAYIwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:52:35 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC91FC04D625;
        Mon, 24 Jan 2022 23:38:14 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id 9so7013161iou.2;
        Mon, 24 Jan 2022 23:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Zn25fVsGFUd1ohDCtBcBG+jBUAqCenaO5d+o235Zzcs=;
        b=PBBMsUAluTUrR1hpeFhdvgYz0duh2+CugQpHvtJDIP3MMII61NGQCQi/9NzcBkqxAq
         //EMqnKTIl8Vtv3HR8ZIP2XBYmmMrhNutQw7jvkKJWF443KdfWJqOU6Hzb8msTBb82XC
         hGdmQOTbkufXSqUK8vmo47qmXlmhAYBS2n7e6nWm2FCbdQYTWNznJ2z6aFsTMr6QUasl
         1AWcQSURNyOQR6fXKXSz0zmo0Of54ZLhVeEUuOy7ClYYQqGfse6a3/dZlfsNmSXMRnUH
         MKmW/bXbipr6eLdEM4+9n6Hnfv0W2Wsb7Z+ibXJ9S9xdaPgiq5MopixK15X4BZNONDOz
         DPWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Zn25fVsGFUd1ohDCtBcBG+jBUAqCenaO5d+o235Zzcs=;
        b=4lr/VCZLDmnH2t+Y8h3IQkm+L4n+4yT+1RRRTH2deuFXFWHdwtW8i6GJhNbKC72bvT
         y//+GWp7o8DOxpdUbMClSlQYndnpAjaAFCxuqhFcs5kyjrTyv1Hyp6bmKJxOk+rZvGeo
         owiLURfPx0JPqq1VzADEQy/mMbEqj61is5S53WIwzR9VYAYEMBfUTHBjcbaDg78mxuID
         Zkd0FTvfOC7I3pGxoAgq5WpWqxCle0LcUp+l/amOBwRuLdQbsLJYTpHa64U8PPsR1wk8
         frlk/pdGybuPP2tCdEov1TG28fHFf1nwOw/Y/PEmajZh6v6+QwUOJS2KkaUXzphgsNvR
         I1Dg==
X-Gm-Message-State: AOAM531dNOOpvM2nEvRYeXW/LeaUuhzOSrbHFASfWlU/3/1yQ5Z4QsDA
        tD1Krtv9y+QeNWta3LSDL0EcDJS0vY45mYJA
X-Google-Smtp-Source: ABdhPJwITyC3y1waSG1nfJ3+ru4J18AwuBTRoYVUl56BPwrqvfHxbQkbMS5jHJU9HSanJn5JfBXtIw==
X-Received: by 2002:a05:6602:2ccc:: with SMTP id j12mr936094iow.161.1643096294212;
        Mon, 24 Jan 2022 23:38:14 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id 8sm9041921ilq.14.2022.01.24.23.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 23:38:13 -0800 (PST)
Date:   Mon, 24 Jan 2022 23:38:06 -0800
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
Message-ID: <61efa8de8babc_274ca20835@john.notmuch>
In-Reply-To: <20220124151340.376807-2-maximmi@nvidia.com>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-2-maximmi@nvidia.com>
Subject: RE: [PATCH bpf-next v2 1/3] bpf: Make errors of
 bpf_tcp_check_syncookie distinguishable
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> bpf_tcp_check_syncookie returns ambiguous error codes in some cases. The
> list below shows various error conditions and matching error codes:
> 
> 1. NULL socket: -EINVAL.
> 
> 2. Invalid packet: -EINVAL, -ENOENT.
> 
> 3. Bad cookie: -ENOENT.
> 
> 4. Cookies are not in use: -EINVAL, -ENOENT.
> 
> 5. Good cookie: 0.
> 
> As we see, the same error code may correspond to multiple error
> conditions, making them undistinguishable, and at the same time one
> error condition may return different codes, although it's typically
> handled in the same way.
> 
> This patch reassigns error codes of bpf_tcp_check_syncookie and
> documents them:
> 
> 1. Invalid packet or NULL socket: -EINVAL;
> 
> 2. Bad cookie: -EACCES.
> 
> 3. Cookies are not in use: -ENOENT.
> 
> 4. Good cookie: 0.
> 
> This change allows XDP programs to make smarter decisions based on error
> code, because different error conditions are now easily distinguishable.

I'm missing the point here it still looks a bit like shuffling
around of code. What do you gain, whats the real bug? Are you
trying to differentiate between an overflow condition and a valid
syncookie? But I don't think you said this anywhere.

At the moment EINVAL tells me somethings wrong with the input or
configuration, although really any app that cares checked the
sysctl flag right?

ENOENT tells me either recent overflow or cookie is invalid. If
there is no '!ack || rst || syn' then I can either learn that
directly from the program (why would a real program through
these at the helper), but it also falls into the incorrect
cookie in some sense.

> 
> Backward compatibility shouldn't suffer because of these reasons:
> 
> 1. The specific error codes weren't documented. The behavior that used
>    to be documented (0 is good cookie, negative values are errors) still
>    holds. Anyone who relied on implementation details should have
>    understood the risks.

I'll disagree, just because a user facing API doesn't document its
behavior very well doesn't mean users should some how understand the
risks. Ideally we would have done better with error codes up front,
but thats old history. If a user complains that this breaks a real
application it would likely be reason to revert it.

At least I would remove this from the commit.

> 
> 2. Two known usecases (classification of ACKs with cookies that initial
>    new connections, SYN flood protection) take decisions which don't
>    depend on specific error codes:
> 
>      Traffic classification:
>        ACK packet is new, error == 0: classify as NEW.
>        ACK packet is new, error < 0: classify as INVALID.
> 
>      SYN flood protection:
>        ACK packet is new, error == 0: good cookie, XDP_PASS.
>        ACK packet is new, error < 0: bad cookie, XDP_DROP.
> 
>    As Lorenz Bauer confirms, their implementation of traffic classifier
>    won't break, as well as the kernel selftests.
> 
> 3. It's hard to imagine that old error codes could be used for any
>    useful decisions.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/uapi/linux/bpf.h       | 18 ++++++++++++++++--
>  net/core/filter.c              |  6 +++---
>  tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++--
>  3 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 16a7574292a5..4d2d4a09bf25 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3575,8 +3575,22 @@ union bpf_attr {
>   * 		*th* points to the start of the TCP header, while *th_len*
>   * 		contains **sizeof**\ (**struct tcphdr**).
>   * 	Return
> - * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
> - * 		error otherwise.
> + *		0 if *iph* and *th* are a valid SYN cookie ACK.
> + *
> + *		On failure, the returned value is one of the following:
> + *
> + *		**-EACCES** if the SYN cookie is not valid.
> + *
> + *		**-EINVAL** if the packet or input arguments are invalid.
> + *
> + *		**-ENOENT** if SYN cookies are not issued (no SYN flood, or SYN
> + *		cookies are disabled in sysctl).
> + *
> + *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
> + *		cookies (CONFIG_SYN_COOKIES is off).
> + *
> + *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
> + *		CONFIG_IPV6 is disabled).
>   *
>   * long bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
>   *	Description
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a06931c27eeb..18559b5828a3 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6998,10 +6998,10 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>  		return -EINVAL;
>  
>  	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> -		return -EINVAL;
> +		return -ENOENT;

I wouldn't change this.

>  
>  	if (!th->ack || th->rst || th->syn)
> -		return -ENOENT;
> +		return -EINVAL;

not sure if this is useful change and it is bpf program visible.

>  
>  	if (tcp_synq_no_recent_overflow(sk))
>  		return -ENOENT;
> @@ -7032,7 +7032,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>  	if (ret > 0)
>  		return 0;
>  
> -	return -ENOENT;
> +	return -EACCES;

This one might have a valid argument to differentiate between an
overflow condition and an invalid cookie. But, curious what do you
do with this info?

Thanks,
John
