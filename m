Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E630E1DA0FE
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgEST2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgEST2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:28:25 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B191C08C5C0;
        Tue, 19 May 2020 12:28:25 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id ee19so168723qvb.11;
        Tue, 19 May 2020 12:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJ2WtymJ/44ukH73/nmAxCbRKt4OtZ9J3eO3Z1WCx+s=;
        b=bmQ+YeugrD0P0y8R1+JB/gALpn6SNySKmGjb+J9kkUSjlI/t+EbizeE4z/gyb8qo4y
         GqhM/bjwtEUJQU65fTXJ8yCTJnwoz1J6pE0MdL/A2Qjl4Q+AEe7sq6w/wYlAaAL4WjKN
         FAKYvqSr1P6krmgL/EVrghAdWjfv1GkQ/7Ii65Q16+kwIbrJuTJJXh/p1iwpSPA2IiXs
         ZXR4rs9p2ZsjPNyc1Pn2dR9ankY5kSbzKIW7CgDj01vXJrbX7W+7GqUEiO7OE+vS58SG
         +FMRIU5HhTWdwC1RsYrRg2IVOHRm++eAQzJ8XBvBtCYv3pj9x3ovMPvHWIIK7Z1ozem4
         QSeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJ2WtymJ/44ukH73/nmAxCbRKt4OtZ9J3eO3Z1WCx+s=;
        b=Vl+I4nNx1DH8P8ZmRa2TnY6tuiDpG/bgAetTNj++Ivr2MqXskxGW7tyVhNlN99bjRd
         fzdKGq3HP1qbmfuRmk1zRkfdFxcTK+julNWIBI4TTTD9MvAtpO6R9cYJHTkq84ARic9e
         CyVxb8LKVSUyuzVAsP7txs/7eduOyg3b+LVEr241UIhNqnngUgrTTbq0NwiJa33yuZge
         6P+zTEsT+DNpY1I31GW9RQl9qwoWFYxvhCbf8KzyguWQaJlAXFLvrg9ijXvEFE1bgykh
         IJDpKdKP+CKYxgvWPWMNkBh+Ws440oZ0EbG5WdXaRaMMQ0P7aL8FH2lOTTGc+lFIFOZM
         jYqQ==
X-Gm-Message-State: AOAM531RNwtONji/6WRqzvEEjmnHQBOv4H6PKvWJmM/0K7hZMDY0OYGK
        /Pkf9cU0t63EB/DpaBUOsp0=
X-Google-Smtp-Source: ABdhPJz0uBnKIXEfrTulqlvs6UK2lZUeYHabJFqmgAMRHk9g9NbIOh8l60tueo4Ud8wq6kVNiTiOqQ==
X-Received: by 2002:a0c:a993:: with SMTP id a19mr1231250qvb.57.1589916503962;
        Tue, 19 May 2020 12:28:23 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id u41sm656836qte.28.2020.05.19.12.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 12:28:22 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C333740AFD; Tue, 19 May 2020 16:28:19 -0300 (-03)
Date:   Tue, 19 May 2020 16:28:19 -0300
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 7/7] perf expr: Migrate expr ids table to a hashmap
Message-ID: <20200519192819.GC28228@kernel.org>
References: <20200515221732.44078-1-irogers@google.com>
 <20200515221732.44078-8-irogers@google.com>
 <20200518154505.GE24211@kernel.org>
 <CAP-5=fWZwuSLaFX+-pgeE_H92Mtp7+_NrwBeRFTqyfPjVRkbWg@mail.gmail.com>
 <20200518160648.GI24211@kernel.org>
 <20200518161137.GK24211@kernel.org>
 <CAP-5=fWzb5XxcFishFErRtdc-Gvv-7DkVpd6HSiy2_RswfjeDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fWzb5XxcFishFErRtdc-Gvv-7DkVpd6HSiy2_RswfjeDg@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, May 18, 2020 at 09:29:06AM -0700, Ian Rogers escreveu:
> I had some issues here too:
> https://lore.kernel.org/lkml/CAEf4BzYxTTND7T7X0dLr2CbkEvUuKtarOeoJYYROefij+qds0w@mail.gmail.com/
> The only reason for the bits/reg.h inclusion is for __WORDSIZE for the
> hash_bits operation. As shown below:

So, to have perf building in all the systems I have test build
containers for I have this in:

tools/include/linux/bitops.h

#include <asm/types.h>
#include <limits.h>
#ifndef __WORDSIZE
#define __WORDSIZE (__SIZEOF_LONG__ * 8)
#endif

With that it works everywhere, Android cross NDK for arm64, older
systems, cross compilers to many arches, Musl libc, uclibc, etc.

So I'm trying, just to check, that this change will make this build
everywhere:

commit ef4c968ccbd52d6a02553719ac7e97f70c65ba47
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue May 19 16:26:14 2020 -0300

    WIP
    
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/hashmap.h b/tools/perf/util/hashmap.h
index e823b35e7371..df59fd4fc95b 100644
--- a/tools/perf/util/hashmap.h
+++ b/tools/perf/util/hashmap.h
@@ -10,10 +10,9 @@
 
 #include <stdbool.h>
 #include <stddef.h>
-#ifdef __GLIBC__
-#include <bits/wordsize.h>
-#else
-#include <bits/reg.h>
+#include <limits.h>
+#ifndef __WORDSIZE
+#define __WORDSIZE (__SIZEOF_LONG__ * 8)
 #endif
 
 static inline size_t hash_bits(size_t h, int bits)


> #ifdef __GLIBC__
> #include <bits/wordsize.h>
> #else
> #include <bits/reg.h>
> #endif
> static inline size_t hash_bits(size_t h, int bits)
> {
> /* shuffle bits and return requested number of upper bits */
> return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
> }
> 
> It'd be possible to change the definition of hash_bits and remove the
> #includes by:
> 
> static inline size_t hash_bits(size_t h, int bits)
> {
> /* shuffle bits and return requested number of upper bits */
> #ifdef __LP64__
>   int shift = 64 - bits;
> #else
>   int shift = 32 - bits;
> #endif
> return (h * 11400714819323198485llu) >> shift;
> }
> 
> Others may have a prefered more portable solution. A separate issue
> with this same function is undefined behavior getting flagged
> (unnecessarily) by sanitizers:
> https://lore.kernel.org/lkml/20200508063954.256593-1-irogers@google.com/
> 
> I was planning to come back to that once we got these changes landed.
> 
> Thanks!
> Ian

-- 

- Arnaldo
