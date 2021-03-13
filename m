Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D55339AE7
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhCMBj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhCMBjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 20:39:35 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72365C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 17:39:35 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id bm21so56876350ejb.4
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 17:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYMAfB+kOe4zeCAszYYiCuALJVYTqLw/9u4411Ko01k=;
        b=wf9Gi0Io5qkPu58qPMReI3HwCjVj6r0koVMzd5oWOo1Z5hpmQzxUTR5//6qy54kLAw
         VFqmQDEkfgn0qbzRoOlrpkhTcV7StQqHz2muxQA9j7+qmdu7MiaWRrIYv+QJcx6isoGF
         3rm48xA1HtQAjI20ywUwdqDeSLRO92yrgopqsbyYNWDUES/KprguvSXSXxmBKU7DE3YA
         H79uzWMbGflIMGTTex8n3ec/inyGJSy3xDoWgaoZgZX1I81+DKZEZ5Wa6HUucCids6GO
         xyqi2fp1NNQx6Nf0E/UnSoT/Z3R8Jgnqo7gPVw20YJ/3j8Qvihyh+vrNmK62gI8c1BhC
         6jDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYMAfB+kOe4zeCAszYYiCuALJVYTqLw/9u4411Ko01k=;
        b=aU46whawRuJXsyRrys7EkmLr+1CzCng//emWnqvw3q/l3NFKAQpzo6IMrfjW3ZiAWL
         DlvZlJ0GxbaKrVAfumshV8vL0JdxaFSnDTOkuzcOm3qhmeVp86100Zt3Z84hTFIoX/Ex
         gXtVYvQDnUl/daDeVXAg4O5UpUoUtjBXoTm8YdakTt0S2pPYGRz+Z07K63ivNyB98Brq
         DFGUf3XHCkqnUWovM+Ihzgial0CSAX4ZoyxLUgwOPBaqpfINDu1CCRtTxcsvNkCADliO
         kQOkX3DvYDOsm1M0SSZQps6bhKuAzLJT8MbZqsM1x+ylyKRNiH2VolB0Qa/xa6MJUo7n
         PaVQ==
X-Gm-Message-State: AOAM533FoRWhdPmlv5tExefyPst/cK/CmYGx9H5W1hIdX8ldik0MyoH3
        C71CJ15RG7x8Q0Up7ikknQXQt5yESgjdT45x6BuM3P2b3Lc=
X-Google-Smtp-Source: ABdhPJzJeDb1ouRJsASyEeLC5udvioXQ+V47yzVNBS6/vXQ9/cvLyXkq9xd3tNlax1E1/SfGA5P13qcEDeHifh9Bmm8=
X-Received: by 2002:a17:906:2ac1:: with SMTP id m1mr1676438eje.472.1615599574174;
 Fri, 12 Mar 2021 17:39:34 -0800 (PST)
MIME-Version: 1.0
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <YEiLI8fGoa9DoCnF@kroah.com> <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
 <BYAPR11MB30950965A223EDE5414EAE08D96F9@BYAPR11MB3095.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB30950965A223EDE5414EAE08D96F9@BYAPR11MB3095.namprd11.prod.outlook.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 12 Mar 2021 17:39:22 -0800
