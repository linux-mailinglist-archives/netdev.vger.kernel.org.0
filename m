Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547E85B08CD
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiIGPlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiIGPlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:41:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E207B98A54;
        Wed,  7 Sep 2022 08:41:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oVxBD-00066D-QS; Wed, 07 Sep 2022 17:41:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 3/8] netfilter: conntrack: remove unneeded indent level
Date:   Wed,  7 Sep 2022 17:41:05 +0200
Message-Id: <20220907154110.8898-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220907154110.8898-1-fw@strlen.de>
References: <20220907154110.8898-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After previous patch, the conditional branch is obsolete, reformat it.
gcc generates same code as before this change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 98 ++++++++++++--------------
 1 file changed, 45 insertions(+), 53 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 2d6925ef269f..0574290326d1 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -663,62 +663,54 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
 					  "ignored ACK under lower bound %u (possible overly delayed)",
 					  receiver->td_end - MAXACKWINDOW(sender) - 1);
-	if (1) {
-		/*
-		 * Take into account window scaling (RFC 1323).
-		 */
-		if (!tcph->syn)
-			win <<= sender->td_scale;
-
-		/*
-		 * Update sender data.
-		 */
-		swin = win + (sack - ack);
-		if (sender->td_maxwin < swin)
-			sender->td_maxwin = swin;
-		if (after(end, sender->td_end)) {
-			sender->td_end = end;
-			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
-		}
-		if (tcph->ack) {
-			if (!(sender->flags & IP_CT_TCP_FLAG_MAXACK_SET)) {
-				sender->td_maxack = ack;
-				sender->flags |= IP_CT_TCP_FLAG_MAXACK_SET;
-			} else if (after(ack, sender->td_maxack))
-				sender->td_maxack = ack;
-		}
 
-		/*
-		 * Update receiver data.
-		 */
-		if (receiver->td_maxwin != 0 && after(end, sender->td_maxend))
-			receiver->td_maxwin += end - sender->td_maxend;
-		if (after(sack + win, receiver->td_maxend - 1)) {
-			receiver->td_maxend = sack + win;
-			if (win == 0)
-				receiver->td_maxend++;
+	/* Take into account window scaling (RFC 1323). */
+	if (!tcph->syn)
+		win <<= sender->td_scale;
+
+	/* Update sender data. */
+	swin = win + (sack - ack);
+	if (sender->td_maxwin < swin)
+		sender->td_maxwin = swin;
+	if (after(end, sender->td_end)) {
+		sender->td_end = end;
+		sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+	}
+	if (tcph->ack) {
+		if (!(sender->flags & IP_CT_TCP_FLAG_MAXACK_SET)) {
+			sender->td_maxack = ack;
+			sender->flags |= IP_CT_TCP_FLAG_MAXACK_SET;
+		} else if (after(ack, sender->td_maxack)) {
+			sender->td_maxack = ack;
 		}
-		if (ack == receiver->td_end)
-			receiver->flags &= ~IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+	}
 
-		/*
-		 * Check retransmissions.
-		 */
-		if (index == TCP_ACK_SET) {
-			if (state->last_dir == dir
-			    && state->last_seq == seq
-			    && state->last_ack == ack
-			    && state->last_end == end
-			    && state->last_win == win_raw)
-				state->retrans++;
-			else {
-				state->last_dir = dir;
-				state->last_seq = seq;
-				state->last_ack = ack;
-				state->last_end = end;
-				state->last_win = win_raw;
-				state->retrans = 0;
-			}
+	/* Update receiver data. */
+	if (receiver->td_maxwin != 0 && after(end, sender->td_maxend))
+		receiver->td_maxwin += end - sender->td_maxend;
+	if (after(sack + win, receiver->td_maxend - 1)) {
+		receiver->td_maxend = sack + win;
+		if (win == 0)
+			receiver->td_maxend++;
+	}
+	if (ack == receiver->td_end)
+		receiver->flags &= ~IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+
+	/* Check retransmissions. */
+	if (index == TCP_ACK_SET) {
+		if (state->last_dir == dir &&
+		    state->last_seq == seq &&
+		    state->last_ack == ack &&
+		    state->last_end == end &&
+		    state->last_win == win_raw) {
+			state->retrans++;
+		} else {
+			state->last_dir = dir;
+			state->last_seq = seq;
+			state->last_ack = ack;
+			state->last_end = end;
+			state->last_win = win_raw;
+			state->retrans = 0;
 		}
 	}
 
-- 
2.35.1

