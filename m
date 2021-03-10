Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CA9333565
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCJFf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232389AbhCJFe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:34:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 542BE64FE7;
        Wed, 10 Mar 2021 05:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615354495;
        bh=ZKBmyRfSTUpswXJdbISr3e+lylHH9GO3aa4eesyzTtU=;
        h=Date:From:To:Cc:Subject:From;
        b=hHbweubGyeeXxCP+2N30IWJnbcn58JW+RqBGH3r80F0g/00Pyev3OkK3/Ypms97Ah
         IHJwlJt7MvXzPjoLgKbBwbtS3SYuFdUDbruoX7KRkAD8jnndpur+66hio/OajFhxrf
         5qDCHN7x3SXQNDlTz4H/6KaGMjKf+EsW5JSbUp2ihxmSLPYXtAWsdEfAtQHfLxBVMN
         iv6XsunVdx7xD7f1PxWG2wWRCclFJzJ8iCC6AGKAuY35wom6jX02gpvxpFaMTx7PK7
         zFmAUcv7jy6yfSJ/mSo/bALdu8wiw3lsn2RMV80+OkJk6N8C/Bicw46qeH4d15CamE
         vinIqGdCQLmyg==
Date:   Tue, 9 Mar 2021 23:34:53 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: 3c509: Fix fall-through warnings for Clang
Message-ID: <20210310053453.GA285349@embeddedor>
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
 Changes in RESEND:
 - None. Resendig now that net-next is open.

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

