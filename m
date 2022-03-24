Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F764E5F28
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 08:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348303AbiCXHOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 03:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237660AbiCXHOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 03:14:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F74298589;
        Thu, 24 Mar 2022 00:12:49 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b24so4504152edu.10;
        Thu, 24 Mar 2022 00:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lEWXgJkZ9YkjxmIKVgLVKeUu8IQ302XTSv9LN9G/J+k=;
        b=W+gG8BokMRYHEkCN2M8homaBABnxT8olVNZHC7zntI4rmt4fe6Qx3dOEHrDyJdQG4r
         VoRgu+wCqprKXvRR8s74QmWRmxhYNJQ5mh7KUyYrJtYtHkrNutcJhfudYF2NOcuwXIMF
         XqLR2zgQ3W/QK2U0fBDJSmBDU/C/DggMVKPs5FYtQikZHfDD2gUcQSiGBqR+QOtEATuk
         7M6cyM9j/5otM+mzv1G5El10T52y4NXs4hUSCDNSZnzXZKC4R00sJBYnSBKmYlSQcASC
         hj1TNRwt7VjnmLZB85iQ9989a1m9DiXRRDQIyQeVkq3G0YrdP41Ew0esEY01s5bshVHk
         zU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lEWXgJkZ9YkjxmIKVgLVKeUu8IQ302XTSv9LN9G/J+k=;
        b=kji1/2B/sT0/3Hp+IOq9nWw4BBUzIbsh+LSw05ymgUbpQF4seLxLyh3cxxTdnbhFQP
         yvyRPl8wamIDG+OY1Xwt3vfYKtqGv6pYojfL5pWtgNLbH/JrXLYdY2AXCDzYfldx+UhH
         VfIgZlWIifvIpSIk8n1h9lqvcKBkJ671z32d9BMXWvivUjKQzSqQZUlSAzti8HH/DOhD
         3wMKffUv+RbygFIYlg7/y7t24gjuOOhC0eKXPP78TsQa8XiAurPm3g5u/sMSOMURn56S
         1ZkOK6ePxz06xKJ007yfg2mlmPEEVJIy65Lfn+T/GksV+2q2YKtuISv1nmTEAz6MDQwH
         dWSg==
X-Gm-Message-State: AOAM530KECHQXlNb+kzmpjMFURzl/nLTfxaRkttWhwBFSD7QScssoRNv
        y4MGcXkq1Jt01TJ/cH0kJR0=
X-Google-Smtp-Source: ABdhPJxqxODbVuYI/M8Rfky4+i8CZnMy/P+h+yDMWA72ydylMCAAGrYl2qjH/DkP6+2Lj3ch+BMpQg==
X-Received: by 2002:a50:875c:0:b0:419:29a:4c35 with SMTP id 28-20020a50875c000000b00419029a4c35mr5020387edv.188.1648105968150;
        Thu, 24 Mar 2022 00:12:48 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id j17-20020a05640211d100b00419357a2647sm1032369edw.25.2022.03.24.00.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 00:12:47 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Nathan Errera <nathan.errera@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] iwlwifi: mvm: replace usage of found with dedicated list iterator variable
Date:   Thu, 24 Mar 2022 08:11:58 +0100
Message-Id: <20220324071158.60032-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c   | 12 +++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c  | 11 +++++------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 628aee634b2a..67a03fcde759 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -1011,11 +1011,10 @@ static int iwl_mvm_ftm_range_resp_valid(struct iwl_mvm *mvm, u8 request_id,
 static void iwl_mvm_ftm_rtt_smoothing(struct iwl_mvm *mvm,
 				      struct cfg80211_pmsr_result *res)
 {
-	struct iwl_mvm_smooth_entry *resp;
+	struct iwl_mvm_smooth_entry *resp = NULL, *iter;
 	s64 rtt_avg, rtt = res->ftm.rtt_avg;
 	u32 undershoot, overshoot;
 	u8 alpha;
-	bool found;
 
 	if (!IWL_MVM_FTM_INITIATOR_ENABLE_SMOOTH)
 		return;
@@ -1029,15 +1028,14 @@ static void iwl_mvm_ftm_rtt_smoothing(struct iwl_mvm *mvm,
 		return;
 	}
 
-	found = false;
-	list_for_each_entry(resp, &mvm->ftm_initiator.smooth.resp, list) {
-		if (!memcmp(res->addr, resp->addr, ETH_ALEN)) {
-			found = true;
+	list_for_each_entry(iter, &mvm->ftm_initiator.smooth.resp, list) {
+		if (!memcmp(res->addr, iter->addr, ETH_ALEN)) {
+			resp = iter;
 			break;
 		}
 	}
 
-	if (!found) {
+	if (!resp) {
 		resp = kzalloc(sizeof(*resp), GFP_KERNEL);
 		if (!resp)
 			return;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index ab06dcda1462..98e91231cc20 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -377,16 +377,15 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 static int iwl_mvm_aux_roc_te_handle_notif(struct iwl_mvm *mvm,
 					   struct iwl_time_event_notif *notif)
 {
-	struct iwl_mvm_time_event_data *te_data, *tmp;
-	bool aux_roc_te = false;
+	struct iwl_mvm_time_event_data *te_data = NULL, *iter, *tmp;
 
-	list_for_each_entry_safe(te_data, tmp, &mvm->aux_roc_te_list, list) {
-		if (le32_to_cpu(notif->unique_id) == te_data->uid) {
-			aux_roc_te = true;
+	list_for_each_entry_safe(iter, tmp, &mvm->aux_roc_te_list, list) {
+		if (le32_to_cpu(notif->unique_id) == iter->uid) {
+			te_data = iter;
 			break;
 		}
 	}
-	if (!aux_roc_te) /* Not a Aux ROC time event */
+	if (!te_data) /* Not a Aux ROC time event */
 		return -EINVAL;
 
 	iwl_mvm_te_check_trigger(mvm, notif, te_data);

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
2.25.1

