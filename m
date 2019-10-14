Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10AF8D5B1B
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 08:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfJNGPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 02:15:06 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39984 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfJNGPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 02:15:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id e13so1248032pga.7;
        Sun, 13 Oct 2019 23:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=whJBGbUMkV3xUHWgAj3VyT9WXAoGTLtFtkwQ6LiTK34=;
        b=nTeF4AUV4StUJ6hzls05v8dWc14FaWnGitUvFilCPUD161mL1VbSF2xooEPT1DCNpO
         DgaGTXo4KK73K8aD1lRubAH39ymTO6y8uou74Wds+X3sF+vgpc5O7JLBeSH4GISL1EWn
         rjOLJn+TD5EAOnpzFCzutGa3Y/lGwPuihtwnYJa9djT8EWnyVTav6+nUneD2JzWz45mu
         /+gGJLRkkpsocOCgRPutvQoPQjqaK141sY6Xbb/+mXOXIlisl60DFOiwV6yofkSxgVrV
         h8r9aERvmA7jJM5U436oEcianMwHHuorDtRI9bKjqKpE+a6PrDF6/6RENMyVZDgPwBHf
         jGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=whJBGbUMkV3xUHWgAj3VyT9WXAoGTLtFtkwQ6LiTK34=;
        b=TtYSCbI1MUMmyk0AU1g2aiTKRSKnn+MAi2XeyNwpHsACSLZn0BdxoVt5wbyMOuAapA
         y8nDWM8nsf5Bh0nAhKnq4fWgABHRNjwldqrHKNxnHMCRtjvUvsntNFjfOvlJ2h92XbR3
         ygLSWbdknc7pN9Jvuzgd8K8JKLS658fO+Uu+BTG1boEVLnZ6jdKyhXyMtWIgEAuUe71B
         SikfpXQY/IcVyQTOvZdc7wHLhcRGC8j6qGMnlcQsw/q+oKD28jwM930VNCnL460v10BQ
         5Q80e1kJccWg4wnf2P6WxSZNUVnr+NC5LN5VGgbQYSa5e3tepv7d7ceHqDpSs50lw20T
         XfSw==
X-Gm-Message-State: APjAAAW1jJJMsayesZxJKTrVGLMDrSk7zVaSR+BNib3USRpBOYEd8h15
        XOZXmvBNMzikcwfLjOCuO05RCRYj
X-Google-Smtp-Source: APXvYqxLWqf1KZyVsJEkGEXMj0eo3/fOV+dlXkJoSAzJppL+s9lFG4J/X6Ovk/L+yHLEqnjQGV/XjA==
X-Received: by 2002:a63:81:: with SMTP id 123mr31985161pga.47.1571033705396;
        Sun, 13 Oct 2019 23:15:05 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h2sm22200469pfq.108.2019.10.13.23.15.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Oct 2019 23:15:04 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
Date:   Mon, 14 Oct 2019 14:14:44 +0800
Message-Id: <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
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

v1->v2:
  - no change
v2->v3:
  - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  2 ++
 net/sctp/associola.c      | 17 ++++-------------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6bce7f9..f4ab7bb 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -410,6 +410,8 @@ enum sctp_spc_state {
 	SCTP_ADDR_ADDED,
 	SCTP_ADDR_MADE_PRIM,
 	SCTP_ADDR_CONFIRMED,
+	SCTP_ADDR_POTENTIALLY_FAILED,
+#define SCTP_ADDR_PF	SCTP_ADDR_POTENTIALLY_FAILED
 };
 
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 1ba893b..4f9efba 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
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
 
@@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
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

