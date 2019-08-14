Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18568C91E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfHNCgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbfHNCNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F89020844;
        Wed, 14 Aug 2019 02:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748785;
        bh=gHrlxgU92Gcc1Zi76YQDYAb8AuaLAwjaPwuJpyck8TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QM1+B1zHmKcQUf382NLZZHLWsshoENUUeoS+N59/O9aDIu3aYVYW5KL+g6oSThk/y
         uRbiyHRK/n6yxNWiPPN2XenYA1T2HHwE3A8SakXGzxliz0H2OyRKlyP7KI3pZJAVJd
         x+OIjz/j1jXnAXBjEajOa13RoMwlIYMpbwYL6POs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 064/123] iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef
Date:   Tue, 13 Aug 2019 22:09:48 -0400
Message-Id: <20190814021047.14828-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

[ Upstream commit abcbef5977df1fb61026ba429964cd6b9a085699 ]

The driver should call iwl_dbg_tlv_free even if debugfs is not defined
since ini mode does not depend on debugfs ifdef.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 68f6f492c4fa ("iwlwifi: trans: support loading ini TLVs from external file")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index efd4bf04d0162..fa81ad67539f3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1649,8 +1649,8 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 err_fw:
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	debugfs_remove_recursive(drv->dbgfs_drv);
-	iwl_fw_dbg_free(drv->trans);
 #endif
+	iwl_fw_dbg_free(drv->trans);
 	kfree(drv);
 err:
 	return ERR_PTR(ret);
-- 
2.20.1

