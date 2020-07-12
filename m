Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E938421CC0C
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgGLXPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgGLXPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBu-004mQY-GQ; Mon, 13 Jul 2020 01:15:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 16/20] net: socket: Move kerneldoc next to function it documents
Date:   Mon, 13 Jul 2020 01:15:12 +0200
Message-Id: <20200712231516.1139335-17-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the warning "Function parameter or member 'inode' not described in
'__sock_release'' due to the kerneldoc being placed before
__sock_release() not sock_release(), which does not take an inode
parameter.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/socket.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index d87812a9ed4b..770503c4ca76 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -586,15 +586,6 @@ struct socket *sock_alloc(void)
 }
 EXPORT_SYMBOL(sock_alloc);
 
-/**
- *	sock_release - close a socket
- *	@sock: socket to close
- *
- *	The socket is released from the protocol stack if it has a release
- *	callback, and the inode is then released if the socket is bound to
- *	an inode not a file.
- */
-
 static void __sock_release(struct socket *sock, struct inode *inode)
 {
 	if (sock->ops) {
@@ -620,6 +611,14 @@ static void __sock_release(struct socket *sock, struct inode *inode)
 	sock->file = NULL;
 }
 
+/**
+ *	sock_release - close a socket
+ *	@sock: socket to close
+ *
+ *	The socket is released from the protocol stack if it has a release
+ *	callback, and the inode is then released if the socket is bound to
+ *	an inode not a file.
+ */
 void sock_release(struct socket *sock)
 {
 	__sock_release(sock, NULL);
-- 
2.27.0.rc2

