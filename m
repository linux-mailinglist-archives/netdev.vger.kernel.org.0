Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E917153CE15
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344483AbiFCRa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 13:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241561AbiFCRa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 13:30:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8163982D
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 10:30:22 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i1so7283894plg.7
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 10:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=meqM7jFCS4vUPCeo3whpvnKpoPst2WZR+IwjDPp1Il4=;
        b=dFwM/g6NP3Z+x1YMX089n48qvZ9hYFZbs1QPrWpox5gyjt8vwZy8hmKARMlyjd8GIg
         DWZu0VhsZZs6DjTtNLeFH4HRzyXYGm60hP8rHDmbIo5Qj8nTCsnuSX+Q7xdRAHGkhXIT
         gt65l9DiUbCYg2ltwkBxdensnXOt9SgW0WGJ88lyvl0+m0Cns423KdM5UR/jl1Ev6xSB
         q+YyAzkuRZWDOOOhtZb3jNeCNf26ijBCv3MQur2AFV8e76EHLI2EmOJaierNEVEjrEy4
         Mk4MmAX23xqS+K7KAI8dmrn5X4aTgR2YNPLNFQaWfhl6pB10Yz+lSTIttZNrDZ4/JazJ
         IOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=meqM7jFCS4vUPCeo3whpvnKpoPst2WZR+IwjDPp1Il4=;
        b=rbsjxQ3W9ejUWPA7RTcOfoCjvofQvkMvA+mZKLcKo+pO+55BTNQZdWg3iKSQOOfPoW
         YEsahKjzzHzA3JnCiqNHtWKAU/962jU+mBXeeAOHgmULgTr5EvDWJJ31ewMSxFnNic0U
         hROk5lxtZIpAFPuOdHvZIyZhiSaeP/sICExR7NJjWjc3zy47SP0cjzD8URixZDDZwewx
         +/sdGEL3pFZJk8tTb9n0SGIxP8KgRwX4pfRhQlQjP2bbcHZi8k7mXYfao4QD3piNxRZ5
         ZGdzJKkUymuo7QF4GEPVZIrr28J30EWWIg3I0JroL5MAQ4sWzq3C5sPW/NLPwGj5kUIl
         ocAg==
X-Gm-Message-State: AOAM530XVkHJT5D/QjtdLexP6FMcuJrjYwX0Z1wh6gfaj7Z/USOsw3g1
        W8WptR7SojZNJmz6hlw24pM=
X-Google-Smtp-Source: ABdhPJwtkAx6na/Mn/BwIaqF0TJ1HX84m9Nw/F2G6ZL/93UAUJPc2u0yjrg2DZnksSRgd+UaPdDxtA==
X-Received: by 2002:a17:902:ceca:b0:166:3418:5267 with SMTP id d10-20020a170902ceca00b0016634185267mr11123220plg.136.1654277422320;
        Fri, 03 Jun 2022 10:30:22 -0700 (PDT)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id ij1-20020a170902ab4100b00163efcd50bdsm5621706plb.94.2022.06.03.10.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:30:21 -0700 (PDT)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        edumazet@google.com, Jeffrey Ji <jeffreyji@google.com>
Subject: [PATCH iproute2-next] show rx_otherehost_dropped stat in ip link show
Date:   Fri,  3 Jun 2022 17:30:16 +0000
Message-Id: <20220603173016.1383423-1-jeffreyjilinux@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeffrey Ji <jeffreyji@google.com>

This stat was added in commit 794c24e9921f ("net-core:
rx_otherhost_dropped to core_stats")

Tested: sent packet with wrong MAC address from 1
network namespace to another, verified that counter showed "1" in
`ip -s -s link sh` and `ip -s -s -j link sh`

Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
---
 ip/ipaddress.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 142731933ba3..544c7450b7bf 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -692,6 +692,7 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		strlen("heartbt"),
 		strlen("overrun"),
 		strlen("compressed"),
+		strlen("otherhost_dropped"),
 	};
 
 	if (is_json_context()) {
@@ -730,6 +731,10 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 			if (s->rx_nohandler)
 				print_u64(PRINT_JSON,
 					   "nohandler", NULL, s->rx_nohandler);
+			if (s->rx_otherhost_dropped)
+				print_u64(PRINT_JSON,
+					   "otherhost_dropped", NULL,
+					   s->rx_otherhost_dropped);
 		}
 		close_json_object();
 
@@ -811,11 +816,14 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		/* RX error stats */
 		if (show_stats > 1) {
 			fprintf(fp, "%s", _SL_);
-			fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s %*s%s",
+			fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s%*s%*s%s",
 				cols[0] - 10, "", cols[1], "length",
 				cols[2], "crc", cols[3], "frame",
 				cols[4], "fifo", cols[5], "overrun",
-				cols[6], s->rx_nohandler ? "nohandler" : "",
+				s->rx_nohandler ? cols[6] + 1 : 0,
+				s->rx_nohandler ? " nohandler" : "",
+				s->rx_otherhost_dropped ? cols[7] + 1 : 0,
+				s->rx_otherhost_dropped ? " otherhost_dropped" : "",
 				_SL_);
 			fprintf(fp, "%*s", cols[0] + 5, "");
 			print_num(fp, cols[1], s->rx_length_errors);
@@ -825,6 +833,9 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 			print_num(fp, cols[5], s->rx_over_errors);
 			if (s->rx_nohandler)
 				print_num(fp, cols[6], s->rx_nohandler);
+			if (s->rx_otherhost_dropped)
+				print_num(fp, cols[7],
+				s->rx_otherhost_dropped);
 		}
 		fprintf(fp, "%s", _SL_);
 
-- 
2.36.1.255.ge46751e96f-goog

