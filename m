Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32183502D45
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355617AbiDOPtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355600AbiDOPtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:49:08 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED605BE5D
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:46:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFMsAiQ52q+UANckyPLvv9ce4D2H9W56CflD+djcJ0/w6Iwakhyod2ZTiuwLR70sKr0P+sF2a90O9tISyLYX9n8btMFPCXpgFi1IHHkdpHegX6T+UDUhIlTLjoTEkNRQQpXfqb4LSu8c2tRc5Me4rtww4YyXw/SZNsTOuThFRjXbTyCwlhDBbNRfyPtWsFwr0/ZV2zZ7D0JKevQvZil5wZAQiMTx3J2r5WEMIJV7DKRj/e9vqkn3d7HxdK9e9DBzRY+nnL/wREcnOedgolNOy4VM0MDJLXwFkU6r4Oy8WTdNtQnHTYQ2zZMUGISmT0kmFhdwY+jWw9zyfNaiDBdSyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjxX1XZR7B2Fc97lXemrIvtQs5USGpzqtYRx5/yxftc=;
 b=ZabecNnZU41fBGfcPtaw/X+NGXYCvmuE4tn8swm1yyxuod2RAbQe/DXjq3mS0cEWNnYCkc9d4t6xbFn7Ev6u+XUY5OdKXJbzXuqu3Frp5w4jpVWYhCEaeNMFQHYd+qWHorzBH/S3qGckpn4fBQ23hM2I0Vs4y+wu/cuX/Mq6LzEDkMVu469IibfaxPoxvwS0oKJRAgsrd5GieSuZdSugCP9Ut0IHQoFlruZojhVFbDLVR5mgoHrUoYSxWwqZyZRvupLatsFeLb93aTx6Kpzcszvx44hYV5MSXR5zwdDA2C7D/IU4FXiJGKwAYxWnSDI25da5NfR8/SoaS/GvojaVBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjxX1XZR7B2Fc97lXemrIvtQs5USGpzqtYRx5/yxftc=;
 b=r/WDO3TOt33QZBXzoymX8TmUQwH8PSd4yxMcsTYjL2V9AvvCwdlj7cBcnpayOfbXTBjdSzJFNNgeOzeImPiGU3egN02tmFo899WlMtdrpQNNAWb1YJNfP+hsUOhiNd9oc6K3Bighqh6CKcZjsq4XnTQZqaDx3lDuezPgYD05GMc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3385.eurprd04.prod.outlook.com (2603:10a6:7:8a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:46:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:46:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 5/6] net: dsa: drop dsa_slave_priv from dsa_slave_change_mtu
