Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FBC664EDA
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjAJWiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjAJWhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:37:54 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724725585D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673390274; x=1704926274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=95wvCj9ZJ3Dg+jsisRYU43FkkP6K+vRi/DzcW0iLtNI=;
  b=KzwxADO6xDHL5GvxCn+aFn6K8Ase4tGtVgayRjftEFtZhdHN4D777w4P
   D1rKdHBeukTA4Xd69SVUYgt8TyEWQRtij5NlmjM7OZAEXFpHOnZsoJC7L
   L/5YCF50hMbvO0L96BpMt5DKhpSOCjFE4WmLSdAA83/HTagmRZ7zFIqwp
   4b/t1Iz84sDeTYgKj0CLjr614+7BsHVw1xAiCJy2IqWX8YU4cN+djZNCW
   kTgHIAlZ8DDPi8qDeGlZhi6C8pC96Kkqzg0rimtXLJ9JwSHalB1VAk5+B
   k8pcea6hocRPtwaVGsml4c2Y5e9RZkw2eWPLVJC/+3fF/+mckjxyBKcDn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="320962816"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="320962816"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 14:37:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="650512956"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="650512956"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga007.jf.intel.com with ESMTP; 10 Jan 2023 14:37:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net 3/3] iavf/iavf_main: actually log ->src mask when talking about it
Date:   Tue, 10 Jan 2023 14:38:25 -0800
Message-Id: <20230110223825.648544-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
References: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

This fixes a copy-paste issue where dev_err would log the dst mask even
though it is clearly talking about src.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 0075fa0fadd0 ("i40evf: Add support to apply cloud filters")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index c4e451ef7942..adc02adef83a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3850,7 +3850,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 				field_flags |= IAVF_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip src mask 0x%08x\n",
-					be32_to_cpu(match.mask->dst));
+					be32_to_cpu(match.mask->src));
 				return -EINVAL;
 			}
 		}
-- 
2.38.1

