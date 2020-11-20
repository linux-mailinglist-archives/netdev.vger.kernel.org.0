Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022ED2BB3B9
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgKTSht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbgKTShs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:37:48 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6411B24124;
        Fri, 20 Nov 2020 18:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897468;
        bh=oHCWpgfauurcAwVAR+BNJveAfh0IeEwBSn1ChD9wm2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uww9x3KPqN3XenRjf4rquTgz5YeYud/BQ2CKJ9L5aLyPXUM2DHjac0A03LVUU3uNH
         luFA06KSPfcGk6EL+o7YSCRXnwfLckX8Grg5rF823Z1GQsOiNv2U7YKKeT5w2jXvPd
         lDcd2CdsqJ665WwVneAJJb5s57wMy+Vt/JSW7RLY=
Date:   Fri, 20 Nov 2020 12:37:53 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 105/141] net: ax25: Fix fall-through warnings for Clang
Message-ID: <37c8748f80572a08f33e4ce354f93d61ddfd175b.1605896060.git.gustavoars@kernel.org>
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

