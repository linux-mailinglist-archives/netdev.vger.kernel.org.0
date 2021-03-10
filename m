Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEBA3333CD
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 04:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhCJDX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 22:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbhCJDXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 22:23:53 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50148C06174A;
        Tue,  9 Mar 2021 19:23:53 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id w34so9379806pga.8;
        Tue, 09 Mar 2021 19:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8hA7wtjwuNH7u9wE5uEObveYbpFZk4PFtn0QcrJql60=;
        b=N9Zebae1FzfVHaSElKX3p7qRNUCBolcLuHG6oIt7iNPhe8IzRI+hDjwQr0tCE99Sw7
         LXOy7JAPpA60WQdanDKaz8UDkCzQyImsojjx/IPOO3dXBCG1T71fIvZsloLnOkRytEAq
         YVfeG3ZT744WC7olcHYaQ/ROqZE5jb3r5X5on8pWYbLw4z+mZ0xL7aHq9SfIYklgQjTK
         y1JYh6s6TEnRWY8tTvVQ15nXbHGXoLwGVLXGSNQrp3/i4yOppLUKAdPSOTpSf46TsBL4
         VbfMRGmNEZtdz0k6SEgN0quSc19Ktv7Mxq9CD94jdxwMFi2T/zbEsl68xWPh/vEMX/7A
         IZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8hA7wtjwuNH7u9wE5uEObveYbpFZk4PFtn0QcrJql60=;
        b=p8TLotDAllgnQP94/8UJ1tNXWcSmbV0NREhtTGcZJHfYolvSzdDOq8BQVIzCLG8MEY
         3XWuRnVBeRDtH5X+n+UHCSnp8TEV9uKNS5a8SC0Nik9KnbpkgqIOLPMyUigMsmPedzWR
         FBm+YoIAQfw+e1MVE+YJoimP1TQMClZkik83QbuvsnpvvqGkOb94s+OAUSBgmIPjkPyV
         am9MXKxsGxsWxR5wwr10T3p8GE4DZ6lIMlMtgBEBmUk3HMs3NyPvtafz7e0T5JGqobLa
         6EhoYayXc5DsMA904HR9qur6Kq7CfGZkkJAZq7vjsY24bMGJgvvxz5dtrA7Gz4zSeJ2Z
         aS7Q==
X-Gm-Message-State: AOAM533SZILvW2FVZpH4dASEVasvJ/HT+E3U3xiBL9x4G6zV1WNvyb9J
        1ku1sKc9I5Pk1OT/Ty8z5cY=
X-Google-Smtp-Source: ABdhPJzRKnJby6GkJhDQWYHW/XdrRCpWIwNdP/Rv6DNdVrvRPEqjeV2Mi58JCL7B+YYqu92Qy2RCyg==
X-Received: by 2002:a62:38d7:0:b029:1fb:2382:57b0 with SMTP id f206-20020a6238d70000b02901fb238257b0mr1091836pfa.10.1615346632724;
        Tue, 09 Mar 2021 19:23:52 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id mu6sm4073456pjb.35.2021.03.09.19.23.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Mar 2021 19:23:52 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] net/rds: Drop duplicate sin and sin6 assignments
Date:   Wed, 10 Mar 2021 11:23:43 +0800
Message-Id: <20210310032343.101732-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to assign the msg->msg_name to sin or sin6,
because there is DECLARE_SOCKADDR statement.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/rds/recv.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index aba4afe4dfed..4db109fb6ec2 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -722,8 +722,6 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 		if (msg->msg_name) {
 			if (ipv6_addr_v4mapped(&inc->i_saddr)) {
-				sin = (struct sockaddr_in *)msg->msg_name;
-
 				sin->sin_family = AF_INET;
 				sin->sin_port = inc->i_hdr.h_sport;
 				sin->sin_addr.s_addr =
@@ -731,8 +729,6 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 				memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
 				msg->msg_namelen = sizeof(*sin);
 			} else {
-				sin6 = (struct sockaddr_in6 *)msg->msg_name;
-
 				sin6->sin6_family = AF_INET6;
 				sin6->sin6_port = inc->i_hdr.h_sport;
 				sin6->sin6_addr = inc->i_saddr;
-- 
2.29.0

