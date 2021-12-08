Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355A746D8FE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbhLHQ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbhLHQ6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:58:15 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD047C0617A2
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 08:54:43 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v11so5121196wrw.10
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 08:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YN7SopJ792rYSyvS/k6+6PuXkEaW1GUeMvGKCe7x+ik=;
        b=J+TbOkyt82nIoJaFvHEWgDDTEY6jM1fG04zXfRHK4uHp2LoCSuRsMIvzHPOloJPfsz
         VaZ1RcPw20Qi/PxMrsxj6bgcTp87z/4dTXl2iA4FcKzjjbgaxslIvg9sdW3R6lTmb4Qy
         JVx6pAoQfeFiVVqQQc2Paml9c7cm6lLVlywQCauLw8o6e/3gchFs23/TPwxT82ak6mWH
         /3Hvg6pk8zCXVq+PaJHgcCWiDkz19z9r35eC4ltmWmrBjGCBRQlKs8S96fu7JIEWVitP
         ypmTeAf6FN8NZyySe4lTY1919vCTLZ39MyJwHM8iKCFaNzMUX06r7RXtEnuHhog3ukVi
         c2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YN7SopJ792rYSyvS/k6+6PuXkEaW1GUeMvGKCe7x+ik=;
        b=jf51zN66rj9wcUIwRzodqP2+TBacKrjHJyg54ZRfxzyQpaGFSWRWAXadDCqIAUULeX
         s1zH0RC7UuFEfkOMDydTF2Z82sW+Fz1zYhl7nZvF3yhdRQsZCmJUByBS4txvCrxDSwWx
         mZqlepvkZ3f2sGv4DJdEhjhvYJjweJCTo9L9H+6DRDCQphLfO0OrS7UftXtJ7L+M17UA
         DXtiu2g1IU3cPy/ZSlhbrMmq/EbiDOnRJIU+4VAlUmjtA+pW2UIAev9n9teYHw/PlqGi
         VHJc9DyT3qa4yx3OJPrnj+SCI+UTWIAS3WPvnr8/o0K2kvEoDNw2c0+qPv1mIeK+DoPE
         B37g==
X-Gm-Message-State: AOAM530KllYa/lEqqftmGSvZBX2eHPzS9gUGIdbtnAVryeetl7yf3Cto
        ymcSCCRc9g6ucBrbvAkaoUwDag==
X-Google-Smtp-Source: ABdhPJyCsxaHwjoJGpb1kpKdErG9QngK0st0jPwjBrFDcGdCXFGG2d4SLrzhQROA3gmmJTUxyr0unw==
X-Received: by 2002:a5d:64a2:: with SMTP id m2mr61750734wrp.248.1638982482311;
        Wed, 08 Dec 2021 08:54:42 -0800 (PST)
Received: from joneslee.c.googlers.com.com (205.215.190.35.bc.googleusercontent.com. [35.190.215.205])
        by smtp.gmail.com with ESMTPSA id y15sm4375735wry.72.2021.12.08.08.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:54:41 -0800 (PST)
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
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org
Subject: [PATCH 1/1] sctp: Protect cached endpoints to prevent possible UAF
Date:   Wed,  8 Dec 2021 16:54:34 +0000
Message-Id: <20211208165434.2962062-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cause of the resultant dump_stack() reported below is a
dereference of a freed pointer to 'struct sctp_endpoint' in
sctp_sock_dump().

This race condition occurs when a transport is cached into its
associated hash table then freed prior to its subsequent use in
sctp_diag_dump() which uses sctp_for_each_transport() to walk the
(now out of date) hash table calling into sctp_sock_dump() where the
dereference occurs.

To prevent this from happening we need to take a reference on the
to-be-used/dereferenced 'struct sctp_endpoint' until such a time when
we know it can be safely released.

When KASAN is not enabled, a similar, but slightly different NULL
pointer derefernce crash occurs later along the thread of execution in
inet_sctp_diag_fill() this time.

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
 net/sctp/associola.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index be29da09cc7ab..df171a297d095 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -499,8 +499,9 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 
 	/* Remove this peer from the list. */
 	list_del_rcu(&peer->transports);
-	/* Remove this peer from the transport hashtable */
+	/* Remove this peer from the transport hashtable and remove its reference */
 	sctp_unhash_transport(peer);
+	sctp_endpoint_put(asoc->ep);
 
 	/* Get the first transport of asoc. */
 	pos = asoc->peer.transport_addr_list.next;
@@ -710,11 +711,12 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	/* Set the peer's active state. */
 	peer->state = peer_state;
 
-	/* Add this peer into the transport hashtable */
+	/* Add this peer into the transport hashtable and take a reference */
 	if (sctp_hash_transport(peer)) {
 		sctp_transport_free(peer);
 		return NULL;
 	}
+	sctp_endpoint_hold(asoc->ep);
 
 	sctp_transport_pl_reset(peer);
 
-- 
2.34.1.400.ga245620fadb-goog

