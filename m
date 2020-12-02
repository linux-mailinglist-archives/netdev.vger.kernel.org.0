Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230B92CC311
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbgLBRJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgLBRJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:09:34 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A823C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 09:08:54 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 64so4789960wra.11
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 09:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Is+FahI+k/tLAhgiR9pQzcX45GetGxN+lw5wwk+WNyA=;
        b=ZK3+2eQnq/kHOZmLHif4gAA8ugCeyLl726d1eTqtcbDaZpoPQ2FSvIdpG7nBPkhQwO
         rsuW2L3TxVCq5cavcQRaw5uWuvZL6gkqsnZ+femKhhnlQA6SToMQyAWllRLrNVOgT0Ub
         0CiL12Ghm9Yl7pQ+s1tgQUQryoTjTDE9XO6g5w4XxuSFYP/1aiZdcDAghYlI6SLLeZSw
         +T4KZ8FjxkqSJrGLtOJpVMVGZ+ubb6CXeUXb6X+ciyp0N1bfV62apVYDKwnzNRL2yzB1
         wAu9A/NHe2k6z10hVRFC7/Decy2V2gsgOPf7Evm7sQHNRjmW/NN7Xr6XhOI2LKGk35Ju
         bfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Is+FahI+k/tLAhgiR9pQzcX45GetGxN+lw5wwk+WNyA=;
        b=UD80SDvMs0Nl8FgvtXYKOu7gAm8j48bDpwiL3sieiKV4vGKDyDnZRG/K3EepM/mW8R
         VkpennN60qIhErI4g/yUh7uZ/UMVB/bxZsO7FQvYNi7/F4jWG+HCclm7sZfYr9/+thVf
         UvswjeR/pjp5TJYWJnBvfg5v0Hvf9jPjp4U2FV0F5gdshrJX83Co6BELcx6kz+YslRcn
         i0yDOwsd+G7kgytOOBMCNbWsQjuRot/EtKGjDCmdaajI4scGTowdZ6tiukmew26HQ7U3
         CtMedqGNrdpqyGW3Cw6XOvlhrKzze2OGzxXHlvtc20zLyXN6+dHMzR0QLJCDNOOlemf3
         NvJA==
X-Gm-Message-State: AOAM533HRhNKn66XPPxeH/Ni/vO4/qkOFzuUEbzt+NGu/Az/++OoST02
        1jXg5lDvH2WODYToFAC6/FpjURyfiIAzmA==
X-Google-Smtp-Source: ABdhPJzalUTLvFH5dIGkTUqYn/oal6v86mXt5TAPVsP+JqE9DJR12fM2xWLnQFgVSRo1fyWEUUTVQQ==
X-Received: by 2002:adf:e444:: with SMTP id t4mr4662941wrm.152.1606928932612;
        Wed, 02 Dec 2020 09:08:52 -0800 (PST)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id k11sm2615735wmj.42.2020.12.02.09.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 09:08:51 -0800 (PST)
From:   luca.boccassi@gmail.com
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH v3] tc/mqprio: json-ify output
Date:   Wed,  2 Dec 2020 17:08:45 +0000
Message-Id: <20201202170845.248008-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201128183015.15889-1-bluca@debian.org>
References: <20201128183015.15889-1-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Boccassi <bluca@debian.org>

As reported by a Debian user, mqprio output in json mode is
invalid:

{
     "kind": "mqprio",
     "handle": "8021:",
     "dev": "enp1s0f0",
     "root": true,
     "options": { tc 2 map 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0
          queues:(0:3) (4:7)
          mode:channel
          shaper:dcb}
}

json-ify it, while trying to maintain the same formatting
for standard output.

New output:

