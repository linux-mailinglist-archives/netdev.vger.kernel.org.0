Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94A637608
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfFFOIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:08:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43243 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfFFOIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:08:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id z24so2736083qtj.10;
        Thu, 06 Jun 2019 07:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CmErKybZK9oamn84qU6DwZUq6+OBsy6EtQxggq/g/80=;
        b=AiEYYW3XqpeoY5c0wV5Uyhnr/E8rmKlWZkSHRIYSzqor2bNuEjoMvI1vc1IfNzSVEn
         Cr+bZX7+ddkuGZe+Nvkb33xwLlAJe6OoZxCOduU7WVA3UiW0C4RJJYiY21bi3+vfY7dD
         Wct+qDw1b35oT4V9nDXfbdeQ4gAO664ICNBMfJ4/2tAOmgucTUtLWtFOBOCTzXeOSVUQ
         okgR/JTF+jOl61auvY67c4TxbHbTwgbcjGlb/1DNY1kjLImNYiukcHdL7jBbCy/VnJ/3
         8klm0nkfkC6D2ievFwtyJz27RusClnI/CNosB/eZNKMPeZr7/5oe8mrhIiW1/vtY3yif
         nrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CmErKybZK9oamn84qU6DwZUq6+OBsy6EtQxggq/g/80=;
        b=uHMp0tNMlkRtoGmOLse8FPNFWss5/1QhudQNrWIktw7gTzAL2pdlgPtVRcxX9DpH7M
         0cMfCyLzHYif1Zi+/RTNmPVW6WTiPTjONPqlLvZttUxk+qH27Ma8LM+pXhcntPnyUn8G
         jKaGvOg/SS46yLheKx6phxErmYlbZC8k0/8vdvTolBTAzXOtzW6cRVQHIe+4ZKskJyBB
         D+NbSzunFAYpE9w2fV3PEnsXSe5g7Jr8GlID2+BCrIJp3AQicIqyVdQhIvuXRbw5cZNO
         EJdss+qOX01F0KSDDKQp5oQFaboMvt9Bil/ZLJN1/5iSz/OCI/PeaATPclDW1gQtPp4a
         qm0g==
X-Gm-Message-State: APjAAAV3noZugDjiQP8JuOLSE4I/gqjPYq4ehvVz7iy1C/8dNfd1JYiK
        RNVSfd3iR6c4uUBGWtiwRL4=
X-Google-Smtp-Source: APXvYqzzqmlkakAjxHCVTu0Z0wyhGrmJNvOWFfbpd5tKkeeJkYjkjJfEQ1KaXqjVSRA81tO7M7Q7gw==
X-Received: by 2002:ac8:2535:: with SMTP id 50mr2545452qtm.373.1559830085068;
        Thu, 06 Jun 2019 07:08:05 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.208.82])
        by smtp.gmail.com with ESMTPSA id n188sm901808qkc.74.2019.06.06.07.08.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 07:08:04 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id BD44841149; Thu,  6 Jun 2019 11:08:00 -0300 (-03)
Date:   Thu, 6 Jun 2019 11:08:00 -0300
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
Subject: Re: [PATCH v2 4/4] perf augmented_raw_syscalls: Document clang
 configuration
Message-ID: <20190606140800.GF30166@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-5-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606094845.4800-5-leo.yan@linaro.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 06, 2019 at 05:48:45PM +0800, Leo Yan escreveu:
> To build this program successfully with clang, there have three
> compiler options need to be specified:
> 
>   - Header file path: tools/perf/include/bpf;
>   - Specify architecture;
>   - Define macro __NR_CPUS__.

So, this shouldn't be needed, all of this is supposed to be done
automagically, have you done a 'make -C tools/perf install'?

- Arnaldo
 
> This patch add comments to explain the reasons for building failure and
> give two examples for llvm.clang-opt variable, one is for x86_64
> architecture and another is for aarch64 architecture.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  .../examples/bpf/augmented_raw_syscalls.c     | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tools/perf/examples/bpf/augmented_raw_syscalls.c b/tools/perf/examples/bpf/augmented_raw_syscalls.c
> index a3701a4daf2e..fb6987edab2c 100644
> --- a/tools/perf/examples/bpf/augmented_raw_syscalls.c
> +++ b/tools/perf/examples/bpf/augmented_raw_syscalls.c
> @@ -6,6 +6,25 @@
>   *
>   * perf trace -e tools/perf/examples/bpf/augmented_raw_syscalls.c cat /etc/passwd > /dev/null
>   *
> + * This program include two header files 'unistd.h' and 'pid_filter.h', which
> + * are placed in the folder tools/perf/include/bpf, but this folder is not
> + * included in env $KERNEL_INC_OPTIONS and it leads to compilation failure.
> + * For building this code, we also need to specify architecture and define macro
> + * __NR_CPUS__.  To resolve these issues, variable llvm.clang-opt can be set in
> + * the file ~/.perfconfig:
> + *
> + * E.g. Test on a platform with 8 CPUs with x86_64 architecture:
> + *
> + *   [llvm]
> + *		clang-opt = "-D__NR_CPUS__=8 -D__x86_64__ \
> + *			     -I./tools/perf/include/bpf"
> + *
> + * E.g. Test on a platform with 5 CPUs with aarch64 architecture:
> + *
> + *   [llvm]
> + *		clang-opt = "-D__NR_CPUS__=5 -D__aarch64__ \
> + *			     -I./tools/perf/include/bpf"
> +
>   * This exactly matches what is marshalled into the raw_syscall:sys_enter
>   * payload expected by the 'perf trace' beautifiers.
>   *
> -- 
> 2.17.1

-- 

- Arnaldo
