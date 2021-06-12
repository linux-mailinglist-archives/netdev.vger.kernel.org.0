Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5943A4D30
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 08:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFLG6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 02:58:10 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:36449 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLG6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 02:58:09 -0400
Received: by mail-qt1-f175.google.com with SMTP id r20so4428277qtp.3
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 23:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tyson.me; s=g;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CFWWCdzeBGPyh5GPWkXRAynRkC6aDWTDhDqyQpS2Lz8=;
        b=e6pFBxpKClJq6YL9LRH6UM0eSk6RU7M/SdCQB8hq0TMgkGnkOFdkUT0CniGvKvuhqq
         2GOMELrcJEDsHQmtdw+ZJnmpCyBS/9oV3V0i8CUWRkeu98bc8WjpgDGUySGLWx4kArlA
         lkjVzSrX8l2oK4xvJQ/gL7iO0RuQo178q53g8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CFWWCdzeBGPyh5GPWkXRAynRkC6aDWTDhDqyQpS2Lz8=;
        b=TrXdGjduAT01qcBAUzeyQTVLRwmCBxPHsVVHcvoitKNa2g52cgfQcHVt63si3EWhZB
         T/WXK//P+RvffMSubDOHQtj0ORSqHbtv+E5RFz+c7/0WccWkbAsW5haZ5f9KvSHokKTW
         RnulDhX/Wg4TtZjmCPvf4lpxLDx8fFNCRmIqvOaZlM3Xdpc3m6s1YzpZc+3zj0htpz2x
         X5vyNlWOvXBwBpB/tCELBEKOdQ1enO81DpVXk5TJrEeURV0PMQutjJcz/iF0YoGQfQh8
         2nzvFbybVaHS8gZmbvleREUDXcuQsf1oBv2MBu1F//Dkh47xpU3j7IWs0ZmLCWyqksct
         2BAg==
X-Gm-Message-State: AOAM533u76Fy27AkJaWVBWhN4rdr09ZbEnc5iyV8AGxVqI3Hhbe6Cs2x
        wb02QO3QA3YUea/S9C+EkDeMTQ==
X-Google-Smtp-Source: ABdhPJx6gFDBZy+l8wOJbjT2yroWK7X2RzQfxTdsLKSqHrUuEGNO1YWg5QgAWfbtugLUzCdAj4Ff3w==
X-Received: by 2002:ac8:4d8b:: with SMTP id a11mr7294676qtw.129.1623480897381;
        Fri, 11 Jun 2021 23:54:57 -0700 (PDT)
Received: from norquay.oak.tppnw.com ([2607:f2c0:f00f:7f03:81a5:9107:3996:6476])
        by smtp.gmail.com with ESMTPSA id 7sm5727163qtx.33.2021.06.11.23.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 23:54:56 -0700 (PDT)
From:   Tyson Moore <tyson@tyson.me>
To:     toke@toke.dk, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tyson Moore <tyson@tyson.me>
Subject: [PATCH] sch_cake: revise docs for RFC 8622 LE PHB support
Date:   Sat, 12 Jun 2021 02:54:11 -0400
Message-Id: <20210612065411.15675-1-tyson@tyson.me>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b8392808eb3fc28e ("sch_cake: add RFC 8622 LE PHB support to CAKE
diffserv handling") added the LE mark to the Bulk tin. Update the
comments to reflect the change.

Signed-off-by: Tyson Moore <tyson@tyson.me>
---
 net/sched/sch_cake.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 7d37638ee1..ea710f1857 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2338,7 +2338,7 @@ static int cake_config_precedence(struct Qdisc *sch)
 
 /*	List of known Diffserv codepoints:
  *
- *	Least Effort (CS1)
+ *	Least Effort (CS1, LE)
  *	Best Effort (CS0)
  *	Max Reliability & LLT "Lo" (TOS1)
  *	Max Throughput (TOS2)
@@ -2360,7 +2360,7 @@ static int cake_config_precedence(struct Qdisc *sch)
  *	Total 25 codepoints.
  */
 
-/*	List of traffic classes in RFC 4594:
+/*	List of traffic classes in RFC 4594, updated by RFC 8622:
  *		(roughly descending order of contended priority)
  *		(roughly ascending order of uncontended throughput)
  *
@@ -2375,7 +2375,7 @@ static int cake_config_precedence(struct Qdisc *sch)
  *	Ops, Admin, Management (CS2,TOS1) - eg. ssh
  *	Standard Service (CS0 & unrecognised codepoints)
  *	High Throughput Data (AF1x,TOS2)  - eg. web traffic
- *	Low Priority Data (CS1)           - eg. BitTorrent
+ *	Low Priority Data (CS1,LE)        - eg. BitTorrent
 
  *	Total 12 traffic classes.
  */
@@ -2391,7 +2391,7 @@ static int cake_config_diffserv8(struct Qdisc *sch)
  *		Video Streaming          (AF4x, AF3x, CS3)
  *		Bog Standard             (CS0 etc.)
  *		High Throughput          (AF1x, TOS2)
- *		Background Traffic       (CS1)
+ *		Background Traffic       (CS1, LE)
  *
  *		Total 8 traffic classes.
  */
@@ -2435,7 +2435,7 @@ static int cake_config_diffserv4(struct Qdisc *sch)
  *	    Latency Sensitive  (CS7, CS6, EF, VA, CS5, CS4)
  *	    Streaming Media    (AF4x, AF3x, CS3, AF2x, TOS4, CS2, TOS1)
  *	    Best Effort        (CS0, AF1x, TOS2, and those not specified)
- *	    Background Traffic (CS1)
+ *	    Background Traffic (CS1, LE)
  *
  *		Total 4 traffic classes.
  */
@@ -2473,7 +2473,7 @@ static int cake_config_diffserv4(struct Qdisc *sch)
 static int cake_config_diffserv3(struct Qdisc *sch)
 {
 /*  Simplified Diffserv structure with 3 tins.
- *		Low Priority		(CS1)
+ *		Low Priority		(CS1, LE)
  *		Best Effort
  *		Latency Sensitive	(TOS4, VA, EF, CS6, CS7)
  */
-- 
2.31.1

