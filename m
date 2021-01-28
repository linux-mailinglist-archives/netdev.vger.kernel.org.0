Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8633080C2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhA1VvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:51:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231561AbhA1VvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 16:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611870584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KD4lbzdIOpjuTGwGAtQkdJ19ZTs68m6KrP7k1kvMzEg=;
        b=UOa93MeGrZFYqdQMHY+bNY6jpoSm60Hng05snWiDKoGZvHM3U60VDOkMOQ3lIxHIt0Sakh
        sGlwNexjD6Cuk3wtFMKvAdJ/ZO3VLjUAALamDr2me4OFZFte0arTtnrSS/Dxn6x4reN30z
        /Au/ua3BJaFzHtdc+xhIcDfeeyfOvyE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-MeO8FvfaPaqEq9DtRpCuhg-1; Thu, 28 Jan 2021 16:49:42 -0500
X-MC-Unique: MeO8FvfaPaqEq9DtRpCuhg-1
Received: by mail-qk1-f199.google.com with SMTP id c63so42646qkd.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:49:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KD4lbzdIOpjuTGwGAtQkdJ19ZTs68m6KrP7k1kvMzEg=;
        b=UfiCUMtRYp1oBanM1TpsfiTilkE2s1v4Fw6JqJC9U6wh9aEfGDooMRN3sPox7fAmV4
         lqByOqECBg/IaBQTptHVXbUmhTIw3h29OCwRRQyKghw/cD7CYDotlRnRVdtyBRPwaUp5
         W73rF95l8YtzGXd9k8pa759FpbusNIYa2nQQUnE90SidyXgsldkYZtIxB6bXAhLPLJN2
         2hkW5jsREJFm7JLhyUNiJwtpn1ml/TuxDFk5BKUab26OcxsFxiud7aFkCj7CLIJFXbJC
         sTg4133nfwqEbS1JnLOB1j3cWaIBZrj/R/zPFOzr5JzkVEjbacv82rrXO39HXuPaSVrJ
         lJdw==
X-Gm-Message-State: AOAM531vce75YNnRtsqqo2Vh6NG2qc/vJLBX0WFVe7Xh1dJvMLYWXh1+
        /BcnHAhJ/Dl1j1qoszjYmUttQ2ugHyiJazqYhDYTL5l+mlp9k5qn8tTziClMdjmTI0jkz/KqlXI
        lrazd0KfW9sikkXfn
X-Received: by 2002:a37:8445:: with SMTP id g66mr1318658qkd.453.1611870582166;
        Thu, 28 Jan 2021 13:49:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwspytYtwyMV4+nu5JRe0UaRVk2dJIKOJZmXq1ypKTH2Z0xJfueN/4QZ8vR/hUYJxHlAbNcUA==
X-Received: by 2002:a37:8445:: with SMTP id g66mr1318633qkd.453.1611870581934;
        Thu, 28 Jan 2021 13:49:41 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id t14sm4394546qkt.50.2021.01.28.13.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 13:49:41 -0800 (PST)
From:   trix@redhat.com
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, johannes.berg@intel.com,
        janiex.tu@intel.com, nathan.errera@intel.com,
        mordechay.goodstein@intel.com, avraham.stern@intel.com,
        ilan.peer@intel.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] iwlwifi: mvm: remove h from printk format specifier
