Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF9F580BCB
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiGZGpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiGZGp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:45:29 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B743D205DE;
        Mon, 25 Jul 2022 23:45:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJuNhO364OBdVW4Vc+F3ztPFJ3KNlot0AJvxrjIT96M+28m4vp/tJZXDkxtSBIqK8faWc9BQdZlzM1HbnDURZXrDX9l5ruCzCJjAELZSbYxC0Hhz/N6QKdDo6ObP1uuPMzld/q1quTRuFmM93pHWxzpNua9WO0s4zfvPUN9ysloJf/X2cbpB9Ba8hlV42YKuHiruUV0Q7PLIrucRvY2PWUtOEQezy1ujWL8k6xbiRamEi9+AEiQT+jsZGjhftJpT5uVCyucCEYjE7fBXN708swzw2fbWfFn+pdAopI9pRVKWtlWxvxZ8OG/ZjFkELgf7LYQzcH1dt5Puq5Qc5NE/eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hFtLGuRNRpY9azyFB5pS0/+1Gyo9DVFeZUg61gdaOw=;
 b=O3GfvUMUqJT+AQ1oeuOXOvZdlpiv/Pmni4QzXZB5q+lACLRvdfypWo47Yo/vWre+8ExOX1iU3fpBv1K0Lzo/69PoKpSAdw26I1DM3ot3xkdecFq2UjqYiYEvoU1nZ1PswtVt2EbZNi1HCm8YlLTFb9xf7YezIi9ZKp4PfFFVjZqgtloVvc4KE+bYwUWKS2A4rKrh7vAcutlasxky8y0W1UNBXciG9s/Oyzh3deGdwP99yQLhFxlDiY/uUjF8lCMBo7gYXhJcK8Y2pX8WiQt1CjfwQaJzkKKEnrG2KoYzZBs6Eq9Pwol/FPSO1+ZlfEy3gLoLKxlKyQe4aE7UgcsWUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hFtLGuRNRpY9azyFB5pS0/+1Gyo9DVFeZUg61gdaOw=;
 b=f5xlC5WHgV4KuU5m8hPb2VOMi1EbBvgBjEp0xmfeMzVM3GawkWuCia1kyqQGETpFNFwvcYBa04/NURLAHY64NecTxaxic00yrGmi2Msnq+D0+yNbWeo7IvrrDgqRsQSlcQzl/AtVvVJHC42x7wLl5XGkXghePlfKwCw59UiGw/Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by VI1PR04MB3247.eurprd04.prod.outlook.com (2603:10a6:802:8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Tue, 26 Jul
 2022 06:45:25 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%8]) with mapi id 15.20.5458.024; Tue, 26 Jul 2022
 06:45:25 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V4 1/3] dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
