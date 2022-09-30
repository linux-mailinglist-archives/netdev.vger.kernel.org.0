Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD53B5F141B
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiI3UtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiI3UtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:49:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A27A18F410
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 13:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664570939; x=1696106939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOL3xnFFYrJ++yt26OYYvZQng4SOtS6SqP8mz9K+yBc=;
  b=TAuMcGVp9rIIFIkUPEXKKsilcDaxrDiE0g2lmhzNFC1IywYjCG7vsfd5
   mJaFcfmUHUfW6hfk2PwrmRG0Inr/1MFUaepudK8HHZqiVKdJfwkI+L2kx
   pIvc7CGtl8UBhXjetxbdEF8Voema8zfAn2FI0oFB68Dlw6aS8ffSLNkw8
   DNFNEX19cgfH2nzqifXD0rw1eTVVB0Tvvy17idtal1Unr6cORA2J6DrjJ
   g45Sd/T2fw5iOGYvUFPKXio/EGv/R7l4iLnG4dqAa74dKfhVtQbXBYcKm
   uHCHeINaJ+zm3VwQLR5n6hspUsW8gq22Q31XhoI21FiS3ZKbhvGZT01ft
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="289445987"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="289445987"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:48:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="691383678"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="691383678"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:48:56 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivek Thampi <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: [net-next v2 1/9] ptp: add missing documentation for parameters
Date:   Fri, 30 Sep 2022 13:48:43 -0700
Message-Id: <20220930204851.1910059-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
In-Reply-To: <20220930204851.1910059-1-jacob.e.keller@intel.com>
References: <20220930204851.1910059-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ptp_find_pin_unlocked function and the ptp_system_timestamp structure
didn't document their parameters and fields. Fix this.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
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
-- 
2.37.1.394.gc50926e1f488

