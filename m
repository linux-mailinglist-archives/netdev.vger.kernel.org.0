Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6417169D04B
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbjBTPIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjBTPIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:08:38 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA66421954
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:07:38 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id h32so6062016eda.2
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NUhIpHxjzBN9TRdOLnzoHrduKH0tsKgb0MlHA9Bsutc=;
        b=cxHtSr4Vcyi7CBHYjG9W9HfZHgoV8PncHbPy0GZNIzB8Xm9Rn0aEBTVtLkEWBV5ay1
         TQ9L6WChXXqoBWCZBbY/LJkvSY2frIOWjAleoaYpl3M/4Cq9qTQMa+VbRgMsn4EbU9xx
         mtdnXJnPIVLY1hok8LYPlsazJQ/KSEeRwIa2dqc9gxtB6TF3EK9o/A7GMVTV0h9+n7NI
         pUYmv4LH5NOmUnvRp+iiyZC2h55C4EJ4HnpL8O6/yUXoe7EZJxJXyxsawu39IhWbBXVa
         X264gaciPV2mOdgWcT6f4w8pSMTkoVh2uCalE4SX6juJxI83f0kUb3ZPXs9U7vjTUAjS
         BK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NUhIpHxjzBN9TRdOLnzoHrduKH0tsKgb0MlHA9Bsutc=;
        b=Ou2eI2NvZZxt+y1s6+hyOiybGQCONPZ58lLGCAKcRJO7lKYn1hk9VVLpw1oQ/bg794
         PkwT7xziQdk0n1IVbJ3CMKZa/glE2BNjJ1q1lEMhsvut/4dpQYDjghSyuEQXs1DNg+mH
         7mfDcfCCHMUI1Nbfrxugf8gvxnr1ZLnwgQD9A5njaFRJBt8Jdc+v5rYW2z+ADJ1cD1fe
         wZfaucx+Uvv50yTDIjGvCeOdvObASfqqxyRS9v+RwgDpc3LvMs60Z50l4IR5vae5CSrE
         HCBo9NpRDoEDnwdtxqcrI9zZhE3QeUb20e9QdauL12aJV0P8s5+GEbZFHgzn9qu2bUeF
         1LDA==
X-Gm-Message-State: AO0yUKV/RcNx/K/pJS5etGy2y39sa3MJkKWfQ5QW2LF66Dz4WNBH15Qb
        bJXVTvxk/BR+5G5JvA6WYKCVpazwyQuy1g==
X-Google-Smtp-Source: AK7set9ahdfWnTsu0mjtdWkky7mJ4ZgwXPneUu6nIhy/hCE3eZpfDk8WYsmH29E8l612MPr6mpoAsA==
X-Received: by 2002:a17:906:2c15:b0:874:e17e:2526 with SMTP id e21-20020a1709062c1500b00874e17e2526mr9307080ejh.72.1676905560709;
        Mon, 20 Feb 2023 07:06:00 -0800 (PST)
Received: from localhost.localdomain (netacc-gpn-7-149-233.pool.yettel.hu. [176.77.149.233])
        by smtp.gmail.com with ESMTPSA id lx25-20020a170906af1900b008d68d018153sm1029113ejb.23.2023.02.20.07.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 07:06:00 -0800 (PST)
From:   =?UTF-8?q?P=C3=A9ter=20Antal?= <peti.antal99@gmail.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?P=C3=A9ter=20Antal?= <peti.antal99@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ferenc Fejes <fejes@inf.elte.hu>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Antal?= <antal.peti99@gmail.com>
Subject: [PATCH iproute2] man: tc-mqprio: extend prio-tc-queue mapping with examples
Date:   Mon, 20 Feb 2023 16:05:48 +0100
Message-Id: <20230220150548.2021-1-peti.antal99@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current mqprio manual is not detailed about queue mapping
and priorities, this patch adds some examples to it.

Suggested-by: Ferenc Fejes <fejes@inf.elte.hu>
Signed-off-by: Péter Antal <peti.antal99@gmail.com>
---
 man/man8/tc-mqprio.8 | 96 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
index 4b9e942e..16ecb9a1 100644
--- a/man/man8/tc-mqprio.8
+++ b/man/man8/tc-mqprio.8
@@ -98,6 +98,7 @@ belong to an application. See kernel and cgroup documentation for details.
 .TP
 num_tc
 Number of traffic classes to use. Up to 16 classes supported.
+You cannot have more classes than queues
 
 .TP
 map
@@ -119,6 +120,8 @@ Set to
 to support hardware offload. Set to
 .B 0
 to configure user specified values in software only.
+The default value of this parameter is
+.B 1
 
 .TP
 mode
