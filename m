Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4891BB111
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgD0WDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgD0WCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CEC122261;
        Mon, 27 Apr 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=sPYOhJHhgnxilQ96b+2lDSVXblKJN5PxG5u6FTo/J3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/eZdJ4rncpgAI+wExY6z8bHKvTC5T5OG2YLMfp2BTb8cTWTQ7UE47vP5tiBbX7FA
         jy2p6BtK3/iyITKcfJySRxS9+jEl1UTxYEUri3m1e2tzu0YFtBPHFkLD206phSDYBE
         qVyJMplKPn0pBXTxCRmqFQaPyAu+eREh0H2lGEeY=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Iq8-AM; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 31/38] docs: networking: convert ip_dynaddr.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:46 +0200
Message-Id: <3c731dc58c8066a68f36d2023d024a94ff9a72e7.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{ip_dynaddr.txt => ip_dynaddr.rst}        | 29 +++++++++++++------
 2 files changed, 21 insertions(+), 9 deletions(-)
 rename Documentation/networking/{ip_dynaddr.txt => ip_dynaddr.rst} (65%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index cf85d0a73144..f81aeb87aa28 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -66,6 +66,7 @@ Contents:
    hinic
    ila
    ipddp
+   ip_dynaddr
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ip_dynaddr.txt b/Documentation/networking/ip_dynaddr.rst
similarity index 65%
rename from Documentation/networking/ip_dynaddr.txt
rename to Documentation/networking/ip_dynaddr.rst
index 45f3c1268e86..eacc0c780c7f 100644
--- a/Documentation/networking/ip_dynaddr.txt
+++ b/Documentation/networking/ip_dynaddr.rst
@@ -1,10 +1,15 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
 IP dynamic address hack-port v0.03
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+==================================
+
 This stuff allows diald ONESHOT connections to get established by
 dynamically changing packet source address (and socket's if local procs).
 It is implemented for TCP diald-box connections(1) and IP_MASQuerading(2).
 
-If enabled[*] and forwarding interface has changed:
+If enabled\ [#]_ and forwarding interface has changed:
+
   1)  Socket (and packet) source address is rewritten ON RETRANSMISSIONS
       while in SYN_SENT state (diald-box processes).
   2)  Out-bounded MASQueraded source address changes ON OUTPUT (when
@@ -12,18 +17,24 @@ If enabled[*] and forwarding interface has changed:
       received by the tunnel.
 
 This is specially helpful for auto dialup links (diald), where the
-``actual'' outgoing address is unknown at the moment the link is
+``actual`` outgoing address is unknown at the moment the link is
 going up. So, the *same* (local AND masqueraded) connections requests that
 bring the link up will be able to get established.
 
-[*] At boot, by default no address rewriting is attempted. 
-  To enable:
+.. [#] At boot, by default no address rewriting is attempted.
+
+  To enable::
+
      # echo 1 > /proc/sys/net/ipv4/ip_dynaddr
-  To enable verbose mode:
-     # echo 2 > /proc/sys/net/ipv4/ip_dynaddr
-  To disable (default)
+
+  To enable verbose mode::
+
+    # echo 2 > /proc/sys/net/ipv4/ip_dynaddr
+
+  To disable (default)::
+
      # echo 0 > /proc/sys/net/ipv4/ip_dynaddr
 
 Enjoy!
 
--- Juanjo  <jjciarla@raiz.uncu.edu.ar>
+Juanjo  <jjciarla@raiz.uncu.edu.ar>
-- 
2.25.4

