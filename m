Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC3A4D377B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiCIQfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiCIQat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:30:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C99177753;
        Wed,  9 Mar 2022 08:24:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B720619C9;
        Wed,  9 Mar 2022 16:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E1DC340E8;
        Wed,  9 Mar 2022 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843082;
        bh=tnE90IB6LR3XgPsa47TXjDRPFMPyJOgNoQJRfk99q+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbCC1+9plPDZ39IIxUYVN0WkWozX167aZQKIwaDWrfjkF2IdXCPVUAA3vSR0fnlRn
         3F4S9nWmdjwEtTuMgAFsKzQyUGtV0DUSzxF6XD6OEkjKg1UEowrRJPVpqfSVe0N/8+
         jmUBTWix0W34yW0slH8d7/FZmVysk13A4iVXWKMM9NaCUxsvxJqK0vUI3NeeFMrezy
         NctU8HD7rZhDS6BQKkEFc7pc/5VgDLHo/QfajtNhOjvO388J8EVsJ5Ca3disOjEM8G
         FYrCacp0vO23W506vBJyohgAOrQuYkX77ew9bOmcOVKsukI/UMbXUI1Jxf7TTNVwf8
         gCR5Yy4/vGFsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        miriam.rachel.korenblit@intel.com, ilan.peer@intel.com,
        mordechay.goodstein@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/19] iwlwifi: don't advertise TWT support
Date:   Wed,  9 Mar 2022 11:23:30 -0500
Message-Id: <20220309162337.136773-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162337.136773-1-sashal@kernel.org>
References: <20220309162337.136773-1-sashal@kernel.org>
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
index 022f2faccab4..4a433e34ee7a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -519,8 +519,7 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
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
index 29ad7804d77a..3c523774ef0e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -343,7 +343,6 @@ const static u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
-	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
 const static struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
-- 
2.34.1

