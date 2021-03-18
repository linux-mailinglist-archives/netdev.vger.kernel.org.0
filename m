Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D183340984
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhCRQCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231648AbhCRQBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 12:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6047364E37;
        Thu, 18 Mar 2021 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616083292;
        bh=8ZlNeGVIC5iDIYpch4tok8Iud0RoY50Apo5qJ3GO4FA=;
        h=From:To:Cc:Subject:Date:From;
        b=EWoXqqN2y8LjEXl/uKzGgC5baeknNblv0OkEGxd/iWoEXKwSxQaxZYvA+NjGCo8B5
         az/COz72aWunC3ek8oGCbCI6pmhHdFC19WpLMKb4N13F28VT922Z5pWqn7IsJeLCXe
         ZrhpoPIslpIcahgnpWn4BSq4+vT7t52jysS+79a05Ee8E+yAnYCgNgpbbcVN/xf66A
         rQuA+vR494BDWTYuRQRHxo97hmFj+t0CLGYJ87gF7hpvqSazUS2IUOlJjN1hOr9C+d
         angl5UOYZ6mZP2sSmQ+OrmgXkQFhC/+KIwrRevdyA8FS7QQY5NImmJjVM7N8iQT1gr
         VgOO58Mw6qnlQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lMv5q-0008Hf-Hj; Thu, 18 Mar 2021 17:01:50 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH net-next] net: cdc_ncm: drop redundant driver-data assignment
Date:   Thu, 18 Mar 2021 17:01:42 +0100
Message-Id: <20210318160142.31801-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver data for the data interface has already been set by
usb_driver_claim_interface() so drop the subsequent redundant
assignment.

Note that this also avoids setting the driver data three times in case
of a combined interface.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 8acf30115428..8ae565a801b5 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -920,7 +920,6 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 		goto error2;
 	}
 
-	usb_set_intfdata(ctx->data, dev);
 	usb_set_intfdata(ctx->control, dev);
 
 	if (ctx->ether_desc) {
-- 
2.26.2

