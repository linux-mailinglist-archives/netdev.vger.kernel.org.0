Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1642BB3D8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbgKTSiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730382AbgKTSir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:38:47 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AFD021D91;
        Fri, 20 Nov 2020 18:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897527;
        bh=P1ptSY1ouxyzCTWuiOpQ/Q3ASw9Fh/CWMBpT5t1VG+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PQO3FY1myXuZxR2tj29dPvCGI2yG2TamQRjlvvQQZ2/YZTT/x6a4Kqnoen6yWzTjq
         oPUNygKm5nTaaJCJPmjW7usuTY4cX15XlhqQq44kZuwGKyaeTx+9W5hAF1DYWf1Auc
         dFioq8oGi5Hs6v2bkuICu0dkQWWrLfONnuncuYMk=
Date:   Fri, 20 Nov 2020 12:38:52 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 116/141] rt2x00: Fix fall-through warnings for Clang
Message-ID: <b0d4c50b803bc38ed370521b9b0a44365cae9386.1605896060.git.gustavoars@kernel.org>
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
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 3b6100e6c8f6..d4d389e8f1b4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -941,6 +941,7 @@ void rt2x00queue_unpause_queue(struct data_queue *queue)
 		 * receive frames.
 		 */
 		queue->rt2x00dev->ops->lib->kick_queue(queue);
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

