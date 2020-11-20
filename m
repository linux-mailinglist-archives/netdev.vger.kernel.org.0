Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34E72BB375
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgKTSeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729952AbgKTSee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:34:34 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D0222470;
        Fri, 20 Nov 2020 18:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897274;
        bh=pNUFEE16O9q1lV79zGxWuVcJGvY5m6bMjPJFWzou+m8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1qAYtGR0yoZVgzXkrY8ihvySutVvfR0l/auGAHC69QBHKGTs1eRqubAV3V4yh3uc5
         XfKrnN90Y0I9sTLO+QaUEl3sEmV44k6cEJSMocI6ap6+2Ej3b0RRFyYeZ15PUFY5kM
         WJFfzbTXZPyBjOSqqlVTDJtvxR0dJKLoRPqObw04=
Date:   Fri, 20 Nov 2020 12:34:40 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 072/141] can: peak_usb: Fix fall-through warnings for Clang
Message-ID: <aab7cf16bf43cc7c3e9c9930d2dae850c1d07a3c.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index c2764799f9ef..fd65a155be3b 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -299,6 +299,8 @@ static void peak_usb_write_bulk_callback(struct urb *urb)
 		if (net_ratelimit())
 			netdev_err(netdev, "Tx urb aborted (%d)\n",
 				   urb->status);
+		break;
+
 	case -EPROTO:
 	case -ENOENT:
 	case -ECONNRESET:
-- 
2.27.0

