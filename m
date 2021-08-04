Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8753E0763
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 20:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbhHDSPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 14:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240209AbhHDSPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 14:15:39 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F58C061386
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 11:15:24 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d9so1976794qty.12
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 11:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YNMPWWBoaClDGCzWpP/bGEyzR71g8h2gDLmLD16sqJc=;
        b=dwv8cmFeTB/7VVduIcYiuL/mX+jCj7V+qshDvgeCJomNbA3KYyc8eOzU/rRMrRTrIa
         4nH8MAL3joHu6VfHDN/W4dMfiUBT1PH4tN7ThSJjFTK48804An6Sykg1ZxXoxXGjXJ2O
         Ray/GPoTItoOH1JURgh3RqjooinZGalbRpHS8NCh8qnW7q4yFWDIb1yr1E3Lt7YyOPXQ
         sfB3ga71JWUdZUFTHNg2Ffu4MGlKH27sWf85XB6G0mS+FohNqyX6itQ3REmyWA63HXK9
         qBbI2igROkIdTL4gFQkqfrfUImvDgxB/iOVLLe2gTpZM8D6RIWiQkq9cslDqIZ+JZcuh
         3tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YNMPWWBoaClDGCzWpP/bGEyzR71g8h2gDLmLD16sqJc=;
        b=ZxmhOL2sn1ZO1HS9aHHvkjU3QYK+RP7aqIISXmTTZ/JM5jczdJsQfsvRdR2+x/0WSG
         +nDKpx+CcRhnWAEzSAdol3t9U/D6jVwfdt4kl9jt7PnV5Tbk0LQgp1H6ErG6UnnEhH8M
         MbMSXLzM887aVbe3THqmygXh4glNi29p3iIB8fV7ujppZcLeA7Hf2FMJDMKtbcR663HW
         q6oB1IN2UQMfiibctlJSR6A7Pom0Geo7QlHZtB7gonyBbwWefQaQlQJPGcEAT7Qj8ANy
         8PnZFp18T0uhr63cOlEWDuwuURz81qqcAmksoKH8ztQRRUgkc2Q5fgTpJob4Crqs8san
         ko3Q==
X-Gm-Message-State: AOAM530cE67VKAxLWqEo/SL4kZdI42PNCVW1iFvFwfwzrp/snxD4E3qE
        yT6bQrOef5C3mDqY/+kcI1Mrf70Ibw==
X-Google-Smtp-Source: ABdhPJxtODBKKDWpkK5B60tvRWXTc7iG4hvoQDOnQtMHxbHKP/VYK7GonODk1WGEEZlzVyPHgG+GBw==
X-Received: by 2002:ac8:44da:: with SMTP id b26mr778139qto.81.1628100923510;
        Wed, 04 Aug 2021 11:15:23 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id g20sm1635952qki.73.2021.08.04.11.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 11:15:23 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next v3] tc/skbmod: Introduce SKBMOD_F_ECN option
Date:   Wed,  4 Aug 2021 11:15:16 -0700
Message-Id: <20210804181516.11921-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721232053.39077-1-yepeilin.cs@gmail.com>
References: <20210721232053.39077-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we added SKBMOD_F_ECN option support to the kernel; support it in
the tc-skbmod(8) front end, and update its man page accordingly.

The 2 least significant bits of the Traffic Class field in IPv4 and IPv6
headers are used to represent different ECN states [1]:

	0b00: "Non ECN-Capable Transport", Non-ECT
	0b10: "ECN Capable Transport", ECT(0)
	0b01: "ECN Capable Transport", ECT(1)
	0b11: "Congestion Encountered", CE

This new option, "ecn", marks ECT(0) and ECT(1) IPv{4,6} packets as CE,
which is useful for ECN-based rate limiting.  For example:

	$ tc filter add dev eth0 parent 1: protocol ip prio 10 \
		u32 match ip protocol 1 0xff flowid 1:2 \
		action skbmod \
		ecn

The updated tc-skbmod SYNOPSIS looks like the following:

	tc ... action skbmod { set SETTABLE | swap SWAPPABLE | ecn } ...

Only one of "set", "swap" or "ecn" shall be used in a single tc-skbmod
command.  Trying to use more than one of them at a time is considered
undefined behavior; pipe multiple tc-skbmod commands together instead.
"set" and "swap" only affect Ethernet packets, while "ecn" only affects
IP packets.

Depends on kernel patch "net/sched: act_skbmod: Add SKBMOD_F_ECN option
support", as well as iproute2 patch "tc/skbmod: Remove misinformation
about the swap action".

[1] https://en.wikipedia.org/wiki/Explicit_Congestion_Notification

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi David,

> I just merged main into next. Please fix up this patch and re-send. In
> the future, just ask for a merge in cases like this.

Ah, I see; thanks!
Peilin Ye

