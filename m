Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D304742F6F6
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 17:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240952AbhJOPXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 11:23:22 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:54156
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232267AbhJOPXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 11:23:22 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 292F23FFE2;
        Fri, 15 Oct 2021 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634311274;
        bh=NwvPoa2VhDuRpmSjf2vzHYXMiqvdYBCWvFv62Vu1wJE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=dNCpLuocZL5UVcoNz/WxHnpq4p7Ofb4aBRgcm2ary8rlqtcbCO4gfsOkG0Ww4Wvby
         vitmT0iKgUFJnuQnre8khHE88fxc+l31Dut5giNXnHCXyZWNmhPp7QoCJhMvr8iKhs
         dDlAiS8Wq0j1cLdp+xHjEylDwMGP4PYSSHFGNWfZNM9Ocu13DUWXKt8KzkIpqBQUDb
         k/xoHtKwKtFGjuRvPmmzCQDwRO7no9QoF5egnnDmIbQDVivZkd3fOvlw3Z5OCoEBGO
         pwIVPjwbqExJf3zsuNTudFxOHGacWECNlHtcwsmu5WnlwR5VrkQuUSwgkbY8TVrW98
         O+EQeAeHENRMQ==
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtw89: Remove redundant check of ret after call to rtw89_mac_enable_bb_rf
Date:   Fri, 15 Oct 2021 16:21:13 +0100
Message-Id: <20211015152113.33179-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The function rtw89_mac_enable_bb_rf is a void return type, so there is
no return error code to ret, so the following check for an error in ret
is redundant dead code and can be removed.

Addresses-Coverity: ("Logically dead code")
Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 0171a5a7b1de..69384c43c046 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -2656,8 +2656,6 @@ int rtw89_mac_init(struct rtw89_dev *rtwdev)
 		goto fail;
 
 	rtw89_mac_enable_bb_rf(rtwdev);
-	if (ret)
-		goto fail;
 
 	ret = rtw89_mac_sys_init(rtwdev);
 	if (ret)
-- 
2.32.0

