Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E03FCE8D6
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfJGQOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:14:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45498 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728552AbfJGQOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:14:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so8924713pfb.12
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 09:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=lhkQIICT57llAxJWjSnnycoopGn+onBA90k6Esl/Rro=;
        b=KRcsAxbx1gYJ42q1JsLHEpc5xrdNZptMMnOd0GkSxr39yEN0k/jFbCbpCIpXvEUfC4
         pjRzooTWgnM0A6PgI1zQd48EEUUiPiSb9r/JFps25hG+XWpIV68OZK/in2EcEz6Oto1D
         P9UR6+3qh4oMn4SI+EP309cx/VGc9xFBzsu33rztpmbCqA9+I+oNaZIQfHfLF+0mw1TT
         x0g5V6ysIxigXSylfw8HQ0fsuClEgdsxIkoynKekvUs2jxAU8+YOPwn08PAjQD/c9mKH
         tMkQAVvJIFYJK+D0pWtfvfs4s10sfgSrjAg+inTNUbMZZYLCCZ1CbTq3HEeaJKvTYIIL
         HLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=lhkQIICT57llAxJWjSnnycoopGn+onBA90k6Esl/Rro=;
        b=O8wlK03NFidrF2hqPFjWjppUi/hhcJC/Adzo5ziMXNBUIC32aFoD6JRnAgREtcisrO
         BQR6pkizDkeZ0KT5BgIZviq5tQ8yKGOQeIdPgZ3eWMWUWdEvoHZ+LSRoa/kqt9jdet+Y
         LgG6HSagPJ5fQr/6gCh9FFkFwRieBOlLvJIv+M7oU8K+lCRAT79PlRkDw5RTkHqr/Kf5
         rpQDKPc/feoTScokD2dKHgMVV8iNsmN6mQKYRfgVCkdWvYplfslpYncdaVpFrfYHI1nW
         KtRpvR4+1kHYKim0zex2iYWrK3TxZOb+L4WEtgutA/GMFezkFkMcpX4PS0zePIRNwUcd
         e8ew==
X-Gm-Message-State: APjAAAUA3daLeCoo4VAj7GPpRMHXuXISofaEDYq02QEzqdb8HLjXX2SS
        o8y/EzhjunUdsOcFOIxp32DPhg==
X-Google-Smtp-Source: APXvYqxyR4IxTbg0rbgEwFk0BZv670ApnbRMlWsmbCFd0fwwIVGbU5cZ6MY6Rc933NPHvZUNaC6SAw==
X-Received: by 2002:a17:90a:21a9:: with SMTP id q38mr66757pjc.23.1570464878972;
        Mon, 07 Oct 2019 09:14:38 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id bx18sm9676pjb.26.2019.10.07.09.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:14:38 -0700 (PDT)
Date:   Mon, 7 Oct 2019 09:14:37 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 1/4] libbpf: stop enforcing kern_version,
 populate it for users
Message-ID: <20191007161437.GB2096@mini-arch>
References: <20191004224037.1625049-1-andriin@fb.com>
 <20191004224037.1625049-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191004224037.1625049-2-andriin@fb.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/04, Andrii Nakryiko wrote:
> Kernel version enforcement for kprobes/kretprobes was removed from
> 5.0 kernel in 6c4fc209fcf9 ("bpf: remove useless version check for prog load").
> Since then, BPF programs were specifying SEC("version") just to please
> libbpf. We should stop enforcing this in libbpf, if even kernel doesn't
> care. Furthermore, libbpf now will pre-populate current kernel version
> of the host system, in case we are still running on old kernel.

[..]
> This patch also removes __bpf_object__open_xattr from libbpf.h, as
> nothing in libbpf is relying on having it in that header. That function
> was never exported as LIBBPF_API and even name suggests its internal
> version. So this should be safe to remove, as it doesn't break ABI.
This gives me the following (I don't know why bpftool was allowed to link
against non-LIBBPF_API exposed function):

+ make -s -j72 -C tools/bpf/bpftool

prog.c: In function ‘load_with_options’:
prog.c:1227:8: warning: implicit declaration of function ‘__bpf_object__open_xattr’; did you mean ‘bpf_object__open_xattr’? [-Wimplicit-function-declaration]
  obj = __bpf_object__open_xattr(&open_attr, bpf_flags);
        ^~~~~~~~~~~~~~~~~~~~~~~~
        bpf_object__open_xattr
prog.c:1227:8: warning: nested extern declaration of ‘__bpf_object__open_xattr’ [-Wnested-externs]   
prog.c:1227:6: warning: assignment to ‘struct bpf_object *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
  obj = __bpf_object__open_xattr(&open_attr, bpf_flags);
      ^

