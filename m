Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C7F1329F8
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgAGPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:24:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56356 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgAGPYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:24:21 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ioqiN-0003lQ-Tw; Tue, 07 Jan 2020 15:24:16 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/rose: remove redundant assignment to variable failed
Date:   Tue,  7 Jan 2020 15:24:15 +0000
Message-Id: <20200107152415.106353-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable failed is being assigned a value that is never read, the
following goto statement jumps to the end of the function and variable
failed is not referenced at all.  Remove the redundant assignment.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/rose/rose_route.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index c53307623236..5277631fa14c 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -696,7 +696,6 @@ struct rose_neigh *rose_get_neigh(rose_address *addr, unsigned char *cause,
 				for (i = 0; i < node->count; i++) {
 					if (!rose_ftimer_running(node->neighbour[i])) {
 						res = node->neighbour[i];
-						failed = 0;
 						goto out;
 					}
 					failed = 1;
-- 
2.24.0

