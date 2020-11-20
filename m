Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690852BB332
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgKTSax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730533AbgKTSav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:30:51 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E9524137;
        Fri, 20 Nov 2020 18:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897051;
        bh=n4gmw6oYJQw9aNSzbjcpzFOwDVRrQdAVrgo2Zbxzdgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2mClBoataV/HE4LTG8pURPdfyWhi5cUchM4NroUZkVlDTvfkKW/9jZvJrRG6G5W7j
         4rC6UDh9OubJO9EnJ47bb31G7CCOC+A2XpqoLldRN7si+mLuGOLaRvXTm3R3lIMlxl
         3SjEzpBfjximHtht+2dxuD9kHmBGYVMeriOm/X3Y=
Date:   Fri, 20 Nov 2020 12:30:56 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 042/141] net: 3c509: Fix fall-through warnings for Clang
Message-ID: <56f997b3e97326076d16930901a4089056e8b6c6.1605896059.git.gustavoars@kernel.org>
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
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/3com/3c509.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 667f38c9e4c6..676cdc6900b5 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -1052,6 +1052,7 @@ el3_netdev_get_ecmd(struct net_device *dev, struct ethtool_link_ksettings *cmd)
 		break;
 	case 3:
 		cmd->base.port = PORT_BNC;
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

