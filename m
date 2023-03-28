Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD66CB695
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 08:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjC1GKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 02:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1GKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 02:10:18 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4721995;
        Mon, 27 Mar 2023 23:10:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jl2ISrWKDe+/X2KxnFHml7pZM0kVBuTrxUhMSwGz3aVqH+orThV9ksmD+j0GJf4Svfqq+UJl+N6V4Gi9V8RN6xIfWFCZpwDgqwGOFfQPRRCLoIpGvmcTUsYnJxvcMSDzvg00xBdgFW0MO/Z6sxK/YgSqJ1PJN9Y8iOC52/O6xpxTNTG3y8IY2CW6xO4g1j7x538lXmD9L0QUkcdNcFC41/Vde0rUBT4CMKSQT0pNbnS5qzgk6krLKlAH7k72fSVqCe3pyzBxq/o8+Nk6Phc2PPWJaAnrVN6u3R+70g6iHbVY08j6K/aBvA3nIUCD5Sqcav2vNQ2hdEIz2KXNCNK1/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFaAJTc4KBz8p7rysd8hNMsfJYL6COW5LqrtJJ5ieI0=;
 b=d2J9TLjH9XHodosKcJRgesVEGPh7OBOp6qK1jLlmzaZNwbi2AxJczy89icGsZigoQUA2z9D/IeAUMAA3WtxhmoQif+JkCUHMrQyPhmNzmdPtf3jw9oEQ0Vj5wASySeqSXTFOdLY3r5sIlXzC1E5X+i5ILGYVsfeOBDWrD3oL7x2tCRF1KH/BquuTmqf8Ap3q7qf4pj9aMmMkDtJK+gODksTYifH93vowV/f/e9v33oI6sf+En/S5M5rDMz9fRUlUOWs3/LRuBk+8j44IPAITdihgmsaP6xZz3faIOqVAUZwS4gY5bLQF1ymQerTUjyy4Lrq3GukuRkAnxRqhDDaG8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFaAJTc4KBz8p7rysd8hNMsfJYL6COW5LqrtJJ5ieI0=;
 b=HK+gVV/IescuIQC8mLNf9qGj5NnU44L2d35e6aV3oSwBtxVRUZlBK1012ytO41KsWQfOvkB1PoJfN4EupNbHn9SkiVtuSuhg1R+LCNklmJimncvwbmBacBCGxN1C93ge1Pbc5KoxUUhIUBaLO97z/rxD/cYb67LF8Ru5e+uDAis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM9PR04MB8923.eurprd04.prod.outlook.com (2603:10a6:20b:40a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 06:10:13 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::778e:19d0:cba0:5cc0]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::778e:19d0:cba0:5cc0%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 06:10:13 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH] dt-bindings: net: fec: add power-domains property
Date:   Tue, 28 Mar 2023 14:15:18 +0800
Message-Id: <20230328061518.1985981-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::35)
 To DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|AM9PR04MB8923:EE_
