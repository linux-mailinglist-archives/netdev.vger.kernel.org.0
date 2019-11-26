Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A85D109F5B
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 14:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfKZNiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 08:38:11 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:32947 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfKZNiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 08:38:10 -0500
Received: by mail-qk1-f194.google.com with SMTP id c124so11653076qkg.0;
        Tue, 26 Nov 2019 05:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HboSwltjR5muBc5SJne7q7ifN5p3DeZfc4hjWq0BaeQ=;
        b=kaAQET/uWDIp4XmDhynu68XPANBorFLgucUiLEyK+yr9/2kmkc4Kd+cq0aUIBiQRSo
         RF4uUBx3+s2FHriY6FH/MosauvA8k0uwUSVyu4NGMq1nAe6BoyGedOJOvJenCISv174x
         ETPOrdDbWUuw0FKlgFAESR0WZXTbIVSOeTrpr2cNbY898M5HrRwPY7du5gb8XzTUlhaB
         Qq4o/R+yjk9e/4lboS6Z2OfriqJ3BJr0ui4rSx6z0+p8XPHZKjcGd2u8mZ0ebj2D2UNV
         BkSpPH6urxm2QEKaX2beyu9HGvDP7p04GCy5BLBmFHt9WeAScEQ0ckTnP8pcM9tHPSqA
         +MQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HboSwltjR5muBc5SJne7q7ifN5p3DeZfc4hjWq0BaeQ=;
        b=RiuIlF2uTLwsteMKUmUEWpvlOFfEIEq5SemmJ8a6wGa/kOKOuwxWbAka9mzaGTQt4M
         l+0/26ZLs05LIGdObaiLrUzeAbEtNQGh+0rMXClLQyzDECUqHyCLWmEGAMk0YNcUYQAu
         +jnQnP2C4psmBAMQ017j1HFTW6Iu0ptFFGR0cIH1Xx4OGsP20tVSzOcMPNFvFthi3Ozc
         ym/vWIsyU1dL+VuUQKZVAWSXrYpA3e9KJQXdieoYVV+LqRLAXcKqKx+XqmE43oB9ow+I
         A2CuN/IKrw3VbbxTZl9hNAPA3CDMcCHdoxMcjGM4ThPhEE7t7ru/HtWnyHE56lSlRr+c
         rKbg==
X-Gm-Message-State: APjAAAUA2hpAWLEVNIX7xcXYm226iVwPTeGCdcMwNCLUsw//5SO86UCA
        2/sKsCFBtRvoOGUOn2+3ILo=
X-Google-Smtp-Source: APXvYqy941zKkDLCRamRT6trjaeicRqIBowghAkLXte8p/tcmmPcvKOIomgvXRqnSOgFfXqiBejnfA==
X-Received: by 2002:a37:8285:: with SMTP id e127mr16293219qkd.62.1574775489596;
        Tue, 26 Nov 2019 05:38:09 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id y24sm5069214qki.104.2019.11.26.05.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:38:08 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id B579A40D3E; Tue, 26 Nov 2019 10:38:06 -0300 (-03)
Date:   Tue, 26 Nov 2019 10:38:06 -0300
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH] perf tools: Allow to link with libbpf dynamicaly
Message-ID: <20191126133806.GA19483@kernel.org>
References: <20191126121253.28253-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126121253.28253-1-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Nov 26, 2019 at 01:12:53PM +0100, Jiri Olsa escreveu:
> Currently we support only static linking with kernel's
> libbpf (tools/lib/bpf). This patch adds libbpf package
> detection and support to link perf with it dynamically.
> 
> The libbpf package status is displayed with:
> 
>   $ make VF=1
>   Auto-detecting system features:
>   ...
>   ...                        libbpf: [ on  ]
> 
> It's not checked by default, because it's quite new.
> Once it's on most distros we can switch it on.
> 
> For the same reason it's not added to the test-all check.
> 
> Perf does not need advanced version of libbpf, so we can
> check just for the base bpf_object__open function.
> 
> Adding new compile variable to detect libbpf package and
> link bpf dynamically:
> 
>   $ make LIBBPF_DYNAMIC=1
>     ...
>     LINK     perf
>   $ ldd perf | grep bpf
>     libbpf.so.0 => /lib64/libbpf.so.0 (0x00007f46818bc000)
> 
> If libbpf is not installed, build stops with:
> 
>   Makefile.config:486: *** Error: No libbpf devel library found,\
>   please install libbpf-devel.  Stop.

Thanks, tested with how I build it:

      $ make LIBBPF_DYNAMIC=1 -C tools/perf O=/tmp/build/perf
      make: Entering directory '/home/acme/git/perf/tools/perf'
        BUILD:   Doing 'make -j8' parallel build
      Makefile.config:493: *** Error: No libbpf devel library found, please install libbpf-devel.  Stop.
      make[1]: *** [Makefile.perf:225: sub-make] Error 2
      make: *** [Makefile:70: all] Error 2
      make: Leaving directory '/home/acme/git/perf/tools/perf'
      $

works as well as advertised, applied.

- Arnaldo
