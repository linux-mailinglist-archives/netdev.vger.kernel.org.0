Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6561E1E7114
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437995AbgE2AIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:2082 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437947AbgE2AIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:35 -0400
IronPort-SDR: VN+7DzrMursPJuUJTFvd+c9a6Wbzo413LfjM0slP0bjnr9BBZt1myLNoYe62eUWFRgiyOUcEBq
 te9fjDM52TOQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:33 -0700
IronPort-SDR: 9pyh0MlLMP3ZuZbCQz0DD1Z0SYAw96HccALyhKirFSTO3DY1LElCO3Aq+oKrprD+4K6DiqYuF6
 8r93xLDEevlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651627"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Declare functions static
Date:   Thu, 28 May 2020 17:08:21 -0700
Message-Id: <20200529000831.2803870-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

ice_get_pfa_module_tlv() and ice_read_sr_word() are not being called
outside of their file. Declare them as static.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 5 +++--
 drivers/net/ethernet/intel/ice/ice_nvm.h | 4 ----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 7c2a06892bbb..b049c1c30c88 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -172,7 +172,8 @@ void ice_release_nvm(struct ice_hw *hw)
  *
  * Reads one 16 bit word from the Shadow RAM using the ice_read_sr_word_aq.
  */
-enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
+static enum ice_status
+ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
 {
 	enum ice_status status;
 
@@ -196,7 +197,7 @@ enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
  * Area (PFA) and returns the TLV pointer and length. The caller can
  * use these to read the variable length TLV value.
  */
-enum ice_status
+static enum ice_status
 ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
 		       u16 module_type)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 999f273ba6ad..165eda07b93d 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -11,10 +11,6 @@ enum ice_status
 ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 		  bool read_shadow_ram);
 enum ice_status
-ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
-		       u16 module_type);
-enum ice_status
 ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
-enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
 #endif /* _ICE_NVM_H_ */
-- 
2.26.2

