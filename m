Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202CCEDB5
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbfD3A3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:29:17 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43281 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729214AbfD3A3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 20:29:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 736234113;
        Mon, 29 Apr 2019 20:29:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Apr 2019 20:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=2xZH67dVb6wgUB263feKLZ/OFq7jqKpOxkOzPVJS6gM=; b=VObclZG+
        JIqqX9GoACkcqVWTp951RK98sL8sRjfzTNQSMOf3W91Cq8K7ZZXRShgfskt0E8Mu
        rskBPDJzjDkI+lZ/qzbmflZDSDntNQsUfVgbuCPfSxK0fnv/f8xR/m3PEC1cUdpk
        8Eqa9Fk8+VUZpOSRGh8iGZp4U4cLCxwiDEumNarOyx01Ygu6jGj4q7s+Jk1FR9o1
        D4RDczHOQd01ZvSMmq+OKV4YnFyyBuTzr+YVx6OSIPuFtpzCwHA7FgqrCCgLDG8z
        XMyamE0tMNs92bWnkWkeoKV5Dzt5m3iJdmGRvkuDM4Qnn7IY7cLleFZ3X80+u0Bb
        CBfnUmBKy3lylQ==
X-ME-Sender: <xms:2pbHXIBdiGDT8AlENHcrXwsSybxzfEUvq1iHdQvJad0SfuS7l1548g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvfedtrddukeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:2pbHXMnr9PEdv_hqPiH2w3com0XzxDD8ElZxw_VV5pdg5JXIY9psKA>
    <xmx:2pbHXMGvDIcJJ8O9D1kGQUQW4nM6TtmQJeo4UidzDxkt8rQIsAMgMw>
    <xmx:2pbHXDjuaMS_5BWtFLPNT5C8eDpCEhYUQmRQbs-n6p7Qs2JPMheZIQ>
    <xmx:2pbHXMh9ugNRFhftBMtMPnZZyOUqZ3YR_KnWzHBZX5Are7h__NvuYA>
Received: from eros.localdomain (ppp121-44-230-188.bras2.syd2.internode.on.net [121.44.230.188])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5001103CA;
        Mon, 29 Apr 2019 20:29:09 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] bridge: Use correct cleanup function
Date:   Tue, 30 Apr 2019 10:28:16 +1000
Message-Id: <20190430002817.10785-3-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430002817.10785-1-tobin@kernel.org>
References: <20190430002817.10785-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The correct cleanup function if a call to kobject_init_and_add() has
returned _successfully_ is kobject_del().  kobject_put() is used if the
call to kobject_init_and_add() fails.  kobject_del() calls kobject_put().

Use correct cleanup function in error path.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 net/bridge/br_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index e5c8c9941c51..d3a1554ccff4 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -701,7 +701,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 err3:
 	sysfs_remove_link(br->ifobj, p->dev->name);
 err2:
-	kobject_put(&p->kobj);
+	kobject_del(&p->kobj);
 	p = NULL; /* kobject_put frees */
 err1:
 	dev_set_allmulti(dev, -1);
-- 
2.21.0

