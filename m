Return-Path: <netdev+bounces-6916-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F49718A57
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D132280D53
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA723C09D;
	Wed, 31 May 2023 19:38:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB7D3C098;
	Wed, 31 May 2023 19:38:55 +0000 (UTC)
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1519912C;
	Wed, 31 May 2023 12:38:54 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3f6b2af4558so34599501cf.1;
        Wed, 31 May 2023 12:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685561933; x=1688153933;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6YbMW6Vm5ZP3l9bQLLGd6zO2NQF37oCsx6kpRBWVcmU=;
        b=dyp9p91GSz0UuR5g9XlRAczlgvTzMBsKZ/nzVZgoo0W12d/W8O9686VhjvIzjXCaaZ
         Y70YPx6Kk452oyrjmS6SYxyxaQVSmNgW4aRr5roZXt7Szct+xeq7H5azvN8ob9nkn5b9
         nGmi+OWPbpR1DD1qJCjB2sc9s9X2dtTuPcnvnyCyNpRbCioESBcFh7btCxtpzBKNBZCJ
         p1tj7/Y2pRxiUy60DOOo3/GcG92okVBtL2C3+YBbk5j0ybsdOmX1cVfOOjgEcWGDFWpx
         zUv5c/59vDaO2v3s1ngeDFwIOyu7wp3PqyD6Mu9lDTvwCSI1l5brdSBKwDBpoWtfZrXo
         aqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685561933; x=1688153933;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6YbMW6Vm5ZP3l9bQLLGd6zO2NQF37oCsx6kpRBWVcmU=;
        b=GJ7jPaYDS2sBmLlR4lIK2pXhC51nOyaJsPOSjShzAIB5KMj5cXXMQKrOS7sAOUuJda
         aQT7awxXymUQxLE3CmcG46s4QZPHPgW368yVpfV08uct4MNbOJX9Ufd8NYy9fTFtEULG
         /Dkv7wzBIyObSshVmXlNDBMM+Dsx+/wHiMG4IH+Uu1rcYuGDE5m1BSCdPDo6LtJ8IX/Q
         eeaO2E117WyZvKoZCbqNqk2upjHA2H/oa5gbPPCeMA/8oW1wJbMEwEaOVpwS3ThaXLyX
         vd8BQL41O+Wk7ys4Y0DGgeKX1T9BmjgzRok2BRIsJF2V30VQqp8f9wACFz4exqNSW0wY
         oapg==
X-Gm-Message-State: AC+VfDw4kKa/YkrduGu6Jnh5U/1lvm568jXrnSygblwN8Q8inAV/bMUz
	p/df+uyPvRhCZIAY1152gKM=
X-Google-Smtp-Source: ACHHUZ6fTaC0bSSU/Q6LZsDlVYr7E6XsJj92Ef9HKxdP0TUagJUwy4WgT09lgwaS0/DsMRJ3yw6nPQ==
X-Received: by 2002:ac8:4e8d:0:b0:3f5:3991:97c3 with SMTP id 13-20020ac84e8d000000b003f5399197c3mr7697382qtp.68.1685561932956;
        Wed, 31 May 2023 12:38:52 -0700 (PDT)
Received: from localhost (ool-944b8b4f.dyn.optonline.net. [148.75.139.79])
        by smtp.gmail.com with ESMTPSA id y3-20020ac87c83000000b003e89e2b3c23sm6363259qtv.58.2023.05.31.12.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 12:38:52 -0700 (PDT)
From: Louis DeLosSantos <louis.delos.devel@gmail.com>
Date: Wed, 31 May 2023 15:38:48 -0400
Subject: [PATCH v2 1/2] bpf: add table ID to bpf_fib_lookup BPF helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230505-bpf-add-tbid-fib-lookup-v2-1-0a31c22c748c@gmail.com>
References: <20230505-bpf-add-tbid-fib-lookup-v2-0-0a31c22c748c@gmail.com>
In-Reply-To: <20230505-bpf-add-tbid-fib-lookup-v2-0-0a31c22c748c@gmail.com>
To: bpf@vger.kernel.org, netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, 
 Stanislav Fomichev <sdf@google.com>, razor@blackwall.org, 
 John Fastabend <john.fastabend@gmail.com>, Yonghong Song <yhs@meta.com>, 
 Louis DeLosSantos <louis.delos.devel@gmail.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add ability to specify routing table ID to the `bpf_fib_lookup` BPF
helper.

A new field `tbid` is added to `struct bpf_fib_lookup` used as
parameters to the `bpf_fib_lookup` BPF helper.

When the helper is called with the `BPF_FIB_LOOKUP_DIRECT` and
`BPF_FIB_LOOKUP_TBID` flags the `tbid` field in `struct bpf_fib_lookup`
will be used as the table ID for the fib lookup.

If the `tbid` does not exist the fib lookup will fail with
`BPF_FIB_LKUP_RET_NOT_FWDED`.

The `tbid` field becomes a union over the vlan related output fields in
`struct bpf_fib_lookup` and will be zeroed immediately after usage.

This functionality is useful in containerized environments.

For instance, if a CNI wants to dictate the next-hop for traffic leaving
a container it can create a container-specific routing table and perform
a fib lookup against this table in a "host-net-namespace-side" TC program.

