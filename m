Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E633371040
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 03:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhECBIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 21:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhECBIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 21:08:07 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEAEC061756
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 18:07:14 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 4D192891AD;
        Mon,  3 May 2021 13:07:07 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1620004027;
        bh=Upj5fwx1JyeJjRhrVdCKHBL0zq2UCEPpkflef9zgd4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=qCsWkP6uYO0/D1AweDjkDIjJTKSoQkZVjv03DIug72V3sCle/bvykCzzvdcuOvRCi
         wm2F+rIrzoSYdcbJR4dYH96s+qJ95T2vWdw8MHa4wZm91nSkEcW++Y2HmdjBC4WNLn
         WCrj4mjv27ivmkOWIVSI3hiunvrT2zsSbXwR0UA1Qv7JSaOXnkOv+s6ZHvd63YC+vD
         oW+aDFmBX34j+Fd7xL/nDuQ7Sn1firw604C3J5t6Efm2WqCK/5dMB74dJgCUfpROh/
         Buv81+muYdB6ZTnbZOwzukypjLPWeaY25MllXdmsk3vheA+Qb5oLWmUImfYyINkZRi
         JsAnJQbGNHLWw==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B608f4cba0000>; Mon, 03 May 2021 13:07:06 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id C689813EDFA;
        Mon,  3 May 2021 13:07:06 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id BAEC92429D0; Mon,  3 May 2021 13:07:06 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     fw@strlen.de
Cc:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v3] netfilter: nf_conntrack: Add conntrack helper for ESP/IPsec
Date:   Mon,  3 May 2021 13:06:39 +1200
Message-Id: <20210503010646.11111-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426123743.GB975@breakpoint.cc>
References: <20210426123743.GB975@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=B+jHL9lM c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=5FLXtPjwQuUA:10 a=yLMRYeITGAxbuLwtk9MA:9 a=dFeSxws7_yScpqrx:21
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce changes to add ESP connection tracking helper to netfilter
conntrack. The connection tracking of ESP is based on IPsec SPIs. The
underlying motivation for this patch was to allow multiple VPN ESP
clients to be distinguished when using NAT.

Added config flag CONFIG_NF_CT_PROTO_ESP to enable the ESP/IPsec
conntrack helper.

Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
---

Notes:
    Thanks for your time reviewing!
   =20
    Q.
    > +static int esp_tuple_to_nlattr(struct sk_buff *skb,
    > +                            const struct nf_conntrack_tuple *t)
    > +{
    > +     if (nla_put_be16(skb, CTA_PROTO_SRC_ESP_ID, t->src.u.esp.id) =
||
    > +         nla_put_be16(skb, CTA_PROTO_DST_ESP_ID, t->dst.u.esp.id))
    > +             goto nla_put_failure;
   =20
    This exposes the 16 bit kernel-generated IDs, right?
    Should this dump the real on-wire SPIs instead?
   =20
    Or is there are reason why the internal IDs need exposure?
   =20
    A.
    I think I need to expose the internal esp ids here due to esp_nlattr_=
to_tuple().
    If esp id was changed to real SPIs here I would be unable to lookup t=
he correct
    tuple (without IP addresses too).
   =20
    changes in v3:
    - Flush all esp entries for a given netns on nf_conntrack_proto_perne=
t_fini
    - Replace _esp_table (and its spinlock) shared over netns with per ne=
tns linked lists and bitmap (for esp ids)
    - Init IPv6 any address with IN6ADDR_ANY_INIT rather than ipv6_addr_s=
et()
    - Change l3num on hash key from u16 to u8
    - Add selftests file for testing tracker with ipv4 and ipv6
    - Removed credits

 .../linux/netfilter/nf_conntrack_proto_esp.h  |  23 +
 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |   3 +
 include/net/netfilter/nf_conntrack.h          |   6 +
 include/net/netfilter/nf_conntrack_l4proto.h  |  16 +
 include/net/netfilter/nf_conntrack_tuple.h    |   3 +
 include/net/netns/conntrack.h                 |  17 +
 .../netfilter/nf_conntrack_tuple_common.h     |   3 +
 .../linux/netfilter/nfnetlink_conntrack.h     |   2 +
 net/netfilter/Kconfig                         |  10 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/nf_conntrack_core.c             |  23 +
 net/netfilter/nf_conntrack_netlink.c          |   4 +-
 net/netfilter/nf_conntrack_proto.c            |  15 +
 net/netfilter/nf_conntrack_proto_esp.c        | 741 ++++++++++++++++++
 net/netfilter/nf_conntrack_standalone.c       |   8 +
 net/netfilter/nf_internals.h                  |   4 +-
 .../netfilter/conntrack_esp_related.sh        | 268 +++++++
 17 files changed, 1145 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/netfilter/nf_conntrack_proto_esp.h
 create mode 100644 net/netfilter/nf_conntrack_proto_esp.c
 create mode 100755 tools/testing/selftests/netfilter/conntrack_esp_relat=
ed.sh

diff --git a/include/linux/netfilter/nf_conntrack_proto_esp.h b/include/l=
inux/netfilter/nf_conntrack_proto_esp.h
new file mode 100644
index 000000000000..96888669edd7
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_proto_esp.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _CONNTRACK_PROTO_ESP_H
+#define _CONNTRACK_PROTO_ESP_H
+#include <asm/byteorder.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+/* ESP PROTOCOL HEADER */
+
+struct esphdr {
+	__u32 spi;
+};
+
+struct nf_ct_esp {
+	__u32 l_spi, r_spi;
+};
+
+void nf_ct_esp_pernet_flush(struct net *net);
+
+void destroy_esp_conntrack_entry(struct nf_conn *ct);
+
+bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		      struct net *net, struct nf_conntrack_tuple *tuple);
+#endif /* _CONNTRACK_PROTO_ESP_H */
diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net=
/netfilter/ipv4/nf_conntrack_ipv4.h
index 2c8c2b023848..1aee91592639 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -25,5 +25,8 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l=
4proto_udplite;
 #ifdef CONFIG_NF_CT_PROTO_GRE
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_esp;
+#endif
=20
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter=
/nf_conntrack.h
index 439379ca9ffa..4011be8c5e39 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -21,6 +21,7 @@
 #include <linux/netfilter/nf_conntrack_dccp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
+#include <linux/netfilter/nf_conntrack_proto_esp.h>
=20
 #include <net/netfilter/nf_conntrack_tuple.h>
=20
@@ -36,6 +37,7 @@ union nf_conntrack_proto {
 	struct ip_ct_tcp tcp;
 	struct nf_ct_udp udp;
 	struct nf_ct_gre gre;
+	struct nf_ct_esp esp;
 	unsigned int tmpl_padto;
 };
=20
@@ -47,6 +49,10 @@ struct nf_conntrack_net {
 	unsigned int users4;
 	unsigned int users6;
 	unsigned int users_bridge;
+
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	DECLARE_BITMAP(esp_id_map, 1024);
+#endif
 };
=20
 #include <linux/types.h>
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/n=
etfilter/nf_conntrack_l4proto.h
index 96f9cf81f46b..f700de0b9059 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -75,6 +75,8 @@ bool nf_conntrack_invert_icmp_tuple(struct nf_conntrack=
_tuple *tuple,
 				    const struct nf_conntrack_tuple *orig);
 bool nf_conntrack_invert_icmpv6_tuple(struct nf_conntrack_tuple *tuple,
 				      const struct nf_conntrack_tuple *orig);
