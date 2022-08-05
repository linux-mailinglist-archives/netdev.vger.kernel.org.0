Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6786A58B2CD
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 01:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241876AbiHEXmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 19:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241875AbiHEXmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 19:42:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F13918E28
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 16:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659742923; x=1691278923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iG0E5pLkDX+tT8EnK90szbojwPJAAg29e97JpGRuzeA=;
  b=OJdi//ipQB/TylXESEw5/bRRUpoosi/0hyN5Bm8h/v09SxeF0q4Fkqqj
   ozeitFG2Pqzkg3S1msdAHygWHa+OjsydOKUJtcChnap1Xw8BaxP4M+tpU
   Z0P+RF5m7BLbR566u2gQ03ruDsMiHlbddJ44db4FKxt8+XmpEWAwcpn9+
   sK5l4kFBJbw+4hEhFwSDpfEWe9gqj5CtwLyOcKaWzn7OcBpuD+74+vrD9
   oSTfcagfJLjPUFdrXQ8VEw4r3L3g5CrOMH2ebEGEoa1pgVPY1u5S0EOBM
   vU1ewcxTrjyvQwSl/YPn4Es++9hkVcDHjwdMYQ/4vkksfCv4EeDqAljvC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289072931"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="289072931"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="931401648"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:02 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 1/6] mnlg: remove unnused mnlg_socket structure
Date:   Fri,  5 Aug 2022 16:41:50 -0700
Message-Id: <20220805234155.2878160-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
In-Reply-To: <20220805234155.2878160-1-jacob.e.keller@intel.com>
References: <20220805234155.2878160-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
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

Commit 62ff25e51bb6 ("devlink: Use generic socket helpers from library")
removed all of the users of struct mnlg_socket, but didn't remove the
structure itself. Fix that.

Fixes: 62ff25e51bb6 ("devlink: Use generic socket helpers from library")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/mnlg.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index e6d92742c150..b2e0b8c0f274 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -22,14 +22,6 @@
 #include "utils.h"
 #include "mnlg.h"
 
-struct mnlg_socket {
-	struct mnl_socket *nl;
-	char *buf;
-	uint32_t id;
-	uint8_t version;
-	unsigned int seq;
-};
-
 int mnlg_socket_send(struct mnlu_gen_socket *nlg, const struct nlmsghdr *nlh)
 {
 	return mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
-- 
2.37.1.208.ge72d93e88cb2

