Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A302F374213
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhEEQn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235382AbhEEQlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445D261463;
        Wed,  5 May 2021 16:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232478;
        bh=AavGADOsZ2avaRn0K1KqrtaIz1J3axuxe+z8UCtXzOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R35jfxBecrp2T2D3uXJosmsj44xS+AHxxXhhh3UlkMXHk9U8zI3lYPzEAwe02ljau
         roS+PgELePzeTgVrJieZU9a2eMqMPmrK2eNDE8YYysDJ7l4hTbm28aLyNDtwNYhf+j
         3ObfRhAtu44dGvcQjJDY6qU4kBzccmwRhM7EybHA/ZNMXMLKgOn70G0T0lV1MzJKFK
         lb4x6kayLZlwojCfrJYRP/58J1Nhh5Kszg8+kbLEhAHugRBaC0UqFJnX/u6/tHiUfY
         iYuCqW3jqiBD9TmB4DnFQM3TKORPdJ5Skeri8BAuE8V1EGfn8leuFnRcE5z5aVC8eX
         yP/qfRIHoxmKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ayush Garg <ayush.garg@samsung.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 017/104] Bluetooth: Fix incorrect status handling in LE PHY UPDATE event
Date:   Wed,  5 May 2021 12:32:46 -0400
Message-Id: <20210505163413.3461611-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ayush Garg <ayush.garg@samsung.com>

[ Upstream commit 87df8bcccd2cede62dfb97dc3d4ca1fe66cb4f83 ]

Skip updation of tx and rx PHYs values, when PHY Update
event's status is not successful.

Signed-off-by: Ayush Garg <ayush.garg@samsung.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 67668be3461e..b3872c7a64e1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5911,7 +5911,7 @@ static void hci_le_phy_update_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
-	if (!ev->status)
+	if (ev->status)
 		return;
 
 	hci_dev_lock(hdev);
-- 
2.30.2

