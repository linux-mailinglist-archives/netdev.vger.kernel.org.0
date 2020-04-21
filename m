Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D11B2C73
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgDUQSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 12:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725987AbgDUQSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 12:18:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FF6C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 09:18:46 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n16so6964254pgb.7
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 09:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=90m5gduL81UmpkEuVTZZS7Hmlotva3IFRX+Uvj/JP4k=;
        b=L/jDjiKcQNKx4vpZwpsI+339wQUmOLEmzRDsM3SWDnewGGbOtHPFeZnSc1+b8PdMCD
         YYoYopItTNUlHA6zN2ASkpG+6clAs+Mtt+R+ta8pQPnmATZ7OMSr4EDZTGUBoGwsE5nl
         Nos/V83gfgjFoLdsfLBtkqIc4tWQqqwk2DWDA+A232j4uOZK4HHGgJvhbYns6yt1WKBA
         Fvi6SzYUGgV/Q1Fpw9/OkBMxwBjpN9nb6ZcAyblIdLAm36uwrjDrliiAmQF/B863+j4m
         Hj5ke+gGbRKwZPyC+Gga1wHznMMAH/DKZOSYLBJCdKyjVfy8el5oAPKWrYL368Vv0ps2
         qw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=90m5gduL81UmpkEuVTZZS7Hmlotva3IFRX+Uvj/JP4k=;
        b=Io1ZBP6Ywcrnt4+SUF+iZoN5QMPcZHyUFGHPQVM7a5YZaIzd3f2oJsDbpnyEW7uGnq
         pULS1XF2Y7A8il63jFobgrZn8nrnsYk+bKHN8RvlKI/EjDOYtIjEb6QJ0FdIa8qNEliq
         IReI6prYIkXf6pox0RhgOwFImKUKSIrc37EuXONeQkD+KyNVhbEc5zBdz39HY/sz7TQU
         toRR2kcL/+5EOyjK1qBZ7WJHC8ky1OiZX4pGWdvtHraTtuEtdP2KFbrOfUsDu90e6nv1
         3pLSL5AuLRHGvPT5k+hkEg8iSO0lzecHwmaqNZeYO1MSoI3AcVbWH7JdW73zoy9hlPly
         cHZg==
X-Gm-Message-State: AGi0PuamdnahZLkfuIfZuEOM4bdc3Gg0c501B6mBrAt/NeVppO85kjig
        F7CgW6paSZefyDwyxwJvgsw=
X-Google-Smtp-Source: APiQypJLofDrT9BHR3l4PnR/lU1FGWUVcMq4hyRhl62A93gnFCIAGNf5xu308PXBDjFc0UJ7DrUWAA==
X-Received: by 2002:a65:6704:: with SMTP id u4mr22870576pgf.263.1587485926301;
        Tue, 21 Apr 2020 09:18:46 -0700 (PDT)
Received: from host ([154.223.71.61])
        by smtp.gmail.com with ESMTPSA id i8sm2583716pgr.82.2020.04.21.09.18.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Apr 2020 09:18:44 -0700 (PDT)
Date:   Wed, 22 Apr 2020 00:18:40 +0800
From:   Bo YU <tsu.yubo@gmail.com>
To:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, tsu.yubo@gmail.com
Subject: [PATCH -next] mptcp/pm_netlink.c : add check for nla_put_in6_addr
Message-ID: <20200421161830.uaiwr5il6kh5texr@host>
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
BWT, I am not sure nla_put_in_addr whether or not to do such that
---
 net/mptcp/pm_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 86d61ab34c7c..f340b00672e1 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -603,8 +603,9 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
 		nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
 				addr->addr.s_addr);
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

