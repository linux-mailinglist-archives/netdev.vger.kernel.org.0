Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7134D346C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbiCIQZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiCIQWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:22:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00AF1EAEB;
        Wed,  9 Mar 2022 08:21:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 465B56194C;
        Wed,  9 Mar 2022 16:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA1EC340E8;
        Wed,  9 Mar 2022 16:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842891;
        bh=97Nn50gt58l93v/9KvAPm/j6wwDc3B/WHx2XjMzWcM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsM7/PejihgS50t5LhctRNJjQjlvPAmlPx4NN7RnhH+Ysco5unSYfgTG7YLcV3vpT
         ggyh9uGHHshcUrIxhxr3Txz4x+mDSM10VZOUWIYmMF0bI235HA0SIktFGspY6RvKPO
         UmW5WGCQbfJNcOjn/PQ0B6hNZob7uSLkR3XY4ij2qZcUUCjRQxvJP1B7YA/nnK4Itj
         dDPDpXiDdrV/pIBPM/y8CCvuU9LDciePlP3Itp63Uh3cfLRGQFOuEtU5SNH+6o2R4v
         eZuuAbgWHmlbq5OLFPRcxmr94YKmhUPkhORqmvZMGEDUyORKgHnIE2C2Wr03fSCEIx
         UHDVsSDAItrvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ilan.peer@intel.com,
        miriam.rachel.korenblit@intel.com, mordechay.goodstein@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/24] iwlwifi: don't advertise TWT support
Date:   Wed,  9 Mar 2022 11:19:37 -0500
Message-Id: <20220309161946.136122-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161946.136122-1-sashal@kernel.org>
References: <20220309161946.136122-1-sashal@kernel.org>
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
index 475f951d4b1e..fc40cca096c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -541,8 +541,7 @@ static const struct ieee80211_sband_iftype_data iwl_he_capa[] = {
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
index 750217393f48..56c7a68a6491 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -295,7 +295,6 @@ static const u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
-	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
 static const struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
-- 
2.34.1

