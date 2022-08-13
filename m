Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BAD591CEC
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 00:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbiHMWAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 18:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240250AbiHMWAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 18:00:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2890BF70;
        Sat, 13 Aug 2022 15:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660428043; x=1691964043;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J2stkkYmPik2bQMds1PPTKQFWYY4K6w3/+pjsawBn4I=;
  b=czriY2QSJtsHs+0YJIn5ie4MEylQAeO1kW/kS7jZoyutko3tg5lYKLsh
   U8uwSotSnGfPl2vJQS7mXtH4oMFazwVlS/Xc7jXjm/W0R2M8xn4DxBnHw
   kIWTBYyV1rhIi/CUgFr62xfLVN+CqYCowKo4VrUWdTiHHWU6njZrRlHxQ
   kaTEKulZ63EuSu4qn9pNqf4xP0sdTWK/u2NAugMb9FbtEUSj30NAXgimh
   5qPunzQISbEjtHhAHANiwq1Jl2HcUvhbN24qdPsixdN+lNMnl7ALLrf3m
   ZKPstDNZJppuxJNs4K8cjvcKaPPyhu1ezSatsWfsJc/83jLR0F08xO9ot
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="293049446"
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="293049446"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2022 15:00:42 -0700
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="635047705"
Received: from tsaiyinl-mobl1.amr.corp.intel.com (HELO localhost) ([10.209.125.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2022 15:00:40 -0700
From:   ira.weiny@intel.com
To:     Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
        loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, x86@kernel.org,
        linux-xtensa@linux-xtensa.org, keyrings@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-edac@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        dri-devel@lists.freedesktop.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, iommu@lists.linux.dev,
        bpf@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] checkpatch: Add kmap and kmap_atomic to the deprecated list
Date:   Sat, 13 Aug 2022 15:00:34 -0700
Message-Id: <20220813220034.806698-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead
as mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when
the kmap’s pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

kmap_local_page() is safe from any context and is therefore redundant
with kmap_atomic() with the exception of any pagefault or preemption
disable requirements.  However, using kmap_atomic() for these side
effects makes the code less clear.  So any requirement for pagefault or
preemption disable should be made explicitly.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts).
It is faster than kmap() in kernels with HIGHMEM enabled. Furthermore,
the tasks can be preempted and, when they are scheduled to run again,
the kernel virtual addresses are restored.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Suggested by credits.
	Thomas: Idea to keep from growing more kmap/kmap_atomic calls.
	Fabio: Stole some of his boiler plate commit message.

Notes on tree-wide conversions:

I've cc'ed mailing lists for subsystems which currently contains either kmap()
or kmap_atomic() calls.  As some of you already know Fabio and I have been
working through converting kmap() calls to kmap_local_page().  But there is a
lot more work to be done.  Help from the community is always welcome,
especially with kmap_atomic() conversions.  To keep from stepping on each
others toes I've created a spreadsheet of the current calls[1].  Please let me
or Fabio know if you plan on tacking one of the conversions so we can mark it
off the list.

[1] https://docs.google.com/spreadsheets/d/1i_ckZ10p90bH_CkxD2bYNi05S2Qz84E2OFPv8zq__0w/edit#gid=1679714357

---
 scripts/checkpatch.pl | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 79e759aac543..9ff219e0a9d5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -807,6 +807,8 @@ our %deprecated_apis = (
 	"rcu_barrier_sched"			=> "rcu_barrier",
 	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
 	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
+	"kmap"					=> "kmap_local_page",
+	"kmap_atomic"				=> "kmap_local_page",
 );
 
 #Create a search pattern for all these strings to speed up a loop below

base-commit: 4a9350597aff50bbd0f4b80ccf49d2e02d1111f5
-- 
2.35.3

