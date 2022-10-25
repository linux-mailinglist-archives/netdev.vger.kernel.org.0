Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C8860CE3F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbiJYOCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiJYOCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:02:10 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8633611F487
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:00:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDsc4KJBDebLCtrMFxLxpMXXpHonVZku0g6fjS0nislGFnNjO8P4i55Tq6muiZL10kWgbTsLPolApe3Ibt0Y0V/DikgHXUIKKBTvwXxzXBDHe+Ks8n/Ficokag02quUEO2pl3tqo7p8lsa7cfvLruDpkm0HDyri7aHblOBmX4ilZ5uVmCipqNwF8WQs44U0IiD9FjzLafrgV6oL5Ib0dJFKSNmDMyzDyD4ncUBCxlZAtpGvZhldrMpDYmMUiaHH2BWnm2wd2kJqjEAafA41bkk4w1gOsRfEmeeOm1sPDhVBtXM0n60sjnNu9qxQcgyLjBinoIiPfbtB0v5M+nso3/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQ6NV5LU3G36DlP5VO7e02jXxZAjs3g3ejjHbQYFP4Y=;
 b=XK3ojvFwj9HPK9U00IHPDvCX5P73Z0iw8neSX4wFGQqZPIpgZBJazFr0wp5S7dXs6CqdkpUCETT0d0ilF9Kk4YOdgdcAvv1NAtIk6OdzFQta81ZEhnZARMTOQKNe7B29Iq1TkXRbpppAz5xE1ceOgSU/7eUNhjdM87v1RUn4b/9SYoolBdWPNr4GazSq6QxXQ8IKCgC1pizx5HYDjpJwFqrxc6c+E6qDpV9AAjChBCtWtrfZ+mpmA1nAprGBnNHAB0pcHTWlqMBcRo5icr3pibkrNx87S/zvNzyrEkWUgw9Fcyyj6kfYO66ckY0IZnjnhduqEjNA6nwS0MGK027K7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQ6NV5LU3G36DlP5VO7e02jXxZAjs3g3ejjHbQYFP4Y=;
 b=LZpm44uV/c4f6Xa6PSiPzTd5GsHq7qbB37nEMEAPznAFrZn+EWFX71VTPVAPOjxZyOsyyuK2MdRFOlp5Hf5tPgGd5PBY2MLvTjLQ3x34a90fX4bTw5Vl4AX/1ZomOlA3xmM5NUVWFmYR1UyL0rDoyF4LYoXAdzgYT5aQTQijT/O8R5xt3nWIxOTqR7a7Qz8R4ZGaZ0Ut75qOQotvchipozJcRe9r3vD9WnvxQSZ/g1q9xB0I5FmWTdzWwVjKeoSuQQAchYKu8ZXm72Sk6zT4y0Q6UZMUlOdJoU4OOacmfJ8CyUELyY/JwnqxZz4WPnDpC7g724OcMl5c0qFhuhPwow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:00:14 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:12 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 01/23] net: Introduce direct data placement tcp offload
