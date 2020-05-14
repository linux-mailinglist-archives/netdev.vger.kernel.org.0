Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832921D38BF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgENSCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENSCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 14:02:33 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E21C061A0C;
        Thu, 14 May 2020 11:02:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k22so182887pls.10;
        Thu, 14 May 2020 11:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7zabWZX7zia6FGAl/2g9/rRePkB0T8QEsMQp4+a+KVc=;
        b=aQCQr6U9CCACb3xi4GcbeO3Ij3GnygrgW/rLvBZHveDxvGGhUA0azKpsjc+ckY1KQi
         GaLXLNDMjd+UDWLTU1dQF/DmbRGXvwrdiIvTzI6h/svgOwYBrtyEBUf545NxdH0qBPpz
         3nUbFXs5s40ooengpKQr9D1fAvVV19Sq6MYkaVUeB0nmhWjBQV2FvhAbk70wGQbf06NX
         ti1JlvBXnmNHMdlWejLYix+UCoPoVvPYeTh95avlwTeZotQM8uaDgqxxSrRw77LyFhtI
         6lyb2vYhWzRT4DxZpojO01GlfcLBW0B/FnFE2QP5F45wmHb6RFCt6NGRfyGGYTWlU4XR
         S6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7zabWZX7zia6FGAl/2g9/rRePkB0T8QEsMQp4+a+KVc=;
        b=O+BHhnRPhJ7ZxgU7v7vkmRNsPXhI1z/XYsx3gQjMyiXGRk0BU6Rdzkyck4cAVlzt9p
         BOEFBNGDhd14d6YF/ZDtLibZfka4hPeN7nCJmtv9Z1Lkn1eWxMiWREy1KnYJt8ye8NSf
         whi1b+ExIBFZaVMbgZMk/LA8pmLqZp00DzLy9RTBOScYqgRQHlBT04qWjxPmbT3qI8z5
         D6CQSDI5eTVcKDQX2RzpsMYqzPe6xjuatTS2YjBPCy4J8Q9qAXalZvvazaJzpCsS3fIO
         6GKQFCqFx/fbCjIRLARbJ7T+Cwh/F4fG/VTF0u+EyOoFnBu2kNSGsDhXVHZFCmAa2Es2
         YGQA==
X-Gm-Message-State: AOAM5304iAz9HvHDOp5mDXZ9iUVhsy8BeWOLeNakDervO8LgWzTbblEM
        5eBBjclUuWwXE7m5fdgZ0hYvTyB3F/k=
X-Google-Smtp-Source: ABdhPJy/icmI40gwG9O80DXWUuHBQDVQog7Y7jXBEQ88FWbaHdlqDynL7D2LdQWr2EQGscCkrTM3hQ==
X-Received: by 2002:a17:90a:de07:: with SMTP id m7mr3795254pjv.100.1589479352409;
        Thu, 14 May 2020 11:02:32 -0700 (PDT)
Received: from localhost.localdomain ([103.87.56.31])
        by smtp.googlemail.com with ESMTPSA id s102sm4594079pjb.57.2020.05.14.11.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 11:02:31 -0700 (PDT)
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
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH net v2 1/2] ipmr: Fix RCU list debugging warning
Date:   Thu, 14 May 2020 23:31:02 +0530
Message-Id: <20200514180102.26425-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipmr_for_each_table() macro uses list_for_each_entry_rcu()
for traversing outside of an RCU read side critical section
but under the protection of rtnl_mutex. Hence, add the
corresponding lockdep expression to silence the following
false-positive warning at boot:

[    4.319347] =============================
[    4.319349] WARNING: suspicious RCU usage
[    4.319351] 5.5.4-stable #17 Tainted: G            E
[    4.319352] -----------------------------
[    4.319354] net/ipv4/ipmr.c:1757 RCU-list traversed in non-reader section!!

Fixes: f0ad0860d01e ("ipv4: ipmr: support multiple tables")
Signed-off-by: Amol Grover <frextrite@gmail.com>
---
v2:
- Add appropriate Fixes tag

 net/ipv4/ipmr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 9cf83cc85e4a..4897f7420c8f 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -110,7 +110,8 @@ static void ipmr_expire_process(struct timer_list *t);
 
 #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
 #define ipmr_for_each_table(mrt, net) \
-	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list)
+	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
+				lockdep_rtnl_is_held())
 
 static struct mr_table *ipmr_mr_table_iter(struct net *net,
 					   struct mr_table *mrt)
-- 
2.24.1

