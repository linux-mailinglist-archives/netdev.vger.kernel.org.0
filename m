Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC60375FE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfFFOFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:05:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39779 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFFOFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:05:35 -0400
Received: by mail-qk1-f194.google.com with SMTP id i125so1497581qkd.6;
        Thu, 06 Jun 2019 07:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VFoOhkDmeyxpQ0VL/b3qeqqcsErXzFhONvkE9YSl7p0=;
        b=XLRnKqLJ2c5xlxKLWl1B9W390UsQ7YdE5zCNZX7uyaDJqjILsffH1nluCzDjnsrQJL
         oGC5F5iet0bKcIsNdaEcBV5FY1yYn+mnM5Kw1RcSXsKlxuOV+KhvN+7AgYGvyasQdQQv
         ldXfNejebjZej5uEWljcE06bYbOfkt2gSgmxyRy56GOJ1krJDsBOG+TUbGgr+NlsDN6w
         iuvKIyDjNbym1VOxrawPjsVEaKnbvmxuuDCHhVf7/HjrcwCpxzBF8jgfQBGDdYsIhMz7
         t9nNGe+XATJYBm95UyggYZQvaLvpJ9BK15o7hIPKgQHCxmWjwX9IeN+HgwddGMX7JVnq
         uhZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VFoOhkDmeyxpQ0VL/b3qeqqcsErXzFhONvkE9YSl7p0=;
        b=Z/DkuRSrmIpujbsu43S5pIB3GVY5MEo/0mG1y19Upu7yFjo4PZg+RkMW7yS/jFh0EL
         N6HiRU3myWpb/kimzJ5D8/+8RG0r3Y14XO41/RD6k1yqQBAKj3QMLkvpXOh257pyav+u
         5OPb33xs0miE03pnmqjQZXW4Ro4hcxx+J98MQx/DlKmQW9wWdOewglXH0vF24P8D83BL
         rgGajEOdu9iBQQcjnNJNuRT9bbjjixcnPmavtEpco0QkYL+kdvQ3nMiIbeN96B++1WJr
         paK324MCBuf5HKIiAcS3vtb/UQiEaXblRfkAbyWwrBUGaftQgftVCn6uto7MBpnGLEfs
         x3KQ==
X-Gm-Message-State: APjAAAUrUWK/xB7jy/fiRoR2T6qBMHFRJ5nPRSGrqKhkwuJyDxeiX7mb
        xYNc34UNBBYGpddKxCQINu0=
X-Google-Smtp-Source: APXvYqyv+zwvXgaLo9yXntA4io8PpnrYtq77UL+OlxvFLLCuD6OlHphUd0A8P/Rdn/FWbbefgUj6Dg==
X-Received: by 2002:a37:4a8a:: with SMTP id x132mr13715140qka.42.1559829933627;
        Thu, 06 Jun 2019 07:05:33 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.208.82])
        by smtp.gmail.com with ESMTPSA id j22sm1033635qtp.0.2019.06.06.07.05.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 07:05:32 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 7C51A41149; Thu,  6 Jun 2019 11:05:28 -0300 (-03)
Date:   Thu, 6 Jun 2019 11:05:28 -0300
To:     Leo Yan <leo.yan@linaro.org>
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
        bpf@vger.kernel.org, Taeung Song <treeze.taeung@gmail.com>
Subject: Re: [PATCH v2 3/4] perf augmented_raw_syscalls: Support arm64 raw
 syscalls
Message-ID: <20190606140528.GE30166@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-4-leo.yan@linaro.org>
 <20190606133838.GC30166@kernel.org>
 <20190606134624.GD30166@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606134624.GD30166@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 06, 2019 at 10:46:24AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Jun 06, 2019 at 10:38:38AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Thu, Jun 06, 2019 at 05:48:44PM +0800, Leo Yan escreveu:
> > > This patch adds support for arm64 raw syscall numbers so that we can use
> > > it on arm64 platform.

> > > After applied this patch, we need to specify macro -D__aarch64__ or
> > > -D__x86_64__ in compilation option so Clang can use the corresponding
> > > syscall numbers for arm64 or x86_64 respectively, other architectures
> > > will report failure when compilation.

