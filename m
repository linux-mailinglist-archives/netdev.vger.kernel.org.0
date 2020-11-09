Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2E12ABE0D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgKIN7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729854AbgKIN7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:59:40 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797FEC0613CF;
        Mon,  9 Nov 2020 05:59:38 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id e7so8228542pfn.12;
        Mon, 09 Nov 2020 05:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gSYjZ1cUgOekEM7SwW9yeu6llfvLPIn9JJb6KN19b+0=;
        b=uheTqZt3G2+6GJj/cnThwf9U010w83aj61EMBOva7nathZ8x/txGFq9RJd7zy5O7q7
         Z+qZveWsaJMx7KsOK8BCgsRr9Myqdh+/u3J9225VqAXndLlOSf3W0jhO3XBASTAN7gdW
         RyRm6KF5rY6emONkNlZRtKwm5EWhnhpLPg3NBtFbJ09MQusOUAd3uPRgMDrF4fGiVqIV
         Em0N3pqiUpDkxQgKxMqrH9W4PezYE3c5d5LixTPQh4NGjXRyKXPEJXyCuusXMbO4YZAw
         mmTQoO4ihtK6Ysm8eStgwwssoRRNxXaopu3jCWJpvhyzV1vXCFNvPEwj6qfM0XXHQePs
         ucKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gSYjZ1cUgOekEM7SwW9yeu6llfvLPIn9JJb6KN19b+0=;
        b=bCsQuA2DYlYSj7Sc5SZD2eDZfFHnyCFnLY+IqKun9DF8DXC+Y7O4jEQNBKQObsvLh5
         NVX2moim0TTguzUec7wAmmy/IFmZqPYkbKkLPCv4qTIK/kMFFZs4QypUkAFE11jKpyJD
         ST50t9xx6Gzf9yJSkdb1GmLAs2sjahc1ko+p1W836gq2mzQ8pxPa4eYJWbIk40hNN/WN
         er7kVX8Z7wrAsLPmwZOOYSzSCFlU5pYOrpqql2r1m15Uz0ciZ6ldlVmtjLXCN1k0yJP4
         hp75oyneEVhsWDDnDzfnsynuOLMEKs4b0EWbYUaxc6iQSASuMNl73pN3mH4xw/Xw5wUC
         kseg==
X-Gm-Message-State: AOAM531Tl5HVFOsD5ydaMXSCNI5JjScvT3OvJ44QrDWCJoY3BdvZDaD9
        fryguhVl/qACkUpjVKwLtZy65i7SKCvn8Q==
X-Google-Smtp-Source: ABdhPJyfg6WaH76st17Ot4HhGAxk1PA0a1hNeb+g2YZFvH9jjh5LnZNprzZ3mGoKYIKRbp8mH0SqoQ==
X-Received: by 2002:a17:90b:1642:: with SMTP id il2mr12300961pjb.81.1604930378160;
        Mon, 09 Nov 2020 05:59:38 -0800 (PST)
Received: from localhost ([209.9.72.213])
        by smtp.gmail.com with ESMTPSA id j12sm10422175pga.78.2020.11.09.05.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 05:59:37 -0800 (PST)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [MPTCP][PATCH net 2/2] mptcp: cleanup for mptcp_pm_alloc_anno_list
Date:   Mon,  9 Nov 2020 21:59:22 +0800
Message-Id: <0f17d2f60c188554d093e820c45caf20fe53aab0.1604930005.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
References: <cover.1604930005.git.geliangtang@gmail.com> <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added NULL pointer check for mptcp_pm_alloc_anno_list, and
avoided similar static checker warnings in mptcp_pm_add_timer.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/mptcp/pm_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 03f2c28f11f5..dfc1bed4a55f 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -266,7 +266,9 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 {
 	struct mptcp_pm_add_entry *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
-	struct net *net = sock_net(sk);
+
+	if (!msk)
+		return false;
 
 	if (lookup_anno_list_by_saddr(msk, &entry->addr))
 		return false;
@@ -283,7 +285,7 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 	sk_reset_timer(sk, &add_entry->add_timer,
-		       jiffies + mptcp_get_add_addr_timeout(net));
+		       jiffies + mptcp_get_add_addr_timeout(sock_net(sk)));
 
 	return true;
 }
-- 
2.26.2

