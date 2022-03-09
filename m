Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6A74D349A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiCIQZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238134AbiCIQVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:21:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655781520F2;
        Wed,  9 Mar 2022 08:19:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F4174615F1;
        Wed,  9 Mar 2022 16:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C87BC340E8;
        Wed,  9 Mar 2022 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842750;
        bh=88f2Inyp4nMPXG1F0eSXddJ2jr5Uf6R8ttDLN4ddLcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTgBlFYcxVLFz8bIuNDzdhT1W+FLaMKQUIoBJd92OYdKPENyI5HnJzGgBZ/i3fuhi
         PblzEfpxXto3Rp1TzjHF0ebCsVbnTprgztV0dtLbxxoy+Lvrt2PGK28kRLwuoRglS8
         A50CB+3512kbnWfjy3FWLxJZHL1v+xqtw89/4yorCp1ami7iv69nHNunbxZ0XVFeEY
         +GTgEHT8fqL719yJR8xtP9Lmns+Ul30bpYaEco0Q7KD1JDXhd9wuh0aG3VRm0icZGK
         UI/3Tj+Bt5dQ/DfCt+mTnH04o3ddnxM283C4rxOXSN4yMSD3sK9wPM5q1+HUZNiZ8A
         9bbiojuJzPsvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        mordechay.goodstein@intel.com, ilan.peer@intel.com,
        miriam.rachel.korenblit@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 21/27] iwlwifi: don't advertise TWT support
Date:   Wed,  9 Mar 2022 11:16:58 -0500
Message-Id: <20220309161711.135679-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Golan Ben Ami <golan.ben.ami@intel.com>

[ Upstream commit 1db5fcbba2631277b78d7f8aff99c9607d29f6d8 ]

Some APs misbehave when TWT is used and cause our firmware to crash.
We don't know a reasonable way to detect and work around this problem
in the FW yet.  To prevent these crashes, disable TWT in the driver by
stopping to advertise TWT support.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215523
Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
[reworded the commit message]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20220301072926.153969-1-luca@coelho.fi
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index f470f9aea50f..c97798f6290a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -552,8 +552,7 @@ static const struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 			.has_he = true,
 			.he_cap_elem = {
 				.mac_cap_info[0] =
-					IEEE80211_HE_MAC_CAP0_HTC_HE |
-					IEEE80211_HE_MAC_CAP0_TWT_REQ,
+					IEEE80211_HE_MAC_CAP0_HTC_HE,
 				.mac_cap_info[1] =
 					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index cde3d2ce0b85..a65024fc96dd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -223,7 +223,6 @@ static const u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
-	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
 static const struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
-- 
2.34.1

