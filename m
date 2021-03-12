Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DB2338383
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhCLCUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:20:38 -0500
Received: from mail-am6eur05on2105.outbound.protection.outlook.com ([40.107.22.105]:12801
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231646AbhCLCU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 21:20:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIf3pT3a8FxL7EJsRc4vSokIWzfSVHmJQnWg0x9TBnlfjVSSjr5CEBGSGbL088oNJVUIkaJ32IPXsSm5zZ/8rQP00XH7VoVAtkQgWGhxs8cuiCjuKfdDB8B0jr1hQb93qaCq03pIYi4R98ItH9j8L8rBpsBxWxiIA4vZfMZF8k5OPDsxnxlZotRiFWunYPpwgU+sBTZN7Xc6oA8l6OlpO6dL0yrNBucBz/ogurzhk4mI8yhX7Nsg0Ne8ctBgIDmL/l//VKCzbwgC8Wp3EWpYschczKe9w9m3SHnqhyRh/3MpGa66Oa/Re+XD89iXtsQGPFj9N8S3kZZtklf5vfKAlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuQB2SS/NtINS3weOzon4QnaZp9KZfE3eRHaoRHKyfE=;
 b=WlO4v4oN7Nd7l4BI8RujCjLBwhkZhh2yxb+VC84WoaERDonPwcAvBfmtKqMxRf9odblspD9/aecQUqAu1FudfqAFmYoP4XImxHZOKe0pgbGQwURGyKHiFR0Bve5op0YZMQP6QnwxF6gw/GTafM9Pm94ZlggxyDXJAR+GOGWw4TFmg5RV8NHhWOyU7yYiXBEO1mjwgN7U3R4OJWsCDQQz4BHZhsewnb6XRUeom0yvNlsy8DtSYrlg5KAac2B4IZ9NwiHFHA5uhvw2ABR8zXSyDMT6+YXuCkQQQsVA3rFvZytlQtSsITzEXFkI6uTJLTSrJDt7rL6piZdM8Oi4kzuchQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuQB2SS/NtINS3weOzon4QnaZp9KZfE3eRHaoRHKyfE=;
 b=T0HaZaLL+bJNKroahMORSvG2+vE8dTdMa44PwLpbWKKBhn49DZxipB1HzO1mhjDM8wUV3sMrPbubLqtT63qJnHz7gIbtDhWubve+r1WXLKTLWS8i71eSv2PSYtzxWsTCueNA2A5P11e6BCZvXblJGjoFMUW+a1hGNs0piZKL9rk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB4782.eurprd05.prod.outlook.com (2603:10a6:802:5f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30; Fri, 12 Mar
 2021 02:20:26 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3%7]) with mapi id 15.20.3868.041; Fri, 12 Mar 2021
 02:20:26 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [net-next v2 2/2] tipc: clean up warnings detected by sparse
