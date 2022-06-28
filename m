Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B9055E97D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346776AbiF1Pfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347854AbiF1Pf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:35:29 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F04833E89;
        Tue, 28 Jun 2022 08:35:28 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id mf9so26692549ejb.0;
        Tue, 28 Jun 2022 08:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DL43punzQ+qzj6hSdoTRg0mAdzG3rAXkxtHbjtjcKDk=;
        b=J/pl124QRt2Wk2blBedwyS9d7/NqidqGNjmcJKmMTwWV1k2PN4bCCL1XaJI2c4NegV
         Tv7PPzrhPRaTW/hgrurPvvbIIjcf2579WfQqhCfIu8GwswFzunf+HuxpWGSQFGwOFG/P
         yKppR+dssvXShdpG2cskbpM2bfmSZNYTFgfDukzoWZasp0UcuvUGbKo0qZJjfEn3t1H8
         cdMKbenRdJgMdGiaOHLS7i/Ic/HqygfFKoJYVNQsZCruUioBSMdg5q0UE714pBAWOkNk
         XY3ulXdyYYl4yKo9JPcylZrcfs5CCZ9h/yqD/4NYcjrjJAmcyO77F2grc2SyfMXit+qx
         BUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DL43punzQ+qzj6hSdoTRg0mAdzG3rAXkxtHbjtjcKDk=;
        b=pzT17uwl6Fba0V2ZPkqe4zMZFBuLECzCZbShEO2QFYosiO68qy3aDx+96iwhHlEIb7
         GAsmJNR3UEfV6vlJ687RXGQkh6dYBgEugJfjt3keLmjrKl7qvsP8hjc52k8Bdfsb7m+Q
         YO+m8t5tmvdTlujwPmbRsG8+200ijNBcFhosH69IveNG0ZGcnFn8yrorzlUrSXqbzeuj
         fmkfBLty3agHu3jsYT9mpJPJcwuuqGZDvbkmmFbbtShBqUFTFFmLCchDNMO9rd28qzlL
         AeaDiA9isidd11CojjJwrC/P1l0yX+52R8yqgeiVnOVog4lL9mLKEUJ1w4+B7AqClAcd
         xYgw==
X-Gm-Message-State: AJIora8h23NQt640u/jGZqDTlpmH485ZsQXaH4lhIinwcBxb2qul6jKz
        xwFiXHW2op1kY2e5KXo0ILk=
X-Google-Smtp-Source: AGRyM1uPRSomYbKmcMmXmhjerNWDelmBl5PQl5c4/qUVsG9o1Ty4qLP7QnFBMkjQwr2Ou31X8L2+FQ==
X-Received: by 2002:a17:906:4794:b0:722:f10e:6240 with SMTP id cw20-20020a170906479400b00722f10e6240mr19530893ejc.704.1656430526484;
        Tue, 28 Jun 2022 08:35:26 -0700 (PDT)
Received: from krava (net-109-116-206-47.cust.vodafonedsl.it. [109.116.206.47])
        by smtp.gmail.com with ESMTPSA id by27-20020a0564021b1b00b004356112a8a2sm9698253edb.15.2022.06.28.08.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 08:35:25 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 28 Jun 2022 17:35:21 +0200
To:     Ian Rogers <irogers@google.com>
Cc:     olsajiri@gmail.com, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <YrsfueiaxKmpf0Ng@krava>
References: <20220614014714.1407239-1-irogers@google.com>
 <Yrq5Bun3Nmb1vrW3@krava>
 <CAP-5=fXNJjRxGCE=mH22bLg1mNXMRgL_px4=-=8Zq-DLUXbxTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fXNJjRxGCE=mH22bLg1mNXMRgL_px4=-=8Zq-DLUXbxTg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 08:15:04AM -0700, Ian Rogers wrote:
> On Tue, Jun 28, 2022 at 1:41 AM <olsajiri@gmail.com> wrote:
> >
> > On Mon, Jun 13, 2022 at 06:47:14PM -0700, Ian Rogers wrote:
> > > bpil data is accessed assuming 64-bit alignment resulting in undefined
> > > behavior as the data is just byte aligned. With an -fsanitize=undefined
> > > build the following errors are observed:
> >
> > I need to add -w to get the clean build with that, do you see that as well?
> >
> >   $ make EXTRA_CFLAGS='-fsanitize=undefined -w'
> 
> I don't recall needing this, but I was stacking fixes which may explain it.
> 
> > >
> > > $ sudo perf record -a sleep 1
> > > util/bpf-event.c:310:22: runtime error: load of misaligned address 0x55f61084520f for type '__u64', which requires 8 byte alignment
> > > 0x55f61084520f: note: pointer points here
> > >  a8 fe ff ff 3c  51 d3 c0 ff ff ff ff 04  84 d3 c0 ff ff ff ff d8  aa d3 c0 ff ff ff ff a4  c0 d3 c0
> > >              ^
> > > util/bpf-event.c:311:20: runtime error: load of misaligned address 0x55f61084522f for type '__u32', which requires 4 byte alignment
> > > 0x55f61084522f: note: pointer points here
> > >  ff ff ff ff c7  17 00 00 f1 02 00 00 1f  04 00 00 58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00
> > >              ^
> > > util/bpf-event.c:198:33: runtime error: member access within misaligned address 0x55f61084523f for type 'const struct bpf_func_info', which requires 4 byte alignment
> > > 0x55f61084523f: note: pointer points here
> > >  58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00 3b 00 00 00 ab  02 00 00 44 00 00 00 14  03 00 00
> >
> >
> > and I'm also getting another error in:
> >
> > [root@krava perf]# ./perf record -a sleep 1
> > util/synthetic-events.c:1202:11: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
> > 0x00000286f7ea: note: pointer points here
> >  20 00  01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
> >               ^
> > util/synthetic-events.c:1203:18: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
> > 0x00000286f7ea: note: pointer points here
> >  20 00  01 00 01 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
> >               ^
> > util/synthetic-events.c:1206:46: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
> > 0x00000286f7ea: note: pointer points here
> >  20 00  01 00 01 00 08 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
> >               ^
> > /home/jolsa/kernel/linux-perf/tools/include/asm-generic/bitops/atomic.h:10:29: runtime error: load of misaligned address 0x00000286f7f2 for type 'long unsigned int', which requires 8 byte alignment
> > 0x00000286f7f2: note: pointer points here
> >  00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  51 00 00 00 00 00
> >               ^
> >
> > are you going to address this one as well?
> >
> >
> > the reason for this one is that 'data' in struct perf_record_cpu_map_data
> > is not alligned(8), so that's why I raised the question in my other reply ;-)
> >
> > I wonder we should mark all tools/lib/perf/include/perf/event.h types
> > as packed to prevent any compiler padding
> 
> I already sent out a fix and some improvements related to this:
> https://lore.kernel.org/lkml/20220614143353.1559597-1-irogers@google.com/
> Could you take a look?

ok, I overlooked that one

> 
> I'm not sure about aligned and packed. I tried to minimize it in the
> change above. The issue is that taking the address of a variable in a
> packed struct results in an unaligned pointer. To address this in the
> fix above I changed the functions to pass pointers to the whole
> struct.

ok, will check,

thanks,
jirka
