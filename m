Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61441555A5
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbfFYRON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:14:13 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41963 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbfFYROM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:14:12 -0400
Received: by mail-io1-f65.google.com with SMTP id w25so545638ioc.8
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 10:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rIEg9mImdLbOPWr5JcAO9mpGaP6d2/FlgncwQFfkJdw=;
        b=iFw/1dYYVqRHgcAh1TpJFGK77tujLxqxZtyDQdAChfPK8J2o5Z35qj7HlPTvAoJDh0
         0LUe8zRzcBUHlMIsII05VrtML3UOjVu/FQEjIrmezQ6XDdecyYt7zJPA5fpXIGdpt63p
         DHUgZqIHhAHn5Y29772IQWcGUWCAZyj5Z2xwo8VQFeDUCFWyvp8tluEdpnBnrkD63QQv
         TQwDL87DoNOU7cDCAPKgC+e7rxUyug338krujNQfqkEtiqWde1T1kd0ZNcLYKO+v1JaY
         zr5Ga8ex+w/NpqHgnMXiK+QpBeUCEVe1JKHl6CYdS6u3bHTHx1BMwcVsbzZ5dFI0KiG1
         qqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rIEg9mImdLbOPWr5JcAO9mpGaP6d2/FlgncwQFfkJdw=;
        b=flqIY5XFbbb8WYeg4xbuZnQvTW8IiKmoh1w2B6xB6V7aSWuZTtR+6/u0G3BaI7P3Kt
         oiNjjP9pLDm7ujagn3a+aCbt/vPdQweSPENZbVEeWRbiobhR2t/72ICRpPz/OGrNBeTd
         PIF4bF5ZN2kgftS7fESToqo9uLfFZPvaT9JRLxMHIWB0nQFzqdQQVIYOzFLMuTbTvpVp
         wlzU4MH1We4sfLZFVMEPirG2kMZqiEyWEteaP/aKbLPh5+/uLfkW57TFJAv/mW8jiN27
         Shw9/KzsGltqmGSGZx4cGAjVVfJq4YSQIPxnmQaK4qoEcU+FkyT5A1C4zE4aJXuoFd1T
         kOOQ==
X-Gm-Message-State: APjAAAVzlgfFrLmXoiK6/+eae0i1Elhe3T+xGZ3A1y7dwhLMslMRMpfw
        3IaKCQ4qKa6UKW1nyOWJnCZpxYdtuzgHrpNtrJfYxw==
X-Google-Smtp-Source: APXvYqxatAKGOw2Hd80AGbHfI0zoxMZ2N12wP/Os4mMS4dOimgUUQdghFbrjzzb/zt7brOd5o3IjqgB2yyjTx1aDKS8=
X-Received: by 2002:a05:6638:3d6:: with SMTP id r22mr457862jaq.71.1561482851619;
 Tue, 25 Jun 2019 10:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190617150024.11787-1-leo.yan@linaro.org> <CANLsYkyMW=WG+=yWTLSyMT3JXqd_2kvsrx9c-EwCoKEnRZvErA@mail.gmail.com>
 <20190620005829.GH24549@leoy-ThinkPad-X240s> <20190624190009.GE4181@kernel.org>
