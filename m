Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE44201BA5
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390720AbgFSTvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390635AbgFSTvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:51:12 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A081CC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:51:12 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id z2so10431880ilq.0
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dSdXND58mEzevvqVYu0Hz0nSoYO4xJPew9/O3z6jKUU=;
        b=TM7q18J9OpoC+IMIFJyOjoPaKC9KRhA9Jtkcjz1iONA9Ouno9U30zt0s8dv0PdhYHk
         3Ewz6E1fnTFm7afhjLLjSNgQMoPWDfXj1sJDxE0fF2dFJoNSVMXc4NCc9+5gZt5enbuS
         9Bp21sFqctG01cQ82tLLVXoDee8LQsQ1+vIxc9VoJPA/J8STSZzw4dbxsF56EEa5zXlv
         eN1uMQOJmbKaYB33ywt4WUYsz3sqiX8Wd0g8hI/e9MYhT5pWT5kLw1tg3KZJSsRezBaO
         zXXkk2+SdLOz5R8vMHzVeIOne76i8GI0TpatZsVLm9wTyWYjts3oSv2062pcOYJesFNe
         Os3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dSdXND58mEzevvqVYu0Hz0nSoYO4xJPew9/O3z6jKUU=;
        b=Gr3iEqE4U0M3vecrXMkksSj2u7OOV+SFKbYOljyr+EjRqOfNd3dnjTK4CI2RETInQb
         ZiOfmde/yO5JDuOfvV3geZn44n4fjA+Ou5O+q6WN1L7MrIWmP4gwyzdeiNxPlft1Q3rI
         cwZA2qszth0FznBC682JD12Ul9oP71Bop2+MypkSST4lo7tlaNV3lirdtzF5UG4nmlZR
         MgkjOp6ESTqLCQJiO1+ljqfQjC62juNmZ5wwWJ/eg9AfOLzBXB+7B+K35y7z14BBpmlS
         Y0UyzVJPZGMxXaJ6b5W3RK2T1JzBn9+K9JPEGr/ACW4c4ITEL4+Pk0XaXZjMKRbQGl0Y
         1LBw==
X-Gm-Message-State: AOAM533zuGb4LJ7ziAe5OTGnqEp2zCtnR0yrJVYPU4DNQ/gxr+VMaDml
        AbwUUM8AiawqVe8SgF2r1BWH6HmA2+v31rMo96kOTopw
X-Google-Smtp-Source: ABdhPJwUcpEi7LdHUnOpZ1/yQlfCRf6ow8t2JlEtQ5aQbz9tLa8i/mhdIUTuioUKF01dk5pEb4eoG9sHwPVNXKt4EjY=
X-Received: by 2002:a92:db44:: with SMTP id w4mr5069251ilq.305.1592596271769;
 Fri, 19 Jun 2020 12:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com> <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com> <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
In-Reply-To: <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 19 Jun 2020 12:51:00 -0700
Message-ID: <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Zefan Li <lizefan@huawei.com>
Cc:     Roman Gushchin <guro@fb.com>,
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

On Thu, Jun 18, 2020 at 11:40 PM Zefan Li <lizefan@huawei.com> wrote:
>
> On 2020/6/19 5:09, Cong Wang wrote:
> > On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
> >>
> >> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> >>> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> >>>>
> >>>> Cc: Roman Gushchin <guro@fb.com>
> >>>>
> >>>> Thanks for fixing this.
> >>>>
> >>>> On 2020/6/17 2:03, Cong Wang wrote:
> >>>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> >>>>> copied, so the cgroup refcnt must be taken too. And, unlike the
> >>>>> sk_alloc() path, sock_update_netprioidx() is not called here.
> >>>>> Therefore, it is safe and necessary to grab the cgroup refcnt
> >>>>> even when cgroup_sk_alloc is disabled.
> >>>>>
> >>>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
> >>>>> would terminate this function if called there. And for sk_alloc()
> >>>>> skcd->val is always zero. So it's safe to factor out the code
> >>>>> to make it more readable.
> >>>>>
> >>>>> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> >>>>
> >>>> but I don't think the bug was introduced by this commit, because there
> >>>> are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> >>>> write_classid(), which can be triggered by writing to ifpriomap or
> >>>> classid in cgroupfs. This commit just made it much easier to happen
> >>>> with systemd invovled.
> >>>>
> >>>> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> >>>> which added cgroup_bpf_get() in cgroup_sk_alloc().
> >>>
> >>> Good point.
> >>>
> >>> I take a deeper look, it looks like commit d979a39d7242e06
> >>> is the one to blame, because it is the first commit that began to
> >>> hold cgroup refcnt in cgroup_sk_alloc().
> >>
> >> I agree, ut seems that the issue is not related to bpf and probably
> >> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> >> seems closer to the origin.
> >
> > Yeah, I will update the Fixes tag and send V2.
> >
>
> Commit d979a39d7242e06 looks innocent to me. With this commit when cgroup_sk_alloc
> is disabled and then a socket is cloned the cgroup refcnt will not be incremented,
> but this is fine, because when the socket is to be freed:
>
>  sk_prot_free()
>    cgroup_sk_free()
>      cgroup_put(sock_cgroup_ptr(skcd)) == cgroup_put(&cgrp_dfl_root.cgrp)
>
> cgroup_put() does nothing for the default root cgroup, so nothing bad will happen.

But skcd->val can be a pointer to a non-root cgroup:

static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
{
#if defined(CONFIG_CGROUP_NET_PRIO) || defined(CONFIG_CGROUP_NET_CLASSID)
        unsigned long v;

        /*
         * @skcd->val is 64bit but the following is safe on 32bit too as we
         * just need the lower ulong to be written and read atomically.
         */
        v = READ_ONCE(skcd->val);

        if (v & 1)
                return &cgrp_dfl_root.cgrp;

        return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
#else
        return (struct cgroup *)(unsigned long)skcd->val;
#endif
}
