Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540235E5964
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiIVDNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIVDLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:11:55 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292499C203
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so765666pjh.3
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Jz+Ostx8EixhSjUkAJ1MIUDEmgukIDR1YF6R1GI6RoI=;
        b=fPTKJgOJ8MKfbMiXIpgZmZo5TbbArv5BmXt+LwFRkAzQw4Qu/q6syj7IcUEyuUSLZC
         yNdKZEHFMNqZF6mSMR/upLZfvUDc4OsZWUqA6LMkXiGnDuz3LTWtfDKv8R/sczIGTB4b
         PPPxu9tlVDDIbwvlIxQ4U87Tuu07hPZSUMAUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Jz+Ostx8EixhSjUkAJ1MIUDEmgukIDR1YF6R1GI6RoI=;
        b=0XzcPeM/dGo3N6YK6wXml/N4nuwVn6cSIAlwmi59SsfBxMiYP32ax2g3OPJ4pkQrLv
         Ou80zI+yL68mBdovYKRJe3dengR7196ULxUvwyezNRrozpdZmMz+WFBHyW1m7qlB42l4
         viivliIF/QR/3kxH7Pe/FkjF+dk/WloMVOFy0xjZfFQTZwNEnfXScxf6zOIGnfcW39UM
         Zoo+5VdfjsLs+ncBBJpTc7RMsz99npM3Quo7YrVMs8KyB1DJK35gStd89nlSi4PQRQFK
         rrPi2VzNHzQ0ZQLRHUhP0x+ApR+EFfDRIBzeIXS/ORIvZ1K45lxFumXCGuBiH3ymGMo8
         ompA==
X-Gm-Message-State: ACrzQf3saIvMl8J6EwxMs0/XHSClS+zFmeeC98qlHuiHCIvYBIA/bK1w
        1IfCGxfjHzEkZHwDZz72juqUUA==
X-Google-Smtp-Source: AMsMyM5tC/t7wLfYhNs5GORrj4kxZVraGAFSpN+CcYK58sR/ai9S8jVYHP0V/B17TTj8XqmzOIYYvg==
X-Received: by 2002:a17:902:f08d:b0:178:e0ba:dbfa with SMTP id p13-20020a170902f08d00b00178e0badbfamr1329661pla.160.1663816230080;
        Wed, 21 Sep 2022 20:10:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f21-20020a623815000000b0053e85a4a2c9sm2967625pfa.5.2022.09.21.20.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:10:26 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH 10/12] iwlwifi: Track scan_cmd allocation size explicitly
Date:   Wed, 21 Sep 2022 20:10:11 -0700
Message-Id: <20220922031013.2150682-11-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922031013.2150682-1-keescook@chromium.org>
References: <20220922031013.2150682-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6042; h=from:subject; bh=/2MF0zaqjNiY4mBxcqwtNff5CpXhf0ch+CZ/OsL6Iys=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK9IUpAWmHsY7kNqv64d6KlpPF5EGDYQVGtcVBB8E RiKZrCqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyvSFAAKCRCJcvTf3G3AJshrD/ 9Q/SIlHUs29NDsmOcljm9C//gN/xxOAY2HM3QP/8nnro1TzHM/dYk6y6fxinyM/FT3a+5rXC4uBc+v LwPu4gwCCxl7xgmEDH1Nvu1rsWajAtwwQqRb+2p10qvqadnerRtSBg76SLZ6yfjddJfabq5nhj5e47 hpU71yCZaGYynPZmJt/PCDMP/w8k2CcwQr6fXuTrj7IihrDXBB1BAQDnu3Fz+xBFsAzgMlmFedsz+L NYQ2PWzeMnR6dNJIsbJi4xfITVOOmalIXP8EOr2LQlXhvK+haHv3VydbbWlEtWo0gFVl+OWhzvCTpA tvw9KSut04RjTKOmYxr//XumjuRUsc7xe0DCBZC8Q07WUSg0U1Fx1IwwXVrTru2WhJbNp+DhdhHU/h yQ1vHJStx9qNRhhdqrorX/Rb+qnPWPzOY5wVtxVsdE6bzcncMOrTmNwjhbwJyFQAvZsEW/zlxmxcQR xRlmfZ7/QdJ4MONHIzN2gzeCr2r+mf4Oa1qvJByIy+yJ2spuLI47uJxNrihVh4Ce9d1dacTBmQy8LN xom1841wxeimKr7/vpOSZFc1D5paqI+KkR9cNjpdWW25CL30X1WsB04ZMBWJbp2alfj1Tuax1Nb/cE O0hD0MGN2WZXISj7I1q4I2U27RiAI1UDAw9FJFoF7ec3RgnwwE00lyfJb1Dg==
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
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
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

