Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F009E704
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfH0Lrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:47:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33834 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfH0Lrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 07:47:43 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i2Zwp-0003U7-GT; Tue, 27 Aug 2019 11:47:39 +0000
From:   Colin King <colin.king@canonical.com>
To:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wimax/i2400m: remove redundant assignment to variable result
Date:   Tue, 27 Aug 2019 12:47:39 +0100
Message-Id: <20190827114739.27305-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable result is being assigned a value that is never read and result
is being re-assigned a little later on. The assignment is redundant
and hence can be removed.

Addresses-Coverity: ("Ununsed value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wimax/i2400m/rx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
index d28b96d06919..c9fb619a9e01 100644
--- a/drivers/net/wimax/i2400m/rx.c
+++ b/drivers/net/wimax/i2400m/rx.c
@@ -1253,7 +1253,6 @@ int i2400m_rx(struct i2400m *i2400m, struct sk_buff *skb)
 	skb_len = skb->len;
 	d_fnstart(4, dev, "(i2400m %p skb %p [size %u])\n",
 		  i2400m, skb, skb_len);
-	result = -EIO;
 	msg_hdr = (void *) skb->data;
 	result = i2400m_rx_msg_hdr_check(i2400m, msg_hdr, skb_len);
 	if (result < 0)
-- 
2.20.1

