Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3650C39462
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfFGSdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:33:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44473 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730870AbfFGSdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:33:00 -0400
Received: by mail-qt1-f193.google.com with SMTP id x47so3387697qtk.11;
        Fri, 07 Jun 2019 11:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5GYL4fUKk00yP4HXvUNZ6Fi+8Ufg5Y3SKrb4tcTkGv4=;
        b=Er9Haffn8ymi5u7v6whd1+YGF4s/uaDHMom/eLld0djCyg42kKyXN4TEC/UE2hHkG+
         JC1MdoWB4bISksLxecXalDGdIMlo62BwnGRPNB9peeXKNcA1MUNrzw36J015vMEaa0uD
         RWJPYcnze0Zh1hxLeHvCHxrkL3AO1M5P83Y2jysQSfFELXvWLJ4LPCh2ZzXAyJlPqDwL
         PMoWEfi7ADRLzSzpB/2HZtnXZktZXZ6EEI+Kp5vkQG6eE9x4atGjGC0R8utDlDzIyqT0
         oe5ZoIG4RfMmeeObNUScT5vRb/4haAEq84Wo3vihCdxEmWeqZSV46x47jHHjFRqlcYxl
         b6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5GYL4fUKk00yP4HXvUNZ6Fi+8Ufg5Y3SKrb4tcTkGv4=;
        b=W5atWO0rx+EZ6knUYsYfjDk2kzI02aFbb2UXhmUU3GRuiLXZ2nfUbVA273DtYGtV5y
         REjzfpJSfn3KRGXuzcDZ0qS3g8+hQRfRsQhzOhwPnPrzvm25GdsqgBim41A6Lf70q/ZA
         H5jk8qVcEPNOVXaSUJ3m75yBJ23rWEiGytu0Oed6PrvCG7i56Gup/R2Z2gmXQCjXnJ2F
         DXGkWbdUsbptm9wMzC/yJ0RKbkrvojqhzj4rf5FcLuk58ArIDXzmQnNuHIgtSoUo94n9
         R4eu8EIrljc7R3UxmFa7KuBjqimEaVY29eTi7mfll3X7PsCtDlHHqPByDwANEzOMsZ/P
         2G7Q==
X-Gm-Message-State: APjAAAVIVI0XpRrLrXVLtGiu5Nfy+yN46ilfpMBK8aOdrg/8K3L0zTKS
        54v/OW6f3kTdD7Cj18Wb8bk=
X-Google-Smtp-Source: APXvYqz70lCRh739won9H5qXaTU9fvSzxLj46nPTcb4qmQOkP9x5eHZsfgZiCIQP/4l7xDriedsOJA==
X-Received: by 2002:a0c:ae31:: with SMTP id y46mr14635450qvc.172.1559932379563;
        Fri, 07 Jun 2019 11:32:59 -0700 (PDT)
Received: from quaco.ghostprotocols.net (187-26-97-17.3g.claro.net.br. [187.26.97.17])
        by smtp.gmail.com with ESMTPSA id p13sm1340288qkj.4.2019.06.07.11.32.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 11:32:58 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0776F41149; Fri,  7 Jun 2019 15:32:55 -0300 (-03)
Date:   Fri, 7 Jun 2019 15:32:54 -0300
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andi Kleen <ak@linux.intel.com>, Mark Drayton <mbd@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf config: Update default value for
 llvm.clang-bpf-cmd-template
Message-ID: <20190607183254.GM21245@kernel.org>
References: <20190607143508.18141-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607143508.18141-1-leo.yan@linaro.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jun 07, 2019 at 10:35:08PM +0800, Leo Yan escreveu:
> The clang bpf cmdline template has defined default value in the file
> tools/perf/util/llvm-utils.c, which has been changed for several times.
> 
> This patch updates the documentation to reflect the latest default value
> for the configuration llvm.clang-bpf-cmd-template.
> 
> Fixes: d35b168c3dcd ("perf bpf: Give precedence to bpf header dir")
> Fixes: cb76371441d0 ("perf llvm: Allow passing options to llc in addition to clang")
> Fixes: 1b16fffa389d ("perf llvm-utils: Add bpf include path to clang command line")

Well done! Three fixes! :-)

Who was it that made the changes and forgot to update the docs... oops,
it was me 8-)

Thanks, applied.

- Arnaldo


> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/perf/Documentation/perf-config.txt | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-config.txt b/tools/perf/Documentation/perf-config.txt
> index 462b3cde0675..e4aa268d2e38 100644
> --- a/tools/perf/Documentation/perf-config.txt
> +++ b/tools/perf/Documentation/perf-config.txt
> @@ -564,9 +564,12 @@ llvm.*::
>  	llvm.clang-bpf-cmd-template::
>  		Cmdline template. Below lines show its default value. Environment
>  		variable is used to pass options.
> -		"$CLANG_EXEC -D__KERNEL__ $CLANG_OPTIONS $KERNEL_INC_OPTIONS \
> -		-Wno-unused-value -Wno-pointer-sign -working-directory \
> -		$WORKING_DIR  -c $CLANG_SOURCE -target bpf -O2 -o -"
> +		"$CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS "\
> +		"-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "	\
> +		"$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
> +		"-Wno-unused-value -Wno-pointer-sign "		\
> +		"-working-directory $WORKING_DIR "		\
> +		"-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
>  
>  	llvm.clang-opt::
>  		Options passed to clang.
> -- 
> 2.17.1

-- 

- Arnaldo
