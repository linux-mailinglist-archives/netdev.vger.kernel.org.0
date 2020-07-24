Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C0522C4F4
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 14:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgGXMSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 08:18:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34735 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGXMSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 08:18:05 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jywe9-0000NI-Od; Fri, 24 Jul 2020 12:17:53 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sctp: remove redundant initialization of variable status
Date:   Fri, 24 Jul 2020 13:17:53 +0100
Message-Id: <20200724121753.16721-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable status is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/sctp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 7ecaf7d575c0..a0448f7c64b9 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1368,7 +1368,7 @@ static struct pernet_operations sctp_ctrlsock_ops = {
 static __init int sctp_init(void)
 {
 	int i;
-	int status = -EINVAL;
+	int status;
 	unsigned long goal;
 	unsigned long limit;
 	unsigned long nr_pages = totalram_pages();
-- 
2.27.0

