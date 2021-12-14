Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F7C474BCD
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhLNTXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhLNTXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 14:23:08 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8BAC06173E
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 11:23:08 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v11so34144345wrw.10
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 11:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9MfX+ladgz8v1uPlUvt81YDUVI2BVYjumD0vKwEPZL8=;
        b=WqDW2eYz3b7YYPBATttXaZ6buiyp4VM0CVsPBNwqwvYXLJqSfLdSDpj5RehBf1rzm8
         0NGFCRKTByBHutzxvd6c3nFRfg7S5gUxzyjAsZRCB6ZNpHiZ2kV4SDb8uD7YJDElQvlZ
         OKIIpRv009ozrHeUDnGuQDG22K2U2mBGC0ta7+gNfXDSXxmilG4PK8PLbtJqfFIzJDBA
         z8MvgBO9eoTIaFj2zVPC3py7D9VrBVFftahzSaKfwtYSDwwnGClk+GUSkt5Geu8DLPDe
         AYpoiIGXYQQWCabokDuhcVDYZs+WEqYPRuJCe9jGgGOnOOBFi7boE3CqCm1HAkh3//a8
         O05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9MfX+ladgz8v1uPlUvt81YDUVI2BVYjumD0vKwEPZL8=;
        b=oVEpUkhp/UtAvUTVM52jBLqocR4CB2awtFwJqCWXXZX8dFW+2moffSAdJXne1mfGRO
         vULe2gZ54Y3BFuhLRopxcHN4AuB0/iLWqVWcouiZNGs20/yEUHrZN9ArHA0jhm41KVZ8
         PRmWdjKeEjn1C4wdv8EC0QmGf6gVb6yizIWpeBBi3QJnyXhpLiiTdc+93Fp5a+coSx/7
         T7hYYsRQ2jYH4jBgw7DC6ouOrh9iBJ2TTQN9asJqf+9Q/sNCnM0D0WKPOaW+VzSgEMIz
         lVzU7RrznoZQJgfpKoyCN4Zmih4fjpXdqSjrO2T3/XIMWGVsVgC2g8+jJa8mpqgXabCK
         Y1Fw==
X-Gm-Message-State: AOAM531nbU7QbOsHIySvNzcsdh6H0yaivBAnpm5XOEcxqRRQCNf3IhYj
        737zm4stp5eyhWnWPIHyA+jzUg==
X-Google-Smtp-Source: ABdhPJwoBMoW5TWXaHsl8SQQzk0cq/QVYi0kpQ4LMnACrafWI+8XOMMdce8J0U4u6zLy20HzGg6EZA==
X-Received: by 2002:a5d:6211:: with SMTP id y17mr1055106wru.97.1639509786687;
        Tue, 14 Dec 2021 11:23:06 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id d7sm672169wrw.87.2021.12.14.11.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 11:23:06 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
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
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org
Subject: [PATCH 2/2] sctp: hold cached endpoints to prevent possible UAF
Date:   Tue, 14 Dec 2021 19:23:01 +0000
Message-Id: <20211214192301.1496754-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
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

To prevent this from happening we need to take a references to the
to-be-used/dereferenced 'struct sock' and 'struct sctp_endpoint's
until such a time when we know it can be safely released.

When KASAN is not enabled, a similar, but slightly different NULL
pointer derefernce crash occurs later along the thread of execution in
inet_sctp_diag_fill() this time.

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
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 net/sctp/diag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 760b367644c12..2029b240b6f24 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -301,6 +301,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
 	struct sctp_association *assoc;
 	int err = 0;
 
+	sctp_endpoint_hold(ep);
+	sock_hold(sk);
 	lock_sock(sk);
 	list_for_each_entry(assoc, &ep->asocs, asocs) {
 		if (cb->args[4] < cb->args[1])
@@ -341,6 +343,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
 	cb->args[4] = 0;
 release:
 	release_sock(sk);
+	sock_put(sk);
+	sctp_endpoint_put(ep);
 	return err;
 }
 
-- 
2.34.1.173.g76aa8bc2d0-goog

