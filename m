Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1304C05B4
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbiBWADp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiBWADo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:03:44 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D790DF5
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:03:18 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id c1so3606602pgk.11
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2Gz6V0zrUTlaB0brXAPvRrPgbkStaoyeek9H1aNQxlE=;
        b=OphNSxqIYEnPL96L/KigpVdzijs5HVegaCaiNpr1/qOg4DyEnLVM3H1rO+iC+ZQyKu
         qKrNr1gOVe1XqLaKVBCqEBpr1wi34YvHRpSvXAZuNDfTF3wNqsVxHuAodUB/x7+FL0PE
         TG8/OkUwUWGvdJx+0nm7pT7z4uCjmMsIsDfRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2Gz6V0zrUTlaB0brXAPvRrPgbkStaoyeek9H1aNQxlE=;
        b=Ghhjm1AVIJDn5B/XmQstpWqUAVfCFB6kljpTs/I2IEOLLEvZzf3weBNC8/FjTxLgfx
         +b1pxROFRbV7DIyb6Lyi5OFe9u2tB8uqpcSnds3FKzNH6SV/4JqUKKgDRKp4nKy8KLLe
         GvS/6oUcojmojkmj0eEOFER/HgSAGTrQ3JAZyWEKPn7ptpIO8N/s3D0PXawtaSFrNvey
         +AEEjMrgahz00/HHupE+y7Sk7Vs900grnBOh+yLn4I70tqz3CGQBDIvTZflUg7aVdJ4k
         OdOI3JrfAzNavmnk+H4uPWVujrslcKfcuV8qIWN/q9DjY1dht5NFfz0oLEr3A5XHY7Hq
         Rl4A==
X-Gm-Message-State: AOAM530jdyiG5lmoaPlgz12QQWTczBRtSNblIPWSR5acLLS3/zWM7Ek7
        skdgpuWK1xTQE52qNI8fu7e+jGzgXZ/tE9wUTIBkEHPhtRNIfHe2Z1GZtibrVNPNqzmWK5r1iPW
        lyAgUtlqR1cR0F28iJ3GjLDVk8uf+oEc3MrCNjNs9R5ID1jFQditsKDjNm/hxDGZEveYh
X-Google-Smtp-Source: ABdhPJwG48KWgCIkZRxY1McXiXX6f1wyEpr3AtDMbHOBO4UF/F/fIFiIl3XRj3TznWdPK4EGgLddYw==
X-Received: by 2002:a63:d348:0:b0:342:3bc2:9b29 with SMTP id u8-20020a63d348000000b003423bc29b29mr21296236pgi.584.1645574597062;
        Tue, 22 Feb 2022 16:03:17 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id i3sm22460027pgq.65.2022.02.22.16.03.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Feb 2022 16:03:16 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v6 0/2] page_pool: Add page pool stats
Date:   Tue, 22 Feb 2022 16:00:22 -0800
Message-Id: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Welcome to v6.

As a reminder: this patch series adds basic per-cpu per-page pool stats
tracking, if enabled at compile time. An API is provided,
page_pool_get_stats, which fills a caller provided page_pool_stats struct
with the totaled stats for the specified page pool. The intention is that
drivers can call this API, if they choose, and export these statistics to
users via ethtool/debugfs/etc. Users can then examine and monitor this
information to get a better sense of how their RX queues, page pools, and
the kernel page allocator are interacting with each other.

This revision contains a single change from v5 based on Jesper's feedback:
the struct page_pool_stats pointer in struct page_pool is now marked as
____cacheline_aligned_in_smp. Its position is unchanged: it remains the
last field in the page_pool struct, but is now located on its own
cache-line. Other locations are possible, such as: sharing the cache-line
with xdp_mem_id, but I didn't hear back on placement preference so I went
with a new cache-line for the page_pool_stats pointer.

With this series applied, but with stats disabled, pahole reports the
following data about struct page_pool:

/* size: 1600, cachelines: 25, members: 15 */
/* sum members: 1436, holes: 2, sum holes: 116 */
/* padding: 48 */

With this series applied, but with stats enabled, pahole shows that the
stats pointer is on its own cache-line:

/* --- cacheline 25 boundary (1600 bytes) --- */
struct page_pool_stats *   stats;                /*  1600     8 */

And, the page_pool struct has grown in size slightly (as expected):

/* size: 1664, cachelines: 26, members: 16 */
/* sum members: 1444, holes: 3, sum holes: 164 */
/* padding: 56 */

I re-ran bench_page_pool_simple and bench_page_pool_cross_cpu with the same
arguments as previous revisions (see below). I also ran
bench_page_pool_cross_cpu a second time, but with 8 returning cpus. Links
to the raw output with this series applied with stats off [1] and stats on
[2] are included for examination. Note that the benchmarks were slightly
modified [3] to produce more verbose output, but no functional changes were
made.

Back to back runs of the same benchmark reveal variability in the results.
The runs below show that the kernel with the extra code enabled is slightly
faster than with a kernel built with this code disabled. Re-running the
benchmarks again on each kernel can (and has) shown different results;
including results which show that disabling stats is slightly faster.