Change since v2:
    - re-rebased on iproute2-next (David)

 man/man8/tc-skbmod.8 | 38 +++++++++++++++++++++++++++++---------
 tc/m_skbmod.c        |  8 +++++++-
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/man/man8/tc-skbmod.8 b/man/man8/tc-skbmod.8
index 76512311b17d..52eaf989e80b 100644
--- a/man/man8/tc-skbmod.8
+++ b/man/man8/tc-skbmod.8
@@ -8,7 +8,8 @@ skbmod - user-friendly packet editor action
 .BR tc " ... " "action skbmod " "{ " "set "
 .IR SETTABLE " | "
 .BI swap " SWAPPABLE"
-.RI " } [ " CONTROL " ] [ "
+.RB " | " ecn
+.RI "} [ " CONTROL " ] [ "
 .BI index " INDEX "
 ]
 
@@ -37,6 +38,12 @@ action. Instead of having to manually edit 8-, 16-, or 32-bit chunks of an
 ethernet header,
 .B skbmod
 allows complete substitution of supported elements.
+Action must be one of
+.BR set ", " swap " and " ecn "."
+.BR set " and " swap
+only affect Ethernet packets, while
+.B ecn
+only affects IP packets.
 .SH OPTIONS
 .TP
 .BI dmac " DMAC"
@@ -51,6 +58,10 @@ Change the ethertype to the specified value.
 .BI mac
 Used to swap mac addresses.
 .TP
+.B ecn
+Used to mark ECN Capable Transport (ECT) IP packets as Congestion Encountered (CE).
+Does not affect Non ECN-Capable Transport (Non-ECT) packets.
+.TP
 .I CONTROL
 The following keywords allow to control how the tree of qdisc, classes,
 filters and actions is further traversed after this action.
@@ -115,7 +126,7 @@ tc filter add dev eth5 parent 1: protocol ip prio 10 \\
 .EE
 .RE
 
-Finally, swap the destination and source mac addresses in the header:
+To swap the destination and source mac addresses in the Ethernet header:
 
 .RS
 .EX
@@ -126,13 +137,22 @@ tc filter add dev eth3 parent 1: protocol ip prio 10 \\
 .EE
 .RE
 
-However, trying to
-.B set
-and
-.B swap
-in a single
-.B skbmod
-command will cause undefined behavior.
+Finally, to mark the CE codepoint in the IP header for ECN Capable Transport (ECT) packets:
+
+.RS
+.EX
+tc filter add dev eth0 parent 1: protocol ip prio 10 \\
+	u32 match ip protocol 1 0xff flowid 1:2 \\
+	action skbmod \\
+	ecn
+.EE
+.RE
+
+Only one of
+.BR set ", " swap " and " ecn
+shall be used in a single command.
+Trying to use more than one of them in a single command is considered undefined behavior; pipe
+multiple commands together instead.
 
 .SH SEE ALSO
 .BR tc (8),
diff --git a/tc/m_skbmod.c b/tc/m_skbmod.c
index 3fe30651a7d8..8d8bac5bc481 100644
--- a/tc/m_skbmod.c
+++ b/tc/m_skbmod.c
@@ -28,7 +28,7 @@
 static void skbmod_explain(void)
 {
 	fprintf(stderr,
-		"Usage:... skbmod { set <SETTABLE> | swap <SWAPPABLE> } [CONTROL] [index INDEX]\n"
+		"Usage:... skbmod { set <SETTABLE> | swap <SWAPPABLE> | ecn } [CONTROL] [index INDEX]\n"
 		"where SETTABLE is: [dmac DMAC] [smac SMAC] [etype ETYPE]\n"
 		"where SWAPPABLE is: \"mac\" to swap mac addresses\n"
 		"\tDMAC := 6 byte Destination MAC address\n"
@@ -111,6 +111,9 @@ static int parse_skbmod(struct action_util *a, int *argc_p, char ***argv_p,
 			p.flags |= SKBMOD_F_SMAC;
 			fprintf(stderr, "src MAC address <%s>\n", saddr);
 			ok += 1;
+		} else if (matches(*argv, "ecn") == 0) {
+			p.flags |= SKBMOD_F_ECN;
+			ok += 1;
 		} else if (matches(*argv, "help") == 0) {
 			skbmod_usage();
 		} else {
@@ -211,6 +214,9 @@ static int print_skbmod(struct action_util *au, FILE *f, struct rtattr *arg)
 	if (p->flags & SKBMOD_F_SWAPMAC)
 		fprintf(f, "swap mac ");
 
+	if (p->flags & SKBMOD_F_ECN)
+		fprintf(f, "ecn ");
+
 	fprintf(f, "\n\t index %u ref %d bind %d", p->index, p->refcnt,
 		p->bindcnt);
 	if (show_stats) {
-- 
2.20.1

