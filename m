Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DD327751C
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgIXPVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgIXPVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:21:35 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC31C0613CE;
        Thu, 24 Sep 2020 08:21:35 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id s66so3535734otb.2;
        Thu, 24 Sep 2020 08:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=tdlSq516nJsQ9Fn8kvplDAgcaQA+pzkFi+5Vr1OObFA=;
        b=q/MPHz6FbEdR5/gLUGvS37zh/WTjQEeB7t3iuPCpZFHhU7iKqytlsxyf7FIvj/V75x
         SvF+YkHLApCfRS1uqzDc6J0JEio7dIixQhVkETRBF7BzlhqqQmjtfR4RttO/DpsQVEQy
         Y2m4vqzGA7FAVqBi4VFC/aAMOjbTYwvfozn28W/rQeMrPFvDsV+4LFX3sAtco3BA+pl3
         6Wm8twwUDftNnKe6De1HyQ3Bvk+qz0lkNd+wA1hJyyKKYlIuPtbvJGIz1HpsxkChAiRh
         cvApC88Ce+LfzfF+q9p+kg/ijOiHxcbRVlHrfZt9TxaT8fjwawm+f/ktaDsPtK3aXfRl
         hfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=tdlSq516nJsQ9Fn8kvplDAgcaQA+pzkFi+5Vr1OObFA=;
        b=MMXdzdzaD7MqQU3j9dBK+Dxe0uy54zYkvJGx6Uw/piLgalRocoJWMgKMxOcfY1jv6m
         VrlbCzAToQBJ2Md8xfVfNzgqnrkWZM0718KYWyGQPal78nqoJxiIiXsiO1+Ap2nNSF+g
         6VOliemztxa8XapbbXvhoMDPxtF8CGR0UJRTcMHD/I+IlP3W6iUL85lwFLVI+U5oIVxK
         lvra2hqUjiaDVFsL+KKsDtCTjJeCYhQHxPdTWGDeWe2JblXST6tm7q3lR39es3F/0Cj6
         OCxw6izAEb4mJF5789oOr/u1YEkxVC6K4YPb2joXzsghR/ETsUnehvtK49YmvZh6Zp8k
         SbuQ==
X-Gm-Message-State: AOAM533EMT11Imk/1s0qhTSmocQqDhVzWBhlxeWvcBWPuiRIahdmniro
        ocGkQ4Vpr3umNJilFqSNYvxNrew2xFwK6Q==
X-Google-Smtp-Source: ABdhPJyF2jqChaAhEtb3l/uAscptqpekYP6oAOrzaMSDlEtf/xy2X1vV2JBL+t+yCuLBX6yezzkzZA==
X-Received: by 2002:a05:6830:2104:: with SMTP id i4mr127671otc.266.1600960894602;
        Thu, 24 Sep 2020 08:21:34 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j10sm748943oif.36.2020.09.24.08.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 08:21:33 -0700 (PDT)
Date:   Thu, 24 Sep 2020 08:21:27 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <5f6cb9778cbd7_4939c208b8@john-XPS-13-9370.notmuch>
In-Reply-To: <20200923155436.2117661-3-andriin@fb.com>
References: <20200923155436.2117661-1-andriin@fb.com>
 <20200923155436.2117661-3-andriin@fb.com>
Subject: RE: [PATCH bpf-next 2/9] libbpf: remove assumption of single
 contiguous memory for BTF data
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Refactor internals of struct btf to remove assumptions that BTF header, type
> data, and string data are layed out contiguously in a memory in a single
> memory allocation. Now we have three separate pointers pointing to the start
> of each respective are: header, types, strings. In the next patches, these
> pointers will be re-assigned to point to independently allocated memory areas,
> if BTF needs to be modified.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

[...]

> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -27,18 +27,37 @@
>  static struct btf_type btf_void;
>  
>  struct btf {
> -	union {
> -		struct btf_header *hdr;
> -		void *data;
> -	};
> +	void *raw_data;
> +	__u32 raw_size;
> +
> +	/*
> +	 * When BTF is loaded from ELF or raw memory it is stored
> +	 * in contiguous memory block, pointed to by raw_data pointer, and
> +	 * hdr, types_data, and strs_data point inside that memory region to
> +	 * respective parts of BTF representation:

I find the above comment a bit confusing. The picture though is great. How
about something like,

  When BTF is loaded from an ELF or raw memory it is stored
  in a continguous memory block. The hdr, type_data, and strs_data
  point inside that memory region to their respective parts of BTF
  representation

> +	 *
> +	 * +--------------------------------+
> +	 * |  Header  |  Types  |  Strings  |
> +	 * +--------------------------------+
> +	 * ^          ^         ^
> +	 * |          |         |
> +	 * hdr        |         |
> +	 * types_data-+         |
> +	 * strs_data------------+
> +	 */
> +	struct btf_header *hdr;
> +	void *types_data;
> +	void *strs_data;
> +
> +	/* type ID to `struct btf_type *` lookup index */
>  	__u32 *type_offs;
>  	__u32 type_offs_cap;
> -	const char *strings;
> -	void *nohdr_data;
> -	void *types_data;
>  	__u32 nr_types;
> -	__u32 data_size;
> +
> +	/* BTF object FD, if loaded into kernel */
>  	int fd;
> +
> +	/* Pointer size (in bytes) for a target architecture of this BTF */
>  	int ptr_sz;
>  };
>  

Thanks,
John
