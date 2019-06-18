Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA79F4A4E3
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbfFRPNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43417 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728905AbfFRPNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F2BA7223A4;
        Tue, 18 Jun 2019 11:13:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=+MlzOgpK91Z1SeLAcwPuAMFdGAwiB13qvFNHE9bjAzA=; b=UluRR8d/
        aP+Mm3uP8gtlgZFO50ptWM6uMeDwnmXWFbj8KLzEBGwsbS/79scCrMLu1WW4+Eop
        x0lHK/gBgpex2cOGXURMEGRItQu2YGNjtbVYQCWDbLHs2Qxu7kGFptXCr5xmwnNM
        cWuDb538eFKuPjpWybThbhcLC1NUKmV9Jumt1Bv/S52Ss6nolmyUd7B8pnjh+9nG
        aGzF97AyeBdwQqG0WTJvNXOra00+4eeVlY7i599oMvr+W7oRBQ1XJKljnLh72EIk
        6BXKTbc2m+tvh5VlGecQywpQ66Vka4ohJ8pBsmhkPEJ0srUw3DaKqBowY8zQBH3o
        raR2fIRNPrbVpA==
X-ME-Sender: <xms:nf8IXTWB0woWIidy8VbmZHvEEXDetV6NlITZn73jf-aaPg22XsxsRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:nf8IXf2WJFZQqxGGuDMGSkgAI2ngkoT7RklXleHuaBUp3TnwUT2Z3A>
    <xmx:nf8IXaaEIuYSO8bJQahlyMQnCJSgxHQFGGq74waIIaWJc0Th_d8K4w>
    <xmx:nf8IXSqo5ktYK1ZUK1iTsE6nvsNiEMJ7HW3wDPvhG61xrNDWOwvG_g>
    <xmx:nf8IXVl_H1KG59Dcxc02mmfUzUtebrXxxqTBGo-wvWQq8KQo342cew>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59752380073;
        Tue, 18 Jun 2019 11:13:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/16] mlxsw: spectrum_router: Ignore IPv6 multipath notifications
Date:   Tue, 18 Jun 2019 18:12:46 +0300
Message-Id: <20190618151258.23023-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

IPv6 multipath notifications are about to be sent, but mlxsw is not
ready to process them, so ignore them.

The limitation will be lifted by a subsequent patch which will also stop
the kernel from sending a notification for each nexthop.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a6055107c5f2..ca47aa74e5d5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6203,6 +6203,8 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 route with nexthop objects is not supported");
 				return notifier_from_errno(-EINVAL);
 			}
+			if (fen6_info->multipath_rt)
+				return NOTIFY_DONE;
 		}
 		break;
 	}
-- 
2.20.1

