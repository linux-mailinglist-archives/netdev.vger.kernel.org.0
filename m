Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BCB486FB
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfFQPYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:24:18 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34335 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfFQPYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 11:24:17 -0400
Received: by mail-qt1-f194.google.com with SMTP id m29so11192252qtu.1;
        Mon, 17 Jun 2019 08:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dvejiB9VUdnTPtOXDs7aVYV8twbZKoZz54ycXSwgD5I=;
        b=cOMCwmFMd9laWcGZmZ5ox6a0vfIC+J1AndUclQ2kSdRc/Rai0dAolxRHWiJC2s2VRx
         rHPSmWvlAQ2gBbZ0B1nzqN3kagB9mCSHkHpw2vFVi0MvhyKJyYYytUyeJ1bRIk83KzbA
         SL7FmHj0leQ3yjHL18/k/NLyd+3yh9TaqdhSwgwq7Nq5Qx1TtLwWAnxsGoWj5rTKpun8
         J4qOAiYXhOv1lWm6vhdM+C/A/FSemKEHwCDmLSTTkh6xQamoz01bwyqRMDziow0gzpv5
         sNw8Sn1TITucv1a5SYlvCMRHNs5RHk5d03ub9UKQeflOGObgj3SVoGGOGBR+ndmgNVh9
         +7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dvejiB9VUdnTPtOXDs7aVYV8twbZKoZz54ycXSwgD5I=;
        b=S3kmg/QTmp9FI/+B4vBU+ms/2qC7AGI7ZxlKSHPtjAcoxe8Dfh5CA1ILONiSV2vgXZ
         M3T5pTblDUwETzlOEEcrTDVfBzuMen+dVr9XQrptK5UKceyRhrboC3ohFHdMLtTYpGCO
         gewBafp3+ydhEczRDPQbog4EFAOrI1Gjvh+JfnwZIFMqhs+RMoH663GEtTAYmHLOEpnI
         h6QSroUxm4V0Ah8Zbl76Od+sHWrHhXAcuj1t/7XSxRqfPLzQy9BRCTR7wmwbnX6ihra8
         kSvH1rxED/h8Q3dIuah7BW6ueliYyRVupo1YKfASA1OixhgTHMkEthsIfLGue8skY/Sa
         ZHDA==
X-Gm-Message-State: APjAAAWwwj7ZdCAa9RcCqeFEmaYNiz/xXdBlXtetUsCZ5/UxOZeZ3C8V
        PBbzzKjTy5unCVxlt2xvzYfe7IuX
X-Google-Smtp-Source: APXvYqx6vNUYxC9DThQHIOlkFIgLC1nuP4uGTY8kt6h64JvpiJNP/WNxnuiIyRLJ6wqw/8rBa1X0Fw==
X-Received: by 2002:a0c:d237:: with SMTP id m52mr21151256qvh.160.1560785056738;
        Mon, 17 Jun 2019 08:24:16 -0700 (PDT)
Received: from quaco.ghostprotocols.net (179-240-145-61.3g.claro.net.br. [179.240.145.61])
        by smtp.gmail.com with ESMTPSA id p64sm7018987qkf.60.2019.06.17.08.24.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 08:24:16 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C555C41149; Mon, 17 Jun 2019 12:24:12 -0300 (-03)
Date:   Mon, 17 Jun 2019 12:24:12 -0300
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] perf trace: Use pr_debug() instead of fprintf() for
 logging
Message-ID: <20190617152412.GJ1402@kernel.org>
References: <20190617091140.24372-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617091140.24372-1-leo.yan@linaro.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Jun 17, 2019 at 05:11:39PM +0800, Leo Yan escreveu:
> In the function trace__syscall_info(), it explicitly checks verbose
> level and print out log with fprintf().  Actually, we can use
> pr_debug() to do the same thing for debug logging.
> 
> This patch uses pr_debug() instead of fprintf() for debug logging; it
> includes a minor fixing for 'space before tab in indent', which
> dismisses git warning when apply it.

But those are not fprintf(stdout,), they explicitely redirect to the
output file that the user may have specified using 'perf trace --output
filename.trace' :-)

- Arnaldo
 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/perf/builtin-trace.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index bd1f00e7a2eb..5cd74651db4c 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1760,12 +1760,11 @@ static struct syscall *trace__syscall_info(struct trace *trace,
>  		 * grep "NR -1 " /t/trace_pipe
>  		 *
>  		 * After generating some load on the machine.
> - 		 */
> -		if (verbose > 1) {
> -			static u64 n;
> -			fprintf(trace->output, "Invalid syscall %d id, skipping (%s, %" PRIu64 ") ...\n",
> -				id, perf_evsel__name(evsel), ++n);
> -		}
> +		 */
> +		static u64 n;
> +
> +		pr_debug("Invalid syscall %d id, skipping (%s, %" PRIu64 ")\n",
> +			 id, perf_evsel__name(evsel), ++n);
>  		return NULL;
>  	}
>  
> @@ -1779,12 +1778,10 @@ static struct syscall *trace__syscall_info(struct trace *trace,
>  	return &trace->syscalls.table[id];
>  
>  out_cant_read:
> -	if (verbose > 0) {
> -		fprintf(trace->output, "Problems reading syscall %d", id);
> -		if (id <= trace->syscalls.max && trace->syscalls.table[id].name != NULL)
> -			fprintf(trace->output, "(%s)", trace->syscalls.table[id].name);
> -		fputs(" information\n", trace->output);
> -	}
> +	pr_debug("Problems reading syscall %d", id);
> +	if (id <= trace->syscalls.max && trace->syscalls.table[id].name != NULL)
> +		pr_debug("(%s)", trace->syscalls.table[id].name);
> +	pr_debug(" information\n");
>  	return NULL;
>  }
>  
> -- 
> 2.17.1

-- 

- Arnaldo
