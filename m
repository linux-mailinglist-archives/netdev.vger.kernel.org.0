Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8C4370D7
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfFFJwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:52:12 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41356 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfFFJwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:52:12 -0400
Received: by mail-yw1-f68.google.com with SMTP id y185so614444ywy.8
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OF/6ZkMdc/RdYDV51lRDRPrAIYbV+QfL4/gwTFmX58o=;
        b=i4GhBjo22XTIEoTVFapUwK6vtxHp2srk589bcFqG7zA6h9A7QlQy8wk4zcip8ufPkv
         Wom0pmtc9P0E8pgBGK2uZpFBOvYSULfziXMHjdcl2Cqwha/EgKFSEi4wp8WmHk1I2Cb3
         HtHBbhoFiPMDqajIz628DOwFKJGvxum1mBMnXEsHvtKHPpkzxvUQ3d8fhUgn6/yuggHV
         xvbBzu511lKlcEysVXWtNjVoVsDU98d2JSgux2auBYwS09gi962zYd2O47DG5dwMFJd+
         88wKOuQfDn7OyXbJb2Tjq6RDVaqOKSU2yZq285mMJN49Wyb+wHXed//7aLWqRp+iHQwH
         M/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OF/6ZkMdc/RdYDV51lRDRPrAIYbV+QfL4/gwTFmX58o=;
        b=SX8FbVimpvlyXR3UYzZGYEX2Fgn8h+yB2Ch5ESL4ZQ711bLTarmMHKSlzElURb5Dd9
         pQxSnLSSKxj0uPYRmypH0o0tjE7b8+IAZIdHsvhTvims24v5raUKMqVBSOyUDPgszqZE
         2USOb7nmRddC0efc7FtMFRIXfnrZWriWCnvuA+Am3MO6xJqH7knvX8pbqAnCa50vx4W/
         qMCXEfOnoJrsF4nVlZO9aHCrFFmREnqMZwisk//0j1+I1OQUSbR+UaQmHRv7TG9w7lDW
         vZQpbFL1MBT1y7wHqchsQCTpPz5yQcdX32cW8bQGsJE4XA/visW8dxwdilfUZLIXt9Fy
         EQTw==
X-Gm-Message-State: APjAAAXnRkPuRgsXnwMJnRyqYlMOcY4b8pZ99HeLKQkWgWnKPEMTw9lC
        z/JG5DxAzc0Kpb1LVVL4oyakpqZYZRpsng==
X-Google-Smtp-Source: APXvYqzIj6mHr6vIMB/M2RU7ehBrhqLjyy5K3mdgCBcs8U4OXzN7ueQNfKWSr3JXx53EPAHS6jc2aw==
X-Received: by 2002:a0d:c5c4:: with SMTP id h187mr22411029ywd.450.1559814731356;
        Thu, 06 Jun 2019 02:52:11 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id r6sm359910ywd.47.2019.06.06.02.52.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 02:52:10 -0700 (PDT)
Date:   Thu, 6 Jun 2019 17:52:02 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Subject: Re: [PATCH v1 0/4] perf augmented_raw_syscalls: Support for arm64
Message-ID: <20190606095202.GA5970@leoy-ThinkPad-X240s>
References: <20190606075617.14327-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606075617.14327-1-leo.yan@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Thu, Jun 06, 2019 at 03:56:13PM +0800, Leo Yan wrote:
> When I tried to run the trace on arm64 platform with eBPF program
> augmented_raw_syscalls, it reports several failures for eBPF program
> compilation.  So tried to resolve these issues and this patch set is
> the working result.
> 
> 0001 patch lets perf command to exit directly if find eBPF program
> building failure.
> 
> 0002 patch is minor refactoring code to remove duplicate macro.
> 
> 0003 patch is to add support arm64 raw syscalls numbers.

I found minor issues in patch 0003, so sent out v2 for reviewing.

Sorry for spamming.

Thanks,
Leo Yan

> 0004 patch is to document clang configuration so that can easily use
> this program on both x86_64 and aarch64 platforms.
> 
> 
> Leo Yan (4):
>   perf trace: Exit when build eBPF program failure
>   perf augmented_raw_syscalls: Remove duplicate macros
>   perf augmented_raw_syscalls: Support arm64 raw syscalls
>   perf augmented_raw_syscalls: Document clang configuration
> 
>  tools/perf/builtin-trace.c                    |   8 ++
>  .../examples/bpf/augmented_raw_syscalls.c     | 102 +++++++++++++++++-
>  2 files changed, 109 insertions(+), 1 deletion(-)
> 
> -- 
> 2.17.1
> 
