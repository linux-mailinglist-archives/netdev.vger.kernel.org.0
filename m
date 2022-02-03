Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FAC4A8E14
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355062AbiBCUep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:34:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39466 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354858AbiBCUdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:33:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD35B61ADD;
        Thu,  3 Feb 2022 20:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF77C36AE5;
        Thu,  3 Feb 2022 20:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920400;
        bh=ZYVIosN5+p9kKGUfTU4t6+9MlmvVBEB3WUba1mWHBCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AT/My6duWz8wMrbglQFxb/dWRpGaTPx+0WPavyTJRDT8xGRSYEJJzZKUA7qP4fsVR
         OBxKsIv4uM0U/3pSKDyxP0soaAW1Ypgi5WtUv1k7vEis2TFO+98BqxvjJImst4CQaV
         uDwLehZS4VJPr1JKQ0nabj2TckOt6GYSEZa2W5FLaqXcrnn8u90BUpcrAeEujPpVTi
         rZxYbGcsKgOf1DS3AqOacEYuCuNj19GDPqjdgCBcDba+RT0O8HlAu86sQYitq+BLLh
         eXEFe0YnMTCEM4WImqT4gNQa4jrHOgdpWUNBrcQJfX0stLWqnPF7V+2XVU/zU89zjt
         ZzG5JfSCXzS/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Nogueira <victor@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/41] net: sched: Clarify error message when qdisc kind is unknown
Date:   Thu,  3 Feb 2022 15:32:25 -0500
Message-Id: <20220203203245.3007-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 973bf8fdd12f0e70ea351c018e68edd377a836d1 ]

When adding a tc rule with a qdisc kind that is not supported or not
compiled into the kernel, the kernel emits the following error: "Error:
Specified qdisc not found.". Found via tdc testing when ETS qdisc was not
compiled in and it was not obvious right away what the message meant
without looking at the kernel code.

Change the error message to be more explicit and say the qdisc kind is
unknown.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 4bbfd26223274..8e629c356e693 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1204,7 +1204,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 
 	err = -ENOENT;
 	if (!ops) {
-		NL_SET_ERR_MSG(extack, "Specified qdisc not found");
+		NL_SET_ERR_MSG(extack, "Specified qdisc kind is unknown");
 		goto err_out;
 	}
 
-- 
2.34.1

