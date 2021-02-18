Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEE231E387
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 01:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBRAq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 19:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhBRAqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 19:46:54 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3CCC061574;
        Wed, 17 Feb 2021 16:46:14 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id q9so42615ilo.1;
        Wed, 17 Feb 2021 16:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FIejfxEN+OKZDYsEhrma7B8eOaQBPFZ4Xime0REzBl8=;
        b=BIOlUGP4CalqxEb+FaqBDN0+Y3g0ppyI7YfN6o54H+4pLr+cllZ4iGI9aTFi1jwTEX
         HifOemf56cvMLR9/zNW1R0zVcFKF/au3qNbP0oICWnfJxLrGiN1Wr3yj7qq+BoS4hIlh
         irsXcb9LhYsorTI84JQF8BDXKr489EgtrNjUcr9WYw5odNO1/GprPNH4amxGQvhhDrSx
         9h/4q4tm8tHRTGJ0sIGpFl6akHtmFFmIF7YDcXbgSekJH9zhLwwYyIXWvACEKNv8qvPj
         3+WV724wqWQ3rnzRRP+PXTBug4ohFcpYHzWCc4zc/IfylYpXTEDiL1vlwDeQ8HI+GFzo
         fH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FIejfxEN+OKZDYsEhrma7B8eOaQBPFZ4Xime0REzBl8=;
        b=GAqAVqQCoCm/pf/1kcd/7ilp/+DWjtYWvju/On8xA8diRKerFPakR6Qia2lb8i9CCY
         MERFah8FRjL3xAKxO35vkVUVeKHUNPUAsr/i5Yq8WGuDtX6JddGL+jp35vgNRtFFhYF0
         kHXdyVIttMl+Z1hovGrGGUL3Ikt114evBeZMkR4WvE3DVXbttmKaXjjFV7wUhjWMH/ak
         MgT9or6ue6euGsKVqWORfsKUXmJbmF6PGSB4JeVdKjyaMtMi+MCw4EkM29rwDaK3Fo9m
         4/+wnBHb2vbvyswHDo2nf0+NX3j80dZXWTJrO8DnL1xS1lciRb4MNilVJRjAA/q/CnDN
         UZpQ==
X-Gm-Message-State: AOAM531GuRf7cI59hUmDGT+TdZDi48/bJgskZtvOyWFmRXOSWT4M0c5O
        A4hdoJadQkjwubABWzJVHUk=
X-Google-Smtp-Source: ABdhPJwDYJNSFnd2wxbwNHFifatEFpaDjjvkV2kZZAVjeyGYGigG85o4rzR5oxz3oajh9p91ZfeP+g==
X-Received: by 2002:a05:6e02:2142:: with SMTP id d2mr1492157ilv.249.1613609172754;
        Wed, 17 Feb 2021 16:46:12 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id y25sm2902166ioa.5.2021.02.17.16.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 16:46:11 -0800 (PST)
Date:   Wed, 17 Feb 2021 16:46:04 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Alexander Lobakin <alobakin@pm.me>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <602db8cc18aaf_fc5420827@john-XPS-13-9370.notmuch>
In-Reply-To: <20210217120003.7938-7-alobakin@pm.me>
References: <20210217120003.7938-1-alobakin@pm.me>
 <20210217120003.7938-7-alobakin@pm.me>
Subject: RE: [PATCH v7 bpf-next 6/6] xsk: build skb by page (aka generic
 zerocopy xmit)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin wrote:
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> 
> This patch is used to construct skb based on page to save memory copy
> overhead.
> 
> This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> directly construct skb. If this feature is not supported, it is still
> necessary to copy data to construct skb.
> 
> ---------------- Performance Testing ------------
> 
> The test environment is Aliyun ECS server.
> Test cmd:
> ```
> xdpsock -i eth0 -t  -S -s <msg size>
> ```
> 
> Test result data:
> 
> size    64      512     1024    1500
> copy    1916747 1775988 1600203 1440054
> page    1974058 1953655 1945463 1904478
> percent 3.0%    10.0%   21.58%  32.3%
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> [ alobakin:
>  - expand subject to make it clearer;
>  - improve skb->truesize calculation;
>  - reserve some headroom in skb for drivers;
>  - tailroom is not needed as skb is non-linear ]
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

[...]

> +	buffer = xsk_buff_raw_get_data(pool, addr);
> +	offset = offset_in_page(buffer);
> +	addr = buffer - pool->addrs;
> +
> +	for (copied = 0, i = 0; copied < len; i++) {
> +		page = pool->umem->pgs[addr >> PAGE_SHIFT];

Looks like we could walk off the end of pgs[] if len is larger than
the number of pgs? Do we need to guard against a misconfigured socket
causing a panic here? AFAIU len here is read from the user space
descriptor so is under user control. Or maybe I missed a check somewhere.

Thanks,
John


> +		get_page(page);
> +
> +		copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> +		skb_fill_page_desc(skb, i, page, offset, copy);
> +
> +		copied += copy;
> +		addr += copy;
> +		offset = 0;
> +	}
> +
> +	skb->len += len;
> +	skb->data_len += len;
> +	skb->truesize += ts;
> +
> +	refcount_add(ts, &xs->sk.sk_wmem_alloc);
> +
> +	return skb;
> +}
> +
