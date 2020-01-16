Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BD613E5E0
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390891AbgAPRN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390878AbgAPRN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123B2246AB;
        Thu, 16 Jan 2020 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194837;
        bh=vTDTnAAIKiPYPr131pc6+8mipPplmDbzj3BDzTdJs80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDwdbpqbd1uTN9kMawAYgvAit1YRgHlDy7F6agfVGjmiejOrwXOiqM6bzMUcvww5k
         f6jPwuV4/eXrrUZWwI0w0IC5H+Y1PaYkjzqHZUOZM8Nj4Nwat1Ba76fr/9xRie3/Jz
         YzG7gMvGF3c5ghN5IpUd/TbgpoDy+E37XfqVVYuk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 637/671] net: neigh: use long type to store jiffies delta
Date:   Thu, 16 Jan 2020 12:04:35 -0500
Message-Id: <20200116170509.12787-374-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9d027e3a83f39b819e908e4e09084277a2e45e95 ]

A difference of two unsigned long needs long storage.

Fixes: c7fb64db001f ("[NETLINK]: Neighbour table configuration and statistics via rtnetlink")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index e260d44ebdca..bf738ec68cb5 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1885,8 +1885,8 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
 		goto nla_put_failure;
 	{
 		unsigned long now = jiffies;
-		unsigned int flush_delta = now - tbl->last_flush;
-		unsigned int rand_delta = now - tbl->last_rand;
+		long flush_delta = now - tbl->last_flush;
+		long rand_delta = now - tbl->last_rand;
 		struct neigh_hash_table *nht;
 		struct ndt_config ndc = {
 			.ndtc_key_len		= tbl->key_len,
-- 
2.20.1

