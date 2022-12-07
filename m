Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0666664652D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiLGXex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLGXew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:34:52 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029E089AF0;
        Wed,  7 Dec 2022 15:34:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i50NMsnI4kMGkYxAV/vaPcQ99BU0A2d6GuIljlOS2Pr0wOSbQ5+UE2kJkfZcvbw/8fRRBeRzvpl9unEXBER4o0LMX5rbADz4SrZMuY6xZ9ghQmho7s1g5JUclU8Qq8mNaA7Eg/c6bs/RgOmSX11CGUggBhX4MwDz4dN1BeeNcmxd42i/EwZZB2pAnYu6dTW8vKjy9MIFuhXfSnl3cqDGn5ExB1tMGkQUhQflAoSkM6vAXlkJW/WUXqpiSgQPM1/kGfeCai3G8wJVfZk9P0BYLiE7kEsHGoRyMMkjleNJfW2+ws69Qj0YcKl56BDtS7U6U0SwR+MXWoTSO8JTMo6CvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZSOF7IcFwmjejSWYU21OezE61xH48s6gGgbKmlmYgY=;
 b=B1oTlOnAZWoe1/+niAwhHw7ddYJicirDAy1NwvwFUhqwiW/xaSPpYZZMYWPtcicmjPUoYMR1dMoxoMDjG2qk2WEdWYHQAJSat0VqiqFy9XaJ5YSLsVE7XmmjAuhXEatcQeYz4hj+1Ddj2cDEw5CRkd/TX431kyUSMPGePufVEos4jHWJnmDrJQyuBdeko4iHQJR8R0YXCg0/p1WhV+fZLQi6e+vT27wZv+IubGj721Hi2g+Xz/PlH2lkVk3EdveXsdWUsK1ZoFupzbLN/Jz7BIyLPiB1JSuEoOHdoDCWh3fSuaQWVI/wXVNR0KQCcY0bD7loqQG/C725TqfygLJpSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZSOF7IcFwmjejSWYU21OezE61xH48s6gGgbKmlmYgY=;
 b=GmdsyIQb5XV4jhvH5LYggRUpB0YDXNchu32bWGkBZ5TklUohroHT0jyq1RPzOPNyoOxYfYn0lP+u/3nXDQcUDipwyK6g3ykn33alqgPwMKzqRXsCi3PCYUXCVdw51wAyWZxDEe/arhbOxeOFrvNbNFvw8lMxoS2WbLrgraWofUY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1390.namprd12.prod.outlook.com (2603:10b6:300:12::13)
 by PH0PR12MB5403.namprd12.prod.outlook.com (2603:10b6:510:eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:34:49 +0000
Received: from MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e]) by MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:34:49 +0000
Message-ID: <c71684b8-ce9a-ad05-89e5-a2955bd666b2@amd.com>
Date:   Wed, 7 Dec 2022 15:34:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH vfio 3/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
References: <20221207010705.35128-1-brett.creeley@amd.com>
 <20221207010705.35128-4-brett.creeley@amd.com> <Y5DIvM1Ca0qLNzPt@ziepe.ca>
 <a94d3456-a7cf-164c-74f1-c946883534cf@amd.com> <Y5Eh1Doh0d98wz2v@ziepe.ca>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <Y5Eh1Doh0d98wz2v@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0104.namprd04.prod.outlook.com
 (2603:10b6:303:83::19) To MWHPR12MB1390.namprd12.prod.outlook.com
 (2603:10b6:300:12::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR12MB1390:EE_|PH0PR12MB5403:EE_
X-MS-Office365-Filtering-Correlation-Id: 681f7cb0-94d7-4c2b-f1a4-08dad8aba0e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akPu2DskBdGGe28V5o2dppyppkDR5yEkzJiF0I5lsT+cIXmiBWiRzus6qogBjb7FfQ9QrBxly9t9dXaiMH+ZdjYzDgaNJHJFhZLlRiEYjcMcdK5j1ObXuCI8s7svqVMCih5cqTr5i1ZpQSeNBEUIDdfnjHoLYOub002raLdTqYd3rJFJolukj4kBs/MFc91NEoi4lGylXgPhRCuSenhqQLI6hHCZCcKEMo6VROBmTJI3Dm87ULt6/lp/XYIELUJzI94fL6KMtARVrRVY7QtqOpKwIeTgfJeQVN7YmRXRwssNKlFBH8TkYn17AEpIxEF7WgTP+4O90Vp1pmjFDAjOfFmceg8260F9DrMmnnEChQdlVDxPEGddUya1G4rlQ+HF1auIZFJXs7jkVtr45sRjamYk9GNQuXX/NaUU/vu0uaEV2HzVr52zIRNmmsTOCPYzuP5VaWJcQ9gt+WWh5hk30teb4wz59bndUngLDf/A/oin6vkHVTqE1au8friSuXpRh6WimNRa3ijQNGkmFxDXzQ1YzXqiOMp1z69KFIxFTuAfw/sZlWSAhaa5xsima9rdxWzur8ECT9w24tNlEYk3dmyP7u08z4tWM0gvPywQkrzhXAzE/0wFEyC7+XhcESW6WhwetM+5NeEMvIYk9jIg7UKagM2+Gy3oY+Q/2qG2zVDgWgYEvZwQyp8j/a/z+c5ZZssNRBAHMCFTLPo1Diu2Y+hJgw5GUXAZjdPyUPaOYg//SGleFkj9UEiFJCCouWE5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199015)(4326008)(6506007)(8676002)(53546011)(6512007)(83380400001)(38100700002)(6916009)(316002)(5660300002)(26005)(186003)(66556008)(66476007)(66946007)(36756003)(45080400002)(8936002)(2906002)(41300700001)(6486002)(31686004)(2616005)(478600001)(966005)(6666004)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3ZrT3hhVHlSbk1QQkJIQlZkTTZGT2IzQWgzUFZNZTYvNkhrYS9QNDRCVDV2?=
 =?utf-8?B?V2V5ZmpXVzBHenQ3S2p6YjNnN2UyK2lET3c2dmRKQjF6K1BOa3dGMnROWWJ4?=
 =?utf-8?B?WVVGdmxIYWVJQzRrMzZUZ0lGNnRzcDBqWXBWdkJmZjkyTDlsNG1WNGQwTWgz?=
 =?utf-8?B?VHFhNzRWd25ObU03eDNQUGhpdGovUnN1MWY3aWt1aTdGUnMzTzBpT1RRRTFo?=
 =?utf-8?B?UklMVHlSL0JPdjczZytvZ1RsMU1FcTEyOEw0K3BSYjdTbWtiV1MvSEZTL3Ay?=
 =?utf-8?B?bjhrM0QwZHFJbnZId1hVTnRsZC9ubEpPL0VhRTRJUnI2Z283LytvU09QeTJD?=
 =?utf-8?B?YkY3TkRvS3lDa3BSSHlUKzQ5eE9FK1pld2VPZy92MERXRDhBUmRRUXYwYnVJ?=
 =?utf-8?B?RlRMaTIrRmFVMm1xbzNZNk9ZeHpsQ1IxcnBvU1k3TE9XMldtSk5aUEl4Uy9m?=
 =?utf-8?B?TVdnTXg5ZXEydFlHTnZwYlRsUmMwRittUEp0dTlValptUzNBaXlOU1VHSG52?=
 =?utf-8?B?RnFGV3A2N0lXamU4Z0xJV1grMFNEb0JObTlsbjk0UTdGUEdOR1NCYzViZUwz?=
 =?utf-8?B?bmp3eE9HRzUraEFKbWhoWEoyUS9JaGROTERHdElIZ2VWZHA2aHoyT3JxVnha?=
 =?utf-8?B?NHNubkpWMm5ZeGRTQndkbWtDKzFDSFZ2UWhxdzJkVTQxYXhZRHlyS2FBcU1q?=
 =?utf-8?B?b1VZdm1jUFlieVNVaDhRQkJiQXIzVFg3UDlGQmRheTNMdVE4b2lkZWo3QXlW?=
 =?utf-8?B?MXExOFB2RGx4cGNMaTZORnRZdFFvUnRwVlNIRnZ3akNwR2VHRkhSZFh4eVNQ?=
 =?utf-8?B?bGdxNzlPQWYyTnMra080Uk5xdlZ2Y05nQ0JuYXVqNC9iYTNEWGJhWmR6b2Np?=
 =?utf-8?B?bEwyK2VpS2w4MExQVHVmcTQ0Um03Y1NZT21MbzZzdkRENUh2ZzVtR3gyRTBv?=
 =?utf-8?B?WE5wR21ScWZKR1N1WTUrSHpZME5yem54dlZ3Rlc2UHVzWENZeVJtYitFVWhz?=
 =?utf-8?B?VDBVeDBOL3dnZ21nejkxYmgzWUFGMGtMZnhaVUd4eGlZNml3Z1lvejVNTFZT?=
 =?utf-8?B?Q1J6TXAyZllpQ0hCOG1UMHFPRHJmZDNTR1dOdW5hcVVkeHZua0tqSFdsLzFt?=
 =?utf-8?B?NWtIS1F6Q1J4NVlUVFRVWnRUd3FZVDltT0FpUFlFZzdGZitBaWlXdkNoNFo3?=
 =?utf-8?B?WGIwY0J2NVd4LzUvNjFUREpJbTN0T2xWTkRsNDhNU0VManozNUxxa1QyVWJN?=
 =?utf-8?B?R04vZjR1dWViZ0NCVlFWSFdCRVFEcVJKSlBlNDdMeGt2RHhCWWVPQmw1ckt4?=
 =?utf-8?B?U3lnb0dUenBzTUszSE41UldxdU9mdzR0Ylh4RFRNdnBRV2psektVZU10aVF0?=
 =?utf-8?B?N29yVkJ2d21QRkQwVGEvdDBIVmNiamc5Qm8wM1pRbGI0cFBEcU1uSzliaEw4?=
 =?utf-8?B?bVNrcUdIalVCT3NQRTA4TStMU3Nyek8xbk5CK1VqaWlRb3BuOVVqNHJoN3dX?=
 =?utf-8?B?MzgrNktEZnQ3c3VEWlR2bE1CYTdreHJoY0lyNjdtb282VVpmTS94OVJZaTFr?=
 =?utf-8?B?ZDB4NFJCY1QvdDUxaTVKTzgyWmtHZ3F1Qnp1K042ckx4QUJlWGpQOWNiSDY1?=
 =?utf-8?B?VkJMZFlUQ0oxK3hIeWlta0hoNVRYalk0NjY1UWkyTFNDeHMvZHhXV3R4RzNt?=
 =?utf-8?B?b2MvOHNmc1QzRmxiOUJjeVR2WHJoNGxpSERoaGZMdEMweHBsUjIxRTBBS2dx?=
 =?utf-8?B?bDdNR3k1MGxFMVZwVXpRMlRxSnJyelZTOVZ3Z3FKRWJGUWE5U2RnWkoxeDBD?=
 =?utf-8?B?ZjBrZEpXSjY1VkY1OXZwVjZSS2o2dFA4MnhUd3QrMWU3MzFGdU5pS1FBRS8z?=
 =?utf-8?B?N3diZGtvR2U4U2FUeFovSVJkaXc4Wm1oNjVlTERrcEwrWXMvenJyN3BRcDVY?=
 =?utf-8?B?ZUN1M3NGeXAycG5zUFhUWXZBTEtwWm9WZTE3eGpEQllTbElkUFZOR0owbE9l?=
 =?utf-8?B?UlBBSkdJL1pFNEpWR0NyQVpnU21iY0RPYUozWEJaQWhET2MxdUVKYXE4WGR5?=
 =?utf-8?B?ZGY2YmVQbUxJUS85Z3E4VlRJOVJ2UEdlWlc3K1dBNlFqdkhIckFGQi9uVG4x?=
 =?utf-8?Q?4Uv3UtKAMSWUXee8B/svfU+xJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681f7cb0-94d7-4c2b-f1a4-08dad8aba0e3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 23:34:49.1020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rm/PIuY2N0/Ue/e//4hsLHFR+eiYpZrhvCppAnZ1I+ErVxPzlIfKlG+zAZyhnIr0YFaTt/mXYkuDcVwb2GJ7ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5403
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/7/2022 3:29 PM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, Dec 07, 2022 at 01:32:34PM -0800, Brett Creeley wrote:
> 
>>> Please implement the P2P states in your device. After long discussions
>>> we really want to see all VFIO migrations implementations support
>>> this.
>>>
>>> It is still not clear what qemu will do when it sees devices that do
>>> not support P2P, but it will not be nice.
>>
>> Does that mean VFIO_MIGRATION_P2P is going to be required going forward or
>> do we just need to handle the P2P transitions? Can you point me to where
>> this is being discussed?
> 
> It means the device has to support a state where it is not issuing any
> outgoing DMA but continuing to process incoming DMA.
> 
> This is mandatory to properly support multiple VFIO devices in the
> same VM, which is why we want to see all devices implementing it. If
> the devices don't support it we may assume it means the device is
> broken and qemu will have to actively block P2P at the IOMMU.
> 
> There was lots of long threads in around Dec 2021 if I recall, lore
> could probably find them. Somewhere around here based on the search
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20220215155602.GB1046125%40nvidia.com%2F&amp;data=05%7C01%7Cbrett.creeley%40amd.com%7C5b6b2f8d92d34c0deaed08dad8aae13e%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638060525686868907%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=Qd0VLPAL5LTYBXi40N3OfWlIecgIhJW70FIAwL9O1lQ%3D&amp;reserved=0

Thanks for the info and link.

Brett

> 
> Jason
