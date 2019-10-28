Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D36E6CCC
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 08:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732427AbfJ1HTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 03:19:34 -0400
Received: from gateway23.websitewelcome.com ([192.185.48.71]:24113 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730751AbfJ1HTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 03:19:34 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 82F4C54F9
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 01:56:36 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id OyxAiPXsLOdBHOyxAiiMjd; Mon, 28 Oct 2019 01:56:36 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oCTskRlbgqD+J7aWayjsVtQZcA0SIwA4npc4QiguN5o=; b=xWHIGGQZ1Iab0c2jpYjZZ0O1Oy
        idQhgFCv+VHyiZt9qhZtSPdqDV6XWoIjQ9LD9elLoup1AYbW8Td72bRF5lr0kkTihUp9DFdPudO0w
        KilHebfPbteyYM7s9JyCgKXe6/ElNoP+cG7dRzqIL1av6S0RlGiwAw9u/tNY93aU9rsixr8gzgC58
        d9XboNFx4FZBVoAi7BKsnMhiX1fqZqBhQf0s5TLXo0rPGmRIKAWt/7DM9p3HQu3YiVKUoXYUiW4V9
        ZNmCDkfOgd5NUgYkoeyuMfUpp9/IE/PiVxJiM1ix1ElIS4MotV1xg2ioyWlJqbnSE88n/uPSbEkS2
        cPVkDtwA==;
Received: from [187.192.2.30] (port=58438 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1iOyx9-0040bs-6Y; Mon, 28 Oct 2019 01:56:35 -0500
Date:   Mon, 28 Oct 2019 01:56:33 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>,
        Nikita Danilov <nikita.danilov@aquantia.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net: aquantia: fix error handling in aq_nic_init
Message-ID: <20191028065633.GA2412@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.2.30
X-Source-L: No
X-Exim-ID: 1iOyx9-0040bs-6Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.2.30]:58438
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix currenty ignored returned error by properly error checking
aq_phy_init().

Addresses-Coverity-ID: 1487376 ("Unused value")
Fixes: dbcd6806af42 ("net: aquantia: add support for Phy access")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 433adc099e44..1914aa0a19d0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -341,7 +341,8 @@ int aq_nic_init(struct aq_nic_s *self)
 
 	if (self->aq_nic_cfg.aq_hw_caps->media_type == AQ_HW_MEDIA_TYPE_TP) {
 		self->aq_hw->phy_id = HW_ATL_PHY_ID_MAX;
-		err = aq_phy_init(self->aq_hw);
+		if (!aq_phy_init(self->aq_hw))
+			goto err_exit;
 	}
 
 	for (i = 0U, aq_vec = self->aq_vec[0];
-- 
2.23.0

