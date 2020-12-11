Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D130A2D707D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 08:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389741AbgLKG66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 01:58:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38352 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389667AbgLKG6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 01:58:44 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BB6rJhL019863;
        Thu, 10 Dec 2020 22:57:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=facebook; bh=PC9a1TEOLWoWwJZ3+WacioGzgi7WeN3oSKVN/cEWve4=;
 b=R7WQ8PAsiCQRiB0MsjUryXqD1ewmHXEIXEXfnS4GavoiSPdnt/KtoXp8TQLnXKtYsDv4
 KkHuq0Q1jRammFNSuztksG3PHrWCEMAwdvLHDPJfbkvJX08tT/2m1DUkAMwce3YWul2q
 JfxWLxWX1qEM8iYgAwO/7ELdmW8mLPnWT3s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35by3usa3u-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Dec 2020 22:57:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 22:57:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3PAETd2dbwCGSTn3I9GmdBdeiKEOqkoxj8FVB4HAEPZduTvX1Zhho4jKDukkf+HmRpmZ5UiD960Y0/j9NCcDBL33F56VmjJQQFVppN5TqbLLu2eSBB4K7o+46fmnK21nBqEa6xhTY+T9GMFnsLpVhPT6Uc9XHEMFHc6VfozYQEX0qK0n6jXuZttPruYq/FD67YS0QqRj+L5Q48oUbVOF27L6+xT9uZZVVOppoa+jty73vxYYMoNCvWv1BQoDnc7AKyAPcMyGJhiM9SB3e6uqzppzTIwirgBXjz1nPLCbmrA9JU9oJpSZjDGs6FT3iDysn2RVjfKxju99BmwXjrcaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PC9a1TEOLWoWwJZ3+WacioGzgi7WeN3oSKVN/cEWve4=;
 b=ls20wUzYdHKV6QciPEPfKdWtm5y/LecvxDWhZSleCRzF8gfhWQijmxYedpCfwOMi+XR7/yPbiC7ICuIwoYNhxDSFfKbmsiK/i7W/jNfmiQn/9k+2Ea4TvqLqA8+FubJsAZ7Ye+TfvQVc4YEwgmx+HpxQUVDYalY5EeeTAfkwAhw8wdACg6OEhCKj/L2RXAQVuB6Qfol5SP7q+mR7gXenLIhtqlHP1EI8X+LyADse35eNkMu1n72VO+EvfHvPc27jQOJTPC0MhvBtwdvIruwtGYiAilyPQdeUYRkGQ0WA3Xn5CBLlsT5B9VZz4E95f94WxjOawXu3wvpkJToKZclRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PC9a1TEOLWoWwJZ3+WacioGzgi7WeN3oSKVN/cEWve4=;
 b=MrhURNNZdeiuDGIzWFt9ZMsMsYIaCUhCjlAXcF/k15QpGFk22XCATLaMoq43KXRB9WcZOo3MT5HqrqgklDJhoQFv1c2EJeG0LhWKhndFcRuvu1jHEwv2rozeY0gRfNMuOrIWh0AjBHx/qGrFKcFEokSWSA4w3HoChKlkwAmJ1Tw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from MN2PR15MB3103.namprd15.prod.outlook.com (2603:10b6:208:f9::10)
 by MN2PR15MB2736.namprd15.prod.outlook.com (2603:10b6:208:128::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 11 Dec
 2020 06:57:06 +0000
Received: from MN2PR15MB3103.namprd15.prod.outlook.com
 ([fe80::59c4:2d2f:cc38:e7b7]) by MN2PR15MB3103.namprd15.prod.outlook.com
 ([fe80::59c4:2d2f:cc38:e7b7%6]) with mapi id 15.20.3654.017; Fri, 11 Dec 2020
 06:57:06 +0000
From:   Pravin B Shelar <pbshelar@fb.com>
To:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        <laforge@gnumonks.org>
CC:     <pravin.ovn@gmail.com>, Pravin B Shelar <pbshelar@fb.com>
Subject: [PATCH net-next] GTP: add support for flow based tunneling API
Date:   Thu, 10 Dec 2020 22:56:57 -0800
Message-Id: <20201211065657.67989-1-pbshelar@fb.com>
X-Mailer: git-send-email 2.29.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [163.114.132.4]
X-ClientProxiedBy: BYAPR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::15) To MN2PR15MB3103.namprd15.prod.outlook.com
 (2603:10b6:208:f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pbshelar-mbp.thefacebook.com (163.114.132.4) by BYAPR11CA0074.namprd11.prod.outlook.com (2603:10b6:a03:f4::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 06:57:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e54b765c-a206-4743-d671-08d89da1f8d2
X-MS-TrafficTypeDiagnostic: MN2PR15MB2736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR15MB27366D17499B180F36BC2111A2CA0@MN2PR15MB2736.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:82;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mYyAjC5HcIuHNeb+msvq2zHMRVnMHI9pUj3M2VGjieOoha07tJp3fwLR3sPxCYSd5NemyR07HGV4P+JdEXS4u9YnG5o5kdv6sOM/tPdNFEh+Q6XofDFZtzeQnS1WA/JVz6pArTfPmF7o6AqSdCHuKlZ9ThU77f8Q9/kX8l+fRTtiB5tJ9YLjT0GnTscPdKBwbx1oaPRUk0PQVhZNO7y5q0n9HkZvyqO35bwGqOamWZXvYm48Bes2RtHdlJwOeL3shakywTxNUBa+CKynhZehACOwoKJPWPxAmASseMzZ6HXYAk0IRYTCSpRd/hnAURiGiPbQLBhJip++/d6I0uTsuChQTSVEZIJAhWDBiCWhKZgp/rcIJpUtAevY5qsS59gs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB3103.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(346002)(2616005)(5660300002)(956004)(186003)(8936002)(83380400001)(16526019)(45080400002)(6666004)(1076003)(30864003)(6512007)(6486002)(508600001)(66946007)(8676002)(6506007)(86362001)(52116002)(36756003)(2906002)(66556008)(26005)(66476007)(4326008)(357404004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+7AV1uzCJUgyQZXvyu4TbSJh2aG5oWy4ft8xZtuXSeGHlyWCJLn4J2Xpw4Sd?=
 =?us-ascii?Q?mOy94zgWWXPySD4l0zuqEr2Uu3wu5Ax7sryzXxQ9oLElrsFmmBrpLMitEoUX?=
 =?us-ascii?Q?qjh6VIuGcnrjd5SVrVIv6wSfYSuPLRnQ9Aa+QuxQnBPboIZs190NZTdjA5+N?=
 =?us-ascii?Q?bpqe84+B7KXgbtlMHvLGTdNyIGq1rc9h+ODVjhUpFfgzGT5pgRRw26QkFGIl?=
 =?us-ascii?Q?pGuLZxDo9j6QJqciaS5D0GKW4X07e9PJ3I9Z2kUVU76r+MAXlWt8XbSAdhE6?=
 =?us-ascii?Q?Nok42zAHLRLSWyQ0hFGKFr5IA40D/4UMZnBCj40Uq9gskkYuHeGqMu5Jzi9C?=
 =?us-ascii?Q?Lnn38FfP+LjxlmV3xVynzADq59zZUPYxwbQdBn4vRzxSvTTdBBF0VrmPa0VJ?=
 =?us-ascii?Q?V/Z1dskwBxkSl0fBHLzUfrtamuMOXHUrw27EaXvOk18MTmIQD0XTEzo4ITlT?=
 =?us-ascii?Q?r6RLS2r/iT79xfpweJqX1lPdSG0N9hVRJvIywtLR5N+hEDINYyedkvlvn1SP?=
 =?us-ascii?Q?bQzJ9Kmfl/78pPopkh1jeMo60K5Yt8RHBcz2cnDrFDPL4sl6sdDnADkqvU2a?=
 =?us-ascii?Q?campZxPEfFdgFpNgJLtPMjnnYSZCAnZKBJJ0oexfUvhBJtIKvgY++0xsCNbP?=
 =?us-ascii?Q?8Y/N1PcJTX/gsRm0h5jABsOSAhGTadz3JK6tNXK1toVZJc4Va3bpmLJbU+RB?=
 =?us-ascii?Q?5T9VbYz0dugtrQNrhBKE9rCZttwQqucWj3T70XzIBZJLnoazKbuTXgsH3wvx?=
 =?us-ascii?Q?Yjs/lTnvUATKE2sf9sNMLck3qLYpJfWaPaLIzyw+JzH+o+IsndCeaO74YHiX?=
 =?us-ascii?Q?7gqhxYxsGINOhj5rGfVSyZbyun1AoIerGLr7lHbSJ839gtkNcEbqZ9QUteKp?=
 =?us-ascii?Q?svvcnYsxY9zwmcWy32b8qURbjweHUE+pYTEk1OgUM6EWIo7VKoYc+zcTvWCF?=
 =?us-ascii?Q?kceFBfCCiXg0EqpkULTPB1q/XWkTrtYP4sxMhCZkANUmoCajpmHBcfcgf2kY?=
 =?us-ascii?Q?v3ZO?=
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB3103.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 06:57:06.1848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: e54b765c-a206-4743-d671-08d89da1f8d2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/z0D4g24BXx03sSUMBn61ab631g6d1uqrz9U6lOAMFkIHVVFPdFgmqo2HpVKgzq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2736
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following patch add support for flow based tunneling API
to send and recv GTP tunnel packet over tunnel metadata API.
This would allow this device integration with OVS or eBPF using
flow based tunneling APIs.

Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
---
 drivers/net/gtp.c                  | 541 ++++++++++++++++++++---------
 include/uapi/linux/gtp.h           |  10 +
 include/uapi/linux/if_link.h       |   1 +
 include/uapi/linux/if_tunnel.h     |   1 +
 tools/include/uapi/linux/if_link.h |   1 +
 5 files changed, 398 insertions(+), 156 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4c04e271f184..bdb4d7c319be 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -21,6 +21,7 @@
 #include <linux/file.h>
 #include <linux/gtp.h>
 
+#include <net/dst_metadata.h>
 #include <net/net_namespace.h>
 #include <net/protocol.h>
 #include <net/ip.h>
@@ -73,6 +74,9 @@ struct gtp_dev {
 	unsigned int		hash_size;
 	struct hlist_head	*tid_hash;
 	struct hlist_head	*addr_hash;
+	/* Used by flow based tunnel. */
+	bool			collect_md;
+	struct socket		*collect_md_sock;
 };
 
 static unsigned int gtp_net_id __read_mostly;
@@ -151,7 +155,7 @@ static struct pdp_ctx *ipv4_pdp_find(struct gtp_dev *gtp, __be32 ms_addr)
 }
 
 static bool gtp_check_ms_ipv4(struct sk_buff *skb, struct pdp_ctx *pctx,
-				  unsigned int hdrlen, unsigned int role)
+			      unsigned int hdrlen, unsigned int role)
 {
 	struct iphdr *iph;
 
@@ -170,7 +174,7 @@ static bool gtp_check_ms_ipv4(struct sk_buff *skb, struct pdp_ctx *pctx,
  * existing mobile subscriber.
  */
 static bool gtp_check_ms(struct sk_buff *skb, struct pdp_ctx *pctx,
-			     unsigned int hdrlen, unsigned int role)
+		unsigned int hdrlen, unsigned int role)
 {
 	switch (ntohs(skb->protocol)) {
 	case ETH_P_IP:
@@ -179,33 +183,116 @@ static bool gtp_check_ms(struct sk_buff *skb, struct pdp_ctx *pctx,
 	return false;
 }
 
-static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
-			unsigned int hdrlen, unsigned int role)
+static int gtp_rx(struct gtp_dev *gtp, struct sk_buff *skb,
+		  unsigned int hdrlen, u8 gtp_version, unsigned int role,
+		  __be64 tid, u8 flags, u8 type)
 {
-	if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
-		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
-		return 1;
-	}
+	int err;
 
-	/* Get rid of the GTP + UDP headers. */
-	if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
-				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
-		return -1;
+	if (ip_tunnel_collect_metadata() || gtp->collect_md) {
+		struct metadata_dst *tun_dst;
+		int opts_len = 0;
+
+		if (unlikely(flags & 0x07))
+			opts_len = sizeof(struct gtpu_metadata);
 
-	netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
+		tun_dst =
+			udp_tun_rx_dst(skb, gtp->sk1u->sk_family, TUNNEL_KEY, tid, opts_len);
+		if (!tun_dst) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		netdev_dbg(gtp->dev, "attaching metadata_dst to skb, gtp ver %d hdrlen %d\n",
+			   gtp_version, hdrlen);
+		if (unlikely(opts_len)) {
+			struct gtpu_metadata *opts = ip_tunnel_info_opts(&tun_dst->u.tun_info);
+			struct gtp1_header *gtp1 = (struct gtp1_header *)(skb->data +
+									  sizeof(struct udphdr));
+
+			opts->ver = GTP_METADATA_V1;
+			opts->flags = gtp1->flags;
+			opts->type = gtp1->type;
+			netdev_dbg(gtp->dev, "recved control pkt: flag %x type: %d\n",
+				   opts->flags, opts->type);
+			tun_dst->u.tun_info.key.tun_flags |= TUNNEL_GTPU_OPT;
+			tun_dst->u.tun_info.options_len = opts_len;
+			skb->protocol = 0xffff;         /* Unknown */
+		}
+		/* Get rid of the GTP + UDP headers. */
+		err = iptunnel_pull_header(skb, hdrlen, skb->protocol,
+					   !net_eq(sock_net(gtp->sk1u), dev_net(gtp->dev)));
+		if (err) {
+			gtp->dev->stats.rx_length_errors++;
+			goto err;
+		}
+
+		skb_dst_set(skb, &tun_dst->dst);
+	} else {
+		struct pdp_ctx *pctx;
+
+		if (flags & GTP1_F_MASK)
+			hdrlen += 4;
+
+		if (type != GTP_TPDU)
+			return 1;
+
+		if (gtp_version == GTP_V0) {
+			pctx = gtp0_pdp_find(gtp, be64_to_cpu(tid));
+			if (!pctx) {
+				netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
+				return 1;
+			}
+		} else {
+			pctx = gtp1_pdp_find(gtp, be64_to_cpu(tid));
+			if (!pctx) {
+				netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
+				return 1;
+			}
+		}
+
+		if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
+			netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
+			return 1;
+		}
+		/* Get rid of the GTP + UDP headers. */
+		err = iptunnel_pull_header(skb, hdrlen, skb->protocol,
+					   !net_eq(sock_net(pctx->sk), dev_net(gtp->dev)));
+		if (err) {
+			gtp->dev->stats.rx_length_errors++;
+			goto err;
+		}
+	}
+	netdev_dbg(gtp->dev, "forwarding packet from GGSN to uplink\n");
 
 	/* Now that the UDP and the GTP header have been removed, set up the
 	 * new network header. This is required by the upper layer to
 	 * calculate the transport header.
 	 */
 	skb_reset_network_header(skb);
+	if (pskb_may_pull(skb, sizeof(struct iphdr))) {
+		struct iphdr *iph;
+
+		iph = ip_hdr(skb);
+		if (iph->version == 4) {
+			netdev_dbg(gtp->dev, "inner pkt: ipv4");
+			skb->protocol = htons(ETH_P_IP);
+		} else if (iph->version == 6) {
+			netdev_dbg(gtp->dev, "inner pkt: ipv6");
+			skb->protocol = htons(ETH_P_IPV6);
+		} else {
+			netdev_dbg(gtp->dev, "inner pkt error: Unknown type");
+		}
+	}
 
-	skb->dev = pctx->dev;
-
-	dev_sw_netstats_rx_add(pctx->dev, skb->len);
-
+	skb->dev = gtp->dev;
+	dev_sw_netstats_rx_add(gtp->dev, skb->len);
 	netif_rx(skb);
 	return 0;
+
+err:
+	gtp->dev->stats.rx_dropped++;
+	return err;
 }
 
 /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
@@ -214,7 +301,6 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	unsigned int hdrlen = sizeof(struct udphdr) +
 			      sizeof(struct gtp0_header);
 	struct gtp0_header *gtp0;
-	struct pdp_ctx *pctx;
 
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
@@ -224,16 +310,7 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if ((gtp0->flags >> 5) != GTP_V0)
 		return 1;
 
-	if (gtp0->type != GTP_TPDU)
-		return 1;
-
-	pctx = gtp0_pdp_find(gtp, be64_to_cpu(gtp0->tid));
-	if (!pctx) {
-		netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
-		return 1;
-	}
-
-	return gtp_rx(pctx, skb, hdrlen, gtp->role);
+	return gtp_rx(gtp, skb, hdrlen, GTP_V0, gtp->role, gtp0->tid, gtp0->flags, gtp0->type);
 }
 
 static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
