Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F7443D9BA
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 05:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhJ1DRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 23:17:35 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10778 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhJ1DRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 23:17:34 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19S1A9DF021055;
        Thu, 28 Oct 2021 03:15:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LbqQI9eHE7gzsjUVGqYzIWEtCrRYvdNJNw41Jsmal4U=;
 b=ylO3ElxBQQEqwK3qyMoS1bUyCbmUPClpaC2J90FkVkDEwUuOY1wuc9GmuFG6m96AdvID
 11d+GLpxU+4UCW2rHhw/2NtnBDCzpozSjSib2Vc0dMCNcpz7+CDNpKSVYEziRCrfw4hG
 kGdvl1otFmGxQt1b1Xk6MMcj+UJpMjpK++1xMlLZIKWEGS/Hg3wqLRRHwZWCDaPTXi4p
 bCsKPNx5DLSpFCyOf6xykJHXZzp5pNlZNapucmu4q3QWiSgIZ9zTl7ZiVojjDEmOp914
 4ij1OmaCNJv/9EPPDYIVbpl+1UYDdzODuklSifPXQmXoDzZ8r51+baFffwdMhdSeva10 lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byhy9g80a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:15:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19S362DP008160;
        Thu, 28 Oct 2021 03:15:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 3bx4h3d16k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:15:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baJkgktMybaAvOArxfa5YDAQstVm0AvJBGfnsq3Q8aPW9ti6ThNnTrEcCMPe4jwjLs8brxCtW2a5ltNsvV+mUpaJx0xu/MGreZI7/oOehYB6rQ952fl+4Yb5Pa/2p5HLaxi0py/ZXjN1X01ax7chM1gNrpfj4+OGapLy7g2iPu2YCxZ6VKmSXUUJbDTHjtYK507OnX4YJZzmidzCWbMlkKbHmVn3oYDMPNVU6lcvmpph4h6rI7tuPF9w1JSK17tvmZSjywvHhr6e4k21Lgzdp4uTvfZJLo8ZzAY2xLbQhBD0Uln4hk8elch1cNAX+ftVMVk69fAHtx+kfn0ORaif3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LbqQI9eHE7gzsjUVGqYzIWEtCrRYvdNJNw41Jsmal4U=;
 b=RMGAL2E5cPxB6v1z3v6ZG96h9Siedq6kIvfCRQoz5NIB853nk5pqWy4fpSdyeF/huD5dVOStjqwFxsVNTC+UHIlOmNcBnhiEoMlry4SO5BTh5mHN2/JZn9qUafUuo7WvdPAvE6Cvk7e03o+2nfJEAasHT8wpCdy9V+mJ/j47g92YrfxsOfEzqEM7G+hT8rqTZzwSwtGnzTTMsAib5M/JwZg2emtQbiTpV1n1+amJoxqCAJa+9FZHKbcxfhxt+l7mdLUF/cJz+turvVa5VtWweyJPO0uYJKGqvrQRW3RvTcUHuNUjUemJR1UxvVkxwj0lMagG/uvTb2R8jtCgE6vQOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbqQI9eHE7gzsjUVGqYzIWEtCrRYvdNJNw41Jsmal4U=;
 b=avzccnpzQJB85PeWavnlwdbG4b4qY3db61S+SzaPFgQLpv36mfW/9kNtWqx5fzBDZ2qVF3ac4KvGc7oZ4phpNNQHap2gi7uIGkZv+25GcqbGV2XzjyGpoTw9eBcOc8+9QiQ4g9tXWWpKJMp9mQAiTQDbLhQZ8a1srFdah6EslNk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 28 Oct
 2021 03:14:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 03:14:59 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next] mpt fusion: use dev_addr_set()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6itzvri.fsf@ca-mkp.ca.oracle.com>
