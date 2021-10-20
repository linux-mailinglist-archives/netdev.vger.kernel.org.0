Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53E34343E3
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 05:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhJTDak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 23:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTDak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 23:30:40 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46168C06161C;
        Tue, 19 Oct 2021 20:28:26 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id w10so20562081ilc.13;
        Tue, 19 Oct 2021 20:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=eBIDOwTiVEDpLZJCtDQ9qFP0TuQHVkD3tTneVRsqqv4=;
        b=Nk3tgkVzH7dUY3M5cYsipgUGd2ehfDSaBrjS+n/n5+uhCIgB1NCkcjvDgkyvLvFBQj
         vQ8cPHpJiq5C3hkCnBiMRkNtxXoGOMec70OJbGrXETc8KU36ZBwmx4Vy1Ltspeaf6PLi
         DM9yuKkP4DToS/mihj7RJRCsmG1a0TM/E0UEXs8TyxNpY5fu5gOv79cS4Vh62AFtYhL8
         4ZdJ/GVl98/aFb8RSAdBmnvYdMStG45+4Ng80KKR1X8MuzR22cnWZcmg38OMp4TvjZzv
         uzucOhIYyd0FR2Al3ucCpW8PpxG2cZVb39a+XfulYpIqp8ggsDoy0KP2wEoOyK0V+SHP
         b2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=eBIDOwTiVEDpLZJCtDQ9qFP0TuQHVkD3tTneVRsqqv4=;
        b=Gn6s9IDSyZ9jEALv75qttXZOCmoeHYuS+XEYV0NUz65szAYMKzAjCIcl+MmTrXslOK
         rs1UjM0eIhwU1rfzIijKMnD9H6t3Thw7IiRQPdIAPtC8WQiZmfyxgSIkuO53lwfcgQWo
         fMc4/R2IHNAhzU9G6HIA/gwk+Zlb6dBDefih2GONIeV6aZxfHr4PaoiWxwQqP7YBjifX
         SXPWOqbxigaDPt0bwPnuswfiao9JMlYF/oBSTQnthkH571U6FEo3YunU9irC4e7ZhB6l
         QffgcYTHURiol6EWYulf3XguXlh3yPyY0emAOqr5xAoUCoBQc6Lqat5qd5xmban6YLV7
         JjPQ==
X-Gm-Message-State: AOAM533mC+/DinVD4BP2pgsl0ypHGu5HJzeSXguroGrQbyBfvvV5/IPi
        BwOT+YXqeaAr5uWP3ZcySCdkVSWewS0BEksi
X-Google-Smtp-Source: ABdhPJwnbPzirbnLmdcyp0XfSK5R5Skc5QcvbUFMKLxJIerSX/IePoumRvxY+Px2YRR/cKNIYx94/A==
X-Received: by 2002:a05:6e02:19ca:: with SMTP id r10mr15540186ill.148.1634700505518;
        Tue, 19 Oct 2021 20:28:25 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x5sm474959ioh.23.2021.10.19.20.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 20:28:24 -0700 (PDT)
Date:   Tue, 19 Oct 2021 20:28:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <616f8cd0a0c6c_340c7208ae@john-XPS-13-9370.notmuch>
In-Reply-To: <20211019144655.3483197-5-maximmi@nvidia.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-5-maximmi@nvidia.com>
Subject: RE: [PATCH bpf-next 04/10] bpf: Make errors of
 bpf_tcp_check_syncookie distinguishable
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> bpf_tcp_check_syncookie returns errors when SYN cookie generation is
> disabled (EINVAL) or when no cookies were recently generated (ENOENT).
> The same error codes are used for other kinds of errors: invalid
> parameters (EINVAL), invalid packet (EINVAL, ENOENT), bad cookie
> (ENOENT). Such an overlap makes it impossible for a BPF program to
> distinguish different cases that may require different handling.

I'm not sure we can change these errors now. They are embedded in
the helper API. I think a BPF program could uncover the meaning
of the error anyways with some error path handling?

Anyways even if we do change these most of us who run programs
on multiple kernel versions would not be able to rely on them
being one way or the other easily.

> 
> For a BPF program that accelerates generating and checking SYN cookies,
> typical logic looks like this (with current error codes annotated):
> 
> 1. Drop invalid packets (EINVAL, ENOENT).
> 
> 2. Drop packets with bad cookies (ENOENT).
> 
> 3. Pass packets with good cookies (0).
> 
> 4. Pass all packets when cookies are not in use (EINVAL, ENOENT).
> 
> The last point also matches the behavior of cookie_v4_check and
> cookie_v6_check that skip all checks if cookie generation is disabled or
> no cookies were recently generated. Overlapping error codes, however,
> make it impossible to distinguish case 4 from cases 1 and 2.
> 
> The original commit message of commit 399040847084 ("bpf: add helper to
> check for a valid SYN cookie") mentions another use case, though:
> traffic classification, where it's important to distinguish new
> connections from existing ones, and case 4 should be distinguishable
> from case 3.
> 
> To match the requirements of both use cases, this patch reassigns error
> codes of bpf_tcp_check_syncookie and adds missing documentation:
> 
> 1. EINVAL: Invalid packets.
> 
> 2. EACCES: Packets with bad cookies.
> 
> 3. 0: Packets with good cookies.
> 
> 4. ENOENT: Cookies are not in use.
> 
> This way all four cases are easily distinguishable.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

At very leasst this would need a fixes tag and should be backported
as a bug. Then we at least have a chance stable and LTS kernels
report the same thing.

[...]

> --- a/net/core/filter.c
> +++ b/net/core/filter.c
 
I'll take a stab at how a program can learn the error cause today.

BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
	   struct tcphdr *, th, u32, th_len)
{
#ifdef CONFIG_SYN_COOKIES
	u32 cookie;
	int ret;

// BPF program should know it pass bad values and can check
	if (unlikely(!sk || th_len < sizeof(*th)))
		return -EINVAL;

// sk_protocol and sk_state are exposed in sk and can be read directly 
	/* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
		return -EINVAL;

// This is a user space knob right? I think this is a misconfig user can
// check before loading a program with check_syncookie?
	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
		return -EINVAL;

// We have th pointer can't we just check?
	if (!th->ack || th->rst || th->syn)
		return -ENOENT;

	if (tcp_synq_no_recent_overflow(sk))
		return -ENOENT;

	cookie = ntohl(th->ack_seq) - 1;

	switch (sk->sk_family) {
	case AF_INET:
// misconfiguration but can be checked.
		if (unlikely(iph_len < sizeof(struct iphdr)))
			return -EINVAL;

		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
		break;

#if IS_BUILTIN(CONFIG_IPV6)
	case AF_INET6:
// misconfiguration can check as well
		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
			return -EINVAL;

		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
		break;
#endif /* CONFIG_IPV6 */

	default:
		return -EPROTONOSUPPORT;
	}

	if (ret > 0)
		return 0;

	return -ENOENT;
#else
	return -ENOTSUPP;
#endif
}


So I guess my point is we have all the fields we could write a bit
of BPF to find the error cause if necessary. Might be better than
dealing with changing the error code and having to deal with the
differences in kernels. I do see how it would have been better
to get errors correct on the first patch though :/

By the way I haven't got to the next set of patches with the
actual features, but why not push everything above this patch
as fixes in its own series. Then the fixes can get going why
we review the feature.

Thanks,
John