Message-ID: <CAPcyv4htddEBB9ePPSheH+rO+=VJULeHzx0gc384if7qXTUHHg@mail.gmail.com>
Subject: Re: [PATCH v10 00/20] dlb: introduce DLB device driver
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 1:55 PM Chen, Mike Ximing
<mike.ximing.chen@intel.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Friday, March 12, 2021 2:18 AM
> > To: Greg KH <gregkh@linuxfoundation.org>
> > Cc: Chen, Mike Ximing <mike.ximing.chen@intel.com>; Netdev <netdev@vger.kernel.org>; David Miller
> > <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Arnd Bergmann <arnd@arndb.de>; Pierre-
> > Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > Subject: Re: [PATCH v10 00/20] dlb: introduce DLB device driver
> >
> > On Wed, Mar 10, 2021 at 1:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Feb 10, 2021 at 11:54:03AM -0600, Mike Ximing Chen wrote:
> > > > Intel DLB is an accelerator for the event-driven programming model of
> > > > DPDK's Event Device Library[2]. The library is used in packet processing
> > > > pipelines that arrange for multi-core scalability, dynamic load-balancing,
> > > > and variety of packet distribution and synchronization schemes
> > >
> > > The more that I look at this driver, the more I think this is a "run
> > > around" the networking stack.  Why are you all adding kernel code to
> > > support DPDK which is an out-of-kernel networking stack?  We can't
> > > support that at all.
> > >
> > > Why not just use the normal networking functionality instead of this
> > > custom char-device-node-monstrosity?
> >
> > Hey Greg,
> >
> > I've come to find out that this driver does not bypass kernel
> > networking, and the kernel functionality I thought it bypassed, IPC /
> > Scheduling, is not even in the picture in the non-accelerated case. So
> > given you and I are both confused by this submission that tells me
> > that the problem space needs to be clarified and assumptions need to
> > be enumerated.
> >
> > > What is missing from todays kernel networking code that requires this
> > > run-around?
> >
> > Yes, first and foremost Mike, what are the kernel infrastructure gaps
> > and pain points that led up to this proposal?
>
> Hi Greg/Dan,
>
> Sorry for the confusion. The cover letter and document did not articulate
> clearly the problem being solved by DLB. We will update the document in
> the next revision.

I'm not sure this answers Greg question about what is missing from
today's kernel implementation?

> In a brief description, Intel DLB is an accelerator that replaces shared memory
> queuing systems. Large modern server-class CPUs,  with local caches
> for each core, tend to incur costly cache misses, cross core snoops
> and contentions.  The impact becomes noticeable at high (messages/sec)
> rates, such as are seen in high throughput packet processing and HPC
> applications. DLB is used in high rate pipelines that require a variety of packet
> distribution & synchronization schemes.  It can be leveraged to accelerate
> user space libraries, such as DPDK eventdev. It could show similar benefits in
> frameworks such as PADATA in the Kernel - if the messaging rate is sufficiently
> high.

Where is PADATA limited by distribution and synchronization overhead?
It's meant for parallelizable work that has minimal communication
between the work units, ordering is about it's only synchronization
overhead, not messaging. It's used for ipsec crypto and page init.
Even potential future bulk work usages that might benefit from PADATA
like like md-raid, ksm, or kcopyd do not have any messaging overhead.

> As can be seen in the following diagram,  DLB operations come into the
> picture only after packets are received by Rx core from the networking
> devices. WCs are the worker cores which process packets distributed by DLB.
> (In case the diagram gets mis-formatted,  please see attached file).
>
>
>                               WC1              WC4
>  +-----+   +----+   +---+  /      \  +---+  /      \  +---+   +----+   +-----+
>  |NIC  |   |Rx  |   |DLB| /        \ |DLB| /        \ |DLB|   |Tx  |   |NIC  |
>  |Ports|---|Core|---|   |-----WC2----|   |-----WC5----|   |---|Core|---|Ports|
>  +-----+   -----+   +---+ \        / +---+ \        / +---+   +----+   ------+
>                            \      /         \      /
>                               WC3              WC6
>
> At its heart DLB consists of resources than can be assigned to
> VDEVs/applications in a flexible manner, such as ports, queues, credits to use
> queues, sequence numbers, etc.

All of those objects are managed in userspace today in the unaccelerated case?

> We support up to 16/32 VF/VDEVs (depending
> on version) with SRIOV and SIOV. Role of the kernel driver includes VDEV
> Composition (vdcm module), functional level reset, live migration, error
> handling, power management, and etc..

Need some more specificity here. What about those features requires
the kernel to get involved with a DLB2 specific ABI to manage ports,
queues, credits, sequence numbers, etc...?
