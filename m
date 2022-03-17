Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3704DC08B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 08:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiCQH6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 03:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiCQH6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 03:58:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390B91C2316;
        Thu, 17 Mar 2022 00:57:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22H3THOU001986;
        Thu, 17 Mar 2022 07:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=W3NTHAB4gqdR5FmYW/tqCauWKciOK8wvXEGeGY9Bqj8=;
 b=QD06/Otfg2CJTnT1wnb3Fe5wYcVhdQHbsQ3nq5u9mKITJYqUhkeWo/2Aem9lbvIABK5o
 zfo8JbqXnsjVW5wM7uJduXTNm0Lydb+jH92yyiXce45bQ2MZ7iGkeo/PnvUGigAP0JF4
 No/AE1g7kCciTdmS+YYPhgRetchvsvTSTAa/vnqET2tqM7svWhalWWjps2c5KMxQjLZY
 6rNNnhTB/YIPAmIep11rriP+1FnJApNu2wd+638cCU14uPuYOXNOHPaobBsCzCee9aJQ
 3bVQdTZqGex6EF7tp+kN9Yb7WDiRjBSWon5PBRAsyOdDnKEI4mOYdol+HUYRn9ALZ8eH kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5xwr65c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 07:56:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22H7uQAU087359;
        Thu, 17 Mar 2022 07:56:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3020.oracle.com with ESMTP id 3et64m5es6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 07:56:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzecJbQC2cPmYFVY48RSisgxLir8VTLtZNpxx4SqM8qhmNm4EFIJnH1Ays+8lK1pDB34Q/uFoOp2ZM8srxIulKGdGEsAeUpzKmOlgxjFyWrnfqC5xB6Xpy1kqRKVTgzLvzQTOprmnCkCi06CUsXHp84jGuUZl6nbUoDtoPoUg9sIGOQdmzcr7u2XrDoDSQOMbgxaJ/sFdhgHhkbVyipdk2X2piUWwaBLPiZ54YrE2sY2VM4lMdIKxOcMGSWPn9YfTqDaA1kAfLK6AZubWwWZpzoVB7/e5tL5dQui5SncKYjAOiZS9Kj8BCR40TNGZIG9RMSWtYQhfS8xOR4TZDvVug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3NTHAB4gqdR5FmYW/tqCauWKciOK8wvXEGeGY9Bqj8=;
 b=K6DTKJNfDEIq2eCe7v1uumdrhUnB8TidenqS04rnEG1zvTbUwJpcbB9qS9PgFCABnejGfb1/1LLDZq7U2XaVzFOCJxaRpIGkT6SvsFR4EMg6XuFXa4TbaeazfD0YwfgS8ManKk4FsqUcn3/yyWG82/mzl9q4XiXj8TV1XBFllJ3TocEeZybvqFMtNj4rxDuGdjgyTeOShVBq6gRphfzPIwLS26d8H5TtYwBbZEapWniryFJB8OS469sIWroTScqmq3cw9+b4aA8AGo3FLBjtJozVIlZmONXIgOEYfYw5DGRLVI6kceSdqRz4Ny3c/Lu8QgOdETAXFTRBVVzfb4UFyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3NTHAB4gqdR5FmYW/tqCauWKciOK8wvXEGeGY9Bqj8=;
 b=aedwBa+1EDicKxPPUEtII1WBFzGdyicHc0dR87nz/UkhZHYZonv0LbAZRbSXDHGmnx6O6LNTJHmUV9M2hbYqPz/tDYD2lr4geM8+Zuv8SbQStgeI5YGDxeb3W/1FVneioqi8WfD/n9w1+TRW7kBnEkqYKFLxxJ8lWwdRdMXhnB4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5390.namprd10.prod.outlook.com
 (2603:10b6:5:3a1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 17 Mar
 2022 07:56:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 07:56:53 +0000
Date:   Thu, 17 Mar 2022 10:56:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Harald Welte <laforge@gnumonks.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] gtp: Remove a bogus tab
Message-ID: <20220317075642.GD25237@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0040.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e09cf67c-5d6c-42cd-4583-08da07ebb371
X-MS-TrafficTypeDiagnostic: DS7PR10MB5390:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB539054DF4DB7FEC92842BA468E129@DS7PR10MB5390.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nlf/s+UU59FmqX6P6YgNyVstCyDcGM+S7Z5EzdNB1PI9o1rAoRMMIG94CFNfdVr9yF5fDymq6V4FiWk94hesaTEPEOz1/TZAQGuLeXM08KS0hIzRDGa01ot8sbu+IEf4GkcfJMDIuqhzDNhQBtlgwez7nSCSZ3ofpE+ZOj1F9VjMC35UpVRt5UZxZ8XcyhUwFw8KQDHekuBH66sOnXYnwkU6z68NityJCtM/eGCq2+3bi8QrurP+CY5+gLv4LcTPKe19dwGEgB8vH+von5CfCgFP4zbrYKRKnA1U/LPp1zeIQJYdzwd5O7m3qA19ztuKGLIEM3FRkT5aGeyOxNrNO4lC8EikyeHYekzEj0DhMK3D7BtkkLR5k1Bqvn4DKYaGz+pU++Z+1Gn14kqgRXb+WgeQX6UamYIa+9I2UTlpqCpwag6sbJOXMLIssJ0rp9hgAb9HGNHzojLcjIV/Vhyme4VTs3PtcjqkQti8NXEBz8rCtLE+5wrkinRjrDKVmuYdFC2iIH9J5pCWW6YNAX+u82UNMaWD9S3SXCwVTePKB1iROKGFrwQ+SaHup6fNY10azkRg7uUZXtoYqTRFkbl+LCXo2TZDuzYkpphap+jvq5i1Dmu7YkI8z4xxf5Ui/L2tOiZHA1cfhYv99f5UeCZATqgXIofEMy/Ly3fzR3Upl4MSP9IRoZFcgau8tVGHFSFuSonY5WsZZCgwMhjkBeU0GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(5660300002)(83380400001)(33716001)(4744005)(44832011)(2906002)(316002)(54906003)(6916009)(4326008)(8676002)(66476007)(66556008)(508600001)(66946007)(9686003)(186003)(6512007)(86362001)(6486002)(6666004)(38100700002)(38350700002)(6506007)(52116002)(33656002)(1076003)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CVmM6wweqXncMktckN3Z42DFZtzac+4k3f8RTPYYnjptjj01rQ/GdgZV3rjp?=
 =?us-ascii?Q?G6Yf6v69l0sjlmJCoHDMRcWBUK3c6YFQC0uEonpoDb/FK99ebFllzz67gTgL?=
 =?us-ascii?Q?BPr+b3LDu5ivG6I+FRJa4EKGIrHdNGzOwD+6i9WQBkDntggcXBd+I394FaPI?=
 =?us-ascii?Q?14KByGbVM8BnjK70BXYOUjUPCZwTW3gOOhee2mzb9TdZM8K840sSShFvfoko?=
 =?us-ascii?Q?SQ2kudc9vET0H7PWjYh8vs1M4hItaKQodVyVEpxQNARZ+JYDlK0WTOz5BImO?=
 =?us-ascii?Q?dGcBN5EeGD5RFz1B96tCBICd3kKwjFqE/c/gpWMgLUHWX0LJUTQLRb9/yBZb?=
 =?us-ascii?Q?40oTQgkou5dfApSHEGMXDbExcZQhYNoF0KfReYhn6TmkBFKadm70D6NP91L8?=
 =?us-ascii?Q?tDNC+g8u/jgXFV0Oe1jRPAQtCjYLEpxnumkGF05RHuviDIJMAmfeI7DqQsjn?=
 =?us-ascii?Q?WKd/z2e3jo/IOxt9EW+TQPECXHZKE4ejv8N88vZ67ahdY1cch6JWM7aaCLiD?=
 =?us-ascii?Q?mLXbuFFTm/EXH43RS7LJ9+50FAPbYcsSSVsbUYhoQIZEl5A98rlN2njnL/Ix?=
 =?us-ascii?Q?Vkjru7OOfLFM3pcqa40LquyL8TmSX9q3pn1O33vluwLCu2NkjPWMTXvomWEw?=
 =?us-ascii?Q?TowtthWRSy5qEa3X0Yr6d2eW71UirZ13nCmF0IdiPX7BR73nIP9kdrqhDsF9?=
 =?us-ascii?Q?PUMPehbWgTskMB09rszEJU9IoIFTaE01+pAB/ao3LrIZekaDcBcfJNgjSFtg?=
 =?us-ascii?Q?MatB+/5ZjbEJi9yugndn+ENIqlPiUaqqphtLNrPhe7KFZ/PEPPbQOqXaRFXX?=
 =?us-ascii?Q?JJ/jHYb/of1nGVqYoLSv4H8XuKDjpFIZ3OJspDfpsmwO+LllAYt1I6yvutgh?=
 =?us-ascii?Q?GOstCEzElq669UhZmgTP9XPsfjXrnqMAoIFMqfzE1dQe9POPFCcTwcYGLPnN?=
 =?us-ascii?Q?tFobW2TnwmX+UOAucxHGSnlwYFI+B1HjK18Yvq9kZs29WdTEccPqCRqSQfTL?=
 =?us-ascii?Q?Vw2L7hGI36KgcKKZe5DOIOl+4ep1f/Xclyd5mAgQUV8NnHn9MFYidT8jAiFP?=
 =?us-ascii?Q?7wkzndBU5/dAJqE9/RHkDA9jSNuouZRt/760cXa5gU4RZyZR0pmZgPBuHhbL?=
 =?us-ascii?Q?EtwIwNI1rR3OJ2+TLx0It0idBh9caw1tQ2zy1sI8Zf4L2qQLHMiHpEgQO4z4?=
 =?us-ascii?Q?DfvQ4NY8mSAeyKP6cKgD0PXv0hxOP4SEi+Q/Uk7HdjrlyAkppQG/Py1XuGXo?=
 =?us-ascii?Q?IUEilLZSTWW6A4ZM0xJzoQWv0x1gIijWITJs9ZkMZd5OPKoYv+aISK+lUk8K?=
 =?us-ascii?Q?AiadgoUvL7ZUHgp7MQyMC5O6e0l8R2W1q9O5qgv2xWdNqByUJXoPJSeuSeDP?=
 =?us-ascii?Q?RVEXFZ/fGe8GPQ3D4jX0A7uNw6xs1LU4bXjnIvRQwS+qGWoosO5Pd13KrUlV?=
 =?us-ascii?Q?x2XKYtYWKiH936zYF1MYhhDl3u/ib/d8YDGtWBUKfQWBtiDykQU8Hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e09cf67c-5d6c-42cd-4583-08da07ebb371
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 07:56:53.6850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0qpyQl41dN+6GbUwPyZ10DRbeDSxzHgRLaIxXyc4M0FwKkV4TNHHyVtRT+lAFn4yCI16Pm25ElolnA0WdJr8TPjfedh+CEDy1B0IsJcUnHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5390
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170046
X-Proofpoint-GUID: eic52e_uqWoeYEsf9orErCP02T4oMkFC
X-Proofpoint-ORIG-GUID: eic52e_uqWoeYEsf9orErCP02T4oMkFC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "kfree_skb(skb_to_send);" is not supposed to be indented that far.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 756714d4ad92..a208e2b1a9af 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1793,7 +1793,7 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(rt)) {
 		netdev_dbg(gtp->dev, "no route for echo request to %pI4\n",
 			   &dst_ip);
-			   kfree_skb(skb_to_send);
+		kfree_skb(skb_to_send);
 		return -ENODEV;
 	}
 
-- 
2.20.1

