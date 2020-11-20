Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4548A2BB411
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731524AbgKTSj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731038AbgKTSj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:39:58 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7209E24178;
        Fri, 20 Nov 2020 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897597;
        bh=vUARP2CaeWis9/yRUx6zGzkgMtkO+rE+mlZhTiYg26o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9ISOAL0VXvMHdFCOsz57eqGUQpeswDilMz9QgcXFqGfxrsKKvgVsTAKuZqRa60H8
         j71bRLbMMN85myUWU1x1tGg0nEeqiDPedM7HzVzBAi1kE+/QSi4aV/Omv4eUizTcfs
         XEDpHf/5NGjWqHyr2I2DjP/DBp3mZ69aPc8xMufs=
Date:   Fri, 20 Nov 2020 12:40:02 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 129/141] SUNRPC: Fix fall-through warnings for Clang
Message-ID: <adea8b6765c2bb0f30eb40460240e0b7a9932fd2.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sunrpc/rpc_pipe.c | 1 +
 net/sunrpc/xprtsock.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index eadc0ede928c..99fcb0bea1d0 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -478,6 +478,7 @@ rpc_get_inode(struct super_block *sb, umode_t mode)
 		inode->i_fop = &simple_dir_operations;
 		inode->i_op = &simple_dir_inode_operations;
 		inc_nlink(inode);
+		break;
 	default:
 		break;
 	}
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7090bbee0ec5..a785c15804d6 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1874,6 +1874,7 @@ static int xs_local_setup_socket(struct sock_xprt *transport)
 		xprt->stat.connect_time += (long)jiffies -
 					   xprt->stat.connect_start;
 		xprt_set_connected(xprt);
+		break;
 	case -ENOBUFS:
 		break;
 	case -ENOENT:
-- 
2.27.0

