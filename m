Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580946A0312
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 08:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjBWHCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 02:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbjBWHB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 02:01:58 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6404BE90;
        Wed, 22 Feb 2023 23:01:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUbBhGJNAZUcjKBJr+N17XqH9WL8K/YrzSBPZwXXrxFx60861hBOdF1AiPYEKw7ura2NNQH0aeS6YOJlrSMKelZHCm5q0GbUFj9y3/sl/bKfbYf7zvcjfhs9G6f4avk0MF18KAkYc1fSpTLUkW8aMCosNO8wZyVIun7n3liepenrKjvXxKpIGKvd+v1iUmkC+GvYTgjU0D4ZW4q+u/pWayqSoAD3KSvEcz8fRdh7o3fC0SZ+cOyDuH9YiOXIgwHQbSr7FklJZP7xv9Ja2guwpnw8qUPUMmq884h4sPmFY9KwDUCAxzfP/ihsHXKi1q7NIPsUbCiTpl6gUzRDvzSKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LdhUws/oLDWSsYD+yYbysea94iqJwqeIa0uC1kA8MrQ=;
 b=heydKrYWI3YddNKueOdqzYaB/Etv3ks2vakclkGvP8gZYnNLLPWYxsov+SIHlvamta9Psj2fx2SVA/mwV8DF9Oghd95Gc2hJqfTiTqUgFJI+wi1zBqFQLrbB+4yhr2s8N/4JNjWNc0babWlEp/20sonBCIfSfsSAb2vkNaU+MOuocxAkd8eEDq6YX9yFG1WQw6A4q/KGBGKzQYl/VrxagZGcD2cLupTDk5b357CLqTiW6Hr3faAYsYQLndu06IvA5oeRUc7NUEnGWAkuEhJGgVtc+gYBH6AMR9O2Qbk58h1mVMWcvx3QOisZiG8ke4R/+/f+zNFWGsXC7Ktq9T7gAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdhUws/oLDWSsYD+yYbysea94iqJwqeIa0uC1kA8MrQ=;
 b=v4cziAVvDsV1BaQXh70F2hfYqrI493YjJzACmLuKj8KndRZleKlIG9oDZVU1CnpL/PMSlg9lTp5+4BJkygBwFt3+8zpuM9dn9eL6ZHsTqIRQUP7eYRFsuRBktd9Wvn8dfeWEEV7AnEN5Q1ie6hPhrX9yHVLesNSB16svxBD7wvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1390.namprd12.prod.outlook.com (2603:10b6:300:12::13)
 by PH7PR12MB7283.namprd12.prod.outlook.com (2603:10b6:510:20a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Thu, 23 Feb
 2023 07:01:37 +0000
Received: from MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::8b33:613e:152c:2c0b]) by MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::8b33:613e:152c:2c0b%2]) with mapi id 15.20.6111.023; Thu, 23 Feb 2023
 07:01:36 +0000
