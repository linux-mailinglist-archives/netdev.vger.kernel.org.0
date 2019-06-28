Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66FBD5A31E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfF1SFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:05:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32953 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfF1SFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:05:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so3673151plo.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ecn5HXaG6CuxgKYhfrIxBJS9FQn/XnfCS++lGW6CY8g=;
        b=nRDXSZ4T3yYQ5X1v+5AOpvPHEItAAFTex7GD9z8LVVuTTiPYycrS6/5r/mtl2CaTMI
         HJGm1Q2f685W23D9KFQ/vn5+tHvRWPkO4GEIStSHh1+i0YlsSgsN+Oh7+P2sdQU/wxhv
         1Ay5VY8yPh+8mqdnWiiL4DY8rhYLPAPGDz6ipu6ZUKVekS4wW6mNO+xrLMMX+eIrhPIC
         pwfKdZqL34BialeXrlf+fOUr0o36dn2yOXfaUCC89KxVF24tYmRWlphMRuAktYT67PdL
         h9Qj2NTjQzgL237RIxE2T4K3iuERHnvrZe33TyJ1xQtAw2bj+GgLbitIZm+sNI64tuAF
         vnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ecn5HXaG6CuxgKYhfrIxBJS9FQn/XnfCS++lGW6CY8g=;
        b=GhCMmohE3OBUiUeGOQpt39cIEbxNIm5AKTiT6lJNqa//ZR/yJUPdSv/iWuQn3VPVYN
         ocbo+G34J+Mne3byRz13z2c3Ftl3ZhmzgkxF5dFVyhJ5ncIlZAR0Osm+KxiDfZeLmjDu
         HWeoxymU55SPrmTKf7QF/Y9n9TUbC1i531RBBxjf8BMw6mGKYvRNjOsZqGdGB/tnQEep
         WI4CDTvqqW9i6tpNQE3/5nUYSXNcyPFhB6izGwIn/KmD17dNSG0mmEvfA6dc9U4TJKi4
         WMbBl2v8e0NQwaKNll8CrTDQ7G3vr5Ljy7onoozJq3gaaN+eQuzNJTTvkjang7FUQB81
         KtjQ==
X-Gm-Message-State: APjAAAWjR8RMNMGqEWaWjraFOOVyxQq/2mM8+Y+1NCxlIvu6lh8LAQQP
        if2E5+uJv2sB552TR8sFwRUWjQ==
X-Google-Smtp-Source: APXvYqxsoME+YGmylVlQ5I4y0HfyqA6O7G0xmuAQuiJiMMD27w6OCVzTzXpPaD8+Y2X4r/y+75lQJw==
X-Received: by 2002:a17:902:e011:: with SMTP id ca17mr13414322plb.328.1561745115298;
        Fri, 28 Jun 2019 11:05:15 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id n184sm2780935pfn.21.2019.06.28.11.05.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:05:14 -0700 (PDT)
Date:   Fri, 28 Jun 2019 11:05:14 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
Message-ID: <20190628180514.GB24308@mini-arch>
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
> +}
> +
> +struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> +						int pfd)
> +{
> +	char errmsg[STRERR_BUFSIZE];
> +	struct bpf_link_fd *link;
> +	int bpf_fd, err;
nit: maybe prog_fd instead of bpf_fd? Should be more consistent with
other places in libbf:

$ grep -Iriw bpf_fd | wc -l
2
$ grep -Iriw prog_fd | wc -l
39

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
