Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574504683F3
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 11:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345038AbhLDKSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 05:18:54 -0500
Received: from mail-bn8nam08on2082.outbound.protection.outlook.com ([40.107.100.82]:46593
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241100AbhLDKSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 05:18:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrqvXKK3VGCvP0sq8m9ukHbgD2DCTQIcSDtqKE2B0d2HhBQ41s1QpCiK20C6ctPFbwY7mdHIf+DkaGpi80lHLBaKOdux1uwU7XYvbWaRMaY6tbT2NhAro9Pi26bMUUJbZUx4xEK+AZqZMrjCRl3qT8HyiOLJicHsEInItKgKHjOGjuELRqUiGVp0VSQuXzbxYTqLTYGPRRBqehEjJZyJVS29XoPC6vEctNk/EAhjL+dlo/d3cQQ99pd/yfdci6zQ1tdbSoXQcOm13CuCorH+vkC64WfyPlSZGYV3jmm9DagCAZJ1WrsmD6JARhe+nyyl+2KR9rbrOKUA3Iou3glf3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HbrhvhqjMkfXXKniABimzxPO3yavGWhIttQFubYwqGk=;
 b=fAF6COJGyt1BJKNRIJIZYJj8l/4cI/nLrypV2ScvGVRaYJ8fWh8iqVbGPKzC69lsxBnE/IibcCpaAosLg1Fu1hI9FWuybxxxTiMp8C4/e6ntLJfY3KjwRUBZGfOQUNFLohQfYp8OgHsfARq6EK8zyTkAclxZB6BycfDEX6WBY6bbXXqQ7/N8F0BhmG201LNiGjUh3Xeg+UH9UeHfwozlAZ88wES8rKuOAb+Qr7XBsGf4mIFmWm32EapSDhafXkBNAtrckRHjyRbMdoeis76Q/kTANLshyiuG2Z3xN6T6y8vIa//m1kyl+y8TLil8TOzfaFoVa/YYKEthaGJ7dyzAxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbrhvhqjMkfXXKniABimzxPO3yavGWhIttQFubYwqGk=;
 b=BUWhv1AyYycQ2TMud5QhXMWCKcRKcoMEnOh1JXtISRyt9eHiq9CfNY+Mi7XzAdPjL+ugjlISrLIssCZhv7qm149TYVpWnnRWtuDAdqIR90E64ZyqQ+dP5CCkImkj6bz7LXgks443FhgGQS7Qza+DKevIajKZItbt80ZJ449vSzjkLt2cQCQ+TuQqDL+8EhP0/5p7iG3PauBrwMglMbtiMwZNseW8EOMSFr+3RovDROPr9ANj+MpDXdJ39DJmF6vNQdE9NUzPr3WizV47og59Y5HI7fKpW3CyQsaR0yUX4FEfWo7D7rCV/CeiDnEEwwRecQtoqlDkziAb8vP1D4DHBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5446.namprd12.prod.outlook.com (2603:10b6:8:3c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Sat, 4 Dec
 2021 10:15:27 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df%3]) with mapi id 15.20.4734.028; Sat, 4 Dec 2021
 10:15:27 +0000