Date:   Tue, 25 Oct 2022 16:59:36 +0300
Message-Id: <20221025135958.6242-2-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0243.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::14) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: d68ead0b-0271-4a34-73ac-08dab6913c24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QDPuW5DIBy+Ba/fwVmYl7ps0vvP8dr7QCDB1sSTU61/f9b+Th1KOyPbELZOAXdJ5WQ3MHhYtYA+yPHQ3SLN98gndNRhZ7KMqH90W/+XHC8mxBC1b5GEYcyGA8EuEf+aoKlSfm3zrhbzdrAJlwWSOmutsoCaexqx45tA0vLMpxitbWXKGmbs2efFaSJa6Z1FpbYuPzte+m2hpb9MJufdJGPE9G2JSTcGjaTYBmVLkSeZT8KnLuHLqa6Z3YmmxfKgoQPaxXXyLL56fi483zj2lhcKRfrr0hAzZO2RNRogfaFo04Bi+fT2UGMMJYuxJfes1taPUsc72rKu0cnBhY4uH3VcB42giVOkIoItZu9SHcmpnhbmKVepPJq81TY2poaimEZ7L5ISG0wkngu8NSmidZTwxY5YounGQ3GltEgFeMuRLK+CFRol5VUSCqFLHPmTI+xloxPmmZTK1vGFlXOqL4zuZRRpSFfA+dLKI+du6pgsGQWl9TsDR7wNl9RZ8vUw9z63DONBLFU2cv6WAbwd19rHCQe4iUyLQk6YOvMwOxB+bUfij4MPjgwiX0PDVbXUq5JXlxj5CJSquUrGlW2VsdYFqq8RamFivDD7/c0ZXCkkc7ACarxhS0yf4ajNhcc0KbN1WPlsRWELT0Be1oK5eeFpLjEtk/DoRSt0j89mvrqNzUTHGQ+tm6ysl2Zpg45tUPs2JBekuQ//ofSPsae+bMKv8UwZ+w33mmzRMZrN00TuocbGCMY/zJMKTyNlTKy3g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(83380400001)(1076003)(186003)(2616005)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(478600001)(7416002)(30864003)(26005)(6506007)(6666004)(6486002)(4326008)(8676002)(66556008)(66476007)(316002)(6636002)(66946007)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h2eeylpa7BB9Gcl3nRqLv3N1ufBxn2ixBGBUL+2uH+gqHblI2tLS2teiys5V?=
 =?us-ascii?Q?9wV1awlCbxH5WzTRIALkFFVV1L9w63A4mZ3DKz0WVLPBEyaAhOWp2KVeN4u3?=
 =?us-ascii?Q?qc6ygvThwmYol+SLrebe+dx9OzmsM8+ykDI8mKQ3vjYV0FRDBPlCnhDaTmMo?=
 =?us-ascii?Q?+VhSe2/3MUI+p3w+Rr8MrhbT1FMSl+5k71rAWeYfyrv3OnVLDWcV5b/5E0x8?=
 =?us-ascii?Q?7DFAGJan3pOlV0+M+w5GtcwE8Y4S4CVzYtk54dUNO0vJnbHf9lc5UpywipiO?=
 =?us-ascii?Q?EQq0zuM+DEtfo5cSQXzrz27uRzJiQT7/RIKAjUtYNiyqM+jJnu0G9ysv/J26?=
 =?us-ascii?Q?EnHx5ALUHGnxyTXoCPIJCQZBkCI+8CJhY05ca6Rl0rx+REU68jKBjYKXxZhJ?=
 =?us-ascii?Q?H4oeSciCe2bIlH8uBPjGhBPvkDTLBt5o6cM3yFWJ1fdtSbujGiadRccv1aRV?=
 =?us-ascii?Q?tRnTUMd5w4DCDTTrmUsDZhYEQ4Y2+XlKFotXzuXEZ/jdHiYY5QYobfv8D0wb?=
 =?us-ascii?Q?/aRoKAqjdMTZKg2Gphw+HF/uIUPLKAvkvJ0PN6FQuB3Zf5DYcSN4SQxKQwCp?=
 =?us-ascii?Q?tqGqxSTNjrvvQwEYohzfm258X4b2oyzNKCy9aIR9il1rJ8Qreczn1wKZphai?=
 =?us-ascii?Q?By1+sHn9hesOHcLsW3SSyy/8HiXCRs+olINWH4f3lveVSjNDqYRRUAXk9ryp?=
 =?us-ascii?Q?Xq/gP80WKq8WRo6PG8adUAGaPTtVBCLoZBZ90yApwKLURj2tDDWZsJknhhlw?=
 =?us-ascii?Q?t6y/7N+k5f478nil+pKmvxxwieqLv1/oI6Hy57QzSU6W+/0qbA2fVpfBbWVu?=
 =?us-ascii?Q?B4WxRf68IHffGlxDnKF4Rhc+FRQbkn95i2Dd+RW8XISZxhizu6ZTAxWUDDid?=
 =?us-ascii?Q?TIprsKXNSObqByV+IfW6+s9kLJnLsb2C2+huY41FpLM9nc5KXLbCNsOJov71?=
 =?us-ascii?Q?NjJ2a1VlPYOYF3lnYayf+sAEqrNZpcMkis+AsLDNiynhLr5slDyQVsi/j1xQ?=
 =?us-ascii?Q?DHCvYASB85IoGLdNJ2V6sWbrdjXm+FRBSuaffuRCyGvmiXABnipxnKqty5So?=
 =?us-ascii?Q?sc/tWty8Tczuk+a5/qJli3RP5d7/o+9v+P/kQGCin2yB5vwsq9wiQDAtx9aO?=
 =?us-ascii?Q?3h26xKJnVRBI7SCbGUry35t+uh/25yVo3TWwCIuUCUsCwgZdNC2t/7e5CFsj?=
 =?us-ascii?Q?MH1Uvj3/gN9Ey1F0asaK0dw6Y90th/R0V28Y1bPkNxcKtr05zd6JiSwZaWIO?=
 =?us-ascii?Q?OKxVUkqANxt1Ef5MrZ/DYJxaqnE0IO5tmNT1KEySskwCeWQ0FaYUfr4eVnID?=
 =?us-ascii?Q?HIil81dkaK18txzX2AOjts2oXv+3nwNAuAllYKM0aBpkwKIcbbN226E6ynHV?=
 =?us-ascii?Q?IVxTNgOE9vSdTDo59aSelPm9AlggggPiMGRo1IP3tMCrsaumrjuojhNcfaOD?=
 =?us-ascii?Q?HmcttSIzDTtJRp9eI8Ib3jBO2oZDLeAbps3b2Wx1AksjPR251GqTBXI7bqyC?=
 =?us-ascii?Q?UWXxu/VEvL6i9h4v9ca1Hj+4y2sDTWW3kvwdPMaKHxqbomnXFQkjTtpZRPJF?=
 =?us-ascii?Q?pwRZZSTaB1hYbn9LONHBOLYaF6tJEMl5tXg8EB/T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d68ead0b-0271-4a34-73ac-08dab6913c24
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:12.4224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLCXOO+hrcePfU0EpZ/S6YpekioIECNGYZzZgGdDv0dlyz4hLlde3MnlxUNzcR1FRxBLsNmo4n6GoD3ayqlJnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6521
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@nvidia.com>

