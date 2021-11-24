Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3088D45CA99
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241612AbhKXRJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:09:41 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:39458 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241709AbhKXRJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:09:33 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Nov 2021 12:09:32 EST
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E7B7016B401
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 17:00:30 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ED56174007D;
        Wed, 24 Nov 2021 17:00:28 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APJIfXpduzkr36LV3DjpasI4NQD/yX1FRBdcWvWK5nSmspEi4mMmlDDawwrVJiTB6q26cMVBl57T4QEbpXRa1VhtjgjOWfAP0vtIfzeRirCIEaM90JNdSZnwywGddh6NJwI1UdfJH/lSoj/F45UztLqfqHqWfZOaaH7IQvb9rKcA8q/9VJzovH3MAbF5YbxfEzzhx8w0sqeXjMrugN4OsMkjAKXmwRYWOBoye+ri8gcsTxp3tfhEQzBzUjT1IcLsRpbTo9T3XzWeUMp2b/fm7xa40J0HVObUdIw+AbtCtnV/JBENUD44mWMyD9zD+fmvtzMl13+39wbR27zn6039wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+HQuU4UbCI5+mrc9MjfLkM12uMPfZiYReNhYgASqGE=;
 b=kCMdhiinjzvDNxAdYm8PenhCd3+DVb6s/mJ0eNrTe1FKoqeJM36PHfhY1TdBRObmsfYQ9V4De7cOJR6Q8Y42Ud+CgqbCSYgqeKwAflXTUuuDJU1Z8TBG5Rmrx4Mc9fgQavFl4hVLChMSx02LvcRU9ioCxNYtL9vc8MpMhC//5TrgV+vt2RZ9PGc6ODT7E/ybZai73kOQaZOJQak2iW+GK5mat1T6bm4ePizb9/qR4T/QYktDRHX5wF2yke9s4ibhLnGaA444Bsv9Kia25rsq3Pb+0Y2GOjsGSDERBmsZvn2KfccKKO5OfPsqYHFSBkqwis4oVytH2WGeTj8SEQqcFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+HQuU4UbCI5+mrc9MjfLkM12uMPfZiYReNhYgASqGE=;
 b=tQfdKyFss1lzGRosirbld9NVfaCfkc8B7C6+OxNbAR0YXcvSjfiTSvY3o5p5BYQASMOHK9bOdeA0T/pYtulTtIxZOFiK8Pzyph1NYdbL9nWzSBVBfGp2psdDquxK8ghKEjrKvUX2IibLR4iOYJixqLL5LAweIV7kE566Eh0mJsk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AM6PR08MB3640.eurprd08.prod.outlook.com (2603:10a6:20b:4c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 17:00:28 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::b4f8:17a9:939c:d75d]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::b4f8:17a9:939c:d75d%7]) with mapi id 15.20.4713.027; Wed, 24 Nov 2021
 17:00:28 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     kuba@kernel.org
Cc:     dsahern@gmail.com, lschlesinger@drivenets.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] rtnetlink: Support fine-grained netdevice bulk deletion
Date:   Wed, 24 Nov 2021 18:59:42 +0200
Message-Id: <20211124165942.2514302-1-gnaaman@drivenets.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211124061507.09fccc97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211124061507.09fccc97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0034.eurprd04.prod.outlook.com
 (2603:10a6:208:122::47) To AM6PR08MB4118.eurprd08.prod.outlook.com
 (2603:10a6:20b:aa::25)