This functionality also allows `ip rule` like functionality at the TC
layer, allowing an eBPF program to pick a routing table based on some
aspect of the sk_buff.

As a concrete use case, this feature will be used in Cilium's SRv6 L3VPN
datapath.

When egress traffic leaves a Pod an eBPF program attached by Cilium will
determine which VRF the egress traffic should target, and then perform a
FIB lookup in a specific table representing this VRF's FIB.

Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
---
 include/uapi/linux/bpf.h       | 21 ++++++++++++++++++---
 net/core/filter.c              | 14 +++++++++++++-
 tools/include/uapi/linux/bpf.h | 21 ++++++++++++++++++---
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1bb11a6ee6676..6254eac48b185 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3167,6 +3167,10 @@ union bpf_attr {
  *		**BPF_FIB_LOOKUP_DIRECT**
  *			Do a direct table lookup vs full lookup using FIB
  *			rules.
+ *		**BPF_FIB_LOOKUP_TBID**
+ *			Used with BPF_FIB_LOOKUP_DIRECT.
+ *			Use the routing table ID present in *params*->tbid
+ *			for the fib lookup.
  *		**BPF_FIB_LOOKUP_OUTPUT**
  *			Perform lookup from an egress perspective (default is
  *			ingress).
@@ -6821,6 +6825,7 @@ enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
 	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
+	BPF_FIB_LOOKUP_TBID    = (1U << 3),
 };
 
 enum {
@@ -6881,9 +6886,19 @@ struct bpf_fib_lookup {
 		__u32		ipv6_dst[4];  /* in6_addr; network order */
 	};
 
-	/* output */
-	__be16	h_vlan_proto;
-	__be16	h_vlan_TCI;
+	union {
+		struct {
+			/* output */
+			__be16	h_vlan_proto;
+			__be16	h_vlan_TCI;
+		};
+		/* input: when accompanied with the
+		 * 'BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_TBID` flags, a
+		 * specific routing table to use for the fib lookup.
+		 */
+		__u32	tbid;
+	};
+
 	__u8	smac[6];     /* ETH_ALEN */
 	__u8	dmac[6];     /* ETH_ALEN */
 };
diff --git a/net/core/filter.c b/net/core/filter.c
index 451b0ec7f2421..6a97a2aeabc10 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5803,6 +5803,12 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
 		struct fib_table *tb;
 
+		if (flags & BPF_FIB_LOOKUP_TBID) {
+			tbid = params->tbid;
+			/* zero out for vlan output */
+			params->tbid = 0;
+		}
+
 		tb = fib_get_table(net, tbid);
 		if (unlikely(!tb))
 			return BPF_FIB_LKUP_RET_NOT_FWDED;
@@ -5936,6 +5942,12 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
 		struct fib6_table *tb;
 
+		if (flags & BPF_FIB_LOOKUP_TBID) {
+			tbid = params->tbid;
+			/* zero out for vlan output */
+			params->tbid = 0;
+		}
+
 		tb = ipv6_stub->fib6_get_table(net, tbid);
 		if (unlikely(!tb))
 			return BPF_FIB_LKUP_RET_NOT_FWDED;
@@ -6008,7 +6020,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 #endif
 
 #define BPF_FIB_LOOKUP_MASK (BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT | \
-			     BPF_FIB_LOOKUP_SKIP_NEIGH)
+			     BPF_FIB_LOOKUP_SKIP_NEIGH | BPF_FIB_LOOKUP_TBID)
 
 BPF_CALL_4(bpf_xdp_fib_lookup, struct xdp_buff *, ctx,
 	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1bb11a6ee6676..6254eac48b185 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3167,6 +3167,10 @@ union bpf_attr {
  *		**BPF_FIB_LOOKUP_DIRECT**
  *			Do a direct table lookup vs full lookup using FIB
  *			rules.
+ *		**BPF_FIB_LOOKUP_TBID**
+ *			Used with BPF_FIB_LOOKUP_DIRECT.
+ *			Use the routing table ID present in *params*->tbid
+ *			for the fib lookup.
  *		**BPF_FIB_LOOKUP_OUTPUT**
  *			Perform lookup from an egress perspective (default is
  *			ingress).
@@ -6821,6 +6825,7 @@ enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
 	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
+	BPF_FIB_LOOKUP_TBID    = (1U << 3),
 };
 
 enum {
@@ -6881,9 +6886,19 @@ struct bpf_fib_lookup {
 		__u32		ipv6_dst[4];  /* in6_addr; network order */
 	};
 
-	/* output */
-	__be16	h_vlan_proto;
-	__be16	h_vlan_TCI;
+	union {
+		struct {
+			/* output */
+			__be16	h_vlan_proto;
+			__be16	h_vlan_TCI;
+		};
+		/* input: when accompanied with the
+		 * 'BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_TBID` flags, a
+		 * specific routing table to use for the fib lookup.
+		 */
+		__u32	tbid;
+	};
+
 	__u8	smac[6];     /* ETH_ALEN */
 	__u8	dmac[6];     /* ETH_ALEN */
 };

-- 
2.40.1


