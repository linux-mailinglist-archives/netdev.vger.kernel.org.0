Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD99145B80
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgAVSXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:23:01 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42154 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:23:01 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so3936260pgb.9
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JS/s9j8U9IeQ6/b6RxEgOuCmaH0wVa5WX2YOp3bYvgI=;
        b=kxfxaxXXufadb3b7T/OH3vwbKBvgG/qTRABmxJlowEEbHWjsJEaur2G7CkzEgDXkN9
         t+npb+dguR/QqhNMlgI7cKtKVJEQbFYofd3Hk44UxaJRNk9iO7Ze0z2kjPQ4sNfgoCZC
         q3WYoIzqPwJg47d4EinysVmJ11SoOVoCrq0EP5oNST+JQQxd6gLE+REENoIJm2EYRt4b
         GV1IkmqWsIWkrrFritGWI/ZD0qU6BXEATyjA780t0ARGuc5f3g0/sjxqw1mAlffJ1/9v
         2xBKW66hdQceM0vpA0BOLJdeH2dhWaPlxs6Nw2zYYMR9HINIMfoiNFEwEimrlo+f/TcA
         NJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JS/s9j8U9IeQ6/b6RxEgOuCmaH0wVa5WX2YOp3bYvgI=;
        b=Y2BFQN2YwVqjcQa+T3OROi5V1N6K5IVG8bsM7YhTKRTs5BvFajqzkbzSykEkmH7AYN
         dC9ye4G9RWASFCkXvmcWHDML4QLHWsFGVxWbb2s4E1hdTO1sdOze/Xc59+AvWfpt4SYP
         Ft83wRNX0jaZrTj4vCj6mxQe47MCWO09DdOXk/njyJHHmGEsnXnHupm48AMOtaluIPxV
         fBRJaYek/D6Qrzc0HfZNj/ci5V5uSwnu9sdZpJi6svG75gIzuDswqjBfVm2uch2hhVli
         YZZ4D97+fECdI4K+rodDyCzNfJkiL2ITU8p3uqersGExr5ZSQW7seBhtwmxigHbFO2tT
         0giA==
X-Gm-Message-State: APjAAAW+AujL0kkUy0d4TWcCGFfVniwtdMJqbxU/UFkWG1h/cmoq+0nq
        FVwlQvvyz7jZPDA29Z2xDOnjgq0taRTmAeVk
X-Google-Smtp-Source: APXvYqw8M0j3Bp5QQqtgxqR+JT1xeViQvW9HyC2D46/nu3mJm/Xhw3W6V0rfTRnM7yF6g2ODBAmoRQ==
X-Received: by 2002:a65:484d:: with SMTP id i13mr1502pgs.32.1579717380231;
        Wed, 22 Jan 2020 10:23:00 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:22:59 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v7 03/10] pie: rearrange macros in order of length
Date:   Wed, 22 Jan 2020 23:52:26 +0530
Message-Id: <20200122182233.3940-4-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Rearrange macros in order of length and align the values to
improve readability.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 7ef375db5bab..397c7abf0879 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -8,11 +8,11 @@
 #include <net/inet_ecn.h>
 #include <net/pkt_sched.h>
 
-#define QUEUE_THRESHOLD 16384
-#define DQCOUNT_INVALID -1
-#define DTIME_INVALID U64_MAX
-#define MAX_PROB U64_MAX
-#define PIE_SCALE 8
+#define MAX_PROB	U64_MAX
+#define DTIME_INVALID	U64_MAX
+#define QUEUE_THRESHOLD	16384
+#define DQCOUNT_INVALID	-1
+#define PIE_SCALE	8
 
 /* parameters used */
 struct pie_params {
-- 
2.17.1

