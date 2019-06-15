Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AC446E86
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 07:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfFOFxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 01:53:02 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38066 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfFOFxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 01:53:02 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so3105909qkk.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 22:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Kz+tawjj+TKGLusbM0dZKp0s2fiz0LpOWBpuEGiIXoo=;
        b=c4dwLIgGIFZILjgl4mh8YLfuK7rL81nwXA/1iHCW5MEKfrs9x4sPI2/59Aao2vYRK2
         JRupca19/9klmYhMoXAQRHQ524wIx8ItlLVH7TwwkzFrnbuPs+b+SL6MAw0etINOfGi1
         tCsAM1QcalwmxnHVmpsNlbCx2ryeQ5qltSyoWo2HuyhrQr4lI7s9VA97Y1tY8Xh1rTGW
         hoFH3XD2+VA6LJCqz5a3XMoCnW2Ge75kQgEAPtZ99qRZiN3MyPVYb4eM+8qjYalAeCEk
         fzbiw7rNGVCwUwVs92X2Jly94WDadpVcYijCGrJrNP7QrA3rTPQlnnII9aQ6e8UHacpS
         /QTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Kz+tawjj+TKGLusbM0dZKp0s2fiz0LpOWBpuEGiIXoo=;
        b=hhqqWXRFKe/Sjvjj+3pa0wu7X6+83UnZ7PLITqd1ZGTkqzzw03NPHQK0zQqnUMXV8k
         7lnznGMlcM3jb94oNx08s/p0GCwUkG0nQiT9Jvo5UJFJlVBjQABHGVzG97XjZSvj376d
         dpkWsjvKzRm3xDDTwiDdSL3mafV9XpUO47Hzaq2NF+/BqpaKssp4UeLDPl3w5esL5VAO
         8va479wWEj0R8aPfvdzoy/dk/NFlS3BPUY9yLsk0mm2ebThpWVKoaCvqHgHXawMsU4Yg
         tb9FAcvKC/1HKc0zWRdzvw9jkNfg1ZJU3xIeqOL3OQKI/Px3/HLZAsBMzXKmZ+Mn14Uz
         rNhg==
X-Gm-Message-State: APjAAAWWCBy6yv1mr15Wxvv9Ek7p2IAMwcpimJ4KCbOp7JNWAX6ZRZRQ
        q9h8hQKbIYoHQavAp+AVmm+Fhw==
X-Google-Smtp-Source: APXvYqzJ8qzubBN5LJ4SW5ilBdh7p6QC+o8PkqRdl/sW5CGmuBBVQ572Ghw9AI2yNX6P9ThsL+rFpg==
X-Received: by 2002:a05:620a:1661:: with SMTP id d1mr4643851qko.192.1560577981016;
        Fri, 14 Jun 2019 22:53:01 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id t67sm2494822qkf.34.2019.06.14.22.52.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Jun 2019 22:53:00 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:52:49 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 3/4] perf augmented_raw_syscalls: Support arm64 raw
 syscalls
Message-ID: <20190615055249.GA3742@leoy-ThinkPad-X240s>
References: <20190606094845.4800-4-leo.yan@linaro.org>
 <20190606133838.GC30166@kernel.org>
 <20190606141231.GC5970@leoy-ThinkPad-X240s>
 <20190606144412.GC21245@kernel.org>
 <20190607095831.GG5970@leoy-ThinkPad-X240s>
 <20190609131849.GB6357@leoy-ThinkPad-X240s>
 <20190610184754.GU21245@kernel.org>
 <20190611041831.GA3959@leoy-ThinkPad-X240s>
 <20190612024917.GG28689@kernel.org>
 <20190613181514.GC1402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613181514.GC1402@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 03:15:14PM -0300, Arnaldo Carvalho de Melo wrote:

[...]

> > > > diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> > > > index 1a2a605cf068..eb70a4b71755 100644
> > > > --- a/tools/perf/builtin-trace.c
> > > > +++ b/tools/perf/builtin-trace.c
> > > > @@ -1529,6 +1529,7 @@ static int trace__read_syscall_info(struct trace *trace, int id)
> > > >  static int trace__validate_ev_qualifier(struct trace *trace)
> > > >  {
> > > >  	int err = 0, i;
> > > > +	bool printed_invalid_prefix = false;
> > > >  	size_t nr_allocated;
> > > >  	struct str_node *pos;
> > > >  
> > > > @@ -1555,14 +1556,15 @@ static int trace__validate_ev_qualifier(struct trace *trace)
> > > >  			if (id >= 0)
> > > >  				goto matches;
> > > >  
> > > > -			if (err == 0) {
> > > > -				fputs("Error:\tInvalid syscall ", trace->output);
> > > > -				err = -EINVAL;
> > > > +			if (!printed_invalid_prefix) {
> > > > +				pr_debug("Skipping unknown syscalls: ");
> > > > +				printed_invalid_prefix = true;
> > > >  			} else {
> > > > -				fputs(", ", trace->output);
> > > > +				pr_debug(", ");
> > > >  			}
> > > >  
> > > > -			fputs(sc, trace->output);
> > > > +			pr_debug("%s", sc);
> > > > +			continue;
> > > 
> > > Here adds 'continue' so that we want to let ev_qualifier_ids.entries
> > > to only store valid system call ids.  But this is not sufficient,
> > > because we have initialized ev_qualifier_ids.nr at the beginning of
> > > the function:
> > > 
> > >   trace->ev_qualifier_ids.nr = strlist__nr_entries(trace->ev_qualifier);
> > > This sentence will set ids number to the string table's length; but
> > > actually some strings are not really supported; this leads to some
> > > items in trace->ev_qualifier_ids.entries[] will be not initialized
> > > properly.
> > > 
> > > If we want to get neat entries and entry number, I suggest at the
> > > beginning of the function we use variable 'nr_allocated' to store
> > > string table length and use it to allocate entries:
> > > 
> > >   nr_allocated = strlist__nr_entries(trace->ev_qualifier);
> > >   trace->ev_qualifier_ids.entries = malloc(nr_allocated *
> > >                                            sizeof(trace->ev_qualifier_ids.entries[0]));
> > > 
> > > If we find any matched string, then increment the nr field under
> > > 'matches' tag:
> > > 
> > > matches:
> > >                 trace->ev_qualifier_ids.nr++;
> > >                 trace->ev_qualifier_ids.entries[i++] = id;
> > > 
> > > This can ensure the entries[0..nr-1] has valid id and we can use
> > > ev_qualifier_ids.nr to maintain the valid system call numbers.
> > 
> > yeah, you're right, I'll address these issues in a followup patch,
> > tomorrow.
> 
> This is equivalent and I think the smallest patch, I'll add one on top
> doing what you suggested about nr_allocated getting the
> strlist__nr_entries() and also will rename i to nr_used to contrast with
> nr_allocated, and then at the end set ev_qualifier_ids.nr to nr_used.

Thanks for this patch, I tested below changes and 'perf trace' works
well.  You could add my test tag:

Tested-by: Leo Yan <leo.yan@linaro.org>

> - Arnaldo
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index eb70a4b71755..bd1f00e7a2eb 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1528,9 +1528,9 @@ static int trace__read_syscall_info(struct trace *trace, int id)
>  
>  static int trace__validate_ev_qualifier(struct trace *trace)
>  {
> -	int err = 0, i;
> +	int err = 0;
>  	bool printed_invalid_prefix = false;
> -	size_t nr_allocated;
> +	size_t nr_allocated, i;
>  	struct str_node *pos;
>  
>  	trace->ev_qualifier_ids.nr = strlist__nr_entries(trace->ev_qualifier);
> @@ -1575,7 +1575,7 @@ static int trace__validate_ev_qualifier(struct trace *trace)
>  			id = syscalltbl__strglobmatch_next(trace->sctbl, sc, &match_next);
>  			if (id < 0)
>  				break;
> -			if (nr_allocated == trace->ev_qualifier_ids.nr) {
> +			if (nr_allocated == i) {
>  				void *entries;
>  
>  				nr_allocated += 8;
> @@ -1588,11 +1588,11 @@ static int trace__validate_ev_qualifier(struct trace *trace)
>  				}
>  				trace->ev_qualifier_ids.entries = entries;
>  			}
> -			trace->ev_qualifier_ids.nr++;
>  			trace->ev_qualifier_ids.entries[i++] = id;
>  		}
>  	}
>  
> +	trace->ev_qualifier_ids.nr = i;
>  out:
>  	if (printed_invalid_prefix)
>  		pr_debug("\n");
