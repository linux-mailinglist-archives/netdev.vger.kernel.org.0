Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C36641A80
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 04:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408511AbfFLCtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 22:49:22 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42713 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404957AbfFLCtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 22:49:22 -0400
Received: by mail-qk1-f196.google.com with SMTP id b18so9056290qkc.9;
        Tue, 11 Jun 2019 19:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QfRBKMSV9Pg/UPNA8gUdodUQ7zfHLKMZ7P3Pxby4Mrs=;
        b=R9ziGZQI882mg9rxm6w7FvvcSgPKG4oN0h3Ods2BR3IKTXz7u5/FeJ7j63Kc20Abm2
         v4k5zo9onKKYrIrJ3H7uvd0RrISy8sBq5NiYX+llaHvjB+sIi477gt8Mu3t826v+WId9
         OZc9DUL1FOp1Ze2yVUWyNrrhjI2+ITmgfNnUtvy2EBypnpcuU+2RVDPAxwcTc75QD73g
         3n50TGj9C7cDkAUtsZ22QqwHOh38c/Jw4x6skA7fphWI05+wsK/g571HChkP7GFsKLsQ
         d4ZNLdOFKnP73q3Nm2Tm3T8Ov6AFXqWBxKTME7KNFaLmCFyvfluFRrmx2iNh3hR/4MZD
         BwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QfRBKMSV9Pg/UPNA8gUdodUQ7zfHLKMZ7P3Pxby4Mrs=;
        b=bWkIcxjfYMopG9ZFH9hm5GyhIoNydj1zCLWf1D36LKjAD69ML5ckOBLAneo1u1q6SD
         zKN4YOvLmALvBh4VQe0nXTfgvpsA+Z8XhRP/61Pz9B7DfWMIqwaw2EB5MCaHXyG5ZHJF
         qq7ixr12oN0Ze6oqUTFtW+qfxCPREzBx5cL5B+PQnBMtCzFdegckwTXAm87QkVcGHxjb
         e8CMLNBMkcyPg1IUDH7Ti9+TCINH0CNXztWtzm0ofmKzYLLb+mHPT86Y4U1GpijhwRW8
         P5Bz4LUK+LuSI0fJqmkhDAfX7OkGQS2XUexo8XhLuSgY97F4ljQiaWDfu6R9LPtmCG31
         jQig==
X-Gm-Message-State: APjAAAV5J8sKD2YuZ3Lwagrs8AuSR4HaNcv9khRazGSs31w70Da1fWFp
        8TlbT7iqzfMkwVKODz3XDP8=
X-Google-Smtp-Source: APXvYqzv2t1AZqinj73eh/fLlsXmeqWh3zwybOQEf95jx1Pl3/VrYjEVuthXqUzx91YOQFNMQjhwvg==
X-Received: by 2002:a37:4152:: with SMTP id o79mr35725514qka.276.1560307760909;
        Tue, 11 Jun 2019 19:49:20 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.11])
        by smtp.gmail.com with ESMTPSA id r5sm2253506qkc.42.2019.06.11.19.49.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 19:49:19 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D21EA41149; Tue, 11 Jun 2019 23:49:17 -0300 (-03)
Date:   Tue, 11 Jun 2019 23:49:17 -0300
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
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
Message-ID: <20190612024917.GG28689@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-4-leo.yan@linaro.org>
 <20190606133838.GC30166@kernel.org>
 <20190606141231.GC5970@leoy-ThinkPad-X240s>
 <20190606144412.GC21245@kernel.org>
 <20190607095831.GG5970@leoy-ThinkPad-X240s>
 <20190609131849.GB6357@leoy-ThinkPad-X240s>
 <20190610184754.GU21245@kernel.org>
 <20190611041831.GA3959@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611041831.GA3959@leoy-ThinkPad-X240s>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jun 11, 2019 at 12:18:31PM +0800, Leo Yan escreveu:
