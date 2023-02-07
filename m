Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E744868E0AD
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBGS64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjBGS6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:58:55 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEFE23643
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:58:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2Ck6ZyhTwKuKMn38A7/wr+aoYvmPeAG+s9KYBZNwmoj8o6YzEnx7nvEEJwkUWe5wf8pBg4nHHemQ1peg4SgkOFg6jKJIXjGt2qZ2F2m3jvGjidJi52oUxn58NtguvB14oeGxHko5/6SwmZBmRtIzj/3aLINSmQfwJg7HWE0J5cAyBVgy8oztZdNxQ6V99f1kQwFgPgOUOxgXhysM5Jq5TrzzjzI36woIQE/UFODPNvNHh8biNYM/g/7Ii0C8QnjlACcPt9RRf8XlfkMS6GLrU9+ntAI2ULIcCTLShc6xh2FPciqBWlvPhhdsIWdd5MvtoarICsVeQmbefKa7KZA9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ellvEMDof2/h1u2xKaF8m/Mx8GVmr1zcbXK6hw9q4Y=;
 b=afyLkYXi/n+lb7enod0aP2BFehqtY+zZHkcnl0vQ1Mb2XyhcjFY5LI6h894wXHX+t4cKg8t6yP+LzdUNIhP89nuYQMwqL0ZIzeHPYiLXiBjM+qTQIKjsjXWxDKPnz24CdSjoWjtBX6+zdVpYHQ5PKzSQ2wUCXkXD6fV7jdBeoavdvYA78MlzdgoZu5YAop+JIU567S4+m9NtTp4tGv5iu00n2y/F+vSnwMd+hbyxP9HaZWzdV4vDgPcq4p531HUdkIkSHUqo+TDY7sVcsBOqZNBZoM6TAn60TD3i5UIYCIxu540rvAi6J/+4XVZbKxIJBoLGipKliERtQob/GwXlpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ellvEMDof2/h1u2xKaF8m/Mx8GVmr1zcbXK6hw9q4Y=;
 b=zQqDQeYvajqghz0K58OqT+6iVTwSyx+KzcxBLMEkIJU8MIXN227urMJVRQmehMsa7n5qdeinZ8OveG5r7nuOm5Kd8lW8ZFV65CkXeEKGPsXdeUoCpIIG/7Li3CtyqK8H13/Oo7c+4QP6tLtujAYUx3ioTF/p00ycGRnztm2owNo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BL1PR12MB5826.namprd12.prod.outlook.com (2603:10b6:208:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 18:58:51 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f%9]) with mapi id 15.20.6064.031; Tue, 7 Feb 2023
 18:58:51 +0000
Message-ID: <1d539934-f937-00a6-3421-b20316f3c541@amd.com>
Date:   Tue, 7 Feb 2023 10:58:47 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 net-next 3/3] ionic: add support for device Component
 Memory Buffers
