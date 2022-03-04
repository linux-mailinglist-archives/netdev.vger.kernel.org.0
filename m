Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AB14CDE3B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiCDUDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiCDUD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:03:26 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA3B28D7B1
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 12:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424008; x=1677960008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7kC064xb6BMbDim0pmnLeLvVczZMRtariLgOphzx/OI=;
  b=Rv/ocFmJkUKMFrKgs9Nu4xThQtuq37OGrqiBH5owS6z5ojBb+x+DwlbP
   BycE2jY/dyXIAYvMwho+OcfRkWAwwvAlGQuUevSQH3SnRzw+xLyFosouB
   rucpz2+lTO+a0Q9+jo0hvQds2oM16OC/309d1a1vqdjlZSugBOuENzQfR
   BCVSta7XkNL/KNMgOS1vgOlFyXs1EGfW2VwHSk1/zo5DQRa8jt5ArewDH
   ykIccDbg2LVEknfUO2c9zZ87TRcigYnGkZRGRnEi6QiJI00tDWD6/RZij
   huTbTW+nn2DO1S6p9Tn1a/UqXPQWwwo96jZKy4JAV0Z1yvIHIFzw0K7pi
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981343"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981343"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340794"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/11] selftests: mptcp: update output info of chk_rm_nr
Date:   Fri,  4 Mar 2022 11:36:36 -0800
Message-Id: <20220304193636.219315-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
References: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch updated the output info of chk_rm_nr. Renamed 'sf' to 'rmsf',
which means 'remove subflow'. Added the display of whether the inverted
namespaces has been used to check the mib counters.

The new output looks like this:

 002 remove multiple subflows          syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       rm [ ok ] - rmsf  [ ok ]
 003 remove single address             syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       add[ ok ] - echo  [ ok ]
                                       rm [ ok ] - rmsf  [ ok ]   invert

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 2912289d63f4..45c6e5f06916 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1153,15 +1153,14 @@ chk_rm_nr()
 	local invert=${3:-""}
 	local count
 	local dump_stats
-	local addr_ns
-	local subflow_ns
+	local addr_ns=$ns1
+	local subflow_ns=$ns2
+	local extra_msg=""
 
-	if [ -z $invert ]; then
-		addr_ns=$ns1
-		subflow_ns=$ns2
-	elif [ $invert = "invert" ]; then
+	if [[ $invert = "invert" ]]; then
 		addr_ns=$ns2
 		subflow_ns=$ns1
+		extra_msg="   invert"
 	fi
 
 	printf "%-${nr_blank}s %s" " " "rm "
@@ -1175,7 +1174,7 @@ chk_rm_nr()
 		echo -n "[ ok ]"
 	fi
 
-	echo -n " - sf    "
+	echo -n " - rmsf  "
 	count=`ip netns exec $subflow_ns nstat -as | grep MPTcpExtRmSubflow | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$rm_subflow_nr" ]; then
@@ -1183,10 +1182,12 @@ chk_rm_nr()
 		ret=1
 		dump_stats=1
 	else
-		echo "[ ok ]"
+		echo -n "[ ok ]"
 	fi
 
 	[ "${dump_stats}" = 1 ] && dump_stats
+
+	echo "$extra_msg"
 }
 
 chk_prio_nr()
-- 
2.35.1