This commit introduces direct data placement (DDP) offload for TCP.

The motivation is saving compute resources/cycles that are spent
to copy data from SKBs to the block layer buffers and CRC
calculation/verification for received PDUs (Protocol Data Units).

The DDP capability is accompanied by new net_device operations that
configure hardware contexts.

There is a context per socket, and a context per DDP operation.
Additionally, a resynchronization routine is used to assist
hardware handle TCP OOO, and continue the offload. Furthermore,
we let the offloading driver advertise what is the max hw
sectors/segments.

The interface includes five net-device ddp operations:

 1. sk_add - add offload for the queue represented by socket+config pair
 2. sk_del - remove the offload for the socket/queue
 3. ddp_setup - request copy offload for buffers associated with an IO
 4. ddp_teardown - release offload resources for that IO
 5. limits - query NIC driver for quirks and limitations (e.g.
             max number of scatter gather entries per IO)

Using this interface, the NIC hardware will scatter TCP payload
directly to the BIO pages according to the command_id.

To maintain the correctness of the network stack, the driver is
expected to construct SKBs that point to the BIO pages.

The SKB passed to the network stack from the driver represents
data as it is on the wire, while it is pointing directly to data
in destination buffers.

As a result, data from page frags should not be copied out to
the linear part. To avoid needless copies, such as when using
skb_condense, we mark the skb->ddp bit.
In addition, the skb->crc will be used by the upper layers to
determine if CRC re-calculation is required. The two separated skb
indications are needed to avoid false positives GRO flushing events.

