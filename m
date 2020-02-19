Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEA2164AB6
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 17:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgBSQir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 11:38:47 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43754 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgBSQir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 11:38:47 -0500
Received: by mail-lj1-f193.google.com with SMTP id a13so1020662ljm.10;
        Wed, 19 Feb 2020 08:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1BusTSWHZd4iZhqbIKlYBvbWdX7TmPHyP4IOzI8LiCY=;
        b=bqh4bs39engdAvKvgFF0Zq2hPV28q+L7t9AlNPVJj2fqn3XcGBoy+rUUkCCeL32Xi3
         OeWL2FthjZuAJLQaXc3UOE/IgsF0Jnv5Sx1GPD4767AKTekJe+6lZikAAw7BpV4VCnin
         Hln5vKrlY87pHkmHFJPdBEbklM0G+cpBZGnM1RldqR+QupyhnE4ZZCUNFxPimXiAuYkt
         1Qt2ITISl728KQy0MCMc+gYpcgOHkIOQqgE33ZqAbhkdUhWe6LRf9AFJbtObzSL7jUtJ
         qDmF+IV1Vw+XmPYdv24jE/9v8BMVWyLvDug601UYkL5L3yZ/Zl8iynnTRtYScSJuPdSj
         f0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1BusTSWHZd4iZhqbIKlYBvbWdX7TmPHyP4IOzI8LiCY=;
        b=tZGGdSwGXm07qpt++bskoqhvYyHnCPyG9zwhdSLkVO/z+zOAbIQPgy+GKpWoIOOuSV
         5gk6uvT/8N0bOpzpiq3LLJG48vHJNgBYqNOVTOvux9EeQ9Q7bZvF/OmubsHjPMyr9ne7
         lfvHJRVNibKMOf0FaTwJ7BlVOcy+HVM7uaYOBauJnV0YpSVY4wUXdPFrFwTUU2obQ8fb
         YHz2s/kFvwAaXmuzIrCRo0qdfJ7vKNb9Ci2tPFLlEVih7XZJeDfLe0x3/7xgDHm1JIFI
         axkG7nAbzwILO6tTZzBTZANDWXmg5Qse+hdPdSxxZUc14P9pOsD8aI0NkmdDg/WDlQCc
         GCkQ==
X-Gm-Message-State: APjAAAX1ORkQJ8J8NAOJbeB2XXUXcUSrj5WhU7Pu0UT7ss9WBslRNuFE
        +hw3hUR2PKZLTSsTCMp8lDTSdAIhh2G8uwl2D5k=
X-Google-Smtp-Source: APXvYqzMMZMnixr5rsqY/fP8O2JFDCDwpwfXCjfmgaU+YylBAsv9qXiKUG6cCv/c0LQblPf/mhGidILCwMduX/S9iNw=
X-Received: by 2002:a2e:a404:: with SMTP id p4mr16827752ljn.234.1582130324319;
 Wed, 19 Feb 2020 08:38:44 -0800 (PST)
MIME-Version: 1.0
References: <20200214133917.304937432@linutronix.de> <20200214161503.804093748@linutronix.de>
 <87a75ftkwu.fsf@linux.intel.com> <875zg3q7cn.fsf@nanos.tec.linutronix.de>
In-Reply-To: <875zg3q7cn.fsf@nanos.tec.linutronix.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Feb 2020 08:38:33 -0800
Message-ID: <CAADnVQ+Q6hZNFZyKSQm1vPYNszH9T6Krz4K8Eu9f3Dy5UQPsag@mail.gmail.com>
Subject: Re: [RFC patch 09/19] bpf: Use BPF_PROG_RUN_PIN_ON_CPU() at simple
 call sites.
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 1:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Vinicius Costa Gomes <vinicius.gomes@intel.com> writes:
>
> Cc+: seccomp folks
>
> > Thomas Gleixner <tglx@linutronix.de> writes:
> >
> >> From: David Miller <davem@davemloft.net>
>
> Leaving content for reference
>
> >> All of these cases are strictly of the form:
> >>
> >>      preempt_disable();
> >>      BPF_PROG_RUN(...);
> >>      preempt_enable();
> >>
> >> Replace this with BPF_PROG_RUN_PIN_ON_CPU() which wraps BPF_PROG_RUN()
> >> with:
> >>
> >>      migrate_disable();
> >>      BPF_PROG_RUN(...);
> >>      migrate_enable();
> >>
> >> On non RT enabled kernels this maps to preempt_disable/enable() and on RT
> >> enabled kernels this solely prevents migration, which is sufficient as
> >> there is no requirement to prevent reentrancy to any BPF program from a
> >> preempting task. The only requirement is that the program stays on the same
> >> CPU.
> >>
> >> Therefore, this is a trivially correct transformation.
> >>
> >> [ tglx: Converted to BPF_PROG_RUN_PIN_ON_CPU() ]
> >>
> >> Signed-off-by: David S. Miller <davem@davemloft.net>
> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >>
> >> ---
> >>  include/linux/filter.h    |    4 +---
> >>  kernel/seccomp.c          |    4 +---
> >>  net/core/flow_dissector.c |    4 +---
> >>  net/core/skmsg.c          |    8 ++------
> >>  net/kcm/kcmsock.c         |    4 +---
> >>  5 files changed, 6 insertions(+), 18 deletions(-)
> >>
> >> --- a/include/linux/filter.h
> >> +++ b/include/linux/filter.h
> >> @@ -713,9 +713,7 @@ static inline u32 bpf_prog_run_clear_cb(
> >>      if (unlikely(prog->cb_access))
> >>              memset(cb_data, 0, BPF_SKB_CB_LEN);
> >>
> >> -    preempt_disable();
> >> -    res = BPF_PROG_RUN(prog, skb);
> >> -    preempt_enable();
> >> +    res = BPF_PROG_RUN_PIN_ON_CPU(prog, skb);
> >>      return res;
> >>  }
> >>
> >> --- a/kernel/seccomp.c
> >> +++ b/kernel/seccomp.c
> >> @@ -268,16 +268,14 @@ static u32 seccomp_run_filters(const str
> >>       * All filters in the list are evaluated and the lowest BPF return
> >>       * value always takes priority (ignoring the DATA).
> >>       */
> >> -    preempt_disable();
> >>      for (; f; f = f->prev) {
> >> -            u32 cur_ret = BPF_PROG_RUN(f->prog, sd);
> >> +            u32 cur_ret = BPF_PROG_RUN_PIN_ON_CPU(f->prog, sd);
> >>
> >
> > More a question really, isn't the behavior changing here? i.e. shouldn't
> > migrate_disable()/migrate_enable() be moved to outside the loop? Or is
> > running seccomp filters on different cpus not a problem?
>
> In my understanding this is a list of filters and they are independent
> of each other.

Yes. It's fine to be preempted between filters.
