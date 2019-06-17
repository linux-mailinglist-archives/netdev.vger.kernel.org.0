Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8699F48A23
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfFQRcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:32:09 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40888 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQRcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:32:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id a15so11691801qtn.7;
        Mon, 17 Jun 2019 10:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t1yJydCVDq5OJIyrTjOy4i8SVUirxdw9ac7nmQRIwbg=;
        b=McKtNWQ2jh6T9n8Ui7/I36Ofbeqr/iUidtuOxm6EQgwWotCtAlLgOfYfBlZOXpmmp1
         rQFMK6ad/0/QDW1+V8R05cljfo9QLUBqSL3h/LXPShJ6hdZ6G1Wy0tf3er54K7fPFgw7
         Lj+dz+isVIEUpd29stGu4uOQgrvFdc7Mds1mc6m1IvkzdLukZoGfULZHh++Bczi9V3ru
         6CYLfDK93KEsMlBuzxFWxEeervGS5yGPWTZOv1BRQtG88k3Aa3havHXpoqiTFTzGIhlw
         fannlqH3iNyRLNhapW1Jkm3YpaH4SkSKFRHzy6v739TcjXJhBuyZkl9u4JRjeS0zYOSR
         uBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t1yJydCVDq5OJIyrTjOy4i8SVUirxdw9ac7nmQRIwbg=;
        b=Qufa0w7Rx/DfTYTlpfTGHlvtTIstDjhGgENtb8qR05oepZNw7ZmCgToE7/gF/5plZ7
         s6kUa5gJcndG5ICq2H2du9avbAAjT+puV6+z7fhrT42HonnXQbFSFxuvZ2tV2GqeUZfJ
         s1GZCU0eHldxbK1FaAlAni30Z3WvJIJm1jIQk8LdRZyt+lx8NPiX9JTK/10SOueG7PDk
         BOtWB9feZ4jX0H68FFbUoRHsZtx9wv0fgxAysBfzOjihhXz26ZPiELgeIC6YiK24q6Ed
         /8Rl83Rquo7P2D6CtAeMF7cxa2u47aHQKYYDVp66XPyF4GCHnJiUHJvxanEWyACIm5YE
         y6nQ==
X-Gm-Message-State: APjAAAWWXjlslyOFsZvbGE+EY7UjguV2hn6/YQEnq3oEinnPlAdyPn6I
        Wj0HVk2Yvb23JbK5hjYBk1M=
X-Google-Smtp-Source: APXvYqwrFiH9HyWsgGS9Bd1/XMSyTPAOP3mCgQw0j4tx6rrJiTpgrlPEX4l4qlpr3T3DxqF6fVmEvQ==
X-Received: by 2002:ac8:303c:: with SMTP id f57mr95760870qte.294.1560792727374;
        Mon, 17 Jun 2019 10:32:07 -0700 (PDT)
Received: from quaco.ghostprotocols.net (179-240-145-61.3g.claro.net.br. [179.240.145.61])
        by smtp.gmail.com with ESMTPSA id u63sm1222212qkh.85.2019.06.17.10.32.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 10:32:06 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8246541149; Mon, 17 Jun 2019 14:32:03 -0300 (-03)
Date:   Mon, 17 Jun 2019 14:32:03 -0300
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
Subject: Re: [PATCH 2/2] perf trace: Handle NULL pointer dereference in
 trace__syscall_info()
Message-ID: <20190617173203.GA23094@kernel.org>
References: <20190617091140.24372-1-leo.yan@linaro.org>
 <20190617091140.24372-2-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617091140.24372-2-leo.yan@linaro.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Jun 17, 2019 at 05:11:40PM +0800, Leo Yan escreveu:
> trace__init_bpf_map_syscall_args() invokes trace__syscall_info() to
> retrieve system calls information, it always passes NULL for 'evsel'
> argument; when id is an invalid value then the logging will try to
> output event name, this triggers NULL pointer dereference.
> 
> This patch directly uses string "unknown" for event name when 'evsel'
> is NULL pointer.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/perf/builtin-trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 5cd74651db4c..49dfb2fd393b 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1764,7 +1764,7 @@ static struct syscall *trace__syscall_info(struct trace *trace,
>  		static u64 n;
>  
>  		pr_debug("Invalid syscall %d id, skipping (%s, %" PRIu64 ")\n",
> -			 id, perf_evsel__name(evsel), ++n);
> +			 id, evsel ? perf_evsel__name(evsel) : "unknown", ++n);
>  		return NULL;

What do you think of this instead?

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 68beef8f47ff..1d6af95b9207 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -590,6 +590,9 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 {
 	char bf[128];
 
+	if (!evsel)
+		goto out_unknown;
+
 	if (evsel->name)
 		return evsel->name;
 
@@ -629,7 +632,10 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 
 	evsel->name = strdup(bf);
 
-	return evsel->name ?: "unknown";
+	if (evsel->name)
+		return evsel->name;
+out_unknown:
+	return "unknown";
 }
 
 const char *perf_evsel__group_name(struct perf_evsel *evsel)