Date:   Thu, 28 Jan 2021 13:49:33 -0800
Message-Id: <20210128214933.2623068-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
  unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c       | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 80f848a9ee13..8f61406ea69a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -326,10 +326,10 @@ static ssize_t iwl_dbgfs_sar_geo_profile_read(struct file *file,
 		pos += scnprintf(buf + pos, bufsz - pos,
 				 "Use geographic profile %d\n", tbl_idx);
 		pos += scnprintf(buf + pos, bufsz - pos,
-				 "2.4GHz:\n\tChain A offset: %hhu dBm\n\tChain B offset: %hhu dBm\n\tmax tx power: %hhu dBm\n",
+				 "2.4GHz:\n\tChain A offset: %u dBm\n\tChain B offset: %u dBm\n\tmax tx power: %u dBm\n",
 				 value[1], value[2], value[0]);
 		pos += scnprintf(buf + pos, bufsz - pos,
-				 "5.2GHz:\n\tChain A offset: %hhu dBm\n\tChain B offset: %hhu dBm\n\tmax tx power: %hhu dBm\n",
+				 "5.2GHz:\n\tChain A offset: %u dBm\n\tChain B offset: %u dBm\n\tmax tx power: %u dBm\n",
 				 value[4], value[5], value[3]);
 	}
 	mutex_unlock(&mvm->mutex);
@@ -1035,7 +1035,7 @@ iwl_dbgfs_scan_ant_rxchain_read(struct file *file,
 		pos += scnprintf(buf + pos, bufsz - pos, "B");
 	if (mvm->scan_rx_ant & ANT_C)
 		pos += scnprintf(buf + pos, bufsz - pos, "C");
-	pos += scnprintf(buf + pos, bufsz - pos, " (%hhx)\n", mvm->scan_rx_ant);
+	pos += scnprintf(buf + pos, bufsz - pos, " (%x)\n", mvm->scan_rx_ant);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index a4fd0bf9ba19..0d5e96fa6525 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -949,10 +949,10 @@ static void iwl_mvm_debug_range_resp(struct iwl_mvm *mvm, u8 index,
 	IWL_DEBUG_INFO(mvm, "\tstatus: %d\n", res->status);
 	IWL_DEBUG_INFO(mvm, "\tBSSID: %pM\n", res->addr);
 	IWL_DEBUG_INFO(mvm, "\thost time: %llu\n", res->host_time);
-	IWL_DEBUG_INFO(mvm, "\tburst index: %hhu\n", res->ftm.burst_index);
+	IWL_DEBUG_INFO(mvm, "\tburst index: %u\n", res->ftm.burst_index);
 	IWL_DEBUG_INFO(mvm, "\tsuccess num: %u\n", res->ftm.num_ftmr_successes);
 	IWL_DEBUG_INFO(mvm, "\trssi: %d\n", res->ftm.rssi_avg);
-	IWL_DEBUG_INFO(mvm, "\trssi spread: %hhu\n", res->ftm.rssi_spread);
+	IWL_DEBUG_INFO(mvm, "\trssi spread: %u\n", res->ftm.rssi_spread);
 	IWL_DEBUG_INFO(mvm, "\trtt: %lld\n", res->ftm.rtt_avg);
 	IWL_DEBUG_INFO(mvm, "\trtt var: %llu\n", res->ftm.rtt_variance);
 	IWL_DEBUG_INFO(mvm, "\trtt spread: %llu\n", res->ftm.rtt_spread);
@@ -1051,7 +1051,7 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	}
 
 	IWL_DEBUG_INFO(mvm, "Range response received\n");
-	IWL_DEBUG_INFO(mvm, "request id: %lld, num of entries: %hhu\n",
+	IWL_DEBUG_INFO(mvm, "request id: %lld, num of entries: %u\n",
 		       mvm->ftm_initiator.req->cookie, num_of_aps);
 
 	for (i = 0; i < num_of_aps && i < IWL_MVM_TOF_MAX_APS; i++) {
@@ -1143,7 +1143,7 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 
 		if (fw_has_api(&mvm->fw->ucode_capa,
 			       IWL_UCODE_TLV_API_FTM_RTT_ACCURACY))
-			IWL_DEBUG_INFO(mvm, "RTT confidence: %hhu\n",
+			IWL_DEBUG_INFO(mvm, "RTT confidence: %u\n",
 				       fw_ap->rttConfidence);
 
 		iwl_mvm_debug_range_resp(mvm, i, &result);
-- 
2.27.0

