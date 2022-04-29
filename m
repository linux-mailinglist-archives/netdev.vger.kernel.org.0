Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A785153E9
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 20:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377752AbiD2Ssf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 14:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242031AbiD2Sse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 14:48:34 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C7E2D1D5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 11:45:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJrIWkeaBTzvOsYnOPmv7kYz0oBy3YY7l6sFi2wByJRSbhQRRWkO06Pn6sW0tfYYpZ4kKd1GNhk6WZUPUpyhT1yBWaVTXyzdmdVAaUYuJH5cEK7KPcpIpfQfhLkalpq+WA4DiiLsafNkHOn8Jps0gVsR6RfojXo6Lb1xKB9ll72+kTWS2Oz+mhU0ZCBqklnLbg3KZ/p/xszmJRGykpI2ByNMlWG96D+XowXApjbpu35eFse3wIvxoNy8gvMd1xmNlDUmDRfiRCbJeFUPtAhptfWXWzVZwAY6MYy4EsCNfNy+NCFHFgnf4RdjjcLssIAlCV1QfEhFdiVn+wRCJf3jMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aaUzEwBKeW9pt0iOgotcAq52QunRz5iXw59ssjWcZLM=;
 b=a9+UupzKOZXVtCuzV6Q1XUoKOOHIRXEqnESpe/4mSNq548qrngBC8nKqeftaqxkHt2pc793RoNPWuKTaFz3IvxUIEbsuNIb0rzeNTEjhgi/CCL3JKN7MF+yZHtYCeSzt02IrrwIl8xTT0C6Q5FmDGIRlr5saKOVxYIpvCKsg01/hj0JoOsedoRnHlu80nOudmGGqPC1h1pg0LKrjMGURU2gMq3J5fY1dDEkE5Eg90f00DFANIfW63KnEazPUJujEymjNH9/JBGQN20Et+UN9iYZNT6IkUCiW6gqlJ/67g8GuKo8mGDcOG72ocC2Bzz6L43I6wbjKzHsFyntk0VDJZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aaUzEwBKeW9pt0iOgotcAq52QunRz5iXw59ssjWcZLM=;
 b=OY0UQm3H4iwUFs2Oh4CxBOVANKr/ugJo19T4XkOCdgG0fHWSFCz8x7Fsj5xtH/t+ayOmX8xAVQTXUCzTLMJKUuU4DYYEUt2lif+S1HV3tGYKnUEFWxam4RHpnFHhx34ILWdIHL/xYOCLYmWFlZcXDxYBmE7wp0j8nBJckm20TQtf5d+07dHytu3mtvXim1xgPU1x/YIlvAVxeDIFFKeqEF8KYq/3UX788U8QCiB7EDpfAF+gybpaj2jpbZQ0cmY9R3VmqiPB1Jl8iBm8pbgr6dCHrLZ8MTXkDjLXOo0kFcKl53kyQq/OygFz/ptuN2/1GagalkD+WU9SzSgOP5ww6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
