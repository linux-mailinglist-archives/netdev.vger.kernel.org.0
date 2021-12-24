Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D1947EE21
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 11:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352379AbhLXKAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 05:00:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:18401 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352377AbhLXKAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Dec 2021 05:00:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640340019; x=1671876019;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Sn9zgDOv7uci6noFgnd4KAaBkeLNUIRege9DyPDdM2U=;
  b=gOvZFECYNSRh8eP6CnOr7/jOaLujh5a+R6d5jPzs2HtGE74gsau7AfPk
   9HSuN61trGVxZmCcEK1d1J6EESZRR8qk44wgmlgU85Xgm9Gs+3DhtD/EV
   unDY+9s9p61N0lHnxF9a4oDXzuG+95GzJ6GIyOkK8nRSREREpIaXd2h+h
   Bms+TV1OjQdsUIVUHUWG57ddOKTQFqAUZeU4HllMsbYeek8T0tdb/+4q0
   sYSHbt1He+sOX0vSIZey+vaGKE+0bGtnPxOwa6pLEtOSydOZPjjus2THg
   5d01sjisjICN4bfwl7eoAES8lITCnElcEQKVJafLn5pw5lPHXC7qQ1GII
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10207"; a="240760275"
X-IronPort-AV: E=Sophos;i="5.88,232,1635231600"; 
   d="scan'208";a="240760275"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2021 02:00:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,232,1635231600"; 
   d="scan'208";a="522397580"
Received: from jzhao8-mobl1.ccr.corp.intel.com (HELO mxinjiax-mobl1.ccr.corp.intel.com) ([10.255.28.232])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2021 02:00:16 -0800
From:   Ma Xinjian <xinjianx.ma@intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>,
        Ma Xinjian <xinjianx.ma@intel.com>
Subject: [PATCH] selftests: mptcp: Remove the deprecated config NFT_COUNTER
Date:   Fri, 24 Dec 2021 17:59:28 +0800
Message-Id: <20211224095928.60584-1-xinjianx.ma@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFT_COUNTER was removed since
390ad4295aa ("netfilter: nf_tables: make counter support built-in")
LKP/0Day will check if all configs listing under selftests are able to
be enabled properly.

For the missing configs, it will report something like:
LKP WARN miss config CONFIG_NFT_COUNTER= of net/mptcp/config

- it's not reasonable to keep the deprecated configs.
- configs under kselftests are recommended by corresponding tests.
So if some configs are missing, it will impact the testing results

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ma Xinjian <xinjianx.ma@intel.com>
---
 tools/testing/selftests/net/mptcp/config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
index 0faaccd21447..2b82628decb1 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -9,7 +9,6 @@ CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NETFILTER_NETLINK=m
 CONFIG_NF_TABLES=m
-CONFIG_NFT_COUNTER=m
 CONFIG_NFT_COMPAT=m
 CONFIG_NETFILTER_XTABLES=m
 CONFIG_NETFILTER_XT_MATCH_BPF=m
-- 
2.20.1

