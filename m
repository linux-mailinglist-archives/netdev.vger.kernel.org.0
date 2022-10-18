Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4720C6024A5
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJRGlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJRGle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:41:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C413DA8795
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:41:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnC095Bf07ksze9jX5YtDkt4YaD7sAzdbiJkY5K457SUR4vGmetjnkadzfDtVn7Bvo4weUMbg2o2RuIg0yKviyFxzQb6hnpSC9uYUJiyd26/CKYgGTwYvijSWlT7RiNAI6LYkbuFERVCAJhedrQ/I3RfyKj+edEVRZB1fijHQzdas7tRRFkq4QhZFn64vo+JjF4piZIIGItC8vDranA5o0x+nID6hRDBnUK+OcYjcyVfrZ3cUxGkklLU9xeamt2NPO0AZlsIvklexAWOdd+Noj49dzbkWqZgqseFDhoUU/0jyHa4QyG2hRba30mizwClJVpGDa5xrwVJVW2Z1YCtVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3B836tSduSX6HvM6NOhRWJnuh1AZBBBz6KtJIP4MbU=;
 b=j92XxsMUUUT6WiVrnjNtVcx9rrI/4aYRPa76K/Qr8WV5QNNX0XTtaGy3a3UurhC58cVdVZUY0v3NidLC3hAeKFvX1xfjzCEdvDfn2VvCI2q4kLJ0VyI8XFz8iL/NfJFCMIl+pabnIVec68uj3nY2dJsl6Tz/ENoMd0N/KCaftIB+G/iX7JEWvYvj98JtbaVF8Ver9dWQ0nLQY6ZYXTBnePLAJflkoJNRKgQl+5TxCvhMGfGhXcuIQKLK9v4WMvFMkT6lD4cNrSWubjsyMZ/m0ukhlSXkcWYhynVDLh5TsQP+nkYS0rB/2wnnMlBvlACwtIhEKWhUm11QEELUvFuNuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3B836tSduSX6HvM6NOhRWJnuh1AZBBBz6KtJIP4MbU=;
 b=ZkfL77sQuzPAW/dN+FPPx+r9aayEBajSteAtg+/XiEZDBviak7CH25p0uFObi7xUSC05iVB2UIzyu+qRn3Xq8/884OifNURVE5H6om0YIx+tx08hSBgg0DraEySRvjPi8DEcWQ9qbp8IdSf5UN31jNpXq7PBzavu3nsJM3qAHVivCbjj38seoKdeTArrL6Z5nUeYNAtaxNJHHMU1f2Y0pFMz5lL+4WlWRdyqf11kveNY/jMxX7WuWgrL3HCtBE30HbXly1NrnKejrtMLvelhZr4AN4RzcJhgk+09wABTNJ8e8TI6fH0EZTKid+F7n2WIwioX+NebZnfeP09ELj/NsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5385.namprd12.prod.outlook.com (2603:10b6:610:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 06:41:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:41:31 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/4] bridge: mcast: Use spin_lock() instead of spin_lock_bh()
