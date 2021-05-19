Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714B3388824
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 09:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbhESH2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 03:28:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3421 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239548AbhESH2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 03:28:34 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FlPWZ0sgQzCs92;
        Wed, 19 May 2021 15:24:26 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 15:27:12 +0800
Received: from code-website.localdomain (10.175.127.227) by
 dggpeml500012.china.huawei.com (7.185.36.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 15:27:12 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <paul@paul-moore.com>
CC:     <netdev@vger.kernel.org>, <zhangjinhao2@huawei.com>,
        <yuehaibing@huawei.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] netlabel: remove unused parameter in netlbl_netlink_auditinfo()
Date:   Wed, 19 May 2021 15:34:38 +0800
Message-ID: <20210519073438.3805430-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

loginuid/sessionid/secid have been read from 'current' instead of struct
netlink_skb_parms, the parameter 'skb' seems no longer needed.

Fixes: c53fa1ed92cd ("netlink: kill loginuid/sessionid/sid members from struct netlink_skb_parms")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 net/netlabel/netlabel_calipso.c   |  4 ++--
 net/netlabel/netlabel_cipso_v4.c  |  4 ++--
 net/netlabel/netlabel_mgmt.c      |  8 ++++----
 net/netlabel/netlabel_unlabeled.c | 10 +++++-----
 net/netlabel/netlabel_user.h      |  4 +---
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index f28c8947c730..91a19c3ea1a3 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -105,7 +105,7 @@ static int netlbl_calipso_add(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NLBL_CALIPSO_A_MTYPE])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	switch (nla_get_u32(info->attrs[NLBL_CALIPSO_A_MTYPE])) {
 	case CALIPSO_MAP_PASS:
 		ret_val = netlbl_calipso_add_pass(info, &audit_info);
@@ -287,7 +287,7 @@ static int netlbl_calipso_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_CALIPSO_A_DOI])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	cb_arg.doi = nla_get_u32(info->attrs[NLBL_CALIPSO_A_DOI]);
 	cb_arg.audit_info = &audit_info;
 	ret_val = netlbl_domhsh_walk(&skip_bkt, &skip_chain,
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 4f50a64315cf..baf235721c43 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -410,7 +410,7 @@ static int netlbl_cipsov4_add(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NLBL_CIPSOV4_A_MTYPE])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	switch (nla_get_u32(info->attrs[NLBL_CIPSOV4_A_MTYPE])) {
 	case CIPSO_V4_MAP_TRANS:
 		ret_val = netlbl_cipsov4_add_std(info, &audit_info);
@@ -709,7 +709,7 @@ static int netlbl_cipsov4_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_CIPSOV4_A_DOI])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	cb_arg.doi = nla_get_u32(info->attrs[NLBL_CIPSOV4_A_DOI]);
 	cb_arg.audit_info = &audit_info;
 	ret_val = netlbl_domhsh_walk(&skip_bkt, &skip_chain,
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index ca52f5085989..e664ab990941 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -434,7 +434,7 @@ static int netlbl_mgmt_add(struct sk_buff *skb, struct genl_info *info)
 	     (info->attrs[NLBL_MGMT_A_IPV6MASK] != NULL)))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_mgmt_add_common(info, &audit_info);
 }
@@ -457,7 +457,7 @@ static int netlbl_mgmt_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_MGMT_A_DOMAIN])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	domain = nla_data(info->attrs[NLBL_MGMT_A_DOMAIN]);
 	return netlbl_domhsh_remove(domain, AF_UNSPEC, &audit_info);
@@ -557,7 +557,7 @@ static int netlbl_mgmt_adddef(struct sk_buff *skb, struct genl_info *info)
 	     (info->attrs[NLBL_MGMT_A_IPV6MASK] != NULL)))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_mgmt_add_common(info, &audit_info);
 }
@@ -576,7 +576,7 @@ static int netlbl_mgmt_removedef(struct sk_buff *skb, struct genl_info *info)
 {
 	struct netlbl_audit audit_info;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_domhsh_remove_default(AF_UNSPEC, &audit_info);
 }
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 3e6ac9b790b1..2483df0bbd7c 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -814,7 +814,7 @@ static int netlbl_unlabel_accept(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NLBL_UNLABEL_A_ACPTFLG]) {
 		value = nla_get_u8(info->attrs[NLBL_UNLABEL_A_ACPTFLG]);
 		if (value == 1 || value == 0) {
-			netlbl_netlink_auditinfo(skb, &audit_info);
+			netlbl_netlink_auditinfo(&audit_info);
 			netlbl_unlabel_acceptflg_set(value, &audit_info);
 			return 0;
 		}
@@ -897,7 +897,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -947,7 +947,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -994,7 +994,7 @@ static int netlbl_unlabel_staticremove(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -1034,7 +1034,7 @@ static int netlbl_unlabel_staticremovedef(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index b9ba8112b3c5..6190cbf94bf0 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -28,11 +28,9 @@
 
 /**
  * netlbl_netlink_auditinfo - Fetch the audit information from a NETLINK msg
- * @skb: the packet
  * @audit_info: NetLabel audit information
  */
-static inline void netlbl_netlink_auditinfo(struct sk_buff *skb,
-					    struct netlbl_audit *audit_info)
+static inline void netlbl_netlink_auditinfo(struct netlbl_audit *audit_info)
 {
 	security_task_getsecid_subj(current, &audit_info->secid);
 	audit_info->loginuid = audit_get_loginuid(current);
-- 
2.17.1

