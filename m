Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22712600BF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgIGQx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729884AbgIGQec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2067521D79;
        Mon,  7 Sep 2020 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496472;
        bh=evB8kI8CgM2XueBp2na5lhPEYi41PUqB/SbvXYg6MdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krzcFWCL8+5aheDpPY69pQrt8q+mWesTON6aDpg5ywL87OwBCZPhr2onjJAql+n7a
         s6U2sWQdrGDgm03WC4pgUx+Q65FudNf0PU3+CFd4He5U5VdnPc4B8n1upwp8D6H3Uo
         hOgFnWvajWqJRyxASXc0P71Ob6G/2QBaBVD94Dis=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/26] drivers/net/wan/lapbether: Added needed_tailroom
Date:   Mon,  7 Sep 2020 12:34:04 -0400
Message-Id: <20200907163426.1281284-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163426.1281284-1-sashal@kernel.org>
References: <20200907163426.1281284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 1ee39c1448c4e0d480c5b390e2db1987561fb5c2 ]

The underlying Ethernet device may request necessary tailroom to be
allocated by setting needed_tailroom. This driver should also set
needed_tailroom to request the tailroom needed by the underlying
Ethernet device to be allocated.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index c94dfa70f2a33..6b2553e893aca 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -343,6 +343,7 @@ static int lapbeth_new_device(struct net_device *dev)
 	 */
 	ndev->needed_headroom = -1 + 3 + 2 + dev->hard_header_len
 					   + dev->needed_headroom;
+	ndev->needed_tailroom = dev->needed_tailroom;
 
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
-- 
2.25.1

