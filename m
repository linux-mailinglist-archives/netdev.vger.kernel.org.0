Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137B82F777D
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbhAOLTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbhAOLTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:19:08 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417F5C0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:18:28 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id k10so6995360wmi.3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1v0kX8Ej1D5vKbj6l4aBaWcu5DlgLp/Dsh/tnFpcg+Y=;
        b=q3yaL+9Dr08XGvGA9C6LCEyO8dv4MnZdXyFkQYqmFx0J6077BQyNrC3ZfumRsecp3C
         jhWw5mwhLJPw0Cs1JbrRKisZLtJwnz1td5U9T0NGKs1Du/ixjp/OJBAzJfzKRI6OcJk7
         jMEwkkp1Tkj+4L5MV7I56bqhm0b41JzVf87hKjB9+45TNRkOJr4vpR/ubLc/6rtvmcJ5
         7mCbPO3LDc6oV5qxhdZ2mVZdYUEoFwtOSOsE5jhkTTaKb96r2hJSt5iuNgvxYG8TmgQR
         6/dS/oeqnNfc5YG3pyRPZOkm06JhrYQzWk/YJrzGR6qgls7QN+s9q82XGRS8f8pSX4Qd
         is3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1v0kX8Ej1D5vKbj6l4aBaWcu5DlgLp/Dsh/tnFpcg+Y=;
        b=bucg4HfB+rl/3ruCBfwM0v/yyFKQdmk/qVkt5AGlZogEhXvuMb/KINrTFCM8hp5NSA
         T5w06t2koBpGzrKGITRnpkl3XP9R9iju1tuneG/afbb6hVKKMjMOXTLGLSAUEUfZaQFp
         A/RPfVH0X1FkS+riW7DuLQRsfgqrnCEItV8MKqWKG+xg69lSIK9FW9DOZOlH8PPFGoRG
         D9utJauA4Yez4rYDVViz3wYU6pXMCmfmTKfi8mxiHMjLzLt3XRB5Lf8RhWpEw05vWBIW
         rD96XQ0ZSW72NZMdjL/zWgYYTXna/9QNX0BV6H/z3BRMcKfWprBwZya1uYKEnXUF/KiK
         6dfA==
X-Gm-Message-State: AOAM5324P70mL/zVpBNRLAD9Yd+nP0csEuTszkufXk08aZP1r1LtVejE
        bNxCosmql8refyGudk4xyZdQ5g==
X-Google-Smtp-Source: ABdhPJy6Ksm7TL3YP23vSBkfPg6+Ma2TEXquqULAQIh92rfS/zIKFK4APldrd16rYZnbmfKF7kRaEA==
X-Received: by 2002:a05:600c:4417:: with SMTP id u23mr8306553wmn.100.1610709506910;
        Fri, 15 Jan 2021 03:18:26 -0800 (PST)
Received: from dell ([91.110.221.158])
        by smtp.gmail.com with ESMTPSA id i18sm14818507wrp.74.2021.01.15.03.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 03:18:26 -0800 (PST)
Date:   Fri, 15 Jan 2021 11:18:23 +0000
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
Message-ID: <20210115111823.GH3975472@dell>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
 <20210113183551.6551a6a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114083349.GI3975472@dell>
 <20210114091453.30177d20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114195422.GB3975472@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210114195422.GB3975472@dell>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021, Lee Jones wrote:

> On Thu, 14 Jan 2021, Jakub Kicinski wrote:
> 
> > On Thu, 14 Jan 2021 08:33:49 +0000 Lee Jones wrote:
> > > On Wed, 13 Jan 2021, Jakub Kicinski wrote:
> > > 
> > > > On Wed, 13 Jan 2021 16:41:16 +0000 Lee Jones wrote:  
> > > > > Resending the stragglers again.                                                                                  
> > > > > 
> > > > > This set is part of a larger effort attempting to clean-up W=1                                                   
> > > > > kernel builds, which are currently overwhelmingly riddled with                                                   
> > > > > niggly little warnings.                                                                                          
> > > > >                                                                                                                  
> > > > > v2:                                                                                                              
> > > > >  - Squashed IBM patches                                                                                      
> > > > >  - Fixed real issue in SMSC
> > > > >  - Added Andrew's Reviewed-by tags on remainder  
> > > > 
> > > > Does not apply, please rebase on net-next/master.  
> > > 
> > > These are based on Tuesday's next/master.
> > 
> > What's next/master?
> 
> I'm not sure if this is a joke, or not? :)
> 
> next/master == Linux Next.  The daily merged repo where all of the
> *-next branches end up to ensure interoperability.  It's also the
> branch that is most heavily tested by the auto-builders to ensure the
> vast majority of issues are ironed out before hitting Mainline.
> 
> > This is net-next:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
> 
> Looks like net-next gets merged into next/master:
> 
> commit 452958f1f3d1c8980a8414f9c37c8c6de24c7d32
> Merge: 1eabba209a17a f50e2f9f79164
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Thu Jan 14 10:35:40 2021 +1100
> 
>     Merge remote-tracking branch 'net-next/master'
> 
> So I'm not sure what it's conflicting with.
> 
> Do you have patches in net-next that didn't make it into next/master
> for some reason?
> 
> I'll try to rebase again tomorrow.
> 
> Hopefully I am able to reproduce your issue by then.

Okay so my development branch rebased again with no issue.

I also took the liberty to checkout net-next and cherry-pick the
patches [0], which again didn't cause a problem.

I'm not sure what else to suggest.  Is your local copy up-to-date?

[0]

lee@dell:~/projects/linux/kernel [net-next]$ gcp 0cea4b05acd57..924e1f46aba5e
Auto-merging drivers/net/ethernet/smsc/smc91x.c
[net-next 19811db3120a2] net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
 Date: Mon Oct 19 12:47:11 2020 +0100
 1 file changed, 1 insertion(+), 1 deletion(-)
[net-next dc6f4490cb64e] net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
 Date: Tue Oct 20 08:00:43 2020 +0100
 1 file changed, 2 insertions(+), 2 deletions(-)
[net-next a3363cb09ae59] net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function header
 Date: Tue Oct 20 09:05:38 2020 +0100
 1 file changed, 1 insertion(+), 1 deletion(-)
[net-next 005462f886c3e] net: ethernet: ti: am65-cpts: Document am65_cpts_rx_enable()'s 'en' parameter
 Date: Tue Oct 20 09:06:57 2020 +0100
 1 file changed, 1 insertion(+), 1 deletion(-)
Auto-merging drivers/net/xen-netfront.c
[net-next 9fcc32e395e09] net: ethernet: ibm: ibmvnic: Fix some kernel-doc misdemeanours
 Date: Tue Oct 20 09:42:19 2020 +0100
 2 files changed, 16 insertions(+), 17 deletions(-)
[net-next 15ba865fef481] net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc misdemeanours
 Date: Tue Oct 20 10:10:14 2020 +0100
 1 file changed, 5 insertions(+), 3 deletions(-)
[net-next f815eb7cbd7f5] net: ethernet: toshiba: spider_net: Document a whole bunch of function parameters
 Date: Tue Oct 20 10:18:21 2020 +0100
 1 file changed, 11 insertions(+), 7 deletions(-)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