This code is defaulted to disabled unless explicitly enabled
by a user in their kernel configuration. Any additional resource
consumption this code generates is limited to users who have explicitly
opted-in.

Jesper: my apologies if I'm missing something obvious with running the
benchmarks, but please let me know if there is anything else you'd like me
to provide. Also, feel free to let me know if you think this code is not
desired at all -- in which case, I'll stop sending updated revisions :)

Test system:
	- 2x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
	- 2 NUMA zones, with 18 cores per zone and 2 threads per core

bench_page_pool_simple results, loops=200000000
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

for_loop			0	0.335		0	0.336
atomic_inc 			13	6.051		13	6.071
lock				31	13.938		32	13.985

no-softirq-page_pool01		75	32.856		74	32.305
no-softirq-page_pool02		75	32.894		74	32.343
no-softirq-page_pool03		107	46.651		107	46.710

tasklet_page_pool01_fast_path	14	6.386		13	5.829
tasklet_page_pool02_ptr_ring	41	17.998		39	17.390
tasklet_page_pool03_slow	107	47.040		107	46.830

bench_page_pool_cross_cpu results, loops=20000000 returning_cpus=4:
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

page_pool_cross_cpu CPU(0)	4050	1765.133	4090	1782.700
page_pool_cross_cpu CPU(1)	4043	1762.174	4090	1782.636
page_pool_cross_cpu CPU(2)	4050	1765.171	4090	1782.762
page_pool_cross_cpu CPU(3)	4050	1765.074	4087	1781.393
page_pool_cross_cpu CPU(4)	1012	441.293		1022	445.691

page_pool_cross_cpu average	3441	-		3475	-

bench_page_pool_cross_cpu results, loops=20000000 returning_cpus=8:
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

page_pool_cross_cpu CPU(0)	7458	3250.426	7531	3282.485
page_pool_cross_cpu CPU(1)	7473	3256.957	7531	3282.409
page_pool_cross_cpu CPU(2)	7459	3251.038	7532	3282.635
page_pool_cross_cpu CPU(3)	7473	3257.048	7530	3282.006
page_pool_cross_cpu CPU(4)	7460	3251.341	7531	3282.372
page_pool_cross_cpu CPU(5)	7474	3257.719	7532	3282.831
page_pool_cross_cpu CPU(6)	7462	3252.377	7531	3282.369
page_pool_cross_cpu CPU(7)	7478	3259.245	7532	3282.799
page_pool_cross_cpu CPU(8)	934	407.406		941	410.354

page_pool_cross_cpu average	6741	-		6799	-

Thanks.

[1]:
https://gist.githubusercontent.com/jdamato-fsly/c86d9bb4144fa12dbab41126772b167e/raw/d1fcf995bbc3f44d1362233fab1c18365922c47f/stats_disabled
[2]:
https://gist.githubusercontent.com/jdamato-fsly/c86d9bb4144fa12dbab41126772b167e/raw/d1fcf995bbc3f44d1362233fab1c18365922c47f/stats_enabled
[3]:
https://gist.githubusercontent.com/jdamato-fsly/26ec72238522074515d47011434d054f/raw/0774a02d29e33cd5876dbe240e23c7a118b743da/benchmark.patch

v5 -> v6:
	- Per cpu page_pool_stats struct pointer is now marked as
	  ____cacheline_aligned_in_smp. Placement of the field in the
	  struct is unchanged; it is the last field.

v4 -> v5:
	- Fixed the description of the kernel option in Kconfig.
	- Squashed commits 1-10 from v4 into a single commit for easier
	  review.
	- Changed the comment style of the comment for
	  the this_cpu_inc_alloc_stat macro.
	- Changed the return type of page_pool_get_stats from struct
	  page_pool_stat * to bool.

v3 -> v4:
	- Restructured stats to be per-cpu per-pool.
	- Global stats and proc file were removed.
	- Exposed an API (page_pool_get_stats) for batching the pool stats.

v2 -> v3:
	- patch 8/10 ("Add stat tracking cache refill") fixed placement of
	  counter increment.
	- patch 10/10 ("net-procfs: Show page pool stats in proc") updated:
		- fix unused label warning from kernel test robot,
		- fixed page_pool_seq_show to only display the refill stat
		  once,
		- added a remove_proc_entry for page_pool_stat to
		  dev_proc_net_exit.

v1 -> v2:
	- A new kernel config option has been added, which defaults to N,
	   preventing this code from being compiled in by default
	- The stats structure has been converted to a per-cpu structure
	- The stats are now exported via proc (/proc/net/page_pool_stat)
Joe Damato (2):
  page_pool: Add page_pool stats
  page_pool: Add function to batch and return stats

 include/net/page_pool.h | 27 +++++++++++++++++++++
 net/Kconfig             | 13 +++++++++++
 net/core/page_pool.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 98 insertions(+), 4 deletions(-)

-- 
2.7.4

