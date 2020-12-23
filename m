Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C2B2E15F1
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731377AbgLWCzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728732AbgLWCVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D22B62332A;
        Wed, 23 Dec 2020 02:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690043;
        bh=Gp5oOfq/sx0oqF5yzsU2b7+d+TCyB/NgCjCFcI7BL70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/62OfGLbqYMH/SBJmc/XLwDq52c/6IMyGg4MSAF5NWO96lilsW2wO/c82T7umFT9
         JMqYn56xKGjrltu8WVRadEAGaDXx0zyP+p6JEPJdPxhGoy0zccsIHU0Up32V/kJD4K
         EyKy9r3+H06iDPd9NMrmMB12JyW5D32NCoqy0GIT2MxFj1QqPLOCpNTniNqEEeetfc
         BqWAg/0ir0IBigkZQOABqiWsWSfK1Va6+wrgaZ8t34oDM91krkzvfkoA7sT+jXQU5X
         M1bl0x8+U8YR0/p+fyReSV9aMm9mliNOLO8YydqZcNeXm6a1XPCCb2X72SaLRHpU4O
         OfT/HV+sr7lxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 116/130] cfg80211: Update TSF and TSF BSSID for multi BSS
Date:   Tue, 22 Dec 2020 21:17:59 -0500
Message-Id: <20201223021813.2791612-116-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit b45a19dd7e46462d0f34fcc05e5b1871d4c415ec ]

When a new BSS entry is created based on multi BSS IE, the
TSF and the TSF BSSID were not updated. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201129172929.8377d5063827.I6f2011b6017c2ad507c61a3f1ca03b7177a46e32@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 328402ab64a3f..a86721f5c0a26 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1396,6 +1396,9 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	tmp.pub.beacon_interval = beacon_interval;
 	tmp.pub.capability = capability;
 	tmp.ts_boottime = data->boottime_ns;
+	tmp.parent_tsf = data->parent_tsf;
+	ether_addr_copy(tmp.parent_bssid, data->parent_bssid);
+
 	if (non_tx_data) {
 		tmp.pub.transmitted_bss = non_tx_data->tx_bss;
 		ts = bss_from_pub(non_tx_data->tx_bss)->ts;
-- 
2.27.0

