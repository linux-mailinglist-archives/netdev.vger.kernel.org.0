Return-Path: <netdev+bounces-7222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF86A71F193
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EAE628189D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B08DA48254;
	Thu,  1 Jun 2023 18:19:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968B847017
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:19:41 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739F5E7;
	Thu,  1 Jun 2023 11:19:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E43G3021715;
	Thu, 1 Jun 2023 18:14:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=mef4M0RWz5T7Pw5cWqcMkp8JSwQNIW/qmbnYuD/GolI=;
 b=K/rxKvSNGg1ovV4IiLFf48HXA77yiglS9TXxJqB5AQEEsf2jMp214XVwnuyiYfyPALNf
 h44RkiW4Q8+H/+H/wabTlWgRal9/bk+Ct6jM8PIEE8nsmiMdBjy+TQ73xECu/rVwFO0q
 hgdCI/UhR08/AYNCQrNUJSQAPuvYIWU/Jvrr74lD8s8bz8ku61MfKeaF3ODAFf1qS5Gb
 9SbY+ANDYiF9ZQMH/TE2/wPv+496nJ8nSkcEN4jYX7v/GUFBVUwBBm+r/yzXNsQ3MrBG
 El/gXTxm9sGafCYo1yWRjyMQm4PmhFH/9kS69bVmKQOWcv1mq4N7FfJ/J20lxnTQQIcf 6Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwhaf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 18:14:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351H495O026017;
	Thu, 1 Jun 2023 18:14:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8ae4fcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 18:14:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9qZfDiUqVXITyk1yQJRNDKFbLcWANTZCrsH0KouuZTFa5iNAn43kMjin6TMxyjy9cVAUztUC1gucKZYG86IGcV9e2dwz8RXdGSqrzImiMJD4XKluyfDJmVKetRZctaZ1Yvfb64avIdyXxVFHIEoaWAe6zGyceDhme+U7JBvRpkzJ1JScQk72hW49Fxu964i08o4wInBZyFrZCETHCC7IC4AWqS46CuVOGdH3brLNnVBugmOqyYVx8SX+bfPoR9xo1zkSZlqrxUrLN3NdwV94iE2lSNbQLtcMgSluvi9MQMsz/iuHIKCz9gT2RVpt+JibuFwnAkxFqhkViAOPHgDZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mef4M0RWz5T7Pw5cWqcMkp8JSwQNIW/qmbnYuD/GolI=;
 b=bbv0XTAQzqbgAscFV3dlrsIk63rJc0dlGCYPnJipWaGA1TkTQ5+gqNUGmPxXqYvo4zCJSBmM2DZq3NM5ApZQZhpznzA0F1tf4qmCWKj/Db7naQgNfzEEz3c2nHB6qWjzON4X/0/OD1SgPQ6xhfra/NgVpiPzxrITlvb53ScQtfKHoo7bsXU67+wLzsVFtTVUniT8fGXgWYh/JQjVsWSHjSy5lEJWwksk/0F3IIRBmAD8U04yKs9WjfiqQgk5qySNy8sgo9QD0pYNUUwaufdF7wUgCoXRkU6VPa6wKPDiuCCbVhmJJsuEsLgle82ZcWMeGuytAvQtX1el/KIgBy/gUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mef4M0RWz5T7Pw5cWqcMkp8JSwQNIW/qmbnYuD/GolI=;
 b=JzuT0X/I1FYboXotRDoXe2ww+bJE+OBq5kXbxOl21ZlkbMTpPY5+l8cRP36FG3ykf0LOprRI8vlOGiMP8HMKv3JB8Bi6BCYaVH0FaFu+xeJ5F3UfuPvCYr6upF0HVkgeUy06WwRNkzZNTWw7l7Ze2JkSVX7XwXFfe7dk+yMCFxc=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by IA1PR10MB7213.namprd10.prod.outlook.com (2603:10b6:208:3f2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 18:14:08 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d%7]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 18:14:08 +0000
