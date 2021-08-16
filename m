Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CACB3ED19F
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhHPKJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhHPKJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:09:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C91D61B2E;
        Mon, 16 Aug 2021 10:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629108511;
        bh=ixj7Ews16X7qrEZhfOBYKxfWDow/6fUwCfpnAvB/nnU=;
        h=From:To:Cc:Subject:Date:From;
        b=OeKnwps7f4egPVZkL2Ekyw42qJhwgK9kXkihlPxy69hpsTA03tL/9AuhQUuS8yiS5
         o0ofgwaPIm7hZVFrUEr9TzGir8QlmnxxQ0u/ut1m0H6h/3d4sMgmJPfSev+RZtX/8B
         lQm5UVAFGMqIrVsiJD+XYSCsivj37SFhGjfr5JZ0Q60Ifeal0ILk/wgaT9rA6VdoAL
         2MoW9wYg8va0Q5ZTmBGYok0YfjJdIpIZhOVj1U7BFwn3SCucnmHVlyqO+Ji4CahaV6
         E2GFzFO8+0MiCopU5CvvWbfBunKtegN7OinmLzDla9EdSmIXzvOUnCowP9IrGlx/w5
         x7ful7sM3bb6Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH net-next] bonding: improve nl error msg when device can't be enslaved because of IFF_MASTER
Date:   Mon, 16 Aug 2021 12:08:28 +0200
Message-Id: <20210816100828.29252-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a more user friendly netlink error message when a device can't be
enslaved because it has IFF_MASTER, by not referring directly to a
kernel internal flag.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 04158a8368e4..b0966e733926 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1759,7 +1759,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	if (slave_dev->flags & IFF_MASTER &&
 	    !netif_is_bond_master(slave_dev)) {
 		BOND_NL_ERR(bond_dev, extack,
-			    "Device with IFF_MASTER cannot be enslaved");
+			    "Device type (master device) cannot be enslaved");
 		return -EPERM;
 	}
 
-- 
2.31.1

