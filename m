Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E67E32C418
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354793AbhCDALD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:16871 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350921AbhCCKr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 05:47:26 -0500
IronPort-SDR: MvjYIMaPmuh3x2N2hYskEveFHNynnPfU5QPP8JhukVHSJIpvBuU91UnR8YV2dWBynYAfjYzTgE
 FFxLcGktnwhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="206826280"
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="yaml'?scan'208";a="206826280"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 00:45:15 -0800
IronPort-SDR: 6bk5fvdEHj2Ls7ajXAi6uUHRuyG1nhEvgFgzxx6QrJN+X52To0Le4I6Nl05Hn7fsfY32znBte6
 TR19nTraC3Lg==
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="yaml'?scan'208";a="445169561"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.140])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 00:45:10 -0800
Date:   Wed, 3 Mar 2021 17:00:33 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Honglei Wang <redsky110@gmail.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, ying.huang@intel.com, feng.tang@intel.com,
        zhengjun.xing@intel.com, davem@davemloft.net, edumazet@google.com,
        netdev@vger.kernel.org, redsky110@gmail.com
Subject: [tcp]  ff0d41306d:  stress-ng.sockmany.ops_per_sec 338.2% improvement
Message-ID: <20210303090033.GF2708@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2hMgfIw2X+zgXrFs"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210220110356.84399-1-redsky110@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Greeting,

FYI, we noticed a 338.2% improvement of stress-ng.sockmany.ops_per_sec due to commit:


commit: ff0d41306d8c7b91c21707559ef67f13e55b3406 ("[PATCH] tcp: avoid unnecessary loop if even ports are used up")
url: https://github.com/0day-ci/linux/commits/Honglei-Wang/tcp-avoid-unnecessary-loop-if-even-ports-are-used-up/20210220-200541
base: https://git.kernel.org/cgit/linux/kernel/git/davem/net.git 3af409ca278d4a8d50e91f9f7c4c33b175645cf3

in testcase: stress-ng
on test machine: 96 threads Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 192G memory
with following parameters:

	nr_threads: 100%
	disk: 1HDD
	testtime: 60s
	class: network
	test: sockmany
	cpufreq_governor: performance
	ucode: 0x5003006


In addition to that, the commit also has significant impact on the following tests:

+------------------+----------------------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.sockmany.ops_per_sec 572.1% improvement         |
| test machine     | 96 threads Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 192G memory |
| test parameters  | class=os                                                             |
|                  | cpufreq_governor=performance                                         |
|                  | disk=1HDD                                                            |
|                  | fs=ext4                                                              |
|                  | nr_threads=10%                                                       |
|                  | test=sockmany                                                        |
|                  | testtime=60s                                                         |
|                  | ucode=0x5003006                                                      |
+------------------+----------------------------------------------------------------------+




Details are as below:
-------------------------------------------------------------------------------------------------->


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install                job.yaml  # job file is attached in this email
        bin/lkp split-job --compatible job.yaml
        bin/lkp run                    compatible-job.yaml

=========================================================================================
class/compiler/cpufreq_governor/disk/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime/ucode:
  network/gcc-9/performance/1HDD/x86_64-rhel-8.3/100%/debian-10.4-x86_64-20200603.cgz/lkp-csl-2sp5/sockmany/stress-ng/60s/0x5003006

commit: 
  3af409ca27 ("net: enetc: fix destroyed phylink dereference during unbind")
  ff0d41306d ("tcp: avoid unnecessary loop if even ports are used up")

