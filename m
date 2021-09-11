Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF3040780C
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbhIKNWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236927AbhIKNUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C9736139D;
        Sat, 11 Sep 2021 13:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366060;
        bh=hy3UwUA+8vvNry4bzehpyJHT56yOSvMuXzICl7nOmF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfGtI5kwJqfoM9fDWG6ZMBi0gRou3oUllX3awHqUcp4z1EmfWDyCPSltGfn2BXOwX
         vEWNJ2+O0VrZcuGH18lfeipdRYWnOGoPPGCSNaBqI0Q4DomP9mSRlxuzjLxBrHrdsQ
         lGFPHabgVrrzNYXJH/PxAWU2BIFKWHi36ISnpeDoUQqUQVP/aRq6W+xkiJxhfZd2Z1
         15cZkJT2bF7UkUpeTBjLWaiWDOILrlTLfLX9J7Rej0V3G57BR0w8RfREQyd2iW2CUI
         WIaSuVFevxqESCaApq9Rkn6OEZBgL97aIHE/TqQBXret3I6c/TG5In32PCfbqX+2J+
         yQHn67tZWOg9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/5] net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920
Date:   Sat, 11 Sep 2021 09:14:13 -0400
Message-Id: <20210911131415.286125-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131415.286125-1-sashal@kernel.org>
References: <20210911131415.286125-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit aabbdc67f3485b5db27ab4eba01e5fbf1ffea62c ]

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit LN920
0x1061 composition in order to avoid bind error.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 0362acd5cdca..cdd1b193fd4f 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -655,6 +655,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit LN920 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1061, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.30.2