MIME-Version: 1.0
Received: from gnaaman-pc.dev.drivenets.net (82.166.105.36) by AM0PR04CA0034.eurprd04.prod.outlook.com (2603:10a6:208:122::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Wed, 24 Nov 2021 17:00:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 095430ba-e60b-455a-c6e2-08d9af6bea5b
X-MS-TrafficTypeDiagnostic: AM6PR08MB3640:
X-Microsoft-Antispam-PRVS: <AM6PR08MB36405C8D8E852407A2108B5BBE619@AM6PR08MB3640.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9d3AVJVzCMHHghCPRBhdA5MMdDnSx0A4VdVqZYZg0IUnWrf89EOVo3vyHlQO1rVrH0lKLDUdrQZIQdo1h1NxqShmdMNtgkvxRopzcSPEcdVypxD9UdeAfgwXDtAzB9WqZ0+WuMtFcGfIIlehykDNigoPCJzNLxuk31tfBy644NP8XxrzzhepVPwVrZbNiWUiunAgn8T77nW0AbQUN2keie+QiXrbggHzAdyJPzE29Q9MvdD+HK4zSp1fTtc7FqX3tg/HALTn5i7qgSQcVQYXH2HU+DTdc30JGiMeCsA3hIJn6Glxyi+dUBD3rt8ngV22l4CYrGkwnLwLO61WOqEMhLIRFh0rnyy/bt/KZPMl4d0bmtQz+BovpAhnalBxhp6YJaraGxzWYivFdErdReUqfs6f5/TTn0zdBadKWvai3gW1HY/5MIRxJdab4dFHfMNNJVIe9CNFoXrmyexOtBjc2hD3aK9afCGrlb10A4NpJLhukPBZY6gR0WpVtXCGK6zwhbvVLfHfkUJJf6eqwyx13mPZFWhO/eE5zCHwFEs8+MZME3xO0eVcK1eWj8m0OSuoMbO+JKRGJ8J2nXHayl2d5JCTSxUfS6s2LkzM/OoqmPVu2Vl8rzYqVYUucWRQg7VXT107P/GfCKLkdX+YQ6ESwnJTm1bg/Exx6pcYPy+RLyuqYLITp6W4IeIyIx0cc90MhjFziL59md5AbM+x+bxSpM+QPNBLcVk+YAg35+L8HWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(316002)(38100700002)(8676002)(86362001)(38350700002)(4326008)(6666004)(6512007)(5660300002)(6506007)(52116002)(26005)(2906002)(83380400001)(8936002)(36756003)(66556008)(66476007)(66946007)(66574015)(508600001)(956004)(2616005)(1076003)(186003)(6486002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkVuK/wDS8TjNpMdnLPBqX1IVWGz2WjcE/KZdIEnW96sSotIw1FhTOUx1mWB?=
 =?us-ascii?Q?7qppbqzbq/zKhnLXjN1m7f1cN7saBnIfIn2XQwef0hw0xbRDZcgW4+yJlIZM?=
 =?us-ascii?Q?McDYvqptkJZzLcBUq9i8+enU6U+vQ/Ar4wG5cNz0l3Hqmz3+OhM+c6noivwl?=
 =?us-ascii?Q?c4PhguLzpZIBPepDpPnkUfjuC44qZIOqD+273egv0fWZW27YKhl9aGn6pRjw?=
 =?us-ascii?Q?NHo+mX3hcxJwYZMkc5mBEznvCILFviZYwxBFEyYSTV/vd7xR00Uv/U3SSsTO?=
 =?us-ascii?Q?8zbJLhQ3QOyKcrql5EB0ibmr0uCabQltRiLTV2JTJ3JiR+BYUAx3o/Vk0zuu?=
 =?us-ascii?Q?2TZyBr0SyH0X7ECLnufa1dd5Z0UFCYh6ocQWpXiXr4TVtdi4GNv5O0M4qTYG?=
 =?us-ascii?Q?e/nqw1mtp8I8/4xHTlPZ0EAK9V05N47NhfOyEKJWOgxTZE37eYiFYdrFWVDS?=
 =?us-ascii?Q?AGoQRwOMat+nv1uYb+b+2j9jcoNb74igttDE8PDvvjxxAGu4dxmoIMkNbLRD?=
 =?us-ascii?Q?jyPa9TV5Vv3en5HQzENsdHQFoMLWtM5A6t1ej5dXu+ofAK0E+20Fm0uEJaXy?=
 =?us-ascii?Q?RJfrnzetTomb5b3doLMnubaqMsOc4W7SJPJxAoIcwL9OE4ualqmRGofTpmC9?=
 =?us-ascii?Q?BF9ZX+iwJqtqlvnqTm8oRCI9MDXNxYUDboqlcWao5T1THGVRj+CLU26ea++f?=
 =?us-ascii?Q?VLpsRhrdfDMySqx05jXRgMSBLt69ZM5khfsxgWeW6BADwWjT23pcLeMYknHS?=
 =?us-ascii?Q?D2GDBfGe3MBWmCoW9gMWlgivT7p9ExjOLT6eD67TIsMaLIYVbZniVojahnrp?=
 =?us-ascii?Q?w+SbhfN8UgL3nxvKHYVENVVGwj9MM0jguqVPeuhuaWp3PQYGabo1r4ZaROYG?=
 =?us-ascii?Q?/NRwr40FEurfo8fK2rezlez88P9m3Hqcbrs2q10C/9HLyQdAWzuV9SurAdf8?=
 =?us-ascii?Q?O42z551IDfPJpRqAdk7MsTEObeu8IFFVmZ6l9LL+kdsWm79WDPedOs/bSzse?=
 =?us-ascii?Q?L344rCsO4IaWcOt+Kdu4jxsN9Wv43klRYm2rJE6+v6QsAPm0e+AN1P1+RgbC?=
 =?us-ascii?Q?xHy7c9b4k7AP6iSWZD2VKFfXf2dqYgj0XHV0o6CV/RmFRMOk/XQJVjwo6Nb6?=
 =?us-ascii?Q?Wq7NhE3RTDRFZ7UCxXdia5s0md8j2VKUbcdLV3GKoHX06t/v77eBPmm8rI5m?=
 =?us-ascii?Q?6DMvCUx6VXJ83VQ2X/POqYcpPo79UkRTbPdoQEx49oJtddHQZhwaJisj0ror?=
 =?us-ascii?Q?iTMZcwWRMcHyqFHA1w4e/NI0NitHOcOticPOofjlwATV0ODmIad98EnVtN9s?=
 =?us-ascii?Q?jhJ4kz1cf8w99uUX44FaEr9RcfnGmnZT4RtJJy856KXSAitRqq9VtFTh87kE?=
 =?us-ascii?Q?sMq+9hUmLz8CWmXxkD7ttRkCFbwVh2UXTqDYSLI/pS2MDFKmYGkmArFdWu3d?=
 =?us-ascii?Q?IbV1zzij+wdz4yIfAHsqtvpivPe0o7JFLWEJQ6sa4q/AOfWXt2tL0HII6H6J?=
 =?us-ascii?Q?ov5pZ/TBGlGkBUWaiF4HyDdOfK4Y9ne0pxDV5k0t3buF96JAHS2HE39Y3gqw?=
 =?us-ascii?Q?62AaGtCIvBicO70cs6IEwfFQ5ne9lk8qHfd1C8gsQQOJpS4Vjz+euBQ/KgXd?=
 =?us-ascii?Q?Oogm27yDFWPTrXNkfAlxezY=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 095430ba-e60b-455a-c6e2-08d9af6bea5b
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 17:00:27.9929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Imrj4717wDlcq36mTgUTiZGaNaScT6LUip0pVmBEfGxvVLGX0xoZlO17N+Y+5fW1HkQd96pZ7xUJqiOp3zvh5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3640
X-MDID: 1637773229-N-RTRAbdVd6O
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm sorry I don't understand. Please provide a clear use case.
> I've never heard of "factory default on a large server".

Our company is developing a core-router that is supposed to support thousands
of links, both physical and virtual. (e.g. loopbacks, tunnels, vrfs, etc)

At times we are required to configure massive amounts of interfaces at once,
such as when a factory reset is performed on the router (causing a deletion
of all links), a configuration is restored after an upgrade,
or really whenever the system reboots.

The significant detail in Lahav's benchmark is not "deleting 10K loopbacks",
it's "deleting 10K interfaces", which *is* a good representation of what we're
trying to do.

> <snipped> I've spent a month
> cleaning up after your colleague who decided to put netdev->dev_addr 
> on a tree, would be great to understand what your needs are before we
> commit more time.

I apologize for any time spent over this; this is absolutely not what I had in
mind or what I magined would happen.
It was not my intention to cause any grief.

The problematic patch (406f42fa0d3cbcea3766c3111d79ac5afe711c5b) I sent has 
another example of our use case.
The numbers used there, 1500 vlans, were not arbitrary chosen for the benchmark,
but are derived from actual workloads which we have encountered.

I apologize if these patches seemed disconnected from real world use.
