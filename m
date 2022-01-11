Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B004248B245
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343708AbiAKQe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:34:27 -0500
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:28000
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240478AbiAKQe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 11:34:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vn2iBckQPioeff9xFCCBqoUS5SstoSoPmJjiHYtY0Sn4K/NPeLKRGCtk/wcm6lMNc+rsPZBHV6zzJ6qmwn0KjBbkpQglZqmCwm8S0wsdmkbV2BvMMSeOLU/Ns1ksOmVptIaz6sZJ41GjK6wdhMItcGAqA6ePH+fbkMe0tzoP4u960ue/8vv7bXFfdndotsZ2zcASSnlZEelD9Qz3KGE6qIAYwG2JX/QBz9UqCLMYm9jRnxpi8LoEBTjZh3DTfCLxAb7oP2nEDStRVyH4oe6/XGm8zlYAod/D/7PjcYSiNTjbiWei6gKyzgUhamARTZhoTlFNb8MPDd8Wl8CUb7CJfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFB3ii2za+LXHV3oAs9zCxqDF0cF0ftumwv3tXjg1og=;
 b=XK8EoIAn//VYWm9iFxfEPMjQMPaCRMU9fk/Seu22MC0W4FVY9+ZKsxXq9W8+iASSzXfRjjiQcdwH9IKC6e01p/YLp4kPux9zMc79eMOvc2Xi9+zYsw2uUF1PqibAhaA0CkEXDMvRSMQattMJHaDhZYi1tvOR4wdfdtZFP1VsR2qmecZ0jmXT1l13z3M4Q/XJYQYhe7UGGkasOWCUyRiFG6yhC/xuEVD10tFwPKK1VrN1Bz9oSwubjo6J7b9s+yb/E2uf/6TigMrmo46MvVJ8Qu4duNp2OVia7ryjbDxCZS+YAWQ7BxdW48jQGbrIDg/QNV1ug/E4vdBibK6SG3Eipw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFB3ii2za+LXHV3oAs9zCxqDF0cF0ftumwv3tXjg1og=;
 b=c9/jFOh3IascXVwNnfahWCwsOoOJKJjT86/SMAlBe9RW+tQnBhAzM4pUCRJnVY+24bHffmLFXC4eMJFlB5xlpTs7W4Kr/4QSXOh52GK8zN5WFjhd/EBgaRlHVBKM9jJRruo1oseFwOF0xyCS7HXfhwihAbY42nM3xWULdm9KsMc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BL1PR12MB5128.namprd12.prod.outlook.com (2603:10b6:208:316::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 16:34:24 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4888.009; Tue, 11 Jan 2022
 16:34:24 +0000
Message-ID: <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
Date:   Tue, 11 Jan 2022 10:33:39 -0600
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
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0017.namprd04.prod.outlook.com
 (2603:10b6:803:21::27) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4db78b51-741e-427e-a413-08d9d5203a47
X-MS-TrafficTypeDiagnostic: BL1PR12MB5128:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5128983989E0901EE26FDC24E2519@BL1PR12MB5128.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I38UaQ6qAp0GDBwxO76Bvw65LhuvCkfrvT84TG6tE+lRqy3/8tOudWearAEcpYYwE4ImFMdaAe3dD44yjuX9ubJrYn2GbxtExzUaJO5qc3gYQH1faSLpSLuNsnbMLPsVocXMG5M2H5U5UFb5YYpJt3J82BBSMdxyxd708qRaq1d9sNWxK1UkWcx5MWYM0oqA3BhY9SMyVWx5IRHsB4QGiw4w8H/cDDxxVmzt4Q0I3OphuAhExl891vWa4iJXH3TR8pdGwZ3t4Ba7sTEcRZeG1RuLXD7wrwin2F1iUo1ZSoPJIb3y4GgId6IjzKhQiuqqeHnJhe8UJFHAYk+LcrdaUOkF0bpJ3KbB9k3wA/VmaqgVWGCeIIAfpz+ZmoOTzFtZEDtGFsPxLvmrk2IMZ2a0zysUqUG1KlZgSj0aNQEAzcXPYFN0Y7QeE5JrZ1L5qNRAH6DZcfli+OuLqTKRbK/9nUg6zK3bWc8kfnONjK1T7GrfWBamLa0CCGzIoRc2IWPr/GsJhZvePH6dvsqLRlHwA2PHnyuru7HH7ONUdjdMDr6TxsVsSxkrKtUaBTvMtvV3yj9FQ+SQOXFvAFplPsFZZx8eFWmSD2tJ7NsO9namAX3MmQjclHJbJZAceCHQoVGzZ/GW6rZh4zRGYXY8rdOyAYwNrJ3KxTNUh7ZP2a0Ft//CxaVCjYLWuu21M3n4QdT1HdGQqhbcHH6m7u0iT9sPqfe4gz+fllnhaKgbJGjsYFAeSXxWXgoiasg5lA5aY3AG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(7416002)(316002)(66476007)(6512007)(8676002)(6506007)(53546011)(54906003)(8936002)(186003)(26005)(66946007)(66556008)(6916009)(6486002)(83380400001)(31696002)(38100700002)(5660300002)(508600001)(4326008)(36756003)(31686004)(2906002)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHRBTjAxOUlQVThDSk5FRXpMWjlVQklpL2MzandML3VkYm9ZM05ZRnowS3Fq?=
 =?utf-8?B?amdxVFJYZFJTUTUzMDUxMjN1aHBBbGFGWk9uVzdoSWdoZFF6djVBazZYOTlF?=
 =?utf-8?B?c0JPUkthWWxTZ3drbngxRjBmSVpRV21lV25nTVRraGMrZVZzVG9ZTUdKNmpG?=
 =?utf-8?B?ZHFpK0NpUTIxaHVTUGowbmg2S3BqSVBPd0NRWk9IbU90MktZVm9NcjBURUpv?=
 =?utf-8?B?Wk9oYk9JSENiWkNwWExqWnFkeHJGMk9STjRzcmlvTFJPVDhLZUp2UUdkL1NP?=
 =?utf-8?B?ZjBEUlozbUhpOFdISWlyeldFRTVqWFVDT2tmVjk3ZkVUUmtIT2xaTjcrUHo1?=
 =?utf-8?B?SzJDTXg1QXVtSng2aEh4VUNJQmVqT0NjeUZ2VyttUHJ3MjU1d0xiYVpkMVBI?=
 =?utf-8?B?R1pvdHBHSTNMZ2xhb1hCMHhSekEyOU9MalNQNmNvNk9INEFwUDBudXNUNy96?=
 =?utf-8?B?azM1NGNkSUhSeEJtM0ovMlk1RklVaFMweHo0cUhKaWNrS205Y3Yra3pRL3Jv?=
 =?utf-8?B?WnZucjhWNWRLTWZic0J3aEsxZ08ycmZJTnVmOHNiakc2ckttZUJLdHdYSits?=
 =?utf-8?B?RlZEMUo3M1p6SHNXQVJHbG5BTXdWOEFFUWJIeFpMckhQUWpWcWxadnZmblU2?=
 =?utf-8?B?czdDMEw2RVZla00yOG1hMnNvdVVFd0xnTUU5WGRqTExzb0xWQXBOVFZLQlEv?=
 =?utf-8?B?VWxlY1V4YlFRUEtXVDdrM0MrMzFadVFRa1g2TGlVb1pJM1VHaytlNDQvNmpt?=
 =?utf-8?B?L3JocXVDVVpiL0xXcU8rbFkzckdkZFhTaTk0dkFtblJhc2ZHOXhtSy93blFE?=
 =?utf-8?B?YmVKNFgvMURUS0JtZlJGRXRCdjcyNUhqSmJiU1RKYzZoVldqS3BkNWV3eC8r?=
 =?utf-8?B?ZUNrbUM2cWpaWHFHZDBvSko5STZiNkR6YWdOWldpRkxlN3RPUTU5L3NKUGcr?=
 =?utf-8?B?TkF3bVZwY0p6eWhmTWtLclROVXBFbE1pVGRlMEE5RWFYaXgybFpDN1pEbnov?=
 =?utf-8?B?SEdiYkl5TVM1ZUhCTkwrMTBCRkxGTXhjcWk5c3MybzNNOFArOUl2OHlkUlRI?=
 =?utf-8?B?c1RiRGFISGhiQk5VZGhnZXgrN0VXUWxpZXRrOFpYUFZEaWNyNFFnWUZENE5P?=
 =?utf-8?B?QlhranY2OE90eVl1bENFOWpHYXh6cE5DWk8wUHhmOWdnVk5OWlNxeG1FZjVa?=
 =?utf-8?B?ZkczZWhyOU80RnV0WGpkYVc4MFd4dFlORTFWL3BVcnREQjM2SjBqQVNGbWxP?=
 =?utf-8?B?UmR5MUEyT0sxMFp4THUxZEFsb0tXd2ZjRDhTNEFtSUpuSWZONW0vY3pYWHdT?=
 =?utf-8?B?MUJmM1hMbU9EWHdQK2FzQzI3aVJTTDR2VXpZYzNWb3hrNkVjUzVxeTJ5Z1FF?=
 =?utf-8?B?UDVWZUtRbzkrRWpLR1BrcmVDRTVHUEkvT3R1UHg3VnBZNUVVRGRTT1g1Zm9O?=
 =?utf-8?B?THVTdVhLMm9HWjlQNGhIK0Q2Y2ZSNUliN2MzckpWbStRZVNsT05XbW03bHBo?=
 =?utf-8?B?cHVJTFprRHpWS1RWZjE4VTZhYk05eTh0MGhYZ00yL0JZN3Nub1hHZWIrekxI?=
 =?utf-8?B?T1VoOHVrZW5jSTkzUDJsNlh4eHROSWtndFExY2l4OEFvamwyQzJhMW1xekwx?=
 =?utf-8?B?ZDFJc3ZpN1dNUzV5SllQQ3NQbXFEaitNdjBRUUtmUW9PbldsdnBkeUpPc01B?=
 =?utf-8?B?d1llNmIrNnZqOUpOd0J0bzZmMnhESXlDRk51emM2b21BRWMzZGVOVDlVRC9r?=
 =?utf-8?B?RlpyV1hDNnhFYU5yaVo0T3IxY04rUmYzZ1ptSzFnNTZvTGFIYjdvVElOcXZo?=
 =?utf-8?B?TGtYMWNzVU8xaThNWERIRDJtbG1UbFQvWHF0ZlRkZWxPNmwvdDdqZUk2NkRx?=
 =?utf-8?B?YldyQXNuOUlMSTUvdkRZWWNoUEQ5WEpMTFRuckJHWStTUUFLQ1RnYmlQOUZm?=
 =?utf-8?B?WFJ6M01uVzRyTXE1aG0yOGsveklMUlVCdTZHb0lvYnVmVTRFVVJ5TnBVUmNz?=
 =?utf-8?B?RWpTdUpTc1BMYXI1bFRZNkMzYzZlVDhFdDFNMVEvaHdOYjg1aW1ncUJ1UkZl?=
 =?utf-8?B?TXk1UVZka2dwdXVUZ3doT0VpWUNyZExhWXNQQytHSjhhOG82SjB5VVp0bU1k?=
 =?utf-8?B?NFdaSExyZHFWMjBjUk5ibGFUUHJYdjF0STN6N3ByeEsvUWNES0VRbWYzZFg2?=
 =?utf-8?Q?CAvkiAfw0ThJeVthRCWP8Ak=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db78b51-741e-427e-a413-08d9d5203a47
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 16:34:24.5578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j1l20dHUhrJ+MXm8gd5QYi0qeFlSz82muEMYjW8ahMUxydDkam3FBILpNcc2x3rLAEJXsb9+mKQKTaJmJwd9og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5128
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/2022 10:26, Jakub Kicinski wrote:
> On Tue, 11 Jan 2022 08:57:39 -0600 Limonciello, Mario wrote:
>> The important thing to remember is that many of these machines *don't*
>> have in-built network controller and rely upon a USB-c network adapter.
>>
>> I recall a few reasons.
>>
>> 1) Consistency with the UEFI network stack and dual booting Windows when
>> using the machine.  IOW 1 DHCP lease to one network controller, not one OS.
>>
>> 2) A (small) part of an onion that is network security.  It allows
>> administrators to allow-list or block-list controllers.
>>
>> The example I recall hearing is someone has their laptop stolen and
>> notifies I/T.  I/T removes the MAC address of the pass through address
>> from the allow-list and now that laptop can't use any hotel cubes for
>> accessing network resources.
>>
>> 3) Resource planning and management of hoteling resources.
>>
>> For example allow facilities to monitor whether users are reserving and
>> using the hoteling cubes they reserved.
> 
> Interesting, I haven't thought about use case (3).

These are just the cases I have from my memory when we kicked this off. 
  There may be others that are now used too.

> 
> Do you know how this is implemented on other platforms?


It's entirely OS independent - but presumes that there is a mapping of 
the pass through MAC address of the HW to a user account in the hoteling 
cube reservation software.

If you end up having only your pass through MAC used for Windows and 
UEFI your hoteling system might not work properly if your corporation 
also supports employees to use Linux and this feature was removed from 
the kernel.