Follow-up patches will use this interface for DDP in NVMe-TCP.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/linux/netdev_features.h    |   3 +-
 include/linux/netdevice.h          |   5 +
 include/linux/skbuff.h             |  24 ++++
 include/net/inet_connection_sock.h |   4 +
 include/net/ulp_ddp.h              | 182 +++++++++++++++++++++++++++++
 net/Kconfig                        |  10 ++
 net/core/skbuff.c                  |   3 +-
 net/ethtool/common.c               |   1 +
 net/ipv4/tcp_input.c               |   8 ++
 net/ipv4/tcp_ipv4.c                |   3 +
 net/ipv4/tcp_offload.c             |   3 +
 11 files changed, 244 insertions(+), 2 deletions(-)
 create mode 100644 include/net/ulp_ddp.h

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 7c2d77d75a88..bf7391aa04c7 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -14,7 +14,7 @@ typedef u64 netdev_features_t;
 enum {
 	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
 	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
-	__UNUSED_NETIF_F_1,
+	NETIF_F_HW_ULP_DDP_BIT,         /* ULP direct data placement offload */
 	NETIF_F_HW_CSUM_BIT,		/* Can checksum all the packets. */
 	NETIF_F_IPV6_CSUM_BIT,		/* Can checksum TCP/UDP over IPV6 */
 	NETIF_F_HIGHDMA_BIT,		/* Can DMA to high memory. */
@@ -168,6 +168,7 @@ enum {
 #define NETIF_F_HW_HSR_TAG_RM	__NETIF_F(HW_HSR_TAG_RM)
 #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
 #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
+#define NETIF_F_HW_ULP_DDP	__NETIF_F(HW_ULP_DDP)
 
 /* Finds the next feature with the highest number of the range of start-1 till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eddf8ee270e7..84554f26ad6b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1043,6 +1043,7 @@ struct dev_ifalias {
 
 struct devlink;
 struct tlsdev_ops;
+struct ulp_ddp_dev_ops;
 
 struct netdev_net_notifier {
 	struct list_head list;
@@ -2096,6 +2097,10 @@ struct net_device {
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
 
+#if IS_ENABLED(CONFIG_ULP_DDP)
+	const struct ulp_ddp_dev_ops *ulp_ddp_ops;
+#endif
+
 	const struct header_ops *header_ops;
 
 	unsigned char		operstate;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 59c9fd55699d..2b97bf90f120 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -811,6 +811,8 @@ typedef unsigned char *sk_buff_data_t;
  *		delivery_time in mono clock base (i.e. EDT).  Otherwise, the
  *		skb->tstamp has the (rcv) timestamp at ingress and
  *		delivery_time at egress.
+ *	@ulp_ddp: DDP offloaded
+ *	@ulp_crc: CRC offloaded
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@alloc_cpu: CPU which did the skb allocation.
@@ -984,6 +986,10 @@ struct sk_buff {
 	__u8			slow_gro:1;
 	__u8			csum_not_inet:1;
 	__u8			scm_io_uring:1;
+#ifdef CONFIG_ULP_DDP
+	__u8                    ulp_ddp:1;
+	__u8			ulp_crc:1;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -5050,5 +5056,23 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 }
 #endif
 
+static inline bool skb_is_ulp_ddp(struct sk_buff *skb)
+{
+#ifdef CONFIG_ULP_DDP
+	return skb->ulp_ddp;
+#else
+	return 0;
+#endif
+}
+
+static inline bool skb_is_ulp_crc(struct sk_buff *skb)
+{
+#ifdef CONFIG_ULP_DDP
+	return skb->ulp_crc;
+#else
+	return 0;
+#endif
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c2b15f7e5516..2ba73167b3bb 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -68,6 +68,8 @@ struct inet_connection_sock_af_ops {
  * @icsk_ulp_ops	   Pluggable ULP control hook
  * @icsk_ulp_data	   ULP private data
  * @icsk_clean_acked	   Clean acked data hook
+ * @icsk_ulp_ddp_ops	   Pluggable ULP direct data placement control hook
+ * @icsk_ulp_ddp_data	   ULP direct data placement private data
  * @icsk_ca_state:	   Congestion control state
  * @icsk_retransmits:	   Number of unrecovered [RTO] timeouts
  * @icsk_pending:	   Scheduled timer event
@@ -98,6 +100,8 @@ struct inet_connection_sock {
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
 	void __rcu		  *icsk_ulp_data;
 	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
+	const struct ulp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
+	void __rcu		  *icsk_ulp_ddp_data;
 	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
 	__u8			  icsk_ca_state:5,
 				  icsk_ca_initialized:1,
diff --git a/include/net/ulp_ddp.h b/include/net/ulp_ddp.h
new file mode 100644
index 000000000000..b190db140367
--- /dev/null
+++ b/include/net/ulp_ddp.h
@@ -0,0 +1,182 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * ulp_ddp.h
+ *	Author:	Boris Pismenny <borisp@nvidia.com>
+ *	Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
+ */
+#ifndef _ULP_DDP_H
+#define _ULP_DDP_H
+
+#include <linux/netdevice.h>
+#include <net/inet_connection_sock.h>
+#include <net/sock.h>
+
+enum ulp_ddp_type {
+	ULP_DDP_NVME = 1,
+};
+
+enum ulp_ddp_offload_capabilities {
+	ULP_DDP_C_NVME_TCP = 1,
+	ULP_DDP_C_NVME_TCP_DDGST_RX = 2,
+};
+
+/**
+ * struct ulp_ddp_limits - Generic ulp ddp limits: tcp ddp
+ * protocol limits.
+ * Protocol implementations must use this as the first member.
+ * Add new instances of ulp_ddp_limits below (nvme-tcp, etc.).
+ *
+ * @type:		type of this limits struct
+ * @offload_capabilities:bitmask of supported offload types
+ * @max_ddp_sgl_len:	maximum sgl size supported (zero means no limit)
+ * @io_threshold:	minimum payload size required to offload
+ * @buf:		protocol-specific limits struct (if any)
+ */
+struct ulp_ddp_limits {
+	enum ulp_ddp_type	type;
+	u64			offload_capabilities;
+	int			max_ddp_sgl_len;
+	int			io_threshold;
+	unsigned char		buf[];
+};
+
+/**
+ * struct nvme_tcp_ddp_limits - nvme tcp driver limitations
+ *
+ * @lmt:		generic ULP limits struct
+ * @full_ccid_range:	true if the driver supports the full CID range
+ */
+struct nvme_tcp_ddp_limits {
+	struct ulp_ddp_limits	lmt;
+
+	bool			full_ccid_range;
+};
+
+/**
+ * struct ulp_ddp_config - Generic ulp ddp configuration: tcp ddp IO queue
+ * config implementations must use this as the first member.
+ * Add new instances of ulp_ddp_config below (nvme-tcp, etc.).
+ *
+ * @type:	type of this config struct
+ * @buf:	protocol-specific config struct
+ */
+struct ulp_ddp_config {
+	enum ulp_ddp_type    type;
+	unsigned char        buf[];
+};
+
+/**
+ * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
+ *
+ * @cfg:	generic ULP config struct
+ * @pfv:	pdu version (e.g., NVME_TCP_PFV_1_0)
+ * @cpda:	controller pdu data alignment (dwords, 0's based)
+ * @dgst:	digest types enabled (header or data, see enum nvme_tcp_digest_option).
+ *		The netdev will offload crc if it is supported.
+ * @queue_size: number of nvme-tcp IO queue elements
+ * @queue_id:	queue identifier
+ * @io_cpu:	cpu core running the IO thread for this queue
+ */
+struct nvme_tcp_ddp_config {
+	struct ulp_ddp_config	cfg;
+
+	u16			pfv;
+	u8			cpda;
+	u8			dgst;
+	int			queue_size;
+	int			queue_id;
+	int			io_cpu;
+};
+
+/**
+ * struct ulp_ddp_io - ulp ddp configuration for an IO request.
+ *
+ * @command_id: identifier on the wire associated with these buffers
+ * @nents:	number of entries in the sg_table
+ * @sg_table:	describing the buffers for this IO request
+ * @first_sgl:	first SGL in sg_table
+ */
+struct ulp_ddp_io {
+	u32			command_id;
+	int			nents;
+	struct sg_table		sg_table;
+	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
+};
+
+/* struct ulp_ddp_dev_ops - operations used by an upper layer protocol
+ *                          to configure ddp offload
+ *
+ * @ulp_ddp_limits:    query ulp driver limitations and quirks.
+ * @ulp_ddp_sk_add:    add offload for the queue represented by socket+config
+ *                     pair. this function is used to configure either copy, crc
+ *                     or both offloads.
+ * @ulp_ddp_sk_del:    remove offload from the socket, and release any device
+ *                     related resources.
+ * @ulp_ddp_setup:     request copy offload for buffers associated with a
+ *                     command_id in ulp_ddp_io.
+ * @ulp_ddp_teardown:  release offload resources association between buffers
+ *                     and command_id in ulp_ddp_io.
+ * @ulp_ddp_resync:    respond to the driver's resync_request. Called only if
+ *                     resync is successful.
+ */
+struct ulp_ddp_dev_ops {
+	int (*ulp_ddp_limits)(struct net_device *netdev,
+			      struct ulp_ddp_limits *limits);
+	int (*ulp_ddp_sk_add)(struct net_device *netdev,
+			      struct sock *sk,
+			      struct ulp_ddp_config *config);
+	void (*ulp_ddp_sk_del)(struct net_device *netdev,
+			       struct sock *sk);
+	int (*ulp_ddp_setup)(struct net_device *netdev,
+			     struct sock *sk,
+			     struct ulp_ddp_io *io);
+	int (*ulp_ddp_teardown)(struct net_device *netdev,
+				struct sock *sk,
+				struct ulp_ddp_io *io,
+				void *ddp_ctx);
+	void (*ulp_ddp_resync)(struct net_device *netdev,
+			       struct sock *sk, u32 seq);
+};
+
+#define ULP_DDP_RESYNC_PENDING BIT(0)
+
+/**
+ * struct ulp_ddp_ulp_ops - Interface to register uppper layer
+ *                          Direct Data Placement (DDP) TCP offload.
+ * @resync_request:         NIC requests ulp to indicate if @seq is the start
+ *                          of a message.
+ * @ddp_teardown_done:      NIC driver informs the ulp that teardown is done,
+ *                          used for async completions.
+ */
+struct ulp_ddp_ulp_ops {
+	bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
+	void (*ddp_teardown_done)(void *ddp_ctx);
+};
+
+/**
+ * struct ulp_ddp_ctx - Generic ulp ddp context: device driver per queue contexts must
+ * use this as the first member.
+ *
+ * @type:	type of this context struct
+ * @buf:	protocol-specific context struct
+ */
+struct ulp_ddp_ctx {
+	enum ulp_ddp_type	type;
+	unsigned char		buf[];
+};
+
+static inline struct ulp_ddp_ctx *ulp_ddp_get_ctx(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	return (__force struct ulp_ddp_ctx *)icsk->icsk_ulp_ddp_data;
+}
+
+static inline void ulp_ddp_set_ctx(struct sock *sk, void *ctx)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	rcu_assign_pointer(icsk->icsk_ulp_ddp_data, ctx);
+}
+
+#endif	/* _ULP_DDP_H */
diff --git a/net/Kconfig b/net/Kconfig
index 48c33c222199..cd59be2d6c6e 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -471,4 +471,14 @@ config NETDEV_ADDR_LIST_TEST
 	default KUNIT_ALL_TESTS
 	depends on KUNIT
 
+config ULP_DDP
+	bool "ULP direct data placement offload"
+	default n
+	help
+	  Direct Data Placement (DDP) offload enables ULP, such as
+	  NVMe-TCP, to request the NIC to place ULP payload data
+	  of a command response directly into kernel pages while
+	  calculate/verify the data digest on ULP PDU as they go through
+	  the NIC. Thus avoiding the costly per-byte overhead.
+
 endif   # if NET
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9b3b19816d2d..ff80667adb14 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/ulp_ddp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6416,7 +6417,7 @@ void skb_condense(struct sk_buff *skb)
 {
 	if (skb->data_len) {
 		if (skb->data_len > skb->end - skb->tail ||
-		    skb_cloned(skb))
+		    skb_cloned(skb) || skb_is_ulp_ddp(skb))
 			return;
 
 		/* Nice, we can free page frag(s) right now */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index ee3e02da0013..5636ef148b4d 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -74,6 +74,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_HSR_TAG_RM_BIT] =	 "hsr-tag-rm-offload",
 	[NETIF_F_HW_HSR_FWD_BIT] =	 "hsr-fwd-offload",
 	[NETIF_F_HW_HSR_DUP_BIT] =	 "hsr-dup-offload",
+	[NETIF_F_HW_ULP_DDP_BIT] =	 "ulp-ddp-offload",
 };
 
 const char
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0640453fce54..df37db420110 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5233,6 +5233,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
 #ifdef CONFIG_TLS_DEVICE
 		nskb->decrypted = skb->decrypted;