@@ -241,41 +318,30 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	unsigned int hdrlen = sizeof(struct udphdr) +
 			      sizeof(struct gtp1_header);
 	struct gtp1_header *gtp1;
-	struct pdp_ctx *pctx;
 
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
 	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
 
+	netdev_dbg(gtp->dev, "GTPv1 recv: flags %x\n", gtp1->flags);
 	if ((gtp1->flags >> 5) != GTP_V1)
 		return 1;
 
-	if (gtp1->type != GTP_TPDU)
-		return 1;
-
 	/* From 29.060: "This field shall be present if and only if any one or
 	 * more of the S, PN and E flags are set.".
 	 *
 	 * If any of the bit is set, then the remaining ones also have to be
 	 * set.
 	 */
-	if (gtp1->flags & GTP1_F_MASK)
-		hdrlen += 4;
-
 	/* Make sure the header is larger enough, including extensions. */
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
 	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
 
-	pctx = gtp1_pdp_find(gtp, ntohl(gtp1->tid));
-	if (!pctx) {
-		netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
-		return 1;
-	}
-
-	return gtp_rx(pctx, skb, hdrlen, gtp->role);
+	return gtp_rx(gtp, skb, hdrlen, GTP_V1, gtp->role,
+		      key32_to_tunnel_id(gtp1->tid), gtp1->flags, gtp1->type);
 }
 
 static void __gtp_encap_destroy(struct sock *sk)
