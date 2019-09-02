Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC12EA58F9
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 16:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfIBOPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 10:15:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37973 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfIBOPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 10:15:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id u190so12640405qkh.5
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 07:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vg5cV8RgYZAUwO4BlUHQDzrdFcjapkG4a4PKGmuKmDk=;
        b=mj/Q0KsoKkL2aU8JZYYOHHonFGHI32S47bwd5c/tBzZWVQqk20Z5lLx+BxwVj/27qU
         CVKjoFn4KS2uLQ/mVkJkNF2mAgDtmCdpBVGUKns+p5oTekFtv67IL8RRWmpZqFtxaZ3U
         v2gxg4Ku+yL/kAxYWoaL9NFMXqoa40a0L1BCLjo/4mrl/lj0XaHeavdXQVStmMlhMohI
         GtAbBq5vOdH/MuvS6pe6D9Sdce9cGAjxA0OGr3pmJ+a3bnABM0SX6/QPtxwY8LhWztnJ
         GuG0qHfkIj9uf2P8ls1l987c+SgQm0iqRt/CuNzTsAGgvJIL4p+Kb21tQgfa6Cxq6myZ
         wTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vg5cV8RgYZAUwO4BlUHQDzrdFcjapkG4a4PKGmuKmDk=;
        b=uW0JawJbXKNnnnz4BqPf8qMlCKPu4XrHI33zXnJcC11O82fB457iVtSD8V3C9xc0f5
         w3vTAkQ6R9NevQrxgoTc8JezVA5ussPSsgye/Z9JBseKFMEs89Sm3paost/oM4YKMh6S
         Mcoe/Mdf8XWpkIgZ469aTMWCrbMsonMyGLzUAV6STvS1CGNcYDC4gJeoz/DQMBR02whm
         qnkbUo5+iDjr36/CQ7DvtiBIQrgVsdJNYIEpbriJvNCjTdYXvHj5yRzDlW9pKMKA68Dn
         FlexSwoJcVwlUdR7wM8KR+05kkcsBlq/iAb87kW6bBhP8oKsvTly9Sz9OCk/f6xrEaDN
         WS4w==
X-Gm-Message-State: APjAAAWvLPflELpBa8w88Y74v6hPNSFKNvhK59YXX4Im6yoWpBRxfT2S
        ibcip2ncGJwCS3TQ/a+iN5IIYg==
X-Google-Smtp-Source: APXvYqwh5YLrf3v8H14X6qT6Rudakihge2BEBvIqE2ipHpxFGIlfyf61HS+kjaheOm4zXVDWDgA7sA==
X-Received: by 2002:a37:de14:: with SMTP id h20mr26496247qkj.260.1567433729523;
        Mon, 02 Sep 2019 07:15:29 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1320-244.members.linode.com. [45.79.221.244])
        by smtp.gmail.com with ESMTPSA id d45sm3752547qtc.70.2019.09.02.07.15.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 02 Sep 2019 07:15:28 -0700 (PDT)
Date:   Mon, 2 Sep 2019 22:15:11 +0800
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5] perf machine: arm/arm64: Improve completeness for
 kernel address space
Message-ID: <20190902141511.GF4931@leoy-ThinkPad-X240s>
References: <20190815082521.16885-1-leo.yan@linaro.org>
 <d874e6b3-c115-6c8c-bb12-160cfd600505@intel.com>
 <20190815113242.GA28881@leoy-ThinkPad-X240s>
 <e0919e39-7607-815b-3a12-96f098e45a5f@intel.com>
 <20190816014541.GA17960@leoy-ThinkPad-X240s>
 <363577f1-097e-eddd-a6ca-b23f644dd8ce@intel.com>
 <20190826125105.GA3288@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826125105.GA3288@leoy-ThinkPad-X240s>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adrian,