3af409ca278d4a8d ff0d41306d8c7b91c21707559ef 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   1968948          +337.5%    8614180 ±  2%  stress-ng.sockmany.ops
     32487          +338.2%     142359 ±  2%  stress-ng.sockmany.ops_per_sec
   1964201          +332.8%    8501580 ±  2%  stress-ng.time.involuntary_context_switches
      9018            -4.3%       8627        stress-ng.time.percent_of_cpu_this_job_got
      5651            -4.4%       5403        stress-ng.time.system_time
   2031507          +332.9%    8794405 ±  2%  stress-ng.time.voluntary_context_switches
    128079 ± 55%     +96.4%     251510 ± 31%  cpuidle.C1.usage
    335719 ± 51%     +89.1%     634765 ± 17%  cpuidle.C1E.usage
   2651720           +11.7%    2963054        vmstat.memory.cache
     63209          +324.8%     268490 ±  2%  vmstat.system.cs
      0.99            +0.1        1.12 ±  2%  mpstat.cpu.all.irq%
      1.56            +3.6        5.13 ±  2%  mpstat.cpu.all.soft%
      0.23            +0.1        0.36 ±  2%  mpstat.cpu.all.usr%
    287823 ± 12%    +128.3%     657171 ±  5%  numa-numastat.node0.local_node
    340321 ±  2%    +102.8%     690114        numa-numastat.node0.numa_hit
    340485 ± 10%     +94.9%     663744 ±  2%  numa-numastat.node1.local_node
    374587 ±  2%     +91.5%     717404 ±  2%  numa-numastat.node1.numa_hit
   1631924           +18.7%    1937517        meminfo.KReclaimable
   8668029           +12.5%    9749676        meminfo.Memused
   1631924           +18.7%    1937517        meminfo.SReclaimable
   4430317           +18.0%    5225972        meminfo.SUnreclaim
   6062242           +18.2%    7163489        meminfo.Slab
   8724017           +33.7%   11666875        meminfo.max_used_kB
    405237           +20.1%     486839        proc-vmstat.nr_slab_reclaimable
   1099299           +19.5%    1313379        proc-vmstat.nr_slab_unreclaimable
    747588           +92.3%    1437790        proc-vmstat.numa_hit
    660960          +104.4%    1351164 ±  2%  proc-vmstat.numa_local
     27094 ±  2%      -6.7%      25291 ±  4%  proc-vmstat.pgactivate
   2303828          +155.2%    5878562 ±  2%  proc-vmstat.pgalloc_normal
   1813432 ± 19%    +171.9%    4930494 ± 14%  proc-vmstat.pgfree
    122980 ±  7%     -48.5%      63324 ± 30%  sched_debug.cfs_rq:/.spread0.avg
    401.35 ±  3%     +21.9%     489.32 ±  2%  sched_debug.cfs_rq:/.util_est_enqueued.avg
    559.81 ±  4%     +15.1%     644.44 ±  5%  sched_debug.cpu.clock_task.stddev
     22854          +291.9%      89556 ±  3%  sched_debug.cpu.nr_switches.avg
     31316 ±  3%    +313.1%     129359 ±  5%  sched_debug.cpu.nr_switches.max
      9328 ± 28%    +521.5%      57972 ± 13%  sched_debug.cpu.nr_switches.min
      2292 ± 11%    +455.8%      12742 ±  7%  sched_debug.cpu.nr_switches.stddev
    204017           +23.8%     252546 ±  5%  numa-vmstat.node0.nr_slab_reclaimable
    555391           +22.5%     680395 ±  3%  numa-vmstat.node0.nr_slab_unreclaimable
    953619 ±  4%     +20.0%    1144710 ±  4%  numa-vmstat.node0.numa_hit
    899530 ±  3%     +21.1%    1089217 ±  7%  numa-vmstat.node0.numa_local
    201468           +14.7%     231159 ±  6%  numa-vmstat.node1.nr_slab_reclaimable
    544805           +14.6%     624239 ±  4%  numa-vmstat.node1.nr_slab_unreclaimable
    927332 ±  4%     +23.4%    1144293 ±  5%  numa-vmstat.node1.numa_hit
    738221 ±  3%     +29.6%     956639 ±  8%  numa-vmstat.node1.numa_local
    817215           +24.4%    1016626 ±  5%  numa-meminfo.node0.KReclaimable
   4372400 ±  2%     +15.4%    5046004 ±  4%  numa-meminfo.node0.MemUsed
    817215           +24.4%    1016626 ±  5%  numa-meminfo.node0.SReclaimable
   2224145           +23.2%    2739496 ±  3%  numa-meminfo.node0.SUnreclaim
   3041360           +23.5%    3756123 ±  3%  numa-meminfo.node0.Slab
    807671           +15.2%     930583 ±  6%  numa-meminfo.node1.KReclaimable
   4264803           +11.2%    4740532 ±  4%  numa-meminfo.node1.MemUsed
    807671           +15.2%     930583 ±  6%  numa-meminfo.node1.SReclaimable
   2184118           +15.0%    2511438 ±  4%  numa-meminfo.node1.SUnreclaim
   2991790           +15.0%    3442022 ±  4%  numa-meminfo.node1.Slab
    100.50 ± 38%     +69.3%     170.17 ± 41%  interrupts.CPU11.RES:Rescheduling_interrupts
     81.00 ± 10%    +101.2%     163.00 ± 60%  interrupts.CPU12.RES:Rescheduling_interrupts
    514.67 ±  3%     +28.9%     663.50 ± 37%  interrupts.CPU13.CAL:Function_call_interrupts
     83.17 ± 14%     +71.3%     142.50 ± 20%  interrupts.CPU15.RES:Rescheduling_interrupts
    467.33 ± 15%     +66.4%     777.83 ± 64%  interrupts.CPU18.CAL:Function_call_interrupts
     85.83 ± 16%    +441.6%     464.83 ±132%  interrupts.CPU18.RES:Rescheduling_interrupts
     82.67 ± 16%    +303.6%     333.67 ±114%  interrupts.CPU19.RES:Rescheduling_interrupts
      1557 ± 47%     -58.5%     646.50 ± 32%  interrupts.CPU2.CAL:Function_call_interrupts
     97.17 ± 29%     +45.1%     141.00 ± 21%  interrupts.CPU20.RES:Rescheduling_interrupts
     96.50 ± 23%     +53.9%     148.50 ± 38%  interrupts.CPU29.RES:Rescheduling_interrupts
    120.17 ± 12%    +586.7%     825.17 ± 87%  interrupts.CPU3.RES:Rescheduling_interrupts
     95.17 ± 14%    +213.8%     298.67 ±113%  interrupts.CPU30.RES:Rescheduling_interrupts
     83.17 ± 13%    +238.9%     281.83 ±120%  interrupts.CPU33.RES:Rescheduling_interrupts
     81.00 ± 12%     +53.1%     124.00 ± 27%  interrupts.CPU35.RES:Rescheduling_interrupts
     83.33 ± 22%     +51.8%     126.50 ± 10%  interrupts.CPU37.RES:Rescheduling_interrupts
     86.33 ± 29%     +89.0%     163.17 ± 39%  interrupts.CPU39.RES:Rescheduling_interrupts
     80.83 ± 16%    +324.7%     343.33 ±128%  interrupts.CPU40.RES:Rescheduling_interrupts
     90.33 ± 34%     +99.8%     180.50 ± 46%  interrupts.CPU45.RES:Rescheduling_interrupts
     84.33 ± 20%     +85.2%     156.17 ± 10%  interrupts.CPU47.RES:Rescheduling_interrupts
    103.17 ±  7%     +71.6%     177.00 ± 28%  interrupts.CPU48.RES:Rescheduling_interrupts
    105.83 ± 11%     +28.0%     135.50 ± 16%  interrupts.CPU49.RES:Rescheduling_interrupts
     88.83 ± 14%     +68.5%     149.67 ± 25%  interrupts.CPU54.RES:Rescheduling_interrupts
     82.17 ± 14%     +56.0%     128.17 ± 26%  interrupts.CPU55.RES:Rescheduling_interrupts
     83.00 ± 20%    +106.4%     171.33 ± 45%  interrupts.CPU57.RES:Rescheduling_interrupts
     79.83 ± 13%     +82.5%     145.67 ± 43%  interrupts.CPU59.RES:Rescheduling_interrupts
     87.17 ± 15%     +80.1%     157.00 ± 35%  interrupts.CPU6.RES:Rescheduling_interrupts
     87.83 ± 17%    +136.2%     207.50 ± 47%  interrupts.CPU61.RES:Rescheduling_interrupts
     86.00 ± 11%     +64.3%     141.33 ± 21%  interrupts.CPU62.RES:Rescheduling_interrupts
     86.00 ± 12%     +61.4%     138.83 ± 19%  interrupts.CPU65.RES:Rescheduling_interrupts
     84.33 ± 13%     +95.5%     164.83 ± 46%  interrupts.CPU66.RES:Rescheduling_interrupts
     94.50 ± 26%    +255.2%     335.67 ±120%  interrupts.CPU7.RES:Rescheduling_interrupts
     91.67 ±  9%     +29.8%     119.00 ± 18%  interrupts.CPU73.RES:Rescheduling_interrupts
     83.17 ± 12%    +223.4%     269.00 ± 70%  interrupts.CPU79.RES:Rescheduling_interrupts
     90.00 ± 11%     +80.6%     162.50 ± 37%  interrupts.CPU8.RES:Rescheduling_interrupts
     79.33 ± 12%     +50.2%     119.17 ± 26%  interrupts.CPU80.RES:Rescheduling_interrupts
     76.17 ± 11%    +324.1%     323.00 ±139%  interrupts.CPU88.RES:Rescheduling_interrupts
     78.67 ± 16%     +61.0%     126.67 ± 32%  interrupts.CPU93.RES:Rescheduling_interrupts
     72.67 ±  5%     +41.1%     102.50 ±  8%  interrupts.CPU94.RES:Rescheduling_interrupts
    137.17 ±  6%     +49.3%     204.83 ± 19%  interrupts.CPU95.RES:Rescheduling_interrupts
     10764 ± 10%     +49.7%      16119 ±  6%  interrupts.RES:Rescheduling_interrupts
   1537929           +19.1%    1830994        slabinfo.TCP.active_objs
    109941           +20.8%     132811        slabinfo.TCP.active_slabs
   1539186           +20.8%    1859366        slabinfo.TCP.num_objs
    109941           +20.8%     132811        slabinfo.TCP.num_slabs
   1613836           +17.9%    1903094        slabinfo.dentry.active_objs
     38427           +18.1%      45397        slabinfo.dentry.active_slabs
   1613982           +18.1%    1906701        slabinfo.dentry.num_objs
     38427           +18.1%      45397        slabinfo.dentry.num_slabs
     42469 ± 17%     +64.3%      69770 ±  5%  slabinfo.dmaengine-unmap-16.active_objs
      1010 ± 17%     +64.8%       1665 ±  5%  slabinfo.dmaengine-unmap-16.active_slabs
     42469 ± 17%     +64.8%      69981 ±  5%  slabinfo.dmaengine-unmap-16.num_objs
      1010 ± 17%     +64.8%       1665 ±  5%  slabinfo.dmaengine-unmap-16.num_slabs
   1551220           +19.3%    1849910        slabinfo.filp.active_objs
     48507           +21.4%      58887        slabinfo.filp.active_slabs
   1552268           +21.4%    1884408        slabinfo.filp.num_objs
     48507           +21.4%      58887        slabinfo.filp.num_slabs
    115939           +25.6%     145663        slabinfo.kmalloc-128.active_objs
      3624           +36.7%       4956        slabinfo.kmalloc-128.active_slabs
    115994           +36.7%     158610        slabinfo.kmalloc-128.num_objs
      3624           +36.7%       4956        slabinfo.kmalloc-128.num_slabs
   1567458           +19.7%    1877025        slabinfo.kmalloc-16.active_objs
      6125           +22.2%       7486        slabinfo.kmalloc-16.active_slabs
   1568110           +22.2%    1916606        slabinfo.kmalloc-16.num_objs
      6125           +22.2%       7486        slabinfo.kmalloc-16.num_slabs
      2454 ± 11%     -17.6%       2021 ± 14%  slabinfo.kmalloc-1k.active_slabs
     78563 ± 11%     -17.6%      64710 ± 14%  slabinfo.kmalloc-1k.num_objs
      2454 ± 11%     -17.6%       2021 ± 14%  slabinfo.kmalloc-1k.num_slabs
     55291           +23.7%      68386        slabinfo.kmalloc-256.active_objs
      1728           +35.2%       2336        slabinfo.kmalloc-256.active_slabs
     55314           +35.2%      74789        slabinfo.kmalloc-256.num_objs
      1728           +35.2%       2336        slabinfo.kmalloc-256.num_slabs
     88755           +18.9%     105533        slabinfo.kmalloc-512.active_objs
      2777           +31.2%       3644        slabinfo.kmalloc-512.active_slabs
     88898           +31.2%     116650        slabinfo.kmalloc-512.num_objs
      2777           +31.2%       3644        slabinfo.kmalloc-512.num_slabs
   1553431           +18.9%    1847560        slabinfo.lsm_file_cache.active_objs
      9138           +19.5%      10919        slabinfo.lsm_file_cache.active_slabs
   1553573           +19.5%    1856425        slabinfo.lsm_file_cache.num_objs
      9138           +19.5%      10919        slabinfo.lsm_file_cache.num_slabs
     60863 ±  9%     -17.0%      50516 ± 15%  slabinfo.skbuff_fclone_cache.active_objs
      2348 ±  9%     -17.5%       1936 ± 13%  slabinfo.skbuff_fclone_cache.active_slabs
     75158 ±  9%     -17.5%      61980 ± 13%  slabinfo.skbuff_fclone_cache.num_objs
      2348 ±  9%     -17.5%       1936 ± 13%  slabinfo.skbuff_fclone_cache.num_slabs
   1547186           +19.2%    1844129        slabinfo.sock_inode_cache.active_objs
     39692           +21.3%      48161        slabinfo.sock_inode_cache.active_slabs
   1548020           +21.3%    1878297        slabinfo.sock_inode_cache.num_objs
     39692           +21.3%      48161        slabinfo.sock_inode_cache.num_slabs
     36.65            -9.4%      33.21        perf-stat.i.MPKI
      2.20            -0.2        2.05        perf-stat.i.branch-miss-rate%
  1.94e+08            -6.8%  1.808e+08        perf-stat.i.branch-misses
 9.187e+08            -6.5%  8.586e+08        perf-stat.i.cache-misses
 1.649e+09            -7.8%  1.521e+09        perf-stat.i.cache-references
     66115          +324.9%     280914 ±  2%  perf-stat.i.context-switches
      5.66            -2.3%       5.53        perf-stat.i.cpi
    779.30 ± 57%    +178.0%       2166 ± 42%  perf-stat.i.cpu-migrations
    334.97            +6.9%     358.10        perf-stat.i.cycles-between-cache-misses
 1.389e+10            +3.9%  1.443e+10        perf-stat.i.dTLB-loads
      0.02 ±  8%      +0.0        0.04 ±  5%  perf-stat.i.dTLB-store-miss-rate%
   1519777 ±  8%    +110.9%    3205350 ±  5%  perf-stat.i.dTLB-store-misses
 6.481e+09           +14.1%  7.396e+09        perf-stat.i.dTLB-stores
     92.64            -1.5       91.17        perf-stat.i.iTLB-load-miss-rate%
   6311216          +388.0%   30801112 ±  3%  perf-stat.i.iTLB-load-misses
    751765 ±  5%    +263.0%    2728968 ±  3%  perf-stat.i.iTLB-loads
 4.442e+10            +3.7%  4.607e+10        perf-stat.i.instructions
     12789           -85.1%       1906 ±  2%  perf-stat.i.instructions-per-iTLB-miss
      0.20            +3.8%       0.21        perf-stat.i.ipc
      0.31           -58.8%       0.13 ± 15%  perf-stat.i.metric.K/sec
    332.55            +4.1%     346.29        perf-stat.i.metric.M/sec
     40.59            +3.3       43.89        perf-stat.i.node-load-miss-rate%
 3.012e+08            -4.0%  2.891e+08        perf-stat.i.node-load-misses
 4.622e+08           -17.2%  3.828e+08        perf-stat.i.node-loads
     94.89            -6.3       88.58        perf-stat.i.node-store-miss-rate%
 1.016e+08 ±  3%      +8.2%  1.099e+08        perf-stat.i.node-store-misses
   2293688 ±  3%    +338.0%   10046935 ±  2%  perf-stat.i.node-stores
     37.12           -11.1%      33.01        perf-stat.overall.MPKI
      2.15            -0.2        1.99        perf-stat.overall.branch-miss-rate%
      5.74            -3.8%       5.52        perf-stat.overall.cpi
    277.31            +6.9%     296.39        perf-stat.overall.cycles-between-cache-misses
      0.02 ±  8%      +0.0        0.04 ±  5%  perf-stat.overall.dTLB-store-miss-rate%
     89.35            +2.5       91.87        perf-stat.overall.iTLB-load-miss-rate%
      7035           -78.7%       1496 ±  2%  perf-stat.overall.instructions-per-iTLB-miss
      0.17            +3.9%       0.18        perf-stat.overall.ipc
     39.46            +3.5       43.01        perf-stat.overall.node-load-miss-rate%
     97.79            -6.2       91.63        perf-stat.overall.node-store-miss-rate%
 1.909e+08            -6.7%   1.78e+08        perf-stat.ps.branch-misses
 9.042e+08            -6.6%  8.444e+08        perf-stat.ps.cache-misses
 1.623e+09            -7.8%  1.497e+09        perf-stat.ps.cache-references
     65106          +324.6%     276427 ±  2%  perf-stat.ps.context-switches
    767.80 ± 57%    +178.0%       2134 ± 42%  perf-stat.ps.cpu-migrations
 1.367e+10            +3.9%  1.421e+10        perf-stat.ps.dTLB-loads
   1497010 ±  8%    +110.7%    3153486 ±  5%  perf-stat.ps.dTLB-store-misses
 6.377e+09           +14.2%  7.281e+09        perf-stat.ps.dTLB-stores
   6213710          +388.2%   30337117 ±  3%  perf-stat.ps.iTLB-load-misses
    740380 ±  5%    +262.9%    2687156 ±  4%  perf-stat.ps.iTLB-loads
 4.371e+10            +3.7%  4.535e+10        perf-stat.ps.instructions
 2.965e+08            -4.2%  2.841e+08        perf-stat.ps.node-load-misses
 4.549e+08           -17.3%  3.764e+08        perf-stat.ps.node-loads
  99918589 ±  3%      +8.3%  1.082e+08        perf-stat.ps.node-store-misses
   2258701 ±  3%    +337.8%    9888880 ±  3%  perf-stat.ps.node-stores
 2.787e+12            +3.7%  2.891e+12        perf-stat.total.instructions
     75.43           -13.7       61.68 ±  3%  perf-profile.calltrace.cycles-pp.__inet_check_established.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect
     23.97            -6.2       17.77        perf-profile.calltrace.cycles-pp._raw_spin_lock.__inet_check_established.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect
     99.12            -5.4       93.67        perf-profile.calltrace.cycles-pp.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect.__sys_connect
     99.47            -4.8       94.65        perf-profile.calltrace.cycles-pp.tcp_v4_connect.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect
     99.67            -3.7       95.92        perf-profile.calltrace.cycles-pp.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64
     99.67            -3.7       95.93        perf-profile.calltrace.cycles-pp.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
     99.67            -3.7       95.95        perf-profile.calltrace.cycles-pp.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
     99.67            -3.7       95.95        perf-profile.calltrace.cycles-pp.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
     99.87            -1.3       98.59        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.08            -0.4        0.70 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.__inet_check_established.__inet_hash_connect.tcp_v4_connect
     99.94            -0.3       99.60        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      1.00            -0.2        0.76 ±  2%  perf-profile.calltrace.cycles-pp.inet_ehashfn.__inet_check_established.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect
      0.00            +0.7        0.65 ± 17%  perf-profile.calltrace.cycles-pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.inet_shutdown
      0.00            +0.7        0.68 ± 15%  perf-profile.calltrace.cycles-pp.tcp_rcv_state_process.tcp_v4_do_rcv.__release_sock.release_sock.__inet_stream_connect
      0.00            +0.7        0.70 ± 18%  perf-profile.calltrace.cycles-pp.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.inet_shutdown.__sys_shutdown
      0.00            +0.7        0.70 ± 15%  perf-profile.calltrace.cycles-pp.tcp_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect.__sys_connect
      0.00            +0.7        0.73 ± 15%  perf-profile.calltrace.cycles-pp.tcp_rcv_synsent_state_process.tcp_rcv_state_process.tcp_v4_do_rcv.__release_sock.release_sock
      0.00            +0.8        0.79 ± 18%  perf-profile.calltrace.cycles-pp.tcp_write_xmit.__tcp_push_pending_frames.inet_shutdown.__sys_shutdown.__x64_sys_shutdown
      0.00            +0.8        0.79 ± 18%  perf-profile.calltrace.cycles-pp.__tcp_push_pending_frames.inet_shutdown.__sys_shutdown.__x64_sys_shutdown.do_syscall_64
      0.00            +0.9        0.91 ± 19%  perf-profile.calltrace.cycles-pp.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.00            +0.9        0.94 ± 20%  perf-profile.calltrace.cycles-pp.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.00            +1.0        0.98 ± 19%  perf-profile.calltrace.cycles-pp.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.00            +1.0        0.99 ± 19%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.00            +1.0        1.05 ± 15%  perf-profile.calltrace.cycles-pp.tcp_v4_do_rcv.__release_sock.release_sock.__inet_stream_connect.inet_stream_connect
      0.00            +1.1        1.09 ± 19%  perf-profile.calltrace.cycles-pp.inet_shutdown.__sys_shutdown.__x64_sys_shutdown.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.1        1.14 ± 19%  perf-profile.calltrace.cycles-pp.__x64_sys_shutdown.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.1        1.14 ± 19%  perf-profile.calltrace.cycles-pp.__sys_shutdown.__x64_sys_shutdown.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.2        1.24 ± 15%  perf-profile.calltrace.cycles-pp.__release_sock.release_sock.__inet_stream_connect.inet_stream_connect.__sys_connect
      0.00            +1.2        1.24 ± 15%  perf-profile.calltrace.cycles-pp.release_sock.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect
      5.67 ± 10%      +6.2       11.87 ±  6%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_bh.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect
     16.93            +8.7       25.64 ±  4%  perf-profile.calltrace.cycles-pp._raw_spin_lock_bh.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect
     75.61           -13.8       61.82 ±  3%  perf-profile.children.cycles-pp.__inet_check_established
     24.09            -6.0       18.12 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock
     99.32            -5.5       93.78        perf-profile.children.cycles-pp.__inet_hash_connect
     99.47            -4.8       94.65        perf-profile.children.cycles-pp.tcp_v4_connect
     99.67            -3.7       95.92        perf-profile.children.cycles-pp.__inet_stream_connect
     99.67            -3.7       95.93        perf-profile.children.cycles-pp.inet_stream_connect
     99.67            -3.7       95.95        perf-profile.children.cycles-pp.__x64_sys_connect
     99.67            -3.7       95.95        perf-profile.children.cycles-pp.__sys_connect
     99.90            -1.3       98.63        perf-profile.children.cycles-pp.do_syscall_64
     99.97            -0.3       99.64        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.83            -0.3        0.52 ±  4%  perf-profile.children.cycles-pp.___might_sleep
      1.02            -0.2        0.79 ±  2%  perf-profile.children.cycles-pp.inet_ehashfn
      0.19 ±  2%      -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.rcu_all_qs
      0.10 ±  4%      -0.0        0.07 ±  9%  perf-profile.children.cycles-pp.__x86_indirect_thunk_rax
      0.14 ±  3%      -0.0        0.11 ±  6%  perf-profile.children.cycles-pp._raw_spin_unlock_bh
      0.04 ± 44%      +0.0        0.07 ±  8%  perf-profile.children.cycles-pp.update_load_avg
      0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.ip_send_skb
      0.00            +0.1        0.06 ± 18%  perf-profile.children.cycles-pp.__x64_sys_close
      0.00            +0.1        0.06 ± 18%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.00            +0.1        0.06 ± 16%  perf-profile.children.cycles-pp.inode_init_always
      0.00            +0.1        0.06 ± 14%  perf-profile.children.cycles-pp.__slab_free
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.update_curr
      0.00            +0.1        0.06 ± 14%  perf-profile.children.cycles-pp.lock_sock_nested
      0.00            +0.1        0.06 ± 14%  perf-profile.children.cycles-pp.security_sk_alloc
      0.00            +0.1        0.07 ± 14%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.1        0.07 ± 23%  perf-profile.children.cycles-pp.tcp_write_queue_purge
      0.00            +0.1        0.07 ± 18%  perf-profile.children.cycles-pp.tcp_recvmsg
      0.00            +0.1        0.07 ± 18%  perf-profile.children.cycles-pp.sk_filter_trim_cap
      0.00            +0.1        0.07 ± 19%  perf-profile.children.cycles-pp.tcp_write_timer
      0.00            +0.1        0.07 ± 23%  perf-profile.children.cycles-pp.tcp_event_new_data_sent
      0.00            +0.1        0.07 ± 23%  perf-profile.children.cycles-pp.sk_stream_alloc_skb
      0.00            +0.1        0.07 ± 14%  perf-profile.children.cycles-pp.read_tsc
      0.00            +0.1        0.07 ± 21%  perf-profile.children.cycles-pp.inet_recvmsg
      0.00            +0.1        0.07 ± 18%  perf-profile.children.cycles-pp.netif_rx
      0.00            +0.1        0.07 ± 18%  perf-profile.children.cycles-pp.netif_rx_internal
      0.00            +0.1        0.08 ± 20%  perf-profile.children.cycles-pp.__sk_mem_reduce_allocated
      0.00            +0.1        0.08 ± 17%  perf-profile.children.cycles-pp.__kfree_skb
      0.00            +0.1        0.08 ± 19%  perf-profile.children.cycles-pp.tcp_v4_send_synack
      0.00            +0.1        0.09 ± 35%  perf-profile.children.cycles-pp.drain_obj_stock
      0.00            +0.1        0.09 ± 17%  perf-profile.children.cycles-pp.__cgroup_bpf_run_filter_skb
      0.00            +0.1        0.09 ± 17%  perf-profile.children.cycles-pp.sk_reset_timer
      0.00            +0.1        0.09 ± 11%  perf-profile.children.cycles-pp.preempt_schedule_common
      0.00            +0.1        0.09 ± 18%  perf-profile.children.cycles-pp.__x64_sys_recvfrom
      0.00            +0.1        0.09 ± 18%  perf-profile.children.cycles-pp.__sys_recvfrom
      0.00            +0.1        0.09 ± 20%  perf-profile.children.cycles-pp.mod_timer
      0.00            +0.1        0.10 ± 18%  perf-profile.children.cycles-pp.tcp_data_queue
      0.00            +0.1        0.10 ± 15%  perf-profile.children.cycles-pp.___slab_alloc
      0.00            +0.1        0.10 ± 20%  perf-profile.children.cycles-pp.sock_alloc_inode
      0.00            +0.1        0.10 ± 15%  perf-profile.children.cycles-pp.ip_route_output_flow
      0.00            +0.1        0.10 ± 18%  perf-profile.children.cycles-pp.tcp_set_state
      0.00            +0.1        0.11 ± 17%  perf-profile.children.cycles-pp.__slab_alloc
      0.00            +0.1        0.11 ± 16%  perf-profile.children.cycles-pp.schedule
      0.00            +0.1        0.11 ± 18%  perf-profile.children.cycles-pp.schedule_timeout
      0.00            +0.1        0.12 ± 17%  perf-profile.children.cycles-pp.sk_clone_lock
      0.00            +0.1        0.12 ± 20%  perf-profile.children.cycles-pp.tcp_reset
      0.00            +0.1        0.12 ± 17%  perf-profile.children.cycles-pp.inet_csk_clone_lock
      0.00            +0.1        0.12 ± 17%  perf-profile.children.cycles-pp.tcp_send_fin
      0.02 ±141%      +0.1        0.14 ± 18%  perf-profile.children.cycles-pp.tcp_delack_timer_handler
      0.00            +0.1        0.12 ± 16%  perf-profile.children.cycles-pp.tcp_clean_rtx_queue
      0.00            +0.1        0.13 ± 15%  perf-profile.children.cycles-pp.ip_route_output_key_hash_rcu
      0.02 ±141%      +0.1        0.15 ± 19%  perf-profile.children.cycles-pp.tcp_delack_timer
      0.00            +0.1        0.13 ± 18%  perf-profile.children.cycles-pp.tcp_done
      0.00            +0.1        0.14 ± 17%  perf-profile.children.cycles-pp.tcp_v4_send_reset
      0.00            +0.1        0.14 ± 18%  perf-profile.children.cycles-pp.tcp_create_openreq_child
      0.00            +0.1        0.14 ± 35%  perf-profile.children.cycles-pp.refill_obj_stock
      0.00            +0.1        0.14 ± 14%  perf-profile.children.cycles-pp.ip_route_output_key_hash
      0.00            +0.1        0.14 ± 19%  perf-profile.children.cycles-pp.ip_send_unicast_reply
      0.00            +0.1        0.14 ± 19%  perf-profile.children.cycles-pp.alloc_empty_file
      0.00            +0.1        0.14 ± 19%  perf-profile.children.cycles-pp.__alloc_file
      0.00            +0.1        0.14 ± 18%  perf-profile.children.cycles-pp.tcp_validate_incoming
      0.00            +0.1        0.15 ± 19%  perf-profile.children.cycles-pp.alloc_file
      0.07 ± 13%      +0.2        0.22 ± 17%  perf-profile.children.cycles-pp.call_timer_fn
      0.00            +0.2        0.15 ± 17%  perf-profile.children.cycles-pp.autoremove_wake_function
      0.00            +0.2        0.15 ± 17%  perf-profile.children.cycles-pp.loopback_xmit
      0.00            +0.2        0.16 ± 19%  perf-profile.children.cycles-pp.sk_alloc
      0.00            +0.2        0.16 ± 17%  perf-profile.children.cycles-pp.try_to_wake_up
      0.00            +0.2        0.16 ± 15%  perf-profile.children.cycles-pp.inet_csk_accept
      0.00            +0.2        0.16 ± 20%  perf-profile.children.cycles-pp.__alloc_skb
      0.00            +0.2        0.16 ± 18%  perf-profile.children.cycles-pp.dev_hard_start_xmit
      0.08 ± 12%      +0.2        0.24 ± 17%  perf-profile.children.cycles-pp.run_timer_softirq
      0.00            +0.2        0.17 ± 17%  perf-profile.children.cycles-pp.alloc_inode
      0.00            +0.2        0.17 ± 15%  perf-profile.children.cycles-pp.__wake_up_common
      0.00            +0.2        0.17 ± 15%  perf-profile.children.cycles-pp.inet_accept
      0.00            +0.2        0.18 ± 17%  perf-profile.children.cycles-pp.sk_prot_alloc
      0.00            +0.2        0.18 ± 17%  perf-profile.children.cycles-pp.new_inode_pseudo
      0.00            +0.2        0.19 ± 15%  perf-profile.children.cycles-pp.sock_def_readable
      0.00            +0.2        0.19 ± 45%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.00            +0.2        0.19 ± 16%  perf-profile.children.cycles-pp.__wake_up_common_lock
      0.00            +0.2        0.19 ± 45%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.00            +0.2        0.19 ± 17%  perf-profile.children.cycles-pp.sock_alloc
      0.00            +0.2        0.20 ± 14%  perf-profile.children.cycles-pp.__sched_text_start
      0.00            +0.2        0.20 ± 19%  perf-profile.children.cycles-pp.inet_create
      0.00            +0.2        0.20 ± 42%  perf-profile.children.cycles-pp.ret_from_fork
      0.00            +0.2        0.20 ± 42%  perf-profile.children.cycles-pp.kthread
      0.00            +0.2        0.20 ± 16%  perf-profile.children.cycles-pp.tcp_v4_syn_recv_sock
      0.00            +0.2        0.21 ± 15%  perf-profile.children.cycles-pp.tcp_conn_request
      0.00            +0.2        0.22 ± 16%  perf-profile.children.cycles-pp.tcp_ack
      0.00            +0.2        0.22 ± 26%  perf-profile.children.cycles-pp.__sk_destruct
      0.00            +0.2        0.22 ± 16%  perf-profile.children.cycles-pp.tcp_child_process
      0.00            +0.2        0.22 ± 20%  perf-profile.children.cycles-pp.__dentry_kill
      0.00            +0.2        0.23 ± 16%  perf-profile.children.cycles-pp.tcp_check_req
      0.00            +0.2        0.23 ± 18%  perf-profile.children.cycles-pp.alloc_file_pseudo
      0.00            +0.2        0.23 ± 19%  perf-profile.children.cycles-pp.sock_alloc_file
      0.00            +0.3        0.27 ± 17%  perf-profile.children.cycles-pp.__dev_queue_xmit
      0.00            +0.3        0.29 ± 18%  perf-profile.children.cycles-pp.__tcp_close
      0.00            +0.3        0.29 ± 20%  perf-profile.children.cycles-pp.irq_exit_rcu
      0.03 ±100%      +0.3        0.32 ± 28%  perf-profile.children.cycles-pp.rcu_core
      0.77 ±  5%      +0.3        1.07 ±  8%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.00            +0.3        0.30 ± 18%  perf-profile.children.cycles-pp.tcp_sendmsg_locked
      0.69 ±  7%      +0.3        0.99 ±  9%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.03 ± 99%      +0.3        0.33 ± 17%  perf-profile.children.cycles-pp.__sys_sendto
      0.03 ± 99%      +0.3        0.33 ± 17%  perf-profile.children.cycles-pp.__x64_sys_sendto
      0.00            +0.3        0.31 ± 19%  perf-profile.children.cycles-pp.tcp_sendmsg
      0.00            +0.3        0.32 ± 29%  perf-profile.children.cycles-pp.rcu_do_batch
      0.00            +0.3        0.32 ± 16%  perf-profile.children.cycles-pp.__inet_lookup_established
      0.00            +0.3        0.32 ± 17%  perf-profile.children.cycles-pp.tcp_close
      0.00            +0.3        0.32 ± 18%  perf-profile.children.cycles-pp.__sock_create
      0.00            +0.3        0.32 ± 18%  perf-profile.children.cycles-pp.sock_sendmsg
      0.00            +0.3        0.34 ± 18%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.06 ±  8%      +0.4        0.41 ± 17%  perf-profile.children.cycles-pp.__sys_accept4_file
      0.06 ±  8%      +0.4        0.42 ± 17%  perf-profile.children.cycles-pp.__sys_accept4
      0.06 ±  8%      +0.4        0.42 ± 16%  perf-profile.children.cycles-pp.__x64_sys_accept
      0.00            +0.4        0.39 ± 16%  perf-profile.children.cycles-pp.tcp_rcv_established
      0.05            +0.4        0.46 ± 19%  perf-profile.children.cycles-pp.__x64_sys_socket
      0.05            +0.4        0.46 ± 19%  perf-profile.children.cycles-pp.__sys_socket
      0.00            +0.4        0.45 ± 30%  perf-profile.children.cycles-pp.kmem_cache_free
      0.00            +0.5        0.49 ± 20%  perf-profile.children.cycles-pp.inet_release
      0.00            +0.5        0.53 ± 20%  perf-profile.children.cycles-pp.__sock_release
      0.00            +0.5        0.53 ± 20%  perf-profile.children.cycles-pp.sock_close
      0.12 ±  3%      +0.6        0.70 ± 15%  perf-profile.children.cycles-pp.tcp_connect
      0.12 ±  3%      +0.6        0.73 ± 15%  perf-profile.children.cycles-pp.tcp_rcv_synsent_state_process
      0.06 ±  6%      +0.9        0.91 ± 19%  perf-profile.children.cycles-pp.__fput
      0.06 ±  7%      +0.9        0.94 ± 20%  perf-profile.children.cycles-pp.task_work_run
      0.07 ±  7%      +0.9        0.98 ± 19%  perf-profile.children.cycles-pp.exit_to_user_mode_prepare
      0.07 ±  5%      +0.9        0.99 ± 19%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      0.00            +1.1        1.09 ± 19%  perf-profile.children.cycles-pp.inet_shutdown
      0.00            +1.1        1.14 ± 19%  perf-profile.children.cycles-pp.__x64_sys_shutdown
      0.00            +1.1        1.14 ± 19%  perf-profile.children.cycles-pp.__sys_shutdown
      0.02 ±141%      +1.2        1.19 ± 17%  perf-profile.children.cycles-pp.tcp_write_xmit
      0.02 ±141%      +1.2        1.19 ± 17%  perf-profile.children.cycles-pp.__tcp_push_pending_frames
      0.22 ±  3%      +1.2        1.43 ± 16%  perf-profile.children.cycles-pp.tcp_rcv_state_process
      0.19 ±  3%      +1.2        1.40 ± 16%  perf-profile.children.cycles-pp.__release_sock
      0.19            +1.3        1.44 ± 16%  perf-profile.children.cycles-pp.release_sock
      0.22 ±  4%      +1.6        1.82 ± 16%  perf-profile.children.cycles-pp.tcp_v4_rcv
      0.23 ±  3%      +1.6        1.84 ± 16%  perf-profile.children.cycles-pp.ip_protocol_deliver_rcu
      0.23 ±  3%      +1.6        1.85 ± 16%  perf-profile.children.cycles-pp.ip_local_deliver_finish
      0.23 ±  4%      +1.6        1.86 ± 16%  perf-profile.children.cycles-pp.ip_local_deliver
      0.25 ±  3%      +1.6        1.89 ± 16%  perf-profile.children.cycles-pp.tcp_v4_do_rcv
      0.24 ±  3%      +1.7        1.91 ± 16%  perf-profile.children.cycles-pp.ip_rcv
      0.91 ±  2%      +1.7        2.62 ± 13%  perf-profile.children.cycles-pp.__local_bh_enable_ip
      0.24 ±  3%      +1.7        1.97 ± 16%  perf-profile.children.cycles-pp.__netif_receive_skb_one_core
      0.25 ±  3%      +1.8        2.02 ± 16%  perf-profile.children.cycles-pp.process_backlog
      0.26 ±  4%      +1.8        2.06 ± 16%  perf-profile.children.cycles-pp.net_rx_action
      0.40 ±  6%      +1.9        2.26 ± 15%  perf-profile.children.cycles-pp.do_softirq
      0.23 ±  3%      +1.9        2.12 ± 16%  perf-profile.children.cycles-pp.ip_finish_output2
      0.24 ±  2%      +2.0        2.23 ± 16%  perf-profile.children.cycles-pp.ip_output
      0.25 ±  3%      +2.1        2.33 ± 16%  perf-profile.children.cycles-pp.__ip_queue_xmit
      1.07 ±  6%      +2.1        3.19 ± 12%  perf-profile.children.cycles-pp.asm_call_sysvec_on_stack
      0.39 ±  6%      +2.1        2.52 ± 16%  perf-profile.children.cycles-pp.do_softirq_own_stack
      0.28 ±  2%      +2.2        2.52 ± 16%  perf-profile.children.cycles-pp.__tcp_transmit_skb
      0.39 ±  6%      +2.3        2.69 ± 17%  perf-profile.children.cycles-pp.__softirqentry_text_start
      6.76 ±  8%      +5.8       12.61 ±  6%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     17.06            +8.8       25.88 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_bh
     50.21            -7.3       42.93 ±  5%  perf-profile.self.cycles-pp.__inet_check_established
     22.80            -5.6       17.24 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock
      0.79            -0.3        0.49 ±  3%  perf-profile.self.cycles-pp.___might_sleep
      0.96            -0.2        0.74 ±  2%  perf-profile.self.cycles-pp.inet_ehashfn
      0.51 ±  2%      -0.2        0.36 ±  4%  perf-profile.self.cycles-pp.__local_bh_enable_ip
      0.14 ±  4%      -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.rcu_all_qs
      0.18 ±  2%      -0.0        0.14 ±  3%  perf-profile.self.cycles-pp._cond_resched
      0.11 ±  4%      -0.0        0.09 ±  7%  perf-profile.self.cycles-pp._raw_spin_unlock_bh
      0.00            +0.1        0.06 ± 18%  perf-profile.self.cycles-pp.__slab_free
      0.00            +0.1        0.06 ± 16%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.1        0.07 ± 14%  perf-profile.self.cycles-pp.__cgroup_bpf_run_filter_skb
      0.00            +0.1        0.07 ± 13%  perf-profile.self.cycles-pp.read_tsc
      0.00            +0.1        0.08 ± 13%  perf-profile.self.cycles-pp.tcp_v4_rcv
      0.00            +0.1        0.08 ± 20%  perf-profile.self.cycles-pp.__sk_mem_reduce_allocated
      0.00            +0.1        0.10 ± 19%  perf-profile.self.cycles-pp.__tcp_transmit_skb
      0.00            +0.1        0.10 ± 17%  perf-profile.self.cycles-pp.kmem_cache_alloc
      0.00            +0.2        0.23 ± 29%  perf-profile.self.cycles-pp.kmem_cache_free
      0.00            +0.3        0.31 ± 16%  perf-profile.self.cycles-pp.__inet_lookup_established
     11.30 ±  4%      +2.6       13.91 ±  3%  perf-profile.self.cycles-pp._raw_spin_lock_bh
      6.66 ±  8%      +5.8       12.48 ±  6%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
     65636 ±  3%    +312.0%     270405 ±  9%  softirqs.CPU0.NET_RX
     14402 ± 14%     +63.3%      23512 ± 10%  softirqs.CPU0.RCU
      6255 ±  8%    +142.9%      15196 ±  2%  softirqs.CPU0.TIMER
     59711 ± 19%    +340.7%     263124 ± 12%  softirqs.CPU1.NET_RX
     11149 ±  7%     +72.9%      19274 ±  4%  softirqs.CPU1.RCU
      5340 ±  3%    +156.6%      13702        softirqs.CPU1.TIMER
     65266          +293.8%     256991 ±  7%  softirqs.CPU10.NET_RX
     10398           +83.4%      19067 ±  3%  softirqs.CPU10.RCU
      5416 ±  2%    +152.3%      13667        softirqs.CPU10.TIMER
     64454          +325.4%     274194 ± 14%  softirqs.CPU11.NET_RX
     10223           +81.8%      18581 ±  3%  softirqs.CPU11.RCU
      5435 ±  2%    +153.5%      13780        softirqs.CPU11.TIMER
     65141          +315.4%     270604 ± 18%  softirqs.CPU12.NET_RX
     10144           +85.0%      18772 ± 10%  softirqs.CPU12.RCU
      5399 ±  2%    +153.2%      13671 ±  6%  softirqs.CPU12.TIMER
     65486 ±  2%    +306.8%     266395 ±  8%  softirqs.CPU13.NET_RX
     10403 ±  2%     +71.3%      17824 ±  2%  softirqs.CPU13.RCU
      5418 ±  2%    +161.2%      14154 ±  4%  softirqs.CPU13.TIMER
     65166          +300.6%     261036 ± 14%  softirqs.CPU14.NET_RX
     10202 ±  2%     +86.7%      19052 ±  5%  softirqs.CPU14.RCU
      5464 ±  3%    +149.7%      13643        softirqs.CPU14.TIMER
     64647          +358.7%     296569 ± 19%  softirqs.CPU15.NET_RX
     10540 ±  4%     +78.6%      18821 ±  6%  softirqs.CPU15.RCU
      5649 ±  8%    +139.6%      13536        softirqs.CPU15.TIMER
     65031 ±  2%    +368.5%     304698 ±  7%  softirqs.CPU16.NET_RX
     10759 ±  4%     +82.6%      19645 ±  2%  softirqs.CPU16.RCU
      5573 ±  6%    +147.1%      13773 ±  2%  softirqs.CPU16.TIMER
     64827          +326.1%     276213 ±  4%  softirqs.CPU17.NET_RX
     10908 ±  6%     +79.5%      19584 ±  5%  softirqs.CPU17.RCU
      5423          +157.4%      13959        softirqs.CPU17.TIMER
     64871          +295.4%     256498 ±  9%  softirqs.CPU18.NET_RX
     10661 ±  2%     +77.0%      18870 ±  6%  softirqs.CPU18.RCU
      5394          +155.8%      13798        softirqs.CPU18.TIMER
     65669 ±  3%    +290.1%     256203 ± 17%  softirqs.CPU19.NET_RX
     10688 ±  2%     +76.4%      18855 ±  5%  softirqs.CPU19.RCU
      5441          +150.3%      13623        softirqs.CPU19.TIMER
     64660          +366.3%     301532 ± 18%  softirqs.CPU2.NET_RX
     10936           +81.0%      19792 ±  5%  softirqs.CPU2.RCU
      5415 ±  2%    +157.5%      13946        softirqs.CPU2.TIMER
     65327 ±  2%    +326.2%     278443 ± 17%  softirqs.CPU20.NET_RX
     10789 ±  3%     +81.6%      19596 ±  5%  softirqs.CPU20.RCU
      5398 ±  2%    +153.2%      13669 ±  2%  softirqs.CPU20.TIMER
     65907 ±  2%    +320.0%     276814 ±  8%  softirqs.CPU21.NET_RX
     10628           +88.7%      20055 ±  6%  softirqs.CPU21.RCU
      5509 ±  2%    +152.0%      13883 ±  3%  softirqs.CPU21.TIMER
     65040          +276.9%     245159 ± 10%  softirqs.CPU22.NET_RX
     10521           +71.6%      18057 ±  4%  softirqs.CPU22.RCU
      5403 ±  2%    +157.8%      13929 ±  8%  softirqs.CPU22.TIMER
     65297 ±  2%    +313.0%     269696 ± 13%  softirqs.CPU23.NET_RX
     11407 ± 13%     +68.1%      19180 ±  4%  softirqs.CPU23.RCU
      5622 ±  7%    +142.1%      13614 ±  2%  softirqs.CPU23.TIMER
     64721          +332.4%     279830 ± 19%  softirqs.CPU24.NET_RX
     11583 ±  3%     +70.3%      19726 ±  5%  softirqs.CPU24.RCU
      5785 ±  9%    +134.8%      13587 ±  5%  softirqs.CPU24.TIMER
     65042          +332.9%     281590 ±  7%  softirqs.CPU25.NET_RX
     11141 ±  2%     +83.3%      20423 ± 10%  softirqs.CPU25.RCU
      5353          +156.2%      13713 ±  5%  softirqs.CPU25.TIMER
     58802 ± 23%    +406.0%     297551 ± 13%  softirqs.CPU26.NET_RX
     10389 ±  8%     +94.9%      20252 ±  7%  softirqs.CPU26.RCU
      5285          +153.4%      13396 ±  4%  softirqs.CPU26.TIMER
     64806          +419.3%     336531 ± 16%  softirqs.CPU27.NET_RX
     10607           +80.6%      19153 ±  5%  softirqs.CPU27.RCU
      5328          +151.5%      13399 ±  4%  softirqs.CPU27.TIMER
     64644          +342.6%     286130 ± 13%  softirqs.CPU28.NET_RX
     10719 ±  4%     +84.7%      19799 ±  3%  softirqs.CPU28.RCU
      5355          +143.5%      13039 ±  4%  softirqs.CPU28.TIMER
     64931          +374.6%     308152 ± 18%  softirqs.CPU29.NET_RX
     10407           +85.0%      19250 ±  3%  softirqs.CPU29.RCU
      5411          +146.7%      13350 ±  4%  softirqs.CPU29.TIMER
     64538          +347.3%     288687 ±  9%  softirqs.CPU3.NET_RX
     10678           +84.6%      19712 ±  4%  softirqs.CPU3.RCU
      5408 ±  2%    +165.7%      14368 ±  5%  softirqs.CPU3.TIMER
     65007 ±  2%    +423.5%     340342 ± 17%  softirqs.CPU30.NET_RX
     10651 ±  5%     +84.5%      19657 ±  6%  softirqs.CPU30.RCU
      5495 ±  3%    +146.3%      13533 ±  4%  softirqs.CPU30.TIMER
     64984          +342.4%     287519 ± 14%  softirqs.CPU31.NET_RX
     10464           +75.7%      18390 ±  5%  softirqs.CPU31.RCU
      5387          +146.0%      13250 ±  3%  softirqs.CPU31.TIMER
     59006 ± 23%    +384.5%     285909 ± 14%  softirqs.CPU32.NET_RX
      9705 ± 11%     +94.1%      18835 ±  7%  softirqs.CPU32.RCU
      5208 ±  2%    +171.6%      14147 ± 16%  softirqs.CPU32.TIMER
     64860          +316.2%     269979 ± 10%  softirqs.CPU33.NET_RX
     10061 ±  2%     +89.4%      19058 ±  2%  softirqs.CPU33.RCU
      5300          +150.6%      13280 ±  3%  softirqs.CPU33.TIMER
     64809          +307.7%     264248 ± 17%  softirqs.CPU34.NET_RX
      9968           +87.1%      18652 ±  3%  softirqs.CPU34.RCU
      5364          +146.0%      13195 ±  2%  softirqs.CPU34.TIMER
     64861          +325.8%     276161 ± 12%  softirqs.CPU35.NET_RX
     10069           +85.1%      18640 ±  3%  softirqs.CPU35.RCU
      5389          +148.1%      13367 ±  4%  softirqs.CPU35.TIMER
     59089 ± 23%    +420.1%     307315 ± 18%  softirqs.CPU36.NET_RX
      9648 ±  9%    +100.3%      19326 ± 10%  softirqs.CPU36.RCU
      5253 ±  2%    +155.6%      13427 ±  4%  softirqs.CPU36.TIMER
     65133          +355.5%     296651 ± 11%  softirqs.CPU37.NET_RX
     10020 ±  2%     +88.4%      18873 ±  4%  softirqs.CPU37.RCU
      5439 ±  5%    +144.0%      13271 ±  5%  softirqs.CPU37.TIMER
     65044          +315.0%     269907 ± 16%  softirqs.CPU38.NET_RX
      9951 ±  2%     +86.5%      18556 ±  6%  softirqs.CPU38.RCU
      5334          +142.3%      12927 ±  7%  softirqs.CPU38.TIMER
     61324 ± 12%    +339.7%     269630 ± 15%  softirqs.CPU39.NET_RX
      9891 ±  5%     +91.4%      18927 ±  3%  softirqs.CPU39.RCU
      5253 ±  4%    +151.0%      13184 ±  2%  softirqs.CPU39.TIMER
     59536 ± 20%    +342.2%     263268 ±  3%  softirqs.CPU4.NET_RX
     10248 ± 13%     +81.1%      18560 ±  5%  softirqs.CPU4.RCU
      5306 ±  5%    +157.0%      13639 ±  2%  softirqs.CPU4.TIMER
     65051          +339.9%     286131 ± 12%  softirqs.CPU40.NET_RX
      9993 ±  2%     +88.1%      18801 ±  3%  softirqs.CPU40.RCU
      5428 ±  3%    +147.6%      13437 ±  4%  softirqs.CPU40.TIMER
     66089 ±  2%    +332.8%     286027 ± 14%  softirqs.CPU41.NET_RX
     10483 ±  6%     +82.3%      19111 ±  7%  softirqs.CPU41.RCU
      5525 ±  4%    +138.2%      13161 ±  5%  softirqs.CPU41.TIMER
     64979          +345.8%     289650 ± 11%  softirqs.CPU42.NET_RX
     10008 ±  3%     +86.5%      18661 ±  3%  softirqs.CPU42.RCU
      5337          +149.4%      13309 ±  3%  softirqs.CPU42.TIMER
     64234          +321.8%     270970 ±  9%  softirqs.CPU43.NET_RX
      9899 ±  2%     +86.3%      18441 ±  5%  softirqs.CPU43.RCU
      5326          +149.9%      13307 ±  3%  softirqs.CPU43.TIMER
     65083          +376.2%     309898 ± 18%  softirqs.CPU44.NET_RX
      9958 ±  2%     +93.8%      19296 ±  6%  softirqs.CPU44.RCU
      5346 ±  2%    +148.1%      13261 ±  4%  softirqs.CPU44.TIMER
     65076          +403.6%     327744 ± 11%  softirqs.CPU45.NET_RX
      9942 ±  3%     +91.4%      19027 ± 10%  softirqs.CPU45.RCU
      5299          +152.5%      13383 ±  6%  softirqs.CPU45.TIMER
     65682 ±  2%    +358.2%     300968 ± 18%  softirqs.CPU46.NET_RX
      9760 ±  4%     +96.3%      19161 ±  5%  softirqs.CPU46.RCU
      5350          +151.9%      13474 ±  4%  softirqs.CPU46.TIMER
     64475          +332.7%     279008 ± 13%  softirqs.CPU47.NET_RX
     10005 ±  3%     +83.6%      18368 ±  6%  softirqs.CPU47.RCU
      5329          +149.2%      13279 ±  2%  softirqs.CPU47.TIMER
     64759 ±  2%    +264.5%     236058 ± 15%  softirqs.CPU48.NET_RX
     10354 ±  2%     +67.5%      17341 ±  9%  softirqs.CPU48.RCU
      5430 ±  2%    +152.5%      13710 ±  3%  softirqs.CPU48.TIMER
     64904          +327.1%     277209 ± 13%  softirqs.CPU49.NET_RX
     10365 ±  2%     +80.1%      18667 ±  3%  softirqs.CPU49.RCU
      5416 ±  2%    +154.0%      13760        softirqs.CPU49.TIMER
     64809          +342.6%     286815 ± 11%  softirqs.CPU5.NET_RX
     10495           +81.1%      19004 ±  5%  softirqs.CPU5.RCU
      5424 ±  2%    +157.0%      13941 ±  2%  softirqs.CPU5.TIMER
     64092          +323.0%     271142 ± 12%  softirqs.CPU50.NET_RX
     10243 ±  5%     +83.8%      18830 ±  6%  softirqs.CPU50.RCU
      5394          +152.0%      13594        softirqs.CPU50.TIMER
     64623          +339.4%     283964 ± 11%  softirqs.CPU51.NET_RX
     10338           +80.4%      18654 ±  2%  softirqs.CPU51.RCU
      5699 ±  7%    +160.1%      14824 ± 14%  softirqs.CPU51.TIMER
     65332          +292.6%     256522 ± 10%  softirqs.CPU52.NET_RX
     10252           +82.1%      18671 ±  4%  softirqs.CPU52.RCU
      5513 ±  3%    +145.5%      13538        softirqs.CPU52.TIMER
     65157 ±  2%    +300.1%     260686 ± 13%  softirqs.CPU53.NET_RX
     10258 ±  2%     +76.9%      18152 ±  4%  softirqs.CPU53.RCU
      5414          +151.9%      13640 ±  2%  softirqs.CPU53.TIMER
     64777          +325.0%     275316 ± 10%  softirqs.CPU54.NET_RX
     10325 ±  4%     +72.6%      17826 ±  3%  softirqs.CPU54.RCU
      5664 ±  9%    +143.8%      13808 ±  3%  softirqs.CPU54.TIMER
     65262          +274.9%     244693 ±  9%  softirqs.CPU55.NET_RX
     10069           +85.1%      18641 ±  3%  softirqs.CPU55.RCU
      5455          +153.3%      13820 ±  2%  softirqs.CPU55.TIMER
     64669          +334.1%     280750 ± 18%  softirqs.CPU56.NET_RX
     10211 ±  6%     +82.9%      18671 ±  7%  softirqs.CPU56.RCU
      5409 ±  2%    +153.9%      13736 ±  3%  softirqs.CPU56.TIMER
     65109          +299.3%     259999 ± 10%  softirqs.CPU57.NET_RX
     10178 ±  2%     +83.7%      18697 ±  2%  softirqs.CPU57.RCU
      5421 ±  2%    +152.1%      13665        softirqs.CPU57.TIMER
     65527 ±  2%    +298.4%     261032 ±  7%  softirqs.CPU58.NET_RX
     10138           +83.3%      18578 ±  3%  softirqs.CPU58.RCU
      5444 ±  2%    +155.5%      13911 ±  3%  softirqs.CPU58.TIMER
     65194          +315.1%     270633 ±  4%  softirqs.CPU59.NET_RX
     10195           +79.5%      18297 ±  4%  softirqs.CPU59.RCU
      5392 ±  2%    +154.4%      13719        softirqs.CPU59.TIMER
     64608          +301.6%     259488 ± 16%  softirqs.CPU6.NET_RX
     10235           +79.0%      18323 ±  3%  softirqs.CPU6.RCU
      5399 ±  2%    +170.0%      14579 ± 14%  softirqs.CPU6.TIMER
     64973 ±  2%    +288.5%     252424 ± 14%  softirqs.CPU60.NET_RX
     10247 ±  2%     +75.6%      17998 ±  4%  softirqs.CPU60.RCU
      5451 ±  2%    +152.9%      13784        softirqs.CPU60.TIMER
     65180 ±  2%    +344.8%     289939 ± 11%  softirqs.CPU61.NET_RX
     11034 ± 14%     +68.1%      18551 ±  6%  softirqs.CPU61.RCU
      5625 ±  7%    +173.2%      15369 ± 14%  softirqs.CPU61.TIMER
     64849          +287.7%     251418 ±  6%  softirqs.CPU62.NET_RX
     10588 ±  4%     +69.9%      17986 ±  2%  softirqs.CPU62.RCU
      5587 ±  7%    +142.5%      13552        softirqs.CPU62.TIMER
     65191          +303.1%     262796 ± 11%  softirqs.CPU63.NET_RX
     10228 ±  3%     +79.1%      18316 ±  5%  softirqs.CPU63.RCU
      5420 ±  2%    +148.3%      13457 ±  2%  softirqs.CPU63.TIMER
     64813          +309.0%     265080 ± 15%  softirqs.CPU64.NET_RX
     10451 ±  3%     +79.2%      18730 ±  3%  softirqs.CPU64.RCU
      5488          +151.1%      13780        softirqs.CPU64.TIMER
     65284          +327.0%     278735 ±  7%  softirqs.CPU65.NET_RX
     10823 ±  2%     +80.5%      19533 ±  4%  softirqs.CPU65.RCU
      5491 ±  2%    +152.5%      13865        softirqs.CPU65.TIMER
     65208          +270.7%     241728 ±  4%  softirqs.CPU66.NET_RX
     10337           +76.5%      18248 ±  6%  softirqs.CPU66.RCU
      5429          +153.2%      13749 ±  2%  softirqs.CPU66.TIMER
     65515 ±  2%    +319.1%     274551 ±  9%  softirqs.CPU67.NET_RX
     10376 ±  2%     +78.9%      18565 ±  4%  softirqs.CPU67.RCU
      5440 ±  2%    +149.7%      13584 ±  2%  softirqs.CPU67.TIMER
     64731          +318.1%     270671 ± 11%  softirqs.CPU68.NET_RX
     10697 ±  4%     +80.0%      19257 ±  4%  softirqs.CPU68.RCU
      5399 ±  2%    +152.6%      13639 ±  2%  softirqs.CPU68.TIMER
     65174          +330.2%     280395 ± 15%  softirqs.CPU69.NET_RX
     10292           +81.9%      18723 ±  4%  softirqs.CPU69.RCU
      5460          +148.4%      13565        softirqs.CPU69.TIMER
     65120 ±  2%    +312.9%     268888 ± 14%  softirqs.CPU7.NET_RX
     10507 ±  3%     +78.2%      18719 ±  2%  softirqs.CPU7.RCU
      5408          +153.2%      13696 ±  3%  softirqs.CPU7.TIMER
     65546          +296.6%     259938 ±  8%  softirqs.CPU70.NET_RX
     10458           +73.6%      18158 ±  4%  softirqs.CPU70.RCU
      5495          +150.8%      13782 ±  5%  softirqs.CPU70.TIMER
     65388 ±  2%    +303.2%     263625 ± 15%  softirqs.CPU71.NET_RX
     11398 ± 14%     +65.5%      18859 ±  5%  softirqs.CPU71.RCU
      5670 ±  6%    +143.9%      13830 ±  3%  softirqs.CPU71.TIMER
     64605          +312.9%     266751 ± 11%  softirqs.CPU72.NET_RX
     10711 ±  3%     +78.8%      19148 ±  5%  softirqs.CPU72.RCU
      5397          +148.5%      13409 ±  4%  softirqs.CPU72.TIMER
     65247 ±  2%    +317.3%     272264 ±  9%  softirqs.CPU73.NET_RX
     10405           +75.7%      18284 ±  2%  softirqs.CPU73.RCU
      5361          +148.4%      13317 ±  4%  softirqs.CPU73.TIMER
     65370          +379.6%     313484 ± 13%  softirqs.CPU74.NET_RX
     10010 ±  5%     +95.5%      19570 ±  3%  softirqs.CPU74.RCU
      5390          +150.4%      13498 ±  5%  softirqs.CPU74.TIMER
     64987 ±  2%    +336.7%     283777 ± 13%  softirqs.CPU75.NET_RX
     10337           +83.3%      18946 ±  4%  softirqs.CPU75.RCU
      5497 ±  6%    +142.8%      13348 ±  5%  softirqs.CPU75.TIMER
     64578          +358.0%     295795 ± 11%  softirqs.CPU76.NET_RX
     10296           +88.8%      19438 ±  4%  softirqs.CPU76.RCU
      5460 ±  3%    +140.9%      13155 ±  3%  softirqs.CPU76.TIMER
     65089          +296.1%     257835 ±  7%  softirqs.CPU77.NET_RX
     10396           +80.8%      18791 ±  3%  softirqs.CPU77.RCU
      5506 ±  3%    +137.5%      13078 ±  4%  softirqs.CPU77.TIMER
     64561          +358.4%     295956 ± 11%  softirqs.CPU78.NET_RX
     10365 ±  2%     +84.8%      19151 ±  2%  softirqs.CPU78.RCU
      5399          +145.6%      13260 ±  4%  softirqs.CPU78.TIMER
     64881          +356.6%     296230 ±  7%  softirqs.CPU79.NET_RX
     10183           +83.0%      18631 ±  5%  softirqs.CPU79.RCU
      5405          +149.9%      13508 ±  2%  softirqs.CPU79.TIMER
     64802          +356.2%     295606 ± 12%  softirqs.CPU8.NET_RX
     10496 ±  3%     +82.3%      19130 ±  4%  softirqs.CPU8.RCU
      5557 ±  4%    +149.4%      13858 ±  3%  softirqs.CPU8.TIMER
     66166 ±  2%    +316.6%     275632 ± 11%  softirqs.CPU80.NET_RX
      9975 ±  4%     +81.8%      18135 ±  7%  softirqs.CPU80.RCU
      5419 ±  4%    +149.5%      13518 ± 11%  softirqs.CPU80.TIMER
     65173          +380.4%     313113 ± 16%  softirqs.CPU81.NET_RX
      9892 ±  2%     +87.6%      18559 ±  4%  softirqs.CPU81.RCU
      5315          +149.7%      13270 ±  4%  softirqs.CPU81.TIMER
     64551          +331.2%     278313 ± 14%  softirqs.CPU82.NET_RX
      9931 ±  2%     +94.6%      19330 ±  6%  softirqs.CPU82.RCU
      5349          +149.4%      13342 ±  2%  softirqs.CPU82.TIMER
     65434 ±  2%    +397.8%     325748 ±  8%  softirqs.CPU83.NET_RX
      9955           +87.9%      18703 ±  5%  softirqs.CPU83.RCU
      5400 ±  2%    +149.6%      13477 ±  3%  softirqs.CPU83.TIMER
     64894          +324.0%     275183 ± 29%  softirqs.CPU84.NET_RX
      9772 ±  4%     +92.8%      18845 ±  4%  softirqs.CPU84.RCU
      5332          +152.1%      13444 ±  4%  softirqs.CPU84.TIMER
     64992          +356.7%     296833 ± 13%  softirqs.CPU85.NET_RX
     10260 ±  8%     +84.9%      18975 ±  7%  softirqs.CPU85.RCU
      5319          +152.4%      13422 ±  4%  softirqs.CPU85.TIMER
     64954          +396.3%     322356 ± 12%  softirqs.CPU86.NET_RX
      9827           +88.4%      18517 ±  6%  softirqs.CPU86.RCU
      5285          +149.8%      13204 ±  4%  softirqs.CPU86.TIMER
     64950          +407.4%     329550 ±  7%  softirqs.CPU87.NET_RX
      9913 ±  4%     +94.8%      19311 ±  8%  softirqs.CPU87.RCU
      5417          +147.3%      13396 ±  2%  softirqs.CPU87.TIMER
     64621          +337.2%     282555 ± 17%  softirqs.CPU88.NET_RX
      9877           +84.1%      18188 ±  4%  softirqs.CPU88.RCU
      5400          +147.8%      13383 ±  5%  softirqs.CPU88.TIMER
     64549          +328.5%     276593 ± 13%  softirqs.CPU89.NET_RX
      9775 ±  3%     +82.6%      17853 ±  4%  softirqs.CPU89.RCU
      5367          +142.5%      13017 ±  4%  softirqs.CPU89.TIMER
     65373 ±  2%    +332.4%     282682 ±  8%  softirqs.CPU9.NET_RX
     10558 ±  3%     +75.1%      18485 ±  2%  softirqs.CPU9.RCU
      5394 ±  2%    +151.9%      13591 ±  2%  softirqs.CPU9.TIMER
     65230          +336.2%     284504 ±  9%  softirqs.CPU90.NET_RX
     10086 ±  2%     +85.4%      18704 ±  6%  softirqs.CPU90.RCU
      5358          +147.1%      13239 ±  5%  softirqs.CPU90.TIMER
     64791          +366.5%     302228 ±  8%  softirqs.CPU91.NET_RX
     10239 ±  2%     +82.0%      18631 ±  3%  softirqs.CPU91.RCU
      5353          +149.8%      13376 ±  3%  softirqs.CPU91.TIMER
     64608          +349.6%     290453 ± 12%  softirqs.CPU92.NET_RX
      9957 ±  3%     +88.5%      18769 ±  4%  softirqs.CPU92.RCU
      5311          +147.3%      13138 ±  2%  softirqs.CPU92.TIMER
     64576          +351.7%     291673 ± 13%  softirqs.CPU93.NET_RX
      9984 ±  5%     +90.2%      18993 ±  4%  softirqs.CPU93.RCU
      5318          +149.7%      13278 ±  4%  softirqs.CPU93.TIMER
     64951          +359.2%     298230 ± 12%  softirqs.CPU94.NET_RX
      9872 ±  4%     +87.9%      18547 ±  3%  softirqs.CPU94.RCU
      5433 ±  4%    +143.2%      13211 ±  4%  softirqs.CPU94.TIMER
     63825          +344.4%     283611 ± 13%  softirqs.CPU95.NET_RX
     10222           +92.5%      19679 ±  5%  softirqs.CPU95.RCU
      5288 ±  2%    +152.1%      13330 ±  2%  softirqs.CPU95.TIMER
   6207557          +334.2%   26955885 ±  2%  softirqs.NET_RX
    995456           +82.3%    1814562 ±  2%  softirqs.RCU
    239542 ±  2%      +7.8%     258235 ±  3%  softirqs.SCHED
    521072          +150.5%    1305253 ±  2%  softirqs.TIMER


                                                                                
                            stress-ng.time.user_time                            
                                                                                
  12 +----------------------------------------------------------------------+   
  11 |-+                 O O                                                |   
     |      O      O    O                                                   |   
  10 |-+ O    OO OO   O        O O   O  OO    O                             |   
   9 |O+O  O         O      O O   OO  O    OO                               |   
   8 |-+                                                                    |   
   7 |-+                                                                    |   
     |                                                                      |   
   6 |-+                                                                    |   
   5 |-+                                                                    |   
   4 |-+                                                                    |   
   3 |-+                                                                    |   
     |+.  .++.++.+++.++.++.++.++.+++.+   +.  .++       .+ .++.     +.  .+ .+|   
   2 |-+++                            +.+  ++   +.++.++  +    +++.+  ++  +  |   
   1 +----------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                            stress-ng.time.system_time                          
                                                                                
  5700 +--------------------------------------------------------------------+   
       |               .+       +.    +                                     |   
  5650 |+.++.+++.++.+++  +.++.++  ++.+ +.++.+++.++.+++.++.++.+++.++.+++.++.+|   
       |                                                                    |   
  5600 |-+                                                                  |   
       |                                                                    |   
  5550 |-+                                                                  |   
       |                                                                    |   
  5500 |-+            O       O                                             |   
       |O O  O          O                                                   |   
  5450 |-+                                                                  |   
       |   O     O       O     O      OO      O                             |   
  5400 |-+    O   O        OO   O O  O   OO  O                              |   
       |       O    OO             O        O                               |   
  5350 +--------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                    stress-ng.time.percent_of_cpu_this_job_got                  
                                                                                
  9050 +--------------------------------------------------------------------+   
  9000 |+.++.+++.++.++                 +.++.+++.++.+++.++.++.+++.++.+++.++.+|   
       |                                                                    |   
  8950 |-+                                                                  |   
  8900 |-+                                                                  |   
       |                                                                    |   
  8850 |-+                                                                  |   
  8800 |-+                                                                  |   
  8750 |-+            O       O                                             |   
       |O O  O          O                                                   |   
  8700 |-+                                                                  |   
  8650 |-+ O     O       O  O  O      OO      O                             |   
       |      O   O        O    O OO O   OO OO                              |   
  8600 |-+     O    OO                                                      |   
  8550 +--------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                      stress-ng.time.voluntary_context_switches                 
                                                                                
  1e+07 +-------------------------------------------------------------------+   
        |      O      O   OO O                                              |   
  9e+06 |-+O    O  OO            OO OO O O OOO O                            |   
  8e+06 |O+ O O   O      O    O O       O                                   |   
        |              O                                                    |   
  7e+06 |-+                                                                 |   
        |                                                                   |   
  6e+06 |-+                                                                 |   
        |                                                                   |   
  5e+06 |-+                                                                 |   
  4e+06 |-+                                                                 |   
        |                                                                   |   
  3e+06 |-+                                                                 |   
        |                                 .+  .+            .+              |   
  2e+06 +-------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                     stress-ng.time.involuntary_context_switches                
                                                                                
  1e+07 +-------------------------------------------------------------------+   
        |      O           O                                                |   
  9e+06 |-+O    O  OO O      O   OO OO   O OOO                              |   
  8e+06 |O+ O O   O      OO   O O      OO      O                            |   
        |              O                                                    |   
  7e+06 |-+                                                                 |   
  6e+06 |-+                                                                 |   
        |                                                                   |   
  5e+06 |-+                                                                 |   
  4e+06 |-+                                                                 |   
        |                                                                   |   
  3e+06 |-+                                                                 |   
  2e+06 |-+    ++.+++.  .++   +.      .+ +.  +.  .+ +.++.     +.  +.++   +.+|   
        |+.++.+       ++   +.+  +++.++  +  ++  ++  +     +++.+  ++    +.+   |   
  1e+06 +-------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                               stress-ng.sockmany.ops                           
                                                                                
  1e+07 +-------------------------------------------------------------------+   
        |      O      O    O O                                              |   
  9e+06 |-+O    O  OO     O      OO OO O O OOO O                            |   
  8e+06 |O+ O O   O    O O    O O       O                                   |   
        |                                                                   |   
  7e+06 |-+                                                                 |   
  6e+06 |-+                                                                 |   
        |                                                                   |   
  5e+06 |-+                                                                 |   
  4e+06 |-+                                                                 |   
        |                                                                   |   
  3e+06 |-+                                                                 |   
  2e+06 |+.++.+++.+++.++.+++.++.+++. +.+        +.+ +.++.     +.+++.+++.++.+|   
        |                           +   ++.+++.+   +     +++.+              |   
  1e+06 +-------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                           stress-ng.sockmany.ops_per_sec                       
                                                                                
  160000 +------------------------------------------------------------------+   
         |      OO  O  O    O O   O O     O  O                              |   
  140000 |-+O      O O     O    O  O  OOO  O  OO                            |   
         |O  OO         OO     O                                            |   
  120000 |-+                                                                |   
         |                                                                  |   
  100000 |-+                                                                |   
         |                                                                  |   
   80000 |-+                                                                |   
         |                                                                  |   
   60000 |-+                                                                |   
         |                                                                  |   
   40000 |-+                                                                |   
         |+.+++.++.+++.+++.++.+++.+++.+++.++.+++.+++.+++.++.+++.+++.++.+++.+|   
   20000 +------------------------------------------------------------------+   
                                                                                
                                                                                
