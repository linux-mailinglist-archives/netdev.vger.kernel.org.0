Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4CD36BD14
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhD0CCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbhD0CCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 22:02:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE72C061574;
        Mon, 26 Apr 2021 19:02:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gq23-20020a17090b1057b0290151869af68bso6259722pjb.4;
        Mon, 26 Apr 2021 19:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tbj9VKgVn6Bk4ORNiBYwvlVORz9AgJEtk02rBGpSXq0=;
        b=C1r6ovIfavI2g/TCNgHOM+JGeChWgb/QnZhBY3CvVRLCANF0jZpnCVllNDiOqoe4eO
         RHnsEy91ZX1udA0A8wkMmwwoy3ciQfz+tSMyqIyiClGaKB8dLvQ392zX2rK7uVq0Sb0j
         sSIaZmPkeq8k5EsyyD1OsFXCXUOspP6+alCCpjI58OPXn3mvT8DUuvsbkVJaCxhiXtNN
         hz0a/IaXN9sjGc1StXW/7WEag10oT3dundo3/blZwmf3OsLwAMw1OocJTVBGzqkEdhwg
         sWWJmr8XX2tIv6oqlLaNJGoXYTAatWyFH7SbUH1d9stBfJ8D8W/V+DME9qXTS8xw+J2S
         bTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tbj9VKgVn6Bk4ORNiBYwvlVORz9AgJEtk02rBGpSXq0=;
        b=ChUOsuvJCnrQZwzdLysyN4AcRiB2Yb8S7kINUz4LRluS22gb4sV326wCCYQ0p046fN
         R5skNfrpzyB42+FfdN/kKszCcbZW0vFCbiCPz47ScqH6xLN7+osCxZdMlL2w1jniTuEG
         ly48pmcYiTosF1BTlZLdYgcz00eobhxi1sM/TsXutT6RQ6CTn2cC4wjXJX5A/fnhVqir
         kI8VJQX2b4i4KOWHUOEGLS5JKVF876QZua6EfMuztuJMauXW+Nne7COl3MpQmQ9TJvU8
         yS0oatAxXIOdo6vikRs8z0uZ22lS56Z35MC5blnWpTv6Ieky1mSrWU3NG5+v2vv0sDCQ
         QjqQ==
X-Gm-Message-State: AOAM531c38aW3BIXs6TvNTelH2v5ShT5VVXHZT0ezK9qX4yOS6ZjrLFz
        d7r3sfSPUO+ffGVATgvdBhA=
X-Google-Smtp-Source: ABdhPJy2C4Gr3ACDAf/4sEH3KZ51qDv9lXN6X5ZUB7aaC5DdWxz3o7FApQ5HkEHcz87mw1mIVzvXSQ==
X-Received: by 2002:a17:902:d706:b029:e6:90aa:24e0 with SMTP id w6-20020a170902d706b02900e690aa24e0mr21952513ply.42.1619488923403;
        Mon, 26 Apr 2021 19:02:03 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ad0])
        by smtp.gmail.com with ESMTPSA id g14sm546883pjh.28.2021.04.26.19.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 19:02:02 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:01:59 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
Message-ID: <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp>
 <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp>
 <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 04:37:19PM -0700, Cong Wang wrote:
> On Mon, Apr 26, 2021 at 4:05 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Apr 26, 2021 at 4:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > Hi, Alexei
> > >
> > > On Wed, Apr 14, 2021 at 9:25 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Apr 14, 2021 at 9:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > Then how do you prevent prog being unloaded when the timer callback
> > > > > is still active?
> > > >
> > > > As I said earlier:
> > > > "
> > > > If prog refers such hmap as above during prog free the kernel does
> > > > for_each_map_elem {if (elem->opaque) del_timer().}
> > > > "
> > >
> > > I have discussed this with my colleagues, sharing timers among different
> > > eBPF programs is a must-have feature for conntrack.
> > >
> > > For conntrack, we need to attach two eBPF programs, one on egress and
> > > one on ingress. They share a conntrack table (an eBPF map), and no matter
> > > we use a per-map or per-entry timer, updating the timer(s) could happen
> > > on both sides, hence timers must be shared for both.
> > >
> > > So, your proposal we discussed does not work well for this scenario.
> >
> > why? The timer inside the map element will be shared just fine.
> > Just like different progs can see the same map value.
> 
> Hmm? In the above quotes from you, you suggested removing all the
> timers installed by one eBPF program when it is freed, but they could be
> still running independent of which program installs them.

Right. That was before the office hours chat where we discussed an approach
to remove timers installed by this particular prog only.
The timers armed by other progs in the same map would be preserved.

> In other words, timers are independent of other eBPF programs, so
> they should not have an owner. With your proposal, the owner of a timer
> is the program which contains the subprog (or callback) of the timer.

right. so?
How is this anything to do with "sharing timers among different eBPF programs"?

> >
> > Also if your colleagues have something to share they should be
> > posting to the mailing list. Right now you're acting as a broken phone
> > passing info back and forth and the knowledge gets lost.
> > Please ask your colleagues to participate online.
> 
> They are already in CC from the very beginning. And our use case is
> public, it is Cilium conntrack:
> https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack.h
> 
> The entries of the code are:
> https://github.com/cilium/cilium/blob/master/bpf/bpf_lxc.c
> 
> The maps for conntrack are:
> https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack_map.h

If that's the only goal then kernel timers are not needed.
cilium conntrack works well as-is.
