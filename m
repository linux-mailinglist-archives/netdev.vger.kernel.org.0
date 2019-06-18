Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF60496BD
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 03:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfFRBch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 21:32:37 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32843 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRBcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 21:32:36 -0400
Received: by mail-lj1-f193.google.com with SMTP id h10so11303870ljg.0;
        Mon, 17 Jun 2019 18:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L9KJ4+1kzcAFaeSK/ZZjLqlQ0Pv9jO+ZIcSnFCmw2HA=;
        b=Tm8wzpJUB5mUUzJ8N7lgiHFw15ltlHK303507E6/JjkM3QNE3v0SpjAvedUp6eMECd
         NVlr696IFDShdnnQZO3JTHcpi/bGOyinjtDjtLvJVn9B5CsW0wJg18eOUOidFVAtvMlW
         AjKwGWYAfK5allqXfyVQ+ARCRY4s5FafKDqPmyaTPq++6TQnKNo0vHSisEgr4gFX8/wo
         vWPDDUXzoE1iR5431E3FY4NzZ2oTWKCtczXpyIzpLMRxDB1pQyBTbm/bK7v95KR/F1RV
         kPw7wzKwn8YaLAkHWrqAcZHyXVV1jJuRjWFpUAfVWYyakiCIfkWZocZh6IdiiNnqwnOF
         Ni+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L9KJ4+1kzcAFaeSK/ZZjLqlQ0Pv9jO+ZIcSnFCmw2HA=;
        b=PFi2Vgqcjzi55opOkzqzmTi7EShz6+B2daTeMLoVQZetw2eGOsI52UYbIvXCLF41JT
         HBbpOvL3m6NdFAbD0JY5E2QAOFftw8469X8Aod6taE1guyyaGan09gZ9YmpwyUX/xmTk
         j1B7Wo7L3/BgEoDRzjR+OmuABX8ftKrhk4D1H5hJmXpNV3QDvmOiPs/Nf4Y7zQ6xYXdC
         ymDsM5uDNqgZNEVVUvT5nCIjsKjUkKXK91IdHhoBTgD0C6tyHXeNBd0XaCTYYMzrxjhR
         312vvqLh2ZePKikV9rZoaZkKU/gOCp1IaJrV87pFJgGZFksaapbLIbc0l6i35VEK5bvj
         vdnQ==
X-Gm-Message-State: APjAAAWZaho0cSo7TlBNRgPSwMZOgPgVyl3jRdfhv3iAh/0yvAaehKzv
        MX0uitFjb9eVKXKoTkzmw6O8aGuC0lZSP5OXKjb0cw==
X-Google-Smtp-Source: APXvYqyNPaHjqLM4VYBYU0C1gLB7y6TWpfCUx5A7FTDRRa5JoNWtIsAlwFQOxTqjfpus9cK6n6E2XAzVii29LL2vbKA=
X-Received: by 2002:a2e:94c9:: with SMTP id r9mr14946799ljh.210.1560821553588;
 Mon, 17 Jun 2019 18:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com> <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com> <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com> <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
 <20190523051608.GP2422@oracle.com> <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
 <20190618012509.GF8794@oracle.com>
