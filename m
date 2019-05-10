Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0EC1A3C8
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 22:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfEJUNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 16:13:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45769 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbfEJUNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 16:13:20 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so3765161pfm.12
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 13:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5kmW1Mcd70I+S2hn4CoHjnetI9cWoaGjqbqg57ZHIFw=;
        b=AavDWWSrqJoZybw1L/Quu+Vf+QjpjdBpEW3h/DnRsRGWJ2UvOWLQZhDsoaDuk7EoeK
         LGX53OoEZ+1QUIjQ4sedUTLS/AAAk3uYsbPT4QbrPQM9/VPCADjWImknx3P0Z3iBj/Q4
         BJyxY1Rq5jUAAzv0kmkLZh6TLM8LHwqnUsBPeiGYHkSVjp8u0CHDbB/nCjeSohgJmhws
         x2Oib9OfRZz1hXeqjmnu8xEG+CVTWvbMwqdDUQ+UY7vslNY8uaYKxTISu1f52heRD5TM
         Qs4Uv86s32Zgz7LN//gYzubkiSoWo1UN6PA+IROYkItwRYbXDk0eqQSInCpfFRtPVZVj
         bbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5kmW1Mcd70I+S2hn4CoHjnetI9cWoaGjqbqg57ZHIFw=;
        b=FYnw/PBarBThQtXhs3LHpydB7802aMjU3DyWKHdS7gc/k4BBl82F+HwepzoLMXqs+Y
         mTsZaoigiP9D4p5zkeSDzo7EyxaAWhX0xzjRlHq4MM2QX0rTGngPFTjoeXgPOnDDsEJl
         kGEsj3w0sLI72c1IdH72nWp0UEl3mCj/N6u+JFGgAKl9iiRugC1KW02WTaJllhRuN1Te
         BmakGUBx8pvwCj2x4k2hRUB50niJPr7Kc5QnWGdU2LIvxp3Y1hqtJI+FKnDKNZR+7A0D
         7C9k4veesnW4kEgktLhr5rT6PNzIfpY45sl2GOOGsO0SNNFtKjxZOt9SjxVlYg2MqVlb
         hH2A==
X-Gm-Message-State: APjAAAU7N+agfRn8AY5TuhvpbAkruIP5XEH/HA1QvCzSjm35WLCKDygz
        9vsbqvs9PQngM6bWvuKOqAc=
X-Google-Smtp-Source: APXvYqyMQ/R05Z9RJpfVN4bWHTz5VLdYrbmtj3/BSGULE4lykYuGoXmLRiWDhNjrWqir8cjaS6UT+w==
X-Received: by 2002:a63:d512:: with SMTP id c18mr16493658pgg.252.1557519199737;
        Fri, 10 May 2019 13:13:19 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::730f])
        by smtp.gmail.com with ESMTPSA id b1sm6722880pgq.15.2019.05.10.13.13.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 13:13:18 -0700 (PDT)
Date:   Fri, 10 May 2019 13:13:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, netdev@vger.kernel.org, ast@fb.com,
        yhs@fb.com, daniel@iogearbox.net
Subject: Re: [PATCH v2 bpf] libbpf: detect supported kernel BTF features and
 sanitize BTF
Message-ID: <20190510201315.jrzt2yo2pchbckda@ast-mbp>
References: <20190510184150.1671773-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510184150.1671773-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 11:41:50AM -0700, Andrii Nakryiko wrote:
> Depending on used versions of libbpf, Clang, and kernel, it's possible to
> have valid BPF object files with valid BTF information, that still won't
> load successfully due to Clang emitting newer BTF features (e.g.,
> BTF_KIND_FUNC, .BTF.ext's line_info/func_info, BTF_KIND_DATASEC, etc), that
> are not yet supported by older kernel.
> 
> This patch adds detection of BTF features and sanitizes BPF object's BTF
> by substituting various supported BTF kinds, which have compatible layout:
>   - BTF_KIND_FUNC -> BTF_KIND_TYPEDEF
>   - BTF_KIND_FUNC_PROTO -> BTF_KIND_ENUM
>   - BTF_KIND_VAR -> BTF_KIND_INT
>   - BTF_KIND_DATASEC -> BTF_KIND_STRUCT
> 
> Replacement is done in such a way as to preserve as much information as
> possible (names, sizes, etc) where possible without violating kernel's
> validation rules.
> 
> v1->v2:
>   - add internal libbpf_util.h w/ common stuff
>   - switch SK storage BTF to use new libbpf__probe_raw_btf()
> 
> Reported-by: Alexei Starovoitov <ast@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
...
> diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
> index da94c4cb2e4d..319e744eb33a 100644
> --- a/tools/lib/bpf/libbpf_util.h
> +++ b/tools/lib/bpf/libbpf_util.h
> @@ -57,4 +57,16 @@ do {				\
>  } /* extern "C" */
>  #endif
>  
> +#define BTF_INFO_ENC(kind, kind_flag, vlen) \
> +	((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
> +#define BTF_TYPE_ENC(name, info, size_or_type) (name), (info), (size_or_type)
> +#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
> +	((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
> +#define BTF_TYPE_INT_ENC(name, encoding, bits_offset, bits, sz) \
> +	BTF_TYPE_ENC(name, BTF_INFO_ENC(BTF_KIND_INT, 0, 0), sz), \
> +	BTF_INT_ENC(encoding, bits_offset, bits)
> +#define BTF_MEMBER_ENC(name, type, bits_offset) (name), (type), (bits_offset)
> +#define BTF_PARAM_ENC(name, type) (name), (type)
> +#define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)

hmm. why are those needed in libbpf_util.h ?
I thought the goal is move them into libbpf_internal.h
and not to expose to users?

