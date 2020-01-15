Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3549013C886
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgAOP4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:56:38 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46936 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgAOP4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:56:38 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so8695921pff.13;
        Wed, 15 Jan 2020 07:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HwV9sGACUDknSqn3rZRjdfv8PQfY2jtJrBDpPLg25bE=;
        b=pfZQgYjBcjyCtn6E2E//UIWWV7YF8uAjc6ggh4p5mbPc/GNDh/t8TClwCoKqEY9iKm
         31WcNv/TU4fwcs85/hvITBoBQwLVXKXc/pq1wY9AFtXF2yclNcKLougfpxo4Rk7HthPf
         JKGNTLguhyvB97/Am9L/CUP3MrCj/46w4fxjcRfkXO25T4sy6vMUxLTAtfX+DvZ+ztaN
         0TJinWp2KwiFxkOa5ztbYrQZYs73Hv1EuT6dgymCzvzr+fdm6LEZUH2G+6yYELu7EAOO
         KM6yEegZ79mbzuNRVufVKJ2z4+wCZyjhs7MRMvV9HWkgyOvBGAQgQiMD9SVbFGb4EqZn
         upRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HwV9sGACUDknSqn3rZRjdfv8PQfY2jtJrBDpPLg25bE=;
        b=b923+AWd4Tbl6fSwkJWwPGNQd+KJvHj6/EZEx5adh0wg1gk9OrL9kLT/bIj6hELgy+
         t+cLRehQy/+d1hxYjOEnNdgR/cyWO+T4SUsgidp51lDK84zcahQ3pk3DCE+BL1lI3lG+
         4lYmRcoR9MiOPxjLNTboDEdAF44eRBDfx1nMDIuL9ZxTSLOi5/lpZg0EWATPHOF7wiCS
         fbG4wtVJGFmw+in8l7wH5fvQAiJqs9xReBrri4lMyVEx8PFfMzXA1jvklUlIhLUwBIg1
         6vEVXEuR2zJbKLGUtnZ5OMd9W5crNTByJIk4oDvTBYeF96isAg8aS+9N2D5RpMhMlEa/
         84OA==
X-Gm-Message-State: APjAAAU/k43JoVzS1Ey5XideiIShi5rk90jd6PSPLi8SOgyR/8XwszIF
        fq5fe5pnFKULoK2/dZiyz6IF8Md8EZc=
X-Google-Smtp-Source: APXvYqwfBfFNxEYPBk1P4r0u33EcwZqChtsYsDBcPVXmULzU6XIoKIK5xPGRQ8bZGAylr4brUje92g==
X-Received: by 2002:a63:4b50:: with SMTP id k16mr34152524pgl.386.1579103797712;
        Wed, 15 Jan 2020 07:56:37 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee8:ed72:75ba:e01f:bdbc:c547])
        by smtp.gmail.com with ESMTPSA id b8sm22755599pfr.64.2020.01.15.07.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 07:56:37 -0800 (PST)
From:   madhuparnabhowmik04@gmail.com
To:     wei.liu@kernel.org, paul@xen.org
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
Subject: [PATCH] net: xen-netback: hash.c: Use built-in RCU list checking
Date:   Wed, 15 Jan 2020 21:25:53 +0530
Message-Id: <20200115155553.13471-1-madhuparnabhowmik04@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>

list_for_each_entry_rcu has built-in RCU and lock checking.
Pass cond argument to list_for_each_entry_rcu.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
---
 drivers/net/xen-netback/hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/hash.c b/drivers/net/xen-netback/hash.c
index 10d580c3dea3..6b7532f7c936 100644
--- a/drivers/net/xen-netback/hash.c
+++ b/drivers/net/xen-netback/hash.c
@@ -51,7 +51,8 @@ static void xenvif_add_hash(struct xenvif *vif, const u8 *tag,
 
 	found = false;
 	oldest = NULL;
-	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
+	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
+				lockdep_is_held(&vif->hash.cache.lock)) {
 		/* Make sure we don't add duplicate entries */
 		if (entry->len == len &&
 		    memcmp(entry->tag, tag, len) == 0)
@@ -102,7 +103,8 @@ static void xenvif_flush_hash(struct xenvif *vif)
 
 	spin_lock_irqsave(&vif->hash.cache.lock, flags);
 
-	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
+	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
+				lockdep_is_held(&vif->hash.cache.lock)) {
 		list_del_rcu(&entry->link);
 		vif->hash.cache.count--;
 		kfree_rcu(entry, rcu);
-- 
2.17.1

