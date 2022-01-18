Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A03B49154B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbiARC1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:27:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbiARCZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:25:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A844EB81239;
        Tue, 18 Jan 2022 02:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19702C36AE3;
        Tue, 18 Jan 2022 02:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472710;
        bh=+ssm34GG7w4RratDitFIfpR8USrSyhcfbr2ppoi86JE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvDBI1lAd2XUXiyRGasAF93buxMtWr2ChGAIdDz0LjOU2r1ojlTijMzcfrx05HSwS
         k16DFcAdz4vxQsgWwA3olMX3790t0yyJWZqjEDSgzOMpZL6UyqojZ3nyZZa4ObFH+G
         THl3CYW5PB+pvzxlV7SNvlPaDbTcRoVX8PliV1oblaaZNZ1+5TuTL5qs4ywDzHbrM6
         gk3NFRJbktjbZIzzLauopOhgSs+srjEpa1mFOkrbZgOaB7/lSMHubCZLjBlSoPLz1/
         syEp5ZpGWKMPqGSbu8iMPiHIAEjLcZxU66VptGF4PVvuFDq7lAM0ThzlU3uvZHJnla
         npwXV0MTOMNrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ayala.barazani@intel.com,
        harish.mitty@intel.com, matt.chen@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 106/217] iwlwifi: acpi: fix wgds rev 3 size
Date:   Mon, 17 Jan 2022 21:17:49 -0500
Message-Id: <20220118021940.1942199-106-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit dc276ffd0754e94080565c10b964f3c211879fdd ]

The exact size of WGDS revision 3 was calculated using the wrong
parameters. Fix it.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211204130722.12c5b0cffe52.I7f342502f628f43a7e000189a699484bcef0f562@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index bf431fa4fe81f..2e4590876bc33 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -789,7 +789,7 @@ int iwl_sar_get_wgds_table(struct iwl_fw_runtime *fwrt)
 				 * looking up in ACPI
 				 */
 				if (wifi_pkg->package.count !=
-				    min_size + profile_size * num_profiles) {
+				    hdr_size + profile_size * num_profiles) {
 					ret = -EINVAL;
 					goto out_free;
 				}
-- 
2.34.1

