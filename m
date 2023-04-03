Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBD46D429B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjDCKxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjDCKx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:27 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406087692
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RUnZJQHrSZN4vFSXnTmMy9I5aokqVe8aG0B05ysG5aaojoi2xz8I+ciq5O1lJF2l+xtap9rk9KSUN1lYibCUWnnWd7CQ3kHV6qB/rGsC8Eoss5Vg16onjAbrQyfPvHy5tjw4UAsLBVFfrL2vdyktnvULJvBYQAdsZI/AG6yfNkbRPBUs5UCHnG4zjvGjqs5YzCRrY5jyOYsg+brFuuyftFV0M7huAT7nudQVDnp2RyweRB3yuCVT6FsQR3ZuQdXe49LF1dguEX+/noylP6HN88Cuee+vPBIKPGMdhRYlC+0bMJNEELVHH2hsUTqUWxShcT6FxhSPY1diMVAzxxdkGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKe2rYfh6qjy9wbM9ZtqMwg4yJB8ASwhehD938LJ8j8=;
 b=IRa7puric+QMJEXY7mqyULVsvQ9eh39+aY2QkLKf9qGzB6ev12oxe/9tw3TyTi60LltJjZS7qmfNKW2gCRHHrWaOR+/VMoPEXAvSyquoomPYKVxhN0+Qi74IqHzjgHGYMe/+EoVPsONFQmYKMI+P6KRUKPlwWBLrhueEBYGoyQw/ZAsL8QWyUf+SbiIEHVKIof7pk2iNvwrFZDLCAe6cW9Qe07ioaRaKr2UzY9wKoVh88ubsnDjrJKBJQtBlXKzBBgprc++llKzePLPzK+peIdl3lQ/piB2cOVctKVy/ls98F94HzuTO/gsNmGj3ulhflQcyKWNqLhP4L2rj302wMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKe2rYfh6qjy9wbM9ZtqMwg4yJB8ASwhehD938LJ8j8=;
 b=BwOWLsMg8P0Nt6P04MeIm7ViUYQaR8Uo9Uwz70ftY/TAcmx5GRsafGPY2siwvhEFYQJTRNDA0Nf+ifoWyd5W1H3pKzg4DZshF3vsZ1dEfx6HWBsqlgsO2/VIXfQ24LKmvDQMkj5KvHVDHhn+0Yz5W3AmXTEt8mmNE6d7aFfOV68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:06 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 5/9] tc/mqprio: fix stray ] in man page synopsis