@@ -315,6 +381,11 @@ static void gtp_encap_disable(struct gtp_dev *gtp)
 {
 	gtp_encap_disable_sock(gtp->sk0);
 	gtp_encap_disable_sock(gtp->sk1u);
+	if (gtp->collect_md_sock) {
+		udp_tunnel_sock_release(gtp->collect_md_sock);
+		gtp->collect_md_sock = NULL;
+		netdev_dbg(gtp->dev, "GTP socket released.\n");
+	}
 }
 
 /* UDP encapsulation receive handler. See net/ipv4/udp.c.
@@ -329,7 +400,7 @@ static int gtp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!gtp)
 		return 1;
 
-	netdev_dbg(gtp->dev, "encap_recv sk=%p\n", sk);
+	netdev_dbg(gtp->dev, "encap_recv sk=%p type %d\n", sk, udp_sk(sk)->encap_type);
 
 	switch (udp_sk(sk)->encap_type) {
 	case UDP_ENCAP_GTP0:
@@ -350,7 +421,7 @@ static int gtp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		break;
 	case 0:
 		break;
-	case -1:
+	default:
 		netdev_dbg(gtp->dev, "GTP packet has been dropped\n");
 		kfree_skb(skb);
 		ret = 0;
@@ -383,12 +454,13 @@ static void gtp_dev_uninit(struct net_device *dev)
 
 static struct rtable *ip4_route_output_gtp(struct flowi4 *fl4,
 					   const struct sock *sk,
-					   __be32 daddr)
+					   __be32 daddr,
+					   __be32 saddr)
 {
 	memset(fl4, 0, sizeof(*fl4));
 	fl4->flowi4_oif		= sk->sk_bound_dev_if;
 	fl4->daddr		= daddr;
-	fl4->saddr		= inet_sk(sk)->inet_saddr;
+	fl4->saddr		= saddr;
 	fl4->flowi4_tos		= RT_CONN_FLAGS(sk);
 	fl4->flowi4_proto	= sk->sk_protocol;
 
@@ -400,7 +472,7 @@ static inline void gtp0_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 	int payload_len = skb->len;
 	struct gtp0_header *gtp0;
 
-	gtp0 = skb_push(skb, sizeof(*gtp0));
+	gtp0 = (struct gtp0_header *)skb_push(skb, sizeof(*gtp0));
 
 	gtp0->flags	= 0x1e; /* v0, GTP-non-prime. */
 	gtp0->type	= GTP_TPDU;
