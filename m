Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8759727BA8A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbgI2Byz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2Byz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:54:55 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5674CC061755;
        Mon, 28 Sep 2020 18:54:55 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jw11so1806404pjb.0;
        Mon, 28 Sep 2020 18:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2SzB7isKAREqUjXH+YUlW/DpD7dRh0cjXqpB4hYOMVM=;
        b=uJtjQGkwh05rX2CZ4v+Qn3bQAHgTuyU3oV3YAdRR/T8rsoyy9vp/a4bTakkZXv5SnR
         c1EBCWjtRgJhSOanZueb+HOttgxiw4RMgWuFcw274b9ZmnsTGggpNfkITxraUKIlB5eu
         qZ2U1PBEppaf58W354aroZvTjSBwC5uVn3wDwaovp/Jr0YwkjuDvhmi2U0eBLCHTNpzK
         9+VFms2abgNGDGaFSXk9CSIa5vngmnlkCFBKBvg+0SOOpV+Gz24Y8qQ3RehnRLWQwiXx
         bulFArQl2BcKMQimOHwhVoLMNG3UAmPP5HM5hnRA5mRVLykHo8PTi7PqvI10XLkVakr9
         WJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2SzB7isKAREqUjXH+YUlW/DpD7dRh0cjXqpB4hYOMVM=;
        b=M1DuJgEEgiAYDebQnLnvKDH/qBgkAilJiU4QhmLkMb1UjfrjicSRU79Rs+AIMfgRFG
         h7Bs4fOgXneBVBvsv1Ynd/v9Pi+Y3duYEJUTfSPQdLvDbvmckTw4sjReWHb4AN8ooPK0
         SLMDSNNHQilWDLwicGQ+lsPacdKF5QN/LOYrf3WHCkPSWOZiLR3FRH65BF9IC6+SzaLv
         vTkRt1VIlySlXTrfm8xNTwPaYRdZ71QHV/Eyc8EgAn/hdQ6j/31ZBzip/mEmlT1jJ0s0
         OFoI45I0lV7cHUAwayYmK3/Ox9ZDYIPG8S/mmViNqL/GZfyj1Ggu7EOrIAKzQYlzrlM+
         Gq+w==
X-Gm-Message-State: AOAM532UJsmD2eB8jkJMsphax8CcsOiFbhTPkndD7Y9WAMr+0pyQYE56
        jnWfGupMGYol5fvtXnp5bew=
X-Google-Smtp-Source: ABdhPJwCmZSmOLbppa1vFzQqfZJlJ7yfoINWoTLVTS9qpnpFboFlltQXt94V0opqudRriRPRFSg+Ew==
X-Received: by 2002:a17:90b:4b8e:: with SMTP id lr14mr1817137pjb.100.1601344494769;
        Mon, 28 Sep 2020 18:54:54 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8e77])
        by smtp.gmail.com with ESMTPSA id z7sm2674142pgc.35.2020.09.28.18.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 18:54:53 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:54:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
        <linux-kselftest@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v6 bpf-next 6/6] selftests/bpf: add test for
 bpf_seq_printf_btf helper
Message-ID: <20200929015450.das2bxw4f3q7oyup@ast-mbp.dhcp.thefacebook.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
 <1600883188-4831-7-git-send-email-alan.maguire@oracle.com>
 <20200925012611.jebtlvcttusk3hbx@ast-mbp.dhcp.thefacebook.com>
 <alpine.LRH.2.21.2009281500220.13299@localhost>
 <CAEf4Bzb2JE_V7cQ=LGto6jHbiKUAg+A5MuqQ0LGb9L8qTUk6yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb2JE_V7cQ=LGto6jHbiKUAg+A5MuqQ0LGb9L8qTUk6yg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 10:51:19AM -0700, Andrii Nakryiko wrote:
> On Mon, Sep 28, 2020 at 7:14 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> >
> >
> > On Thu, 24 Sep 2020, Alexei Starovoitov wrote:
> >
> > > to whatever number, but printing single task_struct needs ~800 lines and
> > > ~18kbytes. Humans can scroll through that much spam, but can we make it less
> > > verbose by default somehow?
> > > May be not in this patch set, but in the follow up?
> > >
> >
> > One approach that might work would be to devote 4 bits or so of
> > flag space to a "maximum depth" specifier; i.e. at depth 1,
> > only base types are displayed, no aggregate types like arrays,
> > structs and unions.  We've already got depth processing in the
> > code to figure out if possibly zeroed nested data needs to be
> > displayed, so it should hopefully be a simple follow-up.

That sounds great to me.

Would it be possible to specify the depth from the other side as well?
Like a lot of 'leaf' fields are struct list_head, struct lockdep_map,
atomic_t, struct callback_head, etc.
When printing a big struct I'm interested in the data that the
struct provides, but many small inner structs are not that useful.
So the data is at the top level and in few layers down,
but depth is different at different fields.
If I could tell printf to avoid printing the last depth I think
it will make the output more concise.
Whereas if I say print depth=2 from the top it will still print
'struct list_head' that happened to be at the top level.

> >
> > One way to express it would be to use "..." to denote field(s)
> > were omitted. We could even use the number of "."s to denote
> > cases where multiple fields were omitted, giving a visual sense
> > of how much data was omitted.  So for example with
> > BTF_F_MAX_DEPTH(1), task_struct looks like this:
> >
> > (struct task_struct){
> >  .state = ()1,
> >  .stack = ( *)0x00000000029d1e6f,
> >  ...
> >  .flags = (unsigned int)4194560,
> >  ...
> >  .cpu = (unsigned int)36,
> >  .wakee_flips = (unsigned int)11,
> >  .wakee_flip_decay_ts = (long unsigned int)4294914874,
> >  .last_wakee = (struct task_struct *)0x000000006c7dfe6d,
> >  .recent_used_cpu = (int)19,
> >  .wake_cpu = (int)36,
> >  .prio = (int)120,
> >  .static_prio = (int)120,
> >  .normal_prio = (int)120,
> >  .sched_class = (struct sched_class *)0x00000000ad1561e6,
> >  ...
> >  .exec_start = (u64)674402577156,
> >  .sum_exec_runtime = (u64)5009664110,
> >  .vruntime = (u64)167038057,
> >  .prev_sum_exec_runtime = (u64)5009578167,
> >  .nr_migrations = (u64)54,
> >  .depth = (int)1,
> >  .parent = (struct sched_entity *)0x00000000cba60e7d,
> >  .cfs_rq = (struct cfs_rq *)0x0000000014f353ed,
> >  ...
> >
> > ...etc. What do you think?
> 
> It's not clear to me what exactly is omitted with ... ? Would it make
> sense to still at least list a field name and "abbreviated" value.
> E.g., for arrays:
> 
> .array_field = (int[16]){ ... },
> 
> Similarly for struct:
> 
> .struct_field = (struct my_struct){ ... },

+1
Something like this would be great.

Another idea...
If there is only one field in the struct can we omit it?
Like instead of:
   .refs = (atomic_t){
    .counter = (int)2,
   },
print
   .refs = (atomic_t){ 2 },

From C point of view it is still a valid initializer and
it's not ambiguous which field being inited, since there is only
one field.