[*] bisect-good sample
[O] bisect-bad  sample

***************************************************************************************************
lkp-csl-2sp5: 96 threads Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 192G memory
=========================================================================================
class/compiler/cpufreq_governor/disk/fs/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime/ucode:
  os/gcc-9/performance/1HDD/ext4/x86_64-rhel-8.3/10%/debian-10.4-x86_64-20200603.cgz/lkp-csl-2sp5/sockmany/stress-ng/60s/0x5003006

commit: 
  3af409ca27 ("net: enetc: fix destroyed phylink dereference during unbind")
  ff0d41306d ("tcp: avoid unnecessary loop if even ports are used up")

3af409ca278d4a8d ff0d41306d8c7b91c21707559ef 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    406932          +572.4%    2736324 ±  2%  stress-ng.sockmany.ops
      6765          +572.1%      45470 ±  2%  stress-ng.sockmany.ops_per_sec
      1903 ± 10%    +211.9%       5935 ±  4%  stress-ng.time.involuntary_context_switches
     10220            +6.7%      10904 ±  6%  stress-ng.time.minor_page_faults
    856.33            -2.5%     835.00        stress-ng.time.percent_of_cpu_this_job_got
    532.86            -2.7%     518.28        stress-ng.time.system_time
    811820          +572.8%    5461555 ±  2%  stress-ng.time.voluntary_context_switches
      9.59            +5.2%      10.09        iostat.cpu.system
    958912           +12.4%    1077693        meminfo.SUnreclaim
   1216083           +10.4%    1343126        meminfo.Slab
      0.18            +0.7        0.86 ±  2%  mpstat.cpu.all.soft%
      0.04            +0.0        0.07        mpstat.cpu.all.usr%
      0.73 ± 30%    +220.5%       2.33 ± 87%  perf-sched.wait_and_delay.avg.ms.__sched_text_start.__sched_text_start.worker_thread.kthread.ret_from_fork
      2.99 ±  2%    +124.8%       6.73 ±108%  perf-sched.wait_and_delay.max.ms.__sched_text_start.__sched_text_start.worker_thread.kthread.ret_from_fork
     90.00            -1.1%      89.00        vmstat.cpu.id
     26898          +531.6%     169904 ±  2%  vmstat.system.cs
      3951 ± 45%    +118.4%       8629 ± 57%  sched_debug.cfs_rq:/.load.avg
    -11161          +259.9%     -40170        sched_debug.cfs_rq:/.spread0.min
      2339 ± 13%     +59.6%       3734 ± 37%  sched_debug.cpu.avg_idle.min
    171001 ± 19%    +100.9%     343533 ± 11%  numa-numastat.node0.local_node
    220436 ±  6%     +72.7%     380593 ±  6%  numa-numastat.node0.numa_hit
    170511 ± 20%     +90.4%     324657 ± 10%  numa-numastat.node1.local_node
    207667 ±  7%     +80.2%     374171 ±  3%  numa-numastat.node1.numa_hit
   7118182 ±  4%    +397.1%   35384127 ±  3%  cpuidle.C1.time
    583205 ±  2%    +576.6%    3946063 ±  2%  cpuidle.C1.usage
  10115087 ± 18%     +20.6%   12200316        cpuidle.C1E.usage
    497217 ± 23%    +209.7%    1539923 ±  6%  cpuidle.POLL.time
    115595 ±  5%    +124.7%     259768 ±  7%  cpuidle.POLL.usage
     63981            +3.2%      66038        proc-vmstat.nr_slab_reclaimable
    238932           +12.5%     268761        proc-vmstat.nr_slab_unreclaimable
    353.50 ± 58%    +351.0%       1594 ± 78%  proc-vmstat.numa_hint_faults
    217.00 ± 66%    +268.0%     798.67 ± 44%  proc-vmstat.numa_hint_faults_local
    461585           +70.4%     786370 ±  2%  proc-vmstat.numa_hit
    374975           +86.6%     699774 ±  3%  proc-vmstat.numa_local
    835776          +179.0%    2331789 ±  6%  proc-vmstat.pgalloc_normal
    570397 ±  2%    +254.2%    2020484 ±  7%  proc-vmstat.pgfree
     12704 ±  2%     +16.9%      14857 ±  2%  slabinfo.TCP.active_slabs
    177868 ±  2%     +16.9%     208016 ±  2%  slabinfo.TCP.num_objs
     12704 ±  2%     +16.9%      14857 ±  2%  slabinfo.TCP.num_slabs
     26316 ±  8%    +165.7%      69913 ±  3%  slabinfo.dmaengine-unmap-16.active_objs
    626.67 ±  8%    +165.9%       1666 ±  3%  slabinfo.dmaengine-unmap-16.active_slabs
     26342 ±  8%    +165.7%      69985 ±  3%  slabinfo.dmaengine-unmap-16.num_objs
    626.67 ±  8%    +165.9%       1666 ±  3%  slabinfo.dmaengine-unmap-16.num_slabs
     18132           +43.9%      26089 ±  8%  slabinfo.kmalloc-128.active_objs
    582.50           +44.9%     844.17 ±  7%  slabinfo.kmalloc-128.active_slabs
     18654           +44.9%      27031 ±  7%  slabinfo.kmalloc-128.num_objs
    582.50           +44.9%     844.17 ±  7%  slabinfo.kmalloc-128.num_slabs
    233241           +41.0%     328829 ±  2%  slabinfo.kmalloc-16.active_objs
    915.67           +44.8%       1326 ±  2%  slabinfo.kmalloc-16.active_slabs
    234552           +44.8%     339569 ±  2%  slabinfo.kmalloc-16.num_objs
    915.67           +44.8%       1326 ±  2%  slabinfo.kmalloc-16.num_slabs
     13671 ±  2%     +40.4%      19187 ±  2%  slabinfo.kmalloc-256.active_objs
    427.67 ±  2%     +42.5%     609.50 ±  2%  slabinfo.kmalloc-256.active_slabs
     13700 ±  2%     +42.5%      19519 ±  2%  slabinfo.kmalloc-256.num_objs
    427.67 ±  2%     +42.5%     609.50 ±  2%  slabinfo.kmalloc-256.num_slabs
     22110           +17.7%      26024        slabinfo.kmalloc-512.active_objs
    692.50           +21.0%     837.67        slabinfo.kmalloc-512.active_slabs
     22175           +21.0%      26828        slabinfo.kmalloc-512.num_objs
    692.50           +21.0%     837.67        slabinfo.kmalloc-512.num_slabs
    191005           +23.4%     235765 ±  3%  slabinfo.lsm_file_cache.active_objs
      1123           +23.6%       1388 ±  3%  slabinfo.lsm_file_cache.active_slabs
    191069           +23.6%     236193 ±  3%  slabinfo.lsm_file_cache.num_objs
      1123           +23.6%       1388 ±  3%  slabinfo.lsm_file_cache.num_slabs
      2640 ± 23%     +61.7%       4270 ±  6%  slabinfo.request_sock_TCP.active_objs
      2640 ± 23%     +61.7%       4270 ±  6%  slabinfo.request_sock_TCP.num_objs
      5264 ±  6%     +55.5%       8188 ±  2%  slabinfo.skbuff_head_cache.active_objs
      5265 ±  6%     +55.5%       8189 ±  2%  slabinfo.skbuff_head_cache.num_objs
    192129           +29.4%     248569        slabinfo.tw_sock_TCP.active_objs
      5825           +30.0%       7576        slabinfo.tw_sock_TCP.active_slabs
    192257           +30.0%     250019        slabinfo.tw_sock_TCP.num_objs
      5825           +30.0%       7576        slabinfo.tw_sock_TCP.num_slabs
     25.38           -16.2%      21.28        perf-stat.i.MPKI
 2.217e+09           +23.1%   2.73e+09        perf-stat.i.branch-instructions
      1.13 ±  2%      +0.1        1.27        perf-stat.i.branch-miss-rate%
  24373526           +40.4%   34215124        perf-stat.i.branch-misses
  88152704            +5.9%   93328112        perf-stat.i.cache-misses
 2.878e+08            +6.2%  3.055e+08        perf-stat.i.cache-references
     27876          +530.4%     175723 ±  2%  perf-stat.i.context-switches
      2.46 ±  2%     -16.0%       2.07        perf-stat.i.cpi
 2.762e+10            +6.1%  2.929e+10        perf-stat.i.cpu-cycles
    117.83 ±  4%     +26.1%     148.63 ±  3%  perf-stat.i.cpu-migrations
  16153047 ± 11%     +44.7%   23371999 ± 11%  perf-stat.i.dTLB-load-misses
 3.465e+09 ±  2%     +27.8%  4.427e+09        perf-stat.i.dTLB-loads
      0.01 ± 19%      +0.0        0.01 ± 13%  perf-stat.i.dTLB-store-miss-rate%
    134988 ± 14%    +155.5%     344922 ± 13%  perf-stat.i.dTLB-store-misses
   1.7e+09 ±  2%     +39.5%  2.372e+09        perf-stat.i.dTLB-stores
     63.19           +17.4       80.64        perf-stat.i.iTLB-load-miss-rate%
   4020769          +256.0%   14313812        perf-stat.i.iTLB-load-misses
   1967939 ±  2%     +58.3%    3115314        perf-stat.i.iTLB-loads
 1.119e+10           +26.6%  1.416e+10        perf-stat.i.instructions
      3490 ±  2%     -68.7%       1092        perf-stat.i.instructions-per-iTLB-miss
      0.42 ±  2%     +18.2%       0.49        perf-stat.i.ipc
      0.29            +6.1%       0.31        perf-stat.i.metric.GHz
      0.30 ± 34%     -63.7%       0.11 ±  9%  perf-stat.i.metric.K/sec
     80.62           +28.0%     103.16        perf-stat.i.metric.M/sec
     94.91            -9.0       85.91        perf-stat.i.node-store-miss-rate%
  20243974 ±  3%     -11.1%   17987019        perf-stat.i.node-store-misses
    519871 ±  5%    +337.7%    2275278 ±  2%  perf-stat.i.node-stores
     25.72           -16.2%      21.56        perf-stat.overall.MPKI
      1.10            +0.2        1.25        perf-stat.overall.branch-miss-rate%
      2.47 ±  2%     -16.3%       2.07        perf-stat.overall.cpi
      0.01 ± 15%      +0.0        0.01 ± 13%  perf-stat.overall.dTLB-store-miss-rate%
     67.12           +15.0       82.13        perf-stat.overall.iTLB-load-miss-rate%
      2789           -64.5%     989.27        perf-stat.overall.instructions-per-iTLB-miss
      0.41 ±  2%     +19.4%       0.48        perf-stat.overall.ipc
     97.51            -8.8       88.75        perf-stat.overall.node-store-miss-rate%
 2.182e+09           +23.2%  2.688e+09        perf-stat.ps.branch-instructions
  23976684           +40.4%   33667917        perf-stat.ps.branch-misses
  86792250            +5.8%   91827397        perf-stat.ps.cache-misses
 2.833e+08            +6.1%  3.006e+08        perf-stat.ps.cache-references
     27275          +534.4%     173046 ±  2%  perf-stat.ps.context-switches
 2.719e+10            +6.0%  2.883e+10        perf-stat.ps.cpu-cycles
    115.93 ±  4%     +26.2%     146.33 ±  3%  perf-stat.ps.cpu-migrations
  15904910 ± 11%     +44.5%   22977809 ± 11%  perf-stat.ps.dTLB-load-misses
 3.411e+09           +27.8%  4.357e+09        perf-stat.ps.dTLB-loads
    132772 ± 14%    +155.5%     339281 ± 13%  perf-stat.ps.dTLB-store-misses
 1.673e+09 ±  2%     +39.5%  2.335e+09        perf-stat.ps.dTLB-stores
   3948292          +257.0%   14096088        perf-stat.ps.iTLB-load-misses
   1934787 ±  2%     +58.5%    3066788        perf-stat.ps.iTLB-loads
 1.101e+10           +26.6%  1.394e+10        perf-stat.ps.instructions
  19931573 ±  3%     -11.2%   17693059        perf-stat.ps.node-store-misses
    509785 ±  5%    +339.6%    2240990 ±  2%  perf-stat.ps.node-stores
 6.971e+11 ±  2%     +27.0%  8.855e+11        perf-stat.total.instructions
     73769 ± 10%     -24.7%      55542 ±  2%  interrupts.CAL:Function_call_interrupts
     26.33 ± 70%   +1144.3%     327.67 ± 17%  interrupts.CPU0.RES:Rescheduling_interrupts
     71.50 ± 42%    +984.8%     775.67 ± 40%  interrupts.CPU1.RES:Rescheduling_interrupts
     43.33 ±119%   +1041.2%     494.50 ± 34%  interrupts.CPU10.RES:Rescheduling_interrupts
     63.50 ± 77%    +481.9%     369.50 ± 27%  interrupts.CPU11.RES:Rescheduling_interrupts
     47.00 ± 70%    +850.4%     446.67 ± 44%  interrupts.CPU12.RES:Rescheduling_interrupts
     39.17 ±135%    +939.6%     407.17 ± 48%  interrupts.CPU13.RES:Rescheduling_interrupts
     37.67 ±103%    +748.2%     319.50 ± 49%  interrupts.CPU14.RES:Rescheduling_interrupts
     28.83 ±148%   +1181.5%     369.50 ± 31%  interrupts.CPU15.RES:Rescheduling_interrupts
     31.67 ± 91%    +887.4%     312.67 ± 44%  interrupts.CPU16.RES:Rescheduling_interrupts
     30.83 ±133%    +935.1%     319.17 ± 24%  interrupts.CPU17.RES:Rescheduling_interrupts
     61.00 ± 37%    +440.2%     329.50 ± 47%  interrupts.CPU18.RES:Rescheduling_interrupts
     54.67 ± 35%    +511.6%     334.33 ± 41%  interrupts.CPU19.RES:Rescheduling_interrupts
     67.17 ± 59%   +1071.5%     786.83 ± 38%  interrupts.CPU2.RES:Rescheduling_interrupts
     33.83 ± 77%    +707.9%     273.33 ± 36%  interrupts.CPU20.RES:Rescheduling_interrupts
     22.17 ± 76%   +1046.6%     254.17 ± 33%  interrupts.CPU21.RES:Rescheduling_interrupts
    119.00 ± 27%    +925.6%       1220 ± 79%  interrupts.CPU22.NMI:Non-maskable_interrupts
    119.00 ± 27%    +925.6%       1220 ± 79%  interrupts.CPU22.PMI:Performance_monitoring_interrupts
     22.67 ± 66%   +1788.2%     428.00 ± 48%  interrupts.CPU22.RES:Rescheduling_interrupts
    120.83 ±  9%   +1111.7%       1464 ±107%  interrupts.CPU23.NMI:Non-maskable_interrupts
    120.83 ±  9%   +1111.7%       1464 ±107%  interrupts.CPU23.PMI:Performance_monitoring_interrupts
     41.00 ±134%    +449.2%     225.17 ± 36%  interrupts.CPU23.RES:Rescheduling_interrupts
    269.83 ± 75%    +768.8%       2344 ± 69%  interrupts.CPU24.NMI:Non-maskable_interrupts
    269.83 ± 75%    +768.8%       2344 ± 69%  interrupts.CPU24.PMI:Performance_monitoring_interrupts
     60.33 ± 69%    +748.3%     511.83 ± 41%  interrupts.CPU24.RES:Rescheduling_interrupts
     51.83 ± 86%   +1797.7%     983.67 ± 26%  interrupts.CPU25.RES:Rescheduling_interrupts
     44.33 ± 61%   +1635.7%     769.50 ± 23%  interrupts.CPU26.RES:Rescheduling_interrupts
     72.17 ± 83%   +1060.3%     837.33 ± 23%  interrupts.CPU27.RES:Rescheduling_interrupts
     51.67 ±147%   +1175.2%     658.83 ± 18%  interrupts.CPU28.RES:Rescheduling_interrupts
    186.67 ± 71%    +468.0%       1060 ± 42%  interrupts.CPU29.NMI:Non-maskable_interrupts
    186.67 ± 71%    +468.0%       1060 ± 42%  interrupts.CPU29.PMI:Performance_monitoring_interrupts
     44.83 ± 66%   +1643.5%     781.67 ± 46%  interrupts.CPU29.RES:Rescheduling_interrupts
     83.17 ± 93%    +686.4%     654.00 ± 19%  interrupts.CPU3.RES:Rescheduling_interrupts
     30.83 ± 79%   +1429.2%     471.50 ± 44%  interrupts.CPU30.RES:Rescheduling_interrupts
     13.17 ± 74%   +4870.9%     654.50 ± 54%  interrupts.CPU31.RES:Rescheduling_interrupts
     22.83 ± 49%   +1778.1%     428.83 ± 59%  interrupts.CPU32.RES:Rescheduling_interrupts
    136.17 ± 18%   +1238.3%       1822 ± 85%  interrupts.CPU33.NMI:Non-maskable_interrupts
    136.17 ± 18%   +1238.3%       1822 ± 85%  interrupts.CPU33.PMI:Performance_monitoring_interrupts
     54.00 ±111%   +1000.9%     594.50 ± 44%  interrupts.CPU33.RES:Rescheduling_interrupts
     49.17 ± 63%    +713.9%     400.17 ± 66%  interrupts.CPU34.RES:Rescheduling_interrupts
     38.50 ± 67%    +955.0%     406.17 ± 51%  interrupts.CPU35.RES:Rescheduling_interrupts
     41.83 ± 83%    +918.7%     426.17 ± 17%  interrupts.CPU36.RES:Rescheduling_interrupts
     37.67 ±107%    +989.8%     410.50 ± 52%  interrupts.CPU37.RES:Rescheduling_interrupts
     50.00 ±100%    +743.0%     421.50 ± 23%  interrupts.CPU38.RES:Rescheduling_interrupts
     24.00 ±110%   +1014.6%     267.50 ± 47%  interrupts.CPU39.RES:Rescheduling_interrupts
     34.50 ± 70%   +2195.7%     792.00 ± 38%  interrupts.CPU4.RES:Rescheduling_interrupts
     50.50 ± 95%    +506.3%     306.17 ± 53%  interrupts.CPU40.RES:Rescheduling_interrupts
     42.17 ±132%    +501.2%     253.50 ± 33%  interrupts.CPU41.RES:Rescheduling_interrupts
     46.17 ± 96%    +571.5%     310.00 ± 57%  interrupts.CPU42.RES:Rescheduling_interrupts
     37.67 ±107%   +1051.3%     433.67 ± 72%  interrupts.CPU43.RES:Rescheduling_interrupts
    115.00 ± 22%    +731.9%     956.67 ± 71%  interrupts.CPU44.NMI:Non-maskable_interrupts
    115.00 ± 22%    +731.9%     956.67 ± 71%  interrupts.CPU44.PMI:Performance_monitoring_interrupts
     11.67 ±132%   +1657.1%     205.00 ± 62%  interrupts.CPU44.RES:Rescheduling_interrupts
     22.83 ± 85%    +838.7%     214.33 ± 56%  interrupts.CPU45.RES:Rescheduling_interrupts
    510.17 ±  3%    +106.2%       1051 ± 78%  interrupts.CPU46.CAL:Function_call_interrupts
     46.50 ± 32%    +373.1%     220.00 ± 37%  interrupts.CPU46.RES:Rescheduling_interrupts
     14.33 ±119%   +1297.7%     200.33 ± 86%  interrupts.CPU47.RES:Rescheduling_interrupts
     42.67 ±103%    +515.6%     262.67 ± 43%  interrupts.CPU48.RES:Rescheduling_interrupts
     47.33 ±140%    +793.7%     423.00 ± 53%  interrupts.CPU49.RES:Rescheduling_interrupts
     65.17 ± 97%    +702.6%     523.00 ± 23%  interrupts.CPU5.RES:Rescheduling_interrupts
     65.67 ± 59%    +298.0%     261.33 ± 48%  interrupts.CPU50.RES:Rescheduling_interrupts
     18.67 ± 75%   +2134.8%     417.17 ± 41%  interrupts.CPU51.RES:Rescheduling_interrupts
     64.17 ± 61%    +490.9%     379.17 ± 34%  interrupts.CPU52.RES:Rescheduling_interrupts
     56.33 ± 97%    +670.4%     434.00 ± 51%  interrupts.CPU54.RES:Rescheduling_interrupts
     32.33 ± 77%   +1141.2%     401.33 ± 15%  interrupts.CPU55.RES:Rescheduling_interrupts
    221.83 ±105%    +366.4%       1034 ±101%  interrupts.CPU56.NMI:Non-maskable_interrupts
    221.83 ±105%    +366.4%       1034 ±101%  interrupts.CPU56.PMI:Performance_monitoring_interrupts
     33.17 ±134%    +814.1%     303.17 ± 42%  interrupts.CPU56.RES:Rescheduling_interrupts
     36.83 ± 82%   +1127.6%     452.17 ± 47%  interrupts.CPU57.RES:Rescheduling_interrupts
     15.00 ± 61%   +3018.9%     467.83 ± 45%  interrupts.CPU58.RES:Rescheduling_interrupts
     20.67 ± 63%   +1154.0%     259.17 ± 32%  interrupts.CPU59.RES:Rescheduling_interrupts
     32.50 ± 49%   +1437.4%     499.67 ± 43%  interrupts.CPU6.RES:Rescheduling_interrupts
     44.83 ± 79%    +673.6%     346.83 ± 53%  interrupts.CPU60.RES:Rescheduling_interrupts
     15.83 ± 56%   +1555.8%     262.17 ± 51%  interrupts.CPU61.RES:Rescheduling_interrupts
     39.83 ±123%    +864.9%     384.33 ± 47%  interrupts.CPU62.RES:Rescheduling_interrupts
     51.50 ± 85%    +411.7%     263.50 ± 50%  interrupts.CPU64.RES:Rescheduling_interrupts
     28.67 ±155%    +719.8%     235.00 ± 63%  interrupts.CPU65.RES:Rescheduling_interrupts
     36.83 ±101%    +557.0%     242.00 ± 64%  interrupts.CPU66.RES:Rescheduling_interrupts
      7.83 ± 75%   +3757.4%     302.17 ± 64%  interrupts.CPU67.RES:Rescheduling_interrupts
     31.83 ±120%    +492.7%     188.67 ± 74%  interrupts.CPU68.RES:Rescheduling_interrupts
     41.67 ±100%    +466.4%     236.00 ± 47%  interrupts.CPU69.RES:Rescheduling_interrupts
     52.17 ± 33%   +1000.3%     574.00 ± 32%  interrupts.CPU7.RES:Rescheduling_interrupts
    121.17 ± 24%    +612.4%     863.17 ± 62%  interrupts.CPU70.NMI:Non-maskable_interrupts
    121.17 ± 24%    +612.4%     863.17 ± 62%  interrupts.CPU70.PMI:Performance_monitoring_interrupts
     16.33 ± 76%   +1075.5%     192.00 ± 66%  interrupts.CPU70.RES:Rescheduling_interrupts
    110.17 ± 25%    +859.8%       1057 ± 75%  interrupts.CPU71.NMI:Non-maskable_interrupts
    110.17 ± 25%    +859.8%       1057 ± 75%  interrupts.CPU71.PMI:Performance_monitoring_interrupts
     36.00 ±146%    +724.5%     296.83 ± 54%  interrupts.CPU71.RES:Rescheduling_interrupts
    415.83 ±101%    +208.9%       1284 ± 76%  interrupts.CPU72.NMI:Non-maskable_interrupts
    415.83 ±101%    +208.9%       1284 ± 76%  interrupts.CPU72.PMI:Performance_monitoring_interrupts
     28.00 ±180%    +848.2%     265.50 ± 83%  interrupts.CPU72.RES:Rescheduling_interrupts
      6.67 ± 51%   +7032.5%     475.50 ± 71%  interrupts.CPU73.RES:Rescheduling_interrupts
      6.67 ±126%   +5160.0%     350.67 ± 33%  interrupts.CPU74.RES:Rescheduling_interrupts
    424.00 ±116%    +260.7%       1529 ± 60%  interrupts.CPU75.NMI:Non-maskable_interrupts
    424.00 ±116%    +260.7%       1529 ± 60%  interrupts.CPU75.PMI:Performance_monitoring_interrupts
     23.17 ± 84%   +1324.5%     330.00 ± 30%  interrupts.CPU75.RES:Rescheduling_interrupts
     14.50 ±110%   +2033.3%     309.33 ± 37%  interrupts.CPU76.RES:Rescheduling_interrupts
    169.50 ± 89%    +400.3%     848.00 ± 58%  interrupts.CPU77.NMI:Non-maskable_interrupts
    169.50 ± 89%    +400.3%     848.00 ± 58%  interrupts.CPU77.PMI:Performance_monitoring_interrupts
     22.17 ±172%   +1917.3%     447.17 ± 52%  interrupts.CPU77.RES:Rescheduling_interrupts
     28.67 ±152%    +804.7%     259.33 ± 40%  interrupts.CPU78.RES:Rescheduling_interrupts
     14.00 ±113%   +2435.7%     355.00 ± 35%  interrupts.CPU79.RES:Rescheduling_interrupts
    196.67 ± 46%    +281.2%     749.67 ± 70%  interrupts.CPU8.NMI:Non-maskable_interrupts
    196.67 ± 46%    +281.2%     749.67 ± 70%  interrupts.CPU8.PMI:Performance_monitoring_interrupts
     59.50 ± 40%    +917.4%     605.33 ± 28%  interrupts.CPU8.RES:Rescheduling_interrupts
     19.17 ± 72%   +1612.2%     328.17 ± 25%  interrupts.CPU80.RES:Rescheduling_interrupts
    121.50 ± 30%   +1200.8%       1580 ± 63%  interrupts.CPU81.NMI:Non-maskable_interrupts
    121.50 ± 30%   +1200.8%       1580 ± 63%  interrupts.CPU81.PMI:Performance_monitoring_interrupts
     52.17 ±114%    +460.7%     292.50 ± 41%  interrupts.CPU81.RES:Rescheduling_interrupts
     50.50 ±121%    +407.9%     256.50 ± 37%  interrupts.CPU82.RES:Rescheduling_interrupts
     37.67 ± 91%    +992.9%     411.67 ± 53%  interrupts.CPU83.RES:Rescheduling_interrupts
     25.83 ± 67%   +1121.9%     315.67 ± 61%  interrupts.CPU84.RES:Rescheduling_interrupts
     38.50 ± 97%    +925.5%     394.83 ± 57%  interrupts.CPU85.RES:Rescheduling_interrupts
     21.17 ± 74%   +1758.3%     393.33 ± 75%  interrupts.CPU86.RES:Rescheduling_interrupts
     47.17 ±101%    +822.6%     435.17 ± 50%  interrupts.CPU87.RES:Rescheduling_interrupts
     16.67 ± 52%   +1871.0%     328.50 ± 72%  interrupts.CPU88.RES:Rescheduling_interrupts
     64.67 ± 31%    +548.5%     419.33 ± 37%  interrupts.CPU9.RES:Rescheduling_interrupts
     40.83 ± 97%    +653.9%     307.83 ± 51%  interrupts.CPU91.RES:Rescheduling_interrupts
     53.00 ± 84%    +511.6%     324.17 ± 45%  interrupts.CPU92.RES:Rescheduling_interrupts
     17.00 ± 80%   +1996.1%     356.33 ± 44%  interrupts.CPU93.RES:Rescheduling_interrupts
     14.67 ±109%   +2461.4%     375.67 ± 49%  interrupts.CPU94.RES:Rescheduling_interrupts
     16.83 ±126%   +1366.3%     246.83 ± 55%  interrupts.CPU95.RES:Rescheduling_interrupts
      3674 ±  4%    +927.8%      37769 ±  5%  interrupts.RES:Rescheduling_interrupts
    435.67 ± 40%    +121.2%     963.50 ± 78%  interrupts.TLB:TLB_shootdowns
      8830 ± 67%   +1260.1%     120103 ± 24%  softirqs.CPU0.NET_RX
     11931 ±  4%     +30.5%      15564 ± 11%  softirqs.CPU0.SCHED
     16183 ± 52%    +757.3%     138737 ± 21%  softirqs.CPU1.NET_RX
      9241 ±  9%     +41.7%      13090 ± 16%  softirqs.CPU1.RCU
      9990 ± 13%     +26.7%      12657 ± 11%  softirqs.CPU1.SCHED
     10833 ± 82%    +587.9%      74518 ± 24%  softirqs.CPU10.NET_RX
      9309           +11.1%      10343 ±  4%  softirqs.CPU10.SCHED
     16966 ± 76%    +396.6%      84257 ± 21%  softirqs.CPU11.NET_RX
     14684 ± 55%    +373.7%      69565 ± 44%  softirqs.CPU12.NET_RX
     11864 ±112%    +528.0%      74509 ± 31%  softirqs.CPU13.NET_RX
      9913 ± 81%    +627.3%      72106 ± 12%  softirqs.CPU14.NET_RX
      8183 ±  9%     +13.6%       9292 ±  6%  softirqs.CPU14.RCU
      9255 ±  2%     +16.3%      10768 ±  5%  softirqs.CPU14.SCHED
     11106 ±121%    +442.0%      60198 ± 30%  softirqs.CPU15.NET_RX
     12926 ± 76%    +407.5%      65607 ± 28%  softirqs.CPU16.NET_RX
      8222 ±102%    +652.2%      61853 ± 38%  softirqs.CPU17.NET_RX
     16663 ± 38%    +259.4%      59894 ± 27%  softirqs.CPU18.NET_RX
      9252 ±  2%     +11.7%      10335 ±  6%  softirqs.CPU18.SCHED
     14125 ± 45%    +306.1%      57361 ± 43%  softirqs.CPU19.NET_RX
     19278 ± 49%    +501.2%     115899 ± 19%  softirqs.CPU2.NET_RX
      9140 ±  8%     +21.4%      11098 ±  4%  softirqs.CPU2.RCU
      9487 ±  3%     +19.2%      11306 ±  7%  softirqs.CPU2.SCHED
     12296 ± 93%    +336.9%      53727 ± 27%  softirqs.CPU20.NET_RX
      9869 ± 77%    +324.5%      41897 ± 31%  softirqs.CPU21.NET_RX
      8826 ± 54%    +607.0%      62404 ± 31%  softirqs.CPU22.NET_RX
      9315 ±  2%     +14.8%      10695 ±  6%  softirqs.CPU22.SCHED
     10475 ± 89%    +456.7%      58319 ± 48%  softirqs.CPU23.NET_RX
     12950 ± 35%   +1009.4%     143672 ± 30%  softirqs.CPU24.NET_RX
      9948 ±  5%     +41.8%      14102 ±  9%  softirqs.CPU24.SCHED
     18416 ± 51%    +741.8%     155031 ± 31%  softirqs.CPU25.NET_RX
      9391 ± 10%     +38.1%      12968 ± 16%  softirqs.CPU25.RCU
      9237 ± 12%     +30.6%      12061 ±  7%  softirqs.CPU25.SCHED
     14158 ± 58%    +850.3%     134537 ± 25%  softirqs.CPU26.NET_RX
      9363 ±  3%     +26.9%      11879 ± 10%  softirqs.CPU26.SCHED
     15992 ± 50%    +799.7%     143881 ± 21%  softirqs.CPU27.NET_RX
      9150 ±  8%     +28.5%      11761 ± 11%  softirqs.CPU27.RCU
      9397 ±  2%     +24.8%      11726 ±  9%  softirqs.CPU27.SCHED
     12036 ± 78%    +787.5%     106824 ± 21%  softirqs.CPU28.NET_RX
     10926 ± 85%   +1028.1%     123256 ± 32%  softirqs.CPU29.NET_RX
      8771 ±  5%     +29.1%      11324 ± 15%  softirqs.CPU29.RCU
     18088 ± 76%    +610.3%     128474 ± 31%  softirqs.CPU3.NET_RX
      9461 ±  2%     +25.1%      11832 ±  8%  softirqs.CPU3.SCHED
     14278 ± 77%    +639.0%     105521 ± 39%  softirqs.CPU30.NET_RX
      8865 ±  8%     +22.5%      10855 ± 14%  softirqs.CPU30.RCU
      6563 ± 83%   +1487.2%     104167 ± 44%  softirqs.CPU31.NET_RX
      8461 ±  5%     +27.5%      10788 ± 16%  softirqs.CPU31.RCU
      9456 ±  2%     +14.8%      10860 ± 10%  softirqs.CPU31.SCHED
      9245 ± 45%    +923.6%      94637 ± 61%  softirqs.CPU32.NET_RX
     12745 ± 96%    +703.7%     102431 ± 54%  softirqs.CPU33.NET_RX
     14430 ± 66%    +436.6%      77441 ± 49%  softirqs.CPU34.NET_RX
     17445 ± 57%    +317.8%      72879 ± 42%  softirqs.CPU35.NET_RX
     13208 ± 59%    +481.6%      76816 ± 33%  softirqs.CPU36.NET_RX
      9637 ± 64%    +640.8%      71395 ± 27%  softirqs.CPU37.NET_RX
     13024 ± 85%    +553.0%      85048 ± 22%  softirqs.CPU38.NET_RX
     11309 ± 91%    +533.3%      71623 ± 16%  softirqs.CPU39.NET_RX
      9184 ±  2%     +15.9%      10640 ±  3%  softirqs.CPU39.SCHED
      9592 ± 41%   +1125.9%     117599 ± 23%  softirqs.CPU4.NET_RX
      8361 ±  5%     +36.4%      11402 ± 12%  softirqs.CPU4.RCU
      9456           +16.2%      10987 ±  9%  softirqs.CPU4.SCHED
     10046 ± 86%    +508.8%      61156 ± 26%  softirqs.CPU40.NET_RX
     13357 ± 78%    +383.7%      64610 ± 20%  softirqs.CPU41.NET_RX
      9495 ±  4%     +11.3%      10570 ±  7%  softirqs.CPU41.SCHED
     14571 ±118%    +329.8%      62628 ± 37%  softirqs.CPU42.NET_RX
     12159 ± 59%    +375.1%      57766 ± 46%  softirqs.CPU43.NET_RX
      4342 ± 86%   +1102.7%      52221 ± 79%  softirqs.CPU44.NET_RX
     10529 ±108%    +313.3%      43516 ± 43%  softirqs.CPU45.NET_RX
     14525 ± 41%    +264.8%      52993 ± 37%  softirqs.CPU46.NET_RX
      4517 ±114%    +754.3%      38592 ± 45%  softirqs.CPU47.NET_RX
     12059 ± 86%    +446.5%      65907 ± 31%  softirqs.CPU48.NET_RX
      7573 ±  9%     +19.9%       9079 ±  6%  softirqs.CPU48.RCU
      7588 ±112%    +652.5%      57103 ± 18%  softirqs.CPU49.NET_RX
     13904 ± 62%    +751.3%     118360 ± 25%  softirqs.CPU5.NET_RX
      8563 ±  9%     +34.4%      11507 ±  5%  softirqs.CPU5.RCU
      9370           +26.5%      11854 ±  8%  softirqs.CPU5.SCHED
     14523 ± 38%    +311.5%      59763 ± 31%  softirqs.CPU50.NET_RX
      8029 ± 26%     +28.0%      10279 ±  4%  softirqs.CPU50.SCHED
      9569 ± 64%    +678.7%      74515 ± 39%  softirqs.CPU51.NET_RX
      9410 ±  2%     +10.6%      10411 ±  4%  softirqs.CPU51.SCHED
     18241 ± 66%    +303.0%      73517 ± 20%  softirqs.CPU52.NET_RX
     20138 ± 67%    +258.5%      72195 ± 28%  softirqs.CPU53.NET_RX
      9574 ±  5%     +11.8%      10699 ±  7%  softirqs.CPU53.SCHED
     14135 ± 69%    +424.0%      74076 ± 36%  softirqs.CPU54.NET_RX
      7701 ± 57%    +718.3%      63025 ±  9%  softirqs.CPU55.NET_RX
     12838 ± 94%    +461.9%      72138 ± 34%  softirqs.CPU56.NET_RX
      9297           +16.8%      10858 ±  9%  softirqs.CPU56.SCHED
      8682 ± 57%    +663.8%      66313 ± 31%  softirqs.CPU57.NET_RX
      6705 ± 78%   +1063.1%      77987 ± 26%  softirqs.CPU58.NET_RX
      7435 ± 13%     +31.5%       9780 ± 12%  softirqs.CPU58.RCU
      9715 ± 90%    +434.0%      51883 ± 48%  softirqs.CPU59.NET_RX
      9224           +16.8%      10769 ± 10%  softirqs.CPU59.SCHED
     16734 ± 49%    +355.6%      76237 ± 32%  softirqs.CPU6.NET_RX
     12885 ± 55%    +350.5%      58051 ± 53%  softirqs.CPU60.NET_RX
      7611 ± 75%    +438.9%      41017 ± 44%  softirqs.CPU61.NET_RX
     13643 ± 74%    +290.5%      53273 ± 50%  softirqs.CPU62.NET_RX
      8762 ±  5%     +10.5%       9680 ±  5%  softirqs.CPU62.SCHED
      9390 ±  2%     +12.9%      10598 ±  4%  softirqs.CPU63.SCHED
     14037 ± 67%    +301.2%      56322 ± 52%  softirqs.CPU64.NET_RX
      9442 ±  2%     +11.5%      10530 ±  8%  softirqs.CPU64.SCHED
      5997 ±132%    +593.9%      41613 ± 54%  softirqs.CPU65.NET_RX
      5753 ± 73%    +760.1%      49486 ± 36%  softirqs.CPU66.NET_RX
      9275           +11.0%      10297 ±  3%  softirqs.CPU66.SCHED
      4948 ±117%    +723.3%      40743 ± 54%  softirqs.CPU67.NET_RX
     14236 ± 82%    +207.4%      43759 ± 29%  softirqs.CPU69.NET_RX
     11767 ± 48%    +885.1%     115925 ± 20%  softirqs.CPU7.NET_RX
      7972 ± 12%     +37.5%      10958 ± 13%  softirqs.CPU7.RCU
      9355 ±  2%     +21.0%      11321 ±  6%  softirqs.CPU7.SCHED
      6165 ± 61%    +504.1%      37246 ± 30%  softirqs.CPU70.NET_RX
      7331 ±149%    +535.7%      46605 ± 41%  softirqs.CPU71.NET_RX
      4994 ±135%   +1042.4%      57059 ± 35%  softirqs.CPU72.NET_RX
      3843 ± 93%   +1959.4%      79143 ± 41%  softirqs.CPU73.NET_RX
      9112 ±  2%     +12.4%      10246 ±  6%  softirqs.CPU73.SCHED
      7262 ± 88%   +1084.9%      86049 ± 29%  softirqs.CPU74.NET_RX
      7966 ±  6%     +18.5%       9444 ± 10%  softirqs.CPU74.RCU
      9226           +16.3%      10730 ± 10%  softirqs.CPU74.SCHED
      7467 ±112%    +704.7%      60088 ± 33%  softirqs.CPU75.NET_RX
      5702 ±102%    +988.5%      62070 ± 48%  softirqs.CPU76.NET_RX
      4963 ±153%   +1267.7%      67889 ± 29%  softirqs.CPU77.NET_RX
      6960 ±111%    +883.5%      68457 ± 24%  softirqs.CPU78.NET_RX
      7773 ±  7%     +21.4%       9437 ± 12%  softirqs.CPU78.RCU
      9181 ±  3%     +18.7%      10896 ±  7%  softirqs.CPU78.SCHED
      7508 ± 83%    +599.5%      52524 ± 13%  softirqs.CPU79.NET_RX
     24309 ± 43%    +355.9%     110836 ± 11%  softirqs.CPU8.NET_RX
      9386           +18.4%      11110 ±  9%  softirqs.CPU8.SCHED
      7213 ± 36%    +581.0%      49121 ± 23%  softirqs.CPU80.NET_RX
      8464 ±114%    +638.1%      62474 ± 24%  softirqs.CPU81.NET_RX
      9082 ±  4%     +13.0%      10264 ±  4%  softirqs.CPU81.SCHED
      9317 ± 67%    +474.4%      53517 ± 34%  softirqs.CPU82.NET_RX
      9424 ±  3%     +13.3%      10681 ±  7%  softirqs.CPU82.SCHED
     14526 ± 39%    +350.9%      65496 ± 42%  softirqs.CPU83.NET_RX
      7002 ± 77%    +791.7%      62441 ± 46%  softirqs.CPU84.NET_RX
     11867 ± 61%    +381.0%      57077 ± 36%  softirqs.CPU85.NET_RX
      7553 ± 76%    +752.2%      64370 ± 31%  softirqs.CPU86.NET_RX
     15523 ± 82%    +322.8%      65638 ± 35%  softirqs.CPU87.NET_RX
      9254 ±  2%      +9.3%      10117 ±  5%  softirqs.CPU87.SCHED
      4728 ± 43%   +1256.9%      64167 ± 64%  softirqs.CPU88.NET_RX
     12545 ± 96%    +335.6%      54650 ± 46%  softirqs.CPU89.NET_RX
     23303 ± 46%    +307.1%      94858 ± 27%  softirqs.CPU9.NET_RX
      9478 ±  2%     +19.5%      11324 ±  5%  softirqs.CPU9.SCHED
     16165 ± 43%    +249.1%      56432 ± 42%  softirqs.CPU91.NET_RX
     18285 ± 64%    +249.3%      63878 ± 46%  softirqs.CPU92.NET_RX
      7378 ±105%    +634.2%      54177 ± 53%  softirqs.CPU93.NET_RX
      5036 ±145%   +1383.9%      74734 ± 52%  softirqs.CPU94.NET_RX
      9235 ±  2%     +16.4%      10747 ±  8%  softirqs.CPU94.SCHED
      3753 ±111%   +1215.1%      49360 ± 50%  softirqs.CPU95.NET_RX
   1098222          +536.8%    6992957 ±  2%  softirqs.NET_RX
    823060           +11.5%     917430 ±  4%  softirqs.RCU
    906425           +11.7%    1012124        softirqs.SCHED
     96956           +66.2%     161160 ±  5%  softirqs.TIMER
     62.15 ±  6%     -14.3       47.90 ±  6%  perf-profile.calltrace.cycles-pp.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect.__sys_connect
     62.70 ±  6%     -12.9       49.83 ±  6%  perf-profile.calltrace.cycles-pp.tcp_v4_connect.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect
     62.86 ±  6%     -11.5       51.39 ±  6%  perf-profile.calltrace.cycles-pp.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64
     62.87 ±  6%     -11.5       51.40 ±  6%  perf-profile.calltrace.cycles-pp.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
     62.87 ±  6%     -11.4       51.45 ±  6%  perf-profile.calltrace.cycles-pp.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
     62.87 ±  6%     -11.4       51.45 ±  6%  perf-profile.calltrace.cycles-pp.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
     39.79 ±  7%     -10.5       29.28 ±  6%  perf-profile.calltrace.cycles-pp.__inet_check_established.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect
     17.61 ±  7%      -3.4       14.20 ±  8%  perf-profile.calltrace.cycles-pp._raw_spin_lock_bh.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect
     16.14 ±  7%      -3.4       12.75 ±  7%  perf-profile.calltrace.cycles-pp._raw_spin_lock.__inet_check_established.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect
      1.26 ±  6%      -0.3        1.00 ±  6%  perf-profile.calltrace.cycles-pp.inet_ehashfn.__inet_check_established.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect
      0.69 ±  7%      -0.2        0.48 ± 45%  perf-profile.calltrace.cycles-pp.___might_sleep.__inet_hash_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect
      0.00            +0.6        0.59 ±  9%  perf-profile.calltrace.cycles-pp.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish
      0.00            +0.6        0.60 ±  8%  perf-profile.calltrace.cycles-pp.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.6        0.60 ±  8%  perf-profile.calltrace.cycles-pp.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.7        0.65 ± 12%  perf-profile.calltrace.cycles-pp.__sock_create.__sys_socket.__x64_sys_socket.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.7        0.69 ± 10%  perf-profile.calltrace.cycles-pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.inet_shutdown
      0.00            +0.7        0.71 ± 32%  perf-profile.calltrace.cycles-pp.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.ip_local_deliver
      0.00            +0.7        0.71 ±  9%  perf-profile.calltrace.cycles-pp.__sys_accept4_file.__sys_accept4.__x64_sys_accept.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.7        0.72 ±  9%  perf-profile.calltrace.cycles-pp.__sys_accept4.__x64_sys_accept.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.7        0.73 ±  9%  perf-profile.calltrace.cycles-pp.__x64_sys_accept.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.8        0.76 ± 10%  perf-profile.calltrace.cycles-pp.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.inet_shutdown.__sys_shutdown
      0.00            +0.8        0.79 ±  9%  perf-profile.calltrace.cycles-pp.__tcp_close.tcp_close.inet_release.__sock_release.sock_close
      0.00            +0.8        0.82 ±  9%  perf-profile.calltrace.cycles-pp.tcp_close.inet_release.__sock_release.sock_close.__fput
      0.00            +0.9        0.88 ± 10%  perf-profile.calltrace.cycles-pp.tcp_write_xmit.__tcp_push_pending_frames.inet_shutdown.__sys_shutdown.__x64_sys_shutdown
      0.00            +0.9        0.88 ± 10%  perf-profile.calltrace.cycles-pp.__tcp_push_pending_frames.inet_shutdown.__sys_shutdown.__x64_sys_shutdown.do_syscall_64
      0.00            +0.9        0.90 ± 10%  perf-profile.calltrace.cycles-pp.__x64_sys_socket.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.9        0.90 ± 10%  perf-profile.calltrace.cycles-pp.__sys_socket.__x64_sys_socket.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.44 ± 45%      +1.0        1.41 ± 24%  perf-profile.calltrace.cycles-pp.irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
      0.00            +1.0        1.00 ±  7%  perf-profile.calltrace.cycles-pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.tcp_sendmsg_locked
      0.00            +1.0        1.01 ±  9%  perf-profile.calltrace.cycles-pp.ip_finish_output2.ip_output.__ip_queue_xmit.__tcp_transmit_skb.tcp_connect
      0.00            +1.0        1.03 ±  8%  perf-profile.calltrace.cycles-pp.ip_output.__ip_queue_xmit.__tcp_transmit_skb.tcp_connect.tcp_v4_connect
      0.00            +1.0        1.04 ±  7%  perf-profile.calltrace.cycles-pp.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.tcp_sendmsg_locked.tcp_sendmsg
      0.00            +1.0        1.05 ±  9%  perf-profile.calltrace.cycles-pp.inet_release.__sock_release.sock_close.__fput.task_work_run
      0.00            +1.1        1.08 ± 10%  perf-profile.calltrace.cycles-pp.__sock_release.sock_close.__fput.task_work_run.exit_to_user_mode_prepare
      0.00            +1.1        1.09 ± 10%  perf-profile.calltrace.cycles-pp.sock_close.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode
      0.00            +1.1        1.12 ±  9%  perf-profile.calltrace.cycles-pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_connect.tcp_v4_connect.__inet_stream_connect
      0.00            +1.1        1.13 ± 10%  perf-profile.calltrace.cycles-pp.ip_finish_output2.ip_output.__ip_queue_xmit.__tcp_transmit_skb.tcp_rcv_synsent_state_process
      0.00            +1.1        1.15 ± 10%  perf-profile.calltrace.cycles-pp.ip_output.__ip_queue_xmit.__tcp_transmit_skb.tcp_rcv_synsent_state_process.tcp_rcv_state_process
      0.00            +1.2        1.17 ± 10%  perf-profile.calltrace.cycles-pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_rcv_synsent_state_process.tcp_rcv_state_process.tcp_v4_do_rcv
      0.00            +1.2        1.18 ± 10%  perf-profile.calltrace.cycles-pp.__tcp_transmit_skb.tcp_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect
      0.00            +1.2        1.20 ± 10%  perf-profile.calltrace.cycles-pp.__tcp_transmit_skb.tcp_rcv_synsent_state_process.tcp_rcv_state_process.tcp_v4_do_rcv.__release_sock
      0.09 ±223%      +1.2        1.30 ± 23%  perf-profile.calltrace.cycles-pp.asm_call_sysvec_on_stack.do_softirq_own_stack.irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.09 ±223%      +1.2        1.30 ± 23%  perf-profile.calltrace.cycles-pp.__softirqentry_text_start.asm_call_sysvec_on_stack.do_softirq_own_stack.irq_exit_rcu.sysvec_apic_timer_interrupt
      0.09 ±223%      +1.2        1.30 ± 22%  perf-profile.calltrace.cycles-pp.do_softirq_own_stack.irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
      0.00            +1.3        1.29 ±  8%  perf-profile.calltrace.cycles-pp.tcp_write_xmit.__tcp_push_pending_frames.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg
      0.00            +1.3        1.29 ±  8%  perf-profile.calltrace.cycles-pp.__tcp_push_pending_frames.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.__sys_sendto
      0.00            +1.3        1.31 ±  9%  perf-profile.calltrace.cycles-pp.inet_shutdown.__sys_shutdown.__x64_sys_shutdown.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.3        1.35 ±  9%  perf-profile.calltrace.cycles-pp.tcp_rcv_state_process.tcp_v4_do_rcv.__release_sock.release_sock.__inet_stream_connect
      0.00            +1.4        1.38 ±  9%  perf-profile.calltrace.cycles-pp.__sys_shutdown.__x64_sys_shutdown.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.4        1.38 ±  9%  perf-profile.calltrace.cycles-pp.__x64_sys_shutdown.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.4        1.39 ±  9%  perf-profile.calltrace.cycles-pp.tcp_connect.tcp_v4_connect.__inet_stream_connect.inet_stream_connect.__sys_connect
      0.00            +1.4        1.43 ± 10%  perf-profile.calltrace.cycles-pp.tcp_rcv_synsent_state_process.tcp_rcv_state_process.tcp_v4_do_rcv.__release_sock.release_sock
      0.00            +1.5        1.47 ±  9%  perf-profile.calltrace.cycles-pp.tcp_v4_do_rcv.__release_sock.release_sock.__inet_stream_connect.inet_stream_connect
      0.00            +1.5        1.48 ±  9%  perf-profile.calltrace.cycles-pp.__release_sock.release_sock.__inet_stream_connect.inet_stream_connect.__sys_connect
      0.00            +1.5        1.49 ±  9%  perf-profile.calltrace.cycles-pp.release_sock.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect
      0.00            +1.5        1.49 ± 16%  perf-profile.calltrace.cycles-pp.ip_finish_output2.ip_output.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit
      0.00            +1.5        1.51 ±  9%  perf-profile.calltrace.cycles-pp.tcp_sendmsg_locked.tcp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto
      0.00            +1.5        1.55 ±  9%  perf-profile.calltrace.cycles-pp.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.00            +1.6        1.59 ±  6%  perf-profile.calltrace.cycles-pp.ip_output.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames
      0.00            +1.6        1.59 ±  9%  perf-profile.calltrace.cycles-pp.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.00            +1.6        1.65 ±  9%  perf-profile.calltrace.cycles-pp.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.00            +1.7        1.66 ±  9%  perf-profile.calltrace.cycles-pp.tcp_sendmsg.sock_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64
      0.00            +1.7        1.66 ±  9%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.00            +1.7        1.68 ±  9%  perf-profile.calltrace.cycles-pp.sock_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.7        1.69 ±  9%  perf-profile.calltrace.cycles-pp.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.7        1.70 ±  8%  perf-profile.calltrace.cycles-pp.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.54 ± 11%      +1.8        4.32 ± 52%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.do_idle
      0.00            +2.7        2.75 ± 17%  perf-profile.calltrace.cycles-pp.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.ip_local_deliver.ip_rcv
      0.00            +2.8        2.78 ± 17%  perf-profile.calltrace.cycles-pp.ip_protocol_deliver_rcu.ip_local_deliver_finish.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core
      0.00            +2.8        2.79 ± 18%  perf-profile.calltrace.cycles-pp.ip_local_deliver_finish.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core.process_backlog
      0.00            +2.8        2.81 ± 17%  perf-profile.calltrace.cycles-pp.ip_local_deliver.ip_rcv.__netif_receive_skb_one_core.process_backlog.net_rx_action
      0.00            +2.9        2.86 ± 17%  perf-profile.calltrace.cycles-pp.ip_rcv.__netif_receive_skb_one_core.process_backlog.net_rx_action.__softirqentry_text_start
      0.00            +3.1        3.09 ± 20%  perf-profile.calltrace.cycles-pp.__netif_receive_skb_one_core.process_backlog.net_rx_action.__softirqentry_text_start.asm_call_sysvec_on_stack
      0.00            +3.2        3.19 ± 14%  perf-profile.calltrace.cycles-pp.net_rx_action.__softirqentry_text_start.asm_call_sysvec_on_stack.do_softirq_own_stack.do_softirq
      0.00            +3.2        3.25 ± 17%  perf-profile.calltrace.cycles-pp.process_backlog.net_rx_action.__softirqentry_text_start.asm_call_sysvec_on_stack.do_softirq_own_stack
      0.00            +3.4        3.41 ± 11%  perf-profile.calltrace.cycles-pp.__softirqentry_text_start.asm_call_sysvec_on_stack.do_softirq_own_stack.do_softirq.__local_bh_enable_ip
      0.00            +3.4        3.43 ± 11%  perf-profile.calltrace.cycles-pp.asm_call_sysvec_on_stack.do_softirq_own_stack.do_softirq.__local_bh_enable_ip.ip_finish_output2
      0.00            +3.4        3.44 ± 11%  perf-profile.calltrace.cycles-pp.do_softirq_own_stack.do_softirq.__local_bh_enable_ip.ip_finish_output2.ip_output
      0.00            +3.5        3.47 ± 11%  perf-profile.calltrace.cycles-pp.do_softirq.__local_bh_enable_ip.ip_finish_output2.ip_output.__ip_queue_xmit
      0.00            +3.5        3.49 ± 11%  perf-profile.calltrace.cycles-pp.__local_bh_enable_ip.ip_finish_output2.ip_output.__ip_queue_xmit.__tcp_transmit_skb
     62.50 ±  6%     -14.4       48.10 ±  6%  perf-profile.children.cycles-pp.__inet_hash_connect
     62.70 ±  6%     -12.9       49.84 ±  6%  perf-profile.children.cycles-pp.tcp_v4_connect
     62.86 ±  6%     -11.5       51.39 ±  6%  perf-profile.children.cycles-pp.__inet_stream_connect
     62.87 ±  6%     -11.5       51.40 ±  6%  perf-profile.children.cycles-pp.inet_stream_connect
     62.87 ±  6%     -11.4       51.45 ±  6%  perf-profile.children.cycles-pp.__sys_connect
     62.87 ±  6%     -11.4       51.45 ±  6%  perf-profile.children.cycles-pp.__x64_sys_connect
     39.97 ±  7%     -10.5       29.42 ±  6%  perf-profile.children.cycles-pp.__inet_check_established
     17.71 ±  7%      -3.2       14.53 ±  8%  perf-profile.children.cycles-pp._raw_spin_lock_bh
     16.31 ±  7%      -2.8       13.49 ±  6%  perf-profile.children.cycles-pp._raw_spin_lock
      1.26 ±  6%      -0.2        1.03 ±  6%  perf-profile.children.cycles-pp.inet_ehashfn
      0.22 ±  8%      -0.1        0.16 ±  9%  perf-profile.children.cycles-pp._raw_spin_unlock_bh
      0.06 ±  9%      +0.0        0.10 ± 49%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.__update_load_avg_se
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.security_sk_free
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.memset_erms
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.__ksize
      0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.evict
      0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.ipv4_mtu
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.__x64_sys_getsockopt
      0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.inet_ehash_insert
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.__sk_mem_reduce_allocated
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.select_idle_sibling
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.kmem_cache_alloc_trace
      0.00            +0.1        0.06 ± 17%  perf-profile.children.cycles-pp.__inet_twsk_schedule
      0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.sk_filter_trim_cap
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.__netif_receive_skb_core
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.__skb_datagram_iter
      0.00            +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.__x64_sys_setsockopt
      0.00            +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.__sys_setsockopt
      0.00            +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.__x64_sys_close
      0.00            +0.1        0.07 ± 26%  perf-profile.children.cycles-pp.nr_iowait_cpu
      0.00            +0.1        0.07 ±  7%  perf-profile.children.cycles-pp.skb_copy_datagram_iter
      0.00            +0.1        0.07 ± 14%  perf-profile.children.cycles-pp.validate_xmit_skb
      0.00            +0.1        0.07 ± 14%  perf-profile.children.cycles-pp.ip_send_skb
      0.00            +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.tcp_get_metrics
      0.00            +0.1        0.07 ±  7%  perf-profile.children.cycles-pp.tcp_timewait_state_process
      0.00            +0.1        0.07 ± 23%  perf-profile.children.cycles-pp.get_partial_node
      0.00            +0.1        0.07 ± 16%  perf-profile.children.cycles-pp.security_sk_clone
      0.00            +0.1        0.07 ± 16%  perf-profile.children.cycles-pp.apparmor_sk_clone_security
      0.00            +0.1        0.07 ± 18%  perf-profile.children.cycles-pp.inet_csk_clear_xmit_timers
      0.07 ± 11%      +0.1        0.13 ± 24%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.00            +0.1        0.07 ± 13%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.00            +0.1        0.07 ± 15%  perf-profile.children.cycles-pp.skb_release_head_state
      0.00            +0.1        0.07 ± 10%  perf-profile.children.cycles-pp.page_counter_try_charge
      0.00            +0.1        0.07 ± 15%  perf-profile.children.cycles-pp.tcp_finish_connect
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.call_rcu
      0.00            +0.1        0.07 ± 15%  perf-profile.children.cycles-pp.tcp_connect_init
      0.00            +0.1        0.07 ± 17%  perf-profile.children.cycles-pp.apparmor_sk_alloc_security
      0.00            +0.1        0.07 ± 17%  perf-profile.children.cycles-pp.inet_csk_reqsk_queue_hash_add
      0.00            +0.1        0.07 ± 17%  perf-profile.children.cycles-pp.sk_stop_timer
      0.00            +0.1        0.07 ± 20%  perf-profile.children.cycles-pp.__skb_clone
      0.00            +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.tcp_v4_destroy_sock
      0.00            +0.1        0.07 ± 12%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.00            +0.1        0.07 ± 14%  perf-profile.children.cycles-pp.enqueue_to_backlog
      0.00            +0.1        0.07 ±  9%  perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.09 ± 10%      +0.1        0.16 ± 27%  perf-profile.children.cycles-pp.native_sched_clock
      0.00            +0.1        0.07 ± 20%  perf-profile.children.cycles-pp.security_file_alloc
      0.00            +0.1        0.07 ± 20%  perf-profile.children.cycles-pp.skb_release_all
      0.00            +0.1        0.08 ± 14%  perf-profile.children.cycles-pp.kmem_cache_alloc_node
      0.00            +0.1        0.08 ± 18%  perf-profile.children.cycles-pp.inet_twsk_kill
      0.00            +0.1        0.08 ± 14%  perf-profile.children.cycles-pp.__fget_light
      0.09 ± 13%      +0.1        0.17 ± 28%  perf-profile.children.cycles-pp.sched_clock
      0.00            +0.1        0.08 ±  6%  perf-profile.children.cycles-pp.__sys_getsockname
      0.00            +0.1        0.08 ± 14%  perf-profile.children.cycles-pp.sockfd_lookup_light
      0.00            +0.1        0.08 ± 15%  perf-profile.children.cycles-pp.__kmalloc_node_track_caller
      0.00            +0.1        0.08 ± 10%  perf-profile.children.cycles-pp.fib_table_lookup
      0.00            +0.1        0.08 ±  7%  perf-profile.children.cycles-pp.__x64_sys_getsockname
      0.00            +0.1        0.08 ± 22%  perf-profile.children.cycles-pp.ktime_get_with_offset
      0.10 ± 15%      +0.1        0.18 ± 27%  perf-profile.children.cycles-pp.sched_clock_cpu
      0.00            +0.1        0.08 ± 11%  perf-profile.children.cycles-pp.__memcg_kmem_charge
      0.00            +0.1        0.08 ± 14%  perf-profile.children.cycles-pp.inet_twsk_alloc
      0.00            +0.1        0.08 ± 14%  perf-profile.children.cycles-pp.__kmalloc_reserve
      0.00            +0.1        0.08 ± 16%  perf-profile.children.cycles-pp.security_sk_alloc
      0.00            +0.1        0.09 ± 13%  perf-profile.children.cycles-pp.select_task_rq_fair
      0.00            +0.1        0.09 ± 17%  perf-profile.children.cycles-pp.__tcp_send_ack
      0.00            +0.1        0.09 ± 17%  perf-profile.children.cycles-pp.tcp_mstamp_refresh
      0.00            +0.1        0.09 ±  9%  perf-profile.children.cycles-pp.ip_finish_output
      0.00            +0.1        0.09 ± 13%  perf-profile.children.cycles-pp.inet_csk_destroy_sock
      0.00            +0.1        0.10 ± 16%  perf-profile.children.cycles-pp.inet_twsk_deschedule_put
      0.00            +0.1        0.10 ± 15%  perf-profile.children.cycles-pp.update_curr
      0.00            +0.1        0.10 ± 10%  perf-profile.children.cycles-pp.sk_forced_mem_schedule
      0.00            +0.1        0.10 ± 17%  perf-profile.children.cycles-pp.skb_release_data
      0.00            +0.1        0.10 ± 10%  perf-profile.children.cycles-pp.set_next_entity
      0.00            +0.1        0.10 ±  9%  perf-profile.children.cycles-pp.d_alloc_pseudo
      0.00            +0.1        0.10 ±  9%  perf-profile.children.cycles-pp.__d_alloc
      0.00            +0.1        0.10 ± 11%  perf-profile.children.cycles-pp.drain_obj_stock
      0.00            +0.1        0.11 ± 10%  perf-profile.children.cycles-pp.__cgroup_bpf_run_filter_skb
      0.00            +0.1        0.11 ± 13%  perf-profile.children.cycles-pp.allocate_slab
      0.00            +0.1        0.12 ± 14%  perf-profile.children.cycles-pp.tcp_event_new_data_sent
      0.00            +0.1        0.12 ± 19%  perf-profile.children.cycles-pp.memcpy_erms
      0.00            +0.1        0.12 ± 14%  perf-profile.children.cycles-pp.tcp_init_transfer
      0.07 ± 11%      +0.1        0.19 ± 38%  perf-profile.children.cycles-pp.update_rq_clock
      0.00            +0.1        0.13 ± 12%  perf-profile.children.cycles-pp.obj_cgroup_charge
      0.00            +0.1        0.13 ± 13%  perf-profile.children.cycles-pp.tcp_set_state
      0.11 ± 12%      +0.1        0.25 ± 15%  perf-profile.children.cycles-pp.read_tsc
      0.00            +0.1        0.14 ± 14%  perf-profile.children.cycles-pp.sk_reset_timer
      0.04 ± 71%      +0.1        0.18 ±  7%  perf-profile.children.cycles-pp.update_load_avg
      0.00            +0.1        0.15 ± 11%  perf-profile.children.cycles-pp.poll_idle
      0.00            +0.2        0.15 ± 16%  perf-profile.children.cycles-pp.netif_rx_internal
      0.00            +0.2        0.15 ± 10%  perf-profile.children.cycles-pp.lock_timer_base
      0.00            +0.2        0.15 ± 20%  perf-profile.children.cycles-pp.tcp_v4_send_synack
      0.00            +0.2        0.16 ± 16%  perf-profile.children.cycles-pp.netif_rx
      0.00            +0.2        0.16 ± 11%  perf-profile.children.cycles-pp.__slab_free
      0.00            +0.2        0.16 ±  9%  perf-profile.children.cycles-pp.tcp_send_fin
      0.00            +0.2        0.17 ±  8%  perf-profile.children.cycles-pp.ip_send_unicast_reply
      0.00            +0.2        0.17 ±  9%  perf-profile.children.cycles-pp.refill_obj_stock
      0.00            +0.2        0.18 ± 10%  perf-profile.children.cycles-pp.tcp_done
      0.00            +0.2        0.18 ±  6%  perf-profile.children.cycles-pp.dequeue_entity
      0.00            +0.2        0.18 ±  9%  perf-profile.children.cycles-pp.tcp_v4_send_ack
      0.00            +0.2        0.18 ± 12%  perf-profile.children.cycles-pp.sk_stream_alloc_skb
      0.00            +0.2        0.18 ± 15%  perf-profile.children.cycles-pp.mod_timer
      0.00            +0.2        0.18 ±  7%  perf-profile.children.cycles-pp.dst_release
      0.00            +0.2        0.19 ± 10%  perf-profile.children.cycles-pp.enqueue_entity
      0.00            +0.2        0.19 ±  8%  perf-profile.children.cycles-pp.pick_next_task_fair
      0.00            +0.2        0.19 ±  8%  perf-profile.children.cycles-pp.lock_sock_nested
      0.00            +0.2        0.20 ±  6%  perf-profile.children.cycles-pp.dequeue_task_fair
      0.00            +0.2        0.20 ± 12%  perf-profile.children.cycles-pp.tcp_time_wait
      0.00            +0.2        0.20 ±  7%  perf-profile.children.cycles-pp.ip_route_output_flow
      0.00            +0.2        0.20 ± 12%  perf-profile.children.cycles-pp.sock_alloc_inode
      0.00            +0.2        0.22 ± 10%  perf-profile.children.cycles-pp.__alloc_file
      0.00            +0.2        0.22 ± 10%  perf-profile.children.cycles-pp.alloc_empty_file
      0.00            +0.2        0.23 ± 10%  perf-profile.children.cycles-pp.alloc_file
      0.00            +0.2        0.23 ± 19%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.00            +0.2        0.23 ± 10%  perf-profile.children.cycles-pp.tcp_clean_rtx_queue
      0.00            +0.2        0.23 ±  7%  perf-profile.children.cycles-pp.ip_route_output_key_hash_rcu
      0.00            +0.2        0.24 ± 19%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.00            +0.2        0.24 ±  8%  perf-profile.children.cycles-pp.enqueue_task_fair
      0.00            +0.2        0.24 ±  8%  perf-profile.children.cycles-pp.ttwu_do_activate
      0.00            +0.2        0.24 ± 10%  perf-profile.children.cycles-pp.tcp_delack_timer_handler
      0.00            +0.2        0.25 ± 12%  perf-profile.children.cycles-pp.__kfree_skb
      0.07 ± 20%      +0.2        0.32 ± 12%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.3        0.25 ± 17%  perf-profile.children.cycles-pp.___slab_alloc
      0.00            +0.3        0.26 ±  8%  perf-profile.children.cycles-pp.ip_route_output_key_hash
      0.03 ±100%      +0.3        0.29 ± 15%  perf-profile.children.cycles-pp.kthread
      0.03 ±100%      +0.3        0.29 ± 15%  perf-profile.children.cycles-pp.ret_from_fork
      0.00            +0.3        0.26 ± 10%  perf-profile.children.cycles-pp.alloc_inode
      0.00            +0.3        0.26 ± 11%  perf-profile.children.cycles-pp.wait_woken
      0.00            +0.3        0.26 ± 16%  perf-profile.children.cycles-pp.__slab_alloc
      0.00            +0.3        0.26 ± 10%  perf-profile.children.cycles-pp.tcp_delack_timer
      0.00            +0.3        0.27 ±  7%  perf-profile.children.cycles-pp.__dentry_kill
      0.01 ±223%      +0.3        0.28 ± 12%  perf-profile.children.cycles-pp.autoremove_wake_function
      0.02 ±141%      +0.3        0.30 ± 10%  perf-profile.children.cycles-pp.call_timer_fn
      0.00            +0.3        0.29 ± 10%  perf-profile.children.cycles-pp.__alloc_skb
      0.00            +0.3        0.29 ± 12%  perf-profile.children.cycles-pp.loopback_xmit
      0.04 ± 71%      +0.3        0.33 ± 10%  perf-profile.children.cycles-pp.run_timer_softirq
      0.00            +0.3        0.29 ± 16%  perf-profile.children.cycles-pp.sk_clone_lock
      0.00            +0.3        0.30 ± 15%  perf-profile.children.cycles-pp.inet_csk_clone_lock
      0.00            +0.3        0.31 ±  8%  perf-profile.children.cycles-pp.new_inode_pseudo
      0.00            +0.3        0.31 ± 12%  perf-profile.children.cycles-pp.dev_hard_start_xmit
      0.00            +0.3        0.32 ±  9%  perf-profile.children.cycles-pp.sock_alloc
      0.01 ±223%      +0.3        0.33 ±  9%  perf-profile.children.cycles-pp.sk_wait_data
      0.00            +0.3        0.33 ±  7%  perf-profile.children.cycles-pp.__sk_destruct
      0.00            +0.3        0.33 ± 11%  perf-profile.children.cycles-pp.schedule_idle
      0.00            +0.3        0.33 ± 13%  perf-profile.children.cycles-pp.sk_prot_alloc
      0.00            +0.3        0.33 ± 14%  perf-profile.children.cycles-pp.tcp_create_openreq_child
      0.07 ± 18%      +0.3        0.40 ±  7%  perf-profile.children.cycles-pp.rcu_core
      0.00            +0.3        0.34 ±  9%  perf-profile.children.cycles-pp.inet_csk_accept
      0.00            +0.3        0.34 ± 13%  perf-profile.children.cycles-pp.sk_alloc
      0.00            +0.3        0.35 ±  8%  perf-profile.children.cycles-pp.rcu_do_batch
      0.01 ±223%      +0.4        0.39 ±  9%  perf-profile.children.cycles-pp.alloc_file_pseudo
      0.01 ±223%      +0.4        0.39 ±  8%  perf-profile.children.cycles-pp.sock_alloc_file
      0.05 ± 45%      +0.4        0.43 ±  7%  perf-profile.children.cycles-pp.schedule
      0.04 ± 44%      +0.4        0.43 ±  9%  perf-profile.children.cycles-pp.schedule_timeout
      0.02 ±142%      +0.4        0.41 ± 12%  perf-profile.children.cycles-pp.tcp_conn_request
      0.01 ±223%      +0.4        0.41 ± 10%  perf-profile.children.cycles-pp.tcp_ack
      0.00            +0.4        0.40 ± 12%  perf-profile.children.cycles-pp.__inet_lookup_established
      0.00            +0.4        0.41 ± 10%  perf-profile.children.cycles-pp.inet_accept
      0.00            +0.4        0.41 ±  6%  perf-profile.children.cycles-pp.tcp_data_queue
      0.04 ± 75%      +0.4        0.45 ± 10%  perf-profile.children.cycles-pp.tcp_child_process
      0.00            +0.4        0.42 ± 13%  perf-profile.children.cycles-pp.inet_create
      0.00            +0.5        0.46 ± 12%  perf-profile.children.cycles-pp.tcp_v4_syn_recv_sock
      0.06 ± 13%      +0.5        0.55 ±  8%  perf-profile.children.cycles-pp.tcp_recvmsg_locked
      0.02 ±141%      +0.5        0.51 ± 11%  perf-profile.children.cycles-pp.tcp_check_req
      0.00            +0.5        0.49 ± 10%  perf-profile.children.cycles-pp.__dev_queue_xmit
      0.06 ± 15%      +0.5        0.56 ±  8%  perf-profile.children.cycles-pp.tcp_recvmsg
      0.06 ± 13%      +0.5        0.56 ±  8%  perf-profile.children.cycles-pp.inet_recvmsg
      0.06 ± 18%      +0.5        0.56 ±  9%  perf-profile.children.cycles-pp.try_to_wake_up
      0.06 ± 17%      +0.5        0.58 ±  9%  perf-profile.children.cycles-pp.__wake_up_common
      0.07 ± 10%      +0.5        0.60 ±  8%  perf-profile.children.cycles-pp.__sys_recvfrom
      0.07 ± 11%      +0.5        0.60 ±  9%  perf-profile.children.cycles-pp.__x64_sys_recvfrom
      0.07 ± 17%      +0.6        0.63 ±  9%  perf-profile.children.cycles-pp.__wake_up_common_lock
      0.07 ± 21%      +0.6        0.65 ±  9%  perf-profile.children.cycles-pp.sock_def_readable
      0.06 ±  9%      +0.6        0.65 ± 11%  perf-profile.children.cycles-pp.__sock_create
      0.06 ±  6%      +0.6        0.67 ± 10%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.00            +0.6        0.62 ±  9%  perf-profile.children.cycles-pp.kmem_cache_free
      0.09 ±  8%      +0.7        0.74 ±  9%  perf-profile.children.cycles-pp.__sched_text_start
      0.04 ± 45%      +0.7        0.71 ±  9%  perf-profile.children.cycles-pp.__sys_accept4_file
      0.04 ± 45%      +0.7        0.72 ±  9%  perf-profile.children.cycles-pp.__sys_accept4
      0.04 ± 45%      +0.7        0.73 ±  9%  perf-profile.children.cycles-pp.__x64_sys_accept
      0.05 ± 47%      +0.8        0.83 ±  9%  perf-profile.children.cycles-pp.tcp_rcv_established
      0.00            +0.8        0.79 ±  9%  perf-profile.children.cycles-pp.__tcp_close
      0.09 ± 10%      +0.8        0.90 ± 10%  perf-profile.children.cycles-pp.__x64_sys_socket
      0.09 ± 10%      +0.8        0.90 ± 10%  perf-profile.children.cycles-pp.__sys_socket
      0.00            +0.8        0.82 ±  9%  perf-profile.children.cycles-pp.tcp_close
      0.00            +1.1        1.05 ± 10%  perf-profile.children.cycles-pp.inet_release
      0.54 ±  7%      +1.1        1.61 ± 21%  perf-profile.children.cycles-pp.irq_exit_rcu
      0.01 ±223%      +1.1        1.09 ± 10%  perf-profile.children.cycles-pp.sock_close
      0.00            +1.1        1.08 ± 10%  perf-profile.children.cycles-pp.__sock_release
      0.16 ± 12%      +1.2        1.39 ±  9%  perf-profile.children.cycles-pp.tcp_connect
      0.15 ± 11%      +1.3        1.43 ± 10%  perf-profile.children.cycles-pp.tcp_rcv_synsent_state_process
      0.00            +1.3        1.31 ±  9%  perf-profile.children.cycles-pp.inet_shutdown
      0.00            +1.4        1.38 ±  9%  perf-profile.children.cycles-pp.__sys_shutdown
      0.00            +1.4        1.38 ±  8%  perf-profile.children.cycles-pp.__x64_sys_shutdown
      0.11 ± 16%      +1.4        1.51 ±  9%  perf-profile.children.cycles-pp.tcp_sendmsg_locked
      0.06 ±  9%      +1.5        1.55 ±  9%  perf-profile.children.cycles-pp.__fput
      0.07 ± 11%      +1.5        1.60 ±  9%  perf-profile.children.cycles-pp.task_work_run
      0.12 ± 15%      +1.5        1.66 ±  8%  perf-profile.children.cycles-pp.tcp_sendmsg
      0.12 ± 16%      +1.6        1.68 ±  9%  perf-profile.children.cycles-pp.sock_sendmsg
      0.12 ± 16%      +1.6        1.69 ±  9%  perf-profile.children.cycles-pp.__sys_sendto
      0.12 ± 16%      +1.6        1.70 ±  8%  perf-profile.children.cycles-pp.__x64_sys_sendto
      0.07 ±  8%      +1.6        1.65 ±  9%  perf-profile.children.cycles-pp.exit_to_user_mode_prepare
      0.07 ± 12%      +1.6        1.67 ±  9%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      0.17 ± 10%      +1.7        1.86 ±  8%  perf-profile.children.cycles-pp.__release_sock
      0.18 ± 10%      +1.8        1.95 ±  8%  perf-profile.children.cycles-pp.release_sock
      2.99 ± 10%      +1.9        4.87 ± 46%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.24 ± 11%      +2.4        2.62 ±  9%  perf-profile.children.cycles-pp.tcp_rcv_state_process
      0.12 ± 14%      +2.5        2.60 ±  8%  perf-profile.children.cycles-pp.tcp_write_xmit
      0.12 ± 14%      +2.5        2.62 ±  8%  perf-profile.children.cycles-pp.__tcp_push_pending_frames
      0.30 ± 11%      +3.2        3.47 ±  9%  perf-profile.children.cycles-pp.tcp_v4_do_rcv
      0.79 ±  5%      +3.6        4.34 ±  9%  perf-profile.children.cycles-pp.__local_bh_enable_ip
      0.34 ± 11%      +3.6        3.91 ±  9%  perf-profile.children.cycles-pp.do_softirq
      0.29 ± 12%      +3.6        3.88 ±  9%  perf-profile.children.cycles-pp.tcp_v4_rcv
      0.30 ± 12%      +3.6        3.92 ±  9%  perf-profile.children.cycles-pp.ip_protocol_deliver_rcu
      0.30 ± 12%      +3.6        3.94 ±  9%  perf-profile.children.cycles-pp.ip_local_deliver_finish
      0.30 ± 12%      +3.7        3.97 ±  8%  perf-profile.children.cycles-pp.ip_local_deliver
      0.30 ± 11%      +3.7        4.04 ±  8%  perf-profile.children.cycles-pp.ip_rcv
      0.32 ± 12%      +3.8        4.13 ±  8%  perf-profile.children.cycles-pp.__netif_receive_skb_one_core
      0.32 ± 11%      +3.9        4.23 ±  9%  perf-profile.children.cycles-pp.process_backlog
      0.32 ± 12%      +3.9        4.25 ±  9%  perf-profile.children.cycles-pp.ip_finish_output2
      0.33 ± 12%      +3.9        4.28 ±  9%  perf-profile.children.cycles-pp.net_rx_action
      0.33 ± 12%      +4.1        4.41 ±  8%  perf-profile.children.cycles-pp.ip_output
      0.35 ± 11%      +4.2        4.56 ±  8%  perf-profile.children.cycles-pp.__ip_queue_xmit
      0.37 ± 10%      +4.5        4.88 ±  9%  perf-profile.children.cycles-pp.__tcp_transmit_skb
      0.79 ±  8%      +4.6        5.37 ±  7%  perf-profile.children.cycles-pp.do_softirq_own_stack
      0.79 ±  8%      +4.8        5.56 ±  7%  perf-profile.children.cycles-pp.__softirqentry_text_start
      2.82 ± 11%      +5.2        8.04 ± 21%  perf-profile.children.cycles-pp.asm_call_sysvec_on_stack
     22.39 ±  8%      -6.9       15.54 ±  6%  perf-profile.self.cycles-pp.__inet_check_established
     17.18 ±  7%      -2.8       14.36 ±  8%  perf-profile.self.cycles-pp._raw_spin_lock_bh
     16.03 ±  7%      -2.8       13.23 ±  6%  perf-profile.self.cycles-pp._raw_spin_lock
      1.17 ±  6%      -0.2        0.95 ±  6%  perf-profile.self.cycles-pp.inet_ehashfn
      0.18 ±  9%      -0.0        0.13 ± 10%  perf-profile.self.cycles-pp._raw_spin_unlock_bh
      0.00            +0.1        0.05 ± 13%  perf-profile.self.cycles-pp.enqueue_task_fair
      0.00            +0.1        0.05 ±  8%  perf-profile.self.cycles-pp.memset_erms
      0.00            +0.1        0.06 ± 13%  perf-profile.self.cycles-pp.__ip_queue_xmit
      0.00            +0.1        0.06 ± 13%  perf-profile.self.cycles-pp.set_next_entity
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.__sk_mem_reduce_allocated
      0.00            +0.1        0.06 ± 13%  perf-profile.self.cycles-pp.__netif_receive_skb_core
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.fib_table_lookup
      0.00            +0.1        0.06 ± 26%  perf-profile.self.cycles-pp.nr_iowait_cpu
      0.03 ±101%      +0.1        0.09 ± 13%  perf-profile.self.cycles-pp.__softirqentry_text_start
      0.00            +0.1        0.07 ± 14%  perf-profile.self.cycles-pp.page_counter_try_charge
      0.00            +0.1        0.07 ± 14%  perf-profile.self.cycles-pp.refill_obj_stock
      0.00            +0.1        0.07 ± 19%  perf-profile.self.cycles-pp.apparmor_sk_clone_security
      0.00            +0.1        0.07 ± 14%  perf-profile.self.cycles-pp.__update_load_avg_cfs_rq
      0.05 ± 45%      +0.1        0.12 ± 24%  perf-profile.self.cycles-pp._raw_spin_unlock_irqrestore
      0.00            +0.1        0.07 ± 13%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.00            +0.1        0.07 ± 11%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.00            +0.1        0.07 ± 14%  perf-profile.self.cycles-pp.update_load_avg
      0.00            +0.1        0.07 ± 18%  perf-profile.self.cycles-pp.__alloc_skb
      0.00            +0.1        0.07 ± 14%  perf-profile.self.cycles-pp.__fget_light
      0.04 ± 44%      +0.1        0.12 ± 24%  perf-profile.self.cycles-pp.do_idle
      0.08 ± 14%      +0.1        0.16 ± 28%  perf-profile.self.cycles-pp.native_sched_clock
      0.00            +0.1        0.08 ± 18%  perf-profile.self.cycles-pp.___slab_alloc
      0.00            +0.1        0.08 ± 11%  perf-profile.self.cycles-pp.tcp_clean_rtx_queue
      0.00            +0.1        0.08 ± 10%  perf-profile.self.cycles-pp.__cgroup_bpf_run_filter_skb
      0.00            +0.1        0.08 ± 19%  perf-profile.self.cycles-pp.sk_alloc
      0.00            +0.1        0.08 ± 13%  perf-profile.self.cycles-pp.ip_route_output_key_hash_rcu
      0.00            +0.1        0.08 ± 14%  perf-profile.self.cycles-pp.ip_finish_output2
      0.00            +0.1        0.09 ± 10%  perf-profile.self.cycles-pp.sk_forced_mem_schedule
      0.00            +0.1        0.10 ± 14%  perf-profile.self.cycles-pp.skb_release_data
      0.00            +0.1        0.10 ± 13%  perf-profile.self.cycles-pp.__dev_queue_xmit
      0.00            +0.1        0.11 ± 12%  perf-profile.self.cycles-pp.tcp_ack
      0.00            +0.1        0.11 ± 22%  perf-profile.self.cycles-pp.update_rq_clock
      0.00            +0.1        0.12 ± 19%  perf-profile.self.cycles-pp.memcpy_erms
      0.00            +0.1        0.12 ± 15%  perf-profile.self.cycles-pp.poll_idle
      0.11 ± 12%      +0.1        0.24 ± 14%  perf-profile.self.cycles-pp.read_tsc
      0.00            +0.2        0.15 ± 13%  perf-profile.self.cycles-pp.__sched_text_start
      0.00            +0.2        0.15 ±  8%  perf-profile.self.cycles-pp.tcp_v4_rcv
      0.00            +0.2        0.15 ± 11%  perf-profile.self.cycles-pp.__slab_free
      0.00            +0.2        0.18 ± 15%  perf-profile.self.cycles-pp.__tcp_transmit_skb
      0.00            +0.2        0.18 ±  8%  perf-profile.self.cycles-pp.dst_release
      0.00            +0.2        0.20 ±  8%  perf-profile.self.cycles-pp.kmem_cache_alloc
      0.07 ± 20%      +0.2        0.32 ± 12%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.3        0.30 ±  8%  perf-profile.self.cycles-pp.kmem_cache_free
      0.00            +0.4        0.38 ± 11%  perf-profile.self.cycles-pp.__inet_lookup_established





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