{
    "kind": "mqprio",
    "handle": "8001:",
    "root": true,
    "options": {
        "tc": 2,
        "map": [ 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
        "queues": [ [ 0, 3 ], [ 4, 7 ] ],
        "mode": "channel",
        "shaper": "dcb"
    }
}

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=972784

Reported-by: Roméo GINON <romeo.ginon@ilexia.com>
Signed-off-by: Luca Boccassi <bluca@debian.org>
---
v2: the original reporter tested the patch, new output added to commit message.
    Fixed empty tag in queues nested arrays.
    Output is accepted by python3 -m json.tool
v3: add missing close_json_array()

 tc/q_mqprio.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index f26ba8d7..5499f621 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -243,13 +243,19 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	qopt = RTA_DATA(opt);
 
-	fprintf(f, " tc %u map ", qopt->num_tc);
+	print_uint(PRINT_ANY, "tc", "tc %u ", qopt->num_tc);
+	open_json_array(PRINT_ANY, is_json_context() ? "map" : "map ");
 	for (i = 0; i <= TC_PRIO_MAX; i++)
-		fprintf(f, "%u ", qopt->prio_tc_map[i]);
-	fprintf(f, "\n             queues:");
-	for (i = 0; i < qopt->num_tc; i++)
-		fprintf(f, "(%u:%u) ", qopt->offset[i],
-			qopt->offset[i] + qopt->count[i] - 1);
+		print_uint(PRINT_ANY, NULL, "%u ", qopt->prio_tc_map[i]);
+	close_json_array(PRINT_ANY, "");
+	open_json_array(PRINT_ANY, is_json_context() ? "queues" : "\n             queues:");
+	for (i = 0; i < qopt->num_tc; i++) {
+		open_json_array(PRINT_JSON, NULL);
+		print_uint(PRINT_ANY, NULL, "(%u:", qopt->offset[i]);
+		print_uint(PRINT_ANY, NULL, "%u) ", qopt->offset[i] + qopt->count[i] - 1);
+		close_json_array(PRINT_JSON, NULL);
+	}
+	close_json_array(PRINT_ANY, "");
 
 	if (len > 0) {
 		struct rtattr *tb[TCA_MQPRIO_MAX + 1];
@@ -262,18 +268,18 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 			__u16 *mode = RTA_DATA(tb[TCA_MQPRIO_MODE]);
 
 			if (*mode == TC_MQPRIO_MODE_CHANNEL)
-				fprintf(f, "\n             mode:channel");
+				print_string(PRINT_ANY, "mode", "\n             mode:%s", "channel");
 		} else {
-			fprintf(f, "\n             mode:dcb");
+			print_string(PRINT_ANY, "mode", "\n             mode:%s", "dcb");
 		}
 
 		if (tb[TCA_MQPRIO_SHAPER]) {
 			__u16 *shaper = RTA_DATA(tb[TCA_MQPRIO_SHAPER]);
 
 			if (*shaper == TC_MQPRIO_SHAPER_BW_RATE)
-				fprintf(f, "\n             shaper:bw_rlimit");
+				print_string(PRINT_ANY, "shaper", "\n             shaper:%s", "bw_rlimit");
 		} else {
-			fprintf(f, "\n             shaper:dcb");
+			print_string(PRINT_ANY, "shaper", "\n             shaper:%s", "dcb");
 		}
 
 		if (tb[TCA_MQPRIO_MIN_RATE64]) {
@@ -287,9 +293,10 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 					return -1;
 				*(min++) = rta_getattr_u64(r);
 			}
-			fprintf(f, "	min_rate:");
+			open_json_array(PRINT_ANY, is_json_context() ? "min_rate" : "	min_rate:");
 			for (i = 0; i < qopt->num_tc; i++)
-				fprintf(f, "%s ", sprint_rate(min_rate64[i], b1));
+				print_string(PRINT_ANY, NULL, "%s ", sprint_rate(min_rate64[i], b1));
+			close_json_array(PRINT_ANY, "");
 		}
 
 		if (tb[TCA_MQPRIO_MAX_RATE64]) {
@@ -303,9 +310,10 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 					return -1;
 				*(max++) = rta_getattr_u64(r);
 			}
-			fprintf(f, "	max_rate:");
+			open_json_array(PRINT_ANY, is_json_context() ? "max_rate" : "	max_rate:");
 			for (i = 0; i < qopt->num_tc; i++)
-				fprintf(f, "%s ", sprint_rate(max_rate64[i], b1));
+				print_string(PRINT_ANY, NULL, "%s ", sprint_rate(max_rate64[i], b1));
+			close_json_array(PRINT_ANY, "");
 		}
 	}
 	return 0;
-- 
2.27.0

