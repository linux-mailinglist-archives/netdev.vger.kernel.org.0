Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885599CFD9
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 14:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbfHZMvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 08:51:21 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:46322 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730674AbfHZMvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 08:51:21 -0400
Received: by mail-yw1-f65.google.com with SMTP id w10so6556886ywa.13
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 05:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tI6zYJOHpKSlhKSWsr8RRDLcFrzabmESL6aWfvKu/S0=;
        b=Dz9BLZxn384spg68xO8S+7nMiKogNXf84Qs7yW4eF41VDHIn+gECV8LiakvGqi0x0M
         s8/UTA5fmyEcXNelXKR4uJLjh0Pgf/ZJoGeXz3fxdq5EwCxfS0931RZM8pl72YUBY6UK
         nphFn9BJDsv+wIrokqt6SWs5POngskGB/mDrdQUc2lRYuufTW7738WDzouUIRWiKDFWF
         zTZomngbsv6bKCriM1M+mRRDnkpBZNGXWSpneOyeTvQPRd/FBfiRHuCIb9Tutq2TK4t5
         cXjTQDHwT2DDYnfXhMK8XXPsB8e+mzq//W+itt2275TUBKq2yvSUv8hTQxYMAhkJ8A0p
         169g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tI6zYJOHpKSlhKSWsr8RRDLcFrzabmESL6aWfvKu/S0=;
        b=DZzJmW5HpElSDIMgu42509NLcam239mtCA36QjYIIOUCcQSiB7nj9KY1JWnLUDsS6G
         c0BWJUB8pmNQrDt/Xg84n2Ytt/DnwersV49UpSakk+6trVTw5hxu0mfg13fKsQRGAggt
         aS6nQ2WSvHZ1tX6h93MEBQkL8lmQqZ6EbkBcxMzYGed4HySmgI4z1eI3zX8xhwnPA1WO
         zQOjn4rhIiSsQXrMI5SCj8ISv+x716+MsMOg+lR1okTPK1vpA1soQQt3UgtqV5VRlEZR
         HPi4A17hnfNHZ7+cu9Hk2QSthrdN7Q2eqShrS9H52eBVgGPl3fHw+O2QORHufh4RXq4t
         3djQ==
X-Gm-Message-State: APjAAAXxL5NAHZZIf8iLkWyUF7n87PQQ5KaMfomoTgcED3ocTR4mxg4G
        KDt5RWqmUrHJwS2yDZpd8tOM7A==
X-Google-Smtp-Source: APXvYqxw60HAOjGCLQXsMEIiBtWXkpn2X3Bgi0XfDdpZOktnPUYQ+2PF/IjDbbTE8J4f7+pKIXxg0A==
X-Received: by 2002:a81:7dc3:: with SMTP id y186mr12362090ywc.223.1566823880025;
        Mon, 26 Aug 2019 05:51:20 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1320-244.members.linode.com. [45.79.221.244])
        by smtp.gmail.com with ESMTPSA id z6sm2438113ywg.40.2019.08.26.05.51.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Aug 2019 05:51:19 -0700 (PDT)
Date:   Mon, 26 Aug 2019 20:51:05 +0800
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
Message-ID: <20190826125105.GA3288@leoy-ThinkPad-X240s>
References: <20190815082521.16885-1-leo.yan@linaro.org>
 <d874e6b3-c115-6c8c-bb12-160cfd600505@intel.com>
 <20190815113242.GA28881@leoy-ThinkPad-X240s>
 <e0919e39-7607-815b-3a12-96f098e45a5f@intel.com>
 <20190816014541.GA17960@leoy-ThinkPad-X240s>
 <363577f1-097e-eddd-a6ca-b23f644dd8ce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <363577f1-097e-eddd-a6ca-b23f644dd8ce@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adrian,

