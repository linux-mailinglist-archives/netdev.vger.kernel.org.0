Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABD430D5A5
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhBCIze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbhBCIza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:55:30 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F19C0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 00:54:50 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id w18so16204331pfu.9
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=8N1rB5fqpCzAQ6vqQKc8x/26gbAnacYrV2W8lJzHL0Q=;
        b=mNY5Pd/+OoyvmxaICuZjn2ng3yNlPMW+/N63MuYh4dDA/Zja2zMStBlkWUWqvJL/YW
         lyVXr6zQVWgDblwQ0//jfaYnOMuWnGILLEuE2K4uO3XYf2mMrcQiBZHj4GXIbUv9p+dW
         MJhfehofSf8CcRhAqGwiBGuR5/QBpY3z2i76mOk9XoRihz+W53eBkSJSahjPzJztLP8Y
         JXh3RkXvPHjoKapDVl72tUz6Sjhi3pfjSX3ymzA4tpxYnKCRkZiXVgggq06R4RT1FYrt
         yiUSWjyd63LBdyHyrob5NlbvcnfpMGBiENjhdv+oL675R4w21uHWVMRFMzEzgB366fAp
         4NaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=8N1rB5fqpCzAQ6vqQKc8x/26gbAnacYrV2W8lJzHL0Q=;
        b=a2raFADUaLFZbkhxd82KxKdxdm0+rn/5ZZ5ipka4EjgJbEMj++2uC4kwerqBKbuPaW
         78YEXXbOPG1DaXauQRXugAgvAZxCbLqegyQyikWBuFdoiBUxiAJCryTeMLf1kRmKo27f
         DC5KvTPEo82LJhUohhKGBFWQr3pIXo0ACtfMd6PFiBaGthyDik8BgXvUzDL6/EOnt29F
         ScHu9upb95oQipvVAZqyNPAZ1PkxxE425zf7vnoND8wlVsAhdZ/+RNffC9raDa+brZur
         InTB3c2dEU2+yHNkMUNIt1phNO/LIyl2T5dNKsKNZNg4sfk/PUai3sQmSVTuFzhkzbZK
         L3Ew==
X-Gm-Message-State: AOAM531MMojtNHs7Bu7a+wMwsznm/k6wV3wytdLT2La90MVNrrCqpSpk
        +cmlu0D2V838AkiDN5rlVYc5ziLJ1LAK3w==
X-Google-Smtp-Source: ABdhPJx39jbkNdrx+PZIDG/IRe4gftHYkDtIY6L796RgYX34BB6vH//5W6oitKxXLr9kbucWnMQheQ==
X-Received: by 2002:a63:3e49:: with SMTP id l70mr2505122pga.96.1612342489251;
        Wed, 03 Feb 2021 00:54:49 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i3sm1500889pfq.194.2021.02.03.00.54.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:54:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCHv5 net-next 2/2] rxrpc: call udp_tunnel_encap_enable in rxrpc_open_socket
Date:   Wed,  3 Feb 2021 16:54:23 +0800
Message-Id: <2da45aee43c74c05a586a7d3c7b1f9fc48bb72f2.1612342376.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com>
References: <cover.1612342376.git.lucien.xin@gmail.com>
 <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1612342376.git.lucien.xin@gmail.com>
References: <cover.1612342376.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing encap_enable/increasing encap_needed_key, up->encap_enabled
is not set in rxrpc_open_socket(), and it will cause encap_needed_key
not being decreased in udpv6_destroy_sock().

This patch is to improve it by just calling udp_tunnel_encap_enable()
where it increases both UDP and UDPv6 encap_needed_key and sets
up->encap_enabled.

v4->v5:
  - add the missing '#include <net/udp_tunnel.h>', as David Howells
    noticed.

Acked-and-tested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/rxrpc/local_object.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 8c28810..33b4936 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -16,6 +16,7 @@
 #include <linux/hashtable.h>
 #include <net/sock.h>
 #include <net/udp.h>
+#include <net/udp_tunnel.h>
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
@@ -135,11 +136,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	udp_sk(usk)->gro_receive = NULL;
 	udp_sk(usk)->gro_complete = NULL;
 
-	udp_encap_enable();
-#if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
-	if (local->srx.transport.family == AF_INET6)
-		udpv6_encap_enable();
-#endif
+	udp_tunnel_encap_enable(local->socket);
 	usk->sk_error_report = rxrpc_error_report;
 
 	/* if a local address was supplied then bind it */
-- 
2.1.0