Date: Thu, 1 Jun 2023 14:14:05 -0400
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: davem@davemloft.net, david@fries.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org,
        keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 5/6] connector/cn_proc: Performance improvements
Message-ID: <20230601181405.lvybxlzvf4w5czx4@revolver>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
 <20230420202709.3207243-6-anjali.k.kulkarni@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420202709.3207243-6-anjali.k.kulkarni@oracle.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT3PR01CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::16) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|IA1PR10MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 23cb3877-7830-4426-8978-08db62cbfdf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	6dsNHbvNadbn9lvk3IV/vaN4cnWbL8dyiz/5bWQCcA+ZVAaaCuflfycsuwHjGA0iGybx2BSDptOtznX37scQ2H7XlmsDg3rm2zhmOogqNT4sVoa7mlrHoSt2ZFTd7VCGPChoyKyW4d0NyPUKcAYFx2rwl7hpffLpI6fPbnnppc+asuj4+OV9BGdWWi4RmC16p/+cdGOrQxPIQAwSN6YEK0QumQT5aTRHa03KM5e9HWojpTkhhhh+8tPV5TAlllzuPfZt1MTxL7btmEUWrTWr05GOwV4JNO51RVBTTyHrOELGaF7RupHCvpnuZEARUG5/GpkQeB0y0DDbH81l10IgIVSzb/gvvLGQXBa0KjiAhyHdNbfv92zxpGZUsVMN4nVe1nAmWfMsIOX51sfHlbckWjMpDHS0fed6DZEebmAUv8I49BZMwoywIK3e5lqrWQFYvpttt/HbnRECFKiWeDOVQ1aVZr0J1GiEXa+trT7BZ6WvLkf4H2xS5A8CQ+je8ymvosQ5B5XarFmSvtO478qdEskAHAyqC7saP2VxXpTtK7a+lZM3ZWWAQmNslYUdzClS
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199021)(2906002)(83380400001)(30864003)(86362001)(33716001)(38100700002)(8936002)(6862004)(6486002)(8676002)(41300700001)(5660300002)(478600001)(66556008)(1076003)(6636002)(4326008)(66946007)(66476007)(7416002)(26005)(316002)(6512007)(6666004)(186003)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?mcqd7BaP9X8yeiz6C0Gyjzmt6FfYixmHYNnIfIYvzqIu6Cgc5c60pGKMzNQE?=
 =?us-ascii?Q?hkqlLVQbjCSJ+YP9GN3WdGP5QprY9OtmpulQHK/m38Dtd+U1FvtCRVl8hGj1?=
 =?us-ascii?Q?vaL1bcrzyNByqtd+zhLyfDVASWKXvh08ZEaWJCcVbJb9yPXPogE8/dxoWzuN?=
 =?us-ascii?Q?Aps1aBrlWKe0xL4f3Kc5j4uyHU0glS+X3R8WkYeFLYeyd6lieUViV8m5jnXI?=
 =?us-ascii?Q?qNwWwkii6nrDnl1BVKOtEOBqw5TWfclawdw0EzK+BJsGFZgI69yZmhpy7Jbt?=
 =?us-ascii?Q?YbIH7oacXKfGWQOw6s+uxl3bTyZkyyZ3bWkA7Ssw8na2/reTYoF87r3agIzI?=
 =?us-ascii?Q?rF8Y1kR8YNPmUXJlNV2q9Tfj2qGWliiITE0noUp8+8rvxZZuaMPq6N5KOoLv?=
 =?us-ascii?Q?LVV75M6yR51C+9xUIE1ypP5btB9rP8KtabNF1jZptexcE0fUFtS9Af4kGpYQ?=
 =?us-ascii?Q?yD9nrHn+6Qbs38BlLJa5Ekv5QBx7t8lP0Jx3MH2abKNua5+KsR8MdfINNc+O?=
 =?us-ascii?Q?RAAUY4Z/bD7b+0RRD8rZIhAGbt+U6uFDbD66MwP+p9eE0FE/ITSceDFJEgL8?=
 =?us-ascii?Q?kPCX7dXumW2pwT55XiZ/BCjjglApupKFvjrkzEzJJtR0bW6ebONfWnFlDqct?=
 =?us-ascii?Q?L7d+0888qSKpIuVzDc6tDTanv0CR03QHSJpmQfg3bV2NYlXOlPzVEOv4xfl1?=
 =?us-ascii?Q?dfsdla8fDvkQ5uG5SN2cdshl7uhwUSVwkzBTGYBXqiRkKpPS9xJ02TLNfpj3?=
 =?us-ascii?Q?ajEmnu201pEY/RSybUujDm2xoyn22E0l2pK0VJlkS9fbu0r9cBUu9y4b44nO?=
 =?us-ascii?Q?n7Jm+E/LFpmtyYmxbe5XOxXl1qjg+HN+ZMXXWK1/Rc8p3ZWaJma8AnSCtOnz?=
 =?us-ascii?Q?lMukCcEFc0nihIxNZWEDtF+j7yGp/sSKgMVk0uKHAJlLTcbneqbMhYVEaWHX?=
 =?us-ascii?Q?8R+VZ01AK66uibFXduHLBTP3SoMyw/K2eq1+GzdFbsOGUnqKHK7YZbgwgj92?=
 =?us-ascii?Q?ONkn/SXkbKTDMc4ntXC5FJD8q6VYtIQ+2OF3U5RoXl9ZUGOwOnRn9Q8YfTyt?=
 =?us-ascii?Q?+9la3Sbgek4putWS+fw2OHoYxgyTBZP1muS1QPIawGx9P65S6Oz0zbtfcRgh?=
 =?us-ascii?Q?NCJrxfIww+onrB+MwbUYcSMibFD3PtR1kCLOptiYmzxhxWaES2t8K3lJmA2+?=
 =?us-ascii?Q?co0cjegytxTGnFSyIRSqsVa3PNtEL7y11rTHO/4k8hZlvA4ZPXDaYtmTd18s?=
 =?us-ascii?Q?iRBtFFGn4HVS6nq0DDt8DQqVsXpBffcPZJacwLN5KZ9Wt0UPzWjjehEbhz20?=
 =?us-ascii?Q?QfWSBljymJZhXYGYMFL29IZfMUCSYvYVgIo7Fx6jmKwDahYjLzJIuOi+X0bg?=
 =?us-ascii?Q?+as8J0WeKtLk6xDFKvZgH6h0PPWqkE56r4zObxsHGNPbbh75nAOtcEF3h4ER?=
 =?us-ascii?Q?Kd3yr6I6m1UyvWfqb4QztuOmGP08QPyvaSBbmXHJL8z/Pfbw+bw0gf2Qdqzl?=
 =?us-ascii?Q?l8scGEVSCxvs4aVIDUc0SYL8LhFB+7UjFae8/bF3GUwnSZciueaLWs43cuBy?=
 =?us-ascii?Q?527d/X0JJ8Mrj8XnqEjwZBV/wM9z5AS+FZGXBk9TTYiEIdMq0JLOEzaMphF8?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?rr8JZ6GqDMyZvJu4NEeL52/uDfQI43QJ0bEFkFzxwjThDiKuR5Nko7f/lWwT?=
 =?us-ascii?Q?/MdMGjKzPB0PdojO8C9JSHe254WhJ+enpZo6XP3maKkz4JtbmH29U85+2ApK?=
 =?us-ascii?Q?zSWgeHi+bwsuEhCaqKqvLsfDBNH4mePMIpVzp4HBV4D95GgPBwJBYjqHXikB?=
 =?us-ascii?Q?hybQLTD8j3eP4MI5RvPWfypEx8A3482n1nUDji+oTCxp9uZXlGvtRLIkr7Tw?=
 =?us-ascii?Q?2/aZNB0M/mnGIGieOyTrmD0jErfQaiM5EpMWgI9SkNsQEd0XVzWYFLKwzKdn?=
 =?us-ascii?Q?jFpxgd6CZ6aMh5BOebh+gVUNZedklBX8P3TgwJhLaKM4OCteS1FmBSfZ4hYF?=
 =?us-ascii?Q?gV+w9EfjQrWcwCZKqOhzWyxuA8J5DLo6+ZwyvKdRNgqA4AOf3rKVsw38U9nd?=
 =?us-ascii?Q?gpcJ7gI4YRFeKnpLdQk16EpgulC/yeR2kwIu/FluRN7LLE650jCQtkGxluEh?=
 =?us-ascii?Q?f8AOIHKLHRu4EUKswDIljW/YuOtYZEc3DrvnjELN9VOUTbfwxQgcuTkgJipz?=
 =?us-ascii?Q?E6lLlUw183mM0hwiswkPchpzboiiIyIbRCMkf1sL2QO5yE65OqDf+JaZwNd2?=
 =?us-ascii?Q?bcLOpJMSPH+aghf05X1dfTWk0pr/9YpdnfLqCHmrc2JpZmCjMY00pVDdmGGn?=
 =?us-ascii?Q?c3CQfakI7JF5e4DRnsPiO7uOiR2qAujiWjQ7Gw5GojiNXfmExFb5moisLoDI?=
 =?us-ascii?Q?Bxt9mk6u5fei8dYrTxxTA1d8tT8yzhnFn8828PPwz/c1DRxoz1HlQD2QqIAs?=
 =?us-ascii?Q?W6K5nniZWME8tzz/Sadw0oE5l9ZzktujLaJrbpILx6wXWPHL5dVTgi23L1HW?=
 =?us-ascii?Q?U/XO86iWH+LXyNVbj3ruYJWeA6cAxNU8Gsm2d53AwiICNZ8xfmKnP0lyIHtO?=
 =?us-ascii?Q?et3VxUP+pg5XYVRCPborsqxIthI7JuNDMxNsoWXMCDL2drXcSgW2lx+22g2m?=
 =?us-ascii?Q?BBOE1cMNRyfg5p7TSP7166FpnaFPEjjSsquj8W1S8YuLK4J6wqwRxBlz2zAv?=
 =?us-ascii?Q?2GyNdPutbSL+sAIZeGxfjB4kpN1bGBFK9o5trQpdQpOX0qJFDiLjDk28Vl1m?=
 =?us-ascii?Q?tWJXEn2AbWMaiX+9667nrC6lPgv64ISkkUPmA8wWWgI44/g0n5w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cb3877-7830-4426-8978-08db62cbfdf0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 18:14:08.4234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFHha7GSkkMO/D0TQSas5+J/xWX4Tqa8elmcs88aQV8t7zzc192GVeB0G9Phi1KUP0Z3Zkwi6m4GquhWOrEBFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010157
