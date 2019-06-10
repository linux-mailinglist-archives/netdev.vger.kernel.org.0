Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C2E3BBFF
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbfFJSsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:48:02 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39939 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387643AbfFJSsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 14:48:01 -0400
Received: by mail-qk1-f193.google.com with SMTP id c70so6092563qkg.7;
        Mon, 10 Jun 2019 11:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FEliiaLTKP8myXUgDNGHzRUM+K36+7Eaw0xHvfUmPyQ=;
        b=ueNjZjx0sJz73Xq9zKh6hoCNxjWxZWeKfeh4anO0WLYmpyzXckJMB0rpgqvQXi7u4D
         5m3c3ggZTEUHS5yO0UJFm6Nl2SPFLdUutirGL1D1HR/wqk31hljDt/UvwL2/AzlGg2T6
         UmChhzsrMhxMbKXpV1pbuIB6WySkrtaxevLDBaor4spYOZzR4h7JA/zfVSCCMk3vuQGv
         3uXGZwUBs6svKSd8fjXe6JZReIkKGs6/wEddy9Pr9fCfrrJ2k34Xbrcmj1qaLrSzI967
         quv4eE304lgLa1rp0JgYQ0ZotmQEiWHdaFcG6am0vvVebgSdlzO/Kzd/r5cghNcMmS+d
         lTAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FEliiaLTKP8myXUgDNGHzRUM+K36+7Eaw0xHvfUmPyQ=;
        b=Vp39OKBWsFfkMhiRE1l+hoE6jJYpsYKQHfbznPDiUrB17zYbIIR/pqZSCPRAYzQDaq
         SxZMu2ztaNoTEBbexgsuutT4hJgqz8iTZOvSUszxlkTLt2Dp0R7N2o0nCD9Ik6LFEPD4
         MwiLw8nLvFPY1wDhOnAZjL9vbbr6JrNwYKGjifh/ICNOUHq5cecfwR/gEoMdwWr65Aj6
         DulwgklhWX8k2mfy9dbLZ60Inf41YZbPsNf+avgiM26+vsMCmjxxxbz1GHakzG7boM0e
         WQPmt4RHfMQg35J2w2H/W4O7IJu8qUNmCJE7bVkPKbDDvUabTTysdwS1YoRMDCNmv31R
         ZOpw==
X-Gm-Message-State: APjAAAU86/Y5VTGi0oFFfISjRmVqS5nSflUix96lC3mpMCr4t+D0g5fx
        BP6E0/dUMypDoHA5A4pYJmqU+XwX7lU=
X-Google-Smtp-Source: APXvYqyIBZYI3GNEPpmwbLLr1TC49VIEUxDnZKsex8CV2BNabGKfgk26QtARRAvN/VazLEtgeM+WYA==
X-Received: by 2002:ae9:f801:: with SMTP id x1mr14361175qkh.151.1560192480005;
        Mon, 10 Jun 2019 11:48:00 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([190.15.121.82])
        by smtp.gmail.com with ESMTPSA id n19sm4812199qkg.58.2019.06.10.11.47.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 11:47:58 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 5428041149; Mon, 10 Jun 2019 15:47:54 -0300 (-03)
Date:   Mon, 10 Jun 2019 15:47:54 -0300
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
Message-ID: <20190610184754.GU21245@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-4-leo.yan@linaro.org>
 <20190606133838.GC30166@kernel.org>
 <20190606141231.GC5970@leoy-ThinkPad-X240s>
 <20190606144412.GC21245@kernel.org>
 <20190607095831.GG5970@leoy-ThinkPad-X240s>
 <20190609131849.GB6357@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609131849.GB6357@leoy-ThinkPad-X240s>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sun, Jun 09, 2019 at 09:18:49PM +0800, Leo Yan escreveu:
