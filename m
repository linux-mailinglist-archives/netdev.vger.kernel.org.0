Return-Path: <netdev+bounces-1944-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED87F6FFB30
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:21:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E22D01C2103A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE3DA946;
	Thu, 11 May 2023 20:21:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827328F58
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:21:08 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C854697
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OltyXK6R+VH3cm4w+2btoDlOxIyvFKvVRwTQwELv36uaUQ6J6YX62Z3oYImRTsLaUFtHXSMmtJn0b/sI7G3FSaMigoQYlCvBszW4mq2I+jBXFNR/84jzD+E3efqQFS3reJUMcVkdMHnotPXvm/4qJZg6U7VOdBM52+pKVCgmuGwp6hmW+dxpLzN8LsObuAm7QowQqYZ6/EwXImg5ZX/s6dZPxP+8aGOsbWhu+etBqw1fwtVv3hFEe7I5jzevPwirna9vi1OkpmjpJu79NDOY3yFGobcEDTyVT2A12ETlSIqMpsQDZLGdbQRzM2R6YD+V8CSogUB3d6ZhrQwUU9hBxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6SLuG2TJuKpEkPFDfnS7xKxFER2cyRLQIysyl9TOTYI=;
 b=MS45qlA+XCqwkPDNXgL5Qo7Q4YwWtmCvJ6iub8sVZEylR/ORsZ+FVfk5Hqd1K2Fsk2WSBoYUpY7Vvl0UbEbeH07049DCc32+N8+ozZK2WU+Toze347FaaOqNaKua0qFWl+/wOCpaqTkd4jiCerNH7yIfmA2oASoweZtdYzroMOdlAM3TQ0SQXO+VwUDNk24KnNh7vumhqMr8LeX+PrLfIiBzcuKlZfIWcjdkshL5/mJadl+2TVJtWZdigteBnsrtwsxldX52i1HNBdVj+x5ycf4ErqTdB+XCieSk9t4exXMKTwNTN8nPT5zqffZ9IkehPXkuPhTb2K2yKQwgCx6cng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SLuG2TJuKpEkPFDfnS7xKxFER2cyRLQIysyl9TOTYI=;
 b=RK26k7I3D7MrRYcceD3JMkbz0IWijfi8F8f4PuRFVLMtiRiM7xAcuFxDlZFVSu5VmoHWv9AVYBNvteUk1myGGwffxv0M4OkIKfsBEBg9GYnwnxnAeXgkE0YQpIQBgi3sd6Z1d99tfGCl9qrJOffpSxZ9VY031N+h3QjthExE99AH11hFd/2erKNtY0Qbyu0idUW6cyLjzhVtf9bEdfNOVbhpj/ruADp3j8+V03+b0GxjnWKI1NFETtwbG2UHEJl7X6PBrOoNppI5wDZGVVJ0xKsJ1Aj9YSwt9PHmsUQ+SDrFXGy3ygo8PxyM9z6yxuGvN+NL9hNj2Eguj/XVL7wNgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 20:21:03 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 20:21:03 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org,  Saeed Mahameed <saeed@kernel.org>,  Gal
 Pressman <gal@nvidia.com>,  Tariq Toukan <tariqt@nvidia.com>,  "David S.
 Miller" <davem@davemloft.net>,  Jakub Kicinski <kuba@kernel.org>,  Jacob
 Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 1/9] ptp: Clarify ptp_clock_info .adjphase
 expects an internal servo to be used
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
	<20230510205306.136766-2-rrameshbabu@nvidia.com>
	<ZFxOZM9saCVDNIqD@hoboy.vegasvil.org>
Date: Thu, 11 May 2023 13:20:45 -0700
In-Reply-To: <ZFxOZM9saCVDNIqD@hoboy.vegasvil.org> (Richard Cochran's message
	of "Wed, 10 May 2023 19:09:40 -0700")
