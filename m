Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14075770E7
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiGPSyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbiGPSyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:07 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458811D30F
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzHMFd0YiPRd+4GVXOfodYbOIm0L6+YOAOGvcEsc1CM9t0n1uHWbl0d69swR4t8mrCZAuypLqIy+SPKQC/QnhmhwiBJ3ZmRwXpqytyaLXF3peODZ419qlSavQbvd/WwuKb25ryiDrQGF0YcG9zCeM3H/38wM0213q+NY2MbTiOYM2O4gS0iV/ap2BAqXFJgtw0PS9BbY6htLSZMxisk7kdI9Dugt/HtOOezi78CJusXP4DIQsNHL3b4QO3hUKds/YxoIUs1S+j1C8JDy+TKpg54dfO1v6zkWbhBVo1DWVP/0SUn8yhV9sXlb9IjDgBLzEgoxEWYLf9oaEhcXQdXlmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgUbNtGnWMz4Bzz75YbBmWK0D87onsws0HE+U6S3Qpw=;
 b=Akx+htjio8Va8af7QdCJqQfU0WoNxHwfr0SDFZZVKcHUnRZRjaxMypPMHNzrcpy55YjxbEJiNypd7NfVQ2rz0qLg/Dol6n1blDjzpAIUlg8ljebop1pPeMkgJdYK+cdTh3s0rGFN1nFNQVQKcquqa7EyCWDqxPVND47eV5id9QsMdIoaleAzB8ns4Xzxbv0NMm2QEuiCNAENDpB4kb/6sQcDzTgOfJGLx0eqEivmYgNelHWI1F9JAz0VCqqZl6lc2WYSrSz0/STFRUSPaqfsR1azwx3xC1dWiCYi0wpe/nH8kJ89iuZMiss+NbmwOEoEvmBNxxs0+E8qQBvqW1aMVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgUbNtGnWMz4Bzz75YbBmWK0D87onsws0HE+U6S3Qpw=;
 b=c3tupOcrDqcO3FdymI6TqrPCpnpi0+rQLD4Mb1uL5oQYSzpi3EUPR62A23X7nAaSLb865hKXu0PHmieGUO2aoDNHDUK8tObFYOpXKPF8iEvO5YlVLbvQZqrPC1L9ds7gZWpdazxKPGm1W/nlBV7kJvvtd7v+iQ65algwO1/BzDE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5261.eurprd04.prod.outlook.com (2603:10a6:803:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:01 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 03/15] docs: net: dsa: rename tag_protocol to get_tag_protocol
