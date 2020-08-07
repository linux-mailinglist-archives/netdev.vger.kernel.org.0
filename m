Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64323E771
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 08:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHGGsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 02:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgHGGsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 02:48:35 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E810CC061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 23:48:34 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id h3so1015015oie.11
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 23:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lidziwKWteKe8xjBgcm1jFbK7UNF1RzTKEyUTC9xCeY=;
        b=JnZFLDjBCY2AwRy5U9XS6oV0GgzPxb6fJUEBYLnRiwcugjkdOFerC/oEJg/fc3r49l
         TdK4V9QBniORKc9q+v6rQpJrdOKyOUe+WVAEvLE4L/46f/RLznznjkMo5SmvFnqis1Cd
         0S5CNFzVexT926fEXFYV77AZxz+FbG0JOCIsnWqnf2xqww6P7ecQfSpLEPBXxTx5Ydwr
         X8UtOTI8itZn6vmhWGpTi3A2mf5YWcxbidWy8wfUmAHyKjVYNA0NOMxsQ1uUrXPOu5Bs
         ZDKBA9SmkO4neJbzxDRXzIJ2/naz3j/FMVPgKDeJZ5mXXwJcOAUXrjGeCTx9lR1WBReE
         bBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lidziwKWteKe8xjBgcm1jFbK7UNF1RzTKEyUTC9xCeY=;
        b=fAxhojoqP69+NTdEAUbZJ2mhA3+8Z7RjIVvFZFwgtPNMbw/BbvYnACR1KohxI6ji8N
         mldIlfSFbiAlhIORwnz40C7BG2aUiD8K/OrWaRgpEhTUBh50p/gQRUGFX/iaCtyyYK4A
         BJogc8BweMXArMQ4YYUeiME1hPbwra1RCMQSzxU1GWW0behW3jbF43KAy1uIG+HnlZHS
         bbeK7KLnxFyovQZRu7PzCuELOlSZh6ghES7e1Ib315RX9YSPA4Z/QvXk8dx1aOajYA5m
         KiUCO/F0o1wLva3oh35Gz9xLzVfcDcT6H01oAuubbnMd2G2dx6RCB3GltyCl6D8y6LlC
         684A==
X-Gm-Message-State: AOAM5305baf7iGJU7czrMieDrCuippIVwaCZmRDRtgnie4aaAnc+iLdV
        KOLKVRXFWIiS1blAqa+3nctieaTPcgnR+ptktx9vkQ==
X-Google-Smtp-Source: ABdhPJwtGBSAV2G+dGuwBXbakZR0UpILGS4bnS9TjkFG7bweYwPNCI1qp1/DSWmHu8BLrK8V+mAM3NUIAnh9uXJcCz4=
X-Received: by 2002:aca:b50b:: with SMTP id e11mr8599944oif.10.1596782914320;
 Thu, 06 Aug 2020 23:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200805.185559.1225246192723680518.davem@davemloft.net>
 <CANcMJZA1pSz8T9gkRtwYHy_vVfoMj35Wd-+qqxQBg+GRaXS0_Q@mail.gmail.com>
 <011a0a3b-74ac-fa61-2a04-73cb9897e8e8@gmail.com> <CALAqxLVDyTygzoktGK+aYnT2dQdOTPFAD=P=Kr1x+TmLuUC=NA@mail.gmail.com>
 <CALAqxLWKGfoPya3u9pbvZcbMAhjXKmYvp8b6L7hpk4bNWyt7sQ@mail.gmail.com>
In-Reply-To: <CALAqxLWKGfoPya3u9pbvZcbMAhjXKmYvp8b6L7hpk4bNWyt7sQ@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Thu, 6 Aug 2020 23:48:23 -0700
Message-ID: <CALAqxLU7a2ChS-jxpjH8=N8oah1ys+n1cZ_3jj_OYddCLw3y6A@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Todd Kjos <tkjos@google.com>,
        Amit Pundir <amit.pundir@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 11:23 PM John Stultz <john.stultz@linaro.org> wrote:
