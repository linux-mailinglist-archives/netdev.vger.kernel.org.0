Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B68B46DE63
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhLHWdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhLHWdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 17:33:50 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7235C061746;
        Wed,  8 Dec 2021 14:30:17 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id p65so4557915iof.3;
        Wed, 08 Dec 2021 14:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=bt66uEPCpvhO5xlEsJtnZpSsKpGJ2P3rR4vXY0f1XcI=;
        b=ALHjq71IP6TXcZLoPBmrtr0EwP0Ym0AgJYegmrJtRINWvx2OQeXAxmGvSDi6GB+vnQ
         hylKvpvYKxXF3AGbuzxaAF7jt6DaNRksqmWLDsVE21BINIoCgrpry+hGfEKmfMNXqoS6
         fl2+amE80tPE9oeASAmBpck3flRiMCegRfkjREW1ZYhkM1YOHPEoAzw+uJigqFq7v5/V
         Y5p5muppeaQH8YcuqLBvMvHzfOA1bTJThweFCdSqTYEqct5Oy79j8IM+S9uKLSiNqrMz
         MaQj5e9hnUO4PWNyDu63z96cLMG/aPqBxNX2ftLLoy3+KErk9L2fTlEY90G0IUf0fCv8
         g9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=bt66uEPCpvhO5xlEsJtnZpSsKpGJ2P3rR4vXY0f1XcI=;
        b=PIOgXhxKujPpIcmATTxuOExEQ5uo1r5AoITAI4evTIizfLg5z9wthF7TR3JMiS/wIV
         eUJjpuEpe6hMspl17v3Yt2ZX9Mk8BrMDUEUMqUbjzpkG5Iy+MvBN9jKbW0eO5spewMYh
         LxGH+KcCRVjjnyTBPmxZsRkyMsEjSvSrqazrde5eqXdOMYqd/VpWGTEnhtgU8pmbAG0N
         nIk5mCTqs1GY2n/0ssG9yht5GrdicFgMxdvMkOal7Gd1vIrrBnM9of8VogVxZbLj9fNM
         D+9kEHPAjdMYfwLlaBHmzvfjcgQqFOZcSNbuVNGH4/sX8UyBCIYj+XDQtvuCnADn5bEj
         OAuA==
X-Gm-Message-State: AOAM531VdSvwIpL25qTrfv8i2bXaf3OQ5rA0cTT/jyiXYNNu2MmU2iXG
        rwMEL8FotNizcFyokMqJ/kw=
X-Google-Smtp-Source: ABdhPJxiLmRQRqhhJ7IWtUnhaPcwSLmdXq8iZ2i1cSkS3wkTJV3M55IDMDim9rXzMYNPfdfqlqtODg==
X-Received: by 2002:a05:6638:24c6:: with SMTP id y6mr3630866jat.98.1639002617312;
        Wed, 08 Dec 2021 14:30:17 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id x15sm2465642iob.8.2021.12.08.14.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 14:30:16 -0800 (PST)
Date:   Wed, 08 Dec 2021 14:30:08 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <61b131f0a4c18_97957208ad@john.notmuch>
In-Reply-To: <20211202000232.380824-2-toke@redhat.com>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-2-toke@redhat.com>
Subject: RE: [PATCH bpf-next 1/8] page_pool: Add callback to init pages when
 they are allocated
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Add a new callback function to page_pool that, if set, will be called e=
very
> time a new page is allocated. This will be used from bpf_test_run() to
> initialise the page data with the data provided by userspace when runni=
ng
> XDP programs with redirect turned on.
> =

> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>

>  include/net/page_pool.h | 2 ++
>  net/core/page_pool.c    | 2 ++
>  2 files changed, 4 insertions(+)
> =

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 3855f069627f..a71201854c41 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -80,6 +80,8 @@ struct page_pool_params {
>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
>  	unsigned int	max_len; /* max DMA sync memory size */
>  	unsigned int	offset;  /* DMA addr offset */
> +	void (*init_callback)(struct page *page, void *arg);
> +	void *init_arg;
>  };
>  =

>  struct page_pool {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9b60e4301a44..fb5a90b9d574 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -219,6 +219,8 @@ static void page_pool_set_pp_info(struct page_pool =
*pool,
>  {
>  	page->pp =3D pool;
>  	page->pp_magic |=3D PP_SIGNATURE;
> +	if (unlikely(pool->p.init_callback))
> +		pool->p.init_callback(page, pool->p.init_arg);

already in slow path right? So unlikely in a slow path should not
have any impact on performance is my reading.

>  }
>  =

>  static void page_pool_clear_pp_info(struct page *page)
> -- =

> 2.34.0
> =



