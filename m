Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251AB23F463
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgHGV3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHGV3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:29:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C71C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 14:29:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d26so4357941yba.20
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2Epbq3zd+57RV+c5a3tR14Y8EZnVI9kXEnkZqe3uwAA=;
        b=W4JL+gkPyvYfdfwk6ydvYnTnosTt4pvJ7tL6kLXU+WUTb6rftiPRdMePYrbZabnBTD
         +ISkyoN5LHfFW3Z6CwOyFJX0djyFH2uNFR35eVqx4/Y/Qi47Gs+4ceJ48kzO4YJo7Gux
         deL3jBPiYpM3y+EqgYB+N5By3UQ0F55MxwqLYjl/Awc3revSFDBw4yahIaJqx+SGgXOg
         vquf/jHyOotjcNWthbAW3uUC7wpRsVMjWeVPbcdTZppHRp2GfKlamKeJ1xDUvV2FIBM8
         PYK8Tlv+XXASS++2PpJDsFc0cd4D+NzUwhVxDOepLelhsNX9Zlr+hx87Y8ZZOIZF3C1g
         i+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2Epbq3zd+57RV+c5a3tR14Y8EZnVI9kXEnkZqe3uwAA=;
        b=RLFNkQhVoSXBf36QFB9hbXWdhaWsogERw1lJue3I/yAqm/3dftQQhCtmmIWq/5Hznb
         1pcJqAwxKOp/qnAZ8VUFgID87TjKQ82LcHEXCwb5RWPrSWGia04kVlfdAIxVc/IxGoO9
         Dl0Wk7Yrdct4OrLD4Mt16zBU0fKUONCPbu2RWPDycfbm7UxP5mMAI2LpuL41QIWka+9F
         EHWZKrgu+zm7TFronAbyBlLPkufMrJg3GotmkuqEcVPoXSaCmM3QVId8m3uK8xVz4BNf
         85yHoaLbAASMhwkAbX6flg7zGk8GUOezjVkATXV/Ltq/2L2NgQhtZwzDLeftmFDkyXpU
         D4+g==
X-Gm-Message-State: AOAM530ujZlvzUbXPIVnXF4SnbtqfCiv2GYa/bzeRsHDIRWjDcGnch7w
        tQOaCGMOfhzeL9mani4bE6H2mMwu23E=
X-Google-Smtp-Source: ABdhPJwpYiGEXI6N/WmSc1sNe+MKpn0dLtZLyveRHzfSP1IyYqPUCszF3totD/1mcAxmqwETOm6E5qQykQ85
X-Received: by 2002:a25:d709:: with SMTP id o9mr21697023ybg.392.1596835774334;
 Fri, 07 Aug 2020 14:29:34 -0700 (PDT)
