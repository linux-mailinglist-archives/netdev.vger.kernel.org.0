Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412A65C47E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfGAUsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:48:38 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:47337 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfGAUsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:48:38 -0400
Received: by mail-pf1-f202.google.com with SMTP id f25so9457403pfk.14
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 13:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=trs1LCZx1TeDDlzbf8u9lj0ooqYGUeGGwTht5ffRyCA=;
        b=LpjuZE5hTGrhyLFusN8A6V+yFsTdeaC36wGSyEmptDZvldo6yIwX3eTbQBEwHkBNbj
         kJDC8WMmY8PUQM5Hmai/ZjI11wDiog/6hYLgXgMergZ0UBUqgFCdit9SvfHK4qukabne
         Z14y1v0oEitpa2XkHpwePf0vVrEkg7WFiUM3ga2H0oWnB0K7ZQLkuZC1p6aiIIs9JL08
         AOzib1murpjC7z3Tj19BNQgFGHwUpA+qB7vH3mh+CcUxQSiX54pYvjKQF7SDimbZxZv1
         mUSgKNPDPq5d/H/BVYZ1hr9Iy9Ud9qFiPjS+oee8qTPlEhUexUv+CnNshFcNCegwQCMR
         kfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=trs1LCZx1TeDDlzbf8u9lj0ooqYGUeGGwTht5ffRyCA=;
        b=rsOU3No2d3vykoGbl4vaozhEdcLqpTcFXPBc1OhzMBwEZQUAlTkoBFBWuVdwfSd25Y
         MCGcHdSFOtsn6j56950608rnsNwZKHA7dWsbFlvkAuzu/54bXU4siR6+V/uw55z41J1W
         6EWX42C3zardE0MMEQWaoobqvh6tJaWB4NpofW3ajhM4ALPpC02QEIm5WGFgTEmC98Oc
         VY4MSw45qBkGdbx0NHk1pRSxEgYxtmD6slSnM5sXE0OxYTYnuCetLqjdAknGPATk/c4e
         LPJAAHcvxvFA5i9diz69bqe55yAc8EMROtbW87kp1PypmHvR3kqU7Fm1vBRd4HdC8kZc
         WA2g==
X-Gm-Message-State: APjAAAUAJutzY4cx6o0X7XQ/Y9zxjbEoIl5ZZ5dvwnJL7vpTpX1++5Pa
        9iD9M3fijj4LvAXTUgLxkaRIzqiNIHED5Cb/PuXFqXBzKwH5Z5RvLwgrkI2kYnZRW1bSIUR6m2J
        rXiNcCtkQz71F47yH/Cu1iilrrQ8i9Gflc7SraA+DOqgcVp5blJc75Q==
X-Google-Smtp-Source: APXvYqySZn0GhS6hgtrVmYWiMjcvhaykE73XPjMP/X/0xZ6541raOaFGRHwei8AZOFLSrObM2gStiOI=
X-Received: by 2002:a63:5a0a:: with SMTP id o10mr27271957pgb.282.1562014117078;
 Mon, 01 Jul 2019 13:48:37 -0700 (PDT)
Date:   Mon,  1 Jul 2019 13:48:18 -0700
In-Reply-To: <20190701204821.44230-1-sdf@google.com>
Message-Id: <20190701204821.44230-6-sdf@google.com>
Mime-Version: 1.0
References: <20190701204821.44230-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next 5/8] bpf/tools: sync bpf.h
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync new bpf_tcp_sock fields and new BPF_PROG_TYPE_SOCK_OPS RTT callback.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a396b516a2b2..cecf42c871d4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1767,6 +1767,7 @@ union bpf_attr {
  * 		* **BPF_SOCK_OPS_RTO_CB_FLAG** (retransmission time out)
  * 		* **BPF_SOCK_OPS_RETRANS_CB_FLAG** (retransmission)
  * 		* **BPF_SOCK_OPS_STATE_CB_FLAG** (TCP state change)
+ * 		* **BPF_SOCK_OPS_RTT_CB_FLAG** (every RTT)
  *
  * 		Therefore, this function can be used to clear a callback flag by
  * 		setting the appropriate bit to zero. e.g. to disable the RTO
@@ -3069,6 +3070,12 @@ struct bpf_tcp_sock {
 				 * sum(delta(snd_una)), or how many bytes
 				 * were acked.
 				 */
+	__u32 dsack_dups;	/* RFC4898 tcpEStatsStackDSACKDups
+				 * total number of DSACK blocks received
+				 */
+	__u32 delivered;	/* Total data packets delivered incl. rexmits */
+	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
+	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
 };
 
 struct bpf_sock_tuple {
@@ -3311,7 +3318,8 @@ struct bpf_sock_ops {
 #define BPF_SOCK_OPS_RTO_CB_FLAG	(1<<0)
 #define BPF_SOCK_OPS_RETRANS_CB_FLAG	(1<<1)
 #define BPF_SOCK_OPS_STATE_CB_FLAG	(1<<2)
-#define BPF_SOCK_OPS_ALL_CB_FLAGS       0x7		/* Mask of all currently
+#define BPF_SOCK_OPS_RTT_CB_FLAG	(1<<3)
+#define BPF_SOCK_OPS_ALL_CB_FLAGS       0xF		/* Mask of all currently
 							 * supported cb flags
 							 */
 
@@ -3366,6 +3374,8 @@ enum {
 	BPF_SOCK_OPS_TCP_LISTEN_CB,	/* Called on listen(2), right after
 					 * socket transition to LISTEN state.
 					 */
+	BPF_SOCK_OPS_RTT_CB,		/* Called on every RTT.
+					 */
 };
 
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detect
-- 
2.22.0.410.gd8fdbe21b5-goog