Date:   Sat, 16 Jul 2022 21:53:32 +0300
Message-Id: <20220716185344.1212091-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5b3648d-beed-492e-300e-08da675c8b09
X-MS-TrafficTypeDiagnostic: VI1PR04MB5261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CXhRsH8yNSBs/v+fFOLJR68+0xqf++osGp+u8CU+iJIPsTepYDO2OeF6eAkcq1mmCIihyG15u1pYjbpCAE0HDYEkdbf1ovHgNuDCxJ8bV0sstN8xi0G5fxpmZ9HVKHSvct1B6OUY/FKDMZB8fQoHNJPYc02g0WOhiauu7QFEwIhGx+R7rpmVSjgw57vKK+S2WYPPvgigH7hTJc39xh02Gnjf0LCzzwGeQMnzlmChlZmr+dhFREWcWizsTyeKzC+Ym5q1X4LiAUhpZFKvm0i1VLFdo9ZgSgE1NscHdhLSJyMyeMG//Y/wTZ0u2DvPw1n0wa2Wah5HmywxAvrxBO+vLoSRrwDv64j1pCbvKL3QA1ySbk6s4uqqNLeIgR9wg2Iyz/o03GIhY9PFhY1T2lM/QcYJAiwvk/1/6kq7yd0OyNaQBQDzqIyCMgz/HeNkUl7617am/8ama05g+5CU5zDCSJQr38yV2Yw09PacHhUQvtubX3DhJ1ufjS2pZypxAnwJAOFqt/QfexqwbWBHC01EblIpi0ZOCJWChDWfN/3SqKZ37dhJsxGEOPinxSsEXA63YUCtFL6iOUkYRaXW/zAo6bpd+Nrkf/L/PRWTgx9ho4OHR4Mw9EvN9IoNWsSURhboUBub3yJmNosDj59QeuW7gWDwb93ED4hBRqqhJ4SAbim7db9nBMoawKGRIMSPrsZvY0ZTvm7tSPuUduNEn7fr4xhsRuER+l3rL4hPVvgMHyTST9s5XsrKq5ZcxX04CEvqt6am9mjqtnQGLR3paXpevnBLyEdxRyBCcE1AZr2yuP52nvb/zftJyRoadWGLxF7H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(83380400001)(2616005)(6506007)(52116002)(6512007)(26005)(86362001)(1076003)(38350700002)(38100700002)(186003)(44832011)(2906002)(8936002)(36756003)(5660300002)(6666004)(6916009)(54906003)(4326008)(8676002)(41300700001)(6486002)(478600001)(66476007)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JPvjYpW3Ioo8zW0ZDllnzuRu0TVVLYSzhkJENSUBqmNdXzBrvMs+zr/9dMjh?=
 =?us-ascii?Q?AAxa/sT39wABij8MJANznGTzj9q3O4BgccBD/ajpSWct4v64ZNTZpKVBSNlH?=
 =?us-ascii?Q?oSsVPLobqRvb5S+aBu9/hYWmmO4IKa7LDPtbOD+FTVlR2Ouv2U3RqSdk+yPP?=
 =?us-ascii?Q?5Gv3Fx376kdyQ08AxZvPeYeLl/fdNablWR/oxuVqedmv/BnxvXT3hspzMSzb?=
 =?us-ascii?Q?x2l3Uom30UD94BsSQOxaLErNfuz1KrXJ8o88vmrdng3C/JDzoKWE4ekbnGaH?=
 =?us-ascii?Q?LzkrM39+jekznRtxENQnxeioFzgGG/dFziN2mzFHKcpB2uoRysq6nMUhepp6?=
 =?us-ascii?Q?uehgusKRuh89NLF2axOp4wvky1EnE4z7Ue1RrYmbJO/fMkLsGACRvYzDb9hV?=
 =?us-ascii?Q?e8TbEsjKv6wNx+NHjipW+e1my3LV1TBwlhlr1/ttoOK6zBIdFSW+ZA/x6FhN?=
 =?us-ascii?Q?unsSC6FdnBa/cICmfixDjhAXcQq3iQGaTmGSG7Ph6sD4ILu5rnBiUf8MUgp8?=
 =?us-ascii?Q?bsjg/EtU3ixXZN0YD+/Y9nl2awrbcO2G0hpL0i467eNLlsIeYO6+JPdHkZvh?=
 =?us-ascii?Q?P/MLiyVYkLn393fqfWnb9DjTuFtF4IMR8rvcfBAFOIT5KPPuxXvE02rzIm/K?=
 =?us-ascii?Q?NrWKT0r6odsfa532ek3+5gF3TJmi/Dc5QZIAYH5ou6dD622LXxfBIIjZo7Nh?=
 =?us-ascii?Q?dqqxZIjQnHfrBleOzUJlNR8sbvbtnW8wXWNubQ9f2Dzm9x7zcq2pT8kH17S2?=
 =?us-ascii?Q?nvALdAFU63alLxPer+/p/W1OvKEzb2/ey+jHeqqzrAohhSxC+RFkQisVhs/5?=
 =?us-ascii?Q?vcn9IBEEFFCX78WhnbX5sa2TztavqNH7Eo/iL/euLQAQBf/PpGVu6PUsU40M?=
 =?us-ascii?Q?3aCdeERLFvUlIe15iemeqqO5JiQlGN4jK1OJLlVkKPSYT95LDNWY1Krwp/Lc?=
 =?us-ascii?Q?lHfyWZI0lsdpuV+kdIqKHK53sVgTXUKa4tQC8GTW7cVNHvtYB1FPZphKs04O?=
 =?us-ascii?Q?sv2jtd3EfBrgFYGBFnpWabJTX3NkNAYhGjYRjhsosNPwN3fXsM2cXTnSHmM4?=
 =?us-ascii?Q?JtBHGTzJVICiJUGpnqftSMiLbJPr+0ASQ7tuUPt20SV0VpLrmO2n+EIZ+UYU?=
 =?us-ascii?Q?Ic9FA89Vfnzk9N8bwYuoVqrBTANfZGR9brk2G/2NzyybsAiI6YcpzexeKNTT?=
 =?us-ascii?Q?C+zfxKvO5ev5QnvpkfTzMjY8N2JhoRnY/e6L3nxDeZoKNL8mpLmR8RqKzd9D?=
 =?us-ascii?Q?6uCSrOaYYrQ/y4iOx9laiXWJ2YOZyK9o/mWwNrgcAUJ2FkGPhUmDMhvmoIpS?=
 =?us-ascii?Q?Fl++LIhnxax9TbdEEW/qUIRZ9XvO62m7yBK+QP0X9gZeDyhas4zlPStO5QDJ?=
 =?us-ascii?Q?4N2WbXTCeQ+gtJxrQ5oX2Zs8Aw4JgvyEnVQzBlwD5yZF+BHwoRmeq6ekR0Fo?=
 =?us-ascii?Q?pgNrDJq0d2AqwkHiBsvC+DPf0Qno3wO3T4GeatJgC530JYE6C2KyLbjhb9hk?=
 =?us-ascii?Q?cfvNV4FQYmbm1MWXp0J5gzNR3OdTa5qsYiFGXhfYIozPmrzxs418LI14G819?=
 =?us-ascii?Q?m850jcJYMC3zDfMhRIUSu/43OZV2oG7LnZJa+BZc8/drfbfYZY7aQn8CiKIE?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b3648d-beed-492e-300e-08da675c8b09
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:53:59.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RB1E9yQa5MrBe1tYlTdkzvCMz9/u7VjxUJE62GXPoku4iX2oFtgVaBLLASK4/92m0psJKym+dRG8laqWoNYUZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed commit, the enum was turned into a function pointer and
also renamed. Update the documentation.

Fixes: 7b314362a234 ("net: dsa: Allow the DSA driver to indicate the tag protocol")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index c04cb4c95b64..f49996e97363 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -593,8 +593,8 @@ driver may free the data structures associated with the ``dsa_switch``.
 Switch configuration
 --------------------
 
-- ``tag_protocol``: this is to indicate what kind of tagging protocol is supported,
-  should be a valid value from the ``dsa_tag_protocol`` enum
+- ``get_tag_protocol``: this is to indicate what kind of tagging protocol is
+  supported, should be a valid value from the ``dsa_tag_protocol`` enum
 
 - ``setup``: setup function for the switch, this function is responsible for setting
   up the ``dsa_switch_ops`` private structure with all it needs: register maps,
-- 
2.34.1

