Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B43F48BAD9
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 23:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbiAKWjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 17:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiAKWjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 17:39:49 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347A4C06173F;
        Tue, 11 Jan 2022 14:39:49 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d10-20020a17090a498a00b001b33bc40d01so2614069pjh.1;
        Tue, 11 Jan 2022 14:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=97CiwfAhfn4FTWlqHWf+0pyGh9oYYOmuavEzGO/cVo4=;
        b=AT++p5EFQ3rBHReLFOVwo90beLjOF170qiYD5AgfHMibFYAka3sMANJc8EqPnhTCWB
         2DLYI6HfKGOt3raxExK751GXSNjc5yPq3lhluAGRnEdL1Mz2qrsIAjYw94HnMn5YHIrQ
         +Gt+eLVg0auXCgzh799ty0aHiRLJD//cEVFtZVfiPUNYWkFZvdp4bXMl5g7HtQ4hoAXV
         NGzN/1HYYx1qzz0igxqrzBrFdEhiVa8ON388VECwol6/7wRsWLjhh5qwPF5G0EejGOqa
         JMbyWzXjvCvKdwuWcx6EkFd7zyynZqUDIG1qxNbBVaw1GWU2/DDR7tf8Iz99QUz+/IQe
         FCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=97CiwfAhfn4FTWlqHWf+0pyGh9oYYOmuavEzGO/cVo4=;
        b=GDW+6flTijvG1nXlca2LpPrzRWYYsiGp+nSq5l4nvhF4RLC1Yr1tn3l0KNzdpxOceo
         i9kuaNLpYrG08Y0vC+aRk/7vBKhJGgYpAiTKpQ+Y2mLnHfr2WpLScbxXQ2CisX/Znv0N
         JCxkgfQ6r7+5/JxVkItxe0glZjeRgn1iWjYoC3NnT3dDg1xiItFdFTqpNDkTsudfgMt+
         JcSnTOjHLoX5dW5x9BVOZJy8gKAqhfEetSKUIRRTVlS9iHUEEWKtesEDERcInnlF5SRA
         ZMCkx4qFtfY9eDoWlxUDk36UCLAfaIEMURIMDtnrU8UFy2W9qY9tMN27mzNsFsQUnhCO
         mCCA==
X-Gm-Message-State: AOAM532thJyRStwNu5i4NN3MGvfdyE0gs2+3oOa46hGM5QQqfsvRknjM
        uLz41cVvnef+stI8/gd0Oy8=
X-Google-Smtp-Source: ABdhPJwX+sM8+ky6mAch/Qbg57pfTU/WkxNRIA9uIATYx2hIMi6S+tRJ0U5wPwtrTkxX3X6C4CbZoA==
X-Received: by 2002:a63:be49:: with SMTP id g9mr5767535pgo.375.1641940788546;
        Tue, 11 Jan 2022 14:39:48 -0800 (PST)
Received: from ast-mbp.lan ([2603:3023:16e:5000:1c05:63fe:2a0d:fa56])
        by smtp.gmail.com with ESMTPSA id j18sm320893pgi.78.2022.01.11.14.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 14:39:48 -0800 (PST)
Date:   Tue, 11 Jan 2022 14:39:44 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 0/6] fprobe: Introduce fprobe function entry/exit
 probe
Message-ID: <20220111223944.jbi3mxedwifxwyz5@ast-mbp.lan>
References: <20220104080943.113249-1-jolsa@kernel.org>
 <164191321766.806991.7930388561276940676.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164191321766.806991.7930388561276940676.stgit@devnote2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 12:00:17AM +0900, Masami Hiramatsu wrote:
> Hi Jiri,
> 
> Here is a short series of patches, which shows what I replied
> to your series.
> 
> This introduces the fprobe, the function entry/exit probe with
> multiple probe point support. This also introduces the rethook
> for hooking function return, which I cloned from kretprobe.
> 
> I also rewrite your [08/13] bpf patch to use this fprobe instead
> of kprobes. I didn't tested that one, but the sample module seems
> to work. Please test bpf part with your libbpf updates.
> 
> BTW, while implementing the fprobe, I introduced the per-probe
> point private data, but I'm not sure why you need it. It seems
> that data is not used from bpf...
> 
> If this is good for you, I would like to proceed this with
> the rethook and rewrite the kretprobe to use the rethook to
> hook the functions. That should be much cleaner (and easy to
> prepare for the fgraph tracer integration)

What is the speed of attach/detach of thousands fprobes?
