Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E3257856
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfF0AeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfF0AeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:11 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E3B20659;
        Thu, 27 Jun 2019 00:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595650;
        bh=eSgky6/yNrdrE41y7JFt3bget9STqGFvqwTectngve0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUlNAEtic47zUiMnYQhhIKhXDyN26As2wIOj82RYJbew19/RtGVZZgwLXq2oGjI6o
         tNCm8pBX1vfbucg5/1Eir38n2/20yiznG5bwaTMqbj8PUvT9KcDCo08QThJPlcc4JK
         QVyleyiGg9wsXHDD/x/PRxesE/m3tz54i2BVIP9I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 67/95] cfg80211: report measurement start TSF correctly
Date:   Wed, 26 Jun 2019 20:29:52 -0400
Message-Id: <20190627003021.19867-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit b65842025335711e2a0259feb4dbadb0c9ffb6d9 ]

Instead of reporting the AP's TSF, host time was reported. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 5e2ab01d325c..d06d514f0bba 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  */
 #ifndef __PMSR_H
 #define __PMSR_H
@@ -446,7 +446,7 @@ static int nl80211_pmsr_send_result(struct sk_buff *msg,
 
 	if (res->ap_tsf_valid &&
 	    nla_put_u64_64bit(msg, NL80211_PMSR_RESP_ATTR_AP_TSF,
-			      res->host_time, NL80211_PMSR_RESP_ATTR_PAD))
+			      res->ap_tsf, NL80211_PMSR_RESP_ATTR_PAD))
 		goto error;
 
 	if (res->final && nla_put_flag(msg, NL80211_PMSR_RESP_ATTR_FINAL))
-- 
2.20.1

