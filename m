Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E03E162FF2
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgBRT2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:28:19 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:40792 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgBRT2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:28:17 -0500
Received: by mail-pf1-f176.google.com with SMTP id b185so814444pfb.7
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 11:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=zhYJCkJXlPxXtgjObEVr42uyGuLn0+lKW2wKfP/UpCE=;
        b=DvmqpHrnM5O330XZo1r4oQuSvPgecXnkvWf1HePsqxhXDtfRmjIjyRMJC5NXDcCYn+
         OwvGhCTbVAvqmsw7DHX6CX7ayI8MRX80ZKZFm3l7gtOi8e7I+QXoV2LNG3hx3pvtvgiV
         LSIt91cMdVZ0sjN19WquhWlHxwMKtoi8sHzngiTeNW13UUBuZJ+eKQMx92fEmu2wm/iA
         Zt5J/EId0BdKG8K0owTwcXRs3abR2p6cDm6V/Hc1tImyyILCj1yMKM1SnD10oedygFij
         qIgZMDYYyaPAr0O+2Mq3cmqiX39FLOwWYivab+YigA6JwRjURv6j+9wGEC6ZR3iOJu+H
         mZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=zhYJCkJXlPxXtgjObEVr42uyGuLn0+lKW2wKfP/UpCE=;
        b=g9f0TfrKP2ACmJ1N0i1xyXjMlKUD2McXyUY81mf0cpxy0ofKomGaez5kcRJlCK2R9O
         JfIS2PjVj2Y0CXFaAktVbjM3ubN9kE+PAFQIGczAH/6oAtOVAjQBZapQoMHxEpvon80u
         XsZT6z5hq2SQqjz5gM996FIrjFuJ5MYTEJan2w3CCQFvsdCTUgXJfa7+jMfGk+oADaf+
         sNmjVJKjQy8FInAWf2lnfVsI0TQTFZDoA/J4gQAYWqeCTAm3q7XvPhjOwpbGymiyULim
         hTIbBebJnZ7LWeXqKAYpL1YfAog0gFHHRlcbNjshMXmHHlNc+4mwJXiShQlAeOPYqyEX
         LHtg==
X-Gm-Message-State: APjAAAUlTul3haPMZeXwW4RZ9nRp7BtdMUMBlXsiYnsiVyzcFvLx+Nbg
        EN5s+SGB+mwvXGistntdfSOgRA==
X-Google-Smtp-Source: APXvYqxvBhs/kNz46f0NM7yQK9O+VsDMro0hxwtL6uWXHEPpf1QvsgH3bBRF8NOa1+svFTWNKSApFA==
X-Received: by 2002:a62:cfc1:: with SMTP id b184mr22611022pfg.55.1582054093924;
        Tue, 18 Feb 2020 11:28:13 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:23a5:d584:6a92:3e3c])
        by smtp.gmail.com with ESMTPSA id q12sm4931028pfh.158.2020.02.18.11.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:28:13 -0800 (PST)
Date:   Tue, 18 Feb 2020 11:28:13 -0800 (PST)
X-Google-Original-Date: Tue, 18 Feb 2020 11:28:02 PST (-0800)
Subject:     Re: arm64: bpf: Elide some moves to a0 after calls
In-Reply-To: <5e39d509c9edc_63882ad0d49345c08@john-XPS-13-9370.notmuch>
CC:     Bjorn Topel <bjorn.topel@gmail.com>, daniel@iogearbox.net,
        ast@kernel.org, zlim.lnx@gmail.com, catalin.marinas@arm.com,
        will@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, shuah@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-team@android.com
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     john.fastabend@gmail.com
Message-ID: <mhng-eae623ac-3032-4327-9b23-af9838e3e979@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Feb 2020 12:33:13 PST (-0800), john.fastabend@gmail.com wrote:
> Björn Töpel wrote:
>> On Tue, 28 Jan 2020 at 03:14, Palmer Dabbelt <palmerdabbelt@google.com> wrote:
>> >
>> > There's four patches here, but only one of them actually does anything.  The
>> > first patch fixes a BPF selftests build failure on my machine and has already
>> > been sent to the list separately.  The next three are just staged such that
>> > there are some patches that avoid changing any functionality pulled out from
>> > the whole point of those refactorings, with two cleanups and then the idea.
>> >
>> > Maybe this is an odd thing to say in a cover letter, but I'm not actually sure
>> > this patch set is a good idea.  The issue of extra moves after calls came up as
>> > I was reviewing some unrelated performance optimizations to the RISC-V BPF JIT.
>> > I figured I'd take a whack at performing the optimization in the context of the
>> > arm64 port just to get a breath of fresh air, and I'm not convinced I like the
>> > results.
>> >
>> > That said, I think I would accept something like this for the RISC-V port
>> > because we're already doing a multi-pass optimization for shrinking function
>> > addresses so it's not as much extra complexity over there.  If we do that we
>> > should probably start puling some of this code into the shared BPF compiler,
>> > but we're also opening the doors to more complicated BPF JIT optimizations.
>> > Given that the BPF JIT appears to have been designed explicitly to be
>> > simple/fast as opposed to perform complex optimization, I'm not sure this is a
>> > sane way to move forward.
>> >
>> 
>> Obviously I can only speak for myself and the RISC-V JIT, but given
>> that we already have opened the door for more advanced translations
>> (branch relaxation e.g.), I think that this makes sense. At the same
>> time we don't want to go all JVM on the JITs. :-P
>
> I'm not against it although if we start to go this route I would want some
> way to quantify how we are increasing/descreasing load times.
>
>> 
>> > I figured I'd send the patch set out as more of a question than anything else.
>> > Specifically:
>> >
>> > * How should I go about measuring the performance of these sort of
>> >   optimizations?  I'd like to balance the time it takes to run the JIT with the
>> >   time spent executing the program, but I don't have any feel for what real BPF
>> >   programs look like or have any benchmark suite to run.  Is there something
>> >   out there this should be benchmarked against?  (I'd also like to know that to
>> >   run those benchmarks on the RISC-V port.)
>> 
>> If you run the selftests 'test_progs' with -v it'll measure/print the
>> execution time of the programs. I'd say *most* BPF program invokes a
>> helper (via call). It would be interesting to see, for say the
>> selftests, how often the optimization can be performed.
>> 
>> > * Is this the sort of thing that makes sense in a BPF JIT?  I guess I've just
>> >   realized I turned "review this patch" into a way bigger rabbit hole than I
>> >   really want to go down...
>> >
>> 
>> I'd say 'yes'. My hunch, and the workloads I've seen, BPF programs are
>> usually loaded, and then resident for a long time. So, the JIT time is
>> not super critical. The FB/Cilium folks can definitely provide a
>> better sample point, than my hunch. ;-)
>
> In our case the JIT time can be relevant because we are effectively holding
> up a kubernetes pod load waiting for programs to load. However, we can
> probably work-around it by doing more aggressive dynamic linking now that
> this is starting to land.
>
> It would be interesting to have a test to measure load time in selftests
> or selftests/benchmark/ perhaps. We have some of these out of tree we
> could push in I think if there is interest.

I'd be interested in some sort of benchmark suite for BPF.  Something like
selftests/bpf/benchmarks/ seems like a reasonable place to me.

>
>> 
>> 
>> Björn
