Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DD469E9D8
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 23:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjBUWDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 17:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBUWDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 17:03:33 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAF210AA0
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 14:03:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz+r7F1UWDrFSNZf2Q5mMyezfaoQaThHllGjmKYb0uHr5opZOjUXHTg/T2EpZ/nX61Nkbfg4OvzAJHvNGT9jHoVZFs6tpD5EqMdiWEr9aYeLXTbb/GiIOjaY1ihSB1MtA6/82D2psChYYhGoQQ4kQsHeRLJsjp85+08uc+hRZPCjE9EFkCyI3lwlxKQe5k5fv8MkfvLRet7kBBK4N/4knJ/0sTlfxcUwG5MCb94/lIucJaF8AqN+YTRXQxJv8WdWXg63wc9ThD5j4t3BLTVbeJ1pw3HFffFw5U1E2zb9PyeN6ZSnjksAOugwO7uj+yJ9CTVse27Qn46lxWP6II6o/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JcHmoB079f4IKW4h7s2DJAriNhMv71XvF+FFt4Yi9A=;
 b=geaV5R2mFJyIrd0xdi5L3oatzJvh6l//m53FnHcwEGDRJZWdfhYg6+Y8tye3jhzjz/KlXVsGC/aLb/d9D9R16FdTZwe+GIbSkXPGh7iPkJ4V+xxm3zBFWmw79ueamaJA4V/neRiF2TXgQxWbIxfhesbpO9mFmOPMK+syQGezFUrxnP4OrbvSJlRNxjq53BbHU4R4qLbc4RK4ta40TtJ4gf+RzOTr/1PMogL2jcwabGsOdnv1XZoOiyV5+y4CYTG0i4ldfMatyExx23rb5H+rt9TJjD7So15V1NEDTSarL3PRX9hkCM8INJTlkpBYRYABSpVWtPpSvB/wNSPpth1pSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JcHmoB079f4IKW4h7s2DJAriNhMv71XvF+FFt4Yi9A=;
 b=x+wP09xHnMk6O7ykkk9vgyJiomZL483yL7i1SeKT0njOXp4j8RhqoC7JYKUtF4Oz/gOO6SMztoj4uPaKvnHO58a1IcygeaDG6RX7gR/OWtku0g9Q06RiYHWycDF1wgkw/NTYcEUwDuCEy2iWc4hsiA0Qr8fIJ5KDP4cw168cttU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BY5PR12MB4305.namprd12.prod.outlook.com (2603:10b6:a03:213::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 22:03:27 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6111.018; Tue, 21 Feb 2023
 22:03:27 +0000
Message-ID: <71f2f2cc-44e7-c315-2005-0b23c8f812af@amd.com>
Date:   Tue, 21 Feb 2023 14:03:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v3 net-next 00/14] pds_core driver
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <Y/H14ByDBPTA+yqg@unreal> <bea899bd-c7c1-80cd-8804-e6a3167ea9eb@amd.com>
 <Y/RqeOVZaGA6nIW9@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y/RqeOVZaGA6nIW9@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0240.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::35) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BY5PR12MB4305:EE_