Date:   Mon,  3 Apr 2023 13:52:41 +0300
Message-Id: <20230403105245.2902376-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 45073d10-e708-44bc-cbaa-08db34319ab0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJ+t9QEdwYiXBCI+SKG73wdrF/kyXq25qyskZlBYfIQgLINj69xx8xAieoIpENz21bzSz6h/bsH4Xpo++UjUL+V/g8KRY3FIHbGt5rtzm35WIO14OAl7oQgeA37cwWIhtBJrySuV40Loe/DVNJSCNcpoTCzCPX7kVdz47WLp7E9jfCp5D25Z3y5LXYluuvWjXbo2/sksdqRGHWNFW22W3jzjq6GNAwB87CJDuoMxO0i3JsKKY8JM+bTruBdp0cWeEZhxh6WcfqsCPwlqiyaj82tWPdfhYlLmQnu1chqwmS2Xz2XFMzb0XkjZUeoY83bzBF945Wjl0TyyGK/btWpqjD82WsLIDHSZNIYeyrApT+0noj4HxCzD6L0G8DDkBhHqAA6tpg/4m0yL2IyD0/H0g7ro8hfT301eaNS+al82xZEa1j9aZjQuW0jrlRA9MGoFwqLzE14Z5H/gtGBT2xn5fP3OzzoDglneXKgkejYN/ub/iuLxTL5Z0uh2H74xrDLE4AfosnDoGUvuuQc8O3R3Gg20XKgPNf+ltlcpy/WV94s3GeseqjwPCTBsV++089wXZp9K1rYACqS7tbkAaf3Og+PkTNn7rxeaHZG30KrINhstwZlwfzc36L+m/vU2qjTB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(4744005)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b0qNDRzJdXHsR13O0dtDva33+rzkn3oIPmXhFoaKHjPMIAo/eEOhFGgh6X+v?=
 =?us-ascii?Q?kMY/T9abqAjFikc0Rqa9LZGpy3K+Mt9YegVUru6v7SX89BDIBGIYDoik3s+y?=
 =?us-ascii?Q?w+AE2JYpQRCuKJmu2RZ86Qzqy9QezNmKf5ugS5MAgez2qfYXB095AlQerf+d?=
 =?us-ascii?Q?MMHJnJ4gNrqCuwNT4cHw8cwYqHxxAP8sSctqElaGRpBwAFPmL+X/G8so0+Ng?=
 =?us-ascii?Q?m4aMgNzrgOdMbFIv1QXoce3SrBVJIvyoUM0QJZdI+vjgLZUG5TFBaYk3PfZj?=
 =?us-ascii?Q?XLeX7GoyhsGu+rrn1P+FfeeNxyuXLOrj2vuA8OK8tUXGd4yqqUqNjNHypIVr?=
 =?us-ascii?Q?eDjCTZzpcoBZBbpkAT7Aasw+PCgoX41NmmvuumiB5vGot1d+SnG4DrlP930W?=
 =?us-ascii?Q?Lhc3x3BvcUzRfeEr+b59+A2w7BIDdBvNmKBzEhIkFcoiyCPu02O1ZSM8is7l?=
 =?us-ascii?Q?e4PDD5bgFlH+xOwEihfMucvQekWLhtDLT7nzBzgwGtIUawn7X23EzPtPek2G?=
 =?us-ascii?Q?31n61AVLT7DhhhbRIIzkV06wnrXtpy02HKy0Ar8Ub2SZy7/usnnLXBa3McqA?=
 =?us-ascii?Q?hPQi9EUOhPXR+ouBjwl+/T4KTC6dRWdr3mq5edFOLchPCSaS7wEDc1Azt3mQ?=
 =?us-ascii?Q?YYpNhTLI1RCO/QKwF0aqth88Azi985vslRXmMUGuybPRwP9nzu1NT6EgcLj4?=
 =?us-ascii?Q?7EHmPP12+eSuLWwlJ6hbvDa1Zds6+IVocAaSEstqQvjK+kHR1wj3qEjlBgaQ?=
 =?us-ascii?Q?0tYJfdVLYClfExb/s65UMrb65gvx2Ezci2tuUvT1irLq0SxBGxGf1WrSpkDP?=
 =?us-ascii?Q?ji04RlZx+QMK4/nqNJGURNo9M6ETqlJ8cjx9L5fNvjrnmbwsMI9yLaFPl0oR?=
 =?us-ascii?Q?2ISOLXTdd0HrOp6QQXNhv3AoD1XGxw1bgIBFauApJsG7JEHVxQZxTRYzaWhQ?=
 =?us-ascii?Q?AwgTlVUFqDHNSMa81RbtNkBKMUGlxBUp77P+HXwPhaApRwijd/A5zLs/aQ0P?=
 =?us-ascii?Q?XX9WP1l+iAzbqFCsHb2rR3Fmy3WdEPsnkVe6hJeMN3OoIL0GFeUv+5bjyBf6?=
 =?us-ascii?Q?NDVBJNdtRPmPG0Oj0piogoSz1RLtgqwdVuS2nC1PQoXrlfYxysgwul0y47F6?=
 =?us-ascii?Q?tZELmeNLqR4FeA0jduGKHa0Sx7gGtlIwpRJCs7rtcc3MJTpXF2s7vCA8S++o?=
 =?us-ascii?Q?se+4689X0j33XFr1z5ZoVdecJUwZIZFrN+ehhDNHrfgqrkpIXoWb5mP5LC0y?=
 =?us-ascii?Q?9ZPkmxKcT9tYTvUAtL6iOQP7JwJFUBmqlssQaDDiBiUUEsX0AbkZJUT15F6t?=
 =?us-ascii?Q?2IqtycF0wndTlNA+9a4VZj5YNlusHsdnj4tv0NY18RchBK7Y/ll8JG7Ippqh?=
 =?us-ascii?Q?dRR3zVtZmgHP8vbZRdxLe7pMC5BTlc2FwO69zv7snut94CKNmUWDni40P/cX?=
 =?us-ascii?Q?JBy5PERFAOZKu6mZLIEwqy/dYySsWGXnqktX2FPIyLHTULJjztrpEu9sUC/G?=
 =?us-ascii?Q?mE9aBzuMDiVSaufCwXO5AdTjvvTGMvE8+dGMgEi7JcAUqb0c0/waYtQGHo6O?=
 =?us-ascii?Q?P2r1g7NbXe7mlWRbJPasaDeq2uQsTB/mljk7HLjjHIuhvOtOEcGSTpTQLE69?=
 =?us-ascii?Q?tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45073d10-e708-44bc-cbaa-08db34319ab0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:05.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxZ1HbGUDZUf/CUbf9dpE7adxSWFSfzIyLnXYIO6r4Gcx2A3r/xN6XS3+c6H7yMJUappdlKeZkMJeqlMOqlpzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8479
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The closing ] bracket doesn't close anything, it is extraneous.
Remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/tc-mqprio.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
index 16ecb9a1ddea..51c5644c36bd 100644
--- a/man/man8/tc-mqprio.8
+++ b/man/man8/tc-mqprio.8
@@ -17,7 +17,7 @@ count1@offset1 count2@offset2 ...
 .B ] [ hw
 1|0
 .B ] [ mode
-dcb|channel]
+dcb|channel
 .B ] [ shaper
 dcb|
 .B [ bw_rlimit
-- 
2.34.1

