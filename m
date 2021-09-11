Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9894077BB
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhIKNTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236954AbhIKNRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:17:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3B986128A;
        Sat, 11 Sep 2021 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366017;
        bh=ukr0NSEzMx/uOpOw9SiAfR/sjNSlvcmbajk1369DDW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+sCI/fPEm89eiBkN5Ex6oFxg/yy6yUk8QF6xa30UmB6iNIuNigk/SOPa8BpRryqW
         K8fjDcjAUlPbOVLCYwEPrYW0T77etKYp+m781N/PzpSqsI+vnz9gEn9W70iS4/lwO/
         wFi1AuA71FYyqhYMcAAZSfpcqgYWfgZeTj0eMDxHzu7KNbHU94bTO6qpvDtYBc6S8c
         LgfYeoZkPRCG+hFHa9BhNVESlMfWx+l/+IiUXquWhn0AdzV5ALBRkrSoNF68vw/VLD
         tk1x+D659PXi18wC6wr2E7oMmfv6EUKLEU4iJpEZMXtNuSRC31LVa0ENEu9dgKjFgT
         IxwmjWwtlfO6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/25] net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920
Date:   Sat, 11 Sep 2021 09:13:06 -0400
Message-Id: <20210911131312.285225-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
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
index eb100eb33de3..77ac5a721e7b 100644
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

