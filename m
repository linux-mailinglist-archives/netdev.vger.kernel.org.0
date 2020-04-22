Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEB91B348F
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 03:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDVBep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 21:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726024AbgDVBep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 21:34:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CE9C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 18:34:45 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j7so255338pgj.13
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 18:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=9xLw5ulRIs9jVr3M7YCo5wjYwMHRyT9jY/CKGEgBZ5E=;
        b=t7+oe7pD7m4cU6JMVD6yxMTlvPQQfGgFhYMgjSvPo8W2VABJTSvmJjrbx+4ZS5tfJU
         lFoo4zkSRdmZzD/uLC6H/x+gJxcZpkrXqF/iPYglxWacsq8gfsu4v4FTp7q2W4pDf/Vx
         3uDm/Jpn+svTEUjXBNc/UuV+TUYS4a6wESUmGiKBF5dGGxslpjDERhyb8JC7jIydZCym
         x9CLXgLEsTNfUpNdZRO7WNoGKe6SpluaurXVPULWgloj7CP5pcKXxOO7GM9yTO/OCZmk
         yLZ5xYw2x6fYZnqSvauOJpkuk6BAlBTNK2OaOMxGWA32gODX36LBJY8cOA1+brW/THOM
         mzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=9xLw5ulRIs9jVr3M7YCo5wjYwMHRyT9jY/CKGEgBZ5E=;
        b=rAX3i2xrVScJ3J/x9SYJXw+AP+df29pQCNFjJju0VF99D2dSIEHUJdIHYrdAl63aT/
         +l7GL7zgg2za77k1QDPyOAl+Gqg4zUC714HGdX5Bfi7A5vPR6tsj9aHgUdfuaq4XzBFq
         JPbu/zpxCow7aje9SCkjrltDEM4lmzgJH50VLbN/i4uW8Xlr9yOki8V0Er9qWPBDKSaB
         1U6FDLppOTPOz3g/8WES+gBqdyZJScTDbrisu1AKrMekM1XHtM9Vwfur7apZFLZHgRir
         /QnHs3swULngoMPzhcgtCEyt7nTSqDdQWTuwLNO9Zt3IgZy2mjvg2vMLYkOjhm4xQwtd
         q8JA==
X-Gm-Message-State: AGi0PubvdxELW6bQ5Msjj/gJqGa0NaDT9AJ2zwSYgJYQDfAgBzjq0EJ8
        Wx5P+4q3QLSUqLuvkbfeylg=
X-Google-Smtp-Source: APiQypKi9qABqsS2nppSbyq/vwS/BOW7iDTEN6OvQkK+pNNO9En9z/Neq9lFILVZzMRm/Pddw6Qg+w==
X-Received: by 2002:a63:e241:: with SMTP id y1mr23316825pgj.353.1587519284506;
        Tue, 21 Apr 2020 18:34:44 -0700 (PDT)
Received: from host ([154.223.71.61])
        by smtp.gmail.com with ESMTPSA id j23sm3644714pjz.13.2020.04.21.18.34.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Apr 2020 18:34:43 -0700 (PDT)
Date:   Wed, 22 Apr 2020 09:34:38 +0800
From:   Bo YU <tsu.yubo@gmail.com>
To:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, tsu.yubo@gmail.com
Subject: [PATCH V2 -next] mptcp/pm_netlink.c : add check for nla_put_in/6_addr
Message-ID: <20200422013433.qzlthtmx4c7mmlh3@host>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normal there should be checked for nla_put_in6_addr like other
usage in net.

Detected by CoverityScan, CID# 1461639

Fixes: 01cacb00b35c("mptcp: add netlink-based PM")
Signed-off-by: Bo YU <tsu.yubo@gmail.com>
---
V2: Add check for nla_put_in_addr suggested by Paolo Abeni
---
 net/mptcp/pm_netlink.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 86d61ab34c7c..0a39f0ebad76 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -599,12 +599,15 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
 	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->ifindex))
 		goto nla_put_failure;

-	if (addr->family == AF_INET)
+	if (addr->family == AF_INET &&
 		nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
-				addr->addr.s_addr);
+				addr->addr.s_addr))
+		goto nla_put_failure;
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	else if (addr->family == AF_INET6)
-		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6);
+	else if (addr->family == AF_INET6 &&
+		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6))
+		goto nla_put_failure;
 #endif
 	nla_nest_end(skb, attr);
 	return 0;
--
2.11.0