Thanks,
Oliver Sang


--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.11.0-rc7-00144-gff0d41306d8c"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.11.0-rc7 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-15) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_LD_VERSION=235000000
CONFIG_CLANG_VERSION=0
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
# CONFIG_BPF_LSM is not set
CONFIG_BPF_SYSCALL=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
# CONFIG_BPF_PRELOAD is not set
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_PVHVM_GUEST=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
CONFIG_PERF_EVENTS_AMD_POWER=m
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_AMD_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
# CONFIG_X86_SGX is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
CONFIG_KVM_MMU_AUDIT=y
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_MQ_RDMA=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=19
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_SMC is not set
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_NETLABEL=y
# CONFIG_MPTCP is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
CONFIG_NF_LOG_NETDEV=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
CONFIG_NF_LOG_BRIDGE=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_GATE is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_MTKSDIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_BW is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_PM_QOS_KUNIT_TEST is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_KUNIT_DRIVER_PE_TEST=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_RDMA is not set
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_RDMA is not set
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
CONFIG_PVPANIC=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
# end of Misc devices

CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_MACSEC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_NET_VRF is not set
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# Distributed Switch Architecture drivers
#
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_NET_VENDOR_AURORA is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBE_IPSEC=y
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
# CONFIG_IGC is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
# CONFIG_LED_TRIGGER_PHY is not set
# CONFIG_FIXED_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# CONFIG_PCS_XPCS is not set
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_HYPERV_NET is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_BCM63XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
# CONFIG_TRACE_SINK is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set
CONFIG_NVRAM=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# CONFIG_PTP_1588_CLOCK_OCP is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_ALDERLAKE is not set
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_MOCKUP is not set
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_AMD_ENERGY is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_INTEL_PMT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_SHARP_DECODER is not set
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=m
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
CONFIG_IR_SIR=m
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_IR_TOY is not set
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
CONFIG_MEDIA_SUPPORT=m
# CONFIG_MEDIA_SUPPORT_FILTER is not set
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_PLATFORM_SUPPORT=y
CONFIG_MEDIA_TEST_SUPPORT=y
# end of Media device types

