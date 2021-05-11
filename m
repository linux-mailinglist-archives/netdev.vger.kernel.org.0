Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E5437A6FA
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhEKMpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:45:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231285AbhEKMpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3oO6HrlHIr+fd9g4x6LVUUxxpjFRVlenNFNXGfb7eCQ=; b=uLj4lhkppsuY6RZsYD2NAaHnyS
        qJ700YwfZg98xbVlvPzvhGNH7qQPZ/KYUHQgaKazFForpxTqD4BAE+JPFGsIwdSFIPS23uin8krXx
        bVsWW08dbF2MsWF7naIL4b1ypkXi8Ay1BzIdQeJ1SfBJXQQiwwd8HGwOXhUAKjYNijOk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRjx-003jzN-3Y; Tue, 11 May 2021 14:43:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, thunder.leizhen@huawei.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] net: forcedeth: Give bot handlers a helping hand understanding the code
Date:   Tue, 11 May 2021 14:43:30 +0200
Message-Id: <20210511124330.891694-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bots handlers repeatedly fail to understand nv_update_linkspeed() and
submit patches unoptimizing it for the human reader. Add a comment to
try to prevent this in the future.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 8724d6a9ed02..0822b28f3b6a 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3475,6 +3475,9 @@ static int nv_update_linkspeed(struct net_device *dev)
 		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
 		newdup = 0;
 	} else {
+		/* Default to the same as 10/Half if we cannot
+		 * determine anything else.
+		 */
 		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
 		newdup = 0;
 	}
-- 
2.31.1

