Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF59607163
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 09:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJUHsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 03:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJUHr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 03:47:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F360B248CA2
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 00:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666338471; x=1697874471;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5BWoHIinJTuK3IX6A1mBFMWqk7BdIXih/23wdyR2uCY=;
  b=H6JgxclgeDw31nbsidBtc29MjdKEUNCzfitT8Q1AxjW0g6aOd7BJXdE8
   HBqvXAkpnFRJHMMFRHImrjavnQ3IzuEE+Ouv070N7TqcCAUm/QtO4bnAB
   ohPURtawpFzKXXNdTcRkuooJEEK6tsprHgBebz2F7ROzxkPfcYuo9Q3jw
   9kxQ/XuHVfG/U/97KhOHYwuBK+Qakaozzy7L3JCTP7OTddUu9xM36FoEA
   UuOjkSA2Uxd82XMb/iuS8nJ1E0KTi9MqP2+T/bVwliZS9dwgpGWI5aOtZ
   uCcaVIrLdnG9hUcO8EIXW1xFfeKDOuLYTU561KZxdrgd8dp5i94L57AF6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="287343453"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="287343453"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 00:47:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="719575220"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="719575220"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Oct 2022 00:47:50 -0700
Subject: [net-next PATCH v3 3/3] Documentation: networking: TC queue based
 filtering
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Fri, 21 Oct 2022 00:58:50 -0700
Message-ID: <166633913071.52141.6608544387632242533.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tc-queue-filters.rst with notes on TC filters for
selecting a set of queues and/or a queue.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 Documentation/networking/index.rst            |    1 +
 Documentation/networking/tc-queue-filters.rst |   37 +++++++++++++++++++++++++
 2 files changed, 38 insertions(+)
 create mode 100644 Documentation/networking/tc-queue-filters.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 16a153bcc5fe..4f2d1f682a18 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -104,6 +104,7 @@ Contents:
    switchdev
    sysfs-tagging
    tc-actions-env-rules
+   tc-queue-filters
    tcp-thin
    team
    timestamping
diff --git a/Documentation/networking/tc-queue-filters.rst b/Documentation/networking/tc-queue-filters.rst
new file mode 100644
index 000000000000..6b417092276f
--- /dev/null
+++ b/Documentation/networking/tc-queue-filters.rst
@@ -0,0 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+TC queue based filtering
+=========================
+
+TC can be used for directing traffic to either a set of queues or
+to a single queue on both the transmit and receive side.
+
+On the transmit side:
+
+1) TC filter directing traffic to a set of queues is achieved
+   using the action skbedit priority for Tx priority selection,
+   the priority maps to a traffic class (set of queues) when
+   the queue-sets are configured using mqprio.
+
+2) TC filter directs traffic to a transmit queue with the action
+   skbedit queue_mapping $tx_qid. The action skbedit queue_mapping
+   for transmit queue is executed in software only and cannot be
+   offloaded.
+
+Likewise, on the receive side, the two filters for selecting set of
+queues and/or a single queue are supported as below:
+
+1) TC flower filter directs incoming traffic to a set of queues using
+   the 'hw_tc' option.
+   hw_tc $TCID - Specify a hardware traffic class to pass matching
+   packets on to. TCID is in the range 0 through 15.
+
+2) TC filter with action skbedit queue_mapping $rx_qid selects a
+   receive queue. The action skbedit queue_mapping for receive queue
+   is supported only in hardware. Multiple filters may compete in
+   the hardware for queue selection. In such case, the hardware
+   pipeline resolves conflicts based on priority. On Intel E810
+   devices, TC filter directing traffic to a queue have higher
+   priority over flow director filter assigning a queue. The hash
+   filter has lowest priority.