X-Proofpoint-ORIG-GUID: 35DgSG23fSN1MfXXBe6VFvTn_tW5hGD1
X-Proofpoint-GUID: 35DgSG23fSN1MfXXBe6VFvTn_tW5hGD1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

* Anjali Kulkarni <anjali.k.kulkarni@oracle.com> [691231 23:00]:
> This patch adds the capability to filter messages sent by the proc
> connector on the event type supplied in the message from the client
> to the connector. The client can register to listen for an event type
> given in struct proc_input.
> 
> This event based filteting will greatly enhance performance - handling
> 8K exits takes about 70ms, whereas 8K-forks + 8K-exits takes about 150ms
> & handling 8K-forks + 8K-exits + 8K-execs takes 200ms. There are currently
> 9 different types of events, and we need to listen to all of them. Also,
> measuring the time using pidfds for monitoring 8K process exits took
> much longer - 200ms, as compared to 70ms using only exit notifications of
> proc connector.
> 
> We also add a new event type - PROC_EVENT_NONZERO_EXIT, which is
> only sent by kernel to a listening application when any process exiting,
> has a non-zero exit status. This will help the clients like Oracle DB,
> where a monitoring process wants notfications for non-zero process exits
> so it can cleanup after them.
> 
> This kind of a new event could also be useful to other applications like
> Google's lmkd daemon, which needs a killed process's exit notification.
> 
> The patch takes care that existing clients using old mechanism of not
> sending the event type work without any changes.
> 
> cn_filter function checks to see if the event type being notified via
> proc connector matches the event type requested by client, before
> sending(matches) or dropping(does not match) a packet.
> 
> The proc_filter.c test file is updated to reflect the new filtering.
> 
> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
> ---
>  drivers/connector/cn_proc.c     | 59 +++++++++++++++++++++++++++++----
>  include/uapi/linux/cn_proc.h    | 19 +++++++++++
>  samples/connector/proc_filter.c | 47 +++++++++++++++++++++++---
>  3 files changed, 115 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index 84f38d2bd4b9..35bec1fd7ee0 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> @@ -50,21 +50,44 @@ static DEFINE_PER_CPU(struct local_event, local_event) = {
>  
>  static int cn_filter(struct sock *dsk, struct sk_buff *skb, void *data)
>  {
> +	uintptr_t val;
> +	__u32 what, exit_code, *ptr;
>  	enum proc_cn_mcast_op mc_op;
>  
> -	if (!dsk)
> +	if (!dsk || !data)
>  		return 0;
>  
> +	ptr = (__u32 *)data;
> +	what = *ptr++;
> +	exit_code = *ptr;
> +	val = ((struct proc_input *)(dsk->sk_user_data))->event_type;
>  	mc_op = ((struct proc_input *)(dsk->sk_user_data))->mcast_op;
>  
>  	if (mc_op == PROC_CN_MCAST_IGNORE)
>  		return 1;
>  
> -	return 0;
> +	if ((__u32)val == PROC_EVENT_ALL)
> +		return 0;
> +	/*
> +	 * Drop packet if we have to report only non-zero exit status
> +	 * (PROC_EVENT_NONZERO_EXIT) and exit status is 0
> +	 */
> +	if (((__u32)val & PROC_EVENT_NONZERO_EXIT) &&
> +	    (what == PROC_EVENT_EXIT)) {
> +		if (exit_code)
> +			return 0;
> +		else
> +			return 1;
> +	}

new line here please.

> +	if ((__u32)val & what)
> +		return 0;

new line here please.

> +	return 1;
>  }
>  
>  static inline void send_msg(struct cn_msg *msg)
>  {
> +	__u32 filter_data[2];
> +
>  	local_lock(&local_event.lock);
>  
>  	msg->seq = __this_cpu_inc_return(local_event.count) - 1;
> @@ -76,8 +99,15 @@ static inline void send_msg(struct cn_msg *msg)
>  	 *
>  	 * If cn_netlink_send() fails, the data is not sent.
>  	 */
> +	filter_data[0] = ((struct proc_event *)msg->data)->what;
> +	if (filter_data[0] == PROC_EVENT_EXIT) {
> +		filter_data[1] =
> +		((struct proc_event *)msg->data)->event_data.exit.exit_code;
> +	} else {
> +		filter_data[1] = 0;
> +	}

new line here please.

>  	cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
> -			     cn_filter, NULL);
> +			     cn_filter, (void *)filter_data);
>  
>  	local_unlock(&local_event.lock);
>  }
> @@ -357,12 +387,15 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
>  
>  /**
>   * cn_proc_mcast_ctl
> - * @data: message sent from userspace via the connector
> + * @msg: message sent from userspace via the connector
> + * @nsp: NETLINK_CB of the client's socket buffer
>   */
>  static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  			      struct netlink_skb_parms *nsp)
>  {
>  	enum proc_cn_mcast_op mc_op = 0, prev_mc_op = 0;
> +	struct proc_input *pinput = NULL;
> +	enum proc_cn_event ev_type = 0;
>  	int err = 0, initial = 0;
>  	struct sock *sk = NULL;
>  
> @@ -381,11 +414,21 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  		goto out;
>  	}
>  
> -	if (msg->len == sizeof(mc_op))
> +	if (msg->len == sizeof(*pinput)) {
> +		pinput = (struct proc_input *)msg->data;
> +		mc_op = pinput->mcast_op;
> +		ev_type = pinput->event_type;
> +	} else if (msg->len == sizeof(mc_op)) {
>  		mc_op = *((enum proc_cn_mcast_op *)msg->data);
> -	else
> +		ev_type = PROC_EVENT_ALL;
> +	} else

