Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B327E60C2FB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 07:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJYFEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 01:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiJYFEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 01:04:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344C4BECE4;
        Mon, 24 Oct 2022 22:04:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/xoMMwJiZE5NLp8Xu00kAvBV6brZY9rSLQAoPzU+HK3V9hLgTdenmUooovGy4wG7A1FiSthulpojjGQEN+BFEpwhZN5xCzTF7TITzrICEBiVC1KArNBKe2/AtTEZ5UCmwVknu0/GGMU9QfUf/zj6lmw4O3rd192HPImYOmzjnW/lGcytUVDi7BxwF4RYFxAz7jAnzMTV1lTXe2pWS8dEYBG8Co/0lG0eidgDdk531/yrguMxqq3bZkb2W6UrBL7lMI/rnyLtbOppLcfXWdr7d4suAuh6e0AcXICPQFDII/I+WWYyRSHbSDG0w7dyZ9XbTiMghJ9el9bWPP2/Yi2CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=201egdP56/L9olqTXpdoJUXA45E/g3ZpaPtzI5fTHAA=;
 b=N8CrbmuCtq05n4xv5waN/VqxYK+QqwA3RQLK4CS5fB3xqqvkkOH45GjzrrUQqRyqEjoqaiRQCdh0ZLugeb0gRziu9JqJ/AJEaG/aJ65tZlbvvk8Csndd03n7bUi3WF0M0i5D1sdr9qUQ0e5WiWBHvL+YN53H1MBlhCwX3OfS5xc5oNsclOUICi+pi2yVFJoEZ0jvVFO2DEk+u9VRGfj/+G/Xy9En6acfBjVfZavkMcgxmgZFPze3kRIFhQiZJELWgTUY0fbNKzIEE9Uqe6Ai81Rhzy535V5wBjY4X0/MMVLN4tdvXXQVKRp/TJP6at2K9fAQ97nTjWl25cNUMuMj2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=201egdP56/L9olqTXpdoJUXA45E/g3ZpaPtzI5fTHAA=;
 b=Z1BgVFv74bm1QLsZmCM4fgbCPoUvw1HUzlRdca2PcnqQQetoXw3bsAoeo+iBuAvgf3EPglwxNlnY0N6JEPSyWL1QKHWV9+ILEllHs0knitHC5vgGmZn9SlExupOjT8PEyxsmJtzbx00YLKrOrfomRmBqFt7UXPTOjx9R0C+LnB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4989.namprd10.prod.outlook.com
 (2603:10b6:5:3a9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 05:04:09 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 05:04:09 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v1 net-next 1/7] dt-bindings: mfd: ocelot: remove spi-max-frequency from required properties
