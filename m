Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09926DCC4B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 22:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDJUvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 16:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDJUvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 16:51:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD21619AF
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 13:50:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAwl1yyj0kzzZp18ZLXsW+kl4rb/nIbaNznefng5ft655OPJSDuDYvOBMy0phALvDZEO8wFZVbLDHL882Jj+jzs2Cgu6AJEA10EP2DfjgGmt/5cDFEn7MnBlctKWrCuTzDk8a+7GHYi118uXwIHIHWVTKRwcvBz33cnF8zVu63VE8eKvnpdI++L8cfkKNzipawDQ5Qj/Jp6ihvw9Bgy8Gzv/kuH3+Khg9R6Vr2G5soCwdheMqWZNQftXRoKabyvru1BKbwCd8EzGzAcodJtHn+wlBkVl7pTCZIrmHB/Rqwe/HzptqEURJw9xKzPriSK1Y1em2qU0IVmuRbBs6ntbrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NlRM5a5RY9zrr0OwA0fWmbgY2uMm+ZPAgNq66b1NYH4=;
 b=jgEapTqbmItCiLDhXll/3ZTX1Zzi12spOWAsqg/cg27fpxPDRkQZGpiCtbpMjxOLtRsvVuv5W5IC+UgMrlnCvwZMB0b9YDQR/oe9BRgRquAdMrtE5c5a9jH32uaq9VerAxrtwszl89lQtW0axp+QlQA0Eul2IvyhDZ2KcgTb/jWOtabkx5iG7qHCLREp4VpgQIP461FxWdmdi2r2GGxDbFyv4oftbkamBjUc04Mli3xovgUHq26zI44ZmpN+3DePylZtdnlwEDuBGH1WCcjBI5WD9UUYeTnnqGn3Z9iWIdXPRw8/fx8CqF+qncRyKsyYOdLqaa1IzPt6kB9FwAxLnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlRM5a5RY9zrr0OwA0fWmbgY2uMm+ZPAgNq66b1NYH4=;
 b=GTVT6h2Mn0wtSCLD+mUTF4y9MTLHd6v5L29lautcfOVIUcYUld+d5EuBdwEGk7baUOkjpRC+hwmeFXmlwK1veoBwtL8WFbX7L1rFTo7C6jZyjy8tsVSJwsWUrbM+xmgAJB1UD97Tn4VrSVA8T8mY4Bli1GscRjpCyJ2eu0a/hXs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.36; Mon, 10 Apr 2023 20:50:55 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 20:50:55 +0000
Message-ID: <94a4ae9e-bd27-1553-593c-89b8bb9d0360@amd.com>
Date:   Mon, 10 Apr 2023 13:50:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 12/14] pds_core: add the aux client API
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-13-shannon.nelson@amd.com>
 <20230409170727.GG182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409170727.GG182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0240.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::35) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM4PR12MB6012:EE_