> On Fri, Jun 07, 2019 at 05:58:31PM +0800, Leo Yan wrote:
> > Hi Arnaldo,
> > 
> > On Thu, Jun 06, 2019 at 11:44:12AM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Jun 06, 2019 at 10:12:31PM +0800, Leo Yan escreveu:
> > > > Hi Arnaldo,
> > > > 
> > > > On Thu, Jun 06, 2019 at 10:38:38AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > > Em Thu, Jun 06, 2019 at 05:48:44PM +0800, Leo Yan escreveu:
> > > > > > This patch adds support for arm64 raw syscall numbers so that we can use
> > > > > > it on arm64 platform.
> > > > > > 
> > > > > > After applied this patch, we need to specify macro -D__aarch64__ or
> > > > > > -D__x86_64__ in compilation option so Clang can use the corresponding
> > > > > > syscall numbers for arm64 or x86_64 respectively, other architectures
> > > > > > will report failure when compilation.
> > > > > 
> > > > > So, please check what I have in my perf/core branch, I've completely
> > > > > removed arch specific stuff from augmented_raw_syscalls.c.
> > > > > 
> > > > > What is done now is use a map to specify what to copy, that same map
> > > > > that is used to state which syscalls should be traced.
> > > > > 
> > > > > It uses that tools/perf/arch/arm64/entry/syscalls/mksyscalltbl to figure
> > > > > out the mapping of syscall names to ids, just like is done for x86_64
> > > > > and other arches, falling back to audit-libs when that syscalltbl thing
> > > > > is not present.
> > > > 
> > > > Actually I have noticed mksyscalltbl has been enabled for arm64, and
> > > > had to say your approach is much better :)
> > > > 
> > > > Thanks for the info and I will try your patch at my side.
> > > 
> > > That is excellent news! I'm eager to hear from you if this perf+BPF
> > > integration experiment works for arm64.
> > 
> > I tested with the lastest perf/core branch which contains the patch:
> > 'perf augmented_raw_syscalls: Tell which args are filenames and how
> > many bytes to copy' and got the error as below:
> > 
> > # perf trace -e string -e /mnt/linux-kernel/linux-cs-dev/tools/perf/examples/bpf/augmented_raw_syscalls.c
> > Error:  Invalid syscall access, chmod, chown, creat, futimesat, lchown, link, lstat, mkdir, mknod, newfstatat, open, readlink, rename,
> > rmdir, stat, statfs, symlink, truncate, unlink

Humm, I think that we can just make the code that parses the
tools/perf/trace/strace/groups/string file to ignore syscalls it can't
find in the syscall_tbl, i.e. trace those if they exist in the arch.

> > Hint:   try 'perf list syscalls:sys_enter_*'
> > Hint:   and: 'man syscalls'
> > 
> > So seems mksyscalltbl has not included completely for syscalls, I
> > use below command to generate syscalltbl_arm64[] array and it don't
> > include related entries for access, chmod, chown, etc ...

So, we need to investigate why is that these are missing, good thing we
have this 'strings' group :-)

> > You could refer the generated syscalltbl_arm64 in:
> > http://paste.ubuntu.com/p/8Bj7Jkm2mP/
> 
> After digging into this issue on Arm64, below is summary info:
> 
> - arm64 uses the header include/uapi/linux/unistd.h to define system
>   call numbers, in this header some system calls are not defined (I
>   think the reason is these system calls are obsolete at the end) so the
>   corresponding strings are missed in the array syscalltbl_native,
>   for arm64 the array is defined in the file:
>   tools/perf/arch/arm64/include/generated/asm/syscalls.c.

Yeah, I looked at the 'access' case and indeed it is not present in
include/uapi/asm-generic/unistd.h, which is the place
include/uapi/linux/unistd.h ends up.

Ok please take a look at the patch at the end of this message, should be ok?

I tested it by changing the strace/gorups/string file to have a few
unknown syscalls, running it with -v we see:

[root@quaco perf]# perf trace -v -e string ls
Skipping unknown syscalls: access99, acct99, add_key99
<SNIP other verbose messages>
normal operation not considering those unknown syscalls.

>   On the other hand, the file tools/perf/trace/strace/groups/string
>   stores the required system call strings, these system call strings
>   are based on x86_64 platform but not for arm64, the strings mismatch
>   with the system call defined in the array syscalltbl_native.  This
>   is the reason why reports the fail: "Error:  Invalid syscall access,
>   chmod, chown, creat, futimesat, lchown, link, lstat, mkdir, mknod,
>   newfstatat, open, readlink, rename, rmdir, stat, statfs, symlink,
>   truncate, unlink".
> 
>   I tried to manually remove these reported strings from
>   tools/perf/trace/strace/groups/string, then 'perf trace' can work
>   well.
> 
>   But I don't know what's a good way to proceed.  Seems to me, we can
>   create a dedicated string file
>   tools/perf/trace/strace/groups/uapi_string which can be used to
>   match with system calls definitions in include/uapi/linux/unistd.h.
>   If there have other more general methods, will be great.
 
