Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B2A19F62E
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgDFMyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:54:17 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:44749 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbgDFMyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:54:17 -0400
Received: by mail-qv1-f67.google.com with SMTP id ef12so7377554qvb.11;
        Mon, 06 Apr 2020 05:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zUCFc1iqmnth4WORXNUlk26E1QRT96JyCR6rxJ9zOgg=;
        b=ayCVDP1iJch5pWsBNgpIFtJTy0/BM3plUKVB64YJLi3rzynY7TsL3bLSVDPg6UkhEy
         PoIjbFzXxmrdoL0hx5GoAKgxcUCxFk8LdkZDJYfd8PspmfQTj4PQBGVtvVCeF16g5hSy
         K2B7wX/gmr0Wfs+tZ1gCpx78WgGc4OdBQx3S76dcsIW2qwXeA6DRBML1sKv7KhQJzLop
         AQHo251pzq1tY618+6T+VafKvrgEfPULAWThiI2Q4ElRQ9a24Reht44cVfsqeWD2270u
         fo/Kf8ht2N9R7qlF2301qFF7vPNUXKigPsBuAOGvctIDXMZKm0yN7bmipCeRc07c8GFd
         dmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zUCFc1iqmnth4WORXNUlk26E1QRT96JyCR6rxJ9zOgg=;
        b=bi9z40JGSGA6q7Lg5n29Yk864KTngNIIYi6zbkLcUoh+3IbjHcNohRwjqnVRO//9ec
         0aKK59CQO78F3N+zaI6K14SSdxMInPqGQvEDmg6AeHC4P7KQ0ESqG5cb7yqbVi2yrp7N
         0GOOi1J9DMSz1yA3x1OquH1ya0bF71qfQp4Cg0bQjv/XOG7F2NYR901mJ2hmHGfiaUVd
         Q4UF6ifIB9ztdcBoUbESAPMOos42AdpgJVPRO9LBZ7nDM52zeXcGjEXMADN15tm1KrX+
         JUED5wJNMi4EjU9B05FJo3uTksl90wN50NtvaAR02TRwi9TQB1+nVc5AgG7+NtpMPNKQ
         sHYQ==
X-Gm-Message-State: AGi0PuZcVh5ptPy6A9VDAvK1bWoW0VatYBreHpFycOs265IjY49qtkXO
        PZF9O40W4S/OPLnG8aD2DDI=
X-Google-Smtp-Source: APiQypK1agSRUVxAGq175pcqjG8AAiDbBtYaD31f1YXF0+/DMsapgsnShXIAoHtEUdy83QaznEXA6g==
X-Received: by 2002:a05:6214:18c1:: with SMTP id cy1mr21044167qvb.142.1586177655546;
        Mon, 06 Apr 2020 05:54:15 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id k3sm7871319qki.6.2020.04.06.05.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 05:54:14 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 61740409A3; Mon,  6 Apr 2020 09:54:12 -0300 (-03)
Date:   Mon, 6 Apr 2020 09:54:12 -0300
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 13/15] perf tools: Synthesize bpf_trampoline/dispatcher
 ksymbol event
Message-ID: <20200406125412.GA29826@kernel.org>
References: <20200312195610.346362-1-jolsa@kernel.org>
 <20200312195610.346362-14-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200312195610.346362-14-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Mar 12, 2020 at 08:56:08PM +0100, Jiri Olsa escreveu:
> +static int
> +process_bpf_image(char *name, u64 addr, struct kallsyms_parse *data)
> +{
> +	struct machine *machine = data->machine;
> +	union perf_event *event = data->event;
> +	struct perf_record_ksymbol *ksymbol;
> +
> +	ksymbol = &event->ksymbol;
> +
> +	*ksymbol = (struct perf_record_ksymbol) {
> +		.header = {
> +			.type = PERF_RECORD_KSYMBOL,
> +			.size = offsetof(struct perf_record_ksymbol, name),
> +		},
> +		.addr      = addr,
> +		.len       = page_size,
> +		.ksym_type = PERF_RECORD_KSYMBOL_TYPE_BPF,
> +		.flags     = 0,
> +	};
> +
> +	strncpy(ksymbol->name, name, KSYM_NAME_LEN);
> +	ksymbol->header.size += PERF_ALIGN(strlen(name) + 1, sizeof(u64));
> +	memset((void *) event + event->header.size, 0, machine->id_hdr_size);
> +	event->header.size += machine->id_hdr_size;
> +
> +	return perf_tool__process_synth_event(data->tool, event, machine,
> +					      data->process);

This explodes in fedora 32 and rawhide and in openmandriva:cooker:

  GEN      /tmp/build/perf/python/perf.so
  CC       /tmp/build/perf/util/bpf-event.o
In file included from /usr/include/string.h:495,
                 from /git/perf/tools/lib/bpf/libbpf_common.h:12,
                 from /git/perf/tools/lib/bpf/bpf.h:31,
                 from util/bpf-event.c:4:
In function ‘strncpy’,
    inlined from ‘process_bpf_image’ at util/bpf-event.c:323:2,
    inlined from ‘kallsyms_process_symbol’ at util/bpf-event.c:358:9:
/usr/include/bits/string_fortified.h:106:10: error: ‘__builtin_strncpy’ specified bound 256 equals destination size [-Werror=stringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
mv: cannot stat '/tmp/build/perf/util/.bpf-event.o.tmp': No such file or directory
make[4]: *** [/git/perf/tools/build/Makefile.build:97: /tmp/build/perf/util/bpf-event.o] Error 1
make[3]: *** [/git/perf/tools/build/Makefile.build:139: util] Error 2
make[2]: *** [Makefile.perf:617: /tmp/build/perf/perf-in.o] Error 2
make[1]: *** [Makefile.perf:225: sub-make] Error 2
make: *** [Makefile:70: all] Error 2
make: Leaving directory '/git/perf/tools/perf'
[perfbuilder@fc58e82bfba4 ~]$

So I patched it a bit, please ack:


diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 3728db98981e..0cd41a862952 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -306,6 +306,7 @@ process_bpf_image(char *name, u64 addr, struct kallsyms_parse *data)
 	struct machine *machine = data->machine;
 	union perf_event *event = data->event;
 	struct perf_record_ksymbol *ksymbol;
+	int len;
 
 	ksymbol = &event->ksymbol;
 
@@ -320,8 +321,8 @@ process_bpf_image(char *name, u64 addr, struct kallsyms_parse *data)
 		.flags     = 0,
 	};
 
-	strncpy(ksymbol->name, name, KSYM_NAME_LEN);
-	ksymbol->header.size += PERF_ALIGN(strlen(name) + 1, sizeof(u64));
+	len = scnprintf(ksymbol->name, KSYM_NAME_LEN, "%s", name);
+	ksymbol->header.size += PERF_ALIGN(len + 1, sizeof(u64));
 	memset((void *) event + event->header.size, 0, machine->id_hdr_size);
 	event->header.size += machine->id_hdr_size;
 
