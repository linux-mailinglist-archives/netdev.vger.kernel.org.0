Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7693F5E8592
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 00:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiIWWJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 18:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiIWWI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 18:08:59 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D1A147F33
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 15:08:57 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s206so1456413pgs.3
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 15:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=v+eLs7CX4OpYnGq5AL+vslir6j393s7nqOXABwCSSN0=;
        b=T0exYYNLRfZvRHGGnonPlRcz4rs9tZG9YwGsSEW7t8vPvHQlfdYZdBBRU8YWHsT1LX
         dt4G48PS/iuXBqG58OC4k55CkVAiD8Ymp7w+ukqNanMqh2dGpvRPwGTbTalJSEY18VYi
         i0AYx1Y4nXHKFokzWzuagim5oVMnJV01o1aaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=v+eLs7CX4OpYnGq5AL+vslir6j393s7nqOXABwCSSN0=;
        b=tDNer+QivcKJ/Q9DfxZCsh+p9sicif9dVjLhaZAvuedaKxQlEEs2HZ1/q3KzYLxztB
         bAdkFagxCKELLlR+GLXshlrTE9GiPw9GBrVy+vMJ++zyHaHFEntXGhi+iHDqwNPOI+xz
         gP6i4oGCmuIvXMdka2q63N1vLHbSzZYUFz/14qyXv568+tivZxH6MyFkvNG+Wh/EtvXn
         deN0PtqTqc+5LTqj8voTd7TJ8a8ApAwd4nrvZbIM1xBQnyfCx3FEtwO1wyDIT8UxIRi/
         sahBZj4y4igpqPVk99520SBSfmHBV2AXr3n42VYIx7NgD8c1lZ0cL/YQ+SRW7SNCNm9Y
         MGVg==
X-Gm-Message-State: ACrzQf1Jp5FVtZ6lAOu6rZDUh/9eR0IYRliq6aiZYLvJSVKzvsp//dWi
        ZtIJPZha87M5wjCD9IB0VGwxng==
X-Google-Smtp-Source: AMsMyM4QU5bjIY/3gea6HILQpt2UH44D4+cROND1jUXN6yrwB0csIEr8R/Bl50VJHW//p4ryuu7uLg==
X-Received: by 2002:a62:1d56:0:b0:557:8233:7442 with SMTP id d83-20020a621d56000000b0055782337442mr2729924pfd.33.1663970936972;
        Fri, 23 Sep 2022 15:08:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l15-20020a17090a72cf00b001f22647cb56sm2039792pjk.27.2022.09.23.15.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 15:08:56 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Gregory Greenman <gregory.greenman@intel.com>
Cc:     Kees Cook <keescook@chromium.org>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nathan Errera <nathan.errera@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Mike Golant <michael.golant@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] iwlwifi: Track scan_cmd allocation size explicitly
Date:   Fri, 23 Sep 2022 15:08:53 -0700
Message-Id: <20220923220853.3302056-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6506; h=from:subject; bh=ZdFtQJrir9vmHjhQgHQJ0oFJQhgmS1Ici2jkyPvaoPg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLi51GpveMhHnnbBVQ18uTL45Sqd7dxnR38G6tGOq txB5j4OJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4udQAKCRCJcvTf3G3AJpHaEA Caye3Bg8AVD0wB7ecF37jyKUkpUro86N+brzREvIRbWC/jURR7U5WS+VOkm5TykDE2Nw7ht7Fmbwds 3lUsm/IhhujEHQyzFy6blO9Tip7rLpfgsKicKR5D121Hen6bAkwuLP0qNRJOAAjlqTSJlXQwfkR1aD tTt6EvXU7el7XtIzigrSAd7eSxJXwx7DS4TiANkvnmv2adjoNoF2XqFBeSpVWgCmdGvq9SqSXMxIPs bmYh1c1LhRcmUBnSFam8JV2AC23wbYGnQFjbK8fboy8s4Y0h3kzt80PR0UdG5ISItyX13Y5qRT/ZzY mmBqz6GP0nBrjPeEZekZOBhAXBGkVKgT8fwmU5Dbgy6BdIOfxl3J4b2RmQKO6yXon3Qokou/9bdnt+ ZsC64cbUSRMZgd/I1NG8bNRmK7ocrzxkjTlvudYRmguhct/ExgRmZWL0PPR43p+ZGBcu5Mv8T6Ktmg C5qi1CMJZqbNaDJyWFwLWgUIj4zzHFIQSJJadAmgkQ+5a6shlQjiQUOV6PMUV38tWpkEctn26qFBc4 Hd/cCfJqXgb2p9AjbrdoNHBahslkU/TpIcYcdL8Ptb8OPYMBpVCDT8adxCc5vLur5VKjrMJJQyEBRw UAaAEuAR4+IzT0ye1E38MbqKQzuoxosBwcmSCjaE0rH/oQ1/CSz+w3cKWcFA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for reducing the use of ksize(), explicitly track the
size of scan_cmd allocations. This also allows for noticing if the scan
size changes unexpectedly. Note that using ksize() was already incorrect
here, in the sense that ksize() would not match the actual allocation
size, which would trigger future run-time allocation bounds checking.
(In other words, memset() may know how large scan_cmd was allocated for,
but ksize() will return the upper bounds of the actually allocated memory,
causing a run-time warning about an overflow.)

Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
Sending this stand-alone for the wireless tree, since it does not
explicitly depend on the ksize() series.
---
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c | 10 ++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  6 +++---
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
index bbd574091201..1a9eadace188 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
@@ -696,6 +696,7 @@ struct iwl_priv {
 	/* Scan related variables */
 	unsigned long scan_start;
 	unsigned long scan_start_tsf;
+	size_t scan_cmd_size;
 	void *scan_cmd;
 	enum nl80211_band scan_band;
 	struct cfg80211_scan_request *scan_request;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 2d38227dfdd2..a7e85c5c8c72 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -626,7 +626,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u8 active_chains;
 	u8 scan_tx_antennas = priv->nvm_data->valid_tx_ant;
 	int ret;
-	int scan_cmd_size = sizeof(struct iwl_scan_cmd) +
+	size_t scan_cmd_size = sizeof(struct iwl_scan_cmd) +
 			    MAX_SCAN_CHANNEL * sizeof(struct iwl_scan_channel) +
 			    priv->fw->ucode_capa.max_probe_length;
 	const u8 *ssid = NULL;
@@ -649,9 +649,15 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 				       "fail to allocate memory for scan\n");
 			return -ENOMEM;
 		}
