Return-Path: <netdev+bounces-1767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6946FF175
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E130C2813BF
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4B819E4E;
	Thu, 11 May 2023 12:23:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D9565B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:23:09 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on20718.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::718])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294F244A9;
	Thu, 11 May 2023 05:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePGHPjy5B7sSk9fyC7P+e6ZJbDdbsOEDaEweXAMzKx3pHMxDm1OjLwFpTJxBbPEp8/3yyYEQYpVvDhCNpiZS7HZwbL99CwbURhDXWUMOhqrR/XQ86e8lgw8riGXwyUxyzQPCF9cxndIhYkLNE5YPX6E+g5fOzDa25CeDbnj61bDCK7qsAfplWOiWtGgE+Qdh5qZHQmUtAdJGdhV4HOOeFjfBQ4/X/zXUn2MbJfv2PRASB20lbHsHeGuMrm98wvqrsbYmdcs7vIsTpc4DrJdvmXaZHfj7UxWhIgRLodWAoiyCwIWyzrC43PUtZLkAs97dqUMa9oIXqdfWjlCzd7Ay+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWrqtm00AdIip3aeQjkLl0apfu3s4Hp10QGr06kiYCk=;
 b=JuWrJG8g18vtDegcT8ttmzIg8LRGWmhvwrk15i4BA5qOS7dONKM2lZQ3p09/Vd1ahfncI9JMBKPpC/i8f/kL801eQlR/2XrNxrBJxHNwPPa+2Ou24sNKbxVIHC6KIK1Lf+OkwnRdq2bksx1rXNXMmUHrOUbpjBS9MTPoQqwveWDKdOrRYxKiK3wgvYzil2r0M/uIrUwKcdr3Xmybxj9vAQJuVjXeVkjOftCTfwmVhnEXAcrkdXFWRjyMsodTpB/xHG0ZSiL06EMhDJ+E+4YBTLGhY49lk5XtTkF7FYGnvSvdJeGXeW33xnnO2R72FxzR67o8fafrAAzNFGIu+dbHhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWrqtm00AdIip3aeQjkLl0apfu3s4Hp10QGr06kiYCk=;
 b=k50HWkXuWEA2hfbBlieX/EdXNRaJEf66hx2bPEUwWGfZe9d6VUSI3kEU1d3izjQNXqHgvTDL4cutZHRWL5rjXez4O7L1r3mpVNnig3Klk4dJRhDAxTmHOtorIUyPtqnqnBrhf55HaRI0Dizb6trt/6X8AKbuCKHiIhEMjtZ+6fU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5496.namprd13.prod.outlook.com (2603:10b6:510:12b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 12:23:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 12:23:03 +0000
Date: Thu, 11 May 2023 14:22:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH net] MAINTAINERS: don't CC docs@ for netlink spec changes
Message-ID: <ZFzeIJh93H7rql6I@corigine.com>
References: <20230511014339.906663-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511014339.906663-1-kuba@kernel.org>
X-ClientProxiedBy: AM9P193CA0020.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5496:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e6d1f6e-b204-4116-8292-08db521a7798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K2heDcwvz4ZvmFC67nThRHa5nRb9KHwSzRxM4SK9CkxSA5i0wWpsCneIn9wZWaK7ywX3qKib1mWnCQtSOf4GqTAwBHe6vATZ4RgSEoDHWrRqe1XgmtP/Un4Tet1WgXAIue5MvQy9s790pyShoGnSUqaG2QENV1SaI5TLv00Sw2X+zGuJsXN6uzs+yjOpZ3mX+FOeCRoA1jdKgiD2hjdWYmGbNKk+A5JtUz4s2Gw1t4GsGSS10UJr0q5dtH8u+cyukP9xL2Q5npgUaw7EnR7+sTwmDX5vV1HhN4eVeNtGTCG2ytDbbY00xFpTXogtMn4kewR1Iq6WS4i5elR5uDo8gn6RvxJNriCsnqx9yfKIrrID2nMDhbH8XJHne0DGVEcF/JLfOzYxLlGEdNE5xgTOfP1MIohmLL0W5zqnkIqEnUyS+Z/RoU0r9D75I8teK63NFTT7eAzJfGzX3hHuRzHflBbHh5LR2PscBmOQ2VfQL10w4CdNg6ayJMuewJRupCellNXjMwc2HbYBgc09IjpcmEAFdTdlMAbRDTPBOUAUsaOzByVbWZ/76wHlS5RWM5c3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199021)(41300700001)(38100700002)(478600001)(6666004)(6486002)(44832011)(36756003)(86362001)(186003)(6506007)(6512007)(66946007)(4326008)(66556008)(66476007)(6916009)(316002)(8936002)(2616005)(8676002)(2906002)(4744005)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G0iDNSSSTEpVOvjLowVNh2zQ6WnSyOKk7C3BsbtKR03bHCQRm2BwzoRnUa8r?=
 =?us-ascii?Q?dTH1m4j0opjviewOCpfrUuuiCvF0FA23QFC6CijkQGzx0/6PMAy2bZ6yG5Gw?=
 =?us-ascii?Q?m0/V0yqsfKhijkyxr6jqfOvIU/sHwRjD0cnpkf+RaoFN8IZZJN6zP2/xgr+2?=
 =?us-ascii?Q?VVvwab9GG7nyMugVOaO/455CVbkTD9hoFifIHSVytP1+rOYf/6KIrrwtRyJN?=
 =?us-ascii?Q?VNb/JbsUXWnLxa47L2utEGKfdU9jTal9km7Tfhm1lvPuFzSeJvQnP5MoKfC4?=
 =?us-ascii?Q?ecTfKfUBovQSMBINLsEEG+Wtq7b1OGOggHqu8b9orx0WRTFQsNZCvyFEa0SD?=
 =?us-ascii?Q?15i6C0NxRCHyc599Jb22cRH8SqLGysE1Hzd0h3NuifjVvAIT4ZpULF63+J1p?=
 =?us-ascii?Q?5SXASz0+iwkfMBmm1AqKMDsK4jcsyRYlCvWAxgzClWbQpdXWIqn8Tqc0+h23?=
 =?us-ascii?Q?SyEcsxqeME1DhwDeKqNWgTruE/s7h12+v4VcKW3J14HCJQT/tBtLlPDiEY9n?=
 =?us-ascii?Q?DVLVeuDTy05RtiguibgV5JdthWu7oYZZ3butLDltsPzTzFuoXECFBatUEA/A?=
 =?us-ascii?Q?w+C2Ax6PvKXlQETmwQP8tHoNFG3WOw7loYKsBuKfHaFTBXQwfEF162jzTqJv?=
 =?us-ascii?Q?jKVJyNvjhQKLbl/hWWuKs9LZLBYdS1d3+lYVJQHD8iegQNaOocvEWbhU/ZZd?=
 =?us-ascii?Q?LCyGj4/SNPo5s3wWxU+gbh/U31HPZa+InHj0D8pgCcrhLiNluU8/a7GrjWeq?=
 =?us-ascii?Q?Y+SJU7FKfYHmzbtsBBxZ7A6HCkfUPnHZgY+tyW1l+3uKPhv+fNR6q5bB60aA?=
 =?us-ascii?Q?uvSjXkV8bIOVpmOp2BA+ZgYIOafTxNM6RzU/sX/nevYRPES6JHAsSfjXuSd9?=
 =?us-ascii?Q?W74rifFDEl5C0AkGOtoJJ19U9a+Yh6BA8QZ+OqrMuvMvDJR1Uni8reDeQdwU?=
 =?us-ascii?Q?TKXUqlWQpNFJNScUNXnq1f802UBE+FaJ3/BNDIp+/U1EHLr3veOIEVv+yao3?=
 =?us-ascii?Q?tIeDupPfyTrrRenunweOwdw6XbYYTJ6Ou5tDrZCSNDaOqglgRfy/mVcfwrOq?=
 =?us-ascii?Q?I8jes2c+rza3Yqcmq0hmvSvMzW721N3sgADi9pmiLPaYjWaSXM7MFdzO6z79?=
 =?us-ascii?Q?shYJiwtsvm4HlvM1ToKku9+ibBBJjcWB8Fvgos0MEWSgpv7bAhmgdmxnV2eN?=
 =?us-ascii?Q?QaE4Xo2Id+1BM7UDSJ4FHNdVXez64cQ9Uf/wvTqUsHy5H1+vKgOm8iYQ2Co5?=
 =?us-ascii?Q?glMDZrZHHSzIi/jZt5oUIKwOhuP3NhKb2n9NJPSxsnGVPFj9MB2yceK0FZ16?=
 =?us-ascii?Q?hKmfupYly5CRiGUzL3doHc0UUbJlpaxRBICyGKrssk2oELs3UMsWS2y+iMea?=
 =?us-ascii?Q?4wG+iKdnwPn2JSyaDCMbHXSVcTiUgq97gaZiaH0Jn2kvIduvqY7T92U2+EeJ?=
 =?us-ascii?Q?2YuWks/iWXEcOZl1ncZL3o0uFxJdT0+DTE09NHBJHi8SZYtuqKVtyY/6jUaM?=
 =?us-ascii?Q?Ie0R3OKrJK5+6OYWwoDMycRkhTKXDPDhXpTXDkDG3CSpsQgvQxG09uRzmL9p?=
 =?us-ascii?Q?Mq2sEVsDw6k5slugkZObIacj3g0kJYWHPWUi63s1urwL/8DPlE55PI/HGocG?=
 =?us-ascii?Q?0O+oTTdX7HeAeignscvnnGxoQVnh7IMg4K8MYYvP4DnJn0jKe7cFCtKobiGe?=
 =?us-ascii?Q?gFTODA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6d1f6e-b204-4116-8292-08db521a7798
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:23:03.3624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JIAfSjg0gGDzR9ixFc0c0pEt7TToZSB4watFdnzbmu2DnbipONKR3Y2tmVi5+mV+Z2knb8VErzGrk3EMNGqAZ6rRjT9AtCSpWq3V31fmxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5496
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 06:43:39PM -0700, Jakub Kicinski wrote:
> Documentation/netlink/ contains machine-readable protocol
> specs in YAML. Those are much like device tree bindings,
> no point CCing docs@ for the changes.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


