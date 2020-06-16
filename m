Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B711FA863
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 07:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgFPFtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 01:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgFPFtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 01:49:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EE0C05BD43
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 22:49:12 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l24so145615pgb.5
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 22:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=N0+ubyPtVAH0RQ3d0TxFBElTUT1oZXdzlK++vfNJWdM=;
        b=UdifinS8ooN+FO1lJ4fLQJ7luHOv8MRTUYxc/1terc1tDCk4qOKZGJ+xOhTmQ0vf6e
         HC4MwIBY1QTF9dzPyI8pC3Apg8Tv4StC0+NY1JzU3tsHtXGqmwoax0z4Auxkayn2UeUb
         3eMZIqyCAauA8wn2NVv3y2Me4//VkmHcSjtbzd/r/Pct5op9MRPBpQfMtFIIs3ZCtP2A
         y349dvHPG28FNPyzMP9DndIjnsyBnLcwF3a0MAgveKTtWvkv8tCA45MSFqjFtIzdPbVS
         lDofNoZk7iJpgP5kOA7/Cxi3ziHirndWGbB8fDkHqWklmmOHeSsroOvIlWkJxmzrBfYa
         Misg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N0+ubyPtVAH0RQ3d0TxFBElTUT1oZXdzlK++vfNJWdM=;
        b=QSLseElGOdXO8+V/Zrmji2EIHMCASq2/1SvoENebS1lptypfPpNN7Kj2KWdh+EVv38
         NPwYskQYd5uayqj7GboZED7AsHJicXF77G+eHvrsbrH0LzUZHCdX5G8q/RcyuQOESIGr
         sFT5xN97f/rkRvqVJhwVB1Vy/6ExUQtdSCVOytZBID5BPLccxunsWswHCC78gxoVKzIn
         OC7w3Dj6agb7QwFOgmmmziVS4t78qd28ro9WfXGLG74UvovtobvRypD/k84BSn2kcEaT
         LWzPn9wVuHnGY0qDB/oygguJ/P/+L2cOfT2tWwTjrkiQNcAuaErIR68mNtA3KRTXpolr
         rftg==
X-Gm-Message-State: AOAM531xXmO97Y6UD7U4SvXHIMq5BqIVIvc4u3v5KSe7Ktmn2puTDxFk
        rgHqXbtPAEOJ93g2m1lvpK6prbFg
X-Google-Smtp-Source: ABdhPJyCWs9GgNL6R6xqtmpDIdFwCzCw/+rHZAozMJ5n2vKPpA/9MFPJTw5vSgXb6vphHhBDivH1kQ==
X-Received: by 2002:a63:3546:: with SMTP id c67mr830211pga.379.1592286551738;
        Mon, 15 Jun 2020 22:49:11 -0700 (PDT)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([137.97.168.26])
        by smtp.gmail.com with ESMTPSA id i12sm16001362pfk.180.2020.06.15.22.49.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 22:49:11 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Martin <martin.varghese@nokia.com>
Subject: [PATCH net] bareudp: Fixed configuration to avoid having garbage values
Date:   Tue, 16 Jun 2020 11:18:58 +0530
Message-Id: <1592286538-6895-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

Code to initialize the conf structure while gathering the configuration
of the device was missing.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Martin <martin.varghese@nokia.com>
---
 drivers/net/bareudp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index efd1a1d..5d3c691 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -552,6 +552,8 @@ static int bareudp_validate(struct nlattr *tb[], struct nlattr *data[],
 static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 			struct netlink_ext_ack *extack)
 {
+	memset(conf, 0, sizeof(*conf));
+
 	if (!data[IFLA_BAREUDP_PORT]) {
 		NL_SET_ERR_MSG(extack, "port not specified");
 		return -EINVAL;
-- 
1.8.3.1

