Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D321B524C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDWCKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgDWCKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:10:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2471C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:10:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id hi11so1756708pjb.3
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=TqG0F1HlKv8ufJ0NHHqwMQ/0mnS4MGBjZrUPxYMzxJw=;
        b=EW6lRhHmAJmdnM7lv0tTtiN+KhgYCGm19XFMLBd2zMy/i3dYE9iH2VKp4E0MGlMzMK
         7mmRBFCoJq5OxmJa2uTEJwGGSXTykX93xz+HAzqkzE2CnWdkPFK9QC5+Qy6QqPwA0Dff
         QzbVEB/ozW600DX2RDijBrgm7YyzzJNjO++pMrVnUqsn8V5mv/VK/R1ynXE28C17L2Ps
         O4JuNq1G7lwverf7kcrEq9xRVO9tVk5kQAPkabrMd2kpQBr+UGkv0h+AIp21PxjPjB3Y
         2Vt12YbvkNh1qLkCS/GH4PyNTAvOMcQrBeD7GkiuvfF4qkomUMNZ9bfWpPtUR8Nd3fvO
         YYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=TqG0F1HlKv8ufJ0NHHqwMQ/0mnS4MGBjZrUPxYMzxJw=;
        b=Qrw9mmSnK99avNMBlpnevGSdyExNkxioitDcd/lnOCBOMXN13VW4RqH/mmLufZy3dn
         8MIuBtSyuyK0gLP7NSLfd8YSb6N1Flf++4v7AckP02jyegg6SY58qVcsySEK5LuYVFCv
         +uOMMucWzxkJwOaXuXErNmIZVbhf5hjmhTa7UBH14dQ4h0xxra4MHfWl3NYfMUVNIupU
         fbQS0LF0Ldj2Ok78h8wxAk3lI4wJph/nATPYr1RPtxN3T+IQabSKR6ICmCHZEH2C91iQ
         srxcln8Z8OCs9IDh/wPqJUk00dmZDCGsTcFp7ES0o+TgYY0ZtzivOSsgU6DXGhLFZnnm
         TOdw==
X-Gm-Message-State: AGi0PubvGF7y3yjKp3XRAXPn0IONLt56yyW7V4dALD4OFLDDlPgpElhL
        iXtT4PDyuMJCCS44aeBNnk8=
X-Google-Smtp-Source: APiQypKN5FU1a0EMkWTkihNvcj3hMFxqTN3Jb1QVVKTKXlUGGMhOT+ZNag/ix7zU47OITaRXHAY/rA==
X-Received: by 2002:a17:902:5983:: with SMTP id p3mr1698616pli.122.1587607811252;
        Wed, 22 Apr 2020 19:10:11 -0700 (PDT)
Received: from debian.debian-2 ([154.223.71.61])
        by smtp.gmail.com with ESMTPSA id f10sm553192pju.34.2020.04.22.19.10.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 19:10:10 -0700 (PDT)
Date:   Thu, 23 Apr 2020 10:10:03 +0800
From:   Bo YU <tsu.yubo@gmail.com>
To:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, tsu.yubo@gmail.com
Subject: [PATCH V3 -next] mptcp/pm_netlink.c : add check for nla_put_in/6_addr
Message-ID: <20200423020957.g5ovpymbbp4nykbr@debian.debian-2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
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
V3: fix code style, thanks for Paolo

V2: Add check for nla_put_in_addr suggested by Paolo Abeni
---
 net/mptcp/pm_netlink.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 86d61ab34c7c..b78edf237ba0 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -599,12 +599,14 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
 	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->ifindex))
 		goto nla_put_failure;

-	if (addr->family == AF_INET)
-		nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
-				addr->addr.s_addr);
+	if (addr->family == AF_INET &&
+	    nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
+			    addr->addr.s_addr))
+		goto nla_put_failure;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	else if (addr->family == AF_INET6)
-		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6);
+	else if (addr->family == AF_INET6 &&
+		 nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6))
+		goto nla_put_failure;
 #endif
 	nla_nest_end(skb, attr);
 	return 0;
--
2.11.0

