Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9588221DE9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgGPIJo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 04:09:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56449 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726963AbgGPIJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:09:41 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-FYw9gi2hOQOOBCTQ_3u87Q-1; Thu, 16 Jul 2020 04:09:36 -0400
X-MC-Unique: FYw9gi2hOQOOBCTQ_3u87Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99D78102C7ED;
        Thu, 16 Jul 2020 08:09:35 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD944710D7;
        Thu, 16 Jul 2020 08:09:34 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec 3/3] xfrm: policy: fix IPv6-only espintcp compilation
Date:   Thu, 16 Jul 2020 10:09:03 +0200
Message-Id: <c65d0e13da667cc6b7537d023ecf0c936ebcfb7f.1594287359.git.sd@queasysnail.net>
In-Reply-To: <cover.1594287359.git.sd@queasysnail.net>
References: <cover.1594287359.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case we're compiling espintcp support only for IPv6, we should
still initialize the common code.

Fixes: 26333c37fc28 ("xfrm: add IPv6 support for espintcp")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 6847b3579f54..19c5e0fa3f44 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -39,7 +39,7 @@
 #ifdef CONFIG_XFRM_STATISTICS
 #include <net/snmp.h>
 #endif
-#ifdef CONFIG_INET_ESPINTCP
+#ifdef CONFIG_XFRM_ESPINTCP
 #include <net/espintcp.h>
 #endif
 
@@ -4149,7 +4149,7 @@ void __init xfrm_init(void)
 	seqcount_init(&xfrm_policy_hash_generation);
 	xfrm_input_init();
 
-#ifdef CONFIG_INET_ESPINTCP
+#ifdef CONFIG_XFRM_ESPINTCP
 	espintcp_init();
 #endif
 
-- 
2.27.0

