Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F883028C
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfE3TEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:04:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54995 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3TEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:04:43 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hWQLu-0004Od-Lv; Thu, 30 May 2019 19:04:38 +0000
From:   Colin King <colin.king@canonical.com>
To:     Wei Liu <wei.liu2@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>,
        "David S . Miller" <davem@davemloft.net>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xen-netback: remove redundant assignment to err
Date:   Thu, 30 May 2019 20:04:38 +0100
Message-Id: <20190530190438.9571-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is assigned with the value -ENOMEM that is never
read and it is re-assigned a new value later on.  The assignment is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/xen-netback/interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 783198844dd7..240f762b3749 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -633,7 +633,7 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 			unsigned int rx_evtchn)
 {
 	struct task_struct *task;
-	int err = -ENOMEM;
+	int err;
 
 	BUG_ON(queue->tx_irq);
 	BUG_ON(queue->task);
-- 
2.20.1

