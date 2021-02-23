Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA34322363
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 02:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhBWBMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 20:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhBWBMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 20:12:36 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAA7C061786;
        Mon, 22 Feb 2021 17:11:56 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u11so8816287plg.13;
        Mon, 22 Feb 2021 17:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vDeQByIi2CaH6S1ngYTrHFmX4a2/WFD9fxPTpaU+LME=;
        b=HLPJs7m5C62nM/Rr5mzoNrunKJtB1OofP99KWHu9x2rQc/lzruMiQFbi4Q4HLnzMXE
         ci0XObAyTufKQ96nOoYsDn1eGw3hUvb1EO2DorHGO0DGSP2KDQAD2Td9QWx75ETdP6ol
         Cxnj/tNvzQeVyh5JSDE4kWY23tDmFKUYcuDif1SePSzpXQFVNDwMOCK+ry3c5n0chTGv
         JP5M84RO97AoigIGqvgDvoX8H4PBC921BMXHbBmNNaIVkB++dO+NA+WcwXlM3qaE6YlG
         xh/ePmhgBVfATBF1dbTdfCb7HKacZt8WlgwiBt9dcCEthczs1SIcIB/5Gj+5rj68wjqO
         AUxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vDeQByIi2CaH6S1ngYTrHFmX4a2/WFD9fxPTpaU+LME=;
        b=KuWkpbXQPx4rLl0JtczbMA0RTl4zA7aUbE4Iuioij8NJzKqCFWHlproFXBMj+i/2Xg
         vaz1gmy4HlrkKbxwO1+/bld+8fcM5ZeRBVQhDWOj01zJhzreqBJnTR1kJPQTfXVRmwW0
         Ywg+8hpO1NbqSeGnkeLwBRaAAXM1Cut9nPOniL85IplcKFeymuqZxOaWOl08JTzSBYLC
         zLoG09q5PYSpHxHA0NFVOSlKBt1Kl4cVrvIaf9rfJ/m5g4MXsMrZ5dUtNvyIgaeuA9/g
         iV2WOKnLiLmfKzxLbyO9Atj8qySxIhIxVpJzHssuEMzGwIJLVgT2ia2i1KJFB8pLKF6f
         lYCA==
X-Gm-Message-State: AOAM530h39yZACxHA/qDvf7Qz9lwakJGoiOLMRKlrqQUarTh0fVpp6Xy
        68LtNUdMl0wCn1/Sc6so8Nk=
X-Google-Smtp-Source: ABdhPJzv2Zd5FpkjOoTk4cRqrFAmKCkekCE9IcATGvfQK8Qeo62OxN7NBHhXN3L9tBjaG0i8Br1iSg==
X-Received: by 2002:a17:90a:7f8d:: with SMTP id m13mr14317724pjl.203.1614042715998;
        Mon, 22 Feb 2021 17:11:55 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:daff])
        by smtp.gmail.com with ESMTPSA id o62sm9719981pga.43.2021.02.22.17.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:11:55 -0800 (PST)
Date:   Mon, 22 Feb 2021 17:11:53 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com, kernel-team@cloudflare.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 4/8] bpf: add PROG_TEST_RUN support for
 sk_lookup programs
Message-ID: <20210223011153.4cvzpvxqn7arbcej@ast-mbp.dhcp.thefacebook.com>
References: <20210216105713.45052-1-lmb@cloudflare.com>
 <20210216105713.45052-5-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216105713.45052-5-lmb@cloudflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:57:09AM +0000, Lorenz Bauer wrote:
> +	user_ctx = bpf_ctx_init(kattr, sizeof(*user_ctx));
> +	if (IS_ERR(user_ctx))
> +		return PTR_ERR(user_ctx);
> +
> +	if (!user_ctx)
> +		return -EINVAL;
> +
> +	if (user_ctx->sk)
> +		goto out;
> +
> +	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
> +		goto out;
> +
> +	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
> +		ret = -ERANGE;
> +		goto out;
> +	}
> +
> +	ctx.family = user_ctx->family;
> +	ctx.protocol = user_ctx->protocol;
> +	ctx.dport = user_ctx->local_port;
> +	ctx.sport = user_ctx->remote_port;
> +
> +	switch (ctx.family) {
> +	case AF_INET:
> +		ctx.v4.daddr = user_ctx->local_ip4;
> +		ctx.v4.saddr = user_ctx->remote_ip4;
> +		break;
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		ctx.v6.daddr = (struct in6_addr *)user_ctx->local_ip6;
> +		ctx.v6.saddr = (struct in6_addr *)user_ctx->remote_ip6;
> +		break;
> +#endif
> +
> +	default:
> +		ret = -EAFNOSUPPORT;
> +		goto out;
> +	}
> +
> +	while (t_check(&t, repeat, &ret, &duration)) {
> +		ctx.selected_sk = NULL;
> +		retval = BPF_PROG_SK_LOOKUP_RUN_ARRAY(progs, ctx, BPF_PROG_RUN);
> +	}
> +
> +	if (ret < 0)
> +		goto out;
> +
> +	user_ctx->cookie = 0;
> +	if (ctx.selected_sk) {
> +		if (ctx.selected_sk->sk_reuseport && !ctx.no_reuseport) {
> +			ret = -EOPNOTSUPP;
> +			goto out;
> +		}
> +
> +		user_ctx->cookie = sock_gen_cookie(ctx.selected_sk);
> +	}

I'm struggling to come up with the case where running N sk_lookup progs
like this cannot be done with running them one by one.
It looks to me that this N prog_fds api is not really about running and
testing the progs, but about testing BPF_PROG_SK_LOOKUP_RUN_ARRAY()
SK_PASS vs SK_DROP logic.
So it's more of the kernel infra testing than program testing.
Are you suggesting that the sequence of sk_lookup progs are so delicate
that they are aware of each other and _has_ to be tested together
with gluing logic that the macro provides?
But if it is so then testing the progs one by one would be better,
because test_run will be able to check each individual prog return code
instead of implicit BPF_PROG_SK_LOOKUP_RUN_ARRAY logic.
It feels less of the unit test and more as a full stack test,
but if so then lack of cookie on input is questionable.
The progs can only examine port/ip/family data.
So testing them individually would give more accurate picture on
what progs are doing and potential bugs can be found sooner than
testing the sequence of progs. In a sequence one prog could have
been buggy, but the final cookie came out correct.

Looking at patch 7 it seems the unit test framework will be comparing
the cookies for your production tests, but then nentns argument
in the cover letter is suprising. If the tests are run in the init_netns
then selected sockets will be just as special as in patch 7.
So it's not a full stack kinda test.

In other words I'm struggling with in-between state of the api.
test_run with N fds is not really a full test, but not a unit test either.
