Return-Path: <netdev+bounces-1725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D5C6FEFC8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F4951C20F3A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429631C776;
	Thu, 11 May 2023 10:17:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1121C754
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:17:27 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EAB558F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:17:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzIdJcNdNhguORhaDuO5OS4VPu5iQiUh/Syg5EqGJVl3MOKzN6wqtEuJz65ME6sNPkRfw9l/usXzPS8rqI231ytkgrR8edd/xqZVus6xfwjuKbVNw+7HvSscgzwjynjG1QJXjWE8sis8lAp8K90s3kXHwyUfgRchB6eodcjxp9yaMMgWGpHtwuqc3KM6ySS6qr5SY8oTkwxv7HpbEDeWArRxBY8EVs/EA72tSwggJ50IXOAXObsnFya6JlL+XOZIw/tNtHEeiqo3qehyOfhZk4D02HXI3YzFVinqCJDQIczLgFL21JQMNrjegJEo8GeSvH6AuKFYJXoX79+V9d+5OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5g8sUKjUOFZkuwK6bPceccvlXcoKr0EkxY4a6hzDu0=;
 b=n5ZtaYcrCKPH5QrnnEGFvKrMaAI1oIMw0O9u9d8AAOyu3gw6TVE7hzslw3xBCD5nAbsryYy42vAT3WLsUHWBh2U9u3ZbnkrvX3U9Q/a0aPnWn/E38gtxddBNKSqvwhzA2nopVWPEMIaGHY3CoY2D/CGebavhRFwwvH2wscDKztICDu/eSX38ULvKJUWLQvLIgj+A30+3NwV04W50LSb+XT4kCUvF2RvReA/bIU1VaxsBRpmRbTn9F/mtSh7x7uslmoa0KAyuvPCIFWPsvBa0IECxIGxGtLwC1VI5woC46bHA28Py0iWeGfjbQiPHdMpFCKOh4zDAPUC0j82U+Tpfyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5g8sUKjUOFZkuwK6bPceccvlXcoKr0EkxY4a6hzDu0=;
 b=mudDxLnEvnzVNf4mSPjBoMrZv74Z8JKvVv44dEVjen7F39bkwH/XeHFte5fM9G+5ExgbtJ/pSIzRf2uCrKfKJGwSoUnFtG24Fy0tsxm3scrrn8fap5SbVs9bgQiEvzF9uq2IBNYM42yUzsvG04brsObhEVOw8D+NICavL1UKF9vb+IubQBdrmZJ9DN5aEJUN6O1sERqS10jFZmwqI1UHvKtjKNDSYZdicAXttj9d2l4/PvCrMwtiz6hXQgozpFHYW1Ml4YIiINEOybs4QuECNYl5Kt5SIzMk5vSfWwnLqB2g++n4if77TAEGox1vbsYMj5k7JSvgO9kPTisfpmPJeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6018.namprd12.prod.outlook.com (2603:10b6:208:3d6::6)
 by CY8PR12MB7730.namprd12.prod.outlook.com (2603:10b6:930:85::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:17:15 +0000
Received: from IA1PR12MB6018.namprd12.prod.outlook.com
 ([fe80::df02:1c55:a9c3:5750]) by IA1PR12MB6018.namprd12.prod.outlook.com
 ([fe80::df02:1c55:a9c3:5750%3]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:17:15 +0000
Message-ID: <271c4388-cbb2-7d4f-22dd-9c73a4becf09@nvidia.com>
Date: Thu, 11 May 2023 13:17:08 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [RFC / RFT net 0/7] tls: rx: strp: fix inline crypto offload
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Tariq Toukan <ttoukan.linux@gmail.com>,
 drort@nvidia.com, samiram@nvidia.com, Gal Pressman <gal@nvidia.com>
References: <20230511012034.902782-1-kuba@kernel.org>
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20230511012034.902782-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0145.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:346::19) To IA1PR12MB6018.namprd12.prod.outlook.com
 (2603:10b6:208:3d6::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6018:EE_|CY8PR12MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd3db15-7fd7-4b02-0316-08db5208e4d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ibr0CX32cmP1/LNgGDkj38LLK46dOwvGwYMddHUlEONtbrIPGEWZkfEGyGZ6iBrH2B4cfleQIEHL4Kvm0qklUwW/8wJ4FcrygTrJkHg4oF2hFxnorNKZAvMIh6mIB+hCTfaNvkRv/5ewDvJfZ24p55OQburJmOSVrwPboAIzz6Lt+Ms9D/fUfxZA73cUtrbXy5x4w32WNKorCgjiLO2dlc42o2KNxLGbvHlXBar26AhGYSzPMB8J/yjrzTSlbRfvwwp888E31bWdUqyQlDevi3FdqB+YaRDcjDwwlhB2YsvAIeVwi8bN8ubeL0n0sFfvCEwo5b2ogAx4wyAiie+hJM4F+yf5AiwfeVCKN7VXT5U0L7BIZySkIw6ShcvnF4BN0Pmq9hR7RTaF7v+tGo6FX3vS7UNwDnA/g5qG6Ero1T7rIrYm2kGSELH7368Bsi/6Q61tOFTgkd49P/5gVX27kG2Nkucej2Nc1Qw/z09Lxu+V6qN09KwOzk04fN6wSiac+I7jKkCd22fxzCS1v/aAM86SW+xraheeUh243oTOPpV64cKUUFOtwuGTHLR+3oGUtzC7xhRMRUseNFvxHPDu2E3F9F6SDwlzpkzURBKKVTGMXo3gkFaSebPLu8KtohPBE1eHBwI0V086le1dTZSTQg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6018.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(5660300002)(54906003)(478600001)(31686004)(6486002)(8676002)(8936002)(41300700001)(316002)(6666004)(53546011)(66556008)(4326008)(66476007)(66946007)(26005)(6506007)(6512007)(107886003)(6916009)(2906002)(83380400001)(4744005)(2616005)(186003)(86362001)(31696002)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aW5uc014WXk2ZU8rLzZwRzJDM0t1clVWNkoyeTR0S3I0NTNaeUxFT2dTUlBD?=
 =?utf-8?B?VnkybFhRd0dWWmlnY2pyeHExajY3TlNIZzVsMzdsQzBTRkpwUStNV3dLVWlE?=
 =?utf-8?B?eUVXclBXcEU5N1I4aEJ4MXhIZGwrSFRJRjJwR2ExbTRNQUhmRHFOeC80bFU5?=
 =?utf-8?B?UUN6OFZsaUw4bVdHZHZDMnRISGUxaktkNFBXbEkrVWNBSTJJSFNzYXNYWlRX?=
 =?utf-8?B?U3VvSUFXU2tOVlQ0ZVlHanA4akFyNjJjNlZKOUFCWDNBY0FKUEEvTm1pYXpp?=
 =?utf-8?B?WjlkeEJIakRRbUJ6VlYrOWpUdlBLUUNYbkw5M1ZhaVdQc21KSHZzOFZLa0hx?=
 =?utf-8?B?bnFHSlYxSjN6N2FTcWcwYXZNTzZOeHBUMzExRFUrOUE4bTk1YUZpcmNwVFlJ?=
 =?utf-8?B?MjA3VDhzcDM5L0dWaWJNS0lXWU5aQ2hISGVBVFovTWJtbFB1NkRsaWxIOW1V?=
 =?utf-8?B?am83dVQ1OWM5Q3Z3YVhWdEJxQnBIeUJPbWtQZnV6akdJN0UyNFBINmRwa2p1?=
 =?utf-8?B?eGhqclgrSFkxVytkaHl3bEpTZXRTaTlUeFE5SHBOeWZrYnU0MEFFb2RjTWo0?=
 =?utf-8?B?cU5Hc2xtY3NiOXZNTkg1b0RUckVab0ZlSldjbnl1R1VwTEp6UENYek5uVU9G?=
 =?utf-8?B?czlpYTBmODZzN2g3TSswOVJJSFd3K1I3TnFmSlZrWFFkbDR4Z1h0QkhRZGs2?=
 =?utf-8?B?V1VCa1FTako2LzZmRlV0KzJ1TU5VT0J2WnpFUWJVTnhpWDNxOXQxNjVtNGRY?=
 =?utf-8?B?WWdra2drOUNiN25TSUUycVoxaHdlZ1RzSXdsNGV3V1hBdkNzNFN6ZmIwa3hM?=
 =?utf-8?B?UVpxOXQ5bE5YQjFtUkFuVkdaVTFuMWU0Mk9Zb1JqZ2FhSTEvRFd1V1JXZTUy?=
 =?utf-8?B?UDNhVUtKV3orYVNHSGVSeVk3M2xrODBvM2FYM243TDRKSnFubGxuN0lMVEcz?=
 =?utf-8?B?WnJxaVFUbyt5UWxwNlA2STgrUFpQTHgwQTBjcVdYOG9oQlFOR0ZCYmx6TVR1?=
 =?utf-8?B?UGNyYWZ0NFdPdmJDczVxbU4rMWFNQUFacE5ZV1VycVp6R3NtTmpvOXh4Um5F?=
 =?utf-8?B?ZTNNVzhTQ295YjkwdVJqUEd2bXhhLy9rZWpsUFduMGpaNGFNak42OWNvbU9p?=
 =?utf-8?B?b2dZSE1RenpYM0xnNXJHamx1czZWbTJQVms3NkgzTU5PeWxBcWxzSFh2SXVi?=
 =?utf-8?B?aVRFbFNEOW9HTjA5ZW0zWFdzN0h2MDk3WlZOWmp5Y2NHVE9aak95blQybDNG?=
 =?utf-8?B?MFNFOGpsVmVwbGI0YXF3TjY1QnZtakRyWFlvR1NlNzFVN1U4eUxRQStad2FJ?=
 =?utf-8?B?TVZRTW1TcG9aS0tmR2YycWIwcjNlTDhXVUx6dHY5WUgrcFBsZHEram5TR0ZD?=
 =?utf-8?B?R25oK3Z6cVBqS3lsVG9QMnRjZDFUdHIwZ1M5YVBJWFBwMzdaS2xYeUNzR29H?=
 =?utf-8?B?eks4ek14RlBDQ2dzNGN5bldWakVvam1jQkdienVCQ3YrTWdNcjNTQks3d0E2?=
 =?utf-8?B?Tm9sNUNQbHNoT1c4NnZGYnJiS01mNXF6YldpNU9rZDc3MHl0N3FGTy9pSUJI?=
 =?utf-8?B?TEFZYkpDVFU2M254b014NC80dzhWeWZ2ZUs5MzU5bm0rYkJPR1NMRUtXbHVG?=
 =?utf-8?B?NEhvUWgxQ29XS2xBTDZhTXQyS1VoRUFad2t4L2RWRGQ4eEpOWCszRDNPbVpJ?=
 =?utf-8?B?ZFp4VTQxS3I5OW1ydVJYUDlxWHo4WFhCQ3FFZUtmc3JUNnJPbDhPaVpXeWV4?=
 =?utf-8?B?STZNdzdnWXBhZ09TY2dwbWxCOE5GQzRZeTZoSUgrYmZsU1BlSFlzcHVCam9m?=
 =?utf-8?B?N0J4b0VKbVdkWXMzaDBlMzZSRDZyZlhQTXlVM2R3Mkc5cVlJeGI1TW5ZS2lC?=
 =?utf-8?B?ZlJHdUlLZ0Y4VDUzMmNOTXFoSWZlUDI3Q1hCUHBudVhvMnJZaVVBR0Fsck0r?=
 =?utf-8?B?TFViVXl4bTIyR1ducmpGeDJTWEVpNllSR2JWRDhUbHJVR0NDS3pxMXBWeG5j?=
 =?utf-8?B?M2FUcmpyRzhad2VWQ1VHa2xLSEpuNmRQdmFsRVcyaFNqVHRjdmphSG9YYXJP?=
 =?utf-8?B?Vk42WlJERVdUSTFyOWprbFpsNWpkWHk4VXhTazdLTHBocG9sSFhrNC9kT0Jw?=
 =?utf-8?Q?RrG/yeWRkZTtdmgLdBZckgBkK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd3db15-7fd7-4b02-0316-08db5208e4d4
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6018.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:17:15.7986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qgL8d5pP++bheJ/a6BFPAl/FPelToq7L1CH4uThhitrE3dr3+h02IQvX8e4/aulf7MYXNRlFGJ+Qlu2VXU5M/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7730
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 11/05/2023 4:20, Jakub Kicinski wrote:
> Tariq, here are the fixes for the bug you reported.
> I managed to test with mlx5 (and selftest, obviously).
> I hacked things up for testing to trigger the copy and
> reencrypt paths.
> 
> Could you run it thru your tests and LMK if there are
> any more regressions?
> 

Hi Jakub,

Thanks for your patches!
I see that several changes were needed.

I tested your series with the repro I had, it seems to be resolved.

We are going to run more intensive and comprehensive tests during the 
weekend, and we'll update on status on Sunday/Monday.

Thanks for the effort!

Regards,
Tariq