#
# Media core support
#
CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=m
# end of Media core support

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# end of Video4Linux options

#
# Media controller options
#
# CONFIG_MEDIA_CONTROLLER_DVB is not set
# end of Media controller options

#
# Digital TV options
#
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set
# end of Digital TV options

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
# CONFIG_SDR_PLATFORM_DRIVERS is not set

#
# MMC/SDIO DVB adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_TEST_DRIVERS is not set

#
# FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AD9389B is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# CONFIG_SDR_MAX2175 is not set
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# end of Miscellaneous helper chips

#
# Camera sensor devices
#
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M032 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T001 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# SPI helper chips
#
# CONFIG_VIDEO_GS1662 is not set
# end of SPI helper chips

#
# Media SPI Adapters
#
CONFIG_CXD2880_SPI_DRV=m
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MSI001=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_RTL2832_SDR=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_ZD1301_DEMOD=m
CONFIG_DVB_CXD2880=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
CONFIG_DVB_MN88443X=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBH29=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
CONFIG_DVB_HORUS3A=m
CONFIG_DVB_ASCOT2E=m
CONFIG_DVB_HELENE=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
CONFIG_DVB_SP2=m
# end of Customise DVB Frontends

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_I915_GVT_KVMGT=m
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
CONFIG_I2C_HID=m
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS3 is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_STUSB160X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_EFA is not set
# CONFIG_INFINIBAND_I40IW is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_USNIC is not set
# CONFIG_INFINIBAND_BNXT_RE is not set
# CONFIG_INFINIBAND_RDMAVT is not set
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_INFINIBAND_ISERT is not set
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
# CONFIG_INFINIBAND_OPA_VNIC is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_XILINX_ZYNQMP_DPDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
CONFIG_DCDBAS=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
# CONFIG_DELL_SMBIOS_SMM is not set
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_RBU=m
CONFIG_DELL_SMO8800=m
CONFIG_DELL_WMI=m
# CONFIG_DELL_WMI_SYSMAN is not set
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_AIO=m
CONFIG_DELL_WMI_LED=m
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WIRELESS=m
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_HID_EVENT=m
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_VBTN=m
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
CONFIG_INTEL_PMC_CORE=m
# CONFIG_INTEL_PMT_CLASS is not set
# CONFIG_INTEL_PMT_TELEMETRY is not set
# CONFIG_INTEL_PMT_CRASHLOG is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_HAVE_CLK=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_EXT4_KUNIT_TESTS=m
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_SECURITY_INFINIBAND is not set
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_APPARMOR_KUNIT_TEST is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
# CONFIG_IMA_ARCH_POLICY is not set
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
# CONFIG_PRIME_NUMBERS is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
CONFIG_DMA_COHERENT_POOL=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_PERNUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
CONFIG_RCU_SCALE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
CONFIG_KUNIT=y
# CONFIG_KUNIT_DEBUGFS is not set
CONFIG_KUNIT_TEST=m
CONFIG_KUNIT_EXAMPLE_TEST=m
# CONFIG_KUNIT_ALL_TESTS is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAULT_INJECTION_USERCOPY is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
CONFIG_TEST_BPF=m
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
# CONFIG_BITFIELD_KUNIT is not set
# CONFIG_RESOURCE_KUNIT_TEST is not set
CONFIG_SYSCTL_KUNIT_TEST=m
CONFIG_LIST_KUNIT_TEST=m
# CONFIG_LINEAR_RANGES_TEST is not set
# CONFIG_CMDLINE_KUNIT_TEST is not set
# CONFIG_BITS_TEST is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_LIVEPATCH is not set
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_HMM is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='stress-ng'
	export testcase='stress-ng'
	export category='benchmark'
	export nr_threads=96
	export testtime=60
	export job_origin='stress-ng-class-network.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-csl-2sp5'
	export tbox_group='lkp-csl-2sp5'
	export kconfig='x86_64-rhel-8.3'
	export submit_id='603efde9544203be299d26a5'
	export job_file='/lkp/jobs/scheduled/lkp-csl-2sp5/stress-ng-network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718-debian-10.4-x86_64-20200603.cgz-ff0d41306d-20210303-48681-4jar9w-3.yaml'
	export id='304e30b67beeacd9486bd4ecfb7b3b055faed5bb'
	export queuer_version='/lkp-src'
	export model='Cascade Lake'
	export nr_node=2
	export nr_cpu=96
	export memory='192G'
	export nr_hdd_partitions=1
	export nr_ssd_partitions=1
	export hdd_partitions='/dev/disk/by-id/ata-ST1000NM0011_Z1N2QGYK-part5'
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4204006P800RGN-part1'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/ata-ST1000NM0011_Z1N2QGYK-part3'
	export brand='Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz'
	export need_kconfig='CONFIG_BLK_DEV_SD
