Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B383921CC18
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgGLXQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:16:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgGLXPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPH-K5; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>
Subject: [PATCH net-next 04/20] net: dccp: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:00 +0200
Message-Id: <20200712231516.1139335-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dccp/ccids/lib/packet_history.c | 2 ++
 net/dccp/feat.c                     | 6 ++++++
 net/dccp/input.c                    | 1 +
 net/dccp/ipv4.c                     | 2 ++
 net/dccp/options.c                  | 4 ++++
 net/dccp/timer.c                    | 2 ++
 6 files changed, 17 insertions(+)

diff --git a/net/dccp/ccids/lib/packet_history.c b/net/dccp/ccids/lib/packet_history.c
index 2d41bb036271..5f749da20759 100644
--- a/net/dccp/ccids/lib/packet_history.c
+++ b/net/dccp/ccids/lib/packet_history.c
@@ -365,6 +365,7 @@ void tfrc_rx_hist_purge(struct tfrc_rx_hist *h)
 
 /**
  * tfrc_rx_hist_rtt_last_s - reference entry to compute RTT samples against
+ * @h:	The non-empty RX history object
  */
 static inline struct tfrc_rx_hist_entry *
 			tfrc_rx_hist_rtt_last_s(const struct tfrc_rx_hist *h)
@@ -374,6 +375,7 @@ static inline struct tfrc_rx_hist_entry *
 
 /**
  * tfrc_rx_hist_rtt_prev_s - previously suitable (wrt rtt_last_s) RTT-sampling entry
+ * @h:	The non-empty RX history object
  */
 static inline struct tfrc_rx_hist_entry *
 			tfrc_rx_hist_rtt_prev_s(const struct tfrc_rx_hist *h)
diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index 9c3b5e056234..afc071ea1271 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -165,6 +165,8 @@ static const struct {
 
 /**
  * dccp_feat_index  -  Hash function to map feature number into array position
+ * @feat_num: feature to hash, one of %dccp_feature_numbers
+ *
  * Returns consecutive array index or -1 if the feature is not understood.
  */
 static int dccp_feat_index(u8 feat_num)
@@ -567,6 +569,8 @@ int dccp_feat_clone_list(struct list_head const *from, struct list_head *to)
 
 /**
  * dccp_feat_valid_nn_length  -  Enforce length constraints on NN options
+ * @feat_num: feature to return length of, one of %dccp_feature_numbers
+ *
  * Length is between 0 and %DCCP_OPTVAL_MAXLEN. Used for outgoing packets only,
  * incoming options are accepted as long as their values are valid.
  */
@@ -1429,6 +1433,8 @@ int dccp_feat_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 
 /**
  * dccp_feat_init  -  Seed feature negotiation with host-specific defaults
+ * @sk: Socket to initialize.
+ *
  * This initialises global defaults, depending on the value of the sysctls.
  * These can later be overridden by registering changes via setsockopt calls.
  * The last link in the chain is finalise_settings, to make sure that between
diff --git a/net/dccp/input.c b/net/dccp/input.c
index 6dce68a55964..bd9cfdb67436 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -715,6 +715,7 @@ EXPORT_SYMBOL_GPL(dccp_rcv_state_process);
 
 /**
  *  dccp_sample_rtt  -  Validate and finalise computation of RTT sample
+ *  @sk:	socket structure
  *  @delta:	number of microseconds between packet and acknowledgment
  *
  *  The routine is kept generic to work in different contexts. It should be
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index d19557c6d04b..a7e989919c53 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -694,6 +694,8 @@ EXPORT_SYMBOL_GPL(dccp_v4_do_rcv);
 
 /**
  *	dccp_invalid_packet  -  check for malformed packets
+ *	@skb: Packet to validate
+ *
  *	Implements RFC 4340, 8.5:  Step 1: Check header basics
  *	Packets that fail these checks are ignored and do not receive Resets.
  */
diff --git a/net/dccp/options.c b/net/dccp/options.c
index 3b42f5c6a63d..daa9eed92646 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -43,6 +43,7 @@ u64 dccp_decode_value_var(const u8 *bf, const u8 len)
  * dccp_parse_options  -  Parse DCCP options present in @skb
  * @sk: client|server|listening dccp socket (when @dreq != NULL)
  * @dreq: request socket to use during connection setup, or NULL
+ * @skb: frame to parse
  */
 int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 		       struct sk_buff *skb)
@@ -471,6 +472,8 @@ static int dccp_insert_option_ackvec(struct sock *sk, struct sk_buff *skb)
 
 /**
  * dccp_insert_option_mandatory  -  Mandatory option (5.8.2)
+ * @skb: frame into which to insert option
+ *
  * Note that since we are using skb_push, this function needs to be called
  * _after_ inserting the option it is supposed to influence (stack order).
  */
@@ -486,6 +489,7 @@ int dccp_insert_option_mandatory(struct sk_buff *skb)
 
 /**
  * dccp_insert_fn_opt  -  Insert single Feature-Negotiation option into @skb
+ * @skb: frame to insert feature negotiation option into
  * @type: %DCCPO_CHANGE_L, %DCCPO_CHANGE_R, %DCCPO_CONFIRM_L, %DCCPO_CONFIRM_R
  * @feat: one out of %dccp_feature_numbers
  * @val: NN value or SP array (preferred element first) to copy
diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index c0b3672637c4..0e06dfc32273 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -216,6 +216,8 @@ static void dccp_delack_timer(struct timer_list *t)
 
 /**
  * dccp_write_xmitlet  -  Workhorse for CCID packet dequeueing interface
+ * @data: Socket to act on
+ *
  * See the comments above %ccid_dequeueing_decision for supported modes.
  */
 static void dccp_write_xmitlet(unsigned long data)
-- 
2.27.0.rc2

