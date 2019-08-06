Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8718329E
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732474AbfHFNUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:20:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36459 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731571AbfHFNUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:20:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BB9272203C;
        Tue,  6 Aug 2019 09:20:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Aug 2019 09:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wvHm8oTkiWUUw/F//eLkpDMPO/t78gnH6iXOHX09QM8=; b=EDgumy2C
        Gla1YqzoY9MJ3/8tGDMstNjo53YonsmT70MtFNNR1DqTunDuIDr7XEF5BAx+V4sr
        xMVGbjBxMx7rUOXk1cdXTvHk9DObDunvJhv1ylC8aJe5yZ3PVvpvvdBlC0UwHvJ0
        Dp21bDlSpRuHkMTAKFV2RU3V+Jwk/02UJgvqCRmxuxPkh1RNdtyy9Vpa4R8br6F5
        qV0JPMfxNfkg6nzoMHn/RXtd23LULJT7QkfAPmD0TAxhVUg50xghngF2nwW7r/6L
        xTsbX9QTTk0Gp8RAi0koiw8stZEnGPqVTC7KYQGtDK1AoBckLnPdN1ik/FCFvHCZ
        sLZPpy37aI1mAw==
X-ME-Sender: <xms:sn5JXe0vxeShHrunqPDZ4Q2DYZRFtrlhz3pEXRTqmGgBdm7LxunXBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddutddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:sn5JXdJolUfcynvu9gpZpDU7qpXdZaboJm7LFI9w9pZ2bue-l71InA>
    <xmx:sn5JXQRU_6FexvTLpQFZ01t2exK6JI_9LVMnNX50GRbGvWWF98YKuw>
    <xmx:sn5JXYA0eg6VXBRbpC6CC02mGTZlx6GCpg-CYrfmjV-oSwfuoOTS4g>
    <xmx:sn5JXX4LRMYoHSV76yFaB6QnI0GzHfTuvSRRPoIaqlw1GbZuF-kf7w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0629B8005C;
        Tue,  6 Aug 2019 09:20:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, toke@redhat.com,
        jiri@mellanox.com, dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/6] drop_monitor: Add extack support
Date:   Tue,  6 Aug 2019 16:19:55 +0300
Message-Id: <20190806131956.26168-6-idosch@idosch.org>
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

Add various extack messages to make drop_monitor more user friendly.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 9080e62245b9..1d463c0d4bc5 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -241,7 +241,7 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 	rcu_read_unlock();
 }
 
-static int set_all_monitor_traces(int state)
+static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 {
 	int rc = 0;
 	struct dm_hw_stat_delta *new_stat = NULL;
@@ -250,6 +250,7 @@ static int set_all_monitor_traces(int state)
 	mutex_lock(&net_dm_mutex);
 
 	if (state == trace_state) {
+		NL_SET_ERR_MSG_MOD(extack, "Trace state already set to requested state");
 		rc = -EAGAIN;
 		goto out_unlock;
 	}
@@ -257,6 +258,7 @@ static int set_all_monitor_traces(int state)
 	switch (state) {
 	case TRACE_ON:
 		if (!try_module_get(THIS_MODULE)) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
 			rc = -ENODEV;
 			break;
 		}
@@ -303,6 +305,8 @@ static int set_all_monitor_traces(int state)
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
+	NL_SET_ERR_MSG_MOD(info->extack, "Command not supported");
+
 	return -EOPNOTSUPP;
 }
 
@@ -311,9 +315,9 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 {
 	switch (info->genlhdr->cmd) {
 	case NET_DM_CMD_START:
-		return set_all_monitor_traces(TRACE_ON);
+		return set_all_monitor_traces(TRACE_ON, info->extack);
 	case NET_DM_CMD_STOP:
-		return set_all_monitor_traces(TRACE_OFF);
+		return set_all_monitor_traces(TRACE_OFF, info->extack);
 	}
 
 	return -EOPNOTSUPP;
-- 
2.21.0