CONFIG_SCSI
CONFIG_BLOCK=y
CONFIG_SATA_AHCI
CONFIG_SATA_AHCI_PLATFORM
CONFIG_ATA
CONFIG_PCI=y
CONFIG_SECURITY_APPARMOR=y'
	export commit='ff0d41306d8c7b91c21707559ef67f13e55b3406'
	export need_kconfig_hw='CONFIG_I40E=y
CONFIG_SATA_AHCI'
	export ucode='0x5003006'
	export enqueue_time='2021-03-03 11:09:29 +0800'
	export _id='603efde9544203be299d26a5'
	export _rt='/result/stress-ng/network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718/lkp-csl-2sp5/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406'
	export user='lkp'
	export compiler='gcc-9'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='933a73780a7af28c7103e47768c091fcff88e6f7'
	export base_commit='f40ddce88593482919761f74910f42f4b84c004b'
	export branch='linux-review/Honglei-Wang/tcp-avoid-unnecessary-loop-if-even-ports-are-used-up/20210220-200541'
	export rootfs='debian-10.4-x86_64-20200603.cgz'
	export monitor_sha='70d6d718'
	export result_root='/result/stress-ng/network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718/lkp-csl-2sp5/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/3'
	export scheduler_version='/lkp/lkp/.src-20210302-150707'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-csl-2sp5/stress-ng-network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718-debian-10.4-x86_64-20200603.cgz-ff0d41306d-20210303-48681-4jar9w-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-8.3
