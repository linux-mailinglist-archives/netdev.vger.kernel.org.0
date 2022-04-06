Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9B04F6BF3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiDFVBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbiDFVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:01:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2086.outbound.protection.outlook.com [40.107.20.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295991F6BF6;
        Wed,  6 Apr 2022 12:30:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJMtWYPdrHCURLR2pLEdQjbFtjWXBs6hSgAxCZJX8mqknxR+Ll39jFUl+YErtHQs9fZ/zKkbriN24BUeZbiNxP14klx+aoLWlLbcDBI+PBFXC30Sd6T5MZ5Pm18v6jE/Ub3NB4/zCY3+g7If/XmbRfBf/BxJzRHe2tH1aNhcm/oWUBmvKrrPOASs7+F+l4ZagTkxlg+yKcYYuU+DejZD4njWqUIS+cnAfhC3GP+HvFHbqsvvcPbVkOX1C0AKgG0Wg4uJI6KWxXjHQlqo0hZQP8oRUw+HoNdXkfg/FlqUW5H8DzGJy9BhQpaaiB7cymTUJp68E1dOBkOOv7uV7Mp2bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btHRSl87lsQvTc2ApgeVTjdAb0wMwPxjdL6VsEl7ZHk=;
 b=Zpofei8QEV8m3AvZmIvoM7F1A+o02WmXGZoEpdHu1aIG1UaqGVcRlKKz6yKojqEm6eQ4xzlprOajQwxoZ17a8RwbpwUI2bRYshsv4DxYKmjvfigsx2g+V8AVtmOYeY5ezta7vh0TDtfqT2SFYgB/iK24HamJGI9on0ZxFfuMuaklt8dcakIEFHD3mT3Nb5AuSVHitcDhysSxZOY+U2C7l2GajKOe2+VN9tbkl+JjAPBjgHNTkNbl8BYpSdhmMH+xlPiD8iTx25izmvfuYGJH5fe7vXArDB7wF1T7qP+hvVxDmqSm3EcyzO3J6heEL1gaFMTNTWKQdmi2RrA0QJsaWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btHRSl87lsQvTc2ApgeVTjdAb0wMwPxjdL6VsEl7ZHk=;
 b=fZIJR2q3VJlqycrwrJom0naT4O0TezghagvobLJpdINuqlaYSQnD/juxVP8DxxaKtffy3bUszusXIpYVtf3QzZyHOAGm1gs5v0ApFsUCmmNUgns+Pd4aI7fyDIpoRMDCjRdO8z2EOsd//SNzTrzCQ+esL+ruryeGkHHWp4zmk2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5487.eurprd04.prod.outlook.com (2603:10a6:803:d1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 19:30:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 19:30:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH 4.14 2/2] net: add missing SOF_TIMESTAMPING_OPT_ID support
Date:   Wed,  6 Apr 2022 22:29:55 +0300
Message-Id: <20220406192956.3291614-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0069.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb9234a0-990f-465f-12c5-08da1803e36f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5487:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5487055CDB0B5B204AF9B902E0E79@VI1PR04MB5487.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPF1SLsfjXhfoOTEKRSGqL+n3ulxD4UpcyTmignmzu0sQHxhZ9PNxbG71ZKJWXqLU7zTZ9y5AKwKc9CFNCnF2ASFTGkFdwY/PoAl0otLCWbPi/eRAI40SKiN3eVESuUG8yUWTJZ1oAFvg8IuYSGNFF6hi5odD8fpvQSSr8Jx78WeR5PWBSywKA473B7Sa6qqfr/kJuvZVAtKBBHC8B/6ULXVHnh/eguRWdLpsamkHaxG1pX+JQ3oMm+P4JCUrcfGdy5aqg1WFqH7inciLxLCr2m+G4foMiQRO2HPdiAebQfEMMI06i3lZHHPyI9LEEnWNuAH8W7w18IMGpI+sz40dILk4KgTbwDJ3aPyb6QEpbF2oAUOOg++SypzitQELqa4doWu91Kev5tLDfMFs9gQWSbBdZtimFOZsqR51VzY9GGifaGPUInt09ye/r0C5ztEmCvzaIY4OkgIvaNVKh3jvRytCQVf/nhfTQaeEWSlY0PFUYtKTPN2S3CiNmmXwt9lcFW3NlTB7rYTYXlUxnFyjht+iD3enSazzPrBfDyLoaW8AG+qYLJTk58nPXTuUU7uhXYbdTTKqYP8oDUjHOnPeJ2AZaZYpwnIB4VgAM0FHtg5r/qtIjQKJ5u/jPSHicOckyF54J6gXbKQgDvR9MRJxx9x26AVXwdwWYHNQL3Hf/43yQQ2cdGM9vvCIdqeEDBoygHwCqVo8c5QmJNDDp5h0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(86362001)(2616005)(316002)(8676002)(66556008)(66476007)(38350700002)(1076003)(6506007)(38100700002)(66946007)(4326008)(6666004)(186003)(110136005)(54906003)(2906002)(508600001)(26005)(6486002)(8936002)(52116002)(83380400001)(36756003)(5660300002)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZfGCyNY67M7BySbkiUlM8LTOZbxs+Rul+4ap5LYk44bLiBpxmKV/l+goKa2/?=
 =?us-ascii?Q?h4lHXdrQT/RmHxbTDdPEq/bShX1ZPP9IzuF4B7SzTLtMSOw0xRqLblIywezd?=
 =?us-ascii?Q?I7qlySLYlp1CX1OesXi1XKyhy7PlWLlpA3drQzmVfgjmYUBZ1xPSMQo6f2yx?=
 =?us-ascii?Q?1y8Hx9CeW4WkSABGRmsvQr5O0IVd4NzoP2fZcqwp/e85TiwW64C1F9JySXuA?=
 =?us-ascii?Q?MFnuOVv22aUU/SaDaM2no2vxoII6g2KDsyudIfi4AW8yJUIwh+pEObH9oty9?=
 =?us-ascii?Q?a7CcRfESILhC41lu3sJoShEneZmwoh+OhMXuPlrtFZOJh2EeeDfV75PuxIrQ?=
 =?us-ascii?Q?jTZL95GMk7LlMUw4USiZifORcokuREjN5IbEYN37pgVqDgfUTdxVuCuuDWLP?=
 =?us-ascii?Q?faxyD7IHASQgl/GUe7Ump/EK0E4XPgu63N0qqi7P6J7TNfgyGd4WTEuDVwXu?=
 =?us-ascii?Q?Q81sRFyCnyWuPbIK9COufqs9D013HxY88IOLEEVisuQ+dMIg5eU8YhdyXxkx?=
 =?us-ascii?Q?0EKEvx44ZoMz/JPVj+WlSvKHn4eXqgVhOExOzHs6gOVxB7RkXgHt+f65PQ0+?=
 =?us-ascii?Q?qceafYA3jjwtvynVf5dn6hwPiwObJZCQ4hhHfwalI24y31BKGv+jG43s1K5I?=
 =?us-ascii?Q?5qbPx9que9d4lzT3H0ovnpwKhNF9Di8+87LFBXNjsvkUuMGVYvr8A5No4D3T?=
 =?us-ascii?Q?kDkXpK8DE+aUwn1aHDId5HGsWPyJsLvXMvYdyv95vppgGHNPXvIBZhL8cjrQ?=
 =?us-ascii?Q?g8J/qhh1Q7JT4Cz5AcXxhp8FVclhbJPNf23tV42eta4mjHXhQAbsbhz/k6qv?=
 =?us-ascii?Q?cFFIVRN059wpwvQWOLLL935k4r06LFsFglDFxELUPUT8oK/d8ovGyPGH+7I4?=
 =?us-ascii?Q?33kbsNy+VMeJImjpVlpJowxzzc5679Fr2vK1Cp3MaCm1KIecwAp3AhUIPEkg?=
 =?us-ascii?Q?/5FTbBH/Twee31FtMKbPDkIa4csVbe4m0WEwYrGruvg9k7YXhpDbnOdZDnGn?=
 =?us-ascii?Q?pr1+fXXTKLdHtQXFl7w2HM6HrtMmO3A4xQYuGVKG7DAdu6qoM8hokYzsq6EX?=
 =?us-ascii?Q?E45EVTZDzxFD0kAexZ4R4z2bVmH/gVDu37qXC5pHTuebl5COE/bqyz83kLho?=
 =?us-ascii?Q?ndnRSwhX39/F2ULVPZ9lUybBUf+3cEstSvJgGReunisNRXfvnr00Em/VhJgV?=
 =?us-ascii?Q?+93VFZrYG+E3v3txvXQAZCYO4P/GqsSCBObtJ51nEel2zlr/mn1X5Ql4zxP0?=
 =?us-ascii?Q?fIzHfyfuiQErRQMNPzngv9HP4KhClJ6lEfW4SITaREpvuP1pN0fyrvxy3xIn?=
 =?us-ascii?Q?iaj2429HUz7Xmxy3HHUGVLYaY/9hS7EakkPsATf6uc+P07y0J7KRdiu6RQwd?=
 =?us-ascii?Q?qSRXMcER4vv1hvU5UKq0j9orqsBIm/Rzvry9qYDT5AIIevlNxbzuQCmmN7lr?=
 =?us-ascii?Q?t5BJwIzHUxEM9igBaWd2wc0GuWjOAaLbD6QjqHqkcBG/aaLgkNDtr5h0Ha3D?=
 =?us-ascii?Q?+IXdnQtZpP5kWdcP7WQPGBqjWpgwPToMytdzIH3TkXYIrDqexTIrr/JR6yP0?=
 =?us-ascii?Q?aEAiffiKGFPsns89OtJ76grgmW/2wLco1xO3k/RHKCAyteQva8x+mWhdusQj?=
 =?us-ascii?Q?lKiTjVo7oi0IWDOs+yOLNyIfrvWw6XyfD2iVAkpSgDhXZoq5NLLUoooejYWx?=
 =?us-ascii?Q?RgM0S19DZf8CqlWgUPxKQYLmQUdgZq4JnIB2qULIKhR+UXAzb+lN0iNiCo/R?=
 =?us-ascii?Q?Ai4HaR+c6k77TjL6DconA/mv3QQQsVs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9234a0-990f-465f-12c5-08da1803e36f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:30:20.7428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6V41Rewd9tfJ3ONMFC5L50qCw4ysQNy7GHV8wOituqs5WNtp5dp6S3X2EDqktdqOKaEHpn5rrRvpYQHK6T1S6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5487
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 8f932f762e7928d250e21006b00ff9b7718b0a64 ]

