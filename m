Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8136EA04A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjDTXxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjDTXxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:53:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C514C01
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034811; x=1713570811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fuUhTHi0j3vkiMgc7gRKWDm3NuS3PLx4z1/yJbU8pNc=;
  b=GJrheXWljOhJJl6SUQe4yKolrEph0UTJuj5WlBUi+xO3ScqZsq9asqQy
   ZzNLeHflBeibnEhrLfXkrop0R9vaQCaAp84GYBw8KdolrM72VW9B9Hkaw
   f1y3KHBW/SElsOJ5FjO9nN4cW5lYJtzPqQ30m5itPWleufMMnq5P0uNxB
   nztrHxJ2cyQMMZI2N3pat5sKQDVq4z69v4oFYXXNWIxGGqHgQpHcNeNhb
   d3lZ31u4q/CKD49TLGkLh1kjoqzjDfcG7qEvoLmXTO9iK4v769jppWFQ7
   NjXAb0/y5QrZrcp2CnEQvpRKGeE55EECOl/lS4aKI6FBbbJ3mkKtV11gV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343368433"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343368433"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:53:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756714239"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="756714239"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 20 Apr 2023 16:53:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Schmidt <mschmidt@redhat.com>, anthony.l.nguyen@intel.com,
        johan@kernel.org, karol.kolacinski@intel.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 2/6] ice: increase the GNSS data polling interval to 20 ms
Date:   Thu, 20 Apr 2023 16:50:29 -0700
Message-Id: <20230420235033.2971567-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
References: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
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

From: Michal Schmidt <mschmidt@redhat.com>

Double the GNSS data polling interval from 10 ms to 20 ms.
According to Karol Kolacinski from the Intel team, they have been
planning to make this change.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_gnss.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h b/drivers/net/ethernet/intel/ice/ice_gnss.h
index 640df7411373..b8bb8b63d081 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -5,7 +5,7 @@
 #define _ICE_GNSS_H_
 
 #define ICE_E810T_GNSS_I2C_BUS		0x2
-#define ICE_GNSS_POLL_DATA_DELAY_TIME	(HZ / 100) /* poll every 10 ms */
+#define ICE_GNSS_POLL_DATA_DELAY_TIME	(HZ / 50) /* poll every 20 ms */
 #define ICE_GNSS_TIMER_DELAY_TIME	(HZ / 10) /* 0.1 second per message */
 #define ICE_GNSS_TTY_WRITE_BUF		250
 #define ICE_MAX_I2C_DATA_SIZE		FIELD_MAX(ICE_AQC_I2C_DATA_SIZE_M)
-- 
2.38.1

