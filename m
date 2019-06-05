Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B37336623
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfFEU66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:58:58 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:46277 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfFEU66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 16:58:58 -0400
Received: from orion.localdomain ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MORN0-1hC9fH03os-00Psna; Wed, 05 Jun 2019 22:58:53 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH] net: socket: drop unneeded likely() call around IS_ERR()
Date:   Wed,  5 Jun 2019 22:58:50 +0200
Message-Id: <1559768330-15678-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:TL4WrsJIS97aN3tCwW4T+bg+aLSkUq6gW54szCJXOY0WD12Nh9o
 7vkKESopfbxf2qvDGkBLe7HfTTFQCP+qbirIPLls73nU810g0m+INXMqG8GZiXkDNlVWamQ
 3vmIsRVIpe1/mJDXyK3qzEo8z4St9PR+nh/S6DFL2vaWrI701jfwEtZLctbpfgR4m34L0vE
 4fJMrAaSN6t4fXUtMRAMg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GoYI2lCMcKY=:tYzEAFBlyU/X9gX2+WxwkV
 ZGi6PIBjUUrz5x8B4mzKKzR3enY5/U8+XmJX2I04R+jWNj9Xv7bcxp12S6HvZtBiR8RPiSeGj
 4IHuDwfV//P7f3FcV6v4+EJfGwZmWd2r4bTK7BObwvMDQ1jovAPANkw9L4WMK2U5oqUr4tS18
 MGwlqcprCOcZilz0Dya/3Gx5WaROL5znG9skJqJxYmA3yfw8nQFAM2F46h3ayf3dQ17XwzG2o
 4aHLVtRAWSRE1zl9fxdhkGodz1P4Ws+sX8MzZ2mjqMKz4Mo2mSolmE+1CotFblYiLXgIra+L4
 3lJYBtex+DoIB7jLPdT/76qWDwhzaNwWIdmlBUE6YBowpYC/uxBPmdaik4Nklqes5GKD4RJNO
 tmk7N8hH6ml5DUdhG+ClfKSgDhgatxpia9nQA9ui6Xq1Y8QRnRgDsTsAWgcLty5aR9VkHtfbA
 6fUKUqCmm/O1tas0XpNFhorFzsk0P8r4s6Euoh8BAj8j3Tg20VNZ3dWRn7HFA4EeD7AyV0Mkh
 FdA9yB52lA8M+P+0qwKAvG1K828FrQAj+32M7pGphIh1Fdn+WylDmWFj8IwfBjNxpr842Ul6/
 thvXgYGJ+ez1ymo29MiW3cXhmWHs0rRRD9v0hgO0zGM/fP3ROe9vbSay7ARtAvUSyBWFoQvEd
 h78vwulh6fBxRTRqr1VcucKuFiz+H8RxikOgGcyhjkwYSuQpE8fpKpzHER0KiGQemPTKWc+/e
 FTI2wFHQ74rOAmC4wNMs14MorUj2XfcZf+4ukQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra likely() call
around the !IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 38eec15..963df5d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -429,7 +429,7 @@ static int sock_map_fd(struct socket *sock, int flags)
 	}
 
 	newfile = sock_alloc_file(sock, flags, NULL);
-	if (likely(!IS_ERR(newfile))) {
+	if (!IS_ERR(newfile)) {
 		fd_install(fd, newfile);
 		return fd;
 	}
-- 
1.9.1

