Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB1746DFCE
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241618AbhLIA4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhLIA4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:56:50 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2987FC061746;
        Wed,  8 Dec 2021 16:53:18 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id m9so4949701iop.0;
        Wed, 08 Dec 2021 16:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yxalUBrs2WbqmCd/2i918DO3+hRWPvQ5gXQagl2i1gM=;
        b=AAFVqrKxPeuTvfvbaks7/6neg0ZOf2csSOpZAu9aKGgp823920QdJ+MjgLbgOtb7d1
         /RntPW67jqyUHqM4cd9cOC4bAPjbtaq1L42/mFnJC6vZxyzFwwYYPcic3pp2aZqn1MfW
         sb268TDP30eGq5DFuHXXFRiZoNAgfYC3zizXtJinYxeeIPx3o4msjIl0nrYue78o6+iS
         M6RrFUwwIM32HvhuMx0E0sQIBfcokuKjfZbzDpGeE/MGlTRSqrxOVXZDeTst6mJ0xCoC
         PfIQf+p8PrF6pYdfthpj6pE4B+9ILdV6uF7hyjTB6mlZLCqzVlo9EPy3I0EAajvaf1+v
         1J/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yxalUBrs2WbqmCd/2i918DO3+hRWPvQ5gXQagl2i1gM=;
        b=jEPcKu4DJah5pK8qPuY+fvo9VCPkJULBs3r1T0pvPgsDrfYm34ezYiS2Psd+rr2krP
         Je/TAoQO1UpyHzjkhn3HHNXoSgkNRqvE8vo5L338Sp+o2SIhn4ZFk3Q9urjQSNtl8vks
         fEsDcpwNumvAsqApZGysYUGXIpljAoMHr9DCSjP/e6HrdUxY1HA4mKgbpixzHINbrVlG
         lRJZStQQa8hjY6J8GY9C+hj88XkLG3xKuaZuGikCOYurXJin58xMSGO33EYeYO8GdjqV
         No33LxHIVwmsiA6aNIZxjHjr+WuahsvNjtSbcB2iqPKGftN0uaSq1DA9if5FzZTJbzSB
         7xFQ==
X-Gm-Message-State: AOAM531ztdyBj20MOZLdgP9zN3WofAH2BWRMeMKv5trvP+1NRjobpkw3
        1uqFw+kvlvlZJ2xpLcQDK6o=
X-Google-Smtp-Source: ABdhPJwPWztgp8ZlMhhDZWgq90+aMuxMQ4U0fX4rzC75ZtyUoHifdZvJx47AC+YAVDpTeyRXLbK21g==
X-Received: by 2002:a05:6602:2cce:: with SMTP id j14mr10665103iow.67.1639011197500;
        Wed, 08 Dec 2021 16:53:17 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id h11sm2825405ili.30.2021.12.08.16.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 16:53:16 -0800 (PST)
Date:   Wed, 08 Dec 2021 16:53:10 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <61b1537634e07_979572086f@john.notmuch>
In-Reply-To: <20211202000232.380824-7-toke@redhat.com>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-7-toke@redhat.com>
Subject: RE: [PATCH bpf-next 6/8] bpf: Add XDP_REDIRECT support to XDP for
 bpf_prog_run()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> This adds support for doing real redirects when an XDP program returns
> XDP_REDIRECT in bpf_prog_run(). To achieve this, we create a page pool
> instance while setting up the test run, and feed pages from that into t=
he
> XDP program. The setup cost of this is amortised over the number of
> repetitions specified by userspace.
> =

> To support performance testing use case, we further optimise the setup =
step
> so that all pages in the pool are pre-initialised with the packet data,=
 and
> pre-computed context and xdp_frame objects stored at the start of each
> page. This makes it possible to entirely avoid touching the page conten=
t on
> each XDP program invocation, and enables sending up to 11.5 Mpps/core o=
n my
> test box.
> =

> Because the data pages are recycled by the page pool, and the test runn=
er
> doesn't re-initialise them for each run, subsequent invocations of the =
XDP
> program will see the packet data in the state it was after the last tim=
e it
> ran on that particular page. This means that an XDP program that modifi=
es
> the packet before redirecting it has to be careful about which assumpti=
ons
> it makes about the packet content, but that is only an issue for the mo=
st
> naively written programs.
> =

> Previous uses of bpf_prog_run() for XDP returned the modified packet da=
ta
> and return code to userspace, which is a different semantic then this n=
ew
> redirect mode. For this reason, the caller has to set the new
> BPF_F_TEST_XDP_DO_REDIRECT flag when calling bpf_prog_run() to opt in t=
o
> the different semantics. Enabling this flag is only allowed if not sett=
ing
> ctx_out and data_out in the test specification, since it means frames w=
ill
> be redirected somewhere else, so they can't be returned.
> =

> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

[...]

> +static int bpf_test_run_xdp_redirect(struct bpf_test_timer *t,
> +				     struct bpf_prog *prog, struct xdp_buff *orig_ctx)
> +{
> +	void *data, *data_end, *data_meta;
> +	struct xdp_frame *frm;
> +	struct xdp_buff *ctx;
> +	struct page *page;
> +	int ret, err =3D 0;
> +
> +	page =3D page_pool_dev_alloc_pages(t->xdp.pp);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	ctx =3D ctx_from_page(page);
> +	data =3D ctx->data;
> +	data_meta =3D ctx->data_meta;
> +	data_end =3D ctx->data_end;
> +
> +	ret =3D bpf_prog_run_xdp(prog, ctx);
> +	if (ret =3D=3D XDP_REDIRECT) {
> +		frm =3D (struct xdp_frame *)(ctx + 1);
> +		/* if program changed pkt bounds we need to update the xdp_frame */

Because this reuses the frame repeatedly is there any issue with also
updating the ctx each time? Perhaps if the prog keeps shrinking
the pkt it might wind up with 0 len pkt? Just wanted to ask.

> +		if (unlikely(data !=3D ctx->data ||
> +			     data_meta !=3D ctx->data_meta ||
> +			     data_end !=3D ctx->data_end))
> +			xdp_update_frame_from_buff(ctx, frm);
> +
> +		err =3D xdp_do_redirect_frame(ctx->rxq->dev, ctx, frm, prog);
> +		if (err)
> +			ret =3D err;
> +	}
> +	if (ret !=3D XDP_REDIRECT)
> +		xdp_return_buff(ctx);
> +
> +	if (++t->xdp.frame_cnt >=3D NAPI_POLL_WEIGHT) {
> +		xdp_do_flush();
> +		t->xdp.frame_cnt =3D 0;
> +	}
> +
> +	return ret;
> +}
> +=
