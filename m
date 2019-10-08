Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE9BCF80D
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfJHLZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:25:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40450 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730051AbfJHLZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:25:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so10592520pfb.7;
        Tue, 08 Oct 2019 04:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=AB1k581sdOY84l1zHfQqHfAjO9h11FT8EGrtEeXje6o=;
        b=dq5AK6AXZ53X1TXw65lwLbNpgxMgkruo9ggO5PRphJZM4tIDPYO7GUh1gfqQhd1FD2
         iw21jXEj9z9vDJJWBkthfiMo583wz3ol2Wifx+gfjccujC8gzrtPvu/LkMfMqrgL41Ag
         USBvwUGTHfE1iBXm8TP8u2mVjftlgpnUBP8NCjTQtYyTjEDyNJFZt6Q9u8FQXKyl/kOM
         6bHvXVuOOFfAfJEfZlVtpsebU5rHDQg6Pbg7c04e6AApwAjNG90htBbNZ1Cn1+M05PE7
         S+HO6bFf7oNgyUVcNuKnsVt1LHbdIZ6BTnsP5MUwKggBv/MS3cwmlWsayHDItO0W0O+P
         ukxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=AB1k581sdOY84l1zHfQqHfAjO9h11FT8EGrtEeXje6o=;
        b=cE5k6UGlhLxZI5NywQAbphtD7B/q/eIgLp5uMHGUC2PGg4AODfg8T9jT34sUOUChw1
         fbpkoQZArWr+ZxDA4k8zkOz3tUyWMUhCWoX9YR1FoMOvDY9tdLW4zi7uB6/Tqu6QuDs9
         TlidQIr+IuIN8cU6YNKq2eIOWhb/Uim7mgWzW0Lvt7oUu/NcdGPtik+xQCDLVSSLx6y6
         vNJMnKOOi9rRalvGqMWHp+yP5jXpKol9eZNxPJvzVJp3OkAFMecxPCgzPTU9cuwGTW6p
         0GgqEegpk4AwPWalNR3rUNODfKcT8uCl9INGLb/ipEcLeFqA8Tr/akeVLUuS2HfZpz2a
         KGVg==
X-Gm-Message-State: APjAAAU8g73VYpZlRu/ih56VwSNwW7odqzhsWe7J+mot/LNRPvksCwDN
        ejgJzFzfzjRpC5xgVQDwW8Y9H0gv
X-Google-Smtp-Source: APXvYqy0qDzupQg/gh6I3vhJiAzhkEdRTTmTBQEdcBcLeNBlPwZjuBV2UzKSXYHV9Ls7T3lUu7uzsQ==
X-Received: by 2002:a63:1401:: with SMTP id u1mr3741455pgl.73.1570533923960;
        Tue, 08 Oct 2019 04:25:23 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h1sm17358499pfk.124.2019.10.08.04.25.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:25:23 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
Date:   Tue,  8 Oct 2019 19:25:03 +0800
Message-Id: <bca4cbf1bee8ad2379b2fe9536b3404fc0935579.1570533716.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1570533716.git.lucien.xin@gmail.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570533716.git.lucien.xin@gmail.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SCTP Quick failover draft section 5.1, point 5 has been removed
from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
Layer Protocol (ULP) about this state transition", as said in
section 3.2, point 8.

So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
in section 7.1, "which is reported if the affected address
becomes PF". Also remove transport cwnd's update when moving
from PF back to ACTIVE , which is no longer in rfc7829 either.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/associola.c      | 17 ++++-------------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6d5b164..45a85d7 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -410,6 +410,7 @@ enum sctp_spc_state {
 	SCTP_ADDR_ADDED,
 	SCTP_ADDR_MADE_PRIM,
 	SCTP_ADDR_CONFIRMED,
+	SCTP_ADDR_POTENTIALLY_FAILED,
 };
 
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d2ffc9a..7278b7e 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -798,14 +798,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 			spc_state = SCTP_ADDR_CONFIRMED;
 		else
 			spc_state = SCTP_ADDR_AVAILABLE;
-		/* Don't inform ULP about transition from PF to
-		 * active state and set cwnd to 1 MTU, see SCTP
-		 * Quick failover draft section 5.1, point 5
-		 */
-		if (transport->state == SCTP_PF) {
-			ulp_notify = false;
-			transport->cwnd = asoc->pathmtu;
-		}
 		transport->state = SCTP_ACTIVE;
 		break;
 
@@ -814,19 +806,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 * to inactive state.  Also, release the cached route since
 		 * there may be a better route next time.
 		 */
-		if (transport->state != SCTP_UNCONFIRMED)
+		if (transport->state != SCTP_UNCONFIRMED) {
 			transport->state = SCTP_INACTIVE;
-		else {
+			spc_state = SCTP_ADDR_UNREACHABLE;
+		} else {
 			sctp_transport_dst_release(transport);
 			ulp_notify = false;
 		}
-
-		spc_state = SCTP_ADDR_UNREACHABLE;
 		break;
 
 	case SCTP_TRANSPORT_PF:
 		transport->state = SCTP_PF;
-		ulp_notify = false;
+		spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
 		break;
 
 	default:
-- 
2.1.0

