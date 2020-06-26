Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A5F20B488
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgFZP3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFZP3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 11:29:45 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE7E7207E8;
        Fri, 26 Jun 2020 15:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593185384;
        bh=zXjG44VNS3z0g6/r9OQ45OaHncYIm/HWnlomXgb0td4=;
        h=From:To:Cc:Subject:Date:From;
        b=jwz6I1HZkH/aTM1g3LDJ+AHjiTXYI38VupkBjQwvQZqebkUAguYylrVaTlYZTiK5w
         fsaLM+YWeysCXxgUZi73Rr4dPoXgHM5gWtJlUnwbuz7pcogd5/FNQcePXQmmTq00NI
         d5I3wUED54W/zXIyxPK9d8kyBNRKhl+u1td3TPXg=
Received: by pali.im (Postfix)
        id 9A82C890; Fri, 26 Jun 2020 17:29:42 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: Use macro MWIFIEX_MAX_BSS_NUM for specifying limit of interfaces
Date:   Fri, 26 Jun 2020 17:29:38 +0200
Message-Id: <20200626152938.12737-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This macro is already used in mwifiex driver for specifying upper limit and
is defined to value 3. So use it also in struct ieee80211_iface_limit.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 4e4f59c17ded..867b5cf385a8 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -27,7 +27,8 @@ module_param(reg_alpha2, charp, 0);
 
 static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
 	{
-		.max = 3, .types = BIT(NL80211_IFTYPE_STATION) |
+		.max = MWIFIEX_MAX_BSS_NUM,
+		.types = BIT(NL80211_IFTYPE_STATION) |
 				   BIT(NL80211_IFTYPE_P2P_GO) |
 				   BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				   BIT(NL80211_IFTYPE_AP),
-- 
2.20.1

