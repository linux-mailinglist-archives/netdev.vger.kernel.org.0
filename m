Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7ED651B11
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 21:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfFXTA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 15:00:27 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41216 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfFXTA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 15:00:27 -0400
Received: by mail-qk1-f195.google.com with SMTP id c11so10593082qkk.8;
        Mon, 24 Jun 2019 12:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jLe9rsWPnlF5E8hqDCO/kSAryjkkZLhq+lQJt0LPNsM=;
        b=cFOczVForZZ0SZUzzYOzAfpcG3WInUSHcvbb4qSoAWCggO67XYv3JHFiSUina2IauF
         lxnZUyt3yQCuKxuxpg/mB4fR0I0u+O6SYuGInjQvp6INdWnuyI0y6AlzaVcdUxPcQFxt
         ulFy3aBZAidsEm39HpWgXluE5Aegt5TOsUi8+PiOeAsjUjeLaGWV75LcscnSPVmbpaK+
         Fu/D/LEUe34Q/BPRdJS8Ov9WpCpt4BdmlWUpnbZA1sbyqqjovoxLtXby9T/a9CiABEzq
         Z46qn20dL+LR3GTH5UJHi6VoiwMRPhJU0UbxwZcdKvlBWavlo3Km6rCGB3+gc1ZHBw9L
         IjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jLe9rsWPnlF5E8hqDCO/kSAryjkkZLhq+lQJt0LPNsM=;
        b=aYZ6cUX9u7djsljri6cEkt/hucQUOFoDPJ1xgj66baY3CV+5rbDPlr0DKWSFJiXoa0
         RlBWJvB4QwULsFLtYrY6iXb7bbgzMGZtac09XH7FqqAwKVeUjrXqJnynBWV4IMTuOSUQ
         K6vLErdSXq+v546dzFZLtc8KypbZp7yeKpRMqTYxjBYKMa4E7/pS/uWU/vCUhbXGIrpL
         d3nvoET+HK6Wr6k3sh4F3F83b/ZAsml1AXwjRc+8vTmLCk3ylkSSLJ6hJotJXp3ghH5p
         p8hhszx5KuBbJMSQelCqqCIkg9VOJ5z35Ewh/OKsL2M4/tJVqBtgNwf+bqVrt6EYy1Ub
         4uqg==
X-Gm-Message-State: APjAAAV7NEHh9msTDUai476xhLNOsEXzhHBZ+jOdUr6a2pWe6rLG6Vwp
        Jhn7xOWcTUAjKZ4pZjKG/WY=
X-Google-Smtp-Source: APXvYqxH1PPatDijts/eOpzI83A95Elb5STnJn33I/c01bWUEAHnudlt9D1Fy2HNQWV0ACtjkgbKiw==
X-Received: by 2002:a37:a643:: with SMTP id p64mr103665746qke.36.1561402825968;
        Mon, 24 Jun 2019 12:00:25 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.11])
        by smtp.gmail.com with ESMTPSA id d199sm6062744qkg.116.2019.06.24.12.00.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 12:00:25 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id F01D341153; Mon, 24 Jun 2019 16:00:09 -0300 (-03)
Date:   Mon, 24 Jun 2019 16:00:09 -0300
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Coresight ML <coresight@lists.linaro.org>
Subject: Re: [PATCH] perf cs-etm: Improve completeness for kernel address
 space
Message-ID: <20190624190009.GE4181@kernel.org>
References: <20190617150024.11787-1-leo.yan@linaro.org>
 <CANLsYkyMW=WG+=yWTLSyMT3JXqd_2kvsrx9c-EwCoKEnRZvErA@mail.gmail.com>
 <20190620005829.GH24549@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620005829.GH24549@leoy-ThinkPad-X240s>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 20, 2019 at 08:58:29AM +0800, Leo Yan escreveu:
