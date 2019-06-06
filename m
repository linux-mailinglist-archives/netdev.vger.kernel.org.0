Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDBD3759C
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfFFNqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:46:30 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33288 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfFFNqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:46:30 -0400
Received: by mail-qt1-f194.google.com with SMTP id 14so2717331qtf.0;
        Thu, 06 Jun 2019 06:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sxuZRg/a5BwwLpOXc2E8P4g4IXtD5jAKIRcm5GraeZs=;
        b=XHOrwfS8/mtrMMyB0x5R2qAgNUAIbmokPuEjYslAfmR42hmTwX6mUmvqN0qJVubtIA
         apBbNQEYjXPml15lz6BHEJTV10xXUF5a6sDyMzyaiyne5WyQLcBKqZPkonlIeHJsVGeM
         m7wlYApzbK9DFyYGaWuyjgPUexcb9gM9Z78ysaRPD5M+FgS52C8hZJ85gec5f0OUj1Q1
         IODc0tO8cks0OwbkxIrpk1JLV8DGd0RTdzDZW7beSOlIe6BEMRk9LukdwPPTrpWmbjVh
         XKBQfQNgo+jLan7eW+FMPE3CY69AggrgnhF2KWAH2HBjK7a15UvDrlnFSJoQNGGeekgW
         RdEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sxuZRg/a5BwwLpOXc2E8P4g4IXtD5jAKIRcm5GraeZs=;
        b=oelqLTW1K7m53dxWmCWg1ZGiFuJ11gOzPgnirEc7Aw7yacMZ7z+JpDr82iAVum/i/B
         RWqv/7MNKk4SJzJTM61manXDTSEpjPTFepGAD85KaxWzfQ890X9T5EYwmv0Yk02GAoHA
         KwzaWEhRF8//CegcFoYH2oLUXkYdOAbbKbUREfezGJ8yMjNbCXP2S53aCymH1/7/GYnV
         M0QLC6ohokP47Z5p+CRVdUaTI8oYuLrYFb7pUcPDL1auQyeHkriz/MOwGYPj4JWjRnkd
         pWYlA1h+Yf+9iNrz/CyXpCqc3oPVTeEFekovRjuda8fJQ682keN1ia3F9mccmY5SeR1b
         O0RQ==
X-Gm-Message-State: APjAAAXNjo7Kdvq3B8YH2Z7W8iXNc5hibQFfCAokE53vc7yMdrtzNtXj
        oefYbCwIvmJRKp3PzR8rJDI=
X-Google-Smtp-Source: APXvYqzvYPqMM+pY1ADNXKjLo3mWNDAGhRI7ulZ41cG+60iOZwW/XVjlNwg0XL5s/YODyp1GiDnkwg==
X-Received: by 2002:a0c:99d8:: with SMTP id y24mr38959520qve.74.1559828789107;
        Thu, 06 Jun 2019 06:46:29 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.208.82])
        by smtp.gmail.com with ESMTPSA id d38sm1344329qtb.95.2019.06.06.06.46.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 06:46:27 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 41B7441149; Thu,  6 Jun 2019 10:46:24 -0300 (-03)
Date:   Thu, 6 Jun 2019 10:46:24 -0300
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
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 3/4] perf augmented_raw_syscalls: Support arm64 raw
 syscalls
Message-ID: <20190606134624.GD30166@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-4-leo.yan@linaro.org>
 <20190606133838.GC30166@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606133838.GC30166@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 06, 2019 at 10:38:38AM -0300, Arnaldo Carvalho de Melo escreveu:
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

Also added:

Fixes: ac96287cae08 ("perf trace: Allow specifying a set of events to add in perfconfig")

For the stable@kernel.org folks to automagically pick this.

- Arnaldo
