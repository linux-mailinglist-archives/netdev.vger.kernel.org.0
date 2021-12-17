Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F170C478CA2
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 14:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbhLQNqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 08:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbhLQNqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 08:46:20 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D46C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 05:46:19 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id a83-20020a1c9856000000b00344731e044bso1598894wme.1
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 05:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0obl21iZR0lkADysAF+uXIHY+MyTcv+XohfoKgeHmoc=;
        b=GUMzU+8l/FJQzoox8E72I4FZi/DJk/mn9M8tUTo8bNI0vy+1f6RQ+hubtJY5zXyAoY
         AtYZMpBa0lzlMYcQrfx2IAr1dLlSucHDCvTK+ImWw45hh4sVBvwC+YGoPB+TgcwHzBNw
         rvlLbuNZxvprX8G4aeRHEVN8XTmciYj6N9tRdyyjCW1S147vXXB6uG0dFjrAYZxuriAI
         AAPN3xjAhSonuvbdOKdJmGnHLUrOHRumj8UA4nMY0unVwlkA2ZGy4YPu6GQ6NPs3syA9
         +7zBmC0eRVYpuLxUGMLl6+9EUXf0d6zfhwDXVMs/CXud1+/LE6MTFW641nyKbQfUwoXh
         vLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0obl21iZR0lkADysAF+uXIHY+MyTcv+XohfoKgeHmoc=;
        b=Ndj+yUYEZeJ11Sxmew9RqEJFxCn9gsFyXIz0sKxbf3PeB41EwYutLfbbLZ8O27EILh
         gE9iMp/9br4UmSqN5l4+4aKqmfFDSLCAAgEupNRU7D3fGzjgVHvWUGtggq3+nd7hZt8N
         9TWXTZYfW4l0omXxOw3MFNFD6Rp+rHnI+WieJ9RDM5KTGVMBZYqHFTe5tplDdW+61NBA
         Ekzo85SfbGelClKvDgLGcYjPtC1mKqjX3Z8r5JJWo4lK1vvg1Fa1ngltYDJn1dL9Jh07
         vmY3htFm2F+rU2KgjhdPxWmYWeN70Z4AGU/1+wpWD7qB3Ct39I5JiLFPj6qCWxCdTjc5
         A1sQ==
X-Gm-Message-State: AOAM531uw/vDV7ARTkqFOcjuoUCfmFJV4RYQvKE+uitX+MxY5G9zIY4l
        V8lQqa+YlejsqB8ZjK0yv3avEQ==
X-Google-Smtp-Source: ABdhPJw3P8AiQQU5c6syEbLtfJP1Xkb6Gq6R4POK5yGZE5YI4XJEmuga360nxWaiDJtrq3Q9+akx7A==
X-Received: by 2002:a05:600c:3d06:: with SMTP id bh6mr9721991wmb.40.1639748778419;
        Fri, 17 Dec 2021 05:46:18 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id a22sm7106009wme.19.2021.12.17.05.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 05:46:17 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] sctp: hold cached endpoints to prevent possible UAF
Date:   Fri, 17 Dec 2021 13:46:07 +0000
Message-Id: <20211217134607.74983-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211217134607.74983-1-lee.jones@linaro.org>
References: <20211217134607.74983-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cause of the resultant dump_stack() reported below is a
dereference of a freed pointer to 'struct sctp_endpoint' in
sctp_sock_dump().

This race condition occurs when a transport is cached into its
associated hash table followed by an endpoint/sock migration to a new
association in sctp_assoc_migrate() prior to their subsequent use in
sctp_diag_dump() which uses sctp_for_each_transport() to walk the hash
table calling into sctp_sock_dump() where the dereference occurs.

  BUG: KASAN: use-after-free in sctp_sock_dump+0xa8/0x438 [sctp_diag]
  Call trace:
   dump_backtrace+0x0/0x2dc
   show_stack+0x20/0x2c
   dump_stack+0x120/0x144
   print_address_description+0x80/0x2f4
   __kasan_report+0x174/0x194
   kasan_report+0x10/0x18
   __asan_load8+0x84/0x8c
   sctp_sock_dump+0xa8/0x438 [sctp_diag]
   sctp_for_each_transport+0x1e0/0x26c [sctp]
   sctp_diag_dump+0x180/0x1f0 [sctp_diag]
   inet_diag_dump+0x12c/0x168
   netlink_dump+0x24c/0x5b8
   __netlink_dump_start+0x274/0x2a8
   inet_diag_handler_cmd+0x224/0x274
   sock_diag_rcv_msg+0x21c/0x230
   netlink_rcv_skb+0xe0/0x1bc
   sock_diag_rcv+0x34/0x48
   netlink_unicast+0x3b4/0x430
   netlink_sendmsg+0x4f0/0x574
   sock_write_iter+0x18c/0x1f0
   do_iter_readv_writev+0x230/0x2a8
   do_iter_write+0xc8/0x2b4
   vfs_writev+0xf8/0x184
   do_writev+0xb0/0x1a8
   __arm64_sys_writev+0x4c/0x5c
   el0_svc_common+0x118/0x250
   el0_svc_handler+0x3c/0x9c
   el0_svc+0x8/0xc

To prevent this from happening we need to take a reference to the
to-be-used/dereferenced 'struct sctp_endpoint' (which inherently
holds a reference to the problematic 'struct sock') until such a time
when we know they can be safely released.

When KASAN is not enabled, a similar, but slightly different NULL
pointer derefernce crash occurs later along the thread of execution.
This time in inet_sctp_diag_fill().

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: lksctp developers <linux-sctp@vger.kernel.org>
Cc: "H.P. Yarroll" <piggy@acm.org>
Cc: Karl Knutson <karl@athena.chicago.il.us>
Cc: Jon Grimm <jgrimm@us.ibm.com>
Cc: Xingang Guo <xingang.guo@intel.com>
Cc: Hui Huang <hui.huang@nokia.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Daisy Chang <daisyc@us.ibm.com>
Cc: Ryan Layer <rmlayer@us.ibm.com>
Cc: Kevin Gao <kevin.gao@intel.com>
Cc: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 8f840e47f190c ("sctp: add the sctp_diag.c file")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 net/sctp/diag.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 760b367644c12..998488a56ce2b 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -292,15 +292,17 @@ static int sctp_tsp_dump_one(struct sctp_transport *tsp, void *p)
 
 static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
 {
-	struct sctp_endpoint *ep = tsp->asoc->ep;
+	struct sctp_endpoint *ep;
 	struct sctp_comm_param *commp = p;
-	struct sock *sk = ep->base.sk;
+	struct sock *sk;
 	struct sk_buff *skb = commp->skb;
 	struct netlink_callback *cb = commp->cb;
 	const struct inet_diag_req_v2 *r = commp->r;
 	struct sctp_association *assoc;
 	int err = 0;
 
+	ep = sctp_endpoint_hold(tsp->asoc->ep);
+	sk = ep->base.sk;
 	lock_sock(sk);
 	list_for_each_entry(assoc, &ep->asocs, asocs) {
 		if (cb->args[4] < cb->args[1])
@@ -341,6 +343,7 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
 	cb->args[4] = 0;
 release:
 	release_sock(sk);
+	sctp_endpoint_put(ep);
 	return err;
 }
 
-- 
2.34.1.173.g76aa8bc2d0-goog

