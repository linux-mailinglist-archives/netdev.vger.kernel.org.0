Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783E5487BAB
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348660AbiAGR5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:57:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:47971 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348659AbiAGR5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 12:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641578264; x=1673114264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JpH7R07Y/MI1hYEQ1If+7wWbVQq4YImWy4lGBx5CusA=;
  b=WXkBqE6pD1Fuv8me3wAPl2TqP/of09WFjMk0iHTlKQ/lEXd3q5e6gMpU
   N+AJGXBi19MX+I7dfQFShlPfhXCLPCiU+W+Tuf/jgEfXPiPLehYOKypRK
   tS3mXuAv5fk350D4IMk9Ov9h7jMyKQUThrrnmqORXI4dE0AMd6fKNzMmS
   OCgy74txqLEjXFnbLAw2QpWxlXb7XIpg8rYJEALn00HksUUFb/8RixfmE
   LgQV/dlTtJMkj+30cnB25QF/BPtJbcxbefYVNgl8zcuI/e2GrJBXW5nxM
   I1lqFas42f67O0ZKKNv4R7mQQG//L0uq7CJdTtpbPC4vCEgRn1p+XX4hJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="229716415"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="229716415"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:57:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668831924"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jan 2022 09:57:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jason Wang <wangborong@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com
Subject: [PATCH net-next v2 6/6] iavf: remove an unneeded variable
Date:   Fri,  7 Jan 2022 09:57:04 -0800
Message-Id: <20220107175704.438387-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
References: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <wangborong@cdjrlc.com>

The variable `ret_code' used for returning is never changed in function
`iavf_shutdown_adminq'. So that it can be removed and just return its
initial value 0 at the end of `iavf_shutdown_adminq' function.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index 9fa3fa99b4c2..cd4e6a22d0f9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -551,15 +551,13 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
  **/
 enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw)
 {
-	enum iavf_status ret_code = 0;
-
 	if (iavf_check_asq_alive(hw))
 		iavf_aq_queue_shutdown(hw, true);
 
 	iavf_shutdown_asq(hw);
 	iavf_shutdown_arq(hw);
 
-	return ret_code;
+	return 0;
 }
 
 /**
-- 
2.31.1

