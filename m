Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA0F8F88C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfHPBpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:45:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39019 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfHPBpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 21:45:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so2262505pfn.6
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 18:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1/p96Axpw0rHsxKvgAnkX2TPQwGbqpRMoy2NJLiILjI=;
        b=Gg18FaJL00NzcRt4W/j4JgqHWrONHfBYA9r8BcsQbvriweFSoDnIzZ9HTDaq3j1sN3
         mdQwP3as5jSogC4XkurlHBh3eFk+CIQlTMe2tXGsAtu+zpX3zw4gsVoYRQ9/GiQBslKN
         pl94B3b02xKzLyxX6FbcVfZ3BYOgY0eGyvUWyymYGxVzO2r7B7J/7xWHlzFUk6V5s2mf
         a5NQsBxgsivAID73l7snH0MFpHauCIYNvGVPxFUu+W7hdKn/1zw0NoK3c3YuONnjhUbd
         UgbFN5XGhNPK0u7BI0IRLwlpz4TxLie/tJ5zsdUiTcZIiNdHxRPhwU1YR10xky4HxKBJ
         cqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1/p96Axpw0rHsxKvgAnkX2TPQwGbqpRMoy2NJLiILjI=;
        b=LArSwIZpWlV3LIA9S0j9mYo4zSmCfP33RqD2tmyK4ht4UYUWXR2IaIcdMVDUKTKvam
         tLV0AZnmVYoRqaepxqrTu9PG+pEKJ6XAoKJE4eoQk1YJ0fAg18x9I2HO/dp1DAzrPX3J
         K5WPvZxgeWqGrSN1iEDkgR3Eozy1/AYhZ1eAMFo23SIZs/jPewSL4wOfwDn6SanRwUjP
         isUhy8lfs6GoN3bKb8+7+zbYy9uTU1YHNaGH5TwqAdq+SCx02OsHgjMNSsz+kRO2z5Kf
         osgjYUiChimWQ1CycpJ8teAN7owZgU2tIMjHeLRyYNO5BcDZtEYJFpBDbPCwDEnob7Dh
         z+ig==
X-Gm-Message-State: APjAAAWFyohIzVmNUGjq7dDIRu5J9YkOs12vvKY72n75EgDtuIkjnkd2
        FpRp6XH6KM15v9x1CEv9TEoxug==
X-Google-Smtp-Source: APXvYqy9TJYA/qdyaDQ7CLxObzKev6Jt6rMN43trN1gJEs6x9PV+CgMrh/p36YHRUcLgQom71CizHg==
X-Received: by 2002:a65:430a:: with SMTP id j10mr5932866pgq.374.1565919949052;
        Thu, 15 Aug 2019 18:45:49 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id v15sm3255539pfn.69.2019.08.15.18.45.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Aug 2019 18:45:48 -0700 (PDT)
Date:   Fri, 16 Aug 2019 09:45:41 +0800
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
Message-ID: <20190816014541.GA17960@leoy-ThinkPad-X240s>
References: <20190815082521.16885-1-leo.yan@linaro.org>
 <d874e6b3-c115-6c8c-bb12-160cfd600505@intel.com>
 <20190815113242.GA28881@leoy-ThinkPad-X240s>
 <e0919e39-7607-815b-3a12-96f098e45a5f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0919e39-7607-815b-3a12-96f098e45a5f@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adrian,

On Thu, Aug 15, 2019 at 02:45:57PM +0300, Adrian Hunter wrote:

[...]

> >> How come you cannot use kallsyms to get the information?
> > 
> > Thanks for pointing out this.  Sorry I skipped your comment "I don't
> > know how you intend to calculate ARM_PRE_START_SIZE" when you reviewed
> > the patch v3, I should use that chance to elaborate the detailed idea
> > and so can get more feedback/guidance before procceed.
> > 
> > Actually, I have considered to use kallsyms when worked on the previous
> > patch set.
> > 
> > As mentioned in patch set v4's cover letter, I tried to implement
> > machine__create_extra_kernel_maps() for arm/arm64, the purpose is to
> > parse kallsyms so can find more kernel maps and thus also can fixup
> > the kernel start address.  But I found the 'perf script' tool directly
> > calls machine__get_kernel_start() instead of running into the flow for
> > machine__create_extra_kernel_maps();
> 
> Doesn't it just need to loop through each kernel map to find the lowest
> start address?

Based on your suggestion, I worked out below change and verified it
can work well on arm64 for fixing up start address; please let me know
if the change works for you?

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f6ee7fbad3e4..51d78313dca1 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2671,9 +2671,26 @@ int machine__nr_cpus_avail(struct machine *machine)
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
@@ -2687,6 +2704,7 @@ int machine__get_kernel_start(struct machine *machine)
 	machine->kernel_start = 1ULL << 63;
 	if (map) {
 		err = map__load(map);
 		/*
 		 * On x86_64, PTI entry trampolines are less than the
 		 * start of kernel text, but still above 2^63. So leave
@@ -2695,6 +2713,16 @@ int machine__get_kernel_start(struct machine *machine)
 		if (!err && !machine__is(machine, "x86_64"))
 			machine->kernel_start = map->start;
 	}
+
+	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
+
+	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
+		goto out;
+
+	if (kallsyms__parse(filename, machine, machine__fixup_kernel_start))
+		pr_warning("Fail to fixup kernel start address. skipping...\n");
+
+out:
 	return err;
 }

Thanks,
Leo Yan
