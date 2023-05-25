Return-Path: <netdev+bounces-5342-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD62710E55
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D96E28156A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A7A156FB;
	Thu, 25 May 2023 14:28:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC01156EE;
	Thu, 25 May 2023 14:28:07 +0000 (UTC)
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0BF197;
	Thu, 25 May 2023 07:28:05 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-62596e46d30so4866916d6.1;
        Thu, 25 May 2023 07:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685024884; x=1687616884;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vzx4YTH4CrsROXotPocM3SrgP03a73+lIvl02NYXgeo=;
        b=QvselHj3LD8fhX3fmPAxDggLienYOrsFvZRGFkTS3Yfhpe4jd1N682F2Ml9Zkt+cy3
         xwo7wpSSMihR1LZHzZYyEVHBRrhNohFJq43k0CE+1cbMeZme0e448JmK2ew0wWelGBte
         gUdTzx0ttPaKuoJBcqnTq1o067FDh8zzdIvUsTxg449tsZeNvjxLUiC6L2yVB0vJTi2h
         zIaQoK8+6rIwJdwgREJAU3UN4TMUT5n5SC9I2AZEaoPA4/gfi9n199RQA17kZPndwvtO
         oc7xfijgO0uMPwtmlfpou1smJSc8WtbsletMNMieHz21a02zE6wdOpYyQkNBj6TDJxr6
         I2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685024884; x=1687616884;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzx4YTH4CrsROXotPocM3SrgP03a73+lIvl02NYXgeo=;
        b=ihB29M084W4CJjY7OIvLGbMynU9yYE6mOfCc335aLZu0/a0w6+gNKDtglc5HA5Nw5q
         +YUwDAhcDqtql5jDbpGpABhVSMfmYcae6WyizBrc429A2qR9lUYO6fDjmbfNP4DcqePL
         TnRgKqVHZopGP/d40NlSS0cZeT3E7IwRsDdCr9RtEW2n6VVxIQxiYXEw3R9H6Br9g+7M
         drA60tB6ANKD3PJqKNZR2ivyKF8HsIJb6RU+MMAIKfgWsa8cBimn+q6F9A0Rwr/49j9w
         nXmK9TaU54pIJ5obkWj+o3ycE1LQTv8wHtXRiumqq8Fs75VQbHq1fWcDFWOQoxHUWsWS
         fu5Q==
X-Gm-Message-State: AC+VfDwSI0CZSZeiQBWAuEJGmxXfM6/wdR7t78jXSQTdllkogL08QEYe
	ooECjs01GY74JZ8+LI7+z3k=
X-Google-Smtp-Source: ACHHUZ4D8q/onSTV3UERTkwj6Mz5wtu+dr4hbmEDdCbczWfW63DT92yHe2RpVPS5VgfnFMb+N1uoGw==
X-Received: by 2002:a05:6214:27e3:b0:623:82ae:8a63 with SMTP id jt3-20020a05621427e300b0062382ae8a63mr1342956qvb.30.1685024884473;
        Thu, 25 May 2023 07:28:04 -0700 (PDT)
Received: from localhost (ool-944b8b4f.dyn.optonline.net. [148.75.139.79])
        by smtp.gmail.com with ESMTPSA id b10-20020a0cbf4a000000b006215f334a18sm442255qvj.28.2023.05.25.07.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:28:04 -0700 (PDT)
From: Louis DeLosSantos <louis.delos.devel@gmail.com>
Date: Thu, 25 May 2023 10:27:59 -0400
Subject: [PATCH 1/2] bpf: add table ID to bpf_fib_lookup BPF helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230505-bpf-add-tbid-fib-lookup-v1-1-fd99f7162e76@gmail.com>
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
In-Reply-To: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
To: bpf@vger.kernel.org, netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, 
 Stanislav Fomichev <sdf@google.com>, razor@blackwall.org, 
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

When the helper is called with the `BPF_FIB_LOOKUP_DIRECT` flag and the
`tbid` field in `struct bpf_fib_lookup` is greater then 0, the `tbid`
field will be used as the table ID for the fib lookup.

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
 include/uapi/linux/bpf.h       | 17 ++++++++++++++---
 net/core/filter.c              | 12 ++++++++++++
 tools/include/uapi/linux/bpf.h | 17 ++++++++++++++---
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1bb11a6ee6676..2096fbb328a9b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3167,6 +3167,8 @@ union bpf_attr {
  *		**BPF_FIB_LOOKUP_DIRECT**
  *			Do a direct table lookup vs full lookup using FIB
  *			rules.
+ *			If *params*->tbid is non-zero, this value designates
+ *			a routing table ID to perform the lookup against.
  *		**BPF_FIB_LOOKUP_OUTPUT**
  *			Perform lookup from an egress perspective (default is
  *			ingress).
@@ -6881,9 +6883,18 @@ struct bpf_fib_lookup {
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
+		/* input: when accompanied with the 'BPF_FIB_LOOKUP_DIRECT` flag, a
+		 * specific routing table to use for the fib lookup.
+		 */
+		__u32	tbid;
+	};
+
 	__u8	smac[6];     /* ETH_ALEN */
 	__u8	dmac[6];     /* ETH_ALEN */
 };
diff --git a/net/core/filter.c b/net/core/filter.c
index 451b0ec7f2421..6f710aa0a54b3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5803,6 +5803,12 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
 		struct fib_table *tb;
 
+		if (params->tbid) {
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
 
+		if (params->tbid) {
+			tbid = params->tbid;
+			/* zero out for vlan output */
+			params->tbid = 0;
+		}
+
 		tb = ipv6_stub->fib6_get_table(net, tbid);
 		if (unlikely(!tb))
 			return BPF_FIB_LKUP_RET_NOT_FWDED;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1bb11a6ee6676..2096fbb328a9b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3167,6 +3167,8 @@ union bpf_attr {
  *		**BPF_FIB_LOOKUP_DIRECT**
  *			Do a direct table lookup vs full lookup using FIB
  *			rules.
+ *			If *params*->tbid is non-zero, this value designates
+ *			a routing table ID to perform the lookup against.
  *		**BPF_FIB_LOOKUP_OUTPUT**
  *			Perform lookup from an egress perspective (default is
  *			ingress).
@@ -6881,9 +6883,18 @@ struct bpf_fib_lookup {
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
+		/* input: when accompanied with the 'BPF_FIB_LOOKUP_DIRECT` flag, a
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