+#endif
+#ifdef CONFIG_ULP_DDP
+		nskb->ulp_ddp = skb->ulp_ddp;
+		nskb->ulp_crc = skb->ulp_crc;
 #endif
 		TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
 		if (list)
@@ -5266,6 +5270,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 #ifdef CONFIG_TLS_DEVICE
 				if (skb->decrypted != nskb->decrypted)
 					goto end;
+#endif
+#ifdef CONFIG_ULP_DDP
+				if (skb_is_ulp_crc(skb) != skb_is_ulp_crc(nskb))
+					goto end;
 #endif
 			}
 		}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 87d440f47a70..e3d884b3bde7 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1821,6 +1821,9 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	      TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_ECE | TCPHDR_CWR)) ||
 #ifdef CONFIG_TLS_DEVICE
 	    tail->decrypted != skb->decrypted ||
+#endif
+#ifdef CONFIG_ULP_DDP
+	    skb_is_ulp_crc(tail) != skb_is_ulp_crc(skb) ||
 #endif
 	    thtail->doff != th->doff ||
 	    memcmp(thtail + 1, th + 1, hdrlen - sizeof(*th)))
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 45dda7889387..2e62f18e85c0 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -268,6 +268,9 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 #ifdef CONFIG_TLS_DEVICE
 	flush |= p->decrypted ^ skb->decrypted;
 #endif
+#ifdef CONFIG_ULP_DDP
+	flush |= skb_is_ulp_crc(p) ^ skb_is_ulp_crc(skb);
+#endif
 
 	if (flush || skb_gro_receive(p, skb)) {
 		mss = 1;
-- 
2.31.1

