Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE846475BA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiLHSo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHSo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:44:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559A184254
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 10:44:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAjzDnMmgO12Eh/cK9tLlgp6DyNrQEBVZnc6fQ/NkiQnnz4JY2Z7qb0Vk8/0T5ZhSQ5s6QHYpizJataz+ctTwFahRzn5cFAmvNyTNzhe1qziTS8uReVASO4zAV68l1+nWsWp0bZWdHAnMs3oH74U80vms8nCZCbMnBylPAeSJX/UhcyYtdsXtOI/zAcADLTGmqQTSl5gEYpOGmlTo2Oq9KUR2qNzQhbThSmgkzZ+Mgc7KQ3tk4zCMueDq1PIeU9oVIxXCDjm71h48Eu5HPCNGqGU4mcQzPtpjfBnNMaNRwqHLWvSHM3NCwZ/+di+w7E12B/s6MkKEzeqQv8Svn0h7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6D9SdH8vFeagGMhr1vWASiG2CEo4iuQpc20KfRqsMzQ=;
 b=H0wrBb+ltjeBc0UisoKcIuHIB+mgZYj6KOOVMOGUFkNqtNwW6p3DuNha/sIRS17K6+vYSBix1T608Hh5kucmq52bf+d09zkY6JzyKNHi3YAsdUjkQ1wEA8oZFmyQROfWdE3z36oxObTWEv1bAB2AXV7KfS3mZwU7gdVjvBO3Puy7NT0HZCok8TQDSh2nbJOGCFRFDfsdyollOYbzHBDqKoYPgcVaC1mmvJr049Fgqfw+tNTB7lzQxopag3ExGg5NqiUVk5454NWfb1eqYtb6qvCUCKrBn8OTl68+NeqG9PRY+Dem0UW5u7DO3IDCF3orGaM1ct15WDWZ8ahqfaIO/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6D9SdH8vFeagGMhr1vWASiG2CEo4iuQpc20KfRqsMzQ=;
 b=bYUz2XcCqRPhpPWDc3r47YhIPcOSC9IvckTNm0BAvVff5+A5Tx+NE0HRHiQE79opQRF+qr8mjYJL7WBENMkttbyUBwSRbe30jtcCDxj1gt9v0MRKAO/oVJoxYVN+6bju/R6QCGhxdffhbKIEJNCEenKviNFLq9dfLPP9jU9iS4w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BL1PR12MB5378.namprd12.prod.outlook.com (2603:10b6:208:31d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 18:44:53 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 18:44:53 +0000
Message-ID: <06865416-5094-e34f-d031-fa7d8b96ed9b@amd.com>
Date:   Thu, 8 Dec 2022 10:44:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-2-shannon.nelson@amd.com>
 <20221206174136.19af0e7e@kernel.org>
 <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
 <20221207163651.37ff316a@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20221207163651.37ff316a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:a03:255::11) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BL1PR12MB5378:EE_
