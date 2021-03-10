Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D040333578
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhCJFkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:40:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhCJFjp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:39:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA1A864F59;
        Wed, 10 Mar 2021 05:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615354784;
        bh=OSa/NWiOxT9hUBy3oJFQuT8JLZChm6Td8cUlrIATMfc=;
        h=Date:From:To:Cc:Subject:From;
        b=n1bGpmAFfRDZ7DSpW+rsiDie5b+sW0p4yQan1cFEHhG9CCiMNyhmr66lnypjtBvS+
         WmvkmqB7X5gDmWGWQ3g/MKqjmACoWuCT4IV0/DdJO0GnBT/lBqVKmMWs6NiQ5SieIu
         s5Cl7d6IGx0gllc8fOviZoCyjFnzebPUODE2mngET2vMAs8Z4Surm+XdIE9DHIWAFZ
         aEqByUjJzIEGGh+IVPHgMzN3ulyxvPNedHExDNXo7IEpRo4OVOkBPHiO8hVIzop84P
         RYXJZxcLrkUjn6vNkUu5MSeCq1TAPEZd7tIUOdY0A+MRf7MKLjVij31GN5Ro1PsPom
         qnrQS5jzbSjfg==
Date:   Tue, 9 Mar 2021 23:39:41 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: ax25: Fix fall-through warnings for Clang
Message-ID: <20210310053941.GA285638@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 Changes in RESEND:
 - None. Resending now that net-next is open.

 net/ax25/af_ax25.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 269ee89d2c2b..2631efc6e359 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -850,6 +850,7 @@ static int ax25_create(struct net *net, struct socket *sock, int protocol,
 		case AX25_P_ROSE:
 			if (ax25_protocol_is_registered(AX25_P_ROSE))
 				return -ESOCKTNOSUPPORT;
+			break;
 #endif
 		default:
 			break;
-- 
2.27.0

