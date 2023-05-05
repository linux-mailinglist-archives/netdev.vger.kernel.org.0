Return-Path: <netdev+bounces-573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF1D66F83A6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88A2D28104A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4718BE0;
	Fri,  5 May 2023 13:16:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AC8156CD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:16:09 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2107.outbound.protection.outlook.com [40.107.94.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB331F485
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:16:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O25Btbi+pYhhREet/WQq1GIYAMGfLy3lPuhSETWbhAvObIIpRFvGqJEjVqqoVsY0IiLWl/tu3jSmnzkxQ1n5TINjz1SCYhkU5c5LBUrSEYUQxPDbgSLIEqkZ3gzdcvEtqGyCkCP+5tPehYDJgAlfgZGpmpRByWsdfJZnrpjZp+v+C5v7qpRCCoA0Sp4/eKwUQA3hwW2sVJ+kq8TARMafR06ru1TQslrZ/iwwPTnbc+Pn8fS9faYph+f6KTSa72oz4WwNV34vLIjZw3xA1jbfNPKWMWZo+wx4rho2L5bSmHLgp6xwwqrvrM7JXYHU6leS3v8qLUlk9K/SAUO9qJOptQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62fAtVln8tySjLUjN05ku5t+a2fg6+WG7ZkF4OoQPgs=;
 b=IxGh2FtPz+M3pAX8LFbOP8kp8+qe34rPBFAEYGj8V3PvKrGZ9316BCXzSzyLysj3L9VQI1RxH3e9ywOA2siNQ5bvhAbmMh9SI7p5CQDXCY1moJ14mJIAOnBs/RY4tQq7Vt7tsQyCtzOddmBa1ObPWSkuPembJdIE+4l5XtXOGjSqxsli6JitrBzFUPpkRd0C79tKCwewX6R4ZVxYTQ+nTN4joKwjCOZVzvkAkA4O50oE8mk31S8oSPutEBPB++OHV0AccHP8Q/u6XoxGdsDgoX7BU/HTKiO/lnzV9b9hxSZl2jQnIk2ZhMdX5+gIO5g/sf0BjnKFJM8YPzR6v80C/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62fAtVln8tySjLUjN05ku5t+a2fg6+WG7ZkF4OoQPgs=;
 b=iwZaGgd+alihfp3UT/jaXf02T6PpBcBci7MzceOW8xFGDmT+6ljsGTTEh7viSliMxj1tvn3ZvUHdmtsHXB6/EnzZpi5ZSN7eZvBPNmAeIvS6zdamZyzeAVtVCBi963O5oNMDcHmLH21qmcBguAqI+tixtDGhIZLjAtT7HQcMHDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4555.namprd13.prod.outlook.com (2603:10b6:610:61::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 5 May
 2023 13:16:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 13:16:02 +0000
Date: Fri, 5 May 2023 15:15:57 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 4/5] net/handshake: handshake_genl_notify() shouldn't
 ignore @flags
Message-ID: <ZFUBjfv1fgPB0ECz@corigine.com>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
 <168321394845.16695.3852024361115547230.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168321394845.16695.3852024361115547230.stgit@oracle-102.nfsv4bat.org>
X-ClientProxiedBy: AS4P251CA0007.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d4dd88-a147-47ba-d274-08db4d6ae03f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ml6a3CIhfJLIcAbB6QGLUk+92ejGqCPeN3ZAlZXb1Yi+7Dl4mcS36ePkKoDMBERQiMND/wirCH9p0QMexqKDe9SpwUw6gYfBUuPlRMmoc6K6oPQPqF7JPGH4Bw+PbVKX3uPF0HY/O+D9Lm0I0Qv3NBTxZ9hJw2n3THMGDUZbA25EKsnRotqPn+9JEtf8aWjrCZ3QAKf2hvp8sRStaW4Fts1CSwKScBY323gLHjptkT7eaAC/9NLjObWvbKtdju0gxkDLZPyp0XhOKsynkzva4BL8pJIMxqEWohZWD24a8I3COc9/7oAi1COG9AekAkLf55SxqZn2GdsSee8SVm304fjsieR+pFNdhPzVhBTpN7RBZttQl+ytKfJNdFNrcUGn0YkhKgbDhTaHVRnbssGP32A56yC8yHhiXu9VsxlZRIuOOwSG9WFD6NsBMIjwh7uFM9di8+CArNVitTDCyebusVXTZEhcqzixLWfQolCik4nZek3Jicxqr2UGDqlU+kHVu0fo0Fu3THPqj8ruY72NTMgm/6HOZnkcHugAedSccaQOe2fEF2s+ZXqAKbxzkvCV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(376002)(346002)(136003)(451199021)(2616005)(36756003)(6512007)(8676002)(41300700001)(6506007)(6486002)(6666004)(186003)(83380400001)(8936002)(66476007)(66556008)(66946007)(478600001)(316002)(4326008)(6916009)(86362001)(5660300002)(44832011)(38100700002)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VHmWBWddVUt4KLElq6yDT6i+yS5RQg4z7nBaGV2qlNG0B1N++PCkIiePPFgY?=
 =?us-ascii?Q?CxPlCMMS9X8h0pwRdgEQ7IHeVKXp6D6Zu2I2LMr2PRt/57lll2+IQChByh8c?=
 =?us-ascii?Q?ZwB79tHYVUpChNkhk3rYarWHkXPAy8hLij5WEE3abW6JN0iYlKgpjxIu+7OU?=
 =?us-ascii?Q?8A9cKd3M0lmSIDs26xviOPt/XOVQztoJM3h5XlEXinmv9bguynUKkp/HM0FO?=
 =?us-ascii?Q?v+QXkw54uBkpURUbBSIopuhuliBTSlCa5llmYDpE8okTsy1LtTlPCtsSQcmb?=
 =?us-ascii?Q?rto+tL153AF4PlfWmwAJFXngpGcFmy5TIzrJe47L+xt6RqysgHWPx6jE6bWQ?=
 =?us-ascii?Q?VwaYK0z7wJeuuh6Y5QjMMHYO0OtDU3JNM3mgCOqcwDeNqrNYBeTXKrgXw9Hn?=
 =?us-ascii?Q?5p748R8cfBcbHVq6qfzK77C+lNAtHGhM4uhP2VozYiR4w2FdHaH/dGID4rLa?=
 =?us-ascii?Q?LZXGyoQZXasQEAJynQBEkiagm6JycAR4FzGXkKFVOlywYRU8On8e1f3AwX9w?=
 =?us-ascii?Q?xHvC8JMni2dkwxzPnoY2DnFso8BH1j93wCActwFoSkjmGonUE8t2fAwwviHJ?=
 =?us-ascii?Q?FnImpFwUgWkVfWRfCv9RRhUDgZufPrLM/pWKliMtYlI1D/yiY8dd6melmP7A?=
 =?us-ascii?Q?ilZx3DiFnwrWxubzNEJ8r9UYwid4yU0TOT1tiIpOUaIawAsMmsLhhx3ByVHm?=
 =?us-ascii?Q?IBfLVvNEISa4awjDbg3BtitxbJ9SBjqbcg9ugC0K3BvLKJANi9BJqisjhZiR?=
 =?us-ascii?Q?htKdFuC90POHJWZ/bWC3OxHiI0kAf5kcdNxwvgWGA9GqyHRWA/yVJ3gGlJOG?=
 =?us-ascii?Q?US6vjb3NiwCz8cF8ioFMtYmGVKgTyOUrHyCmUVQXKdC068EBrpsE/EZGH5DH?=
 =?us-ascii?Q?ucZhqHhX2WfwJVE4J1cgH4kQOQZJfC3Z7Tc99vcItEf4ZZT+kBcVyXvTbrBM?=
 =?us-ascii?Q?pQ3jZKUC3N8hzhnxdmMHP5aYMwGJoURw9dSNfOBq5dsRw7ggHL6jP6BVtGUP?=
 =?us-ascii?Q?Z9T5RIYh2scomzG193C1TyHRoLZaKnvx0aFXBn8Ly6SuObSENk9+a0c/eGIW?=
 =?us-ascii?Q?OahhUtUKzJQV9Ly+VcKvZJQhvbx41bu6/f+3k5C2Ec/ePwTxcGXiUs2WMyFL?=
 =?us-ascii?Q?5WXqoMMU+nUNN4MzxH8VlgieG0VRDsIRshspWV6zs04W6zDGIroo06HyiZWp?=
 =?us-ascii?Q?lejUwK3ulgUU9WxD7F8VmAO4B+swpGjtk56T9rF+9w74+Iz/N5ND0GzJlXLO?=
 =?us-ascii?Q?wL4Kkmk6DV+3O6fkho7WlV/ykiouNhyYiP/HiIxAtuvdJEy/V5P0MwDk4hUZ?=
 =?us-ascii?Q?pb0Pe6ncQP4uwJRqv9YuaEubAHDUtnb63LsZ7M6QIPd6K1GvzwmIG4jzoV+A?=
 =?us-ascii?Q?M9OoJd3LU2nuIjk0gsXUgiufyNEe/8epax/rvoM1YMuyu9rT4HuHNrZu/3Mk?=
 =?us-ascii?Q?6pVgslfeYxN5r/JjS4KjJUpNvNMOaKJrczQOigTswLoVLXE+AJAEtU6didGe?=
 =?us-ascii?Q?EedMR6NbUZ27k9JhDEfzTb+MgJlqEUoFH+rIwlmB5Vg56NqFyyesCgh40emZ?=
 =?us-ascii?Q?CYjSxVEeJE8Tf5ZROw3Nug8vZ1PQXdlOH5PdG2GbnvkZQZOFAKLI/lJAtrU9?=
 =?us-ascii?Q?xCaPL9XBrfPAA8L/WZ/Zn7qY3MC8MkzuBlRrMrHhau7W4hlLlCn9MYN4Hg7F?=
 =?us-ascii?Q?ir1Jog=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d4dd88-a147-47ba-d274-08db4d6ae03f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 13:16:02.8651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKi28ZeYXg4MIGZ6IZB8MAGulTv9lvif0VNueYcKdg+Ey+9Sa8VA9QVL2tZ6QWIgyawMmnrY/vj5zMLdV/Ek5frdSQJHLHb56ZE51Nd9K0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4555
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 11:25:58AM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