+		priv->scan_cmd_size = scan_cmd_size;
+	}
+	if (priv->scan_cmd_size < scan_cmd_size) {
+		IWL_DEBUG_SCAN(priv,
+			       "memory needed for scan grew unexpectedly\n");
+		return -ENOMEM;
 	}
 	scan = priv->scan_cmd;
-	memset(scan, 0, scan_cmd_size);
+	memset(scan, 0, priv->scan_cmd_size);
 
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index bf35e130c876..214b8a525cc6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -860,6 +860,7 @@ struct iwl_mvm {
 
 	/* Scan status, cmd (pre-allocated) and auxiliary station */
 	unsigned int scan_status;
+	size_t scan_cmd_size;
 	void *scan_cmd;
 	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
 	/* For CDB this is low band scan type, for non-CDB - type. */
@@ -1705,7 +1706,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, bool force_upload,
 int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   struct cfg80211_scan_request *req,
 			   struct ieee80211_scan_ies *ies);
-int iwl_mvm_scan_size(struct iwl_mvm *mvm);
+size_t iwl_mvm_scan_size(struct iwl_mvm *mvm);
 int iwl_mvm_scan_stop(struct iwl_mvm *mvm, int type, bool notify);
 int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm);
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index db43c8a83a31..b9cbb18b0dcb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1065,7 +1065,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	static const u8 no_reclaim_cmds[] = {
 		TX_CMD,
 	};
-	int scan_size;
+	size_t scan_size;
 	u32 min_backoff;
 	struct iwl_mvm_csme_conn_info *csme_conn_info __maybe_unused;
 
@@ -1299,6 +1299,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mvm->scan_cmd = kmalloc(scan_size, GFP_KERNEL);
 	if (!mvm->scan_cmd)
 		goto out_free;
+	mvm->scan_cmd_size = scan_size;
 
 	/* invalidate ids to prevent accidental removal of sta_id 0 */
 	mvm->aux_sta.sta_id = IWL_MVM_INVALID_STA;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 582a95ffc7ab..acd8803dbcdd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2626,7 +2626,7 @@ static int iwl_mvm_build_scan_cmd(struct iwl_mvm *mvm,
 	u8 scan_ver;
 
 	lockdep_assert_held(&mvm->mutex);
-	memset(mvm->scan_cmd, 0, ksize(mvm->scan_cmd));
+	memset(mvm->scan_cmd, 0, mvm->scan_cmd_size);
 
 	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
 		hcmd->id = SCAN_OFFLOAD_REQUEST_CMD;
@@ -3091,7 +3091,7 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 				     1 * HZ);
 }
 
-static int iwl_scan_req_umac_get_size(u8 scan_ver)
+static size_t iwl_scan_req_umac_get_size(u8 scan_ver)
 {
 	switch (scan_ver) {
 	case 12:
@@ -3104,7 +3104,7 @@ static int iwl_scan_req_umac_get_size(u8 scan_ver)
 	return 0;
 }
 
-int iwl_mvm_scan_size(struct iwl_mvm *mvm)
+size_t iwl_mvm_scan_size(struct iwl_mvm *mvm)
 {
 	int base_size, tail_size;
 	u8 scan_ver = iwl_fw_lookup_cmd_ver(mvm->fw, SCAN_REQ_UMAC,
-- 
2.34.1

