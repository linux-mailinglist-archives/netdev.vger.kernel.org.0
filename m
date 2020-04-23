Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800F61B52DB
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgDWDBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgDWDBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:01:09 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B9BC03C1AA;
        Wed, 22 Apr 2020 20:01:09 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so1853333pjb.3;
        Wed, 22 Apr 2020 20:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SszMSwgJcLsZFLhmJ+6/nXgWCME2buHUY0yZSC181eE=;
        b=rkkLpnUi/cy1SZFidflk4pKoOsngA63VPsxQSR2XZYfdYXM3w0tiqQHyzbkxoQ+eU9
         /evpDz2s8yZVls/k3Zbcqjre0rsgkhidNmK9Xdh3srt6RT77o6AvNtNOC8HFoCa3yje5
         r84Bp9V1MxGEbQC314DM2dEVzv/MPAbZsjBI9r6CculDWUrrCjbH9bD0rcd8tgbUFLnY
         6YjLPmsL/prrlUBT0LYCa+OJPkSkFLj8onl3ao6sm0O8KKHmcl46mrlLQ+xo7vTsFT2S
         zoE6gNUpHOFtlaxhz13XJg568HZtpAhgWbFO02MZclUWyoFyin6tSdaCUqK15SkiJbR7
         aIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=SszMSwgJcLsZFLhmJ+6/nXgWCME2buHUY0yZSC181eE=;
        b=YJkFweTuewuzWSCsuyOsnkAKRr/VZMemcvYDQFco4uPUkgqlb5jp1QMYQYdlaOtHTU
         TuqU8YUedMTx5z8f5dHZQ7ZaStWoqNo138Wd2X0+qPs5zv5Hw0PJ+uXz0SQYfw+YRN4w
         5WMcvf+bm2xkOBWKFN2vrPimk3KnnV8+VyZFzFC8+cHmTcE2Yiwglkmxbynidb+oP1z4
         bOQUQVXb4lfGP12DFEcd6Y8LccFeWprgZo0em+hlaZF4RDrOe+7kyLBss2cKe/isjdIP
         AUhQFR5xH2I15Su8qBuiZ/W0nG7K8KU7J3/EnphxNh+Ml2HAmikdvLHkuc+XR30ZXQOZ
         zUZw==
X-Gm-Message-State: AGi0PuZUL87+FxmhWJMR4D8yg+NOposPxKh8bp8inR8Flf5h1anBTx5m
        67VcCv6DPehjE2LVc9MTz8Q=
X-Google-Smtp-Source: APiQypIpvEzGCkVcF/iO7ei/fblmHcVdtiYFgo1qQiFB+QQB/IgEKA5O179F9FhzrtOZbYS+QVsv4Q==
X-Received: by 2002:a17:90b:128d:: with SMTP id fw13mr2023311pjb.23.1587610868674;
        Wed, 22 Apr 2020 20:01:08 -0700 (PDT)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id a9sm652683pgv.18.2020.04.22.20.01.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:01:07 -0700 (PDT)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id 03N2AUAd017467;
        Thu, 23 Apr 2020 10:10:30 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id 03N2AM3V017464;
        Thu, 23 Apr 2020 10:10:22 +0800
Date:   Thu, 23 Apr 2020 10:10:22 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Jason Yan <yanaijie@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, lukenels@cs.washington.edu,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf, x32: remove unneeded conversion to bool
Message-ID: <20200423021021.GA16982@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Yan <yanaijie@huawei.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        lukenels@cs.washington.edu, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200420123727.3616-1-yanaijie@huawei.com>
 <dff9a49b-0d00-54b0-0375-cc908289e65a@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dff9a49b-0d00-54b0-0375-cc908289e65a@zytor.com>
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:43:58AM -0700, H. Peter Anvin wrote:
> On 2020-04-20 05:37, Jason Yan wrote:
> > The '==' expression itself is bool, no need to convert it to bool again.
> > This fixes the following coccicheck warning:
> > 
> > arch/x86/net/bpf_jit_comp32.c:1478:50-55: WARNING: conversion to bool
> > not needed here
> > arch/x86/net/bpf_jit_comp32.c:1479:50-55: WARNING: conversion to bool
> > not needed here
> > 
> > Signed-off-by: Jason Yan <yanaijie@huawei.com>
> > ---
> >  arch/x86/net/bpf_jit_comp32.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> 
> x32 is not i386.
> 
> 	-hpa
Hi! H. Peter Anvin and all

I use the name "x86_32" to describe it in original commit 03f5781be2c7
("bpf, x86_32: add eBPF JIT compiler for ia32"), but almost all following
committers and contributors use the world "x32", I think it is short format
for x{86_}32.

Yes, I agree, "x32" isn't the right name here, I think "x32" is well known
as a ABI, so maybe we should use "x86_32" or ia32 in future communication.

Which one is the best name here? x86_32 or ia32 or anything other?

Thanks!