@@ -146,5 +149,98 @@ max_rate
 Maximum value of bandwidth rate limit for a traffic class.
 
 
+.SH EXAMPLE
+
+The following example shows how to attach priorities to 4 traffic classes ("num_tc 4"),
+and then how to pair these traffic classes with 4 hardware queues with mqprio,
+with hardware coordination ("hw 1", or does not specified, because 1 is the default value).
+Traffic class 0 (tc0) is mapped to hardware queue 0 (q0), tc1 is mapped to q1,
+tc2 is mapped to q2, and tc3 is mapped q3.
+
+.EX
+# tc qdisc add dev eth0 root mqprio \
+              num_tc 4 \
+              map 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 \
+              queues 1@0 1@1 1@2 1@3 \
+              hw 1
+.EE
+
+The next example shows how to attach priorities to 3 traffic classes ("num_tc 3"),
+and how to pair these traffic classes with 4 queues,
+without hardware coordination ("hw 0").
+Traffic class 0 (tc0) is mapped to hardware queue 0 (q0), tc1 is mapped to q1,
+tc2 and is mapped to q2 and q3, where the queue selection between these
+two queues is somewhat randomly decided.
+
+.EX
+# tc qdisc add dev eth0 root mqprio \
+              num_tc 3 \
+              map 0 0 0 0 1 1 1 1 2 2 2 2 2 2 2 2 \
+              queues 1@0 1@1 2@2 \
+              hw 0
+.EE
+
+
+In both cases from above the priority values from 0 to 3 (prio0-3) are
+mapped to tc0, prio4-7 are mapped to tc1, and the
+prio8-11 are mapped to tc2 ("map" attribute). The last four priority values
+(prio12-15) are mapped in different ways in the two examples.
+They are mapped to tc3 in the first example and mapped to tc2 in the second example.
+The values of these two examples are the following:
+
+ ┌────┬────┬───────┐  ┌────┬────┬────────┐
+ │Prio│ tc │ queue │  │Prio│ tc │  queue │
+ ├────┼────┼───────┤  ├────┼────┼────────┤
+ │  0 │  0 │     0 │  │  0 │  0 │      0 │
+ │  1 │  0 │     0 │  │  1 │  0 │      0 │
+ │  2 │  0 │     0 │  │  2 │  0 │      0 │
+ │  3 │  0 │     0 │  │  3 │  0 │      0 │
+ │  4 │  1 │     1 │  │  4 │  1 │      1 │
+ │  5 │  1 │     1 │  │  5 │  1 │      1 │
+ │  6 │  1 │     1 │  │  6 │  1 │      1 │
+ │  7 │  1 │     1 │  │  7 │  1 │      1 │
+ │  8 │  2 │     2 │  │  8 │  2 │ 2 or 3 │
+ │  9 │  2 │     2 │  │  9 │  2 │ 2 or 3 │
+ │ 10 │  2 │     2 │  │ 10 │  2 │ 2 or 3 │
+ │ 11 │  2 │     2 │  │ 11 │  2 │ 2 or 3 │
+ │ 12 │  3 │     3 │  │ 12 │  2 │ 2 or 3 │
+ │ 13 │  3 │     3 │  │ 13 │  2 │ 2 or 3 │
+ │ 14 │  3 │     3 │  │ 14 │  2 │ 2 or 3 │
+ │ 15 │  3 │     3 │  │ 15 │  2 │ 2 or 3 │
+ └────┴────┴───────┘  └────┴────┴────────┘
+       example1             example2
+
+
+Another example of queue mapping is the following.
+There are 5 traffic classes, and there are 8 hardware queues.
+
+.EX
+# tc qdisc add dev eth0 root mqprio \
+              num_tc 5 \
+              map 0 0 0 1 1 1 1 2 2 3 3 4 4 4 4 4 \
+              queues 1@0 2@1 1@3 1@4 3@5
+.EE
+
+The value mapping is the following for this example:
+
+        ┌───────┐
+ tc0────┤Queue 0│◄────1@0
+        ├───────┤
+      ┌─┤Queue 1│◄────2@1
+ tc1──┤ ├───────┤
+      └─┤Queue 2│
+        ├───────┤
+ tc2────┤Queue 3│◄────1@3
+        ├───────┤
+ tc3────┤Queue 4│◄────1@4
+        ├───────┤
+      ┌─┤Queue 5│◄────3@5
+      │ ├───────┤
+ tc4──┼─┤Queue 6│
+      │ ├───────┤
+      └─┤Queue 7│
+        └───────┘
+
+
 .SH AUTHORS
 John Fastabend, <john.r.fastabend@intel.com>
-- 
2.34.1