Date:   Fri,  7 Aug 2020 14:29:09 -0700
Message-Id: <20200807212916.2883031-1-jwadams@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 0/7] metricfs metric file system and examples
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[resending to widen the CC lists per rdunlap@infradead.org's suggestion
original posting to lkml here: https://lkml.org/lkml/2020/8/5/1009]

To try to restart the discussion of kernel statistics started by the
statsfs patchsets (https://lkml.org/lkml/2020/5/26/332), I wanted
to share the following set of patches which are Google's 'metricfs'
implementation and some example uses.  Google has been using metricfs
internally since 2012 as a way to export various statistics to our
telemetry systems (similar to OpenTelemetry), and we have over 200
statistics exported on a typical machine.

These patches have been cleaned up and modernized v.s. the versions
in production; I've included notes under the fold in the patches.
They're based on v5.8-rc6.

The statistics live under debugfs, in a tree rooted at:

	/sys/kernel/debug/metricfs

Each metric is a directory, with four files in it.  For example, the '
core/metricfs: Create metricfs, standardized files under debugfs.' patch
includes a simple 'metricfs_presence' metric, whose files look like:
/sys/kernel/debug/metricfs:
 metricfs_presence/annotations
  DESCRIPTION A\ basic\ presence\ metric.
 metricfs_presence/fields
  value
  int
 metricfs_presence/values
  1
 metricfs_presence/version
  1

(The "version" field always says '1', and is kind of vestigial)

An example of a more complicated stat is the networking stats.
For example, the tx_bytes stat looks like:

net/dev/stats/tx_bytes/annotations
  DESCRIPTION net\ device\ transmited\ bytes\ count
  CUMULATIVE
net/dev/stats/tx_bytes/fields
  interface value
  str int
net/dev/stats/tx_bytes/values
  lo 4394430608
  eth0 33353183843
  eth1 16228847091
net/dev/stats/tx_bytes/version
  1

The per-cpu statistics show up in the schedulat stat info and x86
IRQ counts.  For example:

stat/user/annotations
  DESCRIPTION time\ in\ user\ mode\ (nsec)
  CUMULATIVE
stat/user/fields
  cpu value
  int int
stat/user/values
  0 1183486517734
  1 1038284237228
  ...
stat/user/version
  1

The full set of example metrics I've included are:

core/metricfs: Create metricfs, standardized files under debugfs.
  metricfs_presence
core/metricfs: metric for kernel warnings
  warnings/values
core/metricfs: expose scheduler stat information through metricfs
  stat/*
net-metricfs: Export /proc/net/dev via metricfs.
  net/dev/stats/[tr]x_*
core/metricfs: expose x86-specific irq information through metricfs
  irq_x86/*

The general approach is called out in kernel/metricfs.c:

The kernel provides:
  - A description of the metric
  - The subsystem for the metric (NULL is ok)
  - Type information about the metric, and
  - A callback function which supplies metric values.

Limitations:
  - "values" files are at MOST 64K. We truncate the file at that point.
  - The list of fields and types is at most 1K.
  - Metrics may have at most 2 fields.

Best Practices:
  - Emit the most important data first! Once the 64K per-metric buffer
    is full, the emit* functions won't do anything.
  - In userspace, open(), read(), and close() the file quickly! The kernel
    allocation for the metric is alive as long as the file is open. This
    permits users to seek around the contents of the file, while
    permitting an atomic view of the data.

Note that since the callbacks are called and the data is generated at
file open() time, the relative consistency is only between members of
a given metric; the rx_bytes stat for every network interface will
be read at almost the same time, but if you want to get rx_bytes
and rx_packets, there could be a bunch of slew between the two file
opens.  (So this doesn't entirely address Andrew Lunn's comments in
https://lkml.org/lkml/2020/5/26/490)

This also doesn't address one of the basic parts of the statsfs work:
moving the statistics out of debugfs to avoid lockdown interactions.

Google has found a lot of value in having a generic interface for adding
these kinds of statistics with reasonably low overhead (reading them
is O(number of statistics), not number of objects in each statistic).
There are definitely warts in the interface, but does the basic approach
make sense to folks?

Thanks,
- Jonathan

Jonathan Adams (5):
  core/metricfs: add support for percpu metricfs files
  core/metricfs: metric for kernel warnings
  core/metricfs: expose softirq information through metricfs
  core/metricfs: expose scheduler stat information through metricfs
  core/metricfs: expose x86-specific irq information through metricfs

Justin TerAvest (1):
  core/metricfs: Create metricfs, standardized files under debugfs.

Laurent Chavey (1):
  net-metricfs: Export /proc/net/dev via metricfs.

 arch/x86/kernel/irq.c      |  80 ++++
 fs/proc/stat.c             |  57 +++
 include/linux/metricfs.h   | 131 +++++++
 kernel/Makefile            |   2 +
 kernel/metricfs.c          | 775 +++++++++++++++++++++++++++++++++++++
 kernel/metricfs_examples.c | 151 ++++++++
 kernel/panic.c             | 131 +++++++
 kernel/softirq.c           |  45 +++
 lib/Kconfig.debug          |  18 +
 net/core/Makefile          |   1 +
 net/core/net_metricfs.c    | 194 ++++++++++
 11 files changed, 1585 insertions(+)
 create mode 100644 include/linux/metricfs.h
 create mode 100644 kernel/metricfs.c
 create mode 100644 kernel/metricfs_examples.c
 create mode 100644 net/core/net_metricfs.c

-- 
2.28.0.236.gb10cc79966-goog

