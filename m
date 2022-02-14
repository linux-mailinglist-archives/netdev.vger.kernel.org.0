Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBB24B5B2C
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiBNUow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:44:52 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiBNUou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:44:50 -0500
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C324E1B71A0
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:41:18 -0800 (PST)
Received: by mail-qv1-f53.google.com with SMTP id o5so15811979qvm.3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=uKmZZqOw+GSEfunj2juTuGQsqmZiYNUgvKSjO734aX0=;
        b=lT+klE0OqqnkS3DJ+yBqoFPHLZBKEtiZjrhOuotT+rTqg+fGHlOMJPiAty99+MhQhs
         dcscvzVn3DxeboziRvDpqh1vATLo+e8jiUn54qlvJgyH4H7iCagh0eg7piX5mU9RXHID
         8M17FZC0VUEVh0LSFejxQanLNgK1CK3eeTJSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uKmZZqOw+GSEfunj2juTuGQsqmZiYNUgvKSjO734aX0=;
        b=Qj5S7vx3wCNdjZBfE5E6jIBgGTgPwrJLJEbJ8FjumhJ/9nf/UoaMsmUFmeR10jARtX
         +3eVftaQQ01hb8wrJtyX4IA3b3Ubm3DSZFPWoSvbgLVDiYAU2zPcsPWC3gJzll5vxZg4
         k899XUyfBptsVq4Q+e5N1A75c2GYZ0Ih29vo1c4zFXpo6wbSZbR1+Ol/UFZrZgvxUZiu
         v7eeYvAhzDz7djJoOBx2ZDCvzA15RtLPwEHfjJeH5vP62CfY/PleVDNhpVnOwNbgCEGv
         fq0APNT071TNrQgXuwwd2aJjMsFx2CMAp8hvuSagaOFI4LX6unWQMNZuHfON6PZJU4i2
         h7mg==
X-Gm-Message-State: AOAM530p6rxlKfNxiPB0FvIo3WcJ56b+vLACZbiss28yR9Rf+2Jfs5Cj
        QandEYV4qYqemhpyns6Xd0FniEbxHsehTZdbFxNAoIrYdVPlhYPb+UIU1EhPt2TBgMVHfVB42ko
        3ZgxJmGx+546ZaQ0YLqVXrt/fHEjS6+cH/7aBg/kJaLVPBj6NXO8rcr4v0GgWGoH7iOBW
X-Google-Smtp-Source: ABdhPJx3Bzb2hroD3Xzs86DJ2F9I8k9+/vJdT7IIDWuAOaQ1FGM2GVA0+YU2yp1+e0Kizbvy/oEoIA==
X-Received: by 2002:a17:903:2cf:: with SMTP id s15mr648795plk.150.1644869013968;
        Mon, 14 Feb 2022 12:03:33 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a38sm25010916pfx.121.2022.02.14.12.03.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Feb 2022 12:03:33 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v5 0/2] page_pool: Add page_pool stat counters
Date:   Mon, 14 Feb 2022 12:02:27 -0800
Message-Id: <1644868949-24506-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Welcome to v5.

This revision contains some minor changes as suggested by Ilias (summarized
below). These changes do not impact performance, so I've copied the
performance results from v4 along with the note about my thoughts on the
API I've exposed for use by drivers.

Since v4, this code exposes a single API: page_pool_get_stats which fills
in a caller provided struct page_pool_stats with the summed per-cpu stats
for the specified pool. The intention is that drivers will use this API to
access pool stats so that they can be exposed to the user via ethtool,
debugfs, etc. I have modified a driver to use this API. If this v5 is
accepted, I will submit the driver changes in a follow-up to the
appropriate list.

I chose this design of filling in a struct because pulling struct
page_pool_stats into page_pool.c would require exposing a large number of
APIs for accessing individual field values. The obvious downside of this
is that changing the struct fields could break driver code. I don't have a
strong sense for what the page_pool maintainers would prefer, so I chose
the simplest option.

I re-ran the benchmarks using a larger number of loops and cpus, as
documented below. I've summarized the results below; links to the raw
output with this series applied with stats off [1] and stats on [2] are
included for examination.

Test system:
	- 2x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
	- 2 NUMA zones, with 18 cores per zone and 2 threads per core

bench_page_pool_simple results, loops=200000000
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

for_loop			0	0.335		0	0.336
atomic_inc 			14	6.209		13	6.027
lock				31	13.571		31	13.935

no-softirq-page_pool01		70	30.783		68	29.959
no-softirq-page_pool02		73	32.124		72	31.412
no-softirq-page_pool03		112	49.060		108	47.373

tasklet_page_pool01_fast_path	14	6.413		13	5.833
tasklet_page_pool02_ptr_ring	41	17.939		39	17.370
tasklet_page_pool03_slow	110	48.179		108	47.173

bench_page_pool_cross_cpu results, loops=20000000 returning_cpus=4:
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

page_pool_cross_cpu CPU(0)	4101	1787.639	3990	1739.178
page_pool_cross_cpu CPU(1)	4107	1790.281	3987	1737.756
page_pool_cross_cpu CPU(2)	4102	1787.777	3991	1739.731
page_pool_cross_cpu CPU(3)	4108	1790.455	3991	1739.703
page_pool_cross_cpu CPU(4)	1027	447.614		997	434.933

page_pool_cross_cpu average	3489	-		3391	-

Thanks.

[1]: https://gist.githubusercontent.com/jdamato-fsly/343814d33ed75372e98782b796b607a4/raw/9f440a0b38f3eff37b76b914934620625172a0f4/v4%2520with%2520stats%2520off
[2]: https://gist.githubusercontent.com/jdamato-fsly/343814d33ed75372e98782b796b607a4/raw/9f440a0b38f3eff37b76b914934620625172a0f4/v4%2520with%2520stats%2520on

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
  page_pool: Add page_pool stat counters
  page_pool: Add function to batch and return stats

 include/net/page_pool.h | 27 +++++++++++++++++++++
 net/Kconfig             | 13 +++++++++++
 net/core/page_pool.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 98 insertions(+), 4 deletions(-)

-- 
2.7.4

