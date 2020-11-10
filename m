Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEE12ACB72
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgKJDBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKJDBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:01:54 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9858C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 19:01:53 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id y22so723278plr.6
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 19:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ocI1tny0QYGEwvTzxseOGuLHUyvU0HinLGkEDs66FSo=;
        b=ZV8uWk9O7J5OLydfttY9+VK7W6qpBh9V8uoctzMsH+TTKpZo02Y5lt9QYtvM+Blat0
         VvUAJoUWIF71Xny9l85pAABULqQGKvUVRGBeNIhrTSElr1NcnVT0Cv3B2k1Mpbja0YOl
         az3nXSHoY/ITdn7FBP7T//Ze9FOJtoayGhjHKdnNjFcEbQ6IVahTaJLARLXW2IEsa5XV
         fwsFm7lIrCOvuEYKpKW4oRZxEqsbrBby3ZVcSCLjEqjvvavvFI1eRPuPY9DS332TPeKG
         nAqV/TKekPZrt7hx/J9v0ySRDKPv4Prh2f2yUxGb0T5SyRI7MzSVQ71VG2mVkaiwj9T7
         5BOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ocI1tny0QYGEwvTzxseOGuLHUyvU0HinLGkEDs66FSo=;
        b=kTyiGnsCZihQIyopQ8ReI/oVtDZrkcwn48fPkaY+QMptN3FI7qRKaG8UCIj1cSX6sL
         0MYPOsFmxnNGsat2WTg2acvpqmKNtIkeJlab/R2kqJqblEeEqyh66OiuIOWpG+mPTsBH
         UPhWkqeXK0HlJ+vXy1Empt9fkcfpKj9J9mKqHd0sb8Yi/TBaSJ/LS34cocsRBNFjbS7y
         YGXdxT+ru9kguvv6H67K2933ey8Y/GtsW7mJQpxdxmny995ic8J2Vl3TREDCKFKd/xjj
         VWDg5npw2oSmrYaCqdDRp10D2YvWa5ytcLXpQFeGk/2FSyyZfnKVjsJqr/IkSxd/g3vg
         9nwQ==
X-Gm-Message-State: AOAM533QiuBRQr4jTbqDnnZD1TvmNLQYF4PQBipothKAmlLvUGmO9D/m
        ML9mHT1XDnvsdqNCsFqJdgk=
X-Google-Smtp-Source: ABdhPJxlbl/H2EnaLwb93L/EcK6gOkFkgvOllX4IfqsRZtKYtjElHCJuQ9EuPBK8ozRf0Dn7LIpaNw==
X-Received: by 2002:a17:902:fe18:b029:d6:991c:6379 with SMTP id g24-20020a170902fe18b02900d6991c6379mr12030031plj.20.1604977313085;
        Mon, 09 Nov 2020 19:01:53 -0800 (PST)
Received: from localhost ([2400:8800:300:11c:eadf:df6a:3721:a0a2])
        by smtp.gmail.com with ESMTPSA id t12sm12522465pfq.79.2020.11.09.19.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:01:52 -0800 (PST)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [MPTCP][PATCH v2 net-next] mptcp: fix static checker warnings in mptcp_pm_add_timer
Date:   Tue, 10 Nov 2020 11:01:43 +0800
Message-Id: <078a2ef5bdc4e3b2c25ef852461692001f426495.1604976945.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following Smatch complaint:

     net/mptcp/pm_netlink.c:213 mptcp_pm_add_timer()
     warn: variable dereferenced before check 'msk' (see line 208)

 net/mptcp/pm_netlink.c
    207          struct mptcp_sock *msk = entry->sock;
    208          struct sock *sk = (struct sock *)msk;
    209          struct net *net = sock_net(sk);
                                           ^^
 "msk" dereferenced here.

    210
    211          pr_debug("msk=%p", msk);
    212
    213          if (!msk)
                    ^^^^
 Too late.

    214                  return;
    215

Fixes: 93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 v2:
 - drop "mptcp: cleanup for mptcp_pm_alloc_anno_list"
 - change tag to net-next.
This patch should be applied to net-next, not -net. Since commit "mptcp:
add a new sysctl add_addr_timeout" is not applied to -net yet.
---
 net/mptcp/pm_netlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index ed60538df7b2..446ef8f07734 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -206,7 +206,6 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
-	struct net *net = sock_net(sk);
 
 	pr_debug("msk=%p", msk);
 
@@ -234,7 +233,7 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
 		sk_reset_timer(sk, timer,
-			       jiffies + mptcp_get_add_addr_timeout(net));
+			       jiffies + mptcp_get_add_addr_timeout(sock_net(sk)));
 
 	spin_unlock_bh(&msk->pm.lock);
 
-- 
2.26.2