@@ -412,12 +484,12 @@ static inline void gtp0_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 	gtp0->tid	= cpu_to_be64(pctx->u.v0.tid);
 }
 
-static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
+static inline void gtp1_push_header(struct sk_buff *skb, __be32 tid)
 {
 	int payload_len = skb->len;
 	struct gtp1_header *gtp1;
 
-	gtp1 = skb_push(skb, sizeof(*gtp1));
+	gtp1 = (struct gtp1_header *)skb_push(skb, sizeof(*gtp1));
 
 	/* Bits    8  7  6  5  4  3  2	1
 	 *	  +--+--+--+--+--+--+--+--+
@@ -428,89 +500,164 @@ static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 	gtp1->flags	= 0x30; /* v1, GTP-non-prime. */
 	gtp1->type	= GTP_TPDU;
 	gtp1->length	= htons(payload_len);
-	gtp1->tid	= htonl(pctx->u.v1.o_tei);
+	gtp1->tid	= tid;
 
 	/* TODO: Suppport for extension header, sequence number and N-PDU.
 	 *	 Update the length field if any of them is available.
 	 */
 }
 
-struct gtp_pktinfo {
-	struct sock		*sk;
-	struct iphdr		*iph;
-	struct flowi4		fl4;
-	struct rtable		*rt;
-	struct pdp_ctx		*pctx;
-	struct net_device	*dev;
-	__be16			gtph_port;
-};
-
-static void gtp_push_header(struct sk_buff *skb, struct gtp_pktinfo *pktinfo)
+static inline int gtp1_push_control_header(struct sk_buff *skb,
+					   __be32 tid,
+					   struct gtpu_metadata *opts,
+					   struct net_device *dev)
 {
-	switch (pktinfo->pctx->gtp_version) {
-	case GTP_V0:
-		pktinfo->gtph_port = htons(GTP0_PORT);
-		gtp0_push_header(skb, pktinfo->pctx);
-		break;
-	case GTP_V1:
-		pktinfo->gtph_port = htons(GTP1U_PORT);
-		gtp1_push_header(skb, pktinfo->pctx);
-		break;
+	struct gtp1_header *gtp1c;
+	int payload_len;
+
+	if (opts->ver != GTP_METADATA_V1)
+		return -ENOENT;
+
+	if (opts->type == 0xFE) {
+		/* for end marker ignore skb data. */
+		netdev_dbg(dev, "xmit pkt with null data");
+		pskb_trim(skb, 0);
 	}
+	if (skb_cow_head(skb, sizeof(*gtp1c)) < 0)
+		return -ENOMEM;
+
+	payload_len = skb->len;
+
+	gtp1c = (struct gtp1_header *)skb_push(skb, sizeof(*gtp1c));
+
+	gtp1c->flags	= opts->flags;
+	gtp1c->type	= opts->type;
+	gtp1c->length	= htons(payload_len);
+	gtp1c->tid	= tid;
+	netdev_dbg(dev, "xmit control pkt: ver %d flags %x type %x pkt len %d tid %x",
+		   opts->ver, opts->flags, opts->type, skb->len, tid);
+	return 0;
 }
 
+struct gtp_pktinfo {
+	struct sock             *sk;
+	__u8                    tos;
+	struct flowi4           fl4;
+	struct rtable           *rt;
+	struct net_device       *dev;
+	__be16                  gtph_port;
+};
+
 static inline void gtp_set_pktinfo_ipv4(struct gtp_pktinfo *pktinfo,
-					struct sock *sk, struct iphdr *iph,
-					struct pdp_ctx *pctx, struct rtable *rt,
+					struct sock *sk,
+					__u8 tos,
+					struct rtable *rt,
 					struct flowi4 *fl4,
 					struct net_device *dev)
 {
-	pktinfo->sk	= sk;
-	pktinfo->iph	= iph;
-	pktinfo->pctx	= pctx;
-	pktinfo->rt	= rt;
-	pktinfo->fl4	= *fl4;
-	pktinfo->dev	= dev;
+	pktinfo->sk     = sk;
+	pktinfo->tos    = tos;
+	pktinfo->rt     = rt;
+	pktinfo->fl4    = *fl4;
+	pktinfo->dev    = dev;
 }
 
 static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 			     struct gtp_pktinfo *pktinfo)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