X-MS-Office365-Filtering-Correlation-Id: d7e437c2-f84c-4cac-fbdc-08dad94c4b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q/WUD8YSYVna3Y1SRuwpsQoG2vLvMYbp0q7/PMRrTpLqmXWAI4VEY6U2cNHjNE82PYQaZsnDVgz2IED/XEG0HZzFtrCOsPQ1RZ9u6bHzTXa9kg5sqP02iXlMM+XAkeLTgKmUZd3YLtQ85EGpF9Yr0FTDW/iGVEQG1b25VSI6l6awLfpzwSTTf6Hh72SfxO9COEcu5r/FGRQ8WvZXNIMsYDYnKD2FnpM0mX9cl9ZMhA/7AsUPvpEA2GN7gmDIz1EDeZHFtiEm/Ae2Cbb5I0Iphnr4TXnkH8lJmqTH4C+7Teo1bzNnHNNEl9VBQHcxObPY0gHt6poKnOu11CQIcpU4C5d9Vl+LE4IoTCeOV+eV9kXDrnKVMeOkJw+HZDAqR9j5zzclly2m7Q5V/VNDtspfeHudZLR2vQWJPYTH1HR1xrWsKBek3FqrYgpgzbTR8lhUbmGCwmYCbY7wLjaqv6pvqoNwcarw7apeEeIGfCfrQlcctZU2QG5hnf+javM5G01DdiypFr1yqTByJhTmp073OcO2noJYp3rEhjpLhNDlRtkXKYXi8zhYMlrJRsMAeIZvBeMmNZ2eAs/2gQnfBjGVJx+rTCq+uzcsdptPA2wC4sJl7vlE42bZHmSJNv7TQqROtZmO7Viw1rjvlAb1k8yCxEsJrN6yeCRhTx3Xw337bhl3rQzxFdgE5EUns2Cs1vGswxALBgIMWzOREIJv+aBMP0Cyo9Dfz9T45UyQcNVGqy++AAlbKJdphyi45tRZHiFV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199015)(38100700002)(31686004)(2906002)(15650500001)(26005)(83380400001)(8936002)(36756003)(31696002)(316002)(6916009)(53546011)(6512007)(6506007)(478600001)(5660300002)(44832011)(86362001)(186003)(2616005)(45080400002)(4326008)(6486002)(41300700001)(966005)(66556008)(8676002)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODAxdU1FK1BwUnJXRTkyaXVxS0krMFBaVk94MXcwZzM3OWsrSUtSNk5Yc3pX?=
 =?utf-8?B?SlFvSXdmWU5pajFqQjRXMytxbkRpeHF5Y3JoZjFaTExSbncxUE9WZXEzRlRN?=
 =?utf-8?B?V0lJZFlMTkxUTGZmYjZ6YU5zT0lDM1pHYmMvbHk3dGNRRlpBQXVuUTZXMFV0?=
 =?utf-8?B?cTJKTHpiYTVkM3dleFg3NldYZ29kNW54S0VVaStUQ3g0NFZCRzR2aTFGdmE4?=
 =?utf-8?B?TVg0M2xnT3FheG1VYWNVRkRJelNjMDJKL2JIUHkydHVtMTVXUzR6bFVxM21M?=
 =?utf-8?B?cjNyT1MxU1dac2hHeEhmRHJyeklsTXovR093SGF3c0t2ZDRtamhHejV6THJV?=
 =?utf-8?B?TTVUQ1JPZ1pXQ0V2R2NGSjV3R0xiYStid20zYTVvZ3ZyZkp4NFNrYWJ3TklS?=
 =?utf-8?B?aUtSNmV1Vm5vbEVTQ1crME9yV1IzRzgvRGZZd24ydlhGSk42MUI5ZEZnSWFO?=
 =?utf-8?B?cVBYZHArMXJOZ2VJL011YVJ2T0FDZXByd1BPYjJYVWNXSC9hQ09keHdVYTdu?=
 =?utf-8?B?Vi9id1NMeXpaU3NaM3I1L2VIQjlpTEZmM3RSQXpVU24yU28wRmsvU1ZqYUlk?=
 =?utf-8?B?WktMSkplMW1oTWF2amZib00wWklwSlVxSzM5dm9qTVVnUjBuc1labHZHV1Jj?=
 =?utf-8?B?WThSbG9jaUphcUJGZEY1VHEvY001ZmJYaTVrOTRCNmRlQ0ZyaWltMzhJM2xP?=
 =?utf-8?B?WU02TFAzTkQwa2JnUVN3MWdqRk1uUEVPU3dJdGEwOHMvL2tLLy8wUGFPdGZs?=
 =?utf-8?B?Y3B3dlliM0pKOWhjaXdhbGdURVRkd1Y1Rk5UOEFXR2JwUjFSYVlMaVExM1gz?=
 =?utf-8?B?a1l2VS8yUW9PME5mRGFpT2JmaFg5dGxTVGVjQU51UXZXa1o5K3NxcWJYUVJo?=
 =?utf-8?B?RllPYjJCZy82bldDVGtvakVnRndiVElTZC8xV2N4VFMwZ0FTRXVHUVJaWm1M?=
 =?utf-8?B?ekJmZjEzMWsxOEtmbS96MFRBZHNoY1RhN3ZMUFNJQXhMMVMxTG5xdzVOYlFl?=
 =?utf-8?B?MUpvUm1sRm5XQjlKYmQ5UGNKMmZOYTJpSWxEVk5Sei9nOEgwRyswMUV2ZzFl?=
 =?utf-8?B?N0pwUWx1dGtHN3dUUG1ZRi9RRnNGVy96dXI1R1lGTzlZTnhpSkUwVk5LaXRz?=
 =?utf-8?B?cVgvV0FIYkw2TEJ1RWR2bjFrNU9pNGM3UTBySmI3MHpuQmVUdEVCT1poQ3cx?=
 =?utf-8?B?aE9FbkMvWmZnb1VrZld2bG5JZkN3NDRNVnhJeG5UcU5qTmIxT011S2pDL3Ax?=
 =?utf-8?B?aXZwdTlyVmM4NXJ6S3o3TkZudytYZFBqRDNhVU1iQWo3YzlwWFNMME1aSTFj?=
 =?utf-8?B?Y1JIejU1N3hLVHg2eTFGLzA5bHJjTkMxN0JLd29BMXJPeEF4V3Q4V2F3Uksz?=
 =?utf-8?B?cjlsTTB0Z3I0MGsyT3VmRzhmdHFUbUI2TWlXODQwbXVKbGtSVmdCdXh2a21W?=
 =?utf-8?B?MWtSbDk1ekxMQm42Q2g0Qmc2bURtd09NVGlubHdxNUNsSjI4UGMxQW1xb0U1?=
 =?utf-8?B?QWFzWWFleVo2cjlWQ0dFdE9FZzJvRkZjRDlSYmZhcDhIK1BHRWoybVE5b3R5?=
 =?utf-8?B?Q1RUYUl6elFiaDVzSlZLaGRMbFY2czBhd3RHVHlkWHdxdnlIQ0NmbWFWYW4r?=
 =?utf-8?B?ajFlUjJCcnk4dUpyaGI4a0FITW04YmxQL2NqY0dPdXpwRG9nMmgrL3lIL1kw?=
 =?utf-8?B?dUdRVkhaZmNrcWliM2ZBQ212M1NrWEZwdG1NanoxdkduUE9xcXlueVJkYVJY?=
 =?utf-8?B?bDlSRE5NSGI1ZkZJbVNSKzVYbnorc2xrVU1meEdyUVdZaXhSY2tvQzBDUnJQ?=
 =?utf-8?B?TFZPK1ptSDd5MGExRkYzVGpBWDlqdGUxSkY3RXM0NU40NGdLeTVhZnpSSHZk?=
 =?utf-8?B?YXl3d08rMWJla28zbFRGNFJRWGJkZGUwYWFsUThzM2kxMzlnZEkrbmhaK0x2?=
 =?utf-8?B?QmkrSVh1dEsrVUl2Mm9UWmNTQVJUbTZuMnlTVStRa1o4Yk5kcjVkTEdrb05S?=
 =?utf-8?B?Nmh1YnluNXVnUitocWtBeFl5bDNDYTdvM2NFeVNyVHFtWEpPb3NkOEh4QXFh?=
 =?utf-8?B?YUVYQ3hGMmVKWWFDNVkwRWI3UnR5a001Q0p0c2dYNGhiaUROQ0swUXdKNENE?=
 =?utf-8?Q?UUJwu0BbJm4AxFP3EwaUdGlDV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e437c2-f84c-4cac-fbdc-08dad94c4b4e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 18:44:53.2430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFjsrDbGV41scpU9Ed5HA3M1T4u6HBGzbe5RJnMkObIM5xTes8/TonnZ6SR2Z2f0JpgZa8PDFHoP2Zt/4iYp6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5378
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/22 4:36 PM, Jakub Kicinski wrote:
> On Wed, 7 Dec 2022 11:29:58 -0800 Shannon Nelson wrote:
>> On 12/6/22 5:41 PM, Jakub Kicinski wrote:
>>   > On Mon, 5 Dec 2022 09:26:26 -0800 Shannon Nelson wrote:
>>   >> Some devices have multiple memory banks that can be used to
>>   >> hold various firmware versions that can be chosen for booting.
>>   >> This can be used in addition to or along with the FW_LOAD_POLICY
>>   >> parameter, depending on the capabilities of the particular
>>   >> device.
>>   >>