X-MS-Office365-Filtering-Correlation-Id: 79406e09-5e19-4914-e3b9-08db145775cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YSqAZpJpGW+AkcT94bkrbjD3JNcN8lg67VnB5ajaMhbTZMRWWD9wKaApEizixa7LlYZzHlLoBmwayUgMkmm8mCG+3PSMUOf4nlgzBUFE0TGyDhr01LDTkrozOuZ0T1UxTP8qQpPxLBDZ5CredXzQwJxq6raaKOljkkEpIdVf7WeJZAejnnMmdxoKL2zjoTmHgfKi0IZYMQ+j1i5sV1Dwu8YerxXVFCWd6aaxkOAeOy6ozCB6KrNBI/Jl92Lay3znIFC9u1kZNvycs7WtLH9Ig3M3bZ5lHUO7isIRoZAvPuxJBiEBnwU3dkEY8ir0n40vVR3qC7KAFkGeBa+bCC4GCbKNF/ARdINGbQKntDXW33h2GAY0JkbXg7pDyAJCfJaqegqV+eWRbARM0DgQ8mcI2DU7f2cA0ts3EcNB9Wzv+0/moE4eLfK5IOy7B/CIcK5jAjKZ/STi/9LxVR/wTyW+tVKiUNvMtkqKGSz62DiVWnMJAhLrv8ZXt0S3lRor+ZLnzSmOKNeqCeWxui1diYyWlOpmQwn+XTdy3SrPaykD5SFFswayVtzEAlz+NCqSWvJraEw2Z4j1/WP126xDD/PxNj6D4NLhU7WKaFYanckd0881nsfksAvohTe//k28oTUDiEY5tpb2qpVrVPB0llm2dsJ1tGW6NJ+p5WZcODXP/K8k/tERPT332aVokkAeXzSqy4AHg+sjM1DU2MUb64SOMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199018)(8936002)(5660300002)(4326008)(41300700001)(38100700002)(44832011)(2906002)(478600001)(6916009)(2616005)(86362001)(966005)(6486002)(36756003)(31696002)(26005)(186003)(6512007)(31686004)(6666004)(53546011)(6506007)(316002)(83380400001)(66946007)(66476007)(8676002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1p2bXZVaDFFTTN1NWtMYzBMYVlnUk8xb3FuVmNmTlM5UHVtWTFqSDFLTnJl?=
 =?utf-8?B?Qy9PQ1VaY2podEppYTB6aExJWFI2Mmc2YjVpcUIwa2tkSUZPKzMxdVVoUTd1?=
 =?utf-8?B?UVhiNVlBMDdoZmpzSjR4cGV2TmpjWTZLUFBiRE1mMzZxNWN3UjFUWWpKU250?=
 =?utf-8?B?TkwxUEppVmRpRFdHY09lV21UZ1hqb3ZLc3ltME9jNGZXcWpuMGhXYUhpWlN1?=
 =?utf-8?B?N2NZSmx1U0lQQWJYRjBFVkNzMm4rNUg5YVVGTDQ0ZUVTSTh5MHUyRWg2YXQ3?=
 =?utf-8?B?ejZhcW5MRmJXRDBicFAwaHdQV29zSEkyNmIzbVNzVTg2SXEzVHl2bVB3QjE4?=
 =?utf-8?B?UUh2WUhLMi9BRlJJaGtCY1NKNnE5RHFoNnVIV1RlRWZKMlhHeEMvRWowWjFB?=
 =?utf-8?B?MnA1YkhQb21kN3NEeXVBTjBYNzNiaW56Ry9xZ2VVRVVtbk1yUjRKclZXL09s?=
 =?utf-8?B?ZFJKaFBuSFlMQkdPTWVPdGhLV2svbHFTVS9BSVlyMXhhL1VTWGYrcVJKUVQ5?=
 =?utf-8?B?aHUyK1k1UE9ZMmN3NEdPWUlvOU1XMkY3TFpibG85YUhxb1dneHg2VTZwSitp?=
 =?utf-8?B?dnlUb1RsenY1Nit0ZkNvQzZWVnJNMzZJWmh6VllHWXh5a2tJWmw3dEVFVDZL?=
 =?utf-8?B?QS9LU2R4NUNPa3VyVVVEWUExaHV6SWFBRmM4RUROaWtHd1ZHL0JEM29Qdm50?=
 =?utf-8?B?dGpqT0NYYm9YZ3lnVUpKUzY4R2dlblIrRHJsUHZ2L3YyT25oSGp1N3EvT2tX?=
 =?utf-8?B?RjB5UU9CendjUmdud1FVQWlsdWJxSW4wb3lOZnhzNzJCa1h3SzdUM2htSTkv?=
 =?utf-8?B?TTQzUWoyNzNBWDZ1alhWU1ZDNVFoMnVaR3ZkSXEyOU9RdXZHbUhQaGlocjk2?=
 =?utf-8?B?d3NOR1dET0VuNVVBVlZkTis1aTRLN3B2bG5jRm1KRUNtNWllOUloOW1zSmhu?=
 =?utf-8?B?a2FlNmNyWThGaVptcFZtclp5R29hZExlMUY5T3MrZithdVVTQkI0RFo5WUlj?=
 =?utf-8?B?MmtldTBYbHN0M24zVG95K04xVEpheDhNUXB5SmRQS0RCeG5Mc2pIdFZyTTcw?=
 =?utf-8?B?Z0c5L09aZi9iS09jekJlZzdKeGpRNlE0OFd2Znd5WnJrRjRpOVVmeTBMdnZn?=
 =?utf-8?B?Sk10WFVqVnJVV2RuOGp5MVVIU0ZIVFZ4UVFIbWt0RHZwRldaYjdHSXFMbnc0?=
 =?utf-8?B?Q2M1Qkw5TWNOTHI1YjNLQmVNWkZKdlhuejFiM2hhVEhHbFI5cWhraG50QXc4?=
 =?utf-8?B?UEFQNkNEbm1qbVBORm43VlBLaHg4WkZRMDZKd0NlUzRlMG9HaWxIdC9JZWNn?=
 =?utf-8?B?R2x3NlBDRFhXd0paQmZjcXNOTjR5UEdwYUhRTFhML01GdHB0WUtrTXp3dG5q?=
 =?utf-8?B?N3RONjBSWDZZZzBsYXlFbmg0N3o4Vk95UFlMWDRjQjU5VmxqVDA5NGlrUm9i?=
 =?utf-8?B?L25lNkYwcnh1bnVDQ1JkaFEwRWh0cHA3Vk01OUdtK1JCY2crVE04UUdlWGVz?=
 =?utf-8?B?R2ZTV3BTTmRXaThUZkI5Q2daQVA2Q1JVUVY2dkF0Y21jdTFMVzBscUZiT3pl?=
 =?utf-8?B?WEdlWWc2M3BCL0I0T2tYVit2QW9RbTRXQjlZSWh1Nm55QWltTkhXS1NCR211?=
 =?utf-8?B?Mi9yRktqUlVSdWp3dHhiNmV2VHJ1amxNWFZXbUZPT1RxdStkTXJpUVFoeGd2?=
 =?utf-8?B?UUdRUlNWeTlwdWwvZzNuZ29MTENpakg1N2kxYkxUS2FFbzB3UE1iUGFibG04?=
 =?utf-8?B?c2NLcU1vK2g1UjJmT3JNLy9jdkZuZ2tTSVB4a0dhaHA4MUpBbDV4RXhrWDVK?=
 =?utf-8?B?eHhlamNPUTdBa2ExdUZIaVVKSmlHUGdGOVZJaGt2SnRJYjZaRFJ2T0I5cXdx?=
 =?utf-8?B?ZnR6bFRWMmRVZDlWOUtFcjNaSk1xNXRBVmJsVFZ5NEtyYUliVjZ4Zno2ejN0?=
 =?utf-8?B?aktjWnRYSTBmZmFISG9BcjNVSE5ia3I1a1M2MzI5ZFM4SVhHek9uVUJpRVpi?=
 =?utf-8?B?c2h0d1RxRnhHR09WTG5sWlZkVEFERkJUTFA1VDlNbG9Vcm5KOWFFSXJJZzNu?=
 =?utf-8?B?US9hR1IwOHQwUGlLWVNpcklMOUN2TUhEWldaRjZ4SWUwZmF6R20ycGN1TCtZ?=
 =?utf-8?Q?VVxavqLFstKMAWyDSC8iNA0VB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79406e09-5e19-4914-e3b9-08db145775cf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 22:03:27.6356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CruEsfJZcQtRq7Z4PKmtmNK5yIBciju+s3VFvsPE7cii5VjWr2K5K8OjU/TSEYf+SBtI79WtxS14cex01v3Y9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4305
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/23 10:53 PM, Leon Romanovsky wrote:
> On Mon, Feb 20, 2023 at 03:53:02PM -0800, Shannon Nelson wrote:
>> On 2/19/23 2:11 AM, Leon Romanovsky wrote:
>>> On Fri, Feb 17, 2023 at 02:55:44PM -0800, Shannon Nelson wrote:
>>>> Summary:
>>>> --------
>>>> This patchset implements new driver for use with the AMD/Pensando
>>>> Distributed Services Card (DSC), intended to provide core configuration
>>>> services through the auxiliary_bus for VFio and vDPA feature specific
>>>> drivers.
>>>
>>> Hi,
>>>
>>> I didn't look very deeply to this series, but three things caught my
>>> attention and IMHO they need to be changed/redesinged before someone
>>> can consider to merge it.
>>>
>>> 1. Use of bus_register_notifier to communicate between auxiliary devices.
>>> This whole concept makes aux logic in this driver looks horrid. The idea
>>> of auxiliary bus is separate existing device to sub-devices, while every
>>> such sub-device is controlled through relevant subsystem. Current
>>> implementation challenges this assumption by inventing own logic.
>>> 2. devm_* interfaces. It is bad. Please don't use them in such a complex
>>> driver.
>>> 3. Listen to PCI BOUND_DRIVER event can't be correct either.
>>>
>>> Thanks
>>
>> Hi Leon,
>>
>> Thanks for your comments.  I’ll respond to 1 and 3 together.
>>
>>> 1. Use of bus_register_notifier to communicate between auxiliary devices.
>>> 3. Listen to PCI BOUND_DRIVER event can't be correct either
>>
>> We’re only using the notifier for the core driver to know when to create and
>> destroy auxiliary devices, not for communicate between auxiliary devices or
>> drivers – I agree, that would be ugly.
>>
>> We want to create the auxiliary device after a VF PCI device is bound to a
>> driver (BUS_NOTIFY_BOUND_DRIVER), and remove that auxiliary device just
>> before a VF is unbound from its PCI driver (BUS_NOTIFY_UNBIND_DRIVER);
>> bus_notify_register gives us access to these messages.  I believe this is
>> not too far off from other examples that can be seen in
>> vfio/pci/vfio_pci_core, net/ethernet/ibm/emac, and net/mctp.
>>
>> Early on we were creating and deleting the auxiliary devices at the same
>> time as calling sriov_enable() and sriov_disable() but found that when the
>> user was doing unbind/bind operations we could end up with in-operative
>> clients and occasional kernel panics because the devices and drivers were
>> out-of-sync.  Listening for the bind/unbind events allows the pds_core
>> driver to make sure the auxiliary devices serving each of the VF drivers are
>> kept in sync with the state of the VF PCI drivers.
> 
> Auxiliary devices are intended to statically re-partition existing physical devices.
> You are not supposed to create such devices on the fly. So once you create VF physical
> device, it should already have aux device created too.
> 
> This is traditional driver device model which you should follow and not
> reinvent your own schema, just to overcome bugs.

