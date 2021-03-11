Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584D5336AC2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhCKDd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:33:59 -0500
Received: from mail-eopbgr00108.outbound.protection.outlook.com ([40.107.0.108]:62782
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230477AbhCKDdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 22:33:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdknpkUEFJbIXSBIEWtUaaapjtGZjoAgN3Nw9L/OomwwGp4jOYdT+9//X3LCdsJqLF8qoRp6fGHDcbCT3oReZ0YU9UCIt/KvdNzy7poKx2CySpfhPb2EBMXh+QcYgFOghAIyN+FJ0D6Pl4PETyQloS2n9FdSOMhxoW4tdh9SuWOJdGg8CGJgYildjZLvOOnStA8nc+94iFfZNA+KmRNKrhi53VzcFrmOHX6g88T6grz0oSEHiGvWmRVBeBgL9643iVrAaCnHZzTkWSsEiFY7dYUMUO10HdOmeEmIpUvZwtKA8Dn/G+s5CjDby97GM+8hJULGk3G5iMcgjYur8PN6jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRj8r6SUB/7K5qEGXJPIjLUmDyEaCbTVF996HbFR0f8=;
 b=A3D4MxstaCsie2pBvXdstdYYAcKFvoVnvj3v+TNwmx3ENK5MsFYV9Oc9u6pI77qci1rwiMLWY4a2v94g+PXqSxinvHZVcPK1LCQKKQS8d7dd9eFF5ZnFSvWXDCMQPNF+XwfV1xD9i0Kwzht4qCsLSzIs0qhpoEP4II3pVnYi3yOjWTU07r7P/3Qk1yyxG6+SCKbExYnIo/nwUQbuM8i0pdk60DNctiFvsr/3YrDP7U9I/7CjAUTqpK1kdgd/WJrBFodxEGqe/yl/8dgJ4ELC5NRQM/G4OMZ84Ut8dHgXjmKvyoAxUT2IMW1ZYP6Eq3rcjcQ6I5NES2ws2ctlw96+MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRj8r6SUB/7K5qEGXJPIjLUmDyEaCbTVF996HbFR0f8=;
 b=P4DUc+LI+rrC7Oft4ZwO7955ZH86TlB4V4DV1hGuo3NaalFkxThM+QFMJcuvRyu+ztTvZ/R8HCWiodYNaBDDIVEZCpOD3L4oxqeOYQa2LnnRuPIlcE7Cpr8CTJXNdrNMdABJ61NWMfIWBTNm6UY704+XeebUwUpt/u3qgb61qHE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6720.eurprd05.prod.outlook.com (2603:10a6:800:139::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 11 Mar
 2021 03:33:39 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3%7]) with mapi id 15.20.3868.041; Thu, 11 Mar 2021
 03:33:39 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [net-next 2/2] tipc: clean up warnings detected by sparse
