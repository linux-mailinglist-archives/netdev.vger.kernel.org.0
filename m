Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EC76E9F7A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjDTW43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjDTW4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:21 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4446440F0;
        Thu, 20 Apr 2023 15:56:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7ySHTpz8gE3s7DkcG+zNlx+6KlXEkXhX3IQZ+Vz1ncciKB7R/A5p7aM6Zj3ZQmepMnQgVKq8G53fTlABCBXasAcQ59lHBHOwMOyzInrmPp/Xx4bnPMf1Hu+y1oI+Fa2lNkmD78/kcxi/MpqTCqQqYDEtqRSPmss8M/kO8wSaEp0IQ1dSssuL2YdUHgZ4QjAybMPl/ApCQyf6qfS8qIocLvotQ0DkrNJUTaZPRzHLA9IgXTmu1rkaL8gR8IpqgwSMvGJK10vIs1WDXCwTyUrKqNotW82L7rHo3pELrwjp80nxQ94QREwWsYwyOlw8vWLGzJ7biA17QUDBp5y1JXl7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTQeTJCWZwm7sfAUThcnyzZsB0nTfOHGcdL/9FT2qZA=;
 b=Nk+Fq+4e9MdOjIzHMlw2DekGy8SDnOecv0XN+PY7P52+Ku0wmMxx1iAy3YgR/ZpjthKlKZwI1I0KSir16mll54csUX9+BPl5ZeCL1OI8eg1/ILYmvq7YCD9gd6rs0LUv1w4PH0t+1aBf2n07V2Pj/ZVpJYDmvhKOVPWm4UdS+boW/5xzQou5jxknowg4WXRxS0FbKJZ3d7hgPYG1LkwlVJl2aGdxAkJwAG8JGH3+qM+n0aoqgnqeMUnsjpdwbkbmg4DrIVmr4C/uaZFFZltfoFbXzxQ28fIFMY9wnkCFVkG4LwxDN2EjyLo32lbtw+e9iiPyTgrn6tUEhdmOEwL21g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTQeTJCWZwm7sfAUThcnyzZsB0nTfOHGcdL/9FT2qZA=;
 b=DG3idIabPdNXlRJ7hCl0c02LXbnodlY4xJLSMC2XT5fxqu2JWFsX4PPXqA7Z/BwJeAjsHp9Q7FdqTqlseeSv3ID+HsYI3okQXlJkcjyRLxS62s60aWLV/4N6q6+vI3TuZXaCprqXAkkFjhqU/uxJbe4wqOCxlgY3oPZVTtXPHAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:15 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next 4/9] net: dsa: tag_ocelot: do not rely on skb_mac_header() for VLAN xmit
