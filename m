Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9486D427A1E
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbhJIM34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:29:56 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:6886
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232926AbhJIM3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 08:29:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JL5mJB/lAaEzmExJqjNFuxuzfOG3Jj9QHckUmojUcCXAwcBvei1F0Db+CnmnOsdc25fLRJn0Y8VKMkVQGr9WrT+hBX3YY4UynjxJpLxIg7lFLtEokFS3gzvuuL43g4VeQwAZkw3rNze5STJfoOmQ3AZ8eu5pEpIWgFi+LW/+DnPd7++HOQL4y1wMP42Wu8Bdd6/VRkSqnmDg702yHAIx7MR+32FubGp60gXRmynpRNI3kToJT01gU6g6EvYzkipVg8VE/OZTVJz++NI/5los/GyKdEmy1lI/069wh5OESEjhvpB2tPy2pezGryRUPzA34LqCLFfAhgMwP/w+jGCkIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLUgXeL7UMS8uK5Nin68gq/Wi845WFPNNoCmVejpgCI=;
 b=PJQMFcyz/071S8CLfcJc68wUGWq0W4WKThUinXcbmThRlDrfYi43Fm6pZgoGV1L+NgMOL59rMf/2uDWLC3OSOAt5ZT5Iqwo0bTLdW2tRriRu2SCeP2k6FXyxMn54K8eEF/UUFwv9Ivmuwkg29P31HLRZh+DDUZoM2YSaC2n2DEZWCMg5EKu2QzKcWTGCfYkivzX7S4rCf7AIeJiBoibigR2f1EJ0ZF7/zDWHJNh6bi96Jaq67NdKdtPUL8th+fxWN6iGeTNASkGypvMkUrQH7miXgXegcXwwS57kR5wuRJ4BY3rpbRrXUevYWWf/xenDvckk50tdA17hCvu7rWI81A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLUgXeL7UMS8uK5Nin68gq/Wi845WFPNNoCmVejpgCI=;
 b=HojB7/aKwIX1ey44e9zdHdUu4ume7hB+8tJPbMDVfAselVO6JN9HnXc/vux0kLClRtoW/7/Lk1GHTJmtnk6E2J+K8iDfsMgb5+nnrep0XT1jXBW3ccbOvwrgjlU42BFl4bI84m6WQdX8mGawEPGOCRtQVanB9YlFcagi+6+qrTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Sat, 9 Oct
 2021 12:27:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.026; Sat, 9 Oct 2021
 12:27:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/2] dt-bindings: net: dsa: fix typo in dsa-tag-protocol description
