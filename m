Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8B823A97A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgHCPfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgHCPfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:35:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5A9C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:35:13 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o5so2031573pgb.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ooDPWHI8SnAX3jgrhf4BmAyC17eA8Oj/wQo48kOxLSo=;
        b=V9pHvzbNGgqbgtrtbeuVLhCG+0yx2cEEa7YC+247+XufmJdjg6P7EKwWnui5yzQywz
         vbULA7d8sKNP21bpn8x3XBK9KhTguK8q4lt9/d3MGr8eUQahfULjhxwLNihHR12WC9u3
         ZRDqdDOKnKospNY9qqGm0cMIc3/op+ViKKlbIH6kMmRePqjIGMuVPRwtafpchCmMiMd2
         UpG1/SGSD8vnPQcDii0AIRq2iJ7FsnMiJ6Pm+gVi6EAIHV2r0JUMl2FicKizDuTbf9T9
         Ip4Pj76ybr2ekhpvXKWNsfYbQPqVgYtJUGZK6P44H22PFKBKGpoujyvUE07Z+6JYQmAw
         xXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ooDPWHI8SnAX3jgrhf4BmAyC17eA8Oj/wQo48kOxLSo=;
        b=esIOUnSVgUf2KoApcXuv/zm8kqVekmx2UWgVcXUWssUYJdHum+VnMJLGjapI8csILZ
         hiGM59CaAJMqvkg+ZD7EB2h3nQm3/LWWROLFr44l3WumI4cGitue011U0uJcss5WJvFr
         1FRt3C96UFwfOw8GzQe4hhBsmbou4yTx5Zc40PL+L6KyXdqCYP9yPS6vfglFG6mmjPCe
         xZb/huUuKUBuJZv1pxZZqdL5TbNQM/GQn3s3NX62vGn9Zr/YYTaBdc5ab+pg3T3rADqZ
         qqSCihSAqvZlTYJYw5lpPUCFLJDhiJIlU5yxXJNDRbqogoLfmViuGL0ERxzi9AKt/Owv
         5QPw==
X-Gm-Message-State: AOAM530wUbmen7DUc351Y5ZFwNF68e4OT4FVXarYd1CWnL2tZ2uuvwtD
        DJQM2goG3TutxC/PsDBKPLgtEteo/7s=
X-Google-Smtp-Source: ABdhPJyPVqc7an0cVQv705pT1EKMcksIwZOOg1TMM5OTUS3Wt1ys8cLD5zOkKQqGWJnt37miImjwfg==
X-Received: by 2002:a63:a05f:: with SMTP id u31mr15063576pgn.4.1596468912922;
        Mon, 03 Aug 2020 08:35:12 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y1sm590033pfr.207.2020.08.03.08.35.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 08:35:12 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 2/2] tipc: set ub->ifindex for local ipv6 address
Date:   Mon,  3 Aug 2020 23:34:47 +0800
Message-Id: <1806063a61881feadcbf4372f2683114c61b526a.1596468610.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
References: <cover.1596468610.git.lucien.xin@gmail.com>
 <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1596468610.git.lucien.xin@gmail.com>
References: <cover.1596468610.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without ub->ifindex set for ipv6 address in tipc_udp_enable(),
ipv6_sock_mc_join() may make the wrong dev join the multicast
address in enable_mcast(). This causes that tipc links would
never be created.

So fix it by getting the right netdev and setting ub->ifindex,
as it does for ipv4 address.

Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/udp_media.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 28a283f..9dec596 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -738,6 +738,13 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 		b->mtu = b->media->mtu;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (local.proto == htons(ETH_P_IPV6)) {
+		struct net_device *dev;
+
+		dev = ipv6_dev_find(net, &local.ipv6);
+		if (!dev) {
+			err = -ENODEV;
+			goto err;
+		}
 		udp_conf.family = AF_INET6;
 		udp_conf.use_udp6_tx_checksums = true;
 		udp_conf.use_udp6_rx_checksums = true;
@@ -745,6 +752,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 			udp_conf.local_ip6 = in6addr_any;
 		else
 			udp_conf.local_ip6 = local.ipv6;
+		ub->ifindex = dev->ifindex;
 		b->mtu = 1280;
 #endif
 	} else {
-- 
2.1.0

