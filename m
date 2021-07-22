Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003FB3D227E
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhGVKZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:42 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:14336
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231820AbhGVKZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnX+MsETKv22jn+k/K3vPLr+vGoHr80V1mBQXRqLI3BobQpe8dfB5khYdsAqLIe+yuVbuTfykJrtqsejNNzU/voPAsi/3G5DTyBglnws8/qOA9QT/MTIbk1Bm814Jrxs+fM2OvtRoV94FzzLl6njtrq6kqyFAClbneoygo25/eVD3ZwhUqLBZEnzbyaNmJWMD8myGXwSDHvLfu2eILUnPHgtWnEj7QPyivuoz2Rga4G9AWH7AVd7meR2CgH8jLih1vjh5oG+nnIrZooNGakx+hgV2ZKoJHPAQO8hc8QwiLgaXmAStDHQAIZne9Oh+b8YRrq5d9O6w8kX2fkc7/blJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAxudF1Jfwqss5SzIz9EI8r0/Xlh8GGDSBsDbv2ESKk=;
 b=gJjxquzliaaWTnVozCgk9u3kes+hVARJarjFL2kXv39x5C06P5XdMHU27hpb0Ws9BnZCt4ZNocTJISwEdGe4XnF9pzPWxYYdyomtBIraiPszY5r09ZwN+qcwWD+Sd2WJqqytEQt/oRAt2eSTXXHBugxr49Et6Z3F+IDQIQjnKC+6Gct9mwibEs1JmCxEIkN/u5wn8mKaYquF0cF5DPL7AJFzcGOeSppeHRbXsiQBfE7RuwaAWlk7ndAZvTz2G+mmHNB/IfYXfHYdvKpe731QdDubykW1UhY0DcyJxso4lemMa6KvH0VET/CD+IDnhw+HAVOtQGktfoXcG3l7aL1Ejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAxudF1Jfwqss5SzIz9EI8r0/Xlh8GGDSBsDbv2ESKk=;
 b=TsHNHcYWUpTMdoZ0TOlAWI0jHH/vpXRN/Mb5zwuj0L3+CR7mslcSZ4eFyJmGizcePJ//JiOlhedZ9NnvtslzWOXvlQmGywgIHioXiEfJTSEB2sFBhWSJlJrm8Xuo4i+pW+0PstxQvWS37XHfG2Udgh3ytLl0cdysl7RUI6Y9x1YqXbOu8l58tsqBAUJFWzAzLwsNXWZHmgRgbxD1oIBdpV+upQULsNYgL2rDCGi0rRfxPSvMvw7fDj4Rca2zraLspaYJS/WJ4sXO0nV1Qpevnu6Y7FLZGix+qFY6fueyTu0I3baBwZaYfKPfhF1LsWxBt4YsSkadCUlzkmAVewth/A==
Received: from MWHPR12CA0062.namprd12.prod.outlook.com (2603:10b6:300:103::24)
 by BL0PR12MB2468.namprd12.prod.outlook.com (2603:10b6:207:44::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 11:06:05 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:103:cafe::1d) by MWHPR12CA0062.outlook.office365.com
 (2603:10b6:300:103::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:04 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:06:04 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:00 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 23/36] net: Add to ulp_ddp support for fallback flow