+bool nf_conntrack_invert_esp_tuple(struct nf_conntrack_tuple *tuple,
+				   const struct nf_conntrack_tuple *orig);
=20
 int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
 			    unsigned int dataoff,
@@ -132,6 +134,11 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 			    unsigned int dataoff,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state);
+int nf_conntrack_esp_packet(struct nf_conn *ct,
+			    struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state);
=20
 void nf_conntrack_generic_init_net(struct net *net);
 void nf_conntrack_tcp_init_net(struct net *net);
@@ -141,6 +148,8 @@ void nf_conntrack_dccp_init_net(struct net *net);
 void nf_conntrack_sctp_init_net(struct net *net);
 void nf_conntrack_icmp_init_net(struct net *net);
 void nf_conntrack_icmpv6_init_net(struct net *net);
+int nf_conntrack_esp_init(void);
+void nf_conntrack_esp_init_net(struct net *net);
=20
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
@@ -240,4 +249,11 @@ static inline struct nf_gre_net *nf_gre_pernet(struc=
t net *net)
 }
 #endif
=20
+#ifdef CONFIG_NF_CT_PROTO_ESP
+static inline struct nf_esp_net *nf_esp_pernet(struct net *net)
+{
+	return &net->ct.nf_ct_proto.esp;
+}
+#endif
+
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/net=
filter/nf_conntrack_tuple.h
index 9334371c94e2..60279ffabe36 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -62,6 +62,9 @@ struct nf_conntrack_tuple {
 			struct {
 				__be16 key;
 			} gre;
+			struct {
+				__be16 id;
+			} esp;
 		} u;
=20
 		/* The protocol. */
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.=
h
index 806454e767bf..43cd1e78f790 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -69,6 +69,20 @@ struct nf_gre_net {
 };
 #endif
=20
+#ifdef CONFIG_NF_CT_PROTO_ESP
+enum esp_conntrack {
+	ESP_CT_UNREPLIED,
+	ESP_CT_REPLIED,
+	ESP_CT_MAX
+};
+
+struct nf_esp_net {
+	spinlock_t id_list_lock;
+	struct list_head id_list;
+	unsigned int esp_timeouts[ESP_CT_MAX];
+};
+#endif
+
 struct nf_ip_net {
 	struct nf_generic_net   generic;
 	struct nf_tcp_net	tcp;
@@ -84,6 +98,9 @@ struct nf_ip_net {
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	struct nf_gre_net	gre;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	struct nf_esp_net	esp;
+#endif
 };
=20
 struct ct_pcpu {
diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b/i=
nclude/uapi/linux/netfilter/nf_conntrack_tuple_common.h
index 64390fac6f7e..78600cb4bfff 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
@@ -39,6 +39,9 @@ union nf_conntrack_man_proto {
 	struct {
 		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
 	} gre;
+	struct {
+		__be16 id;
+	} esp;
 };
=20
 #define CTINFO2DIR(ctinfo) ((ctinfo) >=3D IP_CT_IS_REPLY ? IP_CT_DIR_REP=
LY : IP_CT_DIR_ORIGINAL)
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include=
/uapi/linux/netfilter/nfnetlink_conntrack.h
index d8484be72fdc..744d8931adeb 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -90,6 +90,8 @@ enum ctattr_l4proto {
 	CTA_PROTO_ICMPV6_ID,
 	CTA_PROTO_ICMPV6_TYPE,
 	CTA_PROTO_ICMPV6_CODE,
+	CTA_PROTO_SRC_ESP_ID,
+	CTA_PROTO_DST_ESP_ID,
 	__CTA_PROTO_MAX
 };
 #define CTA_PROTO_MAX (__CTA_PROTO_MAX - 1)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1a92063c73a4..7269312d322e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -199,6 +199,16 @@ config NF_CT_PROTO_UDPLITE
=20
 	  If unsure, say Y.
=20
+config NF_CT_PROTO_ESP
+	bool "ESP protocol support"
+	depends on NETFILTER_ADVANCED
+	help
+	  ESP connection tracking helper. Provides connection tracking for IPse=
c
+	  clients behind this device based on SPI, especially useful for
+	  distinguishing multiple clients when using NAT.
+
+	  If unsure, say N.
+
 config NF_CONNTRACK_AMANDA
 	tristate "Amanda backup protocol support"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 33da7bf1b68e..0942f2c48ddb 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -14,6 +14,7 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_LABELS) +=3D nf_conn=
track_labels.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_DCCP) +=3D nf_conntrack_proto_dccp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_SCTP) +=3D nf_conntrack_proto_sctp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_GRE) +=3D nf_conntrack_proto_gre.o
+nf_conntrack-$(CONFIG_NF_CT_PROTO_ESP) +=3D nf_conntrack_proto_esp.o
=20
 obj-$(CONFIG_NETFILTER) =3D netfilter.o
=20
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntra=
ck_core.c
index ff0168736f6e..3bef361d19ce 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -295,6 +295,10 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE:
 		return gre_pkt_to_tuple(skb, dataoff, net, tuple);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	case IPPROTO_ESP:
+		return esp_pkt_to_tuple(skb, dataoff, net, tuple);
 #endif
 	case IPPROTO_TCP:
 	case IPPROTO_UDP: /* fallthrough */
@@ -439,6 +443,10 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *invers=
e,
 #if IS_ENABLED(CONFIG_IPV6)
 	case IPPROTO_ICMPV6:
 		return nf_conntrack_invert_icmpv6_tuple(inverse, orig);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	case IPPROTO_ESP:
+		return nf_conntrack_invert_esp_tuple(inverse, orig);
 #endif
 	}
=20
@@ -593,6 +601,13 @@ static void destroy_gre_conntrack(struct nf_conn *ct=
)
 #endif
 }
=20
+static void destroy_esp_conntrack(struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	destroy_esp_conntrack_entry(ct);
+#endif
+}
+
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
@@ -609,6 +624,9 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (unlikely(nf_ct_protonum(ct) =3D=3D IPPROTO_GRE))
 		destroy_gre_conntrack(ct);
=20
+	if (unlikely(nf_ct_protonum(ct) =3D=3D IPPROTO_ESP))
+		destroy_esp_conntrack(ct);
+
 	local_bh_disable();
 	/* Expectations will have been removed in clean_from_lists,
 	 * except TFTP can create an expectation on the first packet,
@@ -1783,6 +1801,11 @@ static int nf_conntrack_handle_packet(struct nf_co=
nn *ct,
 	case IPPROTO_GRE:
 		return nf_conntrack_gre_packet(ct, skb, dataoff,
 					       ctinfo, state);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	case IPPROTO_ESP:
+		return nf_conntrack_esp_packet(ct, skb, dataoff,
+					       ctinfo, state);
 #endif
 	}
=20
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conn=
track_netlink.c
index 1d519b0e51a5..8df33dbbf5a3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1382,7 +1382,9 @@ static const struct nla_policy tuple_nla_policy[CTA=
_TUPLE_MAX+1] =3D {
    CTA_FILTER_F_CTA_PROTO_ICMP_ID | \
    CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE | \
    CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE | \
-   CTA_FILTER_F_CTA_PROTO_ICMPV6_ID)
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_ID | \
+   CTA_FILTER_F_CTA_PROTO_SRC_ESP_ID | \
+   CTA_FILTER_F_CTA_PROTO_DST_ESP_ID)
=20
 static int
 ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntr=
ack_proto.c
index 47e9319d2cf3..e71ddb4e33cc 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -112,6 +112,9 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find=
(u8 l4proto)
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE: return &nf_conntrack_l4proto_gre;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	case IPPROTO_ESP: return &nf_conntrack_l4proto_esp;
+#endif
 #if IS_ENABLED(CONFIG_IPV6)
 	case IPPROTO_ICMPV6: return &nf_conntrack_l4proto_icmpv6;
 #endif /* CONFIG_IPV6 */
