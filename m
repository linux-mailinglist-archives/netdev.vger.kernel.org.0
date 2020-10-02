Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565C8281E9E
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJBWr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJBWr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 18:47:27 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19EA1206C9;
        Fri,  2 Oct 2020 22:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601678846;
        bh=VtJgOLqz1ljDZRJ0+tvKp6/oomcXRGsEABPYY9e8m4k=;
        h=Date:From:To:Cc:Subject:From;
        b=KV0gQshzp3hCTERVt009h/VFNs8MUQubEGW8fY3BiNYF7lnsQJE+X4BqOcM6k4Cey
         E10i+dxlAGrJk5XKuHu8/GNyqSh84zfcqiKHTrTW0QK2UQ80Em/w+MaDYKcrYoRDfZ
         4ObPMjtwDlO8i76vZ66Idxl4aY+KqQttPdBllNLY=
Date:   Fri, 2 Oct 2020 17:53:15 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] usbnet: Use fallthrough pseudo-keyword
Message-ID: <20201002225315.GA1484@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace // FALLTHROUGH comment with the new pseudo-keyword macro
fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/usb/usbnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 2b2a841cd938..bf6c58240bd4 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -597,7 +597,7 @@ static void rx_complete (struct urb *urb)
 	case -EPIPE:
 		dev->net->stats.rx_errors++;
 		usbnet_defer_kevent (dev, EVENT_RX_HALT);
-		// FALLTHROUGH
+		fallthrough;
 
 	/* software-driven interface shutdown */
 	case -ECONNRESET:		/* async unlink */
-- 
2.27.0

