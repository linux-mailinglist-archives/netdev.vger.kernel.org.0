Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33733051D4
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhA0FRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238648AbhA0E1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 23:27:19 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D428C061222;
        Tue, 26 Jan 2021 20:23:49 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j21so330905pls.7;
        Tue, 26 Jan 2021 20:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PKMm5WhbWomId6dxJtacT4f+Nb7CE6/RbR+lQ9lmvb8=;
        b=UW33n3jIrggYz8eQvlnv9rDrFdzrfgPgGdjalR9v2xllzOnf1kAkZFmJwHc2UdcKPO
         kQe7jUjYGLp4dApSP0ZRnEavAo2kfz4QSb1BncBDwk0jgM4jOhe8tHNDGdobFRA53syd
         CNL1uyWHgiEyJsighUHWku3991edDvA+BJ2IoZjZuoHVbxm6znDXQQJpHSDrcSHmqFRg
         LTfCDVY3+hKudRCtZ2YY6TgyZABOPu3dlmHkjvVQ7bWU/O0v7lznEOyYOQWM0zdl5zSE
         YHLNeucGEF+A0ZhoUa/2B0YtGvhoBaRPOmGM0GTO3IrJN3LNZ7yOjcSWCk1G9ubFK+dH
         vkfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PKMm5WhbWomId6dxJtacT4f+Nb7CE6/RbR+lQ9lmvb8=;
        b=LkXkJQ7Woem6GmnIBAQyz5Sxv0wk+bstjIsgNUqwLfM4w49WvenCx/LK00yMXcKWfu
         aYBrD5cvXJ0BXs46NrAE6TeI4z79/PyFt8ef3tB5u6GpW0n738kAVhjE2xXMKUlR5hSN
         YqkY3rjRUQUB3QoKX045CiGuNW/opTjaB1cRsOTLylAZUKxzO8EuCa5XP5kK1fkHtA1z
         eVS5WMvd4RG6m8U/xFM4of06ZhaJBcwUr2BbOBn/MguX1kB9Iz0ntSKedXXuejAX3nk3
         91xxzHz1rNODL+DeoaDFjmMcXIQpmE4lXrfKRCgutthLro7u3dU0ig9kdskzUcwRF4Oz
         ImGw==
X-Gm-Message-State: AOAM531EH6PTn5ZhavnirS+Rk8MYmYUL3TV1F0sB59ggrFOPuLMx2g1I
        83y++V5VBhpbeEYRbKnGjC4=
X-Google-Smtp-Source: ABdhPJyJiZ1xdd00sOoiKgrEjoKuhoY44Kn3r4lbP0vycU+dJuEXzZdcYHq6tuAEpXZUgpmZuBalmA==
X-Received: by 2002:a17:90a:4a4:: with SMTP id g33mr3330295pjg.221.1611721428398;
        Tue, 26 Jan 2021 20:23:48 -0800 (PST)
Received: from ubuntu ([1.53.255.147])
        by smtp.gmail.com with ESMTPSA id n12sm605264pff.29.2021.01.26.20.23.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Jan 2021 20:23:47 -0800 (PST)
Date:   Wed, 27 Jan 2021 11:23:41 +0700
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Fix integer overflow in argument calculation for
 bpf_map_area_alloc
Message-ID: <20210127042341.GA4948@ubuntu>
References: <20210126082606.3183-1-minhquangbui99@gmail.com>
 <CACAyw99bEYWJCSGqfLiJ9Jp5YE1ZsZSiJxb4RFUTwbofipf0dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw99bEYWJCSGqfLiJ9Jp5YE1ZsZSiJxb4RFUTwbofipf0dA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 09:36:57AM +0000, Lorenz Bauer wrote:
> On Tue, 26 Jan 2021 at 08:26, Bui Quang Minh <minhquangbui99@gmail.com> wrote:
> >
> > In 32-bit architecture, the result of sizeof() is a 32-bit integer so
> > the expression becomes the multiplication between 2 32-bit integer which
> > can potentially leads to integer overflow. As a result,
> > bpf_map_area_alloc() allocates less memory than needed.
> >
> > Fix this by casting 1 operand to u64.
> 
> Some quick thoughts:
> * Should this have a Fixes tag?

Ok, I will add Fixes tag in later version patch.

> * Seems like there are quite a few similar calls scattered around
> (cpumap, etc.). Did you audit these as well?

I spotted another bug after re-auditting. In hashtab, there ares 2 places using
the same calls

	static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
	{
		/* ... snip ... */
		if (htab->n_buckets == 0 ||
		    htab->n_buckets > U32_MAX / sizeof(struct bucket))
			goto free_htab;

		htab->buckets = bpf_map_area_alloc(htab->n_buckets *
						   sizeof(struct bucket),
						   htab->map.numa_node);
	}

This is safe because of the above check.

	static int prealloc_init(struct bpf_htab *htab)
	{
		u32 num_entries = htab->map.max_entries;
		htab->elems = bpf_map_area_alloc(htab->elem_size * num_entries,
						 htab->map.numa_node);
	}

This is not safe since there is no limit check in elem_size.

In cpumap,

	static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
	{
		cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
						   sizeof(struct bpf_cpu_map_entry *),
						   cmap->map.numa_node);
	}

I think this is safe because max_entries is not permitted to be larger than NR_CPUS.

In stackmap, there is a place that I'm not very sure about

	static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
	{
		u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;
		smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
						 smap->map.numa_node);
	}

This is called after another bpf_map_area_alloc in stack_map_alloc(). In the first
bpf_map_area_alloc() the argument is calculated in an u64 variable; so if in the second
one, there is an integer overflow then the first one must be called with size > 4GB. I 
think the first one will probably fail (I am not sure about the actual limit of vmalloc()),
so the second one might not be called.

Overall, I think it is error prone in this pattern, maybe we should use typecasting in all
similar calls or make a comment why we don't use typecasting. As I see typecasting is not so
expensive and we can typecast the sizeof() operand so this change only affect 32-bit
architecture.

> * I'd prefer a calloc style version of bpf_map_area_alloc although
> that might conflict with Fixes tag.

Yes, I think the calloc style will prevent this kind of integer overflow bug.

Thank you,
Quang Minh.

