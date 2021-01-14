Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E9D2F6B95
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbhANTzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730174AbhANTzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:55:07 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6991EC061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 11:54:27 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id y17so7033487wrr.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 11:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Jco6OKkBzH2W5YMgKN8CdIkvv1c2tCGRqtwwKgOzoTU=;
        b=j/heu2munUhWuITG04w2E1rUlnHuKEPX2QcskO7PII2HtxbjLoBk0vUIcYEDq+Wzro
         YLJmhogwgK7dlTRE23UGZqyCSoOgK1BzwC0fWeASrYRSGQazGVMHHmXW9K9wa+vH4eTp
         7hJXY4pc3DRmorYpfjoKJWoFz8Uvtjw+DBeVr5OjnyRmzsb+lM9WLIg/+YMqhXwLk5qd
         RNXYmJFSZxYTOJYA90oJcZWqt6vrrA3MHDsaWY5r8+hnBBr2/7nsrV2TFzYqtCwHCchP
         4WXaxG6eUxVUnT80m6hPSIQ9Qd9QUYa1vNxPvRIelB9mmyGw38k8IiFKHNclOgN9xw/C
         ayag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Jco6OKkBzH2W5YMgKN8CdIkvv1c2tCGRqtwwKgOzoTU=;
        b=Q9NM3856U1WZjQPGwHRa+ikmvzCoEc0ViMTdG27ZmiKZOczN7xIZPpIAaSI/1HSfeh
         YkO9127o6A/oxfrmoWCirEyszYRqFPhgHIvd5gzjfvQoLwNIn1d1aodAnVuUXppqshDv
         BJzt38kIybnk0MToYZkfEvISF8NhvLsDkxl5QLnnVbeiLWdO3vMpqhGmCft8EghL+Uib
         UdMazT5pi9FM4wS4Md/Czi7iypNI5ezpUS4OroDcohYdC6BFQIHBUNLAW0xulKNW9ZjA
         9Xsa7Lxu+nDUNsPpNptW7cnatOKTbxF6Epduoy+3Ex7swV8+F2H7Lwp2FZ8qZ1XJ/Bex
         UlgA==
X-Gm-Message-State: AOAM5307qoBDdOjzRytWlx39LIU2wTpaOC9U67hE7xlcJe6rmtUzU7D4
        gXVsZ+swjfV2ao8bYpo6GqJImg==
X-Google-Smtp-Source: ABdhPJwTAnSC8i9erqyaC2T3bmWeIfWfGjCjtI2qx+TyOz9rMatI0AIgHFfUQq4dPzhL98mW7iEdYA==
X-Received: by 2002:adf:9d42:: with SMTP id o2mr9465225wre.135.1610654066061;
        Thu, 14 Jan 2021 11:54:26 -0800 (PST)
Received: from dell ([91.110.221.178])
        by smtp.gmail.com with ESMTPSA id b3sm5050877wme.32.2021.01.14.11.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 11:54:25 -0800 (PST)
Date:   Thu, 14 Jan 2021 19:54:22 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Dany Madden <drt@linux.ibm.com>,
        Daris A Nevil <dnevil@snmc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Erik Stahlman <erik@vt.edu>,
        Geoff Levand <geoff@infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Allen <jallen@linux.vnet.ibm.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Lijun Pan <ljp@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, Paul Durrant <paul@xen.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Cammaert <pc@denkart.be>,
        Russell King <rmk@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Santiago Leon <santi_leon@yahoo.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Wei Liu <wei.liu@kernel.org>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 0/7] Rid W=1 warnings in Ethernet
Message-ID: <20210114195422.GB3975472@dell>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
 <20210113183551.6551a6a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114083349.GI3975472@dell>
 <20210114091453.30177d20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210114091453.30177d20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021, Jakub Kicinski wrote:

> On Thu, 14 Jan 2021 08:33:49 +0000 Lee Jones wrote:
> > On Wed, 13 Jan 2021, Jakub Kicinski wrote:
> > 
> > > On Wed, 13 Jan 2021 16:41:16 +0000 Lee Jones wrote:  
> > > > Resending the stragglers again.                                                                                  
> > > > 
> > > > This set is part of a larger effort attempting to clean-up W=1                                                   
> > > > kernel builds, which are currently overwhelmingly riddled with                                                   
> > > > niggly little warnings.                                                                                          
> > > >                                                                                                                  
> > > > v2:                                                                                                              
> > > >  - Squashed IBM patches                                                                                      
> > > >  - Fixed real issue in SMSC
> > > >  - Added Andrew's Reviewed-by tags on remainder  
> > > 
> > > Does not apply, please rebase on net-next/master.  
> > 
> > These are based on Tuesday's next/master.
> 
> What's next/master?

I'm not sure if this is a joke, or not? :)

next/master == Linux Next.  The daily merged repo where all of the
*-next branches end up to ensure interoperability.  It's also the
branch that is most heavily tested by the auto-builders to ensure the
vast majority of issues are ironed out before hitting Mainline.

> This is net-next:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

Looks like net-next gets merged into next/master:

commit 452958f1f3d1c8980a8414f9c37c8c6de24c7d32
Merge: 1eabba209a17a f50e2f9f79164
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu Jan 14 10:35:40 2021 +1100

    Merge remote-tracking branch 'net-next/master'

So I'm not sure what it's conflicting with.

Do you have patches in net-next that didn't make it into next/master
for some reason?

I'll try to rebase again tomorrow.

Hopefully I am able to reproduce your issue by then.

> > I just rebased them now with no issue.
> > 
> > What conflict are you seeing?
> 
> Applying: net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
> error: patch failed: drivers/net/ethernet/smsc/smc91x.c:2192
> error: drivers/net/ethernet/smsc/smc91x.c: patch does not apply
> Patch failed at 0001 net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
