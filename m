Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645622F73B9
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 08:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbhAOHbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 02:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731488AbhAOHbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 02:31:16 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E9EC061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 23:30:36 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 11so4946801pfu.4
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 23:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=3IFC3iYq1PLDeBWUAx5gWx/qqJGJPyT/FaRL0p5firA=;
        b=N4lVwaxKzraP11CRG9HwatJQly/YSigWwWCRM0UXFETgTIut4ga3QnHGeChotrFbwR
         yB9dfDaeqWQ7vqA/uwzX161jpB6zOvzkKzQfO+ag0j+8oO5zjicdnPXznfi57Mqt5JDZ
         zEokzQu66d5FvI9D5TmDn2+wveiWk/HSLreeXWyMueoqoOvMfOCKZ8SKAVScThE84cCE
         p3dJe1uRJG1606F1QmGGhrhlHq8mNcQ+mIaiQakIgZQBL7qLWXepKf9oR8jNOLifv2By
         KWn1RDjb1vW1EFoL+O2SwLHqaZ9zSuNQiFAKy1zi+ZtyfxqerrLN8CgfWsLy3eF4jm98
         D3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=3IFC3iYq1PLDeBWUAx5gWx/qqJGJPyT/FaRL0p5firA=;
        b=LFV1fjJ32Hv9Vngm7MuFXK1cT7zK1uES/U9v/IYv2I2UN3mafAsbJcU+RATFMS9UCj
         c+f4tsgZ6xDGg+C/KgeS9Fd4a61Z0tn0OXSFv1p2puCIERO6p2deXLrhb0B/AJJkZX+v
         1JWAoS1b5SiWs4nAMmDG9NJ7EinJxIR3KAXx7xx6NZcD7eANXTA1AAnxu3MsIDY/xKkU
         5I+nE5AEvmNpRrmgB1SKsxLGNEMKdbJzhKBI0cQhtRHnlj8ieoXdWW+t7O2vqzrg+B/1
         xuOWbffkzLrOmU2SUdopIflAx4xu/OacnzxBZGhUNiB6sv+vT5R4qrNA0gHC7ZS2TxFV
         WbHw==
X-Gm-Message-State: AOAM530QettiXEGY2f0vqGbmzHI+ARWEKwpm5t9DJAhHZAJCa+XQudoz
        Jp83YX1XvFE7TEgXI+nYyObwF6eJp80hkQ==
X-Google-Smtp-Source: ABdhPJxi/8LQ3OoEhrpgYiqDZJdib/zg3VeyJhKbhxqMFq/JxD3qoAyiiq1m7Qz6eaO/rM8nOc4Iaw==
X-Received: by 2002:a63:78ca:: with SMTP id t193mr11446854pgc.391.1610695836041;
        Thu, 14 Jan 2021 23:30:36 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z7sm7423214pfq.193.2021.01.14.23.30.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 23:30:35 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCHv2 net-next 2/2] Revert "bareudp: Fixed bareudp receive handling"
Date:   Fri, 15 Jan 2021 15:30:09 +0800
Message-Id: <1984207281c8f03b61968731487cd436dba40b80.1610695758.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <f85095ae5835c102d0b8434214f48084f4f4f279.1610695758.git.lucien.xin@gmail.com>
References: <cover.1610695758.git.lucien.xin@gmail.com>
 <f85095ae5835c102d0b8434214f48084f4f4f279.1610695758.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610695758.git.lucien.xin@gmail.com>
References: <cover.1610695758.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As udp_encap_enable() is already called in udp_tunnel_encap_enable()
since the last patch, and we don't need it any more. So remove it by
reverting commit 81f954a44567567c7d74a97b1db78fb43afc253d.
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

