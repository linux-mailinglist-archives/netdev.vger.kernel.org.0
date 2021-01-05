Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9A62EAF64
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 16:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbhAEPts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 10:49:48 -0500
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:6652
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728837AbhAEPts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 10:49:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdviJFE2uvV/AqQFt5lU61MvC+Wf5Q9Fhl5enkCGZXXuzmEQgsrqQ66VOOFxEASNDaxJbIRk3DABoeIBuURdmoNpIRx7I//YQU/pWSXU96e+/3J90ZSQgJevnsVAqVah1OJudt1sSjJF/9AjEouGNTc6aj94E8+JUVv+NOR/6cp3sd/L4lKE17Io+wd1zJKBc+QbB9O8LQn5n/6IFvt0P1airmtd8cYImVjP7W2vdZqByTG0zzmVS/ET/E3hSpBRvPNjAxBuR6tU8e4TgraBNRFLt1Zn17K9QsF+3yqkotOXddv6btip1gNQDSpn58uf7x5iaLV463ZdhaHP0SphHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AZ/FVDFTOxGA2bgze1NWR6KTx8I4I/hLtR15VH8O64=;
 b=a6GHEKJTC+Cp0f64O2E5nhb/2P8IEQLgx7x0B/bsukpUkXNQJWyvS2/3kBZ6ne7f00g5XyKcUDr/l1XdbwtW0Jol7T/zz14STxj+gZFNhNfXLYhPqEZ3m5BvUjGWynxaEO99/mFLPzRhDkq3FcihHjSsLk2KbwqHqOK+84C1REvpNg+I5re1dTXaFwOSsBd3MsCgzSWd0l0Ek1IIIXY54NNeYlRFa3hngmmgddlQRxwk8wbwnZhp23zoVf4Pion7B0qxWdo9Ha0me/o5jS3p1pv/PD9neoCKLIb+qIsi9Gu1K8hsumFrozdDo/ZuCr1x1ZnOcBBJzzDClXkTFgz+Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AZ/FVDFTOxGA2bgze1NWR6KTx8I4I/hLtR15VH8O64=;
 b=dolJsI3YWGyyFLCVacnhY7b2aOrSjNQ9cHSxSRGEIZy3cCyTfdJD4DU4h3G6KUdyHRYYGCZ0SKG7c+NVpuuQ9WjZ0BJ8Aq1vDcSyoL+surGFASdUzOYoGz2QuuoXy98vWCfLTpeaypnZs0Xj1/cI8tDk082Qu2mbWtxHV+EmW5c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VE1PR04MB7454.eurprd04.prod.outlook.com
 (2603:10a6:800:1a8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Tue, 5 Jan
 2021 15:48:57 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::dd31:2096:170b:c947]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::dd31:2096:170b:c947%5]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 15:48:57 +0000