>>   > Can we make this netlink attributes?
>> To be sure, you are talking about defining new values in enum
>> devlink_attr, right?  Perhaps something like
>>       DEVLINK_ATTR_INFO_VERSION_BANK   /* u32 */
>> to go along with _VERSION_NAME and _VERSION_VALUE for each item under
>> running and stored?
> 
> Yes.
> 
>> Does u32 make sense here or should it be a string?
> 
> I'd go with u32, I don't think the banks could have any special meaning?
> That'd need to be communicated? If so we can add that as a separate
> mapping later (so it doesn't have to be repeated for each version).

Works for me.

> 
>> Or do we really need another value here, perhaps we should use the
>> existing _VERSION_NAME to display the bank?  This is what is essentially
>> happening in the current ionic and this proposed pds_core output, but
>> without the concept of bank numbers:
>>         running:
>>           fw 1.58.0-6
>>         stored:
>>           fw.goldfw 1.51.0-3
>>           fw.mainfwa 1.58.0-6
>>           fw.mainfwb 1.56.0-47-24-g651edb94cbe
> 
> To a human that makes sense but standardizing this naming scheme cross
> vendors, and parsing this in code will be much harder than adding the
> attr, IMO.
> 
>> With (optional?) bank numbers, it might look like
>>         running:
>>           1 fw 1.58.0-6
>>         stored:
>>           0 fw.goldfw 1.51.0-3
>>           1 fw.mainfwa 1.58.0-6
>>           2 fw.mainfwb 1.56.0-47-24-g651edb94cbe
>>
>> Is this reasonable?
> 
> Well, the point of the multiple versions was that vendors can expose
> components. Let's take the simplest example of management FW vs option
> rom/UNDI:
> 
>          stored:
>            fw            1.2.3
>            fw.bundle     March 123
>            fw.undi       0.5.6
> 
> What I had in mind was to add bank'ed sections:
> 
>          stored (bank 0, active, current):
>            fw            1.2.3
>            fw.bundle     March 123
>            fw.undi       0.5.6
>          stored (bank 1):
>            fw            1.4.0
>            fw.bundle     May 123
>            fw.undi       0.6.0

Seems reasonable at first glance...



> 
>>   > What is the flow that you have in mind end to end (user actions)?
>>   > I think we should document that, by which I mean extend the pseudo
>>   > code here:
>>   >
>>   >
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdocs.kernel.org%2Fnext%2Fnetworking%2Fdevlink%2Fdevlink-flash.html%23firmware-version-management&amp;data=05%7C01%7Cshannon.nelson%40amd.com%7Ce9ecb748ecab4e58305f08dad8b44e43%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638060566193141649%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=0vhs4ErnQcPoXxkdT8ltnqbJGpiydrpIj5zS0N08uYo%3D&amp;reserved=0
>>   >
>>   > I expect we need to define the behavior such that the user can ignore
>>   > the banks by default and get the right behavior.
>>   >
>>   > Let's define
>>   >   - current bank - the bank from which the currently running image has
>>   >     been loaded
>> I'm not sure this is any more information than what we already have as
>> "running" if we add the bank prefix.
> 
> Running is what's running, current let's you decide where the next
> image will be flash. We can render "next" in the CLI if that's more
> intuitive.
> 
>>   >   - active bank - the bank selected for next boot
>> Can there be multiple active banks?  I can imagine a device that has FW
>> partitioned into multiple banks, and brings in a small set of them for a
>> full runtime.
> 
> I'm not aware of any such cases, but can't prove they don't exist :S

I think your banked sections example above satisfies this question.


> 
>>   >   - next bank - current bank + 1 mod count
>> Next bank for what?
> 
> Flashing, basically.
> 
>> This seems easy to confuse between next bank to
>> boot and next bank to flash.  Is this something that needs to be
>> displayed to the user?
> 
> It's gonna decide which bank is getting overwrite.
> I was just defining the terms for the benefit of the description below,
> not much thought went into them. We can put flash-next or write-target
> or whatever seems most obvious in CLI.

Maybe "flash-target"?

> 
>>   > If we want to keep backward compat - if no bank specified for flashing:
>>   >   - we flash to "next bank"
>>   >   - if flashing is successful we switch "active bank" to "next bank"
>>   > not that multiple flashing operations without activation/reboot will
>>   > result in overwriting the same "next bank" preventing us from flashing
>>   > multiple banks without trying if they work..
>> I think this is a nice guideline, but I'm not sure all physical devices
>> will work this way.
> 
> Shouldn't it be entirely in SW control? (possibly "FW" category of SW)

Sadly, not all HW/FW works the way driver writers would like, nor gives 
us all the features options we want.  Especially that FW that was built 
before we driver writers had an opinion about how this should work.

My comment here mainly is that we need to be able to manage the older FW 
as well as the newer, and be able to make allowances for FW that doesn't 
play along as well.

> 
> I think this is important to get right. Once automation gets unleashed
> on many machines, rare conditions and endless loops inevitably happen.
> The update of stored flash can happen without taking the machine
> offline to lower the downtime. If the update daemon runs at a 15min
> interval we can write the flash 100 times a day, easily.
> 
>>   > "stored" versions in devlink info display the versions for "active bank"
>>   > while running display running (i.e. in RAM, not in the banks!)>
>>   > In terms of modifications to the algo in documentation:
>>   >   - the check for "stored" versions check should be changed to an while
>>   >     loop that iterates over all banks
>>   >   - flashing can actually depend on the defaults as described above so
>>   >     no change
>>   >
>>   > We can expose the "current" and "active" bank as netlink attrs in dev
>>   > info.
>> How about a new info item
>>       DEVLINK_ATTR_INFO_ACTIVE_BANK
>> which would need a new api function something like
>>       devlink_info_active_bank_put()
> 
> Yes, definitely. But I think the next-to-write is also needed, because
> we will need to use the next-to-write bank to populate the JSON for
> stored FW to keep backward compat.
> 
> In CLI we can be more loose but the algo in the docs must work and not
> risk overwriting all the banks if machine gets multiple update cycles
> before getting drained.

If we are going to have multiple "stored" (banks) sections, then we need 
an api that allows for signifying which stored section are we adding a 
fw version to, and to be able to add the "active" and "flash-target" and 
whatever other attributes can get added onto the stored bank.

One option is to assume a bank context gets set by a call to something 
like devlink_info_stored_bank_put(), and add a bitmask of attributes 
(ACTIVE, FLASH_TARGET, CURRENT, ...) that can be added to in the future 
as needed.
     int devlink_info_stored_bank_put(struct devlink_info_req *req,
                                      uint bank_id,
                                      u32 option_mask)



> 
>> Again, with the existing "running" attribute, maybe we don't need to add
>> a "current"?
> 
> Normal NICs have FW on the flash and FW in the RAM. The one in the RAM
> is running, the one in the flash is stored. The stored can be updated
> back, forth and nothing happens until reboot (or explicit activation
> /reset). There is no service impact of updating the stored live.
> 
> Also note that running is a category not a version. With the components
> I gave above running would be:
> 
>            fw            1.2.3
>            fw.bundle     March 123
>            fw.undi       0.5.6
> 
> So all those versions are running...
> 
> Current (in my WIP nomenclature) was just to identify the bank that
> running was loaded from. But bank is a single u32, and running versions
> can be multiple and arbitrary strings.
