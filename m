Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520E9708AD
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbfGVSde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:34 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42215 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727748AbfGVSdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A2F972472;
        Mon, 22 Jul 2019 14:33:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wvHm8oTkiWUUw/F//eLkpDMPO/t78gnH6iXOHX09QM8=; b=wZSVIgeq
        xvzYo5AFsvyrBaJNgp4c0fVA+QECX77gYSLtBIbb9cemnZWpbC6tikyBUfTGWWfx
        qumwBH6ncdsTAvj7FD/aLYuWJnH9YnSuRoaCN0+htW7Diskzxx5vOVRXrDydE6oX
        BmDG3VGffuZw2d5Ir4dDGVge0ZKS43d7qp3/Bt5BE69l3XgoooprpsJSrJGch6f+
        53oBGt4h7j+/j47ahbou2epQ1qZuEJp/6q1R75JZp/hz0zpccV8XfFg8PElDs77w
        szhWzQ0CfXxWJPz50se7Ql8woph7bIEj7fEs5GvNvhymAqiQsQS8Wza8VDWFWnnn
        kfT2t3mliJ89Dg==
X-ME-Sender: <xms:ewE2XTYOXCNoUoCN14bO4NsoWZbd7qA5cbeqpH2EpzkLvNIowCaU7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:ewE2XejbnLt79x45rYhM6mt7EiW5v4tLmh382cH0JQ5WjgoSHbifjw>
    <xmx:ewE2XfMtkXabHAPDVjZuPj1wXqaSt-sNCeahROVlr8zVcwcEx8oyNw>
    <xmx:ewE2XYtHAFW5wpm2BbNkWYTSHUIArsg2ZpAbM-2porA1fFwMgXO4eQ>
    <xmx:ewE2XXhnUbqgEKIuZZvG65P-j1NLM0HXd94AiYlut_h3r_Rt0qVMIw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 376D08005B;
        Mon, 22 Jul 2019 14:33:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 05/12] drop_monitor: Add extack support
Date:   Mon, 22 Jul 2019 21:31:27 +0300
Message-Id: <20190722183134.14516-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
References: <20190722183134.14516-1-idosch@idosch.org>
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