Date:   Tue, 18 Oct 2022 09:40:00 +0300
Message-Id: <20221018064001.518841-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018064001.518841-1-idosch@nvidia.com>
References: <20221018064001.518841-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0089.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB5385:EE_
X-MS-Office365-Filtering-Correlation-Id: 160337d0-2154-47aa-3713-08dab0d3caaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xpTdCg+UxvwHPmJLOhh4bUS7MQyrr3uKn34Eiarg42zwKWW56xuTYD8v73x8Ruw1LPkz16yg5jUqUwUK0ExSEO383ZtrwHALihqko0u8cYE1VYUgfOeL0Sh6DHM9ndElL4rWz+DQhDBF3MKHSygGg8jeLfO66Vfmx06SiEjuim9B+o8Ew/DR697C8EXw2OwMWUDe4GbrmvE7Hfj/vuscESPKhWZrCgk5YE+Hsv9YMrsbRsUZ5Z+uX/iDqQBTd4sidRMfEYgal9egUwSzfbySO9fYhamTt03G/aSHAzR5jv+OpQYDHhyuSCMc8KL8kkB4Kd8KrZiqlVo+TuAnOH+E55bv7wYAEWgcgQ90/xRMunouKyp0cBsrJh4SFnHnys4tS3XVdamLuDoHqsxA8D7aPMLVROjat1vgCwosjtotc8cLudF+Hidi7T6ovReionoJYNfv9tZOojJy9ooWTYY4JZwKQR2OMQEHhsFjJ9TYwsLhOHS+lKvjWxs/cIRYnRpY4SzGX8Ja+15rq58BkgNW2NingxykzQNvc5L1SLzoV6d+2xo9YlvHtoh0+AwAygR2w6AScxEnwM83ZD4pwLkUPv7UyYpgI6H3/xhuf/y1a13+TUv1L0hFl6JoGyp9/ul/k8iHotp7fvHvcq0F2Qll0NbqwTu99zmqe1306yxZDn53To3RTfXeV1K6HprCKmt58PXgkL/xjS2i2luq58egMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199015)(36756003)(86362001)(6512007)(4326008)(26005)(6506007)(8676002)(8936002)(6666004)(5660300002)(41300700001)(66556008)(66476007)(107886003)(478600001)(6486002)(66946007)(316002)(38100700002)(1076003)(186003)(83380400001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ziW7BZYJ2j5Lt4zYp+5UI9JCVQideF3oA+BbdIIo9lpub1pXAC0tobpJploY?=
 =?us-ascii?Q?ntkuhZyxJHBLrzsZSO1d1Mv2miop0ymAb0OmVbEig9cxoZku4TFjV4ijNAX4?=
 =?us-ascii?Q?69b5lPQVBL5gFJLMS2p86Gh6u0mnpLajQFhFMsTnIcaIGANVh7iMtHm+W/11?=
 =?us-ascii?Q?QfSU8bS0nYoYya7jXUItYFBY96nyamfjIr4rVcR1vA8wsfle4TbN12AV49Yr?=
 =?us-ascii?Q?3RTylWPPIMox4p6W6tvuMXOa/6h6FuOQWr5c3485jGIKmRNqY5TUcW3spwJH?=
 =?us-ascii?Q?e/JmjsZjX+lZdU23mj6agB1hwzH23wqxml7fSucrj/4wRy2PpswwjPDE+dtb?=
 =?us-ascii?Q?xDMW6Tnp+jlkgMwrIJOXkSP7YGfpS88nYnDn/oT8QO2wxpHU+0Vr3Caxvuoq?=
 =?us-ascii?Q?uO3PKzg/QWASxLTFznSO/6UUt+ySU/WikF5dmtWxcMysWRQUrDLCVZpIGnde?=
 =?us-ascii?Q?cxxZ89Fd5c8kAr52ang+OSjR53Q0KNLF9UfSNpc8YaUG2SVXkoXYLL3NTyzJ?=
 =?us-ascii?Q?Ke2Yb0O5TzEvYOfegRL5gs5WwdSCbXEWKvHfGDPf7yIQdeDRcALmkDgG1yC8?=
 =?us-ascii?Q?7iMXMtbcgkRWeTova4Qtq7JURyqKGC/2jAkmXlK/ZZMFjiQJ0blnfYgDPiBZ?=
 =?us-ascii?Q?PhIRc8eoVqI6myElHVlWNx/duy0i4gMUSQgznBq77piV+mifKbVhifwJpB5B?=
 =?us-ascii?Q?qq3Roqs+Hu6qb/lHMu8kUIQ4FcZRqfvnryVFORPKkR1vRqo/szg9uy6Vd6bO?=
 =?us-ascii?Q?AlhHdUHlju5KcUW6B0eugINwhOTug2deL/+E6snaKHmzte3St1WJpXyPlGjp?=
 =?us-ascii?Q?1mfg8Rt6Fh5kQ50GXlAIqXV15b1MOT0eE6M32ZoxY0Sw+7549Zb/ttntB79h?=
 =?us-ascii?Q?6sP0YdNb1xVGb86kLsO693GDTo+W7Ly9HWWt0MLZOiqxaOISS9WAN93oEX37?=
 =?us-ascii?Q?www94onw50Ie+u5JpeXRfA5UIHofGYEd/rqGiqMv15zuMDLX8ZnaAK/gc8wH?=
 =?us-ascii?Q?L/mMkNRcJ7kifAfUuiYZKJH3ftd4AVMTKWcrrt1McnSedQDr8PCQtt1Wv0f7?=
 =?us-ascii?Q?2GjhUX3TjZ/oOHGOUtQHqEnXDjr2KALhQ9xiA8MzmVqqLDI6AJfVDYu8b/pS?=
 =?us-ascii?Q?6rpc4Di2WFte4LuR5StgMa2jiEAQ1sYCk+38FkvGWSIGr4zgBZXg8xA1RFHy?=
 =?us-ascii?Q?vrAkM3zcRy9tpTdiSZdM+hPRCf7H3HvhAL3WJ2iNWhz3Wdfjwta13N6k/lIm?=
 =?us-ascii?Q?fX3p3Szq8+Ib6Jab2nlA4ChE5LArzgoG9e2pwEpokiNi6SUwzc+9cFe66Gjd?=
 =?us-ascii?Q?7+P930imSL+EdlsVM8P9MnR5Cs1N2mutPO3T+jFuMAwPv33bYGJr8Q2GSQOA?=
 =?us-ascii?Q?tq4cMwhrnirEargD0dPjAMLb/7gkTLwTS4JGH3TLA+KU02k2PM/79md6xih4?=
 =?us-ascii?Q?SfzTFs7ZEiHBbiuQuqSNIpO/nWqnOFt6FQISiEI6+nzLxyVVBcVhfqf2sPBz?=
 =?us-ascii?Q?Rc+BxI/VDgOdC8V8mB53lYSV08GqzvgbZv9DRrrVN8U1ixBrQ3MUuwOagzhI?=
 =?us-ascii?Q?mHtZ9N9ROLPHXkEMpKvvBgsSfMXwSPxC8JuhKqW/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160337d0-2154-47aa-3713-08dab0d3caaa
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 06:41:31.3586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNgTgRjV1rwf/ct240SI1fXnbxcaMby4Y+1tszQ8jVxpIHU9H5H8iqkFxWlZErzzAQVHrRY+LfpE5+l+M/88Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5385
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IGMPv3 / MLDv2 Membership Reports are only processed from the data path
with softIRQ disabled, so there is no need to call spin_lock_bh(). Use
spin_lock() instead.

This is consistent with how other IGMP / MLD packets are processed.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_multicast.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index db4f2641d1cd..09140bc8c15e 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2669,7 +2669,7 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge_mcast *brmctx,
 		if (!pmctx || igmpv2)
 			continue;
 
-		spin_lock_bh(&brmctx->br->multicast_lock);
+		spin_lock(&brmctx->br->multicast_lock);
 		if (!br_multicast_ctx_should_use(brmctx, pmctx))
 			goto unlock_continue;
 
@@ -2717,7 +2717,7 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge_mcast *brmctx,
 		if (changed)
 			br_mdb_notify(brmctx->br->dev, mdst, pg, RTM_NEWMDB);
 unlock_continue:
-		spin_unlock_bh(&brmctx->br->multicast_lock);
+		spin_unlock(&brmctx->br->multicast_lock);
 	}
 
 	return err;
@@ -2807,7 +2807,7 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 		if (!pmctx || mldv1)
 			continue;
 
-		spin_lock_bh(&brmctx->br->multicast_lock);
+		spin_lock(&brmctx->br->multicast_lock);
 		if (!br_multicast_ctx_should_use(brmctx, pmctx))
 			goto unlock_continue;
 
@@ -2859,7 +2859,7 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 		if (changed)
 			br_mdb_notify(brmctx->br->dev, mdst, pg, RTM_NEWMDB);
 unlock_continue:
-		spin_unlock_bh(&brmctx->br->multicast_lock);
+		spin_unlock(&brmctx->br->multicast_lock);
 	}
 
 	return err;
-- 
2.37.3