@@ -656,6 +659,12 @@ int nf_conntrack_proto_init(void)
 		goto cleanup_sockopt;
 #endif
=20
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	ret =3D nf_conntrack_esp_init();
+	if (ret < 0)
+		goto cleanup_sockopt;
+#endif
+
 	return ret;
=20
 #if IS_ENABLED(CONFIG_IPV6)
@@ -691,6 +700,9 @@ void nf_conntrack_proto_pernet_init(struct net *net)
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	nf_conntrack_gre_init_net(net);
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	nf_conntrack_esp_init_net(net);
+#endif
 }
=20
 void nf_conntrack_proto_pernet_fini(struct net *net)
@@ -698,6 +710,9 @@ void nf_conntrack_proto_pernet_fini(struct net *net)
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	nf_ct_gre_keymap_flush(net);
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	nf_ct_esp_pernet_flush(net);
+#endif
 }
=20
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
diff --git a/net/netfilter/nf_conntrack_proto_esp.c b/net/netfilter/nf_co=
nntrack_proto_esp.c
new file mode 100644
index 000000000000..1bc0cb879bfd
--- /dev/null
+++ b/net/netfilter/nf_conntrack_proto_esp.c
@@ -0,0 +1,741 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * <:copyright-gpl
+ * Copyright 2008 Broadcom Corp. All Rights Reserved.
+ * Copyright (C) 2021 Allied Telesis Labs NZ
+ *
+ * This program is free software; you can distribute it and/or modify it
+ * under the terms of the GNU General Public License (Version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOU=
T
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License alo=
ng
+ * with this program.
+ * :>
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/timer.h>
+#include <linux/list.h>
+#include <linux/seq_file.h>
+#include <linux/in.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/dst.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_timeout.h>
+#include <linux/netfilter/nf_conntrack_proto_esp.h>
+#include <net/netns/hash.h>
+#include <linux/rhashtable.h>
+#include <net/ipv6.h>
+
+#include "nf_internals.h"
+
+/* esp_id of 0 is left for unassigned values */
+#define TEMP_SPI_START 1
+#define TEMP_SPI_MAX   (TEMP_SPI_START + 1024 - 1)
+
+struct _esp_entry {
+	/* linked list node for per net lookup via esp_id */
+	struct list_head net_node;
+
+       /* Hash table nodes for each required lookup
+	* lnode: net->hash_mix, l_spi, l_ip, r_ip
+	* rnode: net->hash_mix, r_spi, r_ip
+	* incmpl_rlist: net->hash_mix, r_ip
+	*/
+	struct rhash_head lnode;
+	struct rhash_head rnode;
+	struct rhlist_head incmpl_rlist;
+
+	u16 esp_id;
+
+	u16 l3num;
+
+	u32 l_spi;
+	u32 r_spi;
+
+	union nf_inet_addr l_ip;
+	union nf_inet_addr r_ip;
+
+	u32 alloc_time_jiffies;
+	struct net *net;
+};
+
+struct _esp_hkey {
+	u8 l3num;
+	union nf_inet_addr src_ip;
+	union nf_inet_addr dst_ip;
+	u32 net_hmix;
+	u32 spi;
+};
+
+extern unsigned int nf_conntrack_net_id;
+
+static struct rhashtable ltable;
+static struct rhashtable rtable;
+static struct rhltable incmpl_rtable;
+static unsigned int esp_timeouts[ESP_CT_MAX] =3D {
+	[ESP_CT_UNREPLIED] =3D 60 * HZ,
+	[ESP_CT_REPLIED] =3D 3600 * HZ,
+};
+
+static void esp_ip_addr_copy(int af, union nf_inet_addr *dst,
+			     const union nf_inet_addr *src)
+{
+	if (af =3D=3D AF_INET6)
+		dst->in6 =3D src->in6;
+	else
+		dst->ip =3D src->ip;
+}
+
+static int esp_ip_addr_equal(int af, const union nf_inet_addr *a,
+			     const union nf_inet_addr *b)
+{
+	if (af =3D=3D AF_INET6)
+		return ipv6_addr_equal(&a->in6, &b->in6);
+	return a->ip =3D=3D b->ip;
+}
+
+static inline struct nf_esp_net *esp_pernet(struct net *net)
+{
+	return &net->ct.nf_ct_proto.esp;
+}
+
+static inline void calculate_key(const u32 net_hmix, const u32 spi,
+				 const u8 l3num,
+				 const union nf_inet_addr *src_ip,
+				 const union nf_inet_addr *dst_ip,
+				 struct _esp_hkey *key)
+{
+	key->net_hmix =3D net_hmix;
+	key->spi =3D spi;
+	key->l3num =3D l3num;
+	esp_ip_addr_copy(l3num, &key->src_ip, src_ip);
+	esp_ip_addr_copy(l3num, &key->dst_ip, dst_ip);
+}
+
+static inline u32 calculate_hash(const void *data, u32 len, u32 seed)
+{
+	return jhash(data, len, seed);
+}
+
+static int ltable_obj_cmpfn(struct rhashtable_compare_arg *arg, const vo=
id *obj)
+{
+	struct _esp_hkey obj_key =3D {};
+	const struct _esp_hkey *key =3D (const struct _esp_hkey *)arg->key;
+	const struct _esp_entry *eobj =3D (const struct _esp_entry *)obj;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	calculate_key(net_hmix, eobj->l_spi, eobj->l3num, &eobj->l_ip,
+		      &eobj->r_ip, &obj_key);
+	return memcmp(key, &obj_key, sizeof(struct _esp_hkey));
+}
+
+static int rtable_obj_cmpfn(struct rhashtable_compare_arg *arg, const vo=
id *obj)
+{
+	const union nf_inet_addr any =3D { .in6 =3D IN6ADDR_ANY_INIT };
+	struct _esp_hkey obj_key =3D {};
+	const struct _esp_hkey *key =3D (const struct _esp_hkey *)arg->key;
+	const struct _esp_entry *eobj =3D (const struct _esp_entry *)obj;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	calculate_key(net_hmix, eobj->r_spi, eobj->l3num, &any, &eobj->r_ip,
+		      &obj_key);
+	return memcmp(key, &obj_key, sizeof(struct _esp_hkey));
+}
+
+static int incmpl_table_obj_cmpfn(struct rhashtable_compare_arg *arg, co=
nst void *obj)
+{
+	const union nf_inet_addr any =3D { .in6 =3D IN6ADDR_ANY_INIT };
+	struct _esp_hkey obj_key =3D {};
+	const struct _esp_hkey *key =3D (const struct _esp_hkey *)arg->key;
+	const struct _esp_entry *eobj =3D (const struct _esp_entry *)obj;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	calculate_key(net_hmix, 0, eobj->l3num, &any, &eobj->r_ip, &obj_key);
+	return memcmp(key, &obj_key, sizeof(struct _esp_hkey));
+}
+
+static u32 ltable_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	struct _esp_hkey key =3D {};
+	const struct _esp_entry *eobj =3D (const struct _esp_entry *)data;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	calculate_key(net_hmix, eobj->l_spi, eobj->l3num, &eobj->l_ip,
+		      &eobj->r_ip, &key);
+	return calculate_hash(&key, len, seed);
+}
+
+static u32 rtable_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const union nf_inet_addr any =3D { .in6 =3D IN6ADDR_ANY_INIT };
+	struct _esp_hkey key =3D {};
+	const struct _esp_entry *eobj =3D (const struct _esp_entry *)data;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	calculate_key(net_hmix, eobj->r_spi, eobj->l3num, &any, &eobj->r_ip, &k=
ey);
+	return calculate_hash(&key, len, seed);
+}
+
+static u32 incmpl_table_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const union nf_inet_addr any =3D { .in6 =3D IN6ADDR_ANY_INIT };
+	struct _esp_hkey key =3D {};
+	const struct _esp_entry *eobj =3D (const struct _esp_entry *)data;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	calculate_key(net_hmix, 0, eobj->l3num, &any, &eobj->r_ip, &key);
+	return calculate_hash(&key, len, seed);
+}
+
+static const struct rhashtable_params ltable_params =3D {
+	.key_len     =3D sizeof(struct _esp_hkey),
+	.head_offset =3D offsetof(struct _esp_entry, lnode),
+	.hashfn      =3D calculate_hash,
+	.obj_hashfn =3D ltable_obj_hashfn,
+	.obj_cmpfn   =3D ltable_obj_cmpfn,
+};
+
+static const struct rhashtable_params rtable_params =3D {
+	.key_len     =3D sizeof(struct _esp_hkey),
+	.head_offset =3D offsetof(struct _esp_entry, rnode),
+	.hashfn      =3D calculate_hash,
+	.obj_hashfn =3D rtable_obj_hashfn,
+	.obj_cmpfn   =3D rtable_obj_cmpfn,
+};
+
+static const struct rhashtable_params incmpl_rtable_params =3D {
+	.key_len     =3D sizeof(struct _esp_hkey),
+	.head_offset =3D offsetof(struct _esp_entry, incmpl_rlist),
+	.hashfn      =3D calculate_hash,
+	.obj_hashfn =3D incmpl_table_obj_hashfn,
+	.obj_cmpfn   =3D incmpl_table_obj_cmpfn,
+};
+
+int nf_conntrack_esp_init(void)
+{
+	int ret;
+
+	ret =3D rhashtable_init(&ltable, &ltable_params);
+	if (ret)
+		return ret;
+
+	ret =3D rhashtable_init(&rtable, &rtable_params);
+	if (ret)
+		goto err_free_ltable;
+
+	ret =3D rhltable_init(&incmpl_rtable, &incmpl_rtable_params);
+	if (ret)
+		goto err_free_rtable;
+
+	return ret;
+
+err_free_rtable:
+	rhashtable_destroy(&rtable);
+err_free_ltable:
+	rhashtable_destroy(&ltable);
+
+	return ret;
+}
+
+void nf_conntrack_esp_init_net(struct net *net)
+{
+	int i;
+	struct nf_esp_net *net_esp =3D esp_pernet(net);
+
+	spin_lock_init(&net_esp->id_list_lock);
+	INIT_LIST_HEAD(&net_esp->id_list);
+
+	for (i =3D 0; i < ESP_CT_MAX; i++)
+		net_esp->esp_timeouts[i] =3D esp_timeouts[i];
+}
+
+static struct _esp_entry *find_esp_entry_by_id(struct nf_esp_net *esp_ne=
t, int esp_id)
+{
+	struct list_head *pos, *head;
+	struct _esp_entry *esp_entry;
+
+	head =3D &esp_net->id_list;
+	list_for_each(pos, head) {
+		esp_entry =3D list_entry(pos, struct _esp_entry, net_node);
+		if (esp_entry->esp_id =3D=3D esp_id)
+			return esp_entry;
+	}
+	return NULL;
+}
+
+static void free_esp_entry(struct nf_conntrack_net *cnet, struct _esp_en=
try *esp_entry)
+{
+	if (esp_entry) {
+		/* Remove from all the hash tables */
+		pr_debug("Removing entry %x from all tables", esp_entry->esp_id);
+		list_del(&esp_entry->net_node);
+		rhashtable_remove_fast(&ltable, &esp_entry->lnode, ltable_params);
+		rhashtable_remove_fast(&rtable, &esp_entry->rnode, rtable_params);
+		rhltable_remove(&incmpl_rtable, &esp_entry->incmpl_rlist, incmpl_rtabl=
e_params);
+		clear_bit(esp_entry->esp_id - TEMP_SPI_START, cnet->esp_id_map);
+		kfree(esp_entry);
+	}
+}
+
+/* Free an entry referred to by esp_id.
+ *
+ * NOTE:
+ * Per net linked list locking and unlocking is the responsibility of th=
e calling function.
+ * Range checking is the responsibility of the calling function.
+ */
+static void free_esp_entry_by_id(struct net *net, int esp_id)
+{
+	struct nf_esp_net *esp_net =3D esp_pernet(net);
+	struct nf_conntrack_net *cnet =3D net_generic(net, nf_conntrack_net_id)=
;
+	struct _esp_entry *esp_entry =3D find_esp_entry_by_id(esp_net, esp_id);
+
+	free_esp_entry(cnet, esp_entry);
+}
+
+/* Allocate the first available IPSEC table entry.
+ * NOTE: This function may block on per net list lock.
+ */
+struct _esp_entry *alloc_esp_entry(struct net *net)
+{
+	struct nf_conntrack_net *cnet =3D net_generic(net, nf_conntrack_net_id)=
;
+	struct nf_esp_net *esp_net =3D esp_pernet(net);
+	struct _esp_entry *esp_entry;
+	int id;
+
+again:
+	id =3D find_first_zero_bit(cnet->esp_id_map, 1024);
+	if (id >=3D 1024)
+		return NULL;
+
+	if (test_and_set_bit(id, cnet->esp_id_map))
+		goto again; /* raced */
+
+	esp_entry =3D kmalloc(sizeof(*esp_entry), GFP_ATOMIC);
+	if (!esp_entry) {
+		clear_bit(id, cnet->esp_id_map);
+		return NULL;
+	}
+
+	esp_entry->esp_id =3D id + TEMP_SPI_START;
+	esp_entry->alloc_time_jiffies =3D nfct_time_stamp;
+	esp_entry->net =3D net;
+
+	spin_lock(&esp_net->id_list_lock);
+	list_add(&esp_entry->net_node, &esp_net->id_list);
+	spin_unlock(&esp_net->id_list_lock);
+
+	return esp_entry;
+}
+
+/* Search for an ESP entry in the initial state based on the IP address =
of
+ * the remote peer.
+ */
+static struct _esp_entry *search_esp_entry_init_remote(struct net *net,
+						       u16 l3num,
+						       const union nf_inet_addr *src_ip)
+{
+	const union nf_inet_addr any =3D { .in6 =3D IN6ADDR_ANY_INIT };
+	u32 net_hmix =3D net_hash_mix(net);
+	struct _esp_entry *first_esp_entry =3D NULL;
+	struct _esp_entry *esp_entry;
+	struct _esp_hkey key =3D {};
+	struct rhlist_head *pos, *list;
+
+	calculate_key(net_hmix, 0, l3num, &any, src_ip, &key);
+	list =3D rhltable_lookup(&incmpl_rtable, (const void *)&key, incmpl_rta=
ble_params);
+	rhl_for_each_entry_rcu(esp_entry, pos, list, incmpl_rlist) {
+		if (net_eq(net, esp_entry->net) &&
+		    l3num =3D=3D esp_entry->l3num &&
+		    esp_ip_addr_equal(l3num, src_ip, &esp_entry->r_ip)) {
+			if (!first_esp_entry) {
+				first_esp_entry =3D esp_entry;
+			} else if (first_esp_entry->alloc_time_jiffies - esp_entry->alloc_tim=
e_jiffies <=3D 0) {
+				/* This entry is older than the last one found so treat this
+				 * as a better match.
+				 */
+				first_esp_entry =3D esp_entry;
+			}
+		}
+	}
+
+	if (first_esp_entry) {
+		if (first_esp_entry->l3num =3D=3D AF_INET) {
+			pr_debug("Matches incmpl_rtable entry %x with l_spi %x r_ip %pI4\n",
+				 first_esp_entry->esp_id, first_esp_entry->l_spi,
+				 &first_esp_entry->r_ip.in);
+		} else {
+			pr_debug("Matches incmpl_rtable entry %x with l_spi %x r_ip %pI6\n",
+				 first_esp_entry->esp_id, first_esp_entry->l_spi,
+				 &first_esp_entry->r_ip.in6);
+		}
+	}
+
+	return first_esp_entry;
+}
+
+/* Search for an ESP entry by SPI, source and destination IP addresses.
+ * NOTE: This function may block on per net list lock.
+ */
+static struct _esp_entry *search_esp_entry_by_spi(struct net *net, const=
 __u32 spi,
+						  u16 l3num,
+						  const union nf_inet_addr *src_ip,
+						  const union nf_inet_addr *dst_ip)
+{
+	const union nf_inet_addr any =3D { .in6 =3D IN6ADDR_ANY_INIT };
+	u32 net_hmix =3D net_hash_mix(net);
+	struct _esp_entry *esp_entry;
+	struct _esp_hkey key =3D {};
+
+	/* Check for matching established session or repeated initial LAN side =
*/
+	/* LAN side first */
+	calculate_key(net_hmix, spi, l3num, src_ip, dst_ip, &key);
+	esp_entry =3D rhashtable_lookup_fast(&ltable, (const void *)&key, ltabl=
e_params);
+	if (esp_entry) {
+		/* When r_spi is set this is an established session. When not set it's
+		 * a repeated initial packet from LAN side. But both cases are treated
+		 * the same.
+		 */
+		if (esp_entry->l3num =3D=3D AF_INET) {
+			pr_debug("Matches ltable entry %x with l_spi %x l_ip %pI4 r_ip %pI4\n=
",
+				 esp_entry->esp_id, esp_entry->l_spi,
+				 &esp_entry->l_ip.in, &esp_entry->r_ip.in);
+		} else {
+			pr_debug("Matches ltable entry %x with l_spi %x l_ip %pI6 r_ip %pI6\n=
",
+				 esp_entry->esp_id, esp_entry->l_spi,
+				 &esp_entry->l_ip.in6, &esp_entry->r_ip.in6);
+		}
+		return esp_entry;
+	}
+
+	/* Established remote side */
+	calculate_key(net_hmix, spi, l3num, &any, src_ip, &key);
+	esp_entry =3D rhashtable_lookup_fast(&rtable, (const void *)&key, rtabl=
e_params);
+	if (esp_entry) {
+		if (esp_entry->l3num =3D=3D AF_INET) {
+			pr_debug("Matches rtable entry %x with l_spi %x r_spi %x l_ip %pI4 r_=
ip %pI4\n",
+				 esp_entry->esp_id, esp_entry->l_spi, esp_entry->r_spi,
+				 &esp_entry->l_ip.in, &esp_entry->r_ip.in);
+		} else {
+			pr_debug("Matches rtable entry %x with l_spi %x r_spi %x l_ip %pI6 r_=
ip %pI6\n",
+				 esp_entry->esp_id, esp_entry->l_spi, esp_entry->r_spi,
+				 &esp_entry->l_ip.in6, &esp_entry->r_ip.in6);
+		}
+		return esp_entry;
+	}
+
+	/* Incomplete remote side, check if packet has a missing r_spi */
+	esp_entry =3D search_esp_entry_init_remote(net, l3num, src_ip);
+	if (esp_entry) {
+		int err;
+
+		esp_entry->r_spi =3D spi;
+		/* Remove entry from incmpl_rtable and add to rtable */
+		rhltable_remove(&incmpl_rtable, &esp_entry->incmpl_rlist, incmpl_rtabl=
e_params);
+		/* Error will not be due to duplicate as established remote side looku=
p
+		 * above would have found it. Delete entry.
+		 */
+		err =3D rhashtable_insert_fast(&rtable, &esp_entry->rnode, rtable_para=
ms);
+		if (err) {
+			struct nf_esp_net *esp_net =3D esp_pernet(net);
+
+			spin_lock(&esp_net->id_list_lock);
+			free_esp_entry_by_id(net, esp_entry->esp_id);
+			spin_unlock(&esp_net->id_list_lock);
+			return NULL;
+		}
+		return esp_entry;
+	}
+
+	if (l3num =3D=3D AF_INET) {
+		pr_debug("No entry matches for spi %x src_ip %pI4 dst_ip %pI4\n",
+			 spi, &src_ip->in, &dst_ip->in);
+	} else {
+		pr_debug("No entry matches for spi %x src_ip %pI6 dst_ip %pI6\n",
+			 spi, &src_ip->in6, &dst_ip->in6);
+	}
+	return NULL;
+}
+
+/* invert esp part of tuple */
+bool nf_conntrack_invert_esp_tuple(struct nf_conntrack_tuple *tuple,
+				   const struct nf_conntrack_tuple *orig)
+{
+	tuple->dst.u.esp.id =3D orig->dst.u.esp.id;
+	tuple->src.u.esp.id =3D orig->src.u.esp.id;
+	return true;
+}
+
+/* esp hdr info to tuple */
+bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		      struct net *net, struct nf_conntrack_tuple *tuple)
+{
+	struct esphdr _esphdr, *esphdr;
+	struct _esp_entry *esp_entry;
+	u32 spi;
+
+	esphdr =3D skb_header_pointer(skb, dataoff, sizeof(_esphdr), &_esphdr);
+	if (!esphdr) {
+		/* try to behave like "nf_conntrack_proto_generic" */
+		tuple->src.u.all =3D 0;
+		tuple->dst.u.all =3D 0;
+		return true;
+	}
+	spi =3D ntohl(esphdr->spi);
+
+	/* Check if esphdr already associated with a pre-existing connection:
+	 *   if no, create a new connection, missing the r_spi;
+	 *   if yes, check if we have seen the source IP:
+	 *             if no, fill in r_spi in the pre-existing connection.
+	 */
+	esp_entry =3D search_esp_entry_by_spi(net, spi, tuple->src.l3num,
+					    &tuple->src.u3, &tuple->dst.u3);
+	if (!esp_entry) {
+		struct _esp_hkey key =3D {};
+		const union nf_inet_addr any =3D { .in6 =3D IN6ADDR_ANY_INIT };
+		u32 net_hmix =3D net_hash_mix(net);
+		struct nf_esp_net *esp_net =3D esp_pernet(net);
+		struct _esp_entry *esp_entry_old;
+		int err;
+
+		esp_entry =3D alloc_esp_entry(net);
+		if (!esp_entry) {
+			pr_debug("All esp connection slots in use\n");
+			return false;
+		}
+		esp_entry->l_spi =3D spi;
+		esp_entry->l3num =3D tuple->src.l3num;
+		esp_ip_addr_copy(esp_entry->l3num, &esp_entry->l_ip, &tuple->src.u3);
+		esp_ip_addr_copy(esp_entry->l3num, &esp_entry->r_ip, &tuple->dst.u3);
+
+		/* Add entries to the hash tables */
+
+		calculate_key(net_hmix, esp_entry->l_spi, esp_entry->l3num, &esp_entry=
->l_ip,
+			      &esp_entry->r_ip, &key);
+		esp_entry_old =3D rhashtable_lookup_get_insert_key(&ltable, &key, &esp=
_entry->lnode,
+								 ltable_params);
+		if (esp_entry_old) {
+			spin_lock(&esp_net->id_list_lock);
+
+			if (IS_ERR(esp_entry_old)) {
+				free_esp_entry_by_id(net, esp_entry->esp_id);
+				spin_unlock(&esp_net->id_list_lock);
+				return false;
+			}
+
+			free_esp_entry_by_id(net, esp_entry->esp_id);
+			spin_unlock(&esp_net->id_list_lock);
+
+			/* insertion raced, use existing entry */
+			esp_entry =3D esp_entry_old;
+		}
+		/* esp_entry_old =3D=3D NULL -- insertion successful */
+
+		calculate_key(net_hmix, 0, esp_entry->l3num, &any, &esp_entry->r_ip, &=
key);
+		err =3D rhltable_insert_key(&incmpl_rtable, (const void *)&key,
+					  &esp_entry->incmpl_rlist, incmpl_rtable_params);
+		if (err) {
+			spin_lock(&esp_net->id_list_lock);
+			free_esp_entry_by_id(net, esp_entry->esp_id);
+			spin_unlock(&esp_net->id_list_lock);
+			return false;
+		}
+
+		if (esp_entry->l3num =3D=3D AF_INET) {
+			pr_debug("New entry %x with l_spi %x l_ip %pI4 r_ip %pI4\n",
+				 esp_entry->esp_id, esp_entry->l_spi,
+				 &esp_entry->l_ip.in, &esp_entry->r_ip.in);
+		} else {
+			pr_debug("New entry %x with l_spi %x l_ip %pI6 r_ip %pI6\n",
+				 esp_entry->esp_id, esp_entry->l_spi,
+				 &esp_entry->l_ip.in6, &esp_entry->r_ip.in6);
+		}
+	}
+
+	tuple->dst.u.esp.id =3D esp_entry->esp_id;
+	tuple->src.u.esp.id =3D esp_entry->esp_id;
+	return true;
+}
+
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
+/* print private data for conntrack */
+static void esp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
+{
+	seq_printf(s, "l_spi=3D%x, r_spi=3D%x ", ct->proto.esp.l_spi, ct->proto=
.esp.r_spi);
+}
+#endif
+
+/* Returns verdict for packet, and may modify conntrack */
+int nf_conntrack_esp_packet(struct nf_conn *ct, struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state)
+{
+	int esp_id;
+	struct nf_conntrack_tuple *tuple;
+	unsigned int *timeouts =3D nf_ct_timeout_lookup(ct);
+	struct nf_esp_net *esp_net =3D esp_pernet(nf_ct_net(ct));
+
+	if (!timeouts)
+		timeouts =3D esp_net->esp_timeouts;
+
+	/* If we've seen traffic both ways, this is some kind of ESP
+	 * stream.  Extend timeout.
+	 */
+	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[ESP_CT_REPLIED]);
+		/* Also, more likely to be important, and not a probe */
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status)) {
+			/* Was originally IPCT_STATUS but this is no longer an option.
+			 * GRE uses assured for same purpose
+			 */
+			nf_conntrack_event_cache(IPCT_ASSURED, ct);
+
+			/* Retrieve SPIs of original and reply from esp_entry.
+			 * Both directions should contain the same esp_entry,
+			 * so just check the first one.
+			 */
+			tuple =3D nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL);
+
+			esp_id =3D tuple->src.u.esp.id;
+			if (esp_id >=3D TEMP_SPI_START && esp_id <=3D TEMP_SPI_MAX) {
+				struct _esp_entry *esp_entry;
+
+				spin_lock(&esp_net->id_list_lock);
+				esp_entry =3D find_esp_entry_by_id(esp_net, esp_id);
+				spin_unlock(&esp_net->id_list_lock);
+
+				if (esp_entry) {
+					ct->proto.esp.l_spi =3D esp_entry->l_spi;
+					ct->proto.esp.r_spi =3D esp_entry->r_spi;
+				}
+			}
+		}
+	} else {
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[ESP_CT_UNREPLIED]);
+	}
+
+	return NF_ACCEPT;
+}
+
+void nf_ct_esp_pernet_flush(struct net *net)
+{
+	struct nf_conntrack_net *cnet =3D net_generic(net, nf_conntrack_net_id)=
;
+	struct nf_esp_net *esp_net =3D esp_pernet(net);
+	struct list_head *pos, *tmp, *head =3D &esp_net->id_list;
+	struct _esp_entry *esp_entry;
+
+	spin_lock(&esp_net->id_list_lock);
+	list_for_each_safe(pos, tmp, head) {
+		esp_entry =3D list_entry(pos, struct _esp_entry, net_node);
+		free_esp_entry(cnet, esp_entry);
+	}
+	spin_unlock(&esp_net->id_list_lock);
+}
+
+/* Called when a conntrack entry has already been removed from the hashe=
s
+ * and is about to be deleted from memory
+ */
+void destroy_esp_conntrack_entry(struct nf_conn *ct)
+{
+	struct nf_conntrack_tuple *tuple;
+	enum ip_conntrack_dir dir;
+	int esp_id;
+	struct net *net =3D nf_ct_net(ct);
+	struct nf_esp_net *esp_net =3D esp_pernet(net);
+
+	/* Probably all the ESP entries referenced in this connection are the s=
ame,
+	 * but the free function handles repeated frees, so best to do them all=
.
+	 */
+	for (dir =3D IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
+		tuple =3D nf_ct_tuple(ct, dir);
+
+		spin_lock(&esp_net->id_list_lock);
+
+		esp_id =3D tuple->src.u.esp.id;
+		if (esp_id >=3D TEMP_SPI_START && esp_id <=3D TEMP_SPI_MAX)
+			free_esp_entry_by_id(net, esp_id);
+		tuple->src.u.esp.id =3D 0;
+
+		esp_id =3D tuple->dst.u.esp.id;
+		if (esp_id >=3D TEMP_SPI_START && esp_id <=3D TEMP_SPI_MAX)
+			free_esp_entry_by_id(net, esp_id);
+		tuple->dst.u.esp.id =3D 0;
+
+		spin_unlock(&esp_net->id_list_lock);
+	}
+}
+
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int esp_tuple_to_nlattr(struct sk_buff *skb,
+			       const struct nf_conntrack_tuple *t)
+{
+	if (nla_put_be16(skb, CTA_PROTO_SRC_ESP_ID, t->src.u.esp.id) ||
+	    nla_put_be16(skb, CTA_PROTO_DST_ESP_ID, t->dst.u.esp.id))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nla_policy esp_nla_policy[CTA_PROTO_MAX + 1] =3D {
+	[CTA_PROTO_SRC_ESP_ID] =3D { .type =3D NLA_U16 },
+	[CTA_PROTO_DST_ESP_ID] =3D { .type =3D NLA_U16 },
+};
+
+static int esp_nlattr_to_tuple(struct nlattr *tb[],
+			       struct nf_conntrack_tuple *t,
+			       u32 flags)
+{
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_ESP_ID)) {
+		if (!tb[CTA_PROTO_SRC_ESP_ID])
+			return -EINVAL;
+
+		t->src.u.esp.id =3D nla_get_be16(tb[CTA_PROTO_SRC_ESP_ID]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_DST_ESP_ID)) {
+		if (!tb[CTA_PROTO_DST_ESP_ID])
+			return -EINVAL;
+
+		t->dst.u.esp.id =3D nla_get_be16(tb[CTA_PROTO_DST_ESP_ID]);
+	}
+
+	return 0;
+}
+
+static unsigned int esp_nlattr_tuple_size(void)
+{
+	return nla_policy_len(esp_nla_policy, CTA_PROTO_MAX + 1);
+}
+#endif
+
+/* protocol helper struct */
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_esp =3D {
+	.l4proto =3D IPPROTO_ESP,
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
+	.print_conntrack =3D esp_print_conntrack,
+#endif
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.tuple_to_nlattr =3D esp_tuple_to_nlattr,
+	.nlattr_tuple_size =3D esp_nlattr_tuple_size,
+	.nlattr_to_tuple =3D esp_nlattr_to_tuple,
+	.nla_policy =3D esp_nla_policy,
+#endif
+};
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_c=
onntrack_standalone.c
index c6c0cb465664..7922ff6cf5a4 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -88,6 +88,14 @@ print_tuple(struct seq_file *s, const struct nf_conntr=
ack_tuple *tuple,
 			   ntohs(tuple->src.u.gre.key),
 			   ntohs(tuple->dst.u.gre.key));
 		break;
