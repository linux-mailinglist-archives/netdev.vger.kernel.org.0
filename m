Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E13D51C9F2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385581AbiEEUKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244961AbiEEUKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:10:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF8854FA5
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651781219; x=1683317219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8qtnhAhm40RhWXD5J0Dd32A9FZvhdycjfSFJPKNwEEs=;
  b=n50kIudX5b3Epn+PheqMC2CyU9VjqVxs+e50UaSyrDoNFsBtcslQ3IjY
   b/eyIPFIY/7XygUM//dzzfstPQPlsLKm9nY+RWBM6XBh1kAjFsT2orLFz
   kW7FI3rpX4yMVjsJxv9/j4l5IRcsar3Xsw569cunZJC0jSOJaED1Cdz5t
   OHRzEyJoQBXguZmlSagyV1TVp6Q6+hJt4dybSwrPAqe9iz7/hII+XxMBq
   MDdzjHzH8/m8M9YdFSwObP/bi6QYB6aUi+itFA6H3RKBakUccWCtkedhG
   y95qR1izx2CjUuiGgdJ0KEcCaPBTUUCs3oC7wZkrAsj/Sdq8Vz5HXiVj2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248772028"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248772028"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 13:06:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="735111697"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2022 13:06:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Wan Jiabing <wanjiabing@vivo.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 01/10] ice: use min_t() to make code cleaner in ice_gnss
Date:   Thu,  5 May 2022 13:03:50 -0700
Message-Id: <20220505200359.3080110-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
References: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
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

From: Wan Jiabing <wanjiabing@vivo.com>

Fix the following coccicheck warning:
./drivers/net/ethernet/intel/ice/ice_gnss.c:79:26-27: WARNING opportunity for min()

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 35579cf4283f..57586a2e6dec 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -76,8 +76,7 @@ static void ice_gnss_read(struct kthread_work *work)
 	for (i = 0; i < data_len; i += bytes_read) {
 		u16 bytes_left = data_len - i;
 
-		bytes_read = bytes_left < ICE_MAX_I2C_DATA_SIZE ? bytes_left :
-					  ICE_MAX_I2C_DATA_SIZE;
+		bytes_read = min_t(typeof(bytes_left), bytes_left, ICE_MAX_I2C_DATA_SIZE);
 
 		err = ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
 				      cpu_to_le16(ICE_GNSS_UBX_EMPTY_DATA),
-- 
2.35.1

