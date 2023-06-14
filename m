Return-Path: <netdev+bounces-10833-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4AE730711
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1188E1C209A3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096111095C;
	Wed, 14 Jun 2023 18:07:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB6B7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 18:07:12 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20716.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::716])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E82635BF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:06:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKAab0tbe+YAluz5P3GO2xJXSoiyOb4oY10OdWvQ0/DV3JNB4HekfWxo2c6EVhVEdSdgKe6fc7CjaypbH1Z2BjMkMwTZySS3ilx/ebfIlNjltiYO3RrHcGyPhioaOfR5tpeYKpVRu6GbDbGBL8Srh+AozsTyzlV9WU+qWk0Biq7+8CnlVN2zmOqD74erxsRy5e/KA9/wlAffrBc4x74XyboEx44MQH2nebImskvsL4YIhNr8qXNNB6x9mNb4rzDWvbP/ohNCXvcbHqenuzunrg6v++jGGKKc74D19jhjzebL2U2U/AsxX2NeERv8loidHP7nrpbaDfObQR6g5BLIRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usgA1/C2prO08JwXO1SUhID8aKet3bjXJHJ3a+gHot0=;
 b=FOZYt2Mt64/ih4G8cfROIFdJR/iUEhhCYZmANMuqMKQ2NVdMGCadLVZtaSek7JGe5GCownMRZ8Lo8+HLJpkIIFSEvqE2pvnM4fHVj6jv3GYPrUVm/u6apmxF7mYEAVRjO9O/MD4KRdcTVvDH4XzPJO+y4mhLLsewAgS82WkN8Gi3lj3Dts/OC7gFyuw+FYBxEFW1Hvg20TDeVBEW3vGQeIY88cup2d5kvc+J6l65SIXMVrdUCm8bHuMEupcGawnsKw9UFOjPU2631eL+lrYuKQ93iCLdTxPO9VKcBzCdJpZIKiZVxwFmi0iHrzbSEHcOs+2iDQQZ57jYnhpXKcGo3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usgA1/C2prO08JwXO1SUhID8aKet3bjXJHJ3a+gHot0=;
 b=uGoR+XttgkyxvQhDFURUfMD6LWXStzHv693LpL8BlBxQvnBahBacuC7wtyq/jFHnZKg3J45IF6HwoslcM68xCcWWUESxELQeIrmV1gAhgZ9g9TMshiCWMncNvJMzBvktBITTsrUqq2H1bIsknWiJAeH31n15xfwO9gO+TIE+MZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6082.namprd13.prod.outlook.com (2603:10b6:806:353::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 14 Jun
 2023 18:06:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 18:06:06 +0000
Date: Wed, 14 Jun 2023 20:06:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, richardbgobert@gmail.com
Subject: Re: [PATCH net-next] gro: move the tc_ext comparison to a helper
Message-ID: <ZIoBiOQIODCLFYgq@corigine.com>
References: <20230613205105.1996166-1-kuba@kernel.org>
 <ZImxOTT4L1J09wj/@corigine.com>
 <20230614104449.2aa6ac41@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614104449.2aa6ac41@kernel.org>
X-ClientProxiedBy: AS4PR10CA0030.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6082:EE_
X-MS-Office365-Filtering-Correlation-Id: 4776c8c6-8caa-4116-eca0-08db6d0205da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gL/8kzUA0qLNL8IdU7FMk02iSIiF5bdkmGCLzgAab38w1F2j7NaQ+8UD3rbXD3o66uMZf6b75qk/o8YE6N2cne4GloTChpUxVOtp6tbykNy1NGyIBDZKk7D9BKIbW4u7XQDLrndwDHs7Jip1j2An6GxVTK8x0IX3mNDboVnd4i2rHZpdZY2c8ZchC7/NKOg6WNXvwUkQ9FEXe+Fv1QcR6KdWnOWdwz6H4fTFe8abIzMt9dQR/os2W5t3S2Ypgr5v2c9TfFWae70Jo+BJ9Tg77ZXlQYGsLnM9MEoecl/LKuW8DGx53t+VZjoPVi6pPDDvnWNstRbGSeUAU9mdAL8oVcb+fo0f19/H4qoKu5yCUp92pxOEvIPgFC1X55y6mHKpz508UGx+6PfY84pgOTQwl3mKIzIg19XlN8yOErpP4bOXPZCZQvo+t12QglmHtj9hH1Yn51AoqFlud61R2H0P9CchC+UYnMBfWggIlM9oih3Q+nHSBtXlsb3L9arErg9cORvC85gXrBCvjOgyRPaOocDEMmkYwWwgi34KIzo14WW0nYENKu9lk4eVFJZsVfioF43/Yc6fSTgijcnrfq/bqQCEpVrW8OPgCLGN6PtUwkE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(39840400004)(136003)(396003)(451199021)(478600001)(186003)(6506007)(6512007)(86362001)(2616005)(66556008)(4326008)(66476007)(6916009)(38100700002)(316002)(66946007)(6486002)(6666004)(8676002)(8936002)(5660300002)(44832011)(2906002)(4744005)(41300700001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T76ZzuKRmZWXrcznK4Q0qecP9xRWb5HxH6/sGgiY/tQGPDgdh4YuKUFL1mOC?=
 =?us-ascii?Q?qFEZsNZ/nucMtunXKPtpreTJFHDSiy96oOgESQRyUE89tzwdNnx5S0fJ1a5+?=
 =?us-ascii?Q?3qfOufvox0/eoiNs7Rr/Tn2qRQ9k5dDgSE8aGT3NLfkgX1hhNkTKaQYP05Dr?=
 =?us-ascii?Q?9eKIMv50WnTsr4+iGRjIAe3AajwfZhYBrTFiwri49LVenBfqRcZYO9KhGCBb?=
 =?us-ascii?Q?zi20FPL1V9s2kwCagcV0vqhGavJONjU4fijhMwv4GtnftZhNHolvCgq5JuE2?=
 =?us-ascii?Q?j7Kb70kfCW9cs8BqTWdNguULf4xi4tB94bvjzvBd2x07QNHwKTwNWnU+YB8d?=
 =?us-ascii?Q?rbPbS+CRW0vFSP+GI0blRZtWQOUhDInufRoqtJHp8hqJDlozN5gsI+HmuJE4?=
 =?us-ascii?Q?xRO9nVJqwNRU07cOzqarcD/xZhX2uFzLDEdRkwiMlrwFv9uDKH3+vHOmHt2X?=
 =?us-ascii?Q?+BNV+3HcduIKVVe6v2CYzXlDNNODQlnYq7T5oq9dwuCbkYL2kqs2ISl1lfGm?=
 =?us-ascii?Q?TomuNzVIfSjcTqQXmFcS6azMcnf6YSPCcF+AuKN51ODRKH4D0xYQIVbnFt7q?=
 =?us-ascii?Q?f4x8CAt2lIPeWPQwT9ZZuuiqd8cMhJqNXXKRWrVl2y1FmDHNuIdX3Zg3bkk0?=
 =?us-ascii?Q?1aEp7sb8y/ruN+khTjC4kLerSEi5jDYUuCevOcoG/3NdNz1m1bo0obi29urG?=
 =?us-ascii?Q?4/eFrlXX6RHoiRi21ieQutMLkmo54h3wCoxAMokgDQDFr2O7r4BFc7J9w/Kx?=
 =?us-ascii?Q?zWNia2k3Tu/0c5Iwa4+AhNo+n+4+eiGf974FbQIfzR6ifk9OwtYlVBNv0W5J?=
 =?us-ascii?Q?5IRrMSUU8gDpAJPtBrUHIejSyexp2CDnvAXdmIypXDGnocwI7agO5tTS6kbZ?=
 =?us-ascii?Q?7VN9k8e4BWFstgeCEp9EcNILUg0avRwGhGhyefASah8YZCc0AiV6v3eusez/?=
 =?us-ascii?Q?nYXLixCzpoyaRYjuEFQLeItJkidIu4XLd+S+arddb1uvVycQPsdm61z66WYw?=
 =?us-ascii?Q?Z6LIfhTc+sRw6lsJZRkcydYIiF4FLzI3QC1yi10J1m6exz2Tllx4XOUW5g63?=
 =?us-ascii?Q?TC3rD2AWbkJOtFTXt9Z75jU3dst8QXfthhTZlTGgx2V3AsvNqTO+WLMCNtw7?=
 =?us-ascii?Q?sJ+mLXN5Ihv5Rx0zsOyZsp81Y3+jOy1xr3qU0vid9/7ingyIKO3Db75KSHKj?=
 =?us-ascii?Q?+DSOTaoyFcz2qWigKCn+GY4l0I2vXOj2Bzcl8yvpDwtNJQ4JGUYpd3wlGutu?=
 =?us-ascii?Q?1cI8hR5bgK2P8DSFmJYS6M6T0IzlkYB0srxAmu4jvHfaNJqXAJtE+Ca9TJxe?=
 =?us-ascii?Q?gDHsQE4x6NwMCpfH9qEjIuPFotSZ2cT4JLXFBTBI/5ATDKwfp/wqZjAquO0w?=
 =?us-ascii?Q?9f1RyrgXOOsRf2C7Yx750uUsfbFDUv2pkNHxtO29j/a5rUuRij+N96RdHujt?=
 =?us-ascii?Q?HCVZVAOkqiz/xXbbCUCqBFPFDhHe598h7iCCdR2SwdAYvkASmYqZLX2K0Mbr?=
 =?us-ascii?Q?11H3FITR4vC6oiCBacjEsnVGPqE8OZ2A03XBq1qbYfj8KtM4+bATGEHMqA6t?=
 =?us-ascii?Q?J2ua4Ro9uxgb3gCGaJGUqCb33UbZe6+v4qRVYZYfsG4I1sUfyX+qTjenCcHn?=
 =?us-ascii?Q?MR/7D7K4MNdmXeG/2xFQKpEM/vmS8oaNmqRkTigv5SsBzpY6R52scX2SPPwx?=
 =?us-ascii?Q?Nj8h2A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4776c8c6-8caa-4116-eca0-08db6d0205da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 18:06:06.1005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hR2X+yzdN5KPElweOG/3wsPJb9QL+7rsFTj0r3Uf/HvPpGWTt5+YlM1DoP/LPamT7KyHT1ePXYkQ9GOzcY+HKuhN5vpUFxhUluHT1wcc89o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6082
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 10:44:49AM -0700, Jakub Kicinski wrote:
> On Wed, 14 Jun 2023 14:23:21 +0200 Simon Horman wrote:
> > I like your patch, and I think it is a good improvement,
> > but I find the patch description slightly confusing.
> > 
> > In my understanding of things this patch is doing two things:
> > 
> > 1) Moving code into a helper
> > 2) Eliminating a check on CONFIG_SKB_EXTENSIONS,
> >    presumably because it is selected by NET_TC_SKB_EXT.
> 
> Ah, I thought removing the check for CONFIG_SKB_EXTENSIONS
> is not worth mentioning. The double ifdefs I was talking about 
> was the fact that we need an ifdef both around the variable
> declarations and the comparisons themselves.

Ok, now I understand. Looks good :)

