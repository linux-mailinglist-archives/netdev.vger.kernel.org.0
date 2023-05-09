Return-Path: <netdev+bounces-1024-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F616FBD8B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95DC82811F9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C450D392;
	Tue,  9 May 2023 03:12:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C4D17F8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:12:27 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1C6A251
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:12:10 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ab14cb3aaeso37459595ad.2
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 20:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683601930; x=1686193930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xz8EbTp6cnKXRSu16PeJ7H/2zeR4wrxo2ZYzQZzLLts=;
        b=eiu8S3T2yblblJ8f5KE7BCO+Y1rDYimfXHozUtWim/2SIocjk3HiOtGQJH3B9TFNTl
         13RW6FZAKF+Z+yXf+ixyoTZDDD1w543GxyiFPxesPny8324xYIGVy7o3dGNhhJVQhSZK
         qnydAaxVdJem8/x7PzFTM1TPTf8dspcKu3AoXYQuiXiH23jW9PIPmgGaY7gYrDY3SILe
         SFfuiF8tVbRXfO9B6Mr1JVTu7JGCfGlO4oN7v8w4gUoH9pPO88/W7SO0D6QjhI6sqpMG
         VUUyUwcLeoSkRAjWELnVuXedXRBCXYb/dee+cXuSoMAPFKq88XoNweNOsqbH6VSCuvuK
         7kng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683601930; x=1686193930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xz8EbTp6cnKXRSu16PeJ7H/2zeR4wrxo2ZYzQZzLLts=;
        b=CrRHiHWXtLa5/H2I6cfG+KrwUA6QtMwyJZaIGucvQ2C1EonqbKLaQ0tO7cPZre0koR
         CdWlbMehojvfsw+fBuFAqV03tgL53L4n8ZaQn8wFg997b6oqPh0H7E3pAKUMP+qLtTKG
         OqVLyYyzWqPIDBPgW3wPhOmZEdSu1URbobwIesZs7+nMnOWiOqP28aDE20Dk93fHZwlq
         x6jl8s42lhRfdadrtkhk+MnZExRwboSWP+ySkwDPU5Qj/cMNljN4RKEt3ei0sda4XVvP
         aohQl3OJ8Xg2zLibxvQYF8atjEmJcraEldziEknGsYKyDc9Zz5L4bOezKCLkBw2VJLW0
         uwsA==
X-Gm-Message-State: AC+VfDwAzDOt+17m00yA0x997HqAXX1WxDCEnJS5DbpPnOX3qMKHDHdp
	okJByqEgq8LFHXDlrGjZKCseOS/38c0FoqUS
X-Google-Smtp-Source: ACHHUZ6+3oCJOeMvV+OoH3c+8ZLeirXGotMjj2Ojt4lHmKQN0XGvVoV1E0JqH7myZy3+xJjRzWzEug==
X-Received: by 2002:a17:902:ea0a:b0:1a9:3447:71ef with SMTP id s10-20020a170902ea0a00b001a9344771efmr16235322plg.54.1683601929781;
        Mon, 08 May 2023 20:12:09 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j2-20020a170902da8200b001ab19724f64sm250768plx.38.2023.05.08.20.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 20:12:09 -0700 (PDT)
From: Hangbin Liu <liuhangbin@gmail.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <j.vosburgh@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Liang Li <liali@redhat.com>,
	Vincent Bernat <vincent@bernat.ch>,
	Simon Horman <simon.horman@corigine.com>,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 1/4] bonding: fix send_peer_notif overflow
Date: Tue,  9 May 2023 11:11:57 +0800
Message-Id: <20230509031200.2152236-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230509031200.2152236-1-liuhangbin@gmail.com>
References: <20230509031200.2152236-1-liuhangbin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Bonding send_peer_notif was defined as u8. Since commit 07a4ddec3ce9
("bonding: add an option to specify a delay between peer notifications").
the bond->send_peer_notif will be num_peer_notif multiplied by
peer_notif_delay, which is u8 * u32. This would cause the send_peer_notif
overflow easily. e.g.

  ip link add bond0 type bond mode 1 miimon 100 num_grat_arp 30 peer_notify_delay 1000

To fix the overflow, let's set the send_peer_notif to u32 and limit
peer_notif_delay to 300s.

Reported-by: Liang Li <liali@redhat.com>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2090053
Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: use NLA_POLICY_FULL_RANGE to limit the max value. The NLA_POLICY_MAX
    only support s16 max limit.
v2: define send_peer_notif as u32 and limit the peer_notif_delay to 300s
---
 drivers/net/bonding/bond_netlink.c | 7 ++++++-
 drivers/net/bonding/bond_options.c | 8 +++++++-
 include/net/bonding.h              | 2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index c2d080fc4fc4..27cbe148f0db 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -84,6 +84,11 @@ static int bond_fill_slave_info(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+/* Limit the max delay range to 300s */
+static struct netlink_range_validation delay_range = {
+	.max = 300000,
+};
+
 static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_MODE]		= { .type = NLA_U8 },
 	[IFLA_BOND_ACTIVE_SLAVE]	= { .type = NLA_U32 },
@@ -114,7 +119,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_AD_ACTOR_SYSTEM]	= { .type = NLA_BINARY,
 					    .len  = ETH_ALEN },
 	[IFLA_BOND_TLB_DYNAMIC_LB]	= { .type = NLA_U8 },
-	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
+	[IFLA_BOND_PEER_NOTIF_DELAY]    = NLA_POLICY_FULL_RANGE(NLA_U32, &delay_range),
 	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U8 },
 	[IFLA_BOND_NS_IP6_TARGET]	= { .type = NLA_NESTED },
 };
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 0498fc6731f8..f3f27f0bd2a6 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -169,6 +169,12 @@ static const struct bond_opt_value bond_num_peer_notif_tbl[] = {
 	{ NULL,      -1,  0}
 };
 
+static const struct bond_opt_value bond_peer_notif_delay_tbl[] = {
+	{ "off",     0,   0},
+	{ "maxval",  300000, BOND_VALFLAG_MAX},
+	{ NULL,      -1,  0}
+};
+
 static const struct bond_opt_value bond_primary_reselect_tbl[] = {
 	{ "always",  BOND_PRI_RESELECT_ALWAYS,  BOND_VALFLAG_DEFAULT},
 	{ "better",  BOND_PRI_RESELECT_BETTER,  0},
@@ -488,7 +494,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.id = BOND_OPT_PEER_NOTIF_DELAY,
 		.name = "peer_notif_delay",
 		.desc = "Delay between each peer notification on failover event, in milliseconds",
-		.values = bond_intmax_tbl,
+		.values = bond_peer_notif_delay_tbl,
 		.set = bond_option_peer_notif_delay_set
 	}
 };
diff --git a/include/net/bonding.h b/include/net/bonding.h
index a60a24923b55..0efef2a952b7 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -233,7 +233,7 @@ struct bonding {
 	 */
 	spinlock_t mode_lock;
 	spinlock_t stats_lock;
-	u8	 send_peer_notif;
+	u32	 send_peer_notif;
 	u8       igmp_retrans;
 #ifdef CONFIG_PROC_FS
 	struct   proc_dir_entry *proc_entry;
-- 
2.38.1


