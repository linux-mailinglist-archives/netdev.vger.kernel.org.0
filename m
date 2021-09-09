Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B73540527B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353051AbhIIMno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354161AbhIIMg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC5961B95;
        Thu,  9 Sep 2021 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188450;
        bh=S/mYC2aZPFp2a9cuahC+9ncNQUxRy7at7ImfNz5LxPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSlTkQoU2TD/izlD8/hIs3+HA7f7k8nkHNExr5yY7yBKtUZ6SpIuJ5yGyIuVc0+VS
         hjH95yuynbidtYh9oQxhxZ91yLzxIg+8455bpZxll++h96flzZuXPnbbYgkVc8a3uh
         meVHSGTdE+KX1qqHTRcS131TM901558gbyFolTIN4JuIaabYzTMYmiBFjFPs3B3zcc
         NOjb1mI3zsM3CEzfgGK4lGnJGMVbSXqE7RMiD4BzNQ0TND03+r7QavAfTJckw2Ti3W
         geR23cOXGZd7elh50ONaH6cMYAaOB0F9s64i80wvXDtMMXXgWFPxr6ZJFDh8LrvGQg
         oU4hjbWyRt0WQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        kernel test robot <lkp@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 133/176] rtw88: wow: build wow function only if CONFIG_PM is on
Date:   Thu,  9 Sep 2021 07:50:35 -0400
Message-Id: <20210909115118.146181-133-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 05e45887382c4c0f9522515759b34991aa17e69d ]

The kernel test robot reports undefined reference after we report wakeup
reason to mac80211. This is because CONFIG_PM is not defined in the testing
configuration file. In fact, functions within wow.c are used if CONFIG_PM
is defined, so use CONFIG_PM to decide whether we build this file or not.

The reported messages are:
   hppa-linux-ld: drivers/net/wireless/realtek/rtw88/wow.o: in function `rtw_wow_show_wakeup_reason':
>> (.text+0x6c4): undefined reference to `ieee80211_report_wowlan_wakeup'
>> hppa-linux-ld: (.text+0x6e0): undefined reference to `ieee80211_report_wowlan_wakeup'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210728014335.8785-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index c0e4b111c8b4..73d6807a8cdf 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -15,9 +15,9 @@ rtw88_core-y += main.o \
 	   ps.o \
 	   sec.o \
 	   bf.o \
-	   wow.o \
 	   regd.o
 
+rtw88_core-$(CONFIG_PM) += wow.o
 
 obj-$(CONFIG_RTW88_8822B)	+= rtw88_8822b.o
 rtw88_8822b-objs		:= rtw8822b.o rtw8822b_table.o
-- 
2.30.2

