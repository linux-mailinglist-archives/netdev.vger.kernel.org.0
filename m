Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7B9690D24
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjBIPit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjBIPir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:38:47 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440C483CB;
        Thu,  9 Feb 2023 07:38:22 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id 206so970324qkl.12;
        Thu, 09 Feb 2023 07:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nqqvLh7HAoa+FDvCfaON3zRI1jJ2//giHKq3hNkcBj0=;
        b=kY6hjHr/DFhUA1l47vIS/cvQ5NP0F1o5H8EK0HuTNsc8sPGcDkubgp8bgWLVM9r+dF
         Y4Xb7LIvTyM72kSgKN5Xnq2J417EhpSfpnuhMNPwmnjm4t0bhwa/gLnKN5+0dTgK8ady
         8Fi4J5uljfDsNfnKGVdRLDMKMQ3HyFXBUmVJ1vMDTTGD0s456NDFPTIu3raaqQK9ixj+
         xXvIR5OvTN7mww22JiLFVo0qQJo7PscQ7+VJcJBPXtc574NB2Nck8HVCM9ZphkNb//sT
         Sgl3XmmqrI9AlZGIB0qxoatAIC96S+o13u75mGbj208DbAVON+cZKHe7a1sjH636YDOL
         lVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nqqvLh7HAoa+FDvCfaON3zRI1jJ2//giHKq3hNkcBj0=;
        b=PQbAPFSWtpN0RgtDKG8VCCL406ij7mPpBQkzQVUz7Y6Me8OLRC42gN8uWSFzHQCc1w
         IArYF/nzNazb2irlyPjJDL7+a7UT6Ii3PhI9SWBOOgZATFksm3lWGJZEtLVnzd4wLYPd
         6q/dm7BCCozRVtqGHndbBvSNWs7rCd41X5nlJPeW7/3yTPScpSYjNYpeVEInjLnZTL/y
         soVnsKJKVwEUCRvMO25VAwumWym85ItaWl0uM9hlmdQgdGcipzpkHJSv+L9iJT3Hh9Uq
         JDqWdh3uc2bizAGjaqXqs5U3We15hfx4g1x8aTBDfJDMZx9w1JY4k3Gm1QiSEOdsnBUR
         zLMA==
X-Gm-Message-State: AO0yUKU955RtnB1qrUCrSAz8AWRc+6NrPkaijV2RK9a5qtycrnPdoZ5V
        Kh5+cfCnAZTo6RrBoH+akRBXZ5FYJ1BlqjNeEsk=
X-Google-Smtp-Source: AK7set8EyvLt35PfyAuI2zkXQM7AFmrSKGHb43oH1I677tcoQxsMfqYgrFEdE61TZWkv9dIACwut1de/gnqRXHzPWfM=
X-Received: by 2002:a37:654f:0:b0:71d:d358:d19f with SMTP id
 z76-20020a37654f000000b0071dd358d19fmr1300669qkb.220.1675957101281; Thu, 09
 Feb 2023 07:38:21 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <Y+QaZtz55LIirsUO@google.com> <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
 <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
 <08e1c9d0-376f-d669-6fe8-559b2fbc2f2b@efficios.com> <CALOAHbBsmajStJ8TrnqEL_pv=UOt-vv0CH30EqThVq=JYXfi8A@mail.gmail.com>
 <Y+UCxSktKM0CzMlA@e126311.manchester.arm.com>
In-Reply-To: <Y+UCxSktKM0CzMlA@e126311.manchester.arm.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 9 Feb 2023 23:37:44 +0800
Message-ID: <CALOAHbCdNZ21oBE2ii_XBxecYLSxM7Ws2LRMirdEOpeULiNk4g@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 9, 2023 at 10:28 PM Kajetan Puchalski
<kajetan.puchalski@arm.com> wrote:
>
> On Thu, Feb 09, 2023 at 02:20:36PM +0800, Yafang Shao wrote:
>
> [...]
>
> Hi Yafang,
>
> > Many thanks for the detailed analysis. Seems it can work.
> >
> > Hi John,
> >
> > Could you pls. try the attached fix ? I have verified it in my test env.
>
> I tested the patch on my environment where I found the issue with newer
> kernels + older Perfetto. The patch does improve things so that's nice.

