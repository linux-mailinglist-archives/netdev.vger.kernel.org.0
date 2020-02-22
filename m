Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A23168CEA
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 07:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgBVGmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 01:42:14 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:47031 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgBVGmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 01:42:13 -0500
Received: by mail-pg1-f193.google.com with SMTP id y30so2097869pga.13;
        Fri, 21 Feb 2020 22:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9hYMlHxQU9EhnNg/RTgwCsCYqoi4kN3olIEeJ3OkvPk=;
        b=EjxVA3Br6FjEjanPqEhDEoiXcouvU+bGrOv3uTHp9VrVsy3AXGgMpJunV/dlGd1qUm
         h3uIb/c+THfk4d8i8eRh2Gmc6RKBk0FeWU0DeLHdnsCMJijfu9dXn3U/Gbw9qIpykRGt
         gagL4hr4DlgdCOOYPod1UshTeKzN51JTcTv3f74iLTF3ML8aBN5tFTu6vgRzkeuugQ8+
         v7r1tvbe5PFXIYjKy1auosHppC+l4qMmg+TqQGywTUnIQ9D24onvbs6RVVN+8cyCqdJZ
         7gcoN0kyc3bs6KMHZ694GcP6l1jBOCqrZomZdNBuvqhCS9wlN++JrQOVIs3Jl97i9n2/
         1y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9hYMlHxQU9EhnNg/RTgwCsCYqoi4kN3olIEeJ3OkvPk=;
        b=I3Dtv0C2qiI+W9qIqynuQp6GzUt0mwf7Gt+HCKHVglc4ez/fz+Zetm3SCN4pL3bA20
         h0MxQ9AMI10s7xI1GqU3RNay4N1q1WewJVMX98+GMyWOkg8IDzvB0d72sNvlIzTM57QA
         ZJW0AUyQZSqQRD8nSg2lcKr8i0IlLWittsf55AfHLoRHvtc6NKWlXip2t3Awahv+f79C
         18aka8oM0ID4HkN8H2KZKveAFnpukZdtpY64KBxS1vxxuhGH14bYX5OTMQFKvTEfuE/p
         5sBRGNMw/n7q6gKq7qJkIqvJk9ll3Y8lz8muWNmgw/3XPlvZS+3fUGq5NXxmStmXlKT2
         Zpiw==
X-Gm-Message-State: APjAAAVJGbSldYCZvu05LzIezEYx8Fl6JjlmwIwggQvP3wptveGpPPcN
        u9jgU3Tm+6CFhtkFjMXAW19HAk40pJo=
X-Google-Smtp-Source: APXvYqwdWk7osSGXdnZrrkUWAfAmanU6pj0j8QeL8rczy5YSTPsqUDFk5CjIMGs1shp3kNuLzO94Qg==
X-Received: by 2002:a65:645a:: with SMTP id s26mr40682184pgv.135.1582353733058;
        Fri, 21 Feb 2020 22:42:13 -0800 (PST)
Received: from localhost.localdomain ([103.87.57.201])
        by smtp.googlemail.com with ESMTPSA id k5sm4455071pju.29.2020.02.21.22.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 22:42:12 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH 2/2] ipmr: Add lockdep expression to ipmr_for_each_table macro
Date:   Sat, 22 Feb 2020 12:08:36 +0530
Message-Id: <20200222063835.14328-2-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200222063835.14328-1-frextrite@gmail.com>
References: <20200222063835.14328-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipmr_for_each_table() uses list_for_each_entry_rcu() for
traversing outside of an RCU read-side critical section but
under the protection of pernet_ops_rwsem. Hence add the
corresponding lockdep expression to silence the following
false-positive warning at boot:

[    0.645292] =============================
[    0.645294] WARNING: suspicious RCU usage
[    0.645296] 5.5.4-stable #17 Not tainted
[    0.645297] -----------------------------
[    0.645299] net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/ipv4/ipmr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 99c864eb6e34..950ffe9943da 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -109,9 +109,10 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags);
 static void ipmr_expire_process(struct timer_list *t);
 
 #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
-#define ipmr_for_each_table(mrt, net) \
-	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
-				lockdep_rtnl_is_held())
+#define ipmr_for_each_table(mrt, net)					\
+	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
+				lockdep_rtnl_is_held() ||		\
+				lockdep_is_held(&pernet_ops_rwsem))
 
 static struct mr_table *ipmr_mr_table_iter(struct net *net,
 					   struct mr_table *mrt)
-- 
2.24.1

