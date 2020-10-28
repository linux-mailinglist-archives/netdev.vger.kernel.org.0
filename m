Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D90929DBCC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390847AbgJ2ANu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390839AbgJ2ANt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXaFF-003uN5-Ll; Wed, 28 Oct 2020 02:27:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Wong Hoi Sing Edison <hswong3i@gmail.com>,
        Hung Hing Lun Mike <hlhung3i@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: ipv4: Fix some kerneldoc warnings in TCP Low Priority
Date:   Wed, 28 Oct 2020 02:27:03 +0100
Message-Id: <20201028012703.931632-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net//ipv4/tcp_lp.c:120: warning: Function parameter or member 'sk' not described in 'tcp_lp_cong_avoid'
net//ipv4/tcp_lp.c:135: warning: Function parameter or member 'sk' not described in 'tcp_lp_remote_hz_estimator'
net//ipv4/tcp_lp.c:188: warning: Function parameter or member 'sk' not described in 'tcp_lp_owd_calculator'
net//ipv4/tcp_lp.c:222: warning: Function parameter or member 'rtt' not described in 'tcp_lp_rtt_sample'
net//ipv4/tcp_lp.c:222: warning: Function parameter or member 'sk' not described in 'tcp_lp_rtt_sample'
net//ipv4/tcp_lp.c:265: warning: Function parameter or member 'sk' not described in 'tcp_lp_pkts_acked'
net//ipv4/tcp_lp.c:97: warning: Function parameter or member 'sk' not described in 'tcp_lp_init'

There are still a few kerneldoc warnings after this fix.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ipv4/tcp_lp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/tcp_lp.c b/net/ipv4/tcp_lp.c
index 8c643a4ffad1..e6459537d4d2 100644
--- a/net/ipv4/tcp_lp.c
+++ b/net/ipv4/tcp_lp.c
@@ -89,6 +89,7 @@ struct lp {
 
 /**
  * tcp_lp_init
+ * @sk: socket to initialize congestion control algorithm for
  *
  * Init all required variables.
  * Clone the handling from Vegas module implementation.
@@ -111,6 +112,7 @@ static void tcp_lp_init(struct sock *sk)
 
 /**
  * tcp_lp_cong_avoid
+ * @sk: socket to avoid congesting
  *
  * Implementation of cong_avoid.
  * Will only call newReno CA when away from inference.
@@ -126,6 +128,7 @@ static void tcp_lp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 
 /**
  * tcp_lp_remote_hz_estimator
+ * @sk: socket which needs an estimate for the remote HZs
  *
  * Estimate remote HZ.
  * We keep on updating the estimated value, where original TCP-LP
@@ -176,6 +179,7 @@ static u32 tcp_lp_remote_hz_estimator(struct sock *sk)
 
 /**
  * tcp_lp_owd_calculator
+ * @sk: socket to calculate one way delay for
  *
  * Calculate one way delay (in relative format).
  * Original implement OWD as minus of remote time difference to local time
@@ -210,6 +214,8 @@ static u32 tcp_lp_owd_calculator(struct sock *sk)
 
 /**
  * tcp_lp_rtt_sample
+ * @sk: socket to add a rtt sample to
+ * @rtt: round trip time, which is ignored!
  *
  * Implementation or rtt_sample.
  * Will take the following action,
@@ -254,6 +260,7 @@ static void tcp_lp_rtt_sample(struct sock *sk, u32 rtt)
 
 /**
  * tcp_lp_pkts_acked
+ * @sk: socket requiring congestion avoidance calculations
  *
  * Implementation of pkts_acked.
  * Deal with active drop under Early Congestion Indication.
-- 
2.28.0

