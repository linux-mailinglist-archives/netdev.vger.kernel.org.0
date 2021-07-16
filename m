Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF263CB01F
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 02:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhGPAkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 20:40:25 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47160 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhGPAkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 20:40:22 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8EB45806B6;
        Fri, 16 Jul 2021 12:37:27 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1626395847;
        bh=CowyWUvzpCh9y/R1jbZYsayfadcPRDKitIhu4cUZRGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ENu4uv1mtMZNajaIx/514SUT4q1DWv9HjyxNPHcSKQ+FlDKSzgpUNZoXkwfe5snOu
         sYz0OMKn0l5aZTANYhktrGaIvffUZHWHv4GS1gSn8A3UOx8FzHr3Bt1Lr36En6FamS
         EnEJi+6ssSjPpBHf2rZ0ULqQaLWnDWfvJ0/8zqMHvq3xHeMClNhe/bXpTfcFyFfQEH
         WK1po5Wmc35jKOIbNuJpBgvNElA/N7wq/vshLR6AeFGW452mfwkKjTeS4CR4JKhMT3
         6JRH6mSOSt3WQTPFZF8qEV9G/uWjQExDfE5C+B54IDsCQP2YaLFG8JcodhhVAKw6v9
         Qrw6YyYfizgxQ==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60f0d4c70000>; Fri, 16 Jul 2021 12:37:27 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id 5D94F13EE58;
        Fri, 16 Jul 2021 12:37:27 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 5A5452428E7; Fri, 16 Jul 2021 12:37:27 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: [PATCH 1/3] net: netfilter: Add RFC-7597 Section 5.1 PSID support xtables API
Date:   Fri, 16 Jul 2021 12:27:40 +1200
Message-Id: <20210716002742.31078-2-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210716002742.31078-1-Cole.Dishington@alliedtelesis.co.nz>
References: <20210705103959.GG18022@breakpoint.cc>
 <20210716002742.31078-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Sr3uF8G0 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=3HDBlxybAAAA:8 a=mhPBjSskWxd-kjGSbREA:9 a=laEoCiVfU_Unz3mSdgXN:22
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for revision 2 of xtables masquerade extension.

Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
---
 include/uapi/linux/netfilter/nf_nat.h |  3 +-
 net/netfilter/xt_MASQUERADE.c         | 44 ++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/n=
etfilter/nf_nat.h
index a64586e77b24..660e53ffdb57 100644
--- a/include/uapi/linux/netfilter/nf_nat.h
+++ b/include/uapi/linux/netfilter/nf_nat.h
@@ -12,6 +12,7 @@
 #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
 #define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)
 #define NF_NAT_RANGE_NETMAP			(1 << 6)
+#define NF_NAT_RANGE_PSID			(1 << 7)
=20
 #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
 	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
@@ -20,7 +21,7 @@
 	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
 	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
 	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET | \
-	 NF_NAT_RANGE_NETMAP)
+	 NF_NAT_RANGE_NETMAP | NF_NAT_RANGE_PSID)
=20
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
diff --git a/net/netfilter/xt_MASQUERADE.c b/net/netfilter/xt_MASQUERADE.=
c
index eae05c178336..dc6870ca2b71 100644
--- a/net/netfilter/xt_MASQUERADE.c
+++ b/net/netfilter/xt_MASQUERADE.c
@@ -16,7 +16,7 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.=
org>");
 MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
=20
 /* FIXME: Multiple targets. --RR */
-static int masquerade_tg_check(const struct xt_tgchk_param *par)
+static int masquerade_tg_check_v0(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr =3D par->targinfo;
=20
@@ -31,8 +31,19 @@ static int masquerade_tg_check(const struct xt_tgchk_p=
aram *par)
 	return nf_ct_netns_get(par->net, par->family);
 }
=20
+static int masquerade_tg_check_v1(const struct xt_tgchk_param *par)
+{
+	const struct nf_nat_range2 *range =3D par->targinfo;
+
+	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
+		pr_debug("bad MAP_IPS.\n");
+		return -EINVAL;
+	}
+	return nf_ct_netns_get(par->net, par->family);
+}
+
 static unsigned int
-masquerade_tg(struct sk_buff *skb, const struct xt_action_param *par)
+masquerade_tg_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	struct nf_nat_range2 range;
 	const struct nf_nat_ipv4_multi_range_compat *mr;
@@ -46,6 +57,15 @@ masquerade_tg(struct sk_buff *skb, const struct xt_act=
ion_param *par)
 				      xt_out(par));
 }
=20
+static unsigned int
+masquerade_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct nf_nat_range2 *range =3D par->targinfo;
+
+	return nf_nat_masquerade_ipv4(skb, xt_hooknum(par), range,
+				      xt_out(par));
+}
+
 static void masquerade_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	nf_ct_netns_put(par->net, par->family);
@@ -73,6 +93,7 @@ static struct xt_target masquerade_tg_reg[] __read_most=
ly =3D {
 	{
 #if IS_ENABLED(CONFIG_IPV6)
 		.name		=3D "MASQUERADE",
+		.revision	=3D 0,
 		.family		=3D NFPROTO_IPV6,
 		.target		=3D masquerade_tg6,
 		.targetsize	=3D sizeof(struct nf_nat_range),
@@ -84,15 +105,28 @@ static struct xt_target masquerade_tg_reg[] __read_m=
ostly =3D {
 	}, {
 #endif
 		.name		=3D "MASQUERADE",
+		.revision	=3D 0,
 		.family		=3D NFPROTO_IPV4,
-		.target		=3D masquerade_tg,
+		.target		=3D masquerade_tg_v0,
 		.targetsize	=3D sizeof(struct nf_nat_ipv4_multi_range_compat),
 		.table		=3D "nat",
 		.hooks		=3D 1 << NF_INET_POST_ROUTING,
-		.checkentry	=3D masquerade_tg_check,
+		.checkentry	=3D masquerade_tg_check_v0,
 		.destroy	=3D masquerade_tg_destroy,
 		.me		=3D THIS_MODULE,
-	}
+	},
+	{
+		.name		=3D "MASQUERADE",
+		.revision	=3D 1,
+		.family		=3D NFPROTO_IPV4,
+		.target		=3D masquerade_tg_v1,
+		.targetsize	=3D sizeof(struct nf_nat_range2),
+		.table		=3D "nat",
+		.hooks		=3D 1 << NF_INET_POST_ROUTING,
+		.checkentry	=3D masquerade_tg_check_v1,
+		.destroy	=3D masquerade_tg_destroy,
+		.me		=3D THIS_MODULE,
+	},
 };
=20
 static int __init masquerade_tg_init(void)
--=20
2.32.0