> > So, please check what I have in my perf/core branch, I've completely
> > removed arch specific stuff from augmented_raw_syscalls.c.

> > What is done now is use a map to specify what to copy, that same map
> > that is used to state which syscalls should be traced.

> > It uses that tools/perf/arch/arm64/entry/syscalls/mksyscalltbl to figure
> > out the mapping of syscall names to ids, just like is done for x86_64
> > and other arches, falling back to audit-libs when that syscalltbl thing
> > is not present.
 
> Also added:
 
> Fixes: ac96287cae08 ("perf trace: Allow specifying a set of events to add in perfconfig")
 
> For the stable@kernel.org folks to automagically pick this.

And this extra patch is needed, with yours and this one we finally get
what we want, which points to the kernel verifier blocking something,
exactly what is it that is blocking
(/home/acme/git/perf/tools/perf/examples/bpf/augmented_raw_syscalls.o)
and who asked for it, (trace.add_events=...) in a config key-value pair:

[root@quaco ~]# perf trace ls
event syntax error: '/home/acme/git/perf/tools/perf/examples/bpf/augmented_raw_syscalls.o'
                     \___ Kernel verifier blocks program loading

(add -v to see detail)
Run 'perf list' for a list of valid events
Error: wrong config key-value pair trace.add_events=/home/acme/git/perf/tools/perf/examples/bpf/augmented_raw_syscalls.o
[root@quaco ~]#


commit 6455f983af2657b950d5dd5c45783e31e41ead4a
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Thu Jun 6 10:56:55 2019 -0300

    perf config: Bail out when a handler returns failure for a key-value pair
    
    So perf_config() uses:
    
      int ret = 0;
    
      perf_config_set__for_each_entry(config_set, section, item) {
              ...
              ret = fn();
              if (ret < 0)
                      break;
      }
    
      return ret;
    
    Expecting that that break will imediatelly go to function exit to return
    that error value (ret).
    
    The problem is that perf_config_set__for_each_entry() expands into two
    nested for() loops, one traversing the sections in a config and the
    second the items in each of those sections, so we have to change that
    'break' to a goto label right before that final 'return ret'.
    
    With that, for instance 'perf trace' now correctly bails out when a
    event that is requested to be added via its 'trace.add_events'
    ~/.perfconfig entry gets rejected by the kernel BPF verifier:
    
      # perf trace ls
      event syntax error: '/home/acme/git/perf/tools/perf/examples/bpf/augmented_raw_syscalls.o'
                           \___ Kernel verifier blocks program loading
    
      (add -v to see detail)
      Run 'perf list' for a list of valid events
      Error: wrong config key-value pair trace.add_events=/home/acme/git/perf/tools/perf/examples/bpf/augmented_raw_syscalls.o
      #
    
    While before it would continue and explode later, when trying to find
    maps that would have been in place had that augmented_raw_syscalls.o
    precompiled BPF proggie been accepted by the, humm, bast... rigorous
    kernel BPF verifier 8-)
    
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
    Cc: Alexei Starovoitov <ast@kernel.org>
    Cc: Daniel Borkmann <daniel@iogearbox.net>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Martin KaFai Lau <kafai@fb.com>
    Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
    Cc: Mike Leach <mike.leach@linaro.org>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Cc: Song Liu <songliubraving@fb.com>
    Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
    Cc: Taeung Song <treeze.taeung@gmail.com>
    Cc: Yonghong Song <yhs@fb.com>
    Fixes: 8a0a9c7e9146 ("perf config: Introduce new init() and exit()")
    Link: https://lkml.kernel.org/n/tip-qvqxfk9d0rn1l7lcntwiezrr@git.kernel.org
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 7e3c1b60120c..e7d2c08d263a 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -739,11 +739,15 @@ int perf_config(config_fn_t fn, void *data)
 			if (ret < 0) {
 				pr_err("Error: wrong config key-value pair %s=%s\n",
 				       key, value);
-				break;
+				/*
+				 * Can't be just a 'break', as perf_config_set__for_each_entry()
+				 * expands to two nested for() loops.
+				 */
+				goto out;
 			}
 		}
 	}
-
+out:
 	return ret;
 }
 