Date:   Fri, 21 Apr 2023 01:55:56 +0300
Message-Id: <20230420225601.2358327-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c4d2a47-582d-42f7-92af-08db41f271d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8C0tjBIXb8Mq4C6GFFV336dpjQhj+2WXd1LHZ5HSou27TUrpt7/jvXLrjUj6nzJHNTEhblU3MI4xKH3B/f76PEPu+Rad8X9H6gdNsZ7+QWfCmeDxV/z4DD6e+8RcwnslrXoeFZMLVzvmN6rJFzn1wnUvDWMkDKL+aIapoyRD+s3yY97YAj0hGms/+s/XfOteNaRAnNpjyq7RdObZy1SLgr35CdD+WEWUEwM+vwgApjnWKqCsCtJFCPM9Fi4w0BtpPkn1inRMNOzaJY23ICum1et9D5bROBa05F5ZVR8HVYSZBi0eomGbhjcFzdBG263NZ/UcJNC8I//pvrmjKf4YYlvjTbefUXuQtBrBvsu6NNLd5xiSTLgndLwnX/umYrTfvA0BRDJUOsrtFTZk/80c6Zl0jDJExYfgmq2bWAcPrNqGwu0vN2tKsvg9I2vAQxcX6q/j9cabl7gl+urrokK5VEYzeYxfnkdeZGaJdL6bOF6TIsuOMGgHJ4kHl7FLhQzU2i0bj4A+w0MNKLb1ieMqhvk/lgm+kKTLtRuIDIurhbki9YQ3fsEIyrmqd6rH+v+vTDnBEeu2cfMKzBJ8Sj6xoqwMTyP33jSH7yy7ia/2z/8ZHuR5/HNm/AFJvQ6JVmjN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(38350700002)(38100700002)(86362001)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MCOgUaLr8EGGY6dxmZhdq8WN7O8t3n9ZWafJm0iqgISDiODWfZRlb+2pRCaj?=
 =?us-ascii?Q?Dk3dYJFDJhTSf11gXr7d+PmLI180LRCOrRatzyoHs3lGJwITLdWOHbpkkN7B?=
 =?us-ascii?Q?6uJN6J80SgZZ05saB/kn/uNkzsj16P3trb6duJhXetlerj4fjBXVtiQ7QWuY?=
 =?us-ascii?Q?aI4pti9YnU1gSYv5I2pa7KMS/6t4ikmngit//S2iCPnUtvzDXqdVZkfPIMXR?=
 =?us-ascii?Q?Kp68Ml1oqjX0sLoYOqVwX0TsSTEvnMtvNDnzWnPu+RopwOb3yV1RzjTToghr?=
 =?us-ascii?Q?DnLsV9JVDsfgFtj2C2bIjN9k3Q+y9c1tG2W44XmNZ1Yk3HJ/Ik2ns5T34XKO?=
 =?us-ascii?Q?V9R46Y6fXSUsNqPX58Z/TmYTy6VLHwIPWEeY6xCaCqttXd/ZeCqArBBoUWfs?=
 =?us-ascii?Q?WQc8wIY70gT1pdzFkOWA7Bm9yV62DgetcRs/MzaaFnUt4nOiT5k8HAohbkVm?=
 =?us-ascii?Q?HpP4l4i6S6thrCsQlhNpEjAOGRghxGK3FPZn2NTaxSrY4yXB9YdSOFYJ37Nn?=
 =?us-ascii?Q?64q7iu76OthkMyMfBqmFgFormgx/QIlMJc8upvzuKUUmVZKCrUTOX9ZJJuxg?=
 =?us-ascii?Q?jxVSSodG/OKcwaKIjz+zKfA3C2n4TWtwLYR7vAdr9ZXG4zn9JUb+EYMtQ2Vf?=
 =?us-ascii?Q?woklbR54EOIwkd/3paZjVsJ6qt16vSHlN10j3Zqqx3GZl+A26NulvYm3Mm28?=
 =?us-ascii?Q?pRp8byix+Jc0v7tBz0w9+WTH58W6cil+kl8YrGogcevGe++Ib1Kj4wOXwDtE?=
 =?us-ascii?Q?q0jSP51P7HC4wh8qwcveRJ0W9+UkzZQvESjdehToHF0LFXPpxwnceRe0uQ92?=
 =?us-ascii?Q?Bico9S+VwjgiAbfjCQrBVAYtmaHDASkOd+c3eLgafcrK/qFbEMASQnTJXTuj?=
 =?us-ascii?Q?i41tOluclzFpipyhS5m3DDhwhrZdph4CcTgf2aHolZf0guAt7iG133odehsk?=
 =?us-ascii?Q?EMrz/F14RjTl64hkE5Oy8LLi0HEPOuBGJobgqUyCw8Oo6LivvUsaHw5K6DfH?=
 =?us-ascii?Q?sRlo+6FiY5enBRlVqJitmg4oFiQEyzU9xFaohZWncxmrQKaWlJen05Kl8RNw?=
 =?us-ascii?Q?gYVQHJDVnAqtUlfrsdj/B8xAq9QFfEiggUA6UIyPc/bfr/aey/PP8wu8tmzX?=
 =?us-ascii?Q?tndYcqZdi3lfiXB3GChAHFzLil+VB6ocZ4h3DUAs7Um6iemXBfCNLSyhShGG?=
 =?us-ascii?Q?tSxf8e5CjMBG2ZCThE3ryy2Xg2VxgsIgXWj3oHU9+O/AAY4ipu+yg1ne7hz9?=
 =?us-ascii?Q?KwNEEoVdsllZc1iErcpwQHSL1tEVFh4R4OGfkotGIDT6ToOsIJy7JrxxYwTb?=
 =?us-ascii?Q?is1EJhMprCCA5tRihSb0swpccLi0hk/aBDtBHj4KggYWMrHmAdNZmkZamdgd?=
 =?us-ascii?Q?Oqd+alH1+jxacjk1EVhUCxzz9blitappwDatyebP8z/O8mTh629DVKikFw8G?=
 =?us-ascii?Q?8UXe2/k0Q2tDa0d7h37gScWt++l9Bx/x6FdYo6ArC+hZ2cMdIf6o5UQmIjed?=
 =?us-ascii?Q?xBSlqw11u5EWqA807poVupbobHeZSjz6SGeTiBngkdhc1rj32wi/Qja5H9z2?=
 =?us-ascii?Q?I9HhnJqw7g3vFCA8Z5t0IUriOWt0yqgVXCSH2s2SRhKHm20x0o+dtH+Ldplp?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4d2a47-582d-42f7-92af-08db41f271d6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:15.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubkHe86JsH+M8q4cJm2uNutpi5O1zbaSDRpLLrZZz9he2JZOWaa0UyvkNoNIsV38IeMN7LaVETGPBaIyoZiCPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_mac_header() will no longer be available in the TX path when
reverting commit 6d1ccff62780 ("net: reset mac header in
dev_start_xmit()"). As preparation for that, let's use
skb_vlan_eth_hdr() to get to the VLAN header instead, which assumes it's
located at skb->data (assumption which holds true here).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 28ebecafdd24..73ee09de1a3a 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -26,7 +26,7 @@ static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
 		return;
 	}
 
-	hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	hdr = skb_vlan_eth_hdr(skb);
 	br_vlan_get_proto(br, &proto);
 
 	if (ntohs(hdr->h_vlan_proto) == proto) {
-- 
2.34.1

