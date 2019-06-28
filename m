Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49825A026
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfF1QCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:02:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40377 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfF1QCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:02:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so3199079pfp.7
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 09:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TLNrAB201YzCAcZmRuW/d296gbc5A6Q/Q8iWXVJPuJE=;
        b=MZ/qw2CVooZO6WTDW/7pVCyicWfdJhtQAilQzFVNZFM9ZwoeDqwJ+ZbX3LfIch9wSc
         NqY/Wp7L8HVY9XVqpfNFE3fMqimCec7UZjGPz+H6HNtqh+zEH4RqSVXl/+HiJJGCdKVX
         x+k9CvrHoEam+Oqw2lMcMQncx8f19sV0punrWW6vrqZhY9L6WVgm0XjhlKkg0jKy5MtS
         pWJVjTqG16Zy5iy/XFkWE491dR1dU5hkRYid3c6w3MAYPTpqvF0aRMV6U2HCLYd5cZDs
         ajvMhxmnCXpRTakOx413rP8WhOT4cPSSTuIIXSe/+xD0HnOrpREBrAF1uZQ+VGLt+4Zc
         iTBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TLNrAB201YzCAcZmRuW/d296gbc5A6Q/Q8iWXVJPuJE=;
        b=kumvfZuQm7Y33wbV86oxu3a8Rf/R77riDyKl2ZxxPEFSkqxY5Aw+/WhcUp6rpHeITG
         ygcAD2eUtIkJY9eG23F6J/OMjoanjyosOY9e/ooMofunicX/0yLaX8ogCwKYqm9wZnie
         aocNULBJCshWl0L/N86i5Qb2jIpixMgELG6dRJNl5DTPRP7r5YU6u4TyMtdP9OufRb+c
         EKXf51hsfVtCBopcwb/eY+Ne4TGR3ff+XR0HH4DqIFRcdxIDVczEjbo8B+bqYuhSJRrR
         JIGv8D3XaWp/7jyYYKVqDscgCm1PZ8vmttPjXZk+j0EnAuER2otXllTfHNFag5Gq3zig
         T4TQ==
X-Gm-Message-State: APjAAAWwWqtY3dXQSO/obh70fcrUXTAPyBXr5L/PbNGaTL0pEATIQpGU
        VWiWzsppKoZJU4ouhi+SeKGApg==
X-Google-Smtp-Source: APXvYqxP2THTuwOO9kkZF/WH/xYdo4zCIIIeCgnfkd/4KMPRjBlzEESBZ7AWsYzy4EtBrDo+c73/YQ==
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr14530889pje.12.1561737751540;
        Fri, 28 Jun 2019 09:02:31 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id w132sm3045829pfd.78.2019.06.28.09.02.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 09:02:31 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:02:30 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 2/9] libbpf: introduce concept of bpf_link
Message-ID: <20190628160230.GG4866@mini-arch>
References: <20190628055303.1249758-1-andriin@fb.com>
 <20190628055303.1249758-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628055303.1249758-3-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/27, Andrii Nakryiko wrote:
> bpf_link is and abstraction of an association of a BPF program and one
> of many possible BPF attachment points (hooks). This allows to have
> uniform interface for detaching BPF programs regardless of the nature of
> link and how it was created. Details of creation and setting up of
> a specific bpf_link is handled by corresponding attachment methods
> (bpf_program__attach_xxx) added in subsequent commits. Once successfully
> created, bpf_link has to be eventually destroyed with
> bpf_link__destroy(), at which point BPF program is disassociated from
> a hook and all the relevant resources are freed.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 17 +++++++++++++++++
>  tools/lib/bpf/libbpf.h   |  4 ++++
>  tools/lib/bpf/libbpf.map |  3 ++-
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6e6ebef11ba3..455795e6f8af 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3941,6 +3941,23 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
>  	return 0;
>  }
>  
> +struct bpf_link {
Maybe call it bpf_attachment? You call the bpf_program__attach_to_blah
and you get an attachment?

> +	int (*destroy)(struct bpf_link *link);
> +};
> +
> +int bpf_link__destroy(struct bpf_link *link)
> +{
> +	int err;
> +
> +	if (!link)
> +		return 0;
> +
> +	err = link->destroy(link);
> +	free(link);
> +
> +	return err;
> +}
> +
>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>  			   void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index d639f47e3110..5082a5ebb0c2 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -165,6 +165,10 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
>  LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
>  LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
>  
> +struct bpf_link;
> +
> +LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> +
>  struct bpf_insn;
>  
>  /*
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 2c6d835620d2..3cde850fc8da 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -167,10 +167,11 @@ LIBBPF_0.0.3 {
>  
>  LIBBPF_0.0.4 {
>  	global:
> +		bpf_link__destroy;
> +		bpf_object__load_xattr;
>  		btf_dump__dump_type;
>  		btf_dump__free;
>  		btf_dump__new;
>  		btf__parse_elf;
> -		bpf_object__load_xattr;
>  		libbpf_num_possible_cpus;
>  } LIBBPF_0.0.3;
> -- 
> 2.17.1
> 