+	struct gtpu_metadata *opts = NULL;
 	struct pdp_ctx *pctx;
 	struct rtable *rt;
 	struct flowi4 fl4;
-	struct iphdr *iph;
-	__be16 df;
+	struct ip_tunnel_info *info = NULL;
+	struct sock *sk = NULL;
+	__be32 tun_id;
+	__be32 daddr;
+	__be32 saddr;
+	u8 gtp_version;
 	int mtu;
+	__u8 tos;
+	__be16 df = 0;
+
+	/* flow-based GTP1U encap */
+	info = skb_tunnel_info(skb);
+	if (gtp->collect_md) {
+		if (!info) {
+			netdev_dbg(dev, "missing tunnel info");
+			return -ENOENT;
+		}
+		if (ntohs(info->key.tp_dst) != GTP1U_PORT) {
+			netdev_dbg(dev, "unexpect GTP dst port: %d", ntohs(info->key.tp_dst));
+			return -EOPNOTSUPP;
+		}
+		pctx = NULL;
+		gtp_version = GTP_V1;
+		tun_id = tunnel_id_to_key32(info->key.tun_id);
+		daddr = info->key.u.ipv4.dst;
+		saddr = info->key.u.ipv4.src;
+		sk = gtp->sk1u;
+		if (!sk) {
+			netdev_dbg(dev, "missing tunnel sock");
+			return -EOPNOTSUPP;
+		}
+		tos = info->key.tos;
+		if (info->key.tun_flags & TUNNEL_DONT_FRAGMENT)
+			df = htons(IP_DF);
+
+		if (info->options_len != 0) {
+			if (info->key.tun_flags & TUNNEL_GTPU_OPT) {
+				opts = ip_tunnel_info_opts(info);
+			} else {
+				netdev_dbg(dev, "missing tunnel metadata for control pkt");
+				return -EOPNOTSUPP;
+			}
+		}
+		netdev_dbg(dev, "flow-based GTP1U encap: tunnel id %d\n",
+			   be32_to_cpu(tun_id));
+	} else {
+		struct iphdr *iph;
 
-	/* Read the IP destination address and resolve the PDP context.
-	 * Prepend PDP header with TEI/TID from PDP ctx.
-	 */
-	iph = ip_hdr(skb);
-	if (gtp->role == GTP_ROLE_SGSN)
-		pctx = ipv4_pdp_find(gtp, iph->saddr);
-	else
-		pctx = ipv4_pdp_find(gtp, iph->daddr);
+		if (ntohs(skb->protocol) != ETH_P_IP)
+			return -EOPNOTSUPP;
 
-	if (!pctx) {
-		netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
-			   &iph->daddr);
-		return -ENOENT;
+		iph = ip_hdr(skb);
+
+		/* Read the IP destination address and resolve the PDP context.
+		 * Prepend PDP header with TEI/TID from PDP ctx.
+		 */
+		if (gtp->role == GTP_ROLE_SGSN)
+			pctx = ipv4_pdp_find(gtp, iph->saddr);
+		else
+			pctx = ipv4_pdp_find(gtp, iph->daddr);
+
+		if (!pctx) {
+			netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
+				   &iph->daddr);
+			return -ENOENT;
+		}
+		sk = pctx->sk;
+		netdev_dbg(dev, "found PDP context %p\n", pctx);
+
+		gtp_version = pctx->gtp_version;
+		tun_id  = htonl(pctx->u.v1.o_tei);
+		daddr = pctx->peer_addr_ip4.s_addr;
+		saddr = inet_sk(sk)->inet_saddr;
+		tos = iph->tos;
+		df = iph->frag_off;
+		netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
+			   &iph->saddr, &iph->daddr);
 	}
