Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F11A2E05
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 06:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfH3EQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 00:16:55 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33773 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfH3EQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 00:16:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id z17so5179342ljz.0;
        Thu, 29 Aug 2019 21:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iCLpdRArKeEL95JPVvIj5SaZBs9XGj7yces6tTfOStA=;
        b=NGcsYzMjskd+7OhewWqjmPfjfb9vMfaXR2uRHfS9k8f4X5oAfxYur3wU1mGw6z9Adb
         s2vSwPdI5MgQ4eo0KXdbdByfhixSLkllBJGWIlIgnMKt/IOTvkIeaEuR6O589lzfmryA
         6DZK5zWsARS5a4cbhaMVO1vNF8zJA+nFUYwp2FocHW1HXNjbxt1aBqC73lDqN3iU2f2l
         ODHuasUQ55rzy4x9fiz0RvJv5FS27UAqM3MvRHxTek4Mg8HyqGD6Owic2fzaFJ8SNuhf
         eF5ngM9Cksnm6F0m+XrxQVECHdjmoyWi/boaFCBQQ7F09g+OKrJHWXcHf6DdE01r/QEj
         VB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iCLpdRArKeEL95JPVvIj5SaZBs9XGj7yces6tTfOStA=;
        b=E7zwOCPAzSWUSb+IQDyQ7chPC/rhm/DNFR1h95z4qMNHlhfYrdMfjwBKlwt2fonFto
         g5c5YDYsgLydq3C4pXX3tLfmUendbfdSVQ8mJCjGcKO5f/q6/lg+P0KPv247cA7zvDnV
         dpyfTW6pLPiYLbL9E8O4s/nlJjT08GGtFEUXZgkama3kb45FvXJMarrI5hU/VWD85slT
         aiR96an0e3ggYOzIAMRZ4SXrkCHinbbhRn+AJZgZqgF0D4F8kZDFKugSlCSphikmVi16
         l/2HxSdFnbz765rx2SfC4Rg2Wj57/WJjcABziS0e8nEHi21uxm9EVxyj8GlMCYfr7al/
         Ex+A==
X-Gm-Message-State: APjAAAVnockiYd+271qgOPHwoy67wrcECitZJWx70mWBYUfcn3ljk2Ai
        KpQyuxYfppQHq+Xkb0nhDhi9bqhbQ5Kf6zrHZPI=
X-Google-Smtp-Source: APXvYqwckFt3LnsIIi6bT/vpq147Uo7WytBr14tQ2z3LKla/6nJ/Z4g9Ap40xGdfMuNke05PcWsONH/yRHIgQeADweg=
X-Received: by 2002:a05:651c:1ba:: with SMTP id c26mr7511169ljn.11.1567138612764;
 Thu, 29 Aug 2019 21:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190829051253.1927291-1-ast@kernel.org> <536636ad-0baf-31e9-85fe-2591b65068df@iogearbox.net>
In-Reply-To: <536636ad-0baf-31e9-85fe-2591b65068df@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 29 Aug 2019 21:16:39 -0700
Message-ID: <CAADnVQLiD_2dTWXgaC773Uo+4LPz=vFEysXUnUcsJ9FKBk5Q7g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and CAP_TRACING
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 8:47 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/29/19 7:12 AM, Alexei Starovoitov wrote:
> [...]
> >
> > +/*
> > + * CAP_BPF allows the following BPF operations:
> > + * - Loading all types of BPF programs
> > + * - Creating all types of BPF maps except:
> > + *    - stackmap that needs CAP_TRACING
> > + *    - devmap that needs CAP_NET_ADMIN
> > + *    - cpumap that needs CAP_SYS_ADMIN
> > + * - Advanced verifier features
> > + *   - Indirect variable access
> > + *   - Bounded loops
> > + *   - BPF to BPF function calls
> > + *   - Scalar precision tracking
> > + *   - Larger complexity limits
> > + *   - Dead code elimination
> > + *   - And potentially other features
> > + * - Use of pointer-to-integer conversions in BPF programs
> > + * - Bypassing of speculation attack hardening measures
> > + * - Loading BPF Type Format (BTF) data
> > + * - Iterate system wide loaded programs, maps, BTF objects
> > + * - Retrieve xlated and JITed code of BPF programs
> > + * - Access maps and programs via id
> > + * - Use bpf_spin_lock() helper
>
> This is still very wide.

'still very wide' ? you make it sound like it's a bad thing.
Covering all of bpf with single CAP_BPF is #1 goal of this set.

> Consider following example: app has CAP_BPF +> CAP_NET_ADMIN. Why can't we in this case *only* allow loading networking
> related [plus generic] maps and programs? If it doesn't have CAP_TRACING,
> what would be a reason to allow loading it? Same vice versa. There are
> some misc program types like the infraread stuff, but they could continue
> to live under [CAP_BPF +] CAP_SYS_ADMIN as fallback. I think categorizing
> a specific list of prog and map types might be more clear than disallowing
> some helpers like below (e.g. why choice of bpf_probe_read() but not
> bpf_probe_write_user() etc).

It kinda makes sense:
cap_bpf+cap_net_admin allows networking progs.
cap_bpf+cap_tracing allows tracing progs.
But what to do with cg_sysctl, cg_device, lirc ?
They are clearly neither.
Invent yet another cap_foo for them?
or let them under cap_bpf alone?
If cap_bpf alone is enough then why bother with bpf+net_admin for networking?
It's not making anything cleaner. Only confuses users.

Also bpf_trace_printk() is using ftrace and can print arbitrary memory.
In that sense it's no different than bpf_probe_read.
Both should be under CAP_TRACING.
But bpf_trace_printk() is available to all progs.
Even to socket filters under cap_sys_admin today.
With this patch set I'm allowing bpf_trace_printk() under CAP_TRACING.
Same goes to bpf_probe_read.

High level description:
cap_bpf alone allows loading of all progs except when
later cap_net_admin or cap_tracing will _not_ be able to
filter out the helper at attach time that shouldn't be there.

Example of how this patch set works:
- to load and attach networking progs
both cap_bpf and cap_net_admin are necessary.
- to load and attach tracing progs
both cap_bpf and cap_tracing are necessary.

when networking prog is using bpf_trace_printk
then cap_tracing is needed too.
And it's checked at load time.
If we do what you're proposing:
"lets allow load of all networking with bpf+net_admin"
then this won't work for bpf_trace_printk.
Per helper function capability check is still needed.
And since it's needed I see no reason to limit
networking progs to bpf+net_admin at load time.
Load time is still cap_bpf only.
And helpers will be filtered out at attach by net_admin.
