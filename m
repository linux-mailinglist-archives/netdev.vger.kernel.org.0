Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EFC46818E
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 01:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383910AbhLDAuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 19:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354618AbhLDAuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 19:50:50 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B25C061751;
        Fri,  3 Dec 2021 16:47:25 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id s37so4639600pga.9;
        Fri, 03 Dec 2021 16:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=82zoxTyylQxErFpnuqHNAfQjAlvM/1ajL8oX6RGNRyI=;
        b=aMSOLBzknMmr7Jy2594bk5fDz23voRIfH9ahtg/4gH8smT/JhXJoq4fjXKCbOOfQjh
         JUO/v7GkGRHtren+t3KBBl40Rs/JgiZblRLOWgoWBhOBRf8qzifPQlnq6XSj/enr9ThV
         1aOzFbaf4wrME/iyezfw4MteryJuFrUZrU/14/clVNgji46r3pj9Xtsb9Wxy/mJ9hfnc
         JVQspMpiF/UGMiBOj7zJNGxjrMo7KwQ0uwTqgEXjylne4xjRtWT3V8v0voG8ixydYmOP
         Ni0yDsASH66wl/cQXwUJtHxssbuRy/tL9jd9QMez6T4f5pZDY7dd78TAtoE0GY0mVAM0
         iuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=82zoxTyylQxErFpnuqHNAfQjAlvM/1ajL8oX6RGNRyI=;
        b=jiKuOzVEgZTCqnou5V9+hf27e5388IEoWoEseKv1yafjuscNcA25uHjfdcYdRHtsKP
         PEA7TxlVOnOhmbzkDDcyQ0rz2IW6M0EVqTdEFHqzzpAqkgfh8ZIPU65sMpXomiCiLtVS
         PXkWRflxEa3YrPpLT6cQO9JmFMs/d5/G+mpNtxWFTePD6x+HhuXQtHsmyRUhlT6EbJ7p
         wjXysv3Y6eGggqDhcbXrV1yCUgqtwzQm/QUxnPOvZL28BLoBu+1kYMLkxk+1qRQXLkYm
         FNaY7flABL5kvyuzzsdTPXZ7OcL8haIhxTbWuSu3gJu6BS0ISnQfQj6iUQ18tDL0uQa0
         vwtg==
X-Gm-Message-State: AOAM533pGV2zPGB0DcrHrSKgnA9S2k/bXJzefWe64B1hXOm2o8U98hgu
        CkLU5DLFgzlBfJOxB9h94hw=
X-Google-Smtp-Source: ABdhPJxcDwxNnWas1calrP2vbMdflZjfU2uftdHg9+YuF/nnzOevI8b8awiRgB40YfH/csy2leAZ7A==
X-Received: by 2002:a05:6a00:2402:b0:4a8:4557:e96b with SMTP id z2-20020a056a00240200b004a84557e96bmr22050497pfh.76.1638578845439;
        Fri, 03 Dec 2021 16:47:25 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id ot18sm3589156pjb.14.2021.12.03.16.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:47:25 -0800 (PST)
Date:   Sat, 4 Dec 2021 06:17:21 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH bpf 1/2] samples: bpf: fix xdp_sample_user.o linking with
 Clang
Message-ID: <20211204004721.ubdt2kcshorcmhw4@apollo.legion>
References: <20211203195004.5803-1-alexandr.lobakin@intel.com>
 <20211203195004.5803-2-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203195004.5803-2-alexandr.lobakin@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 01:20:03AM IST, Alexander Lobakin wrote:
> Clang (13) doesn't get the jokes about specifying libraries to link in
> cclags of individual .o objects:
>
> clang-13: warning: -lm: 'linker' input unused [-Wunused-command-line-argument]
> [ ... ]
>   LD  samples/bpf/xdp_redirect_cpu
>   LD  samples/bpf/xdp_redirect_map_multi
>   LD  samples/bpf/xdp_redirect_map
>   LD  samples/bpf/xdp_redirect
>   LD  samples/bpf/xdp_monitor
> /usr/bin/ld: samples/bpf/xdp_sample_user.o: in function `sample_summary_print':
> xdp_sample_user.c:(.text+0x84c): undefined reference to `floor'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x870): undefined reference to `ceil'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x8cf): undefined reference to `floor'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x8f3): undefined reference to `ceil'
> [ more ]
>
> Specify '-lm' as ldflags for all xdp_sample_user.o users in the main
> Makefile and remove it from ccflags of ^ in Makefile.target -- just
> like it's done for all other samples. This works with all compilers.
>
> Fixes: 6e1051a54e31 ("samples: bpf: Convert xdp_monitor to XDP samples helper")
> Fixes: b926c55d856c ("samples: bpf: Convert xdp_redirect to XDP samples helper")
> Fixes: e531a220cc59 ("samples: bpf: Convert xdp_redirect_cpu to XDP samples helper")
> Fixes: bbe65865aa05 ("samples: bpf: Convert xdp_redirect_map to XDP samples helper")
> Fixes: 594a116b2aa1 ("samples: bpf: Convert xdp_redirect_map_multi to XDP samples helper")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---

Thanks, something to remember to test for next time.

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

--
Kartikeya
