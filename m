Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDBBF659D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfKJCpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbfKJCpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A4C6215EA;
        Sun, 10 Nov 2019 02:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353902;
        bh=Nie++jwXeETwcFQqwwHJgPZbDbLErfmYmKOCTZHw8QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efwLg8q09mvuWm4u4UJ1BDihdxTAw5bgRsZBQeBB6h3gb7+FNE6oY2OC/8oaz6/RY
         d9fQbLYpcTmfloCLP258+0tquS3woWKRBR2syb3oJv+mL/jkJSkn48uo4EsIZm21UY
         nmD9lIFCS30FkgsFzXI3aem60xe0WtbxG1pjaDgE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 167/191] iwlwifi: mvm: Allow TKIP for AP mode
Date:   Sat,  9 Nov 2019 21:39:49 -0500
Message-Id: <20191110024013.29782-167-sashal@kernel.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 6f3df8c1192c873a6ad9a76328920f6f85af90a8 ]

Support for setting keys for TKIP cipher suite was mistakenly removed
for AP mode. Fix this.

Fixes: 85aeb58cec1a ("iwlwifi: mvm: Enable security on new TX API")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 18db1ed92d9b0..04ea516bddcc0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3133,10 +3133,6 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		if (vif->type == NL80211_IFTYPE_AP) {
-			ret = -EINVAL;
-			break;
-		}
 		addr = iwl_mvm_get_mac_addr(mvm, vif, sta);
 		/* get phase 1 key from mac80211 */
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
-- 
2.20.1

