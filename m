Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0958A18B9B1
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCSOr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:47:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33651 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgCSOr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:47:59 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jEwSg-0005CN-C9; Thu, 19 Mar 2020 14:47:54 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH net-next] sysfs: fix static inline declaration of sysfs_groups_change_owner()
Date:   Thu, 19 Mar 2020 15:47:41 +0100
Message-Id: <20200319144741.3864191-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319142002.7382ed70@canb.auug.org.au>
References: <20200319142002.7382ed70@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CONFIG_SYSFS declaration of sysfs_group_change_owner() is different
from the !CONFIG_SYSFS version and thus causes build failurs when
!CONFIG_SYSFS is set.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 303a42769c4c ("sysfs: add sysfs_group{s}_change_owner()")
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 include/linux/sysfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 9e531ec76274..4beb51009b62 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -562,8 +562,8 @@ static inline int sysfs_groups_change_owner(struct kobject *kobj,
 }
 
 static inline int sysfs_group_change_owner(struct kobject *kobj,
-			 const struct attribute_group **groups,
-			 kuid_t kuid, kgid_t kgid)
+					   const struct attribute_group *groups,
+					   kuid_t kuid, kgid_t kgid)
 {
 	return 0;
 }

base-commit: 79e28519ac78dde6d38fe6ea22286af574f5c7db
-- 
2.25.2

