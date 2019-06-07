Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF00939465
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbfFGSde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:33:34 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34528 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730870AbfFGSde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:33:34 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so3450768qtu.1;
        Fri, 07 Jun 2019 11:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QNRX9KnxWkZ2r9K8YGQq6ZdDeDJ/GrTZUflSmXosl7M=;
        b=bWHWpsvEXP6UCqxstvYTLpY98dCZdRFEJaXRlEBBKPuFW7gjzbELeALwqVKt5gMcoO
         OitNPdnpbl3Agn1TV1Zj+XaK9RHHEsCzeC4CUgDIzpSliYHVHJjRRQh9g4Nv+gX9hd1G
         E8VQ5EMXS0VSS8hp+66tlYAFV5QwYz8GHWnFaKAGw7E8Xd5tjulhLKvA5qO49wCjyuzW
         ah2MSK5omCXAGvmMFmOAE8wDRlX1cGnx8sBOKokrHZ+hF1RacuN+ac4vnSJeRPYfEt2d
         e8rCKl2BwFSMa/UQYi1w2iBQua3fbimTOmK4HYZgvP7y2inEaALM4IyBVwsWYOVIkN0E
         P6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QNRX9KnxWkZ2r9K8YGQq6ZdDeDJ/GrTZUflSmXosl7M=;
        b=r41Gh2le1OZOrwIV/kcX4E1TZGWRqtXjZQrhixT9YU23DPDn5vIHt9wHhyZEW0IbZJ
         SD9zV+epWzJf/t8Ja0Uw3puNZfBxs4TUlmXv6+FX0wROiRvvVO0XivLVeSNQ7UUp9Qee
         Tf1cewGnAO1tUe2pFQzIR1UTbrEgnSP2flxAngrO0pdJ7e7ghmHfhEkYSjJL7SmNgNO8
         OAWmJ3Zuz8nCw4X5iV7247ijBLHultWHXJLj3aV4+rQKZ+fO63NbBrmA3c1BKgQbhUNU
         EW1HKPcMhb+jTLl6feN1fmQBVnnXyzp2hn7sIiC9/VgMyhoEVxLOycGsfiqO1rF6k4bt
         aEXQ==
X-Gm-Message-State: APjAAAUCBwzDOVFtr81LOcd9WaaQ680WLnDSMI1q+dsiHCaAViR3Jnyv
        PHF34westCdbYhFFM7S5Ye4=
X-Google-Smtp-Source: APXvYqywQCAflJJIG/WDcICjNR9y51jZgagcRPT2LEDOooYhRTB2XYGnyCKSbsqBjPF7IaWwtzFTOg==
X-Received: by 2002:ac8:18b2:: with SMTP id s47mr46754820qtj.75.1559932412813;
        Fri, 07 Jun 2019 11:33:32 -0700 (PDT)
Received: from quaco.ghostprotocols.net (187-26-97-17.3g.claro.net.br. [187.26.97.17])
        by smtp.gmail.com with ESMTPSA id o6sm1604801qtc.47.2019.06.07.11.33.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 11:33:31 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4093741149; Fri,  7 Jun 2019 15:33:28 -0300 (-03)
Date:   Fri, 7 Jun 2019 15:33:28 -0300
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
Message-ID: <20190607183328.GN21245@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-5-leo.yan@linaro.org>
 <20190606140800.GF30166@kernel.org>
 <20190606143532.GD5970@leoy-ThinkPad-X240s>
 <20190606182941.GE21245@kernel.org>
 <20190607143849.GI5970@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607143849.GI5970@leoy-ThinkPad-X240s>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jun 07, 2019 at 10:38:49PM +0800, Leo Yan escreveu:
> Hi Arnaldo,
> 
> On Thu, Jun 06, 2019 at 03:29:41PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jun 06, 2019 at 10:35:32PM +0800, Leo Yan escreveu:
> > > On Thu, Jun 06, 2019 at 11:08:00AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Thu, Jun 06, 2019 at 05:48:45PM +0800, Leo Yan escreveu:
> > > > > To build this program successfully with clang, there have three
> > > > > compiler options need to be specified:
> > > > > 
> > > > >   - Header file path: tools/perf/include/bpf;
> > > > >   - Specify architecture;
> > > > >   - Define macro __NR_CPUS__.
> > > > 
> > > > So, this shouldn't be needed, all of this is supposed to be done
> > > > automagically, have you done a 'make -C tools/perf install'?
> > > 
> > > I missed the up operation.  But after git pulled the lastest code base
> > > from perf/core branch and used the command 'make -C tools/perf
> > > install', I still saw the eBPF build failure.
> > > 
> > > Just now this issue is fixed after I removed the config
> > > 'clang-bpf-cmd-template' from ~/.perfconfig;  the reason is I followed
> > > up the Documentation/perf-config.txt to set the config as below:
> > > 
> > >   clang-bpf-cmd-template = "$CLANG_EXEC -D__KERNEL__ $CLANG_OPTIONS \
> > >                           $KERNEL_INC_OPTIONS -Wno-unused-value \
> > >                           -Wno-pointer-sign -working-directory \
> > >                           $WORKING_DIR -c $CLANG_SOURCE -target bpf \
> > >                           -O2 -o -"
> > > 
> > > In fact, util/llvm-utils.c has updated the default configuration as
> > > below:
> > > 
> > >   #define CLANG_BPF_CMD_DEFAULT_TEMPLATE                          \
> > >                 "$CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS "\
> > >                 "-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "     \
> > >                 "$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
> > >                 "-Wno-unused-value -Wno-pointer-sign "          \
> > >                 "-working-directory $WORKING_DIR "              \
> > >                 "-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
> > > 
> > > Maybe should update Documentation/perf-config.txt to tell users the
> > > real default value of clang-bpf-cmd-template?
> > 
> > Sure, if you fell like doing this, please update and also please figure
> > out when the this changed and add a Fixes: that cset,
> 
> Thanks for guidance.  Have sent patch for this [1].

yeah, applied already.

- Arnaldo
 
> > Its great that you're going thru the docs and making sure the
> > differences are noted so that we update the docs, thanks a lot!
> 
> You are welcome!