References: <20211026175500.3197955-1-kuba@kernel.org>
Date:   Wed, 27 Oct 2021 23:14:56 -0400
In-Reply-To: <20211026175500.3197955-1-kuba@kernel.org> (Jakub Kicinski's
        message of "Tue, 26 Oct 2021 10:55:00 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:a03:180::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by BY5PR13CA0014.namprd13.prod.outlook.com (2603:10b6:a03:180::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend Transport; Thu, 28 Oct 2021 03:14:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd572c9a-6e07-4f18-d47b-08d999c11fcf
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-Microsoft-Antispam-PRVS: <PH0PR10MB46470AADC945B3880D887D748E869@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5HnItB5M1J0RXm18SK2E5qWWY28RVkhIP4+Xq1f7I/UBS5QBcdHhYsnQ1PJWPSfLCIFzGt9YiJEyxQXaN8VxS2UMIALF6yqfzfwrkMJDBvFNUkuIoSyHgDcWUnBa1GlC1yuddsWjCKzqmOzUmB/pyArbhO1JF2P3hRHZHAcxsbYXpGn/NR0nx7VNNGNxKWKRLovP74GaROPBF5tn7yzSDrhl2pD17gNdbd4BQ1sgmNGn7YsuCZid7JtAp6EoN4esHJkisllC89LETWCs7lxtkH7NjktdvQMDGp9hVEE/FYGbFu93FH4x1YCNgiZ7lGgYX3iRYNEKiwO3pInlRd8zJkP2ipRWbSDVzqGrE94usJQfaerkr14tmt7PPugHRnYiIxP3pI+bH8L/KW+4dp2tpThSdBK8vgkYj+mwEsWj/4S0cdlHGuUkVFcb/pT8gNm1u1pqeR6mJaldtXLd0KNeMcFQ6YASG+CtWyhAw25iB3f0VauhKC79bEYsTQoGOliRI9BMnmatop8Msu+sLnqaj0wa/m8JLBiSBWHNJiGZA+cJg9+kJbq8Ya/6qLhfl70PQ6VtrzQBYRrPcTLPaof4IF70/UGf8TTGMkDF2RxSrUgbC0Xi2CVTLQccmsgiRLyYdFPmaqxMIGHTWikS15+EzrLzrrOD73kZzwaRdJh4lr4DmzGGGMiyaExxid2sZpZSGU0OPGJ6UYYQQuagvDzbbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(26005)(4326008)(52116002)(8676002)(508600001)(8936002)(66946007)(316002)(38350700002)(956004)(86362001)(5660300002)(4744005)(36916002)(66556008)(2906002)(66476007)(6916009)(55016002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HUlWBe/gAVW2uftwPdYb/A1V+mcBv0ek2pOks3WbSOXGbiCNxEujlozrgmqO?=
 =?us-ascii?Q?5dEovS1hnQNc5CQGYHwn3YPcAKoBIYWUbVjYutEBRf3BKOdT5XB3MukJ0loE?=
 =?us-ascii?Q?GVPRwAzvxYuw6CRGKj9BzYe0mveg9CFJ9X9NweC8OIIxQi88NLpigeV2rS8C?=
 =?us-ascii?Q?2cQK1ExHqzMoj0/QgfkIp5NA2xwHLmH08b2AoMJLVXiAUHprGNLti6HJIyVo?=
 =?us-ascii?Q?VEQu9F364G4t/VLwWNH4OdFzNPc2/YaeOKhQSFSE+T9p5q+ccNUy55LhSomn?=
 =?us-ascii?Q?bctwKeVRENE535sDoJq2l7G3UOmxxnoW15HYPUwcrfWftBzEIkF0Xtf3Sh9N?=
 =?us-ascii?Q?iQnwgj0hE6eryEbliqPLlH0D/aqEN+u9YNkpjs8M6ldneehk/GNxP2bZFukh?=
 =?us-ascii?Q?aRGtmQaaHjpAXxSDbAhO6vLLz4kikNjAHnmy64ky1bk7E9npIp6fl+Yq0j53?=
 =?us-ascii?Q?npcbxJs+7JMA65zhQ10loH/KY4H98CtdNryeXeC4OZiQkJDvDoQpMfJDRvO7?=
 =?us-ascii?Q?NEfdou0Rl2NwpVbD+P6jFdqlF9xKqPtBu4MZnMux4botgeo1KGBXe+egSqko?=
 =?us-ascii?Q?Bp1BXX0529ZdTCNjlPgH2k24HLMx2Mn1pxFuuKVsyj19PoqLyCEFKFCXHvq3?=
 =?us-ascii?Q?+YYses2fjmKYf7QU4WDJhWUh7L/lBsf5yQliIMMovG/UfCBuUrOnOhi/fp0g?=
 =?us-ascii?Q?1FJHHf7M/I3eY14s5287lwEICGUEmwlDV1jKtaR6EF08F2LJQltllspI7/S8?=
 =?us-ascii?Q?r5Wfzes2kLVztK2cOT9GV+en+oLgttjEDZyJwgvmurZQ0nQo+P18GvzK+n0h?=
 =?us-ascii?Q?949RQlVH5TIUhtp+NN1yzWErl9apw/pagzTJMhXgQRbKiZ0jXL5kajcFwP0L?=
 =?us-ascii?Q?iuhVIfOFw3hj7xOGqr7eQg7lJH5x/doc06p/G86iirbXfBmaN/XbMz9+caS+?=
 =?us-ascii?Q?BCCySwOq+/1Ti2sYl8PTlB2Pm25+BuszmJ5mhx8nuOaKfpu5PCMuCInI6oZh?=
 =?us-ascii?Q?TivB+0XpwHLYkCDXqPF9r7//PhR+Mg9Iin1gndQ1gJemPB6yaHLaumhvWRBk?=
 =?us-ascii?Q?NHAfpsEAg/ZYAS4jfvKAND65RF6ix1xg9YkoZDaB3z5HB/KwM+6hmm56vZHY?=
 =?us-ascii?Q?QWiiN4816l3aCcCeNPeGOyq8aBd+cqEGgod/51d+oZ8mff/ZdWMx+FBoNyPO?=
 =?us-ascii?Q?13luV62t9YIbJPpG7PQY4q/4Uxr5tcnoG6uOJn8/DfEKczxFo1/71dEzSfc6?=
 =?us-ascii?Q?t7mPlewZB9vFVByn6Zm4PumG+vfGsNJ340gi8qdEXrmnBNurEQOz05xUWI42?=
 =?us-ascii?Q?EqTdNdd8XXlJblQx+zAEnuU4iwcIM7mib9Ot82hZeTNj3DyIjw9OoHKYvHJ3?=
 =?us-ascii?Q?8J1dv8izsOfmLE4EKyWwPXNB5YMZTlfkgNqOu4SHI8Xac4p8nWJEBG6JIKBT?=
 =?us-ascii?Q?OnShQxOH0oue5A/4EjSCN6RcVBUC4gHHv2fN9SwZUAucsVz1uHXlf/p0xie0?=
 =?us-ascii?Q?JvGH/5l5dVrf/IDGveIsNWwXEPCjs8dCrQddvl6c1EyPRYIJdZyC/WEck5kL?=
 =?us-ascii?Q?yjGpmL6YdLWHM1SwYaEH+M57a7qwtUYB5S52Nf33CB17PWqlcJFcp+iZ5BA+?=
 =?us-ascii?Q?yX7nXX+Rn5y84zzOcAsdnMuvjKTSM5I5jKBXwaMLimI0QTbbCh91Ox2Zg/x4?=
 =?us-ascii?Q?amq3oA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd572c9a-6e07-4f18-d47b-08d999c11fcf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 03:14:59.2332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NozLa2LI5RGxhVqjvvkCERX+aAHMSozB5JeCw4NS+b8w6ohV3i6+Gl9GV69slkVsXUTfNok92Oq8GN6HYxbGoILxA2Mc859zfVw1PoHkOcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110280013
X-Proofpoint-ORIG-GUID: 0f4dYrRpb4-KZKSQuV5CAZr3nA1wE2rl
X-Proofpoint-GUID: 0f4dYrRpb4-KZKSQuV5CAZr3nA1wE2rl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub,

> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.

No objections from me although I sincerely doubt anybody is using
mptlan.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
