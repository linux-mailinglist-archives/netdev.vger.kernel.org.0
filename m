Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59E6E6014
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjDRLk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjDRLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:16 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE71349DB
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuW6bI2L/pn0pBciNK0DaMa9eYQsHrEtpehQtTFJqVmLIJa3RRGKtswoIlKMBL8JZ6NPKPjBaHYxTVRgg08Q/XXyCGiAaZ5NBcdpXBHIhA1v7TNtMacXj/2khVf8AWw7KwUOElzvfC/84ytm4UOz6B1udY2wX5AlhErDhw3esXpc/3awP3+KLFs623lXXeU+w+O7sZkXfB/bqax4JZp1fJYO5UeOZhzQ3kY/SQbO6QMAf22NYMzCVI1LTUOguMK68I8dmfsd2hme5l48tGFg/NVggZ8xQMqC+OKzdNvGsX4CarPWY8M7PYnK+wEmXfsVC8sbyyIokOS/ZCVxRbvUnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NG0zXJRR+83odw50V+4Lu8M1jFYC5+QdcudyJNcV7o0=;
 b=RQKPC+oSuLrcwRF1jT2qlUa7MJIKRuR3w16xrKCWwGujm/L509pXW44O/uV8lopEbi0oUcbz6NqHCkEp6ibnMawkXf6Uh6vuDpZ1WOKBc0apVSdjaTgYDxlN485L9cC+My7A6Ww0JeGCdZE1nD3R8p9mfkHNpVx2tHRaqkXdlQI8P+VRVB5ArtPuahXFjuDJwNWyLve6DduFf9fR0cNgdxcQnlsd6yWtylUy5ymkC9n9eQ7A20/HTzL2M34i8FikMR5AllN4yVWV9GrZyO4DFp7oHm5Ilhm8zNJKerkPhEn2Z6Znt5JzeHNq6SOQt7TJhhQJYJTtqfiRbwfTEbxBLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG0zXJRR+83odw50V+4Lu8M1jFYC5+QdcudyJNcV7o0=;
 b=oNLR1YTNqaNOdLCEb/fbf/4PQhVr56gh356oH7PECSPorfPzmyye0VuapjPyMx6I1fgr/oB2Nl/D+3QDA4HBT8q66G/oMxeM0SG9P2lLkEI5kMR6FOgLz2pW6yno1Yw/iUSFHV2EbPE+4O3LFwC+Z5/hx4rZx1EAweu0jDWDYpQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8557.eurprd04.prod.outlook.com (2603:10a6:102:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 11:40:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 08/10] utils: add max() definition
