Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74773DCAD8
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 11:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhHAJGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 05:06:37 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.6]:41936 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbhHAJGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 05:06:36 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Aug 2021 05:06:36 EDT
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BF25516AD02
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 09:01:20 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03lp2056.outbound.protection.outlook.com [104.47.10.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 944CD9C0081;
        Sun,  1 Aug 2021 09:01:18 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIPtubBwoxczcN9d7q5TyxJ8uKf6U8Nm0im4eyzMVy57qfkiL2NNyXJAtQ0LSFii0s/EICoNmRYGgiv1+z/94RvK+DSEVfLCE6aYNKUJyv16CJfGg2gbAyEAJs9GVyoGtEFYlcyjJliYbDBnbOWuDDWtR25ap1OGbOSSzQNODbnjp0Q3onpeMuI0a2g/hC89sa0UpACU1d74Ik53nmFJXaQTkSldkcK8HlOByL95/rczR8BzXURma1Iccn2Vi/jLrJ6o3pCkNLiyvhVaoNtoA1czTDlDvyCb2iGzdQDbLBwykt1PO8GE9lqm4LzYZ7D/cNWqxrNnhWSt5DLrRwnjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSU6abbnGDFwOh3LsAzJ4luG9WN+Nnt6RT7j79UpiIU=;
 b=Ij6O4RkTdMUImvYJBTNA7lqnpUGEpTXQ+mKNiEk9I/D9xM/qmFg6eilWwXQvMT6nqBIb9Xeh0iF04HjcEAVh/Wzdyp7E5dELnijG6trV0lImmAzWm6NMrCEdphgi1+oLtyhy59OimTjXshbUo8BoAHBUg/6ADpFW34aWviiTcHhcACxk+DKVb1wbQnoT3/jOn00kaqNSjGKsh3ek9nPrqgDyQq1MAa02GxEg4x4ynK5/qw+itWS54s8HtHAwIRqQ1VcEg5MeJ6HjbhBQXkFdxq1EkGNyMfXStuxQDcCgsz0NO0YA3xk6K8fCT50S2mYQnkENp69gAdc6gyEOr9/A5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSU6abbnGDFwOh3LsAzJ4luG9WN+Nnt6RT7j79UpiIU=;
 b=iDffq0Fm7eSP2uRptdsOJRSSTFu2HG7ujuLBLlkjCZ3v3wf+rm0Vj4iylrkR9t/AnzNyVgydpH9gw0gM5V9P42P3dyyMQtk7S+l8Hf1Zhtq4pRQk7EoFStO04Ed/qoUkfFhEvIYwWgImokdNKdiZetA0lU2F97tFl6m8fdGIDQk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB3470.eurprd08.prod.outlook.com (2603:10a6:803:7c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sun, 1 Aug
 2021 09:01:16 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 09:01:16 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
Subject: [PATCH] neigh: Support filtering neighbours for L3 slave
Date:   Sun,  1 Aug 2021 12:01:05 +0300
Message-Id: <20210801090105.27595-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0073.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::6) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kgollan-pc.dev.drivenets.net (199.203.244.232) by LO4P123CA0073.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:190::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Sun, 1 Aug 2021 09:01:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc4aaa25-9e03-4355-a512-08d954caebb5
X-MS-TrafficTypeDiagnostic: VI1PR08MB3470:
X-Microsoft-Antispam-PRVS: <VI1PR08MB34709D7B3017B6CCE1D71831CCEE9@VI1PR08MB3470.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQbsn6lKUGKwojZF+zjdzx24bsvGqUTIYnMTtgovKvop3Hfz62Xj1j84n1jCnn5T/eZygBNLv2WdChbqy8Y/XaupwYt7Q7DsKhok2kVSsn23zPNYdurvxkBotzgZbjxGp5s6Qcu4uZpLnDJay1e2kW5/B2Z1gTGlaNSNR51nyL1zfTAPmN/QfsYUZkAzMyyn+S/w8hV6u3cCz93OVMfJFAl0AkPvfmO02w99pU7860VuTRksCUheEUKQJrODfTa7y4t7nLD0RPu9mCkoEAEERt9BBtXpUUvCID/hRqwZKhHTv/EszgHNG7fbetQwj0qWUmUPKxhhR4tyWp3XJTC1vFIutPw45D7+N+PeBjZwx9cdHH71fpzyonEG8pKCmbPNUBEPnVNSiYnAW87GE/gl/ClxtdgJZZTSlO2/Vv4t0HIzV1BtbfdYne+pK2EEbDselHryj9sYeG87AzYPC220N4b5nugJmHPVyiAveRFnr4TJDlsLE6P8hL4d7MjawWZwIZao1ZEneS2aBA11Q1QMn7A6mDGcd+C09eRSoAMLV/Itiwr59kqN1qhUlkRanZyF1NybkaLqxj+OkpHh+sv+IqEPFQq+Nj3x3lKU6lZuxY2QYIPeEKDw1rdGILCz49tBQy34Q73eJNu5FCvfDlBHRnXvIx5QoM+jtOMJkg4zvb9nwbITcCplfDuwUx8R+G29afCC/TS97Ojx5fu/NdLuUicvvbJb5EH/BH3nko7h8Co=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(396003)(366004)(376002)(66476007)(38350700002)(38100700002)(66556008)(316002)(6512007)(4326008)(6916009)(6486002)(1076003)(956004)(2616005)(52116002)(66946007)(6506007)(8676002)(86362001)(2906002)(83380400001)(36756003)(6666004)(26005)(8936002)(478600001)(186003)(5660300002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W5VTZ9bBi0mLTNoRiLeJ6Ng2WO1CWezBWA3HthiOdqmm62pLMAMLRvhrxu6s?=
 =?us-ascii?Q?v4uG0O8bO2JpHPfVVNAwezmmNQwF0tlqX5u8/1Lz/Wg/k9YorllysVsw8Y0h?=
 =?us-ascii?Q?9qky3Xh71M+V5rSeI5OaDslnZh7HwE9zaZ0DgwOgxTYubO/wlIitKxjmkor7?=
 =?us-ascii?Q?whS7iz7vWxj/qw/tlG6x1UdjjaYBRz1pI3oym0pu4B8CBT/5D7vPV+KHCrxG?=
 =?us-ascii?Q?s4lJzA3Dj27TX+jaQk3PRneJn8IWFlskqUKlbFrRHYAAEQuC0NqCTt8WvE1R?=
 =?us-ascii?Q?tEGq/CGoTvbP+AXGgK5Yeww7yZXP8UG5dKTg+/HIB00XJQUU1PamMedBVDf9?=
 =?us-ascii?Q?y7wYCVteuS3u2BCRsxbwaSme5/qIUzTw4S1BCTr4YQFR59fZ+/gzclwwnGCU?=
 =?us-ascii?Q?B9QlCq//rKka/CezStpFqQPnUb/D/DvrIkcIiJK/d4TaZEpd1yLhGaB0BPMV?=
 =?us-ascii?Q?YTCWxKc6QsSOtjzaLop4bpJo/+YHoxb4bCdf1+kP7fV0SSB450b5NtABr3MP?=
 =?us-ascii?Q?4RctIlUk5762uTN6oKmoV21Ozj7OybqH8Epj0lfUUdIJnCXYwUTWs17aIXXH?=
 =?us-ascii?Q?XewDiKPrydnooZ8wD5+71V7C8tboQmbIXws4jlxRXIWXcSOQk9oVOcyaNcy4?=
 =?us-ascii?Q?EMecdI3vtRKpbhthiwvfdecZkpMosk/VtgPT8ko4TgELAnyXYF2X4CKZuaU9?=
 =?us-ascii?Q?5f3y+A5kN1h43eK7gMgShe1kKTql1a6ynWsJHrmICv3Ailn0wGskphxXv9MU?=
 =?us-ascii?Q?OC7gEV7MWV4OVXGcTttTedHep4RqagISZUT+ur2u1sjGDkcMOMGHAqK4yOON?=
 =?us-ascii?Q?z0NKujCkDs3BY9LR9wMiqCc3x3Tcux8warwnIHLlyhFy+8Qu7aiDfiNJyM7o?=
 =?us-ascii?Q?+kn68TMQ2KIEzXAJY4icwdhald6pU+RnObBEmqfl9Ir/XRnzbdTkaVLGJdmK?=
 =?us-ascii?Q?gE9xKMIPGsh1qaEEdKIQr021awv9Doperx4lzb3SYXm1IoNx/gOp+1neXXCS?=
 =?us-ascii?Q?V7K/yoF2/7DBypCv03t7kOVub0Rw+TQ5wE3VtBfmYzGaU7X6CfsfuXC4qY1c?=
 =?us-ascii?Q?BvJAFCMOBnP/KKl5wtQJdm/A0JeCkHd13jgQ7ftaQQq/ofVAjU7qzWfmpq93?=
 =?us-ascii?Q?woglkYYrXFZI3TmtFjFjS5dnTVXOQoXGnshcT7xk2tV6iIUFRymyV0I8p16C?=
 =?us-ascii?Q?SGl1etp/7aH2NtTCCSL6RJyMyY1fcPyRUWs8iDVp2bmwOV3/wVns/yCnvYZv?=
 =?us-ascii?Q?eEnNMuQsDi9jqOjcryEdnokAn8bDdYYErCByxqkrHfP4NS87LRW9w30wYXth?=
 =?us-ascii?Q?Mad6w1lKiMkt8PWM1jtU3K4L?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4aaa25-9e03-4355-a512-08d954caebb5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 09:01:16.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/163B4i0nOVrQVBs4nIkCJ/Np6p6b6lL2kje4HVo9lejsRqbHaZbrjfpgC0cW8CjHsjyQQ+G+KMBFaNtn+9Z0RwRGAWLjjMX/nUGjS+FyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3470
X-MDID: 1627808479-lU-YF4OgcLSj
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there's support for filtering neighbours for interfaces which
are in a specific VRF (passing the VRF interface in 'NDA_MASTER'), but
there's not support for filtering interfaces which are not in an L3
domain (the "default VRF").

This means userspace is unable to show/flush neighbours in the default VRF
(in contrast to a "real" VRF - Using "ip neigh show vrf <vrf_dev>").

Therefore for userspace to be able to do so, it must manually iterate
over all the interfaces, check each one if it's in the default VRF, and
if so send the matching flush/show message.

This patch adds the ability to do so easily, by passing a dummy value as
the 'NDA_MASTER' ('NDV_NOT_L3_SLAVE').
Note that 'NDV_NOT_L3_SLAVE' is a negative number, meaning it is not a valid
ifindex, so it doesn't break existing programs.

I have a patch for iproute2 ready for adding this support in userspace.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
---
 include/uapi/linux/neighbour.h | 2 ++
 net/core/neighbour.c           | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index dc8b72201f6c..d4f4c2189c63 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -196,4 +196,6 @@ enum {
 };
 #define NFEA_MAX (__NFEA_MAX - 1)
 
+#define NDV_NOT_L3_SLAVE	(-10)
+
 #endif
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 53e85c70c6e5..b280103b6806 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2529,6 +2529,9 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
 {
 	struct net_device *master;
 
+	if (master_idx == NDV_NOT_L3_SLAVE)
+		return netif_is_l3_slave(dev);
+
 	if (!master_idx)
 		return false;
 
-- 
2.17.1

