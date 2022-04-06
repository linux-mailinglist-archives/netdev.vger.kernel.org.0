Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD6F4F6BF2
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbiDFVBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiDFVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:01:21 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD4C2E9F4;
        Wed,  6 Apr 2022 12:30:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWgtk0CaUgtPSac544AIz0efSNtvriuNPBUR8wAibpQ4QMYnnHKzvYw/tJQygf3MvfYw5AWdeo7i3CtRqbjTrtfiHpBXYbATeqm6ku+Di3eavX2WlvBwAde9Ij7MwKIaVyzJh9AyYM+Rz7x9wh30fbfoKIgvscsZrny5F3F7soyX/PMEDcOGURrZfLevAxHDHWrcDJ79giTSrz4Zinm6AOVrbiLPmOd5RPDe60Cxi+Q2WwzBMNOo+aQJ7zahMGsre8t+6WkOopLh4o5YQIU73+MIpO4CfM+7ARf5io7r6tfeXqKX52Vr7CZehdCKNCiOTZuwMnWXExDPPfvqWx+uJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9aVhbqGMoN9ZeCrIDse23fOCtAsZ2JHn0wwz6dqDGs=;
 b=lYZuJ5FUutp7pCdb3ZHuQhPpiy/i9LLac1FyU1nzoRDiiIuvf0wJQw17WyKx3R7SRN9n3nlOu9rin4gGcoE/YVipKSji5CaOtriFiBMerV6i4rKsYPhqm7qkKkRBzxzIoY/lpJOmg7Z6twR8oUVRgB50zlutZ/6Fa6GbXhoqLB+yjYHxIBaaIDjT9jMlWEmxeTiHSTnM+yC8kBoMlJJhP6WAEfAMnlfrnnIV3124QdlsdftqPeZNyDfeVd8m4EqIDSs4nw3c1TuBrWZynbKo0cglGsjoO2OZe8Eug3OmQfG8aRV9ykeI1nG6MQjcfB/cmNwsAKz5122j6H274CskGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9aVhbqGMoN9ZeCrIDse23fOCtAsZ2JHn0wwz6dqDGs=;
 b=mRG37GcQmA16zBJcYJMFA6joSMrZ1nj8hNUO4+D44uihucxIO+DxLFhNRaAyjx/V9D4gs1OIKBFfIAG5t+BJa30RwJ9uchGrV2oOb3zaTfjkBehPzXmFydhfLwaJJU8vprdgjg1W2Y2IRsfgTSvy9mRZB/ZDO3M73fKQKLaDfpo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM4PR0401MB2402.eurprd04.prod.outlook.com (2603:10a6:200:51::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 19:30:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 19:30:22 +0000
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
Subject: [PATCH 4.19 1/1] net: add missing SOF_TIMESTAMPING_OPT_ID support
Date:   Wed,  6 Apr 2022 22:29:56 +0300
Message-Id: <20220406192956.3291614-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3083aa1f-2f1f-4f41-7daf-08da1803e41f
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2402:EE_
X-Microsoft-Antispam-PRVS: <AM4PR0401MB24027BE624B62B7BE6C2C0F7E0E79@AM4PR0401MB2402.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qIA4lXfIu88UhYXNplqNtx6OzPhfPnNKLBKb6q+Arw7fyXlMKmDruf8IFngjfKqgXJIWmxIPY1LcfCfrQWkdMdMvlXE2NBZWaf35+RHynyoBhjvKE1r7ydy0GsIUvNMzHX4A6bv/qTYpaHHujYPJrlPqgTr489A249AXJl/yLWEcAayUu+RgIKzN0XNp7fQ6XNqSGMEef85Dn86mARxqamFnVIXt+ymdC9KvEHM4wEUFDjq0W/u2YBrUzKbGP0xA+QPdS9wp42gw9JkpcK/N/QV5R67YWHdipV6UF3vMe0nsJ0Dy4H4wwYNKAdlSoBnrmhbdmgSCQKW7k995XpagKv4FaTqa15YkbEfq9DELuqBDZ/qjkyPNBvC+rlnGzd1k6O4fVJGOY3+W6PGQ4ukQrA4QuDfGt02CwzARDNMJ/TrzrD8fMjSL8HG3NLKuGtv2P8yPc3aTyt7KXQlnbEWxdWNRC7cwo3mAhlHgnYeIiUYuT0ZmdEMLd/WxnYB0GvM3s1QOOXZI9db+hyFTEemEG2IvpNK9ZHrhDxeaE5+u3819Kq2TicPAQsNFpSMJS0l2N7TotlRJKYl8t/Yhtwn3tMNL9GYebs61/pmt0Jmj/yUsDd4CJwz2YjcAjSHJCAV3z8wJYR7Z1KRGKubZteoImNOiYrbCRpdtOwC8sJhrDN0kffnpSiMcLykiUdQb672i4imNqV9MaKWAXG7wAORRyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(66476007)(54906003)(83380400001)(66556008)(8676002)(110136005)(6486002)(316002)(86362001)(66946007)(508600001)(4326008)(8936002)(1076003)(6512007)(44832011)(6666004)(38100700002)(7416002)(2616005)(5660300002)(52116002)(6506007)(38350700002)(2906002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sSnDw2WLZ51shP2fPsM75HKq50PuFMBPqf1hirDBz6/eqaxTvIYW4odkQxr+?=
 =?us-ascii?Q?5/ez5kf6aywC0DcR2boiAGm9xR5BK0dvHXvV27BKwWfDxWTZSfhnhsfMRgMr?=
 =?us-ascii?Q?emOCznEPbxFKRtedtCmrwhw9GFzmu52oB/wo0KVN/d4NxISbeCrIk6Zh3fwi?=
 =?us-ascii?Q?fIbLM6MSpXb1i+RhnfjlWJrKAI5u+IjTP3Y/K+VPSttuFEP4S+N7BP/wYnAl?=
 =?us-ascii?Q?NCsZBsURLPqugkIn//oVuzSlZh4vuyOkvRy6ruAW8UVnORax6OQL2XyANh1G?=
 =?us-ascii?Q?8uF2JrK0vXqqu+ps3z3JDf+w5R+dH1tkuxjPCu6IWoTOVp5B7uUqlPEZLAr9?=
 =?us-ascii?Q?alUp16R2VgNUvfejdJvX2T1CIhd9wntacLQ0hr/5QRkcUaxcB4c9SknH4axJ?=
 =?us-ascii?Q?czVhGDHvUXl0B/PTo4RJana0Otloc3882ko53yLiD32Z4cN6LmtE3Ubi2rm3?=
 =?us-ascii?Q?cXCUh320ihRlZCIA4OgpetNPRX31RyZPMoPnppFjE5+7/eTL6xxzABrwS/Sk?=
 =?us-ascii?Q?wMief3p7h6cziNhEisOk8o5+a4ApHGpBm08bq0v+HLkpFdCts6g/o56YCXMh?=
 =?us-ascii?Q?oYYY91otgf+0cnkpcL2Jm7UmKDC4bGWCMoXT7N7BZli6bHbnLs3XeHYvB8N4?=
 =?us-ascii?Q?CnoR0vgP+2BR9u7EkI3J9LxDbNuadTeaRR+kSmpi3T3BQrpqzBdsTSrUk4Oy?=
 =?us-ascii?Q?ysLQgO6mFCt//c1kk/oy2vwSjkcU9ii/Ii8scQ4/K90Nh0Sl5lnyigAy5h7z?=
 =?us-ascii?Q?sVe7Xyv6BkbOib1TxwT//4zw19jZBgUR25cFhTZrvsX9wub43pxe1f1ujvaY?=
 =?us-ascii?Q?3dOwBpydriXL3QfRaz9+yzISTCNFZv2zvEyFTgRQn5385ESGIJzFYjHc9cUC?=
 =?us-ascii?Q?alOyiKIDZCZYP1Z/yAYxYpQpF4rTVNgczHyOZRAbuLf2W/FgND0QvyqVNgMF?=
 =?us-ascii?Q?BtIJdcXTY335xxk0JIjORl9LarzZSNCNwzWfsMl6gB4gX16Pa7uoY7bLLiW/?=
 =?us-ascii?Q?PNFkfFx8kfVozjZXxYHJSgnLKuKLEzGclZGRUpK3eOXmMKa4iyMXEr5e3yX1?=
 =?us-ascii?Q?fhQFb1V1PDK6rlScg3M3hnfeNHyAwWwADOX8KtxpR4L+hF7yRCXFP6jfin3v?=
 =?us-ascii?Q?qaMi6/bTzagVsuF18earuvO/+DDHlNvaLRUgxW3XcS4HvtQy8/b0LLhd3XK5?=
 =?us-ascii?Q?eiw6gBYMrBJAr1swRffYMvzdvsMTxAFVsYOLaUylKIpbNvKpwVk2dyhaoo+o?=
 =?us-ascii?Q?yVhCtxWHJE5+xGq1UkKD7K9MNSxX+9amNcrEvElndwgYIfVL3+pFn8qo/PYE?=
 =?us-ascii?Q?S1KJdN6YpiVz/jnbCa1bGiS4nYl3xaipSjaoBKtgl7yRtNbVfRy1CKR4wYwu?=
 =?us-ascii?Q?a7BWuWHlLmXQRS7sxghqwsGiJSSDBkMpijAsdXQNrA2UAFfUD2765vILDZ18?=
 =?us-ascii?Q?SSTzsy98Dxekdec6O0wZjBg6ujzS6kVfuAGurTlMXVw7w7XaPTvkgCbY6hMF?=
 =?us-ascii?Q?yJW26TMAq+Gvaxpd1E3GpN3oXo4ZfbPkMu8m2nO+OPQbrp2w0ZSz581zyWB8?=
 =?us-ascii?Q?WOZJ7xGUVh6BQdhQ6PoLKr9jgcAN1KvRQacfWYBgZwut/qZ1v38ohwoWcA+6?=
 =?us-ascii?Q?qnh7Wf7edaG3J74pYoTjGSaHibB1W70wg9CVaXwlClfaIuB6Jbt6n2e5RhOY?=
 =?us-ascii?Q?vvxv78Wt+1h7jDgWF+hQzIFUSnSFbVk89u9azlqBie8bpzt7uD4NSvhNKWAH?=
 =?us-ascii?Q?FfMz0hOv9sxGfk/1ugpRO1zLaBX8DNk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3083aa1f-2f1f-4f41-7daf-08da1803e41f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:30:21.9146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /gk+pxWAAyX8MgYfgKiI04o5Z9RmZkVBW+K+NQjTxMRYEg653ZmLppIKrY4fulIDlVhWTUshMs+MSJNOrQgPgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2402
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
index 2bf8dcf863f2..7d3a4c2eea95 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2400,22 +2400,39 @@ static inline void sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
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
index d0fb5a57c66d..2a6db8752b61 100644
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
index 8cae691c3c9f..654f586fc0d7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -391,7 +391,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 98c8f98a7660..ad7bd40b6d53 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -660,7 +660,7 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d65051959f85..b951f411dded 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1978,7 +1978,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 	skb->mark = sk->sk_mark;
 	skb->tstamp = sockc.transmit_time;
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
@@ -2501,7 +2501,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	skb->priority = po->sk.sk_priority;
 	skb->mark = po->sk.sk_mark;
 	skb->tstamp = sockc->transmit_time;
-	sock_tx_timestamp(&po->sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 	skb_zcopy_set_nouarg(skb, ph.raw);
 
 	skb_reserve(skb, hlen);
@@ -2965,7 +2965,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out_free;
 	}
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (!vnet_hdr.gso_type && (len > dev->mtu + reserve + extra_len) &&
 	    !packet_extra_vlan_len_allowed(dev, skb)) {
-- 
2.25.1