X-MS-Office365-Filtering-Correlation-Id: ff260929-8530-4588-8035-08db2f5317f5
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7J0675Mqd5kQVu0APcybGr012wZIKuO2J6GiUhZMzzCs1zafC8rTttVPFHBYt0eD3tP25ohHpyS4EF8BQYc6gC2jfe2pACdcF3BYMFViNTQjIRZX2bqUe2VoZr7LtH5ZX4tmT2jde5AkyE05MIHrx0VQh1d9SenH8sTPunFLVzF8egg7RiM5w583y7Tq98+8DV9aIGKIlfuIbDiA9dPbzwOIcrVwUQ7FuHnD785CcLw+Ufj69sACylqWRfAuiLfuSbj4mUnP3op/CuPU9kYOON8kASmHC/Cs++VgbxiBJ1XPMS+q+d/vVsvoBZcb8ZxLdlYjL8hnUkdoYZL778up1/1M8Mab+KKG7Lf91x+3be8hCRdechKelXSZASml1Uj3sLCX+9vLU6WVlrdSIPUTCNEwE5I1K/9jy4p5nnAe0RQhxmQxbI2FsFP4JMtTNtoGxJ2x+XHEBSKhC+U+oRRyTaMS3m3QOqfQxkSw3JGHCrKx4YnjS5VCiQIezd9CKkjEHYFe3qj88vZ6pC99f9jGwT4D0SetgOQ2vuRTj62mRfx1S6YRopcU743wciuyc868ZJbk/pM3a+cF4AoAJSRgVn0OcS9siTekdDciqTVrcTc/SwyP97QvfFusW2bomW7NIJpaFRsrLjxBZLG7mZBAjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(5660300002)(921005)(8936002)(41300700001)(66946007)(66556008)(66476007)(8676002)(4326008)(2906002)(38100700002)(38350700002)(7416002)(4744005)(2616005)(6486002)(86362001)(52116002)(6506007)(6512007)(26005)(1076003)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m9jLKQ3BsxNgAzM2G7AWR1A82nmDGLJqphrQPn4AhHRWhT+9IYP7BZV0wsW4?=
 =?us-ascii?Q?Xzz14X/QeBd/59kh9wDJjURoyiLvvcRAmhhP25kqxgR/egkeo+KLD+CmA8Lk?=
 =?us-ascii?Q?+3GVQH/GOOi9PRMLd7aKDm9aLQ+p1WlV9BBJeihBhdLI1eUsuNBN0lFDJh5P?=
 =?us-ascii?Q?5rnq0+XV6IsUSbSDhpeRWEHQ781lmB+aweDc91uLhP6cNhGh16gBi+aFo7/B?=
 =?us-ascii?Q?JOqpxrQZ9vX5/RD6NKkUzE5vCLfTe/H/3A7dx4jHvq3aXmtXGkDWe2RHYIM6?=
 =?us-ascii?Q?3I+f+109H+0v2EIp6L7eyzW+niR/3ehLop8zL5yu4XcbLb1m9FUu5lyoXGJv?=
 =?us-ascii?Q?omRhkoDmQNPyKGYxVRNrO55B33nJtyDAYcMrJbnJE0enX2nqE+OcEDml5Lux?=
 =?us-ascii?Q?Rq5sNO9Lux+qUNHb9Ku9BJA3TlA4qK792ov6FyOzkYWI/hIxjZmCN4IhzLg+?=
 =?us-ascii?Q?3UULV4wjCgttPfWY3BshqWdtVEpPoOv1Mrk4hXAUkyg8Qdn7ZP2YHuzdOfwD?=
 =?us-ascii?Q?9BSrlgPijEyCXBkNgN2K91oo6MY9S7JIVndebjpAT5xDHTNJdmQuXKvCfr1C?=
 =?us-ascii?Q?OxJg17TpcXQn9oH7SDoYTzhoFEDWDuZLeZ40bZO2PqTFafq8qQegGucxEbC5?=
 =?us-ascii?Q?cizTumJpRKFcupf5pwXbACLMkRZutIS+g2iynYWRADQM6QJAszeR/U35jNf+?=
 =?us-ascii?Q?LeAP7R4xkv9yfW6BOHUl27MSJz6Xl35IdPhZK5Hc/BM3XD/NSuqk1SzuQIfd?=
 =?us-ascii?Q?hrIz2VF1kcxkyMM8Jg8Zt2mAmB9PtYHHEDh/Xyb4IIgIyVq++oo2xhU/pHmK?=
 =?us-ascii?Q?ZbUwpTFcXenb2iMv2agaaOi2CpOHi8H3LYxB9Zy9Jse/wAzz0pUcHQoho87G?=
 =?us-ascii?Q?i0ErJ0DbFcX7tzFSoMb0DstoQfbW09Y6vxPH8xvh3l4yp4DgDqaUGMD/LLBz?=
 =?us-ascii?Q?Bb4feovCJPp6EaxjD1cHaQVyfZbELHZ/N3nYacTBEIcIxsN2YlfRvA198wzf?=
 =?us-ascii?Q?tnTDN5wDAg0ZTAm+hAJ7bsD64ofovsbVz4YMZY91L9d9jgSeZhrh5tRsvlR8?=
 =?us-ascii?Q?9ZvNyP6grqqmis09eim9EUi4/bC7qCrXH55DYtxT2AKQwEkNcO5B5zAprtHG?=
 =?us-ascii?Q?+zQ8MjDHXEN9axaqbDFxB+2MdjLylhS1hhM89M1HPDa+xzd6aTVlcShBh9y4?=
 =?us-ascii?Q?oQs4j+IC9EuuhNFOtTR7jgObREkhkhaAUK3Ld5DoAE0KJvYInP7bfRxOCakD?=
 =?us-ascii?Q?L4GSvsNr7NukE5wx05PHUXCd2JW/4N/Gdw7QVGv8M+dMb0eB9ilSb74tyYwE?=
 =?us-ascii?Q?Ysu7B9ChlURErHIjCeJ+PzaaNwTzwHfY025redgaQnI4K+l+EzaZgX95tsva?=
 =?us-ascii?Q?IUt0tdeNSw/SRinbvBtdnh8Lp1W4nJNtXVUEFisXUTJ1TZqnVUe6TkLllTOY?=
 =?us-ascii?Q?8cvJbeHyPmoEjOhdIg8O/edf1tVSyT5BDnqoQbb444TSX37NjZXIlMrTTU+y?=
 =?us-ascii?Q?RDfcb1fGWN6a5Xz4WJcMhkeAWkVM9BgDCtYOsgVkCgamm5s4iSUZv5+szPL6?=
 =?us-ascii?Q?wILlumOzNaz0Ryz7zBE/RhHgAnH42U7CmXomvVgW?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff260929-8530-4588-8035-08db2f5317f5
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 06:10:13.7416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p66fAQ+jpkGvxdeYDYBnoboGsZ/P3Igazx+aJ8UweRZEF1rZbHobJnPzOfgciK+OARJPMtB6P9xyXbFqiwo6KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8923
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

Add optional power domains property

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index e6f2045f05de..b494e009326e 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -144,6 +144,9 @@ properties:
     description:
       Regulator that powers the Ethernet PHY.
 
+  power-domains:
+    maxItems: 1
+
   fsl,num-tx-queues:
     $ref: /schemas/types.yaml#/definitions/uint32
     description:
-- 
2.37.1

