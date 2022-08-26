Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F7B5A2A38
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiHZPA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiHZPA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:00:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF34BB6AE;
        Fri, 26 Aug 2022 08:00:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QDcaJv011386;
        Fri, 26 Aug 2022 15:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=Y14mf166721kMdjhIINKz4Zy7bOBdpoFAoaOAeetgso=;
 b=aqo891Y2VLOqb0++EBMiDE9WrUP1JFiRvSl58tE6lrQWhRBr+Kqba/6O5pzQ9YmxeIul
 WcPGeXiULYWfrY+ZOh+FqfNCH9i//HLlA1y7zIm0bxWSDW/DzJkHgZybBnpMc9suXeu7
 DvPTXwW6zy05O7AoYQZpjmYYAJiFXtQgQBJWYRNgGVk8jRfc0OXZa4NhCwyeQdz0TVyC
 VFULaUWuS/qvT7OR5gdJT3zxwAYiJl0LrY3nCwNzcWzw8CWVngIpOauQpwQyxIC1S18M
 hGOJ9/LTp6mHXkKHhJincIo9Wp9BQ5Q9LDTZYa8SbfuhuIGeG2Kbs4mHV4gytUBKArgA bQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j55nyg5rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 15:00:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27QDqI3s028236;
        Fri, 26 Aug 2022 15:00:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n4nx3hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 15:00:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOBK5UH3TnfsRF264xs7+rAY+2eG+89cmqCN3TOYJbEGRTrr4h2QvDh3zqWrbg55z6qWhaeXXlnao2MHybDLHiTo8S1TDuv4cvXj8tWoAM0rtqzA8W+fpgr/dmwn35mNo2COyq+M+bcwO6jiHECf3/hfNYkGFblCj6kBP3uvJCoGyjYelmCyt+Yq6dZTQhX1vBlGkB8PJPokwM0CuzmDzTLtuQl+IAH5OcFZ8+5ma9hFlJZcaVkiAc6peo63Z/x5LGpMRHC6KNjVDEe1fm9ftCRP/2sbyxPiXGpO6paYvZzkuvTQtzraUcaJajqbhkjA0u/AWQZcwHasYuEEgUPaVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y14mf166721kMdjhIINKz4Zy7bOBdpoFAoaOAeetgso=;
 b=mY6w233m2QBBLJ+maZQKknGark1YU/0TIN5XIL++5D+u3WUEldO80j81pCASfQHJ6/HP3TZi3sj9abIfhwk7MVvjwXM6Mujij3X3y8yI69nn2owR2z016rWP6ME0LvXFdmj/g/bPjz7n2NI6/C5pSP/YRGns1/+r0yjLO14Owxypnwsjl5Nfh2+KKOL4/pOo0OBFWI42sIrb1HkTPjfx8BNfMu5IfckDhtAAMKeIKTBpkL/NqIsGObWy0I/Z6Ul9NAbTyY9b9pLUnRNmSppg8nRGQwhS9jH0iKLBIWI2tjC5ixtAyFnd+fHifddXpx9l/F/6fvQIrxjqkd7AtmmGyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y14mf166721kMdjhIINKz4Zy7bOBdpoFAoaOAeetgso=;
 b=Gr3mOrDnIsuBQJ7+UK/FVhq03gOieUJ/bw1ZwxVbCY+7w22D6+HDmos0/CYsJqccTseJUnd/YB/9gy5c4wTh5JbLOnJMwmy/gvKKDNGJwPw8sMiyfNXQqa1D4qm1+QZxhAN6Q+OGtjBVP5F04vi3bGden3QnEHkUUi58PtyaRQo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB2473.namprd10.prod.outlook.com
 (2603:10b6:5:b4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 26 Aug
 2022 15:00:41 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 15:00:41 +0000
Date:   Fri, 26 Aug 2022 18:00:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: lan966x: improve error handle in
 lan966x_fdma_rx_get_frame()
Message-ID: <YwjgDm/SVd5c1tQU@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZRAP278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::27) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 178c6300-14fc-4063-423b-08da8773be12
X-MS-TrafficTypeDiagnostic: DM6PR10MB2473:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RVwy2h2DlfG+waEjHHq5MbFt509CZkJHi8vPDMfGjovxyCQZM99MixCnxGwA6277ffWdDsema3QsmdaYHGhSD2FttmEQch2papkgrioDOIhWIid5BqODUFo/64wK+28hDnos7Brx6y8NgUhNPi3Tli8ps6aAb4TNDKLaQFxOsMEkV+6sWFK8k6X4/PsbdBiirewB0ClZIWgWHMWPXthYCSkRRvdfH9lMNWEOiCvN0Qchy45zllf9wkTTslHyT+s5LnxP6D+sLg4oKN+/LjVJfCBfBc/GTN6myGnWr3ICD4gnX3ThFX57Jf1n6p52FGORDYRPlwEevPvvXIXg+0lgrkh+GTojUr35CYRhF7e4QqCZy4WtSuBX8MFCKCfCrI0sRVe56uIaD3i1V7XuwxQb9+nWbJhbC+SjX0hZ7LVJzgEBC7kTrVAt4iAsEjWkBIt8+o6jvdJ2zsX6+z/qhe6zR6BQwoWmZJKSprxXxYcopIM+74ldLRLNrEgqSFCIdFRCUFEhbvsry1nfwSX5efSUKQvw6poooeF5DOgRoSLhg0HdqT3lvOiXPjN0MDS4SChQOpTzwAjnGgCYipPr5nk1VGIE2KSlBui6XO/ngs585ZeoZZPASBXlJMJfF+Y1E7dWGjvrqFR+tjadMRR35hHjEy2WWue/hr7X179wJPPBLllSm2VfAMg3/jdDBvYAZd8YJoMGPjn9bUwhjU/8EGtxRvf9110ZRrc3Cxtmcmej9I+8+gZagab3BiJgwM/UdcoGw4xfcA0yAdWUSjUbUItMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(346002)(396003)(39860400002)(136003)(376002)(186003)(2906002)(83380400001)(478600001)(38100700002)(4326008)(38350700002)(66556008)(8676002)(66476007)(66946007)(6486002)(54906003)(86362001)(6916009)(6512007)(44832011)(6506007)(316002)(26005)(6666004)(8936002)(9686003)(5660300002)(41300700001)(52116002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kseFnb/cTJM29Ava1l0TDwG9/H8OjwJD6a2Oxw9s2LDIO083vq3pdpAmABIS?=
 =?us-ascii?Q?vQ9e4N6pU6gitrQYJn9yTqdIUALULPLlU6iX49WPFWNfX85XMrPn5LkspeMy?=
 =?us-ascii?Q?bDErweMYylyin+UggKK5uSudwrUsWf/J7fjMnZWAAS/TFjkGli7fr2kDBbIo?=
 =?us-ascii?Q?q9lqfdxbxOdf49CXtmzswPBub8PANB7lKOO9TW/5eO3xxhgT8yY2jZnlgogN?=
 =?us-ascii?Q?UJUjtvgrTq9YjsFmkvvXOaX+0jK2FvvkUF8gWXWMSLLOw5YI2P7jvsezREtt?=
 =?us-ascii?Q?D6LzeHN8rX6U9K/BKuiAj9KUCA/eAJGWMbkeoyBQgGkTWz6NwZjHhHNdXsE3?=
 =?us-ascii?Q?SMreMKxpKKEX2Hwv2TrKrTRa2mNyhuZ8eXM7RJPHJzfFCZkxYOKlCaBNpbiv?=
 =?us-ascii?Q?lE/GzWqGSNKjHyYuA1f4vFHKPYDMyhl8EJvUcBg+jTEOaJvJt9N6b6XN7kgC?=
 =?us-ascii?Q?5+KRm+fKPsQ4QdBVUkYTMLjdjCaRuzsVk1U8jRQL6tuDR/RUvCi9wtCV9LTs?=
 =?us-ascii?Q?YS0kXtsqe2bB1JGmM7dVCa6fzS0Xj+8THVLx2soMhbe2tN0YBTJUrSti7Tpr?=
 =?us-ascii?Q?k1JwDHe4VDPSSrs2/8a6Gf1SVvS/hRyYFi29LcCqs2WyUOiOAwnVHYi7zn/F?=
 =?us-ascii?Q?rC095h5ulKjpsrlBzquYmaa5U1V4daggDyN6UPXjNa9hWWtG4h4DjBttEIFZ?=
 =?us-ascii?Q?st+DtwT4SA2SvuWJty+tXqebIkqKn5ZkPSYzuOOUxi5mmg2GhcJHk1zzxteY?=
 =?us-ascii?Q?8/ZL9NpjJgoG0nT6puiSzbvdP6KBwFLqh4i1RzhexaAx7+wKQbDORF38bGeJ?=
 =?us-ascii?Q?ztWTVXf9HEd1SMu16NgShfdNQ/cF3Ukjssuc3423HRI+oREWOIw24pbFYyKA?=
 =?us-ascii?Q?ocnyL1Pq05JbIfxRZ1MSRSWGxx51XNiU6zxSDXYYfqtKpLd8x3NCb0HHJs8W?=
 =?us-ascii?Q?uD4I3tDe+bdKLZAyXKB0cCnYl1wp2GdPIDb5yynGwuA9QyqjEwUqQnlvqhg9?=
 =?us-ascii?Q?9UPdBy9LJmUvWw3C9Iu8JQ50UxiwoTOSAUIoz5iRdyTQrxWsS3mQY4k1ggXc?=
 =?us-ascii?Q?92TexKgO8rdtfladSXUcxvhFU2FabswNupMqr657CUwZXR7svlZGHT/bU04z?=
 =?us-ascii?Q?e//ESNAC7XhrwDsCe2UqJMCESFlbilroUnmLR+FaXtJ8R99lQuG6g2D7Nscu?=
 =?us-ascii?Q?v2xC+j4YhtONPqOBkh7FhZMZY1WihV1icg9jyl/Z/bjMx//xTSM4jnYMFEzF?=
 =?us-ascii?Q?gbAjJ8uCcYGHtIRgCGW+A1gd6kiqgBwuSsw4ONnPsOsVaDuKYWcz+nyylLIz?=
 =?us-ascii?Q?SWclmmstE1t8bgbOPi0JgGUl3nZZGLXrd7LoqFzej4DlfgjSrXa12K26YB6r?=
 =?us-ascii?Q?VIOlk/91v+uMjUkNl3uw6coEUPiemsUxcqvRD+oFYb3D3Pu17alYXz2l6ewx?=
 =?us-ascii?Q?/n7KLKPoMO7gPQP/YBg07ug0cnC5mWp1EUrlyFG6bplrr9804K0pj0QgkmHd?=
 =?us-ascii?Q?LKJy9EEj0ZB4LWBk4qHzzd4CHVLEpEyHfk+hZDrN20cZPB4uzB7FaXYPNAbH?=
 =?us-ascii?Q?HisRZWlUfHwU4WrEZsEh7hUWQAbktw2b02MHe/itWfqebZ2r4jKuA6BQEfH6?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 178c6300-14fc-4063-423b-08da8773be12
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 15:00:41.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPJD07Rtdq5DCelDKBhcBSvceQj0CWNnQKNRT2hPZdJFLTUotH1u3ClW/KohVCMRbmjLUVnhMa+5mQNf8h9/MHcoP8q6FvP2ZaLdYzBi8vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2473
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_08,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208260062
X-Proofpoint-ORIG-GUID: dsTTTMIbVTYQro_1vkkWjMtfZS5dK37P
X-Proofpoint-GUID: dsTTTMIbVTYQro_1vkkWjMtfZS5dK37P
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't just print a warning.  Clean up and return an error as well.

Fixes: c8349639324a ("net: lan966x: Add FDMA functionality")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 6dea7f8c1481..51f8a0816377 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -425,7 +425,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 	lan966x_ifh_get_src_port(skb->data, &src_port);
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
 
-	WARN_ON(src_port >= lan966x->num_phys_ports);
+	if (WARN_ON(src_port >= lan966x->num_phys_ports))
+		goto free_skb;
 
 	skb->dev = lan966x->ports[src_port]->dev;
 	skb_pull(skb, IFH_LEN * sizeof(u32));
@@ -449,6 +450,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 
 	return skb;
 
+free_skb:
+	kfree_skb(skb);
 unmap_page:
 	dma_unmap_page(lan966x->dev, (dma_addr_t)db->dataptr,
 		       FDMA_DCB_STATUS_BLOCKL(db->status),
-- 
2.35.1

