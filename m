Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817751D38C1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgENSCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENSCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 14:02:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8CAC061A0C;
        Thu, 14 May 2020 11:02:39 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w65so1638611pfc.12;
        Thu, 14 May 2020 11:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ca0BK/SGguPh7YFdWi84as3Zz0WDKCZt+ZX9om6cp8s=;
        b=vB3ezNNGYx/OX/GE+/020ICoVVXSEKWSQIMqDnGH24sr8nyR4gmbHc8Q+FFPfc3LYf
         ECWCy/KpLzrvqMmiTzD0WlfXlaTuydT3awaHd4wpxew4Xk6yew68jZtoOu/ggOXtUF9b
         /eUVOHFN164nYxKeS7MpD7W7Hk+AcCN53/lHsaj+FnlZyO/Rl+I8uUcRQ5/nZOqjxfNG
         /5mu0vLfwy6Cxy0zFIQYB3pKk1UNOjBGyDWCp9C5tJ1OoAWeHRFMvZ6zBqK6a+nCd1xr
         w5Y97aJG7DTWJAcr2ZHP3cxPimP0h5/qgMU2i5IdYvWNLsXjYXPBbdU6vsFNSgjY5vDB
         trkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ca0BK/SGguPh7YFdWi84as3Zz0WDKCZt+ZX9om6cp8s=;
        b=BTvk5agM2/UwnFXlHpwUsVIP1bDJCJpNFSAZhBX3+Emgk+SIHdyR3XYqYqgPNDCH8R
         RK7CdLFT6K2GzAc/9N9EcdLa7CoikCM3thh2mwNvS5HrCP7nUt4tnxc9K/ReSXSQUu3r
         Rf00+dlJxqZ4wcRO6Xu9wvsONik8EiI5bkH57dFLIqD04M78feYfhtbyK1AAMdLQa9t7
         oj1SFmoeRvFkevamugR5yWPoY9Ts3AwBi7JNH+Jx4kZhjOhdhWEOX85XnsIOPMl0vTTZ
         f+w3TW1Yz0XprZg7a0MTMDeUp1ZXHKBcr8TGlF9cK1YP/Ja6O26HeWGI6h8NV17N3oSu
         Z+CQ==
X-Gm-Message-State: AOAM532QvzoKudxCJkpc5ixQG1APOtSUUAuz4dTaWpsqYcZ0HhE9AROd
        Xc2LYbW6g4RxEMurJsLG6JE=
X-Google-Smtp-Source: ABdhPJx1d23IkIDeVzl+s/M8y4Qu5Th2SszbNzKYQrEBab8KIaYwzFQ+J3GcXEmDo6GeH3LOsiySdQ==
X-Received: by 2002:a63:b1a:: with SMTP id 26mr4946012pgl.443.1589479357535;
        Thu, 14 May 2020 11:02:37 -0700 (PDT)
Received: from localhost.localdomain ([103.87.56.31])
        by smtp.googlemail.com with ESMTPSA id s102sm4594079pjb.57.2020.05.14.11.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 11:02:36 -0700 (PDT)
From:   Amol Grover <frextrite@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Patrick McHardy <kaber@trash.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Qian Cai <cai@lca.pw>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>,
        syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com
Subject: [PATCH net v2 2/2] ipmr: Add lockdep expression to ipmr_for_each_table macro
Date:   Thu, 14 May 2020 23:31:03 +0530
Message-Id: <20200514180102.26425-2-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200514180102.26425-1-frextrite@gmail.com>
References: <20200514180102.26425-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the initialization process, ipmr_new_table() is called
to create new tables which in turn calls ipmr_get_table() which
traverses net->ipv4.mr_tables without holding the writer lock.
However, this is safe to do so as no tables exist at this time.
Hence add a suitable lockdep expression to silence the following
false-positive warning:

=============================
WARNING: suspicious RCU usage
5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
-----------------------------
net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!

ipmr_get_table+0x130/0x160 net/ipv4/ipmr.c:136
ipmr_new_table net/ipv4/ipmr.c:403 [inline]
ipmr_rules_init net/ipv4/ipmr.c:248 [inline]
ipmr_net_init+0x133/0x430 net/ipv4/ipmr.c:3089

Fixes: f0ad0860d01e ("ipv4: ipmr: support multiple tables")
Reported-by: syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Amol Grover <frextrite@gmail.com>
---
v2:
- Change the lockdep expression to check for list emptiness at init
- Add Fixes tag
- Add Reported-by tag for syzbot report

 net/ipv4/ipmr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 4897f7420c8f..5c218db2dede 100644
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
+				list_empty(&net->ipv4.mr_tables))
 
 static struct mr_table *ipmr_mr_table_iter(struct net *net,
 					   struct mr_table *mrt)
-- 
2.24.1