> - As a side topic, arm64 also supports aarch32 compat system call
>   which are defined in header arch/arm64/include/asm/unistd32.h.
> 
>   For either aarch64 or aarch32 system call, both of them finally will
>   invoke function el0_svc_common() to handle system call [1].  But so
>   far we don't distinguish the system call numbers is for aarch64 or
>   aarch32 and always consider it's aarch64 system call.
> 
>   I think we can set an extra bit (e.g. use the 16th bit in 32 bits
>   signed int) to indicate it's a aarch32 compat system call, but not
>   sure if this is general method or not.

compat syscalls were not supported because of limitations in the
raw_syscalls:sys_{enter,exit} tracepoints I can't recall from the top of
my head right now, I think that looking at that code
(raw_syscalls:sys_{enter,exit}) git log history may provide the
explanation.
 
>   Maybe there have existed solution in other architectures for this,
>   especially other platforms also should support 32 bits and 64 bits
>   system calls along with the architecture evoluation, so want to
>   inquiry firstly to avoid duplicate works.
> 
> Thanks a lot for suggestions!
> Leo.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kernel/syscall.c#n93

- Arnaldo


commit e0b34a78c4ed0a6422f5b2dafa0c8936e537ee41
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Mon Jun 10 15:37:45 2019 -0300

    perf trace: Skip unknown syscalls when expanding strace like syscall groups
    
    We have $INSTALL_DIR/share/perf-core/strace/groups/string files with
    syscalls that should be selected when 'string' is used, meaning, in this
    case, syscalls that receive as one of its arguments a string, like a
    pathname.
    
    But those were first selected and tested on x86_64, and end up failing
    in architectures where some of those syscalls are not available, like
    the 'access' syscall on arm64, which makes using 'perf trace -e string'
    in such archs to fail.
    
    Since this the routine doing the validation is used only when reading
    such files, do not fail when some syscall is not found in the
    syscalltbl, instead just use pr_debug() to register that in case people
    are suspicious of problems.
    
    Now using 'perf trace -e string' should work on arm64, selecting only
    the syscalls that have a string and are available on that architecture.
    
    Reported-by: Leo Yan <leo.yan@linaro.org>
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
    Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
    Cc: Yonghong Song <yhs@fb.com>
    Link: https://lkml.kernel.org/n/tip-oa4c2x8p3587jme0g89fyg18@git.kernel.org
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1a2a605cf068..eb70a4b71755 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1529,6 +1529,7 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 static int trace__validate_ev_qualifier(struct trace *trace)
 {
 	int err = 0, i;
+	bool printed_invalid_prefix = false;
 	size_t nr_allocated;
 	struct str_node *pos;
 
@@ -1555,14 +1556,15 @@ static int trace__validate_ev_qualifier(struct trace *trace)
 			if (id >= 0)
 				goto matches;
 
-			if (err == 0) {
-				fputs("Error:\tInvalid syscall ", trace->output);
-				err = -EINVAL;
+			if (!printed_invalid_prefix) {
+				pr_debug("Skipping unknown syscalls: ");
+				printed_invalid_prefix = true;
 			} else {
-				fputs(", ", trace->output);
+				pr_debug(", ");
 			}
 
-			fputs(sc, trace->output);
+			pr_debug("%s", sc);
+			continue;
 		}
 matches:
 		trace->ev_qualifier_ids.entries[i++] = id;
@@ -1591,15 +1593,14 @@ static int trace__validate_ev_qualifier(struct trace *trace)
 		}
 	}
 
-	if (err < 0) {
-		fputs("\nHint:\ttry 'perf list syscalls:sys_enter_*'"
-		      "\nHint:\tand: 'man syscalls'\n", trace->output);
-out_free:
-		zfree(&trace->ev_qualifier_ids.entries);
-		trace->ev_qualifier_ids.nr = 0;
-	}
 out:
+	if (printed_invalid_prefix)
+		pr_debug("\n");
 	return err;
+out_free:
+	zfree(&trace->ev_qualifier_ids.entries);
+	trace->ev_qualifier_ids.nr = 0;
+	goto out;
 }
 
 /*
