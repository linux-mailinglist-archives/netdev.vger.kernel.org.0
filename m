Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D2A19CDF
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 13:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfEJLqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 07:46:31 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57232 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfEJLqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 07:46:31 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190510114628euoutp01b49eab63e9f71968c4b7e8119aba6dfa~dT80at1JQ1858118581euoutp01i;
        Fri, 10 May 2019 11:46:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190510114628euoutp01b49eab63e9f71968c4b7e8119aba6dfa~dT80at1JQ1858118581euoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557488788;
        bh=sAYgRsBUjpJp0qTA3ifq8squgPrBoWwQtxswIlARtRM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=FRBEPPErTlLsbK4UQ1aMkP83pf0G5vtZrv9mTttFmXaaMroTJKrHvvAzdoTY5sxKe
         CkTG5Y9iGW77P3OOkpDm7LHuMaBRby49hAozsEOX467cj6Vdm1bfCmPbuwotw9EMcR
         3tnKmLJAEBorSAcMoyGFMpMUp07Mb+ktSJhttCuY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190510114628eucas1p23184b6e27317f65fa9398e4402585694~dT8z-YXaK1072710727eucas1p2u;
        Fri, 10 May 2019 11:46:28 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 76.FB.04298.39465DC5; Fri, 10
        May 2019 12:46:27 +0100 (BST)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190510114627eucas1p25476833d2d375b113353741c18aecd92~dT8zVFDaW1928319283eucas1p27;
        Fri, 10 May 2019 11:46:27 +0000 (GMT)
X-AuditID: cbfec7f2-f2dff700000010ca-71-5cd56493a8f5
Received: from eusync3.samsung.com ( [203.254.199.213]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 3C.4F.04146.39465DC5; Fri, 10
        May 2019 12:46:27 +0100 (BST)
Received: from amdc2143.DIGITAL.local ([106.120.51.59]) by
        eusync3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PRA004DQE1CEA60@eusync3.samsung.com>;
        Fri, 10 May 2019 12:46:27 +0100 (BST)
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH v3] netfilter: xt_owner: Add supplementary groups option
Date:   Fri, 10 May 2019 13:46:22 +0200
Message-id: <20190510114622.831-1-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWy7djPc7qTU67GGBzaqW3xd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAlfG24lrmAv2CVV09G5l
        a2A8ytfFyMEhIWAi8WiLTBcjF4eQwApGibcn7jJ1MXICOZ8ZJe5894WpuXi9AqJmGaPEsqkP
        WCGc/4wS7QdfsoI0sAkYSHy/sJcZJCEiMJ1JYk3DK0aQBLNAqMS5R+uZQWxhAQ+JKxNfs4JM
        ZRFQlTi5hAskzCtgJTHl5zuwEgkBeYnzvevYIeKCEj8m32OBGCMvcfDKcxaImjVsEk8+hUEc
        5yLRfJoHIiwj0dlxkAkiXC1x8gzYzRICHYwSG1/MZoSosZb4PGkLM8RIPolJ26YzQ9TzSnS0
        CUGUeEhMmHqaHSQsJBArsfdCwQRGyVlI7pmF5J4FjEyrGMVTS4tz01OLDfNSy/WKE3OLS/PS
        9ZLzczcxAiP69L/jn3Ywfr2UdIhRgINRiYfXgv9KjBBrYllxZe4hRgkOZiUR3iIdoBBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXHeaoYH0UIC6YklqdmpqQWpRTBZJg5OqQbGaXca986o/v3k7YEn
        p7p5dthqaDz/JXBA4MbXQz837l9QqNW+XXi752+Fnyusf73/Vy/NcP7yCzZX2fUKujE/mPP7
        LopJXN3/qoHroFrUhO//dy2wsbzC0yx7n3Ox82c+voJVJ/5JNjBM88kJmxpx8cXJi9vXeyvG
        vNx56FDalGieZY5Lz0SaX1RiKc5INNRiLipOBABtnahb5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xq7qTU67GGKw8J2Dxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAlfG24lrmAv2CVV09G5l
        a2A8ytfFyMEhIWAicfF6RRcjF4eQwBJGiW1HZjBBOI1MEtdOXWLtYuTkYBMwkPh+YS8ziC0i
        MJ1J4s8sYRCbWSBU4tqM6WBxYQEPiSsTX7OCDGURUJU4uYQLJMwrYCUx5ec7sBIJAXmJ873r
        2CHighI/Jt9jgRgjL3HwynOWCYw8s5CkZiFJLWBkWsUoklpanJueW2yoV5yYW1yal66XnJ+7
        iREYltuO/dy8g/HSxuBDjAIcjEo8vBMEr8QIsSaWFVfmHmKU4GBWEuEt0gEK8aYkVlalFuXH
        F5XmpBYfYpTmYFES5+0QOBgjJJCeWJKanZpakFoEk2Xi4JRqYOwxvusnJfStsbY4kt2B2zDf
        VWY2154pv8wvaWSteWS+78yr9Cn8tXP3tBozBpfaNtVHha0XecRVtVabKdhw3lFryU5e7XQX
        /eQpbpufCYT+nr7hm6XfsVdLGyrDZzpJWlX4R6wV4ujXm8woVsOSn/I2ftUOXu2wo48f8Ols
        2LDG4HzfZIZsJZbijERDLeai4kQAsBtk9UcCAAA=
