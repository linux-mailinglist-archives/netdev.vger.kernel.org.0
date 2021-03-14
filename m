Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C072733A4B1
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhCNMUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:20:52 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45841 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235313AbhCNMUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4B9235808B9;
        Sun, 14 Mar 2021 08:20:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ait519S8vQL2dE/QTPUq8nTsDaey0vx5HwhpaZBwCZU=; b=PmXD7DM3
        yAF3m+1BdmgDAvCvr/Ml605A9/9hZhFKU4RvZ9NSTkpfYwnf0CdKlheEsbajo5iP
        /GIaVa7r6ldc0Gouh7NDz3axZ1RfTXm3NzZg7hNVTknSQQW2uLUMRWZXRtTsyv8/
        cdg3UeO5INs67xnHXCEckc3n3CuHgOvbOYOsZxQvxy6vJbtdXLb87z6JYdsdfq2r
        +3SQEx8ZgCSZh5bcewT2tbEXi+/HBTxWLaucv+pBlCEDa5qbFewZHimXGf3bkRDY
        93lX1fZhjUqmcQWEjtmj3/6F9fhOPk0UKM6XGkEeBPYYu9rhsQme1ChT629lVYyS
        UJ6Gt08g/axK5A==
X-ME-Sender: <xms:hv9NYK__-sGgYPcvlQeTDLMVp0BSW8_J8MCF2ZWHSUS2Pfou5L3QvA>
    <xme:hv9NYKsz4NjSRxpXan52_lNX0lR9hmhlSVCcvrWuoRqsSh8STChv_j6WVxek5V9EY
    Cm8S70zUVyw0OE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hv9NYAD65agwO9ShufLZ52xjvok7BeijTrJBSs4c0Uc9jsFc0NnVGQ>
    <xmx:hv9NYCfeakXd6BGLXqO9sv8rrp4lGXbEHh6ptTJHWVY-2tDngB1Bnw>
    <xmx:hv9NYPNkT2xEt-HpnXwuqZHHjmC1aqHGdqJBmG5EZxeWtabdg5NvGw>
    <xmx:hv9NYIhiBy50wImKGXhmZiKB1e3ezFCWGHc1_MV7rZf-W4oIMwmfdw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63120240057;
        Sun, 14 Mar 2021 08:20:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/11] psample: Add additional metadata attributes
Date:   Sun, 14 Mar 2021 14:19:31 +0200
Message-Id: <20210314121940.2807621-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Extend psample to report the following attributes when available:

* Output traffic class as a 16-bit value
* Output traffic class occupancy in bytes as a 64-bit value
* End-to-end latency of the packet in nanoseconds resolution
* Software timestamp in nanoseconds resolution (always available)
* Packet's protocol. Needed for packet dissection in user space (always
  available)

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/psample.h        |  7 +++++++
 include/uapi/linux/psample.h |  7 +++++++
 net/psample/psample.c        | 39 +++++++++++++++++++++++++++++++++++-
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/include/net/psample.h b/include/net/psample.h
index ac6dbfb3870d..e328c5127757 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -18,6 +18,13 @@ struct psample_metadata {
 	u32 trunc_size;
 	int in_ifindex;
 	int out_ifindex;
+	u16 out_tc;
+	u64 out_tc_occ;	/* bytes */
+	u64 latency;	/* nanoseconds */
+	u8 out_tc_valid:1,
+	   out_tc_occ_valid:1,
+	   latency_valid:1,
+	   unused:5;
 };
 
 struct psample_group *psample_group_get(struct net *net, u32 group_num);
diff --git a/include/uapi/linux/psample.h b/include/uapi/linux/psample.h
index aea26ab1431c..c6329f71b939 100644
--- a/include/uapi/linux/psample.h
+++ b/include/uapi/linux/psample.h
@@ -16,6 +16,13 @@ enum {
 	/* commands attributes */
 	PSAMPLE_ATTR_GROUP_REFCOUNT,
 
+	PSAMPLE_ATTR_PAD,
+	PSAMPLE_ATTR_OUT_TC,		/* u16 */
+	PSAMPLE_ATTR_OUT_TC_OCC,	/* u64, bytes */
+	PSAMPLE_ATTR_LATENCY,		/* u64, nanoseconds */
+	PSAMPLE_ATTR_TIMESTAMP,		/* u64, nanoseconds */
+	PSAMPLE_ATTR_PROTO,		/* u16 */
+
 	__PSAMPLE_ATTR_MAX
 };
 
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 065bc887d239..118d5d2a81a0 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/module.h>
+#include <linux/timekeeping.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -358,6 +359,7 @@ static int psample_tunnel_meta_len(struct ip_tunnel_info *tun_info)
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 			   u32 sample_rate, const struct psample_metadata *md)
 {
+	ktime_t tstamp = ktime_get_real();
 	int out_ifindex = md->out_ifindex;
 	int in_ifindex = md->in_ifindex;
 	u32 trunc_size = md->trunc_size;
@@ -372,10 +374,15 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 
 	meta_len = (in_ifindex ? nla_total_size(sizeof(u16)) : 0) +
 		   (out_ifindex ? nla_total_size(sizeof(u16)) : 0) +
+		   (md->out_tc_valid ? nla_total_size(sizeof(u16)) : 0) +
+		   (md->out_tc_occ_valid ? nla_total_size_64bit(sizeof(u64)) : 0) +
+		   (md->latency_valid ? nla_total_size_64bit(sizeof(u64)) : 0) +
 		   nla_total_size(sizeof(u32)) +	/* sample_rate */
 		   nla_total_size(sizeof(u32)) +	/* orig_size */
 		   nla_total_size(sizeof(u32)) +	/* group_num */
-		   nla_total_size(sizeof(u32));		/* seq */
+		   nla_total_size(sizeof(u32)) +	/* seq */
+		   nla_total_size_64bit(sizeof(u64)) +	/* timestamp */
+		   nla_total_size(sizeof(u16));		/* protocol */
 
 #ifdef CONFIG_INET
 	tun_info = skb_tunnel_info(skb);
@@ -425,6 +432,36 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 	if (unlikely(ret < 0))
 		goto error;
 
+	if (md->out_tc_valid) {
+		ret = nla_put_u16(nl_skb, PSAMPLE_ATTR_OUT_TC, md->out_tc);
+		if (unlikely(ret < 0))
+			goto error;
+	}
+
+	if (md->out_tc_occ_valid) {
+		ret = nla_put_u64_64bit(nl_skb, PSAMPLE_ATTR_OUT_TC_OCC,
+					md->out_tc_occ, PSAMPLE_ATTR_PAD);
+		if (unlikely(ret < 0))
+			goto error;
+	}
+
+	if (md->latency_valid) {
+		ret = nla_put_u64_64bit(nl_skb, PSAMPLE_ATTR_LATENCY,
+					md->latency, PSAMPLE_ATTR_PAD);
+		if (unlikely(ret < 0))
+			goto error;
+	}
+
+	ret = nla_put_u64_64bit(nl_skb, PSAMPLE_ATTR_TIMESTAMP,
+				ktime_to_ns(tstamp), PSAMPLE_ATTR_PAD);
+	if (unlikely(ret < 0))
+		goto error;
+
+	ret = nla_put_u16(nl_skb, PSAMPLE_ATTR_PROTO,
+			  be16_to_cpu(skb->protocol));
+	if (unlikely(ret < 0))
+		goto error;
+
 	if (data_len) {
 		int nla_len = nla_total_size(data_len);
 		struct nlattr *nla;
-- 
2.29.2

