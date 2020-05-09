Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145E21CBE62
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgEIHYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725822AbgEIHYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 03:24:10 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBB9C061A0C;
        Sat,  9 May 2020 00:24:10 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f6so1986234pgm.1;
        Sat, 09 May 2020 00:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9hYMlHxQU9EhnNg/RTgwCsCYqoi4kN3olIEeJ3OkvPk=;
        b=toFHJ7qtvFR7dzF3OjoWHpTnMz2hSw7vehIHfwf2hCwwkiLguoTGUaaQyPygrhaQvA
         cNNF3HMgAU64obZSlo/Qbsp2Llv22owcs9QCBvxrwFjrecTpXPvrTzi2plEah/5zyNZE
         dAcfD6e5Mdi2rtYx8YiMdLBgb/c6Ihup0trgaXarr4Th6G1gaUV+Pls621KGL7tWdlYh
         Cr5bbih5uoIJGmuB0iMJjD7stWQczo1Ps+Xli8bU0glt01Zmgyyt6ZjTshxMle/haV7I
         W2NvGABs6rG0PR4bOLkj4HYOEzNWNtJu+ESTkGtZWLPpkQyntqA2qNK1LOEWZIE449QV
         hI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9hYMlHxQU9EhnNg/RTgwCsCYqoi4kN3olIEeJ3OkvPk=;
        b=kmQa3v8lFAmp/KWyX73gDyxAhZfuTMoAEeTbzrLarsf3WnZcHfbDqs6zWUM2RlCkAl
         Ey2L4yfLnfiuJqw2n/iU+8u+dmlCBydfwYuf5KcoWfH15oGHA3WsDgRfnGmS5LJzIiJc
         gLXF178lcIayx0NNiGs9J4JfHGAtU1LLICGsYKaMVRceqgPgA4hDZG32syM8kr8yHrxV
         FUYLXXFqJQT6KKTD4a4nyhP9W/wEwT71n2i02rNW9EzoBaNS5dFDYYbancEVyPVCXTxQ
         KAXON8yJFqyzxRpiXX0e1jXnTPrTBczePuLtYzHmZmgw8zef4vtnlGHu8beEeNDBY/Yc
         92jA==
X-Gm-Message-State: AGi0Pub3Mw2LX4Oq426SZf7rnOJbRPbi8ZeRZ1W46QxH9npClRGYtiWS
        Eal5Bsb8z7Gl+IMSH525wac=
X-Google-Smtp-Source: APiQypLeSUYISLie9vr9evfLKogEfTs2rJMiVRXqzJqa7GYRnCG/v53OoKFMppNGjJ0uC767/mYgiw==
X-Received: by 2002:aa7:91da:: with SMTP id z26mr7135697pfa.18.1589009049866;
        Sat, 09 May 2020 00:24:09 -0700 (PDT)
Received: from localhost.localdomain ([103.87.56.89])
        by smtp.googlemail.com with ESMTPSA id f74sm14024249pje.3.2020.05.09.00.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 00:24:09 -0700 (PDT)
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
Subject: [PATCH net 2/2 RESEND] ipmr: Add lockdep expression to ipmr_for_each_table macro
Date:   Sat,  9 May 2020 12:52:44 +0530
Message-Id: <20200509072243.3141-2-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200509072243.3141-1-frextrite@gmail.com>
References: <20200509072243.3141-1-frextrite@gmail.com>
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