Content-Language: en-US
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
References: <20230206181628.73302-1-shannon.nelson@amd.com>
 <20230206181628.73302-4-shannon.nelson@amd.com>
 <0b5e7968ba5e18db29fea886c818782fc35f0556.camel@gmail.com>
 <7ef03ee8-5ba6-4231-6eaa-e4a46f9218fa@amd.com>
 <CAKgT0UeC9zFfSM=pLa-a3h-_LgaCrgizq_xTUzf3sS8SaHaJEw@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CAKgT0UeC9zFfSM=pLa-a3h-_LgaCrgizq_xTUzf3sS8SaHaJEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0111.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::26) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BL1PR12MB5826:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e24c553-7969-4a56-9a9b-08db093d59f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ew1bd2Dzao45hD+ozVduTPnXtwNaqwUpPxLNk1thJugZbyd7eJjkC+M4vGw79bd0jYb/k5Njj3RKPksxrGyIBDuoqYl+X0UdTZQMGeOBnCXb4MftW7CASTD/XQtmJr/L8lkx3TDLWQa/GGCR8DAEMfRSe/LtgAcCLvd4JTxCBtIm8OS6GhLuHUZbSDYLuheWsQWK3lhZIkXcetzEnwUKjVbWF6tQWMPuMMLQs8ZLP5CJ2lhAUm5/Cxj6zarbt8t32yHjOacLp1dJkbnvqEXBumFKYXa7ojivclwRihEOzLKb0Q+aZ+QyCoxQ6tyZTJ3/H3xvHq0tlusdLs3FPzhwo97gLTGS5TtorndNCniAm+VvmRpTyAmJwC1P37d+h7XxfwUoxWMiU8tBoNdkecTb5U6DxkNtxL+Fq+rdz2/AlfOCXGpoG/O2Nw8AkumXfzIclAOgAPl1OwB8XMoBz9IWP0N+AEeFB/MPT2enXhy6GtC19NI8wIFoxJkqxW5W8etBpnNuiM+igpv2dx9IO+AegWjmtNJWfGL7/cfcjxf6s/9ywx4KTJOS+OQa6JCBb83HZiGkZ69H0MJkg6gVDbnElsUPHqmqJ5IvGQFC7ULnH01FeqyeMivC7s7QXAM9ULMCyJOMr1VwDEt8ZGeeJG+RMrZFyJKGY28LxEZhNLNDJhZ18d9ZRzlwcl8BKSwa9QF1N5DxmYZhtWaYjxRrrnoczRflLfvYNYVPOveMSKv0yKQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199018)(31686004)(186003)(26005)(6506007)(6512007)(36756003)(53546011)(6666004)(8676002)(6486002)(86362001)(66556008)(6916009)(83380400001)(66946007)(31696002)(4326008)(66476007)(478600001)(316002)(38100700002)(44832011)(5660300002)(2616005)(2906002)(8936002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWYrckp2bHpubUlyNWNlRkk3NEovMWNUT1N5V0tZZXZWNGt3NVRQSHhuR3pC?=
 =?utf-8?B?RGtuU3JxR3VPU1c5ajFpNGU0by9zclhGdjB3VkFLYVBUVUQzVHVRS3IzSGZT?=
 =?utf-8?B?YUFyaTZuU2ZYTk1HRXE0YjJ1UWN2T0wyanVBTTJHVFJBVWFFNmNjRUZoVDlN?=
 =?utf-8?B?NGgwUXErQ0xNMHZJYXRVRGduZ21GQWxlSGNWZytqeE1FbVFYM0FqOHRrRk9N?=
 =?utf-8?B?SElaeEdVbG1wdVVkM0VjZGRWbGJWMFN0TmFrN3pwam8rd1BueTdqTHhxS2lO?=
 =?utf-8?B?T012cTVHQ2h2dXhvQ2JKaFpGakFKQlcrYW5rcXZXZUs1MEV5YzhBUmdTdW85?=
 =?utf-8?B?MDcyQitoK1N2VGtCanE5bUtsd2FycG5OZkxvOTdjNm94UUtka3dCdW5zZ21x?=
 =?utf-8?B?T0UzM2JHZnlwSkhva3prWGVIRDRCMHhoUFZidzllU3FJdWdBb3d1RlBBVGM4?=
 =?utf-8?B?ajhra2xnZDNacUNDV05GVWZNZSs4ekZmUXZyS0RWTFVlTDlYVzFnL3VxVFFn?=
 =?utf-8?B?UlFrTFlTTWFkWHRBTHdEa0xFdWl0OXlERlAxVzJrejRwenN5U3U2a0hocWky?=
 =?utf-8?B?d01HeEQ4MnFocXU0OGVzbkp2bDBFVXQ3QmZTTEQ4YzZPWDIzTktjQUp1ZzJW?=
 =?utf-8?B?Q3Q2Y0lGQjk5UmdmNVhEd3dJT0JOMmxRbW1rSHRYMHJTR3BtTWlILzBHZzBG?=
 =?utf-8?B?cUttV1d6eGFyYjNkQy9pL0hCQXR2N04xK3czS1d4MituVm9OdEg3aFBKZWJo?=
 =?utf-8?B?bVo5U2Ywb21IOEcwUVBUK0tkdDdlUUJYZ0tjcmJXYmNUaHorbGtEY1NYbE9t?=
 =?utf-8?B?bVZtcFlNMHpIdWpPb05UN1l2cFlla25zakZZSUFDeC9pOS8wUmR4ektoWThj?=
 =?utf-8?B?K2xLakhXTnk4R2FwS1BFaFhBQ0doQjRpODF5NVBRUGhRUS8xM1diT1VkS3RR?=
 =?utf-8?B?Tk5pNDI3ZzZOblFtTXlqSXFaSUZqdkRPaVYzK2xJc2g0cnJnMzQvbDNiNW5q?=
 =?utf-8?B?byt0dUJqa1RMS1hiRkRLeHZXZk5WdkRmdmRIdC9tVEg2L0pCcC9PcHFDVGhp?=
 =?utf-8?B?aXcrTy9KajlnV3FkUFAvaDhneWVCNlhjRVJXamI0UXp1STFJZGFDb0VDaDdl?=
 =?utf-8?B?Q2MrODRBM3NsM1IyanA1WEVKMHcwVFRvdHVzdXd0THYwOHVrY1BjUXY2Mk1W?=
 =?utf-8?B?THFpanp4cnJBK2ZRS3B3MEVxemlRNkNBNmJMZU1nc1d2UUtoWnArdUU4WUtZ?=
 =?utf-8?B?aWtQY0lvS0x3RHF5MHo2b2RVNkVhalZsbXoxWWtnSkp3Vmdsc3ZJd3orYkxq?=
 =?utf-8?B?TXVGcUF1NXdZZDFWdXF1VVlxY3NDTGtFcW10NzhzU0RFbEp0RVR0Mm94OG9X?=
 =?utf-8?B?M0xEaXloMGx0WFp3TzRPM0I4a0tGdURXUkVoVWhUeDBNeEV2d0ZremdlWGpX?=
 =?utf-8?B?TzRZYVdJMnBGa1czTDNFQUE1eUg2UGlPWGROMTg4TWk2b0ZHVlkxYVlkZjI3?=
 =?utf-8?B?ZGRXT2hxc0UveEhDSzl1VlFxTXpPVmIxS0VIbW9xUCtyQVQ1VHpjN0Qxb29n?=
 =?utf-8?B?OWtRV3M0RnY5YU44OC9UZFgyY3hDekZRVGJab3UwNUdDbmVEQTQ2dTIrNVM3?=
 =?utf-8?B?bC9XbVRuaFB0ckR2RW5KWC9Qc0xGaDJYc1R5UG9XNkdkZDJieXRNMTd5alpr?=
 =?utf-8?B?eVVvMERlTDI0enhyR1dpbnhkRWV0R1BmcVdwUjFPV25EbWtaZ0RjbWJOa3dS?=
 =?utf-8?B?bXhMNDFzd012bitsTHJwdzRxaHhLMmE5VlBSL3lKazl4TVhwOVJvZnczdko0?=
 =?utf-8?B?bDNuMkhBOHZMMTRBWGVYQ3h3Um03SktLUTF0MUlXcEdCV2Y5SWM0YVVmMzRx?=
 =?utf-8?B?enUrY2NzK2IzT08xYXYyT1N2VjBjMlpkV05rU0JsMHovOG9UN21IRGJTWnpi?=
 =?utf-8?B?b1paR1pTNk5tek16aFRUSHdUMnFQT1NCeUtJZCtRaWRxa3JwTkFBV3RiaUNj?=
 =?utf-8?B?U2JHOHF1dDZ1UkF4V0gvN2hSZkhzQnhIM2RCaDg3NFB1eENVV1pQVHB1MFdO?=
 =?utf-8?B?VHlyWCtndElpVk1nd3RsbWcrTnFraTBnaXlaMjVFb3BDSnpKV09Ea1dlbHBD?=
 =?utf-8?Q?+IZrKibAR3lG8I9oTZwbq/GrI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e24c553-7969-4a56-9a9b-08db093d59f9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 18:58:51.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFyckaBLEDBeS1RnQlJuI1mtsYSjjD6IuR2wwaEfAZUJpj2cDOfoO1Q3CVri67ZotATUBGB2fHi115mZmm4uSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5826
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/23 10:45 AM, Alexander Duyck wrote:
> On Tue, Feb 7, 2023 at 10:24 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> On 2/6/23 1:36 PM, Alexander H Duyck wrote:
>>> On Mon, 2023-02-06 at 10:16 -0800, Shannon Nelson wrote:
>>>> The ionic device has on-board memory (CMB) that can be used
>>>> for descriptors as a way to speed descriptor access for faster
>>>> traffic processing.  It imposes a couple of restrictions so
>>>> is not on by default, but can be enabled through the ethtool
>>>> priv-flags.
>>>
>>> For the purposes of patch review it might be convinent to call out what
>>> those restrictions are as you enable the code below. I'm assuming it is
>>> mostly just the amount of space you can use, but if there is something
>>> else it would be useful to have that noted.
> 
> The big thing for me is to make sure you call out your limitations. I
> just want to make sure as the reviewer we know what to watch out for.
> My main concern is wanting to see it documented somewhere as I am
> assuming that it is mostly related to your MMIO size limitations.
> However I have concerns that there may be other items such as the use
> of write combining that would be nice to see called out somewhere as I
> assume that is only needed for performance and not some writeback
> limitation of the hardware.

Oh, ouch, in concentrating on the other comments, I missed responding to 
this one.

That "restrictions" note I think is over-stated here and left over from 
an earlier draft where queue/ring/mtu size changes were disallowed while 
CMB was running.  The main restriction now is just that the interface 
must be 'down' before enabling/disabing CMB.

I'll fix up the commit comment to be a little less alarming.

> 
>>>
>>>> @@ -390,6 +392,7 @@ static void ionic_remove(struct pci_dev *pdev)
>>>>
>>>>         ionic_port_reset(ionic);
>>>>         ionic_reset(ionic);
>>>> +     ionic_dev_teardown(ionic);
>>>>         pci_clear_master(pdev);
>>>>         ionic_unmap_bars(ionic);
>>>>         pci_release_regions(pdev);
>>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>>>> index 626b9113e7c4..9b4bba2279ab 100644
>>>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
>>>> @@ -92,6 +92,7 @@ int ionic_dev_setup(struct ionic *ionic)
>>>>         unsigned int num_bars = ionic->num_bars;
>>>>         struct ionic_dev *idev = &ionic->idev;
>>>>         struct device *dev = ionic->dev;
>>>> +     int size;
>>>>         u32 sig;
>>>>
>>>>         /* BAR0: dev_cmd and interrupts */
>>>> @@ -133,9 +134,40 @@ int ionic_dev_setup(struct ionic *ionic)
>>>>         idev->db_pages = bar->vaddr;
>>>>         idev->phy_db_pages = bar->bus_addr;
>>>>
>>>> +     /* BAR2: optional controller memory mapping */
>>>> +     bar++;
>>>> +     mutex_init(&idev->cmb_inuse_lock);
>>>> +     if (num_bars < 3 || !ionic->bars[IONIC_PCI_BAR_CMB].len) {
>>>> +             idev->cmb_inuse = NULL;
>>>> +             idev->phy_cmb_pages = 0;
>>>> +             idev->cmb_npages = 0;
>>>> +             return 0;
>>>> +     }
>>>> +
>>>> +     idev->phy_cmb_pages = bar->bus_addr;
>>>> +     idev->cmb_npages = bar->len / PAGE_SIZE;
>>>> +     size = BITS_TO_LONGS(idev->cmb_npages) * sizeof(long);
>>>> +     idev->cmb_inuse = kzalloc(size, GFP_KERNEL);
>>>> +     if (!idev->cmb_inuse) {
>>>> +             idev->phy_cmb_pages = 0;
>>>> +             idev->cmb_npages = 0;
>>>> +     }
>>>> +
>>>
>>> Why not hold of on setting phy_cmb_pages and cmb_npages until after you
>>> have allocated the pages rather then resetting them in the event of
>>> failure?
>>
>> I need the values anyway to determine size, and the fail is unlikely, so
>> why bother with tmp variables in the middle?  Also, this clearly sets
>> idev->cmb_npages to 0 which is used as an indicator in the ethtool
>> handler that thm CMB pages feature is not available.
> 
> Everything seems to be based on cmb_inuse being set anyway. You could
> probably just leave the values set and not bother with zeroing them
> since cmb_inuse would be NULL in case of the failure.

I should be able to change ionic_cmb_rings_toggle() to look at cmb_inuse 
rather than cmb_npages.


> 
>>>
>>> Also is it really acceptable for this to fail silently?
>>
>> The fail would be from the memory allocation, which usually will already
>> have printed some message, and we are usually discouraged from adding
>> more "alloc failed" type messages.  Also, this is an optional feature,
>> not needed for normal driver operations, so we don't need to kill the
>> probe with an error code.  If the user tries to enable CMB, they will
>> get a message that it is not available.
> 
> The error I would be looking for would be specific to the feature
> failing to be enabled. The memory allocation would be harder to track
> down since you would have to pick it out of a backtrace. If we had a
> one line message about it failing to initialize that might be useful
> in debugging should an attempt to enable it fail.

Sure, I can add that.

Thanks,
sln