> On Mon, Jun 10, 2019 at 03:47:54PM -0300, Arnaldo Carvalho de Melo wrote:
> 
> [...]
> 
> > > > I tested with the lastest perf/core branch which contains the patch:
> > > > 'perf augmented_raw_syscalls: Tell which args are filenames and how
> > > > many bytes to copy' and got the error as below:
> > > > 
> > > > # perf trace -e string -e /mnt/linux-kernel/linux-cs-dev/tools/perf/examples/bpf/augmented_raw_syscalls.c
> > > > Error:  Invalid syscall access, chmod, chown, creat, futimesat, lchown, link, lstat, mkdir, mknod, newfstatat, open, readlink, rename,
> > > > rmdir, stat, statfs, symlink, truncate, unlink
> > 
> > Humm, I think that we can just make the code that parses the
> > tools/perf/trace/strace/groups/string file to ignore syscalls it can't
> > find in the syscall_tbl, i.e. trace those if they exist in the arch.
> 
> Agree.
> 
> > > > Hint:   try 'perf list syscalls:sys_enter_*'
> > > > Hint:   and: 'man syscalls'
> > > > 
> > > > So seems mksyscalltbl has not included completely for syscalls, I
> > > > use below command to generate syscalltbl_arm64[] array and it don't
> > > > include related entries for access, chmod, chown, etc ...
> > 
> > So, we need to investigate why is that these are missing, good thing we
> > have this 'strings' group :-)
> > 
> > > > You could refer the generated syscalltbl_arm64 in:
> > > > http://paste.ubuntu.com/p/8Bj7Jkm2mP/
> > > 
> > > After digging into this issue on Arm64, below is summary info:
> > > 
> > > - arm64 uses the header include/uapi/linux/unistd.h to define system
> > >   call numbers, in this header some system calls are not defined (I
> > >   think the reason is these system calls are obsolete at the end) so the
> > >   corresponding strings are missed in the array syscalltbl_native,
> > >   for arm64 the array is defined in the file:
> > >   tools/perf/arch/arm64/include/generated/asm/syscalls.c.
> > 
> > Yeah, I looked at the 'access' case and indeed it is not present in
> > include/uapi/asm-generic/unistd.h, which is the place
> > include/uapi/linux/unistd.h ends up.
> > 
> > Ok please take a look at the patch at the end of this message, should be ok?
> > 
> > I tested it by changing the strace/gorups/string file to have a few
> > unknown syscalls, running it with -v we see:
> > 
> > [root@quaco perf]# perf trace -v -e string ls
> > Skipping unknown syscalls: access99, acct99, add_key99
> > <SNIP other verbose messages>
> > normal operation not considering those unknown syscalls.
> 
> I did testing with the patch, but it failed after I added eBPF event
> with below command, I even saw segmentation fault; please see below
> inline comments.
> 
>   perf --debug verbose=10 trace -e string -e \
>     /mnt/linux-kernel/linux-cs-dev/tools/perf/examples/bpf/augmented_raw_syscalls.c
> 
> [...]
> 
> > commit e0b34a78c4ed0a6422f5b2dafa0c8936e537ee41
> > Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Date:   Mon Jun 10 15:37:45 2019 -0300
> > 
> >     perf trace: Skip unknown syscalls when expanding strace like syscall groups
> >     
> >     We have $INSTALL_DIR/share/perf-core/strace/groups/string files with
> >     syscalls that should be selected when 'string' is used, meaning, in this
> >     case, syscalls that receive as one of its arguments a string, like a
> >     pathname.
> >     
> >     But those were first selected and tested on x86_64, and end up failing
> >     in architectures where some of those syscalls are not available, like
> >     the 'access' syscall on arm64, which makes using 'perf trace -e string'
> >     in such archs to fail.
> >     
> >     Since this the routine doing the validation is used only when reading
> >     such files, do not fail when some syscall is not found in the
> >     syscalltbl, instead just use pr_debug() to register that in case people
> >     are suspicious of problems.
> >     
> >     Now using 'perf trace -e string' should work on arm64, selecting only
> >     the syscalls that have a string and are available on that architecture.
> >     
> >     Reported-by: Leo Yan <leo.yan@linaro.org>
> >     Cc: Adrian Hunter <adrian.hunter@intel.com>
> >     Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> >     Cc: Alexei Starovoitov <ast@kernel.org>
> >     Cc: Daniel Borkmann <daniel@iogearbox.net>
> >     Cc: Jiri Olsa <jolsa@redhat.com>
> >     Cc: Martin KaFai Lau <kafai@fb.com>
> >     Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> >     Cc: Mike Leach <mike.leach@linaro.org>
> >     Cc: Namhyung Kim <namhyung@kernel.org>
> >     Cc: Song Liu <songliubraving@fb.com>
> >     Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> >     Cc: Yonghong Song <yhs@fb.com>
> >     Link: https://lkml.kernel.org/n/tip-oa4c2x8p3587jme0g89fyg18@git.kernel.org
> >     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> > index 1a2a605cf068..eb70a4b71755 100644
> > --- a/tools/perf/builtin-trace.c
> > +++ b/tools/perf/builtin-trace.c
> > @@ -1529,6 +1529,7 @@ static int trace__read_syscall_info(struct trace *trace, int id)
> >  static int trace__validate_ev_qualifier(struct trace *trace)
> >  {
> >  	int err = 0, i;
> > +	bool printed_invalid_prefix = false;
> >  	size_t nr_allocated;
> >  	struct str_node *pos;
> >  
> > @@ -1555,14 +1556,15 @@ static int trace__validate_ev_qualifier(struct trace *trace)
> >  			if (id >= 0)
> >  				goto matches;
> >  
> > -			if (err == 0) {
> > -				fputs("Error:\tInvalid syscall ", trace->output);
> > -				err = -EINVAL;
> > +			if (!printed_invalid_prefix) {
> > +				pr_debug("Skipping unknown syscalls: ");
> > +				printed_invalid_prefix = true;
> >  			} else {
> > -				fputs(", ", trace->output);
> > +				pr_debug(", ");
> >  			}
> >  
> > -			fputs(sc, trace->output);
> > +			pr_debug("%s", sc);
> > +			continue;
> 
> Here adds 'continue' so that we want to let ev_qualifier_ids.entries
> to only store valid system call ids.  But this is not sufficient,
> because we have initialized ev_qualifier_ids.nr at the beginning of
> the function:
> 
>   trace->ev_qualifier_ids.nr = strlist__nr_entries(trace->ev_qualifier);
> This sentence will set ids number to the string table's length; but
> actually some strings are not really supported; this leads to some
> items in trace->ev_qualifier_ids.entries[] will be not initialized
> properly.
> 
> If we want to get neat entries and entry number, I suggest at the
> beginning of the function we use variable 'nr_allocated' to store
> string table length and use it to allocate entries:
> 
>   nr_allocated = strlist__nr_entries(trace->ev_qualifier);
>   trace->ev_qualifier_ids.entries = malloc(nr_allocated *
>                                            sizeof(trace->ev_qualifier_ids.entries[0]));
> 
> If we find any matched string, then increment the nr field under
> 'matches' tag:
> 
> matches:
>                 trace->ev_qualifier_ids.nr++;
>                 trace->ev_qualifier_ids.entries[i++] = id;
> 
> This can ensure the entries[0..nr-1] has valid id and we can use
> ev_qualifier_ids.nr to maintain the valid system call numbers.

yeah, you're right, I'll address these issues in a followup patch,
tomorrow.

- Arnaldo
 
> 
> >  		}
> >  matches:
> >  		trace->ev_qualifier_ids.entries[i++] = id;
> > @@ -1591,15 +1593,14 @@ static int trace__validate_ev_qualifier(struct trace *trace)
> >  		}
> >  	}
> >  
> > -	if (err < 0) {
> > -		fputs("\nHint:\ttry 'perf list syscalls:sys_enter_*'"
> > -		      "\nHint:\tand: 'man syscalls'\n", trace->output);
> > -out_free:
> > -		zfree(&trace->ev_qualifier_ids.entries);
> > -		trace->ev_qualifier_ids.nr = 0;
> > -	}
> >  out:
> > +	if (printed_invalid_prefix)
> > +		pr_debug("\n");
> >  	return err;
> > +out_free:
> > +	zfree(&trace->ev_qualifier_ids.entries);
> > +	trace->ev_qualifier_ids.nr = 0;
> > +	goto out;
> 
> Nitpick: directly return err and 'goto out' is not necessary.
> 
> Thanks,
> Leo Yan
> 
> >  }
> >  
> >  /*

-- 

- Arnaldo
