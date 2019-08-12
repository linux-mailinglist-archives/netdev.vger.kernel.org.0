Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD15897FD
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfHLHjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:39:40 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44555 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfHLHjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 03:39:40 -0400
Received: by mail-pf1-f193.google.com with SMTP id c81so277027pfc.11
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 00:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2quQnHJeT9Fa5IrcwEwRCo1YcerZTXomN5HFRZFMkZA=;
        b=UZbvpYbcRKMB/b1QsY8X3xIXLrbQEdCpA4iv13KRfFJsy7ZRirVFICaxDYOri61lmI
         /kPemgdrhQXdHaDh5SYmHoB06YaJICbPKKh5UjTUqeOZPR0/yAVReQ981EUoIPLWHoue
         HdNp0+7bLSTsZQ3ZzvBkRI4aNF8cSRi6tEwa3xCZMoD3V//LdModJ5MZxOCsiEGWUmwf
         5ftBQ9yml82PT+YSCWCIa/cGWj7xRg6+KIfxzDqQz95QAfsqF5syMu2pj7crCYOp5MwK
         lZ3e2Qxq9uOgPMIZ4d7gc7E8ffRUBNVI8KTgbRriTGU/JNG6ndglyx8GhUTUP9KaHqCA
         CUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2quQnHJeT9Fa5IrcwEwRCo1YcerZTXomN5HFRZFMkZA=;
        b=Qk6Tuf57n8aNRL+nebO8cK+5x78355Gqsf4yrwPyoYK7FCLLAJVwqsgEueKlKgZKIq
         +FHXcHTxNqFJybXR/rCWlvzEh41dUN4QNkXJtL4Yjtg7dP8pwtmKUp4xiXR0A21YKcNE
         IzNwzPDNX3p2HmLV8BXL6Lm7elM/pEzgi4DmJt5bMJ/NGnS0WyRksX2RxqsAu7EOnNZa
         IbI4C6ApiwZMWd+gD4hwsDxLTJLIntW7jMeGJNItZjvSW8vVyh1LAu05UGDKCFObsAJh
         gYClPwltqNfpZRyLPpoozRGgk/PcQuoqvD5jVNmLoPfXwRubqvSna265FvKwhTFZWO7h
         2a5Q==
X-Gm-Message-State: APjAAAUFxjmfd08oBZqChRYLL48FHXNO39vrgFg8sWcC6WwwDXo0CFpq
        sFX2KNrS8N/r03P6Ivcip2v8qzT98xGvIA==
X-Google-Smtp-Source: APXvYqxsTbOEkvNmm97I6dKg6Jvq/xPehRt6IenrYIjfZP9tbVsVlR9H+zzFNqA/n8mNeFGwsh9AAw==
X-Received: by 2002:a65:4505:: with SMTP id n5mr26188138pgq.301.1565595579238;
        Mon, 12 Aug 2019 00:39:39 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id k6sm115551672pfi.12.2019.08.12.00.39.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 12 Aug 2019 00:39:38 -0700 (PDT)
Date:   Mon, 12 Aug 2019 15:39:31 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Milian Wolff <milian.wolff@kdab.com>,
        Donald Yandt <donald.yandt@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Wei Li <liwei391@huawei.com>, Mark Drayton <mbd@fb.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v4 1/2] perf machine: Support arch's specific kernel
 start address
Message-ID: <20190812073931.GB8062@leoy-ThinkPad-X240s>
References: <20190810072135.27072-1-leo.yan@linaro.org>
 <20190810072135.27072-2-leo.yan@linaro.org>
 <c1818f6f-37df-6971-fddc-6663e5b6ff95@intel.com>
 <20190812070236.GA8062@leoy-ThinkPad-X240s>
 <250165c6-908a-c57e-8d83-03da4272f568@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <250165c6-908a-c57e-8d83-03da4272f568@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 10:23:21AM +0300, Adrian Hunter wrote:
