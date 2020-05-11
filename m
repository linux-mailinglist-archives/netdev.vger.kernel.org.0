Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070B21CD0F7
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgEKEqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728353AbgEKEp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:57 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7E7C061A0E;
        Sun, 10 May 2020 21:45:57 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KC-005jIv-1Z; Mon, 11 May 2020 04:45:56 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/19] batadv_socket_read(): get rid of pointless access_ok()
Date:   Mon, 11 May 2020 05:45:48 +0100
Message-Id: <20200511044553.1365660-14-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
References: <20200511044328.GP23230@ZenIV.linux.org.uk>
 <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

address is passed only to copy_to_user()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/batman-adv/icmp_socket.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/batman-adv/icmp_socket.c b/net/batman-adv/icmp_socket.c
index ccb535c77e5d..8bdabc03b0b2 100644
--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -135,9 +135,6 @@ static ssize_t batadv_socket_read(struct file *file, char __user *buf,
 	if (!buf || count < sizeof(struct batadv_icmp_packet))
 		return -EINVAL;
 
-	if (!access_ok(buf, count))
-		return -EFAULT;
-
 	error = wait_event_interruptible(socket_client->queue_wait,
 					 socket_client->queue_len);
 
-- 
2.11.0

