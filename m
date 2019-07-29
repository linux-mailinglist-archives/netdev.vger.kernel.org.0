Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04B799E6
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfG2U0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:26:15 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.147]:33314 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfG2U0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:26:14 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id B3CFC400C2EF5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 15:01:41 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id sBq1hGv5qdnCesBq1hkHFX; Mon, 29 Jul 2019 15:01:41 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8IG03zJ4dGQM2zbEUf5K8f+GqYdtT4wDuV0aUuJyIEc=; b=h3AQ9EvojkPpBuTQyEEMrXpXZq
        nSPz/PMP8BOP/Gkpovpf4ecOi0Bgk1Nj5vZeZuBCjFi7MHcr8mrCsTfHJtd6xdHjqwmCv/2Vtauqa
        OZ//RWt45ZLleJ711Q0j3wzO75rler0Spa/gO0E1YCVNVtiImHsDaFqUby2/WfTdQZl68xzDsE5Xu
        0T6Y4kiSO98nkftvORk+VbjLpfg0oEYNZZPMPpZHe7COxSx95ZGsKvvyEuFf536pc3khda2KjBwe9
        vV0xJFcJCOokYnV+JNKOahJIvEUkJ9RGdHY4zg0Dk9CNfxeah9RUVHS7yGdWmSNd/C33YeA7xswHQ
        aYERSh3Q==;
Received: from [187.192.11.120] (port=59520 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hsBq0-000tYi-Gi; Mon, 29 Jul 2019 15:01:40 -0500
Date:   Mon, 29 Jul 2019 15:01:39 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] net: wan: sdla: Mark expected switch fall-through
Message-ID: <20190729200139.GA6102@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.11.120
X-Source-L: No
X-Exim-ID: 1hsBq0-000tYi-Gi
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:59520
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 2
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warning (Building: i386):

drivers/net/wan/sdla.c: In function ‘sdla_errors’:
drivers/net/wan/sdla.c:414:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
    if (cmd == SDLA_INFORMATION_WRITE)
       ^
drivers/net/wan/sdla.c:417:3: note: here
   default:
   ^~~~~~~

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wan/sdla.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index a9ac3f37b904..e2e679a01b65 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -413,6 +413,7 @@ static void sdla_errors(struct net_device *dev, int cmd, int dlci, int ret, int
 		case SDLA_RET_NO_BUFS:
 			if (cmd == SDLA_INFORMATION_WRITE)
 				break;
+			/* Else, fall through */
 
 		default: 
 			netdev_dbg(dev, "Cmd 0x%02X generated return code 0x%02X\n",
-- 
2.22.0