-	netdev_dbg(dev, "found PDP context %p\n", pctx);
 
-	rt = ip4_route_output_gtp(&fl4, pctx->sk, pctx->peer_addr_ip4.s_addr);
+	rt = ip4_route_output_gtp(&fl4, sk, daddr, saddr);
 	if (IS_ERR(rt)) {
-		netdev_dbg(dev, "no route to SSGN %pI4\n",
-			   &pctx->peer_addr_ip4.s_addr);
+		netdev_dbg(dev, "no route to SSGN %pI4\n", &daddr);
 		dev->stats.tx_carrier_errors++;
 		goto err;
 	}
 
 	if (rt->dst.dev == dev) {
-		netdev_dbg(dev, "circular route to SSGN %pI4\n",
-			   &pctx->peer_addr_ip4.s_addr);
+		netdev_dbg(dev, "circular route to SSGN %pI4\n", &daddr);
 		dev->stats.collisions++;
 		goto err_rt;
 	}
@@ -518,11 +665,10 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 	skb_dst_drop(skb);
 
 	/* This is similar to tnl_update_pmtu(). */
-	df = iph->frag_off;
 	if (df) {
 		mtu = dst_mtu(&rt->dst) - dev->hard_header_len -
 			sizeof(struct iphdr) - sizeof(struct udphdr);
-		switch (pctx->gtp_version) {
+		switch (gtp_version) {
 		case GTP_V0:
 			mtu -= sizeof(struct gtp0_header);
 			break;
@@ -536,17 +682,38 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 
 	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, false);
 
-	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
-	    mtu < ntohs(iph->tot_len)) {
-		netdev_dbg(dev, "packet too big, fragmentation needed\n");
+	if (!skb_is_gso(skb) && (df & htons(IP_DF)) && mtu < skb->len) {
+		netdev_dbg(dev, "packet too big, fragmentation needed");
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			      htonl(mtu));
 		goto err_rt;
 	}
 
-	gtp_set_pktinfo_ipv4(pktinfo, pctx->sk, iph, pctx, rt, &fl4, dev);
-	gtp_push_header(skb, pktinfo);
+	gtp_set_pktinfo_ipv4(pktinfo, sk, tos, rt, &fl4, dev);
+
+	if (unlikely(opts)) {
+		int err;
+
+		pktinfo->gtph_port = htons(GTP1U_PORT);
+		err = gtp1_push_control_header(skb, tun_id, opts, dev);
+		if (err) {
+			netdev_info(dev, "cntr pkt error %d", err);
+			goto err_rt;
+		}
+		return 0;
+	}
+
+	switch (gtp_version) {
+	case GTP_V0:
+		pktinfo->gtph_port = htons(GTP0_PORT);
+		gtp0_push_header(skb, pctx);
+		break;
+	case GTP_V1:
+		pktinfo->gtph_port = htons(GTP1U_PORT);
+		gtp1_push_header(skb, tun_id);
+		break;
+	}
 
 	return 0;
 err_rt:
@@ -557,7 +724,6 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 
 static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	unsigned int proto = ntohs(skb->protocol);
 	struct gtp_pktinfo pktinfo;
 	int err;
 
@@ -569,32 +735,22 @@ static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* PDP context lookups in gtp_build_skb_*() need rcu read-side lock. */
 	rcu_read_lock();
-	switch (proto) {
-	case ETH_P_IP:
-		err = gtp_build_skb_ip4(skb, dev, &pktinfo);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
+	err = gtp_build_skb_ip4(skb, dev, &pktinfo);
 	rcu_read_unlock();
 
 	if (err < 0)
 		goto tx_err;
 
-	switch (proto) {
-	case ETH_P_IP:
-		netdev_dbg(pktinfo.dev, "gtp -> IP src: %pI4 dst: %pI4\n",
-			   &pktinfo.iph->saddr, &pktinfo.iph->daddr);
-		udp_tunnel_xmit_skb(pktinfo.rt, pktinfo.sk, skb,
-				    pktinfo.fl4.saddr, pktinfo.fl4.daddr,
-				    pktinfo.iph->tos,
-				    ip4_dst_hoplimit(&pktinfo.rt->dst),
-				    0,
-				    pktinfo.gtph_port, pktinfo.gtph_port,
-				    true, false);
-		break;
-	}
+	udp_tunnel_xmit_skb(pktinfo.rt, pktinfo.sk, skb,
+			    pktinfo.fl4.saddr,
+			    pktinfo.fl4.daddr,
+			    pktinfo.tos,
+			    ip4_dst_hoplimit(&pktinfo.rt->dst),
+			    0,
+			    pktinfo.gtph_port,
+			    pktinfo.gtph_port,
+			    false,
+			    false);
 
 	return NETDEV_TX_OK;
 tx_err:
@@ -610,6 +766,19 @@ static const struct net_device_ops gtp_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 };
 
+static struct gtp_dev *gtp_find_flow_based_dev(struct net *net)
+{
+	struct gtp_net *gn = net_generic(net, gtp_net_id);
+	struct gtp_dev *gtp;
+
+	list_for_each_entry(gtp, &gn->gtp_dev_list, list) {
+		if (gtp->collect_md)
+			return gtp;
+	}
+
+	return NULL;
+}
+
 static void gtp_link_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &gtp_netdev_ops;
@@ -634,7 +803,7 @@ static void gtp_link_setup(struct net_device *dev)
 }
 
 static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
