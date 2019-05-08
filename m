Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8C217B5B
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfEHOMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 10:12:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51345 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727679AbfEHOMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 10:12:22 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190508141221euoutp028cea8ced28b0a2510e24712543729fb8~cupnW9IGe3075530755euoutp02q;
        Wed,  8 May 2019 14:12:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190508141221euoutp028cea8ced28b0a2510e24712543729fb8~cupnW9IGe3075530755euoutp02q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557324741;
        bh=T+lf+1k8YuKNiyfOassRgPNzGiL/wVazNKrJDOT69BY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=W0zFkUdemth3RtaYvuq3tc182zvprhIz57wpVSt5F6mqkgSlSpj7vqsNx8m3L1v2T
         4aUHoxLufsnRblNabTJ3om9Lsa+B+oZJl+MT/XTTDEYjwLaAQI0YRYGyiIdpvQwYTP
         EBjdnTvpAXraEhCXSu/bPpvC+m/LyXtrNGOkUEJA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190508141220eucas1p2df52aaf791210790c3f4cb55e881005f~cupm38-fd2225522255eucas1p2L;
        Wed,  8 May 2019 14:12:20 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 93.AD.04325.4C3E2DC5; Wed,  8
        May 2019 15:12:20 +0100 (BST)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190508141219eucas1p1e5a899714747b497499976113ea9681f~cupmPV-6e0143501435eucas1p11;
        Wed,  8 May 2019 14:12:19 +0000 (GMT)
X-AuditID: cbfec7f5-b75ff700000010e5-62-5cd2e3c47158
Received: from eusync4.samsung.com ( [203.254.199.214]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id FF.9A.04146.3C3E2DC5; Wed,  8
        May 2019 15:12:19 +0100 (BST)
Received: from amdc2143.DIGITAL.local ([106.120.51.59]) by
        eusync4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PR6003Y7VGD4K00@eusync4.samsung.com>;
        Wed, 08 May 2019 15:12:19 +0100 (BST)
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH v2] netfilter: xt_owner: Add supplementary groups option
Date:   Wed, 08 May 2019 16:12:11 +0200
Message-id: <20190508141211.4191-1-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWy7djPc7pHHl+KMXj6kN/i7852Zos551tY
        LLb1rma0+P9ax+Jy3zRmizOTFjJZXN41h83i2AIxiwnrTrFYTH9zldmBy+N000YWjy0rbzJ5
        7Jx1l93j7e8TTB59W1Yxehz6voDV4/MmuQD2KC6blNSczLLUIn27BK6M3ZufMRZ856u4vCym
        gfEDdxcjJ4eEgInEk10r2boYuTiEBFYwSvzbvhHK+cwoseLzCTaYqpNT9rJCJJYxSmz7+4wZ
        wvnPKLH32jRWkCo2AQOJ7xf2giVEBKYzSaxpeMUIkmAWCJU492g9M4gtLOAhcXt/CwuIzSKg
        KrFh0zmwGl4Ba4mfO2ezQqyTlzjfu44dIi4o8WPyPRaIOfISB688ZwFZICGwhk2i4/J3ZogG
        F4nHq5dD2TISnR0HmboYOYDsaomTZyog6jsYJTa+mM0IUWMt8XnSFmaIoXwSk7ZNZ4ao55Xo
        aBOCKPGQOHxjCxOILSQQK/HgziPGCYySs5CcNAvJSQsYmVYxiqeWFuempxYb56WW6xUn5haX
        5qXrJefnbmIERvfpf8e/7mDc9yfpEKMAB6MSD2/GoUsxQqyJZcWVuYcYJTiYlUR4r08ECvGm
        JFZWpRblxxeV5qQWH2KU5mBREuetZngQLSSQnliSmp2aWpBaBJNl4uCUamBs4dq0WufuGpHJ
        TE67dWZ2ybBO992myb/j57G9x7fv+7qroO7Cg6vz/NjLCgOM53PvcP42m833c4drwxStxES5
        Pyrr/vj1TjcSuMdzV4WtVNwq5HtvcFTSw+jNHCFM0vdc7G6XN//sn3588szyvbN21dz6rSDr
        +IO9hSu4guHwhU3+ypZWmXpKLMUZiYZazEXFiQBqMhL56gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xa7qHH1+KMeh9YWDxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAlfG7s3PGAu+81VcXhbT
        wPiBu4uRk0NCwETi5JS9rF2MXBxCAksYJT5/3MIM4TQySbx/t48ZpIpNwEDi+4W9YLaIwHQm
        iT+zhEFsZoFQiWszpoPFhQU8JG7vb2EBsVkEVCU2bDrHCGLzClhL/Nw5mxVim7zE+d517BBx
        QYkfk++xQMyRlzh45TnLBEaeWUhSs5CkFjAyrWIUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAgM
        zG3Hfm7ewXhpY/AhRgEORiUe3oxDl2KEWBPLiitzDzFKcDArifBenwgU4k1JrKxKLcqPLyrN
        SS0+xCjNwaIkztshcDBGSCA9sSQ1OzW1ILUIJsvEwSnVwGhustb7V5j9699Wkmvrniw9U5O1
        NNZFb7XJbuW/j9gfuEwJmXR0lRx/MFeUw/zKuFnyiclyFUcnSTwV+ChfWSDzvtqBSbbMU33V
        2h+dejvevD4g5BJTIrtgsyHnh01vk9b8nfXzXofdrjmnzvh6n/xzj4d52dvfq9d7sb88z7zw
        n/TjDXZbrfyUWIozEg21mIuKEwFBU6/jSAIAAA==
X-CMS-MailID: 20190508141219eucas1p1e5a899714747b497499976113ea9681f
CMS-TYPE: 201P
X-CMS-RootMailID: 20190508141219eucas1p1e5a899714747b497499976113ea9681f
References: <CGME20190508141219eucas1p1e5a899714747b497499976113ea9681f@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XT_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID to
be also checked in the supplementary groups of a process.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 include/uapi/linux/netfilter/xt_owner.h |  1 +
 net/netfilter/xt_owner.c                | 23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_owner.h b/include/uapi/linux/netfilter/xt_owner.h
index fa3ad84957d5..d646f0dc3466 100644
--- a/include/uapi/linux/netfilter/xt_owner.h
+++ b/include/uapi/linux/netfilter/xt_owner.h
@@ -8,6 +8,7 @@ enum {
 	XT_OWNER_UID    = 1 << 0,
 	XT_OWNER_GID    = 1 << 1,
 	XT_OWNER_SOCKET = 1 << 2,
+	XT_SUPPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 46686fb73784..283a1fb5cc52 100644
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
+		if (!match && (info->match & XT_SUPPL_GROUPS) && gi) {
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

