Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E9A33867A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhCLHS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhCLHSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:18:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15C3C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 23:18:36 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id j3so6511738edp.11
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 23:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhkXsUQwFJd4p3wwdmUDZNeScmbDWk4gsHyLcLAcyoM=;
        b=ZrzKxjcrENP077JVJEWGhRapjHUhd5tZB7+ckUx1VtKpPNPLf6Lb0ak/FQpoBTaHXy
         ZuQrUh/O9Fhk8tewzuwW7y40Lun0RaTH5leRVWVtYpvkMere22VF3AfOXsOoyN06Sxeo
         BsLydCLRKyqcEsac0RxJ2OLbrpNYu4eFYeT3AlDpeaHIAylPU7O3FVoHaKTtYqJvlV5x
         BmxPnob62CTxXak9AkDh44TDqeax+d5bdD4uM5KzZh4c/6WiB7nczQsr6+KgNCbB4aR3
         tlJWJ83Nq3lFDB8ECfH8AIMAeSRPmEVEjKej0C1ka5T2tQSYcbFRAbkyTOdf0VDR6jqq
         Qvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhkXsUQwFJd4p3wwdmUDZNeScmbDWk4gsHyLcLAcyoM=;
        b=jgjzGJj2azsgHuLIBwKEkGhCMsF6F+QeyNA+ejCYDgcRMrpuCJqliqrr3Rtqzs+SKA
         E8898W5xyUSEIKhtG0sW73NJYAGCtt8tPby6Sxot3pZfuRo2Fmpkr5KEPPJS1uanjxQn
         /d3JDzhQbI31tUfskS9uZ8KJOjzRQSnPYHjg3X0zkmHS7x8YLWKwiOXm1wQBU4m68KoI
         8hkRLpC6zglQOiPnyHIW+apSFLHtImYlK6f2F+ShKdmD9bQwRq83+8snjsAegI/Jk5Vy
         yfrG6aIq3baEyjOAZZfFRvOWmGYCbM6unAwgUez0vgML3UEilovaiEukvFPnzSP/EbC4
         VaEQ==
X-Gm-Message-State: AOAM531iSpYiPCUyXqL25Hf+5otGrmbUr91t0ETyZTdJYkmKrKHwXcQN
        4LlAK8ZmVDITyF1p0hdqixQMR4Jwcv/Q2IWlZlIvLg==
X-Google-Smtp-Source: ABdhPJyhpJYTJh1dw23psGNFB+CW8y3E3icZVfuXFO0A5Pk9pUSq1cqWAVpO3UBir7tMPsmcG2Mf/+Vf849IG5Ueo9Q=
X-Received: by 2002:aa7:d156:: with SMTP id r22mr12827445edo.18.1615533515509;
 Thu, 11 Mar 2021 23:18:35 -0800 (PST)
MIME-Version: 1.0
References: <20210210175423.1873-1-mike.ximing.chen@intel.com> <YEiLI8fGoa9DoCnF@kroah.com>
In-Reply-To: <YEiLI8fGoa9DoCnF@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 11 Mar 2021 23:18:24 -0800
Message-ID: <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
Subject: Re: [PATCH v10 00/20] dlb: introduce DLB device driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Mike Ximing Chen <mike.ximing.chen@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 1:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Feb 10, 2021 at 11:54:03AM -0600, Mike Ximing Chen wrote:
> > Intel DLB is an accelerator for the event-driven programming model of
> > DPDK's Event Device Library[2]. The library is used in packet processing
> > pipelines that arrange for multi-core scalability, dynamic load-balancing,
> > and variety of packet distribution and synchronization schemes
>
> The more that I look at this driver, the more I think this is a "run
> around" the networking stack.  Why are you all adding kernel code to
> support DPDK which is an out-of-kernel networking stack?  We can't
> support that at all.
>
> Why not just use the normal networking functionality instead of this
> custom char-device-node-monstrosity?

Hey Greg,

I've come to find out that this driver does not bypass kernel
networking, and the kernel functionality I thought it bypassed, IPC /
Scheduling, is not even in the picture in the non-accelerated case. So
given you and I are both confused by this submission that tells me
that the problem space needs to be clarified and assumptions need to
be enumerated.

> What is missing from todays kernel networking code that requires this
> run-around?

Yes, first and foremost Mike, what are the kernel infrastructure gaps
and pain points that led up to this proposal?
