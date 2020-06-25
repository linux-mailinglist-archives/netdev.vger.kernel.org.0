Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D03F20A360
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406297AbgFYQwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404001AbgFYQwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 12:52:15 -0400
Received: from localhost (p54b332a0.dip0.t-ipconnect.de [84.179.50.160])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7020206BE;
        Thu, 25 Jun 2020 16:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593103935;
        bh=3IC/qxq+c3azNGHSnoz9SjkclgpX1yfKjOq4gbNl2cw=;
        h=From:To:Cc:Subject:Date:From;
        b=uaBmBng98knRwyN1mqjYqhvZ6pcsfMfXV4rpDqN0LaLuTBR6kcRFAooVnnn3qTPyc
         iTlNEMsX9bWCwaN7sP2a7qa3pJy7VFMqSGyT90l9XoueRnHkG3pQCodcZveXUbDSRC
         2+sN466a8GT0UWkyXHtEayRS+/fheo8XI28MVVdo=
From:   Wolfram Sang <wsa@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] iwlwifi: yoyo: don't print failure if debug firmware is missing
Date:   Thu, 25 Jun 2020 18:52:10 +0200
Message-Id: <20200625165210.14904-1-wsa@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Missing this firmware is not fatal, my wifi card still works. Even more,
I couldn't find any documentation what it is or where to get it. So, I
don't think the users should be notified if it is missing. If you browse
the net, you see the message is present is in quite some logs. Better
remove it.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
---

This is only build tested because I wanted to get your opinions first. I
couldn't find any explanation about yoyo, so I am entering unknown
territory here.

 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 7987a288917b..f180db2936e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -468,7 +468,7 @@ void iwl_dbg_tlv_load_bin(struct device *dev, struct iwl_trans *trans)
 	if (!iwlwifi_mod_params.enable_ini)
 		return;
 
-	res = request_firmware(&fw, "iwl-debug-yoyo.bin", dev);
+	res = firmware_request_nowarn(&fw, "iwl-debug-yoyo.bin", dev);
 	if (res)
 		return;
 
-- 
2.20.1

