Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E569A12A8FC
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfLYTEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:31 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39127 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:31 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so6720495plp.6
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T3xmfSy4nQpr7oRVpOuoPJKT1UHKpcMPxvddXK0xNo4=;
        b=IGN8wnzzpmYfFZqQvrdNBYN15BHqMgmPUuTilJShzXeiijD/hVsaO3pgcqEt4F7Fph
         PZTw4IoY/mfvyIYyEX4Y3gk6nZ5r/LV9f4DgT3BOxUDpv+HAhYV1tBA99839vZTOIR+c
         L8vAqH0pI6Ef8Td0Fyqr/KxTYjSC7rHQmGcR03bbGuqR4cG1swXpxH8RMW/VDqDtC5pc
         W2F9erOiSTvGjWGTomSiOhdHUnEcKxkGGyL/B01P+3l4MVTTqhE3ksAiOU3mrIKryBRR
         MtYPkHJZPME8FbHaCzHwY4/HNY61myymGN+7fT69BGiKxAAbtL/WsvV7YpjGtVEnk2kq
         biYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T3xmfSy4nQpr7oRVpOuoPJKT1UHKpcMPxvddXK0xNo4=;
        b=b+hhD5r/HcMRaTDZvWPRzkE5Ui2PPyyiHNXHCW2Ti8GRtm3CsP9nBcNsaqny9WYsTY
         Uow8mh/Py7jiwXnQ+U1QMZ+/uaF+25AmZWVSC/O79/tdyFmSNVjboTxZot3IVyzRHoL4
         OJFbeCwD2NYKJhyj64VLBDC/IFS5T+l1z5GfPWcjZRpRkRGIgc5FzDhWIW+Jysi6kGrk
         RAMmL+Ewfe/WHDwQegoLK4xIopR+n482cYrJMZjklIpTKjuBeVmI9oYZUtzhchzjDLmE
         P1l9W6fQUeX32CQ2dup+EqJ2zTrS/bgrYmjehKKZGSemWNGF1SJafaAShm/ZS0eqBBSg
         pMEQ==
X-Gm-Message-State: APjAAAWMQ162ZDSp2CgvhiCBOwFK7NIZv7BfcMlVRFd8W24MTLpA/3lN
        NorufoF/cLp/vRkjlAX6BhG+OHkzSNc=
X-Google-Smtp-Source: APXvYqxZKG5DHeWP/oC19TlyY8K13iXOqh4fzc1bwiWNuLrARlkjR3dJSvMJD2sPdvsgtoeyDDDqHA==
X-Received: by 2002:a17:902:d204:: with SMTP id t4mr43234831ply.167.1577300670214;
        Wed, 25 Dec 2019 11:04:30 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:29 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 02/10] tc: choke: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:10 +0530
Message-Id: <20191225190418.8806-3-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the choke Qdisc.
Also, use the long double format specifier to print the value of
"probability".

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_choke.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/tc/q_choke.c b/tc/q_choke.c
index 648d9ad7..570c3599 100644
--- a/tc/q_choke.c
+++ b/tc/q_choke.c
@@ -186,18 +186,23 @@ static int choke_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	    RTA_PAYLOAD(tb[TCA_CHOKE_MAX_P]) >= sizeof(__u32))
 		max_P = rta_getattr_u32(tb[TCA_CHOKE_MAX_P]);
 
-	fprintf(f, "limit %up min %up max %up ",
-		qopt->limit, qopt->qth_min, qopt->qth_max);
+	print_uint(PRINT_ANY, "limit", "limit %up ", qopt->limit);
+	print_uint(PRINT_ANY, "min", "min %up ", qopt->qth_min);
+	print_uint(PRINT_ANY, "max", "max %up ", qopt->qth_max);
 
 	tc_red_print_flags(qopt->flags);
 
 	if (show_details) {
-		fprintf(f, "ewma %u ", qopt->Wlog);
+		print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
+
 		if (max_P)
-			fprintf(f, "probability %g ", max_P / pow(2, 32));
+			print_float(PRINT_ANY, "probability",
+				    "probability %lg ", max_P / pow(2, 32));
 		else
-			fprintf(f, "Plog %u ", qopt->Plog);
-		fprintf(f, "Scell_log %u", qopt->Scell_log);
+			print_uint(PRINT_ANY, "Plog", "Plog %u ", qopt->Plog);
+
+		print_uint(PRINT_ANY, "Scell_log", "Scell_log %u",
+			   qopt->Scell_log);
 	}
 	return 0;
 }
@@ -214,8 +219,13 @@ static int choke_print_xstats(struct qdisc_util *qu, FILE *f,
 		return -1;
 
 	st = RTA_DATA(xstats);
-	fprintf(f, "  marked %u early %u pdrop %u other %u matched %u",
-		st->marked, st->early, st->pdrop, st->other, st->matched);
+
+	print_uint(PRINT_ANY, "marked", "  marked %u", st->marked);
+	print_uint(PRINT_ANY, "early", " early %u", st->early);
+	print_uint(PRINT_ANY, "pdrop", " pdrop %u", st->pdrop);
+	print_uint(PRINT_ANY, "other", " other %u", st->other);
+	print_uint(PRINT_ANY, "matched", " matched %u", st->matched);
+
 	return 0;
 
 }
-- 
2.17.1