Date:   Mon, 24 Oct 2022 22:03:49 -0700
Message-Id: <20221025050355.3979380-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025050355.3979380-1-colin.foster@in-advantage.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: 592e5b3b-e448-47e4-b9b0-08dab6465989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMZar3S3XnvssXzspj08x1zt/hWllsWpzf/BLIzeW5IgDD7XMyjRQcJSGQRP1lIjQLuAf7Ctn/JSEdqxw/TNGwQzzEK0e9a2pT0xTrTZ5B35c+orXgJxzed7mYMmF3hW65O8+BvT1HgVWZTkMFjaRgzhSdgxjBVBXfQn2pFV6NEUb3T97momYxfZxEHiyO0/VU7NwpTYrXe7b3n+cbZ+H2W+ISgDElkTSnPDdETd+Jpc4MCLyUvGk5BIwjLd6zEClG87koyGZsqjc5HCxHLzS3ey/vEtflho8Dzl8AVPe9ItfIih/FRoVKT6z9IphZof04mNBxwNEmWVylOw3abUekfImDPI41cRVyHNGKnLNhpf1h3ggxi8TgZvNdhTuam4VfLu6duf4OA/TC2uTgbm/nsUUhjWCZuv+gqj2KfiZjIeTQYQdXoACgaI0n307wX45A+oFreOmfqDI7WagY9u3fiAqtdWTs97SuPD60Ba4verCfpAeCAWPExGuikxg+U+kOGBzizEA/0kXchi8mTbL4H/IyE55tkx46PwV9GccqmhWaI4NVqOG8rCur0A12NLdNW+kJ/kv5OJFvLSWxbVqp/1idmlPB5gwR7a4UzlQDz+Lhe2LA62YAaSNYlM3zGk9UYbN6AkXNLRJE7Fij75DTXQZne/UbKTqA9jmwrmVRzLMnsDd1GEgGYC9wDDW6gIvkyL2/i1VujvzcsoQB4iJV50KWFUr0pdns0ttGjMxblFj6BeGQRjmKDyLO4XHtqVL8tA9/Fz/NjStXMaK0fzlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199015)(316002)(52116002)(66476007)(6512007)(26005)(54906003)(44832011)(36756003)(4744005)(7416002)(66556008)(4326008)(41300700001)(8676002)(66946007)(86362001)(8936002)(5660300002)(2906002)(6666004)(478600001)(6486002)(83380400001)(6506007)(1076003)(38100700002)(186003)(38350700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FOGho1Vf2UKTdHWt16nXqX9+2Ig+IACy6u5bVBd0L6ABNCSjBhrNrWNHCthf?=
 =?us-ascii?Q?3cYGZNUGj9Df9HaLAg5miZSwtePtljfsfBUEsHrO3Qg+ikNxXCVMIMYyNqJ9?=
 =?us-ascii?Q?v8wXUJZx42+997huHlWK8G6EerKyph+NWZryY6nme7GPpm+J5Oxk17mEQUtt?=
 =?us-ascii?Q?TjpcBNbL7iKe5H7L2sFShzVhOoIMCpCr4bObk2X4Q2KvSs6Gjqi9WOUwxoNE?=
 =?us-ascii?Q?aYQ3lnjOJ0JZ4G0L4GeX58bvN0ELTWNTKMFfWP4NixCxZpTc9fYC3k/A4AW/?=
 =?us-ascii?Q?hBFJBA08glXjWLUCu7RQjjjYx7hPxg5e9U/cgciBCTMTN0Bgxpj57ZLU1Lfh?=
 =?us-ascii?Q?P3TQ9up1LjioLPB6X8x8JRhFNF82cmPRnqMTCY7Nyz9TNzjpTJaf+IscLPt7?=
 =?us-ascii?Q?7+MVHfaQ+n9chcjnBDRrZ76CjusbKvmMHDATfFEQBpjR+a8zrYqJHEhTap2f?=
 =?us-ascii?Q?txOFFz9UIs7mTHHHstSw13ZKBvM1pfz2tezM9VlcIlPRFyMX6nXtjN/W/Aq5?=
 =?us-ascii?Q?iRn48th6vAOzPp+IhKYtWOFZqot1Qm6VmvaknTx4M9Z+orvjsDibZqiDRsQP?=
 =?us-ascii?Q?0UnjHngGx6bpgTpaPL1JPZs6sHvX3FgsIqDCFF8Z3LR0YQ91s6KFgA31YhQc?=
 =?us-ascii?Q?dshmew8Fr1wtzPEdFal9iapNpVF6dLbfeqjhYpUlSehqIg1fgryqWHprZPOW?=
 =?us-ascii?Q?4F0rlctRnJGjNkKe1vS+0EMJKqRHt0RNjwN6v4FzwGVYMIw+t4OqhkaXkZnI?=
 =?us-ascii?Q?AMdQ9wNrEtP9ADTFHwXIz+HmiHXaoOG1nCBfVzYRBsnqdy3HFRBbvCTtpC0X?=
 =?us-ascii?Q?G1TwQzTCGytqN8W0RuP5VAn1AFR6kkOyhuZ/bBrCudtSp1qM8Bgprk9tVMOo?=
 =?us-ascii?Q?s4FcuZas1GRvDZzc4aJPH8YkWKWw7uYjl6rVtOgixqxwRBXyNG3Vdeh/SBp/?=
 =?us-ascii?Q?fKt6jDqjVYMzENEZL8yPi7u4E4QrIqpPe0Bf03DNwqKuwRV7dineTz4nrVCw?=
 =?us-ascii?Q?g7oNDuDxUe+RDthkv5fJibWz9c3T+ztA0Km5Hxr+O4IQwAd5kpFNJP219mU0?=
 =?us-ascii?Q?Bq9zoLZk03thYB53jkToyk9+K3yLDU7AvBvbDp576+wNbZAiEA2CX8W+/koj?=
 =?us-ascii?Q?UcCGTxsb36S3HM8Bj7f3ZVSua62DHuovGf4ztfhf6Iu8KpyC1rLmNWuaM6Zl?=
 =?us-ascii?Q?Q6DIU3695P2phaUer4IdgDV52OXtXaCVYRoH55aW5FanWvtjCZh/h4xkdnVW?=
 =?us-ascii?Q?Ktk67nU2IC5M6HaPDuOtq7pOYMIMVQCi6OTEJd6dBDu1NztdGWfY8DOdSzkW?=
 =?us-ascii?Q?OJtFu4RMUg2CgrzDTjlIHcRTjWb1wCtBgTwsA232FHl5UPuHIGdugtOgygtU?=
 =?us-ascii?Q?xXBDOOkIn0vHlnAGOkN4ROYnKQJciCIen0gto9HZYJnAKI/3RqJxKmJirs0s?=
 =?us-ascii?Q?P17CTsNWTk8YgzMFcwzvDVaMAmmb1SduarY4P5lFXBAuGCI9VwRTNaN6YAZc?=
 =?us-ascii?Q?IUEKLw6Jo4U1JbRy0RyUya8ir7AroBSDDU9cVEMdYf866V8dnwNpokIlE3V8?=
 =?us-ascii?Q?LQjdsPz6vXPOhqsjifm2qyGIW2k/+caZG4TJTnqf82on73jUr32BXXSnRVvr?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592e5b3b-e448-47e4-b9b0-08dab6465989
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 05:04:09.5635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTaLyismx1GK/VyhKQnQAO5hugONkmxz8nJ0B5QJ7QmQe4t/KKaHUvs6A/AKPN3CvjdsjRw15UF5WyOnqH7bU/AJu0q0qOoEdVmDUV1rJP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The property spi-max-frequency was initially documented as a required
property. It is not actually required, and will break bindings validation
if other control mediums (e.g. PCIe) are used.

Remove this property from the required arguments.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
index 8bf45a5673a4..c6da91211a18 100644
--- a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
@@ -61,7 +61,6 @@ required:
   - reg
   - '#address-cells'
   - '#size-cells'
-  - spi-max-frequency
 
 additionalProperties: false
 
-- 
2.25.1

