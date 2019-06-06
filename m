Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1925637562
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfFFNip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:38:45 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39957 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFNio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:38:44 -0400
Received: by mail-qk1-f196.google.com with SMTP id c70so1426871qkg.7;
        Thu, 06 Jun 2019 06:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=trAiNHHguw+SHGFI0WIJdhNPJZ51oDisk40wuKdyvmU=;
        b=vHa4kjUvJnh6TEwOmtVpCGO4LsEuQXwm5fKHkwflbo3A5timtdFEXGDDmITiOe9crt
         zyWRONHudPdcXHLWhGt/CbLJlKIswAejg6Cpm1/zfjx3g1/iPYVF2QFBFd3tQI7iblis
         EzSjHGJNaTzwTphdMvFe3DoDgm/pzq2pAQvpRQKY3aa2dKpg/BcrLSsUPPg9Iz/Um7EB
         P0Yz2d7x2CB+oIy2rhcx19+nSIczxgbZggZRP8Z4h9Pm3eGgspZOHyZ/U4eC4sPnHRBX
         LIhygJYWqp4dDy7feSvYM1wipi5YVrmKpalKAJNo1Nk+5uZ0JLnucqmRafxZQaqsqlBG
         /QJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=trAiNHHguw+SHGFI0WIJdhNPJZ51oDisk40wuKdyvmU=;
        b=FyrZrGzfBM2McsS7zPwXM1plTNGH6u7ugbnB8mFt7CALSjaaphZ1LaJfDG25xnn1pw
         zRgfkOUBsc5o4ZIP6eLu2cmMAB/3avwpwZMGabZ5In1dNVmtojiGuxNvn4VWBAYSJwBb
         jENtRdW+SHbxauc+BySQWIBSad1KSsKO8ywHvhja4B64LEYAbUY6CnOaCPLmPVuijoIx
         y4+KYk8v76qF3AycNG5/7QI8fdPM+lPgtWbqYSSn3EiZevMGR/+4DHNdjxc3ZSjm9bUo
         sf3wTSdYF6P5DmYir4H2+lbqj+sy5nAhqA5FAELyAMNOHMIGNt9KprtVlGyHHbYFQ0Vw
         eUPQ==
X-Gm-Message-State: APjAAAXE21+z5/syrkcJ6q3jdHS60c7FH8sjakHDnqw4ZV3oGaVNgXJS
        jebShx+6wp1lUImPxB2Ksts=
X-Google-Smtp-Source: APXvYqwNYpcGINzZbp9tNCzgiOv6LVrx/6BJcmxzKvf7s6SzTOfvn4wTdFgp8W/HMNp7tU1tCl80Vw==
X-Received: by 2002:a37:b342:: with SMTP id c63mr39439096qkf.292.1559828323053;
        Thu, 06 Jun 2019 06:38:43 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.208.82])
        by smtp.gmail.com with ESMTPSA id e8sm924845qkn.95.2019.06.06.06.38.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 06:38:42 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8F18341149; Thu,  6 Jun 2019 10:38:38 -0300 (-03)
Date:   Thu, 6 Jun 2019 10:38:38 -0300
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 3/4] perf augmented_raw_syscalls: Support arm64 raw
 syscalls
Message-ID: <20190606133838.GC30166@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-4-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606094845.4800-4-leo.yan@linaro.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 06, 2019 at 05:48:44PM +0800, Leo Yan escreveu:
> This patch adds support for arm64 raw syscall numbers so that we can use
> it on arm64 platform.
> 
> After applied this patch, we need to specify macro -D__aarch64__ or
> -D__x86_64__ in compilation option so Clang can use the corresponding
> syscall numbers for arm64 or x86_64 respectively, other architectures
> will report failure when compilation.

So, please check what I have in my perf/core branch, I've completely
removed arch specific stuff from augmented_raw_syscalls.c.

What is done now is use a map to specify what to copy, that same map
that is used to state which syscalls should be traced.

It uses that tools/perf/arch/arm64/entry/syscalls/mksyscalltbl to figure
out the mapping of syscall names to ids, just like is done for x86_64
and other arches, falling back to audit-libs when that syscalltbl thing
is not present.

- Arnaldo
 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  .../examples/bpf/augmented_raw_syscalls.c     | 81 +++++++++++++++++++
