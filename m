Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6E52F8B44
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbhAPEdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729787AbhAPEdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 23:33:46 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E962EC061799
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 20:32:33 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id b3so6803273pft.3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 20:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=T+vvNq3SP4PfyWRXUjIhXZR26GW6JmhhuUdKtR2t97I=;
        b=SS9FmYqI0gisMywuYitzDHL1zFCbzAfaDUHOAQ78NZQCrfWhgpVgRfxUUAw0Owoea6
         MkD2xEhFgGkHaZrpmJBw8RcDBtGF2L5mN2Y8wO/9XNYno1OCl9jLN6KfQ18CLnc6dqUM
         AavrjEorVVvzAIBWr0NyrcKWEBPVdpPO7hy76fRiF1gwpklSTqgGqFrhY7w5KuDh2U1j
         qQJTcj+pooOk+OTADx4ezx6YqIzyndFplj6L4ORR/hx/TG6GioJYHKxUhObmrGhvPAnh
         +X2+lmcEmj86HMyZOyECFRjjuH9tAhWyOPvUWMg8s0LES5Wnh9jaUDOzbSgIhioIyzeQ
         uXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=T+vvNq3SP4PfyWRXUjIhXZR26GW6JmhhuUdKtR2t97I=;
        b=Rt7ZgrOCPpQ5cYCB6OxCaNS/0ZzrGf2BPbpFW+uE1hezEtQMARV0Fp5eaGoqi7G3sU
         uzOIGpAFieMZ0yrWgwFQ5fsx50lKjWJ1oVhm0NCC0b+RZZDu+35NaqEwkiduxC6iAesR
         YL/7aj826/EmDuoRFlKa5jel4kg28cAlXVjvNnebcDc0gjZFswEdf88n7UFBiV2SuSAe
         i+Vi33xdBwQyLhrN7dIZp/TN5kdljWj9QPe5Oeob6zbc7PPVKm2MmdZHjjOJ3+6bqLa0
         TczT4w4rovAwY+mUbFlDZp3DebomsnAXlQqmTKuqPGBpStvVyiT6J//OMRZR2K/pIU2x
         izUg==
X-Gm-Message-State: AOAM5326NPcqwP73PF+baUCs0CxxAiahbCC9AZDb5jJfmhnr+pEps5lQ
        p5e4KCcncsWqoiWQ3vkwesACxGKSkDjWAw==
X-Google-Smtp-Source: ABdhPJyPO7Q+XD3OFaGzAu8KUizWzAF+cKAV5634EPy2DZOHaAppy6jRbAsKf4JW5f4019AWT3UBiA==
X-Received: by 2002:a62:6d06:0:b029:1a8:4d3f:947a with SMTP id i6-20020a626d060000b02901a84d3f947amr16182261pfc.6.1610771553287;
        Fri, 15 Jan 2021 20:32:33 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s7sm9306748pgi.69.2021.01.15.20.32.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 20:32:32 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCHv3 net-next 2/2] Revert "bareudp: Fixed bareudp receive handling"
Date:   Sat, 16 Jan 2021 12:32:08 +0800
Message-Id: <ef2fdd7f2f102663461e8630ad1aad74bb1219a0.1610771509.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0ba74e791c186444af53489ebc55664462a1caf6.1610771509.git.lucien.xin@gmail.com>
References: <cover.1610771509.git.lucien.xin@gmail.com>
 <0ba74e791c186444af53489ebc55664462a1caf6.1610771509.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610771509.git.lucien.xin@gmail.com>
References: <cover.1610771509.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As udp_encap_enable() is already called in udp_tunnel_encap_enable()
since the last patch, and we don't need it any more. So remove it by
reverting commit 81f954a44567567c7d74a97b1db78fb43afc253d.

v1->v2:
 - no change.
v2->v3:
 - add the missing signoff.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/bareudp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 0965d13..57dfaf4 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -240,12 +240,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
 	tunnel_cfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
 
-	/* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
-	 * socket type is v6 an explicit call to udp_encap_enable is needed.
-	 */
-	if (sock->sk->sk_family == AF_INET6)
-		udp_encap_enable();
-
 	rcu_assign_pointer(bareudp->sock, sock);
 	return 0;
 }
-- 
2.1.0