+	case IPPROTO_ESP:
+		/* Both src and dest esp.id should be equal but showing both
+		 * will help find errors.
+		 */
+		seq_printf(s, "srcid=3D0x%x dstid=3D0x%x ",
+			   ntohs(tuple->src.u.esp.id),
+			   ntohs(tuple->dst.u.esp.id));
+		break;
 	default:
 		break;
 	}
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 832ae64179f0..4fd8956aec65 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -19,7 +19,9 @@
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE	(1 << 9)
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE	(1 << 10)
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_ID	(1 << 11)
-#define CTA_FILTER_F_MAX			(1 << 12)
+#define CTA_FILTER_F_CTA_PROTO_SRC_ESP_ID	(1 << 12)
+#define CTA_FILTER_F_CTA_PROTO_DST_ESP_ID	(1 << 13)
+#define CTA_FILTER_F_MAX			(1 << 14)
 #define CTA_FILTER_F_ALL			(CTA_FILTER_F_MAX-1)
 #define CTA_FILTER_FLAG(ctattr) CTA_FILTER_F_ ## ctattr
=20
diff --git a/tools/testing/selftests/netfilter/conntrack_esp_related.sh b=
/tools/testing/selftests/netfilter/conntrack_esp_related.sh
new file mode 100755
index 000000000000..88b0f164664f
--- /dev/null
+++ b/tools/testing/selftests/netfilter/conntrack_esp_related.sh
@@ -0,0 +1,268 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# <:copyright-gpl
+# Copyright (C) 2021 Allied Telesis Labs NZ
+#
+# check that related ESP connections are tracked via spi.
+#
+# Setup is:
+#
+# nsclient3(veth0) -> (veth2)
+#                            (br0)nsrouter1(veth1) -> (veth1)nsrouter2 -=
> (veth0)nsclient2
+# nsclient1(veth0) -> (veth0)
+# Setup xfrm esp connections for IPv4 and IPv6 and check they are tracke=
d.
+#
+# In addition, nsrouter1 will perform IP masquerading. If nsrouter1 does=
 not support esp
