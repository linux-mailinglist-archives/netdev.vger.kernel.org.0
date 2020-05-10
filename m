Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289241CC5C9
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 02:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgEJAfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 20:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726778AbgEJAfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 20:35:39 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E133C061A0C;
        Sat,  9 May 2020 17:35:38 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r10so2224616pgv.8;
        Sat, 09 May 2020 17:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iDCr2ISbXb85EK9NUJkkgFn8YOtX1VZszLrfJxpdewQ=;
        b=Hjw4hS6QHZpkK0JSnU+EY4ghKjsVhKjGo4Wd48+Ek/xb+WQeHaVMyHvYzOzzFfviWu
         vnd63K/Ua4CbmljDaIiioWWeTuTnwopm5rRAVvsYVSuRF1GZDXlkFn7QDOP4PNvUO7PX
         WhHdqeH0wO+hj13iRS2BNTp9+MHfN8JUW1y69ob+2mSpzvusn2yk9QsNBLD+hhYZXKvk
         6/1EP8UlrdEdLS90l/H3L/V9IXIdh9a1yhYNXVyd31JE9WrUCw4xl7Lbq1l2Jw/B+dlb
         3Qa+6077k1SlmP9dmojA34Hyo5NmCCcDn9LmfrbYZ790MYSrENIozbYMKJiCf1Y7LNR3
         IGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iDCr2ISbXb85EK9NUJkkgFn8YOtX1VZszLrfJxpdewQ=;
        b=d2Yx2ISeJTa2Q7mDRDdJsd9TVWrWHiohRBp08dbQu9sRTbWkTg9AdvmY8FlV2hEwVk
         3r1ONTujszHl3b0RAjt41HcCzKr378E6X2l10ZTwEpXTwweSlNjyk0Ll0UKYxlwO8ZoI
         tWMbv42cBW88f9E1wlWulWNynaaKFQqUQg6ES4JTIaOUcdHH1UvpAfxpfHZnfdb87WhH
         8ydEZ6S2lROfEBrb9xtKf9WmxlW7guNdsD98WR3LXv4FWmsnU49wzBHcyFdmP6U9sMyQ
         jsJT9Tq5sSM3JA0evtkC3vzwTMUBoS/VBJwcWZf2Cvyc3i9nSSbd0HsVX9XpBrX6j4EI
         fz0Q==
X-Gm-Message-State: AGi0PubvHIzFhiCd12No3BrOkGRUox63c0jjlhnaRx14g6YQhFlecZtP
        dNclO7SfIcCFAGf2NUcWBzc=
X-Google-Smtp-Source: APiQypKp2dim1vMrfqO4QxoT1dSr/Pyo3EXGWZ+TCv4VhBpHabF2ZB0oGyV3XkwKsm5MmZw0Qhj8wQ==
X-Received: by 2002:a62:34c1:: with SMTP id b184mr9703543pfa.73.1589070937861;
        Sat, 09 May 2020 17:35:37 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7bdb])
        by smtp.gmail.com with ESMTPSA id d8sm5286255pfd.159.2020.05.09.17.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 17:35:37 -0700 (PDT)
Date:   Sat, 9 May 2020 17:35:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v4 16/21] tools/libbpf: add bpf_iter support
Message-ID: <20200510003535.rfnwiuunxst6lqe5@ast-mbp>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175917.2476936-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509175917.2476936-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 10:59:17AM -0700, Yonghong Song wrote:
> @@ -6891,6 +6897,7 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
>  
>  #define BTF_TRACE_PREFIX "btf_trace_"
>  #define BTF_LSM_PREFIX "bpf_lsm_"
> +#define BTF_ITER_PREFIX "__bpf_iter__"
>  #define BTF_MAX_NAME_SIZE 128

In the kernel source the prefix doesn't stand out, but on libbpf side it looks
inconsistent. May be drop __ prefix and keep one _ in the suffix?
