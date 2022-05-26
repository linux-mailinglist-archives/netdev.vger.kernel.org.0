Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCB4534909
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 04:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbiEZCu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 22:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbiEZCuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 22:50:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD82AF31D;
        Wed, 25 May 2022 19:50:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h11so233898eda.8;
        Wed, 25 May 2022 19:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+PxzJ0mEkdSYF8ZjesaHmXDjlnXJp4NiQPsBWw5HWTw=;
        b=eTR1/DCpjWjhflcy7UMBGhaeo9LNiJU7skGJ/APkyeUlQqKhQoScv8nlTSKYz/qqu3
         z0NhXmE5nsY09lvLYmSz1YoiCwympZevo38uUDE43h5ngJiddy1qw21tAlF+rW6Qpy0A
         lAdnzXFFcpzkYFTOyrb40JThwqv8tgteFAHU3IsgMwdc7w4RleGB1QRQYqcy8gbq5XX6
         1xuWCurzHRL4j2A37mgQuquPG37OCvx6fzf1sqPD6tV2t+IJO9kk4gEiOsDPk3W2hwGz
         2PN17hAI/3+/T1aJacmv2BGHT2pqIQt3lOTozZ/s/T59OCL+jkPSNi0oy1WV6Rgp18FU
         S+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+PxzJ0mEkdSYF8ZjesaHmXDjlnXJp4NiQPsBWw5HWTw=;
        b=y6w2JlSI58f1cUCZk/UmolytuqULy32Wki0hOjPuF5LR5kFa+YO+/c89NwZO0NsSrD
         eOxjxsqOheWo8QD9lnqEzDq4kFUEpyIvqyreL5tidwrbr/66QAmIl2busJvVreTPOiDm
         NpoGhn7iSwmB/y0TuCL0EnQhLsIk9053wvTN9bOYloBC0LbpsWmbjuHvSWOWQJgo0WIr
         Vydi9/sq/9/bsoXGmpRmKaaEaG+0juRQCE8ojT+m2AFu2+oWwzQwwVOpXJB1f5oLHiVM
         iNsLumrEZ72XU3ieJeNiUH1nDYL/HMzpGzP7L5y5RRa0Ga1v0kNwvOy0BO48R9cp0dpS
         fgCQ==
X-Gm-Message-State: AOAM533+w4i+zQyc7RMlaW9frMYCWJRPAKIOXIdwTlQd9HvJpO219bq1
        b954nNvIs1Przx1hxIDb5BU=
X-Google-Smtp-Source: ABdhPJzFbywADWXG9MDAbh3KL0fEiBHxdZrHt/Y5ui+0qWEW/8lwbSWRDlqXnOBtL6Idcwh+JbNN0A==
X-Received: by 2002:a05:6402:1445:b0:42b:cc8a:a309 with SMTP id d5-20020a056402144500b0042bcc8aa309mr5392192edx.43.1653533422378;
        Wed, 25 May 2022 19:50:22 -0700 (PDT)
Received: from gmail.com ([5.38.225.110])
        by smtp.gmail.com with ESMTPSA id w14-20020a50c44e000000b0042bdb6a3602sm152753edf.69.2022.05.25.19.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 19:50:21 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Thu, 26 May 2022 04:50:17 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: Re: [PATCH v2] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <Yo7q6dwphFexGuRA@gmail.com>
References: <20220525180553.419eac77@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525180553.419eac77@gandalf.local.home>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If an unused weak function was traced, it's call to fentry will still
> exist, which gets added into the __mcount_loc table. Ftrace will use
> kallsyms to retrieve the name for each location in __mcount_loc to display
> it in the available_filter_functions and used to enable functions via the
> name matching in set_ftrace_filter/notrace. Enabling these functions do
> nothing but enable an unused call to ftrace_caller. If a traced weak
> function is overridden, the symbol of the function would be used for it,
> which will either created duplicate names, or if the previous function was
> not traced, it would be incorrectly listed in available_filter_functions
> as a function that can be traced.
> 
> This became an issue with BPF[1] as there are tooling that enables the
> direct callers via ftrace but then checks to see if the functions were
> actually enabled. The case of one function that was marked notrace, but
> was followed by an unused weak function that was traced. The unused
> function's call to fentry was added to the __mcount_loc section, and
> kallsyms retrieved the untraced function's symbol as the weak function was
> overridden. Since the untraced function would not get traced, the BPF
> check would detect this and fail.
> 
> The real fix would be to fix kallsyms to not show address of weak
> functions as the function before it. But that would require adding code in
> the build to add function size to kallsyms so that it can know when the
> function ends instead of just using the start of the next known symbol.