Date:   Sat,  9 Oct 2021 15:27:35 +0300
Message-Id: <20211009122736.173838-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5P194CA0004.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM5P194CA0004.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.21 via Frontend Transport; Sat, 9 Oct 2021 12:27:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 251b7183-c6ca-4e40-1638-08d98b203644
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3616:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3616B8C55418B45C84804B01E0B39@VI1PR0402MB3616.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: POcM+mQ3nDFpb6gPr4IQ/tTKq3mBRE868JEftcFdgpvJpu0OkFdwqbQqWeXChUS+suasM4Ev5gAiURXUqRK6islE6w/RfUh6CKjbiOX/ZxV/f2MV9ZFVaeYLh6btp+u0Z5MA41PA6mpAvDnTZhZLhlelu6ujHkWFYYQN79Ek9X3vnEKVk2wTW67yiwuNaN4ujXM20S622WlpXvFgXtjXqzw9VGk7AuGN2QpSaDWrsK84ZH7NMmaxglrf0jh089H0Ca50U7HRjKRIBZ//i+oOVpHks7w7ttCQ9q/FfVjHRmDT3HJ3VvvWJigbJsrUpjqApwLy/PQu4TJdlC1LW3YS1+l8PmTysVbdCk9W2oerOVswxgKvY6+fVkL0xs3OSz0xMRlykzDZdRG0NqJGYBT5DBcx9QOA0/yidTLPVbcU3UP7KvuwqeEhPF3AOX5/nQkh4CxmEmmZ0XUneIwFnHZuyDPsf+PJMbD6OmjgEuQw1soNhjU3y4P2A9ff4+UYUvlnMu1QM2R+iSM18CKlz+sYnZwKgW0ieIeAbCVy8w/vKnIC+PhDGo8GYHT1Ge2MgHBUhe5mp0mL/acOepBeTaR6gp7C7qgnI0m/zsF3ueE4rrvTAMGIQ7BIikmb8XbCDJk8bjOt9oRHpXy9lcw0fcroYuDtezVWzomJzhTkydgEqXfZ6c88x760+aPA6x5iv+pEcFNT47MxDXp0zLC71bFXtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(508600001)(38350700002)(6666004)(44832011)(38100700002)(26005)(52116002)(5660300002)(6512007)(6506007)(7416002)(86362001)(6486002)(54906003)(4744005)(4326008)(2906002)(8676002)(83380400001)(8936002)(36756003)(2616005)(956004)(316002)(66476007)(66556008)(66946007)(1076003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JnzF5kL+ol79TsSj4DJi/VCLYrPCSLX65X365NyTaV2VyiOc/QYAcizdL+ZF?=
 =?us-ascii?Q?ei0trzfe2dJg1QNzIqKzg1UrzCuHgtIUpdN0ah0XaBXlNh3JkIG2KqqQRS4G?=
 =?us-ascii?Q?QuoVQYxKPfEixtlpztjzQDkNWtwXFAJkbjnj4GQkUvJITgymkT4mJebFGbpF?=
 =?us-ascii?Q?8HGF5TRtBzn4pAgS2VyfNXuwb48jmyu1v0xDR1FRnEztmGPRlslDF2LTAu8A?=
 =?us-ascii?Q?DPv1n2Ar3IY08L7K8yz3M8wpWfpze0qgfo+kZMw0DNbnH3EutAyldDfQIdGY?=
 =?us-ascii?Q?v1M4VqM7XFeV5yyCANX6xA8sGM/usL4PEtZ/t8MCrEhJ25nRjKieESzA5K19?=
 =?us-ascii?Q?LX7kVHCZhos1t07bUMqyY6ktuBAex99k8/bRgtr9m9ltXSW1u5cdQph14yCS?=
 =?us-ascii?Q?mw2Mc9H4+CxVO0Ss/zB3dgwzDdLjyoGnKPpn2u2/msQBn+7qzsi38yWh5aHq?=
 =?us-ascii?Q?N6oanoiRnmCCVO6qRiGJwfoo1h508rY7bbC/quryFjzFznwNkUl6yTxvNlZj?=
 =?us-ascii?Q?QyKeLAtut+LL+oqtbuXoF67POy6asA5mMl1kMi/JXwdwJIoeyttULshnybXr?=
 =?us-ascii?Q?760txX0RsfcDpb2qEvIZHvxBgpN5cK6VGraLZ+N6EGCajUqrf57Dj6Wr5Kiz?=
 =?us-ascii?Q?tZsLdrBYZz3CsGgg+M30+inglJUvLLbQJM4iphuMT3/ncKyFrSRIsSYeITK5?=
 =?us-ascii?Q?Uss4Huq5hPRi/ZHX5WTGKiT9Cc+C7c+iITfHt+sHGmYHawktXWgnrEGLjIT3?=
 =?us-ascii?Q?rhpiUpbUwYtQ4vT+0OPoD+XXfJrPZ6xjX7ssjHV79luDdSS2RiNEX4t1mKUD?=
 =?us-ascii?Q?Mh/kwxn7AYb7kE3t5HJaHwdIoxh1SPHO3gHOUONoShPynxU1AR2LZnOvgBZL?=
 =?us-ascii?Q?os9UUru0Rid/ZZVKQHPSiOjOPXx8QnLAMgjVUFI+qPxXIPL09jSOEnmb2KlC?=
 =?us-ascii?Q?RxUE5hwu+/xuRR9MrLg7VKyvyh4R/tTGqy79+Kkl3vDoOZGhoHPh7FQNTawv?=
 =?us-ascii?Q?nuqMfAN6sImT782/zbb/GSNUO29ObQOcu1g3kB8W7wOCKj3FJUGJ4pdyPs3y?=
 =?us-ascii?Q?UZQ0zTS3Bhv8QjYva008RtnG1Qj5xlp4RVo7X9rr1/EHMiwOKTzeHqYsqtPc?=
 =?us-ascii?Q?B+/Y9oijxWlbLiBYv0I9BBjdawRwy2YUaC0bPqCzb9xziDYt6CnWSxVgq+Y/?=
 =?us-ascii?Q?S12Q0BdcIkM7QKzl0PJQWqGYmNcUBOu7sVvfjzO7cFhCNOE5OP8LuyTQDM+0?=
 =?us-ascii?Q?prldPlZg5mEoth9URwT2k6z0dN/iPL4xNZZrE96b1kH7f5o//3wdrfOsVBLt?=
 =?us-ascii?Q?ZBLwpOdDtX+YF1JFLPiqz3Q7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 251b7183-c6ca-4e40-1638-08d98b203644
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2021 12:27:51.7610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rED72wkAcLH/0dVY+Dzo6tAiumPeBiPyV+vjpGtkmu+osWuFhEhlxY74zwMRXNc3gWD/uT38w8gvq4y48HZhVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a trivial typo when spelling "protocol", fix it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 16aa192c118e..51f243244f7b 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -73,7 +73,7 @@ patternProperties:
           dsa-tag-protocol:
             description:
               Instead of the default, the switch will use this tag protocol if
-              possible. Useful when a device supports multiple protcols and
+              possible. Useful when a device supports multiple protocols and
               the default is incompatible with the Ethernet device.
             enum:
               - dsa
-- 
2.25.1

