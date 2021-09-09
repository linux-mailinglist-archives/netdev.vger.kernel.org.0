Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADE740507A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347419AbhIIM1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349582AbhIIMWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3090E61AD1;
        Thu,  9 Sep 2021 11:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188262;
        bh=v2eAQalN9+dq+alzkTjatiitCku3D0+kDsMpTGOhSng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCfB9le2MP5Z3mE+A5CGD3qW+Pnesf72tMRdfcllXedc+4yfri2ToBppbcvSCSKtm
         RpppTj6eyBVhRBQwwb5FzzNu4ha4Nrj6hawM19y6wCJ9/vcE5FvDCV/OpWR1E/vjZc
         qyHr+R2SbEAieBqDkMIderBgZWXcKd/GrNk0mbHa+UqUMbouTK/mTCr7mzTKsupTUN
         wZDUYl6SjKAvmPzLQhBrP/hM06ttil4jHiXr2nM1QxywAiyQ979QrBrl2SXoZMPLab
         l0ukxT457UoiiF4If29WzZXwUcOCP1MMg8aO/f0EpmJJMUUxMdTDNv0tQ2bdCuT8cT
         c6BJMaGk1nG7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 208/219] iwlwifi: mvm: Fix scan channel flags settings
Date:   Thu,  9 Sep 2021 07:46:24 -0400
Message-Id: <20210909114635.143983-208-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 090f1be3abf3069ef856b29761f181808bf55917 ]

The iwl_mvm_scan_ch_n_aps_flag() is called with a variable
before the value of the variable is set. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210826224715.f6f188980a5e.Ie7331a8b94004d308f6cbde44e519155a5be91dd@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 3627de2af344..ee3aff8bf7c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1648,7 +1648,7 @@ iwl_mvm_umac_scan_cfg_channels_v6(struct iwl_mvm *mvm,
 		struct iwl_scan_channel_cfg_umac *cfg = &cp->channel_config[i];
 		u32 n_aps_flag =
 			iwl_mvm_scan_ch_n_aps_flag(vif_type,
-						   cfg->v2.channel_num);
+						   channels[i]->hw_value);
 
 		cfg->flags = cpu_to_le32(flags | n_aps_flag);
 		cfg->v2.channel_num = channels[i]->hw_value;
-- 
2.30.2

