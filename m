Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E8224AF4E
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHTGgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHTGgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:36:13 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394FBC061757;
        Wed, 19 Aug 2020 23:36:13 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id q3so542108ybp.7;
        Wed, 19 Aug 2020 23:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Eh4a8IZ8Vtaus1TpZa+JWR6Miwc2l245MjjJmRfgCc=;
        b=S2uqL2mxVaLh93eeNlkajjl7qMfPE8dd0INuememkGCzeZ3HLSm1Qj+WRPjD9zn//l
         BiIHChVn2L6Hkwzc5Z3NT4B7O374X7bm3Ci35AQs/hBwNkAiKeePAwebD6KDSXQHIuxk
         7964qTOPLkVhfssxuzhe3Dlb1MYmkAukQdoa6ub3KBJmKICvjjeC0GZSfFpM5gwBRD0n
         +bognHA/Lo+Bq9GO8AerN6yCxuFB2peS5+B9wt6IFEKUNCHZZygsWortv0oEQqLs2il5
         jLS61yQWrkRbglwrBl8K/9mwNpHkijqa/fgviScvpHjMUNn4RFUSJNs2J8SbPGtEURKy
         h3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Eh4a8IZ8Vtaus1TpZa+JWR6Miwc2l245MjjJmRfgCc=;
        b=jhmP2x2w+xZpJCk558rYEVZaqgAa5c6Bf7WgxoOZJdTRVZtSJ+b2PGsT24Gh8cIVfw
         put1vfBTr5ASBtSHo+Dbv8T/sgbEAG5oa+Fu0S3GgBKmAsk/nFj5epwowjSgdM1IYxH3
         22/whuxQMoLFruxx+/DDtTe1msqd/+f/QtnhIB5AHshnZDq5aJcB6YnaxEzulzzMLA8y
         KpLv4ShFHvvL7OY43mrW7B4dIhZsgucjrBZqgH8F5EXGTkSGNXn5SjhAIkg0Qa37rT58
         l6+9FypotR/NJ1KnNs90S2jKyLJFn34Gz49w7p8nH7LsAUxTlRUXkUQ1IxYhIU6MOUvQ
         9Flg==
X-Gm-Message-State: AOAM5302QHBckwynWj8X9zfJ1LebJeyYElOHVLRqJVvOxjAgrH5rcrzO
        KPoTu4DVYGOqemuz5d/3CXU+FCHrjNUEYij2mBw=
X-Google-Smtp-Source: ABdhPJxxVASbhatgTY7biEw4RWC6A99m35aG1fAl2ZFSmEuhDKZs6CLGq02tkgy72vmphJ33L2Nnnel0zGWm/9W2/wU=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr2736441ybk.230.1597905372297;
 Wed, 19 Aug 2020 23:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com> <1596724945-22859-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1596724945-22859-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Aug 2020 23:36:01 -0700
Message-ID: <CAEf4BzbZsFpGoD6=w__XVqS7w2NPWghhYe+QuBxhM25CaucHjg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/4] bpf: add bpf_trace_btf helper
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        andriy.shevchenko@linux.intel.com, Petr Mladek <pmladek@suse.com>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Andrey Ignatov <rdna@fb.com>, scott.branden@broadcom.com,
        Quentin Monnet <quentin@isovalent.com>,
        Carlos Neira <cneirabustos@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 1:24 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> A helper is added to support tracing kernel type information in BPF
