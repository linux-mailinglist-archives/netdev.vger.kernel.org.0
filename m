Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0597F5A035
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfF1QEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:04:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38693 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfF1QEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:04:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id z75so2784096pgz.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 09:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ej8QVKf/5ZTp8F2SHWsH8VnKFdML06Uqo03duPLklpc=;
        b=AUPotkinOm43N5H/gahaeOa/ZfSD/qRznui6WEjHoGdqR1DVX7w1eJ5okgBc67YhJC
         Rl72gAYHdRGRApSik5Ndjugys8OXk0OmyEdDLM2j7VcqrfcenKXclGkIhHJf1hrJyxGT
         GrJMfd630CalysOnGL9dY6FD2MNnxQsdXElNqcFQdkz2AmDDfZgrI/RjH2GcEGkgCCbl
         7a/kooFpC+psmoHRJhnSlZNDkE3D0bSqOZurRXTCbOL94D8bmGBIIDT1yddkCQHrkESN
         uY4yR1HaIf7Ep9yCEfV1WLX3iYsGKPyCjEXbAmNKQrxF84kEsXwdT8l9UIHl0HyImx7F
         F8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ej8QVKf/5ZTp8F2SHWsH8VnKFdML06Uqo03duPLklpc=;
        b=RHfYWkMfGIVjdji1GUkGm2K1PnQP59yurp2siDQpL7/q1Pp4bAoR1VHkD9ECTs/G94
         Cda2elOXDJ6eiOoDpQHysNfv6+blILT/4110SrU7wHKXRrR9TwLE0eYm/HYUtxcqB6uA
         wwOqPS0HMyw5ksrj51fvgTjdw2ZUQv8C363DUPFvUw70HlWkAGReGl76xsNktygadAch
         2dqgTol04mtm+dLRTYp+aYAqoxZpicb/9mrKO1MDZtbNeLTk/qp0aas1SWAlS54ZrTgT
         bCPMumZxNsmUtdDPmRoHnBtT9IRvZkfLPV58JIpm4r8mw0Nfcg0S141LR9NpgyzTETM4
         i/rg==
X-Gm-Message-State: APjAAAVkMGqdgiK1ti4/TTpGTi+jweoPGhcI0eTjTE1jL8C7to4q8z2+
        NIxN37oAR6wD86CahXPCBwqg3tTH8FM=
X-Google-Smtp-Source: APXvYqzK9vlhFLJNP1OkFzCru9OvkgzJ1gNv0Lxizz1Nb0+9eYCDr7iROwBIp48kLR08iTPB6Z4p2g==
X-Received: by 2002:a17:90a:ac11:: with SMTP id o17mr14297916pjq.134.1561737878313;
        Fri, 28 Jun 2019 09:04:38 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id n2sm2246918pgp.27.2019.06.28.09.04.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 09:04:37 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:04:36 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
Message-ID: <20190628160436.GH4866@mini-arch>
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
[..]
> +	int fd; /* hook FD */
> +};
Any cons to storing everything in bpf_link, instead of creating a
"subclass"? Less things to worry about.

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
