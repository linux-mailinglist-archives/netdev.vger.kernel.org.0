Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBCD2FF9E4
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbhAVBXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbhAVBXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 20:23:03 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758ACC06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 17:22:23 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id gx5so5358953ejb.7
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 17:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BxGGj+QHz9z0MyhBNQhWeoPxFtYu0j591n57w19eumg=;
        b=arMYHOljyZ3Q7cjZl7vQaSk1IJiZJ+B7ezSMGRJerUxSuPK4Z1FgIsXK+ETPAjfHfh
         +WBgQaTZOf7xJxHNjbLm/dQipsH3D4q5GrDKPyE9C7+hIntm0+0v9mQJXL0ffcnfZwiw
         MhdskGen+TPja8/cFrK1Rz00Dqs9pTNnXGddAERg/7xb3oQLUkh3TrI2BasQxPgYMD9M
         RR90U6KHWCzvClbxm3lHLK3g3W6yDhrY1e2BVRFr9aUTz2jPsMqK9IexkdgfeeEtIDe1
         MHrVhsBhEgTCNfhxIA/jluPJGSLVKrm+VxQq/xK3LQvRtSlUCSpIuNfygaODH/FBIDSf
         q3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BxGGj+QHz9z0MyhBNQhWeoPxFtYu0j591n57w19eumg=;
        b=Oh6zgY19cFaNkrFxwgD2YQ9NLn3eE84etkNNJdhnmeZ6Hi2xDLnhPl+nNbg76TvTcU
         2ialVQaV/ttKOcCzaPL19b304jfJL8/Goyfchhd22RJQUAmNEmwzJZXKCoXcUZcT+Lus
         I5q5gGDlKr9xu2QnT5d8V69iIPB0HcWFILkCTdNbRUlvzGO6n8oaBklpTqTfeP15xLm2
         2NbBhpqSgWzf1qMPXSxblDNFoWDqZazvlBLQ7oLCaRvsR1VZCuREQikhdZx6iECJtD5M
         NZxCvZ9OkMazCAkOQEG3qFQOajUhj+CGxN+bhuuJAnkjv73rL0jg7DmG3ymhhF9chVb0
         YxPQ==
X-Gm-Message-State: AOAM530mICiLGAMWbQMqzrDNnKPpjIK5YSJImJFBha4n31udmmzV+/cV
        xixJCV6gWkgmr1ptl3G4Zag=
X-Google-Smtp-Source: ABdhPJynYxhX8BMQGg+4ji7U73cT291q1fj/FYAU7KxuyMYqYl+aBkqWwtJgXzqjmQivcic3rdYWUA==
X-Received: by 2002:a17:906:f755:: with SMTP id jp21mr1416496ejb.22.1611278542182;
        Thu, 21 Jan 2021 17:22:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id w16sm4037433edv.4.2021.01.21.17.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 17:22:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH v2 iproute2] man: tc-taprio.8: document the full offload feature
Date:   Fri, 22 Jan 2021 03:22:11 +0200
Message-Id: <20210122012211.2784760-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since this feature's introduction in commit 9c66d1564676 ("taprio: Add
support for hardware offloading") from kernel v5.4, it never got
documented in the man pages. Due to this reason, we see customer reports
of seemingly contradictory information: the community manpages claim
there is no support for full offload, nonetheless many silicon vendors
have already implemented it.

This patch documents the full offload feature (enabled by specifying
"flags 2" to the taprio qdisc) and gives one more example that tries to
illustrate some of the finer points related to the usage.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Some wording adjustments.

 man/man8/tc-taprio.8 | 51 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index e1d19ba19089..d13c86f779b7 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -92,7 +92,11 @@ in the schedule;
 clockid
 .br
 Specifies the clock to be used by qdisc's internal timer for measuring
-time and scheduling events.
+time and scheduling events. This argument must be omitted when using the
+full-offload feature (flags 0x2), since in that case, the clockid is
+implicitly /dev/ptpN (where N is given by
+.B ethtool -T eth0 | grep 'PTP Hardware Clock'
+), and therefore not necessarily synchronized with the system's CLOCK_TAI.
 
 .TP
 sched-entry
@@ -115,13 +119,27 @@ before moving to the next entry.
 .TP
 flags
 .br
-Specifies different modes for taprio. Currently, only txtime-assist is
-supported which can be enabled by setting it to 0x1. In this mode, taprio will
-set the transmit timestamp depending on the interval in which the packet needs
-to be transmitted. It will then utililize the
+This is a bit mask which specifies different modes for taprio.
+.RS
+.TP
+.I 0x1
+Enables the txtime-assist feature. In this mode, taprio will set the transmit
+timestamp depending on the interval in which the packet needs to be
+transmitted. It will then utililize the
 .BR etf(8)
 qdisc to sort and transmit the packets at the right time. The second example
 can be used as a reference to configure this mode.
+.TP
+.I 0x2
+Enables the full-offload feature. In this mode, taprio will pass the gate
+control list to the NIC which will execute it cyclically in hardware.
+When using full-offload, there is no need to specify the
+.B clockid
+argument.
+
+The txtime-assist and full-offload features are mutually exclusive, i.e.
+setting flags to 0x3 is invalid.
+.RE
 
 .TP
 txtime-delay
@@ -178,5 +196,28 @@ for more information about configuring the ETF qdisc.
               offload delta 200000 clockid CLOCK_TAI
 .EE
 
+The following is a schedule in full offload mode. The
+.B base-time
+is 200 ns and the
+.B cycle-time
+is implicitly calculated as the sum of all
+.B sched-entry
+durations (i.e. 20 us + 20 us + 60 us = 100 us). Although the base-time is in
+the past, the hardware will start executing the schedule at a PTP time equal to
+the smallest integer multiple of 100 us, plus 200 ns, that is larger than the
+NIC's current PTP time.
+
+.EX
+# tc qdisc add dev eth0 parent root taprio \\
+              num_tc 8 \\
+              map 0 1 2 3 4 5 6 7 \\
+              queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \\
+              base-time 200 \\
+              sched-entry S 80 20000 \\
+              sched-entry S a0 20000 \\
+              sched-entry S df 60000 \\
+              flags 0x2
+.EE
+
 .SH AUTHORS
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
-- 
2.25.1

