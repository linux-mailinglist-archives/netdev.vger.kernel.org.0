Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB4B24DF6A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgHUSX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHUSXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:23:25 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2749C061573;
        Fri, 21 Aug 2020 11:23:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u128so1472981pfb.6;
        Fri, 21 Aug 2020 11:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z1l3J4HIwjaymDbG87bFgQjdS5UWloioib/q8SREpNk=;
        b=jgKxm2H3dmu91ou+hWH8jUo90teTDoqJUzE5K8yC/yLdQLabVo8lvwe+4EVvpoXPQU
         Pt4fDERjlsRuMxDC+VG61rkO/ycOm3z5g28ZSgI5p8a7NU8zrV8+8uMR0Nb8t4+JYPyQ
         dbDcmhE9V/Y0PLo2xz1IlAF9C4b3GlSmwLONidpWrXM+srwAMoYyAmhyPdG0Spa9Htlv
         51FbgUjiYjWYCIfop+HWnyy4Ue9Kv+VE0SoRmnIu9/04cVHOYhzSrleeTi2eFZ4gHOZb
         b8aBSl3nVs3Eu7pyeVkY5uVHwjUlf16mAvu2aqnbMy9OSq4Ybdrl96jJDdYlyGo+HlRm
         /3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z1l3J4HIwjaymDbG87bFgQjdS5UWloioib/q8SREpNk=;
        b=nCQnjlT+PRlq2nHA/rr0tYQsq5bUO4PCd7E2cfNhTKhLyEwhOgV6YSdGUwPnmtIOQ5
         xlmC0/f/XuVaJTvbQ0EvJDKGvoFrYSTDA5zjuS+aFvVQxEFZfvYQLQhpQmcqCbF1faj1
         mxmUT1friyVBM0BKlbtbJ6PSB3mtxZ6Mh8KbVoEdEQfsmHqbNdVxsFdYUY2X+13q88M/
         ywSAW+1xVofQmqJX0S3zBrgHVq2XMnq0lYtoTfElxbmeZtlPFJGdoEj+KQqlynCWyKSs
         BB+6GdD5i+LsAi/PYFIZIMBgi1E2nJcIq3MQCwqxYKyfQo5XJzL7Ec82h822ffO70F/1
         VJVA==
X-Gm-Message-State: AOAM533u2BOuLQU8OeXukj7b9HbYAF7WBjH4rN9QWEg3a59EXHi5x9XQ
        JgNhhVYWuhMG3zv75/z9r4g=
X-Google-Smtp-Source: ABdhPJzJuiD3ixxA6vJ/NRGlFHb2PXkNQM1SMpjW6/zkgEg4SKvYZ5jB7O5yS6IHs9iQlIHpZAf9Ew==
X-Received: by 2002:a63:955d:: with SMTP id t29mr3122232pgn.135.1598034205068;
        Fri, 21 Aug 2020 11:23:25 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8791])
        by smtp.gmail.com with ESMTPSA id h19sm2494976pjv.41.2020.08.21.11.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 11:23:24 -0700 (PDT)
Date:   Fri, 21 Aug 2020 11:23:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH bpf-next v4 28/30] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
Message-ID: <20200821182321.dtkf5wpi4pukbq3w@ast-mbp.dhcp.thefacebook.com>
References: <20200821150134.2581465-1-guro@fb.com>
 <20200821150134.2581465-29-guro@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821150134.2581465-29-guro@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 08:01:32AM -0700, Roman Gushchin wrote:
>  
> diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> index 473665cac67e..49d1dcaf7999 100644
> --- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> +++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> @@ -26,17 +26,12 @@ __u32 g_line = 0;
>  		return 0;	\
>  })
>  
> -struct bpf_map_memory {
> -	__u32 pages;
> -} __attribute__((preserve_access_index));
> -
>  struct bpf_map {
>  	enum bpf_map_type map_type;
>  	__u32 key_size;
>  	__u32 value_size;
>  	__u32 max_entries;
>  	__u32 id;
> -	struct bpf_map_memory memory;
>  } __attribute__((preserve_access_index));

hmm. Did you build selftests?

progs/map_ptr_kern.c:45:14: error: no member named 'memory' in 'struct bpf_map'
        VERIFY(map->memory.pages > 0);
               ~~~  ^
progs/map_ptr_kern.c:25:8: note: expanded from macro 'VERIFY'