X-CMS-MailID: 20190510114627eucas1p25476833d2d375b113353741c18aecd92
CMS-TYPE: 201P
X-CMS-RootMailID: 20190510114627eucas1p25476833d2d375b113353741c18aecd92
References: <CGME20190510114627eucas1p25476833d2d375b113353741c18aecd92@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XT_OWNER_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID
to be also checked in the supplementary groups of a process.

f_cred->group_info cannot be modified during its lifetime and f_cred
holds a reference to it so it's safe to use.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---

Changes from v2:
 - XT_SUPPL_GROUPS -> XT_OWNER_SUPPL_GROUPS
 - clarified group_info usage in the commit log
    
Changes from v1:
 - complementary -> supplementary

 include/uapi/linux/netfilter/xt_owner.h |  7 ++++---
 net/netfilter/xt_owner.c                | 23 ++++++++++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_owner.h b/include/uapi/linux/netfilter/xt_owner.h
index fa3ad84957d5..9e98c09eda32 100644
--- a/include/uapi/linux/netfilter/xt_owner.h
+++ b/include/uapi/linux/netfilter/xt_owner.h
@@ -5,9 +5,10 @@
 #include <linux/types.h>
 
 enum {
-	XT_OWNER_UID    = 1 << 0,
-	XT_OWNER_GID    = 1 << 1,
-	XT_OWNER_SOCKET = 1 << 2,
+	XT_OWNER_UID          = 1 << 0,
+	XT_OWNER_GID          = 1 << 1,
+	XT_OWNER_SOCKET       = 1 << 2,
+	XT_OWNER_SUPPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 46686fb73784..a8784502aca6 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	if (info->match & XT_OWNER_GID) {
+		unsigned int i, match = false;
 		kgid_t gid_min = make_kgid(net->user_ns, info->gid_min);
 		kgid_t gid_max = make_kgid(net->user_ns, info->gid_max);
-		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
-		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
-		    !(info->invert & XT_OWNER_GID))
+		struct group_info *gi = filp->f_cred->group_info;
+
+		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
+		    gid_lte(filp->f_cred->fsgid, gid_max))
+			match = true;
+
+		if (!match && (info->match & XT_OWNER_SUPPL_GROUPS) && gi) {
+			for (i = 0; i < gi->ngroups; ++i) {
+				kgid_t group = gi->gid[i];
+
+				if (gid_gte(group, gid_min) &&
+				    gid_lte(group, gid_max)) {
+					match = true;
+					break;
+				}
+			}
+		}
+
+		if (match ^ !(info->invert & XT_OWNER_GID))
 			return false;
 	}
 
-- 
2.20.1

