Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FF419D196
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 09:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390228AbgDCH7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 03:59:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46659 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732595AbgDCH7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 03:59:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id s23so2389199plq.13;
        Fri, 03 Apr 2020 00:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HkFftEmd1xByJ3L+7Q66Ss8hnA6ge5noLyBAo3i2apI=;
        b=owdPcNHLVrE6Ernuo3DIqVGM+J5Nqciv40IjY4XcWu6kUJXVDuppwYzvUm9xhzkGer
         2RyZBP3uYHNjwRvtxkJcB/FYs3ct/0V3YBWr5k5LLix+qzWavz5paoVlgAvhoR7jJYEE
         mvvgY0d14n8bomLWQlFCr7FyU6IUbUfBrwkw6Pvy4NMU9ZF3KLO5XyV+dBokkDkCC0ot
         QQZIYeZEV1nseE8I+9SvwHqOryshuUpMFamfMArl1Th+4HqS//ZCJkeMwnbZUFvsZOOn
         GwvHh7kB2LDxYOFVy29uV+XjTjBI3wXmZucdYE2l4lIuPc0E9AHMW9gg7sp6agq5FJrJ
         dfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HkFftEmd1xByJ3L+7Q66Ss8hnA6ge5noLyBAo3i2apI=;
        b=RgbUCBc2+NLLTtv8hEGMbba8mpHUZQ9V6b+0G3rmSWWgqclzpIK9tYjRSrmBFT2RAp
         H+VOaVPckg6D7WFEw0jH6KclBu893fe6pBUVs5p2Bx1eQP1Co9TBqvXmErDZJZlT5EMO
         Q6dIF0nuphYLIEuBeqBU3RlUwJEDDuJcJb26aGhiTyJCoW3bju47o0EVuEndFtrVeF6m
         vwygaGGk18WFg2Q4thUiAwtKyRz9jNtuIECYN5u8kuqLs70oXMLSMFoXFJo1eAZ6wVoQ
         4l38xZHuCyS6/+iXdKaZzYuJj+pcj5Jg3EN9v2pNnulmzeA5h218sirunAuXDXDaa5Hs
         skqg==
X-Gm-Message-State: AGi0PubNJILFPw1P/2XZ/J7MywEHOY10oVOVHyhQKE21R+gulcwSUw9h
        CIa/cFfUJStUjsAaVf4+QHBCHeHn
X-Google-Smtp-Source: APiQypJCLfL2iWxMmyuJ+LAUznxT/4OCgOffcowdkVFQSdCP3AaRC5/0SwntKetKknxf7y3Lqj4VfQ==
X-Received: by 2002:a17:90b:1118:: with SMTP id gi24mr7409859pjb.99.1585900780339;
        Fri, 03 Apr 2020 00:59:40 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id x27sm5263837pff.200.2020.04.03.00.59.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Apr 2020 00:59:39 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mptcp: move pr_fmt defining to protocol.h
Date:   Fri,  3 Apr 2020 15:57:25 +0800
Message-Id: <34c83a5fe561739c7b85a3c4959eb44c3155d075.1585899578.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the mptcp logs didn't print out the format string "MPTCP":

[  129.185774] DSS
[  129.185774] data_fin=0 dsn64=1 use_map=1 ack64=1 use_ack=1
[  129.185774] data_ack=5481534886531492085
[  129.185775] data_seq=15725204003114694615 subflow_seq=1425409 data_len=5216
[  129.185776] subflow=0000000093526a92 fully established=1 seq=0:0 remaining=28
[  129.185776] MPTCP: msk=00000000d5a704a6 ssk=00000000b5aabc31 data_avail=0 skb=0000000088f05424
[  129.185777] MPTCP: seq=15725204003114694615 is64=1 ssn=1425409 data_len=5216 data_fin=0
[  129.185777] MPTCP: msk=00000000d5a704a6 ssk=00000000b5aabc31 status=0
[  129.185778] MPTCP: msk ack_seq=da3b25b9a233c2c7 subflow ack_seq=da3b25b9a233c2c7
[  129.185778] MPTCP: msk=00000000d5a704a6 ssk=00000000b5aabc31 data_avail=1 skb=000000000caed2cc
[  129.185779] subflow=0000000093526a92 fully established=1 seq=0:0 remaining=28

So this patch moves the pr_fmt defining from protocol.c to protocol.h, which
is included by all the C files. Then we can get the same format string
"MPTCP" in all mptcp logs like this:

[  141.854787] MPTCP: DSS
[  141.854788] MPTCP: data_fin=0 dsn64=1 use_map=1 ack64=1 use_ack=1
[  141.854788] MPTCP: data_ack=18028325517710311871
[  141.854788] MPTCP: data_seq=6163976859259356786 subflow_seq=3309569 data_len=8192
[  141.854789] MPTCP: msk=000000005847a66a ssk=0000000022469903 data_avail=0 skb=00000000dd95efc3
[  141.854789] MPTCP: seq=6163976859259356786 is64=1 ssn=3309569 data_len=8192 data_fin=0
[  141.854790] MPTCP: msk=000000005847a66a ssk=0000000022469903 status=0
[  141.854790] MPTCP: msk ack_seq=558ad84b9be1d162 subflow ack_seq=558ad84b9be1d162
[  141.854791] MPTCP: msk=000000005847a66a ssk=0000000022469903 data_avail=1 skb=000000000b8926f6
[  141.854791] MPTCP: subflow=00000000e4e4579c fully established=1 seq=0:0 remaining=28
[  141.854792] MPTCP: subflow=00000000e4e4579c fully established=1 seq=0:dcdf2f3b remaining=28

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/protocol.c | 2 --
 net/mptcp/protocol.h | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 72f3176dc924..cc86137cd04f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -4,8 +4,6 @@
  * Copyright (c) 2017 - 2019, Intel Corporation.
  */
 
-#define pr_fmt(fmt) "MPTCP: " fmt
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 67448002a2d7..3eff041eeccf 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -7,6 +7,8 @@
 #ifndef __MPTCP_PROTOCOL_H
 #define __MPTCP_PROTOCOL_H
 
+#define pr_fmt(fmt) "MPTCP: " fmt
+
 #include <linux/random.h>
 #include <net/tcp.h>
 #include <net/inet_connection_sock.h>
-- 
2.17.1