Warning: Kernel ABI header at 'tools/include/uapi/linux/if_link.h' differs from latest version at 'include/uapi/linux/if_link.h'
/usr/bin/ld: prog.o: in function `load_with_options':
prog.c:(.text+0x49b): undefined reference to `__bpf_object__open_xattr'
collect2: error: ld returned 1 exit statu

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c                        | 100 ++++--------------
>  tools/lib/bpf/libbpf.h                        |   2 -
>  .../selftests/bpf/progs/test_attach_probe.c   |   1 -
>  .../bpf/progs/test_get_stack_rawtp.c          |   1 -
>  .../selftests/bpf/progs/test_perf_buffer.c    |   1 -
>  .../selftests/bpf/progs/test_stacktrace_map.c |   1 -
>  6 files changed, 23 insertions(+), 83 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e0276520171b..024334b29b54 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -33,6 +33,7 @@
>  #include <linux/limits.h>
>  #include <linux/perf_event.h>
>  #include <linux/ring_buffer.h>
> +#include <linux/version.h>
>  #include <sys/epoll.h>
>  #include <sys/ioctl.h>
>  #include <sys/mman.h>
> @@ -255,7 +256,7 @@ struct bpf_object {
>  	 */
>  	struct {
>  		int fd;
> -		void *obj_buf;
> +		const void *obj_buf;
>  		size_t obj_buf_sz;
>  		Elf *elf;
>  		GElf_Ehdr ehdr;
> @@ -491,8 +492,19 @@ bpf_object__init_prog_names(struct bpf_object *obj)
>  	return 0;
>  }
>  
> +static __u32 get_kernel_version(void)
> +{
> +	__u32 major, minor, patch;
> +	struct utsname info;
> +
> +	uname(&info);
> +	if (sscanf(info.release, "%u.%u.%u", &major, &minor, &patch) != 3)
> +		return 0;
> +	return KERNEL_VERSION(major, minor, patch);
> +}
> +
>  static struct bpf_object *bpf_object__new(const char *path,
> -					  void *obj_buf,
> +					  const void *obj_buf,
>  					  size_t obj_buf_sz)
>  {
>  	struct bpf_object *obj;
> @@ -526,6 +538,7 @@ static struct bpf_object *bpf_object__new(const char *path,
>  	obj->efile.rodata_shndx = -1;
>  	obj->efile.bss_shndx = -1;
>  
> +	obj->kern_version = get_kernel_version();
>  	obj->loaded = false;
>  
>  	INIT_LIST_HEAD(&obj->list);
> @@ -569,7 +582,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
>  		 * obj_buf should have been validated by
>  		 * bpf_object__open_buffer().
>  		 */
> -		obj->efile.elf = elf_memory(obj->efile.obj_buf,
> +		obj->efile.elf = elf_memory((char *)obj->efile.obj_buf,
>  					    obj->efile.obj_buf_sz);
>  	} else {
>  		obj->efile.fd = open(obj->path, O_RDONLY);
> @@ -636,21 +649,6 @@ bpf_object__init_license(struct bpf_object *obj, void *data, size_t size)
>  	return 0;
>  }
>  
> -static int
> -bpf_object__init_kversion(struct bpf_object *obj, void *data, size_t size)
> -{
> -	__u32 kver;
> -
> -	if (size != sizeof(kver)) {
> -		pr_warning("invalid kver section in %s\n", obj->path);
> -		return -LIBBPF_ERRNO__FORMAT;
> -	}
> -	memcpy(&kver, data, sizeof(kver));
> -	obj->kern_version = kver;
> -	pr_debug("kernel version of %s is %x\n", obj->path, obj->kern_version);
> -	return 0;
> -}
> -
>  static int compare_bpf_map(const void *_a, const void *_b)
>  {
>  	const struct bpf_map *a = _a;
> @@ -1568,11 +1566,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>  			if (err)
>  				return err;
>  		} else if (strcmp(name, "version") == 0) {
> -			err = bpf_object__init_kversion(obj,
> -							data->d_buf,
> -							data->d_size);
> -			if (err)
> -				return err;
> +			/* skip, we don't need it anymore */
>  		} else if (strcmp(name, "maps") == 0) {
>  			obj->efile.maps_shndx = idx;
>  		} else if (strcmp(name, MAPS_ELF_SEC) == 0) {
> @@ -3551,54 +3545,9 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>  	return 0;
>  }
>  
> -static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
> -{
> -	switch (type) {
> -	case BPF_PROG_TYPE_SOCKET_FILTER:
> -	case BPF_PROG_TYPE_SCHED_CLS:
> -	case BPF_PROG_TYPE_SCHED_ACT:
> -	case BPF_PROG_TYPE_XDP:
> -	case BPF_PROG_TYPE_CGROUP_SKB:
> -	case BPF_PROG_TYPE_CGROUP_SOCK:
> -	case BPF_PROG_TYPE_LWT_IN:
> -	case BPF_PROG_TYPE_LWT_OUT:
> -	case BPF_PROG_TYPE_LWT_XMIT:
> -	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
> -	case BPF_PROG_TYPE_SOCK_OPS:
> -	case BPF_PROG_TYPE_SK_SKB:
> -	case BPF_PROG_TYPE_CGROUP_DEVICE:
> -	case BPF_PROG_TYPE_SK_MSG:
> -	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> -	case BPF_PROG_TYPE_LIRC_MODE2:
> -	case BPF_PROG_TYPE_SK_REUSEPORT:
> -	case BPF_PROG_TYPE_FLOW_DISSECTOR:
> -	case BPF_PROG_TYPE_UNSPEC:
> -	case BPF_PROG_TYPE_TRACEPOINT:
> -	case BPF_PROG_TYPE_RAW_TRACEPOINT:
> -	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
> -	case BPF_PROG_TYPE_PERF_EVENT:
> -	case BPF_PROG_TYPE_CGROUP_SYSCTL:
> -	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> -		return false;
> -	case BPF_PROG_TYPE_KPROBE:
> -	default:
> -		return true;
> -	}
> -}
> -
> -static int bpf_object__validate(struct bpf_object *obj, bool needs_kver)
> -{
> -	if (needs_kver && obj->kern_version == 0) {
> -		pr_warning("%s doesn't provide kernel version\n",
> -			   obj->path);
> -		return -LIBBPF_ERRNO__KVERSION;
> -	}
> -	return 0;
> -}
> -
>  static struct bpf_object *
> -__bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
> -		   bool needs_kver, int flags)
> +__bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
> +		   int flags)
>  {
>  	struct bpf_object *obj;
>  	int err;
> @@ -3617,7 +3566,6 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
>  	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
>  	CHECK_ERR(bpf_object__elf_collect(obj, flags), err, out);
>  	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
> -	CHECK_ERR(bpf_object__validate(obj, needs_kver), err, out);
>  
>  	bpf_object__elf_finish(obj);
>  	return obj;
> @@ -3626,8 +3574,8 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
>  	return ERR_PTR(err);
>  }
>  
> -struct bpf_object *__bpf_object__open_xattr(struct bpf_object_open_attr *attr,
> -					    int flags)
> +static struct bpf_object *
> +__bpf_object__open_xattr(struct bpf_object_open_attr *attr, int flags)
>  {
>  	/* param validation */
>  	if (!attr->file)
> @@ -3635,9 +3583,7 @@ struct bpf_object *__bpf_object__open_xattr(struct bpf_object_open_attr *attr,
>  
>  	pr_debug("loading %s\n", attr->file);
>  
> -	return __bpf_object__open(attr->file, NULL, 0,
> -				  bpf_prog_type__needs_kver(attr->prog_type),
> -				  flags);
> +	return __bpf_object__open(attr->file, NULL, 0, flags);
>  }
>  
>  struct bpf_object *bpf_object__open_xattr(struct bpf_object_open_attr *attr)
> @@ -3673,7 +3619,7 @@ struct bpf_object *bpf_object__open_buffer(void *obj_buf,
>  	}
>  	pr_debug("loading object '%s' from buffer\n", name);
>  
> -	return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true);
> +	return __bpf_object__open(name, obj_buf, obj_buf_sz, true);
>  }
>  
>  int bpf_object__unload(struct bpf_object *obj)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index e8f70977d137..2905dffd70b2 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -70,8 +70,6 @@ struct bpf_object_open_attr {
>  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>  LIBBPF_API struct bpf_object *
>  bpf_object__open_xattr(struct bpf_object_open_attr *attr);
> -struct bpf_object *__bpf_object__open_xattr(struct bpf_object_open_attr *attr,
> -					    int flags);
>  LIBBPF_API struct bpf_object *bpf_object__open_buffer(void *obj_buf,
>  						      size_t obj_buf_sz,
>  						      const char *name);
> diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> index 63a8dfef893b..534621e38906 100644
> --- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
> +++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> @@ -49,4 +49,3 @@ int handle_uprobe_return(struct pt_regs *ctx)
>  }
>  
>  char _license[] SEC("license") = "GPL";
> -__u32 _version SEC("version") = 1;
> diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> index f8ffa3f3d44b..736b6955bba7 100644
> --- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> +++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> @@ -100,4 +100,3 @@ int bpf_prog1(void *ctx)
>  }
>  
>  char _license[] SEC("license") = "GPL";
> -__u32 _version SEC("version") = 1; /* ignored by tracepoints, required by libbpf.a */
> diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
> index 876c27deb65a..07c09ca5546a 100644
> --- a/tools/testing/selftests/bpf/progs/test_perf_buffer.c
> +++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
> @@ -22,4 +22,3 @@ int handle_sys_nanosleep_entry(struct pt_regs *ctx)
>  }
>  
>  char _license[] SEC("license") = "GPL";
> -__u32 _version SEC("version") = 1;
> diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> index fa0be3e10a10..3b7e1dca8829 100644
> --- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> +++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> @@ -74,4 +74,3 @@ int oncpu(struct sched_switch_args *ctx)
>  }
>  
>  char _license[] SEC("license") = "GPL";
> -__u32 _version SEC("version") = 1; /* ignored by tracepoints, required by libbpf.a */
> -- 
> 2.17.1
> 
