Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C99F88114
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 19:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437320AbfHIRWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 13:22:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39274 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfHIRWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 13:22:25 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hw8an-0008KU-Re; Fri, 09 Aug 2019 17:22:17 +0000
From:   Colin King <colin.king@canonical.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: remove redundant assignment to pointer hash
Date:   Fri,  9 Aug 2019 18:22:17 +0100
Message-Id: <20190809172217.1809-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer hash is being initialized with a value that is never read
and is being re-assigned a little later on. The assignment is
redundant and hence can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 8428be8b8d43..e3dd8623be4e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1468,7 +1468,6 @@ static int brcmf_msgbuf_stats_read(struct seq_file *seq, void *data)
 	seq_printf(seq, "\nh2d_flowrings: depth %u\n",
 		   BRCMF_H2D_TXFLOWRING_MAX_ITEM);
 	seq_puts(seq, "Active flowrings:\n");
-	hash = msgbuf->flow->hash;
 	for (i = 0; i < msgbuf->flow->nrofrings; i++) {
 		if (!msgbuf->flow->rings[i])
 			continue;
-- 
2.20.1

