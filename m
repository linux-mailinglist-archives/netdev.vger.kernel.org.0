Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A9D4684FC
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 14:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385015AbhLDNVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:21:49 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:48635 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhLDNVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 08:21:48 -0500
Received: from localhost.localdomain ([37.4.249.122]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MwgKC-1mdcja3bI2-00yCvo; Sat, 04 Dec 2021 14:18:08 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC V2 3/4] net: introduce media selection IF_PORT_HOMEPLUG
Date:   Sat,  4 Dec 2021 14:17:50 +0100
Message-Id: <1638623871-21805-4-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
References: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:v79XfJBN6IC3wWE+xmdySoDd/bpMHYFNukSE3LwhL2aL+C0ecvq
 9RZc96a/uq6QeunM+MInMy9oGG6n+EfZ99lFNDzhkV5+8Kwt3SAhW5hNZgjAcb/OzAYfDY0
 MjEe6Hku+5XwqJPNPTORgMNy6dphZ7fmmaOB2Z8rOUdpotu0U9lh3ffAa+M7M2pqXafB1N1
 svItlrC4IdQ6+r0hj5u1Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WsUPArtdaUE=:iDUIYCNFSX+0QRzaSWh2hr
 oSERPofTw/FkdnQPO8SUJsDZ6Sd1bfY2W6GUlvd9XaLjmJDuv1v+J9J/lru3+CPC3H0cZ9jOK
 I9xgCM7iWUhg7PWqyoiazw8n896rmRWFkVkb1fkLJhCB3UhhGWOSueG0s5+PXLSH5okS3NgjP
 K9RJ8i+kqJ0R57vy29c4+XsfLEhmTt6Vbsr5wCwtQobpaPIg3bQxN0hRUApn2lAuVAogRY9TM
 c4P6OeOFVEB9v4ObHnshoYK7jOErJyS6/wSOjMBZLrZzT3VI9ZHBWjNOyj0F2G6a6Q3a0OvoY
 60/2lxdLLTmniuCnHOiDbPBpr8IPCIgadkHWGkBkXTnBVcKYOqVHAwcvXZM0y0kQv2mJJ8kZl
 FFjBby1KoHDuA77fIWiUL9dtkQG07fWLIrEMrSuSJJkx9L6aIe7EnZ9/cxB9Y+O6LCRMYayjJ
 e77MLTOqa8LUWq7QgQuiATmLI3ubEfo0FbsAC7Y4TcEGxos0oTr3zwS7Ce+H52fXqltOjSghD
 zVSZzAInhA34rwC7blNs6s+HvqBN/awuGcUGrEWlnGQt4RqYGW/+Yak7lP5rJuzCwt954bT2g
 LKc4wEPR8Vc3CNXyGh9+xW9ahbvS1lqErOPi1p/OrKbGwmloitE+OyQccBI/BrVZJ8faFgwHl
 Otn0fF8Eva+kkYMg/qtLmLBiVO4mN3zPK5M/LHD0hs3AHoXSYmWQGZmbQUz3ceqGadM03ldgl
 rgUexwJN/FMBZN0c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new media selection dedicated for HomePlug powerline
communication. This allows us to use the proper if_port setting in
HomePlug drivers.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 include/uapi/linux/netdevice.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netdevice.h b/include/uapi/linux/netdevice.h
index f3770c5..0f1f536 100644
--- a/include/uapi/linux/netdevice.h
+++ b/include/uapi/linux/netdevice.h
@@ -53,7 +53,8 @@ enum {
         IF_PORT_AUI,
         IF_PORT_100BASET,
         IF_PORT_100BASETX,
-        IF_PORT_100BASEFX
+        IF_PORT_100BASEFX,
+        IF_PORT_HOMEPLUG
 };
 
 /* hardware address assignment types */
-- 
2.7.4

