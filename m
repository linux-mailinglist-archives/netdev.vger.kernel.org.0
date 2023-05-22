Return-Path: <netdev+bounces-4370-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF7E270C3E8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:03:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04A282810A1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5712814ABB;
	Mon, 22 May 2023 17:03:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4500379D2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:03:46 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070.outbound.protection.outlook.com [40.107.95.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AA3F4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:03:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1cB8BEb8EN56rTOlxC8yiz6MJbmOjq31VzSnJli+uJvOqYbB8hZVF3DVZY1FSqlisTfmyxS2ajA3vZBUHQ1sZr4XLgNLtq3Qmnr4iSQCDgFNIxLAV9gKnf1uDH6Sfs8JfT4rLRNAFqE5lQd69UxujFtKbbB0y/7qkQTxAKnDLna3REZiQ48whmqBbSnB9LHlTiDOO2yZiJp3esTgaamsstGS5sxKgDqlvcOcrIQxnuyHCqFOsHDOJ8npGOjFoxIxot9uNh5ysJSLB43QOl4mos9ImJpASoRb2YvWFoexmFHLgZYjAP1Rkpc4tLYILrhacC5LN0s8/4gP8IC6NIXXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0GA266shFX5G3y5cN4dS2WLGflZCy6M7U2zNkbxiPI=;
 b=RB8KHlyCdak+sCq5bBcsZdf9mNSHQXTH/fxMDuhGT+QDjjVOzqtqRf2b+C1qmzdiHgtBoG8HYlKeOwOTXlUvhYuzcsPG43MvU8ImJ9EXYNfatdMJ19buy1irZ1W5APkbhNMleMmOxVFAp/IuX6pgAROsIQzna1B0Kf+xh0k6+GuEi7ckYFDZSPqZ3I3md66BYhvYsjKR4qONkcXfWyGFM0n56RfA3HzNXqMB6V+AX420H23lfzo6ySk5K9ek8b5XVW5K6ETOZyYWPAKz2N27T9oHrx2AOQgRyE8uICdqtzPnlXAdhhIcZn9gDPAg1aSarcvROwBh93ik8CNQC8UaPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0GA266shFX5G3y5cN4dS2WLGflZCy6M7U2zNkbxiPI=;
 b=HFHSg9q/sqChDBXHq4A6aX20h23ovGENQVbHU8AEoCGq5fTxq2uirzod/K1evTOWrTsjIE+59COoTusx8njHFexPDiOvmoVVDdcjC++xOO59h6oAI4nDiHNYRL0TGd8BVB6Enuv+WfIeBtXaJjFBl4eiB2fNqgqzJBy0imAcOoP6yrQ63IGfn5UzDgv1tqc13kntwIZAPAIK1Ra4m2+DmFLigUFFulhenu0wXxhD66Jz7F/gwyQfwPnZPMlmaTM84WTIHuoQgq0xMXdGNAZlrOL5NqR87b7xpQk729jLe5+ZyGUmY0a48/tR6VBgsdHOdY0oqIHmjF4gzu84dLy2eA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 17:03:41 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Mon, 22 May 2023
 17:03:41 +0000
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
	<ZFxOZM9saCVDNIqD@hoboy.vegasvil.org> <87ttwizkki.fsf@nvidia.com>
	<ZF2No6gW3HlzZscV@hoboy.vegasvil.org>
Date: Mon, 22 May 2023 10:03:23 -0700
In-Reply-To: <ZF2No6gW3HlzZscV@hoboy.vegasvil.org> (Richard Cochran's message
	of "Thu, 11 May 2023 17:51:47 -0700")
Message-ID: <87mt1w5mec.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0182.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::7) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: d74b4d66-3d32-4cab-ce85-08db5ae67e3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0KjyzkdafwZv762sE12y/SCVU9H6rj4IiNk2prL9XNLxUU7YrFdPVsKKCHXI3iJT0zWgIIXsoLC/g7dhUlMSnjFN0f7SO4m4iFOjtUemCbCP66puLZwmGgl+oZkjjtf2xBbGRUNV2/sp+a9Y04FX5oV4+XpRIzX4fVBW2bH9AGlSx+G8kho++XXuHX5/NJVqRaUgJgpc0bP/SFCxOw7D9ziYEIwph8fPbJy0i3yOvDHebwPB4n8RL78iTOqWNJ49N05RTV9MbVowQaw1VGRMISV4H737FJxsU9NbnAC9eBSm3LwyMD4BZhIsd7ueVzA2Uera60rTTdCngvoq/nKKMX1f+7DB2o/MBjT83i8RxPuPGQYgL+tRRqfIhTI5LMl4b1zeGqyn901LzeRqSgLgoQNaYA5SgGJ4txmamL5unPCw5tEyF90PAOxrlP4lZTXj0N/h5XrYH4oFP/K9xkwbeVVukAu3NRWGkKe8QoqH4eOc5QZY+53Wf9f81V1talVLxYd8GfM0MHWGaR38I8jnpduoQ4pXDkIRz3kazQmyE0vqPefsl2aMNgtZc1godYSUkRETcrJ1YbFhqevGEBSFINdDSvqq36iou2XavrqyM4lqQaFQvCl8ubmwwKIMGLrQPiLGi59J7lea7V8nVZglIQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199021)(83380400001)(36756003)(6666004)(966005)(6486002)(86362001)(2906002)(54906003)(478600001)(26005)(6512007)(2616005)(186003)(6506007)(8676002)(8936002)(66556008)(66476007)(66946007)(38100700002)(316002)(41300700001)(5660300002)(4326008)(6916009)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1up4WO0xhqIPmnem1ECjMyk2PR8F+5pLtaAK/h4joI5AJMJPsvwfRKfe38hu?=
 =?us-ascii?Q?Xf5+ScApyTKQ2lFiiRJUR31V6CzJbo2ja1UQmPoJ8psT8ymIW0k/bnJUJ4Oc?=
 =?us-ascii?Q?/HR96FLES5wHBCZaETSJaPcq/SurRtf64123KSrDQIxo9QPZtX/b9avG/jAk?=
 =?us-ascii?Q?lsEuz76oVjbXt9dhqNQGsKukJU5gShk8TSlZeuAv+iPKV83xr60GQH6A1Jyn?=
 =?us-ascii?Q?Gb75N5jljEULpKwMeHqJjbd/tDMmkVWZqV9q6dqaxIg3c+b9U7iFF6If6t2j?=
 =?us-ascii?Q?ZJfYPp7vdPcY+l49p3AEHStFVxLWrvT1n7PTspseISJdJkM2ooi7OQTgMfxB?=
 =?us-ascii?Q?eN2x0/nK+HAm7NTI5i6e1JceXUVzQDjRHbNVvV6b0NsxO2G/Go/D3PtH9RLV?=
 =?us-ascii?Q?G1Wfoowtk6jyTjOaMGKjssuaHjJkEystE7IBZdd5ZH0dJpsphlX7dRoP8Sw8?=
 =?us-ascii?Q?1ia1ECmrQ3LQdFqpB1Ix6810Qp1ENOJ3mMRZgR3ajBkDhgdjiGZyHacT79Ty?=
 =?us-ascii?Q?thcxWDGcbbDqsY40BVdcbcXR7B8dVC+2Yt1/YFd32veeTjPWStqZM5kpmN87?=
 =?us-ascii?Q?LmUIt66t1AzuUIXQTiUNrX9nm5e/9ZS3mzyJWTkqTErJ/jK/RKAJ1BWBFzYM?=
 =?us-ascii?Q?EvEgOlEZ6QUrurmimD6KGo/OEIFvKd2MREBl+NI9p8xteg+TXnaOF0VJAYd+?=
 =?us-ascii?Q?N8BUtD2InRbA3BWUPzihPznWRdUfczzb9TfQNrutmWIc5CPCGyHZMcDTaaEh?=
 =?us-ascii?Q?PDRxw3M+PU4az2rnSc5eEJ9pMzBg9W71Y85SIuLaBtMWdxQY6Zc9Vh0XtLjf?=
 =?us-ascii?Q?AQQMIa/5wKtoEFq699cgqjc+KsQXIkaNTWP93NgVo7SAIhhyl+vGJsVO+lTw?=
 =?us-ascii?Q?+3QUquMoDZs4Fw/d4A6vs06hNFqKR+SUl5/fLLrM8tGFRo2MY6JUPNN1PdlW?=
 =?us-ascii?Q?CC6L45dHQvfht3G1HusqQTSygiFVh30HW8OkRRL7wJQFLwsfvsoarDnAJvV/?=
 =?us-ascii?Q?SaQQvoP6FcB/RNLzykw/khnD2m4K4eu9DtAESF/UIz2gaiWJxP/zu70ie31n?=
 =?us-ascii?Q?aIPzCIoC/fQ2UcQYy6pdbY7TJg7w4Io9HwPeQwA6u/vZbhE8nM3YafjJAsCY?=
 =?us-ascii?Q?TNdtih8GUBc/vV0GfamsfEiuGVVgtKtQ6wOvZe55YWOCN9cAodF8hdAA3TSE?=
 =?us-ascii?Q?+fDDepxvpGeLlMNpyrvrNo7bGMIsPnLLJKHOHapJqLo/RLjsSySPNoDE40PP?=
 =?us-ascii?Q?4ZNQrTmZvgqQHDoHVgoak6P2yLRtUhn+8SU5AvXHNJSkIeSkIjOHnkHIqokM?=
 =?us-ascii?Q?pS0isIlBB4BcW1IffXP8WFoEsaatkzsLIoXlIbZPsIDkCQO9X8XIMji1Fu8H?=
 =?us-ascii?Q?PMap9l+Ajkz2O2xB6F5+oP4EXTyDItjMaQT3hCPTFBPAd+Ud+1PrGSXKIomx?=
 =?us-ascii?Q?bnyDRXNlNJD43tjoahorw0QGkqfePNBb67hWsBkvAurMTU7ppLXY4+vbVpZK?=
 =?us-ascii?Q?mtrWpFIUpK4hhzWCOewCNq7oegELNq4Qfcb7QvM259IMXUzRkNQ2onW5aK1D?=
 =?us-ascii?Q?eJkegb1LbklbFI1qafr2VjBp89hwBeVqAzL1HNQx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d74b4d66-3d32-4cab-ce85-08db5ae67e3e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 17:03:41.2642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJRYhlt32WuMG+ANcWYAVZR/Vh9CYhKm4Lqh5GwDM/UCJ92pNIspwlb79A714ueJwz9Hu7WxuO5BQF7TP9siNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Richard,

