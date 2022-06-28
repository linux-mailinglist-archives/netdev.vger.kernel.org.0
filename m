Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7DE55E86E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348183AbiF1PPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348162AbiF1PP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:15:28 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFC832059
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:15:19 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d17so12535788wrc.10
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8kVNWHrBL0GiaNqy7pXs9TTaPLwVW5aeut18uIqtgkc=;
        b=Lur6rtWdWtsnC+SAMWRIoyGTCnfrArnoVRT/JoKQA1MBFjN7wKpLHEMLSnukDEMMHU
         Ay8mffu3ExD+WOLzoMZ+p+JZ0ihbmQHBW6GWjmYKXBoeoe0FBG0XJ7G9Gj7v5Haq+GO3
         Q4N96g0vvP7TUEYJcVhsixklEsMkotlZak7Lw+VD8LfCJ+ePdug2NU13uZZa4uLEPlGY
         R1LHApvvD7Xx1zetSoSWWfwOIYLhCIdnAERf7Bj6mgMQXZar+tZqeEOkuMD/O/XWIa7q
         K+OFjxGLNiNhPL9R9aMgdJuBzRu/VIrMkviyPILGE1JV+wYAVrZ32Z/g1Y0yuXXmJN41
         0Myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8kVNWHrBL0GiaNqy7pXs9TTaPLwVW5aeut18uIqtgkc=;
        b=vub5rM8GaeCfcBffMX74OPWdqtCeiPNjgHwfVZDXH7CoX3kyWqUzbxHFXi8/cDrgNu
         wRiIkZdVFAC4XeXdQNhdCo9p6flUQAULqFnmDaCD9GR5fAq4SnU8gQINnIUxIwGju7+f
         DYhAlM83lFAhbjJZKLwaxgIs8lCZ8NGMy4Vb4vsjbaDu4IBNIcImYnwIJRcCrd8PTluO
         2GxleUII+eKn72t4Qdd0i6PLyQKi57SysnvImueDc+a1NqhBXKIstKbQSUCqtWYc7V0I
         iRvA5FReOssrlyabhefEsaaQ2Lhrb7UfopmWfxd6b9Jq5sUEthJmYt4nRMzo5V21uVi2
         rZAw==
X-Gm-Message-State: AJIora8Dxztbt/qr9B7INS20WUHvP/KHipE6NTO6cTzN8xY+0GNP1tKk
        8Tc7oNWmqahYd3eruglEqya/PxZgbgxtnYxt6wf6rA==
X-Google-Smtp-Source: AGRyM1vzfRMZwSSEMuW4Vd1zY8jVZxxwz2LtHYL1OrjbU/xaztX9Iy32yiJySZYdl72ksriuNPl+C/SvWFQ9AuqsVYs=
X-Received: by 2002:a5d:544c:0:b0:21b:a288:f98c with SMTP id
 w12-20020a5d544c000000b0021ba288f98cmr17779907wrv.300.1656429317400; Tue, 28
 Jun 2022 08:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220614014714.1407239-1-irogers@google.com> <Yrq5Bun3Nmb1vrW3@krava>
In-Reply-To: <Yrq5Bun3Nmb1vrW3@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 28 Jun 2022 08:15:04 -0700
Message-ID: <CAP-5=fXNJjRxGCE=mH22bLg1mNXMRgL_px4=-=8Zq-DLUXbxTg@mail.gmail.com>
Subject: Re: [PATCH] perf bpf: 8 byte align bpil data
To:     olsajiri@gmail.com
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 1:41 AM <olsajiri@gmail.com> wrote:
>
> On Mon, Jun 13, 2022 at 06:47:14PM -0700, Ian Rogers wrote:
> > bpil data is accessed assuming 64-bit alignment resulting in undefined
> > behavior as the data is just byte aligned. With an -fsanitize=undefined
> > build the following errors are observed:
>
> I need to add -w to get the clean build with that, do you see that as well?
>
>   $ make EXTRA_CFLAGS='-fsanitize=undefined -w'

I don't recall needing this, but I was stacking fixes which may explain it.

> >
> > $ sudo perf record -a sleep 1
> > util/bpf-event.c:310:22: runtime error: load of misaligned address 0x55f61084520f for type '__u64', which requires 8 byte alignment
> > 0x55f61084520f: note: pointer points here
> >  a8 fe ff ff 3c  51 d3 c0 ff ff ff ff 04  84 d3 c0 ff ff ff ff d8  aa d3 c0 ff ff ff ff a4  c0 d3 c0
> >              ^
> > util/bpf-event.c:311:20: runtime error: load of misaligned address 0x55f61084522f for type '__u32', which requires 4 byte alignment
> > 0x55f61084522f: note: pointer points here
> >  ff ff ff ff c7  17 00 00 f1 02 00 00 1f  04 00 00 58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00
> >              ^
> > util/bpf-event.c:198:33: runtime error: member access within misaligned address 0x55f61084523f for type 'const struct bpf_func_info', which requires 4 byte alignment
> > 0x55f61084523f: note: pointer points here
> >  58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00 3b 00 00 00 ab  02 00 00 44 00 00 00 14  03 00 00
>
>
> and I'm also getting another error in:
>
> [root@krava perf]# ./perf record -a sleep 1
> util/synthetic-events.c:1202:11: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
> 0x00000286f7ea: note: pointer points here
>  20 00  01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
>               ^
> util/synthetic-events.c:1203:18: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
> 0x00000286f7ea: note: pointer points here
>  20 00  01 00 01 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
>               ^
> util/synthetic-events.c:1206:46: runtime error: member access within misaligned address 0x00000286f7ea for type 'struct perf_record_record_cpu_map', which requires 8 byte alignment
> 0x00000286f7ea: note: pointer points here
>  20 00  01 00 01 00 08 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00
>               ^
> /home/jolsa/kernel/linux-perf/tools/include/asm-generic/bitops/atomic.h:10:29: runtime error: load of misaligned address 0x00000286f7f2 for type 'long unsigned int', which requires 8 byte alignment
> 0x00000286f7f2: note: pointer points here
>  00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  51 00 00 00 00 00
>               ^
>
> are you going to address this one as well?
>
>
> the reason for this one is that 'data' in struct perf_record_cpu_map_data
> is not alligned(8), so that's why I raised the question in my other reply ;-)
>
> I wonder we should mark all tools/lib/perf/include/perf/event.h types
> as packed to prevent any compiler padding

I already sent out a fix and some improvements related to this:
https://lore.kernel.org/lkml/20220614143353.1559597-1-irogers@google.com/
Could you take a look?

I'm not sure about aligned and packed. I tried to minimize it in the
change above. The issue is that taking the address of a variable in a
packed struct results in an unaligned pointer. To address this in the
fix above I changed the functions to pass pointers to the whole
struct.

Thanks,
Ian

> thanks,
> jirka
