Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADDF462BC
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfFNP3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:29:20 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34831 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNP3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:29:19 -0400
Received: by mail-lf1-f65.google.com with SMTP id a25so2034390lfg.2;
        Fri, 14 Jun 2019 08:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qNZZnJGaKofn2cHkIBRXjMyNHGsFyy4dzeNzR7jKPw4=;
        b=e+P5gDSWAKwulncFFhF6v5lyy8ulSp/mGS8oB7e1qQac6yToKhocOhhl+HDGViIdNj
         Gl08Kiw2dMAsy8dd+MOLIjFrtl2P53mY7Y7k8u9Gz4m7Id2SvL5IW8bdSmuO3v9gYFt8
         MKte5Rl2qivER/G3ECgRtuhx5fzd9A/+JUKZ1ttH3KyzD+eLtm7PWy70joJqO/+PLBQu
         mvMwHFcwTt2MNeDTIeArq9pUjN+sEl5GIcYdY5faUP+PZAQhLRBIY+A7FxVJx61Uwcco
         m7OqmoTDwCc8lyhwNofcEJW7SOMYTR4EJ82Vm+fGTtsfiU3JowL/eqjD4oI3lOgAtT9k
         Fdvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qNZZnJGaKofn2cHkIBRXjMyNHGsFyy4dzeNzR7jKPw4=;
        b=YBt0KdiT+EDITLTrJttuKg/+hv62MyhQ5joB0J5uegLuB8Q441FR+Nls+i+vH4JZtZ
         Z8jpw3Q4YBppEmdAe2HpWH4Wxcr+ERof55KpB3eaappAaILXrcIudp++YWuc4FIEaZ28
         6/DEGnY/6QCN+BB8UqjT06gkafafDMQZUCGEDcCrl3655NtwgL41U+CfYthtuo5o4jLK
         5QB56P6rPLoiHay4RrJOhNEYtm48ddGeeEtmpv2CVd0FYTfj/TkqxyiJsGimdhA35vBL
         i+zmbYeLsg/1T787uAI+L0VmI37nCTwDmi3HKFs4ZSToNXfuBNMpkpmFxXhysX+sFbZE
         ojhw==
X-Gm-Message-State: APjAAAXwKll3WzPzFqS8eeauBGdi4AACk3G135lpdu5raRizB5gUzq/K
        6F0M3HuI9UioLh4A/8G7Dqg0ggwDIv0pA6bncS8=
X-Google-Smtp-Source: APXvYqxloTnUeXliCBshJ+sHIUsfQSQIoO2O2mNEJ/EaFCec653XsZE6w0JtQhNxw4ZGgos7x1xxJ25NwStuBR77SMU=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr10583956lfe.6.1560526157752;
 Fri, 14 Jun 2019 08:29:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560431531.git.jpoimboe@redhat.com> <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble> <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble> <20190614022848.ly4vlgsz6fa4bcbl@treble>
 <20190614045037.zinbi2sivthcfrtg@treble> <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
 <20190614074136.GR3436@hirez.programming.kicks-ass.net>
In-Reply-To: <20190614074136.GR3436@hirez.programming.kicks-ass.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 08:29:06 -0700
Message-ID: <CAADnVQJS2tZr8vVsORm+PF7qJZ-aKsRj5Mbwcim5q7PXCQgU4Q@mail.gmail.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers for
 generated code
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:41 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Jun 13, 2019 at 11:00:09PM -0700, Alexei Starovoitov wrote:
>
> > There is something wrong with
> > commit d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
>
> It assumes we can always unwind stack, which is, imo, not a weird thing.
>
> > If I simply revert it and have CONFIG_UNWINDER_FRAME_POINTER=y
> > JITed stacks work just fine, because
> > bpf_get_stackid()->get_perf_callchain()
> > need to start unwinding before any bpf stuff.
>
> How does stack unwinding work if we try and unwind from an interrupt
> that hits inside a BPF program? That too needs to work properly.
>
> > After that commit it needs to go through which is a bug on its own.
> > imo patch 1 doesn't really fix that issue.
>
> This we agree on, patch 1 doesn't solve that at all. But we also should
> not loose the initial regs->ip value.
>
> > As far as mangled rbp can we partially undo old
> > commit 177366bf7ceb ("bpf: change x86 JITed program stack layout")
> > that introduced that rbp adjustment.
>
> > Going through bpf code is only interesting in case of panics somewhere
> > in bpf helpers. Back then we didn't even have ksym of jited code.
>
> I disagree here, interrupts/NMIs hitting inside BPF should be able to
> reliably unwind the entire stack. Back then is irrelevant, these days we
> expect a reliable unwind.
>
> > Anyhow I agree that we need to make the jited frame proper,
> > but unwinding need to start before any bpf stuff.
> > That's a bigger issue.
>
> I strongly disagree, we should be able to unwind through bpf.

I'm not saying that we should not.
I'm saying that unwinding through jited code was not working
for long time and it wasn't an issue. The issue is start of unwind.
This is user expected behavior that we cannot just break.
The users expect stack trace to be the same JITed vs interpreted.
Hence unwinder should start before interpreter/jit.
That's the first problem to address.
In parallel we can discuss how to make unwinding work through jited code.