branch=linux-review/Honglei-Wang/tcp-avoid-unnecessary-loop-if-even-ports-are-used-up/20210220-200541
commit=ff0d41306d8c7b91c21707559ef67f13e55b3406
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/vmlinuz-5.11.0-rc7-00144-gff0d41306d8c
max_uptime=2100
RESULT_ROOT=/result/stress-ng/network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718/lkp-csl-2sp5/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/3
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/modules.cgz'
	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20201211.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/stress-ng_20210105.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/stress-ng-x86_64-0.11-06_20210105.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/mpstat_20200714.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/perf_20201126.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/perf-x86_64-e71ba9452f0b-1_20210106.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/sar-x86_64-34c92ae-1_20200702.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20210222.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.11.0-07287-g933a73780a7a'
	export repeat_to=6
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/vmlinuz-5.11.0-rc7-00144-gff0d41306d8c'
	export dequeue_time='2021-03-03 11:10:30 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-csl-2sp5/stress-ng-network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718-debian-10.4-x86_64-20200603.cgz-ff0d41306d-20210303-48681-4jar9w-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_setup nr_hdd=1 $LKP_SRC/setup/disk

	run_setup $LKP_SRC/setup/cpufreq_governor 'performance'

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper uptime
	run_monitor $LKP_SRC/monitors/wrapper iostat
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-numastat
	run_monitor $LKP_SRC/monitors/wrapper numa-vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-meminfo
	run_monitor $LKP_SRC/monitors/wrapper proc-vmstat
	run_monitor $LKP_SRC/monitors/wrapper proc-stat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper slabinfo
	run_monitor $LKP_SRC/monitors/wrapper interrupts
	run_monitor $LKP_SRC/monitors/wrapper lock_stat
	run_monitor lite_mode=1 $LKP_SRC/monitors/wrapper perf-sched
	run_monitor $LKP_SRC/monitors/wrapper softirqs
	run_monitor $LKP_SRC/monitors/one-shot/wrapper bdi_dev_mapping
	run_monitor $LKP_SRC/monitors/wrapper diskstats
	run_monitor $LKP_SRC/monitors/wrapper nfsstat
	run_monitor $LKP_SRC/monitors/wrapper cpuidle
	run_monitor $LKP_SRC/monitors/wrapper cpufreq-stats
	run_monitor $LKP_SRC/monitors/wrapper sched_debug
	run_monitor $LKP_SRC/monitors/wrapper perf-stat
	run_monitor $LKP_SRC/monitors/wrapper mpstat
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper perf-profile
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test class='network' test='sockmany' $LKP_SRC/tests/wrapper stress-ng
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env class='network' test='sockmany' $LKP_SRC/stats/wrapper stress-ng
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper uptime
	$LKP_SRC/stats/wrapper iostat
	$LKP_SRC/stats/wrapper vmstat
	$LKP_SRC/stats/wrapper numa-numastat
	$LKP_SRC/stats/wrapper numa-vmstat
	$LKP_SRC/stats/wrapper numa-meminfo
	$LKP_SRC/stats/wrapper proc-vmstat
	$LKP_SRC/stats/wrapper meminfo
	$LKP_SRC/stats/wrapper slabinfo
	$LKP_SRC/stats/wrapper interrupts
	$LKP_SRC/stats/wrapper lock_stat
	env lite_mode=1 $LKP_SRC/stats/wrapper perf-sched
	$LKP_SRC/stats/wrapper softirqs
	$LKP_SRC/stats/wrapper diskstats
	$LKP_SRC/stats/wrapper nfsstat
	$LKP_SRC/stats/wrapper cpuidle
	$LKP_SRC/stats/wrapper sched_debug
	$LKP_SRC/stats/wrapper perf-stat
	$LKP_SRC/stats/wrapper mpstat
	$LKP_SRC/stats/wrapper perf-profile

	$LKP_SRC/stats/wrapper time stress-ng.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/stress-ng-class-network.yaml