I have a v2 prepared. I have just one question left before sending that
it out.

On Thu, 11 May, 2023 17:51:47 -0700 Richard Cochran <richardcochran@gmail.com> wrote:
> On Thu, May 11, 2023 at 01:20:45PM -0700, Rahul Rameshbabu wrote:
>
>> If the PHC does not restore the frequency, won't the value cached in the
>> ptp stack in the kernel become inaccurate compared to the frequency
>> change induced by the '.adjphase' call?
>
> If the HW implements a PI controller, and if it has converged, then
> the current frequency will be close to the remote time server's.

This point makes sense to me. However, I have a concern about the case
where the linuxptp servo has not had a chance to make a single frequency
adjustment (0 ppb) and .adjphase/LOCKED_STABLE state is initially
called/reached. After converging, the frequency will be close to the
remote time's server's frequency, but that frequency will likely not be
0 ppb. If .adjfine had been called previously, the difference between
the remote time server's frequency and the cached frequency in the ptp
stack would likely be significantly closer. That said, do you think it
makes sense to have some kind of API that gives information about the
in-HW controller such as the frequency offset it operated? Or maybe in
general an API in the future for introspecting the state of this in-HW
servo?

>
>> This concern is why I added this
>> clause in the documentation. Let me know if my understanding is off with
>> regards to this. I think we had a similar conversation on this
>> previously in the mailing list.
>> 
>> https://lore.kernel.org/netdev/Y88L6EPtgvW4tSA+@hoboy.vegasvil.org/
>
> I guess it depends on the HW algorithm and the situation.  But I don't
> think there is a "rule" that always gets the best result.

Agreed. I do not think enforcing the PHC to restore the frequency to the
value before .adjphase is called would be helpful. This preserves the
integrity of the cached value in the kernel stack, but that is not
helpful since we can potentially see an initial growing error in the
offset between the remote server's time and the PHC's time after making
this frequency reversion.

>
> Thanks,
> Richard

-- Rahul Rameshbabu