Date:   Thu, 11 Mar 2021 10:33:23 +0700
Message-Id: <20210311033323.191873-2-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311033323.191873-1-hoang.h.le@dektech.com.au>
References: <20210311033323.191873-1-hoang.h.le@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR0302CA0003.apcprd03.prod.outlook.com
 (2603:1096:3:2::13) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR0302CA0003.apcprd03.prod.outlook.com (2603:1096:3:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 03:33:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae3ec38c-9409-4686-5e01-08d8e43e75e2
X-MS-TrafficTypeDiagnostic: VI1PR05MB6720:
X-Microsoft-Antispam-PRVS: <VI1PR05MB6720879E0F0A9217FDBE8393F1909@VI1PR05MB6720.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cDmpOekh/oWNUmi8VMUxyZzbXF0B82kcJQG/lX43wEEbvlSnY51CV8oUHfxQkD2keK50/EaSFbQ0jFgahq/HVQO+F8yiOFPKTLZpmpDR7e3w7KxzVmKDFVOtJCs9HCi4X0wK7PXtEAGNR1RsxpA0sQieUMmgO3gjyMOuT5xwlkXmKCvF8Lc27vBvAeEiDeadg95lvKoIX0i17UF5wJv741J5TqGU5Gbxng2s70VJw855P+YplExJsAmCkbj91KObIjsOHLuPQ0E2w2+FmgFKWAf3JO4NqOrVX5Iisx92FXJAJmAYGJyyhksdUQ2yB6ia+bnNX+l43KcIqaxxMxSKaUw7NP+dwIqwMZIaPN5P8L55aOJttZGjy1rPVPfNEjhp5XPf7A0ZLqJNlc/tzqMW/Z4OAM4h70VCsnzC0QsPzvJehHIsQ/5oMjCSEtUjNqQ7XqsnPz05XfWPb4cLxlXQNmaozsZtdr2OqrCnqOVIQnwB9eNLDEg4wpX9gdNh4xPoKsKSWq+Z97+/AWJ9hQY7bf8pKlOL1GzI2LSdgoaI3A5+4bjp8EfuWmKkvPEGN9T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39840400004)(346002)(396003)(376002)(2906002)(36756003)(5660300002)(478600001)(1076003)(16526019)(26005)(66476007)(956004)(2616005)(186003)(66556008)(66946007)(8676002)(6666004)(316002)(103116003)(7696005)(52116002)(83380400001)(86362001)(55016002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XxJM6/yJepXf4A4aKVsMs6ADMGKyKSjHfEWXmeYp5Ru3nknaauebuE0e52lL?=
 =?us-ascii?Q?eX80XOwSAwo8VIKIaZSKSY0Dtwne3MJxEbDWdMEuEf2xELtlmda+XbxR37z7?=
 =?us-ascii?Q?F+TmLjdIqq6jdDfH7XZf6MIc4UYtj2FslVauwYZDvLzVEgdtIlF/Q4d5vA9h?=
 =?us-ascii?Q?CuFHem44RWyvsIERsHmPiBDMhv4d80kImstFUK0FmaUjmk8MPX/Ee5iX3DoA?=
 =?us-ascii?Q?MKJ7eyKw8pGRiOH3T2Bt0N9tcxorL6H3g1VkeQ03QDNXxwtqNCvsx7+zb3dH?=
 =?us-ascii?Q?kIyXzWWq5W4+9VE7BtfygKR5AJHf71tAyLVI9X7fb2wdnv77GhIIwWDBcnhk?=
 =?us-ascii?Q?qc83cwq/3fkrILV5DbY/ececJWjYK67WTmtzDTYgA3oYa6MZewM6f4MFAVbf?=
 =?us-ascii?Q?CwuzzMW8Xq/GFMCNggEb7xE62CkY0QlTesZN8uTgX+RsOfAlpRKWGD0oydvW?=
 =?us-ascii?Q?+JGDPKajLZ+VqYkrRubv/yDmVJjb7qVkRSjYjS06GP0QxoxsRt9tWbi4Gx+E?=
 =?us-ascii?Q?qfkjn2+xTNjnXmjG16PSN3BYdvG24Ev1uHF4Cij0rzzF/xGyxac7Xp97rZNQ?=
 =?us-ascii?Q?Ici73+vFOR7oJbambJEvSFTCf7uzebiWlsvXwVwNFnJ+lsbkTOTU3IlB8APJ?=
 =?us-ascii?Q?R6h2LH8rv9KN+BJ2HWaDb0IaRoIXyntw1DJZDuD+JqtB6uQr8LAvXoZAjwwY?=
 =?us-ascii?Q?DuJ7f+e75txE1jRid+e3jsfJZl7M8B2G4HhS7GUO5DP0wM0sUaeo0V37zZ2O?=
 =?us-ascii?Q?dc1klMfY74nLYGm0IssMrpteq5MpMIOFxdFqcZeRRms10X/EB1KdLG+DiQmI?=
 =?us-ascii?Q?uXlMNT/vcOGFlWh+9PSIwCqUA/tWMmVCE7RHb2wdzWoPqPYgXicw3xKGkqLL?=
 =?us-ascii?Q?kZCg7aaY+g+iUKQrUi0guPMvxlNzug0uOsM3B8JmHC28Lm9oTYMb2DExEbqj?=
 =?us-ascii?Q?0FbUHn9dmxT/15n626KxQj94H913VAAYUd9C1MdpS6HS8y0itAkZzPvK2ez4?=
 =?us-ascii?Q?k+XuB74iB/S4yXCv2qdWGatc7OA8T4TWQva5PWPBKp4TCY0TH/uxUaSSrpJi?=
 =?us-ascii?Q?ZfdYpuse9g46tymbCjN1OLqT6BUgHlblMpnStgWaJnMu/0uNwINb+XhfJdTi?=
 =?us-ascii?Q?tIMcGHk4pWoGbizpC/lnrMzYqXzbRRXFnVGGBlUrpeg8SxL4OgRaNdOZe/Mv?=
 =?us-ascii?Q?40sX0s7lpGXCYsTCDji5gNlFDuuC083P/Qyl5m9yA51liMViKs6JpWksnZci?=
 =?us-ascii?Q?puGGOdwMwY74V0+2AOSsRUM7g7TwSRrN1AyNxNtJHvYaoh/8Tj5uX1Wgkpb6?=
 =?us-ascii?Q?W8yucnN7OjI3ed+OPtpaVw9O?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: ae3ec38c-9409-4686-5e01-08d8e43e75e2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 03:33:39.4007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fo5qLpfx0xoy6dtU9qGGHBwLhDZ5TW4vQgCqAxrSnsRlyxYUy/jCyegsdSZ1uNtDlWpwYlM0mbtwCoxMyO8cJSsy8N+Vpy30vpdqrZx2ZFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6720
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

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/crypto.c  | 12 ++++-----
 net/tipc/monitor.c | 63 ++++++++++++++++++++++++++++++++++------------
 net/tipc/node.c    |  5 ++++
 3 files changed, 58 insertions(+), 22 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index f4fca8f7f63f..6f64acef73dc 100644
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
@@ -1946,16 +1946,16 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 			goto rcv;
 		}
 		tipc_aead_put(aead);
