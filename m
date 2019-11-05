Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE22EF3D5
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 04:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfKEDN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 22:13:26 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:56326 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbfKEDN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 22:13:26 -0500
Received: by mail-pl1-f202.google.com with SMTP id k8so11635063pll.23
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 19:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=egMGy2VrLIR5LdMeyVqXO7lBeVg2QaLUiTWijAKsfHQ=;
        b=IU6PHKc59eQgmbIO9sIz1UuVy6nO48q1T4qvzQjC0JyxkwcXhhfUEcxk8n7CWI+8xE
         o5KK63D62JGR9WJVrcC695P21CGQ8WwyJuHt7KW9PweewIa9iYbZiyh50AcW5kKlPgGI
         /92S+C8t+0FzYVRWM122qBt01dRoie3oHqqsiS/qT7739mGeSHdUvGfTY/LR0Ap5onb0
         dxH0uWBqnBYGnEc1sT3TJ2FvwLCTCOD6hr2LkPaGXlWuoPgJp9bDzImNu2aY5m3wTr1/
         zJMoWvnyJ6/4v0cp+bT/vQPwBedffEOQSVC/tS2eGmJGVjIHJ6plcMdo/fa9ps8I+o2Y
         erPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=egMGy2VrLIR5LdMeyVqXO7lBeVg2QaLUiTWijAKsfHQ=;
        b=VIXJcGUx3PCVpn7t+K7vFzk1nCoDL70R3sqtMpwsghEZI60zSFdLxqgVNDIuhYSvoQ
         MVygV/ciawHbttKVqR+8/2TUBw0tRM2F2rQ8BlHhl+xrnzrgFFrBImb6HLspExBAHrjl
         JXcJbSQ7EtqtLtgahLKC1lEHUo7Xi5eeINp3fXkmfLH4zBJWT1Upsxw5ysybLQCyHCIY
         dTdNYox9IWZVzLHQyQ0Fl+T6b8xIkv1juG1mvoA4LGsVghUczareqHxb1/u3wxH59Whh
         ji1H5iD38YM0GbLLX3Hktyk+mUm1ValfQYg0M84l7/Bw0PvUx9slSb2KwuJQKw34xHqj
         7GZQ==
X-Gm-Message-State: APjAAAXk3loQceAe/6UCHXXTgcV0NwWAXbGsTzWFDr+x3QLkbpwKsNsj
        /SanDuoCucSeR4OEc8t/tdMIc+g3yFVZkw==
X-Google-Smtp-Source: APXvYqxZq5TMZySIy8/sj90BLCB1V0MYhBkxqzFMcyHiNNz63NgvsAViqUNzOadbacBWKeu1z9On1h2FN6wCUw==
X-Received: by 2002:a63:2057:: with SMTP id r23mr35189126pgm.274.1572923605561;
 Mon, 04 Nov 2019 19:13:25 -0800 (PST)
Date:   Mon,  4 Nov 2019 19:13:13 -0800
In-Reply-To: <20191105031315.90137-1-edumazet@google.com>
Message-Id: <20191105031315.90137-2-edumazet@google.com>
Mime-Version: 1.0
References: <20191105031315.90137-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 1/3] net_sched: do not export gnet_stats_basic_packed
 to uapi
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gnet_stats_basic_packed was really meant to be private kernel structure.

If this proves to be a problem, we will have to rename the in-kernel
version.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/gen_stats.h        | 6 ++++++
 include/uapi/linux/gen_stats.h | 4 ----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index ca23860adbb956fcfff3605068fdedf59073ce1a..5f3889e7ec1bb8b5148e9c552dd222b7f1c077d8 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -7,6 +7,12 @@
 #include <linux/rtnetlink.h>
 #include <linux/pkt_sched.h>
 
+/* Note: this used to be in include/uapi/linux/gen_stats.h */
+struct gnet_stats_basic_packed {
+	__u64	bytes;
+	__u32	packets;
+} __attribute__ ((packed));
+
 struct gnet_stats_basic_cpu {
 	struct gnet_stats_basic_packed bstats;
 	struct u64_stats_sync syncp;
diff --git a/include/uapi/linux/gen_stats.h b/include/uapi/linux/gen_stats.h
index 065408e16a807be59fec72ae7a9fec99b8fd383f..4eaacdf452e3b34f8f813046b801bfc1e6bdd2d4 100644
--- a/include/uapi/linux/gen_stats.h
+++ b/include/uapi/linux/gen_stats.h
@@ -26,10 +26,6 @@ struct gnet_stats_basic {
 	__u64	bytes;
 	__u32	packets;
 };
-struct gnet_stats_basic_packed {
-	__u64	bytes;
-	__u32	packets;
-} __attribute__ ((packed));
 
 /**
  * struct gnet_stats_rate_est - rate estimator
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