Message-ID: <87ttwizkki.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::47) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: efc5fec9-bee2-4f6a-5423-08db525d3e0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3dQHsYpAYLRBTBJkrQFf/NbtqXKlTlKQSpe8qyX5xVczLWrIgtx8mwcf+FuOylMs20E+khXNhmr1Em1Mgxz2gSFE193P1GAxkFyzx1rMhdmClkPMEDvYQYpx61vF47LiahOztpA5/25MO5aLRt1nQeBvxBq7EbueWU/URihl6SvllPo/FVZMDmwdNbOGGLbU3uRTLoRAX7QznKX/DjzxdcrOAAcI+qAJ3Mzo5He4O7TXya5K54Tascm+uSOXSO3xFcuUiYlNsHxsUfSgLakvtNZiebiK9BkvNpWGfsO5NKv5AbFnWYa4VtaLo98uZuBQ/AnDQdKWoInGTQZS2zApXCCPEuLyCrP7QLRWln8sbubW8cZyUkCLlM+5s9njpXV2VXPaXUQTXSlydSBLbZmAlr7LZQgGwwOGJPj+yWmgRlVXn0YUv4F6HPq+fFhUrvIZb5hbEiK6Dhq5WadAnHsy/MUPiRvKD/0aBlusScrS1pFMrIEjf3bcClk9OXiqGJRnnLsN5QlfqlRFIHtfux1rQLdrBUOIwwyCeRT4s5OSTFsmQVnpTCElJkENdZGd98qcfpxoEcFL5crPCa1yYF1JH9KoN0+xVn2ZrdXlD+Ge/wgkr3EPDUwxFs8prsO5kAjCieuASbCfb4ccMKg+nYredg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199021)(6486002)(6666004)(966005)(4326008)(54906003)(6916009)(66556008)(66946007)(66476007)(36756003)(2906002)(41300700001)(86362001)(38100700002)(8936002)(5660300002)(316002)(8676002)(478600001)(186003)(6506007)(6512007)(83380400001)(2616005)(26005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bVq/DxfMARyIDe1MValVN1VGcBMMivLaiqAt9FKfYfFRWDLMeKDJceOPkS91?=
 =?us-ascii?Q?kFMuPIEhQDagCK9GQ4Lt9rK2xeQnT3+BEsjOFoLZM37aELW3k7GHIEFWDmqI?=
 =?us-ascii?Q?9TCMcQVrLLAMd5EaW/LbOTPsxs0J8+HeLSDHoj/CP9LuKqWugGg7sQaOcwyn?=
 =?us-ascii?Q?XsQNLodw9yO1ZT+QyTG8pCc2TtXsKY5Dcadydq9hl8L+Jq57UBQvpOHtJswZ?=
 =?us-ascii?Q?xjQlinVeKbitxctGNFKt5XN7uOU1iqKjJCHkCCsR7h25ki7uJQvdWdFMermc?=
 =?us-ascii?Q?S3poIFLqHc+BBaXv1HwD94klK8gg9W9LO8m/mN3XCjgIkbfzt6f7buG1Ic54?=
 =?us-ascii?Q?4AocZccYRpOF+co/1NwqiDgQz5plfo+8G+7X+dgXbANkuqa+z2+p2hwgmM8S?=
 =?us-ascii?Q?P7QIS4R5mhnnOTHFVA0Je2iWrBGs5BC4tGSnYdxxrBA9XrQ9Edh9C+nt6bkA?=
 =?us-ascii?Q?sOeegm71VsvjcrkOtXBl2AFExqD5LaLf/NmC95GmhxTQgAvGbtK+RtBIbKG0?=
 =?us-ascii?Q?0fTg2Mddzxq9FddArOcPtLSYynAKbxIEqPYiujtd+l21dOSeaLOflPBPthwv?=
 =?us-ascii?Q?jBJ5qCWSPrLN7x6AJQ3XcY+pCYsmr3qBnesA1Iqx2mgpyyjDIblypb9hVYnN?=
 =?us-ascii?Q?qP3TJteu54li+6dWM/pVo1K5+ZLLoo0vjHmJbb06mDTBkiGCAeJw6MpSd6PQ?=
 =?us-ascii?Q?7gUNEjldYuBN9a3HGugl5TgpAIbrCtEKnA0BW1Myir76lAmDl2ZlKa4dUgOi?=
 =?us-ascii?Q?4MjYbTb5xS12BQsY/OO7Hh5XDOMtWjvNXwZrsoQYjRoN6PDn9X1WtcVy5TQM?=
 =?us-ascii?Q?/UPlnU073VtNF6E51kdGQfxOtbhC5l2Ch+UGoQzt3s+0vjGr1t70lPslV9rV?=
 =?us-ascii?Q?AzPLk7CGlFRSPUhwH/2NAX9VEStO/L08HeqkHpOEaJyWhnOP+F8wdICwiaod?=
 =?us-ascii?Q?C7R6WDLqj7aGiTqnkI/41rZPwNxPshvJl70kCrhDq1w81+UfTLGR4bOdC94q?=
 =?us-ascii?Q?Elc5ccdreNtYA81zAA9GL6jtsVkErLzszwdOUo36iurY23I3BTVHKiSlOsjT?=
 =?us-ascii?Q?MbbjJHi1Bc1rZlkpz6evUQQ4beSdcfDMHN0EBUDFQc/n7PwEnDRZDnSxcDGj?=
 =?us-ascii?Q?X1mLgSEGa0sXKNd75KRViuoFPunboM1lM/P0cpgzMgRmQOgMt7+0Q2+accTu?=
 =?us-ascii?Q?+XQ17hYCbdiGrb0gDG9tSBEdBA0kf1YPm6vErOENuWgqLJfX07OGjnuCbfAA?=
 =?us-ascii?Q?7HT0u1/xVIhsx2kQfRkbdamY+pWdw9Wi+VmDiDptEUOSm7ZiOAuBx/qeCfWm?=
 =?us-ascii?Q?9uCFF0DOTc3VaRE0zEyzVgeMWe7yF0ZdU/WrPIFw0lWdzhMBVDdobLEDOjUq?=
 =?us-ascii?Q?GSYG+BI9c9hnnZ8iLdmJko4VtNIgQ9+ennygJNEB+TvSJgGb/UqBs8ZvIasb?=
 =?us-ascii?Q?wlqJy6NA+DHUUhwLHfjGDMPdEAkk1rOu6VXBtpVbubZs2y18GK+FjASiDM97?=
 =?us-ascii?Q?t8qSZJutUtN8FeD0Gx+HF6VpNdGQ8DT2h/3Wpp84yJGGNwd6gv9poZSaLSnN?=
 =?us-ascii?Q?194DNn9VbzsKxGlZA39e7pE58jHlbVRmX7/w2Otyx6EWH7yQZgvbo0Jw+7Z4?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc5fec9-bee2-4f6a-5423-08db525d3e0c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 20:21:03.1712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYvvHr4Q4FELLeiVuELHfaAuEc2NCwJU6bJEAneJBtNU7ivsh/byDFn4wd4AvFkmQNQt89Oyks3MqlplwgcLNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 10 May, 2023 19:09:40 -0700 Richard Cochran <richardcochran@gmail.com> wrote:
> On Wed, May 10, 2023 at 01:52:58PM -0700, Rahul Rameshbabu wrote:
>> +PTP hardware clock requirements for '.adjphase'
>> +-----------------------------------------------
>> +
>> +   The 'struct ptp_clock_info' interface has a '.adjphase' function.
>> +   This function has a set of requirements from the PHC in order to be
>> +   implemented.
>> +
>> +     * The PHC implements a servo algorithm internally that is used to
>> +       correct the offset passed in the '.adjphase' call.
>> +     * When other PTP adjustment functions are called, the PHC servo
>> +       algorithm is disabled,
>
> I disagree with this part:
>
>> and the frequency prior to the '.adjphase'
>> +       call is restored internally in the PHC.
>
> That seems like an arbitrary rule that doesn't make much sense.

If the PHC does not restore the frequency, won't the value cached in the
ptp stack in the kernel become inaccurate compared to the frequency
change induced by the '.adjphase' call? This concern is why I added this
clause in the documentation. Let me know if my understanding is off with
regards to this. I think we had a similar conversation on this
previously in the mailing list.

https://lore.kernel.org/netdev/Y88L6EPtgvW4tSA+@hoboy.vegasvil.org/

>
> Thanks,
> Richard

-- Rahul Rameshbabu

