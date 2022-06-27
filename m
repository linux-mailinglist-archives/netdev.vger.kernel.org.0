Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DB955DCFE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbiF0Iqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 04:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbiF0Iqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 04:46:35 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAA76355
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:46:33 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id q132so15498199ybg.10
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vsOnIc+C2gY1UVlbVz/JDciMvgYEap1WYGcSJm7nik=;
        b=izm5TvVaySgpwnEQF9/y67fAWYu9B2xhHcC5MrbsqfKRyBWcvUJOefttP3U8C7H5yK
         cf/c+G/MDFeL9d3jWR3ZM1W+uRZZqwp2hTAlphjRcQ4y5gzmknF6zrBjrzS5Oq9593TH
         prMhKu/+/nH//vvJzE+A8myFZw0Vf2YB5togDcAyh2pSj1lg7+NXGygkUac2Pq5BEBXO
         5+wwtXrzIkpK6w7dEXtmMbM9imlU0I4M6KLt1i3bZoyGQ30Vb87yxIZpNyIgjCBXAtgw
         DSd6AsFRpnuauM1qBq8q0T/kLZUm8tLjA1oB1Fx/TPENkDLwNudIWg8vpilEWofAkp3b
         qS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vsOnIc+C2gY1UVlbVz/JDciMvgYEap1WYGcSJm7nik=;
        b=tUDj6iQcQzQ/VA4jEytLu0uL4Mlb73aCpbQP001YnMtElL9gqgDXEMMwI30DTKumHX
         2mI5YWJJXt0YO5nBYvxQPv5ArJp4RNn3+XWF0shqPsbCtusVLR9RnLA0YBQB5Rf3BmGn
         IsUtMPFNkAOtoLMjMVXACCHNmHsfj5t2Q1pzA3NR+Cm9I10LQ+fdiyTZk6ME6aAXQPsj
         93LetWXhinYKSa90i9VGKdaIhuO0G/mf/nDGnU0pX62MvXhjA70zH2BFcWcQebVHQ/xu
         0l+/WE1jxrfmbgTMK5tCevIh0NBw5Py2F2IacSbGkYS21xWB0zHGTcAjZFopUEVf8dxT
         mW8Q==
X-Gm-Message-State: AJIora+7NIeM+R2lDb0FqrPht0EfEkLZjMl0KXScffakia1/FY6wuf96
        FlGsOpS9XQj1pykrwXfED84xJIPN5D+YAfxpYSkYbA==
X-Google-Smtp-Source: AGRyM1tmdR+Xbj5kJ69vq4foOyHTSytqN33Xz6MWmkpMcamFreKrameDkaAL4/75vWqZ0Cye+/NLca9lf7qZmNQ/HPM=
X-Received: by 2002:a25:6c5:0:b0:669:a17a:2289 with SMTP id
 188-20020a2506c5000000b00669a17a2289mr12352386ybg.231.1656319592797; Mon, 27
 Jun 2022 01:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220619150456.GB34471@xsang-OptiPlex-9020> <20220622172857.37db0d29@kernel.org>
 <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
 <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
 <20220623185730.25b88096@kernel.org> <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com> <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com> <20220627023812.GA29314@shbuild999.sh.intel.com>
In-Reply-To: <20220627023812.GA29314@shbuild999.sh.intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 10:46:21 +0200
Message-ID: <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
To:     Feng Tang <feng.tang@intel.com>
Cc:     Shakeel Butt <shakeelb@google.com>, Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        kernel test robot <oliver.sang@intel.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        linux-s390@vger.kernel.org, MPTCP Upstream <mptcp@lists.linux.dev>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        lkp@lists.01.org, kbuild test robot <lkp@intel.com>,
        Huang Ying <ying.huang@intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Yin Fengwei <fengwei.yin@intel.com>, Ying Xu <yinxu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 4:38 AM Feng Tang <feng.tang@intel.com> wrote:
>
> On Sat, Jun 25, 2022 at 10:36:42AM +0800, Feng Tang wrote:
> > On Fri, Jun 24, 2022 at 02:43:58PM +0000, Shakeel Butt wrote:
> > > On Fri, Jun 24, 2022 at 03:06:56PM +0800, Feng Tang wrote:
> > > > On Thu, Jun 23, 2022 at 11:34:15PM -0700, Shakeel Butt wrote:
> > > [...]
> > > > >
> > > > > Feng, can you please explain the memcg setup on these test machines
> > > > > and if the tests are run in root or non-root memcg?
> > > >
> > > > I don't know the exact setup, Philip/Oliver from 0Day can correct me.
> > > >
> > > > I logged into a test box which runs netperf test, and it seems to be
> > > > cgoup v1 and non-root memcg. The netperf tasks all sit in dir:
> > > > '/sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service'
> > > >
> > >
> > > Thanks Feng. Can you check the value of memory.kmem.tcp.max_usage_in_bytes
> > > in /sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service after making
> > > sure that the netperf test has already run?
> >
> > memory.kmem.tcp.max_usage_in_bytes:0
>
> Sorry, I made a mistake that in the original report from Oliver, it
> was 'cgroup v2' with a 'debian-11.1' rootfs.
>
> When you asked about cgroup info, I tried the job on another tbox, and
> the original 'job.yaml' didn't work, so I kept the 'netperf' test
> parameters and started a new job which somehow run with a 'debian-10.4'
> rootfs and acutally run with cgroup v1.
>
> And as you mentioned cgroup version does make a big difference, that
> with v1, the regression is reduced to 1% ~ 5% on different generations
> of test platforms. Eric mentioned they also got regression report,
> but much smaller one, maybe it's due to the cgroup version?

This was using the current net-next tree.
Used recipe was something like:

Make sure cgroup2 is mounted or mount it by mount -t cgroup2 none $MOUNT_POINT.
Enable memory controller by echo +memory > $MOUNT_POINT/cgroup.subtree_control.
Create a cgroup by mkdir $MOUNT_POINT/job.
Jump into that cgroup by echo $$ > $MOUNT_POINT/job/cgroup.procs.

<Launch tests>

The regression was smaller than 1%, so considered noise compared to
the benefits of the bug fix.

>
> Thanks,
> Feng
>
> > And here is more memcg stats (let me know if you want to check more)
> >
> > > If this is non-zero then network memory accounting is enabled and the
> > > slowdown is expected.
> >
> > >From the perf-profile data in original report, both
> > __sk_mem_raise_allocated() and __sk_mem_reduce_allocated() are called
> > much more often, which call memcg charge/uncharge functions.
> >
> > IIUC, the call chain is:
> >
> > __sk_mem_raise_allocated
> >     sk_memory_allocated_add
> >     mem_cgroup_charge_skmem
> >         charge memcg->tcpmem (for cgroup v2)
> >       try_charge memcg (for v1)
> >
> > Also from Eric's one earlier commit log:
> >
> > "
> > net: implement per-cpu reserves for memory_allocated
> > ...
> > This means we are going to call sk_memory_allocated_add()
> > and sk_memory_allocated_sub() more often.
> > ...
> > "
> >
> > So this slowdown is related to the more calling of charge/uncharge?
> >
> > Thanks,
> > Feng
> >
> > > > And the rootfs is a debian based rootfs
> > > >
> > > > Thanks,
> > > > Feng
> > > >
> > > >
> > > > > thanks,
> > > > > Shakeel
