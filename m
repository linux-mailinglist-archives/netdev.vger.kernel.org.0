Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F22F6A5F06
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 19:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjB1Svm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 13:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjB1Svk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 13:51:40 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2084.outbound.protection.outlook.com [40.107.104.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2AB2658C;
        Tue, 28 Feb 2023 10:51:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApXyAgdqeg6lDSWv1gho/26+zNJ6TKbNjq9+XHyb/rO8nVeb7Xh+h87D6+PM3O/RPc4MLcnF2Y6eVUhvacHuHM/VtMcwcoJApwnXSlcUMuVoyQlBVZMWF9Pczh8Sp8LLjKCwjROFAHVRIDPl2vzVFBpDXbynbmj48Xi63qCMRx/spcPLxky7QkkXUN4pHUN+BzErQkQivqLcRXdXF+LgKFfgKxlrqJLW7wQa3Pcp4OuUXJPPw7C4oycpSLbzoDd5WhKIfCHXteA6td4Xy9WsXGwUfKQuHM9MGVK+IHcSFFN+rR1Td39cpsRhrdnSx6tMZ4dmiEQ7JTiPaqIQzvvnwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNEhMd0si0yISQ+Ztq9uIMMuryRUkCp3PYqPr7YQFJ0=;
 b=EBBBrAkGX3UksA3Iq6PqXMBGvcalO3XojPgiCVajI7JdTJD36VKQKQqNYxjefHlB5eMbif7bKaOtKt6DbCi7b8c9Myi2SZGxRyIgPLx6EB/PC73TJh76+OPblrBHxgivLB2nAyQocI1GjLgdAavRZzCnIDoYurO68ZkDghqEyCBn1HTEHi21Kxfs5y2hO3+EAHs5yT+cRaHD84Nrg5PXbUQeHKqIrwHD5cA4+I1MVXWnBL0TRaEPZPHmzjYGwOeUuFQllUFptHnZcBNtT8QbmTdvF8s0flZwpbW2D+HNjoBWEdsEtmidv/OuuNdNLq4+SQBNW0sgUDpu/GbxH66gXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNEhMd0si0yISQ+Ztq9uIMMuryRUkCp3PYqPr7YQFJ0=;
 b=azdFT9u6b1aHuuNlGCqeS/XrVw/AuXd8T9RPPmfdELhO2DCYy2G+FQCsEPTqVpfYMqgdLjuY8J4I9hSSfg5El+ss6E6U5hHKIqpbMFQe0COybgadBXOZSlpwV1u2VMvm/n/BgFhaASzbGJAx+/o7gR6/xlpPELAf8m3Ql90XTtNT9JzSJSA69ZKdM2pCNBjywfO5ldAS+FUI53H03IstouxkKNRLyY1X7Rq8r8uuMW2yZl5leQLHnTMmc7EMAiQ1RMvFFUNHk1W4HFTzSvu7bhmTgNfBeml7Tu8XpPgqd1U3nmOUE/7T/HmSoh/KGNLvGQCQFml9HAnX/XTtqNVcNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS4PR08MB8168.eurprd08.prod.outlook.com (2603:10a6:20b:58f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Tue, 28 Feb
 2023 18:51:22 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%7]) with mapi id 15.20.6134.025; Tue, 28 Feb 2023
 18:51:22 +0000
From:   Ken Sloat <ken.s@variscite.com>
Cc:     noname.nuno@gmail.com, pabeni@redhat.com, edumazet@google.com,
        Ken Sloat <ken.s@variscite.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] dt-bindings: net: adin: Document bindings for fast link down disable
