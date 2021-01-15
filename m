Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E442F7CDE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbhAONje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbhAONjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:39:33 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE56C0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 05:38:52 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v15so5654213wrx.4
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 05:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DswJVhq5oOWqV31Bgiu3EAlzk38txQMCgnjE7KAWjVA=;
        b=jXZvvwF2rP8IsoXlvyLwXO3x/CSK7EgntdzRZOi5InOS2/t6wE/3wPuCbGPo7PRm7p
         zYi56lZWwAIjU1O69C65Py54hgRcsKO+6JQsOMv/LIoQeL6X+3v5wc0Y8Zuybd2vLKHN
         p6WwQJ2tzT3qP2LdcqRUPt/96iLsmVirVebC7xAF+N8WLRNj111UQBlWXOy1P8MKS7Ym
         J/Ag+ZGSDnNBzU/6C68jLgxGK161s8dHuUWHIlNeiYXXRvWOkKNnP2j2gC5fKqgZC3nb
         ifpgWmwZmfsidZDX0ntRGiVC1h/GKNueBs/XPjLPdcX+sujI/6zAsKB2Hmz/0D2YtdaM
         RO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DswJVhq5oOWqV31Bgiu3EAlzk38txQMCgnjE7KAWjVA=;
        b=Xln6NveYxa+KRb25cKR1Whv5nHPgav+3MQ57BEfw4af0/Z7AVRvl2diFnudEWaXFct
         Fe+oMd/Exluto2s6EVOQf2+h9bM22ITTRgbWqPy7XFZInUnB/vChn7A1GDly+8ATftoS
         r4esKv+XJm9wvOTR7TFVznGYGsJYWSgXoGZRyLEdD/q5QYDRq71vdI0hn9hYbCZstP0s
         n166wgvQ1Ti6SHTAY608zgC6zwkbC7Qn9Ye3ucMnkDpzLFyPaT2jdQx07ck08HCAk5+q
         FpuGYGAvO7XjqpGOHpwDvOPKTCsWts3kJsIgxLkHzSSi6QeMrCoc1uhQ7F/SZbGBkYf9
         q05w==
X-Gm-Message-State: AOAM531TJonzTGu1WjRgHIWFBO7SuszyBOeWn4pL8KNmqGDPmd40q3LJ
        zu6i6XcsAqCbhLXLFxQ1T1ayjg==
X-Google-Smtp-Source: ABdhPJysZOhfTL14eox4hPGNf3Lqvov2cwR+lXWXy1PG1Q/0jmq6BIg+bkMfA6LBTgWGloBI3Vho+g==
X-Received: by 2002:adf:f74e:: with SMTP id z14mr13824863wrp.146.1610717931535;
        Fri, 15 Jan 2021 05:38:51 -0800 (PST)
Received: from dell ([91.110.221.158])
        by smtp.gmail.com with ESMTPSA id i11sm11689161wmq.10.2021.01.15.05.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 05:38:50 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:38:48 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paul Durrant <paul@xen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Peter Cammaert <pc@denkart.be>,
        Paul Mackerras <paulus@samba.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Wei Liu <wei.liu@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Santiago Leon <santi_leon@yahoo.com>,
        xen-devel@lists.xenproject.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Daris A Nevil <dnevil@snmc.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Erik Stahlman <erik@vt.edu>,
        John Allen <jallen@linux.vnet.ibm.com>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Dany Madden <drt@linux.ibm.com>, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v2 0/7] Rid W=1 warnings in Ethernet
Message-ID: <20210115133848.GK3975472@dell>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
 <20210113183551.6551a6a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114083349.GI3975472@dell>
 <20210114091453.30177d20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114195422.GB3975472@dell>
 <20210115111823.GH3975472@dell>
 <bc775cc3-fda3-0280-5f92-53058996f02f@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc775cc3-fda3-0280-5f92-53058996f02f@csgroup.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021, Christophe Leroy wrote:

