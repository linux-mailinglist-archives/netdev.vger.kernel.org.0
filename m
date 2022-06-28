Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED95855CD5D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241822AbiF1ITQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243873AbiF1IS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:56 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383282DA8E;
        Tue, 28 Jun 2022 01:17:15 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k129so5446562wme.0;
        Tue, 28 Jun 2022 01:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rvtNK3NUMkA8CEKQZP6QnJui/bz93uaFnF6matKQyQM=;
        b=cxAglpNwSh89Nnir5pAQ7ttQI2O9psUBx/mFiwgkBjNaiztLg+9vV2idAHUlq65XHu
         2kg7maDDPRYq60w8hevSYnMBCGoc2b7LP7uC+vPgY9HTvgXd/pAGwaiT2/AmoO5NvPZQ
         Pw7C3O5PHfDYdY7BTZPz9ueL5C+B5EpwGRstFjXazmSVuJBiY2orpEj+r8yFfP1FcWvm
         f2J46zgVt0BFOB/gWI5RnOheRBehRsZCKhi0NDRko8AHLaYt0aqV/bSZEibKuC5bAAaT
         /QuUPpPssS4xW8xM4+y6XFwxGEjT9rG/KA9H2/lgoItG7buGO0SC5KKJ38Zuj8QY9Y9e
         uVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rvtNK3NUMkA8CEKQZP6QnJui/bz93uaFnF6matKQyQM=;
        b=WezqgjzZqX7FYUWaEamf2hj8Onyuh9aRlnin0SrmMffvafiVRGsdxlf8NLp8fcVxHK
         sfFLSNPhiwLwrdH2PgFevUjDAZ7q7AZ/ZihEt7mqSFl3v053tkTQ8jMgRcOPvQ3mFEop
         xyP31QZPFoEpuvAyQzImqeZYQOE91Gg3I/LI0U07p9ITHWWoboUQ+np40xB0Hp30CPjq
         RP818RERdjKylZSaRa0s+4vLsTjYnpEyxY/K6o5mXernIPb+gP7b7qBXJ0+laRV9KETY
         XKF6BGbKKfwBbsRpTws67DWZRdXQaQ8cQcKVLqSI7Wm1SdKHaULdToyyHCrHfGeGWQ9j
         qMqA==
X-Gm-Message-State: AJIora+yW9VyYOOKyeJz4LfmTCEymtvZpNXqZmKcNAMLyTas2vDt03//
        6HTIPF0cSbLGyF1k4yGpjCg=
X-Google-Smtp-Source: AGRyM1uRSYDZ9aC5Z8EfsD/JtEoL1Mk+C1NLf+4DXGkBtIFLknP8eoN1sBhSiqy97pj2VMo4RrXs0A==
X-Received: by 2002:a05:600c:a42:b0:39c:9086:8a34 with SMTP id c2-20020a05600c0a4200b0039c90868a34mr24969500wmq.169.1656404233695;
        Tue, 28 Jun 2022 01:17:13 -0700 (PDT)
Received: from krava (net-109-116-206-47.cust.vodafonedsl.it. [109.116.206.47])
        by smtp.gmail.com with ESMTPSA id y10-20020a1c4b0a000000b0039c587342d8sm20620836wma.3.2022.06.28.01.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 01:17:13 -0700 (PDT)
From:   olsajiri@gmail.com
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>, To: Ian Rogers <irogers@google.com>;
Date:   Tue, 28 Jun 2022 10:17:10 +0200
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf bpf: 8 byte align bpil data
Message-ID: <Yrq5Bun3Nmb1vrW3@krava>
References: <20220614014714.1407239-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614014714.1407239-1-irogers@google.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 06:47:14PM -0700, Ian Rogers wrote:
> bpil data is accessed assuming 64-bit alignment resulting in undefined
> behavior as the data is just byte aligned. With an -fsanitize=undefined
> build the following errors are observed:

I need to add -w to get the clean build with that, do you see that as well?

  $ make EXTRA_CFLAGS='-fsanitize=undefined -w'

> 
> $ sudo perf record -a sleep 1
> util/bpf-event.c:310:22: runtime error: load of misaligned address 0x55f61084520f for type '__u64', which requires 8 byte alignment
> 0x55f61084520f: note: pointer points here
>  a8 fe ff ff 3c  51 d3 c0 ff ff ff ff 04  84 d3 c0 ff ff ff ff d8  aa d3 c0 ff ff ff ff a4  c0 d3 c0
>              ^
> util/bpf-event.c:311:20: runtime error: load of misaligned address 0x55f61084522f for type '__u32', which requires 4 byte alignment
> 0x55f61084522f: note: pointer points here
>  ff ff ff ff c7  17 00 00 f1 02 00 00 1f  04 00 00 58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00
>              ^
> util/bpf-event.c:198:33: runtime error: member access within misaligned address 0x55f61084523f for type 'const struct bpf_func_info', which requires 4 byte alignment
> 0x55f61084523f: note: pointer points here
>  58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00 3b 00 00 00 ab  02 00 00 44 00 00 00 14  03 00 00


and I'm also getting another error in:

[root@krava perf]# ./perf record -a sleep 1
util/synthetic-events.c:1202:11: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
0x00000286f7ea: note: pointer points here
 20 00  01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
              ^ 
util/synthetic-events.c:1203:18: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
0x00000286f7ea: note: pointer points here
 20 00  01 00 01 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
              ^ 
util/synthetic-events.c:1206:46: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
0x00000286f7ea: note: pointer points here
 20 00  01 00 01 00 08 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
              ^ 
/home/jolsa/kernel/linux-perf/tools/include/asm-generic/bitops/atomic.h:10:29: runtime error: load of misaligned address 0x00000286f7f2 for type 'long unsigned int', which requires 8 byte alignment
0x00000286f7f2: note: pointer points here
 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  51 00 00 00 00 00
              ^ 

are you going to address this one as well?


the reason for this one is that 'data' in struct perf_record_cpu_map_data
is not alligned(8), so that's why I raised the question in my other reply ;-)

I wonder we should mark all tools/lib/perf/include/perf/event.h types
as packed to prevent any compiler padding

thanks,
jirka