Date:   Tue, 28 Feb 2023 13:49:56 -0500
Message-Id: <20230228184956.2309584-2-ken.s@variscite.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230228184956.2309584-1-ken.s@variscite.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <20230228184956.2309584-1-ken.s@variscite.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:408:e2::21) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|AS4PR08MB8168:EE_
X-MS-Office365-Filtering-Correlation-Id: e91bd178-9cb5-4987-bf97-08db19bcc95d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3EqanR15QL6rJ3QfM8J/DbMoIAKHjyKrR2TNf/xmWNOInzqOLdqBVMvG/nx3sgKt1pk8dfG5aE+MO+A5TVbr/JJMNnAfwV2fiz5fJF2qpmeTjwgeJrdm5QhU2QNGFOk4CX4QwpXWzsVXo+H/aFoGd5tzRVUMH+6xKXw8DkpEcXC9DXjRHvVgP2M87iLnQnTQUWG3S88TGeHOq4I2KDms9cy9kRhIwrmNlY9gVOcvMj+DENCjhBUE4Xyw35QRuwSDa0n3fz938+t7txPURivbdoNxs2u3x6GNCCY1gK/qLjMxdXKtusyOXq0E3KDjOJ5jjX8d4UEGKhW6IGIxQLfHxjm7LT7pSG5sbzkyKSh2DjDYX2Ut/0Be2nI5Cgx3DR5suX7Nh6XGeXQwgJXYlJtHMCJ2Ab5PyLCacu38HGYqC++JWr9GzR1NgBSdmPmC6zGTTR2m7iwmCZtlQBRkeoIEkD42rcFoIipAdIGpbx4RU6gvwvz5I4pmeGhssoMWokT0ES22G+RIMbikZDlLUPDVZXo9KQvYQtnfl0cxDmoGFfAYWAOvnvmakpENS6Yf5Vf8dNIAaLkQCwnHvsv0AYx+qV9R7SAGM6C0s00HNLcXanIe/bZFB8bErfvMf2QqmhQcj6i/giI2R5sqRSaQ+qEv7WdzC7gKxpOcKaIhxkGwG4mPZGv+yss2Yx59KslMeuFj1YRQYJP/yjx8syNl9oEJyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(346002)(39840400004)(376002)(109986016)(451199018)(83380400001)(478600001)(316002)(54906003)(36756003)(4326008)(8676002)(38100700002)(38350700002)(2616005)(6506007)(6512007)(1076003)(186003)(26005)(6666004)(52116002)(6486002)(7416002)(5660300002)(66556008)(66946007)(66476007)(8936002)(86362001)(41300700001)(2906002)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CoILtVXFYboxGMjjLK6l9mWxVIrbauspXISH6uXfHg6cK5fCdEw69/WxJ2FA?=
 =?us-ascii?Q?OngU4mH1iI0TgvPlk/3bXEJaOGlfgYAyEYqkDM1dTtyLJZQnHNojuXdlVfFJ?=
 =?us-ascii?Q?t4ptDJmGqlBlYUC/l3lHymRcLcbJscFJM/WpPoKfwOGbeQVSKFEC9i3wMCOU?=
 =?us-ascii?Q?g38mir2m//KUQbOU+DipvH2gzldx6KAwsr9ppcgPUL2gaeroJcsLQgkdE8U0?=
 =?us-ascii?Q?T8cjhJII+CBxfStpTBPqF8Db/ZHc9ylowRVB89fIwJ711zPa0N2EaqPyEkxm?=
 =?us-ascii?Q?zBlxj6axGYEWbZwLvMbYFPKgm5Sx9EpygAyC+gijzIamp7CAa6nlgJ4cJrdY?=
 =?us-ascii?Q?FTXk4kjMtDnpjsATwY/NXdoqMyh/bjNvuosIpB8Y0rfmBMhNOcMPevQMY0Fc?=
 =?us-ascii?Q?ys/kOrdmhu2ca8VdmD5RcOl2rWYa00PFk45VGIReDPjzLcl/gYBFhnsi+8Y2?=
 =?us-ascii?Q?tzOlUlfud2o6HjO8Bh5NYFfUlqumivfp9v2f2cYSoUGAN6ejuEZbfKfzQjtx?=
 =?us-ascii?Q?nm6ruoINt5bbKgU5GIkROfe3+0TJgTLGd5ECD+1kw2CUq2k1vewUs4iPC+GM?=
 =?us-ascii?Q?5oqhiAw2k14bQ2rGGO/EbyNBqwlU9+Coyl2aFDfyJFPM5iwojjC6LdDSSHvR?=
 =?us-ascii?Q?8xHL7RvI/uuAeZDVhsc6qeypqwWiL7VNT+S5hshFRmJt32P4cCViKhkLjwp0?=
 =?us-ascii?Q?SpxdU95C6Z1CLlDMruocS3BDspgzmiUwZfadJ92qj5nDWApHQz5ZsKwsF9+Q?=
 =?us-ascii?Q?j4P9mVKaa0yUvnNo6Ji+YFCEGKufRhMWsIz49LKBtJvd9HumsBoUPqG65l97?=
 =?us-ascii?Q?XN+tiCOEc94Fyb3P6/bKCN819Phq0m0aMjC3cgJmI5SwFomV7l5reg6Qzaum?=
 =?us-ascii?Q?7D2yNE+jVXWgYrcxkijewUrCyaTZMuTnzS4bcprZuWuvsGl72WsO1BPFJpvr?=
 =?us-ascii?Q?HMI7VpO9hJn223r0tso+pCzgt2VjQH6YKiyymDaqb961KjXBPQWxFTsboSlN?=
 =?us-ascii?Q?pozE24VQxrHPBZ2HXI8v2x9cZS8VD9SP/VPo3axzP87erw0eZpa3HqTSOKk8?=
 =?us-ascii?Q?ZpkAHzY4X2xaKWiYCSU4yB/52I+3umsQ3Nn5iE4NiKTqHX37Eo/stYl0uGzI?=
 =?us-ascii?Q?HEJ/1JqVM756wfwypM8NlgWWV6fCr/yDBwc4lkt14xzaHvTdXX8aT0XgDTm5?=
 =?us-ascii?Q?whGCWNfrw1WjbwNKnlPUvQQYIojn6Uc1UFk2ib2skieEO1lSWKIAmL+f0QKl?=
 =?us-ascii?Q?6oXwN6E7CCmaszlRfiaWe4MOtUuhwNdW7fT23iHvXC7pJHclktgGF9pBr8ev?=
 =?us-ascii?Q?q4vxwBzpWyQt8u+OxgWozePDNnBsG8ZcN3NtlJgQ7j+O/JyM1y+hGkmQNjoB?=
 =?us-ascii?Q?g79Lb644tpEFSSo3exi0Vjowmcg9ShA+koKIbdaxJBqHzy2wlbClw1y16C3c?=
 =?us-ascii?Q?4GgvAKQplcHQUF/a2Nq/cDaLwCBYGlqWKZJv4dMjIwzDa1zSPLu03vDviD2j?=
 =?us-ascii?Q?0VKFYcH9y+UmPc5bff9svdNPI7JjAcGQAeMZ0TWoNzgAc6nKVrTcSICfwQ/T?=
 =?us-ascii?Q?4lrdN7YQPFGd5JgAflCUn4G/U0VQMKuc9+Zn3mLI?=
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e91bd178-9cb5-4987-bf97-08db19bcc95d
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 18:51:22.7061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9+aHMzoikPEdRxQbh4r7c6J8e0/UDExhG65G3kyXMndXVswjfOb4nPWkbLgvvBgb/vYDv2b3qvM/AaMD9OjyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8168
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADI PHY contains a feature commonly known as "Fast Link Down" and
called "Enhanced Link Detection" by ADI. This feature is enabled by
default and provides earlier detection of link loss in certain
situations.

Document the new optional flags "adi,disable-fast-down-1000base-t" and
"adi,disable-fast-down-100base-tx" which disable the "Fast Link Down"
feature in the ADI PHY.

Signed-off-by: Ken Sloat <ken.s@variscite.com>
---
 Documentation/devicetree/bindings/net/adi,adin.yaml | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 64ec1ec71ccd..923baff26c3e 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -52,6 +52,18 @@ properties:
     description: Enable 25MHz reference clock output on CLK25_REF pin.
     type: boolean
 
+  adi,disable-fast-down-1000base-t:
+    $ref: /schemas/types.yaml#definitions/flag
+    description: |
+      If set, disables any ADI fast link down ("Enhanced Link Detection")
+      function bits for 1000base-t interfaces.
+
+  adi,disable-fast-down-100base-tx:
+    $ref: /schemas/types.yaml#definitions/flag
+    description: |
+      If set, disables any ADI fast link down ("Enhanced Link Detection")
+      function bits for 100base-tx interfaces.
+
 unevaluatedProperties: false
 
   adi,phy-mode-override:
-- 
2.34.1