> 
> 
> Le 15/01/2021 à 12:18, Lee Jones a écrit :
> > On Thu, 14 Jan 2021, Lee Jones wrote:
> > 
> > > On Thu, 14 Jan 2021, Jakub Kicinski wrote:
> > > 
> > > > On Thu, 14 Jan 2021 08:33:49 +0000 Lee Jones wrote:
> > > > > On Wed, 13 Jan 2021, Jakub Kicinski wrote:
> > > > > 
> > > > > > On Wed, 13 Jan 2021 16:41:16 +0000 Lee Jones wrote:
> > > > > > > Resending the stragglers again.
> > > > > > > 
> > > > > > > This set is part of a larger effort attempting to clean-up W=1
> > > > > > > kernel builds, which are currently overwhelmingly riddled with
> > > > > > > niggly little warnings.
> > > > > > > v2:
> > > > > > >   - Squashed IBM patches
> > > > > > >   - Fixed real issue in SMSC
> > > > > > >   - Added Andrew's Reviewed-by tags on remainder
> > > > > > 
> > > > > > Does not apply, please rebase on net-next/master.
> > > > > 
> > > > > These are based on Tuesday's next/master.
> > > > 
> > > > What's next/master?
> > > 
> > > I'm not sure if this is a joke, or not? :)
> > > 
> > > next/master == Linux Next.  The daily merged repo where all of the
> > > *-next branches end up to ensure interoperability.  It's also the
> > > branch that is most heavily tested by the auto-builders to ensure the
> > > vast majority of issues are ironed out before hitting Mainline.
> > > 
> > > > This is net-next:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
> > > 
> > > Looks like net-next gets merged into next/master:
> > > 
> > > commit 452958f1f3d1c8980a8414f9c37c8c6de24c7d32
> > > Merge: 1eabba209a17a f50e2f9f79164
> > > Author: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Date:   Thu Jan 14 10:35:40 2021 +1100
> > > 
> > >      Merge remote-tracking branch 'net-next/master'
> > > 
> > > So I'm not sure what it's conflicting with.
> > > 
> > > Do you have patches in net-next that didn't make it into next/master
> > > for some reason?
> > > 
> > > I'll try to rebase again tomorrow.
> > > 
> > > Hopefully I am able to reproduce your issue by then.
> > 
> > Okay so my development branch rebased again with no issue.
> 
> Rebasing is not same as patches application.
> 
> > 
> > I also took the liberty to checkout net-next and cherry-pick the
> > patches [0], which again didn't cause a problem.
> 
> Also normal, cherry-picking is not the same as applying a patch series.
> 
> > 
> > I'm not sure what else to suggest.  Is your local copy up-to-date?
> 
> I guess so, I have the same problem as Jakub, see below. I had to use 'git
> am -3' to apply you series. As you can see, git falls back to 3 way merge
> for patch 1, which means your series is close to but not fully in sync with
> net-next.
> 
> 
> [root@localhost linux-powerpc]# git remote -v
> net-next	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git (fetch)
> net-next	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git (push)
> 
> [root@localhost linux-powerpc]# git checkout net-next/master -b net-next
> Switched to a new branch 'net-next'
> 
> [root@localhost linux-powerpc]# git am /root/Downloads/Rid-W-1-warnings-in-Ethernet.patch
> Applying: net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
> error: patch failed: drivers/net/ethernet/smsc/smc91x.c:2192
> error: drivers/net/ethernet/smsc/smc91x.c: patch does not apply
> Patch failed at 0001 net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
> hint: Use 'git am --show-current-patch' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> [root@localhost linux-powerpc]# git am --abort
> 
> [root@localhost linux-powerpc]# git am -3 /root/Downloads/Rid-W-1-warnings-in-Ethernet.patch
> Applying: net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
> Using index info to reconstruct a base tree...
> M	drivers/net/ethernet/smsc/smc91x.c
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/ethernet/smsc/smc91x.c
> Applying: net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
> Applying: net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function header
> Applying: net: ethernet: ti: am65-cpts: Document am65_cpts_rx_enable()'s 'en' parameter
> Applying: net: ethernet: ibm: ibmvnic: Fix some kernel-doc misdemeanours
> Applying: net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc misdemeanours
> Applying: net: ethernet: toshiba: spider_net: Document a whole bunch of function parameters

Seeing as you went to all that effort, I thought it was only fair that
I did the same.  After some digging my tentative conclusion is that
Linux -next is up-to-date with net-next, but net-next is not
up-to-date with Linux -next.

I think this patch is conflicting:

 smc91x: remove GPIOLIB dependency.

Was that taken in via another tree?  If not resolved there is a chance
that this may cause a conflict when net-next is merged into Mainline.

..

Okay, so what would you like me to do?  Would you like me to re-submit
the set based only on net-next, or are you happy with your 3-way
merge?

I'll do as you ask.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
