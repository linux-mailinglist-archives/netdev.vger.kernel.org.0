Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676DD2E6F3E
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 10:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgL2JJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 04:09:40 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:47623 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgL2JJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 04:09:35 -0500
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 14BEF440B08;
        Tue, 29 Dec 2020 11:08:51 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        =?UTF-8?q?Ulisses=20Alonso=20Camar=C3=B3?= <uaca@alumni.uv.es>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v2 2/2] docs: networking: packet_mmap: fix old config reference
Date:   Tue, 29 Dec 2020 11:08:39 +0200
Message-Id: <80089f3783372c8fd7833f28ce774a171b2ef252.1609232919.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <5cb47005e7a59b64299e038827e295822193384c.1609232919.git.baruch@tkos.co.il>
References: <5cb47005e7a59b64299e038827e295822193384c.1609232919.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 889b8f964f2f ("packet: Kill CONFIG_PACKET_MMAP.") there
used to be a CONFIG_PACKET_MMAP config symbol that depended on
CONFIG_PACKET. The text still implies that PACKET_MMAP can be disabled.
Remove that from the text, as well as reference to old kernel versions.

Also, drop reference to broken link to information for pre 2.6.5
kernels.

Make a slight working improvement (s/In/On/) while at it.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: Address comments from Jakub Kicinski and Willem de Bruijn

  * Don't change PACKET_MMAP

  * Remove mention of specific kernel versions

  * Don't reflow paragraphs

  * s/In/On/
---
 Documentation/networking/packet_mmap.rst | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/packet_mmap.rst b/Documentation/networking/packet_mmap.rst
index f3646c80b019..500ef60b1b82 100644
--- a/Documentation/networking/packet_mmap.rst
+++ b/Documentation/networking/packet_mmap.rst
@@ -8,7 +8,7 @@ Abstract
 ========
 
 This file documents the mmap() facility available with the PACKET
-socket interface on 2.4/2.6/3.x kernels. This type of sockets is used for
+socket interface. This type of sockets is used for
 
 i) capture network traffic with utilities like tcpdump,
 ii) transmit network traffic, or any other that needs raw
@@ -25,12 +25,12 @@ Please send your comments to
 Why use PACKET_MMAP
 ===================
 
-In Linux 2.4/2.6/3.x if PACKET_MMAP is not enabled, the capture process is very
+Non PACKET_MMAP capture process (plain AF_PACKET) is very
 inefficient. It uses very limited buffers and requires one system call to
 capture each packet, it requires two if you want to get packet's timestamp
 (like libpcap always does).
 
-In the other hand PACKET_MMAP is very efficient. PACKET_MMAP provides a size
+On the other hand PACKET_MMAP is very efficient. PACKET_MMAP provides a size
 configurable circular buffer mapped in user space that can be used to either
 send or receive packets. This way reading packets just needs to wait for them,
 most of the time there is no need to issue a single system call. Concerning
@@ -252,8 +252,7 @@ PACKET_MMAP setting constraints
 
 In kernel versions prior to 2.4.26 (for the 2.4 branch) and 2.6.5 (2.6 branch),
 the PACKET_MMAP buffer could hold only 32768 frames in a 32 bit architecture or
-16384 in a 64 bit architecture. For information on these kernel versions
-see http://pusa.uv.es/~ulisses/packet_mmap/packet_mmap.pre-2.4.26_2.6.5.txt
+16384 in a 64 bit architecture.
 
 Block size limit
 ----------------
-- 
2.29.2

