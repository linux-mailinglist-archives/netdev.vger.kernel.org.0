Return-Path: <netdev+bounces-360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7266F7425
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4BA81C21385
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001E8C12A;
	Thu,  4 May 2023 19:43:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AD1F4ED
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118F5C4339B;
	Thu,  4 May 2023 19:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229416;
	bh=MJS4dzAVZY1D72hkrMes3j6B2EDrslbNlLubS/o/zaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLlQjG263BsbE6scllCxPBc+WPhqR6fw9OU5nUVmQH6+tSJLNj+Hnj34dkZjyy+Ag
	 ZDuq2/OTKoFecYEIIuT9fiQjx1wzarJbT4e/FY0J3pUMzQvQseZutHcp/j8haNRkGu
	 xhbH4v/9RhzFSgkf/oprxrZX2wldcDJUY7THDr5fglcicNDBoZ7gYjoB+j1fN1NuTZ
	 WoZizABj6LFktxYIr9N+DvS7MgfBhANGzzBo3kjjkMId+EkJhS6hQVQfijWbXMYD62
	 50hdYhPfHoRMhgsMEPkUsNs3P+F9P5DyQA04stEc3Ya+1TZhnl+VvsXpg6UIrzQbHR
	 JOYW8SibsbRkg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Reese Russell <git@qrsnap.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	matthias.bgg@gmail.com,
	sean.wang@mediatek.com,
	deren.wu@mediatek.com,
	sridhar.samudrala@intel.com,
	gch981213@gmail.com,
	greearb@candelatech.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.3 41/59] wifi: mt76: mt7921: add Netgear AXE3000 (A8000) support
Date: Thu,  4 May 2023 15:41:24 -0400
Message-Id: <20230504194142.3805425-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Reese Russell <git@qrsnap.io>

[ Upstream commit 03eb52dd78cab08f13925aeec8315fbdbcba3253 ]

Issue: Though the Netgear AXE3000 (A8000) is based on the mt7921
chipset because of the unique USB VID:PID combination this device
does not initialize/register. Thus making it not plug and play.

Fix: Adds support for the Netgear AXE3000 (A8000) based on the Mediatek
mt7921au chipset. The method of action is adding the USD VID/PID
pair to the mt7921u_device_table[] array.

Notes: A retail sample of the Netgear AXE3000 (A8000) yeilds the following
from lsusb D 0846:9060 NetGear, Inc. Wireless_Device. This pair
0846:9060 VID:PID has been reported by other users on Github.

Signed-off-by: Reese Russell <git@qrsnap.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index 8fef09ed29c91..a95ec388653c5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -18,6 +18,9 @@ static const struct usb_device_id mt7921u_device_table[] = {
 	/* Comfast CF-952AX */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3574, 0x6211, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
+	/* Netgear, Inc. [A8000,AXE3000] */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9060, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
 	{ },
 };
 
-- 
2.39.2


