Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6526407765
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbhIKNRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236095AbhIKNPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:15:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39BA761153;
        Sat, 11 Sep 2021 13:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365983;
        bh=BP4d9d4bjOOYFK7CSlAnWJ5oSIt8LhI/0CCz34oz1K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYwncPe2l7VA/zk7BnyoVRqHWgTdj301BNfEz1q7G6+iaA+GWHIMVuuhPlYMCYzGm
         6SiThh+x4iOozkKz5kRUPOxUZe7UYJaqMDqs5EFPIIarvok3Rdqgo1wJKFzIxwFAUK
         631llq2LiL3qpXVa4LKr6yI+poJP7j8RIgGVSWnVMv+o+2J0PXYKPvnOzvLuanB6pe
         vreDHJkOYTmVkEzygcxGOTqKS3qp7i31jU1PfZCejmS4e23yIgGYfHKatxUWWOVefT
         cEHqy1s6CDCJjkL70O4EP9hk8gdtT26vfgWcArPYvCDD2NTpkYGglx4/2TgFm7jep7
         lcTmPuzsjEpmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 23/29] net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920
Date:   Sat, 11 Sep 2021 09:12:27 -0400
Message-Id: <20210911131233.284800-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131233.284800-1-sashal@kernel.org>
References: <20210911131233.284800-1-sashal@kernel.org>
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
index 5db66272fc82..ec3a97e079fc 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -653,6 +653,11 @@ static const struct usb_device_id mbim_devs[] = {
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

