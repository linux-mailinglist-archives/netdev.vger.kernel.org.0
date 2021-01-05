Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9804C2EA2D7
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 02:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbhAEBX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 20:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhAEBXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 20:23:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF0D22581;
        Tue,  5 Jan 2021 01:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609809764;
        bh=zoCxlZ5gLljAW6cQMQ2/94cW6XhO54lbJF+SWkV/Wbk=;
        h=From:To:Cc:Subject:Date:From;
        b=d33TaEmHtMHeybnzh2eZqQteNpdtn5MI13UxAB9vM/f1ntZXGJvytI1K3bY00nVd5
         pH1/yF0dCdts2OH38NYXkNUPPwDzjsHZefFJ1PZGlEFzna7onQsb6Sw8cSwNMI6niJ
         FRUzko9K8E+ffpdyT0+xL9HrLF8HahbHl0YIyCC/17ag4PDsHMjUXoVTYJ8TrcV1Ux
         3Mux8FX2rb44KN++W9XgAWlbxIuDbkZJ2DxXqyc1YgrVTKlRqXfXi5PZcnpDhSJs2/
         sRo48ILLk7forw1McbI+tdWbmwyzEPTk2USw/yo+VR1Y4jTwxee0c35m5rHXGOo2Sm
         dFToSvAf3JlfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2] docs: net: fix documentation on .ndo_get_stats
Date:   Mon,  4 Jan 2021 17:22:24 -0800
Message-Id: <20210105012224.1681573-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix calling context.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdevices.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 5a85fcc80c76..e65665c5ab50 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -64,8 +64,8 @@ struct net_device synchronization rules
 	Context: process
 
 ndo_get_stats:
-	Synchronization: dev_base_lock rwlock.
-	Context: nominally process, but don't sleep inside an rwlock
+	Synchronization: rtnl_lock() semaphore, dev_base_lock rwlock, or RCU.
+	Context: atomic (can't sleep under rwlock or RCU)
 
 ndo_start_xmit:
 	Synchronization: __netif_tx_lock spinlock.
-- 
2.26.2

