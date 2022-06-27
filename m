Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0590555E222
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiF0OIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 10:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236744AbiF0OIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 10:08:09 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F0A11450
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 07:08:07 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v38so6227262ybi.3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 07:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sjw8Rq/SzvseVodDwQxp2+Q31Mr0tWQ4MKXsdJlU2cg=;
        b=FNybrAKvk56tbmhGsNSol/sAk2WPCD9f/EnbfNGtYtTRxuDjK5KtlipdfEkdZ15GfR
         2ZVGGTdXYE8JCJ73vYP045eGq1ZtgwuqKnC0ysZD0ffk/M8eLDDCoTK1+7MXH1UF8v/h
         OmIFdtZQE8XN4VDlxAbc8cd3FHUJNWruSpWTHLSObfVxTcKInOj0mpwlSAwvhmGxXebU
         htw640mczpUob+epPmy+ZAgZAg+JzC04mGFtVp1P15GuAjDL9Th+UMRsWwSWJZoe9+Qs
         Q+mBhAat4RLw+HLV2uKp/c2ZKyCFZSW8QC8lGFgH/kagAIAnnCPkRitYGr0ZKOhtxwRN
         x7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sjw8Rq/SzvseVodDwQxp2+Q31Mr0tWQ4MKXsdJlU2cg=;
        b=LsMOq5nd+pnj8ecLAk6bH2qCBb96tDEGYFOEyfgbi92WOJaidofNv/cBiwV4K25stp
         Qq4zhTPwym/n6F9D+toeFxmB7Fur+TfSEJr7d+iXgRGyyvpehj2f6fmthiEdcI5794dU
         Nx0kLMIXyq7QaRhzIeg8h0Ag6Iw7C8hH+5vsqLX8+CxsCjLGg1L5JpMjgRg+HwhREbID
         UEbjsxXFkv+wr3xNQhhXhgDMlVnDfDF0hR4qD44REct+Ie6IdMw+Cm1H3H2zxBAGGx5F
         seGnLP+ArbKCVymimvRu/sEBpARYStYCL3PaZLgnZqUuObWkXRqw3t+f5J2r6SIQiZaU
         XL2Q==
X-Gm-Message-State: AJIora9lIvGqWQrD5xCSRVeud8S6FR2oObqEgBgDv9K2lbXP3ayXg8Qe
        2RyfLJIvYUHhQfzDWGfh+B+nAOfjDpu6fBH+obi4xw==
X-Google-Smtp-Source: AGRyM1uowX5w9MG4KUhH5mzYPs/nJYOessQKIWZ2T27hbR78LZ0upAkQZTZYPIlSVQsuDxp8yWRUmqzbJ4KyVb5DKSc=
X-Received: by 2002:a25:d957:0:b0:66c:9476:708f with SMTP id
 q84-20020a25d957000000b0066c9476708fmr10600680ybg.427.1656338886354; Mon, 27
 Jun 2022 07:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
 <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
 <20220623185730.25b88096@kernel.org> <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com> <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com> <20220627023812.GA29314@shbuild999.sh.intel.com>
 <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com> <20220627123415.GA32052@shbuild999.sh.intel.com>
In-Reply-To: <20220627123415.GA32052@shbuild999.sh.intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 16:07:55 +0200
Message-ID: <CANn89iJAoYCebNbXpNMXRoDUkFMhg9QagetVU9NZUq+GnLMgqQ@mail.gmail.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 2:34 PM Feng Tang <feng.tang@intel.com> wrote:
>
> On Mon, Jun 27, 2022 at 10:46:21AM +0200, Eric Dumazet wrote:
> > On Mon, Jun 27, 2022 at 4:38 AM Feng Tang <feng.tang@intel.com> wrote:
> [snip]
> > > > >
> > > > > Thanks Feng. Can you check the value of memory.kmem.tcp.max_usage_in_bytes
> > > > > in /sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service after making
> > > > > sure that the netperf test has already run?
> > > >
> > > > memory.kmem.tcp.max_usage_in_bytes:0
> > >
> > > Sorry, I made a mistake that in the original report from Oliver, it
> > > was 'cgroup v2' with a 'debian-11.1' rootfs.
> > >
> > > When you asked about cgroup info, I tried the job on another tbox, and
> > > the original 'job.yaml' didn't work, so I kept the 'netperf' test
> > > parameters and started a new job which somehow run with a 'debian-10.4'
> > > rootfs and acutally run with cgroup v1.
> > >
> > > And as you mentioned cgroup version does make a big difference, that
> > > with v1, the regression is reduced to 1% ~ 5% on different generations
> > > of test platforms. Eric mentioned they also got regression report,
> > > but much smaller one, maybe it's due to the cgroup version?
> >
> > This was using the current net-next tree.
> > Used recipe was something like:
> >
> > Make sure cgroup2 is mounted or mount it by mount -t cgroup2 none $MOUNT_POINT.
> > Enable memory controller by echo +memory > $MOUNT_POINT/cgroup.subtree_control.
> > Create a cgroup by mkdir $MOUNT_POINT/job.
> > Jump into that cgroup by echo $$ > $MOUNT_POINT/job/cgroup.procs.
> >
> > <Launch tests>
> >
> > The regression was smaller than 1%, so considered noise compared to
> > the benefits of the bug fix.
>
> Yes, 1% is just around noise level for a microbenchmark.
>
> I went check the original test data of Oliver's report, the tests was
> run 6 rounds and the performance data is pretty stable (0Day's report
> will show any std deviation bigger than 2%)
>
> The test platform is a 4 sockets 72C/144T machine, and I run the
> same job (nr_tasks = 25% * nr_cpus) on one CascadeLake AP (4 nodes)
> and one Icelake 2 sockets platform, and saw 75% and 53% regresson on
> them.
>
> In the first email, there is a file named 'reproduce', it shows the
> basic test process:
>
> "
>   use 'performane' cpufre  governor for all CPUs
>
>   netserver -4 -D
>   modprobe sctp
>   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
>   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
>   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
>   (repeat 36 times in total)
>   ...
>
> "
>
> Which starts 36 (25% of nr_cpus) netperf clients. And the clients number
> also matters, I tried to increase the client number from 36 to 72(50%),
> and the regression is changed from 69.4% to 73.7%"
>

This seems like a lot of opportunities for memcg folks :)

struct page_counter has poor field placement [1], and no per-cpu cache.

[1] "atomic_long_t usage" is sharing cache line with read mostly fields.

(struct mem_cgroup also has poor field placement, mainly because of
struct page_counter)

    28.69%  [kernel]       [k] copy_user_enhanced_fast_string
    16.13%  [kernel]       [k] intel_idle_irq
     6.46%  [kernel]       [k] page_counter_try_charge
     6.20%  [kernel]       [k] __sk_mem_reduce_allocated
     5.68%  [kernel]       [k] try_charge_memcg
     5.16%  [kernel]       [k] page_counter_cancel



> Thanks,
> Feng
>
> > >
> > > Thanks,
> > > Feng
