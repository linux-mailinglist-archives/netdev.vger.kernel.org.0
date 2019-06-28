Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7775A2FC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfF1SAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:00:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43750 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF1SAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:00:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so3639562plb.10
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jYb3HeTQfcaIFWpL/ma+nS5IiqOCQX6f79nGlje2oxI=;
        b=Itbje9RPJpvc2oL309mj4r5ADr6AXFyHyPGFhgT3L4XivbJatLbHk/H9vuuGSIdfpG
         GoZuemy4B6JdFXIxsKYMoWoIV74tzblZ1yDwoKdX7luhTsliuGQkuJDBMzOJ3Cwd0Ht5
         /ZHeT4Z5S8uf4OVP9GG+LMdZuvZLGNxLOPo8BPwD0r/A8nsOEQsYxrlPj/WDe/5/7yWC
         aQ/rKaIFwVf+0h+Oxc1JLdCqcRaVMEx7Hleb+9mbaVeYnM/bJedInsdZZCGVvQG0ewID
         anDtGZiw7kx9nPeSxSIRbRBsnkBIANpkR6pzHwA7cnGDWipqDVWMSnFqf1/qHgfAdjt8
         5Z8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jYb3HeTQfcaIFWpL/ma+nS5IiqOCQX6f79nGlje2oxI=;
        b=tiexGr09GCiP0LZb6QZKShkm832GLwBomW5tr8Wg2WiFmuE2K4KiDuBZD0DS4HQJBP
         3Wi/zUqYJrx1ZrhDmXT6kNalOqcnH/VNbrf9gUUDDa5VCXUpNKBgK18lRGJ14IVKe2Sh
         LCrj/N/V5DAlzsEgSHzsV4W+uLL9y5asJ2MsvUbUEj0dGb2bLVAD0RaL55H/nPQk7aRR
         M+4pSx+W+Bl6e0FCtriI5FRoqusSPyuFp1h57uTiZLzETErMO9IC/r8mcMQ60xcWL6Fs
         beg44EXQgf317jrkq3rB1RQd+DCMRu3tVbYyfthu1nl4NUn2pOrTD7/1QG/vbKhm8ZeK
         eUYQ==
X-Gm-Message-State: APjAAAWqIaugnpimvPSsSxxJhTZFp03al+tiaXgOyWfNiZTdnybNJt+m
        buzGwF+MnJWMORTgjb0Oa/P6Og==
X-Google-Smtp-Source: APXvYqzEP5dTno6gpjCzfyor7yx+9fSqCOrt0Ek/QInu8yUiEyEOqUOSZfq1IzDye50dhd+/WN0wEw==
X-Received: by 2002:a17:902:9a85:: with SMTP id w5mr11538718plp.221.1561744811267;
        Fri, 28 Jun 2019 11:00:11 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id w16sm3666140pfj.85.2019.06.28.11.00.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:00:10 -0700 (PDT)
Date:   Fri, 28 Jun 2019 11:00:10 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
Message-ID: <20190628180010.GA24308@mini-arch>
References: <20190628055303.1249758-1-andriin@fb.com>
 <20190628055303.1249758-4-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628055303.1249758-4-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/27, Andrii Nakryiko wrote:
> bpf_program__attach_perf_event allows to attach BPF program to existing
> perf event hook, providing most generic and most low-level way to attach BPF
> programs. It returns struct bpf_link, which should be passed to
> bpf_link__destroy to detach and free resources, associated with a link.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 58 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |  3 +++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 62 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 455795e6f8af..606705f878ba 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -32,6 +32,7 @@
>  #include <linux/limits.h>
>  #include <linux/perf_event.h>
>  #include <linux/ring_buffer.h>
> +#include <sys/ioctl.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <sys/vfs.h>
> @@ -3958,6 +3959,63 @@ int bpf_link__destroy(struct bpf_link *link)
>  	return err;
>  }
>  
> +struct bpf_link_fd {
> +	struct bpf_link link; /* has to be at the top of struct */
> +	int fd; /* hook FD */
> +};
> +
> +static int bpf_link__destroy_perf_event(struct bpf_link *link)
> +{
> +	struct bpf_link_fd *l = (void *)link;
> +	int err;
> +
> +	if (l->fd < 0)
> +		return 0;
> +
> +	err = ioctl(l->fd, PERF_EVENT_IOC_DISABLE, 0);
> +	close(l->fd);
> +	return err;
Why not return -errno from ioctl here (as you do elsewhere)?

> +}
> +
> +struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> +						int pfd)
> +{
> +	char errmsg[STRERR_BUFSIZE];
> +	struct bpf_link_fd *link;
> +	int bpf_fd, err;
> +
> +	bpf_fd = bpf_program__fd(prog);
> +	if (bpf_fd < 0) {
> +		pr_warning("program '%s': can't attach before loaded\n",
> +			   bpf_program__title(prog, false));
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	link = malloc(sizeof(*link));
> +	if (!link)
> +		return ERR_PTR(-ENOMEM);
> +	link->link.destroy = &bpf_link__destroy_perf_event;
> +	link->fd = pfd;
> +
> +	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, bpf_fd) < 0) {
> +		err = -errno;
> +		free(link);
> +		pr_warning("program '%s': failed to attach to pfd %d: %s\n",
> +			   bpf_program__title(prog, false), pfd,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return ERR_PTR(err);
> +	}
> +	if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
> +		err = -errno;
> +		free(link);
> +		pr_warning("program '%s': failed to enable pfd %d: %s\n",
> +			   bpf_program__title(prog, false), pfd,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return ERR_PTR(err);
> +	}
> +	return (struct bpf_link *)link;
> +}
> +
>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>  			   void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 5082a5ebb0c2..1bf66c4a9330 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -169,6 +169,9 @@ struct bpf_link;
>  
>  LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
>  
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> +
>  struct bpf_insn;
>  
>  /*
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 3cde850fc8da..756f5aa802e9 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -169,6 +169,7 @@ LIBBPF_0.0.4 {
>  	global:
>  		bpf_link__destroy;
>  		bpf_object__load_xattr;
> +		bpf_program__attach_perf_event;
>  		btf_dump__dump_type;
>  		btf_dump__free;
>  		btf_dump__new;
> -- 
> 2.17.1
> 