Date:   Wed, 27 Jul 2022 00:38:51 +1000
Message-Id: <20220726143853.23709-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726143853.23709-1-wei.fang@nxp.com>
References: <20220726143853.23709-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0003.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::20) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d720491e-f9aa-4fe3-8b02-08da6ed26b66
X-MS-TrafficTypeDiagnostic: VI1PR04MB3247:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AN++MtR7lUQ7/qBVS0wn1s13rj43dQf2+z7Zs395kKiy54rgpRo3p1NBQyaP+0xNE8EeKcNYrTkcI1fytKI0txrjLKvNjMCQ2tRBKCT3bBeGXUeuGj0hOUiPFeNIak493cTZEqMWE+3ALO6UaipfqkNoDFHXvsQ8saFNpjO/j/XUsJbmRxH59kcmjRPBH/nuuyqawOwr5+6toOoChjNs4rlNVfiUuIMEi8dCuw5++ah5oGqN8zO1lQVmjdIhlZ7ZthXhlQ5rbsfnxTVUG1vXdBg+BhEF0KLY83Ws+t+vZ55RAiiu/edvCTKdOrCkW08Q/Wds/YIkueVcYugEr5u0mbyc1t8HtBSC0v7xiNjZL7XgvlC9ltGIXBdaRHTiW3dcEOj7fxNSj0I4oDuTpRLGpwScRjsrUN00G9xCKk9U6Q+L7tpYcpvxfr8RsCxiPaG2SJ1sGr1cqW2H4cpEA4V1T9ofDI32IhE07W4lrYYOa1q8C62ac2aJXw6m1woc3ecYyTtglOOLjbB5Jm1vl1Z4GqwBK4sZ+VHTzG/vQZKuCSdu7Ei53sxXgTNa8gbcZ7O3OlrUJtzapaUEjdQ4zHi7zJasG7LAg0JbKP7P3KghYuxN3LeU3XGfUGMJGKVmKDkyl3oTQ9zWEfADmh3Tp9xWtcXwOryqAnCYDOwj6G4gykdc7yb4hA2GeovZPbtCCFoJaVY+5SHFOtrkwUDZomrSZ1lbTu5z+i9HWI+miAERV+VoAtbBPjtXgvm+4WmqIUrc44pAyF7KzJiPzNJ0MJ7hBRmoCt5nU6QWKre/p2bLyn4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(36756003)(1076003)(186003)(86362001)(2616005)(2906002)(5660300002)(7416002)(4744005)(4326008)(38100700002)(8676002)(66946007)(66556008)(66476007)(38350700002)(8936002)(41300700001)(6666004)(316002)(6506007)(52116002)(9686003)(6512007)(26005)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sDcxj/h512BejOrDJWhJsPxQIlkEOYgQpPX5mrLY+BbQuS7Xa5PMOfvDG0+2?=
 =?us-ascii?Q?xKwlQFjibm9LrkqGpP5smLziRG8LH4/NSt1g55Ng/KqK5JNADiIm/ErL4uW1?=
 =?us-ascii?Q?wzNc+LtRZoHu9EOrQ0HpfbUMVC3KK6iqx5zpprLsV1eyFyzS1SjYCG6ZOLFw?=
 =?us-ascii?Q?gA/BlWE1dEm67BojwPW/SORVeGve4NSx2m3QIRRNS0Crsz4TG4mQP1zaauqR?=
 =?us-ascii?Q?KFRhG7+uNKdcS8Mj8KvRfvJsVIk52oJA2pXO3yOnGpMuuRsP170I1xDKLqGA?=
 =?us-ascii?Q?xzA7Z4lDu8CFIK07qtUITTYrdbcpxivkMOB/GcQJ+TpR9Ly7uh4pQtIhK8Kl?=
 =?us-ascii?Q?RZ8HKrgGPbTLLs+ueveFub99DL9IHxXxk0vo1rXU5CGyFcianpJHGgUjd8hX?=
 =?us-ascii?Q?bFyo5MaSDB4OmrH0/hF+4Bwge+HaiZRwkdy5QDtWMmF6fP3r3uuyAeinlHe2?=
 =?us-ascii?Q?bhcHdXeTxBOd70xusV++Y0Hzv4TSG0NUAbgb9y7FtI38pYR/JH1tMgidDoFQ?=
 =?us-ascii?Q?DqguqsHUqLkbR02MxZd8kmc8zhwMtt6KIgB7VNjRzi0hVJUI8qKW4+gH96lW?=
 =?us-ascii?Q?xpwmkj1nIF99TsV8gNUgXN9mJGMHyilfefcIPZ2njZ2ZvlSJTEgw4ascmMpn?=
 =?us-ascii?Q?/HqqKUYQS4/f7wy2w5+1UkiU1Shj6c6sssEJ9KnQ07thnM69SLVCDgP2p9NQ?=
 =?us-ascii?Q?0Rk1fgzgTu2AbLUEnaSxZrE4dOEzgfnCc00d1Mi8wURJVFyJ7Y2h/+NUD6id?=
 =?us-ascii?Q?kZ4IX25nyWLErYWhXf6wyRYZP+QGwr2pwY1G+BYIYOV9HT1c5r9j1ESqNs9c?=
 =?us-ascii?Q?0IgN2ujif6kWc0yJGtOfhPEblT7io0IaRUtg2UeST8cHB7wKtqlRMMzAzu/C?=
 =?us-ascii?Q?IyA6qnAhgZVQLxB48hwD0IEOm3k36mJlyBRA5uhngOFK0/msMbXy3pbrkcYu?=
 =?us-ascii?Q?WWfR/6ogQRCoswEI4BwPAvS8Ohh4F14Oiq7U4wR3R05Xn0EYq7IRdd9+nYNv?=
 =?us-ascii?Q?NTclCfwGSja7WXD/WAnSeuL/rSpi/R42LkvFhQ/TJdzuXwbscJ3V/exV3WkD?=
 =?us-ascii?Q?pGkSKuV+AmwkGThSM3qIPPMo6kHGkcrP2rHBMnTu1aRczvKyytpSyndYs8ok?=
 =?us-ascii?Q?tcyjgWHsD0x5PWgf94kd0lv+NuyaS75O/mFJweZ0TB2H3N/mSS2MeYdYQoU0?=
 =?us-ascii?Q?PJf6mDkTUrMmAFGmYkxXNOKdPBey0vQFF+bTLlYJHO6fmuvaIK5ETMLa+K8Z?=
 =?us-ascii?Q?5gf+vjsJJtAAqLGylKpYOMaOVjnUl4jDKvkW6AUU8sxcLNMxFMJt3q4hwODX?=
 =?us-ascii?Q?sQ6EaE67WR8LQn1VxwBCrq6rIdoogesTs45tClCr2y2I7O7mS1/WWPLoGCL1?=
 =?us-ascii?Q?mTyp7OU2+3e16RRatz11SJhEQM2RsB5hCveCvWMFUDyhqCArFr/GBFiC4JmK?=
 =?us-ascii?Q?iGh47kfxRYh7X+yX1hWznhi+xNu35P2ODBH9wR04x+IgwK9phtLda1iTMGDu?=
 =?us-ascii?Q?OVa34181/buZRFhAxL9seYAtKgthZoqXJYLtNncnHKa3wHOKQKWFQrC8fHYo?=
 =?us-ascii?Q?EQf2DBI0bdXdmvG69EIRhAmda9pI3ygSmaP25rHp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d720491e-f9aa-4fe3-8b02-08da6ed26b66
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 06:45:25.3072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrZBiIa04Vo4VIjgMlDNbGLRV5609Z8RA4q+iYkplvGQmXYQ4nnKSgnYH18tyPcmS05cmITVaqebX3gvhms8bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3247
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Add fsl,imx8ulp-fec for i.MX8ULP platform.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
V2 change:
Add fsl,imx6q-fec
V3 change:
No change.
V4 change:
Add Acked-by tag.
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..4d2454ade3b6 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -58,6 +58,11 @@ properties:
               - fsl,imx8qxp-fec
           - const: fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8ulp-fec
+          - const: fsl,imx6ul-fec
+          - const: fsl,imx6q-fec
 
   reg:
     maxItems: 1
-- 
2.25.1