-		aead = tipc_aead_get(tmp);
+		aead = tipc_aead_get((struct tipc_aead __force __rcu *)tmp);
 	}
 
 	if (unlikely(err)) {
-		tipc_aead_users_dec(aead, INT_MIN);
+		tipc_aead_users_dec((struct tipc_aead __force __rcu *)aead, INT_MIN);
 		goto free_skb;
 	}
 
 	/* Set the RX key's user */
-	tipc_aead_users_set(aead, 1);
+	tipc_aead_users_set((struct tipc_aead __force __rcu *)aead, 1);
 
 	/* Mark this point, RX works */
 	rx->timer1 = jiffies;
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 48fac3b17e40..407619697292 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -104,6 +104,36 @@ static struct tipc_monitor *tipc_monitor(struct net *net, int bearer_id)
 
 const int tipc_max_domain_size = sizeof(struct tipc_mon_domain);
 
+static inline u16 mon_cpu_to_le16(u16 val)
+{
+	return (__force __u16)htons(val);
+}
+
+static inline u32 mon_cpu_to_le32(u32 val)
+{
+	return (__force __u32)htonl(val);
+}
+
+static inline u64 mon_cpu_to_le64(u64 val)
+{
+	return (__force __u64)cpu_to_be64(val);
+}
+
+static inline u16 mon_le16_to_cpu(u16 val)
+{
+	return ntohs((__force __be16)val);
+}
+
+static inline u32 mon_le32_to_cpu(u32 val)
+{
+	return ntohl((__force __be32)val);
+}
+
+static inline u64 mon_le64_to_cpu(u64 val)
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