suite: stress-ng
testcase: stress-ng
category: benchmark
nr_threads: 100%
disk: 1HDD
testtime: 60s
stress-ng:
  class: network
  test: sockmany
job_origin: stress-ng-class-network.yaml

#! queue options
queue_cmdline_keys:
- branch
- commit
- queue_at_least_once
queue: bisect
testbox: lkp-csl-2sp5
tbox_group: lkp-csl-2sp5
kconfig: x86_64-rhel-8.3
submit_id: 603eead5544203adbf4590b7
job_file: "/lkp/jobs/scheduled/lkp-csl-2sp5/stress-ng-network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718-debian-10.4-x86_64-20200603.cgz-ff0d41306d-20210303-44479-usoypp-0.yaml"
id: 736703c6f1b075012157cf8e26d8f515c96267ce
queuer_version: "/lkp-src"

#! hosts/lkp-csl-2sp5
model: Cascade Lake
nr_node: 2
nr_cpu: 96
memory: 192G
nr_hdd_partitions: 1
nr_ssd_partitions: 1
hdd_partitions: "/dev/disk/by-id/ata-ST1000NM0011_Z1N2QGYK-part5"
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4204006P800RGN-part1"
swap_partitions: 
rootfs_partition: "/dev/disk/by-id/ata-ST1000NM0011_Z1N2QGYK-part3"
brand: Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz

#! include/category/benchmark
kmsg: 
boot-time: 
uptime: 
iostat: 
heartbeat: 
vmstat: 
numa-numastat: 
numa-vmstat: 
numa-meminfo: 
proc-vmstat: 
proc-stat: 
meminfo: 
slabinfo: 
interrupts: 
lock_stat: 
perf-sched:
  lite_mode: 1
softirqs: 
bdi_dev_mapping: 
diskstats: 
nfsstat: 
cpuidle: 
cpufreq-stats: 
sched_debug: 
perf-stat: 
mpstat: 
perf-profile: 

#! include/category/ALL
cpufreq_governor: performance

#! include/disk/nr_hdd
need_kconfig:
- CONFIG_BLK_DEV_SD
- CONFIG_SCSI
- CONFIG_BLOCK=y
- CONFIG_SATA_AHCI
- CONFIG_SATA_AHCI_PLATFORM
- CONFIG_ATA
- CONFIG_PCI=y
- CONFIG_SECURITY_APPARMOR=y

#! include/stress-ng

#! include/queue/cyclic
commit: ff0d41306d8c7b91c21707559ef67f13e55b3406

#! include/testbox/lkp-csl-2sp5
need_kconfig_hw:
- CONFIG_I40E=y
- CONFIG_SATA_AHCI
ucode: '0x5003006'
enqueue_time: 2021-03-03 09:48:05.743709014 +08:00
_id: 603eead5544203adbf4590b7
_rt: "/result/stress-ng/network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718/lkp-csl-2sp5/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406"

#! schedule options
user: lkp
compiler: gcc-9
LKP_SERVER: internal-lkp-server
head_commit: 933a73780a7af28c7103e47768c091fcff88e6f7
base_commit: f40ddce88593482919761f74910f42f4b84c004b
branch: linux-devel/devel-hourly-20210222-083330
rootfs: debian-10.4-x86_64-20200603.cgz
monitor_sha: 70d6d718
result_root: "/result/stress-ng/network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718/lkp-csl-2sp5/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/0"
scheduler_version: "/lkp/lkp/.src-20210302-150707"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-csl-2sp5/stress-ng-network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718-debian-10.4-x86_64-20200603.cgz-ff0d41306d-20210303-44479-usoypp-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3
- branch=linux-devel/devel-hourly-20210222-083330
- commit=ff0d41306d8c7b91c21707559ef67f13e55b3406
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/vmlinuz-5.11.0-rc7-00144-gff0d41306d8c
- max_uptime=2100
- RESULT_ROOT=/result/stress-ng/network-performance-1HDD-100%-sockmany-60s-ucode=0x5003006-monitor=70d6d718/lkp-csl-2sp5/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/0
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/modules.cgz"
bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20201211.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/stress-ng_20210105.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/stress-ng-x86_64-0.11-06_20210105.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/mpstat_20200714.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/perf_20201126.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/perf-x86_64-e71ba9452f0b-1_20210106.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/sar-x86_64-34c92ae-1_20200702.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20210222.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /lkp/lkp/.src-20210226-170207/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 

#! runtime status
last_kernel: 5.11.0-rc7-00141-g17aff5389d4f
repeat_to: 3

#! user overrides
queue_at_least_once: 0
kernel: "/pkg/linux/x86_64-rhel-8.3/gcc-9/ff0d41306d8c7b91c21707559ef67f13e55b3406/vmlinuz-5.11.0-rc7-00144-gff0d41306d8c"
dequeue_time: 2021-03-03 09:48:54.994681337 +08:00

#! /lkp/lkp/.src-20210302-150707/include/site/inn
job_state: finished
loadavg: 49.55 17.62 6.29 1/855 4448
start_time: '1614736181'
end_time: '1614736244'
version: "/lkp/lkp/.src-20210302-150739:a043c691:e885c583e"

--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce


for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*
do
	online_file="$cpu_dir"/online
	[ -f "$online_file" ] && [ "$(cat "$online_file")" -eq 0 ] && continue

	file="$cpu_dir"/cpufreq/scaling_governor
	[ -f "$file" ] && echo "performance" > "$file"
done

 "stress-ng" "--timeout" "60" "--times" "--verify" "--metrics-brief" "--sockmany" "96"

--2hMgfIw2X+zgXrFs--
