Return-Path: <netdev+bounces-591-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE91E6F85EA
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9C4E1C215B6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1B0C2D5;
	Fri,  5 May 2023 15:35:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295485383
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:35:16 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3958AD09;
	Fri,  5 May 2023 08:35:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3paf9vh5M2ebimmGbkTykqJWNZi64RYIVoR3Ig6DpVCFspjUv7dWqexTKkZEX9tFX+5a9LHc/QaqNMdnoxWTl622BblL+AthV2lUXxViGDYCwRy0GvIQdBzb18n0nSHemNJCcDXleGRcohuwYrENpyfwFsfXqCzgwn805knC3vjpLCgUkJ8rn3Oyk1KlX+/O3KxYSfWWEvSHrJrFvL02J7MZVY7vxLkyws6RoIRKCtkG2Stw1cbYG+F4K1qlh86ABdpJHmvgv7+H6lUP86HqjAlrc60Hi2vDeZS6RhZ9bK7jEGPDpBHa/7tvdIF8Ae9apOuZRgM/7UNgRuBtjyWwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBmVE/2E6j17oMUvH9Y/RSpJKvJbaX1M+s3/D6oDoN4=;
 b=a7OC956IA859i/bVdOv5sWU4ummPHF1HcAscO9w8yCq85cej/BhdfxYYaUkvqcYMxs8Lz1UD1pt2DCHZXnTZ0EO5fc1/J77oaV8L4oU4N/GdoBk0PnyVi3GacLU1fI8GAZ/F9E5EF7YUGyRnwCI02XqNDedfbJtztprpqcE9bvdX58nB0rVo83bDbS/ylXGiianWf4kQjfakUpbmQ9kNW+nMKPiZ7HfwdjNIKMoJkRbp5+E0C+p0iWw+DA/1tvX5IU4UPpkALTi/xPolUmJI6Bd4W06A4qs1gJGPRSrb0nf7HJbFCRzfKwxzXNa9BsVnyzNSelxHvnlh3fshYqxS2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBmVE/2E6j17oMUvH9Y/RSpJKvJbaX1M+s3/D6oDoN4=;
 b=sXgzmzXDsE6dCEzvgRIAc67C9CG8b1UcyelZ8616dn7HDVEZrS6GcJ94Dc3x2KEF9jNtXD8BfazrOPkWGl4CGkwriSZUI63ol+Rw4fG4ok2EuGsS+X6jD4Zyhnf0djDZkiBCUsnqFaveoKmJrzgFyyjLxJEvuDEc56Ar1PBKbxM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH7PR12MB6739.namprd12.prod.outlook.com (2603:10b6:510:1aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 15:35:05 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 15:35:05 +0000
Message-ID: <8146fc21-9fdd-37fd-434a-c5705934d4a4@amd.com>
Date: Fri, 5 May 2023 08:35:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-3-brett.creeley@amd.com> <ZFPq0xdDWKYFDcTz@nvidia.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZFPq0xdDWKYFDcTz@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0071.namprd05.prod.outlook.com
 (2603:10b6:a03:74::48) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH7PR12MB6739:EE_
X-MS-Office365-Filtering-Correlation-Id: 486d583b-383a-42d0-3c6e-08db4d7e4cae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qK2pUbwXWQD7bCc6e+IC4ufNhzxni7W3/a2p0i4rgk5tgQeQ0tEMbbs/bkwS0P1NIqorbcOgZTGX1ywMT8XGVrbSsSOkTNm29hJKliZYXL4o4LDbRBFwFqamhquQWNMCa6u8Pi5DG20UAMHEBsZZjsujkuP34ZlqR9LIhFqChr59wtbIS8YsUOjZIxS8ac1xh0ucMUD0ksPDAARhCwJTYl+xZ/83S9YOK01cyPhKGVDWldhG6V8aFhCZO0zv9mBJMBu0E8cTAM+nuT9vxhutFbKgX2e8rq/kUyFuL0ziFXYx20+pHus+f2RhlTGOSc92PBkHjEcnjGRsazndY4UjI8YmF4CzplJ8D6mrSy2/r+ek8Sn93QGQoYGegU+B0qioZQERIi4MLiqDP3NC4lAm7WEO+b2pNo4nU4IaBVLyNe5f44bf+XeXjP8JRYa+yuBdbLxxDqjH9TssWs69c67LLFhvvN+RzFBfCJ1wKERplet1z+t+3VNdHJxwckFMXmvMSmLnjeIw+E03VyNxIC2ZZt+Q0lT5kPjwCI6DN4ymE9LLyiiIitQ1YcOijwAtZ5eQqTvG97Bml01ny36T6VYiB8K2sd8trgaSiVbQ1BWYRifg/otMOz0pq2Y59R0T/hgyAX4/8zvnEkFNRuNIVfrkKg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199021)(316002)(66556008)(8676002)(5660300002)(8936002)(2616005)(4326008)(4744005)(6636002)(66946007)(66476007)(31696002)(83380400001)(2906002)(31686004)(186003)(6512007)(26005)(53546011)(6506007)(6486002)(36756003)(38100700002)(41300700001)(478600001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ym01cXcwZU00M3l2NWRuaFN0VlladjNsTENLd1B1eDBKNFR2K0g1VkFPS1Jj?=
 =?utf-8?B?R0YyaVRrOHlVcEV5MTArZFF2MUR6V2lscW16M1ZON1hhcllPdVEzYy9kRncx?=
 =?utf-8?B?czNUNzczYVc0bmN0b1FQdFFTMjN2a29zdUY4c0VtN0FmV3Q3MTFrc0xjR21v?=
 =?utf-8?B?cXE2MS9YKy90RkFrYThDUTFPTmJwT0Rwd2lKQTRyblBSMmtQWS9wRnZWdGRW?=
 =?utf-8?B?VnBzV3d2MHFNbE4yem13cVM3K1pOTGRHWjVuVDN4QUt2eGdRbmhLVWpUVWEy?=
 =?utf-8?B?KzdWTm80eGRCOUxVMmg3MWVib3dFU1p1NGgxTkVJVGhnQno5MW4vNjI2WlVE?=
 =?utf-8?B?NDBDalFxK091ZTA2dFVQejBJT2xHSThSdVZLUm9HRktuSzIyWldyamJwQWs1?=
 =?utf-8?B?S0h4Ti8vVW9TYlpZNnZwWXgrSWhhaGtUVHBHMjdKZklqN0E1bGNmR1RBWEtC?=
 =?utf-8?B?c2gxNWM4VGN3cThoLzQ1SUE5Vm43eklSMzdlWitRUmJVWTA0UitEbWRwMlJR?=
 =?utf-8?B?dzZhWHg3cFI2dk1QN1J4bmRnTzU3VWJLR1R1UExFK1F1dmg4a3VZSDNTTkNn?=
 =?utf-8?B?ejdXMm1NM1JzN2tyS3FlOTFyMzk1VUVIaU9ITjk1Y1RlS2JNQWg2WXVWYUow?=
 =?utf-8?B?U3huNE16ZlhaT05CNUpZcFd0VEVoQmJwbExRckZ5eGQyMHdINXo4dFlTM2Ur?=
 =?utf-8?B?MnNxRzVMN25jd0szNVhFeHNZYkNwZ3NISVozL084YTdydTZrS1hpbGU0cXA2?=
 =?utf-8?B?NXZaRk5KY1FZM0tOaUx1TDhEMHdmRllKdmFVb3B0Z3N0Vm5kVmNidkhoL0kz?=
 =?utf-8?B?UjNxTktmWnE3bTVISHMzdWlpc3ZOQUNVVTVTeGVwZENyT3hsbFZjeFYvbUN1?=
 =?utf-8?B?dG1QSXV4SjhaZzhQenJHcXAxa2pZRG5lTDloY1lZNnQ0aFBqWXV1ZlNnd3NQ?=
 =?utf-8?B?d2xkUitWN2hvS2Z1aURFc1NaZU1wMmdNSTFsaDFQTDlnY3RZNWQxdFd0bEFH?=
 =?utf-8?B?dnpJSllzWFF1bTg0Rytzd3JMRnAwb2lDSHBySnFZZ1FjSjRxbDlVNGNGSnEv?=
 =?utf-8?B?L0tYcDlCWHRZdjdCaWt1RWJXTCtNVmpHRDRJeGxRanhJeWlSQ3BsMGpuUXJ5?=
 =?utf-8?B?aU41SkV2dEt6M2lIL2dJUVlSeU5IbmlOS2dGalhMb0dGWGV4Y3YydWlJem8y?=
 =?utf-8?B?L0g3YTM0TzZKOFZuV0ZDdElhT1pZOUpOZXpqZnhCUmhyWkprNjUrZmJkSTg3?=
 =?utf-8?B?Uy80bXFYeHM0M0NtZ21aRkNpMkdyaWtQN3dWWFFMN3hoUTZjWmxQOUdiM1pH?=
 =?utf-8?B?WjliZFNSajBiQk9TS0tua0ZjMXdNQkxPY1lyVUtHR1hCYzRhRkMvSFMxUTZX?=
 =?utf-8?B?Nk1US0RGNTZmbXZjUjRtVHpDeUVBa0RjVGZuUG1YSjhJQ0RVbUVYaURUTWR3?=
 =?utf-8?B?RXdJdE1QUnlXbVR1c3dWQ1ZmQitkL0ZKbFMwam9Db2FmaktHZHlJL2kzVld6?=
 =?utf-8?B?Q3NjWEJOaG5GWjB5UGErdTNldlJaeElXeUZERVBTVE96MEJRdXhrN2I2OE56?=
 =?utf-8?B?aXFobTJaL0hZL2RyVmx3Q2RYdy84WWZEV2xONkN0eGkrSUh1MytnbFhVb255?=
 =?utf-8?B?WmprMnpDZ3Izd0gxZ0dXWGh6Ym1pbGtFWll3VWhIeWM5TFIrN2lLRU1Vcy9N?=
 =?utf-8?B?OVJsV1B5WWMwVHFUbzh6bDZleFNCVUhGOXZTSUROOUNNWDBVYXovbWVHTmJo?=
 =?utf-8?B?Q0dkdm1XZWp0TnEvekhlYnlxNUlhR3E1NEpFYXQyR29ZY1ZKZkFRUzVFUlpH?=
 =?utf-8?B?RmxKWmVVQ3ZpRVlHZklYZU9OU3VZVmx3WXBjVmdWQjl4Z2VxV1NETEVIdVk2?=
 =?utf-8?B?YlBwSTBqY2xER2dHT1FlT0ZGTHJjQlBYSnNncFJwTC82YlpQUUdUd2s0eTY1?=
 =?utf-8?B?bXBwZSt6SEJ4YStuVk1ScmNZUTdNV3QyRThvWWRWQW15Z0VEWEdPQ1ZoYnZS?=
 =?utf-8?B?ZE04M0YybndrOXFhRWRqeEozSTFHOGhaZi9hZzhoTDlncmRpK2luakxac3FB?=
 =?utf-8?B?YmgxN3o2OWVUTkYzYWxnSWZjZ3E4OU1ocWt5WXNBRndYTUlISitDRVhac0pk?=
 =?utf-8?Q?/0WMpSrd57Y5rbWd4+1s9CwYh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486d583b-383a-42d0-3c6e-08db4d7e4cae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 15:35:05.1839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ZxVzfy+95WWRThwbHdI/nDP1VNPzY6L2YFEF3TJXYYyCqafvknbwzaHLrEwZBD3Bc+eT/E0X+k+rafjyJH3xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6739
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/4/2023 10:26 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, Apr 21, 2023 at 06:06:37PM -0700, Brett Creeley wrote:
> 
>> +static int
>> +pds_vfio_pci_probe(struct pci_dev *pdev,
>> +                const struct pci_device_id *id)
>> +{
> 
> This indenting scheme is not kernel style. I generally suggest people
> run their code through clang-format and go through and take most of
> the changes. Most of what it sugges for this series is good
> 
> This GNU style of left aligning the function name should not be
> in the kernel.
> 
> Jason

I will align and fix it in the next revision. Thanks for the review.

Brett

