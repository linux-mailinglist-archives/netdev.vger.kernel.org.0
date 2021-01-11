Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986162F0DB3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbhAKIPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:15:42 -0500
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:24462
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726611AbhAKIPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 03:15:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IL2TmBMNmG65ZzChMD4SOqPwzp2epyaPLsEwM2bw4LQd0XlXQHigcYhiLrOHWDCMknA85OYhLk54T5T0U/jEK5ZqzhxcwTy+YW9+Gjp1cfXAoVFcAinaVeusb7su//4aYv6aatQPJQouOI9+WqCkNnQf6cLLJyp5rJUWeRYebTQQtmiIooBW4pTva2Cd1rqwMdPd9PpvQZwxzR3VggCUjQ9YNx3GJ3PWdSzq0TaBhCD5HQS6wf3l9WUF8j0Jz8ZA01w0oFf0X1YehD3YxQYM7UqacF7UW8wVe1Ofi1xOwFqb4dvpU3nALhBwpV2L9UYOHOglXfFc3Y0MdHkOewwheQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZULmzNPShkceCJZHZ7Cjgwg+Ai+Jax6gwfql4RWIBFM=;
 b=SUc7fITqd/6LhQMgi9a2kbnOob77n7bF1RED/oGfNNgXkc2YTJKuZuBzWOSzjbbLpXgwtaJgboYP5mxodzSG0AGaxnotCNI1/BgWgrSbG3sBJeDs+57xwAIRjdxfKJQTMhP/aZfiohuN5uwuqqX+m1k54UWhhLPjinT9RhXHXl7fqfjohohbVHNxhN7B6LvYOYFXDCDsNChiTqYDKjTDFlrbp3YUHLXvqV9hvHu6CYb50Ek1VjHT4fg6VyE8rtpHZbtTA3FK2qyrDsEvWmJtZFcKfvdS2j6vKLYQ7PsWxnxZgE1OW/xLeLhWBhNr+LslU6Mg3F19RGvm2TBJmoU3wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZULmzNPShkceCJZHZ7Cjgwg+Ai+Jax6gwfql4RWIBFM=;
 b=i3s7/o4GIOH5YVw+1Zsnk3pZKZFvQzjM2OHumY3FlMjMWH6bQHrRf2QIvxgmQ1hITFP2yWYwXw+1EPkK8XNYzkvgeyYeR1F5nCRa3jb/oKUJHG5y4dPmgSm0MfkQHQDIUV7IPRrBq5FGB1eUTlu4eFIsUjRkDLsqZOgHQ1BeENA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VE1PR04MB7405.eurprd04.prod.outlook.com
 (2603:10a6:800:1a4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 08:14:52 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::dd31:2096:170b:c947]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::dd31:2096:170b:c947%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 08:14:52 +0000
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v1 net] dt-bindings: net: dwmac: fix queue priority documentation
Date:   Mon, 11 Jan 2021 09:14:07 +0100
Message-Id: <20210111081406.1348622-1-sebastien.laveze@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [84.102.252.120]
X-ClientProxiedBy: AM4PR0101CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::21) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (84.102.252.120) by AM4PR0101CA0053.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 08:14:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6127dd4-4e46-4e38-7be3-08d8b608f91b
X-MS-TrafficTypeDiagnostic: VE1PR04MB7405:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74053819583ABEAD9FD58F1ACDAB0@VE1PR04MB7405.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUlXojqUxOjz71vhMLY00vzZALocA2w4sS91N0ykThvmeqm6uvL40KLAIJk2INWvvnKJjiOAbqjClOQJHXwlcGPa3vyhRlUdEEd/GtReZUOL+fXcngPiQ/vxU+5L1ptiOwcZYh86wJSgugABw4KaUns8A64eBYz8RX6by+fB1+ysTaV5Bu66aHtawAsSHKDigI+PjfW4oaByZBupQMWqHUfshZntSsCkMCxXzMN8ZQ8Fpo9oYOh+0I5Swk65eOUnQgjhlj4mLN2zC254VE1lWBRNIZ8CsTc7xHcnh3EIWHjk00Tb3/Z533gc0NMdLcRBj4iUvf75xBA0xgOgv2a6bPKHjIxGclnKOrtDfmsz0bsbCIi1PNrM+g8sBwx82oYWtnBYxFDIPWCbL6DYicGwKey+8a/zGA+Sp7nGRNaFmkqGy5nY1o8ZXSoTMmbkb75Zy4avVPzeNip3MEOC5wB2qQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(1076003)(2906002)(83380400001)(186003)(8676002)(6486002)(956004)(110136005)(316002)(6512007)(478600001)(52116002)(8936002)(2616005)(5660300002)(6666004)(69590400011)(86362001)(16526019)(44832011)(66946007)(26005)(66476007)(6506007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q4aAvWajn1Y4I8nY3tOICk3WNdbkLQT9w8zuOilk2RA5ogPhU/on6mUFwKKr?=
 =?us-ascii?Q?pLjYcjSt7w4EVfAy4SKIcHaeu6Th7BFFLguTlpY96ZQ89WqyZO7wQWz8wWhe?=
 =?us-ascii?Q?OIfcgm03VVv3bkQghY6Se+1iUatmaWkXNSGAR7/4fFh6Ghs5iowqD+JzXgnW?=
 =?us-ascii?Q?64LgV+uoHaZs6lPZnDspCe/f3eOeCRm1e4DhKWXo3GNZZaCZRama5egZwTdA?=
 =?us-ascii?Q?94m57kJHvnrQcYP4Qn9/l48VxpshJyt57cocN09jjHweXNR2pLBj9o9d5906?=
 =?us-ascii?Q?RM0lBVpjXJnZVjLBsWrS7+aWFeJ3d9Mc+i14pnKvD9THHaF2e8w2KC1RZGs6?=
 =?us-ascii?Q?e4Xf9PStaK6WMxTyxhyXDEBX0kUWubSvd/4uqNdK+EBT3Wf3oaEVJy4fp9bP?=
 =?us-ascii?Q?M4nKwo3WgAgBNCT2u6dHtw8n3SneDg1H3WCdpfn7i43QW419gzwZml2HmIUO?=
 =?us-ascii?Q?Y+Corz3YfjjBzIMDSqnUP+VjV8k+Sb4OZzygbeB3sWg2I7CcwM+/Wshe/+r1?=
 =?us-ascii?Q?9wSssmPXgxm9a1DbvnDay2F8z4gEbbxnAfIqewEO1jJLarTVKzXuPoHcAOjl?=
 =?us-ascii?Q?XW+nzvlmDJVo2Mt/eNsb9xEyfzIl7PEf5aPqmZ8cA41DGAq8yhPbZBx5zT5X?=
 =?us-ascii?Q?U+BfwZa+0guuF/olZrh2ClZT5Imdw4VA3+QnbWKtpwtmbT+FapsIQOHNJG9c?=
 =?us-ascii?Q?1JGDD6SX4ufZgT2l8wgastTk1eslvDvCX1u1hzxFMYeuePFge8DI4n9Qzg2T?=
 =?us-ascii?Q?INZBFJwM/LGdNFlZQ24yc50WKxnck8SA1eqdoB5BVFL4Yj3koyx4DFdjLBTH?=
 =?us-ascii?Q?iiD2XCy8yZixfayKMk40cyT7NBW7QCHS3A0m/9ya7m40t8lnmokrQ6i9I1NB?=
 =?us-ascii?Q?nV9rweP11kLvRw7Ny1AA4Nsie/e4pgK7USU1pMdtiXWQBIxewnmgYW3Nuhya?=
 =?us-ascii?Q?lCHKWVB2SgyG1vpoxc67hXjijsD0tudw5zoljWS1dIYFeRMnGfvuhb7sFy97?=
 =?us-ascii?Q?8bPa?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 08:14:52.7287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: c6127dd4-4e46-4e38-7be3-08d8b608f91b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZHj9DB/ewBSQR3Nfe2dBMF61WnPir3DKDjE+iTVuYmlhn7/aPvSRm7dRK+JslOBdmgBrsjzZ1boyd/P8fOubtV2Dri5GFce2Zsh4zGMmwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7405
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Seb Laveze <sebastien.laveze@nxp.com>

The priority field is not the queue priority (queue priority is fixed)
but a bitmask of priorities assigned to this queue.

In receive, priorities relate to tagged frames priorities.

In transmit, priorities relate to PFC frames.

Signed-off-by: Seb Laveze <sebastien.laveze@nxp.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index b2f6083f556a..dfbf5fe4547a 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -161,7 +161,8 @@ properties:
             * snps,route-dcbcp, DCB Control Packets
             * snps,route-up, Untagged Packets
             * snps,route-multi-broad, Multicast & Broadcast Packets
-          * snps,priority, RX queue priority (Range 0x0 to 0xF)
+          * snps,priority, bitmask of the tagged frames priorities assigned to
+            the queue
 
   snps,mtl-tx-config:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -188,7 +189,10 @@ properties:
             * snps,idle_slope, unlock on WoL
             * snps,high_credit, max write outstanding req. limit
             * snps,low_credit, max read outstanding req. limit
-          * snps,priority, TX queue priority (Range 0x0 to 0xF)
+          * snps,priority, bitmask of the priorities assigned to the queue.
+            When a PFC frame is received with priorities matching the bitmask,
+            the queue is blocked from transmitting for the pause time specified
+            in the PFC frame.
 
   snps,reset-gpio:
     deprecated: true
-- 
2.25.1