Thanks for the test. I don't have Perfetto in hand, so I haven't
verify Perfetto.

> It goes from "not working at all" to "mostly working but missing data"
> compared to what happens if I just revert 3087c61ed2c48548b74dd343a5209b87082c682d.
>

Do you mean there are no errors at all if revert
3087c61ed2c48548b74dd343a5209b87082c682d ?

> I'm just an end user so can't really speak to the underlying causes but
> for those more familiar with how Perfetto works this is what I'm getting:
>

The sched_switch tracepoint format file has the same output with
reverting the commit,

$ cat /sys/kernel/debug/tracing/events/sched/sched_switch/format
name: sched_switch
ID: 286
format:
field:unsigned short common_type; offset:0; size:2; signed:0;
field:unsigned char common_flags; offset:2; size:1; signed:0;
field:unsigned char common_preempt_count; offset:3; size:1; signed:0;
field:int common_pid; offset:4; size:4; signed:1;
field:char prev_comm[16]; offset:8; size:16; signed:0;
field:pid_t prev_pid; offset:24; size:4; signed:1;
field:int prev_prio; offset:28; size:4; signed:1;
field:long prev_state; offset:32; size:8; signed:1;
field:char next_comm[16]; offset:40; size:16; signed:0;
field:pid_t next_pid; offset:56; size:4; signed:1;
field:int next_prio; offset:60; size:4; signed:1;

print fmt: "prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==>
next_comm=%s next_pid=%d next_prio=%d", REC->prev_comm, REC->prev_pid,
REC->prev_prio, (REC->prev_state & ((((0x00000000 | 0x00000001 |
0x00000002 | 0x00000004 | 0x00000008 | 0x00000010 | 0x00000020 |
0x00000040) + 1) << 1) - 1)) ? __print_flags(REC->prev_state &
((((0x00000000 | 0x00000001 | 0x00000002 | 0x00000004 | 0x00000008 |
0x00000010 | 0x00000020 | 0x00000040) + 1) << 1) - 1), "|", {
0x00000001, "S" }, { 0x00000002, "D" }, { 0x00000004, "T" }, {
0x00000008, "t" }, { 0x00000010, "X" }, { 0x00000020, "Z" }, {
0x00000040, "P" }, { 0x00000080, "I" }) : "R", REC->prev_state &
(((0x00000000 | 0x00000001 | 0x00000002 | 0x00000004 | 0x00000008 |
0x00000010 | 0x00000020 | 0x00000040) + 1) << 1) ? "+" : "",
REC->next_comm, REC->next_pid, REC->next_prio

So may be these errors were caused by other issues ?