On Mon, Aug 26, 2019 at 08:51:05PM +0800, Leo Yan wrote:
> Hi Adrian,
> 
> On Fri, Aug 16, 2019 at 04:00:02PM +0300, Adrian Hunter wrote:
> > On 16/08/19 4:45 AM, Leo Yan wrote:
> > > Hi Adrian,
> > > 
> > > On Thu, Aug 15, 2019 at 02:45:57PM +0300, Adrian Hunter wrote:
> > > 
> > > [...]
> > > 
> > >>>> How come you cannot use kallsyms to get the information?
> > >>>
> > >>> Thanks for pointing out this.  Sorry I skipped your comment "I don't
> > >>> know how you intend to calculate ARM_PRE_START_SIZE" when you reviewed
> > >>> the patch v3, I should use that chance to elaborate the detailed idea
> > >>> and so can get more feedback/guidance before procceed.
> > >>>
> > >>> Actually, I have considered to use kallsyms when worked on the previous
> > >>> patch set.
> > >>>
> > >>> As mentioned in patch set v4's cover letter, I tried to implement
> > >>> machine__create_extra_kernel_maps() for arm/arm64, the purpose is to
> > >>> parse kallsyms so can find more kernel maps and thus also can fixup
> > >>> the kernel start address.  But I found the 'perf script' tool directly
> > >>> calls machine__get_kernel_start() instead of running into the flow for
> > >>> machine__create_extra_kernel_maps();
> > >>
> > >> Doesn't it just need to loop through each kernel map to find the lowest
> > >> start address?
> > > 
> > > Based on your suggestion, I worked out below change and verified it
> > > can work well on arm64 for fixing up start address; please let me know
> > > if the change works for you?
> > 
> > How does that work if take a perf.data file to a machine with a different
> > architecture?
> 
> Sorry I delayed so long to respond to your question; I didn't have
> confidence to give out very reasonale answer and this is the main reason
> for delaying.

Could you take chance to review my below replying?  I'd like to get
your confirmation before I send out offical patch.

Thanks,
Leo Yan

> 
> For your question for taking a perf.data file to a machine with a
> different architecture, we can firstly use command 'perf buildid-list'
> to print out the buildid for kallsyms, based on the dumped buildid we
> can find out the location for the saved kallsyms file; then we can use
> option '--kallsyms' to specify the offline kallsyms file and use the
> offline kallsyms to fixup kernel start address.  The detailed commands
> are listed as below:
> 
> root@debian:~# perf buildid-list
> 7b36dfca8317ef74974ebd7ee5ec0a8b35c97640 [kernel.kallsyms]
> 56b84aa88a1bcfe222a97a53698b92723a3977ca /usr/lib/systemd/systemd
> 0956b952e9cd673d48ff2cfeb1a9dbd0c853e686 /usr/lib/aarch64-linux-gnu/libm-2.28.so
> [...]
> 
> root@debian:~# perf script --kallsyms ~/.debug/\[kernel.kallsyms\]/7b36dfca8317ef74974ebd7ee5ec0a8b35c97640/kallsyms
> 
> The amended patch is as below, please review and always welcome
> any suggestions or comments!
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 5734460fc89e..593f05cc453f 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -2672,9 +2672,26 @@ int machine__nr_cpus_avail(struct machine *machine)
>  	return machine ? perf_env__nr_cpus_avail(machine->env) : 0;
>  }
>  
> +static int machine__fixup_kernel_start(void *arg,
> +				       const char *name __maybe_unused,
> +				       char type,
> +				       u64 start)
> +{
> +	struct machine *machine = arg;
> +
> +	type = toupper(type);
> +
> +	/* Fixup for text, weak, data and bss sections. */
> +	if (type == 'T' || type == 'W' || type == 'D' || type == 'B')
> +		machine->kernel_start = min(machine->kernel_start, start);
> +
> +	return 0;
> +}
> +
>  int machine__get_kernel_start(struct machine *machine)
>  {
>  	struct map *map = machine__kernel_map(machine);
> +	char filename[PATH_MAX];
>  	int err = 0;
>  
>  	/*
> @@ -2696,6 +2713,22 @@ int machine__get_kernel_start(struct machine *machine)
>  		if (!err && !machine__is(machine, "x86_64"))
>  			machine->kernel_start = map->start;
>  	}
> +
> +	if (symbol_conf.kallsyms_name != NULL) {
> +		strncpy(filename, symbol_conf.kallsyms_name, PATH_MAX);
> +	} else {
> +		machine__get_kallsyms_filename(machine, filename, PATH_MAX);
> +
> +		if (symbol__restricted_filename(filename, "/proc/kallsyms"))
> +			goto out;
> +	}
> +
> +	if (kallsyms__parse(filename, machine, machine__fixup_kernel_start))
> +		pr_warning("Fail to fixup kernel start address. skipping...\n");
> +
> +out:
>  	return err;
>  }
>  
> 
> Thanks,
> Leo Yan