X-MS-Office365-Filtering-Correlation-Id: b9608868-ae14-42de-f579-08db3a054760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EVWh79Y0ULHiUSIy9ik7VFckDsbv2aNZdx/aXLarVEV1LdnGDyCqbsElmWGMxQ3WOg9hLyrsjhE1BX349FIrqS8UFTbwozQzhwqI6jJtRfNQ1Ufu0GNWAet7eSZtMvMpemXeu3h0oCJBp0wxpm+Mae3xxCeq2VAVClrgaOjyfOsHqtWzHn+kMW8/5Y9KPX8tVmsLfWlxTI9e1k/DprylwzOl0uuNnxjm+54vo6u3SpDWxySB2lhCP+rrV798ivfV6HYwpHuEJXZugeHZjrS1y6L6dhJKdYhm1pg8rHYZ+zXzNgtSv7cqWjY6TQ/M4ZvelaURtXfjmb66dFM0Q26bLU3Co6sp/sWoI3FXmMAIPoWExRTlOGtL8tQ1ZzcBveSGRCK/yrHY1NoV4a8HEqMEyPm7pyVRMrKID6q9aR6QfdLawGrIadDpChYIPE51ZxR844m83Tg1C6AlESqJIodHu8ECUxKhQaNUeuCxaVxB0DZDKdpLOyjIe0kn4S9c9f+qXX2jT2dNiREO1NQyw4O+j9SFt67TFID8ky7EnoiP9BYO/1uumX3QQ7pGiK0t3Lg8F5VzeEYQW4a8EiwONYuqk7Mj1fvbmliMIsLNJqoRCPFP5a4GDBEY/7SS8g3rHAd5toHnh+Q66zf6Hcj5WiBp6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199021)(31686004)(478600001)(31696002)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6666004)(6486002)(2906002)(316002)(6506007)(186003)(44832011)(53546011)(6512007)(26005)(66476007)(8676002)(66556008)(6916009)(8936002)(5660300002)(41300700001)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnRmdUM4dklXOW5GbFdDNTJyb1g1M3dIZFA0UXA0RVZoSDBzbDVkencxUUJI?=
 =?utf-8?B?YnVGMnZMOWkxQ3FIa0Z0QXdreExvZVIrWmJRRjA1Z3p0WVhhUitqK3VRSTha?=
 =?utf-8?B?azRTQUtKOEd1bzFBNVZiOFNzaUMrYVZyejYzQlNzSUl6blJhR0V5MVNETE4z?=
 =?utf-8?B?MUk2N1hMZ0dVM0x2Wk5MdHp5OVZFbjMrVktldXdUNnpoTmhvOGcrRExnZkFh?=
 =?utf-8?B?T280UkNuVFNrS09oSHo1aEpkZkFBOHB6R3R3UFpIYzlUY1BlSWlzQThnOEZt?=
 =?utf-8?B?UFdicUhwdlJESHVhc00vZ2EvTS9QeWpsS1NQb3kweFhRaG9uTnphU3NKQk5N?=
 =?utf-8?B?cTVzYVIweHNRRk85R0dlVVR1bk9qUGh0ejAyM1JVSXBYMnZPam5nTmROU2Zq?=
 =?utf-8?B?dTllWmx2cVZ6Sm1lZmNaWTBJUS9XcFZnSjBQYzdQUHkrYlNFVzd5OUFxYTlQ?=
 =?utf-8?B?NnBqeHpmckV3ZXZmTjhWaXN4ckhQeDBCbm8zenNMZG1aQW83UEV3NnVvRE5V?=
 =?utf-8?B?ZFBia0plYmR2QWszc29vSEgrTlRlSmFNZmZIdG00d2dyYWlsV2NLR3orOUVo?=
 =?utf-8?B?TlJteVRRWmVpQVg1Zk1FL1NxUERtVjYwRVY5ZE1sOVBKWkl0Y1l6Zkl4bVRZ?=
 =?utf-8?B?cTM4NThRbG1ENGpkb1BlK1p3WkwwTkV0SzJUODdSYU84d2I0cFFQN1BwWnl1?=
 =?utf-8?B?YUFESmpRKzJydjkvSEdrWUpydzhFRzZTZFd5ZjFhN0prSEsxTUZub1hXbGov?=
 =?utf-8?B?b3o1aGZwdmNjdk9QWVZOSWRqYjdBd2VmRHlwdEIwNnRtdElDUHltSGk4MU51?=
 =?utf-8?B?YkF1Qi82U0syL29xSDJhTzlEa3NrY1I0TFZoS1hVTG80d1FMcWxVejI2UVpL?=
 =?utf-8?B?VjZtY291Ykl5RFJOYTZTaGxSZmVOZHk0UDZQSTQ0eU13cHV4dEc1ZzNzSHJz?=
 =?utf-8?B?WXpvMThLSkY2Zm94YmgxZ09IaWl6K0dLd2wxNUJKTHErVXdTVkxZeHJHclVC?=
 =?utf-8?B?RXRMUmNzemJLeHNqU0xXaitiM0R6eXZZWlVwR05LNXNGYVpMUEZjSW54TWxn?=
 =?utf-8?B?UWRzUjlLY3VVenZkL0ZzbDQrc2FTZmg2cWN6MjBrOGp1T0paN1pZUHhuVGdH?=
 =?utf-8?B?a3pscENRTVB3ZU5WYUVSRnM1RHFidEtiSnBWc1ZQVGw1b283Y1JhQmUzYnlK?=
 =?utf-8?B?cFdNa0Y0Q2lETVVMN04xdGV5V0lQQnc5NFFxbWdnY3BsSUFWTVNJYXJPRVJ5?=
 =?utf-8?B?dmxvSDVmU1JmQUI4TnlXR1NreUlOZm5INnRocFFKSmlobFJ1ck5Xbm0raW10?=
 =?utf-8?B?QVAwMWtOMlo0RUlXOVBZU1VMVkppS1BnaDlHWkxaVXgxR0lBWEJJVjlqZGVh?=
 =?utf-8?B?Z0ZnMFh0RmMyS2pSTWR5NDF5VStmRzh6K3JVU2pWUkhKS2FseW1YbEdVekt5?=
 =?utf-8?B?b2RkNE1TUXZWWlVEMFV0YnY1L0tMTS92WnlsVzV1OWM4bFpxZU1uMzYrNml4?=
 =?utf-8?B?b3YwNFlCdDFyVXduM3VyT3VyUFQvTHBScWFUMEdObGdIdCtPRStsYXlXUmFu?=
 =?utf-8?B?ZUFPV0NPK2VlMUM5cUJtL3ZMTXBZWUFNOUVaN2JxeVVBWGs1ekxZTmYzN0tv?=
 =?utf-8?B?b2QzZW5jdVVBUE9FdEhzZHNxNEJjaVpIVDJtc1p3dW9aZnYxTjQ2TWM2Ulhj?=
 =?utf-8?B?aVBLNHpTUUJKR09GWjZ5VytnU3oyYjR6c1lRVXJHVHh4L29NMTB2SlV4RGI3?=
 =?utf-8?B?S2lBTnNjaERKZHpWTHpYUlZ0SmVWcjZrUnlXTldZWEJWWlE4SFdzZnFVU2V4?=
 =?utf-8?B?cnhSY3Fmc3lWbnE4Y3RpMEwrcjNYSFZJSUpwTHdLYzR0R1BVTlVyNk9TZW81?=
 =?utf-8?B?N0ZLQm10TjVMcVlrUkJmNW5ldDhhRGJRb1YzdytXSTVIblFpYzVGUG9DbW51?=
 =?utf-8?B?OC9FbjJuc1drUHlUU2NNcVluODJreGtlMk9CME9lREwvWHdXTEhRZmtNSktp?=
 =?utf-8?B?VU41UGxOeGMvRE5XWjUwQlNKa2RQeXI3SU5QWjkvNTNaRy8vV0pYWFdXVm5Y?=
 =?utf-8?B?Rkp6bzQxejhqMTlvTmo0bVF1U1R0N3R4U0gxaG1RZnV3R1F1dnZpQ2lKeFps?=
 =?utf-8?Q?PUMqgVoQtwMWhsWXwpVtVExbR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9608868-ae14-42de-f579-08db3a054760
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 20:50:55.1614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDJue8z4+ge9DZb4FdAZJ//amnjZ0Z89qYOlm5WmXnGW/SooLcGfCowFWXqpWesXpv28F5oD/0PObfu/R/N0tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 10:07 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:41PM -0700, Shannon Nelson wrote:
>> Add the client API operations for running adminq commands.
>> The core registers the client with the FW, then the client
>> has a context for requesting adminq services.  We expect
>> to add additional operations for other clients, including
>> requesting additional private adminqs and IRQs, but don't have
>> the need yet.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/net/ethernet/amd/pds_core/auxbus.c | 135 ++++++++++++++++++++-
>>   include/linux/pds/pds_auxbus.h             |  28 +++++
>>   2 files changed, 160 insertions(+), 3 deletions(-)
> 
> <...>
> 
>> +static struct pds_core_ops pds_core_ops = {
>> +     .adminq_cmd = pds_client_adminq_cmd,
>> +};
>> +
> 
> <...>
> 
>> diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
>> index aa0192af4a29..f98efd578e1c 100644
>> --- a/include/linux/pds/pds_auxbus.h
>> +++ b/include/linux/pds/pds_auxbus.h
>> @@ -10,7 +10,35 @@ struct pds_auxiliary_dev {
>>        struct auxiliary_device aux_dev;
>>        struct pci_dev *vf_pdev;
>>        struct pci_dev *pf_pdev;
>> +     struct pds_core_ops *ops;
> 
> I honestly don't understand why pds_core functionality is espoused
> through ops callbacks on auxdevice. IMHO, they shouldn't be callbacks
> and that functionality shouldn't operate on auxdevice.

The original design had several more operations and wrapped all the 
interaction into a single defined interface rather that polluting the 
kernel with additional direct EXPORTed functions from the PF.  Since 
much has disappeared as we simplified the interface and don't yet have 
use for some of them, this ops struct with its single entry is the last 
vestige of that idea.

Perhaps it is time to put it away and add one more EXPORTed function. 
We can revisit this idea if/when the interface grows again.


> 
> Thanks
> 
>>        u16 client_id;
>>        void *priv;
>>   };
>> +
>> +/*
>> + *   ptrs to functions to be used by the client for core services
>> + */
>> +struct pds_core_ops {
>> +     /* .adminq_cmd() - process an adminq request for the client
>> +      * padev:  ptr to the client device
>> +      * req:     ptr to buffer with request
>> +      * req_len: length of actual struct used for request
>> +      * resp:    ptr to buffer where answer is to be copied
>> +      * flags:   optional flags defined by enum pds_core_adminq_flags
>> +      *          and used for more flexible adminq behvior
>> +      *
>> +      * returns 0 on success, or
>> +      *         negative for error
>> +      * Client sends pointers to request and response buffers
>> +      * Core copies request data into pds_core_client_request_cmd
>> +      * Core sets other fields as needed
>> +      * Core posts to AdminQ
>> +      * Core copies completion data into response buffer
>> +      */
>> +     int (*adminq_cmd)(struct pds_auxiliary_dev *padev,
>> +                       union pds_core_adminq_cmd *req,
>> +                       size_t req_len,
>> +                       union pds_core_adminq_comp *resp,
>> +                       u64 flags);
>> +};
>>   #endif /* _PDSC_AUXBUS_H_ */
>> --
>> 2.17.1
>>