Date:   Fri, 12 Mar 2021 09:20:08 +0700
Message-Id: <20210312022008.6495-2-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210312022008.6495-1-hoang.h.le@dektech.com.au>
References: <20210312022008.6495-1-hoang.h.le@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [113.20.114.51]
X-ClientProxiedBy: HKAPR03CA0004.apcprd03.prod.outlook.com
 (2603:1096:203:c8::9) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by HKAPR03CA0004.apcprd03.prod.outlook.com (2603:1096:203:c8::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Fri, 12 Mar 2021 02:20:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e38cc71-1d0a-4e5d-834c-08d8e4fd653d
X-MS-TrafficTypeDiagnostic: VI1PR05MB4782:
X-Microsoft-Antispam-PRVS: <VI1PR05MB47825D07720436C6374B50FDF16F9@VI1PR05MB4782.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4keJc3nPoVDkvY0wo9SA3dF62iTHl4X8vHW47clunefbN/KxqvYe61Bfb7+OE8aNcIKbJe1yUYpJemJdOg66UV1RlOGtNTIGJAEP7xrYymbUlTc0Ex+R28d+bzvBw+uBEmL7ophxRuw5Rz8ftTZyZrp5X8yML/hZ49ABoPtHhiMMsLIqjJExUHuAmfVa8WqAX3o9BPaSMOqGJmrkkIcyNMTfE3I9+DkljGZ8EVHXm+kRvlfHEW/BXxzYARFNopfirTisxNjapxv7jCF74Su/o6Lc7m7CygFtSPdyw9EpLMF5YDtWNihm+z6rTLRzvXwa6daB09qC6g4axWFcB7UXG9BAh+VJjmjC11rQjjsQs2+MuzgUKSsYT9V1TXMEVWOMyn6yEKhkUM+eqAs5jKGpdGwKeDyuvrDJS9oJC+ImGxbbB0aqMfisi4+aec4AwgtGfQNBy/D0i78aGMTtdQfVBJmYdBCjCmfG9V2ebqVHTWtwIPvfJvTzY52sFQO4f57zAbXfA8T4/dt4zd1F0QBgWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(396003)(39840400004)(136003)(52116002)(55016002)(66476007)(186003)(7696005)(83380400001)(5660300002)(36756003)(103116003)(478600001)(66946007)(2906002)(66556008)(8676002)(1076003)(6666004)(2616005)(16526019)(956004)(8936002)(316002)(26005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SdXbiRlRLMsAf4XurLqRKSeHiLPdnYlSM9k14FPdq0FKa+l6gxD6dGkSqBQB?=
 =?us-ascii?Q?0WRftWlg1L5XZso8q3ptIxCVbDb/tURjQoLIl0d392lNtZJeqoFBG5968ayg?=
 =?us-ascii?Q?gGGsaQn4y31l35AUcO7fLsiSrUpCcr3U1kqWmlTca8gwidRF/AOnAxGye93/?=
 =?us-ascii?Q?Lt4/UE54ltc+cNbLv/Y3ybaqjTt43s4kFn0Fa6Bfq7RYGNeXHo68+PQq+NA3?=
 =?us-ascii?Q?Dfu6pVQXQuF34SHDjfSPzMGtgKIgKi5LmTxOeQlRCHCnZnCf2GLF06IaDcX0?=
 =?us-ascii?Q?P659nGzEipdZMWpDmyqFhVnpz7/zgpqMEI3pwsiyRlvCmwpoVIgMP6XAsYhm?=
 =?us-ascii?Q?k8FkCmAYU5JE/7ONodMUCYoHZC0dAL7HthMmAAE+mGhx/ibLKg+/0hGCQcRm?=
 =?us-ascii?Q?12lncq9E0w1LG8NFm3c7gY1kgTBZjP8zfeqR3DPboK8wkSH3aqDf4tt3n1+f?=
 =?us-ascii?Q?GRHmRrD7WR/SwYsgC/FdHeeO0+ibRH5ZNa3kUeBbGS3G8Y0GamK0XcVxKXS4?=
 =?us-ascii?Q?mMgwr3vFeTYIjyyWEUMlK8S+xhRjT49TiZxVePOPu7tQRX1Vi5gyF+ayoDvK?=
 =?us-ascii?Q?yOPUsgWd5ZV1mC2psh954NWvfDuI7WpgQJHVylrlseUMoOaUbDNmboYH1lU/?=
 =?us-ascii?Q?0QxBIDeNJRQNJo3Sj+G7jQVlDgY6ChZ6g6ejvznxqhkNuxy1b8gN+HCgscSU?=
 =?us-ascii?Q?KKRnCW/smuyRT7O9u/oonwWCyp220hpG7u9GvN8r3iYiKQb09E9GyGK/xtAm?=
 =?us-ascii?Q?CN3xloLxGSoQkY/vAFqS9ZNheA6RopHfz5VlCtw/FIGcRJmjYDtMvw0CvSqg?=
 =?us-ascii?Q?cX4lm9cB/9q4AB9MBCKX3xN8H4s9lWjh3v43hHKG5u88AMnUBAoNwMfp/oAP?=
 =?us-ascii?Q?parSnHkKQNz4Jy874dJB2vLevCowyxS1pxJ99ok2zEA02yl51Y+DzSD2MTwx?=
 =?us-ascii?Q?gmnK8yTztjZ7Bepp399bDXn8oE87tLH11FCv3pVMvz8WX9ISBgarRMAuN3UZ?=
 =?us-ascii?Q?xg8xYiNKseJByGLG7Qj25zT+Q0hbn48JR6O9c4OsiP4girnep0oqjA6I5Jcj?=
 =?us-ascii?Q?paKR9jExnZMfuO/9rBgsH6FcFvoyNEgrRz0KNWS2IK0XNZScPa4Ovfdm7Qg1?=
 =?us-ascii?Q?2CLzAyT5X9z46YDV6RJiOhPpcAniMdF38oXa9IJkGKNNzdk+aY080LPuxnMe?=
 =?us-ascii?Q?HKH0jbY1/jVyDV6BTRvaRBY6wapZJMlnsG1nJ5Uas8tfSaDLCexvl0kbzQpN?=
 =?us-ascii?Q?/nq2NUKnXhRuCPQr5FpXmUV1lkGZ4iTvWo6YIHc3ZYaf2X+/rbtMvi0/PFGi?=
 =?us-ascii?Q?bkolTJUrVvNt6SCLZOHl9Klu?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e38cc71-1d0a-4e5d-834c-08d8e4fd653d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 02:20:25.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1d8wuKwddq8E7mbhnst8wVBdsGBi7FgvuOJQ1JDGO4wGqeW50uI69gkY8CY6NQDW9VCwfAzcpimAsMos+x8bRphEKFTtqqSkyDpqUzu8gyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4782
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following warning from sparse:

net/tipc/monitor.c:263:35: warning: incorrect type in assignment (different base types)
net/tipc/monitor.c:263:35:    expected unsigned int
net/tipc/monitor.c:263:35:    got restricted __be32 [usertype]
[...]
net/tipc/node.c:374:13: warning: context imbalance in 'tipc_node_read_lock' - wrong count at exit
net/tipc/node.c:379:13: warning: context imbalance in 'tipc_node_read_unlock' - unexpected unlock
net/tipc/node.c:384:13: warning: context imbalance in 'tipc_node_write_lock' - wrong count at exit
net/tipc/node.c:389:13: warning: context imbalance in 'tipc_node_write_unlock_fast' - unexpected unlock
net/tipc/node.c:404:17: warning: context imbalance in 'tipc_node_write_unlock' - unexpected unlock
[...]
net/tipc/crypto.c:1201:9: warning: incorrect type in initializer (different address spaces)
net/tipc/crypto.c:1201:9:    expected struct tipc_aead [noderef] __rcu *__tmp
net/tipc/crypto.c:1201:9:    got struct tipc_aead *
[...]

v2: switch to use the keyword "__always_inline" for inline function

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/crypto.c  | 13 +++++-----
 net/tipc/monitor.c | 63 ++++++++++++++++++++++++++++++++++------------
 net/tipc/node.c    |  5 ++++
 3 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index f4fca8f7f63f..b428fa1c3241 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -317,7 +317,7 @@ static int tipc_aead_key_generate(struct tipc_aead_key *skey);
 
 #define tipc_aead_rcu_replace(rcu_ptr, ptr, lock)			\
 do {									\
-	typeof(rcu_ptr) __tmp = rcu_dereference_protected((rcu_ptr),	\
+	struct tipc_aead *__tmp = rcu_dereference_protected((rcu_ptr),	\
 						lockdep_is_held(lock));	\
 	rcu_assign_pointer((rcu_ptr), (ptr));				\
 	tipc_aead_put(__tmp);						\
@@ -798,7 +798,7 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 	ehdr = (struct tipc_ehdr *)skb->data;
 	salt = aead->salt;
 	if (aead->mode == CLUSTER_KEY)
-		salt ^= ehdr->addr; /* __be32 */
+		salt ^= __be32_to_cpu(ehdr->addr);
 	else if (__dnode)
 		salt ^= tipc_node_get_addr(__dnode);
 	memcpy(iv, &salt, 4);
@@ -929,7 +929,7 @@ static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 	ehdr = (struct tipc_ehdr *)skb->data;
 	salt = aead->salt;
 	if (aead->mode == CLUSTER_KEY)
-		salt ^= ehdr->addr; /* __be32 */
+		salt ^= __be32_to_cpu(ehdr->addr);
 	else if (ehdr->destined)
 		salt ^= tipc_own_addr(net);
 	memcpy(iv, &salt, 4);
@@ -1946,16 +1946,17 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 			goto rcv;
 		}
 		tipc_aead_put(aead);
-		aead = tipc_aead_get(tmp);
+		aead = tipc_aead_get((struct tipc_aead __force __rcu *)tmp);
 	}
 
 	if (unlikely(err)) {
-		tipc_aead_users_dec(aead, INT_MIN);
+		tipc_aead_users_dec((struct tipc_aead __force __rcu *)aead,
+				    INT_MIN);
 		goto free_skb;
 	}
 
 	/* Set the RX key's user */
-	tipc_aead_users_set(aead, 1);
+	tipc_aead_users_set((struct tipc_aead __force __rcu *)aead, 1);
 
 	/* Mark this point, RX works */
 	rx->timer1 = jiffies;
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 48fac3b17e40..1b514cb7a7d3 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -104,6 +104,36 @@ static struct tipc_monitor *tipc_monitor(struct net *net, int bearer_id)
 
 const int tipc_max_domain_size = sizeof(struct tipc_mon_domain);
 
+static __always_inline u16 mon_cpu_to_le16(u16 val)
+{
+	return (__force __u16)htons(val);
+}
+
+static __always_inline u32 mon_cpu_to_le32(u32 val)
+{
+	return (__force __u32)htonl(val);
+}
+
+static __always_inline u64 mon_cpu_to_le64(u64 val)
+{
+	return (__force __u64)cpu_to_be64(val);
+}
+
+static __always_inline u16 mon_le16_to_cpu(u16 val)
+{
+	return ntohs((__force __be16)val);
+}
+
+static __always_inline u32 mon_le32_to_cpu(u32 val)
+{
+	return ntohl((__force __be32)val);
+}
+
+static __always_inline u64 mon_le64_to_cpu(u64 val)
+{
+	return be64_to_cpu((__force __be64)val);
+}
+
 /* dom_rec_len(): actual length of domain record for transport
  */
 static int dom_rec_len(struct tipc_mon_domain *dom, u16 mcnt)
@@ -260,16 +290,16 @@ static void mon_update_local_domain(struct tipc_monitor *mon)
 		diff |= dom->members[i] != peer->addr;
 		dom->members[i] = peer->addr;
 		map_set(&dom->up_map, i, peer->is_up);
-		cache->members[i] = htonl(peer->addr);
+		cache->members[i] = mon_cpu_to_le32(peer->addr);
 	}
 	diff |= dom->up_map != prev_up_map;
 	if (!diff)
 		return;
 	dom->gen = ++mon->dom_gen;
-	cache->len = htons(dom->len);
-	cache->gen = htons(dom->gen);
-	cache->member_cnt = htons(member_cnt);
-	cache->up_map = cpu_to_be64(dom->up_map);
+	cache->len = mon_cpu_to_le16(dom->len);
+	cache->gen = mon_cpu_to_le16(dom->gen);
+	cache->member_cnt = mon_cpu_to_le16(member_cnt);
+	cache->up_map = mon_cpu_to_le64(dom->up_map);
 	mon_apply_domain(mon, self);
 }
 
