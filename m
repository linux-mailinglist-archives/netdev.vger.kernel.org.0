Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A280462C418
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiKPQWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiKPQWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:22:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2138.outbound.protection.outlook.com [40.107.237.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E248773;
        Wed, 16 Nov 2022 08:22:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c92f3Esz0mJ+08nLHna5BzS2zxxlGSguVpCUYFWDXKQhXVhRXyb/olwrMh2pP7GqBiUgEwT33YamlFIOkrvC7dCVxTrCJvJXjvu9xjAQSQqupM4ZXyYk67FljHdAK+pqop5Wdo0Q8HmtJbJT3oD+lfpcticY7JP2i7/+qcyGKuwOLh2sR6HAPB+C6FLMf0h+jjixdOulxRMsYKDOlI6yQazWv2BQRP1ABFHJvFNjUSCvArQSvqjDRexGpUA4FotZHluZKiS1KUb3UvCAb9gMwZEdnEjifXW43T1MUi8v8O4nNEFngrNtqPn5PboJTrYEMc2OS4xuaN2N46eVYbjCKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5b4a3m1STINXt1z1tTb31a6jjRY59A41licBByOEc4E=;
 b=GqedXjz1CAKNVZIAckRmtq9OXNA2pFvRcwWC26nDLBn8xvsc9DzLHp6vBRvtIdDHufL9Ndb8W0sz7/cY0nzRVKJ8JJeBIuH4P9tXGUFRC4qYfBDd07PmLeIG4ObwbCUc4DJnlmjSk2JO2PiMKhDYvj0lJE1hbryA0Gh+s/ATi+7Dauec97BChKf9DoLKFo7lLr64Xh8jK2K9iu9GzDcjgO/A0di7qRj201X5OeJyzgRqGceYxxHEa2J5ALp6nqKEYm5Ai+vtOX/wmzMDMhySscSMmXafZ5Kecd8UIn2Yh2LK/YH5Cn8qpDTPg8IyTYyl/3Ep5r5XfdHgdHcBomUZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5b4a3m1STINXt1z1tTb31a6jjRY59A41licBByOEc4E=;
 b=OlzsCtDJJEGgD4m4s2JThSgQo9P0FwAjznSSnJ2d7CRY1sTbTn/X+5E1nT1FuLROEW4CiV19pV3z3UJjH7SoEBCVqSV8eWBziHyRk1zL0wX0uOvWcRoJmA9R22K1O1sAmPff7CMlZ5knXfjaEne2QS6gbiXcgbz6+PR0ak63elbXfNazUKcd63s0IGH5gvx+Q60yJkace+IYLHz9ymooB1IwZERjj11gUrMXLV0Lk8F8Q9goKUOydl37U3AgXLVTb/Fk3Yv/DxolWUuGvj9xqqXxkPvYXYrLxtmy3m5B0PVELYCCiTHzDLBRhyUGpKsnHC5XfESNR4PJYcLXy3AKXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from BL0PR01MB4131.prod.exchangelabs.com (2603:10b6:208:42::20) by
 CY4PR01MB3301.prod.exchangelabs.com (2603:10b6:903:e4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.19; Wed, 16 Nov 2022 16:21:59 +0000
Received: from BL0PR01MB4131.prod.exchangelabs.com
 ([fe80::619b:37fc:f005:109b]) by BL0PR01MB4131.prod.exchangelabs.com
 ([fe80::619b:37fc:f005:109b%4]) with mapi id 15.20.5813.019; Wed, 16 Nov 2022
 16:21:58 +0000
Message-ID: <87b12755-15d6-1064-1559-8951c1252eaa@cornelisnetworks.com>
Date:   Wed, 16 Nov 2022 10:21:26 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/7] RDMA/hfi1: don't pass bogus GFP_ flags to
 dma_alloc_coherent
To:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20221113163535.884299-1-hch@lst.de>
 <20221113163535.884299-3-hch@lst.de>
 <c7c6eb30-4b54-01f7-9651-07deac3662bf@cornelisnetworks.com>
 <be8ca3f9-b7f7-5402-0cfc-47b9985e007b@arm.com>
Content-Language: en-US
From:   Dean Luick <dean.luick@cornelisnetworks.com>
In-Reply-To: <be8ca3f9-b7f7-5402-0cfc-47b9985e007b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH0PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:610:cc::13) To BL0PR01MB4131.prod.exchangelabs.com
 (2603:10b6:208:42::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR01MB4131:EE_|CY4PR01MB3301:EE_
X-MS-Office365-Filtering-Correlation-Id: f94ab83b-5838-4411-6ec6-08dac7eeaf60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXMi8VLWdG149kuS90zguMYpOGhR8XBIvGIvbIvvbvdVkZuKsWz78zUWCWFzea/kWZNYYhJfpQP/pdm+I5QQDBN0KWD+yTFr/vUBB14fG9wSLWSuCC3iLbOA0ChcZFyBACrfyOjNJVEArj+RC9o5ngEykeiwB8LCpamCDJEG73/e44VRCvtKLS4lN1NnsoLGrwfZaF8CF4KyAn+pL/pXDcEFBmVkPtIihhvyIqwT5MVgK4ZhlhWXueFML5FqAmX3zQVCRrdf6gsKoFzBsh8ANCUxJap8z33nvf/jLDTYiUqDwbihRG4kdFjG3hsb/JFDvSP0/SkzQueqtTBFZG7TcRTrCPudU7fCnSr/pdGlqSgdxBHw0YhHHZx5mde9zGlolRU4IHNuW9VdvIzviclS7aWY+CRcXlrn4E9tg4ZZtWpxQkd4PHhRJgdz1PJSRkHAUTd3729Crwx8b3yJ3fUApFXl/6PTl8bKUKCUORlXBShGcFAbRYjFd/rT5iyC33hdjcCLaaW+2jTkhOOOdr0UHa41fv5O62CSFmMeQkFd1e+NqSVXEXHipM4PZIu4xYv129NpYhfvVB+YCIqGoSnGcpfi8RPZbGsiY8JfQHFBlLajlrQYv/str2kVlqW7wQJzYrngXmbIgc1BqhSdUtC27VGdACyXZGCK4sZWnM2uruX3bVmPlhoINnIObgLeIifKlAhX9IAXRijWeNLrKjskvS6/h8fwxgQutHTphLVddRmpC2GBIqebglks9XIR6dsHKKgllmbzKV4YKVy+4b4hTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR01MB4131.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39840400004)(366004)(136003)(396003)(451199015)(41300700001)(8676002)(83380400001)(4326008)(66946007)(66556008)(66476007)(6486002)(36756003)(2616005)(186003)(110136005)(316002)(31696002)(38100700002)(86362001)(921005)(8936002)(44832011)(7416002)(4001150100001)(5660300002)(2906002)(31686004)(26005)(53546011)(6666004)(6506007)(6512007)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SCs0RzUzdDdpRmdYckdydmJQOUFIRk0rbVZocG9rM1NLNTlIMzFwTHlWaXJS?=
 =?utf-8?B?bEcxL3VSTklFNkZBUFdYb04vVXMzYyt2cHl4QkhQRmF4dHNsbFpncjN3Mmh1?=
 =?utf-8?B?MGRvL3NSL01lQVEwaUFCSFNEcVlDVEtnbGZMclUrMzJGcHNLVWJKN0pPTTc2?=
 =?utf-8?B?bHBZcE5DT2ZOd2NVMmY3WTVOVS9WUndaTjMzYUpPbFVzUWZ5Z3hnUkFreU5U?=
 =?utf-8?B?bmhxTnZUOHpIUDZyOHU1d2Y4cGxCYU5rSlJiM29WWFJSN3pPdWk1aGt2c1Vm?=
 =?utf-8?B?aTBRV1VEbnFjYlRrVlRNR3RjNGd0cWw4UlFvRXQyb1FONWdRRXE2SDlxdVc4?=
 =?utf-8?B?Z0t5NUl0eTJZTnJoRjQwM0JYNzIrSk9La3RVMkdKeDdrTTBza25wMU16VFpS?=
 =?utf-8?B?bHo4NzAwSEdvNnkxamcxcUM5QjlCRC9wVVZlOWtlckw5d045emRRczhkTWJB?=
 =?utf-8?B?eGo2cmhuTS9rTkVCTnBsaUM1K3gyOXM0YmVETGNnRmRJR2U5NU1ORmNMWXBh?=
 =?utf-8?B?NHZpMDhKdXcxUTdDRXB5QlJJZGkzTEViSE80MkIzbllBcDd4b3VjV3BLOStM?=
 =?utf-8?B?bHAyWWJWRWNYMHg2N05PczZ3UUE4c0l3WHhORnlhY3N3czcxTE83VzBVakx2?=
 =?utf-8?B?TGdpUmhKRFJlTFBPWTVFMXdSM3BRMTAyRVhjcU5ZQnJ5K0FSYVdqUG85NVVX?=
 =?utf-8?B?TUtkalZYNHJUZTBZQUpCLytRTXVMd1lNenBybWI0R1VDbjJ1RGZCSm9wOHds?=
 =?utf-8?B?aHV5N2xIajZxVzVYZnVTOGQ2SnNubWlKb003RUE3RlU1dnlwVGVNYWJkSjBx?=
 =?utf-8?B?SGFpNlRmaDZvSjZRanBHN3k5SGhTdW9vZHZjbkI5ZkVORkdsdCtIRWJvMHo2?=
 =?utf-8?B?eVZoZnQ4L2FWWGV1QTJldWhRUlBtTDVWbDF2Q1NRZ2VQYm40MUtEbHhlK3RM?=
 =?utf-8?B?MVNSY3FWRVNHTThNK0F6RDQ1eG5Ba1M3UFMwZ0JpYlpGNDZvam54ckoyNlJI?=
 =?utf-8?B?OWx2cHA2VUkyRDBlcmY0Mi9mVXZuOEYweVowV3hLeWVCM01FaWl2ajh1SE1Y?=
 =?utf-8?B?STg4SjVSYXJoRy9aMFJnaWVzdm5pNkVFVFYydHlFc1BZdkhLVnVlRVlPWlBt?=
 =?utf-8?B?S25nUFlJVzYyM1JybDZxMEJURTdtZUtGcE96a21tT1FRK1JnTUxrTWZhbFJU?=
 =?utf-8?B?VWN2WkJtd3lCYkxETHdGWDEzLzREY25iS0hGeDRjbW9SaGFIdE9HQ1pHbFpX?=
 =?utf-8?B?UmZ2R0ZoaU1tV3k5QkNiRTF6dlFPbDNkT3BobnFhbHQ5TW83OERlQTJ2bGNn?=
 =?utf-8?B?OGNyTHJyRFZzQTd4ZWpyT2RBWkd4WE5vR1J3ck9EUlhRTStqUzdzdUlCa01k?=
 =?utf-8?B?TkVtdWlSeWdwVjJwc3NwbXkxYWtWWUpVNTNjMEpOTFhoWDV3Z1ZWV05JSlEw?=
 =?utf-8?B?bnh5eW5qYitudzJZeXoyMG1RRDZHenBnS2lwSmFmbzM4SHlsTlc0cjNDeElS?=
 =?utf-8?B?TFhMb2d5QlZRN0VCUU5maXpIVkxUQmpvODQ4d3JYVjNJYTRkSG1xaGp0QVM1?=
 =?utf-8?B?cCt3RWV0QlptM0VJbmYzUVNqcDIza2x0R3dCZ09ZVDcybExHSlUyd0ZDN0lD?=
 =?utf-8?B?dWlMYy9XZTVmSys0UnRqVWpmaHVlcmVmdjRob25YaXFodTU1Qno4eFQ2eXBW?=
 =?utf-8?B?eHlzKzVlRHUrNERUeG9xcWZNbHJSaEwxY1BaL3RwSHlSMVNVNC81ZjRsQ1JS?=
 =?utf-8?B?QThwL3JKNWppbXB4SXF5ZWpjZUM4dkZac1VJbWJzR0Z1TStzUHErb28vM1c3?=
 =?utf-8?B?aDEvQkJMUGVlZkNZallXRVZ1ZUhVcHlyYmYwOWJYdEQxWVNHQlIrYW1vRElN?=
 =?utf-8?B?TmxOc1RialdnVU1qMDd3UWxWU1F4Wld1Q3UwS3hPTDBHTXg2aGtFRk5tS1ZR?=
 =?utf-8?B?SDZmWHpiVGxrR2ZzNjY3T0NwdHFSd1ovUkRnUjZGYll6a0thZXVQbkNHaGk5?=
 =?utf-8?B?cnZOOWdPa09MTllkR0ZnMCsyeC9JWlpUbFdWOFIzL2xJMjA1KzM2UnMrMkRH?=
 =?utf-8?B?ajU3b2Y5TmltMlVqZUNmU2pjTGQxZ0R2bnhVRmJKa014azNGN0pWN29GTmQv?=
 =?utf-8?B?b2sxRWRVWHRUWk9kbSt3Wlh4ODRRaHNUQzlOdDRkaG9mZ016N08zTG1kcEsx?=
 =?utf-8?B?OUE9PQ==?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94ab83b-5838-4411-6ec6-08dac7eeaf60