-static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[]);
+static int gtp_encap_enable(struct gtp_dev *gtp, struct net_device *dev, struct nlattr *data[]);
 
 static void gtp_destructor(struct net_device *dev)
 {
@@ -652,11 +821,24 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	struct gtp_net *gn;
 	int hashsize, err;
 
-	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
+	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1] &&
+	    !data[IFLA_GTP_COLLECT_METADATA])
 		return -EINVAL;
 
 	gtp = netdev_priv(dev);
 
+	if (data[IFLA_GTP_COLLECT_METADATA]) {
+		if (data[IFLA_GTP_FD0] || data[IFLA_GTP_FD1]) {
+			netdev_dbg(dev, "flow based device does not support setting socket");
+			return -EINVAL;
+		}
+		if (gtp_find_flow_based_dev(src_net)) {
+			netdev_dbg(dev, "flow based device already exist");
+			return -EBUSY;
+		}
+		gtp->collect_md = true;
+	}
+
 	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
 		hashsize = 1024;
 	} else {
@@ -669,7 +851,7 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	if (err < 0)
 		return err;
 
-	err = gtp_encap_enable(gtp, data);
+	err = gtp_encap_enable(gtp, dev, data);
 	if (err < 0)
 		goto out_hashtable;
 
@@ -683,7 +865,7 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	list_add_rcu(&gtp->list, &gn->gtp_dev_list);
 	dev->priv_destructor = gtp_destructor;
 
-	netdev_dbg(dev, "registered new GTP interface\n");
+	netdev_dbg(dev, "registered new GTP interface %s\n", dev->name);
 
 	return 0;
 
@@ -706,6 +888,7 @@ static void gtp_dellink(struct net_device *dev, struct list_head *head)
 			pdp_context_delete(pctx);
 
 	list_del_rcu(&gtp->list);
+
 	unregister_netdevice_queue(dev, head);
 }
 
@@ -714,6 +897,7 @@ static const struct nla_policy gtp_policy[IFLA_GTP_MAX + 1] = {
 	[IFLA_GTP_FD1]			= { .type = NLA_U32 },
 	[IFLA_GTP_PDP_HASHSIZE]		= { .type = NLA_U32 },
 	[IFLA_GTP_ROLE]			= { .type = NLA_U32 },
+	[IFLA_GTP_COLLECT_METADATA]	= { .type = NLA_FLAG },
 };
 
 static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -737,6 +921,9 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
 		goto nla_put_failure;
 
+	if (gtp->collect_md  && nla_put_flag(skb, IFLA_GTP_COLLECT_METADATA))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
@@ -782,35 +969,24 @@ static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize)
 	return -ENOMEM;
 }
 
