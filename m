Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BAD1A0311
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgDGAGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgDGACS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51400208E4;
        Tue,  7 Apr 2020 00:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217738;
        bh=iryEKzf2hO9H4jsbyGgbgdA/v/MMTMlVjJvsGOanEFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpKPTJzckpj6IZBkaldR7BsmGdws1LXufMNNEEq7US9dQRutgVlJmPxHXMRZFI9BQ
         0PUFZIkuOiU2swhnTo9xOvrp/9FIGTzaz+iG+ZM0XHgqiqiPVFtF4GvrC6zhXmNxCs
         9jgyoaaPcIw2+nMXtNwgsH6ODgBT1ahRP/iNn0+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo bin <luobin9@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/32] hinic: fix wrong value of MIN_SKB_LEN
Date:   Mon,  6 Apr 2020 20:01:39 -0400
Message-Id: <20200407000151.16768-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 7296695fc16dd1761dbba8b68a9181c71cef0633 ]

the minimum value of skb len that hw supports is 32 rather than 17

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 375d81d03e866..365016450bdbe 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -45,7 +45,7 @@
 
 #define HW_CONS_IDX(sq)                 be16_to_cpu(*(u16 *)((sq)->hw_ci_addr))
 
-#define MIN_SKB_LEN                     17
+#define MIN_SKB_LEN			32
 
 #define	MAX_PAYLOAD_OFFSET	        221
 #define TRANSPORT_OFFSET(l4_hdr, skb)	((u32)((l4_hdr) - (skb)->data))
-- 
2.20.1

