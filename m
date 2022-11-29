Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACFA63C3B9
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiK2P1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiK2P1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:27:36 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE36BF8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 07:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669735654; x=1701271654;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8DaPoguemd1xeM/9bB0k2RpU7Gpd1O1W61mg5haAZC0=;
  b=QZ0FZvS05nAVqLvwJJgPvG53MkvvsIjhK6suUzednz2ErJH4OqN6BSSI
   G/K1j/APLyBPbFsSi1nMRZ2h1TmmytmDxnF2CdjN3f0pF/T0Oj+pcq8/M
   bOOnbQI3BhX9/GFX2djq6+EgPmgTqFhs3R4Zw72155nEUmBOjSB4ijG9u
   uLezCFFDzkh7NHUJTXVvZQ99Nn9hOm8QntO2fScvad5E30u+R4e+w4R5+
   FJlaiFoPky/79IleoNgQMXozuWHsC6uiJnvq97CVS7hzkq8uQtwJ6E96O
   VzrCNVbA+NsRcy2Jdv0OrptFQgdYqtvo8mGjtx+CBEFN0z1WWCb5Ro6mf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="294828306"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="294828306"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 07:23:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="645930333"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="645930333"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 29 Nov 2022 07:23:27 -0800
Received: from vecna.. (vecna.igk.intel.com [10.123.220.17])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ATFNPZe015209;
        Tue, 29 Nov 2022 15:23:25 GMT
From:   Przemek Kitszel <przemyslaw.kitszel@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Maciej Machnikowski <maciej.machnikowski@intel.com>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH net-next] ice: Enable extended PTP support for E823L & E823C devices
Date:   Tue, 29 Nov 2022 16:12:53 +0100
Message-Id: <20221129151253.2239967-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Machnikowski <maciej.machnikowski@intel.com>

Enable extended PTP support for E823C and E823L devices.

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Co-developed-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 938ba8c215cb..ea813306e6cd 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4199,6 +4199,16 @@ void ice_init_feature_support(struct ice_pf *pf)
 	case ICE_DEV_ID_E810C_BACKPLANE:
 	case ICE_DEV_ID_E810C_QSFP:
 	case ICE_DEV_ID_E810C_SFP:
+	case ICE_DEV_ID_E823L_BACKPLANE:
+	case ICE_DEV_ID_E823L_SFP:
+	case ICE_DEV_ID_E823L_10G_BASE_T:
+	case ICE_DEV_ID_E823L_1GBE:
+	case ICE_DEV_ID_E823L_QSFP:
+	case ICE_DEV_ID_E823C_BACKPLANE:
+	case ICE_DEV_ID_E823C_SFP:
+	case ICE_DEV_ID_E823C_10G_BASE_T:
+	case ICE_DEV_ID_E823C_SGMII:
+	case ICE_DEV_ID_E823C_QSFP:
 		ice_set_feature_support(pf, ICE_F_DSCP);
 		ice_set_feature_support(pf, ICE_F_PTP_EXTTS);
 		if (ice_is_e810t(&pf->hw)) {
-- 
2.34.3