In-Reply-To: <20190624190009.GE4181@kernel.org>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Tue, 25 Jun 2019 11:14:00 -0600
Message-ID: <CANLsYkyOOS_ow_bRpok+V73_EBRg2yechwF0VHLtDBWB4VBEBw@mail.gmail.com>
Subject: Re: [PATCH] perf cs-etm: Improve completeness for kernel address space
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Leo Yan <leo.yan@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Coresight ML <coresight@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 at 13:00, Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Thu, Jun 20, 2019 at 08:58:29AM +0800, Leo Yan escreveu:
> > Hi Mathieu,
> >
> > On Wed, Jun 19, 2019 at 11:49:44AM -0600, Mathieu Poirier wrote:
> >
> > [...]
> >
> > > > diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> > > > index 51dd00f65709..4776c2c1fb6d 100644
> > > > --- a/tools/perf/Makefile.config
> > > > +++ b/tools/perf/Makefile.config
> > > > @@ -418,6 +418,30 @@ ifdef CORESIGHT
> > > >      endif
> > > >      LDFLAGS += $(LIBOPENCSD_LDFLAGS)
> > > >      EXTLIBS += $(OPENCSDLIBS)
> > > > +    ifneq ($(wildcard $(srctree)/arch/arm64/kernel/vmlinux.lds),)
> > > > +      # Extract info from lds:
> > > > +      #  . = ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
> > > > +      # ARM64_PRE_START_SIZE := (0x08000000 + 0x08000000 + 0x00080000)
> > > > +      ARM64_PRE_START_SIZE := $(shell egrep ' \. \= \({8}0x[0-9a-fA-F]+\){2}' \
> > > > +        $(srctree)/arch/arm64/kernel/vmlinux.lds | \
> > > > +        sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
> > > > +        awk -F' ' '{print "("$$6 "+"  $$7 "+" $$8")"}' 2>/dev/null)
> > > > +    else
> > > > +      ARM64_PRE_START_SIZE := 0
> > > > +    endif
> > > > +    CFLAGS += -DARM64_PRE_START_SIZE="$(ARM64_PRE_START_SIZE)"
> > > > +    ifneq ($(wildcard $(srctree)/arch/arm/kernel/vmlinux.lds),)
> > > > +      # Extract info from lds:
> > > > +      #   . = ((0xC0000000)) + 0x00208000;
> > > > +      # ARM_PRE_START_SIZE := 0x00208000
> > > > +      ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({2}0x[0-9a-fA-F]+\){2}' \
> > > > +        $(srctree)/arch/arm/kernel/vmlinux.lds | \
> > > > +        sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
> > > > +        awk -F' ' '{print "("$$2")"}' 2>/dev/null)
> > > > +    else
> > > > +      ARM_PRE_START_SIZE := 0
> > > > +    endif
> > > > +    CFLAGS += -DARM_PRE_START_SIZE="$(ARM_PRE_START_SIZE)"
> > > >      $(call detected,CONFIG_LIBOPENCSD)
> > > >      ifdef CSTRACE_RAW
> > > >        CFLAGS += -DCS_DEBUG_RAW
> > > > diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> > > > index 0c7776b51045..ae831f836c70 100644
> > > > --- a/tools/perf/util/cs-etm.c
> > > > +++ b/tools/perf/util/cs-etm.c
> > > > @@ -613,10 +613,34 @@ static void cs_etm__free(struct perf_session *session)
> > > >  static u8 cs_etm__cpu_mode(struct cs_etm_queue *etmq, u64 address)
> > > >  {
> > > >         struct machine *machine;
> > > > +       u64 fixup_kernel_start = 0;
> > > > +       const char *arch;
> > > >
> > > >         machine = etmq->etm->machine;
> > > > +       arch = perf_env__arch(machine->env);
> > > >
> > > > -       if (address >= etmq->etm->kernel_start) {
> > > > +       /*
> > > > +        * Since arm and arm64 specify some memory regions prior to
> > > > +        * 'kernel_start', kernel addresses can be less than 'kernel_start'.
> > > > +        *
> > > > +        * For arm architecture, the 16MB virtual memory space prior to
> > > > +        * 'kernel_start' is allocated to device modules, a PMD table if
> > > > +        * CONFIG_HIGHMEM is enabled and a PGD table.
> > > > +        *
> > > > +        * For arm64 architecture, the root PGD table, device module memory
> > > > +        * region and BPF jit region are prior to 'kernel_start'.
> > > > +        *
> > > > +        * To reflect the complete kernel address space, compensate these
> > > > +        * pre-defined regions for kernel start address.
> > > > +        */
> > > > +       if (!strcmp(arch, "arm64"))
> > > > +               fixup_kernel_start = etmq->etm->kernel_start -
> > > > +                                    ARM64_PRE_START_SIZE;
> > > > +       else if (!strcmp(arch, "arm"))
> > > > +               fixup_kernel_start = etmq->etm->kernel_start -
> > > > +                                    ARM_PRE_START_SIZE;
> > >
> > > I will test your work but from a quick look wouldn't it be better to
> > > have a single define name here?  From looking at the modifications you
> > > did to Makefile.config there doesn't seem to be a reason to have two.
> >
> > Thanks for suggestion.  I changed to use single define
> > ARM_PRE_START_SIZE and sent patch v2 [1].
> >
> > If possible, please test patch v2.
> >
> > Thanks,
> > Leo Yan
>
> So just for the record, I'm waiting for Mathieu on this one, i.e. for
> him to test/ack v3.

Right, please give me some time to test this.  As Leo indicated the
procedure is time consuming.

Thanks,
Mathieu

>
> - Arnaldo
>
> > [1] https://lore.kernel.org/linux-arm-kernel/20190620005428.20883-1-leo.yan@linaro.org/T/#u
> >
> > > > +
> > > > +       if (address >= fixup_kernel_start) {
> > > >                 if (machine__is_host(machine))
> > > >                         return PERF_RECORD_MISC_KERNEL;
> > > >                 else
> > > > --
> > > > 2.17.1
> > > >
>
> --
>
> - Arnaldo
