Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E021F32F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGNNzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgGNNzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:55:41 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A87C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:55:41 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t15so1548408pjq.5
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4R6aAP2hnHU5BomscdB2+QQtEfcfOo7mlJFUbwCE+FA=;
        b=A9bHkLfo4H2ZVElBgw57VyHwEEw+XfzOp3NNrx1mZwtzgzQBHfUNcprjm4OZdvZwtd
         SjZ10FmvfuB08Eudp0GDzzyqSf4//56rWuh9i4XlDTcCUJ94d0QwU3QAa6GYNFA7my5+
         uWgcjmtLEekCoiE7VQGer4/E5RCLcAIWUm62w0cRumWUthXcJYX29dcQRBJ5BXhv5ID4
         uJYfEjNSiJRhKXAWhXxMXvCdxVItP+0OhjFWJ2xaqotUNeF8z/8VXyj3i/KujHyuXZ3Z
         NXX45ISe+240UUYewPc5ACGhoERmzE5b5iA3N1mcR/I2WwgGly74ZDp5gqjNCF59DfNh
         vvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4R6aAP2hnHU5BomscdB2+QQtEfcfOo7mlJFUbwCE+FA=;
        b=MlW1ejR7wW4x6VuEnHh8B74KrefkETbFlxnoABMX46ZaRCv6QU2PpEc4JoH60/lX9C
         kOHeEDaYX853FAwX81YXG3VIvZy2v8lMPQiEK32nwZewYCl7bV8EpFjOlYTxLZHDzAWg
         IgrMr0225Vv6I9vy8igShUOq32spbVGVQ6FO/BAKbtXFwg8H53N4cvueowEkoM3MAJgS
         AW6sv2kZD8XXQXNrHkUqHsCdRh14Cry8ZTSSVBwjMgu+jGCrBFxTPkZUuSg9CdqDbvTv
         eqFy68cD0etL8oqnyA48pBdWSdkV3FzekUaM1cwly6ZosTenanWPMip0Lc/hG02tjqrY
         7ekA==
X-Gm-Message-State: AOAM533oWvu0oAxmOknBksSEOwZwZsITuUUnlE+wP475aFPAWlRzGPUj
        7D0eX00pDqdu+fD2GftfZoE=
X-Google-Smtp-Source: ABdhPJx2IXeXRE4rtv64EDOZf3FZZeAjczPZCUCXwxWrLa2CHbZRcwdlI3GU0WWMtjTrjjdcDE8ztg==
X-Received: by 2002:a17:90a:de8d:: with SMTP id n13mr4536985pjv.95.1594734940896;
        Tue, 14 Jul 2020 06:55:40 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ga7sm2652322pjb.50.2020.07.14.06.55.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 06:55:39 -0700 (PDT)
Date:   Tue, 14 Jul 2020 06:55:38 -0700
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
Message-ID: <20200714135538.GA56663@roeck-us.net>
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
FWIW: Tested and working.

Guenter
