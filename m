Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7528E4A8D73
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354380AbiBCUbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354214AbiBCUaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:30:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D876C061768;
        Thu,  3 Feb 2022 12:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F98561A69;
        Thu,  3 Feb 2022 20:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9427FC36AE2;
        Thu,  3 Feb 2022 20:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920221;
        bh=sJ6+mzYe74c4klAocmWr1wXKcpylYLufUpLD0y2wM5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efVnIiaiPPtN3BHDdeiMg3JZ9yCvIx9ykBM8oIASgDqASuQfZ9GjYxeXEWlUtC9Af
         jQ21/IckphuH1fjEfs671W1DoVyRsXdwsBKsgvNDz05ZuD0gSrGC6pJnW5UYMMLtL8
         SxlPHZQ1MeqX80vEMJK8EEeCdhaNrfIO4xS1G0CngEImBv3LHLEdBVKnuDgmNNW0sj
         X2v4GfSva+UTpTx6qD+/X+vCqFlwzoRE0Rb7+BX4tD8yQA8pLm0kvaHO5TEcooR334
         cIp6ZLb/Am7sSin9C96fZwyihrvvjAsTAi/zeE8W97xrawMYeb9Q4h5O0xTJ56e8qP
         pBtaEP+r7OX+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Nogueira <victor@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 21/52] net: sched: Clarify error message when qdisc kind is unknown
Date:   Thu,  3 Feb 2022 15:29:15 -0500
Message-Id: <20220203202947.2304-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 910a36ed56343..e4a7ce5c79f4f 100644
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