Date:   Fri, 15 Apr 2022 18:46:25 +0300
Message-Id: <20220415154626.345767-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415154626.345767-1-vladimir.oltean@nxp.com>
References: <20220415154626.345767-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbf698d0-fea8-452b-c5c0-08da1ef72044
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3385:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB338560EB0090BFF0462A3665E0EE9@HE1PR0402MB3385.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJxH9KWpSmclEzPAwtdT9CJpmXpP1kYwuspwYuwgvhiQgUntVdYMbbm3YRut5Zfq9J/QAl9Tfm2qdk15wkAvwNjR38EaOiJ92XacmlKPDNRhf8RuDXEPbe/2JCcYQv7eIFOsKtAuv7H8oZvayPp6BfHnuLERbIwYS/nMco8DotVQtml6GuaG21S+DckC9Mj14bPPmi9MetgTgCS3qJ+ZYofII/ae/qRqe6ydUua0iXWjXzW2LlfotauGwPyxjwZUkK9nIEXBWOGjTbTd2AabulximspF8bROqllP/YmAh61vE5L/SiuS15cSWzMKJ75bTH5ykXW3K/f4krZapRbUXdp/LbvDU+8zN5TNa1YnnczwxKKQHQW7sD+qNEcpPJx0YPXdVvYWzeG5djs6onE22ayWLD+vbv5Otb7LGeCYaiE6ma0t/Olr7p9XVwnYzo2C/aHoPwywFmVeH6QCqkVfXa377gGRHBNDW4xKxmUETMxEXLP2TdaTRMr1CPAuwAG818i0gaT8F3axwevxzPQIBFFSgzU6UtBAfteE5SaN8wXkrCxz+5lWjeKzAGLdao+6VWd+WZP4dHUqKF1k2jSo7nCsu09SpJNVBjEETMLgcZuQZA2+L8PLIOgkB3+CZ7fBrIqcqY32qQxC/hnSzm2i4eDZ315fsV3puBPmVIr4ezH4BDg7rHh0mAwhIEVOwJ4XPF/7rNIDr6Xix0LGyQ3FQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(6486002)(36756003)(316002)(52116002)(2616005)(4744005)(508600001)(186003)(5660300002)(54906003)(38100700002)(38350700002)(6506007)(8936002)(6666004)(6512007)(2906002)(44832011)(4326008)(66556008)(66476007)(66946007)(83380400001)(86362001)(6916009)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?alIxBWnjUxIxaDPFU5LDQlTao39QXlapZ5Zu++iLO4ZTtnJSO6cad/VWdJKr?=
 =?us-ascii?Q?oj5jq4orooDpVf/oSihZIEMsaQ9Gb65q5oEFJxij6OFmaYH2hFBFdk8Ph0W7?=
 =?us-ascii?Q?2T2CIyVxfANhpnUZ59q3SVIAS+aXUgHjpnATDplgECGcY8A4E+WuJquq/6oc?=
 =?us-ascii?Q?7Wg/bypAtRyEI/H/0uSZbAMuMTTCexrndIOeL1wa5mVQfZItsm1HElQeXS/u?=
 =?us-ascii?Q?IMaCSWwFrI1jGwyUnF4CZo6StfCIC9hPY9X3xO5qQ2Nvi2a0yTvmIwpL8lO9?=
 =?us-ascii?Q?H9gcaNuzQ2IaEHN1/YE4CrbZ0PxNK48dvbHyW8ekZFxviltd6xdeOh5CYxq+?=
 =?us-ascii?Q?ddZGISVEoc7PXl/AobRYehu+Ew3mg+h3beM+NdLJPEAGtvE42LdS7ucYAXiF?=
 =?us-ascii?Q?ze8A1Q6/Mpd7inQoPNiIknx4T+eFPbIC3mSuQfe6XrcVGi7o1hbn5sVlmLct?=
 =?us-ascii?Q?uDWWB0PKBVimNIxN78jcBtIyBkt9a4r6QqnJF6ZG1z38jlJoHCOwBesZuhpK?=
 =?us-ascii?Q?AMuhllo9XPd3eKLGMtI2ZvhOEq7KvMyc4MV/iVuASWksKIJavH3OexFpA8X3?=
 =?us-ascii?Q?U62l+xtASNJsRZKxDYn9wi/5mHneQyXuLfabR/HAtEjfRtY0cb+fndN3HXHr?=
 =?us-ascii?Q?x+qY4hC8NUfHPjZHbGgphFr2GDZ6UWkxRQR7JbUDMjKYdLta9lE1sHZ17MCH?=
 =?us-ascii?Q?p3hLefQS+vRneDsEyrhfDTeQR8q8VThy8a6ce/J3w61EJ+KiEQJRaBpfcy+L?=
 =?us-ascii?Q?g4fb4XthLIDBJ2kDw8o/gMd7tvFD1dROl0XR8l5s465/vlWomIyXDFnbsAKV?=
 =?us-ascii?Q?DefTELPRM71XAgWENQTDCP5dqftrdsZgBl0VF6fkZ0nyBDTtIUYtkbzdIi4c?=
 =?us-ascii?Q?2zkkgVmwE9agiP5ahusP+W4Mw73bVsvw9OsptlnxYZhg1cHg84/S2FnpZHlb?=
 =?us-ascii?Q?EaT9EnhOCZF/dE+3z9NCjkfZ2xwOrBb7NpCeYaajVaLHIV4ldyDohrZ2ascE?=
 =?us-ascii?Q?GUpCmIjyPU2gW3xMJtI+o/H5bT6ikldUTr5lYjtQo0vYXISjViyHm1/p9SsG?=
 =?us-ascii?Q?vMvenMKA91BuKg+Rc4PGGIBpusOEEx4W8X7XDdEKHeaQ9cQZXH0DCj0OvlST?=
 =?us-ascii?Q?li+jeVoaHd/oEeIJcrKKVOjUk+o6k22Eooiw4IbIcsqx8DEaSb/MM1r3Ypsb?=
 =?us-ascii?Q?/56Fyc/XiVTYodIMgZY+5zHNHHEkkKba0HLGpJrETeUZSDfiUc1wY2AP0Xtn?=
 =?us-ascii?Q?xnEV9vrEHwAft8hTROwqKFAD0/Hlze6ONJzPdA4vvnJH/uYX+HsgDhR08s67?=
 =?us-ascii?Q?5HvxbO1NuI8GyuUx0sv81pF/kaH0ObULBSoFCjxUr0Do52wCmp6FPAUobySd?=
 =?us-ascii?Q?bKJZRTN+1GTnILAmwhg9IsZ3SQfnBr/yTdLOL/mBg1q6siSW5G2BQ9YH/3w7?=
 =?us-ascii?Q?8nzgR4t4bwL5xGCOAd0QCOjl0PLWDjyhfTg7XEqH8GuifIPXgQbYGUDWFzX+?=
 =?us-ascii?Q?wpu9hBg/V/RKjm7ljzjfYWwaCw/tk0lOh/Y08/ZfJayzxgkZX3dOCgQF0I/S?=
 =?us-ascii?Q?Id6Iw56Xuyen+Fjg1EYqV6tCySM8skhYiztdeJQSEvZ7+eDetGCFA6ntSGn0?=
 =?us-ascii?Q?ExdCAOppvJg8mVjDrCGHAEOorvNsgQH4wNGw1HWkDT1Rp9KHNgJjXqYnTJRb?=
 =?us-ascii?Q?8TunC9Yr/086b9yTvucb/1mq9H0gKqAvG0rpaRJzxW1W8b41MX58r2aK0JSJ?=
 =?us-ascii?Q?waV6L6ymtawX6zif7parlMIvnNVScOs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf698d0-fea8-452b-c5c0-08da1ef72044
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:46:37.4729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXPMWILpSQK3Y6x/6ieNSNq5hHI5rMMr8RzKCqbMQitC8I1BM+XFpx192e7hMVnuCcsnqgbFLjPN6hm1pz1k3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can get a hold of the "ds" pointer directly from "dp", no need for
the dsa_slave_priv.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3ff8647be619..bf93d6b38668 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1806,9 +1806,8 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_slave_priv *p = netdev_priv(dev);
 	struct dsa_port *cpu_dp = dp->cpu_dp;
-	struct dsa_switch *ds = p->dp->ds;
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_port *other_dp;
 	int largest_mtu = 0;
 	int new_master_mtu;
-- 
2.25.1

