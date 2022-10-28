Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2586E610F4A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJ1LEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJ1LEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EC7BC94
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955075; x=1698491075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+8B+TsH/HoVYY5FCKEkAwLHWNW4Dtk0tGu06ix4r3Cw=;
  b=FnERxd3oE7fVFqikrVHBs9rYK0RUSb2lNJCcvSo12CFnveB5NIPvoS5H
   AI0tS8dOeJ+nB4BId73R4UIXDfCRPz6YNBtYzgFBE9/iS2y7bbzBtqcN8
   D0ZIfxvnfpdeRSDuRvvDQ65gtBeK+j6h8ZasyljbcLEhmIYonckckKz6E
   +nRiEYvms0IV51MSbJgj/dl1AubiktcN/jT9Iubswntg8hXfRTdFBqd0N
   cy5maFdsrtb99gQ8YzxfeZADH16X0jRszKWScyc76GDd5KknJUQdBK5V9
   WTQ6Ztmq0dWEHkEPOks6ryCbeGaXU8gKVM4LXge55HEgeQx4EQ3jZv4H1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766534"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766534"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:33 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698082"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698082"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:33 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next v3 1/9] ptp: add missing documentation for parameters
Date:   Fri, 28 Oct 2022 04:04:12 -0700
Message-Id: <20221028110420.3451088-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
In-Reply-To: <20221028110420.3451088-1-jacob.e.keller@intel.com>
References: <20221028110420.3451088-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ptp_find_pin_unlocked function and the ptp_system_timestamp structure
didn't document their parameters and fields. Fix this.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/ptp_clock_kernel.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 92b44161408e..ad4aaadc2f7a 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -45,6 +45,8 @@ struct system_device_crosststamp;
 
 /**
  * struct ptp_system_timestamp - system time corresponding to a PHC timestamp
+ * @pre_ts: system timestamp before capturing PHC
+ * @post_ts: system timestamp after capturing PHC
  */
 struct ptp_system_timestamp {
 	struct timespec64 pre_ts;
@@ -316,6 +318,11 @@ int ptp_find_pin(struct ptp_clock *ptp,
  * should most likely call ptp_find_pin() directly from their
  * ptp_clock_info::enable() method.
  *
+* @ptp:    The clock obtained from ptp_clock_register().
+* @func:   One of the ptp_pin_function enumerated values.
+* @chan:   The particular functional channel to find.
+* Return:  Pin index in the range of zero to ptp_clock_caps.n_pins - 1,
+*          or -1 if the auxiliary function cannot be found.
  */
 
 int ptp_find_pin_unlocked(struct ptp_clock *ptp,

base-commit: 12dee519d466025fdedced911d0fe81cb7ba29e7
-- 
2.38.0.83.gd420dda05763

