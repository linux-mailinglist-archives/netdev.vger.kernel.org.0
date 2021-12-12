Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E863B47193B
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 09:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhLLIKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 03:10:45 -0500
Received: from smtpbg587.qq.com ([113.96.223.105]:50980 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhLLIKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 03:10:45 -0500
X-QQ-mid: bizesmtp38t1639296604t6oikcmj
Received: from localhost.localdomain (unknown [182.132.179.213])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sun, 12 Dec 2021 16:10:03 +0800 (CST)
X-QQ-SSF: 01000000002000D0I000B00A0000000
X-QQ-FEAT: hR9GyqeohShUxdW3mu+7fFAfGUyr+SlNqYGhRsPHYYX+MvQr7svU16nMkacwm
        UX4FTtuY62WwOpkG5weoNDC86skft94YO6j4y8r9s1FfzkqIVyb4/iBY+S9OtDXqcOhNV5Q
        i43V+gGfdKfIZby9LjvPL5JklvmivqFs4z/iP4Dfj2Q1w1MOq7QabNV1HUzD3/EngasyYX7
        KxVdzHKSWQMOSTkgv33/47INDZvLERMUt/pHlGOa9Nkys8gkKwlhhYIfOl1r6lCVhUQHoXJ
        ku4lnYxoAaqzjNjBGLV30bm4fjEVeaCdfOY+D6IavdFpxs6UNWALkoJ005v09N8gJyRGpD7
        bkabWgBe4G4vnzPBHMSyMLQBHOsAbG4PxGFVRcKxX/c1GnwDCM=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] iavf: remove an unneeded variable
Date:   Sun, 12 Dec 2021 16:10:01 +0800
Message-Id: <20211212081001.368126-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable `ret_code' used for returning is never changed in function
`iavf_shutdown_adminq'. So that it can be removed and just return its
initial value 0 at the end of `iavf_shutdown_adminq' function.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
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
2.34.1