-static struct sock *gtp_encap_enable_socket(int fd, int type,
-					    struct gtp_dev *gtp)
+static int __gtp_encap_enable_socket(struct socket *sock, int type,
+				     struct gtp_dev *gtp)
 {
 	struct udp_tunnel_sock_cfg tuncfg = {NULL};
-	struct socket *sock;
 	struct sock *sk;
-	int err;
-
-	pr_debug("enable gtp on %d, %d\n", fd, type);
-
-	sock = sockfd_lookup(fd, &err);
-	if (!sock) {
-		pr_debug("gtp socket fd=%d not found\n", fd);
-		return NULL;
-	}
 
 	sk = sock->sk;
 	if (sk->sk_protocol != IPPROTO_UDP ||
 	    sk->sk_type != SOCK_DGRAM ||
 	    (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)) {
-		pr_debug("socket fd=%d not UDP\n", fd);
-		sk = ERR_PTR(-EINVAL);
-		goto out_sock;
+		pr_debug("socket not UDP\n");
+		return -EINVAL;
 	}
 
 	lock_sock(sk);
 	if (sk->sk_user_data) {
-		sk = ERR_PTR(-EBUSY);
-		goto out_rel_sock;
+		release_sock(sock->sk);
+		return -EBUSY;
 	}
 
 	sock_hold(sk);
@@ -821,15 +997,58 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	tuncfg.encap_destroy = gtp_encap_destroy;
 
 	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
-
-out_rel_sock:
 	release_sock(sock->sk);
-out_sock:
+	return 0;
+}
+
+static struct sock *gtp_encap_enable_socket(int fd, int type,
+					    struct gtp_dev *gtp)
+{
+	struct socket *sock;
+	int err;
+
+	pr_debug("enable gtp on %d, %d\n", fd, type);
+
+	sock = sockfd_lookup(fd, &err);
+	if (!sock) {
+		pr_debug("gtp socket fd=%d not found\n", fd);
+		return NULL;
+	}
+	err =  __gtp_encap_enable_socket(sock, type, gtp);
 	sockfd_put(sock);
-	return sk;
+	if (err)
+		return ERR_PTR(err);
+
+	return sock->sk;
+}
+
+static struct socket *gtp_create_gtp_socket(struct gtp_dev *gtp, struct net_device *dev)
+{
+	struct udp_port_cfg udp_conf;
+	struct socket *sock;
+	int err;
+
+	memset(&udp_conf, 0, sizeof(udp_conf));
+	udp_conf.family = AF_INET;
+	udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
+	udp_conf.local_udp_port = htons(GTP1U_PORT);
+
+	err = udp_sock_create(dev_net(dev), &udp_conf, &sock);
+	if (err < 0) {
+		pr_debug("create gtp sock failed: %d\n", err);
+		return ERR_PTR(err);
+	}
+	err = __gtp_encap_enable_socket(sock, UDP_ENCAP_GTP1U, gtp);
+	if (err) {
+		pr_debug("enable gtp sock encap failed: %d\n", err);
+		udp_tunnel_sock_release(sock);
+		return ERR_PTR(err);
+	}
+	pr_debug("create gtp sock done\n");
+	return sock;
 }
 
-static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
+static int gtp_encap_enable(struct gtp_dev *gtp, struct net_device *dev, struct nlattr *data[])
 {
 	struct sock *sk1u = NULL;
 	struct sock *sk0 = NULL;
@@ -853,11 +1072,21 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 		}
 	}
 
+	if (data[IFLA_GTP_COLLECT_METADATA]) {
+		struct socket *sock;
+
+		sock = gtp_create_gtp_socket(gtp, dev);
+		if (IS_ERR(sock))
+			return PTR_ERR(sock);
+
+		gtp->collect_md_sock = sock;
+		sk1u = sock->sk;
+	}
+
 	if (data[IFLA_GTP_ROLE]) {
 		role = nla_get_u32(data[IFLA_GTP_ROLE]);
 		if (role > GTP_ROLE_SGSN) {
-			gtp_encap_disable_sock(sk0);
-			gtp_encap_disable_sock(sk1u);
+			gtp_encap_disable(gtp);
 			return -EINVAL;
 		}
 	}
@@ -1416,7 +1645,7 @@ static int __init gtp_init(void)
 	if (err < 0)
 		goto unreg_genl_family;
 
-	pr_info("GTP module loaded (pdp ctx size %zd bytes)\n",
+	pr_info("GTP module loaded (pdp ctx size %zd bytes) with tnl-md support\n",
 		sizeof(struct pdp_ctx));
 	return 0;
 
diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
index 79f9191bbb24..b1498049d6e6 100644
--- a/include/uapi/linux/gtp.h
+++ b/include/uapi/linux/gtp.h
@@ -34,4 +34,14 @@ enum gtp_attrs {
 };
 #define GTPA_MAX (__GTPA_MAX + 1)
 
+enum {
+	GTP_METADATA_V1
+};
+
+struct gtpu_metadata {
+	__u8    ver;
+	__u8    flags;
+	__u8    type;
+};
+
 #endif /* _UAPI_LINUX_GTP_H_ */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 874cc12a34d9..15117fead4b1 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -808,6 +808,7 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_COLLECT_METADATA,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
index 7d9105533c7b..802da679fab1 100644
--- a/include/uapi/linux/if_tunnel.h
+++ b/include/uapi/linux/if_tunnel.h
@@ -176,6 +176,7 @@ enum {
 #define TUNNEL_VXLAN_OPT	__cpu_to_be16(0x1000)
 #define TUNNEL_NOCACHE		__cpu_to_be16(0x2000)
 #define TUNNEL_ERSPAN_OPT	__cpu_to_be16(0x4000)
+#define TUNNEL_GTPU_OPT		__cpu_to_be16(0x8000)
 
 #define TUNNEL_OPTIONS_PRESENT \
 		(TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index d208b2af697f..28d649bda686 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -617,6 +617,7 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_COLLECT_METADATA,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
-- 
2.17.1

