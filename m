Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78E44DDF9
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfFUABn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:01:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33144 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfFUABm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:01:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so2064492plo.0
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6cpwnTEwuXiMTyKTCTme69+IwlGMeQfavdRu2nlMK6I=;
        b=mFv14T5inRn9+esUmOCWr95xruJZ/OiXgzYUFvpFsPogGsPZUEBmUc5h1U9XBu+Gpf
         gOfbGdyVNZUrx8pSE6AW/YGSpPAO7EAMLxDCOmWRy0ZErMgWb0ZBP8ig0up/bvYXAv8i
         Hw62M+JwP+yBKISlCiXY5xcIzOSwuoZD8gL6WLZxu/1JwbR2/nA++ipGOH5nS/Ec8mkA
         nDSYHpu2IiiANzpZWqyECMc6YdgGhgjQ0QNNSDvZev4uSg6asTO3qugNI2l/N20KC5E/
         WCNYrnQHejbDR3n1A4NU6uITGujIIR0AOsk+kXecMsdfaD1Qvp+dEy3kOR1uqxEtS2CJ
         A59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6cpwnTEwuXiMTyKTCTme69+IwlGMeQfavdRu2nlMK6I=;
        b=ePWMSz7ZLSdxHM71k6UOhNJnxgK8NmIKSU8dsJVD0KdkvfTK6cXnglNGdtVp4BGHlQ
         OsNeuOYv7dTTUFnEbNQ9COceYQ/N7XZfqysNJ1Y2EsgVtpMEsWmPhnym/ydjW/0Gz+Pk
         o6MC7ai8iMVyv2IVJ5gPKpobZwzPAvh5pWAxuNpyn5xlsxgYiArxW1UCp/zkYe9pwqdU
         vwVVJLMCUoMyTwdt1IpINKevZmqSKx+cR9Du4G9hkkeF2+9vOzSgRdjdaoGcnmoe6aVq
         sNmXL6GoRz9sO+5+0IGC9pz4k6a9gXbQ5vZ9lNHEceB9ikth/Diy3MTutuduGcFV0Zr+
         l3vg==
X-Gm-Message-State: APjAAAVwfQP9JIEIsofwwxXclHmvTLvmaTouGEil/VMIC7nPfZfeo75d
        RXAXfM3q+NXvApMS/vEnQBwdnw==
X-Google-Smtp-Source: APXvYqyaJYgQ0muDFHefCa97k1wbroJn6xRpzW1eht1eRHUsMTX1BshlYCmRO5Q+Ztf+dCwxf9iDvA==
X-Received: by 2002:a17:902:7249:: with SMTP id c9mr22053378pll.25.1561075301685;
        Thu, 20 Jun 2019 17:01:41 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id f7sm580476pfd.43.2019.06.20.17.01.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:01:41 -0700 (PDT)
Date:   Thu, 20 Jun 2019 17:01:40 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/7] libbpf: add ability to attach/detach BPF to
 perf event
Message-ID: <20190621000140.GA1383@mini-arch>
References: <20190620230951.3155955-1-andriin@fb.com>
 <20190620230951.3155955-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620230951.3155955-3-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/20, Andrii Nakryiko wrote:
> bpf_program__attach_perf_event allows to attach BPF program to existing
> perf event, providing most generic and most low-level way to attach BPF
> programs.
> 
> libbpf_perf_event_disable_and_close API is added to disable and close
> existing perf event by its FD.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 41 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |  4 ++++
>  tools/lib/bpf/libbpf.map |  2 ++
>  3 files changed, 47 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8ce3beba8551..2bb1fa008be3 100644
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
> @@ -3928,6 +3929,46 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
>  	return 0;
>  }
>  
[..]
> +int libbpf_perf_event_disable_and_close(int pfd)
nit: why not call it libbpf_perf_event_detach[_and_close]?
It's usually attach/detach.

> +{
> +	int err;
> +
> +	if (pfd < 0)
> +		return 0;
> +
> +	err = ioctl(pfd, PERF_EVENT_IOC_DISABLE, 0);
> +	close(pfd);
> +	return err;
> +}
> +
> +int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
> +{
> +	char errmsg[STRERR_BUFSIZE];
> +	int bpf_fd, err;
> +
> +	bpf_fd = bpf_program__fd(prog);
> +	if (bpf_fd < 0) {
> +		pr_warning("program '%s': can't attach before loaded\n",
> +			   bpf_program__title(prog, false));
> +		return -EINVAL;
> +	}
> +	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, bpf_fd) < 0) {
> +		err = -errno;
> +		pr_warning("program '%s': failed to attach to pfd %d: %s\n",
> +			   bpf_program__title(prog, false), pfd,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return err;
> +	}
> +	if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
> +		err = -errno;
> +		pr_warning("program '%s': failed to enable pfd %d: %s\n",
> +			   bpf_program__title(prog, false), pfd,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return err;
> +	}
> +	return 0;
> +}
> +
>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>  			   void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index d639f47e3110..76db1bbc0dac 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -165,6 +165,10 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
>  LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
>  LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
>  
> +LIBBPF_API int libbpf_perf_event_disable_and_close(int pfd);
> +LIBBPF_API int bpf_program__attach_perf_event(struct bpf_program *prog,
> +					      int pfd);
> +
>  struct bpf_insn;
>  
>  /*
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 2c6d835620d2..d27406982b5a 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -172,5 +172,7 @@ LIBBPF_0.0.4 {
>  		btf_dump__new;
>  		btf__parse_elf;
>  		bpf_object__load_xattr;
> +		bpf_program__attach_perf_event;
>  		libbpf_num_possible_cpus;
> +		libbpf_perf_event_disable_and_close;
>  } LIBBPF_0.0.3;
> -- 
> 2.17.1
> 