> Error stats for this trace:
>                                     name                                      idx                                   source                                    value
> ---------------------------------------- ---------------------------------------- ---------------------------------------- ----------------------------------------
> mismatched_sched_switch_tids             [NULL]                                   analysis                                                                    11101
> systrace_parse_failure                   [NULL]                                   analysis                                                                    19040
>
> The trace explorer window ends up containing the ftrace-specific tracks
> but missing the tracks related to Android-specific callbacks and such.
>
> Debug stats below in case they're relevant:
>
> Name    Value   Type
> android_br_parse_errors 0       error (trace)
> android_log_format_invalid      0       error (trace)
> android_log_num_failed  0       error (trace)
> android_log_num_skipped 0       info (trace)
> android_log_num_total   0       info (trace)
> clock_sync_cache_miss   181     info (analysis)
> clock_sync_failure      0       error (analysis)
> compact_sched_has_parse_errors  0       error (trace)
> compact_sched_switch_skipped    0       info (analysis)
> compact_sched_waking_skipped    0       info (analysis)
> counter_events_out_of_order     0       error (analysis)
> deobfuscate_location_parse_error        0       error (trace)
> empty_chrome_metadata   0       error (trace)
> energy_breakdown_missing_values 0       error (analysis)
> energy_descriptor_invalid       0       error (analysis)
> energy_uid_breakdown_missing_values     0       error (analysis)
> flow_duplicate_id       0       error (trace)
> flow_end_without_start  0       info (trace)
> flow_invalid_id 0       error (trace)
> flow_no_enclosing_slice 0       error (trace)
> flow_step_without_start 0       info (trace)
> flow_without_direction  0       error (trace)
> frame_timeline_event_parser_errors      0       info (analysis)
> ftrace_bundle_tokenizer_errors  0       error (analysis)
> ftrace_cpu_bytes_read_begin[0]  0       info (trace)
> ftrace_cpu_bytes_read_begin[1]  264     info (trace)
> ftrace_cpu_bytes_read_begin[2]  0       info (trace)
> ftrace_cpu_bytes_read_begin[3]  224     info (trace)
> ftrace_cpu_bytes_read_begin[4]  0       info (trace)
> ftrace_cpu_bytes_read_begin[5]  0       info (trace)
> ftrace_cpu_bytes_read_begin[6]  0       info (trace)
> ftrace_cpu_bytes_read_begin[7]  0       info (trace)
> ftrace_cpu_bytes_read_delta[0]  6919836 info (trace)
> ftrace_cpu_bytes_read_delta[1]  7197556 info (trace)
> ftrace_cpu_bytes_read_delta[2]  6381828 info (trace)
> ftrace_cpu_bytes_read_delta[3]  5988336 info (trace)
> ftrace_cpu_bytes_read_delta[4]  5933528 info (trace)
> ftrace_cpu_bytes_read_delta[5]  4858400 info (trace)
> ftrace_cpu_bytes_read_delta[6]  6175260 info (trace)
> ftrace_cpu_bytes_read_delta[7]  4633460 info (trace)
> ftrace_cpu_bytes_read_end[0]    6919836 info (trace)
> ftrace_cpu_bytes_read_end[1]    7197820 info (trace)
> ftrace_cpu_bytes_read_end[2]    6381828 info (trace)
> ftrace_cpu_bytes_read_end[3]    5988560 info (trace)
> ftrace_cpu_bytes_read_end[4]    5933528 info (trace)
> ftrace_cpu_bytes_read_end[5]    4858400 info (trace)
> ftrace_cpu_bytes_read_end[6]    6175260 info (trace)
> ftrace_cpu_bytes_read_end[7]    4633460 info (trace)
> ftrace_cpu_commit_overrun_begin[0]      0       info (trace)
> ftrace_cpu_commit_overrun_begin[1]      0       info (trace)
> ftrace_cpu_commit_overrun_begin[2]      0       info (trace)
> ftrace_cpu_commit_overrun_begin[3]      0       info (trace)
> ftrace_cpu_commit_overrun_begin[4]      0       info (trace)
> ftrace_cpu_commit_overrun_begin[5]      0       info (trace)
> ftrace_cpu_commit_overrun_begin[6]      0       info (trace)
> ftrace_cpu_commit_overrun_begin[7]      0       info (trace)
> ftrace_cpu_commit_overrun_delta[0]      0       error (trace)
> ftrace_cpu_commit_overrun_delta[1]      0       error (trace)
> ftrace_cpu_commit_overrun_delta[2]      0       error (trace)
> ftrace_cpu_commit_overrun_delta[3]      0       error (trace)
> ftrace_cpu_commit_overrun_delta[4]      0       error (trace)
> ftrace_cpu_commit_overrun_delta[5]      0       error (trace)
> ftrace_cpu_commit_overrun_delta[6]      0       error (trace)
> ftrace_cpu_commit_overrun_delta[7]      0       error (trace)
> ftrace_cpu_commit_overrun_end[0]        0       info (trace)
> ftrace_cpu_commit_overrun_end[1]        0       info (trace)
> ftrace_cpu_commit_overrun_end[2]        0       info (trace)
> ftrace_cpu_commit_overrun_end[3]        0       info (trace)
> ftrace_cpu_commit_overrun_end[4]        0       info (trace)
> ftrace_cpu_commit_overrun_end[5]        0       info (trace)
> ftrace_cpu_commit_overrun_end[6]        0       info (trace)
> ftrace_cpu_commit_overrun_end[7]        0       info (trace)
> ftrace_cpu_dropped_events_begin[0]      0       info (trace)
> ftrace_cpu_dropped_events_begin[1]      0       info (trace)
> ftrace_cpu_dropped_events_begin[2]      0       info (trace)
> ftrace_cpu_dropped_events_begin[3]      0       info (trace)
> ftrace_cpu_dropped_events_begin[4]      0       info (trace)
> ftrace_cpu_dropped_events_begin[5]      0       info (trace)
> ftrace_cpu_dropped_events_begin[6]      0       info (trace)
> ftrace_cpu_dropped_events_begin[7]      0       info (trace)
> ftrace_cpu_dropped_events_delta[0]      0       error (trace)
> ftrace_cpu_dropped_events_delta[1]      0       error (trace)
> ftrace_cpu_dropped_events_delta[2]      0       error (trace)
> ftrace_cpu_dropped_events_delta[3]      0       error (trace)
> ftrace_cpu_dropped_events_delta[4]      0       error (trace)
> ftrace_cpu_dropped_events_delta[5]      0       error (trace)
> ftrace_cpu_dropped_events_delta[6]      0       error (trace)
> ftrace_cpu_dropped_events_delta[7]      0       error (trace)
> ftrace_cpu_dropped_events_end[0]        0       info (trace)
> ftrace_cpu_dropped_events_end[1]        0       info (trace)
> ftrace_cpu_dropped_events_end[2]        0       info (trace)
> ftrace_cpu_dropped_events_end[3]        0       info (trace)
> ftrace_cpu_dropped_events_end[4]        0       info (trace)
> ftrace_cpu_dropped_events_end[5]        0       info (trace)
> ftrace_cpu_dropped_events_end[6]        0       info (trace)
> ftrace_cpu_dropped_events_end[7]        0       info (trace)
> ftrace_cpu_entries_begin[0]     0       info (trace)
> ftrace_cpu_entries_begin[1]     6       info (trace)
> ftrace_cpu_entries_begin[2]     0       info (trace)
> ftrace_cpu_entries_begin[3]     5       info (trace)
> ftrace_cpu_entries_begin[4]     0       info (trace)
> ftrace_cpu_entries_begin[5]     0       info (trace)
> ftrace_cpu_entries_begin[6]     0       info (trace)
> ftrace_cpu_entries_begin[7]     0       info (trace)
> ftrace_cpu_entries_delta[0]     6       info (trace)
> ftrace_cpu_entries_delta[1]     -6      info (trace)
> ftrace_cpu_entries_delta[2]     0       info (trace)
> ftrace_cpu_entries_delta[3]     2       info (trace)
> ftrace_cpu_entries_delta[4]     0       info (trace)
> ftrace_cpu_entries_delta[5]     0       info (trace)
> ftrace_cpu_entries_delta[6]     0       info (trace)
> ftrace_cpu_entries_delta[7]     0       info (trace)
> ftrace_cpu_entries_end[0]       6       info (trace)
> ftrace_cpu_entries_end[1]       0       info (trace)
> ftrace_cpu_entries_end[2]       0       info (trace)
> ftrace_cpu_entries_end[3]       7       info (trace)
> ftrace_cpu_entries_end[4]       0       info (trace)
> ftrace_cpu_entries_end[5]       0       info (trace)
> ftrace_cpu_entries_end[6]       0       info (trace)
> ftrace_cpu_entries_end[7]       0       info (trace)
> ftrace_cpu_now_ts_begin[0]      93305027000     info (trace)
> ftrace_cpu_now_ts_begin[1]      93305103000     info (trace)
> ftrace_cpu_now_ts_begin[2]      93305159000     info (trace)
> ftrace_cpu_now_ts_begin[3]      93305207000     info (trace)
> ftrace_cpu_now_ts_begin[4]      93305262000     info (trace)
> ftrace_cpu_now_ts_begin[5]      93305312000     info (trace)
> ftrace_cpu_now_ts_begin[6]      93305362000     info (trace)
> ftrace_cpu_now_ts_begin[7]      93305411000     info (trace)
> ftrace_cpu_now_ts_end[0]        282906571000    info (trace)
> ftrace_cpu_now_ts_end[1]        282906676000    info (trace)
> ftrace_cpu_now_ts_end[2]        282906738000    info (trace)
> ftrace_cpu_now_ts_end[3]        282906803000    info (trace)
> ftrace_cpu_now_ts_end[4]        282906863000    info (trace)
> ftrace_cpu_now_ts_end[5]        282906925000    info (trace)
> ftrace_cpu_now_ts_end[6]        282906987000    info (trace)
> ftrace_cpu_now_ts_end[7]        282907048000    info (trace)
> ftrace_cpu_oldest_event_ts_begin[0]     0       info (trace)
> ftrace_cpu_oldest_event_ts_begin[1]     93304642000     info (trace)
> ftrace_cpu_oldest_event_ts_begin[2]     0       info (trace)
> ftrace_cpu_oldest_event_ts_begin[3]     93304876000     info (trace)
> ftrace_cpu_oldest_event_ts_begin[4]     0       info (trace)
> ftrace_cpu_oldest_event_ts_begin[5]     0       info (trace)
> ftrace_cpu_oldest_event_ts_begin[6]     0       info (trace)
> ftrace_cpu_oldest_event_ts_begin[7]     0       info (trace)
> ftrace_cpu_oldest_event_ts_end[0]       282905715000    info (trace)
> ftrace_cpu_oldest_event_ts_end[1]       282903723000    info (trace)
> ftrace_cpu_oldest_event_ts_end[2]       282903881000    info (trace)
> ftrace_cpu_oldest_event_ts_end[3]       282816175000    info (trace)
> ftrace_cpu_oldest_event_ts_end[4]       282896619000    info (trace)
> ftrace_cpu_oldest_event_ts_end[5]       282884168000    info (trace)
> ftrace_cpu_oldest_event_ts_end[6]       282783221000    info (trace)
> ftrace_cpu_oldest_event_ts_end[7]       282880081000    info (trace)
> ftrace_cpu_overrun_begin[0]     0       info (trace)
> ftrace_cpu_overrun_begin[1]     0       info (trace)
> ftrace_cpu_overrun_begin[2]     0       info (trace)
> ftrace_cpu_overrun_begin[3]     0       info (trace)
> ftrace_cpu_overrun_begin[4]     0       info (trace)
> ftrace_cpu_overrun_begin[5]     0       info (trace)
> ftrace_cpu_overrun_begin[6]     0       info (trace)
> ftrace_cpu_overrun_begin[7]     0       info (trace)
> ftrace_cpu_overrun_delta[0]help_outline 0       data_loss (trace)
> ftrace_cpu_overrun_delta[1]help_outline 0       data_loss (trace)
> ftrace_cpu_overrun_delta[2]help_outline 0       data_loss (trace)
> ftrace_cpu_overrun_delta[3]help_outline 0       data_loss (trace)
> ftrace_cpu_overrun_delta[4]help_outline 0       data_loss (trace)
> ftrace_cpu_overrun_delta[5]help_outline 0       data_loss (trace)
> ftrace_cpu_overrun_delta[6]help_outline 0       data_loss (trace)
> ftrace_cpu_overrun_delta[7]help_outline 0       data_loss (trace)
> ftrace_cpu_overrun_end[0]       0       info (trace)
> ftrace_cpu_overrun_end[1]       0       info (trace)
> ftrace_cpu_overrun_end[2]       0       info (trace)
> ftrace_cpu_overrun_end[3]       0       info (trace)
> ftrace_cpu_overrun_end[4]       0       info (trace)
> ftrace_cpu_overrun_end[5]       0       info (trace)
> ftrace_cpu_overrun_end[6]       0       info (trace)
> ftrace_cpu_overrun_end[7]       0       info (trace)
> ftrace_cpu_read_events_begin[0] 0       info (trace)
> ftrace_cpu_read_events_begin[1] 0       info (trace)
> ftrace_cpu_read_events_begin[2] 0       info (trace)
> ftrace_cpu_read_events_begin[3] 0       info (trace)
> ftrace_cpu_read_events_begin[4] 0       info (trace)
> ftrace_cpu_read_events_begin[5] 0       info (trace)
> ftrace_cpu_read_events_begin[6] 0       info (trace)
> ftrace_cpu_read_events_begin[7] 0       info (trace)
> ftrace_cpu_read_events_delta[0] 454848  info (trace)
> ftrace_cpu_read_events_delta[1] 453484  info (trace)
> ftrace_cpu_read_events_delta[2] 386290  info (trace)
> ftrace_cpu_read_events_delta[3] 356432  info (trace)
> ftrace_cpu_read_events_delta[4] 393337  info (trace)
> ftrace_cpu_read_events_delta[5] 325244  info (trace)
> ftrace_cpu_read_events_delta[6] 392637  info (trace)
> ftrace_cpu_read_events_delta[7] 350623  info (trace)
> ftrace_cpu_read_events_end[0]   454848  info (trace)
> ftrace_cpu_read_events_end[1]   453484  info (trace)
> ftrace_cpu_read_events_end[2]   386290  info (trace)
> ftrace_cpu_read_events_end[3]   356432  info (trace)
> ftrace_cpu_read_events_end[4]   393337  info (trace)
> ftrace_cpu_read_events_end[5]   325244  info (trace)
> ftrace_cpu_read_events_end[6]   392637  info (trace)
> ftrace_cpu_read_events_end[7]   350623  info (trace)
> ftrace_packet_before_tracing_starthelp_outline  0       info (analysis)
> ftrace_setup_errorshelp_outline 0       error (trace)
> fuchsia_invalid_event   0       error (analysis)
> fuchsia_non_numeric_counters    0       error (analysis)
> fuchsia_timestamp_overflow      0       error (analysis)
> game_intervention_has_parse_errorshelp_outline  0       error (trace)
> game_intervention_has_read_errorshelp_outline   0       error (trace)
> gpu_counters_invalid_spec       0       error (analysis)
> gpu_counters_missing_spec       0       error (analysis)
> gpu_render_stage_parser_errors  0       error (analysis)
> graphics_frame_event_parser_errors      0       info (analysis)
> guess_trace_type_duration_ns    7654    info (analysis)
> heap_graph_non_finalized_graph  0       error (trace)
> heapprofd_missing_packet        0       error (trace)
> heapprofd_non_finalized_profile 0       error (trace)
> interned_data_tokenizer_errors  0       info (analysis)
> invalid_clock_snapshots 0       error (analysis)
> invalid_cpu_times       0       error (analysis)
> json_display_time_unithelp_outline      0       info (trace)
> json_parser_failure     0       error (trace)
> json_tokenizer_failure  0       error (trace)
> meminfo_unknown_keys    0       error (analysis)
> memory_snapshot_parser_failure  0       error (analysis)
> metatrace_overruns      0       error (trace)
> mismatched_sched_switch_tids    11101   error (analysis)
> misplaced_end_event     0       data_loss (analysis)
> mm_unknown_type 0       error (analysis)
> ninja_parse_errors      0       error (trace)
> packages_list_has_parse_errors  0       error (trace)
> packages_list_has_read_errors   0       error (trace)
> parse_trace_duration_ns 1780589548      info (analysis)
> perf_samples_skipped    0       info (trace)
> perf_samples_skipped_dataloss   0       data_loss (trace)
> power_rail_unknown_index        0       error (trace)
> proc_stat_unknown_counters      0       error (analysis)
> process_tracker_errors  0       error (analysis)
> rss_stat_negative_size  0       info (analysis)
> rss_stat_unknown_keys   0       error (analysis)
> rss_stat_unknown_thread_for_mm_id       0       info (analysis)
> sched_switch_out_of_order       0       error (analysis)
> sched_waking_out_of_order       0       error (analysis)
> slice_out_of_order      0       error (analysis)
> sorter_push_event_out_of_orderhelp_outline      0       error (trace)
> stackprofile_invalid_callstack_id       0       error (trace)
> stackprofile_invalid_frame_id   0       error (trace)
> stackprofile_invalid_mapping_id 0       error (trace)
> stackprofile_invalid_string_id  0       error (trace)
> stackprofile_parser_error       0       error (trace)
> symbolization_tmp_build_id_not_foundhelp_outline        0       error (analysis)
> systrace_parse_failure  19040   error (analysis)
> task_state_invalid      0       error (analysis)
> thread_time_in_state_out_of_order       0       error (analysis)
> thread_time_in_state_unknown_cpu_freq   0       error (analysis)
> tokenizer_skipped_packets       0       info (analysis)
> traced_buf_abi_violations[0]    0       data_loss (trace)
> traced_buf_abi_violations[1]    0       data_loss (trace)
> traced_buf_buffer_size[0]       534773760       info (trace)
> traced_buf_buffer_size[1]       2097152 info (trace)
> traced_buf_bytes_overwritten[0] 0       info (trace)
> traced_buf_bytes_overwritten[1] 0       info (trace)
> traced_buf_bytes_read[0]        78929920        info (trace)
> traced_buf_bytes_read[1]        425984  info (trace)
> traced_buf_bytes_written[0]     78962688        info (trace)
> traced_buf_bytes_written[1]     425984  info (trace)
> traced_buf_chunks_committed_out_of_order[0]     0       info (trace)
> traced_buf_chunks_committed_out_of_order[1]     0       info (trace)
> traced_buf_chunks_discarded[0]  0       info (trace)
> traced_buf_chunks_discarded[1]  0       info (trace)
> traced_buf_chunks_overwritten[0]        0       info (trace)
> traced_buf_chunks_overwritten[1]        0       info (trace)
> traced_buf_chunks_read[0]       2428    info (trace)
> traced_buf_chunks_read[1]       13      info (trace)
> traced_buf_chunks_rewritten[0]  6       info (trace)
> traced_buf_chunks_rewritten[1]  0       info (trace)
> traced_buf_chunks_written[0]    2429    info (trace)
> traced_buf_chunks_written[1]    13      info (trace)
> traced_buf_padding_bytes_cleared[0]     0       info (trace)
> traced_buf_padding_bytes_cleared[1]     0       info (trace)
> traced_buf_padding_bytes_written[0]     0       info (trace)
> traced_buf_padding_bytes_written[1]     0       info (trace)
> traced_buf_patches_failed[0]    0       data_loss (trace)
> traced_buf_patches_failed[1]    0       data_loss (trace)
> traced_buf_patches_succeeded[0] 5633    info (trace)
> traced_buf_patches_succeeded[1] 8       info (trace)
> traced_buf_readaheads_failed[0] 115     info (trace)
> traced_buf_readaheads_failed[1] 18      info (trace)
> traced_buf_readaheads_succeeded[0]      2257    info (trace)
> traced_buf_readaheads_succeeded[1]      6       info (trace)
> traced_buf_trace_writer_packet_loss[0]  0       data_loss (trace)
> traced_buf_trace_writer_packet_loss[1]  0       data_loss (trace)
> traced_buf_write_wrap_count[0]  0       info (trace)
> traced_buf_write_wrap_count[1]  0       info (trace)
> traced_chunks_discarded 0       info (trace)
> traced_data_sources_registered  16      info (trace)
> traced_data_sources_seen        6       info (trace)
> traced_final_flush_failed       0       data_loss (trace)
> traced_final_flush_succeeded    0       info (trace)
> traced_flushes_failed   0       data_loss (trace)
> traced_flushes_requested        0       info (trace)
> traced_flushes_succeeded        0       info (trace)
> traced_patches_discarded        0       info (trace)
> traced_producers_connected      3       info (trace)
> traced_producers_seen   3       info (trace)
> traced_total_buffers    2       info (trace)
> traced_tracing_sessions 1       info (trace)
> track_event_dropped_packets_outside_of_range_of_interesthelp_outline    0       info (analysis)
> track_event_parser_errors       0       info (analysis)
> track_event_thread_invalid_endhelp_outline      0       error (trace)
> track_event_tokenizer_errors    0       info (analysis)
> truncated_sys_write_durationhelp_outline        0       data_loss (analysis)
> unknown_extension_fieldshelp_outline    0       error (trace)
> vmstat_unknown_keys     0       error (analysis)
> vulkan_allocations_invalid_string_id    0       error (trace)
>
> > --
> > Regards
> > Yafang
>
>


-- 
Regards
Yafang