Message-ID: <9b8c306a-eea0-3d77-c4a3-3406e5954eaa@nvidia.com>
Date:   Sat, 4 Dec 2021 12:15:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, dsahern@gmail.com
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211202174502.28903-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0029.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::16) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.25] (213.179.129.39) by ZR0P278CA0029.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sat, 4 Dec 2021 10:15:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50906f9e-af90-46e8-e326-08d9b70efe20
X-MS-TrafficTypeDiagnostic: DM8PR12MB5446:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5446381FBAD3B42CAC1E0653DF6B9@DM8PR12MB5446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J4nJSWPrkgSUI57ZcNYurKUgVsFrjo05ub+M90TpeRXFCnNHHqnbP+qvFaNjorrcXEF9iQaDR4kyjs1ud1ADGlqMsau8CSUyS93YApnmaF1bmD9eE6sIlRdIe1Owb2GriaaX8rWFKdLrOMc30FjVO/C0Z1H7mXgNA9Yw4R2sGjVf87HMFPDaDgXFy1CVarXUGXc2T9yxpVtvZzR8EyFZeLr9YLwF05s5nDr0p4JKpbaSFKnspJWMKgq++Zx7ZqQfmCfqGvhdzRSA+ZneBrUJpWI7boTuLK9GjbFfOLxFQ1PRQ9AjxovSVMurn5tY5XY/mNDLB1I/sNel5lw+SyqG0E98A/ohHDQiy2M3JB6R1FzB2+MoBv/O6uie+f08/9506fHaMRAUV2sl0jPlBwEzi96SkQ+4CjJ67xuOrsYcCLR1hIaclyPuU90zCD/dkSL8ejNK8Cu/H0ShYA4AKx7ZBP5c3znXwoIKQV2M/mj8LjnVSeG201knCpKwMQSv+uOSjUvA5CpORhBdUYBXfdeG5zuM77lOfOcT8rGpOLrBa3/6ZETqWrL2Muv/V1Mm1ARecbU8BNSRk9DmT4hq0UjW25ZPtWqtZuS145wMJVrbz9U43PMROdkUheUGQDPP3rFN+oyPZo+Bnw0x9vPxvICTn73dI+Ph2ypMgObMqSSH3RsEcxPIpSXmSF+fjTMUs+2AxFLFjs6P/CGCGaH7xt6nO7IRB5l8yF5B+Vk6AeeQpgDN9VjQbe2CqmCI5FLxiogF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(66946007)(66476007)(53546011)(83380400001)(316002)(36756003)(26005)(66556008)(4326008)(16576012)(186003)(2906002)(6486002)(86362001)(5660300002)(8676002)(31686004)(6666004)(2616005)(66574015)(31696002)(956004)(508600001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c05ES0dPdVB0N3d4YzVWKzE2Vm1DbDhoSkRxU2M1d2dCemVPcjc0aUxDVjE5?=
 =?utf-8?B?TDVBbkJ1bFFUVjJGL3Q4MnhkR1pFbzZGc0xmaWRITmhkM1BtcWVRQThqL3hJ?=
 =?utf-8?B?TUtmeVh0c3dEWG9RQmhZNTREVVhGZUJldHBIMm5MZm5IaTBWeU5nSTBGVDdW?=
 =?utf-8?B?cFV2d0FNb0QxelpScG45aUxVQlVhck81WlJTRWZCdGNTZUlkSGpWVUFacXJT?=
 =?utf-8?B?VWtMZ2MySklYOXdPV2V6VUJjTmZpMlVISVFvZVl1QU9kM2FtdGR1cFMvZld5?=
 =?utf-8?B?a004VzF1MzlrZGwwaGtsVXpwQ2tSVDhiRGpVTnJVL0NzVzBSNm1GWjBqcHRJ?=
 =?utf-8?B?b0h3bVhTSDN6TlpEYTJUbkpXVDFpOTVMMEs2UVlnYTgrdnFLWXBjMExwaWQ5?=
 =?utf-8?B?NnhoLy8vQXdUNTNSNHVZUHpLckp4UjdlNmpweUxtY3UxMHpiS2wyNTZ5QzUx?=
 =?utf-8?B?S2lRREpDMEdscGFQcmFBa294RS9jYm1iY0E1cWxNaHllT01xOEVDVjlreTRH?=
 =?utf-8?B?L0NTOEQvS2ZwZDFKRDZHSU54R1dZRUJlTi9CTjdsOU04OXZoaHA4ZTZYU1hK?=
 =?utf-8?B?VndtRXQ2YTlubGxFYVZpcWZSc2Fvd3VPak5YRk1sU3NROUFMd0o3S25QNXk2?=
 =?utf-8?B?N28xOUFQTERQMFBjamE3eVgySURkQ1F1eGNhQzJaa0FRTHZxMjVMWmgwQjRB?=
 =?utf-8?B?VEV1UVVaY20yN1ppY1gydFA4TnJjbHkyVC93c3ZkSEV0Wjl6R2dtMURSNVdR?=
 =?utf-8?B?ZEZzTkxyUTZhcFJndDdQbU5SSmYxT09BZXlQYzNNRHVtYU1wSXdRaUZCaW1J?=
 =?utf-8?B?cU9RMW91NlhyM2ZCYTdsQis3UHhJWmFSNUdETkpOQlJGbFpHbHZSRmt6Uzcv?=
 =?utf-8?B?dXBaakk5NDhjaW5pU0E1cXlzZi84d2lqM2tlaHdRb05xNXlZL0NVcmVlZ0Nh?=
 =?utf-8?B?bDVGd2VYNDdpeERwWFUxVEFYNlVXQTB3a2dxT1JNUTNYbHhZNFZwdnhiTFJN?=
 =?utf-8?B?WlNEWTQ5SUNTU1lGR0NKMUljTGxiMzRVQ3NQOUNRZzRoK1hGVTNpYnM5dEdE?=
 =?utf-8?B?UitkRHRsZ2VwYStWVCtnZlJQU1VQUFdVM2pyaEEwSmE0b3BZMXNOOVRXb0Fh?=
 =?utf-8?B?U1pzZU91VE5rQnNsL1Z4bkZ4cXdBYkh4VE9oNE1CcVlqRU5wdkUwd09vVnVu?=
 =?utf-8?B?a2ovN3JjOGRQSUU4NDF2d2RkOFhsanphd1IzdU03ZkNPKzl2a0Zya1VjU2dw?=
 =?utf-8?B?VjAwZGVsTHVOQ3VVNGVBbTMyTHJEbjM2OHRZbjI5bzMxU3JDajYyV3NxMDdi?=
 =?utf-8?B?MHcvQXN0d2ZKWThsSzV1QWVtQXkwdzNTWm9iK3c0T0VZQU9PQmZXU0pPTFZq?=
 =?utf-8?B?REh0VkZPYzBpa2t3L1RhTzZWRDlIbmJuQ204LzlFVnAzSm5mb2Y4SHlYbWxj?=
 =?utf-8?B?N1dxSDRXUC83YXVnQTNLMDk3cDI0YVU0ZGZVd3pqTnU4Q3RPRE9VZzcvcW53?=
 =?utf-8?B?NElETldXWkRRdHh3MGloSWNjbkcyQ3A1cG0ybHowc0I3endDa1lqMTM4SHFs?=
 =?utf-8?B?MkVYSGp3TUNnRDhybVQwNUtrOElmNkJ5TXhkSGxqZWEvaDQ4RHhpTGkvb1BM?=
 =?utf-8?B?M0R4UFJvc0piQmFKYWs5MXlDYzBBR2ZuNjVTWi9LUFR3V0RPZU9YNCt6ODBr?=
 =?utf-8?B?dUJPQnF2UVE4bmUzeG1ZQ2svTVk5UGhQcUV6Rkw0Wko5QnNsRGV3cDI3amhn?=
 =?utf-8?B?Vy9JQ1ZjQ2U4TklHeENUbHJ3bGwzeXdVM2JRTDRrM0NoMmdmZDMvODlGVENa?=
 =?utf-8?B?OEV0eWdraFpRazFzUHNjdGdPYnB1MkE0UGpZTnRtcnJqdVBlTlZTaDNTdWRt?=
 =?utf-8?B?U0MzZTRGZUNNVk5mV3F2RXVDVUl3SjRvbURXME4yQ3Q1dk5WbXU0eG90aUdI?=
 =?utf-8?B?NUg2aFNHekp4aWlJaEUvSEcrUml6ZjNzN0xHKzl0VGZpSWt1Rks1ZzFJcEN2?=
 =?utf-8?B?VjBLT0RKYlFNcnZRMXJpQURFZ0NiT3J4QUM1QzlFcXF3aHBnVTZzaDFqOExi?=
 =?utf-8?B?T3dVamdMTFRrS2FBYnNWaDcyTllhM0prejc3dU9JMXJYRlR2Z2UyN21lRmZP?=
 =?utf-8?B?dnBjejM0WldRakNQN04vZFFucHJHaUtCN2l2TFI1NHdCeGtXeWdNbHFLcndH?=
 =?utf-8?Q?S0efNLfXlDVr0cPa8xLRyuA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50906f9e-af90-46e8-e326-08d9b70efe20
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 10:15:27.3825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSHrtIaVxQIQygTXfmvN3Z6rDhuevcuMj38NmCmRqZHWudkG2fTYzoxPpVufZff7T8a3QaMQjQ32/9tzE+lgNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5446
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/12/2021 19:45, Lahav Schlesinger wrote:
> Under large scale, some routers are required to support tens of thousands
> of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> vrfs, etc).
> At times such routers are required to delete massive amounts of devices
> at once, such as when a factory reset is performed on the router (causing
> a deletion of all devices), or when a configuration is restored after an
> upgrade, or as a request from an operator.
> 
> Currently there are 2 means of deleting devices using Netlink:
> 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> or by name using IFLA_IFNAME)
> 2. Delete all device that belong to a group (using IFLA_GROUP)
> 
> Deletion of devices one-by-one has poor performance on large scale of
> devices compared to "group deletion":
> After all device are handled, netdev_run_todo() is called which
> calls rcu_barrier() to finish any outstanding RCU callbacks that were
> registered during the deletion of the device, then wait until the
> refcount of all the devices is 0, then perform final cleanups.
> 
> However, calling rcu_barrier() is a very costly operation, each call
> taking in the order of 10s of milliseconds.
> 
> When deleting a large number of device one-by-one, rcu_barrier()
> will be called for each device being deleted.
> As an example, following benchmark deletes 10K loopback devices,
> all of which are UP and with only IPv6 LLA being configured:
> 
> 1. Deleting one-by-one using 1 thread : 243 seconds
> 2. Deleting one-by-one using 10 thread: 70 seconds
> 3. Deleting one-by-one using 50 thread: 54 seconds
> 4. Deleting all using "group deletion": 30 seconds
> 
> Note that even though the deletion logic takes place under the rtnl
> lock, since the call to rcu_barrier() is outside the lock we gain
> some improvements.
> 
> But, while "group deletion" is the fastest, it is not suited for
> deleting large number of arbitrary devices which are unknown a head of
> time. Furthermore, moving large number of devices to a group is also a
> costly operation.
> 
> This patch adds support for passing an arbitrary list of ifindex of
> devices to delete with a new IFLA_IFINDEX attribute. A single message
> may contain multiple instances of this attribute).
> This gives a more fine-grained control over which devices to delete,
> while still resulting in rcu_barrier() being called only once.
> Indeed, the timings of using this new API to delete 10K devices is
> the same as using the existing "group" deletion.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
> v3 -> v4
>  - Change single IFLA_INDEX_LIST into multiple IFLA_IFINDEX
>  - Fail if passing both IFLA_GROUP and at least one IFLA_IFNEX
> 
> v2 -> v3
>  - Rename 'ifindex_list' to 'ifindices', and pass it as int*
>  - Clamp 'ops' variable in second loop.
> 
> v1 -> v2
>  - Unset 'len' of IFLA_IFINDEX_LIST in policy.
>  - Use __dev_get_by_index() instead of n^2 loop.
>  - Return -ENODEV if any ifindex is not present.
>  - Saved devices in an array.
>  - Fix formatting.
> 
>  include/uapi/linux/if_link.h |  1 +
>  net/core/rtnetlink.c         | 68 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 

I like the idea, but what happens if the same device is present twice or more times?
I mean are you sure it is safe to call dellink method of all device types multiple
times with the same device?

Cheers,
 Nik

