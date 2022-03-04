Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE164CD93E
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240702AbiCDQmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240661AbiCDQl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:41:59 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D6C1B7605
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646412072; x=1677948072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mo135wmiyBV1MyO7OEFoIfk7OQwDjj5fc99hb7inUI0=;
  b=fatEM2Hh5pHSXtmS5cpr04Jv+K8pjiEDiChfwi3u8bNSimoQjeXjWTMW
   gm7a81Y45TVpj3OmG0nriVi2kS6Ijy00K++eHex8ro07DUUXybFpwquTM
   L4idO1xbb/tp3zTvzp2R6Q2dS0+PIvJFWjVPilLWxtTYpKyOP8lFBH9iH
   3uEOUQ5yGxgRbmMynxnOPe5Cu3I96EZlBJunkJpNXy7dZ8ZV7lWY0ByjV
   dDjWNNL271agah0a3OrKddmdccS576GKps/kThQYHfyzuwNTh/MwQpLAj
   csHLaK5FThhRXQb7u5Cf0CbRehmPY3Wg8FkB77VzuzTEp7mOcBlDrA2vV
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251585573"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="251585573"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 08:41:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="642560949"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 04 Mar 2022 08:41:07 -0800
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 224Gf12L020994;
        Fri, 4 Mar 2022 16:41:06 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next v10 5/7] gtp: Add support for checking GTP device type
Date:   Fri,  4 Mar 2022 17:40:46 +0100
Message-Id: <20220304164048.476900-6-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304164048.476900-1-marcin.szycik@linux.intel.com>
References: <20220304164048.476900-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Add a function that checks if a net device type is GTP.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Harald Welte <laforge@gnumonks.org>
---
 include/net/gtp.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/gtp.h b/include/net/gtp.h
index 23c2aaae8a42..c1d6169df331 100644
--- a/include/net/gtp.h
+++ b/include/net/gtp.h
@@ -63,6 +63,12 @@ struct gtp_pdu_session_info {	/* According to 3GPP TS 38.415. */
 	u8	qfi;
 };
 
+static inline bool netif_is_gtp(const struct net_device *dev)
+{
+	return dev->rtnl_link_ops &&
+		!strcmp(dev->rtnl_link_ops->kind, "gtp");
+}
+
 #define GTP1_F_NPDU	0x01
 #define GTP1_F_SEQ	0x02
 #define GTP1_F_EXTHDR	0x04
-- 
2.35.1

