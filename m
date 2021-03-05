Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702FE32E2FE
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCEHfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCEHfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 02:35:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92DD164F59;
        Fri,  5 Mar 2021 07:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614929741;
        bh=u2T+T0aJOG1TaSV8gbevkf4cJS3hyJZFb+sufWcrL9I=;
        h=Date:From:To:Cc:Subject:From;
        b=mIxhKlp7yLF+kuGa/o+YfWsqrda++kk32ba184hytxkPkxUxyFbPbJS26VY3fHeY0
         hsdJKDOTJDiY5AJ4jgmIu22rTH+tH8/zMJnokM5rj9F823VW5F5vH3eB2z1mM+foAp
         7fYzTV4x8S6jysdHDVACru2pNQAjNC4P/TY+sgH5FNhPuqnyadb173/joxbfUFuOt4
         wSKP/uTai5LOmaeD+konceDUxI5h5u/oBLGHb6yYkoiU4iWzi4zOfbK0WZnkVWJrQ7
         pDXxKqu31G392c2nDz92vqgSTjbe44LXt13YUoIfG/fb/WHJ/tiSeoykcOfS/3gkWS
         0kxsOTiACdyxw==
Date:   Fri, 5 Mar 2021 01:35:38 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: 3c509: Fix fall-through warnings for Clang
Message-ID: <20210305073538.GA122397@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
index 53e1f7e07959..96cc5fc36eb5 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -1051,6 +1051,7 @@ el3_netdev_get_ecmd(struct net_device *dev, struct ethtool_link_ksettings *cmd)
 		break;
 	case 3:
 		cmd->base.port = PORT_BNC;
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

