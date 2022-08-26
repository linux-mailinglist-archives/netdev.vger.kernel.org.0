Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4155A2E22
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiHZSRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiHZSRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:17:50 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFEFD21C0
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 11:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661537870; x=1693073870;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VqqiHIglH4SdWGKmbHUkk70gfDXTV3J9p29ES78IC2I=;
  b=bN4G5qxLwELQx8F/lIQ5okTOVT19v8y4YAOLFW964k0ySDvK7IOK2WwL
   hSdjjoiBapV5WKApj3o1QhnXyhRS2dls2wB2/hxiLbwAvSisoMhZ0gEGY
   0xsRrWgDmZHeAyLoiIeK++XN8NIy10b99qOl6wA5jdmqpphsatIAeaOTQ
   0Sd038k7kYQDOMXSBI+zsfutStz9I25gEhSVYdt3ioYsOluIK6Cqrg6Kv
   KPGsEWV646gy4to4ZDVMVRkQhmATVO7Y7Mwq+IcrgRF/029K4NNaiBdFy
   TvVLYUh5fvmKxz9vvrWkgM6uJn4J/i1P+PET+MlWzhgwEhdofD6XkOrSR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="274970453"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="274970453"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 11:17:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="643754621"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 11:17:48 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH iproute2-next 1/2] mnlg: remove unnused mnlg_socket structure
Date:   Fri, 26 Aug 2022 11:17:40 -0700
Message-Id: <20220826181741.3878852-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

base-commit: fc6be06cab4327eecac5885f80048e7a57dd28e8
-- 
2.37.1.394.gc50926e1f488