> using the BPF Type Format (BTF).  Its signature is
>
> long bpf_trace_btf(struct btf_ptr *ptr, u32 btf_ptr_size, u32 trace_id,
>                    u64 flags);
>
> struct btf_ptr * specifies
>
> - a pointer to the data to be traced;
> - the BTF id of the type of data pointed to; or
> - a string representation of the type of data pointed to
> - a flags field is provided for future use; these flags
>   are not to be confused with the BTF_TRACE_F_* flags
>   below that control how the btf_ptr is displayed; the
>   flags member of the struct btf_ptr may be used to
>   disambiguate types in kernel versus module BTF, etc;
>   the main distinction is the flags relate to the type
>   and information needed in identifying it; not how it
>   is displayed.
>
> The helper also specifies a trace id which is set for the
> bpf_trace_printk tracepoint; this allows BPF programs
> to filter on specific trace ids, ensuring output does
> not become mixed between different traced events and
> hard to read.
>
> For example a BPF program with a struct sk_buff *skb
> could do the following:
>
>         static const char *skb_type = "struct sk_buff";
>         static struct btf_ptr b = { };
>
>         b.ptr = skb;
>         b.type = skb_type;
>         bpf_trace_btf(&b, sizeof(b), 0, 0);
>
> Default output in the trace_pipe looks like this:
>
>           <idle>-0     [023] d.s.  1825.778400: bpf_trace_printk: (struct sk_buff){
>           <idle>-0     [023] d.s.  1825.778409: bpf_trace_printk:  (union){
>           <idle>-0     [023] d.s.  1825.778410: bpf_trace_printk:   (struct){
>           <idle>-0     [023] d.s.  1825.778412: bpf_trace_printk:    .prev = (struct sk_buff *)0x00000000b2a3df7e,
>           <idle>-0     [023] d.s.  1825.778413: bpf_trace_printk:    (union){
>           <idle>-0     [023] d.s.  1825.778414: bpf_trace_printk:     .dev = (struct net_device *)0x000000001658808b,
>           <idle>-0     [023] d.s.  1825.778416: bpf_trace_printk:     .dev_scratch = (long unsigned int)18446628460391432192,
>           <idle>-0     [023] d.s.  1825.778417: bpf_trace_printk:    },
>           <idle>-0     [023] d.s.  1825.778417: bpf_trace_printk:   },
>           <idle>-0     [023] d.s.  1825.778418: bpf_trace_printk:   .rbnode = (struct rb_node){
>           <idle>-0     [023] d.s.  1825.778419: bpf_trace_printk:    .rb_right = (struct rb_node *)0x00000000b2a3df7e,
>           <idle>-0     [023] d.s.  1825.778420: bpf_trace_printk:    .rb_left = (struct rb_node *)0x000000001658808b,
>           <idle>-0     [023] d.s.  1825.778420: bpf_trace_printk:   },
>           <idle>-0     [023] d.s.  1825.778421: bpf_trace_printk:   .list = (struct list_head){
>           <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:    .prev = (struct list_head *)0x00000000b2a3df7e,
>           <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:   },
>           <idle>-0     [023] d.s.  1825.778422: bpf_trace_printk:  },
>           <idle>-0     [023] d.s.  1825.778426: bpf_trace_printk:  .len = (unsigned int)168,
>           <idle>-0     [023] d.s.  1825.778427: bpf_trace_printk:  .mac_len = (__u16)14,
>           <idle>-0     [023] d.s.  1825.778428: bpf_trace_printk:  .queue_mapping = (__u16)17,
>           <idle>-0     [023] d.s.  1825.778430: bpf_trace_printk:  .head_frag = (__u8)0x1,
>           <idle>-0     [023] d.s.  1825.778431: bpf_trace_printk:  .ip_summed = (__u8)0x1,
>           <idle>-0     [023] d.s.  1825.778432: bpf_trace_printk:  .l4_hash = (__u8)0x1,
>           <idle>-0     [023] d.s.  1825.778433: bpf_trace_printk:  .hash = (__u32)1873247608,
>           <idle>-0     [023] d.s.  1825.778434: bpf_trace_printk:  (union){
>           <idle>-0     [023] d.s.  1825.778435: bpf_trace_printk:   .napi_id = (unsigned int)8209,
>           <idle>-0     [023] d.s.  1825.778436: bpf_trace_printk:   .sender_cpu = (unsigned int)8209,
>           <idle>-0     [023] d.s.  1825.778436: bpf_trace_printk:  },
>           <idle>-0     [023] d.s.  1825.778437: bpf_trace_printk:  .protocol = (__be16)8,
>           <idle>-0     [023] d.s.  1825.778438: bpf_trace_printk:  .transport_header = (__u16)226,
>           <idle>-0     [023] d.s.  1825.778439: bpf_trace_printk:  .network_header = (__u16)206,
>           <idle>-0     [023] d.s.  1825.778440: bpf_trace_printk:  .mac_header = (__u16)192,
>           <idle>-0     [023] d.s.  1825.778440: bpf_trace_printk:  .tail = (sk_buff_data_t)374,
>           <idle>-0     [023] d.s.  1825.778441: bpf_trace_printk:  .end = (sk_buff_data_t)1728,
>           <idle>-0     [023] d.s.  1825.778442: bpf_trace_printk:  .head = (unsigned char *)0x000000009798cb6b,
>           <idle>-0     [023] d.s.  1825.778443: bpf_trace_printk:  .data = (unsigned char *)0x0000000064823282,
>           <idle>-0     [023] d.s.  1825.778444: bpf_trace_printk:  .truesize = (unsigned int)2304,
>           <idle>-0     [023] d.s.  1825.778445: bpf_trace_printk:  .users = (refcount_t){
>           <idle>-0     [023] d.s.  1825.778445: bpf_trace_printk:   .refs = (atomic_t){
>           <idle>-0     [023] d.s.  1825.778447: bpf_trace_printk:    .counter = (int)1,
>           <idle>-0     [023] d.s.  1825.778447: bpf_trace_printk:   },
>           <idle>-0     [023] d.s.  1825.778447: bpf_trace_printk:  },
>           <idle>-0     [023] d.s.  1825.778448: bpf_trace_printk: }
>
> Flags modifying display are as follows:
>
> - BTF_TRACE_F_COMPACT:  no formatting around type information
> - BTF_TRACE_F_NONAME:   no struct/union member names/types
> - BTF_TRACE_F_PTR_RAW:  show raw (unobfuscated) pointer values;
>                         equivalent to %px.
> - BTF_TRACE_F_ZERO:     show zero-valued struct/union members;
>                         they are not displayed by default
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  include/linux/bpf.h            |   1 +
>  include/linux/btf.h            |   9 ++--
>  include/uapi/linux/bpf.h       |  63 +++++++++++++++++++++++++
>  kernel/bpf/core.c              |   5 ++
>  kernel/bpf/helpers.c           |   4 ++
>  kernel/trace/bpf_trace.c       | 102 ++++++++++++++++++++++++++++++++++++++++-
>  scripts/bpf_helpers_doc.py     |   2 +
>  tools/include/uapi/linux/bpf.h |  63 +++++++++++++++++++++++++
>  8 files changed, 243 insertions(+), 6 deletions(-)
>

[...]

> +/*
> + * struct btf_ptr is used for typed pointer display; the
> + * additional type string/BTF type id are used to render the pointer
> + * data as the appropriate type via the bpf_trace_btf() helper
> + * above.  A flags field - potentially to specify additional details
> + * about the BTF pointer (rather than its mode of display) - is
> + * present for future use.  Display flags - BTF_TRACE_F_* - are
> + * passed to display functions separately.
> + */
> +struct btf_ptr {
> +       void *ptr;
> +       const char *type;
> +       __u32 type_id;
> +       __u32 flags;            /* BTF ptr flags; unused at present. */
> +};

Would it be possible to just utilize __builtin_btf_type_id() to pass
BTF type id directly, without this string -> BTF type translation?
Please check [0] to see if that would make sense here. Thanks.

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200819194519.3375898-4-andriin@fb.com/

[...]
