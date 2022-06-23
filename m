Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0D75571B1
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiFWEjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiFWDJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 23:09:13 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580CB23177;
        Wed, 22 Jun 2022 20:09:09 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id l81so23674005oif.9;
        Wed, 22 Jun 2022 20:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PNpsXUruLK6qlPU9267V4w5h505vOp/Sv56NBzUUbzs=;
        b=edBqqVJzS/2Tr66Chm55WKVPRDXZa6tl2DqSPL/arlElHDsMVT/UklIZWNt1pK6nld
         SNy+58bnPgr8dOXW1pu1Ni7WMlwhn9b32fi2v5hXaYrlaTk5dCDNCOsc8CCFk4nT3Ivo
         S4a/McmCcZh98wsinmrvOBgr7nwzREJBN4C4KcKROctyHeJFPp/Nrs1fIqFg4mOs41Ce
         0yAAXptRPdz+wXqILeTkYfA7cMMPGqTHmJfmwWm2fBe+r+jxXI9drqboZOwAVqshYlIb
         WpvVeuPa4bVdEBOHFnnSwwZwAIfVo2815b8O+Is+kYnebFsl7onD0zYA7HAlg6bTgYgA
         DLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PNpsXUruLK6qlPU9267V4w5h505vOp/Sv56NBzUUbzs=;
        b=gwOb7ik15NdATwms7V1haZOdORHZxDdRLN28Zhf69kzCK+JmWaAvLWCMbp3/rr8Srr
         HxheXzjC2u7bjjpc3EnEhEgQrYMmYJqsWM9Kd7dCV6cEIeKiqlXkTP94hpOuenO4Oc2S
         WbKdP8F9Bi0wRq84jNH61LnL7Ri6g2+VHJwTQnCumynEiAtKT1yR+9w4XZwdDMZ8XglL
         eMReypX2W3DSNvKWHVYCNfXjIWJORIVqCDB3+7jTGlYKc+x4YxXEOZNYh+UAqP4dcccq
         32ElyQ1myVq+A3ppcVwhDvdtxwU/C4JRJb7FNYjpgKJGaly3+G31oVy8kmMwCAUKttlU
         dHuQ==
X-Gm-Message-State: AJIora9Q+ZH8wugtdyjDklzMQCimxfhzuamM0j2sB3MTTgn+Uz4Fpfx7
        DSOO3qT9zBMFCoKWhdaJ9q73Xgn2dad8t/YVGlI=
X-Google-Smtp-Source: AGRyM1vJBFF5c/0AAIw85aj0cKbxOg7H4lzepMmgbLieJfx5MFiVGU171o2t1ooLs4U7lvKxDMRurHMhG5rS30/PqhE=
X-Received: by 2002:a05:6808:179a:b0:32f:fd4:3ad6 with SMTP id
 bg26-20020a056808179a00b0032f0fd43ad6mr958412oib.190.1655953748183; Wed, 22
 Jun 2022 20:09:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220619150456.GB34471@xsang-OptiPlex-9020> <20220622172857.37db0d29@kernel.org>
In-Reply-To: <20220622172857.37db0d29@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 22 Jun 2022 23:08:40 -0400
Message-ID: <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        kernel test robot <oliver.sang@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        network dev <netdev@vger.kernel.org>,
        linux-s390@vger.kernel.org, mptcp@lists.linux.dev,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        lkp@lists.01.org, kbuild test robot <lkp@intel.com>,
        Huang Ying <ying.huang@intel.com>, feng.tang@intel.com,
        zhengjun.xing@linux.intel.com, fengwei.yin@intel.com,
        Ying Xu <yinxu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I'm working on it. I couldn't see the regression in my env with
the 'reproduce' script attached.
I will try with lkp tomorrow.

Thanks.

