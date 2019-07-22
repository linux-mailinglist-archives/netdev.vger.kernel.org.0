Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1F0708B5
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfGVSdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:50 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:43903 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730000AbfGVSdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 968742644;
        Mon, 22 Jul 2019 14:33:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=D4UadlB+NqXyNIGr9Kv89/FkJnAQgLuVjqmpbezrTvM=; b=Er2DRZPq
        UZxwTrneUajhMqP2INaGlNZ2vTCu0uSf32cBdFKy8D1J+qAHxVquXDopL10wFBek
        VYdqwjqnJVzJzmRd081TuKPhhLetTbRcxZsVGiL26cdHqmDYuFu5+w+Qw7FvUkAb
        Eq6zSeV6fXB6GGzE7XHDrzc5gxkE2dUFGhsHvyRtG4XZpE8e2DEBzdOcCpfVpLc8
        FsHMLO//Por/TdnUJxPqzmDi4RHMvCwcuZlyFN20+SEJIA4eBUx6UE+joqkx1AjF
        P36EhW3EbLQLur1rdlhDdmHpQ/SEG1/5EmISInzOUtWcyku4trw4JqXfaF6HbBYt
        Vq1dN6rL2Rs+xQ==
X-ME-Sender: <xms:jAE2XU5x7pgf8Epnex3apHr-fDMXmBFItY_JHDujnmdJIYbi1s9c9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeel
X-ME-Proxy: <xmx:jAE2XSzkYBi57svP-qqQWTMBRG5wqvhTxhPGKKBkChv8ohr42_mBTQ>
    <xmx:jAE2XSPYOZTj8xMr5ZDF_kyZSuMJa6uo-vjdPUgX9K4z1W6v_JPlhQ>
    <xmx:jAE2XdZ3R-4za5_lrdgvhf8P0YWhjRxSlc4U7WfRhs6HqdEComjgWA>
    <xmx:jAE2XUWZRXUnEON-mjVXwwb4Ix4CeJjwbEkXfPzgoRAvR3AO-uEO2w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CD8C8005B;
        Mon, 22 Jul 2019 14:33:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 12/12] drop_monitor: Add a command to query current configuration
Date:   Mon, 22 Jul 2019 21:31:34 +0300
Message-Id: <20190722183134.14516-13-idosch@idosch.org>
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

Users should be able to query the current configuration of drop monitor
before they start using it. Add a command to query the existing
configuration which currently consists of alert mode and packet
truncation length.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |  2 ++
 net/core/drop_monitor.c          | 48 ++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index eb36b61485ef..cdcd23a8b72b 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -54,6 +54,8 @@ enum {
 	NET_DM_CMD_START,
 	NET_DM_CMD_STOP,
 	NET_DM_CMD_PACKET_ALERT,
+	NET_DM_CMD_CONFIG_GET,
+	NET_DM_CMD_CONFIG_NEW,
 	_NET_DM_CMD_MAX,
 };
 
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 5af1e1e8d4d0..c753cd6c39ec 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -656,6 +656,50 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &net_drop_monitor_family, 0, NET_DM_CMD_CONFIG_NEW);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(msg, NET_DM_ATTR_ALERT_MODE, net_dm_alert_mode))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NET_DM_ATTR_TRUNC_LEN, net_dm_trunc_len))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int net_dm_cmd_config_get(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	int rc;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	rc = net_dm_config_fill(msg, info);
+	if (rc)
+		goto err_config_fill;
+
+	return genlmsg_reply(msg, info);
+
+err_config_fill:
+	nlmsg_free(msg);
+	return rc;
+}
+
 static int dropmon_net_event(struct notifier_block *ev_block,
 			     unsigned long event, void *ptr)
 {
@@ -718,6 +762,10 @@ static const struct genl_ops dropmon_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = net_dm_cmd_trace,
 	},
+	{
+		.cmd = NET_DM_CMD_CONFIG_GET,
+		.doit = net_dm_cmd_config_get,
+	},
 };
 
 static struct genl_family net_drop_monitor_family __ro_after_init = {
-- 
2.21.0

