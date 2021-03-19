Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F30B34197F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCSKGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:06:49 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:14955 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhCSKGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 06:06:38 -0400
X-Greylist: delayed 86079 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Mar 2021 06:06:38 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1616148393; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=nW2h1c6BOdakMygIypz9by6KNflUNSgEqRTyygs4wpIqHZD1RNWGjArDRYbP/TGuZU
    BYCE7yOBuu2Fj1Ik3DBvwgIW7GcMZeZgI05F6wnbTpi8edVtg/qO8LFitsUwTaRkOIXn
    fQlPXJVbtHPEwxyAhyJw2RCoVMf/fX3mu9rkuWWHNO5e85UYtVWjL4uhDZ+fj4D0CjTn
    NUYJO4FtSejFrnFFpnMoFh/pn+hZq7T4qjYLplHLPEeD+decq2VfGGBhAWZATT4eX0qm
    CtVF6FMQZ1acHX6484esZKEflfBA/qgN7/e2KDl6dPVRMTeUSTIQPQdTzs3O/ULs2fEe
    RsXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1616148393;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=zi3B7+zrZHG8aJQy2F6Ng2jMGgEBYU7pcqpOb+s3dDg=;
    b=aKwPxcwaXhI9DWUDsuT0PTLGACjFxuYYVGZvpetFsK9YW3kVAN7sbtWpIWUkHEYAcP
    UmMw4EY4hPw/i9DsoJymV8MCCB3c3/YegmPPofo3qlZLmQBDzdWLxqNw2jQcOGjMYEsG
    GRQEXR9PQv0vuBniDe02DU3YTZl/xKmXGCIYoxj2Xa827oyyQ3sZ4hapAUBb3rnR9xm9
    E5/cFagTrjqM/H/0L4Ppy4AMu4vY9pqgWV0MgqLZtxsQ08r4jjXXhFlgB4I8+yjTHzxQ
    Rg+qku+fd+JzQGTfJDWbUtVJbprw3CCHpiTOXDi0f8LyOUxUcVbx/dg5I672BjrNsgO6
    VHbQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1616148393;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=zi3B7+zrZHG8aJQy2F6Ng2jMGgEBYU7pcqpOb+s3dDg=;
    b=T0kWfqpXaQN4vhWIHiQg/nJ2ywtrZQv4Vds7i3JWUkIJmnT9/02EiH4AQqq1jIKmrf
    DLiOZZyrxOWhoP7l+ZKq8hhAptDJCqs/usJQmNB9SaL9MUNDuLYoOyEe5KhtuzrTWxH1
    2cPw6x98/dSfWhHTldDZlUsUIJJSjDs9POyUvnE7zBqckhovbjP5O5WqSoD87YrBpPgj
    TH7lUtt8wdWAfMeJSt2WHJ/1SrqKg7HkICbk+JwTmj94G+KJKRIII2n/G0TL3e9g7qWB
    ZaJY5krjtaJWNBFv3tFUio60Z90FTi6wlhfWUojhKCWUxD27vcdzWlQFyph/Dra1iftX
    tRPA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejuVLjM8tyWa"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.21.0 DYNA|AUTH)
    with ESMTPSA id R01debx2JA6X59H
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 19 Mar 2021 11:06:33 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH v2] can: isotp: tx-path: zero initialize outgoing CAN frames
Date:   Fri, 19 Mar 2021 11:06:19 +0100
Message-Id: <20210319100619.10858-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d4eb538e1f48 ("can: isotp: TX-path: ensure that CAN frame flags are
initialized") ensured the TX flags to be properly set for outgoing CAN
frames.

In fact the root cause of the issue results from a missing initialization
of outgoing CAN frames created by isotp. This is no problem on the CAN bus
as the CAN driver only picks the correctly defined content from the struct
can(fd)_frame. But when the outgoing frames are monitored (e.g. with
candump) we potentially leak some bytes in the unused content of
struct can(fd)_frame.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 430976485d95..15ea1234d457 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -194,11 +194,11 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 	can_skb_prv(nskb)->skbcnt = 0;
 
 	nskb->dev = dev;
 	can_skb_set_owner(nskb, sk);
 	ncf = (struct canfd_frame *)nskb->data;
-	skb_put(nskb, so->ll.mtu);
+	skb_put_zero(nskb, so->ll.mtu);
 
 	/* create & send flow control reply */
 	ncf->can_id = so->txid;
 
 	if (so->opt.flags & CAN_ISOTP_TX_PADDING) {
@@ -777,11 +777,11 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 		can_skb_reserve(skb);
 		can_skb_prv(skb)->ifindex = dev->ifindex;
 		can_skb_prv(skb)->skbcnt = 0;
 
 		cf = (struct canfd_frame *)skb->data;
-		skb_put(skb, so->ll.mtu);
+		skb_put_zero(skb, so->ll.mtu);
 
 		/* create consecutive frame */
 		isotp_fill_dataframe(cf, so, ae, 0);
 
 		/* place consecutive frame N_PCI in appropriate index */
@@ -893,11 +893,11 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	so->tx.state = ISOTP_SENDING;
 	so->tx.len = size;
 	so->tx.idx = 0;
 
 	cf = (struct canfd_frame *)skb->data;
-	skb_put(skb, so->ll.mtu);
+	skb_put_zero(skb, so->ll.mtu);
 
 	/* check for single frame transmission depending on TX_DL */
 	if (size <= so->tx.ll_dl - SF_PCI_SZ4 - ae - off) {
 		/* The message size generally fits into a SingleFrame - good.
 		 *
-- 
2.30.1

