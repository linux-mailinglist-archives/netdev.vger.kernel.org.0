Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F9F2019D7
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 19:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbgFSR41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 13:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391253AbgFSR4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 13:56:25 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBEAA20776;
        Fri, 19 Jun 2020 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592589385;
        bh=SBYulPuDZybIxI1JcS3h+aJtlYogWO1Z61bGFGfjzVk=;
        h=Date:From:To:Cc:Subject:From;
        b=MWg9vX70Vo/xjh7nTRyaioJm0lcT3zBZmEJysYbEY6GE3tH3dBTqcaTOPAN/fHPlV
         n+8EkK89P6V1ND4DkUYKiBpI1IOW1us0edAp3BGGpHWoDqCh9fulIRIsdQZtaIDjP9
         vlhStnqIBvBJHus59C9BjeJkAly85Npdd0K2vyLM=
Date:   Fri, 19 Jun 2020 13:01:49 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] cxgb4: Use struct_size() helper
Message-ID: <20200619180149.GA29621@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 1359158652b7..b3da3d05aa2d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2431,7 +2431,7 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 	struct sk_buff *skb;
 	int ret = 0;
 
-	len = sizeof(*flowc) + sizeof(struct fw_flowc_mnemval) * nparams;
+	len = struct_size(flowc, mnemval, nparams);
 	len16 = DIV_ROUND_UP(len, 16);
 
 	entry = cxgb4_lookup_eotid(&adap->tids, eotid);
-- 
2.27.0