if you have a  } else, you should brace the second part:
	} else { ...

>  		return;
>  
> +	ev_type = valid_event((enum proc_cn_event)ev_type);
> +
> +	if (ev_type == PROC_EVENT_NONE)
> +		ev_type = PROC_EVENT_ALL;
> +
>  	if (nsp->sk) {
>  		sk = nsp->sk;
>  		if (sk->sk_user_data == NULL) {
> @@ -396,6 +439,8 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  			prev_mc_op =
>  			((struct proc_input *)(sk->sk_user_data))->mcast_op;
>  		}
> +		((struct proc_input *)(sk->sk_user_data))->event_type =
> +			ev_type;
>  		((struct proc_input *)(sk->sk_user_data))->mcast_op = mc_op;
>  	}
>  
> @@ -407,6 +452,8 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  	case PROC_CN_MCAST_IGNORE:
>  		if (!initial && (prev_mc_op != PROC_CN_MCAST_IGNORE))
>  			atomic_dec(&proc_event_num_listeners);
> +		((struct proc_input *)(sk->sk_user_data))->event_type =
> +			PROC_EVENT_NONE;
>  		break;
>  	default:
>  		err = EINVAL;
> diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h
> index 6a06fb424313..f2afb7cc4926 100644
> --- a/include/uapi/linux/cn_proc.h
> +++ b/include/uapi/linux/cn_proc.h
> @@ -30,6 +30,15 @@ enum proc_cn_mcast_op {
>  	PROC_CN_MCAST_IGNORE = 2
>  };
>  
> +#define PROC_EVENT_ALL (PROC_EVENT_FORK | PROC_EVENT_EXEC | PROC_EVENT_UID |  \
> +			PROC_EVENT_GID | PROC_EVENT_SID | PROC_EVENT_PTRACE | \
> +			PROC_EVENT_COMM | PROC_EVENT_NONZERO_EXIT |           \
> +			PROC_EVENT_COREDUMP | PROC_EVENT_EXIT)
> +
> +/*
> + * If you add an entry in proc_cn_event, make sure you add it in
> + * PROC_EVENT_ALL above as well.
> + */
>  enum proc_cn_event {
>  	/* Use successive bits so the enums can be used to record
>  	 * sets of events as well
> @@ -45,15 +54,25 @@ enum proc_cn_event {
>  	/* "next" should be 0x00000400 */
>  	/* "last" is the last process event: exit,
>  	 * while "next to last" is coredumping event
> +	 * before that is report only if process dies
> +	 * with non-zero exit status
>  	 */
> +	PROC_EVENT_NONZERO_EXIT = 0x20000000,
>  	PROC_EVENT_COREDUMP = 0x40000000,
>  	PROC_EVENT_EXIT = 0x80000000
>  };
>  
>  struct proc_input {
>  	enum proc_cn_mcast_op mcast_op;
> +	enum proc_cn_event event_type;
>  };
>  
> +static inline enum proc_cn_event valid_event(enum proc_cn_event ev_type)
> +{
> +	ev_type &= PROC_EVENT_ALL;
> +	return ev_type;
> +}
> +
>  /*
>   * From the user's point of view, the process
>   * ID is the thread group ID and thread ID is the internal
> diff --git a/samples/connector/proc_filter.c b/samples/connector/proc_filter.c
> index 84e53855c650..e2aab859cc34 100644
> --- a/samples/connector/proc_filter.c
> +++ b/samples/connector/proc_filter.c
> @@ -15,22 +15,33 @@
>  #include <errno.h>
>  #include <signal.h>
>  
> +#define FILTER
> +
> +#ifdef FILTER
> +#define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
> +			 sizeof(struct proc_input))
> +#else
>  #define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
>  			 sizeof(int))
> +#endif
>  
>  #define MAX_EVENTS 1
>  
> +volatile static int interrupted;
> +static int nl_sock, ret_errno, tcount;
> +static struct epoll_event evn;
> +
>  #ifdef ENABLE_PRINTS
>  #define Printf printf
>  #else
>  #define Printf
>  #endif
>  
> -volatile static int interrupted;
> -static int nl_sock, ret_errno, tcount;
> -static struct epoll_event evn;
> -

It's not obvious to me why the above needed to be moved?

> +#ifdef FILTER
> +int send_message(struct proc_input *pinp)
> +#else
>  int send_message(enum proc_cn_mcast_op mcast_op)
> +#endif
>  {
>  	char buff[NL_MESSAGE_SIZE];
>  	struct nlmsghdr *hdr;
> @@ -50,8 +61,14 @@ int send_message(enum proc_cn_mcast_op mcast_op)
>  	msg->ack = 0;
>  	msg->flags = 0;
>  
> +#ifdef FILTER
> +	msg->len = sizeof(struct proc_input);
> +	((struct proc_input *)msg->data)->mcast_op = pinp->mcast_op;
> +	((struct proc_input *)msg->data)->event_type = pinp->event_type;
> +#else
>  	msg->len = sizeof(int);
>  	*(int *)msg->data = mcast_op;
> +#endif
>  
>  	if (send(nl_sock, hdr, hdr->nlmsg_len, 0) == -1) {
>  		ret_errno = errno;
> @@ -61,7 +78,11 @@ int send_message(enum proc_cn_mcast_op mcast_op)
>  	return 0;
>  }
>  
> +#ifdef FILTER
> +int register_proc_netlink(int *efd, struct proc_input *input)
> +#else
>  int register_proc_netlink(int *efd, enum proc_cn_mcast_op mcast_op)
> +#endif
>  {
>  	struct sockaddr_nl sa_nl;
>  	int err = 0, epoll_fd;
> @@ -92,7 +113,11 @@ int register_proc_netlink(int *efd, enum proc_cn_mcast_op mcast_op)
>  		return -2;
>  	}
>  
> +#ifdef FILTER
> +	err = send_message(input);
> +#else
>  	err = send_message(mcast_op);
> +#endif
>  	if (err < 0)
>  		return err;
>  
> @@ -223,10 +248,19 @@ int main(int argc, char *argv[])
>  {
>  	int epoll_fd, err;
>  	struct proc_event proc_ev;
> +#ifdef FILTER
> +	struct proc_input input;
> +#endif
>  
>  	signal(SIGINT, sigint);
>  
> +#ifdef FILTER
> +	input.event_type = PROC_EVENT_NONZERO_EXIT;
> +	input.mcast_op = PROC_CN_MCAST_LISTEN;
> +	err = register_proc_netlink(&epoll_fd, &input);
> +#else
>  	err = register_proc_netlink(&epoll_fd, PROC_CN_MCAST_LISTEN);
> +#endif
>  	if (err < 0) {
>  		if (err == -2)
>  			close(nl_sock);
> @@ -252,7 +286,12 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> +#ifdef FILTER
> +	input.mcast_op = PROC_CN_MCAST_IGNORE;
> +	send_message(&input);
> +#else
>  	send_message(PROC_CN_MCAST_IGNORE);
> +#endif
>  
>  	close(epoll_fd);
>  	close(nl_sock);
> -- 
> 2.40.0
> 

