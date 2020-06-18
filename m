Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7621FFD2D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgFRVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgFRVJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:09:56 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36ABC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 14:09:55 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a13so7370392ilh.3
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 14:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2+sF2f7zdvzBync83jDF2uelVm2rI0OyJxDb0ykk28E=;
        b=epjlMjJe5vvF0C84VAw5UmzYHIVkslPFFjsNnaRsNkminhubcIpMAFH8jsZHycUwBV
         UgkR8KJ2A0BjDAUZoeypYgL+Gt9s4BIbSkkCKYI7Ww/S1rImmscRBsLatreXgQfRUQ7+
         TJyeNi1iCK8ICE4DMVmBHnF0U85bJfAZKjBer0WAVz44qsdFDU1/QY+4qpaSG2V2oqdw
         sLjbkGKiuwcPDaV2OHWQLoPDDlpoVyP+6d5OWE8y514RDnJg2Ha0QdvILOLLp0GMxf8D
         7SEsrAv6B8PVAC/F0hvLme7AeR2vyvxh0qb7nvGZqk9HYJ7lYlWdG0GLzD7XksIQ2BW8
         613Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2+sF2f7zdvzBync83jDF2uelVm2rI0OyJxDb0ykk28E=;
        b=Xd0a1Kyx63/wHU+P+Jcaez4q3z1kW25Mf9qImhW17bk9q6U9gb5p6zZlLsT5GPg4PY
         3383poITzVAaIUyC+F4J7IsSh3hKCEUVNV4clPU0un9W+qB11Pf2koNV3U/ei5+Lt2Yy
         2ZDEJ4hTVhVCwFIa7Si8gHAJQ+tSKAYaNph2wBMHB+wjDgNuirPovlzJiFxUBzq0M8uC
         GPme18+pdR1Bi6jTTXWiceqigq+Oft3E/w6Q8W4kqm7vnIXBRS/YHoEhWkjsBI9vZPj7
         JtU0rIgMStRyAaLynHNwHjgGTenzzaBr2kGuGi3/mx2SUAVBnuq4zFmYq11xmhwQM04u
         jEQQ==
X-Gm-Message-State: AOAM531iACXOEOK+8a24MnLyLyLxd99a7wbDApHhV2gMc6T4HW1RvTdh
        /A/d29WS6D5b92TzWWh6Tfg+nsp3Uj6m6x9wBkQ=
X-Google-Smtp-Source: ABdhPJwK9pArfVGylu8rJcNC7s4L0Nv1UbrjgyMz0N9/0NYuOMF5pNubI70XRZDpDdI/Vr8Tzugr5rkd1BaAcjUBTPs=
X-Received: by 2002:a92:5b15:: with SMTP id p21mr470606ilb.22.1592514595265;
 Thu, 18 Jun 2020 14:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com> <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
In-Reply-To: <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 18 Jun 2020 14:09:43 -0700
Message-ID: <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>
Cc:     Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> > On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> > >
> > > Cc: Roman Gushchin <guro@fb.com>
> > >
> > > Thanks for fixing this.
> > >
> > > On 2020/6/17 2:03, Cong Wang wrote:
> > > > When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> > > > copied, so the cgroup refcnt must be taken too. And, unlike the
> > > > sk_alloc() path, sock_update_netprioidx() is not called here.
> > > > Therefore, it is safe and necessary to grab the cgroup refcnt
> > > > even when cgroup_sk_alloc is disabled.
> > > >
> > > > sk_clone_lock() is in BH context anyway, the in_interrupt()
> > > > would terminate this function if called there. And for sk_alloc()
> > > > skcd->val is always zero. So it's safe to factor out the code
> > > > to make it more readable.
> > > >
> > > > Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> > >
> > > but I don't think the bug was introduced by this commit, because there
> > > are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> > > write_classid(), which can be triggered by writing to ifpriomap or
> > > classid in cgroupfs. This commit just made it much easier to happen
> > > with systemd invovled.
> > >
> > > I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> > > which added cgroup_bpf_get() in cgroup_sk_alloc().
> >
> > Good point.
> >
> > I take a deeper look, it looks like commit d979a39d7242e06
> > is the one to blame, because it is the first commit that began to
> > hold cgroup refcnt in cgroup_sk_alloc().
>
> I agree, ut seems that the issue is not related to bpf and probably
> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> seems closer to the origin.

Yeah, I will update the Fixes tag and send V2.

>
> Btw, based on the number of reported-by tags it seems that there was
> a real issue which the patch is fixing. Maybe you'll a couple of words
> about how it reveals itself in the real life?

I still have no idea how exactly this is triggered. According to the
people who reported this bug, they just need to wait for some hours
to trigger. So I am not sure what to add here, just the stack trace?

Thanks.
