Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA35364AA1
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 21:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239355AbhDSTfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 15:35:54 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:47128 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234943AbhDSTfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 15:35:53 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d74 with ME
        id ujbK2400121Fzsu03jbKZD; Mon, 19 Apr 2021 21:35:21 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 19 Apr 2021 21:35:21 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] brcmfmac: Avoid GFP_ATOMIC when GFP_KERNEL is enough
Date:   Mon, 19 Apr 2021 21:35:17 +0200
Message-Id: <b6e619415db4ee5de95389280d7195bb56e45f77.1618860716.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A workqueue is not atomic, so constraints can be relaxed here.
GFP_KERNEL can be used instead of GFP_ATOMIC.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ea78fe527c5d..838b09b23abf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -151,7 +151,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	/* Send down the multicast list first. */
 	cnt = netdev_mc_count(ndev);
 	buflen = sizeof(cnt) + (cnt * ETH_ALEN);
-	buf = kmalloc(buflen, GFP_ATOMIC);
+	buf = kmalloc(buflen, GFP_KERNEL);
 	if (!buf)
 		return;
 	bufp = buf;
-- 
2.27.0

