Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA1C37624
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfFFOMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:12:47 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40815 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfFFOMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:12:47 -0400
Received: by mail-qk1-f194.google.com with SMTP id c70so1509498qkg.7
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 07:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KsiUn6UsyR6iRYKgGuT3vtVzQmJqP/05UQ9EDQmxkYE=;
        b=owFu3Fk/e7jEjijt33GbOdLU7wrt+TBcjiaCyjlULB6hkiy37D5u8Aju1N4vIMmoR/
         n5NNr4lh6bp84cVFjyMjN0Mw4Z8vmrSHB3RBSg3NJ7aT8zaNh3oUNg39ODvxBNtPEclE
         LAxd0xxXerPHSrujz8tT82p5tHypH+0T2p4T3TIx2r0N5Jr3ZO0DVKXj6xaxtEHgtmSG
         KA0PzqakNaf7Mdsc79p3uDLqNVpqsVa6S+UatKlpgwkNFC1Hixrq7VX7SYxiV9sIoxv0
         ulDl1jgrzItWa/yKQGAxt1/UNIs87mZCf4d8Uaef13YMMnSyeBWI5bjyb622xwikzjvW
         amnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KsiUn6UsyR6iRYKgGuT3vtVzQmJqP/05UQ9EDQmxkYE=;
        b=LjsxS893kobFwCnbfJ5TB6tPplAyUMnqnpUiuuN++M0kMPtndFGJSBJox81OcfvWXy
         7GC+jhXhFm1QzWf0eeHVCx4Rw98HuKD0YIjgyy7AOcvWsBX0YW1rusXuywwR/SCPC0K0
         QkoOpq0HEUU9Da0/48ARnAO4iVMi10MzZf8rVIokLO/uyYRtWhfPDOzehjfdkISDDJG/
         g8tzls9HkFiNmREGRhIYXM/k0CFHdvDQXPkKyQxoa1xBrdlTnrWiDnHk7I4S/NZOAgmj
         bUxUZ9uipPvcCF3F43VgKwkScLIXSmDdE6w/RCIFWWP5esH0E+jM1E+rK11EcuhG6exE
         JTww==
X-Gm-Message-State: APjAAAW8Cn1dWcRlpB/ow5LsNfVv67RtrcshoecfA9bl8YTaZy6CYtbT
        OOvItNjSZjvtygTlSmZDhtQQow==
X-Google-Smtp-Source: APXvYqzgywbaiNWm+kvMN3tdGnjUsKuDiMR1/OIQeKYq2OvUeH9rJad4z7QbVGO/S7K3ecfUNlGn4g==
X-Received: by 2002:a37:68ca:: with SMTP id d193mr28018788qkc.240.1559830365868;
        Thu, 06 Jun 2019 07:12:45 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id e4sm765192qtc.3.2019.06.06.07.12.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 07:12:45 -0700 (PDT)
Date:   Thu, 6 Jun 2019 22:12:31 +0800
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
Message-ID: <20190606141231.GC5970@leoy-ThinkPad-X240s>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-4-leo.yan@linaro.org>
 <20190606133838.GC30166@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606133838.GC30166@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnaldo,

On Thu, Jun 06, 2019 at 10:38:38AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 06, 2019 at 05:48:44PM +0800, Leo Yan escreveu:
> > This patch adds support for arm64 raw syscall numbers so that we can use
> > it on arm64 platform.
> > 
> > After applied this patch, we need to specify macro -D__aarch64__ or
> > -D__x86_64__ in compilation option so Clang can use the corresponding
> > syscall numbers for arm64 or x86_64 respectively, other architectures
> > will report failure when compilation.
> 
> So, please check what I have in my perf/core branch, I've completely
> removed arch specific stuff from augmented_raw_syscalls.c.
> 
> What is done now is use a map to specify what to copy, that same map
> that is used to state which syscalls should be traced.
> 
> It uses that tools/perf/arch/arm64/entry/syscalls/mksyscalltbl to figure
> out the mapping of syscall names to ids, just like is done for x86_64
> and other arches, falling back to audit-libs when that syscalltbl thing
> is not present.

Actually I have noticed mksyscalltbl has been enabled for arm64, and
had to say your approach is much better :)

Thanks for the info and I will try your patch at my side.

[...]

Thanks,
Leo Yan
