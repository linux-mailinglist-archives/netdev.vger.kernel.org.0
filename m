Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F566D429C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjDCKxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjDCKx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:27 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1FC1027F
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIoZ1G74CUCU7Z6vNZ1GK2mM9OQZ0s+EQ3R/zxy7Xltf4V8NL8IIS5/z2G98F9GIKZ9gim7rdakYSu8donprdhO6GF/sXE92lP+7M+VgkkWHFxGLf8XmV0eNI0iAStCov2Enc385szkvXC9s39SJadj99GvBdjnClkZsE2PFppvef34HxiFLpJ4tx7jo6eLOjRRzW5e9QwvAPUj41cieY/kAn6W2RvqUiwkXDaPDlvFy7GYVyIZQIXs86YpVfTagfpMfxeMWSlefcuGqqONAjuvxjHPOplGx4cKyr1e4du9Vwqm9xlS063oOIvZws3Z6ZysiMx9mHALNPfnq0cWF6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19SkOQoO0PTZMiZ+iswIRgcZZLkXOz0KPwkBPcg5r+8=;
 b=LkVhpYFh9dCSwuf475Fz+H6w5vD2ZUDfswcQbo72X7+rXQDJj4WqxgRlsDYlvRr+HOIJ0bcKZ4bMm3WBzcIxD0ohb9FZWS36xHV9973z0JmNrVN6hsd5VhWAwD62gzULFl3sYEBcowwgBXbLd9k9IiBrwNOCOL8vhwuBaR0cELc7yQDnLhAAlDD/KNuLGkc9zLnWo8LGYpNhpchVCufV6G21AsZIDqSQxuG8HQKfSm+6CBLcQlPni4vKh3RMcmC38Bc3Xk/O6in71AN1g2mtnv1iKum+l/TehuGmYQ8X3vaR/1cu7uuYpXXXAdb6fk+uj2PkW9tMDQLfb5oFA8DEjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19SkOQoO0PTZMiZ+iswIRgcZZLkXOz0KPwkBPcg5r+8=;
 b=DNZ4NAQVwNomZnCN++HuLLPyJajOIZSlG3+W/QlVeYlxecOxbBFOknt8hWetecF9WXQxi3DlFGy/iQcmdglRiv5csBXFxwtbrdI+1Wg5rR42EouXK7XrwAksXLdYx+Y5pXwTjyv/YhCE9jkHDIGP8Aid64Zn8LbXi0fIIDQUz60=
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
 10:53:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 6/9] tc/mqprio: use words in man page to express min_rate/max_rate dependency on bw_rlimit