> Hi Mathieu,
> 
> On Wed, Jun 19, 2019 at 11:49:44AM -0600, Mathieu Poirier wrote:
> 
> [...]
> 
> > > diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> > > index 51dd00f65709..4776c2c1fb6d 100644
> > > --- a/tools/perf/Makefile.config
> > > +++ b/tools/perf/Makefile.config
> > > @@ -418,6 +418,30 @@ ifdef CORESIGHT
> > >      endif
> > >      LDFLAGS += $(LIBOPENCSD_LDFLAGS)
> > >      EXTLIBS += $(OPENCSDLIBS)
> > > +    ifneq ($(wildcard $(srctree)/arch/arm64/kernel/vmlinux.lds),)
> > > +      # Extract info from lds:
> > > +      #  . = ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
> > > +      # ARM64_PRE_START_SIZE := (0x08000000 + 0x08000000 + 0x00080000)
> > > +      ARM64_PRE_START_SIZE := $(shell egrep ' \. \= \({8}0x[0-9a-fA-F]+\){2}' \
> > > +        $(srctree)/arch/arm64/kernel/vmlinux.lds | \
> > > +        sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
> > > +        awk -F' ' '{print "("$$6 "+"  $$7 "+" $$8")"}' 2>/dev/null)
> > > +    else
> > > +      ARM64_PRE_START_SIZE := 0
> > > +    endif
> > > +    CFLAGS += -DARM64_PRE_START_SIZE="$(ARM64_PRE_START_SIZE)"
> > > +    ifneq ($(wildcard $(srctree)/arch/arm/kernel/vmlinux.lds),)
> > > +      # Extract info from lds:
> > > +      #   . = ((0xC0000000)) + 0x00208000;
> > > +      # ARM_PRE_START_SIZE := 0x00208000
> > > +      ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({2}0x[0-9a-fA-F]+\){2}' \
> > > +        $(srctree)/arch/arm/kernel/vmlinux.lds | \
> > > +        sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
> > > +        awk -F' ' '{print "("$$2")"}' 2>/dev/null)
> > > +    else
> > > +      ARM_PRE_START_SIZE := 0
> > > +    endif
> > > +    CFLAGS += -DARM_PRE_START_SIZE="$(ARM_PRE_START_SIZE)"
> > >      $(call detected,CONFIG_LIBOPENCSD)
> > >      ifdef CSTRACE_RAW
> > >        CFLAGS += -DCS_DEBUG_RAW
> > > diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> > > index 0c7776b51045..ae831f836c70 100644
> > > --- a/tools/perf/util/cs-etm.c
> > > +++ b/tools/perf/util/cs-etm.c
> > > @@ -613,10 +613,34 @@ static void cs_etm__free(struct perf_session *session)
> > >  static u8 cs_etm__cpu_mode(struct cs_etm_queue *etmq, u64 address)
> > >  {
> > >         struct machine *machine;
> > > +       u64 fixup_kernel_start = 0;
> > > +       const char *arch;
> > >
> > >         machine = etmq->etm->machine;
> > > +       arch = perf_env__arch(machine->env);
> > >
> > > -       if (address >= etmq->etm->kernel_start) {
> > > +       /*
> > > +        * Since arm and arm64 specify some memory regions prior to
> > > +        * 'kernel_start', kernel addresses can be less than 'kernel_start'.
> > > +        *
> > > +        * For arm architecture, the 16MB virtual memory space prior to
> > > +        * 'kernel_start' is allocated to device modules, a PMD table if
> > > +        * CONFIG_HIGHMEM is enabled and a PGD table.
> > > +        *
> > > +        * For arm64 architecture, the root PGD table, device module memory
> > > +        * region and BPF jit region are prior to 'kernel_start'.
> > > +        *
> > > +        * To reflect the complete kernel address space, compensate these
> > > +        * pre-defined regions for kernel start address.
> > > +        */
> > > +       if (!strcmp(arch, "arm64"))
> > > +               fixup_kernel_start = etmq->etm->kernel_start -
> > > +                                    ARM64_PRE_START_SIZE;
> > > +       else if (!strcmp(arch, "arm"))
> > > +               fixup_kernel_start = etmq->etm->kernel_start -
> > > +                                    ARM_PRE_START_SIZE;
> > 
> > I will test your work but from a quick look wouldn't it be better to
> > have a single define name here?  From looking at the modifications you
> > did to Makefile.config there doesn't seem to be a reason to have two.
> 
> Thanks for suggestion.  I changed to use single define
> ARM_PRE_START_SIZE and sent patch v2 [1].
> 
> If possible, please test patch v2.
> 
> Thanks,
> Leo Yan

So just for the record, I'm waiting for Mathieu on this one, i.e. for
him to test/ack v3.

- Arnaldo
 
> [1] https://lore.kernel.org/linux-arm-kernel/20190620005428.20883-1-leo.yan@linaro.org/T/#u
> 
> > > +
> > > +       if (address >= fixup_kernel_start) {
> > >                 if (machine__is_host(machine))
> > >                         return PERF_RECORD_MISC_KERNEL;
> > >                 else
> > > --
> > > 2.17.1
> > >

-- 

- Arnaldo
