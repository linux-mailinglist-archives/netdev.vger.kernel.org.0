Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D766F1AAA7D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370871AbgDOOlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S370803AbgDOOkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:40:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087CFC061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:40:20 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so3932475ljn.7
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PPPoOHuTP2XeQ/6TCikOSxG1v+BI76w53F3xk1k1YO0=;
        b=GFyKxmqqV+OizwXib8+LVNcmYURIdssoBzfuSEFg/gn6ini9DKnH/sGYbl8uOLPpHE
         sn0O/ag5ArrJ37q4vZzVMZ/YvkIKrghidjv6DfWGjAukKOJYGPdHuyWgOz/Y3KzFq1VO
         tDaq/cw9REMeUIfyM1du6SQhKLB3/a2j/6C3JJJzeMm7yf0Tby1Ka04X4ZvYF7NRpmbA
         vMXD9hYyCdBRNU8q97/HOAF2jE8YWzSDwg4MtaExSoZsisTlZy5lc7RrcDGBKgZ1uah2
         k38i3zgD+wsDZG59HQQ9r4Bb8Z9nVw2/MZr8T3VT57ikPWO4taVFwmIp/DqsAG4COx+g
         CrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PPPoOHuTP2XeQ/6TCikOSxG1v+BI76w53F3xk1k1YO0=;
        b=r3VeUcR1QCMkikzvy9HNVWHcP2xRRewxS+TnBCa3r5MxfeIra5z22m+df8ljQog2zw
         O+gWW5l8Saxu1WgQxEzHAjuWaAaxOABhlAPMmMnkEPWy5Hpr5DVgPsZd1+PbPOOu4NbQ
         YrGT5gEEQMCILO3Q49zKBeIvxVITf59U2SaC30QvnQFIUIn6EJ6rzGlKbtNd+YCa38l1
         7ianyxstSMcdFRHAMMxYDyjp8W2P5R/F3aLmPpE97FZguAIqL4JChrKggXlI0D1EkDuB
         MmhQcbJy3JZN2qpcOckSzzwKhT5jyyvbC2SYiGjBAZ2RrFCa9tu227RqY/HEPrhed9zS
         bjHA==
X-Gm-Message-State: AGi0PuZggCGDZJ8o6LjTGSXRrT81xlHM5Qcuj558k8UwlnKqZe9HNkSv
        mlDWX54UuCNtnHf3nVX7Egagew==
X-Google-Smtp-Source: APiQypK5JP3Ht4iPrHWBECEz1DxlANp525yqoEF4q1TuVErvPYZjMzV3uOUIzfru4ptp71xCIU5Psg==
X-Received: by 2002:a2e:854e:: with SMTP id u14mr3456476ljj.95.1586961618493;
        Wed, 15 Apr 2020 07:40:18 -0700 (PDT)
Received: from xps13.home ([2001:4649:7d40:0:4415:c24b:59d6:7e4a])
        by smtp.gmail.com with ESMTPSA id l22sm1860327lja.74.2020.04.15.07.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 07:40:17 -0700 (PDT)
From:   Odin Ugedal <odin@ugedal.com>
To:     toke@redhat.com, netdev@vger.kernel.org
Cc:     Odin Ugedal <odin@ugedal.com>
Subject: [PATCH 1/3] q_cake: Make fwmark uint instead of int
Date:   Wed, 15 Apr 2020 16:39:34 +0200
Message-Id: <20200415143936.18924-2-odin@ugedal.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200415143936.18924-1-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will help avoid overflow, since setting it to 0xffffffff would
result in -1 when converted to integer, resulting in being "-1", setting
the fwmark to 0x00.

Signed-off-by: Odin Ugedal <odin@ugedal.com>
---
 tc/q_cake.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tc/q_cake.c b/tc/q_cake.c
index 3c78b176..9ebb270c 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -97,6 +97,7 @@ static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	unsigned int interval = 0;
 	unsigned int diffserv = 0;
 	unsigned int memlimit = 0;
+	unsigned int fwmark = 0;
 	unsigned int target = 0;
 	__u64 bandwidth = 0;
 	int ack_filter = -1;
@@ -107,7 +108,6 @@ static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	int autorate = -1;
 	int ingress = -1;
 	int overhead = 0;
-	int fwmark = -1;
 	int wash = -1;
 	int nat = -1;
 	int atm = -1;
@@ -335,15 +335,12 @@ static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				return -1;
 			}
 		} else if (strcmp(*argv, "fwmark") == 0) {
-			unsigned int fwm;
-
 			NEXT_ARG();
-			if (get_u32(&fwm, *argv, 0)) {
+			if (get_u32(&fwmark, *argv, 0)) {
 				fprintf(stderr,
 					"Illegal value for \"fwmark\": \"%s\"\n", *argv);
 				return -1;
 			}
-			fwmark = fwm;
 		} else if (strcmp(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -388,7 +385,7 @@ static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	if (memlimit)
 		addattr_l(n, 1024, TCA_CAKE_MEMORY, &memlimit,
 			  sizeof(memlimit));
-	if (fwmark != -1)
+	if (fwmark)
 		addattr_l(n, 1024, TCA_CAKE_FWMARK, &fwmark,
 			  sizeof(fwmark));
 	if (nat != -1)
-- 
2.26.1

