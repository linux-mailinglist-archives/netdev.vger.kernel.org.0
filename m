Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3065417ABC7
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgCERPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgCERPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:15:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D23217F4;
        Thu,  5 Mar 2020 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428552;
        bh=mwst+dBFMWQvD2GtYzncPLfCVIHE0q3HaiZ5TbF0oAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1p33aI0IDhFrBrftyfXtug8/stUqCikbS/miVAlrotiQtaLlL2nR9Re13kehDDxTu
         Qj7mG04AH1MWvEn+y3Sxedu+6hRAdafXMR36/42uNKp8RTVX4l/pjnuLM+CuG+e+n6
         4yY06ecGW54aNbE6Wp82VmAuE9CoGGM02NPucT0U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/19] cfg80211: check reg_rule for NULL in handle_channel_custom()
Date:   Thu,  5 Mar 2020 12:15:30 -0500
Message-Id: <20200305171540.30250-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171540.30250-1-sashal@kernel.org>
References: <20200305171540.30250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a7ee7d44b57c9ae174088e53a668852b7f4f452d ]

We may end up with a NULL reg_rule after the loop in
handle_channel_custom() if the bandwidth didn't fit,
check if this is the case and bail out if so.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200221104449.3b558a50201c.I4ad3725c4dacaefd2d18d3cc65ba6d18acd5dbfe@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a520f433d4765..b95d1c2bdef7e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1733,7 +1733,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 			break;
 	}
 
-	if (IS_ERR(reg_rule)) {
+	if (IS_ERR_OR_NULL(reg_rule)) {
 		pr_debug("Disabling freq %d MHz as custom regd has no rule that fits it\n",
 			 chan->center_freq);
 		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
-- 
2.20.1

