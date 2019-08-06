Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1528B8329A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbfHFNUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:20:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56969 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfHFNUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:20:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3B7A32201F;
        Tue,  6 Aug 2019 09:20:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Aug 2019 09:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oumIawjw22yg3IErEQR79W9IYFK7MjMaFCMCrmx1ScA=; b=LWZk0I+H
        SMb7stoB+0dOwd83NQ070owGk0huAgWW7EjOu1JkOP0k6pyuO4hZayqbGoOB4iAa
        FqFNajYr2huSGV6ZU7PbBZmWR0x5vJA8FPdaCs42erZYG1894DfQyU9Omi2iJJO0
        Khz+bzHc/KEgYgBrmTzrMIyTy4ifMZ8cyrLfvq5vIrSOYArhXWo8+qKDG3QUP9zP
        R8bFw+BujxV3cX1aeSQmwddY6mAypEAS6I8stzroBBazzi5A44pHKBEJuYvbB/wi
        vzVr6IFZKaYIamUWXtfVXXVCH0WVPk6DjyEEJcgXA9ZwCGSjQ62cx8JNiaE1U4fZ
        nG/fupuTNpXsVg==
X-ME-Sender: <xms:rH5JXTpzVXy0RUJX8WCHpjjY7Xkxe3VhOPZ3e6SalzhQBy3X_4k3Sg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddutddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:rH5JXRzOVfUQuheyLamWRTL2LKDZ6lPtEEhR2NOkg8ZgYzASAMuaKg>
    <xmx:rH5JXdOoyh94d6f5XCXvNGY6ZPh7tLoEPbUzl-7CMbwcvpZTyIivQw>
    <xmx:rH5JXRcQXfyJYJ8Q4WTkO3rqoC9glGM8EuDMp93w2ojw1MdezbjpXw>
    <xmx:rH5JXQmVk9ZedfAS6Tq9tVi6y72_em6oKOQpRwHq4a7PPZsDe4bdqw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 88FD68006D;
        Tue,  6 Aug 2019 09:20:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, toke@redhat.com,
        jiri@mellanox.com, dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/6] drop_monitor: Use correct error code
Date:   Tue,  6 Aug 2019 16:19:51 +0300
Message-Id: <20190806131956.26168-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190806131956.26168-1-idosch@idosch.org>
References: <20190806131956.26168-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The error code 'ENOTSUPP' is reserved for use with NFS. Use 'EOPNOTSUPP'
instead.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 4ea4347f5062..dcb4d2aeb2a8 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -298,7 +298,7 @@ static int set_all_monitor_traces(int state)
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static int net_dm_cmd_trace(struct sk_buff *skb,
@@ -311,7 +311,7 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 		return set_all_monitor_traces(TRACE_OFF);
 	}
 
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static int dropmon_net_event(struct notifier_block *ev_block,
-- 
2.21.0

