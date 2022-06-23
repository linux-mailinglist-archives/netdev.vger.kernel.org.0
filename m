Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F415572DF
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 08:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiFWGJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 02:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFWGJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 02:09:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9215519F;
        Wed, 22 Jun 2022 23:09:54 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eq6so19644551edb.6;
        Wed, 22 Jun 2022 23:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OqGyQJ3vy7PFybuXdaUB9y/gte3aocvZWTw7e9ixzAM=;
        b=lfk6qyQ2fHmok7eXGaiDcxvHYiLHGIceYW1LPAad5yb6Ay6jih9ZhoKkeGTZ40xkic
         OgsbLla2SyPpwu4KFIjE9FOVcwQex/sr8vG4L7sk4MsLLMGKB2/fgenkEkHzT+a+kUTQ
         X7lDtbiyR9z8BbBAwo/xTBitKPzbw++ToQr9P9S9tS4uBQNIUquj3tXF7rq36LK/ewTk
         IiAwYpgj+njfWm4i7tVO9HbwL7bq0/KV2TsB8dVgpJXy2nDmbzDdRPtxbBM/bkepTui6
         rSgnKd/NhSMrG6C8cSRVKO2qFvYaz4yz68wG4N+TckRnnpjScrXn/+mLX4cs1y71jVEl
         AxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OqGyQJ3vy7PFybuXdaUB9y/gte3aocvZWTw7e9ixzAM=;
        b=Bn/ea0dKagsVaMOZHcJNr9oac5TBRAELpmIko6d3CRKiywPqty1JYZHkw2FuY3P1EL
         qfjVLIFKNLL1mjFoFSXdmKWLLJYnDEDXDxk9hGPvxP7XAzJq+zknbkD6asoPcAHob/x5
         TjFZpAqWYUkOzZTgvSBoWULm5BQbr+K4UnvLfNpXs1JslwK+PMLHNc/zUj63UYppAEVE
         AK/R5TosDLV1m1SJ9PwXSR1BPqVFCSGgJaDyC2rUHxNjCdmdAymFM8b9dUbtu6Qr8mjC
         JS7FjY7H6vbUpUERZB7+ILIv/UovD4PxEuuxVm66hSrDPYBDX04DzpDESopeNJ/z50P+
         U0ZA==
X-Gm-Message-State: AJIora90wO38LBb5tzM+5rSxED3ht1rBoAlSULp/j/zP4vsoNe6M0aK+
        Z13a9iUhgcvECHLX5pfRWHOsQjOpq6XHIceksNE=
X-Google-Smtp-Source: AGRyM1tX7/C4TnqkwnjThVlTdE+GzhG4vp86mMRor/sZYWYPxI83UaXFp/FMuDnRrnE63mmfJGJ240OuBGkPpMXORCI=
X-Received: by 2002:a05:6402:24a4:b0:434:e43e:2462 with SMTP id
 q36-20020a05640224a400b00434e43e2462mr8577471eda.312.1655964593015; Wed, 22
 Jun 2022 23:09:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220621073233.53776-1-nashuiliang@gmail.com> <62b3dfeae3f40_6a3b2208a3@john.notmuch>
In-Reply-To: <62b3dfeae3f40_6a3b2208a3@john.notmuch>
From:   Chuang W <nashuiliang@gmail.com>
Date:   Thu, 23 Jun 2022 14:09:41 +0800
Message-ID: <CACueBy5ia2VhgNiyQnjsrjY=b7kBUKuN4Lv38cXHymdWHYiuVQ@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Cleanup the kprobe_event on failed add_kprobe_event_legacy()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jingren Zhou <zhoujingren@didiglobal.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, John. Thanks, I will resubmit V3 soon, and supplement the commit
information.

On Thu, Jun 23, 2022 at 11:37 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Chuang W wrote:
> > Before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
> > livepatch"), in a scenario where livepatch and kprobe coexist on the
> > same function entry, the creation of kprobe_event using
> > add_kprobe_event_legacy() will be successful, at the same time as a
> > trace event (e.g. /debugfs/tracing/events/kprobe/XX) will exist, but
> > perf_event_open() will return an error because both livepatch and kprobe
> > use FTRACE_OPS_FL_IPMODIFY.
> >
> > With this patch, whenever an error is returned after
> > add_kprobe_event_legacy(), this ensures that the created kprobe_event is
> > cleaned.
> >
> > Signed-off-by: Chuang W <nashuiliang@gmail.com>
> > Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
>
> I think we want to improve the commit message otherwise I'm sure we will
> stumble on this in the future and from just above its tricky to follow.
> I would suggest almost verbatim the description you gave in reply to
> my question. Just cut'n'pasting your text together with minor edit
> glue,
>
> "
>  The legacy kprobe API (i.e. tracefs API) has two steps:
>
>  1) register_kprobe
>
>  $ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events
>
>  This will create a trace event of mykprobe and register a disable
>  kprobe that waits to be activated.
>
>  2) enable_kprobe
>
>  2.1) using syscall perf_event_open as the following code,
>  perf_event_kprobe_open_legacy (file: tools/lib/bpf/libbpf.c):
>  ---
>  attr.type = PERF_TYPE_TRACEPOINT;
>  pfd = syscall(__NR_perf_event_open, &attr,
>                pid < 0 ? -1 : pid, /* pid */
>                pid == -1 ? 0 : -1, /* cpu */
>                -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC);
>  ---
>
>  In the implementation code of perf_event_open, enable_kprobe() will be executed.
>
>  2.2) using shell
>
>  $ echo 1 > /sys/kernel/debug/tracing/events/kprobes/mykprobe/enable
>
>  As with perf_event_open, enable_kprobe() will also be executed.
>
>  When using the same function XXX, kprobe and livepatch cannot coexist,
>  that is, step 2) will return an error (ref: arm_kprobe_ftrace()),
>  however, step 1) is ok! The new kprobe API (i.e. perf kprobe API)
>  aggregates register_kprobe and enable_kprobe, internally fixes the
>  issue on failed enable_kprobe.
>
>  To fix: before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
>  livepatch"), in a scenario where livepatch and kprobe coexist on the
>  same function entry, the creation of kprobe_event using
>  add_kprobe_event_legacy() will be successful, at the same time as a
>  trace event (e.g. /debugfs/tracing/events/kprobe/XX) will exist, but
>  perf_event_open() will return an error because both livepatch and kprobe
>  use FTRACE_OPS_FL_IPMODIFY.
>
>  With this patch, whenever an error is returned after
>  add_kprobe_event_legacy(), this ensures that the created kprobe_event is
>  cleaned.
> "
>
> Thanks,
> John