+# connection tracking, it will be unable to tell the difference between =
packets from nsclient2 to
+# either nsclient1 or nsclient3.
+#
+# ESP connections (for IPv6) need to use tunnel mode, as ICMPv6 computes=
 checksum over encapsulating
+# IP header addresses.
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=3D4
+ret=3D0
+ns_all=3D"nsclient1 nsclient3 nsrouter1 nsrouter2 nsclient2"
+
+conntrack -V > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without conntrack tool"
+	exit $ksft_skip
+fi
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+ipv4() {
+	echo -n 192.168.$1.$2
+}
+
+ipv6 () {
+	echo -n dead:$1::$2
+}
+
+cleanup() {
+	for n in $ns_all; do ip netns del $n;done
+}
+
+check_counter()
+{
+	local ns_name=3D$1
+	local name=3D"unknown"
+	local expect=3D"packets 0 bytes 0"
+	local lret=3D0
+
+	cnt=3D$(ip netns exec $ns_name nft list counter inet filter "$name" | g=
rep -q "$expect")
+	if [ $? -ne 0 ]; then
+		echo "ERROR: counter $name in $ns_name has unexpected value (expected =
$expect)" 1>&2
+		ip netns exec $ns_name nft list counter inet filter "$name" 1>&2
+		lret=3D1
+	fi
+	return $lret
+}
+
+check_unknown()
+{
+	for n in nsrouter1 nsrouter2; do
+		check_counter $n
+		if [ $? -ne 0 ] ;then
+			return 1
+		fi
+	done
+	return 0
+}
+
+check_conntrack()
+{
+	local ret=3D0
+
+	for p in ipv4 ipv6; do
+		cnt=3D$(ip netns exec nsrouter1 conntrack -f $p -L 2>&1)
+		# Check tracked connection was esp by port (conntrack shows unknown at=
 the moment)
