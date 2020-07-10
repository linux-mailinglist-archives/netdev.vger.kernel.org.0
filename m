Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506D821BB3A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGJQm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgGJQm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:42:28 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB23C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 09:42:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ch3so2847208pjb.5
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aqAKN03VF0q+aAs2MXwlG2ySMnIcQGX92mFyYVLBpcg=;
        b=NWTjGzn21rPJuWuPUTeS4o9Lee6iEOcYq6ex3bRJSLDRe8ozOw/66QiYUWa1WYGKzR
         gUu+G3PTECiJpzGA2AIJeDIKUvLrkUo8/uylZLRRI3zYt8+bT5j0fAnS5P0cB1WALJt3
         e74+OAovk6swgHs6AxpvoUKMehYTSEaKNGjKW5MW+CbfUp4Nv2qmgPtlRc2J2SNxIbVy
         NGH5l6vs1N9kF8gAaBAe7Dpg0bjdKgZCl39r4HJGoFjgyHQ8CmxztS8zGUikflTL0SwC
         JUCoht1Uut9OvgsfU8bHzCSXNn+cD4HVGAj1DBLMSqmfKB/2X54A6THCy5+fFPLUAciI
         U2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=aqAKN03VF0q+aAs2MXwlG2ySMnIcQGX92mFyYVLBpcg=;
        b=aqFclxhSix6C95sI2vla3YEcRPCGjAlPfZlPAZ8aF7QdnykSB2CCBH6KSd5EHhlaq3
         h6zCnzF45okenhrzs6Dwi4JDLMcAKtCiJYms611Hu+K+FfX+IOH6edpiy5rKyNOi6r8L
         5IH8jPRC3qSRse35NlX62KAnXqmnCiZQV/maQaadsGjwYDGvxmUmfer5LeJeDIzewX0y
         NdVFRjR3gUx+kRY+KutRSe3R2enUBnoUiK1b7gIrZITwReIXLsoH793BbmCGyA3LI2x5
         ooZRbl3nuL1r98HzjS6Vo5uIh8PVb8VDE62oD9X2wb5HxDbonZK4QnVHNXJ8u7yNGkIl
         gXEQ==
X-Gm-Message-State: AOAM530Q8R84L7UfuyKGWy8xeVD8xQdN114xNeT3SNlO7rMRHX7jHq0e
        fbSjBZGGQmq87N17Eq/zVIY=
X-Google-Smtp-Source: ABdhPJymECoxzk6sUPjfDg2UTVsk6azOm0XXqN6Mnfm17UW4Hslw23EpFf8FwUZB9bTUSz+XGsTPrQ==
X-Received: by 2002:a17:90b:4910:: with SMTP id kr16mr6621175pjb.126.1594399348159;
        Fri, 10 Jul 2020 09:42:28 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 190sm6292154pfz.41.2020.07.10.09.42.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 Jul 2020 09:42:26 -0700 (PDT)
Date:   Fri, 10 Jul 2020 09:42:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Message-ID: <20200710164224.GA179556@roeck-us.net>
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
 <20200708153327.GA193647@roeck-us.net>
 <CAM_iQpWLcbALSZDNkiCm7zKOjMZV8z1XnC5D0vyiYPC6rU3v8A@mail.gmail.com>
 <fe638e54-be0e-d729-a20f-878d017d0da7@roeck-us.net>
 <CAM_iQpWWXmrNzNZc5-N=bXo2_o58V0=3SeFkPzmJaDL3TVUeEA@mail.gmail.com>
 <38f6a432-fadf-54a6-27d0-39d205fba92e@roeck-us.net>
 <CAM_iQpVk=54omCG8rrDn7GDg9KxKATT4fufRHbn=BSDKWyTu7w@mail.gmail.com>
 <CAM_iQpWaWcJYG_JWkHdy__=Y5NYPFaX2T+W-c6MskYoZ8G7rRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWaWcJYG_JWkHdy__=Y5NYPFaX2T+W-c6MskYoZ8G7rRQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:59:09AM -0700, Cong Wang wrote:
> On Thu, Jul 9, 2020 at 11:51 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Jul 9, 2020 at 10:10 AM Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > Something seems fishy with the use of skcd->val on big endian systems.
> > >
> > > Some debug output:
> > >
> > > [   22.643703] sock: ##### sk_alloc(sk=000000001be28100): Calling cgroup_sk_alloc(000000001be28550)
> > > [   22.643807] cgroup: ##### cgroup_sk_alloc(skcd=000000001be28550): cgroup_sk_alloc_disabled=0, in_interrupt: 0
> > > [   22.643886] cgroup:  #### cgroup_sk_alloc(skcd=000000001be28550): cset->dfl_cgrp=0000000001224040, skcd->val=0x1224040
> > > [   22.643957] cgroup: ###### cgroup_bpf_get(cgrp=0000000001224040)
> > > [   22.646451] sock: ##### sk_prot_free(sk=000000001be28100): Calling cgroup_sk_free(000000001be28550)
> > > [   22.646607] cgroup:  #### sock_cgroup_ptr(skcd=000000001be28550) -> 0000000000014040 [v=14040, skcd->val=14040]
> > > [   22.646632] cgroup: ####### cgroup_sk_free(): skcd=000000001be28550, cgrp=0000000000014040
> > > [   22.646739] cgroup: ####### cgroup_sk_free(): skcd->no_refcnt=0
> > > [   22.646814] cgroup: ####### cgroup_sk_free(): Calling cgroup_bpf_put(cgrp=0000000000014040)
> > > [   22.646886] cgroup: ###### cgroup_bpf_put(cgrp=0000000000014040)
> >
> > Excellent debugging! I thought it was a double put, but it seems to
> > be an endian issue. I didn't realize the bit endian machine actually
> > packs bitfields in a big endian way too...
> >
> > Does the attached patch address this?
> 
> Ah, this is too ugly. We just have to always make them the last two bits.
> 
> Please test this attached patch instead and ignore the previous one.
> 

Sorry, that one came too late; I was already about to leave when I got the first
one. It looks correct, though. I'll be back Monday night and will have another
look then (and I guess my builders will pick it up after Dave sends it all to
Linus). I'll let you know if I still see a problem.

Thanks,
Guenter