On Fri, Aug 16, 2019 at 04:00:02PM +0300, Adrian Hunter wrote:
> On 16/08/19 4:45 AM, Leo Yan wrote:
> > Hi Adrian,
> > 
> > On Thu, Aug 15, 2019 at 02:45:57PM +0300, Adrian Hunter wrote:
> > 
> > [...]
> > 
> >>>> How come you cannot use kallsyms to get the information?
> >>>
> >>> Thanks for pointing out this.  Sorry I skipped your comment "I don't
> >>> know how you intend to calculate ARM_PRE_START_SIZE" when you reviewed
> >>> the patch v3, I should use that chance to elaborate the detailed idea
> >>> and so can get more feedback/guidance before procceed.
> >>>
> >>> Actually, I have considered to use kallsyms when worked on the previous
> >>> patch set.
> >>>
> >>> As mentioned in patch set v4's cover letter, I tried to implement
> >>> machine__create_extra_kernel_maps() for arm/arm64, the purpose is to
> >>> parse kallsyms so can find more kernel maps and thus also can fixup
> >>> the kernel start address.  But I found the 'perf script' tool directly
> >>> calls machine__get_kernel_start() instead of running into the flow for
> >>> machine__create_extra_kernel_maps();
> >>
> >> Doesn't it just need to loop through each kernel map to find the lowest
> >> start address?
> > 
> > Based on your suggestion, I worked out below change and verified it
> > can work well on arm64 for fixing up start address; please let me know
> > if the change works for you?
> 
> How does that work if take a perf.data file to a machine with a different
> architecture?

Sorry I delayed so long to respond to your question; I didn't have
confidence to give out very reasonale answer and this is the main reason
for delaying.

For your question for taking a perf.data file to a machine with a
different architecture, we can firstly use command 'perf buildid-list'
to print out the buildid for kallsyms, based on the dumped buildid we
can find out the location for the saved kallsyms file; then we can use
option '--kallsyms' to specify the offline kallsyms file and use the
offline kallsyms to fixup kernel start address.  The detailed commands
are listed as below:

root@debian:~# perf buildid-list
7b36dfca8317ef74974ebd7ee5ec0a8b35c97640 [kernel.kallsyms]
56b84aa88a1bcfe222a97a53698b92723a3977ca /usr/lib/systemd/systemd
0956b952e9cd673d48ff2cfeb1a9dbd0c853e686 /usr/lib/aarch64-linux-gnu/libm-2.28.so
[...]

root@debian:~# perf script --kallsyms ~/.debug/\[kernel.kallsyms\]/7b36dfca8317ef74974ebd7ee5ec0a8b35c97640/kallsyms

The amended patch is as below, please review and always welcome
any suggestions or comments!

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 5734460fc89e..593f05cc453f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2672,9 +2672,26 @@ int machine__nr_cpus_avail(struct machine *machine)
 	return machine ? perf_env__nr_cpus_avail(machine->env) : 0;
 }
 
+static int machine__fixup_kernel_start(void *arg,
+				       const char *name __maybe_unused,
+				       char type,
+				       u64 start)
+{
+	struct machine *machine = arg;
+
+	type = toupper(type);
+
+	/* Fixup for text, weak, data and bss sections. */
+	if (type == 'T' || type == 'W' || type == 'D' || type == 'B')
+		machine->kernel_start = min(machine->kernel_start, start);
+
+	return 0;
+}
+
 int machine__get_kernel_start(struct machine *machine)
 {
 	struct map *map = machine__kernel_map(machine);
+	char filename[PATH_MAX];
 	int err = 0;
 
 	/*
@@ -2696,6 +2713,22 @@ int machine__get_kernel_start(struct machine *machine)
 		if (!err && !machine__is(machine, "x86_64"))
 			machine->kernel_start = map->start;
 	}
+
+	if (symbol_conf.kallsyms_name != NULL) {
+		strncpy(filename, symbol_conf.kallsyms_name, PATH_MAX);
+	} else {
+		machine__get_kallsyms_filename(machine, filename, PATH_MAX);
+
+		if (symbol__restricted_filename(filename, "/proc/kallsyms"))
+			goto out;
+	}
+
+	if (kallsyms__parse(filename, machine, machine__fixup_kernel_start))
+		pr_warning("Fail to fixup kernel start address. skipping...\n");
+
+out:
 	return err;
 }
 

Thanks,
Leo Yan
