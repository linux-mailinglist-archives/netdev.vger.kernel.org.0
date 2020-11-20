Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CCC2BB33E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgKTSb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730290AbgKTSbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:31:25 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1C1024171;
        Fri, 20 Nov 2020 18:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897084;
        bh=eY3rGMEBBqNXM9DWJ8q+8xbYaA0kUDZyDVNTJUPw/qc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A8Y0sONpSzmqWlhukQyBqkptKNU1sna4yDH9KDvVqQeY5fQtP5wt4Y1wjizvr+KmB
         Ii0YBw4DgTfC8OEOUHwDQCS2LjlR/7cyMwJuB5F//Bge4U9SxsvagPp1zwwMcwNVOp
         ZkHZ/XVIuSpZha4dJLYp1+LfrjhAAojI8BGb0N9U=
Date:   Fri, 20 Nov 2020 12:31:30 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 047/141] nfp: Fix fall-through warnings for Clang
Message-ID: <14feaa5fe729f5c3b3d23e1b8fb9ef834da55e23.1605896059.git.gustavoars@kernel.org>
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
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index b3cabc274121..3b8e675087de 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -103,6 +103,7 @@ nfp_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 	case NFP_PORT_PF_PORT:
 	case NFP_PORT_VF_PORT:
 		nfp_repr_vnic_get_stats64(repr->port, stats);
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

