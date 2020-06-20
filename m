Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66622020A3
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387442AbgFTDby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733184AbgFTDb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:31:28 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F41C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:31:27 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p5so11156564ile.6
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9f0Gjamj3Kf1oQmhcAGPYQZVAknbqBPeTdhd79AObF4=;
        b=LrwN3if17HRccqgSMCdznchmJtkuCZNk9YjsewaXaa3YG6jV4MX7vPRzw8SMlbzkNK
         KLdWTHPqlWxbUMnhCq9YtY+b5r7OkKjpeDxcwY/YWzMCLl9dm2w0TjfhHB6LmPUkcsOK
         55tvuLllj3eYxNQMq8umuXh/I3lHUTNuHTdSn+E/PE6ZyqxsRfVPUD6XbulKFgyGlJmf
         wzq/89rwPXHL4pSaLNPpekSGrR8vW1Mg8qoRrgQcFmOfXnryG7qy5cKtVPB414viERdm
         SeBeWNyF1/pQwojLFbYvib0dA9Ss4I2+/RFgiR/txqKIdL3RyGsyZf1jhAx46yR3Dki+
         id2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9f0Gjamj3Kf1oQmhcAGPYQZVAknbqBPeTdhd79AObF4=;
        b=ODmGJmnCCDvGx6AmgXHbJtybzj9vZaq/alQWEVFrakqV5Vro+5CttXfaOkwtQP5wmS
         KUm6vaaEuVRaxtDTWnRa+G5mmQZ61sLl0FBim/8sPIPSDzzMi56IeytsAafJGnbgqCAb
         QUivD3QnBo1Xh1wpR4ty7FFJ8xEJZi2wgUXGybjwjn8Qr6qHs/yn7Ali+AgWXnCkj3Ix
         7uZCMBjcOjqyMZ77LKAdUETlaQ+uR02NBBju5f8ZT8S+TR54HKVfn5X4GpYu4hm9zUNy
         xMDq77k+khUOdR4RMXQovyP3c93vXHbLP82IO950Unwkj4TuYEJlLfIiKjp0s7jZY4Kv
         vFjQ==
X-Gm-Message-State: AOAM532CGGz9DVJzUSFGRW0M8SSTanCVljFMYHG+dBkdi9w8ysOZWKIH
        nAXSGGsFWs0qyDU/eT6yS7Kaa6GFPdulLn/eY5M=
X-Google-Smtp-Source: ABdhPJw0VEd+6UjULOyoyy9x/Gcw83ipj0YP9MBZR5Jt826uR+03JjOsFurKk38DZa2hnYy/0QyV45QpI8OjsKLVwEo=
X-Received: by 2002:a92:d905:: with SMTP id s5mr6696553iln.268.1592623887082;
 Fri, 19 Jun 2020 20:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com> <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com> <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com> <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com> <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
In-Reply-To: <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 19 Jun 2020 20:31:14 -0700
Message-ID: <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 5:51 PM Zefan Li <lizefan@huawei.com> wrote:
>
> =E5=9C=A8 2020/6/20 8:45, Zefan Li =E5=86=99=E9=81=93:
> > On 2020/6/20 3:51, Cong Wang wrote:
> >> On Thu, Jun 18, 2020 at 11:40 PM Zefan Li <lizefan@huawei.com> wrote:
> >>>
> >>> On 2020/6/19 5:09, Cong Wang wrote:
> >>>> On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
> >>>>>
> >>>>> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> >>>>>> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrot=
e:
> >>>>>>>
> >>>>>>> Cc: Roman Gushchin <guro@fb.com>
> >>>>>>>
> >>>>>>> Thanks for fixing this.
> >>>>>>>
> >>>>>>> On 2020/6/17 2:03, Cong Wang wrote:
> >>>>>>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> >>>>>>>> copied, so the cgroup refcnt must be taken too. And, unlike the
> >>>>>>>> sk_alloc() path, sock_update_netprioidx() is not called here.
> >>>>>>>> Therefore, it is safe and necessary to grab the cgroup refcnt
> >>>>>>>> even when cgroup_sk_alloc is disabled.
> >>>>>>>>
> >>>>>>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
> >>>>>>>> would terminate this function if called there. And for sk_alloc(=
)
> >>>>>>>> skcd->val is always zero. So it's safe to factor out the code
> >>>>>>>> to make it more readable.
> >>>>>>>>
> >>>>>>>> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory=
 leak of v2 cgroups")
> >>>>>>>
> >>>>>>> but I don't think the bug was introduced by this commit, because =
there
> >>>>>>> are already calls to cgroup_sk_alloc_disable() in write_priomap()=
 and
> >>>>>>> write_classid(), which can be triggered by writing to ifpriomap o=
r
> >>>>>>> classid in cgroupfs. This commit just made it much easier to happ=
en
> >>>>>>> with systemd invovled.
> >>>>>>>
> >>>>>>> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgr=
oup_bpf from cgroup itself"),
> >>>>>>> which added cgroup_bpf_get() in cgroup_sk_alloc().
> >>>>>>
> >>>>>> Good point.
> >>>>>>
> >>>>>> I take a deeper look, it looks like commit d979a39d7242e06
> >>>>>> is the one to blame, because it is the first commit that began to
> >>>>>> hold cgroup refcnt in cgroup_sk_alloc().
> >>>>>
> >>>>> I agree, ut seems that the issue is not related to bpf and probably
> >>>>> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> >>>>> seems closer to the origin.
> >>>>
> >>>> Yeah, I will update the Fixes tag and send V2.
> >>>>
> >>>
> >>> Commit d979a39d7242e06 looks innocent to me. With this commit when cg=
roup_sk_alloc
> >>> is disabled and then a socket is cloned the cgroup refcnt will not be=
 incremented,
> >>> but this is fine, because when the socket is to be freed:
> >>>
> >>>  sk_prot_free()
> >>>    cgroup_sk_free()
> >>>      cgroup_put(sock_cgroup_ptr(skcd)) =3D=3D cgroup_put(&cgrp_dfl_ro=
ot.cgrp)
> >>>
> >>> cgroup_put() does nothing for the default root cgroup, so nothing bad=
 will happen.
> >>
> >> But skcd->val can be a pointer to a non-root cgroup:
> >
> > It returns a non-root cgroup when cgroup_sk_alloc is not disabled. The =
bug happens
> > when cgroup_sk_alloc is disabled.
> >
>
> And please read those recent bug reports, they all happened when bpf cgro=
up was in use,
> and there was no bpf cgroup when d979a39d7242e06 was merged into mainline=
.

I am totally aware of this. My concern is whether cgroup
has the same refcnt bug as it always pairs with the bpf refcnt.

But, after a second look, the non-root cgroup refcnt is immediately
overwritten by sock_update_classid() or sock_update_netprioidx(),
which effectively turns into a root cgroup again. :-/

(It seems we leak a refcnt here, but this is not related to my patch).

Thanks.
