Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D4648B2AB
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241681AbiAKQzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:55:38 -0500
Received: from mail-bn1nam07on2054.outbound.protection.outlook.com ([40.107.212.54]:65511
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232425AbiAKQzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 11:55:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfpVOBzypCJ6c1CWhIT70MNsM3Btq1NtYxFB+WZsyDway5upWQFl1RLsqAKZl012RTx1vc8Y+AMEkJD6hZftTu4P8qkBM+Kd5bZDngUFlm952TTiVyqpj9y3u49tQeIqeTZfVFqx1a0niLHvTy10Bc/ygeLBiSfuHygt+6+DJR8rWQNh19QRweAiyilL3KX6WaU8HF4FwJrLKGQtor2IxwVIheBquJZeo7v2niWN9Hp+Vy5CICrfAZJ2Cw8BviKGwTPH9SaK8SXOSrDyC7Ws9azu7gqdB+QOCvWHpmzNt5bL6B+x6w1spmnDEV/8wesF/5X2IFi/XpnCjg4u2z8Rlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZw0sf73294iNQ4/btEB5tFgqNcd+ko0exbyYW8QllY=;
 b=NZafx5UxEbq64mIaconExd39V/L2bI75Gm8y97qDoH1AxZtmxxATp58yVqqOO5Dchxgor4c2DgyKx4YAISMyNsczXJ6Dxn/QmyLZDi7y+RYHSEl5JQsq79nGmexMKmcrlXG96a7GudSshdD0KQSI7vdVgXeYTgrQxSo5ydT4Jq0+gphQb7LZdjjt6Pyhdqu9V1NG8AkeW/Z2lZwPawl4bURhkaIAtB7uo5BujoS0EyxXY3vILi2SX3hvwI82u1COh8qnXCNreQ0pIRe3gfhgl5NcOhtw0qAy4ltdX6SpNwJX1dy0Yv06IwRv16Jsgo7/aAtqLHU6DRgKhVD/o/PF8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZw0sf73294iNQ4/btEB5tFgqNcd+ko0exbyYW8QllY=;
 b=jJbUJWxnx7mWvoOj+FpFUbb23VEU4DeINfY9JjmadG5mPf3ORrM3dTX0g4K9bwmrFlyomHkJfXuQhZsDl42Z0YXbwmyQjPN1kLXkWPrwq/FUIc582ooIaoLDQ/4YtplDPC6DieMITwpjcyxAYV3fbypxIN3bax8x8oTzuqtJrxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 16:55:35 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4888.009; Tue, 11 Jan 2022
 16:55:35 +0000
Message-ID: <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
Date:   Tue, 11 Jan 2022 10:54:50 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <YdXVoNFB/Asq6bc/@lunn.ch> <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
 <YdYbZne6pBZzxSxA@lunn.ch>
 <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
 <YdbuXbtc64+Knbhm@lunn.ch>
 <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
 <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
 <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
 <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
 <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
 <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0010.namprd05.prod.outlook.com
 (2603:10b6:803:40::23) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc1abeb5-7b20-4b93-7786-08d9d5232f9b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5380444EB58155B314BEF6C3E2519@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FSDLlOVx21ejGDfScpclBPhGgEOGl+ifg6iy88hkuLU6bPw2s+3QbANuInktcfLKDm14t/inl30nvFNAPb63ZIL5xsxmicduqRMXjRK7nGL4IVR3cN09NwD1lFIZIw59gnt/d530G3tPmOOmm3ykop9klrlH6mslMQK4lic13y0ocrLiKLpUp83ewGIyXR1j7T6tUz3eYQKbL7ztryke5/NYkk41zX0tVrUE6tCBseWh4tssOmBeYxdmcIogA0TYDR/t6wVNPzvMA7IwVuqQSF/hn4xiL2Vo4CH5b3KH73sFoVO3e8XNXk6k7KnYUNV39ikzthDtrngTLxmFnIoBmsxGJqhVJBMud9Mzgc8ApOmSfhPEk6mJV754yYzBFZxNq65B1qLpoJjQmUS0pTOGfGjWAHP4+uaGyGgk0ZvvMYqX2V/NsemNppPRHia86weIzvUJ9hLeZxApFu5wXLiZERh8UqXS0ZooSQCQcdYporEt693CAMKHuW/w66vd7Pz757WwvcInGG40Vqu05VKHHP7QIArA0teeOataSdaJ4ZnmqWjrMjUHHbw42lGGgi/TX5ddXc2QK9f9+DWAX/JB/kdBKTXA27Rk/ZKIvLTR/OXhvrVbLydN0/uV9SibETINaXrGQDypoloxwDkk3vLlErJcz//z+cvO+wscVHTB/pFK5CIcwmU6J1045HCHtiM8CKz3Fcy+InMTjlvxvaz8CKKa/URkwI8RuZygB+CRZtFY3vrsSQKWbhDzwGs1xCTw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(5660300002)(6512007)(508600001)(6916009)(2616005)(66476007)(54906003)(316002)(4326008)(66556008)(8676002)(6486002)(66946007)(8936002)(86362001)(31696002)(6666004)(38100700002)(53546011)(26005)(6506007)(186003)(36756003)(7416002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDBkWWY1SUkxTEppaW5JaGtGQzM5WkRZd09DUXlZWVlCNExZZEdQNHFtN2xY?=
 =?utf-8?B?NXdVeTdLcHBycVJVVmFJMmd1NHNZTU1CWHRHVWs3NXM4dlNWWWloRXBUVUNG?=
 =?utf-8?B?ejhHVWxXWERQMUoxSjU1dHh2cjdDL3hzMkl2TVhPUUtjR0xrbm0wQVlqYWYr?=
 =?utf-8?B?QUY2YkM1VGtGNXRyMW9oTkVZSXBZU2RRSmJiK1JxQ1VNcFB3dmRnb0JSem9F?=
 =?utf-8?B?cVNiSHZqVjY0dmZabjlTK3ppT0V2cE5PSWRqaGViS3pKeFZPTkRQQjAwWjBZ?=
 =?utf-8?B?eCtLNnA1a1o4bVcxak5nRGR6VHBFbDQ5SktmUHFhYWIxdmIrN0lidUVPdTJF?=
 =?utf-8?B?TXBXRG8zK0tpVTJtNTRvNTNQWmV5VFVlNDBMT3dHNDk2RDhrU1htdDhNc3dw?=
 =?utf-8?B?QXhRM05uR3E5emhsZTlmLzNlaUdJS0N0UG82SWtlU05YczNQbllnRzBXVXI4?=
 =?utf-8?B?dXhwd1UxaVl2VkRkSUFVcEQ0VnEzcnJWcExReElkTlp6ZW1IUWpsbytmOFYx?=
 =?utf-8?B?V2NuVm0xZFV6UUpyT0h2QlYyb3JBeFBHV0RFRzZaV2dFem4zd2NCeUVsWFJV?=
 =?utf-8?B?eXArbS8vaktLS1p0M0RCaVpGcjBTd3FIV3R2K2xGNHpCOUdRUmpkcmVvZS9G?=
 =?utf-8?B?L2dValM1b04rUHptS3pvcHZ1SDFKK3Zmc0FZQVBnRkVQOUx1b0pRNnc0dHll?=
 =?utf-8?B?VGlUMm1KVHZuZFdOTlhCNFJJQkFDK08rRHZybVlLNWNUQkZmRGEySjZmZkw4?=
 =?utf-8?B?U1VRL2w3Z1JlRTZLdWJUM3dEY2kyd3ZSaGJldFVwdU9xbk0yRVVROEcwVWFE?=
 =?utf-8?B?SHVjYnJJRHMzcUJiQ1ltVElpeEJmWDQvVllPelM2Ri9OL0pKUHVBMThPVjFs?=
 =?utf-8?B?TjF1d2tQcHVqeHFXbzRxcm1VOUFxOFArZFI4M3luSkd0eTR2Z1QwRmJ4azVO?=
 =?utf-8?B?dWRzcDk4WVFQK3RwWGMyQTI0ZjBSQStmdC8rK0tjTGFTVEliZVE3SGlGSFIy?=
 =?utf-8?B?cGs0US9YWXhldk5aN0theVlEUHBPSldIYTFPSlRUVGRmQ3hlUVdvdGpjZlJr?=
 =?utf-8?B?dXdUYXhORnd1WWp4ajJHWndnY0ZQTTFadThqd2FFUzEzN0pnZVYzMkM3TWpC?=
 =?utf-8?B?VlRSMmZhRnNxeStGRGEyZnRPRDdNMUxKZU0rdHhYV2VZeWkxWUR6S011RHhG?=
 =?utf-8?B?VUJWRjF5d1Z0M0Y2SitBZDNpdjN2MnNHOG5hQnhIRkVIcU81RC9EQjRqQ2RM?=
 =?utf-8?B?SFJIUWxSbmlqNXZJd09GL0dVSGVXSCt6alRHZmZrSzFLVjNITUdZUnJESG5P?=
 =?utf-8?B?QXZ4NmtLeHAybFpGWmo1MmphQ1JBUVY1RjJqaDlRMkVVTE45QXA1WVEzQ3hz?=
 =?utf-8?B?V3EvTUZSMEtvSjAxNzd6M2pSblNVWEVGQk9aU3RCZDk1TFdUSGV4ZVowRzk2?=
 =?utf-8?B?TjZyVjZJc2pleDFxWWpxeHV1ZnJBRzhENlFYeTVHTUFtTEE3ZUF0Qyt0TW5i?=
 =?utf-8?B?bWg1cmpVaENsM2t1MnpqdUgrdDdZOEF2MWhyU0IxYmpnTGNrSDI0V0dmR01u?=
 =?utf-8?B?bWI4ekF6bmRGN2tZR25mdFZDc20xRnJOWTJxZU9UczhmN1czMTl2VVhUREc2?=
 =?utf-8?B?bTlSN2RqOTA5bzZvRkdFeUM1OUZxZzRLNjFUaGR4ZHpGRjJZSmdPTFZJMWI0?=
 =?utf-8?B?ZkdlUTFKNFI1dXZwcGUwczVmODdoZkpQNlVLSDUxQlRHeHNRak5COGhkSGQ4?=
 =?utf-8?B?aWRoM3BEUGxjYlBIN1RSWW4rQzQzTjgwNWE1M28weWZ3Tm1OZFJrYnA1cHY3?=
 =?utf-8?B?M0VuRUhtNGxla3hPQ0Z4TFgrZFFCbW1iUUtIREZrU1NBdzFkTk5QUEMyeHY3?=
 =?utf-8?B?UzlqbEdVQ0RVaTUzVTRMcjFqRHg1YTJPdnVaN2NZMHEwck04QkZadXFsbW1V?=
 =?utf-8?B?L1RiWjN2eUloUEJ6UXdOS25ZaU9CRmZ1c2szM3gvY1ZPYnZtaWl0NGxVQ2w4?=
 =?utf-8?B?dEp2dndiVEpCb09WMWxiSzJ6bUYzQ2h3TnpGOUdWRUhXNUNLOWo2ZEsydE1Z?=
 =?utf-8?B?OXZMZG5HZXUyVHpvRUpMTVZaQzJ5S29KK0JZM1Q2Qy9aZVZkckJlWE1taEFq?=
 =?utf-8?B?Ykxlb0ZVMzkzbWxnc1ZBOU45aHpYV3ptM3VEclN6amlRRGlZUmRTOFNaeHhi?=
 =?utf-8?Q?sDF92HdqKavc7sSeFZZPVPA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1abeb5-7b20-4b93-7786-08d9d5232f9b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 16:55:35.0175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NquAHl7keo4bpjluDojGHBwQmkkYUhsRBEbW5/oca23Z38gT9pVATxwIAnqdUpu5Qua8I1NcWBtIS7QofARBlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/2022 10:43, Jakub Kicinski wrote:
> On Tue, 11 Jan 2022 10:33:39 -0600 Limonciello, Mario wrote:
>> If you end up having only your pass through MAC used for Windows and
>> UEFI your hoteling system might not work properly if your corporation
>> also supports employees to use Linux and this feature was removed from
>> the kernel.
> 
> Right, I think the utility of the feature is clear now. Let me clarify
> what I was after - 

Thanks, I was looped into this thread late so I didn't have any context.

You prompted me to look at this patch series on patchwork.

We talked about this when the initial patch series was developed and the 
intention was to align what Windows does.  That means that all dongles 
or docks with the appropriate effuse blown take the same pass through 
address.

Anything else and you lose the element of predictability and all those 
use cases I mentioned stop working.

> I was wondering which component is responsible for
> the address inheritance in Windows or UEFI. 

The Realtek driver for Windows and the Realtek DXE for UEFI.

> Is it also hardcoded into
> the realtek driver or is there a way to export the ACPI information to
> the network management component?

On Windows there is no indication outside of the driver that this 
feature has been used.  It's "invisible" to the user.

> 
> Also knowing how those OSes handle the new docks which don't have
> unique device IDs would obviously be great..

I'm sorry, can you give me some more context on this?  What unique 
device IDs?
