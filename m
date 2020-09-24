Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35B27656D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgIXAwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIXAwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:52:30 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DF0C0613CE;
        Wed, 23 Sep 2020 17:52:30 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f1so668593plo.13;
        Wed, 23 Sep 2020 17:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=sNAZchgd5OvG1GcGF+GODBoLJmoZ1bnk2rZ2FrG1Cfk=;
        b=pPDjcriqt8lA4Z1uNyxMsyR/Y/j3JAwh8u05hXW1NzTZ8OTPpqL2aXSrU8uGl8C3rf
         R+OCqvAlHJCpH5U+dFo3InNVmYDB01TV7gXiJlBipS1EQUKAT20mImNSgrQpbKtUkm/E
         9MN8dvs/o6OjZB1KJKsGXthP2MOgB9a/zB89P7XFqsxpjnAbfWwvOVbGaIGN3NDwFGmP
         GaxJCyX3LRAXfCuLUkyQV315D4xSpEHK/L9zcdfifhZHdoNTpKyBrGNhy9F48ZjhET/l
         bFedrSShQZ+vDNzWYiVGfY2Teb2L0Tll/pJFVBuHWkQcZ46NXyPFh79pIK+0joAR19YL
         qMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=sNAZchgd5OvG1GcGF+GODBoLJmoZ1bnk2rZ2FrG1Cfk=;
        b=YobWhLcPh15bfvoA/826F9JQvVQqpcrBMEfn0wgpca5nWzMfzXwJwaHJnpy6oITLfw
         bnbu1f/XKg17YcGeISgVFjd1JCRcd8DU4djWlI1PEM3qYmkgdAg+yInkSpQkQIGfKLuA
         fBmSfzKM9UQrpJvBJsdpBqXdfsc77Fw+nUZbblsBhEnL7C2SA/SnU+ArCDLUkure6Kyn
         9S/2R+maklDmqpUNQckq/LMecbcXlUL1hWsRBbLQFBPck67tmCuzSG2XgpE2X3jMpA/E
         fft2zlNnyWHRpzTMGM2PcITwfaWfbKQOuuZxg3zy9Zsd439nDdPIYDWsY61bi59AmC5t
         g6kQ==
X-Gm-Message-State: AOAM530ngSzzmJfoaC2pZkYc+e7t6PCfoy1yZ4xhlzb7mUpOyFycUwmF
        ODdt12cWulh6v51aKRsnLyw=
X-Google-Smtp-Source: ABdhPJz4Z3m6YLE4n4xpQqADzyOlhYcIC2IX1RvGi9O/0aqQHjvjwqV8UyHZ6HVjOjn3i3V6dQQSRg==
X-Received: by 2002:a17:90b:3841:: with SMTP id nl1mr1556075pjb.99.1600908750320;
        Wed, 23 Sep 2020 17:52:30 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id n7sm749840pfq.114.2020.09.23.17.52.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:52:29 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 09/16] mptcp: implement mptcp_pm_remove_subflow
Date:   Thu, 24 Sep 2020 08:29:55 +0800
Message-Id: <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com> <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com> <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com> <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com> <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com> <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implemented the local subflow removing function,
mptcp_pm_remove_subflow, it simply called mptcp_pm_nl_rm_subflow_received
under the PM spin lock.

We use mptcp_pm_remove_subflow to remove a local subflow, so change it's
argument from remote_id to local_id.

We check subflow->local_id in mptcp_pm_nl_rm_subflow_received to remove
a subflow.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm.c         |  9 +++++++--
 net/mptcp/pm_netlink.c | 33 +++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h   |  3 ++-
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index f450bf0d49aa..7e81f53d1e5d 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -33,9 +33,14 @@ int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id)
 	return 0;
 }
 
-int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 remote_id)
+int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 local_id)
 {
-	return -ENOTSUPP;
+	pr_debug("msk=%p, local_id=%d", msk, local_id);
+
+	spin_lock_bh(&msk->pm.lock);
+	mptcp_pm_nl_rm_subflow_received(msk, local_id);
+	spin_unlock_bh(&msk->pm.lock);
+	return 0;
 }
 
 /* path manager event handlers */
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 97f9280f83fb..9064c8098521 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -350,6 +350,39 @@ void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 	}
 }
 
+void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id)
+{
+	struct mptcp_subflow_context *subflow, *tmp;
+	struct sock *sk = (struct sock *)msk;
+
+	pr_debug("subflow rm_id %d", rm_id);
+
+	if (!rm_id)
+		return;
+
+	if (list_empty(&msk->conn_list))
+		return;
+
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
+		long timeout = 0;
+
+		if (rm_id != subflow->local_id)
+			continue;
+
+		spin_unlock_bh(&msk->pm.lock);
+		mptcp_subflow_shutdown(sk, ssk, how);
+		__mptcp_close_ssk(sk, ssk, subflow, timeout);
+		spin_lock_bh(&msk->pm.lock);
+
+		msk->pm.local_addr_used--;
+		msk->pm.subflows--;
+
+		break;
+	}
+}
+
 static bool address_use_port(struct mptcp_pm_addr_entry *entry)
 {
 	return (entry->addr.flags &
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d1b1416797f8..df6cc94df1f7 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -448,7 +448,7 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
 			   bool echo);
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id);
-int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 remote_id);
+int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 local_id);
 
 static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 {
@@ -479,6 +479,7 @@ void mptcp_pm_nl_fully_established(struct mptcp_sock *msk);
 void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk);
 void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk);
+void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 
 static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
-- 
2.17.1

