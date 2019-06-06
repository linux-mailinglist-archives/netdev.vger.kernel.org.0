Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95373770B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfFFOoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:44:19 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36038 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfFFOoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:44:19 -0400
Received: by mail-qk1-f196.google.com with SMTP id g18so1611187qkl.3;
        Thu, 06 Jun 2019 07:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QiT2s8e89xd+f/5BqwjU7xp+ncS2jpCgbXa7HZDxqTY=;
        b=VhwyJU/+ivjU1zPCSlPQrda2fDRKoXHBpsp2xDCXDh5RJs9qZ2ZFMKzDR8OqNKFxRH
         6MoaSJ7Rj58BYSaLH+brbA4YxXwdSxwLaXawTEi0ZHRYIstMhx6dVKBzZBEtDdwWGEHW
         qT+S/LFrIHtJxhxcpJ6l4gJDmestUH5rdGKFuirXpfNylF8FOYMxrC079t2BhL/BPbdb
         EBtt8Dfz7X4LbqyebRStRq6QKofSvBbto0bw/KtM3IoDm6GQIdVgQ4FjWAHNRCBBozEx
         F+sxVXYrWq7mfy1CeStus+t7NqCx/IpOANbhtK9hJMTAWuOvDT5YGJ5uRBYk4NO0Xea7
         8z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QiT2s8e89xd+f/5BqwjU7xp+ncS2jpCgbXa7HZDxqTY=;
        b=HxOwlITr24fiP19bQmp7F1aQ7tPunYd7bIt+5Giu4pEfQRUMm47MfwbHUFRinSnHkA
         OHXfREW7fhTgLhEpwwoNxkvjFUy25aGEYJwsEJr833QL0qZisuUBzpGlYav7AzrNobyK
         Z+tZRkW5O/58pq/xvhrvvmkZRbdfcHciUkG8zslK89XY/JysJlC4mfwl5Q2H9wNbXaYa
         WKcHEBcfKfTGkOecbjbFHAe6nXUu9upnneeWl06qpg1e2WO6yg27Y6j67gUvGVt0K/xD
         oziigxmcWIVcaoM+RbUjNyiToON++dwmnfRW3EXsD9n2VQnVinfJzqQcVgw8rWmiEiFf
         bUaA==
X-Gm-Message-State: APjAAAV2/7pW1rXCbC84sB/BVw7vHkN1drk3Wm+cch7SeUp9izeMVKqZ
        03z7vaYbnFaLLiaJDJmsCbY=
X-Google-Smtp-Source: APXvYqy4gqJMKLRhlKX01BsFurCNHHmfUplwwtZoGmnZbOzn9Wr0V47tBBll7Ci9gBAUn4qZlccVBA==
X-Received: by 2002:a37:5c8:: with SMTP id 191mr27446435qkf.188.1559832257784;
        Thu, 06 Jun 2019 07:44:17 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.208.82])
        by smtp.gmail.com with ESMTPSA id q37sm1216774qtj.94.2019.06.06.07.44.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 07:44:16 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2B59A41149; Thu,  6 Jun 2019 11:44:12 -0300 (-03)
Date:   Thu, 6 Jun 2019 11:44:12 -0300
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
Message-ID: <20190606144412.GC21245@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-4-leo.yan@linaro.org>
 <20190606133838.GC30166@kernel.org>
 <20190606141231.GC5970@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606141231.GC5970@leoy-ThinkPad-X240s>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 06, 2019 at 10:12:31PM +0800, Leo Yan escreveu:
> Hi Arnaldo,
> 
> On Thu, Jun 06, 2019 at 10:38:38AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jun 06, 2019 at 05:48:44PM +0800, Leo Yan escreveu:
> > > This patch adds support for arm64 raw syscall numbers so that we can use
> > > it on arm64 platform.
> > > 
> > > After applied this patch, we need to specify macro -D__aarch64__ or
> > > -D__x86_64__ in compilation option so Clang can use the corresponding
> > > syscall numbers for arm64 or x86_64 respectively, other architectures
> > > will report failure when compilation.
> > 
> > So, please check what I have in my perf/core branch, I've completely
> > removed arch specific stuff from augmented_raw_syscalls.c.
> > 
> > What is done now is use a map to specify what to copy, that same map
> > that is used to state which syscalls should be traced.
> > 
> > It uses that tools/perf/arch/arm64/entry/syscalls/mksyscalltbl to figure
> > out the mapping of syscall names to ids, just like is done for x86_64
> > and other arches, falling back to audit-libs when that syscalltbl thing
> > is not present.
> 
> Actually I have noticed mksyscalltbl has been enabled for arm64, and
> had to say your approach is much better :)
> 
> Thanks for the info and I will try your patch at my side.

That is excellent news! I'm eager to hear from you if this perf+BPF
integration experiment works for arm64.

I'm now trying to get past the verifier when checking if more than one
syscall arg is a filename, i.e. things like the rename* family, that
take two filenames.

An exercise in loop unrolling, providing the right hints to the
verifier, making sure clang don't trash those via explicit barriers, and
a lot of patience, limitless fun! ;-)

- Arnaldo
