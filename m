Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD8AF6607
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfKJDKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbfKJCow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 147AB21655;
        Sun, 10 Nov 2019 02:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353891;
        bh=WpEQZ96HSyMvJyMLElFdXV/w39V1EhtGl8Y9d68T/ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/0/6SEwkD2ayaACbkvmQh6EyLs7u8CQH/NHsuNA3v1omK9vFuSrJYd2/k74CkyxJ
         hFxuo+YQum1mo5BsANr1xumr9TFrS/kAXqjEOOd1BgS4nmgyzsZiWsuectljdgixdd
         JB9ADSuSnpUll6pAOFupgaLiYDevEIvyS9j7Y/48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 163/191] iwlwifi: api: annotate compressed BA notif array sizes
Date:   Sat,  9 Nov 2019 21:39:45 -0500
Message-Id: <20191110024013.29782-163-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6f68cc367ab6578a33cca21b6056804165621f00 ]

Annotate the compressed BA notification array sizes and
make both of them 0-length since the length of 1 is just
confusing - it may be different than that and the offset
to the second one needs to be calculated in the C code
anyhow.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 514b86123d3d3..80853f6cbd6d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -747,9 +747,9 @@ enum iwl_mvm_ba_resp_flags {
  * @tfd_cnt: number of TFD-Q elements
  * @ra_tid_cnt: number of RATID-Q elements
  * @tfd: array of TFD queue status updates. See &iwl_mvm_compressed_ba_tfd
- *	for details.
+ *	for details. Length in @tfd_cnt.
  * @ra_tid: array of RA-TID queue status updates. For debug purposes only. See
- *	&iwl_mvm_compressed_ba_ratid for more details.
+ *	&iwl_mvm_compressed_ba_ratid for more details. Length in @ra_tid_cnt.
  */
 struct iwl_mvm_compressed_ba_notif {
 	__le32 flags;
@@ -766,7 +766,7 @@ struct iwl_mvm_compressed_ba_notif {
 	__le32 tx_rate;
 	__le16 tfd_cnt;
 	__le16 ra_tid_cnt;
-	struct iwl_mvm_compressed_ba_tfd tfd[1];
+	struct iwl_mvm_compressed_ba_tfd tfd[0];
 	struct iwl_mvm_compressed_ba_ratid ra_tid[0];
 } __packed; /* COMPRESSED_BA_RES_API_S_VER_4 */
 
-- 
2.20.1