Date:   Tue, 18 Apr 2023 14:39:51 +0300
Message-Id: <20230418113953.818831-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 32a7d8ab-3637-4c7a-403d-08db4001aa77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cViTrnTLmhzeUnwUKO1et4Bw15zXLvcID5cyhlSypXkxM36Cd1Pvpf4uSRuYUOWhv3gz1h+g/9cIF66T+8lurz2qFdi60aKAtKq2SVFlv7dvwrVOAYsOEqiHW9ywM8NMlisSzAq7Hkyj21KKc5U5oP9DrjOFz9qwrSjD6en9RJKEOAdpsvriqYba4PHq99rskfssfj/Y+ASSXlfnFzTVpOaR9iBOKjTlag2SNODyQOI2Hkd0k5XKh4tSICXzlUtEzXR4n4CrlFIdiyIG71o2dh43E7zCo5s8aYQ/SO+JTKDSY2jg4eRTRv3gAf+S5Hv76RpcBkrlLUvYrdhe/G90y1ZBxlvXXYJGB+E3rrEA80pRvzusjme2kmoaXExQszqOC67GwnE34PKTIl5oHiOkds7Icu1N1gdQh/Ox3x5zAh3O/3IF+Yfp+XdOt//+kF+ypv3YnSkc3MHgc6fIbQpeELDVIhvh2dgV/TRoY+CX+llI5Q73W5uWIYlQyE6HAhnRWWZarjvz6b1ulLggldzjPj+KBpVJzIlde9IfS061THmJ2ULdH8Fx3ChXJ9ttslKzdyFbmdtc2G/OS+oZBHBtNAap+z1m1XDJC1NwSFYPifHz9VXzDBsHDdhXlEIpGgJV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(316002)(4326008)(66946007)(66556008)(66476007)(6916009)(478600001)(54906003)(8936002)(8676002)(5660300002)(44832011)(41300700001)(38100700002)(38350700002)(186003)(2616005)(6486002)(6666004)(52116002)(6512007)(6506007)(1076003)(26005)(86362001)(36756003)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K2t2iQVGJLFXoa/sMgI0i9ts1ScBqD82krT9zFNpX60YsvdurbUe4mmldCt9?=
 =?us-ascii?Q?jggvXb5BNeDpqibH3lLNIsZDDRafkS6HUBik23W6Y28TqS/tpctxRqH+I390?=
 =?us-ascii?Q?RTX1aSriiSVkem0i5DJt+H1Krm9AyeL5OKWrjoDPrIKpSDHZSMdR3c3ELkMr?=
 =?us-ascii?Q?tsTACBLzlxyfBvNbYln0GS6984BLctHblTsvr4sMP7NHRhVDG09doroYQFiA?=
 =?us-ascii?Q?eTGQzBv9CArDegOhUyKJC72IcGzqWOFfQnhNM44zPdFT/NudGpqKGj2FdRB0?=
 =?us-ascii?Q?b4olDKacsmy1tBdn8stx7i0p7kKsxs3NvFfTokiGZAKrshPGf8CmWyEP+rDx?=
 =?us-ascii?Q?xBBLxPlWiT2W5qg7uNbj9YcBmdWQq0wMdEvRBgL6uYoMAtGYGxr8XPDNAxmK?=
 =?us-ascii?Q?OW9Xd4kdTan9G0ujrEbMDo2zetaGg2V80BPLUOcdhkMzRNkAg7Kqcglhz13U?=
 =?us-ascii?Q?kFA8jYr3kj+KiEKT4Z5tFKMII9Nl8SbTQW0ZrM0MuT3DuldNMuD7BgOsOPz9?=
 =?us-ascii?Q?dguV2OBFTCIyZCXZ9asumW+LsnbK/NS2biQSrnItLZHoQCMyxO6y/FW1DqyW?=
 =?us-ascii?Q?OtkDL4Wu7Z2/6mgKfItuyIRDqaFypCIro4iOJuOJCPtVLVj8nL3zbSf3T1Ih?=
 =?us-ascii?Q?5/Cckz/dmSyTIvnOueBJmoLWP0TcxPWHBaVfb0qcUNkkZYQc5Rl5G2Jn06wg?=
 =?us-ascii?Q?8opsa9l7eUbEqcGz7ZBXL8vEPE2Q/1HFsmnsR08RAYxKckpP740Vb4b83PKm?=
 =?us-ascii?Q?L4gCxKJBhTzZwLO8SkBIjED6E4QxHViEIA+jSL3nKGotcWR13uPlZanEzNlP?=
 =?us-ascii?Q?E1Xq12BzUYNBoC97IA72IDDZNztC5YA0eGtnBT3/4gOd1IsLBnHCTVM3wIxS?=
 =?us-ascii?Q?/L9Os/u+hUGw2/vUBI+oQKrHODdY3d0SNlLBsoEBpz2cbpQZ1o9Xvnef0BPS?=
 =?us-ascii?Q?//gfsVgeR+ymh+XXIeearIhMpB5U6yYUGqSNAoqECFuZkyz1h0aI/LZ4n5Cz?=
 =?us-ascii?Q?AqpBSv/eShyxkEeez2KdCpT8LcN0iBWJg+iKRS71PhGo3k/Tsd6BsWRclEig?=
 =?us-ascii?Q?gs0LXqVX/rMgG8LeCvhLH3jHO34gAsMaoArmlgIFzmj451/dhHtZnbieVV5V?=
 =?us-ascii?Q?EeVifz9OaO4OtCUo+e/fILQnWWMq/Gt6rFpCQ1XcIHbueprDuSD1IhEGKjyL?=
 =?us-ascii?Q?EST6UR1dUAgHqbhtaQbGBquDEHBylC2LXXtwMdabLe7WH2hn/r9UcL7cdvNC?=
 =?us-ascii?Q?z8GC9veWgpV5ESvTq4jT/e2Rfl6fLRA4MoQpcybL+dL1htWMupoheovzsFKy?=
 =?us-ascii?Q?SgpD2qR6UFEQmiU99H1tuuTfUdxpQl1Z7gPoVSfEGKbMpcUQzxXqObo2Vx0m?=
 =?us-ascii?Q?nTvDo7nCyi09tLLwD+BXln0/EDOK8PWIJl+kltN0YirODdiXEc9semq/kpGV?=
 =?us-ascii?Q?eD4LguwC6GyMsLHaxour6qdiqFTXDy8x2lFvn1XOerEdLc1bocIpxezEKacy?=
 =?us-ascii?Q?qJDVXgRhEHZpYFrYVFhzhv9cJnIwRriamSWB8ChLGq4hui1ZQWL2X0WmtOfC?=
 =?us-ascii?Q?wieSiq+A5l+0K9NFvvz9dqPzFIOONwpNjLampvE2DbMxPds3HllgAg7ofcxP?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a7d8ab-3637-4c7a-403d-08db4001aa77
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:10.3813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dv2g6ktcv96hMApQizRNFKU09TMtBYhd4UNC9zBOZQ1Xo/ZgtJDrd9Sk91Udkk58HvD+wjjvzuOUdThTcCjA7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is already a min() definition, add this below it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 include/utils.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index 2eb80b3e487c..0f1b3bef34d8 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -284,6 +284,14 @@ unsigned int print_name_and_link(const char *fmt,
 	_min1 < _min2 ? _min1 : _min2; })
 #endif
 
+#ifndef max
+# define max(x, y) ({			\
+	typeof(x) _max1 = (x);		\
+	typeof(y) _max2 = (y);		\
+	(void) (&_max1 == &_max2);	\
+	_max1 < _max2 ? _max2 : _max1; })
+#endif
+
 #ifndef __check_format_string
 # define __check_format_string(pos_str, pos_args) \
 	__attribute__ ((format (printf, (pos_str), (pos_args))))
-- 
2.34.1

