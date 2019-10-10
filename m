Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B8FD1F1B
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 05:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbfJJDxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 23:53:07 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:58670 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfJJDxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 23:53:07 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2019 23:53:07 EDT
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 5D12F1A40556; Wed,  9 Oct 2019 20:43:47 -0700 (PDT)
Date:   Wed, 9 Oct 2019 20:43:47 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] af_unix: __unix_find_socket_byname() cleanup
Message-ID: <20191010034347.ohjmoivd7f426znd@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove pointless return variable dance.

Appears vestigial from when the function did locking as seen in
unix_find_socket_byinode(), but locking is handled in
unix_find_socket_byname() for __unix_find_socket_byname().

Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
---
 net/unix/af_unix.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 67e87db5877f..c853ad0875f4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -284,11 +284,9 @@ static struct sock *__unix_find_socket_byname(struct net *net,
 
 		if (u->addr->len == len &&
 		    !memcmp(u->addr->name, sunname, len))
-			goto found;
+			return s;
 	}
-	s = NULL;
-found:
-	return s;
+	return NULL;
 }
 
 static inline struct sock *unix_find_socket_byname(struct net *net,
-- 
2.11.0

