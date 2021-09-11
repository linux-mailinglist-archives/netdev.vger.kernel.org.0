Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44917407812
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbhIKNWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236968AbhIKNUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1141861247;
        Sat, 11 Sep 2021 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366067;
        bh=+pym0QwsC8Fviq7aC3T+wd9qCQclUcQD/hEuj45WaZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzuNiK022Zu0SR9EoDjSSB9L3frJe2dAN9JCDxoT/nv2i5ko/sBck2t98IEmIS1vp
         8B41iu9sQEi/ygn3vo8dDNB1fvzo8lyUDTkKyErElH4rRV9LvXttMTxOX5QcR5qZ9k
         t4jnxwvXEkSOnqyBqG1hXgKkMmvJ1RHrXGOhoCmuT5sLzazMuWF9NnkrvbX6OlgG59
         pi/5yZi4OhIbMfgS0PX8nTg/xkmLsF8sG8Bhv9oAuhHHtoGdn85vz68iIjd5GhYFSc
         NAjqs9qzEB93fGWUI8jgp+3XHh/k6qTzsKq3emQiBiUaHlRJ9zIi+Jnbu7s5CQBS/E
         h6mEeE9R8vedQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/4] net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920
Date:   Sat, 11 Sep 2021 09:14:21 -0400
Message-Id: <20210911131423.286235-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131423.286235-1-sashal@kernel.org>
References: <20210911131423.286235-1-sashal@kernel.org>
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
index 4c8baba72933..d86132d41416 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -647,6 +647,11 @@ static const struct usb_device_id mbim_devs[] = {
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