In-Reply-To: <20190618012509.GF8794@oracle.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 17 Jun 2019 18:32:22 -0700
Message-ID: <CAADnVQJoH4WOQ0t7ZhLgh4kh2obxkFs0UGDRas0y4QSqh1EMsg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, dtrace-devel@oss.oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 6:25 PM Kris Van Hees <kris.van.hees@oracle.com> wrote:
>
> On Thu, May 23, 2019 at 01:28:44PM -0700, Alexei Starovoitov wrote:
>
> << stuff skipped because it is not relevant to the technical discussion... >>
>
> > > > In particular you brought up a good point that there is a use case
> > > > for sharing a piece of bpf program between kprobe and tracepoint events.
> > > > The better way to do that is via bpf2bpf call.
> > > > Example:
> > > > void bpf_subprog(arbitrary args)
> > > > {
> > > > }
> > > >
> > > > SEC("kprobe/__set_task_comm")
> > > > int bpf_prog_kprobe(struct pt_regs *ctx)
> > > > {
> > > >   bpf_subprog(...);
> > > > }
> > > >
> > > > SEC("tracepoint/sched/sched_switch")
> > > > int bpf_prog_tracepoint(struct sched_switch_args *ctx)
> > > > {
> > > >   bpf_subprog(...);
> > > > }
> > > >
> > > > Such configuration is not supported by the verifier yet.
> > > > We've been discussing it for some time, but no work has started,
> > > > since there was no concrete use case.
> > > > If you can work on adding support for it everyone will benefit.
> > > >
> > > > Could you please consider doing that as a step forward?
> > >
> > > This definitely looks to be an interesting addition and I am happy to look into
> > > that further.  I have a few questions that I hope you can shed light on...
> > >
> > > 1. What context would bpf_subprog execute with?  If it can be called from
> > >    multiple different prog types, would it see whichever context the caller
> > >    is executing with?  Or would you envision bpf_subprog to not be allowed to
> > >    access the execution context because it cannot know which one is in use?
> >
> > bpf_subprog() won't be able to access 'ctx' pointer _if_ it's ambiguous.
> > The verifier already smart enough to track all the data flow, so it's fine to
> > pass 'struct pt_regs *ctx' as long as it's accessed safely.
> > For example:
> > void bpf_subprog(int kind, struct pt_regs *ctx1, struct sched_switch_args *ctx2)
> > {
> >   if (kind == 1)
> >      bpf_printk("%d", ctx1->pc);
> >   if (kind == 2)
> >      bpf_printk("%d", ctx2->next_pid);
> > }
> >
> > SEC("kprobe/__set_task_comm")
> > int bpf_prog_kprobe(struct pt_regs *ctx)
> > {
> >   bpf_subprog(1, ctx, NULL);
> > }
> >
> > SEC("tracepoint/sched/sched_switch")
> > int bpf_prog_tracepoint(struct sched_switch_args *ctx)
> > {
> >   bpf_subprog(2, NULL, ctx);
> > }
> >
> > The verifier should be able to prove that the above is correct.
> > It can do so already if s/ctx1/map_value1/, s/ctx2/map_value2/
> > What's missing is an ability to have more than one 'starting' or 'root caller'
> > program.
> >
> > Now replace SEC("tracepoint/sched/sched_switch") with SEC("cgroup/ingress")
> > and it's becoming clear that BPF_PROG_TYPE_PROBE approach is not good enough, right?
> > Folks are already sharing the bpf progs between kprobe and networking.
> > Currently it's done via code duplication and actual sharing happens via maps.
> > That's not ideal, hence we've been discussing 'shared library' approach for
> > quite some time. We need a way to support common bpf functions that can be called
> > from networking and from tracing programs.
> >
> > > 2. Given that BPF programs are loaded with a specification of the prog type,
> > >    how would one load a code construct as the one you outline above?  How can
> > >    you load a BPF function and have it be used as subprog from programs that
> > >    are loaded separately?  I.e. in the sample above, if bpf_subprog is loaded
> > >    as part of loading bpf_prog_kprobe (prog type KPROBE), how can it be
> > >    referenced from bpf_prog_tracepoint (prog type TRACEPOINT) which would be
> > >    loaded separately?
> >
> > The api to support shared libraries was discussed, but not yet implemented.
> > We've discussed 'FD + name' approach.
> > FD identifies a loaded program (which is root program + a set of subprogs)
> > and other programs can be loaded at any time later. The BPF_CALL instructions
> > in such later program would refer to older subprogs via FD + name.
> > Note that both tracing and networking progs can be part of single elf file.
> > libbpf has to be smart to load progs into kernel step by step
> > and reusing subprogs that are already loaded.
> >
> > Note that libbpf work for such feature can begin _without_ kernel changes.
> > libbpf can pass bpf_prog_kprobe+bpf_subprog as a single program first,
> > then pass bpf_prog_tracepoint+bpf_subprog second (as a separate program).
> > The bpf_subprog will be duplicated and JITed twice, but sharing will happen
> > because data structures (maps, global and static data) will be shared.
> > This way the support for 'pseudo shared libraries' can begin.
> > (later accompanied by FD+name kernel support)
>
> As far as I can determine, the current libbpd implementation is already able
> to do the duplication of the called function, even when the ELF object contains
> programs of differemt program types.  I.e. the example you give at the top
> of the email actually seems to work already.  Right?

Have you tried it?

> In that case, I am a bit unsure what more can be done on the side of libbpf
> without needing kernel changes?

it's a bit weird to discuss hypothetical kernel changes when the first step
of changing libbpf wasn't even attempted.
