Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7438FF228
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 10:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfD3Imo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 04:42:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33277 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfD3Imo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 04:42:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E016F23075;
        Tue, 30 Apr 2019 04:42:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 30 Apr 2019 04:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yVrkeUk2KBhDPnm2O
        fjgvCa5g/Fz1bstW+rBK/o0zNA=; b=h73VzZ7IoO/659sbJfPD1JOjSnnfd1ii6
        d+gBhI3SCUNMh0FO+fJ2+P7NIBWiCurExn0lK/E1I8WZSsPwIJtRE8ZuaHLoRQeZ
        LKeXzVjPPbjFQt4Slb3tQ7H2DyFfs2tMKRq+utKCGtZwEDibF+u6hvWMI/7zZlQ9
        MAMMZqBDEEF+U5kG5b/8biAox7HZ9JBamgreLS3+ntBXonqjhxcAYZgk09Fpn8kA
        nerfV/ej/LBnmIu4fShVudDS+ziAkHZzGDcGze83R7xQAuoZVP+o4h6vFDvVNbnV
        58TDkKBTc5VzQ/Gw3TwPxebabpyHyOZDI6tpYfFA8fS+XMV3BqRAQ==
X-ME-Sender: <xms:ggrIXBt1793mTSDT8iDL6nNxJh0borhauXVfXTXqPlEiPnOKtZwy-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieeggddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:ggrIXJ5CdhxLvIerutqGphi_zLmpfMwKjE2TI9J2rLB-p2GRK8eOdw>
    <xmx:ggrIXF1WB2C9ARE8i7BfWYRjV6VlgIIYlnHrBQGHeycV5yZgPTtQww>
    <xmx:ggrIXMjGHfL-y0s_yyCkBbp_xXJFYPbbHa0oa8qaphKQZBuspPGMyw>
    <xmx:ggrIXLUiSUYUJGBnvulB5VbO9dhnpeDOwibxOj6o7yhemv44Up20sA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2A03103CB;
        Tue, 30 Apr 2019 04:42:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, alexanderk@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2] devlink: Increase column size for larger shared buffers
Date:   Tue, 30 Apr 2019 11:42:08 +0300
Message-Id: <20190430084208.4693-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

With current number of spaces the output is mangled if the shared buffer
is congested.

Before:

# devlink sb occupancy show swp25
swp25:
  pool: 0:    33384960/39344256 1:          0/0       2:          0/0       3:          0/0
        4:          0/720     5:          0/0       6:          0/0       7:          0/0
        8:          0/288     9:          0/0      10:          0/0
  itc:  0(0): 33272064/39344256 1(0):       0/0       2(0):       0/0       3(0):       0/0
        4(0):       0/0       5(0):       0/0       6(0):       0/0       7(0):       0/0
  etc:  0(4):       0/720     1(4):       0/0       2(4):       0/0       3(4):       0/0
        4(4):       0/0       5(4):       0/0       6(4):       0/0       7(4):       0/0
        8(8):       0/288     9(8):       0/0      10(8):       0/0      11(8):       0/0
       12(8):       0/0      13(8):       0/0      14(8):       0/0      15(8):       0/0

After:

# devlink sb occupancy show swp25
swp25:
  pool: 0:      39070080/39344256   1:             0/0          2:             0/0          3:             0/0
        4:             0/720        5:             0/0          6:             0/0          7:             0/0
        8:             0/288        9:             0/0         10:             0/0
  itc:  0(0):   39062016/39344256   1(0):          0/0          2(0):          0/0          3(0):          0/0
        4(0):          0/0          5(0):          0/0          6(0):          0/0          7(0):          0/0
  etc:  0(4):          0/720        1(4):          0/0          2(4):          0/0          3(4):          0/0
        4(4):          0/0          5(4):          0/0          6(4):          0/0          7(4):          0/0
        8(8):          0/288        9(8):          0/0         10(8):          0/0         11(8):          0/0
       12(8):          0/0         13(8):          0/0         14(8):          0/0         15(8):          0/0

v2:
* Increase number of spaces to make the change more future-proof

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
---
 devlink/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index dc6e73fec20c..5bf81f55cde8 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3422,7 +3422,7 @@ static void pr_out_occ_show_item_list(const char *label, struct list_head *list,
 				  occ_item->bound_pool_index);
 		else
 			pr_out_sp(7, "%2u:", occ_item->index);
-		pr_out_sp(15, "%7u/%u", occ_item->cur, occ_item->max);
+		pr_out_sp(21, "%10u/%u", occ_item->cur, occ_item->max);
 		if (i++ % 4 == 0)
 			pr_out("\n");
 	}
-- 
2.20.1

