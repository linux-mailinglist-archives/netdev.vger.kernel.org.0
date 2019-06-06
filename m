Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572BF37C47
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbfFFS3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:29:53 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44423 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729165AbfFFS3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:29:53 -0400
Received: by mail-qt1-f193.google.com with SMTP id x47so3804314qtk.11;
        Thu, 06 Jun 2019 11:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VDyWzmRCEFjiSNNaRnKgaThnkb6qt5FoNhaBpkNRo4o=;
        b=AAlI2KM0uk4kE32HxvkLoOpHYXsGwTmmS3guDD0J9itTCOT6EA1N308hWHCK6p1paf
         hXwv9mzUL7eVRRjl9LVk2FPptt5QYiUu6AmVQyXYVNYYZnsP2Q7nk6fhdiFK3E0YtFOF
         hDSsyKUbrWsQ/w+amz1hTw34jj+O3oSjUy7CMFCRs2NKPxM/ZBOViJFwcsAHTSCJrmIp
         ZcV1xsGbC39xQYk0EcD7iG2S1vRg61MUF/PnpRP/0Fo/W9tDLRi/gyfnyN7koKIYsUkL
         ZJrvGlnj6+fYdGO9e2EHTA3xFR3QM7er5dSgLvkfIUDMqBQ3vGFvBxdnUPcD6LQBkurK
         nrXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VDyWzmRCEFjiSNNaRnKgaThnkb6qt5FoNhaBpkNRo4o=;
        b=OstfW8VTnnlEVel9NlPNLnzcHCADNxwYvBQ44TDhDaPWS450hjNGvCNO8K3YyLxzJ/
         gLZVHqlzcp3uNRVFnhrmbnLjAkctH4+y5F+NNYJJ+PbhvaOENmTQijQB5yRwosK34DjJ
         7UtMF0tw3/ejaRM6TKFC4afFpHh3HmiSBPtxMPwSJ3jmMFFM+SBzNr+nDJaAciw0lg/v
         J/g9hJ+J1urldyM/SlJGrOtmrhYcOLxU7DiS7OY3HL+WbCEUPi3vkG1DBlqYf8CzYqXx
         fk9p3GIWLeDipiXhxnua7mkzjdHtPVMSzHZd7fWJ+epIbxV6nX7K5pRqwNHCXH//WiV7
         uNOA==
X-Gm-Message-State: APjAAAW7M3nNBG71QMSDWQyMN9z9YR034LU4CCh4Ub2fMLktid0tcqGo
        kAwrURwAm82evJtJjpEBslE=
X-Google-Smtp-Source: APXvYqxSQs6DlT2QSTIZfamR7F6e/5KiLWc1qKb6vFB+/5MPiN3QfN7IcRBzokNHwN+mLuffT0AfyQ==
X-Received: by 2002:ac8:1855:: with SMTP id n21mr38568496qtk.311.1559845791966;
        Thu, 06 Jun 2019 11:29:51 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.209.167])
        by smtp.gmail.com with ESMTPSA id x7sm1581941qth.37.2019.06.06.11.29.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 11:29:51 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 36B6341149; Thu,  6 Jun 2019 15:29:41 -0300 (-03)
Date:   Thu, 6 Jun 2019 15:29:41 -0300
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
Subject: Re: [PATCH v2 4/4] perf augmented_raw_syscalls: Document clang
 configuration
Message-ID: <20190606182941.GE21245@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-5-leo.yan@linaro.org>
 <20190606140800.GF30166@kernel.org>
 <20190606143532.GD5970@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606143532.GD5970@leoy-ThinkPad-X240s>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 06, 2019 at 10:35:32PM +0800, Leo Yan escreveu:
> On Thu, Jun 06, 2019 at 11:08:00AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jun 06, 2019 at 05:48:45PM +0800, Leo Yan escreveu:
> > > To build this program successfully with clang, there have three
> > > compiler options need to be specified:
> > > 
> > >   - Header file path: tools/perf/include/bpf;
> > >   - Specify architecture;
> > >   - Define macro __NR_CPUS__.
> > 
> > So, this shouldn't be needed, all of this is supposed to be done
> > automagically, have you done a 'make -C tools/perf install'?
> 
> I missed the up operation.  But after git pulled the lastest code base
> from perf/core branch and used the command 'make -C tools/perf
> install', I still saw the eBPF build failure.
> 
> Just now this issue is fixed after I removed the config
> 'clang-bpf-cmd-template' from ~/.perfconfig;  the reason is I followed
> up the Documentation/perf-config.txt to set the config as below:
> 
>   clang-bpf-cmd-template = "$CLANG_EXEC -D__KERNEL__ $CLANG_OPTIONS \
>                           $KERNEL_INC_OPTIONS -Wno-unused-value \
>                           -Wno-pointer-sign -working-directory \
>                           $WORKING_DIR -c $CLANG_SOURCE -target bpf \
>                           -O2 -o -"
> 
> In fact, util/llvm-utils.c has updated the default configuration as
> below:
> 
>   #define CLANG_BPF_CMD_DEFAULT_TEMPLATE                          \
>                 "$CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS "\
>                 "-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "     \
>                 "$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
>                 "-Wno-unused-value -Wno-pointer-sign "          \
>                 "-working-directory $WORKING_DIR "              \
>                 "-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
> 
> Maybe should update Documentation/perf-config.txt to tell users the
> real default value of clang-bpf-cmd-template?

Sure, if you fell like doing this, please update and also please figure
out when the this changed and add a Fixes: that cset,

Its great that you're going thru the docs and making sure the
differences are noted so that we update the docs, thanks a lot!

- Arnaldo
