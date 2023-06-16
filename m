Return-Path: <netdev+bounces-11383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BF8732D90
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB6221C20A21
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9952418B02;
	Fri, 16 Jun 2023 10:25:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1F379D3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5262FC433CC;
	Fri, 16 Jun 2023 10:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686911155;
	bh=4IAMA0vcyuQBJnllk7XYAnwiLEWwqj/NmIhIBEKPVX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6GQXZ0PVe9YZhK4YK+JDNBgr5vC8Hyp3GsWOfbJ8TRfxSp9Kb2eigSncIYibqUFj
	 QBG6JSMJIK91kxOB8BSxUbuCpGwb3AMMG/ASGNF5cI2MjrP9xNK/t16ZKGlYCWPnDI
	 DHnDzBT8mJLhgpDNshgTOiPAqZ7IrpSdSst8/E/pDAlZIIUIVT9WaT8J88oTon2uVS
	 z7wtnrCERHCh5Y9UktAbVXcz8O9RXF249MiueCHA7ftOF9ZRff6z7qxoN4fYrnd455
	 oK0KhCCJi6HxVKDL41w5icvgVZAA8Ld0CQ8ZofofBJnOqL7F/H193ULGpwI2tOe7nA
	 //usLO7Bzh3hA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Min-Hua Chen <minhuadotchen@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 17/30] net: sched: wrap tc_skip_wrapper with CONFIG_RETPOLINE
Date: Fri, 16 Jun 2023 06:25:05 -0400
Message-Id: <20230616102521.673087-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616102521.673087-1-sashal@kernel.org>
References: <20230616102521.673087-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.3.8
Content-Transfer-Encoding: 8bit

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit 8cde87b007dad2e461015ff70352af56ceb02c75 ]

This patch fixes the following sparse warning:

net/sched/sch_api.c:2305:1: sparse: warning: symbol 'tc_skip_wrapper' was not declared. Should it be static?

No functional change intended.

Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Acked-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 7045b67b5533e..96c063a787b22 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2300,7 +2300,9 @@ static struct pernet_operations psched_net_ops = {
 	.exit = psched_net_exit,
 };
 
+#if IS_ENABLED(CONFIG_RETPOLINE)
 DEFINE_STATIC_KEY_FALSE(tc_skip_wrapper);
+#endif
 
 static int __init pktsched_init(void)
 {
-- 
2.39.2