@@ -455,10 +485,11 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	struct tipc_mon_domain dom_bef;
 	struct tipc_mon_domain *dom;
 	struct tipc_peer *peer;
-	u16 new_member_cnt = ntohs(arrv_dom->member_cnt);
+	u16 new_member_cnt = mon_le16_to_cpu(arrv_dom->member_cnt);
 	int new_dlen = dom_rec_len(arrv_dom, new_member_cnt);
-	u16 new_gen = ntohs(arrv_dom->gen);
-	u16 acked_gen = ntohs(arrv_dom->ack_gen);
+	u16 new_gen = mon_le16_to_cpu(arrv_dom->gen);
+	u16 acked_gen = mon_le16_to_cpu(arrv_dom->ack_gen);
+	u16 arrv_dlen = mon_le16_to_cpu(arrv_dom->len);
 	bool probing = state->probing;
 	int i, applied_bef;
 
@@ -469,7 +500,7 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 		return;
 	if (dlen != dom_rec_len(arrv_dom, new_member_cnt))
 		return;
-	if ((dlen < new_dlen) || ntohs(arrv_dom->len) != new_dlen)
+	if (dlen < new_dlen || arrv_dlen != new_dlen)
 		return;
 
 	/* Synch generation numbers with peer if link just came up */
@@ -517,9 +548,9 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	dom->len = new_dlen;
 	dom->gen = new_gen;
 	dom->member_cnt = new_member_cnt;