>  1 file changed, 81 insertions(+)
> 
> diff --git a/tools/perf/examples/bpf/augmented_raw_syscalls.c b/tools/perf/examples/bpf/augmented_raw_syscalls.c
> index 5c4a4e715ae6..a3701a4daf2e 100644
> --- a/tools/perf/examples/bpf/augmented_raw_syscalls.c
> +++ b/tools/perf/examples/bpf/augmented_raw_syscalls.c
> @@ -45,6 +45,83 @@ struct augmented_filename {
>  	char		value[PATH_MAX];
>  };
>  
> +#if defined(__aarch64__)
> +
> +/* syscalls where the first arg is a string */
> +#define SYS_OPEN               1024
> +#define SYS_STAT               1038
> +#define SYS_LSTAT              1039
> +#define SYS_ACCESS             1033
> +#define SYS_EXECVE              221
> +#define SYS_TRUNCATE             45
> +#define SYS_CHDIR                49
> +#define SYS_RENAME             1034
> +#define SYS_MKDIR              1030
> +#define SYS_RMDIR              1031
> +#define SYS_CREAT              1064
> +#define SYS_LINK               1025
> +#define SYS_UNLINK             1026
> +#define SYS_SYMLINK            1036
> +#define SYS_READLINK           1035
> +#define SYS_CHMOD              1028
> +#define SYS_CHOWN              1029
> +#define SYS_LCHOWN             1032
> +#define SYS_MKNOD              1027
> +#define SYS_STATFS             1056
> +#define SYS_PIVOT_ROOT           41
> +#define SYS_CHROOT               51
> +#define SYS_ACCT                 89
> +#define SYS_SWAPON              224
> +#define SYS_SWAPOFF             225
> +#define SYS_DELETE_MODULE       106
> +#define SYS_SETXATTR              5
> +#define SYS_LSETXATTR             6
> +#define SYS_GETXATTR              8
> +#define SYS_LGETXATTR             9
> +#define SYS_LISTXATTR            11
> +#define SYS_LLISTXATTR           12
> +#define SYS_REMOVEXATTR          14
> +#define SYS_LREMOVEXATTR         15
> +#define SYS_MQ_OPEN             180
> +#define SYS_MQ_UNLINK           181
> +#define SYS_ADD_KEY             217
> +#define SYS_REQUEST_KEY         218
> +#define SYS_SYMLINKAT            36
> +#define SYS_MEMFD_CREATE        279
> +
> +/* syscalls where the second arg is a string */
> +#define SYS_PWRITE64             68
> +#define SYS_RENAME             1034
> +#define SYS_QUOTACTL             60
> +#define SYS_FSETXATTR             7
> +#define SYS_FGETXATTR            10
> +#define SYS_FREMOVEXATTR         16
> +#define SYS_MQ_TIMEDSEND        182
> +#define SYS_REQUEST_KEY         218
> +#define SYS_INOTIFY_ADD_WATCH    27
> +#define SYS_OPENAT               56
> +#define SYS_MKDIRAT              34
> +#define SYS_MKNODAT              33
> +#define SYS_FCHOWNAT             54
> +#define SYS_FUTIMESAT          1066
> +#define SYS_NEWFSTATAT         1054
> +#define SYS_UNLINKAT             35
> +#define SYS_RENAMEAT             38
> +#define SYS_LINKAT               37
> +#define SYS_READLINKAT           78
> +#define SYS_FCHMODAT             53
> +#define SYS_FACCESSAT            48
> +#define SYS_UTIMENSAT            88
> +#define SYS_NAME_TO_HANDLE_AT   264
> +#define SYS_FINIT_MODULE        273
> +#define SYS_RENAMEAT2           276
> +#define SYS_EXECVEAT            281
> +#define SYS_STATX               291
> +#define SYS_MOVE_MOUNT          429
> +#define SYS_FSPICK              433
> +
> +#elif defined(__x86_64__)
> +
>  /* syscalls where the first arg is a string */
>  #define SYS_OPEN                 2
>  #define SYS_STAT                 4
> @@ -119,6 +196,10 @@ struct augmented_filename {
>  #define SYS_MOVE_MOUNT         429
>  #define SYS_FSPICK             433
>  
> +#else
> +#error "unsupported architecture"
> +#endif
> +
>  pid_filter(pids_filtered);
>  
>  struct augmented_args_filename {
> -- 
> 2.17.1

-- 

- Arnaldo
