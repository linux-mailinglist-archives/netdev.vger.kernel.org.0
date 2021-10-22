Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F4437C4C
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhJVR6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233543AbhJVR6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F322761284;
        Fri, 22 Oct 2021 17:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634925347;
        bh=GjePRYsuxbkMK4AxbVDxBnBZ2/Dfo3Ul8l0t+bMtyLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELs8FYsQj5sX7t27djcRaoPzYKf0vZDoFRGhDZ3aor7E945VY3JKPt3vcg8xFufVx
         GS4cXhY+VNQETc0eoTgO4sSC/5sVqU0ePUWXDTbqyB7RPF3uYrYeHkoSwKHkp8RuKW
         QAOAePhaIw0brZjMIvwFC4Colc8sIByEShx4qrvYEQJDM5qhXKwxtYa67shkq3ZjaL
         JsLfnTj9U3voAGnQgxNNLXCLE17Ip3IRCqxbQR0nwbIYEtZOMhV2C+GRCJeho/d64J
         qoQq5QGecBi7Ygxt1lDatV7h40NqpsuQZwmayo5qi0o8XOfMAkV6damSRNdPGrjQan
         3mb5lRYP/lFBQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/8] net: rtnetlink: use __dev_addr_set()
Date:   Fri, 22 Oct 2021 10:55:37 -0700
Message-Id: <20211022175543.2518732-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022175543.2518732-1-kuba@kernel.org>
References: <20211022175543.2518732-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get it ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 79477dcae7c2..2af8aeeadadf 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3204,8 +3204,8 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		dev->mtu = mtu;
 	}
 	if (tb[IFLA_ADDRESS]) {
-		memcpy(dev->dev_addr, nla_data(tb[IFLA_ADDRESS]),
-				nla_len(tb[IFLA_ADDRESS]));
+		__dev_addr_set(dev, nla_data(tb[IFLA_ADDRESS]),
+			       nla_len(tb[IFLA_ADDRESS]));
 		dev->addr_assign_type = NET_ADDR_SET;
 	}
 	if (tb[IFLA_BROADCAST])
-- 
2.31.1