SOF_TIMESTAMPING_OPT_ID is supported on TCP, UDP and RAW sockets.
But it was missing on RAW with IPPROTO_IP, PF_PACKET and CAN.

Add skb_setup_tx_timestamp that configures both tx_flags and tskey
for these paths that do not need corking or use bytestream keys.

Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/sock.h     | 25 +++++++++++++++++++++----
 net/can/raw.c          |  2 +-
 net/ipv4/raw.c         |  2 +-
 net/ipv6/raw.c         |  2 +-
 net/packet/af_packet.c |  6 +++---
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f72753391acc..f729ccfe756a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2311,22 +2311,39 @@ static inline void sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
 void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags);
 
 /**
- * sock_tx_timestamp - checks whether the outgoing packet is to be time stamped
+ * _sock_tx_timestamp - checks whether the outgoing packet is to be time stamped
  * @sk:		socket sending this packet
  * @tsflags:	timestamping flags to use
  * @tx_flags:	completed with instructions for time stamping
+ * @tskey:      filled in with next sk_tskey (not for TCP, which uses seqno)
  *
  * Note: callers should take care of initial ``*tx_flags`` value (usually 0)
  */
-static inline void sock_tx_timestamp(const struct sock *sk, __u16 tsflags,
-				     __u8 *tx_flags)
+static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+				      __u8 *tx_flags, __u32 *tskey)
 {
-	if (unlikely(tsflags))
+	if (unlikely(tsflags)) {
 		__sock_tx_timestamp(tsflags, tx_flags);
+		if (tsflags & SOF_TIMESTAMPING_OPT_ID && tskey &&
+		    tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
+			*tskey = sk->sk_tskey++;
+	}
 	if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
 		*tx_flags |= SKBTX_WIFI_STATUS;
 }
 
+static inline void sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+				     __u8 *tx_flags)
+{
+	_sock_tx_timestamp(sk, tsflags, tx_flags, NULL);
+}
+
+static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
+{
+	_sock_tx_timestamp(skb->sk, tsflags, &skb_shinfo(skb)->tx_flags,
+			   &skb_shinfo(skb)->tskey);
+}
+
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
diff --git a/net/can/raw.c b/net/can/raw.c
index 2a987a6ea6d7..bda2113a8529 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -814,7 +814,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err < 0)
 		goto free_skb;
 
-	sock_tx_timestamp(sk, sk->sk_tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sk->sk_tsflags);
 
 	skb->dev = dev;
 	skb->sk  = sk;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 9c4b2c0dc68a..19a6ec2adc6c 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -390,7 +390,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index f0d8b7e9a685..e8926ebfe74c 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -659,7 +659,7 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 92394595920c..b0dd17d1992e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2017,7 +2017,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
@@ -2539,7 +2539,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	skb->dev = dev;
 	skb->priority = po->sk.sk_priority;
 	skb->mark = po->sk.sk_mark;
-	sock_tx_timestamp(&po->sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 	skb_zcopy_set_nouarg(skb, ph.raw);
 
 	skb_reserve(skb, hlen);
@@ -3002,7 +3002,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out_free;
 	}
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (!vnet_hdr.gso_type && (len > dev->mtu + reserve + extra_len) &&
 	    !packet_extra_vlan_len_allowed(dev, skb)) {
-- 
2.25.1

