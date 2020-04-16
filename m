Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D361ACD95
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 18:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410750AbgDPQXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 12:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729633AbgDPQXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 12:23:13 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0C0C061A0C;
        Thu, 16 Apr 2020 09:23:13 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 20so13835245qkl.10;
        Thu, 16 Apr 2020 09:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zyCDv7z5P0ha1HmRsnaqPPghx3RwbCflcoKCK45AcNQ=;
        b=J52186us0PCS+Cz5RZA6O1mgs7unxz8luOWtHeEVsVCLVREwEDlIrfHaKZtURXKodV
         urpmXfWvnimP59fPHugAPdEkZTxtlAVSbB7ecb8pq5VmzOkGpbM/CLn1a92wDTczam19
         arxKY9C6PJzYJeFj9YmPiL/rAYlzCKtAvXt/FY7RaFCkkelB+6bhcWwQzNT9XZ81ZJQ8
         HVTqzf52Vu+6+nQOrZm5gMHc4KtdUL2772KVcy6PkLZtHJvKwQYYQ5o3l5X4rQnQtZy1
         oz4VhpBsCu3nR7f2sqXZS/LLg4OpnNItIx8d3lmVUlkKIx9+tX98dB4X1+VQPC/wK4TE
         AUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zyCDv7z5P0ha1HmRsnaqPPghx3RwbCflcoKCK45AcNQ=;
        b=MZ7LWV5sxmHVGWjYSwaIRhRreQzXGFQjF6RVI7CW50dI8oS2a36geYLio5cBSB/6Ao
         LFBOPcbTTlnjqu2me62I8ityzjWExv0fYV9ZQ1GTRazmwmPaMVQuhnHI5aam9MjgEuoc
         2z61IAnwTK7bGhm7apW5rpBJM+yTuDDlJ49jIqZXpXHuM+wT4Kry33RFiCt4twbSnpLa
         nsZ5SFf/0VWIKqWuVIfAp8bGj5LcbdKnaWqCIfosa44faKfO1lZgQFT7yfO8E9NcULGj
         HvRtvt5H6uzMJ8foBd/E8n7Jo8hKf5IcPFKJLj0Q0o8bVlwC3SFGm4O9yR+U5fBGB3mi
         3erg==
X-Gm-Message-State: AGi0PubbSx1Mgf+NXctnLCwkkNuqRWeKWA3xC73IQGxglAYN5Maej0EW
        YFbZQjMNq+YfegOrllNY9TdJU0iBfZpOoA==
X-Google-Smtp-Source: APiQypLbzSLCVFS1K2wcJuiSSKo7Ug5S+nV6EpBYg/kFWNvmaebKGIrDFk8kqGe/sp5s/DnbLsbl2w==
X-Received: by 2002:a37:8787:: with SMTP id j129mr32366716qkd.157.1587054192708;
        Thu, 16 Apr 2020 09:23:12 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id r18sm884383qtt.25.2020.04.16.09.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:23:11 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id DEFB5409A3; Thu, 16 Apr 2020 13:23:09 -0300 (-03)
Date:   Thu, 16 Apr 2020 13:23:09 -0300
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v10 1/4] perf doc: allow ASCIIDOC_EXTRA to be an argument
Message-ID: <20200416162309.GH2650@kernel.org>
References: <20200416162058.201954-1-irogers@google.com>
 <20200416162058.201954-2-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416162058.201954-2-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Apr 16, 2020 at 09:20:55AM -0700, Ian Rogers escreveu:
> This will allow parent makefiles to pass values to asciidoc.

Thanks, applied
 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/Documentation/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
> index 31824d5269cc..6e54979c2124 100644
> --- a/tools/perf/Documentation/Makefile
> +++ b/tools/perf/Documentation/Makefile
> @@ -48,7 +48,7 @@ man5dir=$(mandir)/man5
>  man7dir=$(mandir)/man7
>  
>  ASCIIDOC=asciidoc
> -ASCIIDOC_EXTRA = --unsafe -f asciidoc.conf
> +ASCIIDOC_EXTRA += --unsafe -f asciidoc.conf
>  ASCIIDOC_HTML = xhtml11
>  MANPAGE_XSL = manpage-normal.xsl
>  XMLTO_EXTRA =
> @@ -59,7 +59,7 @@ HTML_REF = origin/html
>  
>  ifdef USE_ASCIIDOCTOR
>  ASCIIDOC = asciidoctor
> -ASCIIDOC_EXTRA = -a compat-mode
> +ASCIIDOC_EXTRA += -a compat-mode
>  ASCIIDOC_EXTRA += -I. -rasciidoctor-extensions
>  ASCIIDOC_EXTRA += -a mansource="perf" -a manmanual="perf Manual"
>  ASCIIDOC_HTML = xhtml5
> -- 
> 2.26.1.301.g55bc3eb7cb9-goog
> 

-- 

- Arnaldo