Message-ID: <a797f017-4233-0464-45fb-0d9aeab6b4e4@amd.com>
Date:   Wed, 22 Feb 2023 23:01:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 vfio 0/7] pds vfio driver
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
References: <20230219083908.40013-1-brett.creeley@amd.com>
 <Y/MTQZ53nVYMw9jI@infradead.org>
 <4220d8d7-1140-9570-3d6c-ba70c4048d98@amd.com> <Y/QaVdnL+URV7oAk@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <Y/QaVdnL+URV7oAk@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To MWHPR12MB1390.namprd12.prod.outlook.com
 (2603:10b6:300:12::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR12MB1390:EE_|PH7PR12MB7283:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bfe9ef6-8fc5-4515-8ec0-08db156bcdd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lwnr7tXDAN3zln1TBuKomDXQNCeq9pKCDfwQdVZS/4U0RsoME/PEgPxDKl0Bj9x+epSYWfbWx+PmbJleKOSYLyTj+Uqzgy9/idZTfrk8CCJ3BNRS6Mvg1VaNAdeLb+ff84hvit57l9gtTQxZqGZkWXohQyGKauRk7Czb/dlcneDhL/WEnfAdPa65WPJaqNPp/7EH9bYRI8o79dDEBLwaBH4JOazkKRCtNRLuawnEZgZ5LXuXN14CMCNJYokDOhqmY9XZf65rbpFV2b1ca0/3HSSaog5f0gu+FwOSzBuDfdUzWHfgHrGLUgYsiLQUc1nhPVpxQjzpLBZJTP/OqO07++wk5ZBgryCbyQH32hrIUFlvNuct/1fqZh8wVeraUiTPdwlg3Cebu0AfKY0yS+ed0b0U2lsfZuzULyJSpOsNkL7yqu1qCFl3vOx8uWlOeX1K5keBd/1ESkov2Mxs7mPGsLJcb75r3/YZH+0upWBm/HW8qz8szVQq5RHsIL3FGAWZD4qR55EdV1NZb8WaGjFT/VubImhYdNJKP5AjBUH5bp5lcdLLahgctHvIPKj0pjD7H4zTjU4RIKVUR+7W27cs97SwDz1vHqpMraOJiqGLsV0JR9y3O+K6uNcwEt4cF2WQYETYC1nAIc0xOgSnKFQbHn6tQkKrq1eURgtpTzzekl/otp7hHSfk3JGO1mjsl1o7C1ib9Ah/FVcy7Jl3dmimTrQ5jXLlLAcwbhCHhFI+s9M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199018)(38100700002)(8936002)(83380400001)(31696002)(36756003)(41300700001)(7416002)(2906002)(5660300002)(26005)(186003)(316002)(6666004)(6512007)(53546011)(6506007)(4326008)(2616005)(54906003)(66946007)(66556008)(6486002)(66476007)(478600001)(6916009)(8676002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckxpLzN3ZFcydllrbUowUE5MdEJBRjdXT1p1cHZQK3R2dUFnT3c4cjdmdlJZ?=
 =?utf-8?B?NXdFRWdlazhEU09weXFvNk9wT2dRRkJYekFuM0Z0UHlldlZmYTZVZkhDaXdv?=
 =?utf-8?B?V0J0Nk1LRkszRTY0SkJzcDV2M2hzNUVJVWc3bkl2UkFwMXdCMkpMSDAvY1hJ?=
 =?utf-8?B?Y2VpZmFNL3ZxTkFJUkZTbzdVTjhUREJJR01ONTU5YlpMUnpYbnRRdm5weE5B?=
 =?utf-8?B?S2w3R1JOd2E4T3ZVUVNERE1SN2ZYUmllZFJFaExqVEtmREViRTRLTllFd3Np?=
 =?utf-8?B?emRnQ3NRYzQrNms5bDJONFM3ZzBIQTcrRk43NVFHQk9QT0JJakhXTVdVdk9q?=
 =?utf-8?B?aWZJcGtPRnVpcUR1TlhVVW0wUGhpT203K2J6MjBmVDByaTE3S3E1UFBXN0kw?=
 =?utf-8?B?elB5bDU1QjJmR0xaa2tubXlPa1Y3ZWVmOVpUS3B3UHFINzI5em9IVmNCdGtR?=
 =?utf-8?B?SC9EaWxyWE0rTVhFbnpzUXYzd3pKU3ZDQ3M3ZXZBZHVVdWFlaW9yenBlUHRK?=
 =?utf-8?B?Z1FaTXZEamJiMDdIK3ZvWmJObVF3UmV1MGIrSElNS3hMb1J2aHFsYWRxZTFS?=
 =?utf-8?B?eWN1M2dWSDkwTXE2dmIxMDlQUFM5SWVDZ1owU1JYRS9VcXRjbXBnL0lMN0VY?=
 =?utf-8?B?anpUS0J1L1dabXRVSzM2cUxjTDQvVk5kdnhDdzlmTVFaYm5JWVhkSVlMSWhL?=
 =?utf-8?B?Ym5oTjBLU1h4TjVsekF2RytHZHhPb1hFb3FUbExCbGRFV2d5MzYvSzhoUXd0?=
 =?utf-8?B?cUg0RmdWb1FsaFBjY3R0WGJhcDRIc2JJVyttNUpFNU91Tll1c2k3ZUorNG5P?=
 =?utf-8?B?dG5Fd09XTDlIdlFkOGJBelV0S0VHcjZtR0swV1lKSzYxMXJNTitDQU15RXpi?=
 =?utf-8?B?OTl3eXdyWVJramFmY00zcytyS0VjL095ZGN2RVhQR3B1TFZudlhnU2wvd1Zi?=
 =?utf-8?B?MC9UWVA0bmZ1ZWl0MjZPZFcrOXlTK0xiVm1TS3duYmlKV0NxSzN5TXdUZksx?=
 =?utf-8?B?MHRqL2dRVmJ2Z2d3V2VraTZXS3FGZXZJODA2TGtaUHVNZ084KzJvdXNXcUYv?=
 =?utf-8?B?eVZUZkh4aUo4S2pULzMyelpJZ1ZNSTJXK2w2QTNQMWdDTHE3KzQxS01neGZz?=
 =?utf-8?B?OXdOYjVnbi8veW9xZ1NnVUZDWDdUM1IzZlFHc3hNNVV2TmpmOHpHMDJuMExO?=
 =?utf-8?B?eTFvSGhvbjhEa0gyRzYwLzR6OXdKZGcyeVpOVVpsVTFLUEtHcmFyUWJhemtm?=
 =?utf-8?B?V2tyaEl3VHk4K1M4dFN3bTBvaDhSaElxTUNZVnFvZFBTUkdxVlJ3TEEyWWZh?=
 =?utf-8?B?enAzQVQ4TnJVZiszZDVkc25FdGtTZk9ieDhUQTdHclRIUWlXTDJ1enZtZDBM?=
 =?utf-8?B?Qis3Z1BnNGFHQzhXdnlidTZRbjBJcU5WQVhPaXNVc3RyWUkxSmZMM3FCZFVG?=
 =?utf-8?B?ditWQzZyeFdtcGxXeEtRNUZqZXJSVXdmeWtRTjUrMUVXM2JPc1RaZkdkOTFC?=
 =?utf-8?B?NGlYemcwWHVyZHR0cWN3dzQ3NldON3pDR1VWaFBqbnZYTTJ3TXZCQXc3OGhx?=
 =?utf-8?B?SWc5TktaQncxNzZvLzdhRlo1VHJTeFpXT21obEtodmxoWS9LMjByRDVIbkxY?=
 =?utf-8?B?bXBxRUdVTVVveDkzWGNTWmV3QmF5TEdjUys3d3RKQTRhZ1ZyY2I1VEdTaFVa?=
 =?utf-8?B?Q1pSQzljSUpKSmh3aXhUQzR0bG1BZExuaGQ0RVNuTGNJMm1HeVJjZ1M5MUw2?=
 =?utf-8?B?L2s4Z1ZiNXlDeTg1djVVN0l1M3piaWpSZ1NNKzA5cytaem9uZDdPUU1mbFhm?=
 =?utf-8?B?QXQvREpIaXFudkJNbHRZWDFLQVZ3MS83bUxCNzVYWVRHV3Y2RDYxTkYvemFm?=
 =?utf-8?B?d0dveDdmQ2RVZFhWQW5oK0J2c0wvdFMyY3FXbjVVeVY2T2liRFZvbVg5MVZU?=
 =?utf-8?B?VlQyanV4Y3hWaEExWEkxcHJCWEhvUWk1bklkYi84RjYvUjlSZkJ5RnZhNEk4?=
 =?utf-8?B?eFdRdTJuZVFwd29abXY1MXpvVmRaV2dDTjJrUWdwVFhaNnBHMFdZMXdJNjl1?=
 =?utf-8?B?Vnlna0pWMkE4QzBlU3B5U0xJeFpRdENIQ1ZEeHFLcjIrNkZ3NnRWaVZEejZz?=
 =?utf-8?Q?18GM90+Mhv4QJGRFBlEv9Dpz9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bfe9ef6-8fc5-4515-8ec0-08db156bcdd1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 07:01:36.4772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vj9CC6HYOJXOTjy7cTdGF9lJjCOc7KmG0c5MZCcCNPQFTQajGDMWyjdD0paeIFkPKILbZDzPvmr+EfWe5oErmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7283
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/2023 5:11 PM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Mon, Feb 20, 2023 at 04:45:51PM -0800, Brett Creeley wrote:
>>> On Sun, Feb 19, 2023 at 12:39:01AM -0800, Brett Creeley wrote:
>>>> This is a draft patchset for a new vendor specific VFIO driver
>>>> (pds_vfio) for use with the AMD/Pensando Distributed Services Card
>>>> (DSC). This driver is device type agnostic and live migration is
>>>> supported as long as the underlying SR-IOV VF supports live migration
>>>> on the DSC. This driver is a client of the newly introduced pds_core
>>>> driver, which the latest version can be referenced at:
>>>
>>> Just as a broken clock:  non-standard nvme live migration is not
>>> acceptable.  Please work with the NVMe technical workning group to
>>> get this feature standardized.  Note that despite various interested
>>> parties on linux lists I've seen exactly zero activity from the
>>> (not so) smart nic vendors active there.
>>
>>
>> You're right, we intend to work with the respective groups, and we removed
>> any mention of NVMe from the series. However, this solution applies to our
>> other PCI devices.
> 
> The first posting had a PCI ID that was literally only for NVMe and
> now suddenly this very same driver supports "other devices" with nary
> a mention of what those devices are? It strains credibility.
> 
> List the exact IDs of these other devices in your PCI ID table and
> don't try to get away with a PCI_ANY_ID that just happens to match the
> NVMe device ID too.

Okay, we'll look at revising/updating our VF device ID scheme for a 
specific VF and add that entry in the PCI ID table.

> 
> Keeping in mind that PCI IDs of the VF are not supposed to differ from
> the PF so this looks like a spec violation to me too :\
> 
> You have to remove the aux bus stuff also if you want this taken
> seriously. Either aux for all or aux for none, I don't want drivers

Can you please expand on the "aux for all or aux for none" comment? It's 
not clear what you mean here.

> making up their own stuff here. Especially since this implementation
> is wrongly locked and racy.
Can you please provide more details on what's wrongly locked and racy?

Thanks for the review.

Brett

> 
> Jason