On Wed, Jun 22, 2022 at 8:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Could someone working on SCTP double check this is a real regression?
> Feels like the regression reports are flowing at such rate its hard
> to keep up.
>
> On Sun, 19 Jun 2022 23:04:56 +0800 kernel test robot wrote:
> > Greeting,
> >
> > FYI, we noticed a -69.4% regression of netperf.Throughput_Mbps due to c=
ommit:
> >
> >
> > commit: 4890b686f4088c90432149bd6de567e621266fa2 ("net: keep sk->sk_for=
ward_alloc as small as possible")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> >
> > in testcase: netperf
> > on test machine: 144 threads 4 sockets Intel(R) Xeon(R) Gold 5318H CPU =
@ 2.50GHz with 128G memory
> > with following parameters:
> >
> >       ip: ipv4
> >       runtime: 300s
> >       nr_threads: 25%
> >       cluster: cs-localhost
> >       send_size: 10K
> >       test: SCTP_STREAM_MANY
> >       cpufreq_governor: performance
> >       ucode: 0x7002402
> >
> > test-description: Netperf is a benchmark that can be use to measure var=
ious aspect of networking performance.
> > test-url: http://www.netperf.org/netperf/
> >
> > In addition to that, the commit also has significant impact on the foll=
owing tests:
> >
> > +------------------+---------------------------------------------------=
-------------------------------+
> > | testcase: change | netperf: netperf.Throughput_Mbps -73.7% regression=
                               |
> > | test machine     | 144 threads 4 sockets Intel(R) Xeon(R) Gold 5318H =
CPU @ 2.50GHz with 128G memory |
> > | test parameters  | cluster=3Dcs-localhost                            =
                                 |
> > |                  | cpufreq_governor=3Dperformance                    =
                                 |
> > |                  | ip=3Dipv4                                         =
                                 |
> > |                  | nr_threads=3D50%                                  =
                                 |
> > |                  | runtime=3D300s                                    =
                                 |
> > |                  | send_size=3D10K                                   =
                                 |
> > |                  | test=3DSCTP_STREAM_MANY                           =
                                 |
> > |                  | ucode=3D0x7002402                                 =
                                 |
> > +------------------+---------------------------------------------------=
-------------------------------+
> >
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> >
> >
> > Details are as below:
> > -----------------------------------------------------------------------=
--------------------------->
> >
> >
> > To reproduce:
> >
> >         git clone https://github.com/intel/lkp-tests.git
> >         cd lkp-tests
> >         sudo bin/lkp install job.yaml           # job file is attached =
in this email
> >         bin/lkp split-job --compatible job.yaml # generate the yaml fil=
e for lkp run
> >         sudo bin/lkp run generated-yaml-file
> >
> >         # if come across any failure that blocks the test,
> >         # please remove ~/.lkp and /lkp dir to run from a clean state.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/=
send_size/tbox_group/test/testcase/ucode:
> >   cs-localhost/gcc-11/performance/ipv4/x86_64-rhel-8.3/25%/debian-11.1-=
x86_64-20220510.cgz/300s/10K/lkp-cpl-4sp1/SCTP_STREAM_MANY/netperf/0x700240=
2
> >
> > commit:
> >   7c80b038d2 ("net: fix sk_wmem_schedule() and sk_rmem_schedule() error=
s")
> >   4890b686f4 ("net: keep sk->sk_forward_alloc as small as possible")
> >
> > 7c80b038d23e1f4c 4890b686f4088c90432149bd6de
> > ---------------- ---------------------------
> >          %stddev     %change         %stddev
> >              \          |                \
> >      15855           -69.4%       4854        netperf.Throughput_Mbps
> >     570788           -69.4%     174773        netperf.Throughput_total_=
Mbps
> >      30543           -59.1%      12480 =C2=B1  3%  netperf.time.involun=
tary_context_switches
> >      16661 =C2=B1  2%     -20.1%      13317 =C2=B1  2%  netperf.time.mi=
nor_page_faults
> >       2076           -58.1%     869.17 =C2=B1  2%  netperf.time.percent=
_of_cpu_this_job_got
> >       6118           -57.8%       2583 =C2=B1  2%  netperf.time.system_=
time
> >     143.71 =C2=B1  6%     -72.3%      39.77        netperf.time.user_ti=
me
> >      87371 =C2=B1  8%     +81.1%     158253        netperf.time.volunta=
ry_context_switches
> >   2.09e+09           -69.4%    6.4e+08        netperf.workload
> >      36264           +18.2%      42849        uptime.idle
> >  3.058e+10           +22.0%  3.731e+10        cpuidle..time
> >  6.536e+08           -60.7%  2.566e+08        cpuidle..usage
> >     127819 =C2=B1 79%     -82.3%      22609 =C2=B1 65%  numa-meminfo.no=
de3.Inactive
> >     127764 =C2=B1 79%     -82.4%      22440 =C2=B1 66%  numa-meminfo.no=
de3.Inactive(anon)
> >      71.38           +14.7       86.09        mpstat.cpu.all.idle%
> >       4.84            -2.1        2.78 =C2=B1  2%  mpstat.cpu.all.soft%
> >      22.32           -12.1       10.25 =C2=B1  2%  mpstat.cpu.all.sys%
> >       0.78 =C2=B1  3%      -0.5        0.25        mpstat.cpu.all.usr%
> >      71.00           +20.9%      85.83        vmstat.cpu.id
> >    4121749           -23.6%    3150424        vmstat.memory.cache
> >      43.00 =C2=B1  2%     -55.0%      19.33 =C2=B1  2%  vmstat.procs.r
> >    3921783           -69.4%    1200263        vmstat.system.cs
> >     292198            -1.3%     288478        vmstat.system.in
> >  6.908e+08 =C2=B1  3%     -70.1%  2.064e+08 =C2=B1  9%  numa-numastat.n=
ode0.local_node
> >  6.907e+08 =C2=B1  3%     -70.1%  2.065e+08 =C2=B1  9%  numa-numastat.n=
ode0.numa_hit
> >  6.517e+08 =C2=B1  2%     -65.5%  2.246e+08 =C2=B1 10%  numa-numastat.n=
ode1.local_node
> >  6.519e+08 =C2=B1  2%     -65.5%  2.247e+08 =C2=B1 10%  numa-numastat.n=
ode1.numa_hit
> >   6.81e+08 =C2=B1  3%     -72.1%  1.902e+08 =C2=B1  8%  numa-numastat.n=
ode2.local_node
> >  6.811e+08 =C2=B1  3%     -72.0%  1.905e+08 =C2=B1  8%  numa-numastat.n=
ode2.numa_hit
> >  6.819e+08 =C2=B1  3%     -69.9%   2.05e+08 =C2=B1  6%  numa-numastat.n=
ode3.local_node
> >  6.823e+08 =C2=B1  3%     -69.9%  2.051e+08 =C2=B1  6%  numa-numastat.n=
ode3.numa_hit
> >  6.907e+08 =C2=B1  3%     -70.1%  2.065e+08 =C2=B1  9%  numa-vmstat.nod=
e0.numa_hit
> >  6.908e+08 =C2=B1  3%     -70.1%  2.064e+08 =C2=B1  9%  numa-vmstat.nod=
e0.numa_local
> >  6.519e+08 =C2=B1  2%     -65.5%  2.247e+08 =C2=B1 10%  numa-vmstat.nod=
e1.numa_hit
> >  6.517e+08 =C2=B1  2%     -65.5%  2.246e+08 =C2=B1 10%  numa-vmstat.nod=
e1.numa_local
> >  6.811e+08 =C2=B1  3%     -72.0%  1.905e+08 =C2=B1  8%  numa-vmstat.nod=
e2.numa_hit
> >   6.81e+08 =C2=B1  3%     -72.1%  1.902e+08 =C2=B1  8%  numa-vmstat.nod=
e2.numa_local
> >      31948 =C2=B1 79%     -82.4%       5622 =C2=B1 66%  numa-vmstat.nod=
e3.nr_inactive_anon
> >      31948 =C2=B1 79%     -82.4%       5622 =C2=B1 66%  numa-vmstat.nod=
e3.nr_zone_inactive_anon
> >  6.823e+08 =C2=B1  3%     -69.9%  2.051e+08 =C2=B1  6%  numa-vmstat.nod=
e3.numa_hit
> >  6.819e+08 =C2=B1  3%     -69.9%   2.05e+08 =C2=B1  6%  numa-vmstat.nod=
e3.numa_local
> >    1216292 =C2=B1  5%     -70.1%     363637 =C2=B1  4%  meminfo.Active
> >    1215873 =C2=B1  5%     -70.1%     363097 =C2=B1  4%  meminfo.Active(=
anon)
> >    3994598           -24.3%    3022264        meminfo.Cached
> >    1878317 =C2=B1  4%     -53.7%     870428        meminfo.Committed_AS
> >     431272 =C2=B1  8%     -28.0%     310461        meminfo.Inactive
> >     428860 =C2=B1  9%     -28.4%     306912        meminfo.Inactive(ano=
n)
> >     668273 =C2=B1  5%     -71.3%     192010 =C2=B1  4%  meminfo.Mapped
> >    5793516           -17.1%    4802753        meminfo.Memused
> >       8320 =C2=B1  2%     -12.1%       7309 =C2=B1  2%  meminfo.PageTab=
les
> >    1341918 =C2=B1  6%     -72.5%     368590 =C2=B1  4%  meminfo.Shmem
> >    9796929           -25.1%    7337138        meminfo.max_used_kB
> >       1029           -51.6%     498.17 =C2=B1  2%  turbostat.Avg_MHz
> >      31.32           -16.2       15.17 =C2=B1  2%  turbostat.Busy%
> >  5.953e+08           -69.1%  1.837e+08 =C2=B1  2%  turbostat.C1
> >       9.22            -5.2        4.04 =C2=B1  4%  turbostat.C1%
> >      68.58           +23.5%      84.67        turbostat.CPU%c1
> >      57.67           -16.8%      48.00 =C2=B1  3%  turbostat.CoreTmp
> >       0.23 =C2=B1  2%     -31.4%       0.16        turbostat.IPC
> >      18.59 =C2=B1 30%     -18.6        0.00        turbostat.PKG_%
> >    4524200 =C2=B1  6%     -81.5%     835280        turbostat.POLL
> >       0.10 =C2=B1  3%      -0.1        0.02 =C2=B1 17%  turbostat.POLL%
> >      57.33           -16.6%      47.83 =C2=B1  4%  turbostat.PkgTmp
> >     561.39           -25.9%     416.03        turbostat.PkgWatt
> >       7.75            +6.8%       8.27        turbostat.RAMWatt
> >     303881 =C2=B1  5%     -70.2%      90609 =C2=B1  4%  proc-vmstat.nr_=
active_anon
> >     998594           -24.4%     755404        proc-vmstat.nr_file_pages
> >     107254 =C2=B1  9%     -28.4%      76741        proc-vmstat.nr_inact=
ive_anon
> >     167104 =C2=B1  5%     -71.0%      48414 =C2=B1  4%  proc-vmstat.nr_=
mapped
> >       2081 =C2=B1  2%     -12.1%       1828 =C2=B1  2%  proc-vmstat.nr_=
page_table_pages
> >     335422 =C2=B1  6%     -72.6%      91983 =C2=B1  4%  proc-vmstat.nr_=
shmem
> >      32561            -1.7%      31994        proc-vmstat.nr_slab_recla=
imable
> >     303881 =C2=B1  5%     -70.2%      90609 =C2=B1  4%  proc-vmstat.nr_=
zone_active_anon
> >     107254 =C2=B1  9%     -28.4%      76741        proc-vmstat.nr_zone_=
inactive_anon
> >     267554 =C2=B1 15%     -25.4%     199518 =C2=B1 10%  proc-vmstat.num=
a_hint_faults
> >      82267 =C2=B1 20%     -27.2%      59929 =C2=B1 13%  proc-vmstat.num=
a_hint_faults_local
> >  2.706e+09           -69.5%  8.266e+08        proc-vmstat.numa_hit
> >  2.705e+09           -69.5%  8.262e+08        proc-vmstat.numa_local
> >     489361 =C2=B1  9%     -19.4%     394229 =C2=B1  6%  proc-vmstat.num=
a_pte_updates
> >     510140 =C2=B1 18%     -75.3%     125829 =C2=B1  2%  proc-vmstat.pga=
ctivate
> >   7.17e+09           -69.4%  2.197e+09        proc-vmstat.pgalloc_norma=
l
> >    1636476 =C2=B1  2%     -11.5%    1448944        proc-vmstat.pgfault
> >   7.17e+09           -69.4%  2.197e+09        proc-vmstat.pgfree
> >      30967 =C2=B1 41%     -88.7%       3488 =C2=B1 30%  sched_debug.cfs=
_rq:/.MIN_vruntime.avg
> >    1604384 =C2=B1 22%     -83.6%     262510 =C2=B1 14%  sched_debug.cfs=
_rq:/.MIN_vruntime.max
> >     201146 =C2=B1 30%     -86.1%      28034 =C2=B1 18%  sched_debug.cfs=
_rq:/.MIN_vruntime.stddev
> >       0.29 =C2=B1  8%     -43.5%       0.16 =C2=B1  9%  sched_debug.cfs=
_rq:/.h_nr_running.avg
> >       0.42 =C2=B1  3%     -15.1%       0.36 =C2=B1  3%  sched_debug.cfs=
_rq:/.h_nr_running.stddev
> >      30967 =C2=B1 41%     -88.7%       3488 =C2=B1 30%  sched_debug.cfs=
_rq:/.max_vruntime.avg
> >    1604384 =C2=B1 22%     -83.6%     262510 =C2=B1 14%  sched_debug.cfs=
_rq:/.max_vruntime.max
> >     201146 =C2=B1 30%     -86.1%      28034 =C2=B1 18%  sched_debug.cfs=
_rq:/.max_vruntime.stddev
> >    1526268 =C2=B1 11%     -80.6%     295647 =C2=B1 10%  sched_debug.cfs=
_rq:/.min_vruntime.avg
> >    2336190 =C2=B1 12%     -79.4%     482042 =C2=B1  7%  sched_debug.cfs=
_rq:/.min_vruntime.max
> >     859659 =C2=B1 11%     -85.8%     121714 =C2=B1 18%  sched_debug.cfs=
_rq:/.min_vruntime.min
> >     343902 =C2=B1 15%     -78.7%      73263 =C2=B1  6%  sched_debug.cfs=
_rq:/.min_vruntime.stddev
> >       0.29 =C2=B1  8%     -43.6%       0.16 =C2=B1  9%  sched_debug.cfs=
_rq:/.nr_running.avg
> >       0.42 =C2=B1  3%     -15.1%       0.36 =C2=B1  3%  sched_debug.cfs=
_rq:/.nr_running.stddev
> >     312.39 =C2=B1  7%     -46.1%     168.29 =C2=B1  5%  sched_debug.cfs=
_rq:/.runnable_avg.avg
> >     355.85 =C2=B1  2%     -27.3%     258.86 =C2=B1  3%  sched_debug.cfs=
_rq:/.runnable_avg.stddev
> >     984535 =C2=B1 22%     -82.1%     176253 =C2=B1 31%  sched_debug.cfs=
_rq:/.spread0.max
> >    -491914           -62.6%    -184050        sched_debug.cfs_rq:/.spre=
ad0.min
> >     343876 =C2=B1 15%     -78.7%      73261 =C2=B1  6%  sched_debug.cfs=
_rq:/.spread0.stddev
> >     312.25 =C2=B1  7%     -46.1%     168.23 =C2=B1  5%  sched_debug.cfs=
_rq:/.util_avg.avg
> >     355.80 =C2=B1  2%     -27.3%     258.80 =C2=B1  3%  sched_debug.cfs=
_rq:/.util_avg.stddev
> >     213.78 =C2=B1  8%     -62.3%      80.50 =C2=B1 11%  sched_debug.cfs=
_rq:/.util_est_enqueued.avg
> >     331.99 =C2=B1  3%     -37.4%     207.79 =C2=B1  4%  sched_debug.cfs=
_rq:/.util_est_enqueued.stddev
> >     630039           +19.0%     749877 =C2=B1  3%  sched_debug.cpu.avg_=
idle.avg
> >       4262           +45.9%       6219 =C2=B1  3%  sched_debug.cpu.avg_=
idle.min
> >       2345 =C2=B1 14%     -35.1%       1522 =C2=B1  6%  sched_debug.cpu=
.clock_task.stddev
> >       1496 =C2=B1  5%     -47.9%     779.72 =C2=B1  7%  sched_debug.cpu=
.curr->pid.avg
> >       2528 =C2=B1  3%     -19.7%       2031 =C2=B1  3%  sched_debug.cpu=
.curr->pid.stddev
> >       0.00 =C2=B1 10%     -23.0%       0.00 =C2=B1  4%  sched_debug.cpu=
.next_balance.stddev
> >       0.25 =C2=B1  6%     -48.0%       0.13 =C2=B1  8%  sched_debug.cpu=
.nr_running.avg
> >       0.41 =C2=B1  2%     -19.9%       0.33 =C2=B1  3%  sched_debug.cpu=
.nr_running.stddev
> >    3859540 =C2=B1 10%     -70.7%    1132195 =C2=B1 10%  sched_debug.cpu=
.nr_switches.avg
> >    7113795 =C2=B1 11%     -64.8%    2504199 =C2=B1 10%  sched_debug.cpu=
.nr_switches.max
> >    1618475 =C2=B1 15%     -86.1%     224980 =C2=B1 30%  sched_debug.cpu=
.nr_switches.min
> >    1045624 =C2=B1  9%     -57.2%     447501 =C2=B1  9%  sched_debug.cpu=
.nr_switches.stddev
> >  2.446e+10           -66.9%  8.087e+09        perf-stat.i.branch-instru=
ctions
> >  2.356e+08 =C2=B1  2%     -65.6%   80979566 =C2=B1  3%  perf-stat.i.bra=
nch-misses
> >       0.74 =C2=B1  8%      +5.7        6.47        perf-stat.i.cache-mi=
ss-rate%
> >   16166727 =C2=B1 10%    +236.6%   54420281 =C2=B1  2%  perf-stat.i.cac=
he-misses
> >  2.609e+09           -67.5%  8.493e+08 =C2=B1  2%  perf-stat.i.cache-re=
ferences
> >    3956687           -69.4%    1211999        perf-stat.i.context-switc=
hes
> >       1.23           +44.9%       1.79        perf-stat.i.cpi
> >   1.51e+11           -52.3%  7.199e+10 =C2=B1  2%  perf-stat.i.cpu-cycl=
es
> >     363.75           -38.7%     223.06        perf-stat.i.cpu-migration=
s
> >      10558 =C2=B1 10%     -87.4%       1326        perf-stat.i.cycles-b=
etween-cache-misses
> >     652403 =C2=B1109%     -72.7%     178258 =C2=B1  8%  perf-stat.i.dTL=
B-load-misses
> >  3.497e+10           -66.9%  1.158e+10        perf-stat.i.dTLB-loads
> >       0.00 =C2=B1  3%      +0.0        0.00 =C2=B1 11%  perf-stat.i.dTL=
B-store-miss-rate%
> >     119514 =C2=B1  5%     -51.8%      57642 =C2=B1  9%  perf-stat.i.dTL=
B-store-misses
> >  2.067e+10           -66.9%  6.833e+09        perf-stat.i.dTLB-stores
> >      74.98            +0.8       75.82        perf-stat.i.iTLB-load-mis=
s-rate%
> >  1.648e+08 =C2=B1  3%     -67.2%   54063746 =C2=B1  4%  perf-stat.i.iTL=
B-load-misses
> >   54768215           -68.8%   17107737        perf-stat.i.iTLB-loads
> >  1.223e+11           -66.9%  4.052e+10        perf-stat.i.instructions
> >       0.81           -30.7%       0.56        perf-stat.i.ipc
> >       1.05           -52.3%       0.50 =C2=B1  2%  perf-stat.i.metric.G=
Hz
> >     453.64           -46.1%     244.53        perf-stat.i.metric.K/sec
> >     574.31           -66.9%     189.94        perf-stat.i.metric.M/sec
> >       4984 =C2=B1  2%     -12.4%       4368        perf-stat.i.minor-fa=
ults
> >    4306378 =C2=B1 13%    +145.4%   10568372 =C2=B1  2%  perf-stat.i.nod=
e-load-misses
> >     267971 =C2=B1 20%    +205.5%     818656 =C2=B1  4%  perf-stat.i.nod=
e-loads
> >      93.32            +4.7       98.02        perf-stat.i.node-store-mi=
ss-rate%
> >    1642200 =C2=B1 14%    +217.5%    5214268 =C2=B1  2%  perf-stat.i.nod=
e-store-misses
> >     198883 =C2=B1 16%     -39.3%     120629 =C2=B1  9%  perf-stat.i.nod=
e-stores
> >       4985 =C2=B1  2%     -12.4%       4369        perf-stat.i.page-fau=
lts
> >      21.33            -1.7%      20.96        perf-stat.overall.MPKI
> >       0.62 =C2=B1 10%      +5.8        6.41        perf-stat.overall.ca=
che-miss-rate%
> >       1.23           +44.0%       1.78        perf-stat.overall.cpi
> >       9426 =C2=B1  9%     -86.0%       1323        perf-stat.overall.cy=
cles-between-cache-misses
> >       0.00 =C2=B1  4%      +0.0        0.00 =C2=B1  9%  perf-stat.overa=
ll.dTLB-store-miss-rate%
> >      75.04            +0.9       75.95        perf-stat.overall.iTLB-lo=
ad-miss-rate%
> >       0.81           -30.5%       0.56        perf-stat.overall.ipc
> >      89.11            +8.6       97.73        perf-stat.overall.node-st=
ore-miss-rate%
> >      17633            +8.3%      19103        perf-stat.overall.path-le=
ngth
> >  2.438e+10           -66.9%  8.061e+09        perf-stat.ps.branch-instr=
uctions
> >  2.348e+08 =C2=B1  2%     -65.6%   80709139 =C2=B1  3%  perf-stat.ps.br=
anch-misses
> >   16118295 =C2=B1 10%    +236.5%   54240216 =C2=B1  2%  perf-stat.ps.ca=
che-misses
> >    2.6e+09           -67.4%  8.464e+08 =C2=B1  2%  perf-stat.ps.cache-r=
eferences
> >    3943074           -69.4%    1207953        perf-stat.ps.context-swit=
ches
> >  1.505e+11           -52.3%  7.175e+10 =C2=B1  2%  perf-stat.ps.cpu-cyc=
les
> >     362.72           -38.7%     222.48        perf-stat.ps.cpu-migratio=
ns
> >     650701 =C2=B1109%     -72.7%     177916 =C2=B1  8%  perf-stat.ps.dT=
LB-load-misses
> >  3.485e+10           -66.9%  1.155e+10        perf-stat.ps.dTLB-loads
> >     119179 =C2=B1  5%     -51.8%      57464 =C2=B1  9%  perf-stat.ps.dT=
LB-store-misses
> >   2.06e+10           -66.9%   6.81e+09        perf-stat.ps.dTLB-stores
> >  1.642e+08 =C2=B1  3%     -67.2%   53885104 =C2=B1  4%  perf-stat.ps.iT=
LB-load-misses
> >   54583301           -68.8%   17050690        perf-stat.ps.iTLB-loads
> >  1.219e+11           -66.9%  4.039e+10        perf-stat.ps.instructions
> >       4965 =C2=B1  2%     -12.3%       4352        perf-stat.ps.minor-f=
aults
> >    4293134 =C2=B1 13%    +145.4%   10534117 =C2=B1  2%  perf-stat.ps.no=
de-load-misses
> >     267097 =C2=B1 20%    +205.5%     816047 =C2=B1  4%  perf-stat.ps.no=
de-loads
> >    1637287 =C2=B1 13%    +217.4%    5197315 =C2=B1  2%  perf-stat.ps.no=
de-store-misses
> >     198487 =C2=B1 15%     -39.3%     120430 =C2=B1  9%  perf-stat.ps.no=
de-stores
> >       4966 =C2=B1  2%     -12.3%       4353        perf-stat.ps.page-fa=
ults
> >  3.686e+13           -66.8%  1.223e+13        perf-stat.total.instructi=
ons
> >       9.05 =C2=B1  7%      -3.4        5.70 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_packet_pack.sctp_packet_transmit.sctp_outq_flush.sct=
p_cmd_interpreter.sctp_do_sm
> >       8.94 =C2=B1  7%      -3.2        5.69 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_do_sm.sctp_primitive_SEND.sctp_sendmsg_to_asoc.sctp_=
sendmsg.sock_sendmsg
> >       8.61 =C2=B1  7%      -3.2        5.44 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.memcpy_erms.sctp_packet_pack.sctp_packet_transmit.sctp_ou=
tq_flush.sctp_cmd_interpreter
> >       5.69 =C2=B1  4%      -3.0        2.68 =C2=B1  7%  perf-profile.ca=
lltrace.cycles-pp.mwait_idle_with_hints.intel_idle_irq.cpuidle_enter_state.=
cpuidle_enter.cpuidle_idle_call
> >       5.85 =C2=B1  4%      -3.0        2.90 =C2=B1  8%  perf-profile.ca=
lltrace.cycles-pp.intel_idle_irq.cpuidle_enter_state.cpuidle_enter.cpuidle_=
idle_call.do_idle
> >      21.32 =C2=B1  6%      -2.9       18.43 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_sendmsg_to_asoc.sctp_sendmsg.sock_sendmsg.____sys_se=
ndmsg.___sys_sendmsg
> >      13.45 =C2=B1  7%      -2.5       10.92 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_primitive_SEND.sctp_sendmsg_to_asoc.sctp_sendmsg.soc=
k_sendmsg.____sys_sendmsg
> >       7.02 =C2=B1  7%      -2.5        4.51 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_datamsg_from_user.sctp_sendmsg_to_asoc.sctp_sendmsg.=
sock_sendmsg.____sys_sendmsg
> >       6.53 =C2=B1  6%      -2.5        4.06 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.skb_copy_datagram_iter.sctp_recvmsg.inet_recvmsg.____sys_=
recvmsg.___sys_recvmsg
> >       6.51 =C2=B1  6%      -2.5        4.05 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.__skb_datagram_iter.skb_copy_datagram_iter.sctp_recvmsg.i=
net_recvmsg.____sys_recvmsg
> >       5.68 =C2=B1  6%      -2.1        3.54 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.=
sctp_recvmsg.inet_recvmsg
> >       5.52 =C2=B1  6%      -2.1        3.45 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.copyout._copy_to_iter.__skb_datagram_iter.skb_copy_datagr=
am_iter.sctp_recvmsg
> >       5.48 =C2=B1  6%      -2.1        3.42 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.copy_user_enhanced_fast_string.copyout._copy_to_iter.__sk=
b_datagram_iter.skb_copy_datagram_iter
> >      11.97 =C2=B1  7%      -2.0        9.98 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_flush.sctp_cmd_interpreter.sctp_do_sm.sctp_prim=
itive_SEND.sctp_sendmsg_to_asoc
> >       9.16 =C2=B1  7%      -1.8        7.37 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_cmd_interpreter.sctp_do_sm.sctp_primitive_SEND.sctp_=
sendmsg_to_asoc.sctp_sendmsg
> >      10.42 =C2=B1  7%      -1.4        9.00 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_packet_transmit.sctp_outq_flush.sctp_cmd_interpreter=
.sctp_do_sm.sctp_primitive_SEND
> >       1.58 =C2=B1  6%      -1.2        0.35 =C2=B1 70%  perf-profile.ca=
lltrace.cycles-pp.__alloc_pages.kmalloc_large_node.__kmalloc_node_track_cal=
ler.kmalloc_reserve.__alloc_skb
> >       3.49 =C2=B1  6%      -1.2        2.30 =C2=B1  7%  perf-profile.ca=
lltrace.cycles-pp.sctp_user_addto_chunk.sctp_datamsg_from_user.sctp_sendmsg=
_to_asoc.sctp_sendmsg.sock_sendmsg
> >       3.15 =C2=B1  6%      -1.1        2.06 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp._copy_from_iter.sctp_user_addto_chunk.sctp_datamsg_from_u=
ser.sctp_sendmsg_to_asoc.sctp_sendmsg
> >       2.86 =C2=B1  7%      -1.1        1.79 =C2=B1  7%  perf-profile.ca=
lltrace.cycles-pp.sctp_make_datafrag_empty.sctp_datamsg_from_user.sctp_send=
msg_to_asoc.sctp_sendmsg.sock_sendmsg
> >       3.16 =C2=B1  7%      -1.1        2.11 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_data_ready.sctp_ulpq_tail_event.sctp_ulpq_tail_data.=
sctp_cmd_interpreter.sctp_do_sm
> >       3.00 =C2=B1  6%      -1.0        1.96 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.copyin._copy_from_iter.sctp_user_addto_chunk.sctp_datamsg=
_from_user.sctp_sendmsg_to_asoc
> >       2.97 =C2=B1  6%      -1.0        1.93 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.copy_user_enhanced_fast_string.copyin._copy_from_iter.sct=
p_user_addto_chunk.sctp_datamsg_from_user
> >       3.26 =C2=B1  7%      -1.0        2.22 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_ulpq_tail_event.sctp_ulpq_tail_data.sctp_cmd_interpr=
eter.sctp_do_sm.sctp_assoc_bh_rcv
> >       2.89 =C2=B1  7%      -1.0        1.87 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__wake_up_common_lock.sctp_data_ready.sctp_ulpq_tail_even=
t.sctp_ulpq_tail_data.sctp_cmd_interpreter
> >       2.68 =C2=B1  6%      -0.9        1.74 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__wake_up_common.__wake_up_common_lock.sctp_data_ready.sc=
tp_ulpq_tail_event.sctp_ulpq_tail_data
> >       2.40 =C2=B1  7%      -0.9        1.46 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp._sctp_make_chunk.sctp_make_datafrag_empty.sctp_datamsg_fr=
om_user.sctp_sendmsg_to_asoc.sctp_sendmsg
> >       2.49 =C2=B1  7%      -0.9        1.62 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.autoremove_wake_function.__wake_up_common.__wake_up_commo=
n_lock.sctp_data_ready.sctp_ulpq_tail_event
> >       2.46 =C2=B1  6%      -0.9        1.60 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.try_to_wake_up.autoremove_wake_function.__wake_up_common.=
__wake_up_common_lock.sctp_data_ready
> >       1.86 =C2=B1  6%      -0.8        1.10 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.schedule_timeout.sctp_skb_recv_datagram.sctp_recvmsg.inet=
_recvmsg.____sys_recvmsg
> >       1.81 =C2=B1  7%      -0.8        1.06 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__alloc_skb._sctp_make_chunk.sctp_make_datafrag_empty.sct=
p_datamsg_from_user.sctp_sendmsg_to_asoc
> >       1.76 =C2=B1  9%      -0.7        1.01 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_ulpevent_free.sctp_recvmsg.inet_recvmsg.____sys_recv=
msg.___sys_recvmsg
> >       1.82 =C2=B1  6%      -0.7        1.08 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.schedule.schedule_timeout.sctp_skb_recv_datagram.sctp_rec=
vmsg.inet_recvmsg
> >       1.50 =C2=B1  6%      -0.7        0.76 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.skb_release_data.kfree_skb_reason.sctp_recvmsg.inet_recvm=
sg.____sys_recvmsg
> >       1.79 =C2=B1  6%      -0.7        1.06 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.__schedule.schedule.schedule_timeout.sctp_skb_recv_datagr=
am.sctp_recvmsg
> >       1.61 =C2=B1  6%      -0.6        1.01 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.s=
econdary_startup_64_no_verify
> >       0.86 =C2=B1  7%      -0.6        0.26 =C2=B1100%  perf-profile.ca=
lltrace.cycles-pp.dequeue_entity.dequeue_task_fair.__schedule.schedule.sche=
dule_timeout
> >       1.56 =C2=B1  6%      -0.6        0.98 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.start_=
secondary
> >       1.56 =C2=B1  8%      -0.6        0.99 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_flush_data.sctp_outq_flush.sctp_cmd_interpreter=
.sctp_do_sm.sctp_primitive_SEND
> >       1.25 =C2=B1  7%      -0.6        0.68 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.kmalloc_reserve.__alloc_skb._sctp_make_chunk.sctp_make_da=
tafrag_empty.sctp_datamsg_from_user
> >       1.22 =C2=B1  7%      -0.6        0.66 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__kmalloc_node_track_caller.kmalloc_reserve.__alloc_skb._=
sctp_make_chunk.sctp_make_datafrag_empty
> >       1.19 =C2=B1  7%      -0.5        0.64 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.kmalloc_large_node.__kmalloc_node_track_caller.kmalloc_re=
serve.__alloc_skb._sctp_make_chunk
> >       0.90 =C2=B1  7%      -0.5        0.39 =C2=B1 70%  perf-profile.ca=
lltrace.cycles-pp.skb_release_data.consume_skb.sctp_chunk_put.sctp_outq_sac=
k.sctp_cmd_interpreter
> >       0.94 =C2=B1  7%      -0.5        0.46 =C2=B1 45%  perf-profile.ca=
lltrace.cycles-pp.dequeue_task_fair.__schedule.schedule.schedule_timeout.sc=
tp_skb_recv_datagram
> >       0.74 =C2=B1  6%      -0.5        0.27 =C2=B1100%  perf-profile.ca=
lltrace.cycles-pp.sctp_endpoint_lookup_assoc.sctp_sendmsg.sock_sendmsg.____=
sys_sendmsg.___sys_sendmsg
> >       0.98 =C2=B1  8%      -0.4        0.57 =C2=B1  7%  perf-profile.ca=
lltrace.cycles-pp.sctp_chunk_put.sctp_ulpevent_free.sctp_recvmsg.inet_recvm=
sg.____sys_recvmsg
> >       1.05 =C2=B1  8%      -0.4        0.66 =C2=B1  7%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_flush.sctp_cmd_interpreter.sctp_do_sm.sctp_asso=
c_bh_rcv.sctp_rcv
> >       1.10 =C2=B1  7%      -0.4        0.72 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sendmsg_copy_msghdr.___sys_sendmsg.__sys_sendmsg.do_sysca=
ll_64.entry_SYSCALL_64_after_hwframe
> >       0.46 =C2=B1 45%      +0.4        0.83 =C2=B1 27%  perf-profile.ca=
lltrace.cycles-pp.menu_select.cpuidle_idle_call.do_idle.cpu_startup_entry.s=
tart_secondary
> >       0.00            +0.8        0.84 =C2=B1 24%  perf-profile.calltra=
ce.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_ti=
mer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
> >       0.00            +0.8        0.84 =C2=B1 24%  perf-profile.calltra=
ce.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_=
sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
> >       0.00            +0.9        0.85 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.page_counter_uncharge.drain_stock.refill_stock.__sk_mem_reduce=
_allocated.skb_release_head_state
> >       0.00            +0.9        0.87 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.drain_stock.refill_stock.__sk_mem_reduce_allocated.skb_release=
_head_state.kfree_skb_reason
> >       0.00            +1.0        0.98 =C2=B1  7%  perf-profile.calltra=
ce.cycles-pp.refill_stock.__sk_mem_reduce_allocated.skb_release_head_state.=
kfree_skb_reason.sctp_recvmsg
> >       0.00            +1.2        1.24 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.page_counter_uncharge.drain_stock.refill_stock.__sk_mem_reduce=
_allocated.sctp_wfree
> >       0.00            +1.3        1.26 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.drain_stock.refill_stock.__sk_mem_reduce_allocated.sctp_wfree.=
skb_release_head_state
> >       0.00            +1.3        1.27 =C2=B1 19%  perf-profile.calltra=
ce.cycles-pp.try_charge_memcg.mem_cgroup_charge_skmem.__sk_mem_raise_alloca=
ted.__sk_mem_schedule.sctp_ulpevent_make_rcvmsg
> >       0.00            +1.3        1.29 =C2=B1 26%  perf-profile.calltra=
ce.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cp=
uidle_enter_state.cpuidle_enter.cpuidle_idle_call
> >       1.60 =C2=B1 10%      +1.3        2.92 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_ulpevent_make_rcvmsg.sctp_ulpq_tail_data.sctp_cmd_in=
terpreter.sctp_do_sm.sctp_assoc_bh_rcv
> >       0.00            +1.4        1.35 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.refill_stock.__sk_mem_reduce_allocated.sctp_wfree.skb_release_=
head_state.consume_skb
> >       0.00            +1.4        1.42 =C2=B1 25%  perf-profile.calltra=
ce.cycles-pp.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_en=
ter.cpuidle_idle_call.do_idle
> >       0.00            +1.6        1.63 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.mem_cgroup_charge_skmem.__sk_mem_raise_allocated.__sk_mem_sche=
dule.sctp_ulpevent_make_rcvmsg.sctp_ulpq_tail_data
> >       0.00            +1.7        1.66 =C2=B1 19%  perf-profile.calltra=
ce.cycles-pp.page_counter_try_charge.try_charge_memcg.mem_cgroup_charge_skm=
em.__sk_mem_raise_allocated.__sk_mem_schedule
> >      10.96 =C2=B1  7%      +1.7       12.67 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__ip_queue_xmit.sctp_packet_transmit.sctp_outq_flush.sctp=
_cmd_interpreter.sctp_do_sm
> >       0.00            +1.7        1.72 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_raise_allocated.__sk_mem_schedule.sctp_ulpevent_make_=
rcvmsg.sctp_ulpq_tail_data.sctp_cmd_interpreter
> >       0.00            +1.7        1.73 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_schedule.sctp_ulpevent_make_rcvmsg.sctp_ulpq_tail_dat=
a.sctp_cmd_interpreter.sctp_do_sm
> >      10.84 =C2=B1  7%      +1.8       12.59 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.ip_finish_output2.__ip_queue_xmit.sctp_packet_transmit.sc=
tp_outq_flush.sctp_cmd_interpreter
> >      10.63 =C2=B1  7%      +1.8       12.42 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__local_bh_enable_ip.ip_finish_output2.__ip_queue_xmit.sc=
tp_packet_transmit.sctp_outq_flush
> >      10.58 =C2=B1  7%      +1.8       12.40 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.do_softirq.__local_bh_enable_ip.ip_finish_output2.__ip_qu=
eue_xmit.sctp_packet_transmit
> >      10.53 =C2=B1  7%      +1.8       12.36 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__softirqentry_text_start.do_softirq.__local_bh_enable_ip=
.ip_finish_output2.__ip_queue_xmit
> >      10.36 =C2=B1  7%      +1.9       12.25 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.net_rx_action.__softirqentry_text_start.do_softirq.__loca=
l_bh_enable_ip.ip_finish_output2
> >      10.26 =C2=B1  7%      +1.9       12.18 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__napi_poll.net_rx_action.__softirqentry_text_start.do_so=
ftirq.__local_bh_enable_ip
> >      10.23 =C2=B1  7%      +1.9       12.17 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.process_backlog.__napi_poll.net_rx_action.__softirqentry_=
text_start.do_softirq
> >      10.07 =C2=B1  7%      +2.0       12.08 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__netif_receive_skb_one_core.process_backlog.__napi_poll.=
net_rx_action.__softirqentry_text_start
> >       0.00            +2.0        2.02 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.try_charge_memcg.mem_cgroup_charge_skmem.__sk_mem_raise_alloca=
ted.__sk_mem_schedule.sctp_sendmsg_to_asoc
> >       9.84 =C2=B1  7%      +2.1       11.95 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.ip_local_deliver_finish.__netif_receive_skb_one_core.proc=
ess_backlog.__napi_poll.net_rx_action
> >       9.82 =C2=B1  7%      +2.1       11.94 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_r=
eceive_skb_one_core.process_backlog.__napi_poll
> >       9.74 =C2=B1  7%      +2.1       11.88 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.=
__netif_receive_skb_one_core.process_backlog
> >       3.38 =C2=B1  7%      +2.1        5.53 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_skb_recv_datagram.sctp_recvmsg.inet_recvmsg.____sys_=
recvmsg.___sys_recvmsg
> >       0.00            +2.4        2.38 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.mem_cgroup_charge_skmem.__sk_mem_raise_allocated.__sk_mem_sche=
dule.sctp_sendmsg_to_asoc.sctp_sendmsg
> >       0.00            +2.5        2.54 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_raise_allocated.__sk_mem_schedule.sctp_sendmsg_to_aso=
c.sctp_sendmsg.sock_sendmsg
> >       0.00            +2.5        2.55 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_schedule.sctp_sendmsg_to_asoc.sctp_sendmsg.sock_sendm=
sg.____sys_sendmsg
> >       8.08 =C2=B1  7%      +2.7       10.74 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_assoc_bh_rcv.sctp_rcv.ip_protocol_deliver_rcu.ip_loc=
al_deliver_finish.__netif_receive_skb_one_core
> >       7.63 =C2=B1  7%      +2.8       10.44 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_do_sm.sctp_assoc_bh_rcv.sctp_rcv.ip_protocol_deliver=
_rcu.ip_local_deliver_finish
> >      15.25 =C2=B1  6%      +2.9       18.11 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.inet_recvmsg.____sys_recvmsg.___sys_recvmsg.__sys_recvmsg=
.do_syscall_64
> >      15.15 =C2=B1  7%      +2.9       18.03 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.release_sock.sctp_sendmsg.sock_sendmsg.____sys_sendmsg.__=
_sys_sendmsg
> >      15.20 =C2=B1  6%      +2.9       18.09 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_recvmsg.inet_recvmsg.____sys_recvmsg.___sys_recvmsg.=
__sys_recvmsg
> >      15.02 =C2=B1  7%      +2.9       17.94 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.__release_sock.release_sock.sctp_sendmsg.sock_sendmsg.___=
_sys_sendmsg
> >      14.96 =C2=B1  7%      +2.9       17.90 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_backlog_rcv.__release_sock.release_sock.sctp_sendmsg=
.sock_sendmsg
> >      11.70 =C2=B1  7%      +3.0       14.67 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_cmd_interpreter.sctp_do_sm.sctp_assoc_bh_rcv.sctp_ba=
cklog_rcv.__release_sock
> >       0.84 =C2=B1 10%      +3.1        3.94 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp._raw_spin_lock_bh.lock_sock_nested.sctp_skb_recv_datagram=
.sctp_recvmsg.inet_recvmsg
> >       0.96 =C2=B1  9%      +3.1        4.06 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.lock_sock_nested.sctp_skb_recv_datagram.sctp_recvmsg.inet=
_recvmsg.____sys_recvmsg
> >       0.64 =C2=B1 11%      +3.2        3.82 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_bh.lock_s=
ock_nested.sctp_skb_recv_datagram.sctp_recvmsg
> >       0.00            +3.9        3.90 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.sctp_eat_data.sctp_sf_eat_data_6_2.sctp_do_sm.sctp_assoc_bh_rc=
v.sctp_rcv
> >       0.00            +4.0        3.98 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.sctp_sf_eat_data_6_2.sctp_do_sm.sctp_assoc_bh_rcv.sctp_rcv.ip_=
protocol_deliver_rcu
> >       2.90 =C2=B1  7%      +4.2        7.09 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_sack.sctp_cmd_interpreter.sctp_do_sm.sctp_assoc=
_bh_rcv.sctp_backlog_rcv
> >       1.87 =C2=B1  7%      +4.5        6.40 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_chunk_put.sctp_outq_sack.sctp_cmd_interpreter.sctp_d=
o_sm.sctp_assoc_bh_rcv
> >       1.43 =C2=B1  7%      +4.6        6.01 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.consume_skb.sctp_chunk_put.sctp_outq_sack.sctp_cmd_interp=
reter.sctp_do_sm
> >       1.78 =C2=B1  6%      +4.6        6.42 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.kfree_skb_reason.sctp_recvmsg.inet_recvmsg.____sys_recvms=
g.___sys_recvmsg
> >       0.00            +5.1        5.10 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_reduce_allocated.sctp_wfree.skb_release_head_state.co=
nsume_skb.sctp_chunk_put
> >       0.17 =C2=B1141%      +5.3        5.42 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.skb_release_head_state.consume_skb.sctp_chunk_put.sctp_ou=
tq_sack.sctp_cmd_interpreter
> >       0.00            +5.3        5.35 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.sctp_wfree.skb_release_head_state.consume_skb.sctp_chunk_put.s=
ctp_outq_sack
> >       0.00            +5.5        5.51 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_reduce_allocated.skb_release_head_state.kfree_skb_rea=
son.sctp_recvmsg.inet_recvmsg
> >       0.00            +5.7        5.65 =C2=B1  6%  perf-profile.calltra=
ce.cycles-pp.skb_release_head_state.kfree_skb_reason.sctp_recvmsg.inet_recv=
msg.____sys_recvmsg
> >       9.38 =C2=B1  6%      -3.5        5.93 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_pack
> >      24.70 =C2=B1  6%      -3.4       21.34 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_flush
> >       8.83 =C2=B1  6%      -3.2        5.60 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.copy_user_enhanced_fast_string
> >       8.77 =C2=B1  6%      -3.2        5.58 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.memcpy_erms
> >       5.88 =C2=B1  4%      -3.0        2.92 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.intel_idle_irq
> >      21.34 =C2=B1  6%      -2.8       18.58 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_sendmsg_to_asoc
> >       7.06 =C2=B1  6%      -2.5        4.54 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_datamsg_from_user
> >      13.52 =C2=B1  6%      -2.5       11.00 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_primitive_SEND
> >       6.53 =C2=B1  6%      -2.5        4.06 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.skb_copy_datagram_iter
> >       6.51 =C2=B1  6%      -2.5        4.05 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__skb_datagram_iter
> >       5.68 =C2=B1  6%      -2.1        3.54 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp._copy_to_iter
> >       5.52 =C2=B1  6%      -2.1        3.45 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.copyout
> >       3.33 =C2=B1  6%      -1.4        1.92 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__alloc_skb
> >       3.38 =C2=B1  6%      -1.3        2.07 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__schedule
> >       3.51 =C2=B1  6%      -1.2        2.31 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_user_addto_chunk
> >       2.67 =C2=B1  6%      -1.2        1.47 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.skb_release_data
> >       2.43 =C2=B1  6%      -1.1        1.32 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.kmalloc_reserve
> >       3.17 =C2=B1  6%      -1.1        2.08 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp._copy_from_iter
> >       2.38 =C2=B1  6%      -1.1        1.29 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__kmalloc_node_track_caller
> >       2.88 =C2=B1  7%      -1.1        1.80 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_make_datafrag_empty
> >       3.18 =C2=B1  6%      -1.1        2.12 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_data_ready
> >       3.02 =C2=B1  6%      -1.0        1.98 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.copyin
> >       3.28 =C2=B1  6%      -1.0        2.25 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpq_tail_event
> >       2.26 =C2=B1  6%      -1.0        1.22 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.kmalloc_large_node
> >       2.62 =C2=B1  6%      -1.0        1.60 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp._sctp_make_chunk
> >       2.90 =C2=B1  6%      -1.0        1.89 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__wake_up_common_lock
> >       2.69 =C2=B1  6%      -0.9        1.75 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__wake_up_common
> >       1.97 =C2=B1  6%      -0.9        1.04 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__alloc_pages
> >       2.50 =C2=B1  6%      -0.9        1.64 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.autoremove_wake_function
> >       2.48 =C2=B1  6%      -0.9        1.63 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.try_to_wake_up
> >       1.67 =C2=B1  5%      -0.8        0.86 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.get_page_from_freelist
> >       2.26 =C2=B1  7%      -0.8        1.48 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_flush_data
> >       1.86 =C2=B1  6%      -0.8        1.10 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.schedule_timeout
> >       1.76 =C2=B1  8%      -0.7        1.02 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpevent_free
> >       2.08 =C2=B1  5%      -0.7        1.33 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.kmem_cache_free
> >       1.84 =C2=B1  6%      -0.7        1.10 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.schedule
> >       1.62 =C2=B1  6%      -0.6        1.02 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.schedule_idle
> >       1.20 =C2=B1  6%      -0.6        0.62 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.free_unref_page
> >       1.49 =C2=B1  5%      -0.5        0.95 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp._copy_from_user
> >       1.03 =C2=B1  6%      -0.5        0.54 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.rmqueue
> >       1.06 =C2=B1  6%      -0.5        0.58 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp._raw_spin_lock_irqsave
> >       1.18 =C2=B1  5%      -0.4        0.74 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__check_object_size
> >       1.22 =C2=B1  4%      -0.4        0.79 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__rhashtable_lookup
> >       0.97 =C2=B1  6%      -0.4        0.57 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__slab_free
> >       0.94 =C2=B1  7%      -0.4        0.54 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.dequeue_task_fair
> >       1.18 =C2=B1  6%      -0.4        0.78 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.ttwu_do_activate
> >       0.82 =C2=B1  6%      -0.4        0.43 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp._raw_spin_lock
> >       1.11 =C2=B1  6%      -0.4        0.73 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sendmsg_copy_msghdr
> >       1.14 =C2=B1  6%      -0.4        0.76 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.enqueue_task_fair
> >       0.87 =C2=B1  7%      -0.4        0.50 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.dequeue_entity
> >       0.92 =C2=B1 11%      -0.4        0.56 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_select_transport
> >       1.00 =C2=B1  5%      -0.4        0.65 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__copy_msghdr_from_user
> >       0.82 =C2=B1 12%      -0.3        0.49 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_config
> >       0.84 =C2=B1  6%      -0.3        0.54 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.import_iovec
> >       0.84 =C2=B1  6%      -0.3        0.55 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.pick_next_task_fair
> >       0.80 =C2=B1  4%      -0.3        0.51 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.kfree
> >       0.50 =C2=B1  6%      -0.3        0.20 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.free_pcppages_bulk
> >       0.80 =C2=B1  6%      -0.3        0.51 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__import_iovec
> >       0.83 =C2=B1  6%      -0.3        0.54 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.enqueue_entity
> >       0.79 =C2=B1  7%      -0.3        0.51 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.kmem_cache_alloc
> >       0.70 =C2=B1  6%      -0.3        0.42 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.update_load_avg
> >       0.78 =C2=B1  7%      -0.3        0.50 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_hash_cmp
> >       0.73 =C2=B1  5%      -0.3        0.47 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__sctp_rcv_lookup
> >       0.69 =C2=B1  6%      -0.3        0.44 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.check_heap_object
> >       0.47 =C2=B1  6%      -0.3        0.22 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__free_pages_ok
> >       0.70 =C2=B1  4%      -0.2        0.46 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_addrs_lookup_transport
> >       0.68 =C2=B1  6%      -0.2        0.43 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.iovec_from_user
> >       0.71 =C2=B1  6%      -0.2        0.47 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_chunkify
> >       0.66 =C2=B1  5%      -0.2        0.42 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__might_resched
> >       0.60 =C2=B1  5%      -0.2        0.36 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.set_next_entity
> >       0.74 =C2=B1  6%      -0.2        0.51 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_endpoint_lookup_assoc
> >       0.72 =C2=B1  6%      -0.2        0.50 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sctp_epaddr_lookup_transport
> >       0.54 =C2=B1  6%      -0.2        0.32 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.__dev_queue_xmit
> >       0.44 =C2=B1  7%      -0.2        0.23 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_inq_pop
> >       0.61 =C2=B1  6%      -0.2        0.40 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.copy_user_short_string
> >       0.62 =C2=B1 13%      -0.2        0.42 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__skb_clone
> >       0.52 =C2=B1  5%      -0.2        0.32 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__might_fault
> >       0.46 =C2=B1  5%      -0.2        0.27 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.simple_copy_to_iter
> >       0.51 =C2=B1  7%      -0.2        0.33 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__entry_text_start
> >       0.36 =C2=B1  7%      -0.2        0.19 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.update_curr
> >       0.56 =C2=B1  6%      -0.2        0.38 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__list_del_entry_valid
> >       0.37 =C2=B1  7%      -0.2        0.21 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__mod_node_page_state
> >       0.32 =C2=B1  7%      -0.2        0.17 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__zone_watermark_ok
> >       0.42 =C2=B1 10%      -0.2        0.27 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.select_task_rq
> >       0.46 =C2=B1 17%      -0.2        0.31 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__copy_skb_header
> >       0.46 =C2=B1  7%      -0.1        0.31 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_transmit_chunk
> >       0.46 =C2=B1  7%      -0.1        0.32 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.update_rq_clock
> >       0.43 =C2=B1  5%      -0.1        0.29 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_addto_chunk
> >       0.41 =C2=B1  7%      -0.1        0.27 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_append_chunk
> >       0.34 =C2=B1  6%      -0.1        0.20 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.dev_hard_start_xmit
> >       0.46 =C2=B1  8%      -0.1        0.32 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.kmem_cache_alloc_node
> >       0.40 =C2=B1  5%      -0.1        0.27 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sockfd_lookup_light
> >       0.38 =C2=B1  6%      -0.1        0.25 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_chunk_free
> >       0.24 =C2=B1 14%      -0.1        0.10 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.sctp_assoc_rwnd_increase
> >       0.35 =C2=B1  6%      -0.1        0.21 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__list_add_valid
> >       0.36 =C2=B1  7%      -0.1        0.22 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_gen_sack
> >       0.36 =C2=B1  5%      -0.1        0.23 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.memset_erms
> >       0.35 =C2=B1  8%      -0.1        0.22 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.memcg_slab_free_hook
> >       0.32 =C2=B1  6%      -0.1        0.19 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.loopback_xmit
> >       0.36 =C2=B1  5%      -0.1        0.23 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sock_kmalloc
> >       0.36 =C2=B1  4%      -0.1        0.24 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__might_sleep
> >       0.33 =C2=B1  8%      -0.1        0.21 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__virt_addr_valid
> >       0.28 =C2=B1  8%      -0.1        0.15 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.free_unref_page_commit
> >       0.34 =C2=B1  4%      -0.1        0.22 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.free_pcp_prepare
> >       0.33 =C2=B1  7%      -0.1        0.20 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.sctp_make_sack
> >       0.30 =C2=B1 13%      -0.1        0.18 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sctp_v4_xmit
> >       0.34 =C2=B1  5%      -0.1        0.22 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__fdget
> >       0.35 =C2=B1  6%      -0.1        0.23 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.move_addr_to_kernel
> >       0.25 =C2=B1  5%      -0.1        0.13 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__free_one_page
> >       0.40 =C2=B1  9%      -0.1        0.29 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.aa_sk_perm
> >       0.24 =C2=B1  6%      -0.1        0.12 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.prepare_task_switch
> >       0.32 =C2=B1  7%      -0.1        0.21 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_check_transmitted
> >       0.30 =C2=B1  6%      -0.1        0.19 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_association_put
> >       0.36 =C2=B1  7%      -0.1        0.24 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sock_recvmsg
> >       0.26 =C2=B1 12%      -0.1        0.16 =C2=B1 15%  perf-profile.ch=
ildren.cycles-pp.ipv4_dst_check
> >       0.22 =C2=B1  9%      -0.1        0.11 =C2=B1 46%  perf-profile.ch=
ildren.cycles-pp.accept_connections
> >       0.31 =C2=B1 11%      -0.1        0.20 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.select_task_rq_fair
> >       0.22 =C2=B1 17%      -0.1        0.11 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.dst_release
> >       0.23 =C2=B1  6%      -0.1        0.12 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.rmqueue_bulk
> >       0.22 =C2=B1  6%      -0.1        0.11 =C2=B1 12%  perf-profile.ch=
ildren.cycles-pp.sock_wfree
> >       0.28 =C2=B1  6%      -0.1        0.18 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.send_sctp_stream_1toMany
> >       0.32 =C2=B1  7%      -0.1        0.23 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.security_socket_recvmsg
> >       0.30 =C2=B1  7%      -0.1        0.20 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.skb_set_owner_w
> >       0.28 =C2=B1  7%      -0.1        0.18 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.entry_SYSRETQ_unsafe_stack
> >       0.27 =C2=B1  4%      -0.1        0.17 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sock_kfree_s
> >       0.27 =C2=B1 10%      -0.1        0.18 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.sctp_transport_hold
> >       0.24 =C2=B1  6%      -0.1        0.15 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__switch_to
> >       0.24 =C2=B1  7%      -0.1        0.15 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.tick_nohz_idle_exit
> >       0.21 =C2=B1 10%      -0.1        0.12 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.recv_sctp_stream_1toMany
> >       0.23 =C2=B1  7%      -0.1        0.14 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.prepare_to_wait_exclusive
> >       0.22 =C2=B1  9%      -0.1        0.14 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.accept_connection
> >       0.22 =C2=B1  9%      -0.1        0.14 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.spawn_child
> >       0.22 =C2=B1  9%      -0.1        0.14 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.process_requests
> >       0.23 =C2=B1  3%      -0.1        0.14 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__kmalloc
> >       0.20 =C2=B1  9%      -0.1        0.12 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.skb_clone
> >       0.31 =C2=B1 10%      -0.1        0.22 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.sctp_sched_fcfs_dequeue
> >       0.29 =C2=B1 12%      -0.1        0.21 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_transport_put
> >       0.22 =C2=B1  8%      -0.1        0.14 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.select_idle_sibling
> >       0.22 =C2=B1  8%      -0.1        0.14 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__switch_to_asm
> >       0.25 =C2=B1 10%      -0.1        0.17 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.__sctp_packet_append_chunk
> >       0.23 =C2=B1  5%      -0.1        0.15 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.__cond_resched
> >       0.20 =C2=B1  6%      -0.1        0.13 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.available_idle_cpu
> >       0.19 =C2=B1  9%      -0.1        0.11 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.poll_idle
> >       0.20 =C2=B1  6%      -0.1        0.13 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.reweight_entity
> >       0.20 =C2=B1  7%      -0.1        0.13 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_make_control
> >       0.25 =C2=B1  9%      -0.1        0.18 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.syscall_exit_to_user_mode
> >       0.20 =C2=B1  6%      -0.1        0.12 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__free_pages
> >       0.26 =C2=B1  8%      -0.1        0.19 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.security_socket_sendmsg
> >       0.19 =C2=B1  8%      -0.1        0.12 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.syscall_return_via_sysret
> >       0.17 =C2=B1  9%      -0.1        0.10 =C2=B1 14%  perf-profile.ch=
ildren.cycles-pp.__mod_timer
> >       0.16 =C2=B1  5%      -0.1        0.09 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.___perf_sw_event
> >       0.21 =C2=B1  6%      -0.1        0.14 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sctp_datamsg_put
> >       0.21 =C2=B1  7%      -0.1        0.14 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_association_hold
> >       0.18 =C2=B1 10%      -0.1        0.11 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_flush_ctrl
> >       0.16 =C2=B1  8%      -0.1        0.09 =C2=B1 14%  perf-profile.ch=
ildren.cycles-pp.__update_load_avg_cfs_rq
> >       0.20 =C2=B1  4%      -0.1        0.13 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.kmem_cache_alloc_trace
> >       0.19 =C2=B1  5%      -0.1        0.13 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__update_load_avg_se
> >       0.16 =C2=B1  5%      -0.1        0.10 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.del_timer
> >       0.14 =C2=B1 11%      -0.1        0.08 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.check_new_pages
> >       0.23 =C2=B1  7%      -0.1        0.17 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_sched_dequeue_common
> >       0.10 =C2=B1  5%      -0.1        0.04 =C2=B1 71%  perf-profile.ch=
ildren.cycles-pp.finish_task_switch
> >       0.18 =C2=B1  7%      -0.1        0.12 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_tail
> >       0.12 =C2=B1  4%      -0.1        0.06 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.check_stack_object
> >       0.13 =C2=B1  8%      -0.1        0.08 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__put_user_nocheck_4
> >       0.16 =C2=B1  4%      -0.1        0.10 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.__genradix_ptr
> >       0.17 =C2=B1  6%      -0.1        0.11 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.nr_iowait_cpu
> >       0.16 =C2=B1  8%      -0.1        0.11 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.sctp_sendmsg_parse
> >       0.13 =C2=B1  7%      -0.1        0.08 =C2=B1 12%  perf-profile.ch=
ildren.cycles-pp.lock_timer_base
> >       0.08 =C2=B1 12%      -0.0        0.02 =C2=B1 99%  perf-profile.ch=
ildren.cycles-pp.ip_local_out
> >       0.14 =C2=B1  7%      -0.0        0.09 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.memcg_slab_post_alloc_hook
> >       0.14 =C2=B1  9%      -0.0        0.09 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.switch_mm_irqs_off
> >       0.14 =C2=B1  9%      -0.0        0.09 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_datamsg_destroy
> >       0.12 =C2=B1 20%      -0.0        0.07 =C2=B1 21%  perf-profile.ch=
ildren.cycles-pp.sctp_hash_key
> >       0.11 =C2=B1 20%      -0.0        0.06 =C2=B1 14%  perf-profile.ch=
ildren.cycles-pp.ip_rcv
> >       0.11 =C2=B1  8%      -0.0        0.07 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_sock_rfree
> >       0.24 =C2=B1  7%      -0.0        0.19 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sched_clock_cpu
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.__netif_rx
> >       0.16 =C2=B1  8%      -0.0        0.11 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.ttwu_do_wakeup
> >       0.31 =C2=B1  6%      -0.0        0.27 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpevent_receive_data
> >       0.13 =C2=B1  7%      -0.0        0.09 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.pick_next_entity
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__check_heap_object
> >       0.12 =C2=B1  8%      -0.0        0.08 =C2=B1 12%  perf-profile.ch=
ildren.cycles-pp.netif_rx_internal
> >       0.08 =C2=B1 10%      -0.0        0.03 =C2=B1 70%  perf-profile.ch=
ildren.cycles-pp.__wrgsbase_inactive
> >       0.22 =C2=B1  8%      -0.0        0.18 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.read_tsc
> >       0.14 =C2=B1  8%      -0.0        0.10 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.check_preempt_curr
> >       0.10 =C2=B1  9%      -0.0        0.06 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.rcu_all_qs
> >       0.10 =C2=B1 10%      -0.0        0.06 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.validate_xmit_skb
> >       0.14 =C2=B1  8%      -0.0        0.10 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.perf_trace_sched_wakeup_template
> >       0.11 =C2=B1  6%      -0.0        0.07 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.enqueue_to_backlog
> >       0.09 =C2=B1  5%      -0.0        0.05 =C2=B1 45%  perf-profile.ch=
ildren.cycles-pp.__netif_receive_skb_core
> >       0.12 =C2=B1  5%      -0.0        0.08 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__put_user_nocheck_8
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1 14%  perf-profile.ch=
ildren.cycles-pp.sctp_chunk_abandoned
> >       0.12 =C2=B1  5%      -0.0        0.08 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.skb_put
> >       0.20 =C2=B1  7%      -0.0        0.17 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.native_sched_clock
> >       0.09 =C2=B1  5%      -0.0        0.05 =C2=B1 46%  perf-profile.ch=
ildren.cycles-pp.__mod_lruvec_page_state
> >       0.11 =C2=B1  9%      -0.0        0.08 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_inet_skb_msgname
> >       0.10 =C2=B1  8%      -0.0        0.06        perf-profile.childre=
n.cycles-pp.tick_nohz_idle_enter
> >       0.09 =C2=B1  7%      -0.0        0.06 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.os_xsave
> >       0.12 =C2=B1  9%      -0.0        0.09 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.resched_curr
> >       0.09 =C2=B1 10%      -0.0        0.06 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpevent_init
> >       0.14 =C2=B1 10%      -0.0        0.11 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.update_cfs_group
> >       0.09 =C2=B1 10%      -0.0        0.06 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpq_order
> >       0.08 =C2=B1 11%      -0.0        0.05 =C2=B1 44%  perf-profile.ch=
ildren.cycles-pp.perf_tp_event
> >       0.07 =C2=B1  5%      -0.0        0.04 =C2=B1 45%  perf-profile.ch=
ildren.cycles-pp._raw_spin_unlock_irqrestore
> >       0.10 =C2=B1  8%      -0.0        0.07 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.syscall_exit_to_user_mode_prepare
> >       0.07 =C2=B1 10%      -0.0        0.04 =C2=B1 45%  perf-profile.ch=
ildren.cycles-pp.__cgroup_account_cputime
> >       0.08 =C2=B1  6%      -0.0        0.06 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_tsnmap_check
> >       0.00            +0.1        0.06 =C2=B1  9%  perf-profile.childre=
n.cycles-pp.perf_mux_hrtimer_handler
> >       0.00            +0.1        0.07 =C2=B1 26%  perf-profile.childre=
n.cycles-pp.update_sd_lb_stats
> >       0.00            +0.1        0.08 =C2=B1 22%  perf-profile.childre=
n.cycles-pp.find_busiest_group
> >       0.01 =C2=B1223%      +0.1        0.09 =C2=B1 26%  perf-profile.ch=
ildren.cycles-pp.load_balance
> >       0.05 =C2=B1 46%      +0.1        0.13 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_get_af_specific
> >       0.00            +0.1        0.09 =C2=B1 14%  perf-profile.childre=
n.cycles-pp.lapic_next_deadline
> >       0.00            +0.1        0.09 =C2=B1 13%  perf-profile.childre=
n.cycles-pp.native_irq_return_iret
> >       0.00            +0.1        0.09 =C2=B1 39%  perf-profile.childre=
n.cycles-pp.tsc_verify_tsc_adjust
> >       0.00            +0.1        0.09 =C2=B1 31%  perf-profile.childre=
n.cycles-pp.calc_global_load_tick
> >       0.00            +0.1        0.10 =C2=B1 37%  perf-profile.childre=
n.cycles-pp.arch_cpu_idle_enter
> >       0.00            +0.1        0.10 =C2=B1 31%  perf-profile.childre=
n.cycles-pp._raw_spin_trylock
> >       0.00            +0.1        0.10 =C2=B1 25%  perf-profile.childre=
n.cycles-pp.arch_scale_freq_tick
> >       0.03 =C2=B1100%      +0.1        0.15 =C2=B1 35%  perf-profile.ch=
ildren.cycles-pp.rebalance_domains
> >       0.00            +0.1        0.14 =C2=B1 21%  perf-profile.childre=
n.cycles-pp.cgroup_rstat_updated
> >       0.17 =C2=B1 15%      +0.1        0.32 =C2=B1 19%  perf-profile.ch=
ildren.cycles-pp.scheduler_tick
> >       0.00            +0.2        0.16 =C2=B1 32%  perf-profile.childre=
n.cycles-pp.tick_nohz_irq_exit
> >       0.24 =C2=B1 11%      +0.2        0.42 =C2=B1 20%  perf-profile.ch=
ildren.cycles-pp.update_process_times
> >       0.24 =C2=B1 11%      +0.2        0.43 =C2=B1 20%  perf-profile.ch=
ildren.cycles-pp.tick_sched_handle
> >       0.09 =C2=B1 11%      +0.2        0.29 =C2=B1 28%  perf-profile.ch=
ildren.cycles-pp.__irq_exit_rcu
> >       0.53 =C2=B1  7%      +0.2        0.74 =C2=B1 16%  perf-profile.ch=
ildren.cycles-pp.ktime_get
> >       0.20 =C2=B1 10%      +0.2        0.42 =C2=B1 21%  perf-profile.ch=
ildren.cycles-pp.clockevents_program_event
> >       0.06 =C2=B1 13%      +0.3        0.31 =C2=B1 53%  perf-profile.ch=
ildren.cycles-pp.timekeeping_max_deferment
> >       0.00            +0.3        0.26 =C2=B1 12%  perf-profile.childre=
n.cycles-pp.propagate_protected_usage
> >       0.28 =C2=B1  8%      +0.3        0.54 =C2=B1 19%  perf-profile.ch=
ildren.cycles-pp.tick_sched_timer
> >       0.55 =C2=B1  7%      +0.3        0.84 =C2=B1 26%  perf-profile.ch=
ildren.cycles-pp.menu_select
> >       0.29 =C2=B1  7%      +0.3        0.58 =C2=B1 39%  perf-profile.ch=
ildren.cycles-pp.tick_nohz_get_sleep_length
> >       0.20 =C2=B1  8%      +0.3        0.50 =C2=B1 44%  perf-profile.ch=
ildren.cycles-pp.tick_nohz_next_event
> >       0.32 =C2=B1  6%      +0.3        0.66 =C2=B1 17%  perf-profile.ch=
ildren.cycles-pp.__hrtimer_run_queues
> >       0.00            +0.5        0.52 =C2=B1  6%  perf-profile.childre=
n.cycles-pp.mem_cgroup_uncharge_skmem
> >       0.56 =C2=B1  7%      +0.6        1.16 =C2=B1 17%  perf-profile.ch=
ildren.cycles-pp.hrtimer_interrupt
> >       0.56 =C2=B1  7%      +0.6        1.17 =C2=B1 17%  perf-profile.ch=
ildren.cycles-pp.__sysvec_apic_timer_interrupt
> >       0.00            +1.0        0.96 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.__mod_memcg_state
> >       0.72 =C2=B1  6%      +1.0        1.69 =C2=B1 20%  perf-profile.ch=
ildren.cycles-pp.sysvec_apic_timer_interrupt
> >       0.91 =C2=B1  6%      +1.1        2.05 =C2=B1 16%  perf-profile.ch=
ildren.cycles-pp.asm_sysvec_apic_timer_interrupt
> >       1.62 =C2=B1  9%      +1.3        2.96 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpevent_make_rcvmsg
> >      10.76 =C2=B1  7%      +1.8       12.59 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__local_bh_enable_ip
> >      10.64 =C2=B1  7%      +1.9       12.51 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.do_softirq
> >      10.41 =C2=B1  7%      +2.0       12.37 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.net_rx_action
> >      10.31 =C2=B1  7%      +2.0       12.30 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__napi_poll
> >      10.29 =C2=B1  7%      +2.0       12.30 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.process_backlog
> >      10.66 =C2=B1  7%      +2.1       12.73 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__softirqentry_text_start
> >      10.12 =C2=B1  7%      +2.1       12.20 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__netif_receive_skb_one_core
> >       0.00            +2.1        2.10 =C2=B1  6%  perf-profile.childre=
n.cycles-pp.page_counter_uncharge
> >       3.40 =C2=B1  7%      +2.1        5.54 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_skb_recv_datagram
> >       0.00            +2.1        2.14 =C2=B1  5%  perf-profile.childre=
n.cycles-pp.drain_stock
> >       9.89 =C2=B1  7%      +2.2       12.07 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.ip_local_deliver_finish
> >       9.87 =C2=B1  7%      +2.2       12.06 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.ip_protocol_deliver_rcu
> >       0.00            +2.2        2.20 =C2=B1  5%  perf-profile.childre=
n.cycles-pp.page_counter_try_charge
> >       9.80 =C2=B1  7%      +2.2       12.00 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_rcv
> >       0.00            +2.4        2.36 =C2=B1  6%  perf-profile.childre=
n.cycles-pp.refill_stock
> >      15.40 =C2=B1  6%      +2.8       18.21 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_recvmsg
> >       1.10 =C2=B1  8%      +2.8        3.94 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.native_queued_spin_lock_slowpath
> >      15.25 =C2=B1  6%      +2.9       18.12 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.inet_recvmsg
> >      15.36 =C2=B1  6%      +2.9       18.28 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.release_sock
> >       1.36 =C2=B1  7%      +3.0        4.35 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.lock_sock_nested
> >       1.25 =C2=B1  8%      +3.0        4.24 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp._raw_spin_lock_bh
> >      15.10 =C2=B1  6%      +3.0       18.11 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__release_sock
> >      15.04 =C2=B1  6%      +3.0       18.07 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_backlog_rcv
> >       0.62 =C2=B1  6%      +3.4        4.02 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_sf_eat_data_6_2
> >       0.00            +3.4        3.41 =C2=B1  6%  perf-profile.childre=
n.cycles-pp.try_charge_memcg
> >       0.49 =C2=B1  6%      +3.4        3.94 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_eat_data
> >      19.74 =C2=B1  6%      +3.7       23.44 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_assoc_bh_rcv
> >       3.40 =C2=B1  7%      +3.9        7.34 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_chunk_put
> >       0.00            +4.0        4.04 =C2=B1  6%  perf-profile.childre=
n.cycles-pp.mem_cgroup_charge_skmem
> >       2.92 =C2=B1  6%      +4.2        7.16 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_sack
> >       0.00            +4.3        4.29 =C2=B1  6%  perf-profile.childre=
n.cycles-pp.__sk_mem_raise_allocated
> >       0.00            +4.3        4.32 =C2=B1  6%  perf-profile.childre=
n.cycles-pp.__sk_mem_schedule
> >       1.99 =C2=B1  6%      +4.4        6.40 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.consume_skb
> >       1.78 =C2=B1  6%      +4.6        6.42 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.kfree_skb_reason
> >       0.37 =C2=B1  8%      +5.0        5.40 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_wfree
> >       0.87 =C2=B1  9%     +10.3       11.20 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.skb_release_head_state
> >       0.00           +10.7       10.66 =C2=B1  6%  perf-profile.childre=
n.cycles-pp.__sk_mem_reduce_allocated
> >       8.78 =C2=B1  6%      -3.2        5.58 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.copy_user_enhanced_fast_string
> >       8.70 =C2=B1  6%      -3.2        5.54 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.memcpy_erms
> >       0.96 =C2=B1  6%      -0.4        0.57 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__slab_free
> >       0.83 =C2=B1  7%      -0.3        0.54 =C2=B1  6%  perf-profile.se=
lf.cycles-pp._raw_spin_lock_irqsave
> >       0.70 =C2=B1  9%      -0.3        0.41 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.sctp_chunk_put
> >       0.83 =C2=B1  4%      -0.2        0.59 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.kmem_cache_free
> >       0.60 =C2=B1  6%      -0.2        0.36 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_recvmsg
> >       0.64 =C2=B1  5%      -0.2        0.41 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__might_resched
> >       0.57 =C2=B1  6%      -0.2        0.36 =C2=B1  8%  perf-profile.se=
lf.cycles-pp._raw_spin_lock_bh
> >       0.38 =C2=B1  7%      -0.2        0.16 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_sendmsg_to_asoc
> >       0.62 =C2=B1  6%      -0.2        0.40 =C2=B1  6%  perf-profile.se=
lf.cycles-pp._raw_spin_lock
> >       0.59 =C2=B1  7%      -0.2        0.39 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__schedule
> >       0.58 =C2=B1  6%      -0.2        0.39 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.copy_user_short_string
> >       0.50 =C2=B1 12%      -0.2        0.31 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_packet_config
> >       0.40 =C2=B1  8%      -0.2        0.23 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_packet_pack
> >       0.33 =C2=B1  8%      -0.2        0.16 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.rmqueue
> >       0.45 =C2=B1  3%      -0.2        0.29 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.kfree
> >       0.45 =C2=B1  8%      -0.2        0.29 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_datamsg_from_user
> >       0.32 =C2=B1  5%      -0.2        0.16 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.get_page_from_freelist
> >       0.37 =C2=B1  7%      -0.2        0.21 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__mod_node_page_state
> >       0.52 =C2=B1  7%      -0.2        0.36 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__list_del_entry_valid
> >       0.32 =C2=B1  6%      -0.2        0.16 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.__zone_watermark_ok
> >       0.41 =C2=B1  7%      -0.2        0.26 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.kmem_cache_alloc
> >       0.46 =C2=B1 17%      -0.1        0.31 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.__copy_skb_header
> >       0.35 =C2=B1  7%      -0.1        0.20 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.update_load_avg
> >       0.39 =C2=B1  5%      -0.1        0.25 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_outq_flush_data
> >       0.37 =C2=B1  7%      -0.1        0.23 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.update_rq_clock
> >       0.37 =C2=B1  6%      -0.1        0.24 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__skb_datagram_iter
> >       0.23 =C2=B1 13%      -0.1        0.10 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.sctp_assoc_rwnd_increase
> >       0.38 =C2=B1  6%      -0.1        0.25 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.sctp_sendmsg
> >       0.35 =C2=B1  5%      -0.1        0.22 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.memset_erms
> >       0.37 =C2=B1  5%      -0.1        0.24 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.set_next_entity
> >       0.37 =C2=B1  6%      -0.1        0.24 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.skb_release_data
> >       0.36 =C2=B1 13%      -0.1        0.23 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.entry_SYSCALL_64_after_hwframe
> >       0.35 =C2=B1  5%      -0.1        0.22 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.check_heap_object
> >       0.31 =C2=B1  6%      -0.1        0.18 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.__rhashtable_lookup
> >       0.34 =C2=B1  7%      -0.1        0.22 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.memcg_slab_free_hook
> >       0.34 =C2=B1  5%      -0.1        0.22 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.free_pcp_prepare
> >       0.32 =C2=B1  8%      -0.1        0.20 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__virt_addr_valid
> >       0.25 =C2=B1  7%      -0.1        0.13 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.free_unref_page_commit
> >       0.39 =C2=B1  6%      -0.1        0.28 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.enqueue_entity
> >       0.32 =C2=B1  6%      -0.1        0.20 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__list_add_valid
> >       0.30 =C2=B1 13%      -0.1        0.18 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_v4_xmit
> >       0.32 =C2=B1  7%      -0.1        0.20 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__alloc_skb
> >       0.33 =C2=B1  5%      -0.1        0.22 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__fdget
> >       0.30 =C2=B1  6%      -0.1        0.19 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_association_put
> >       0.31 =C2=B1  5%      -0.1        0.20 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__might_sleep
> >       0.21 =C2=B1 18%      -0.1        0.10 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.dst_release
> >       0.26 =C2=B1 13%      -0.1        0.15 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.ipv4_dst_check
> >       0.31 =C2=B1  6%      -0.1        0.21 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_skb_recv_datagram
> >       0.26 =C2=B1  9%      -0.1        0.16 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.sctp_cmd_interpreter
> >       0.21 =C2=B1  6%      -0.1        0.11 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.sock_wfree
> >       0.23 =C2=B1  7%      -0.1        0.13 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__alloc_pages
> >       0.31 =C2=B1  6%      -0.1        0.21 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.kmem_cache_alloc_node
> >       0.24 =C2=B1  5%      -0.1        0.14 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.__check_object_size
> >       0.17 =C2=B1  7%      -0.1        0.07 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.update_curr
> >       0.18 =C2=B1 36%      -0.1        0.08 =C2=B1 20%  perf-profile.se=
lf.cycles-pp.sctp_cmp_addr_exact
> >       0.31 =C2=B1  6%      -0.1        0.22 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.enqueue_task_fair
> >       0.27 =C2=B1  5%      -0.1        0.18 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.send_sctp_stream_1toMany
> >       0.27 =C2=B1  8%      -0.1        0.18 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.entry_SYSRETQ_unsafe_stack
> >       0.29 =C2=B1  6%      -0.1        0.20 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.skb_set_owner_w
> >       0.26 =C2=B1 10%      -0.1        0.17 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_transport_hold
> >       0.21 =C2=B1 10%      -0.1        0.12 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.recv_sctp_stream_1toMany
> >       0.24 =C2=B1  7%      -0.1        0.15 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__switch_to
> >       0.25 =C2=B1 12%      -0.1        0.17 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.sctp_rcv
> >       0.24 =C2=B1  4%      -0.1        0.16 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.__entry_text_start
> >       0.28 =C2=B1 12%      -0.1        0.20 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.sctp_transport_put
> >       0.20 =C2=B1  5%      -0.1        0.11 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__wake_up_common
> >       0.22 =C2=B1  6%      -0.1        0.14 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__switch_to_asm
> >       0.22 =C2=B1  5%      -0.1        0.14 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.consume_skb
> >       0.21 =C2=B1  7%      -0.1        0.13 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.recvmsg
> >       0.20 =C2=B1  6%      -0.1        0.13 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.reweight_entity
> >       0.21 =C2=B1  6%      -0.1        0.14 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.sctp_datamsg_put
> >       0.20 =C2=B1  4%      -0.1        0.13 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.available_idle_cpu
> >       0.20 =C2=B1  6%      -0.1        0.12 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__free_pages
> >       0.10 =C2=B1 16%      -0.1        0.02 =C2=B1 99%  perf-profile.se=
lf.cycles-pp.sctp_ulpq_tail_data
> >       0.16 =C2=B1  9%      -0.1        0.09 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.____sys_recvmsg
> >       0.28 =C2=B1  9%      -0.1        0.21 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.aa_sk_perm
> >       0.18 =C2=B1  8%      -0.1        0.11 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.syscall_return_via_sysret
> >       0.10 =C2=B1  9%      -0.1        0.03 =C2=B1100%  perf-profile.se=
lf.cycles-pp.process_backlog
> >       0.20 =C2=B1  7%      -0.1        0.14 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_association_hold
> >       0.20 =C2=B1  7%      -0.1        0.13 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_hash_cmp
> >       0.22 =C2=B1  8%      -0.1        0.16 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.sctp_wfree
> >       0.18 =C2=B1  7%      -0.1        0.11 =C2=B1  6%  perf-profile.se=
lf.cycles-pp._copy_from_user
> >       0.17 =C2=B1  8%      -0.1        0.10 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.poll_idle
> >       0.16 =C2=B1  8%      -0.1        0.09 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.__update_load_avg_cfs_rq
> >       0.19 =C2=B1  6%      -0.1        0.13 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.__update_load_avg_se
> >       0.14 =C2=B1  7%      -0.1        0.08 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.___perf_sw_event
> >       0.16 =C2=B1  8%      -0.1        0.10 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.try_to_wake_up
> >       0.16 =C2=B1  5%      -0.1        0.10 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.sctp_packet_append_chunk
> >       0.20 =C2=B1  8%      -0.1        0.14 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.sendmsg
> >       0.14 =C2=B1 12%      -0.1        0.08 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.check_new_pages
> >       0.17 =C2=B1 11%      -0.1        0.11 =C2=B1 15%  perf-profile.se=
lf.cycles-pp.sctp_outq_flush
> >       0.17 =C2=B1  8%      -0.1        0.11 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_assoc_bh_rcv
> >       0.17 =C2=B1  6%      -0.1        0.11 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.nr_iowait_cpu
> >       0.17 =C2=B1  7%      -0.1        0.12 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_packet_transmit
> >       0.12 =C2=B1  9%      -0.1        0.06 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.dequeue_entity
> >       0.15 =C2=B1  8%      -0.1        0.10 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.____sys_sendmsg
> >       0.15 =C2=B1 14%      -0.1        0.10 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_ulpevent_free
> >       0.18 =C2=B1  9%      -0.1        0.12 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.sctp_do_sm
> >       0.14 =C2=B1  4%      -0.1        0.09 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.__genradix_ptr
> >       0.13 =C2=B1 10%      -0.1        0.08 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__put_user_nocheck_4
> >       0.15 =C2=B1  7%      -0.1        0.10 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__copy_msghdr_from_user
> >       0.13 =C2=B1 10%      -0.1        0.08 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.__import_iovec
> >       0.16 =C2=B1  4%      -0.0        0.11 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.__skb_clone
> >       0.16 =C2=B1  8%      -0.0        0.11 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.sctp_sendmsg_parse
> >       0.13 =C2=B1  6%      -0.0        0.08 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.do_syscall_64
> >       0.17 =C2=B1  6%      -0.0        0.12 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.do_idle
> >       0.12 =C2=B1 17%      -0.0        0.07 =C2=B1 18%  perf-profile.se=
lf.cycles-pp.sctp_hash_key
> >       0.14 =C2=B1  9%      -0.0        0.09 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_check_transmitted
> >       0.13 =C2=B1  5%      -0.0        0.08 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sock_kmalloc
> >       0.11 =C2=B1  6%      -0.0        0.06 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_sock_rfree
> >       0.11 =C2=B1  6%      -0.0        0.07 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__kmalloc_node_track_caller
> >       0.12 =C2=B1  9%      -0.0        0.07 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.___sys_recvmsg
> >       0.14 =C2=B1  8%      -0.0        0.09 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.switch_mm_irqs_off
> >       0.07 =C2=B1 10%      -0.0        0.03 =C2=B1100%  perf-profile.se=
lf.cycles-pp._sctp_make_chunk
> >       0.22 =C2=B1  8%      -0.0        0.18 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.read_tsc
> >       0.12 =C2=B1  5%      -0.0        0.07 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__put_user_nocheck_8
> >       0.13 =C2=B1  8%      -0.0        0.08 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_inq_pop
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__check_heap_object
> >       0.12 =C2=B1  4%      -0.0        0.08 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.__kmalloc
> >       0.08 =C2=B1  8%      -0.0        0.04 =C2=B1 71%  perf-profile.se=
lf.cycles-pp.__mod_lruvec_page_state
> >       0.12 =C2=B1  8%      -0.0        0.08 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__local_bh_enable_ip
> >       0.12 =C2=B1  7%      -0.0        0.08 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_sf_eat_data_6_2
> >       0.12 =C2=B1  6%      -0.0        0.07 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.__free_pages_ok
> >       0.11 =C2=B1  8%      -0.0        0.07 =C2=B1  7%  perf-profile.se=
lf.cycles-pp._copy_to_iter
> >       0.11 =C2=B1  6%      -0.0        0.06 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__ip_queue_xmit
> >       0.08 =C2=B1 10%      -0.0        0.03 =C2=B1 70%  perf-profile.se=
lf.cycles-pp.__wrgsbase_inactive
> >       0.13 =C2=B1  8%      -0.0        0.09 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.pick_next_entity
> >       0.11 =C2=B1  8%      -0.0        0.07 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.select_task_rq
> >       0.11 =C2=B1  7%      -0.0        0.07 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_inet_skb_msgname
> >       0.10 =C2=B1  9%      -0.0        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_outq_sack
> >       0.08 =C2=B1  5%      -0.0        0.05 =C2=B1 45%  perf-profile.se=
lf.cycles-pp.__netif_receive_skb_core
> >       0.20 =C2=B1  8%      -0.0        0.16 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.native_sched_clock
> >       0.12 =C2=B1  9%      -0.0        0.08 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.memcg_slab_post_alloc_hook
> >       0.10 =C2=B1  7%      -0.0        0.06 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.__cond_resched
> >       0.12 =C2=B1  4%      -0.0        0.08 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.kmem_cache_alloc_trace
> >       0.10 =C2=B1  5%      -0.0        0.06 =C2=B1 15%  perf-profile.se=
lf.cycles-pp.check_stack_object
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_outq_tail
> >       0.12 =C2=B1  8%      -0.0        0.08 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.sctp_chunk_abandoned
> >       0.10 =C2=B1  4%      -0.0        0.06 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.iovec_from_user
> >       0.09 =C2=B1  7%      -0.0        0.06 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.os_xsave
> >       0.13 =C2=B1  7%      -0.0        0.09 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_sched_dequeue_common
> >       0.07 =C2=B1 11%      -0.0        0.04 =C2=B1 71%  perf-profile.se=
lf.cycles-pp.move_addr_to_kernel
> >       0.09 =C2=B1 10%      -0.0        0.05 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_ulpevent_init
> >       0.08 =C2=B1 10%      -0.0        0.05 =C2=B1 45%  perf-profile.se=
lf.cycles-pp.free_unref_page
> >       0.10 =C2=B1  5%      -0.0        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.__might_fault
> >       0.11 =C2=B1 12%      -0.0        0.08 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.__sctp_packet_append_chunk
> >       0.07 =C2=B1 11%      -0.0        0.03 =C2=B1 70%  perf-profile.se=
lf.cycles-pp.sockfd_lookup_light
> >       0.11 =C2=B1  7%      -0.0        0.08 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.cpuidle_idle_call
> >       0.12 =C2=B1  7%      -0.0        0.09 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.ip_finish_output2
> >       0.12 =C2=B1  8%      -0.0        0.09 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.resched_curr
> >       0.10 =C2=B1  5%      -0.0        0.07 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.skb_put
> >       0.09 =C2=B1  7%      -0.0        0.06 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_outq_select_transport
> >       0.08 =C2=B1  6%      -0.0        0.04 =C2=B1 45%  perf-profile.se=
lf.cycles-pp.__sys_recvmsg
> >       0.08 =C2=B1  5%      -0.0        0.05 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sock_kfree_s
> >       0.10 =C2=B1  5%      -0.0        0.07 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.net_rx_action
> >       0.09 =C2=B1  8%      -0.0        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_chunkify
> >       0.10 =C2=B1  9%      -0.0        0.07 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.syscall_exit_to_user_mode_prepare
> >       0.14 =C2=B1 10%      -0.0        0.11 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.update_cfs_group
> >       0.09 =C2=B1  8%      -0.0        0.06 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.security_socket_recvmsg
> >       0.08 =C2=B1  9%      -0.0        0.05        perf-profile.self.cy=
cles-pp.rcu_all_qs
> >       0.07 =C2=B1  9%      -0.0        0.04 =C2=B1 45%  perf-profile.se=
lf.cycles-pp.sctp_tsnmap_check
> >       0.08 =C2=B1 11%      -0.0        0.06 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.sctp_addto_chunk
> >       0.08 =C2=B1 10%      -0.0        0.06 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.kmalloc_large_node
> >       0.10 =C2=B1  8%      +0.0        0.12 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.lock_sock_nested
> >       0.00            +0.1        0.06 =C2=B1  9%  perf-profile.self.cy=
cles-pp.mem_cgroup_uncharge_skmem
> >       0.00            +0.1        0.08 =C2=B1 11%  perf-profile.self.cy=
cles-pp.lapic_next_deadline
> >       0.00            +0.1        0.09 =C2=B1 13%  perf-profile.self.cy=
cles-pp.native_irq_return_iret
> >       0.04 =C2=B1 71%      +0.1        0.12 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_get_af_specific
> >       0.00            +0.1        0.09 =C2=B1 41%  perf-profile.self.cy=
cles-pp.tsc_verify_tsc_adjust
> >       0.00            +0.1        0.09 =C2=B1 31%  perf-profile.self.cy=
cles-pp.calc_global_load_tick
> >       0.00            +0.1        0.10 =C2=B1 31%  perf-profile.self.cy=
cles-pp._raw_spin_trylock
> >       0.01 =C2=B1223%      +0.1        0.10 =C2=B1 50%  perf-profile.se=
lf.cycles-pp.tick_nohz_next_event
> >       0.11 =C2=B1  9%      +0.1        0.21 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.cpuidle_enter_state
> >       0.00            +0.1        0.10 =C2=B1 25%  perf-profile.self.cy=
cles-pp.arch_scale_freq_tick
> >       0.00            +0.1        0.13 =C2=B1 19%  perf-profile.self.cy=
cles-pp.cgroup_rstat_updated
> >       0.00            +0.1        0.14 =C2=B1 10%  perf-profile.self.cy=
cles-pp.mem_cgroup_charge_skmem
> >       0.00            +0.2        0.21 =C2=B1  8%  perf-profile.self.cy=
cles-pp.refill_stock
> >       0.00            +0.2        0.25 =C2=B1  9%  perf-profile.self.cy=
cles-pp.__sk_mem_raise_allocated
> >       0.31 =C2=B1  8%      +0.3        0.56 =C2=B1 23%  perf-profile.se=
lf.cycles-pp.ktime_get
> >       0.06 =C2=B1 13%      +0.3        0.31 =C2=B1 53%  perf-profile.se=
lf.cycles-pp.timekeeping_max_deferment
> >       0.00            +0.3        0.26 =C2=B1 11%  perf-profile.self.cy=
cles-pp.propagate_protected_usage
> >       0.00            +0.8        0.82 =C2=B1  3%  perf-profile.self.cy=
cles-pp.__mod_memcg_state
> >       0.00            +1.2        1.19 =C2=B1  7%  perf-profile.self.cy=
cles-pp.try_charge_memcg
> >       0.00            +2.0        1.96 =C2=B1  6%  perf-profile.self.cy=
cles-pp.page_counter_uncharge
> >       0.00            +2.1        2.07 =C2=B1  5%  perf-profile.self.cy=
cles-pp.page_counter_try_charge
> >       1.09 =C2=B1  8%      +2.8        3.92 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.native_queued_spin_lock_slowpath
> >       0.29 =C2=B1  6%      +3.5        3.81 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_eat_data
> >       0.00            +7.8        7.76 =C2=B1  6%  perf-profile.self.cy=
cles-pp.__sk_mem_reduce_allocated
> >
> >
> > ***********************************************************************=
****************************
> > lkp-cpl-4sp1: 144 threads 4 sockets Intel(R) Xeon(R) Gold 5318H CPU @ 2=
.50GHz with 128G memory
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/=
send_size/tbox_group/test/testcase/ucode:
> >   cs-localhost/gcc-11/performance/ipv4/x86_64-rhel-8.3/50%/debian-11.1-=
x86_64-20220510.cgz/300s/10K/lkp-cpl-4sp1/SCTP_STREAM_MANY/netperf/0x700240=
2
> >
> > commit:
> >   7c80b038d2 ("net: fix sk_wmem_schedule() and sk_rmem_schedule() error=
s")
> >   4890b686f4 ("net: keep sk->sk_forward_alloc as small as possible")
> >
> > 7c80b038d23e1f4c 4890b686f4088c90432149bd6de
> > ---------------- ---------------------------
> >          %stddev     %change         %stddev
> >              \          |                \
> >       9985           -73.7%       2624        netperf.Throughput_Mbps
> >     718950           -73.7%     188942        netperf.Throughput_total_=
Mbps
> >      68186           -71.8%      19239 =C2=B1  2%  netperf.time.involun=
tary_context_switches
> >      29139 =C2=B1  2%     -16.8%      24247        netperf.time.minor_p=
age_faults
> >       3137           -68.1%       1000        netperf.time.percent_of_c=
pu_this_job_got
> >       9264           -67.8%       2979        netperf.time.system_time
> >     199.50           -77.7%      44.44 =C2=B1  2%  netperf.time.user_ti=
me
> >     316769 =C2=B1  2%     +21.5%     384840        netperf.time.volunta=
ry_context_switches
> >  2.633e+09           -73.7%  6.919e+08        netperf.workload
> >      29358           +42.4%      41821        uptime.idle
> >  2.381e+10           +52.8%  3.639e+10        cpuidle..time
> >  7.884e+08           -65.8%  2.694e+08        cpuidle..usage
> >      56.10           +27.9       83.96        mpstat.cpu.all.idle%
> >       0.80            -0.2        0.61 =C2=B1  5%  mpstat.cpu.all.irq%
> >       7.50            -4.2        3.29        mpstat.cpu.all.soft%
> >      34.45           -22.6       11.86        mpstat.cpu.all.sys%
> >       1.14            -0.9        0.27        mpstat.cpu.all.usr%
> >      55.83           +49.3%      83.33        vmstat.cpu.id
> >    5727924 =C2=B1  3%     -43.6%    3229130        vmstat.memory.cache
> >      64.67 =C2=B1  2%     -65.2%      22.50 =C2=B1  2%  vmstat.procs.r
> >    4915230           -73.6%    1295498        vmstat.system.cs
> >     298596            -3.1%     289395        vmstat.system.in
> >      92833 =C2=B1101%     -63.0%      34380 =C2=B1 35%  numa-meminfo.no=
de1.Inactive
> >      92773 =C2=B1101%     -62.9%      34380 =C2=B1 35%  numa-meminfo.no=
de1.Inactive(anon)
> >    1468231 =C2=B1 19%     -74.4%     376377 =C2=B1 16%  numa-meminfo.no=
de3.Active
> >    1468231 =C2=B1 19%     -74.4%     376377 =C2=B1 16%  numa-meminfo.no=
de3.Active(anon)
> >     925228 =C2=B1 17%     -95.4%      42887 =C2=B1 27%  numa-meminfo.no=
de3.Inactive
> >     925228 =C2=B1 17%     -95.4%      42887 =C2=B1 27%  numa-meminfo.no=
de3.Inactive(anon)
> >    1162413 =C2=B1 17%     -85.6%     167082 =C2=B1 21%  numa-meminfo.no=
de3.Mapped
> >    2348690 =C2=B1 14%     -83.8%     380889 =C2=B1 16%  numa-meminfo.no=
de3.Shmem
> >  8.422e+08           -72.9%  2.286e+08 =C2=B1  5%  numa-numastat.node0.=
local_node
> >  8.425e+08           -72.8%  2.288e+08 =C2=B1  5%  numa-numastat.node0.=
numa_hit
> >  8.344e+08           -73.3%  2.226e+08 =C2=B1  5%  numa-numastat.node1.=
local_node
> >  8.341e+08           -73.3%  2.227e+08 =C2=B1  5%  numa-numastat.node1.=
numa_hit
> >  8.584e+08           -74.8%  2.163e+08 =C2=B1 10%  numa-numastat.node2.=
local_node
> >  8.583e+08           -74.8%  2.164e+08 =C2=B1 10%  numa-numastat.node2.=
numa_hit
> >  8.684e+08           -74.1%  2.251e+08 =C2=B1  6%  numa-numastat.node3.=
local_node
> >  8.681e+08           -74.1%  2.252e+08 =C2=B1  6%  numa-numastat.node3.=
numa_hit
> >    1860369 =C2=B1  5%     -76.2%     442423 =C2=B1  3%  meminfo.Active
> >    1860257 =C2=B1  5%     -76.2%     442314 =C2=B1  3%  meminfo.Active(=
anon)
> >    5599254 =C2=B1  3%     -44.7%    3099170        meminfo.Cached
> >    3542743 =C2=B1  6%     -71.5%    1010644        meminfo.Committed_AS
> >    1423628 =C2=B1 11%     -76.4%     336110        meminfo.Inactive
> >    1423448 =C2=B1 11%     -76.4%     335928        meminfo.Inactive(ano=
n)
> >    1453354 =C2=B1  6%     -83.5%     240203 =C2=B1  3%  meminfo.Mapped
> >    7494321 =C2=B1  2%     -34.5%    4912267        meminfo.Memused
> >      12458           -18.9%      10104        meminfo.PageTables
> >    2948963 =C2=B1  7%     -84.8%     449291 =C2=B1  3%  meminfo.Shmem
> >   11063817           -30.5%    7685444        meminfo.max_used_kB
> >  8.425e+08           -72.8%  2.288e+08 =C2=B1  5%  numa-vmstat.node0.nu=
ma_hit
> >  8.422e+08           -72.9%  2.286e+08 =C2=B1  5%  numa-vmstat.node0.nu=
ma_local
> >      23213 =C2=B1101%     -63.0%       8583 =C2=B1 35%  numa-vmstat.nod=
e1.nr_inactive_anon
> >      23213 =C2=B1101%     -63.0%       8583 =C2=B1 35%  numa-vmstat.nod=
e1.nr_zone_inactive_anon
> >  8.341e+08           -73.3%  2.227e+08 =C2=B1  5%  numa-vmstat.node1.nu=
ma_hit
> >  8.344e+08           -73.3%  2.226e+08 =C2=B1  5%  numa-vmstat.node1.nu=
ma_local
> >  8.583e+08           -74.8%  2.164e+08 =C2=B1 10%  numa-vmstat.node2.nu=
ma_hit
> >  8.584e+08           -74.8%  2.163e+08 =C2=B1 10%  numa-vmstat.node2.nu=
ma_local
> >     366556 =C2=B1 19%     -74.2%      94616 =C2=B1 16%  numa-vmstat.nod=
e3.nr_active_anon
> >     231387 =C2=B1 17%     -95.4%      10658 =C2=B1 27%  numa-vmstat.nod=
e3.nr_inactive_anon
> >     291532 =C2=B1 17%     -86.8%      38558 =C2=B1 21%  numa-vmstat.nod=
e3.nr_mapped
> >     586771 =C2=B1 14%     -83.7%      95702 =C2=B1 16%  numa-vmstat.nod=
e3.nr_shmem
> >     366556 =C2=B1 19%     -74.2%      94616 =C2=B1 16%  numa-vmstat.nod=
e3.nr_zone_active_anon
> >     231387 =C2=B1 17%     -95.4%      10658 =C2=B1 27%  numa-vmstat.nod=
e3.nr_zone_inactive_anon
> >  8.681e+08           -74.1%  2.252e+08 =C2=B1  6%  numa-vmstat.node3.nu=
ma_hit
> >  8.684e+08           -74.1%  2.251e+08 =C2=B1  6%  numa-vmstat.node3.nu=
ma_local
> >       1495           -61.8%     571.00        turbostat.Avg_MHz
> >      47.16           -29.8       17.36        turbostat.Busy%
> >       3178            +3.7%       3295        turbostat.Bzy_MHz
> >  7.464e+08           -73.4%  1.985e+08        turbostat.C1
> >      13.74            -8.9        4.80 =C2=B1  2%  turbostat.C1%
> >   34154266 =C2=B1 14%     +97.4%   67405025        turbostat.C1E
> >      36.80 =C2=B1 21%     +37.1       73.90 =C2=B1  3%  turbostat.C1E%
> >      52.81           +56.4%      82.60        turbostat.CPU%c1
> >      58.83 =C2=B1  2%     -20.1%      47.00 =C2=B1  2%  turbostat.CoreT=
mp
> >       0.20           -25.6%       0.15        turbostat.IPC
> >     128.56 =C2=B1  3%    -128.6        0.00        turbostat.PKG_%
> >    5447540 =C2=B1  3%     -83.7%     887322        turbostat.POLL
> >       0.13            -0.1        0.03        turbostat.POLL%
> >      58.83 =C2=B1  2%     -19.8%      47.17 =C2=B1  2%  turbostat.PkgTm=
p
> >     591.77           -28.1%     425.61        turbostat.PkgWatt
> >       8.17            +3.5%       8.46        turbostat.RAMWatt
> >     465173 =C2=B1  5%     -76.3%     110436 =C2=B1  3%  proc-vmstat.nr_=
active_anon
> >      83691            -1.7%      82260        proc-vmstat.nr_anon_pages
> >    3086038            +2.1%    3150528        proc-vmstat.nr_dirty_back=
ground_threshold
> >    6179622            +2.1%    6308761        proc-vmstat.nr_dirty_thre=
shold
> >    1399831 =C2=B1  3%     -44.7%     774653        proc-vmstat.nr_file_=
pages
> >   31038779            +2.1%   31684629        proc-vmstat.nr_free_pages
> >     355768 =C2=B1 11%     -76.4%      83981        proc-vmstat.nr_inact=
ive_anon
> >     363110 =C2=B1  6%     -83.4%      60381 =C2=B1  3%  proc-vmstat.nr_=
mapped
> >       3114           -18.9%       2526        proc-vmstat.nr_page_table=
_pages
> >     737257 =C2=B1  7%     -84.8%     112182 =C2=B1  3%  proc-vmstat.nr_=
shmem
> >      33546            -3.9%      32233        proc-vmstat.nr_slab_recla=
imable
> >     465173 =C2=B1  5%     -76.3%     110436 =C2=B1  3%  proc-vmstat.nr_=
zone_active_anon
> >     355768 =C2=B1 11%     -76.4%      83981        proc-vmstat.nr_zone_=
inactive_anon
> >     125868 =C2=B1 15%     -29.5%      88747 =C2=B1 12%  proc-vmstat.num=
a_hint_faults_local
> >  3.403e+09           -73.8%   8.93e+08        proc-vmstat.numa_hit
> >  3.403e+09           -73.8%  8.927e+08        proc-vmstat.numa_local
> >    1698265 =C2=B1  8%     -91.3%     146940 =C2=B1  2%  proc-vmstat.pga=
ctivate
> >  9.031e+09           -73.7%  2.375e+09        proc-vmstat.pgalloc_norma=
l
> >    1809374 =C2=B1  2%     -11.5%    1601059 =C2=B1  2%  proc-vmstat.pgf=
ault
> >  9.031e+09           -73.7%  2.375e+09        proc-vmstat.pgfree
> >      40961            +1.3%      41503        proc-vmstat.pgreuse
> >     121388 =C2=B1 29%     -96.2%       4632 =C2=B1 47%  sched_debug.cfs=
_rq:/.MIN_vruntime.avg
> >    3776647 =C2=B1 10%     -91.9%     305894 =C2=B1 40%  sched_debug.cfs=
_rq:/.MIN_vruntime.max
> >     623786 =C2=B1 18%     -94.3%      35468 =C2=B1 44%  sched_debug.cfs=
_rq:/.MIN_vruntime.stddev
> >       0.40 =C2=B1  7%     -58.4%       0.17 =C2=B1  7%  sched_debug.cfs=
_rq:/.h_nr_running.avg
> >       0.45           -19.1%       0.37 =C2=B1  3%  sched_debug.cfs_rq:/=
.h_nr_running.stddev
> >     121388 =C2=B1 29%     -96.2%       4632 =C2=B1 47%  sched_debug.cfs=
_rq:/.max_vruntime.avg
> >    3776647 =C2=B1 10%     -91.9%     305894 =C2=B1 40%  sched_debug.cfs=
_rq:/.max_vruntime.max
> >     623786 =C2=B1 18%     -94.3%      35468 =C2=B1 44%  sched_debug.cfs=
_rq:/.max_vruntime.stddev
> >    3455794 =C2=B1  6%     -89.2%     374393 =C2=B1  9%  sched_debug.cfs=
_rq:/.min_vruntime.avg
> >    4153720 =C2=B1  7%     -88.1%     494762 =C2=B1  7%  sched_debug.cfs=
_rq:/.min_vruntime.max
> >    2710531 =C2=B1  7%     -91.1%     240412 =C2=B1 10%  sched_debug.cfs=
_rq:/.min_vruntime.min
> >     368488 =C2=B1  8%     -85.9%      51911 =C2=B1 13%  sched_debug.cfs=
_rq:/.min_vruntime.stddev
> >       0.40 =C2=B1  7%     -58.4%       0.17 =C2=B1  7%  sched_debug.cfs=
_rq:/.nr_running.avg
> >       0.45           -19.2%       0.37 =C2=B1  3%  sched_debug.cfs_rq:/=
.nr_running.stddev
> >     386.20 =C2=B1  3%     -56.3%     168.94        sched_debug.cfs_rq:/=
.runnable_avg.avg
> >       1215 =C2=B1  8%     -18.7%     987.82 =C2=B1  4%  sched_debug.cfs=
_rq:/.runnable_avg.max
> >     340.61           -31.1%     234.69 =C2=B1  2%  sched_debug.cfs_rq:/=
.runnable_avg.stddev
> >     429174 =C2=B1 24%    -103.8%     -16476        sched_debug.cfs_rq:/=
.spread0.avg
> >    1127012 =C2=B1 15%     -90.8%     103881 =C2=B1 28%  sched_debug.cfs=
_rq:/.spread0.max
> >    -315952           -52.4%    -150458        sched_debug.cfs_rq:/.spre=
ad0.min
> >     368407 =C2=B1  8%     -85.9%      51908 =C2=B1 13%  sched_debug.cfs=
_rq:/.spread0.stddev
> >     385.96 =C2=B1  3%     -56.3%     168.81        sched_debug.cfs_rq:/=
.util_avg.avg
> >       1215 =C2=B1  8%     -18.7%     987.79 =C2=B1  4%  sched_debug.cfs=
_rq:/.util_avg.max
> >     340.53           -31.1%     234.60 =C2=B1  2%  sched_debug.cfs_rq:/=
.util_avg.stddev
> >     274.31 =C2=B1  7%     -74.9%      68.97 =C2=B1  5%  sched_debug.cfs=
_rq:/.util_est_enqueued.avg
> >     981.12           -10.6%     877.51 =C2=B1  3%  sched_debug.cfs_rq:/=
.util_est_enqueued.max
> >     337.06           -47.8%     176.03 =C2=B1  3%  sched_debug.cfs_rq:/=
.util_est_enqueued.stddev
> >     457832 =C2=B1  5%     +41.2%     646422 =C2=B1  5%  sched_debug.cpu=
.avg_idle.avg
> >       1762 =C2=B1  7%     -42.8%       1009 =C2=B1  7%  sched_debug.cpu=
.clock_task.stddev
> >       2358 =C2=B1  5%     -61.0%     920.92 =C2=B1  2%  sched_debug.cpu=
.curr->pid.avg
> >       2793           -22.1%       2176 =C2=B1  2%  sched_debug.cpu.curr=
->pid.stddev
> >     557670 =C2=B1  6%      +8.4%     604409 =C2=B1  7%  sched_debug.cpu=
.max_idle_balance_cost.max
> >       0.00 =C2=B1  2%     -27.5%       0.00 =C2=B1  5%  sched_debug.cpu=
.next_balance.stddev
> >       0.39 =C2=B1  5%     -61.1%       0.15 =C2=B1  3%  sched_debug.cpu=
.nr_running.avg
> >       0.45           -22.2%       0.35        sched_debug.cpu.nr_runnin=
g.stddev
> >    5005510 =C2=B1  7%     -75.6%    1221805 =C2=B1 10%  sched_debug.cpu=
.nr_switches.avg
> >    6928957 =C2=B1  8%     -70.7%    2030568 =C2=B1  9%  sched_debug.cpu=
.nr_switches.max
> >    3447354 =C2=B1 12%     -84.3%     541402 =C2=B1 17%  sched_debug.cpu=
.nr_switches.min
> >     629520 =C2=B1  7%     -55.8%     278525 =C2=B1  6%  sched_debug.cpu=
.nr_switches.stddev
> >  3.074e+10           -71.6%  8.745e+09        perf-stat.i.branch-instru=
ctions
> >  2.971e+08 =C2=B1  2%     -70.3%   88205513 =C2=B1  4%  perf-stat.i.bra=
nch-misses
> >       1.05 =C2=B1  3%      +5.6        6.66        perf-stat.i.cache-mi=
ss-rate%
> >   30824055 =C2=B1  3%     +98.8%   61267408        perf-stat.i.cache-mi=
sses
> >  3.297e+09           -71.8%  9.296e+08        perf-stat.i.cache-referen=
ces
> >    4957450           -73.6%    1308421        perf-stat.i.context-switc=
hes
> >       1.43           +33.1%       1.90        perf-stat.i.cpi
> >  2.196e+11           -62.4%  8.259e+10        perf-stat.i.cpu-cycles
> >     929.67           -64.3%     331.55        perf-stat.i.cpu-migration=
s
> >       7494 =C2=B1  4%     -82.0%       1351        perf-stat.i.cycles-b=
etween-cache-misses
> >       0.01 =C2=B1 26%      -0.0        0.00        perf-stat.i.dTLB-loa=
d-miss-rate%
> >    2694006 =C2=B1 27%     -90.1%     265691        perf-stat.i.dTLB-loa=
d-misses
> >  4.398e+10           -71.5%  1.252e+10        perf-stat.i.dTLB-loads
> >       0.00 =C2=B1  7%      -0.0        0.00 =C2=B1  5%  perf-stat.i.dTL=
B-store-miss-rate%
> >     967059 =C2=B1  8%     -84.3%     151835 =C2=B1  6%  perf-stat.i.dTL=
B-store-misses
> >  2.599e+10           -71.6%  7.377e+09        perf-stat.i.dTLB-stores
> >      63.87           +10.9       74.76        perf-stat.i.iTLB-load-mis=
s-rate%
> >  1.972e+08           -70.5%   58088811 =C2=B1  5%  perf-stat.i.iTLB-loa=
d-misses
> >  1.126e+08           -82.7%   19440392        perf-stat.i.iTLB-loads
> >  1.538e+11           -71.5%   4.38e+10        perf-stat.i.instructions
> >       0.71           -24.8%       0.53        perf-stat.i.ipc
> >       1.53           -62.4%       0.57        perf-stat.i.metric.GHz
> >     909.37           -69.9%     273.61        perf-stat.i.metric.K/sec
> >     722.30           -71.6%     205.33        perf-stat.i.metric.M/sec
> >       5562 =C2=B1  3%     -12.4%       4874 =C2=B1  2%  perf-stat.i.min=
or-faults
> >    8844727 =C2=B1  5%     +30.4%   11534796        perf-stat.i.node-loa=
d-misses
> >     623949 =C2=B1 11%     +54.9%     966213 =C2=B1  2%  perf-stat.i.nod=
e-loads
> >      91.43            +5.4       96.84        perf-stat.i.node-store-mi=
ss-rate%
> >    3461624 =C2=B1  2%     +66.0%    5746681        perf-stat.i.node-sto=
re-misses
> >     410920 =C2=B1  7%     -49.7%     206502 =C2=B1  3%  perf-stat.i.nod=
e-stores
> >       5563 =C2=B1  3%     -12.4%       4876 =C2=B1  2%  perf-stat.i.pag=
e-faults
> >      21.44            -1.0%      21.22        perf-stat.overall.MPKI
> >       0.93 =C2=B1  4%      +5.7        6.59        perf-stat.overall.ca=
che-miss-rate%
> >       1.43           +32.0%       1.89        perf-stat.overall.cpi
> >       7136 =C2=B1  4%     -81.1%       1348        perf-stat.overall.cy=
cles-between-cache-misses
> >       0.01 =C2=B1 27%      -0.0        0.00        perf-stat.overall.dT=
LB-load-miss-rate%
> >       0.00 =C2=B1  7%      -0.0        0.00 =C2=B1  5%  perf-stat.overa=
ll.dTLB-store-miss-rate%
> >      63.66           +11.2       74.89        perf-stat.overall.iTLB-lo=
ad-miss-rate%
> >       0.70           -24.3%       0.53        perf-stat.overall.ipc
> >      89.40            +7.1       96.53        perf-stat.overall.node-st=
ore-miss-rate%
> >      17593            +8.6%      19108        perf-stat.overall.path-le=
ngth
> >  3.063e+10           -71.5%  8.716e+09        perf-stat.ps.branch-instr=
uctions
> >  2.961e+08 =C2=B1  2%     -70.3%   87907848 =C2=B1  4%  perf-stat.ps.br=
anch-misses
> >   30717141 =C2=B1  3%     +98.8%   61062871        perf-stat.ps.cache-m=
isses
> >  3.286e+09           -71.8%  9.265e+08        perf-stat.ps.cache-refere=
nces
> >    4940513           -73.6%    1304046        perf-stat.ps.context-swit=
ches
> >  2.189e+11           -62.4%  8.231e+10        perf-stat.ps.cpu-cycles
> >     926.60           -64.3%     330.61        perf-stat.ps.cpu-migratio=
ns
> >    2684405 =C2=B1 27%     -90.1%     264976        perf-stat.ps.dTLB-lo=
ad-misses
> >  4.383e+10           -71.5%  1.248e+10        perf-stat.ps.dTLB-loads
> >     963689 =C2=B1  8%     -84.3%     151363 =C2=B1  6%  perf-stat.ps.dT=
LB-store-misses
> >  2.591e+10           -71.6%  7.352e+09        perf-stat.ps.dTLB-stores
> >  1.965e+08           -70.5%   57894987 =C2=B1  5%  perf-stat.ps.iTLB-lo=
ad-misses
> >  1.122e+08           -82.7%   19375491        perf-stat.ps.iTLB-loads
> >  1.532e+11           -71.5%  4.366e+10        perf-stat.ps.instructions
> >       5536 =C2=B1  3%     -12.3%       4857 =C2=B1  2%  perf-stat.ps.mi=
nor-faults
> >    8813664 =C2=B1  5%     +30.4%   11496729        perf-stat.ps.node-lo=
ad-misses
> >     622201 =C2=B1 11%     +54.8%     963024 =C2=B1  2%  perf-stat.ps.no=
de-loads
> >    3450020 =C2=B1  2%     +66.0%    5727738        perf-stat.ps.node-st=
ore-misses
> >     409584 =C2=B1  8%     -49.7%     206027 =C2=B1  3%  perf-stat.ps.no=
de-stores
> >       5537 =C2=B1  3%     -12.3%       4858 =C2=B1  2%  perf-stat.ps.pa=
ge-faults
> >  4.632e+13           -71.5%  1.322e+13        perf-stat.total.instructi=
ons
> >       9.54 =C2=B1  4%      -6.1        3.40 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.intel_idle_irq.cpuidle_enter_state.cpuidle_enter.cpuidle_=
idle_call.do_idle
> >       9.17 =C2=B1  5%      -6.1        3.05 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.mwait_idle_with_hints.intel_idle_irq.cpuidle_enter_state.=
cpuidle_enter.cpuidle_idle_call
> >       8.84 =C2=B1  4%      -3.2        5.62 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_do_sm.sctp_primitive_SEND.sctp_sendmsg_to_asoc.sctp_=
sendmsg.sock_sendmsg
> >       8.63 =C2=B1  4%      -3.1        5.53 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_packet_pack.sctp_packet_transmit.sctp_outq_flush.sct=
p_cmd_interpreter.sctp_do_sm
> >       8.18 =C2=B1  4%      -2.9        5.29 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.memcpy_erms.sctp_packet_pack.sctp_packet_transmit.sctp_ou=
tq_flush.sctp_cmd_interpreter
> >       6.49 =C2=B1  4%      -2.5        3.99 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.skb_copy_datagram_iter.sctp_recvmsg.inet_recvmsg.____sys_=
recvmsg.___sys_recvmsg
> >       6.47 =C2=B1  3%      -2.5        3.98 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__skb_datagram_iter.skb_copy_datagram_iter.sctp_recvmsg.i=
net_recvmsg.____sys_recvmsg
> >      21.33 =C2=B1  3%      -2.5       18.86 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_sendmsg_to_asoc.sctp_sendmsg.sock_sendmsg.____sys_se=
ndmsg.___sys_sendmsg
> >      13.50 =C2=B1  3%      -2.5       11.04 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_primitive_SEND.sctp_sendmsg_to_asoc.sctp_sendmsg.soc=
k_sendmsg.____sys_sendmsg
> >       6.89 =C2=B1  3%      -2.4        4.50 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_datamsg_from_user.sctp_sendmsg_to_asoc.sctp_sendmsg.=
sock_sendmsg.____sys_sendmsg
> >       5.63 =C2=B1  3%      -2.1        3.49 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.=
sctp_recvmsg.inet_recvmsg
> >       5.46 =C2=B1  3%      -2.1        3.40 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.copyout._copy_to_iter.__skb_datagram_iter.skb_copy_datagr=
am_iter.sctp_recvmsg
> >       5.42 =C2=B1  3%      -2.0        3.38 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.copy_user_enhanced_fast_string.copyout._copy_to_iter.__sk=
b_datagram_iter.skb_copy_datagram_iter
> >      11.96 =C2=B1  3%      -1.9       10.08 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_flush.sctp_cmd_interpreter.sctp_do_sm.sctp_prim=
itive_SEND.sctp_sendmsg_to_asoc
> >       9.08 =C2=B1  4%      -1.6        7.48 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_cmd_interpreter.sctp_do_sm.sctp_primitive_SEND.sctp_=
sendmsg_to_asoc.sctp_sendmsg
> >       1.76 =C2=B1  4%      -1.3        0.43 =C2=B1 44%  perf-profile.ca=
lltrace.cycles-pp.__alloc_pages.kmalloc_large_node.__kmalloc_node_track_cal=
ler.kmalloc_reserve.__alloc_skb
> >      10.30 =C2=B1  4%      -1.2        9.11 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_packet_transmit.sctp_outq_flush.sctp_cmd_interpreter=
.sctp_do_sm.sctp_primitive_SEND
> >       3.42 =C2=B1  3%      -1.1        2.30 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_user_addto_chunk.sctp_datamsg_from_user.sctp_sendmsg=
_to_asoc.sctp_sendmsg.sock_sendmsg
> >       2.85 =C2=B1  3%      -1.1        1.78 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_make_datafrag_empty.sctp_datamsg_from_user.sctp_send=
msg_to_asoc.sctp_sendmsg.sock_sendmsg
> >       1.79 =C2=B1  4%      -1.0        0.75 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.skb_release_data.kfree_skb_reason.sctp_recvmsg.inet_recvm=
sg.____sys_recvmsg
> >       3.08 =C2=B1  4%      -1.0        2.07 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_data_ready.sctp_ulpq_tail_event.sctp_ulpq_tail_data.=
sctp_cmd_interpreter.sctp_do_sm
> >       3.08 =C2=B1  3%      -1.0        2.08 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp._copy_from_iter.sctp_user_addto_chunk.sctp_datamsg_from_u=
ser.sctp_sendmsg_to_asoc.sctp_sendmsg
> >       3.20 =C2=B1  4%      -1.0        2.20 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_ulpq_tail_event.sctp_ulpq_tail_data.sctp_cmd_interpr=
eter.sctp_do_sm.sctp_assoc_bh_rcv
> >       2.82 =C2=B1  4%      -1.0        1.84 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__wake_up_common_lock.sctp_data_ready.sctp_ulpq_tail_even=
t.sctp_ulpq_tail_data.sctp_cmd_interpreter
> >       2.94 =C2=B1  3%      -1.0        1.97 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.copyin._copy_from_iter.sctp_user_addto_chunk.sctp_datamsg=
_from_user.sctp_sendmsg_to_asoc
> >       2.42 =C2=B1  3%      -1.0        1.46 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp._sctp_make_chunk.sctp_make_datafrag_empty.sctp_datamsg_fr=
om_user.sctp_sendmsg_to_asoc.sctp_sendmsg
> >       2.90 =C2=B1  3%      -0.9        1.95 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.copy_user_enhanced_fast_string.copyin._copy_from_iter.sct=
p_user_addto_chunk.sctp_datamsg_from_user
> >      11.68 =C2=B1  3%      -0.9       10.75 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_packet_transmit.sctp_outq_flush.sctp_cmd_interpreter=
.sctp_do_sm.sctp_assoc_bh_rcv
> >       2.63 =C2=B1  4%      -0.9        1.70 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__wake_up_common.__wake_up_common_lock.sctp_data_ready.sc=
tp_ulpq_tail_event.sctp_ulpq_tail_data
> >       2.46 =C2=B1  4%      -0.9        1.59 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.autoremove_wake_function.__wake_up_common.__wake_up_commo=
n_lock.sctp_data_ready.sctp_ulpq_tail_event
> >       2.44 =C2=B1  4%      -0.9        1.58 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.try_to_wake_up.autoremove_wake_function.__wake_up_common.=
__wake_up_common_lock.sctp_data_ready
> >      11.49 =C2=B1  3%      -0.8       10.64 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_flush.sctp_cmd_interpreter.sctp_do_sm.sctp_asso=
c_bh_rcv.sctp_backlog_rcv
> >       1.82 =C2=B1  3%      -0.8        1.02 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_ulpevent_free.sctp_recvmsg.inet_recvmsg.____sys_recv=
msg.___sys_recvmsg
> >       1.86 =C2=B1  4%      -0.8        1.08 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__alloc_skb._sctp_make_chunk.sctp_make_datafrag_empty.sct=
p_datamsg_from_user.sctp_sendmsg_to_asoc
> >       1.88 =C2=B1  3%      -0.8        1.10 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.schedule_timeout.sctp_skb_recv_datagram.sctp_recvmsg.inet=
_recvmsg.____sys_recvmsg
> >       1.84 =C2=B1  3%      -0.8        1.09 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.schedule.schedule_timeout.sctp_skb_recv_datagram.sctp_rec=
vmsg.inet_recvmsg
> >       1.81 =C2=B1  3%      -0.7        1.07 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__schedule.schedule.schedule_timeout.sctp_skb_recv_datagr=
am.sctp_recvmsg
> >       1.68 =C2=B1  4%      -0.7        0.98 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_flush_data.sctp_outq_flush.sctp_cmd_interpreter=
.sctp_do_sm.sctp_primitive_SEND
> >       1.65 =C2=B1  4%      -0.7        0.99 =C2=B1  3%  perf-profile.ca=
lltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.s=
econdary_startup_64_no_verify
> >       1.61 =C2=B1  4%      -0.6        0.96 =C2=B1  3%  perf-profile.ca=
lltrace.cycles-pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.start_=
secondary
> >       1.30 =C2=B1  3%      -0.6        0.69 =C2=B1  3%  perf-profile.ca=
lltrace.cycles-pp.kmalloc_reserve.__alloc_skb._sctp_make_chunk.sctp_make_da=
tafrag_empty.sctp_datamsg_from_user
> >       1.27 =C2=B1  3%      -0.6        0.67 =C2=B1  3%  perf-profile.ca=
lltrace.cycles-pp.__kmalloc_node_track_caller.kmalloc_reserve.__alloc_skb._=
sctp_make_chunk.sctp_make_datafrag_empty
> >       1.24 =C2=B1  3%      -0.6        0.65 =C2=B1  3%  perf-profile.ca=
lltrace.cycles-pp.kmalloc_large_node.__kmalloc_node_track_caller.kmalloc_re=
serve.__alloc_skb._sctp_make_chunk
> >       0.97 =C2=B1  3%      -0.5        0.46 =C2=B1 44%  perf-profile.ca=
lltrace.cycles-pp.dequeue_task_fair.__schedule.schedule.schedule_timeout.sc=
tp_skb_recv_datagram
> >       1.02 =C2=B1  3%      -0.5        0.57 =C2=B1  3%  perf-profile.ca=
lltrace.cycles-pp.sctp_chunk_put.sctp_ulpevent_free.sctp_recvmsg.inet_recvm=
sg.____sys_recvmsg
> >       1.10 =C2=B1  4%      -0.4        0.67 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_flush.sctp_cmd_interpreter.sctp_do_sm.sctp_asso=
c_bh_rcv.sctp_rcv
> >       0.92 =C2=B1  3%      -0.4        0.56 =C2=B1  6%  perf-profile.ca=
lltrace.cycles-pp.skb_release_data.consume_skb.sctp_chunk_put.sctp_outq_sac=
k.sctp_cmd_interpreter
> >       1.04 =C2=B1  4%      -0.3        0.71 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sendmsg_copy_msghdr.___sys_sendmsg.__sys_sendmsg.do_sysca=
ll_64.entry_SYSCALL_64_after_hwframe
> >       0.17 =C2=B1141%      +0.5        0.70 =C2=B1 15%  perf-profile.ca=
lltrace.cycles-pp.menu_select.cpuidle_idle_call.do_idle.cpu_startup_entry.s=
tart_secondary
> >       0.00            +0.9        0.91 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.page_counter_uncharge.drain_stock.refill_stock.__sk_mem_reduce=
_allocated.skb_release_head_state
> >       0.00            +0.9        0.93 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.drain_stock.refill_stock.__sk_mem_reduce_allocated.skb_release=
_head_state.kfree_skb_reason
> >       0.00            +1.0        0.95 =C2=B1 15%  perf-profile.calltra=
ce.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cp=
uidle_enter_state.cpuidle_enter.cpuidle_idle_call
> >       0.00            +1.0        1.03 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.refill_stock.__sk_mem_reduce_allocated.skb_release_head_state.=
kfree_skb_reason.sctp_recvmsg
> >       0.00            +1.0        1.04 =C2=B1 14%  perf-profile.calltra=
ce.cycles-pp.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_en=
ter.cpuidle_idle_call.do_idle
> >      11.57 =C2=B1  3%      +1.3       12.82 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_assoc_bh_rcv.sctp_backlog_rcv.__release_sock.release=
_sock.sctp_sendmsg
> >       0.00            +1.3        1.33 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.page_counter_uncharge.drain_stock.refill_stock.__sk_mem_reduce=
_allocated.sctp_wfree
> >       0.00            +1.4        1.36 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.drain_stock.refill_stock.__sk_mem_reduce_allocated.sctp_wfree.=
skb_release_head_state
> >       1.67 =C2=B1  3%      +1.4        3.04 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_ulpevent_make_rcvmsg.sctp_ulpq_tail_data.sctp_cmd_in=
terpreter.sctp_do_sm.sctp_assoc_bh_rcv
> >      11.39 =C2=B1  3%      +1.4       12.77 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_do_sm.sctp_assoc_bh_rcv.sctp_backlog_rcv.__release_s=
ock.release_sock
> >       0.00            +1.4        1.45 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.refill_stock.__sk_mem_reduce_allocated.sctp_wfree.skb_release_=
head_state.consume_skb
> >       0.00            +1.5        1.46 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.try_charge_memcg.mem_cgroup_charge_skmem.__sk_mem_raise_alloca=
ted.__sk_mem_schedule.sctp_ulpevent_make_rcvmsg
> >       0.00            +1.7        1.74 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.mem_cgroup_charge_skmem.__sk_mem_raise_allocated.__sk_mem_sche=
dule.sctp_ulpevent_make_rcvmsg.sctp_ulpq_tail_data
> >       0.00            +1.8        1.83 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_raise_allocated.__sk_mem_schedule.sctp_ulpevent_make_=
rcvmsg.sctp_ulpq_tail_data.sctp_cmd_interpreter
> >       0.00            +1.8        1.84 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_schedule.sctp_ulpevent_make_rcvmsg.sctp_ulpq_tail_dat=
a.sctp_cmd_interpreter.sctp_do_sm
> >       0.00            +2.0        1.97 =C2=B1  5%  perf-profile.calltra=
ce.cycles-pp.page_counter_try_charge.try_charge_memcg.mem_cgroup_charge_skm=
em.__sk_mem_raise_allocated.__sk_mem_schedule
> >      18.94 =C2=B1  3%      +2.1       21.02 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.recvmsg
> >       0.00            +2.1        2.14 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.try_charge_memcg.mem_cgroup_charge_skmem.__sk_mem_raise_alloca=
ted.__sk_mem_schedule.sctp_sendmsg_to_asoc
> >      10.88 =C2=B1  4%      +2.2       13.11 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__ip_queue_xmit.sctp_packet_transmit.sctp_outq_flush.sctp=
_cmd_interpreter.sctp_do_sm
> >      10.74 =C2=B1  4%      +2.3       13.04 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.ip_finish_output2.__ip_queue_xmit.sctp_packet_transmit.sc=
tp_outq_flush.sctp_cmd_interpreter
> >      18.22 =C2=B1  3%      +2.3       20.55 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.recvmsg
> >      10.51 =C2=B1  4%      +2.4       12.88 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__local_bh_enable_ip.ip_finish_output2.__ip_queue_xmit.sc=
tp_packet_transmit.sctp_outq_flush
> >      10.47 =C2=B1  4%      +2.4       12.84 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.do_softirq.__local_bh_enable_ip.ip_finish_output2.__ip_qu=
eue_xmit.sctp_packet_transmit
> >      18.08 =C2=B1  3%      +2.4       20.46 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.recvmsg
> >      10.42 =C2=B1  4%      +2.4       12.81 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__softirqentry_text_start.do_softirq.__local_bh_enable_ip=
.ip_finish_output2.__ip_queue_xmit
> >      10.25 =C2=B1  4%      +2.4       12.70 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.net_rx_action.__softirqentry_text_start.do_softirq.__loca=
l_bh_enable_ip.ip_finish_output2
> >      17.84 =C2=B1  3%      +2.5       20.32 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__sys_recvmsg.do_syscall_64.entry_SYSCALL_64_after_hwfram=
e.recvmsg
> >      10.15 =C2=B1  4%      +2.5       12.64 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__napi_poll.net_rx_action.__softirqentry_text_start.do_so=
ftirq.__local_bh_enable_ip
> >      10.13 =C2=B1  4%      +2.5       12.63 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.process_backlog.__napi_poll.net_rx_action.__softirqentry_=
text_start.do_softirq
> >       0.00            +2.5        2.50 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.mem_cgroup_charge_skmem.__sk_mem_raise_allocated.__sk_mem_sche=
dule.sctp_sendmsg_to_asoc.sctp_sendmsg
> >       3.59 =C2=B1  3%      +2.5        6.11 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_skb_recv_datagram.sctp_recvmsg.inet_recvmsg.____sys_=
recvmsg.___sys_recvmsg
> >       9.97 =C2=B1  4%      +2.6       12.54 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.__netif_receive_skb_one_core.process_backlog.__napi_poll.=
net_rx_action.__softirqentry_text_start
> >      17.56 =C2=B1  3%      +2.6       20.14 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.___sys_recvmsg.__sys_recvmsg.do_syscall_64.entry_SYSCALL_=
64_after_hwframe.recvmsg
> >       0.00            +2.7        2.66 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_raise_allocated.__sk_mem_schedule.sctp_sendmsg_to_aso=
c.sctp_sendmsg.sock_sendmsg
> >       0.00            +2.7        2.68 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_schedule.sctp_sendmsg_to_asoc.sctp_sendmsg.sock_sendm=
sg.____sys_sendmsg
> >       9.70 =C2=B1  4%      +2.7       12.40 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.ip_local_deliver_finish.__netif_receive_skb_one_core.proc=
ess_backlog.__napi_poll.net_rx_action
> >       9.68 =C2=B1  4%      +2.7       12.39 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_r=
eceive_skb_one_core.process_backlog.__napi_poll
> >       9.61 =C2=B1  4%      +2.7       12.33 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.=
__netif_receive_skb_one_core.process_backlog
> >      16.65 =C2=B1  3%      +2.9       19.58 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.____sys_recvmsg.___sys_recvmsg.__sys_recvmsg.do_syscall_6=
4.entry_SYSCALL_64_after_hwframe
> >       8.06 =C2=B1  4%      +3.1       11.19 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_assoc_bh_rcv.sctp_rcv.ip_protocol_deliver_rcu.ip_loc=
al_deliver_finish.__netif_receive_skb_one_core
> >      15.88 =C2=B1  3%      +3.2       19.12 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.inet_recvmsg.____sys_recvmsg.___sys_recvmsg.__sys_recvmsg=
.do_syscall_64
> >      15.83 =C2=B1  3%      +3.3       19.09 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_recvmsg.inet_recvmsg.____sys_recvmsg.___sys_recvmsg.=
__sys_recvmsg
> >       7.62 =C2=B1  3%      +3.3       10.90 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_do_sm.sctp_assoc_bh_rcv.sctp_rcv.ip_protocol_deliver=
_rcu.ip_local_deliver_finish
> >       1.14 =C2=B1  3%      +3.5        4.62 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.lock_sock_nested.sctp_skb_recv_datagram.sctp_recvmsg.inet=
_recvmsg.____sys_recvmsg
> >       1.02 =C2=B1  3%      +3.5        4.51 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp._raw_spin_lock_bh.lock_sock_nested.sctp_skb_recv_datagram=
.sctp_recvmsg.inet_recvmsg
> >       0.83 =C2=B1  4%      +3.6        4.38 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_bh.lock_s=
ock_nested.sctp_skb_recv_datagram.sctp_recvmsg
> >      15.16 =C2=B1  3%      +3.6       18.74 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.release_sock.sctp_sendmsg.sock_sendmsg.____sys_sendmsg.__=
_sys_sendmsg
> >      15.04 =C2=B1  3%      +3.6       18.66 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.__release_sock.release_sock.sctp_sendmsg.sock_sendmsg.___=
_sys_sendmsg
> >      11.66 =C2=B1  3%      +3.6       15.29 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_cmd_interpreter.sctp_do_sm.sctp_assoc_bh_rcv.sctp_ba=
cklog_rcv.__release_sock
> >      14.98 =C2=B1  3%      +3.6       18.62 =C2=B1  5%  perf-profile.ca=
lltrace.cycles-pp.sctp_backlog_rcv.__release_sock.release_sock.sctp_sendmsg=
.sock_sendmsg
> >       0.00            +4.2        4.24 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.sctp_eat_data.sctp_sf_eat_data_6_2.sctp_do_sm.sctp_assoc_bh_rc=
v.sctp_rcv
> >       0.00            +4.3        4.33 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.sctp_sf_eat_data_6_2.sctp_do_sm.sctp_assoc_bh_rcv.sctp_rcv.ip_=
protocol_deliver_rcu
> >       2.88 =C2=B1  3%      +4.7        7.54 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_outq_sack.sctp_cmd_interpreter.sctp_do_sm.sctp_assoc=
_bh_rcv.sctp_backlog_rcv
> >      23.81 =C2=B1 12%      +4.8       28.57 =C2=B1 11%  perf-profile.ca=
lltrace.cycles-pp.mwait_idle_with_hints.intel_idle.cpuidle_enter_state.cpui=
dle_enter.cpuidle_idle_call
> >      23.81 =C2=B1 12%      +4.8       28.58 =C2=B1 11%  perf-profile.ca=
lltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle=
_call.do_idle
> >       2.11 =C2=B1  4%      +4.8        6.89 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.kfree_skb_reason.sctp_recvmsg.inet_recvmsg.____sys_recvms=
g.___sys_recvmsg
> >       1.84 =C2=B1  3%      +5.0        6.86 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.sctp_chunk_put.sctp_outq_sack.sctp_cmd_interpreter.sctp_d=
o_sm.sctp_assoc_bh_rcv
> >       1.42 =C2=B1  3%      +5.0        6.47 =C2=B1  4%  perf-profile.ca=
lltrace.cycles-pp.consume_skb.sctp_chunk_put.sctp_outq_sack.sctp_cmd_interp=
reter.sctp_do_sm
> >       0.00            +5.5        5.53 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_reduce_allocated.sctp_wfree.skb_release_head_state.co=
nsume_skb.sctp_chunk_put
> >       0.00            +5.8        5.80 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.sctp_wfree.skb_release_head_state.consume_skb.sctp_chunk_put.s=
ctp_outq_sack
> >       0.00            +5.9        5.87 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.skb_release_head_state.consume_skb.sctp_chunk_put.sctp_outq_sa=
ck.sctp_cmd_interpreter
> >       0.00            +6.0        5.99 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.__sk_mem_reduce_allocated.skb_release_head_state.kfree_skb_rea=
son.sctp_recvmsg.inet_recvmsg
> >       0.00            +6.1        6.13 =C2=B1  4%  perf-profile.calltra=
ce.cycles-pp.skb_release_head_state.kfree_skb_reason.sctp_recvmsg.inet_recv=
msg.____sys_recvmsg
> >       9.61 =C2=B1  5%      -6.2        3.42 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.intel_idle_irq
> >       9.16 =C2=B1  3%      -3.3        5.87 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_pack
> >       8.74 =C2=B1  3%      -3.1        5.61 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.copy_user_enhanced_fast_string
> >      25.01 =C2=B1  3%      -3.0       21.98 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_flush
> >       8.52 =C2=B1  3%      -3.0        5.50 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.memcpy_erms
> >       6.49 =C2=B1  3%      -2.5        3.99 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.skb_copy_datagram_iter
> >       6.47 =C2=B1  3%      -2.5        3.98 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__skb_datagram_iter
> >       7.07 =C2=B1  3%      -2.5        4.60 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_datamsg_from_user
> >      21.61 =C2=B1  3%      -2.4       19.19 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_sendmsg_to_asoc
> >      13.72 =C2=B1  3%      -2.4       11.31 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_primitive_SEND
> >       5.63 =C2=B1  3%      -2.1        3.50 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp._copy_to_iter
> >       5.46 =C2=B1  3%      -2.1        3.40 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.copyout
> >      22.37 =C2=B1  3%      -2.0       20.39 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_transmit
> >       3.59 =C2=B1  3%      -1.6        1.96 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__alloc_skb
> >       2.98 =C2=B1  3%      -1.5        1.49 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.skb_release_data
> >       3.46 =C2=B1  4%      -1.4        2.06 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__schedule
> >       2.66 =C2=B1  3%      -1.3        1.35 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.kmalloc_reserve
> >       2.62 =C2=B1  3%      -1.3        1.32 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__kmalloc_node_track_caller
> >       2.50 =C2=B1  3%      -1.3        1.24 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.kmalloc_large_node
> >       3.51 =C2=B1  3%      -1.2        2.36 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_user_addto_chunk
> >       2.20 =C2=B1  3%      -1.1        1.07 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__alloc_pages
> >       2.93 =C2=B1  3%      -1.1        1.82 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_make_datafrag_empty
> >       2.70 =C2=B1  3%      -1.1        1.62 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp._sctp_make_chunk
> >       3.17 =C2=B1  3%      -1.0        2.12 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_data_ready
> >       3.16 =C2=B1  3%      -1.0        2.13 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp._copy_from_iter
> >       3.28 =C2=B1  3%      -1.0        2.26 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpq_tail_event
> >       2.90 =C2=B1  3%      -1.0        1.88 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__wake_up_common_lock
> >       1.89 =C2=B1  4%      -1.0        0.88 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.get_page_from_freelist
> >       3.02 =C2=B1  3%      -1.0        2.02 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.copyin
> >       2.47 =C2=B1  3%      -1.0        1.49 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_flush_data
> >       2.70 =C2=B1  3%      -0.9        1.75 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__wake_up_common
> >       2.53 =C2=B1  3%      -0.9        1.64 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.autoremove_wake_function
> >       2.51 =C2=B1  3%      -0.9        1.63 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.try_to_wake_up
> >       1.83 =C2=B1  3%      -0.8        1.02 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpevent_free
> >       2.10 =C2=B1  3%      -0.8        1.32 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.kmem_cache_free
> >       1.89 =C2=B1  3%      -0.8        1.12 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.schedule_timeout
> >       1.39 =C2=B1  4%      -0.8        0.63 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.free_unref_page
> >       1.86 =C2=B1  3%      -0.7        1.11 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.schedule
> >       1.25 =C2=B1  4%      -0.7        0.56 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.rmqueue
> >       1.28 =C2=B1  4%      -0.7        0.60 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp._raw_spin_lock_irqsave
> >       1.66 =C2=B1  4%      -0.7        1.00 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.schedule_idle
> >       0.98 =C2=B1  4%      -0.6        0.43 =C2=B1  3%  perf-profile.ch=
ildren.cycles-pp._raw_spin_lock
> >       1.08 =C2=B1  4%      -0.5        0.54 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_select_transport
> >       1.45 =C2=B1  4%      -0.5        0.94 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp._copy_from_user
> >       0.98 =C2=B1  4%      -0.5        0.48 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_config
> >       1.25 =C2=B1 12%      -0.5        0.78 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__rhashtable_lookup
> >       1.21 =C2=B1  3%      -0.5        0.73 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__check_object_size
> >       0.98 =C2=B1  3%      -0.4        0.53 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.dequeue_task_fair
> >       0.64 =C2=B1  5%      -0.4        0.20 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.free_pcppages_bulk
> >       1.18 =C2=B1  4%      -0.4        0.78 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.ttwu_do_activate
> >       0.62 =C2=B1  4%      -0.4        0.22 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__free_pages_ok
> >       0.90 =C2=B1  3%      -0.4        0.50 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.dequeue_entity
> >       1.14 =C2=B1  3%      -0.4        0.75 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.enqueue_task_fair
> >       0.95 =C2=B1  4%      -0.4        0.57 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__slab_free
> >       0.76 =C2=B1  3%      -0.3        0.42 =C2=B1  3%  perf-profile.ch=
ildren.cycles-pp.__skb_clone
> >       1.07 =C2=B1  4%      -0.3        0.73 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sendmsg_copy_msghdr
> >       0.76 =C2=B1  3%      -0.3        0.42 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.update_load_avg
> >       0.98 =C2=B1  4%      -0.3        0.65 =C2=B1  3%  perf-profile.ch=
ildren.cycles-pp.__copy_msghdr_from_user
> >       0.81 =C2=B1 14%      -0.3        0.49 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_hash_cmp
> >       0.88 =C2=B1  4%      -0.3        0.56 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.pick_next_task_fair
> >       0.84 =C2=B1  3%      -0.3        0.54 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.enqueue_entity
> >       0.82 =C2=B1  3%      -0.3        0.53 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.import_iovec
> >       0.81 =C2=B1  2%      -0.3        0.52 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.kfree
> >       0.59 =C2=B1  3%      -0.3        0.30 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__copy_skb_header
> >       0.78 =C2=B1  3%      -0.3        0.51 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__import_iovec
> >       0.62 =C2=B1  5%      -0.3        0.35 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.set_next_entity
> >       0.76 =C2=B1 12%      -0.3        0.50 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_endpoint_lookup_assoc
> >       0.69 =C2=B1  4%      -0.3        0.43 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.check_heap_object
> >       0.77 =C2=B1  3%      -0.3        0.52 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.kmem_cache_alloc
> >       0.74 =C2=B1 12%      -0.3        0.49 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_epaddr_lookup_transport
> >       0.72 =C2=B1 10%      -0.2        0.48 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__sctp_rcv_lookup
> >       0.66 =C2=B1  4%      -0.2        0.42 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__might_resched
> >       0.70 =C2=B1 10%      -0.2        0.46 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_addrs_lookup_transport
> >       0.65 =C2=B1  2%      -0.2        0.42 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.iovec_from_user
> >       0.50 =C2=B1  4%      -0.2        0.26 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.simple_copy_to_iter
> >       0.46 =C2=B1  3%      -0.2        0.23 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_inq_pop
> >       0.41 =C2=B1  3%      -0.2        0.19 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.update_curr
> >       0.69 =C2=B1  3%      -0.2        0.47 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_chunkify
> >       0.55 =C2=B1  3%      -0.2        0.34 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__dev_queue_xmit
> >       0.53 =C2=B1  4%      -0.2        0.33 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__might_fault
> >       0.58 =C2=B1  4%      -0.2        0.39 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.copy_user_short_string
> >       0.46 =C2=B1  9%      -0.2        0.28 =C2=B1 12%  perf-profile.ch=
ildren.cycles-pp.select_task_rq
> >       0.33 =C2=B1  4%      -0.2        0.16 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.free_unref_page_commit
> >       0.28 =C2=B1  5%      -0.2        0.11 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.dst_release
> >       0.32 =C2=B1  7%      -0.2        0.15 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.ipv4_dst_check
> >       0.38 =C2=B1  3%      -0.2        0.22 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__mod_node_page_state
> >       0.44 =C2=B1  8%      -0.2        0.28 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_append_chunk
> >       0.49 =C2=B1  6%      -0.2        0.33 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.sctp_packet_transmit_chunk
> >       0.54 =C2=B1  4%      -0.2        0.39 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__list_del_entry_valid
> >       0.34 =C2=B1  4%      -0.2        0.19 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_v4_xmit
> >       0.42 =C2=B1  3%      -0.2        0.27 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sockfd_lookup_light
> >       0.32 =C2=B1  4%      -0.1        0.17 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__zone_watermark_ok
> >       0.47 =C2=B1  3%      -0.1        0.32 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__entry_text_start
> >       0.28 =C2=B1  2%      -0.1        0.13 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__free_one_page
> >       0.28 =C2=B1  5%      -0.1        0.13 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.prepare_task_switch
> >       0.43 =C2=B1  5%      -0.1        0.29 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sctp_addto_chunk
> >       0.37 =C2=B1  4%      -0.1        0.23 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_gen_sack
> >       0.41 =C2=B1  4%      -0.1        0.27 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.aa_sk_perm
> >       0.35 =C2=B1  3%      -0.1        0.22 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__list_add_valid
> >       0.34 =C2=B1  4%      -0.1        0.20 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_make_sack
> >       0.44 =C2=B1  4%      -0.1        0.30 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.update_rq_clock
> >       0.37 =C2=B1  4%      -0.1        0.24 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sock_recvmsg
> >       0.34 =C2=B1  4%      -0.1        0.22 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_check_transmitted
> >       0.35 =C2=B1  3%      -0.1        0.22 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.memcg_slab_free_hook
> >       0.36 =C2=B1  4%      -0.1        0.23 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__fdget
> >       0.34 =C2=B1 10%      -0.1        0.22 =C2=B1 15%  perf-profile.ch=
ildren.cycles-pp.select_task_rq_fair
> >       0.44 =C2=B1  4%      -0.1        0.32 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.kmem_cache_alloc_node
> >       0.34 =C2=B1  5%      -0.1        0.21 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__virt_addr_valid
> >       0.34 =C2=B1  3%      -0.1        0.22 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.dev_hard_start_xmit
> >       0.28 =C2=B1 14%      -0.1        0.16 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_transport_hold
> >       0.35 =C2=B1  2%      -0.1        0.23 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__might_sleep
> >       0.38 =C2=B1  4%      -0.1        0.26 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_chunk_free
> >       0.31 =C2=B1  5%      -0.1        0.20 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.loopback_xmit
> >       0.33 =C2=B1  4%      -0.1        0.22 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.free_pcp_prepare
> >       0.33 =C2=B1  5%      -0.1        0.22 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.security_socket_recvmsg
> >       0.35 =C2=B1  2%      -0.1        0.24 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sock_kmalloc
> >       0.30 =C2=B1  2%      -0.1        0.20 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_association_put
> >       0.22 =C2=B1  7%      -0.1        0.12 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_assoc_rwnd_increase
> >       0.34 =C2=B1  4%      -0.1        0.23 =C2=B1  2%  perf-profile.ch=
ildren.cycles-pp.move_addr_to_kernel
> >       0.28 =C2=B1  4%      -0.1        0.17 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sock_kfree_s
> >       0.23 =C2=B1  5%      -0.1        0.13 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.rmqueue_bulk
> >       0.31 =C2=B1  9%      -0.1        0.21 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_transport_put
> >       0.33 =C2=B1  6%      -0.1        0.23 =C2=B1 12%  perf-profile.ch=
ildren.cycles-pp.sctp_sched_fcfs_dequeue
> >       0.28 =C2=B1  8%      -0.1        0.18 =C2=B1 20%  perf-profile.ch=
ildren.cycles-pp.__sctp_packet_append_chunk
> >       0.34 =C2=B1  4%      -0.1        0.24 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.memset_erms
> >       0.19 =C2=B1  4%      -0.1        0.10 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__update_load_avg_cfs_rq
> >       0.29 =C2=B1  4%      -0.1        0.19 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.skb_set_owner_w
> >       0.27 =C2=B1  4%      -0.1        0.18 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.security_socket_sendmsg
> >       0.24 =C2=B1  4%      -0.1        0.14 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__switch_to
> >       0.26 =C2=B1  4%      -0.1        0.17 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.entry_SYSRETQ_unsafe_stack
> >       0.27 =C2=B1  2%      -0.1        0.18 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.send_sctp_stream_1toMany
> >       0.23 =C2=B1  4%      -0.1        0.14 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.tick_nohz_idle_exit
> >       0.20 =C2=B1  4%      -0.1        0.11 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_flush_ctrl
> >       0.24 =C2=B1  7%      -0.1        0.15 =C2=B1 14%  perf-profile.ch=
ildren.cycles-pp.select_idle_sibling
> >       0.26 =C2=B1  4%      -0.1        0.17 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.syscall_exit_to_user_mode
> >       0.22 =C2=B1  5%      -0.1        0.14 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__switch_to_asm
> >       0.21            -0.1        0.13 =C2=B1  8%  perf-profile.childre=
n.cycles-pp.accept_connection
> >       0.21            -0.1        0.13 =C2=B1  8%  perf-profile.childre=
n.cycles-pp.spawn_child
> >       0.21            -0.1        0.13 =C2=B1  8%  perf-profile.childre=
n.cycles-pp.process_requests
> >       0.14 =C2=B1  5%      -0.1        0.06 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.check_stack_object
> >       0.20 =C2=B1  3%      -0.1        0.12 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sock_wfree
> >       0.22 =C2=B1  4%      -0.1        0.14 =C2=B1  3%  perf-profile.ch=
ildren.cycles-pp.prepare_to_wait_exclusive
> >       0.24 =C2=B1  5%      -0.1        0.17 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sctp_sched_dequeue_common
> >       0.22 =C2=B1  3%      -0.1        0.15 =C2=B1  2%  perf-profile.ch=
ildren.cycles-pp.__kmalloc
> >       0.21 =C2=B1  3%      -0.1        0.13 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_make_control
> >       0.20 =C2=B1  2%      -0.1        0.12 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.recv_sctp_stream_1toMany
> >       0.17 =C2=B1  6%      -0.1        0.09 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.___perf_sw_event
> >       0.14 =C2=B1  5%      -0.1        0.06 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.sctp_sock_rfree
> >       0.20 =C2=B1  4%      -0.1        0.13 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.skb_clone
> >       0.19 =C2=B1 30%      -0.1        0.12 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_cmp_addr_exact
> >       0.17 =C2=B1  4%      -0.1        0.10 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__mod_timer
> >       0.20 =C2=B1  4%      -0.1        0.13 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.available_idle_cpu
> >       0.23 =C2=B1  7%      -0.1        0.16 =C2=B1  3%  perf-profile.ch=
ildren.cycles-pp.__cond_resched
> >       0.21 =C2=B1  6%      -0.1        0.14 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_datamsg_put
> >       0.16 =C2=B1  4%      -0.1        0.09 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.check_new_pages
> >       0.14 =C2=B1  6%      -0.1        0.08 =C2=B1 12%  perf-profile.ch=
ildren.cycles-pp.sctp_inet_skb_msgname
> >       0.14 =C2=B1  6%      -0.1        0.08 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.ip_rcv
> >       0.18 =C2=B1  3%      -0.1        0.11 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.syscall_return_via_sysret
> >       0.18 =C2=B1  4%      -0.1        0.12 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.poll_idle
> >       0.20 =C2=B1  6%      -0.1        0.14 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.kmem_cache_alloc_trace
> >       0.19            -0.1        0.13 =C2=B1  8%  perf-profile.childre=
n.cycles-pp.sctp_outq_tail
> >       0.18 =C2=B1  3%      -0.1        0.12 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.reweight_entity
> >       0.20 =C2=B1  4%      -0.1        0.13 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.update_cfs_group
> >       0.16 =C2=B1  5%      -0.1        0.10 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.del_timer
> >       0.16 =C2=B1  5%      -0.1        0.10 =C2=B1  3%  perf-profile.ch=
ildren.cycles-pp.sctp_sendmsg_parse
> >       0.16 =C2=B1  5%      -0.1        0.10 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.perf_trace_sched_wakeup_template
> >       0.18 =C2=B1  2%      -0.1        0.12 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__free_pages
> >       0.17 =C2=B1  4%      -0.1        0.11 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.nr_iowait_cpu
> >       0.14 =C2=B1  2%      -0.1        0.09 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.switch_mm_irqs_off
> >       0.11 =C2=B1  6%      -0.1        0.05 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__build_skb_around
> >       0.19 =C2=B1  3%      -0.1        0.14 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__update_load_avg_se
> >       0.16 =C2=B1  5%      -0.1        0.11 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.ttwu_do_wakeup
> >       0.13 =C2=B1  6%      -0.1        0.08 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.task_tick_fair
> >       0.21 =C2=B1  3%      -0.0        0.16 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_association_hold
> >       0.15 =C2=B1  6%      -0.0        0.10 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.check_preempt_curr
> >       0.07 =C2=B1  6%      -0.0        0.02 =C2=B1 99%  perf-profile.ch=
ildren.cycles-pp._raw_spin_unlock_irqrestore
> >       0.10 =C2=B1  5%      -0.0        0.05 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.finish_task_switch
> >       0.14 =C2=B1  6%      -0.0        0.10 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.__genradix_ptr
> >       0.12 =C2=B1  4%      -0.0        0.08 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_chunk_abandoned
> >       0.07 =C2=B1  5%      -0.0        0.02 =C2=B1 99%  perf-profile.ch=
ildren.cycles-pp.ip_local_out
> >       0.22 =C2=B1  6%      -0.0        0.17 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sched_clock_cpu
> >       0.14 =C2=B1  5%      -0.0        0.09 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.memcg_slab_post_alloc_hook
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__netif_rx
> >       0.20 =C2=B1  5%      -0.0        0.16 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.read_tsc
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.lock_timer_base
> >       0.19 =C2=B1  5%      -0.0        0.15 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.native_sched_clock
> >       0.13 =C2=B1  5%      -0.0        0.09 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.pick_next_entity
> >       0.12 =C2=B1  5%      -0.0        0.08 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.netif_rx_internal
> >       0.12 =C2=B1  7%      -0.0        0.08 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.__put_user_nocheck_4
> >       0.12 =C2=B1  4%      -0.0        0.08 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.skb_put
> >       0.11 =C2=B1  4%      -0.0        0.07 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.__put_user_nocheck_8
> >       0.12 =C2=B1  3%      -0.0        0.08 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.resched_curr
> >       0.11 =C2=B1  8%      -0.0        0.07 =C2=B1 25%  perf-profile.ch=
ildren.cycles-pp.sctp_chunk_assign_ssn
> >       0.13 =C2=B1  4%      -0.0        0.09 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.sctp_datamsg_destroy
> >       0.07 =C2=B1  7%      -0.0        0.03 =C2=B1100%  perf-profile.ch=
ildren.cycles-pp.ip_rcv_core
> >       0.11 =C2=B1  3%      -0.0        0.07 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.enqueue_to_backlog
> >       0.10 =C2=B1  5%      -0.0        0.06 =C2=B1 13%  perf-profile.ch=
ildren.cycles-pp.sctp_transport_reset_t3_rtx
> >       0.09 =C2=B1  6%      -0.0        0.05 =C2=B1  7%  perf-profile.ch=
ildren.cycles-pp.__netif_receive_skb_core
> >       0.10 =C2=B1  5%      -0.0        0.06 =C2=B1  6%  perf-profile.ch=
ildren.cycles-pp.validate_xmit_skb
> >       0.11 =C2=B1  6%      -0.0        0.07 =C2=B1 12%  perf-profile.ch=
ildren.cycles-pp.syscall_exit_to_user_mode_prepare
> >       0.06 =C2=B1  6%      -0.0        0.02 =C2=B1 99%  perf-profile.ch=
ildren.cycles-pp.entry_SYSCALL_64_safe_stack
> >       0.10 =C2=B1  8%      -0.0        0.06 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpq_order
> >       0.09 =C2=B1  6%      -0.0        0.06 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.os_xsave
> >       0.12 =C2=B1  5%      -0.0        0.08 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.__check_heap_object
> >       0.10 =C2=B1  5%      -0.0        0.07 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.rcu_all_qs
> >       0.08 =C2=B1  5%      -0.0        0.06 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.tick_nohz_idle_enter
> >       0.08 =C2=B1  5%      -0.0        0.06 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.perf_tp_event
> >       0.08            -0.0        0.06 =C2=B1  9%  perf-profile.childre=
n.cycles-pp.__mod_lruvec_page_state
> >       0.31 =C2=B1  3%      -0.0        0.28 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpevent_receive_data
> >       0.10 =C2=B1 10%      -0.0        0.08 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.rcu_idle_exit
> >       0.08 =C2=B1  6%      -0.0        0.05 =C2=B1  8%  perf-profile.ch=
ildren.cycles-pp.sctp_tsnmap_check
> >       0.08 =C2=B1  5%      -0.0        0.06 =C2=B1 14%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpevent_init
> >       0.07 =C2=B1  8%      -0.0        0.05        perf-profile.childre=
n.cycles-pp.__wrgsbase_inactive
> >       0.10 =C2=B1  5%      +0.0        0.13 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.sctp_sockaddr_af
> >       0.00            +0.1        0.05        perf-profile.children.cyc=
les-pp.perf_mux_hrtimer_handler
> >       0.19 =C2=B1  3%      +0.1        0.24 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.scheduler_tick
> >       0.00            +0.1        0.06 =C2=B1  7%  perf-profile.childre=
n.cycles-pp.lapic_next_deadline
> >       0.00            +0.1        0.07 =C2=B1 32%  perf-profile.childre=
n.cycles-pp.arch_cpu_idle_enter
> >       0.00            +0.1        0.07 =C2=B1 16%  perf-profile.childre=
n.cycles-pp.native_irq_return_iret
> >       0.00            +0.1        0.08 =C2=B1 22%  perf-profile.childre=
n.cycles-pp.update_blocked_averages
> >       0.00            +0.1        0.08 =C2=B1 22%  perf-profile.childre=
n.cycles-pp.run_rebalance_domains
> >       0.24 =C2=B1  3%      +0.1        0.32 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.update_process_times
> >       0.00            +0.1        0.08 =C2=B1 22%  perf-profile.childre=
n.cycles-pp.update_sg_lb_stats
> >       0.24 =C2=B1  4%      +0.1        0.32 =C2=B1  9%  perf-profile.ch=
ildren.cycles-pp.tick_sched_handle
> >       0.00            +0.1        0.08 =C2=B1 41%  perf-profile.childre=
n.cycles-pp._raw_spin_trylock
> >       0.00            +0.1        0.09 =C2=B1 20%  perf-profile.childre=
n.cycles-pp.update_sd_lb_stats
> >       0.00            +0.1        0.09 =C2=B1 19%  perf-profile.childre=
n.cycles-pp.find_busiest_group
> >       0.04 =C2=B1 71%      +0.1        0.14 =C2=B1  3%  perf-profile.ch=
ildren.cycles-pp.sctp_get_af_specific
> >       0.01 =C2=B1223%      +0.1        0.11 =C2=B1 18%  perf-profile.ch=
ildren.cycles-pp.load_balance
> >       0.00            +0.1        0.11 =C2=B1 11%  perf-profile.childre=
n.cycles-pp.tick_nohz_irq_exit
> >       0.02 =C2=B1141%      +0.1        0.14 =C2=B1 46%  perf-profile.ch=
ildren.cycles-pp.rebalance_domains
> >       0.45 =C2=B1  5%      +0.1        0.58 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.ktime_get
> >       0.00            +0.1        0.14 =C2=B1 17%  perf-profile.childre=
n.cycles-pp.cgroup_rstat_updated
> >       0.26 =C2=B1  4%      +0.1        0.41 =C2=B1 12%  perf-profile.ch=
ildren.cycles-pp.tick_sched_timer
> >       0.15 =C2=B1 10%      +0.2        0.32 =C2=B1 16%  perf-profile.ch=
ildren.cycles-pp.clockevents_program_event
> >       0.30 =C2=B1  4%      +0.2        0.50 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.__hrtimer_run_queues
> >       0.25 =C2=B1  4%      +0.2        0.45 =C2=B1 20%  perf-profile.ch=
ildren.cycles-pp.tick_nohz_get_sleep_length
> >       0.00            +0.2        0.20 =C2=B1 16%  perf-profile.childre=
n.cycles-pp.timekeeping_max_deferment
> >       0.50 =C2=B1  2%      +0.2        0.71 =C2=B1 15%  perf-profile.ch=
ildren.cycles-pp.menu_select
> >       0.16 =C2=B1  5%      +0.2        0.38 =C2=B1 22%  perf-profile.ch=
ildren.cycles-pp.tick_nohz_next_event
> >       0.08 =C2=B1  8%      +0.2        0.30 =C2=B1 23%  perf-profile.ch=
ildren.cycles-pp.__irq_exit_rcu
> >       0.00            +0.3        0.33 =C2=B1 12%  perf-profile.childre=
n.cycles-pp.propagate_protected_usage
> >       0.48 =C2=B1  5%      +0.4        0.89 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.hrtimer_interrupt
> >       0.48 =C2=B1  6%      +0.4        0.90 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.__sysvec_apic_timer_interrupt
> >       0.00            +0.6        0.55 =C2=B1  3%  perf-profile.childre=
n.cycles-pp.mem_cgroup_uncharge_skmem
> >       0.61 =C2=B1  5%      +0.7        1.35 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.sysvec_apic_timer_interrupt
> >       1.00 =C2=B1  2%      +0.8        1.82 =C2=B1 10%  perf-profile.ch=
ildren.cycles-pp.asm_sysvec_apic_timer_interrupt
> >       0.00            +1.0        1.03 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.__mod_memcg_state
> >       1.73 =C2=B1  2%      +1.4        3.14 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_ulpevent_make_rcvmsg
> >      19.09 =C2=B1  3%      +2.0       21.11 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.recvmsg
> >      11.51 =C2=B1  3%      +2.2       13.66 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__ip_queue_xmit
> >      11.26 =C2=B1  3%      +2.3       13.53 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.ip_finish_output2
> >       0.00            +2.3        2.27 =C2=B1  5%  perf-profile.childre=
n.cycles-pp.page_counter_uncharge
> >       0.00            +2.3        2.32 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.drain_stock
> >       0.00            +2.4        2.40 =C2=B1  5%  perf-profile.childre=
n.cycles-pp.page_counter_try_charge
> >      10.87 =C2=B1  3%      +2.4       13.28 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__local_bh_enable_ip
> >      10.76 =C2=B1  3%      +2.4       13.20 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.do_softirq
> >      17.84 =C2=B1  3%      +2.5       20.32 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__sys_recvmsg
> >       3.60 =C2=B1  3%      +2.5        6.12 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_skb_recv_datagram
> >      10.53 =C2=B1  3%      +2.5       13.07 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.net_rx_action
> >       0.00            +2.5        2.54 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.refill_stock
> >      10.43 =C2=B1  3%      +2.6       13.01 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__napi_poll
> >      17.57 =C2=B1  3%      +2.6       20.15 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.___sys_recvmsg
> >      10.41 =C2=B1  3%      +2.6       12.99 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.process_backlog
> >      10.77 =C2=B1  3%      +2.7       13.43 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__softirqentry_text_start
> >      10.24 =C2=B1  3%      +2.7       12.90 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__netif_receive_skb_one_core
> >       9.97 =C2=B1  3%      +2.8       12.76 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.ip_local_deliver_finish
> >       9.95 =C2=B1  3%      +2.8       12.74 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.ip_protocol_deliver_rcu
> >       9.89 =C2=B1  3%      +2.8       12.69 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_rcv
> >       1.71 =C2=B1  4%      +2.9        4.57 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.native_queued_spin_lock_slowpath
> >      16.66 =C2=B1  3%      +2.9       19.59 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.____sys_recvmsg
> >      16.01 =C2=B1  3%      +3.2       19.21 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_recvmsg
> >      15.89 =C2=B1  3%      +3.2       19.12 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.inet_recvmsg
> >       1.49 =C2=B1  3%      +3.4        4.86 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp._raw_spin_lock_bh
> >       1.59 =C2=B1  3%      +3.4        4.96 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.lock_sock_nested
> >      15.60 =C2=B1  3%      +3.6       19.22 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.release_sock
> >       0.00            +3.7        3.69 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.try_charge_memcg
> >      15.33 =C2=B1  3%      +3.7       19.04 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.__release_sock
> >      15.27 =C2=B1  3%      +3.7       19.00 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_backlog_rcv
> >       0.62 =C2=B1  5%      +3.8        4.45 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_sf_eat_data_6_2
> >       0.48 =C2=B1  5%      +3.9        4.36 =C2=B1  5%  perf-profile.ch=
ildren.cycles-pp.sctp_eat_data
> >       0.00            +4.4        4.36 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.mem_cgroup_charge_skmem
> >       3.46 =C2=B1  3%      +4.4        7.91 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_chunk_put
> >      20.07 =C2=B1  3%      +4.6       24.66 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_assoc_bh_rcv
> >       0.00            +4.6        4.60 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.__sk_mem_raise_allocated
> >       0.00            +4.6        4.63 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.__sk_mem_schedule
> >      24.02 =C2=B1 12%      +4.7       28.76 =C2=B1 11%  perf-profile.ch=
ildren.cycles-pp.intel_idle
> >       2.97 =C2=B1  3%      +4.8        7.75 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_outq_sack
> >       2.11 =C2=B1  4%      +4.8        6.90 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.kfree_skb_reason
> >       2.04 =C2=B1  3%      +4.9        6.98 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.consume_skb
> >       0.37 =C2=B1  3%      +5.6        5.94 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.sctp_wfree
> >       0.95 =C2=B1  3%     +11.3       12.23 =C2=B1  4%  perf-profile.ch=
ildren.cycles-pp.skb_release_head_state
> >       0.00           +11.7       11.67 =C2=B1  4%  perf-profile.childre=
n.cycles-pp.__sk_mem_reduce_allocated
> >       8.68 =C2=B1  3%      -3.1        5.58 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.copy_user_enhanced_fast_string
> >       8.45 =C2=B1  3%      -3.0        5.46 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.memcpy_erms
> >       0.94 =C2=B1  4%      -0.4        0.57 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__slab_free
> >       0.71 =C2=B1  3%      -0.3        0.42 =C2=B1  2%  perf-profile.se=
lf.cycles-pp.sctp_chunk_put
> >       0.58 =C2=B1  3%      -0.3        0.30 =C2=B1  3%  perf-profile.se=
lf.cycles-pp.__copy_skb_header
> >       0.87 =C2=B1  3%      -0.3        0.59 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.kmem_cache_free
> >       0.58 =C2=B1  5%      -0.3        0.30 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_packet_config
> >       0.82 =C2=B1  3%      -0.3        0.55 =C2=B1  5%  perf-profile.se=
lf.cycles-pp._raw_spin_lock_irqsave
> >       0.65 =C2=B1  4%      -0.2        0.41 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__might_resched
> >       0.41 =C2=B1  4%      -0.2        0.17 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.rmqueue
> >       0.63 =C2=B1  4%      -0.2        0.40 =C2=B1  3%  perf-profile.se=
lf.cycles-pp._raw_spin_lock
> >       0.59 =C2=B1  4%      -0.2        0.36 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_recvmsg
> >       0.39 =C2=B1  4%      -0.2        0.18 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.sctp_sendmsg_to_asoc
> >       0.58 =C2=B1  3%      -0.2        0.36 =C2=B1  3%  perf-profile.se=
lf.cycles-pp._raw_spin_lock_bh
> >       0.43 =C2=B1  4%      -0.2        0.24 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_packet_pack
> >       0.39 =C2=B1  4%      -0.2        0.20 =C2=B1  2%  perf-profile.se=
lf.cycles-pp.update_load_avg
> >       0.56 =C2=B1  4%      -0.2        0.38 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.copy_user_short_string
> >       0.27 =C2=B1  5%      -0.2        0.10 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.dst_release
> >       0.32 =C2=B1  3%      -0.2        0.16 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.get_page_from_freelist
> >       0.31 =C2=B1  7%      -0.2        0.15 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.ipv4_dst_check
> >       0.30 =C2=B1  4%      -0.2        0.14 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.free_unref_page_commit
> >       0.38 =C2=B1  3%      -0.2        0.22 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.__mod_node_page_state
> >       0.54 =C2=B1  3%      -0.2        0.38 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__schedule
> >       0.47 =C2=B1  2%      -0.2        0.31 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.kfree
> >       0.34 =C2=B1  4%      -0.2        0.18 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_v4_xmit
> >       0.23 =C2=B1  4%      -0.2        0.07 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.update_curr
> >       0.32 =C2=B1 12%      -0.2        0.17 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.__rhashtable_lookup
> >       0.51 =C2=B1  4%      -0.2        0.36 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__list_del_entry_valid
> >       0.32 =C2=B1  3%      -0.2        0.17 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.__zone_watermark_ok
> >       0.42 =C2=B1  3%      -0.1        0.27 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.kmem_cache_alloc
> >       0.40 =C2=B1  5%      -0.1        0.26 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_outq_flush_data
> >       0.28 =C2=B1  4%      -0.1        0.15 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__check_object_size
> >       0.35 =C2=B1  4%      -0.1        0.22 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.__fdget
> >       0.42 =C2=B1  4%      -0.1        0.29 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_datamsg_from_user
> >       0.36 =C2=B1  5%      -0.1        0.24 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.set_next_entity
> >       0.34 =C2=B1  3%      -0.1        0.21 =C2=B1  3%  perf-profile.se=
lf.cycles-pp.check_heap_object
> >       0.34 =C2=B1  3%      -0.1        0.22 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.memcg_slab_free_hook
> >       0.32 =C2=B1  2%      -0.1        0.20 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__list_add_valid
> >       0.32 =C2=B1  5%      -0.1        0.20 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.__virt_addr_valid
> >       0.34 =C2=B1  5%      -0.1        0.22 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.__skb_datagram_iter
> >       0.34 =C2=B1  4%      -0.1        0.22 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.update_rq_clock
> >       0.37 =C2=B1  5%      -0.1        0.25 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.sctp_sendmsg
> >       0.27 =C2=B1 13%      -0.1        0.16 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_transport_hold
> >       0.35 =C2=B1  3%      -0.1        0.24 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.skb_release_data
> >       0.32 =C2=B1  4%      -0.1        0.20 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__alloc_skb
> >       0.22 =C2=B1  7%      -0.1        0.10 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_assoc_rwnd_increase
> >       0.33 =C2=B1  5%      -0.1        0.22 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.free_pcp_prepare
> >       0.31 =C2=B1  4%      -0.1        0.20 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.enqueue_task_fair
> >       0.36 =C2=B1  3%      -0.1        0.26 =C2=B1  3%  perf-profile.se=
lf.cycles-pp.enqueue_entity
> >       0.30            -0.1        0.20 =C2=B1  8%  perf-profile.self.cy=
cles-pp.sctp_association_put
> >       0.24 =C2=B1  4%      -0.1        0.14 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__alloc_pages
> >       0.30 =C2=B1  9%      -0.1        0.20 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_transport_put
> >       0.31 =C2=B1  3%      -0.1        0.21 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_skb_recv_datagram
> >       0.30 =C2=B1  4%      -0.1        0.20 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.aa_sk_perm
> >       0.33 =C2=B1  4%      -0.1        0.23 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.entry_SYSCALL_64_after_hwframe
> >       0.30 =C2=B1  3%      -0.1        0.20 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__might_sleep
> >       0.18 =C2=B1  4%      -0.1        0.09 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.____sys_recvmsg
> >       0.19 =C2=B1  5%      -0.1        0.09 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_ulpevent_free
> >       0.32 =C2=B1  3%      -0.1        0.23 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.memset_erms
> >       0.30 =C2=B1  6%      -0.1        0.21 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.kmem_cache_alloc_node
> >       0.28 =C2=B1  3%      -0.1        0.19 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.skb_set_owner_w
> >       0.23 =C2=B1  6%      -0.1        0.14 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__switch_to
> >       0.18 =C2=B1  4%      -0.1        0.10 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__update_load_avg_cfs_rq
> >       0.26 =C2=B1  4%      -0.1        0.17 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_cmd_interpreter
> >       0.25 =C2=B1  4%      -0.1        0.17 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.entry_SYSRETQ_unsafe_stack
> >       0.26            -0.1        0.18 =C2=B1  5%  perf-profile.self.cy=
cles-pp.send_sctp_stream_1toMany
> >       0.17 =C2=B1 32%      -0.1        0.09 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_cmp_addr_exact
> >       0.22 =C2=B1  5%      -0.1        0.14 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__switch_to_asm
> >       0.20 =C2=B1  2%      -0.1        0.12 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.recv_sctp_stream_1toMany
> >       0.19 =C2=B1  3%      -0.1        0.11 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sock_wfree
> >       0.10 =C2=B1  5%      -0.1        0.02 =C2=B1 99%  perf-profile.se=
lf.cycles-pp.process_backlog
> >       0.10 =C2=B1  6%      -0.1        0.02 =C2=B1 99%  perf-profile.se=
lf.cycles-pp.__free_one_page
> >       0.20 =C2=B1  4%      -0.1        0.13 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.recvmsg
> >       0.22 =C2=B1  3%      -0.1        0.14 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.consume_skb
> >       0.18 =C2=B1  3%      -0.1        0.11 =C2=B1 10%  perf-profile.se=
lf.cycles-pp._copy_from_user
> >       0.15 =C2=B1  7%      -0.1        0.08 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.___perf_sw_event
> >       0.15 =C2=B1  4%      -0.1        0.08 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.check_new_pages
> >       0.20 =C2=B1  5%      -0.1        0.13 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.available_idle_cpu
> >       0.22 =C2=B1  3%      -0.1        0.15 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__entry_text_start
> >       0.18 =C2=B1  2%      -0.1        0.11 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_assoc_bh_rcv
> >       0.13 =C2=B1  7%      -0.1        0.06 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_sock_rfree
> >       0.17 =C2=B1  4%      -0.1        0.11 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.syscall_return_via_sysret
> >       0.13 =C2=B1  5%      -0.1        0.07 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.__free_pages_ok
> >       0.20 =C2=B1  5%      -0.1        0.14 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_datamsg_put
> >       0.19 =C2=B1  3%      -0.1        0.12 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.sendmsg
> >       0.18 =C2=B1  4%      -0.1        0.12 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.reweight_entity
> >       0.14 =C2=B1  7%      -0.1        0.07 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.sctp_inet_skb_msgname
> >       0.23 =C2=B1  3%      -0.1        0.17 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_wfree
> >       0.19 =C2=B1  3%      -0.1        0.13 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.update_cfs_group
> >       0.17 =C2=B1  4%      -0.1        0.11 =C2=B1  3%  perf-profile.se=
lf.cycles-pp.nr_iowait_cpu
> >       0.17 =C2=B1  7%      -0.1        0.11 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_packet_transmit
> >       0.08 =C2=B1 18%      -0.1        0.02 =C2=B1 99%  perf-profile.se=
lf.cycles-pp.sctp_ulpq_tail_data
> >       0.17 =C2=B1  7%      -0.1        0.11 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_packet_append_chunk
> >       0.19 =C2=B1  4%      -0.1        0.13 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_do_sm
> >       0.18 =C2=B1  2%      -0.1        0.12 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.__free_pages
> >       0.17 =C2=B1  5%      -0.1        0.12 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.__wake_up_common
> >       0.16 =C2=B1  6%      -0.1        0.10 =C2=B1  3%  perf-profile.se=
lf.cycles-pp.sctp_sendmsg_parse
> >       0.15 =C2=B1  6%      -0.1        0.09 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.try_to_wake_up
> >       0.10 =C2=B1  3%      -0.1        0.04 =C2=B1 45%  perf-profile.se=
lf.cycles-pp.__build_skb_around
> >       0.15 =C2=B1  6%      -0.1        0.09 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_check_transmitted
> >       0.08 =C2=B1 14%      -0.1        0.03 =C2=B1101%  perf-profile.se=
lf.cycles-pp.select_task_rq_fair
> >       0.12 =C2=B1  6%      -0.1        0.06 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.dequeue_entity
> >       0.19 =C2=B1  4%      -0.1        0.14 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.sctp_hash_cmp
> >       0.14 =C2=B1  4%      -0.1        0.09 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.switch_mm_irqs_off
> >       0.16 =C2=B1  4%      -0.1        0.10 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.poll_idle
> >       0.22 =C2=B1  8%      -0.1        0.17 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.sctp_rcv
> >       0.11 =C2=B1  4%      -0.1        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.__ip_queue_xmit
> >       0.12 =C2=B1 10%      -0.1        0.08 =C2=B1 24%  perf-profile.se=
lf.cycles-pp.__sctp_packet_append_chunk
> >       0.13 =C2=B1  2%      -0.0        0.08 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.sctp_inq_pop
> >       0.18 =C2=B1  3%      -0.0        0.13 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.__update_load_avg_se
> >       0.14 =C2=B1  5%      -0.0        0.09 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.do_syscall_64
> >       0.11 =C2=B1  6%      -0.0        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp._copy_to_iter
> >       0.09 =C2=B1 11%      -0.0        0.04 =C2=B1 76%  perf-profile.se=
lf.cycles-pp.sctp_chunk_assign_ssn
> >       0.14 =C2=B1  3%      -0.0        0.10 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.____sys_sendmsg
> >       0.12 =C2=B1  4%      -0.0        0.07 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.___sys_recvmsg
> >       0.20 =C2=B1  2%      -0.0        0.15 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_association_hold
> >       0.17 =C2=B1  3%      -0.0        0.12 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__skb_clone
> >       0.14 =C2=B1  3%      -0.0        0.09 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__copy_msghdr_from_user
> >       0.13 =C2=B1  5%      -0.0        0.08 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_sf_eat_data_6_2
> >       0.13 =C2=B1  2%      -0.0        0.09 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.sctp_outq_tail
> >       0.20 =C2=B1  4%      -0.0        0.16 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.read_tsc
> >       0.13 =C2=B1  5%      -0.0        0.08 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__import_iovec
> >       0.13 =C2=B1  6%      -0.0        0.08 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__genradix_ptr
> >       0.11 =C2=B1  8%      -0.0        0.07 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.select_task_rq
> >       0.12 =C2=B1  3%      -0.0        0.08 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.resched_curr
> >       0.13 =C2=B1  5%      -0.0        0.09 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.pick_next_entity
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.__put_user_nocheck_4
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_chunk_abandoned
> >       0.10 =C2=B1  7%      -0.0        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.syscall_exit_to_user_mode_prepare
> >       0.07 =C2=B1  7%      -0.0        0.02 =C2=B1 99%  perf-profile.se=
lf.cycles-pp.ip_rcv_core
> >       0.13 =C2=B1  7%      -0.0        0.09 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_sched_dequeue_common
> >       0.13 =C2=B1  7%      -0.0        0.09 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.ip_finish_output2
> >       0.12 =C2=B1  6%      -0.0        0.08 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.memcg_slab_post_alloc_hook
> >       0.08 =C2=B1  6%      -0.0        0.04 =C2=B1 71%  perf-profile.se=
lf.cycles-pp._sctp_make_chunk
> >       0.10 =C2=B1  4%      -0.0        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.net_rx_action
> >       0.10 =C2=B1  5%      -0.0        0.06 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.sctp_addto_chunk
> >       0.09 =C2=B1  6%      -0.0        0.05 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__netif_receive_skb_core
> >       0.12 =C2=B1  5%      -0.0        0.08 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__kmalloc
> >       0.11 =C2=B1  5%      -0.0        0.07 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.__put_user_nocheck_8
> >       0.18 =C2=B1  6%      -0.0        0.15 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.native_sched_clock
> >       0.09 =C2=B1  5%      -0.0        0.06 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.check_stack_object
> >       0.07            -0.0        0.03 =C2=B1 70%  perf-profile.self.cy=
cles-pp.__mod_lruvec_page_state
> >       0.16 =C2=B1  4%      -0.0        0.12 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.sctp_outq_flush
> >       0.10 =C2=B1  3%      -0.0        0.06 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.skb_put
> >       0.06 =C2=B1  6%      -0.0        0.02 =C2=B1 99%  perf-profile.se=
lf.cycles-pp.entry_SYSCALL_64_safe_stack
> >       0.10 =C2=B1  4%      -0.0        0.07 =C2=B1 15%  perf-profile.se=
lf.cycles-pp.__might_fault
> >       0.12 =C2=B1  5%      -0.0        0.08 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.kmem_cache_alloc_trace
> >       0.07 =C2=B1  8%      -0.0        0.04 =C2=B1 71%  perf-profile.se=
lf.cycles-pp.sockfd_lookup_light
> >       0.10 =C2=B1  7%      -0.0        0.07 =C2=B1 10%  perf-profile.se=
lf.cycles-pp.__cond_resched
> >       0.09 =C2=B1  6%      -0.0        0.06 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.os_xsave
> >       0.09 =C2=B1  6%      -0.0        0.06 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.free_unref_page
> >       0.09 =C2=B1  7%      -0.0        0.06 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.security_socket_recvmsg
> >       0.11 =C2=B1  4%      -0.0        0.08 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.__local_bh_enable_ip
> >       0.12 =C2=B1  4%      -0.0        0.09 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.sock_kmalloc
> >       0.09 =C2=B1  6%      -0.0        0.06 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_user_addto_chunk
> >       0.07 =C2=B1  6%      -0.0        0.04 =C2=B1 44%  perf-profile.se=
lf.cycles-pp.rcu_all_qs
> >       0.10 =C2=B1  5%      -0.0        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_outq_sack
> >       0.09 =C2=B1  4%      -0.0        0.06 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.sctp_outq_select_transport
> >       0.10 =C2=B1  3%      -0.0        0.07 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.__kmalloc_node_track_caller
> >       0.08 =C2=B1  5%      -0.0        0.05 =C2=B1 46%  perf-profile.se=
lf.cycles-pp.sctp_ulpevent_init
> >       0.12 =C2=B1  4%      -0.0        0.08 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.__check_heap_object
> >       0.07 =C2=B1 11%      -0.0        0.04 =C2=B1 44%  perf-profile.se=
lf.cycles-pp.loopback_xmit
> >       0.14 =C2=B1  2%      -0.0        0.12 =C2=B1  6%  perf-profile.se=
lf.cycles-pp.do_idle
> >       0.11 =C2=B1  4%      -0.0        0.08 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.cpuidle_idle_call
> >       0.09            -0.0        0.06 =C2=B1 11%  perf-profile.self.cy=
cles-pp._copy_from_iter
> >       0.08 =C2=B1  5%      -0.0        0.06 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.kmalloc_large_node
> >       0.08 =C2=B1  5%      -0.0        0.06 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sctp_chunkify
> >       0.09 =C2=B1  4%      -0.0        0.06 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.iovec_from_user
> >       0.14 =C2=B1  4%      -0.0        0.12 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.sctp_ulpevent_make_rcvmsg
> >       0.07 =C2=B1  6%      -0.0        0.05 =C2=B1  7%  perf-profile.se=
lf.cycles-pp.sctp_tsnmap_check
> >       0.08 =C2=B1  6%      -0.0        0.06 =C2=B1  9%  perf-profile.se=
lf.cycles-pp.sock_kfree_s
> >       0.08 =C2=B1  5%      -0.0        0.06 =C2=B1 11%  perf-profile.se=
lf.cycles-pp.skb_release_head_state
> >       0.07 =C2=B1  8%      -0.0        0.05        perf-profile.self.cy=
cles-pp.__wrgsbase_inactive
> >       0.09 =C2=B1  8%      -0.0        0.07 =C2=B1 13%  perf-profile.se=
lf.cycles-pp.__softirqentry_text_start
> >       0.07 =C2=B1  5%      -0.0        0.05 =C2=B1  8%  perf-profile.se=
lf.cycles-pp.__sys_recvmsg
> >       0.18 =C2=B1  4%      +0.0        0.22 =C2=B1 12%  perf-profile.se=
lf.cycles-pp.menu_select
> >       0.00            +0.1        0.06 =C2=B1 19%  perf-profile.self.cy=
cles-pp.update_sg_lb_stats
> >       0.00            +0.1        0.06 =C2=B1  7%  perf-profile.self.cy=
cles-pp.lapic_next_deadline
> >       0.00            +0.1        0.07 =C2=B1 16%  perf-profile.self.cy=
cles-pp.native_irq_return_iret
> >       0.09 =C2=B1  4%      +0.1        0.16 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.cpuidle_enter_state
> >       0.00            +0.1        0.08 =C2=B1 41%  perf-profile.self.cy=
cles-pp._raw_spin_trylock
> >       0.00            +0.1        0.09 =C2=B1 54%  perf-profile.self.cy=
cles-pp.tick_nohz_next_event
> >       0.01 =C2=B1223%      +0.1        0.13 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.sctp_get_af_specific
> >       0.00            +0.1        0.13 =C2=B1  6%  perf-profile.self.cy=
cles-pp.mem_cgroup_charge_skmem
> >       0.00            +0.1        0.14 =C2=B1 19%  perf-profile.self.cy=
cles-pp.cgroup_rstat_updated
> >       0.25 =C2=B1  6%      +0.2        0.43 =C2=B1 14%  perf-profile.se=
lf.cycles-pp.ktime_get
> >       0.00            +0.2        0.20 =C2=B1 16%  perf-profile.self.cy=
cles-pp.timekeeping_max_deferment
> >       0.00            +0.2        0.22 =C2=B1  6%  perf-profile.self.cy=
cles-pp.refill_stock
> >       0.00            +0.3        0.25 =C2=B1  9%  perf-profile.self.cy=
cles-pp.__sk_mem_raise_allocated
> >       0.00            +0.3        0.32 =C2=B1 12%  perf-profile.self.cy=
cles-pp.propagate_protected_usage
> >       0.00            +0.9        0.89 =C2=B1  4%  perf-profile.self.cy=
cles-pp.__mod_memcg_state
> >       0.00            +1.3        1.27 =C2=B1  5%  perf-profile.self.cy=
cles-pp.try_charge_memcg
> >       0.00            +2.1        2.10 =C2=B1  5%  perf-profile.self.cy=
cles-pp.page_counter_uncharge
> >       0.00            +2.2        2.23 =C2=B1  5%  perf-profile.self.cy=
cles-pp.page_counter_try_charge
> >       1.70 =C2=B1  4%      +2.8        4.54 =C2=B1  4%  perf-profile.se=
lf.cycles-pp.native_queued_spin_lock_slowpath
> >       0.29 =C2=B1  5%      +4.0        4.24 =C2=B1  5%  perf-profile.se=
lf.cycles-pp.sctp_eat_data
> >       0.00            +8.6        8.55 =C2=B1  4%  perf-profile.self.cy=
cles-pp.__sk_mem_reduce_allocated
> >
> >
> >
> >
> >
> > Disclaimer:
> > Results have been estimated based on internal Intel analysis and are pr=
ovided
> > for informational purposes only. Any difference in system hardware or s=
oftware
> > design or configuration may affect actual performance.
> >
> >
>
