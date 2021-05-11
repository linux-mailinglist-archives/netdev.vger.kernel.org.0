Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421F537B0C9
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhEKVbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhEKVbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 17:31:17 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E768C061574;
        Tue, 11 May 2021 14:30:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cl24-20020a17090af698b0290157efd14899so2132285pjb.2;
        Tue, 11 May 2021 14:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Efmg9vR8a9TAGQ+WatkLG/30mVXC6cbsqkFflWx9JGQ=;
        b=LbrLoAqdvK5dt7y0f1Zd7E1LC/8H4CHzePq0vgaJ6y/1rfSP36wd7XjZxOZDu07QwY
         tnLQ+t6XeIcyPX+rCGADd5W58gHLqydFN95HGfOqBz9yke2OHDxI2mh2Weq7JjNvCK2P
         wYDL36NbuXH190YPPo/orAl2ufs8BbB8t7fUVDGlYG83RyBHyQul5NSTGFX5jLadwhmh
         cjuWZs+LNO8IawlMkoUCFQEGu0+Q/JyOM2rWRiq/Jm6KErrdOw2x/WY7zxafCLCAcFxt
         M9QQ2UR7TJJGIh8QFJ2qDGkL7+psmloBrz+EzN2uDoZCSaYPgiYpFcrkIOFXoiEXK9iG
         r0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Efmg9vR8a9TAGQ+WatkLG/30mVXC6cbsqkFflWx9JGQ=;
        b=btG0WWFbifbC3ao+AJvEi2HTvKm+0mgWDJW2N7kXjF9zGRYw+AztG4lpZpF7RFLSha
         My+n5RUsKhshPAx9mT8SWosx6ncz2Koo1NvitwiIwGLfBls02IrMk4b33JFAQFC5hGbT
         UFtV8b9EC/kKsVkG5uDmACdQ/+136Ovovm+x1Nh/WHDRjXUFlFLr6Abgi2aCMqegn3iP
         dm8Cl0NnYtsHTXVRpA44N9Tu6MCtzHuVPKuHFHryaEJPkUYHnjG0quY0eXykz33VmMzZ
         qiwYxd1YNk3yaRiIer2NK32ySrWLQyVkTDxEgcqYXwkWEPMjoIRltl/SX0rG7JKEZUyc
         V94A==
X-Gm-Message-State: AOAM532MyWn5e7dVSRGzd9kMJUONpM6djQGD93d2ZigJ58Sk+bkDRW+b
        YRY4BrXD6V8s6TMDv+2Z1fO1WyJi/yhsjuQPG9k=
X-Google-Smtp-Source: ABdhPJyuV6I8EIWEdby1gfGtA+JaBZoHxFW0Ii4vxske2bGr2HaBUw1tZXfh+i9HKf2wHPWBN3AiMclKE8mXnydP9uc=
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr3260419pjb.56.1620768609846;
 Tue, 11 May 2021 14:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
 <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
 <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com> <d38c7ccf-bc66-9b71-ef96-7fe196ac5c09@mojatatu.com>
In-Reply-To: <d38c7ccf-bc66-9b71-ef96-7fe196ac5c09@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 11 May 2021 14:29:58 -0700
Message-ID: <CAM_iQpXLcpga=DF+ateBk1jiiCx2mPJW=WHT+j3JrS8kuPS4Zw@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
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
        Joe Stringer <joe@cilium.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 1:55 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-05-09 1:37 a.m., Cong Wang wrote:
> > On Tue, Apr 27, 2021 at 11:34 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
>
>
> [..]
> > I am pretty sure I showed the original report to you when I sent
> > timeout hashmap patch, in case you forgot here it is again:
> > https://github.com/cilium/cilium/issues/5048
> >
> > and let me quote the original report here:
> >
> > "The current implementation (as of v1.2) for managing the contents of
> > the datapath connection tracking map leaves something to be desired:
> > Once per minute, the userspace cilium-agent makes a series of calls to
> > the bpf() syscall to fetch all of the entries in the map to determine
> > whether they should be deleted. For each entry in the map, 2-3 calls
> > must be made: One to fetch the next key, one to fetch the value, and
> > perhaps one to delete the entry. The maximum size of the map is 1
> > million entries, and if the current count approaches this size then
> > the garbage collection goroutine may spend a significant number of CPU
> > cycles iterating and deleting elements from the conntrack map."
> >
>
> That cilium PR was a good read of the general issues.
> Our use case involves anywhere between 4-16M cached entries.
>
> Like i mentioned earlier:
> we want to periodically, if some condition is met in the
> kernel on a map entry, to cleanup, update or send unsolicited
> housekeeping events to user space.
> Polling in order to achieve this for that many entries is expensive.

Thanks for sharing your use case. As we discussed privately, please
also share the performance numbers you have.

I talked to my colleagues at Bytedance yesterday, we actually have
similar code which periodically collects map entry stats too, currently
we use iterator from user-space, which definitely has the same CPU
overhead.


>
> I would argue, again, timers generally are useful for a variety
> of house keeping purposes and they are currently missing from ebpf.
> Again, this despite Cong's use case.
> Currently things in the ebpf datapath are triggered by either packets
> showing up or from a control plane perspective by user space polling.
> We need the timers for completion.
>

Thanks!
