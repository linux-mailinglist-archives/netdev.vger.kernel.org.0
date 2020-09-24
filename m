Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5801276590
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgIXBDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgIXBDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:03:46 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA4BC0613CE;
        Wed, 23 Sep 2020 18:03:46 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id j7so691847plk.11;
        Wed, 23 Sep 2020 18:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=GDo7ywuW16yTRIPjlkiYS4kR39FyUMOrSMyJsiSy7mo=;
        b=AxBV5nz2LOn1ed183HSV1njzhM67P9iKERd/NXi9hoCS84L6DB4RR5ADpMxWIaOVUg
         o+pI9AeLifXWoom/WpptRrcfSGZhRDTK9JkBmxAYIWguIW/DWTtUyJwf8a9SG5w9BpXV
         Acz6Mvp1K6dm2hUzubCbmpk+3D1Z/Mm2XVgASYJoqtsBkXi7vgtx7i0KQTKxABNOvXjg
         JK5NVZ+FH93FuKmKxBaWdBPK+ey79tHczZ1qwifB/gMS15HXpeoixIHvWb2CmCoDb1sd
         GjdvPUQKByRvvE1nN1xyEOQ5hgwz5VxxHR6aqneJ03GCXyh1eDPTrwZ4RQ/lcexmI43D
         cDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=GDo7ywuW16yTRIPjlkiYS4kR39FyUMOrSMyJsiSy7mo=;
        b=QjwN0gi/pYuWdbxnk3Pufs8vYQfufM9y66b9FIFetvYdIOdLttuajPtxtlIXOK6y/p
         XXwGXppx93SM/H/UqVE+7t9iJb/qyvYvYKmuglGhQdzj/uQBt2qVLfZpv/S57ZMduCSJ
         oVHbrT6mbJ4a6idsokx485011gqus8RHX2qNu8XfovFp7baXq++/G2AEwDwxFu+TIfnd
         rlWTr/8QrHz5NhqIA9C66B1Di/r6bWK+Ej/JUDmaZbuDStrX+1JlY7nlF0LWqemAs2lf
         4rLf4kNQUUT9lxHAsBVB0ucElqgvQo6cOzlryanqDc9eiHyhyAOqD2SwRDkDnfFL/p19
         kqPQ==
X-Gm-Message-State: AOAM533tpYyARcFPY4Fev9WjU7KWq8Vx1Rc3Mp3mfI561rAfSe0PmB2N
        /KDqPNH4Ao5r/hheP1zhEc8=
X-Google-Smtp-Source: ABdhPJxS6fb1EoP4wTqbwtkI8wNS8yo9woG+hiXkzF63S1UFb6UxqATcl6yqjZS9beteZq2RLNLmKA==
X-Received: by 2002:a17:902:c3d3:b029:d1:e5e7:c4da with SMTP id j19-20020a170902c3d3b02900d1e5e7c4damr2366861plj.46.1600909426138;
        Wed, 23 Sep 2020 18:03:46 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id g26sm762856pfr.105.2020.09.23.18.03.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 18:03:45 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 14/16] mptcp: add struct mptcp_pm_add_entry
Date:   Thu, 24 Sep 2020 08:30:00 +0800
Message-Id: <26617b54898c115de8d916633b8e42055ed5c678.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <e0f074f2764382c6aa1e901f3003455261a33da3.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
 <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
 <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
 <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com>
 <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com>
 <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com>
 <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com>
 <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
 <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
 <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
 <fcebccadfa3127e0f55103cc7ee4cd00841e2ea0.1600853093.git.geliangtang@gmail.com>
 <aa4ffb8cb7f8c135e5704eb11cfce7cb0bf7ecd4.1600853093.git.geliangtang@gmail.com>
 <e0f074f2764382c6aa1e901f3003455261a33da3.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new struct mptcp_pm_add_entry to describe add_addr's entry.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index b33aebd85bd5..701972b55a45 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -28,6 +28,11 @@ struct mptcp_pm_addr_entry {
 	struct rcu_head		rcu;
 };
 
+struct mptcp_pm_add_entry {
+	struct list_head	list;
+	struct mptcp_addr_info	addr;
+};
+
 struct pm_nl_pernet {
 	/* protects pernet updates */
 	spinlock_t		lock;
@@ -181,7 +186,7 @@ static void check_work_pending(struct mptcp_sock *msk)
 static bool lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 				      struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_addr_entry *entry;
+	struct mptcp_pm_add_entry *entry;
 
 	list_for_each_entry(entry, &msk->pm.anno_list, list) {
 		if (addresses_equal(&entry->addr, addr, false))
@@ -194,23 +199,23 @@ static bool lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 				     struct mptcp_pm_addr_entry *entry)
 {
-	struct mptcp_pm_addr_entry *clone = NULL;
+	struct mptcp_pm_add_entry *add_entry = NULL;
 
 	if (lookup_anno_list_by_saddr(msk, &entry->addr))
 		return false;
 
-	clone = kmemdup(entry, sizeof(*entry), GFP_ATOMIC);
-	if (!clone)
+	add_entry = kmalloc(sizeof(*add_entry), GFP_ATOMIC);
+	if (!add_entry)
 		return false;
 
-	list_add(&clone->list, &msk->pm.anno_list);
+	list_add(&add_entry->list, &msk->pm.anno_list);
 
 	return true;
 }
 
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
 {
-	struct mptcp_pm_addr_entry *entry, *tmp;
+	struct mptcp_pm_add_entry *entry, *tmp;
 
 	pr_debug("msk=%p", msk);
 
@@ -654,7 +659,7 @@ __lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
 static bool remove_anno_list_by_saddr(struct mptcp_sock *msk,
 				      struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_addr_entry *entry, *tmp;
+	struct mptcp_pm_add_entry *entry, *tmp;
 
 	list_for_each_entry_safe(entry, tmp, &msk->pm.anno_list, list) {
 		if (addresses_equal(&entry->addr, addr, false)) {
-- 
2.17.1