Date:   Thu, 22 Jul 2021 14:03:12 +0300
Message-ID: <20210722110325.371-24-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4473b2b8-a685-4394-675f-08d94d00b32a
X-MS-TrafficTypeDiagnostic: BL0PR12MB2468:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2468DC9A5A2936F4A379C6C8BDE49@BL0PR12MB2468.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQlVI+xvg4TqqtGi35sGzz1I74C137j84BQOjOfR5Uz4ppoeK7EDB0XtZtmhe5OjQUVhAKxhqONeqtzlibEvwQMUYAy7KsDuwRT8yDwh361ToXV8avS03RCY7bl9T3DmYX1TCTZCBFdarMu9f5dlKYZBQgnaLz37R4DCkbelqkvHrw1CeE4+9xvKTj4idi9zSZPGRKkGFyaU/bF4/90miPfATLLzKqJsVbkdDBjLOUb/SlHlf44veHsJoTxvDi9Q2KZqxT3uAZFInd9rX+AFjqSKrzzcSSqr3TY31Y4TXKOOGGkOujvpaKBDNOuyXADkkFcRo2dE95U2wr7X86PJ7/VSLnViEePhkdmkLcYX5agkrwhrFgqQ+cj8QnmaRh+jDAo1mPh4R+GoOM21rfnFFw7ngMfGQL+e7vxEUckTp/0YONYrkG69H1ZL0aCq1xsV6Klkk4q310ZEPXscZR9ygUWXTQQx7uSE9sqRLtTZwI4NjYjWqqXpsR1Sz0q1yOjdca1qeDpwEzzmvyqZ+R5Hi9Z9gwbD3zHs7x+w6JI4NMCj4kRXGbm0WV+mG5ffDpoR9dhTLmJJpVG+zIdw2AKoHDKl1XJfFQoE3SxC7jzuyUxe/YrqPPmADgRAlDt3CwhH4mLXkfza3VvAY7uedW7qkhpHXhaVOOdw000mNDqgN1+4MRTfZm7aCSR/G8N8Yq1C00IvQpYnKdbQ6ApaAXbRtIy8LXm7wE2gLG6AyeGwR5o=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(36840700001)(46966006)(8936002)(86362001)(426003)(36860700001)(36756003)(7696005)(336012)(107886003)(36906005)(921005)(316002)(478600001)(7416002)(2906002)(8676002)(54906003)(186003)(1076003)(110136005)(2616005)(70206006)(47076005)(5660300002)(82310400003)(70586007)(4326008)(6666004)(83380400001)(26005)(356005)(82740400003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:04.9735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4473b2b8-a685-4394-675f-08d94d00b32a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2468
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

Add ddp_ddgest_falback(), and ddp_get_pdu_info function to ulp.

During DDP CRC Tx offload, the HW is responsible for calculate the crc,
and therefore the SW not calculates it.

If the HW changes for some reason,
the SW should fallback from the offload and calculate the crc.
This is checking in the ulp_ddp_validate_skb and if need fallback it do it.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 include/net/ulp_ddp.h |  7 +++++
 net/core/ulp_ddp.c    | 69 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/include/net/ulp_ddp.h b/include/net/ulp_ddp.h
index 8f48fc121c3a..40bfcfe94cef 100644
--- a/include/net/ulp_ddp.h
+++ b/include/net/ulp_ddp.h
@@ -77,6 +77,7 @@ struct ulp_ddp_io {
  * @hdr_len:	the size (in bytes) of the pdu header.
  * @hdr:	pdu header.
  * @req:	the ulp request for the original pdu.
+ * @ddgst:	pdu data digest.
  */
 struct ulp_ddp_pdu_info {
 	struct list_head list;
@@ -86,6 +87,7 @@ struct ulp_ddp_pdu_info {
 	u32		hdr_len;
 	void		*hdr;
 	struct request	*req;
+	__le32          ddgst;
 };
 
 /* struct ulp_ddp_dev_ops - operations used by an upper layer protocol to configure ddp offload
@@ -129,6 +131,8 @@ struct ulp_ddp_ulp_ops {
 	bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
 	/* NIC driver informs the ulp that ddp teardown is done - used for async completions*/
 	void (*ddp_teardown_done)(void *ddp_ctx);
+	/* NIC request ulp to calculate the ddgst and store it in pdu_info->ddgst */
+	void (*ddp_ddgst_fallback)(struct ulp_ddp_pdu_info *pdu_info);
 };
 
 /**
@@ -182,4 +186,7 @@ int ulp_ddp_map_pdu_info(struct sock *sk, u32 start_seq, void *hdr,
 void ulp_ddp_close_pdu_info(struct sock *sk);
 bool ulp_ddp_need_map(struct sock *sk);
 struct ulp_ddp_pdu_info *ulp_ddp_get_pdu_info(struct sock *sk, u32 seq);
+struct sk_buff *ulp_ddp_validate_xmit_skb(struct sock *sk,
+					  struct net_device *dev,
+					  struct sk_buff *skb);
 #endif //_ULP_DDP_H
diff --git a/net/core/ulp_ddp.c b/net/core/ulp_ddp.c
index 06ed4ad59e88..80366c7840a8 100644
--- a/net/core/ulp_ddp.c
+++ b/net/core/ulp_ddp.c
@@ -164,3 +164,72 @@ struct ulp_ddp_pdu_info *ulp_ddp_get_pdu_info(struct sock *sk, u32 seq)
 	return info;
 } EXPORT_SYMBOL(ulp_ddp_get_pdu_info);
 
+static void ulp_ddp_ddgst_recalc(const struct ulp_ddp_ulp_ops *ulp_ops,
+				 struct ulp_ddp_pdu_info *pdu_info)
+{
+	if (pdu_info->ddgst)
+		return;
+
+	ulp_ops->ddp_ddgst_fallback(pdu_info);
+}
+
+static struct sk_buff *ulp_ddp_fallback_skb(struct ulp_ddp_ctx *ctx,
+					    struct sk_buff *skb,
+					    struct sock *sk)
+{
+	const struct ulp_ddp_ulp_ops *ulp_ops = inet_csk(sk)->icsk_ulp_ddp_ops;
+	int datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	struct ulp_ddp_pdu_info *pdu_info = NULL;
+	int ddgst_start, ddgst_offset, ddgst_len;
+	u32 seq = ntohl(tcp_hdr(skb)->seq);
+	u32 end_skb_seq = seq + datalen;
+	u32 first_seq = seq;
+
+	if (!(ulp_ops && ulp_ops->ddp_ddgst_fallback))
+		return skb;
+
+again:
+	/*  check if we can't use the last pdu_info
+	 *  Reasons we can't use it:
+	 *  1. first time and then pdu_info is NULL.
+	 *  2. seq doesn't Map to this pdu_info (out of bounds).
+	 */
+	if (!pdu_info || !between(seq, pdu_info->start_seq, pdu_info->end_seq - 1)) {
+		pdu_info = ulp_ddp_get_pdu_info(sk, seq);
+		if (!pdu_info)
+			return skb;
+	}
+
+	ddgst_start = pdu_info->end_seq - ctx->ddgst_len;
+
+	//check if this skb contains ddgst field
+	if (between(ddgst_start, seq, end_skb_seq - 1) && pdu_info->data_len) {
+		ulp_ddp_ddgst_recalc(ulp_ops, pdu_info);
+		ddgst_offset = ddgst_start - first_seq + skb_headlen(skb);
+		ddgst_len = min_t(int, ctx->ddgst_len, end_skb_seq - ddgst_start);
+		skb_store_bits(skb, ddgst_offset, &pdu_info->ddgst, ddgst_len);
+	}
+
+	//check if there is more PDU's in this skb
+	if (between(pdu_info->end_seq, seq + 1, end_skb_seq - 1)) {
+		seq = pdu_info->end_seq;
+		goto again;
+	}
+
+	return skb;
+}
+
+struct sk_buff *ulp_ddp_validate_xmit_skb(struct sock *sk,
+					  struct net_device *dev,
+					  struct sk_buff *skb)
+{
+	struct ulp_ddp_ctx *ctx = ulp_ddp_get_ctx(sk);
+
+	if (!ctx)
+		return skb;
+
+	if (dev == ctx->netdev)
+		return skb;
+
+	return ulp_ddp_fallback_skb(ctx, skb, sk);
+} EXPORT_SYMBOL(ulp_ddp_validate_xmit_skb);
-- 
2.24.1