Received: from AM8PR08MB5746.eurprd08.prod.outlook.com (2603:10a6:20b:1d8::20)
 by AS8PR08MB6632.eurprd08.prod.outlook.com (2603:10a6:20b:31c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 18:45:11 +0000
Received: from AM8PR08MB5746.eurprd08.prod.outlook.com
 ([fe80::9dfd:cf1c:a154:9a09]) by AM8PR08MB5746.eurprd08.prod.outlook.com
 ([fe80::9dfd:cf1c:a154:9a09%9]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 18:45:11 +0000
From:   Nate Drude <nate.d@variscite.com>
To:     netdev@vger.kernel.org
Cc:     michael.hennerich@analog.com, eran.m@variscite.com,
        Nate Drude <nate.d@variscite.com>
Subject: [PATCH 1/2] dt-bindings: net: adin: document adi,clk_rcvr_125_en property
Date:   Fri, 29 Apr 2022 13:44:31 -0500
Message-Id: <20220429184432.962738-1-nate.d@variscite.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0049.namprd04.prod.outlook.com
 (2603:10b6:610:77::24) To AM8PR08MB5746.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d8::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 921aec10-44e0-4624-10d7-08da2a1063da
X-MS-TrafficTypeDiagnostic: AS8PR08MB6632:EE_
X-Microsoft-Antispam-PRVS: <AS8PR08MB663202B8C67D59569633936285FC9@AS8PR08MB6632.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHSje6gVe9xf9Pq++MohVWlNMPIidVwuvoWznMQeBWr6Kh6MTjx6QTw7ZPI/ubKhBxNna72bgkFPLv/tJnMj6Y8hcjv/24KYhqz6MeLk3WC8HxeYXcZFwZhq2hJbs4VcF2rZxDQumHgE2s6pe0NWtmICo98I401lA5jKWRY5qL9yEatKiiJRllAptA4q5DEk/cB5x2hdv7yFZ12XDcNuiTyc1lHD04p1QjqHeD9CglmgKk/p+5cMnF2L5DbF22YLfk3plJErKtQ0fE4FfayL3RyI8QRt0fJGU1GbfFULI40OKJ11EnhnpsxfnKbO5a04TWUalNj9PvXxfVflE0bK4mjlEKmA3ZUdOwP6ci57Np9rn8DOrglxS3Bw4kkgSIp7vUOqXb8RtBBAmZ9pkKgEFJscrsTDZTL6ETfwuhirK4+gFR2sGKadDNyD/ggCFCOu+crAzMz5isRPWZJyMjkU43+dvn10UEfgSKWO2E/Nv4Paxse2nTWDBK6i/V78H9TpMEKyL0GK95LCveHyAJMgP3HtbHQmI11EvWKwBFS4tbuM/k6z09zey/mXAqk3O2uiAJDv10i6U/2glXmi4EdDR1KyDF9zM4KEr0fqhkno8gSgWr4xlel4qYrePAaaNl3bf0O80LNM/SCUD+4CTwWsMgR7xjCfWXW7d1zUTFfyavab3yiQ384is9Y0Rds6aAb/tlXqcp3eCQ4zP8U9NRCHtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5746.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(376002)(136003)(39840400004)(346002)(396003)(86362001)(6486002)(508600001)(2616005)(107886003)(1076003)(26005)(6506007)(6512007)(38100700002)(38350700002)(6666004)(66946007)(66556008)(66476007)(316002)(2906002)(186003)(4744005)(5660300002)(36756003)(8936002)(83380400001)(4326008)(6916009)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ddXWih80ww83uMaZNMUa8jNfyvMuSvd0609CKrzA3rcfoYo5PWj+CbBqAMx?=
 =?us-ascii?Q?3SF/Sx/SUG6PwIOvZBGniRySmqCyjanoQDwx22c4QKfUFH2nzq3VQa4EEOJ8?=
 =?us-ascii?Q?4Lt+UWIgbOjbw2yPwo976jGb+Ek1D/KaP1EJGIJkJCzcZfmTymtKPc7PylbX?=
 =?us-ascii?Q?RLN3SwxrA0mD9WE/SrBS814YCxYjzfpvYOKbdxtv/DieYH64c+sLQzuENQ8c?=
 =?us-ascii?Q?Eed0IsjCUzChdV1wLV9mbvNemMnqTBROaP7K6PUqqdBREBbV+gkzP2NpJmc8?=
 =?us-ascii?Q?+WNo0lEcT3RuVCQnLEDyoMep79DMZXTBpvMeFtqcQX0xt41XVRL5/KH+PeXX?=
 =?us-ascii?Q?obzn6MxwqpCLF+lJ8yi3nT3lqdobqrf2ayRbwereH+C/u3I0XVrbM940tarH?=
 =?us-ascii?Q?gl+MrleOx1AR+I42QMOw3InfqEfaAXKReRYgQindn8Du0gIfe9zKcCxGckMO?=
 =?us-ascii?Q?HsBF6QOpl4VCci9fk3mn0/E43uO/oa4oUvmQ+iXRiwDhCxlBXrPQkpkrziiM?=
 =?us-ascii?Q?yoOjNxpDexU93UnBLKlgVQ5nPtCkjYaUxVDJtJLWfnSAqT6I54x4KNtkUT9c?=
 =?us-ascii?Q?GoM3AW4qKbFx1p+lixfIvL20hdIV9yih2EFogvC2qJpQf8X8JoeHrIFZ0on4?=
 =?us-ascii?Q?LP1f95kQHjdJXTTbPvwDAw5h6Ny/awsjtRvVtBeiCFCcwVDKw8Pw6GeeFYVr?=
 =?us-ascii?Q?AvdmlltG/4xlfThpachfBLaYrqWYKCpAV6GIeIX7xUugyjNT7qzFAJWHkhwY?=
 =?us-ascii?Q?90hFh6A69cFyEQ0Z4yB5pznAiiYbyyS5V9cdRrHs3BcSj+rZN81QxFaziyif?=
 =?us-ascii?Q?ni6gAWbyzjrFXzob+jGPBvvV1a91/FsRudl6CVTl85uJITgrUEMUD09Aj/h/?=
 =?us-ascii?Q?5C1WZCKneYiC3WvTJLEu41tryNK9qj+P9k3l3zbe3D1IJsPrLs1xB3LXsWbw?=
 =?us-ascii?Q?sWV1/NpU8Im1YVoyyRqIGvWdAKa68aaHVA+k8wG5WgF3jkINF9b147onaecy?=
 =?us-ascii?Q?vNgXbQe87AURufJBFAIgsmnj8mR/MNcj6eWq4uAV8MP11brxeEePiRowbweO?=
 =?us-ascii?Q?atvw+9Kets4NlAZBaOom5waO8SkGiyBFLDvz4Sgcuf0yftPwMPvQqDcSImlY?=
 =?us-ascii?Q?FTNK848rHbLkG8CwF5U1kvJ49w6O+I78a9r4Rm/689M7QTIYuCZq2vTI6jGV?=
 =?us-ascii?Q?/Oxg9BIjFxpm0ekwy+81PmMM0icp0WRMIkAtz/tWBoNBlJCIv32lVr22kMR3?=
 =?us-ascii?Q?Ttl8Mgw1T7IwCfC6jkAwyPH8qz1HF9yvcMqS4Z1hwV6v9kh8TCqVdWk5NM3C?=
 =?us-ascii?Q?+LpFJJmpVTOdpAiPh14eG0S5pUMtT6bz/NKOljwyKXqbiMqIKMfC2RRMzYWN?=
 =?us-ascii?Q?f+jcJG+8f5GV2rjYy+/ISsOWJck32SGqu7ZQWfJLoiKnydj+PtwZaJ/kcYLh?=
 =?us-ascii?Q?K2BPD59XVJXQKyBEfWbGc66NlIzrUK/kOPMSehCvZjlLccjDJozOmRwW+BJ6?=
 =?us-ascii?Q?MsO4xd40atPBmfGFucntxf43pTqL5SFCsGvzKMjzYkAZcJHI0OGXX6G+u1rm?=
 =?us-ascii?Q?Lm9zZ8HzCD9oMRj5cyfPMjMEmElgbfgz4w/uqP3VUVPSWO71fOwrqtdt2eH5?=
 =?us-ascii?Q?h7H30RS29eK1eXCQXh8M6j7DonvopSx9AS8YYtOLrZHqOWslPWxtpvq3jwbm?=
 =?us-ascii?Q?QFmfzbIVuRG2qorompquZyQNJ4x6JDL3iRMkdh1GfI/XXI6KyctjR4dZyl21?=
 =?us-ascii?Q?dFj9jii0ZA=3D=3D?=
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 921aec10-44e0-4624-10d7-08da2a1063da
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5746.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 18:45:11.1612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRkarZDS7zM56BHrcDa7lHOro8Uujbyfh61k7fZKIzfUwp7cZipMcRVjtdSqQwLFaOA+nSb/J0p+q/pfGc+l1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6632
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document device tree property to set GE_CLK_RCVR_125_EN (bit 5 of GE_CLK_CFG),
causing the 125 MHz PHY recovered clock (or PLL clock) to be driven at
the GP_CLK pin.

Signed-off-by: Nate Drude <nate.d@variscite.com>
---
 Documentation/devicetree/bindings/net/adi,adin.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 1129f2b58e98..5fdbbd5aff82 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -36,6 +36,11 @@ properties:
     enum: [ 4, 8, 12, 16, 20, 24 ]
     default: 8
 
+  adi,clk_rcvr_125_en:
+    description: |
+      Set GE_CLK_RCVR_125_EN (bit 5 of GE_CLK_CFG), causing the 125 MHz
+      PHY recovered clock (or PLL clock) to be driven at the GP_CLK pin.
+
 unevaluatedProperties: false
 
 examples:
-- 
2.25.1

