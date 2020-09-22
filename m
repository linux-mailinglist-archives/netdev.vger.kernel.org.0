Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4EC273EBF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIVJoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgIVJoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:44:06 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCD4C0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:44:05 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id s205so13549281lja.7
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=guVVaBxnWrQ86fDPccANXl4ruP0cfa0fdBrEFJjzk2w=;
        b=HrhPC/cSVDNvm9kRZbwXzKjP6DTk7b2Nny0qurmlykw8pbZ55EM/YwnTphGw0Phb0i
         zLX5bT+td8tZrb0mEVN/5fL82j/z07O92s3jT9d8a3W4dm57qRVrcwJUKb/E954BVUFV
         TFAFWTS9f1YWrkJmJXHSfoOpeRSQND+w5H5Fjv8qHCsv7cOPHBTyoHb2k7c4eymMDFdn
         36bHMIDD9tsCIpE+KTz3b5R3eCf65PHRjGW/uP65gLuixUJGJ3T+62IcXjI47ThEu5eZ
         VV1igHblTySvW9p8oAXIc5QU5B9pDzu/21y96VHJGLYi8awC0gVsJZPlzCzJkQh6mF7V
         96iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=guVVaBxnWrQ86fDPccANXl4ruP0cfa0fdBrEFJjzk2w=;
        b=PQcJ4oVJitG5dL0gPTbj8bv6O86fRl/3elizVIUxcv0GhJEE8JWH6BZ8Cwpxur2BeA
         Qnc+v09YxoP8gXKXcluovWMiBaNd2k2qX1O2FPYZY2SHaUwssYQSpXVpqcrWOHyN+iX+
         TpMSeuo3vLjueb13nL8bReZlTacNl1zOCCsxlK8UskVCaArNXgHZRT2TR2FSfIBbu6Hm
         iiqGCCvga08qy+pYx66cUdYN933QNMXiuYIVc+fwqvuWi0C+b2PDWBfnK28NVflzhgW0
         OPdwzIw8+SsHXcmixW8ya4vpT7yUDB6u1buuZCZAqg2QFjx9gDEQL9/tj1jeUvMURg/b
         Nr1w==
X-Gm-Message-State: AOAM532RqnTUgATVVL4k/IVmdmZilhDEzK3CSk0K2q/B0AShU16CoMtj
        frJ9s2nVx9t+Ms8R1eTQBk10DTDXYyubijiwuoWa1Q==
X-Google-Smtp-Source: ABdhPJxXVnl7GUvUOwrcD+5qdd9k2lu/yskeXQOKLRd98NXH9jTfBpsWC5OGIMBrUFqa0KDjRh3xVSSaQ18LIv9nGbI=
X-Received: by 2002:a2e:b8d1:: with SMTP id s17mr1198265ljp.222.1600767843752;
 Tue, 22 Sep 2020 02:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz>
In-Reply-To: <20200921110505.GH12990@dhcp22.suse.cz>
From:   Chunxin Zang <zangchunxin@bytedance.com>
Date:   Tue, 22 Sep 2020 17:43:52 +0800
Message-ID: <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
To:     Michal Hocko <mhocko@suse.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 7:05 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 21-09-20 18:55:40, Yafang Shao wrote:
> > On Mon, Sep 21, 2020 at 4:12 PM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> > > > From: Chunxin Zang <zangchunxin@bytedance.com>
> > > >
> > > > In the cgroup v1, we have 'force_mepty' interface. This is very
> > > > useful for userspace to actively release memory. But the cgroup
> > > > v2 does not.
> > > >
> > > > This patch reuse cgroup v1's function, but have a new name for
> > > > the interface. Because I think 'drop_cache' may be is easier to
> > > > understand :)
> > >
> > > This should really explain a usecase. Global drop_caches is a terribl=
e
> > > interface and it has caused many problems in the past. People have
> > > learned to use it as a remedy to any problem they might see and cause
> > > other problems without realizing that. This is the reason why we even
> > > log each attempt to drop caches.
> > >
> > > I would rather not repeat the same mistake on the memcg level unless
> > > there is a very strong reason for it.
> > >
> >
> > I think we'd better add these comments above the function
> > mem_cgroup_force_empty() to explain why we don't want to expose this
> > interface in cgroup2, otherwise people will continue to send this
> > proposal without any strong reason.
>
> I do not mind people sending this proposal.  "V1 used to have an
> interface, we need it in v2 as well" is not really viable without
> providing more reasoning on the specific usecase.
>
> _Any_ patch should have a proper justification. This is nothing really
> new to the process and I am wondering why this is coming as a surprise.
>

I'm so sorry for that.
My usecase is that there are two types of services in one server. They
have difference
priorities. Type_A has the highest priority, we need to ensure it's
schedule latency=E3=80=81I/O
latency=E3=80=81memory enough. Type_B has the lowest priority, we expect it
will not affect
Type_A when executed.
So Type_A could use memory without any limit. Type_B could use memory
only when the
memory is absolutely sufficient. But we cannot estimate how much
memory Type_B should
use. Because everything is dynamic. So we can't set Type_B's memory.high.

So we want to release the memory of Type_B when global memory is
insufficient in order
to ensure the quality of service of Type_A . In the past, we used the
'force_empty' interface
of cgroup v1.

> --
> Michal Hocko
> SUSE Labs

Best wishes
Chunxin