+		local num=3D$(echo -e "$cnt" | grep -cE "[a-zA-Z]+ +50")
+		if [ $? -ne 0 ] || [ "x$num" !=3D "x2" ]; then
+			echo -e "ERROR: expect to see two conntrack esp flows for $p:\n $cnt"=
 1>&2
+			ret=3D1
+		fi
+	done
+	return $ret
+}
+
+for n in $ns_all; do
+	ip netns add $n
+	ip -net $n link set lo up
+done
+
+ip link add veth0 netns nsclient1 type veth peer name veth0 netns nsrout=
er1
+ip link add veth0 netns nsclient3 type veth peer name veth2 netns nsrout=
er1
+ip link add br0 netns nsrouter1 type bridge
+ip -net nsrouter1 link set veth0 master br0
+ip -net nsrouter1 link set veth2 master br0
+ip link add veth1 netns nsrouter1 type veth peer name veth1 netns nsrout=
er2
+ip link add veth0 netns nsrouter2 type veth peer name veth0 netns nsclie=
nt2
+
+for n in $ns_all; do
+	ip -net $n link set veth0 up
+done
+ip -net nsrouter1 link set veth1 up
+ip -net nsrouter1 link set veth2 up
+ip -net nsrouter1 link set br0 up
+ip -net nsrouter2 link set veth1 up
+
+for i in 1 2; do
+	ip -net nsclient$i addr add $(ipv4 $i 2)/24 dev veth0
+	ip -net nsclient$i addr add $(ipv6 $i 2)/64 dev veth0
+	ip -net nsclient$i route add default via $(ipv4 $i 1)
+	ip -net nsclient$i -6 route add default via $(ipv6 $i 1)
+
+	ip -net nsrouter$i addr add $(ipv4 3 $i)/24 dev veth1
+	ip -net nsrouter$i addr add $(ipv6 3 $i)/64 dev veth1
+done
+ip -net nsrouter1 addr add $(ipv4 1 1)/24 dev br0
+ip -net nsrouter1 addr add $(ipv6 1 1)/64 dev br0
+ip -net nsrouter2 addr add $(ipv4 2 1)/24 dev veth0
+ip -net nsrouter2 addr add $(ipv6 2 1)/64 dev veth0
+
+ip -net nsclient3 addr add $(ipv4 1 3)/24 dev veth0
+ip -net nsclient3 addr add $(ipv6 1 3)/64 dev veth0
+ip -net nsclient3 route add default via $(ipv4 1 1)
+ip -net nsclient3 -6 route add default via $(ipv6 1 1)
+
+ip -net nsrouter1 route add default via $(ipv4 3 2)
+ip -net nsrouter1 -6 route add default via $(ipv6 3 2)
+ip -net nsrouter2 route add default via $(ipv4 3 1)
+ip -net nsrouter2 -6 route add default via $(ipv6 3 1)
+
+for i in 1 2; do
+	ip netns exec nsrouter$i sysctl -q net.ipv4.conf.all.forwarding=3D1
+	ip netns exec nsrouter$i sysctl -q net.ipv6.conf.all.forwarding=3D1
+done
+
+for i in 1 2; do
+	ip netns exec nsrouter$i nft -f - <<-EOF
+	table inet filter {
+		counter unknown { }
+		chain forward {
+			type filter hook forward priority 0; policy accept;
+			meta l4proto esp ct state new,established accept
+			counter name "unknown" accept
+		}
+	}
+	EOF
+done
+
+for i in 1 2; do
+	ip netns exec nsrouter1 nft -f - <<-EOF
+	table ip nat {
+		chain postrouting {
+			type nat hook postrouting priority 0; policy accept;
+		oifname "veth1" counter masquerade
+		}
+	}
+	table ip6 nat {
+		chain postrouting {
+			type nat hook postrouting priority 0; policy accept;
+		oifname "veth1" counter masquerade
+		}
+	}
+	EOF
+done
+sleep 2
+
+ip_tunnel() {
+	ip -net nsclient$2 tunnel add tunnel$1 mode vti${1%4} local $3 remote $=
4 key 0x$1
+	ip -net nsclient$2 link set tunnel$1 up
+}
+
+ip_xfrm() {
+	ip -net nsclient$2 xfrm state add src $4 dst $5 \
+	 proto esp spi 0x$1$2$3 mode tunnel mark 0x$1 \
+	 sel src $6 dst $7 \
+	 auth-trunc 'hmac(sha256)' \
+	  0x0000000000000000000000000000000000000000000000000000000000000$1$2$3=
 128 \
+	 enc 'cbc(aes)' \
+	  0x0000000000000000000000000000000000000000000000000000000000000$1$2$3
+
+	ip -net nsclient$2 xfrm state add src $5 dst $4 \
+	 proto esp spi 0x$1$3$2 mode tunnel mark 0x$1 \
+	 sel src $7 dst $6 \
+	 auth-trunc 'hmac(sha256)' \
+	  0x0000000000000000000000000000000000000000000000000000000000000$1$3$2=
 128 \
+	 enc 'cbc(aes)' \
+	  0x0000000000000000000000000000000000000000000000000000000000000$1$3$2
+
+	ip -net nsclient$2 xfrm policy add src $7 dst $6 dir in mark 0x$1 \
+	 tmpl src $5 dst $4 proto esp mode tunnel
+	ip -net nsclient$2 xfrm policy add src $6 dst $7 dir out mark 0x$1 \
+	 tmpl src $4 dst $5 proto esp mode tunnel
+}
+
+ip_tunnel 4 1 $(ipv4 1 2) $(ipv4 2 2)
+ip -net nsclient1 addr add $(ipv4 250 1)/24 dev tunnel4
+ip_xfrm 4 1 2 $(ipv4 1 2) $(ipv4 2 2) $(ipv4 250 1) $(ipv4 250 2)
+
+ip_tunnel 4 3 $(ipv4 1 3) $(ipv4 2 2)
+ip -net nsclient3 addr add $(ipv4 251 1)/24 dev tunnel4
+ip_xfrm 4 3 2 $(ipv4 1 3) $(ipv4 2 2) $(ipv4 251 1) $(ipv4 251 2)
+
+ip_tunnel 4 2 $(ipv4 2 2) $(ipv4 3 1)
+ip -net nsclient2 addr add $(ipv4 250 2)/24 dev tunnel4
+ip -net nsclient2 addr add $(ipv4 251 2)/24 dev tunnel4
+ip_xfrm 4 2 1 $(ipv4 2 2) $(ipv4 3 1) $(ipv4 250 2) $(ipv4 250 1)
+ip_xfrm 4 2 3 $(ipv4 2 2) $(ipv4 3 1) $(ipv4 251 2) $(ipv4 251 1)
+
+
+ip_tunnel 6 1 $(ipv6 1 2) $(ipv6 2 2)
+ip -net nsclient1 addr add $(ipv6 250 1)/64 dev tunnel6
+ip_xfrm 6 1 2 $(ipv6 1 2) $(ipv6 2 2) $(ipv6 250 1) $(ipv6 250 2)
+
+ip_tunnel 6 3 $(ipv6 1 3) $(ipv6 2 2)
+ip -net nsclient3 addr add $(ipv6 251 1)/64 dev tunnel6
+ip_xfrm 6 3 2 $(ipv6 1 3) $(ipv6 2 2) $(ipv6 251 1) $(ipv6 251 2)
+
+ip_tunnel 6 2 $(ipv6 2 2) $(ipv6 3 1)
+ip -net nsclient2 addr add $(ipv6 250 2)/64 dev tunnel6
+ip -net nsclient2 addr add $(ipv6 251 2)/64 dev tunnel6
+ip_xfrm 6 2 1 $(ipv6 2 2) $(ipv6 3 1) $(ipv6 250 2) $(ipv6 250 1)
+ip_xfrm 6 2 3 $(ipv6 2 2) $(ipv6 3 1) $(ipv6 251 2) $(ipv6 251 1)
+
+test_ping() {
+	ip netns exec $1 ping -q -c 1 $2 >/dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		echo "ERROR: netns ip routing/connectivity broken from $1 to $2" 1>&2
+	fi
+}
+
+test_ping nsclient1 $(ipv4 250 2)
+test_ping nsclient3 $(ipv4 251 2)
+test_ping nsclient1 $(ipv6 250 2)
+test_ping nsclient3 $(ipv6 251 2)
+
+check_conntrack
+if [ $? -ne 0 ]; then
+	ret=3D1
+fi
+
+check_unknown
+if [ $? -ne 0 ]; then
+	ret=3D1
+fi
+
+if [ $ret -eq 0 ];then
+	echo "PASS: ESP connections were tracked via SPIs"
+else
+	echo "ERROR: ESP connections were not tracked"
+fi
+
+cleanup
+exit $ret
--=20
2.31.1