>
> On Thu, Aug 6, 2020 at 5:32 PM John Stultz <john.stultz@linaro.org> wrote:
> >
> > On Thu, Aug 6, 2020 at 4:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > On 8/6/20 2:39 PM, John Stultz wrote:
> > > > [   19.709492] Unable to handle kernel access to user memory outside
> > > > uaccess routines at virtual address 0000006f53337070
> > > > [   19.726539] Mem abort info:
> > > > [   19.726544]   ESR = 0x9600000f
> > > > [   19.741323]   EC = 0x25: DABT (current EL), IL = 32 bits
> > > > [   19.741326]   SET = 0, FnV = 0
> > > > [   19.761185]   EA = 0, S1PTW = 0
> > > > [   19.761188] Data abort info:
> > > > [   19.761190]   ISV = 0, ISS = 0x0000000f
> > > > [   19.761192]   CM = 0, WnR = 0
> > > > [   19.761199] user pgtable: 4k pages, 39-bit VAs, pgdp=000000016e9e9000
> > > > [   19.777584] [0000006f53337070] pgd=000000016e99e003,
> > > > p4d=000000016e99e003, pud=000000016e99e003, pmd=000000016e99a003,
> > > > pte=00e800016d3c7f53
> > > > [   19.789205] Internal error: Oops: 9600000f [#1] PREEMPT SMP
> > > > [   19.789211] Modules linked in:
> > > > [   19.797153] CPU: 7 PID: 364 Comm: iptables-restor Tainted: G
> > > > W         5.8.0-mainline-08255-gf9e74a8eb6f3 #3350
> > > > [   19.797156] Hardware name: Thundercomm Dragonboard 845c (DT)
> > > > [   19.797161] pstate: a0400005 (NzCv daif +PAN -UAO BTYPE=--)
> > > > [   19.797177] pc : do_ipt_set_ctl+0x304/0x610
> > > > [   19.807891] lr : do_ipt_set_ctl+0x50/0x610
> > > > [   19.807894] sp : ffffffc0139bbba0
> > > > [   19.807898] x29: ffffffc0139bbba0 x28: ffffff80f07a3800
> > > > [   19.846468] x27: 0000000000000000 x26: 0000000000000000
> > > > [   19.846472] x25: 0000000000000000 x24: 0000000000000698
> > > > [   19.846476] x23: ffffffec8eb0cc80 x22: 0000000000000040
> > > > [   19.846480] x21: b400006f53337070 x20: ffffffec8eb0c000
> > > > [   19.846484] x19: ffffffec8e9e9000 x18: 0000000000000000
> > > > [   19.846487] x17: 0000000000000000 x16: 0000000000000000
> > > > [   19.846491] x15: 0000000000000000 x14: 0000000000000000
> > > > [   19.846495] x13: 0000000000000000 x12: 0000000000000000
> > > > [   19.846501] x11: 0000000000000000 x10: 0000000000000000
> > > > [   19.856005] x9 : 0000000000000000 x8 : 0000000000000000
> > > > [   19.856008] x7 : ffffffec8e9e9d08 x6 : 0000000000000000
> > > > [   19.856012] x5 : 0000000000000000 x4 : 0000000000000213
> > > > [   19.856015] x3 : 00000001ffdeffef x2 : 11ded3fb0bb85e00
> > > > [   19.856019] x1 : 0000000000000027 x0 : 0000008000000000
> > > > [   19.856024] Call trace:
> > > > [   19.866319]  do_ipt_set_ctl+0x304/0x610
> > > > [   19.866327]  nf_setsockopt+0x64/0xa8
> > > > [   19.866332]  ip_setsockopt+0x21c/0x1710
> > > > [   19.866338]  raw_setsockopt+0x50/0x1b8
> > > > [   19.866347]  sock_common_setsockopt+0x50/0x68
> > > > [   19.882672]  __sys_setsockopt+0x120/0x1c8
> > > > [   19.882677]  __arm64_sys_setsockopt+0x30/0x40
> > > > [   19.882686]  el0_svc_common.constprop.3+0x78/0x188
> > > > [   19.882691]  do_el0_svc+0x80/0xa0
> > > > [   19.882699]  el0_sync_handler+0x134/0x1a0
> > > > [   19.901555]  el0_sync+0x140/0x180
> > > > [   19.901564] Code: aa1503e0 97fffd3e 2a0003f5 17ffff80 (a9401ea6)
> > > > [   19.901569] ---[ end trace 22010e9688ae248f ]---
> > > > [   19.913033] Kernel panic - not syncing: Fatal exception
> > > > [   19.913042] SMP: stopping secondary CPUs
> > > > [   20.138885] Kernel Offset: 0x2c7d080000 from 0xffffffc010000000
> > > > [   20.138887] PHYS_OFFSET: 0xfffffffa80000000
> > > > [   20.138894] CPU features: 0x0040002,2a80a218
> > > > [   20.138898] Memory Limit: none
> > > >
> > > > I'll continue to work on bisecting this down further, but figured I'd
> > > > share now as you or someone else might be able to tell whats wrong
> > > > from the trace.
> > > >
> > >
> > > Can you try at commit c2f12630c60ff33a9cafd221646053fc10ec59b6 ("netfilter: switch nf_setsockopt to sockptr_t")
> > > (and right before it)
> >
> >
> > So I rebased my patches ontop of that commit, but I'm not seeing the
> > crash there.  I also hand applied your suggested patch when I did see
> > the issue, but that didn't seem to fix it either.
> >
> > So far I've only narrowed it down to between
> > 65ccbbda52288527b7c48087eb33bb0757975875..530fe9d433b9e60251bb8fdc5dddecbc486a50ef.
> > But I'll keep rebase-bisecting it down.
>
> So I've finally rebase-bisected it down to:
>   a31edb2059ed ("net: improve the user pointer check in init_user_sockptr")
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a31edb2059ed4e498f9aa8230c734b59d0ad797a
>
> And reverting that from linus/HEAD (at least from this morning) seems
> to avoid it.
>
> Seems like it is just adding extra checks on the data passed, so maybe
> existing trouble from a different driver is the issue here, but it's
> not really clear from the crash what might be wrong.
>
> Suggestions would be greatly appreciated!

And while I'm back to being able to boot with the above reverted, wifi
is seemingly not connecting properly. I can associate and get an IP
but I can't ping the gateway. And I get similar behavior with ethernet
as well. So maybe firewall related? Not sure if it's connected to the
crash above or just a separate issue. I'll try to bisect that down
tomorrow.

thanks
-john