X-MS-Exchange-CrossTenant-AuthSource: BL0PR01MB4131.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 16:21:58.7479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CEJgAUljV/gXjyHgtrtn50S9JAnvHBdZfKc5Cwg76kyzr8IXzxtmWX6+kuLHrL50jfxcuoh2JS0wUJb9BoBfsDbSEaBUc8wVAclLJzNEucA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR01MB3301
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/2022 9:15 AM, Robin Murphy wrote:
> On 2022-11-16 14:40, Dean Luick wrote:
>> On 11/13/2022 10:35 AM, Christoph Hellwig wrote:
>>> dma_alloc_coherent is an opaque allocator that only uses the GFP_ flags
>>> for allocation context control.  Don't pass GFP_USER which doesn't make
>>> sense for a kernel DMA allocation or __GFP_COMP which makes no sense
>>> for an allocation that can't in any way be converted to a page pointer.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> ---
>>>   drivers/infiniband/hw/hfi1/init.c | 21 +++------------------
>>>   1 file changed, 3 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/=
hfi1/init.c
>>> index 436372b314312..24c0f0d257fc9 100644
>>> --- a/drivers/infiniband/hw/hfi1/init.c
>>> +++ b/drivers/infiniband/hw/hfi1/init.c
>>> @@ -1761,17 +1761,11 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd=
, struct hfi1_ctxtdata *rcd)
>>>        unsigned amt;
>>>
>>>        if (!rcd->rcvhdrq) {
>>> -             gfp_t gfp_flags;
>>> -
>>>                amt =3D rcvhdrq_size(rcd);
>>>
>>> -             if (rcd->ctxt < dd->first_dyn_alloc_ctxt || rcd->is_vnic)
>>> -                     gfp_flags =3D GFP_KERNEL;
>>> -             else
>>> -                     gfp_flags =3D GFP_USER;
>>>                rcd->rcvhdrq =3D dma_alloc_coherent(&dd->pcidev->dev, am=
t,
>>>                                                  &rcd->rcvhdrq_dma,
>>> -                                               gfp_flags | __GFP_COMP)=
;
>>> +                                               GFP_KERNEL);
>>
>> A user context receive header queue may be mapped into user space.  Is t=
hat not the use case for GFP_USER?  The above conditional is what decides.
>>
>> Why do you think GFP_USER should be removed here?
>
> Coherent DMA buffers are allocated by a kernel driver or subsystem for th=
e use of a device managed by that driver or subsystem, and thus they fundam=
entally belong to the kernel as proxy for the device. Any coherent DMA buff=
er may be mapped to userspace with the dma_mmap_*() interfaces, but they're=
 never a "userspace allocation" in that sense.

My (seemingly dated) understanding is that GFP_USER is for kernel allocatio=
ns that may be mapped into user space.  The description of GFP_USER in gfp_=
types.h enforces my understanding.  Is my uderstanding no longer correct?  =
If not, then what is the point of GFP_USER?  Is GFP_USER now mostly an arti=
fact?  Should its description be updated?

Presently, the difference between GFP_KERNEL and GFP_USER is __GFP_HARDWALL=
.  This enforces cpuset allocation policy. If HARDWALL is not set, the allo=
cator will back off to the nearest memory ancestor if needed.  The back off=
 seems like a reasonable general policy.  I do have one concern that may be=
 hypothetical: if GFP_KERNEL is used and a buffer is silently pushed out of=
 the expected cpuset, this can lead to mysterious slowdowns.

-Dean

External recipient
