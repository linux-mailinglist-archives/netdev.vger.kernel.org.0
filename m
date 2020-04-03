Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD04919D354
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 11:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbgDCJQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 05:16:26 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44509 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgDCJQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 05:16:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id 142so3217483pgf.11;
        Fri, 03 Apr 2020 02:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=RGJzzKFtpMKwScibAzUPyVKFWmPESO3cVWtJiVbhtHk=;
        b=XVB2FpkhVY7LY+m+aYgnH9JhrXwxRrKtZ4KedbZoQ2SvOFvh7m7j2z6xHqnEpWua4g
         5wzj4NqRE5PhS5z1FB/u0m2aZZZgIXJhbcfiV/zGGuFPzd2c20GNNPDZjSIVOeqeTaq3
         StVZZ56H4ERPXhfY7iO941/MztLAKIR588259sQWUECLm+wy/lJks1cnnuJmzSB8zUdD
         IAiV6HO9Lk8x/O/WjbOs4YQHV3DBiw2hovWjix4wfiboFG+qzOdZNCeqmBcLX9d8LoCU
         zGYAOEelIN46+4Vb3jcI1H2Jodm5VPX8nLCT/fY53mic5cqJbGRoy4289ya3wA/FM8ix
         ZQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=RGJzzKFtpMKwScibAzUPyVKFWmPESO3cVWtJiVbhtHk=;
        b=q7mfQ/XA3ybAq+PYxzRcYnR4p6nISY7EZFrWjnRv3a0UfQxDA1peQRPQNyTgeBNweM
         EHG+GHwESTiXcG9Y1isZV3JlXiuAwx9F8aI/+kOoIiGGg+hfM8PEq8mgBh5l4VzZKWaS
         9s6SO8sq3AQiJpLIdB1bmLIaSvqRFAlYnsaAUrpWdg1BztbBV7vyUL0vdYo16GlGkLkm
         9NCmUFZHXvxY7s+N3fN3n+cn2p6VGB+nEqTAuaOu/tp/mjQrWsslRAsHqlYXthuV8yFM
         Wn3RqtNPaPFUkmJ2YtIUZZPVo9LymCVyjehz38vlh5FjZgMqe/nxF46tMHKMX5LbD56L
         c/OQ==
X-Gm-Message-State: AGi0PuZBUBfCggdB3e2WNkobVsp85XsWbRLO77nlHaMzG/xIwZ2ZWten
        GTSc5j320HK5eD17AIp0ypU=
X-Google-Smtp-Source: APiQypKLkyqex5WEdWq1dy4thrKY9/NTeFrsj5htXG6HJa5dtUYNkxEOcte9tTGGs8QwsckqyNKaIg==
X-Received: by 2002:a62:5f06:: with SMTP id t6mr7789776pfb.192.1585905384838;
        Fri, 03 Apr 2020 02:16:24 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id e80sm5608468pfh.117.2020.04.03.02.16.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Apr 2020 02:16:24 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mptcp: add some missing pr_fmt defines
Date:   Fri,  3 Apr 2020 17:14:08 +0800
Message-Id: <f66ab0b7dfcc895d901e6e85b30f2a21842d2b2c.1585904950.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <34c83a5fe561739c7b85a3c4959eb44c3155d075.1585899578.git.geliangtang@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the mptcp logs didn't print out the format string:

[  185.651493] DSS
[  185.651494] data_fin=0 dsn64=0 use_map=0 ack64=1 use_ack=1
[  185.651494] data_ack=13792750332298763796
[  185.651495] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 data_avail=0 skb=0000000063dc595d
[  185.651495] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 status=0
[  185.651495] MPTCP: msk ack_seq=9bbc894565aa2f9a subflow ack_seq=9bbc894565aa2f9a
[  185.651496] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 data_avail=1 skb=0000000012e809e1

So this patch added these missing pr_fmt defines. Then we can get the same
format string "MPTCP" in all mptcp logs like this:

[  142.795829] MPTCP: DSS
[  142.795829] MPTCP: data_fin=0 dsn64=0 use_map=0 ack64=1 use_ack=1
[  142.795829] MPTCP: data_ack=8089704603109242421
[  142.795830] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 data_avail=0 skb=00000000d5f230df
[  142.795830] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 status=0
[  142.795831] MPTCP: msk ack_seq=66790290f1199d9b subflow ack_seq=66790290f1199d9b
[  142.795831] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 data_avail=1 skb=00000000de5aca2e

Signed-off-by: Geliang Tang <geliangtang@gmail.com>

---
Changes in v2:
 - add pr_fmt to C files, not headers. 
---
 net/mptcp/options.c    | 2 ++
 net/mptcp/pm.c         | 2 ++
 net/mptcp/pm_netlink.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index bd220ee4aac9..faf57585b892 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -4,6 +4,8 @@
  * Copyright (c) 2017 - 2019, Intel Corporation.
  */
 
+#define pr_fmt(fmt) "MPTCP: " fmt
+
 #include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/mptcp.h>
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 064639f72487..977d9c8b1453 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -3,6 +3,8 @@
  *
  * Copyright (c) 2019, Intel Corporation.
  */
+#define pr_fmt(fmt) "MPTCP: " fmt
+
 #include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/mptcp.h>
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index a0ce7f324499..86d61ab34c7c 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -4,6 +4,8 @@
  * Copyright (c) 2020, Red Hat, Inc.
  */
 
+#define pr_fmt(fmt) "MPTCP: " fmt
+
 #include <linux/inet.h>
 #include <linux/kernel.h>
 #include <net/tcp.h>
-- 
2.17.1

