Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1BA3CF1C2
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 04:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbhGTBTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 21:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbhGTBCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 21:02:05 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C0FC061768;
        Mon, 19 Jul 2021 18:42:44 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 70so17708932pgh.2;
        Mon, 19 Jul 2021 18:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yAKEdbRASVTCVDA6Pth10I+WXA6yOgQj9SbrcWT0+UM=;
        b=Likab/Io5q4ZvilS3QZBUIT/B/8UycV1jwy1Lbc4ASOi74Rl6Z5257JBZedykNbCJw
         0ylMh4vjn7Wy1X+7gQ1p+5fYseFRPMd2xF/qOJxYh/hjCVNmyAkqVC21AkMGejgaQD1W
         XsTMqvnkzozbFa+kCTKVxzgyBNe2YipUmMMYHn/wVIFcDA8G9M88ntSH29lAX3mlyzfc
         LLwccptnHnviYU7bUtqEWLT428pMprvlmRUK9YLmumFUozzlCNoJQFkhxL6aKpKu7rIq
         G2bvMH8EpjvyCtINMO9kahu313D+yhBU4MTKyC5djZiqCx3pYmpmGtBPCFp2FBMSh69g
         4WQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yAKEdbRASVTCVDA6Pth10I+WXA6yOgQj9SbrcWT0+UM=;
        b=fW2ayNwCRO9Mt7Uhj7xWAXI+10LARb/H5QLiqMtnpn6i1lsjl7bpBCd7sP+GArt9Gq
         insLIzkETKNtsaPNgY9u4CVevjkUUe2jy1Ahrt6XU3Ius2KB/06aAvqRWXDqysz9//h/
         YylvUwllzwv6JsFb03HeVHB1uQR99hWJK1tkbKi3ndBc+wvo6nn4uwn6S6fM5E2RwGxS
         gbmGK5FjB/XdlKt5CLic6Eb4Hn4e62cJTK+0mZ28ThBHgClheXu/9++OA6TqJi80fPc1
         BdWFL/jiZhm++bm6vNTrC+b5ooFVnq1ZswplwvC7w3kSsPg5tZdgdj5FVU/+0U40GFOP
         M08g==
X-Gm-Message-State: AOAM532JUT7BVvvRi4WGZbIN3PiTi+yZ5pgsouyoQfVASL+FUdTtbKo2
        oB/yynZiulAKB/WHdpApFgc=
X-Google-Smtp-Source: ABdhPJzHsx7X6lE4mB6eQIOMwI5gzPcHNLUHR4Pu7Q+E1eEquYwz+JDSRAvTH68gs9n/MKD32LoNBw==
X-Received: by 2002:a05:6a00:1390:b029:32a:e2a2:74de with SMTP id t16-20020a056a001390b029032ae2a274demr28355456pfg.6.1626745364423;
        Mon, 19 Jul 2021 18:42:44 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id bf18sm17549943pjb.46.2021.07.19.18.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 18:42:44 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: yang.yang29@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Yang <yang.yang29@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH net-next] net: ipv4: add capability check for net administration
Date:   Mon, 19 Jul 2021 18:43:28 -0700
Message-Id: <20210720014328.378868-1-yang.yang29@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yang <yang.yang29@zte.com.cn>

Root in init user namespace can modify /proc/sys/net/ipv4/ip_forward
without CAP_NET_ADMIN, this doesn't follow the principle of
capabilities. For example, let's take a look at netdev_store(),
root can't modify netdev attribute without CAP_NET_ADMIN.
So let's keep the consistency of permission check logic.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
---
 net/ipv4/devinet.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 73721a4448bd..6238ab2dd3d1 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2424,11 +2424,15 @@ static int devinet_sysctl_forward(struct ctl_table *ctl, int write,
 	int *valp = ctl->data;
 	int val = *valp;
 	loff_t pos = *ppos;
-	int ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
+	struct net *net = ctl->extra2;
+	int ret;
 
-	if (write && *valp != val) {
-		struct net *net = ctl->extra2;
+	if (write && !ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 
+	if (write && *valp != val) {
 		if (valp != &IPV4_DEVCONF_DFLT(net, FORWARDING)) {
 			if (!rtnl_trylock()) {
 				/* Restore the original values before restarting */
-- 
2.25.1