-	dom->up_map = be64_to_cpu(arrv_dom->up_map);
+	dom->up_map = mon_le64_to_cpu(arrv_dom->up_map);
 	for (i = 0; i < new_member_cnt; i++)
-		dom->members[i] = ntohl(arrv_dom->members[i]);
+		dom->members[i] = mon_le32_to_cpu(arrv_dom->members[i]);
 
 	/* Update peers affected by this domain record */
 	applied_bef = peer->applied;
@@ -548,19 +579,19 @@ void tipc_mon_prep(struct net *net, void *data, int *dlen,
 	if (likely(state->acked_gen == gen)) {
 		len = dom_rec_len(dom, 0);
 		*dlen = len;
-		dom->len = htons(len);
-		dom->gen = htons(gen);
-		dom->ack_gen = htons(state->peer_gen);
+		dom->len = mon_cpu_to_le16(len);
+		dom->gen = mon_cpu_to_le16(gen);
+		dom->ack_gen = mon_cpu_to_le16(state->peer_gen);
 		dom->member_cnt = 0;
 		return;
 	}
 	/* Send the full record */
 	read_lock_bh(&mon->lock);
-	len = ntohs(mon->cache.len);
+	len = mon_le16_to_cpu(mon->cache.len);
 	*dlen = len;
 	memcpy(data, &mon->cache, len);
 	read_unlock_bh(&mon->lock);
-	dom->ack_gen = htons(state->peer_gen);
+	dom->ack_gen = mon_cpu_to_le16(state->peer_gen);
 }
 
 void tipc_mon_get_state(struct net *net, u32 addr,
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 008670d1f43e..9c95ef4b6326 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -372,26 +372,31 @@ static struct tipc_node *tipc_node_find_by_id(struct net *net, u8 *id)
 }
 
 static void tipc_node_read_lock(struct tipc_node *n)
+	__acquires(n->lock)
 {
 	read_lock_bh(&n->lock);
 }
 
 static void tipc_node_read_unlock(struct tipc_node *n)
+	__releases(n->lock)
 {
 	read_unlock_bh(&n->lock);
 }
 
 static void tipc_node_write_lock(struct tipc_node *n)
+	__acquires(n->lock)
 {
 	write_lock_bh(&n->lock);
 }
 
 static void tipc_node_write_unlock_fast(struct tipc_node *n)
+	__releases(n->lock)
 {
 	write_unlock_bh(&n->lock);
 }
 
 static void tipc_node_write_unlock(struct tipc_node *n)
+	__releases(n->lock)
 {
 	struct net *net = n->net;
 	u32 addr = 0;
-- 
2.25.1