Date:   Mon,  3 Apr 2023 13:52:42 +0300
Message-Id: <20230403105245.2902376-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6fb38b02-f0d4-41bc-0188-08db34319b09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3W5gallDEgk4WmB+iwCvobD9Ne9ZF0CZYMuOpIxneE4t1/0KktcVR+f+neE8jSPFFsLM6V2xS3w6ul/MwTmeuIyZfXn1Sb0vwy6lEeBMUkROR8mb0yOFJUBc43lgbURp1vco/l6h7tIAAiohTpBUZMx2yVzew6mjSoMT1qmwSKTVk6V0Y3/alpAoXCSBAfDWvHO/VzfERl1iTTkbvuAnyz+t0G+ml1jAwLT29UDhTtbejeidP6kaYNiTWmcCSSa76Og9lRdcPDOrvNIlf8ySfNInW3NZoL079KqZz81ZFo9vOBrtH+n9XWKpxig3lUkbw4MsoGGJlboM4ZoXlPBB3mVsvcshIZFg+XzCVnzBmMt4BXCN32BF0Vg++P+wJ0925Nn1dppXjmN70O2116POjGL5gBsysoaOBzOge15FyAr8nHVRkuGMk2y/iJHlk1ugR5EdlsDtA2Um+7pD15Mobw8EMZq7uCd9WT4XKUJXy9O4dxG+Md+EtVFBO1gXeQGwE44NSw3PPiJ3nZ5fp4E0mW/41y/MhZvdUN/vf8vyKGi+oZ5cuuhyCJFVvEPn0GYIPp2kP2Cu4yqIb8hvkkLTytN5Ex770l2fUp6iVQgU3WZXNAKrnWtzCnm8kZ4HtZJX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LkIlyjK5gZJilFYvWS05TNX4kh3OHEC9NA2/V1098z0lbSeKvc1fGH5oQiQo?=
 =?us-ascii?Q?7W1gILLSJMfRyRzkTgQ/c0ZNjGYFDvT43DxpMZHz818o71aPDENhEq6Ag+V3?=
 =?us-ascii?Q?72TBSU39HGNRiQwqknNTT73cE+ljcjWyHT13EM3KGdFmd+4PdpPVpystKe9X?=
 =?us-ascii?Q?I8WZqgEc15qz5co3Z0qoEyT5mliAjpL2G+F6ZBV4LLMLtb4+l0lT4BNSF1bP?=
 =?us-ascii?Q?PMW+rZRy33JWd3XgdVlQ8SMSmhsxeFANBPMH/EuVLziEX/9iU539L8HCLMbl?=
 =?us-ascii?Q?WGphpS5Rxk4bkzArscvXJMVK5hpgK0cE38Ke3jWGrfZ0wal4zvgI/h0BQpxa?=
 =?us-ascii?Q?5hDQcwiXy7YrMCiOk/fkatu6Vu1a2WJZP7psfLk+3S2Bvs3vUOUuFrT4UfXZ?=
 =?us-ascii?Q?IFxCR+IqNcHadX8JYGTKwkAGeZ1EPBKNVjUvGHCC04IVyMeVJluq62lqe1h9?=
 =?us-ascii?Q?s8FTKkcQI6Oc2aUHBzULNyk6nguEwPGYfOolNgEmhfOzKFJZSOghCQIVYxxf?=
 =?us-ascii?Q?srY44us9maqU2PNcCFYC+fS3OWcB6dSmra+V9I0Eh9umNq/jxcfx4Bt2xNFz?=
 =?us-ascii?Q?b3hbiToZqvyOvHGPB3bHJnxnCuSkrbhQ0blG/z1aA+k+ox4UTfaYL1lEuajH?=
 =?us-ascii?Q?2nm+kSQsz7GhqcQaEOFeaWovF87BJ/4Z+k1qYOtSDCOFpvpGJo0018VTmFqk?=
 =?us-ascii?Q?Y8AvMopd03csGGqR7Jaq/ltCCowiXtLvcOvFSuiS0rTPbUMgmkPMTmexS3AZ?=
 =?us-ascii?Q?/BPUJV7qDtssFBdXVHr1zHarxPv5WcOkUkkurqQVS80mIMoHlzmVuayI1Hik?=
 =?us-ascii?Q?cboIzMY1LMGjbx2+Ig6kwPNwqe6LE/EJ2OiNcg4FXonU5LgoazWCQwKm7EF2?=
 =?us-ascii?Q?uM3sjNzVHrz4xW/572tsyQwiLmjySw/30nIs7bYBNYVs2bX5D4m2zGsUWebj?=
 =?us-ascii?Q?1UIgbuYoaPPWmvbJVxoVQPacMdrBTfzaScgAPGy5ogI2KF3qER7/vvfDhX1x?=
 =?us-ascii?Q?sWqfWr4Uvkjo93X1zmT9kPTWWqObtSoq4zw932PbwqkQ2eiVCFMvU8NjiHCM?=
 =?us-ascii?Q?1nyHQ0NAmQuytPag3UrNZ6Ys4sdqYZWWAoLeN7R4Fzlr5n0rsDtmHlYllXhM?=
 =?us-ascii?Q?YrK3YbxJSUK4lhSra7Y2wZhrUSeXVUmlD4teWFgCT/zY8m+YH9gNLzwLSFWO?=
 =?us-ascii?Q?s1voXfxpdNEtRsr7jhO+l9om2KKFegkItDbJOkuqICyOw1IcoJEOc9PWeKX+?=
 =?us-ascii?Q?X+jeFEROuNMqHW6/PQyh6inka3bCTeKYHERoquqPrq6RmyFNm5CmApZuBzlG?=
 =?us-ascii?Q?9SLrfNvsX9Dn7uWwpOb3wuraL1PtynHWo1tuxbgwJBJY3o8/lrxxmAprvD7q?=
 =?us-ascii?Q?QzeNZtswOSUsoSASJuVDtBTfgdRx01tcICn5MGSQnexrXPt0P8m3RwASjgcC?=
 =?us-ascii?Q?6YxhcMveSIB3AYQrdzySyq7OrLZ0B+cor+wVrHhPuBD3xKFhKA2o+x6uI4dv?=
 =?us-ascii?Q?ueUL3RgDP6hbKoc/Urb/oAZ+1s+7lYVwzH4s1bZqq9XttxWzKv9RK/Su7BiV?=
 =?us-ascii?Q?rCdLWnCdOJwGkIFa+yM9l6HKRkkFw3IDm8V9Zp67teoGns7qmkQ4/JDpSWIF?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fb38b02-f0d4-41bc-0188-08db34319b09
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:06.3890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdXbzFoRpEjDS/31T06/E/0OemOHkscK9RFDZp4jKGsHBls9jjUns/LS4eHUYPSv0zlBdhFoP4XbxFtME8fMEQ==
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

It is confusing and easy to get lost in the soup of brackets when trying
to explain that min_rate and max_rate are only accepted as optional
arguments when "shaper" takes the value "bw_rlimit".

Before (synopsis):

[ shaper dcb| [ bw_rlimit min_rate min_rate1 min_rate2 ...  max_rate max_rate1 max_rate2 ...  ]]

After (synopsis):

[ shaper dcb|bw_rlimit ] [ min_rate min_rate1 min_rate2 ... ] [ max_rate max_rate1 max_rate2 ...  ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/tc-mqprio.8 | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
index 51c5644c36bd..e17c50621af0 100644
--- a/man/man8/tc-mqprio.8
+++ b/man/man8/tc-mqprio.8
@@ -19,13 +19,12 @@ count1@offset1 count2@offset2 ...
 .B ] [ mode
 dcb|channel
 .B ] [ shaper
-dcb|
-.B [ bw_rlimit
+dcb|bw_rlimit ] [
 .B min_rate
-min_rate1 min_rate2 ...
+min_rate1 min_rate2 ... ] [
 .B max_rate
 max_rate1 max_rate2 ...
-.B ]]
+.B ]
 
 
 .SH DESCRIPTION
@@ -142,11 +141,19 @@ for hardware QOS defaults. Supported with 'hw' set to 1 only.
 
 .TP
 min_rate
-Minimum value of bandwidth rate limit for a traffic class.
+Minimum value of bandwidth rate limit for a traffic class. Supported only when
+the
+.B 'shaper'
+argument is set to
+.B 'bw_rlimit'.
 
 .TP
 max_rate
-Maximum value of bandwidth rate limit for a traffic class.
+Maximum value of bandwidth rate limit for a traffic class. Supported only when
+the
+.B 'shaper'
+argument is set to
+.B 'bw_rlimit'.
 
 
 .SH EXAMPLE
-- 
2.34.1