Not so much a “bug”, I think, as an incomplete model which we addressed 
by using a hotplug model with the aux-devices.  We felt we were 
following a part of the device model, but perhaps from the wrong angle: 
hot-plugging the aux-devices, which  worked nicely to simplify the 
aux-driver/pci-driver relationship.  However, I think the hole we fell 
into was expecting the client to be tied to a pci device on the other 
end, and this shouldn’t be a factor in the core’s management of the aux 
device.

So, the aux-device built by the core needs to remain the constant, which 
is what we originally had: the aux devices created at pci_enable_sriov() 
time and torn down at pci_disable_sriov().  It’s easy enough to go back 
to that model, and that makes sense.

Meanwhile, for those clients that do rely on the existence of a pci 
device, would you see that as a proper use of a bus listener to have the 
aux-driver subscribe and listen for its bind/unbind events?


> 
> Additionally, it is unclear how much we should invest in this review
> given the fact that pds VFIO series was NACKed.

We haven’t given up on that one yet, and we have a vDPA client in mind 
as well possibly one or two others.


> 
>>
>>
>>> 2. devm_* interfaces
>>
>> Can you elaborate a bit on why you see using the devm interfaces as bad?  I
>> don’t see the code complexity being any different than using the non-devm
>> interfaces, and these give the added protection of making sure to not leak
>> resources on driver removals, whether clean or on error.  We are using these
>> allocations for longer term driver structures, not for ephemeral short-term
>> use buffers or fast-path operations, so the overhead should remain minimal.
>> It seems to me this is the advertised use as described in the devres notes
>> under Documentation.
> 
> We had a very interesting talk in last LPC and overall agreement across
> various subsystem maintainers was to stay away from devm_* interfaces.
> https://lpc.events/event/16/contributions/1227/
> 
> We prefer explicit nature of kzalloc/kfree instead of implicit approach
> of devm_kzalloc.

Interesting – thanks, I missed that presentation.  Sure, we can pull 
back on this.

Thanks for your comments.

sln