> On 12/08/19 10:02 AM, Leo Yan wrote:
> > On Mon, Aug 12, 2019 at 09:37:33AM +0300, Adrian Hunter wrote:
> >> On 10/08/19 10:21 AM, Leo Yan wrote:
> >>> machine__get_kernel_start() gives out the kernel start address; some
> >>> architectures need to tweak the start address so that can reflect the
> >>> kernel start address correctly.  This is not only for x86_64 arch, but
> >>> it is also required by other architectures, e.g. arm/arm64 needs to
> >>> tweak the kernel start address so can include the kernel memory regions
> >>> which are used before the '_stext' symbol.
> >>>
> >>> This patch refactors machine__get_kernel_start() by adding a weak
> >>> arch__fix_kernel_text_start(), any architecture can implement it to
> >>> tweak its specific start address; this also allows the arch specific
> >>> code to be placed into 'arch' folder.
> >>>
> >>> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> >>> ---
> >>>  tools/perf/arch/x86/util/machine.c | 10 ++++++++++
> >>>  tools/perf/util/machine.c          | 13 +++++++------
> >>>  tools/perf/util/machine.h          |  2 ++
> >>>  3 files changed, 19 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/tools/perf/arch/x86/util/machine.c b/tools/perf/arch/x86/util/machine.c
> >>> index 1e9ec783b9a1..9f012131534a 100644
> >>> --- a/tools/perf/arch/x86/util/machine.c
> >>> +++ b/tools/perf/arch/x86/util/machine.c
> >>> @@ -101,4 +101,14 @@ int machine__create_extra_kernel_maps(struct machine *machine,
> >>>  	return ret;
> >>>  }
> >>>  
> >>> +void arch__fix_kernel_text_start(u64 *start)
> >>> +{
> >>> +	/*
> >>> +	 * On x86_64, PTI entry trampolines are less than the
> >>> +	 * start of kernel text, but still above 2^63. So leave
> >>> +	 * kernel_start = 1ULL << 63 for x86_64.
> >>> +	 */
> >>> +	*start = 1ULL << 63;
> >>> +}
> >>
> >> That is needed for reporting x86 data on any arch i.e. it is not specific to
> >> the compile-time architecture, it is specific to the perf.data file
> >> architecture, which is what machine__is() compares. So, this looks wrong.
> > 
> > Thanks for reviewing, Adrian.
> > 
> > If so, I think we should extend the function machine__get_kernel_start()
> > as below; for building successfully, will always define the macro
> > ARM_PRE_START_SIZE in Makefile.config.
> > 
> > @Arnaldo, @Adrian, Please let me know if this works for you?
> 
> I don't know how you intend to calculate ARM_PRE_START_SIZE, but below is OK
> for x86.
> 
> > 
> > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > index f6ee7fbad3e4..30a0ff627263 100644
> > --- a/tools/perf/util/machine.c
> > +++ b/tools/perf/util/machine.c
> > @@ -2687,13 +2687,26 @@ int machine__get_kernel_start(struct machine *machine)
> >         machine->kernel_start = 1ULL << 63;
> >         if (map) {
> >                 err = map__load(map);
> > +               if (err)
> > +                       return err;
> > +
> >                 /*
> >                  * On x86_64, PTI entry trampolines are less than the
> >                  * start of kernel text, but still above 2^63. So leave
> >                  * kernel_start = 1ULL << 63 for x86_64.
> >                  */
> > -               if (!err && !machine__is(machine, "x86_64"))
> > +               if (!machine__is(machine, "x86_64"))
> >                         machine->kernel_start = map->start;
> > +
> > +               /*
> > +                * On arm/arm64, some memory regions are prior to '_stext'
> > +                * symbol; to reflect the complete kernel address space,
> > +                * compensate these pre-defined regions for kernel start
> > +                * address.
> > +                */
> > +               if (machine__is(machine, "arm64") ||
> > +                   machine__is(machine, "arm"))
> 
> machine__is() does not normalize the architecture, so you may want to use
> perf_env__arch() instead.

You are right, thanks for suggestion.  Will use perf_env__arch() in
next spin.

Thanks,
Leo Yan

> 
> > +                       machine->kernel_start -= ARM_PRE_START_SIZE;
> >         }
> >         return err;
> >  }

[...]