Yeah, so I actually have a (prototype...) objtool based kallsyms 
implementation in the (way too large) fast-headers tree that is both faster 
& allows such details in principle:

  431bca135cf8 kbuild/linker: Gather all the __kallsyms sections into a single table
  6bc7af02e402 objtool/kallsyms: Copy the symbol name and offset to the new __kallsyms ELF section
  e1e85b2fab9e objtool/kallsyms: Increase section size dynamically
  3528d607641b objtool/kallsyms: Use zero entry size for section
  2555dd62348a objtool/kallsyms: Output variable length strings
  c114b71f8547 objtool/kallsyms: Add kallsyms_offsets[] table
  cfcfce6cb51f objtool/kallsyms: Change name to __kallsyms_strs
  134160bb2de1 objtool/kallsyms: Split out process_kallsyms_symbols()
  33347a4b46e0 objtool/kallsyms: Add relocations
  86626e9e6603 objtool/kallsyms: Skip discarded sections
  7dd9fef6fbb0 kallsyms/objtool: Print out the new symbol table on the kernel side
  c82d94b33a1f objtool/kallsyms: Use struct kallsyms_entry
  a66ee5034008 objtool/kallsyms, kallsyms/objtool: Share 'struct kallsyms_entry' definition
  e496159e5282 kallsyms/objtool: Process entries
  47fc63ef3fa8 objtool/kallsyms: Switch to 64-bit absolute relocations
  c54fcc03cd64 objtool/kallsyms: Fix initial offset
  eac3c107aa6e kallsyms/objtool: Emit System.map-alike symbol list
  ebfb7e14b8ca objtool/kallsyms: Skip undefined symbols
  25b69ef5666b objtool/kallsyms: Update symbol filter
  3b26a82c733f objtool/kallsyms: Add the CONFIG_KALLSYMS_FAST Kconfig option & its related Kconfig switches
  9350c25942f8 kallsyms/objtool: Make the kallsyms work even if the generic tables are not there
  4a0a120bde05 objtool/kallsyms, x86/relocs: Detect & ignore __kallsyms_offset section relocations
  87c5244f1fa8 kallsyms/objtool: Introduce linear table of symbol structures: kallsyms_syms[]
  51dafdefc61f kallsyms/objtool: Split fast vs. generic functions
  e4123a40125f kallsyms/objtool: Sort symbols by address and deduplicate them
  2d738c69965a kallsyms/objtool: Utilize the kallsyms_syms[] table in kallsyms_expand_symbol() and kallsyms_sym_address()
  997ffe217a34 kallsyms/objtool: Port kallsyms_relative_base functionality to the kallsyms_syms[] offsets

> In the mean time, this is a work around. Add a FTRACE_MCOUNT_MAX_OFFSET
> macro that if defined, ftrace will ignore any function that has its call
> to fentry/mcount that has an offset from the symbol that is greater than
> FTRACE_MCOUNT_MAX_OFFSET.
> 
> If CONFIG_HAVE_FENTRY is defined for x86, define FTRACE_MCOUNT_MAX_OFFSET
> to zero, which will have ftrace ignore all locations that are not at the
> start of the function.
> 
> [1] https://lore.kernel.org/all/20220412094923.0abe90955e5db486b7bca279@kernel.org/
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

LGTM.

I suppose you'd like to merge this via the tracing tree? If so:

  Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