From:   "Sebastien Laveze (OSS)" <sebastien.laveze@oss.nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net] dt-bindings: net: dwmac: fix queue priority documentation
Date:   Tue,  5 Jan 2021 16:47:48 +0100
Message-Id: <20210105154747.1158827-1-sebastien.laveze@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [84.102.252.120]
X-ClientProxiedBy: PR0P264CA0183.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::27) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (84.102.252.120) by PR0P264CA0183.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23 via Frontend Transport; Tue, 5 Jan 2021 15:48:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 656f38ce-2adf-4d8c-d2e2-08d8b19169c9
X-MS-TrafficTypeDiagnostic: VE1PR04MB7454:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7454AA8AFC38818043E60102CDD10@VE1PR04MB7454.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v23Iam/2orbFm0n62y9JJ3F3aMuAtWf5SJ37sA6x5r0QKePd1TeoP0mghaP/sKdMamPow5k+C0TNrBZTrRzYkhBV1Nf9kDSzGevlsAwqVsjJg1puIMxr+0Cubbr9M8qGxA8YO0J2Llp+Rt0CRUagCY3rGsUMLAbmWdN1u+iX9BocfpVni7JcvgLD12KBkKNfM0KBHjO57YH7WmnRmGpiL37FFEfrOscV4m1px/dBFkyiuJ+2xcvXd2KW7B7OL1rP9pjvdDBhypUpXKfkJQY2Fvj+mrZAXhPkAo3blOQGMkPJCfa3U7I95rPnEEtqZYMHOvMv/1QL//iMwYyzOtaBFsC5XFLYIgOw0rK+Lvh8X4cWUlC8B3DsbjuYsE9m/esoN5BzDNh6MOG5WfF6z90GBEUir4QSg7bDupMkmdugN6YvApZKlOZKfjtnEjUAZK6hZjMqNwY28ggHeLu+XmmnWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(6512007)(86362001)(1076003)(2616005)(956004)(69590400011)(110136005)(478600001)(66476007)(26005)(66556008)(6486002)(83380400001)(52116002)(6506007)(8676002)(5660300002)(8936002)(2906002)(6666004)(66946007)(316002)(186003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RPuDOiLGNeIXjl04bleBadu2fbaQwbVMtajcoSwqBgdoIW/oByzAOx5aqz0q?=
 =?us-ascii?Q?+iiHLugXgD0L7y0jMBMfFgjxizzIL9xyHTAgTb4kZ8/6owQ0j0hHMycV3Rb6?=
 =?us-ascii?Q?Tl851zo92jhH7Sck59/N0wq4fbEOiFyjpyGPSlwM3FAdjnpDge0qbjz0VjD+?=
 =?us-ascii?Q?eQK8jIHeF8mo+dYbOs9Xs/54MRK3lJAXD8GRbiNXE2O6Dom4Vq7P3fDMXA1X?=
 =?us-ascii?Q?PkQ0egpwJApPfi41bAAhW1G8UaNGT25aQE+EZDmxvlOmMpiOU6jdS4dE2FTm?=
 =?us-ascii?Q?6edMaMc1q9WzjmLZEgmpqmQhtfHzjsNAmqqBF818Jj9KeS4SkTmFPw1FZejG?=
 =?us-ascii?Q?ihrsARKREQesF4eKQh9utjmV9kKazGyGKfJPLoBfj3QnM+b9xO6Im//o+IRU?=
 =?us-ascii?Q?MT5eWjzu06u3B0oiT5W2Tj1SiaZ8BpiA6kKcT36VhSr7DLb2cWCqiy6GOuk6?=
 =?us-ascii?Q?NfqQPnsWy0uOZJfmRsKyPfkdz7BmlG1WImN3fajrRKUMJuJCUxwyzsB6xDd4?=
 =?us-ascii?Q?H48Woqwxqkj1S8gd4DcTAoPZbkyqChzj76sTwodh58m/8TVe9u9/r3XNpEGf?=
 =?us-ascii?Q?Tor9ENOZnwJmfRDrGa6WXX1NhJjLu4T38gtYHQq4tvBeLSwq3eb/52vlXNKs?=
 =?us-ascii?Q?LsJO9YN2lQqi92nVHzwATNZyAegqtuDlf11sSlam4DqPFZiDwSqeZOHLOYVR?=
 =?us-ascii?Q?gPy4lUKgB5Xo3llrIAmKq/n8Zv9Neh1PmZoSZEtMJJvade+nnxvdkIoeTx6u?=
 =?us-ascii?Q?1zofLFBI0rzbc7gsB2JELZTE5JjpQecxpPZD3KSsI/mP5TjuNoORqRPGGFVn?=
 =?us-ascii?Q?O4DvdEp/jLEIBIJ+cCIUaVpSysjPHNAeBVerPGKAaEISDGTwL1wii4vkSark?=
 =?us-ascii?Q?O2n133Zvx8AJrcvgBYUsSuxjqCgopud+NxnFKIKyvaFQzHXtclZKAk/R8CSP?=
 =?us-ascii?Q?n629+Dz3AUdYwmb1qClAv9yk/hJ0ED9i3tTMOd+DuBalkzx5glYXKPdmEvcp?=
 =?us-ascii?Q?5K2R?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 15:48:57.5294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 656f38ce-2adf-4d8c-d2e2-08d8b19169c9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPC1bUXBVDZFuqHmkD58H22znud1uhzTkFcdpAhD7sMYSddXrVmpJnKXPqygZnDc0REzwlHgAHhhJZnnsEm+quABwvkaald8X5JpkrFwRvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7454
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
index 11a6fdb657c9..9f6ba47513a7 100644
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
     $ref: /schemas/types.yaml#definitions/phandle
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

