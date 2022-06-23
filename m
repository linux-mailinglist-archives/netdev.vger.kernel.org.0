Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9761C5571D0
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiFWEjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240771AbiFWDhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 23:37:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1A436155;
        Wed, 22 Jun 2022 20:37:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p3-20020a17090a428300b001ec865eb4a2so1256728pjg.3;
        Wed, 22 Jun 2022 20:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=KYNLoM6OlEsOl9RGsNpTi6ZntIlmfhhXqJ1nIViCbJQ=;
        b=iZIQWR+Aag78WcApUrSCQOmM60KmHwBGPVbXctBC6lirexHofTRjfbzjeFnnZurh2B
         3fQKpsbPYH+W8i1OzIFjtOZi/QLzF3lrGDJ6QC8lhLheuAsBj4CFQ8lekzGHS2bOs2yD
         ubjVd7Uz5OmFPkRMrJrnbynVDmGdzPKSqeK8GKSP1DBnetPLEPXrkTGUhq/EFO9SDpZr
         6esfYoCacWIzY3I28zvQoNMND652iaD70tTxbDSbnwrOMq9/kwmvh2/tpWeTW2aX86aA
         zfAewdgNMnjVTD4Qw0NU0X6K5kr4e8W+v5VyYfY3PUXWuz4E9JJJhw3sRv2dmhDxYnZd
         lWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=KYNLoM6OlEsOl9RGsNpTi6ZntIlmfhhXqJ1nIViCbJQ=;
        b=0iuVjdnNYTUknxDi4jhC1POzCMygh2vjTafopX3glnE/D3iY/QRZMjPDkvcwy+pkfz
         C0VttDE2ogIDb74sHr6Xx8/uWDeJ2qod+UzHz2N14X6Bp8q9+xDDE17XEcvsBsAYD4Oc
         pJmwbB4LFCE0EPvt0aqxeuZAJhKVa/d7DnB4ESOKF0S4yrju1bOgB7cvqG6Rhu+5HRVa
         Cb9XyTZ69VDt25ululN0neTP77IBHoC7hha3TnCaMJGfIynoPPJfJZYVTLfKi/JK94TG
         7XgVOgCQSTvmXyiLOJSeV4jrKaAZgNUNYaxNGIlXdrn+XHpjKqneeWw+9DTmW26Efx6B
         WSOw==
X-Gm-Message-State: AJIora+1myUQel8Y4ja6sATcrRV89a+KTDjJw6CFSppHSfN/f3/X1j5u
        mVbxvqshib7b6V9c9yX4SwmzGLIXEu6SLA==
X-Google-Smtp-Source: AGRyM1sJec17Ley3ioCU511oMWlFJPlqtB0xifo802yLKNfnlq8KmtHa1x+W/rHzggvvWIbJDak/zw==
X-Received: by 2002:a17:90b:38c3:b0:1ec:cb07:f216 with SMTP id nn3-20020a17090b38c300b001eccb07f216mr1823373pjb.168.1655955436339;
        Wed, 22 Jun 2022 20:37:16 -0700 (PDT)
Received: from localhost ([98.97.116.244])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902b69200b00168eb15f4c1sm13579227pls.210.2022.06.22.20.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 20:37:16 -0700 (PDT)
Date:   Wed, 22 Jun 2022 20:37:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Chuang W <nashuiliang@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Chuang W <nashuiliang@gmail.com>,
        Jingren Zhou <zhoujingren@didiglobal.com>
Message-ID: <62b3dfeae3f40_6a3b2208a3@john.notmuch>
In-Reply-To: <20220621073233.53776-1-nashuiliang@gmail.com>
References: <20220621073233.53776-1-nashuiliang@gmail.com>
Subject: RE: [PATCH v2] libbpf: Cleanup the kprobe_event on failed
 add_kprobe_event_legacy()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuang W wrote:
> Before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
> livepatch"), in a scenario where livepatch and kprobe coexist on the
> same function entry, the creation of kprobe_event using
> add_kprobe_event_legacy() will be successful, at the same time as a
> trace event (e.g. /debugfs/tracing/events/kprobe/XX) will exist, but
> perf_event_open() will return an error because both livepatch and kprobe
> use FTRACE_OPS_FL_IPMODIFY.
> 
> With this patch, whenever an error is returned after
> add_kprobe_event_legacy(), this ensures that the created kprobe_event is
> cleaned.
> 
> Signed-off-by: Chuang W <nashuiliang@gmail.com>
> Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
> ---
>  tools/lib/bpf/libbpf.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

I think we want to improve the commit message otherwise I'm sure we will
stumble on this in the future and from just above its tricky to follow.
I would suggest almost verbatim the description you gave in reply to
my question. Just cut'n'pasting your text together with minor edit
glue,

"
 The legacy kprobe API (i.e. tracefs API) has two steps:
 
 1) register_kprobe

 $ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events

 This will create a trace event of mykprobe and register a disable
 kprobe that waits to be activated.
 
 2) enable_kprobe

 2.1) using syscall perf_event_open as the following code,
 perf_event_kprobe_open_legacy (file: tools/lib/bpf/libbpf.c):
 ---
 attr.type = PERF_TYPE_TRACEPOINT;
 pfd = syscall(__NR_perf_event_open, &attr,
               pid < 0 ? -1 : pid, /* pid */
               pid == -1 ? 0 : -1, /* cpu */
               -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC);
 ---

 In the implementation code of perf_event_open, enable_kprobe() will be executed.

 2.2) using shell

 $ echo 1 > /sys/kernel/debug/tracing/events/kprobes/mykprobe/enable

 As with perf_event_open, enable_kprobe() will also be executed.
 
 When using the same function XXX, kprobe and livepatch cannot coexist,
 that is, step 2) will return an error (ref: arm_kprobe_ftrace()),
 however, step 1) is ok! The new kprobe API (i.e. perf kprobe API)
 aggregates register_kprobe and enable_kprobe, internally fixes the
 issue on failed enable_kprobe.

 To fix: before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
 livepatch"), in a scenario where livepatch and kprobe coexist on the
 same function entry, the creation of kprobe_event using
 add_kprobe_event_legacy() will be successful, at the same time as a
 trace event (e.g. /debugfs/tracing/events/kprobe/XX) will exist, but
 perf_event_open() will return an error because both livepatch and kprobe
 use FTRACE_OPS_FL_IPMODIFY.
 
 With this patch, whenever an error is returned after
 add_kprobe_event_legacy(), this ensures that the created kprobe_event is
 cleaned.
"

Thanks,
John
