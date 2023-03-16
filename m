Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F0B6BC31B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCPBI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCPBIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:08:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714ADCA30
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:08:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShacSGIPxO3ccs/9IUMeATfFPdAOzQsALsOFqNdWti3CFZdq1LCQCAXfy/hxJFu1HXMhj56+IyELL1VFXvcL/QXzpD/eWpSuc2NI6wL+ivCpbTbu8FBxRx4TbV+XytUklh7g2gcCvhlLeLJcgD/CF2MUUK8FFFiC8hQ9ww00eNPPCYmugYHuGxkzJScm8u4dD8CmsJ0jIDVo80V56+kU1zVOQEpyD6lBVC/oyT0gwzLC7+B9QpEKNoT2KJa+d9nB83Q1K6fIrJ0R9e4xm8n+ziVmib/V/0AD423i+KW480S1FssjNai3ztqaCNHYYgNDNyDrHQXvhvCBpMf1TLAQwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EawtPnbC4NEYyamcT5rKqd03crbH3tsBexhuOQB7Lks=;
 b=aIJZEpGFEzps6S00b2Bm0mSwoMAHbZ0KH6XCy+g2PB3Asd6j/ieFkTJum5SNcOepm2lwepnsHgkR5eRjP3TLvtOtdR02ilo7Z6CbyW/2MEFWxpOAqyc7eu7xDppJrBz6v6C4gdmxVMYN5Nnx8gWy43BPBB3xgZAmGqAcGwTdVwWdmmo+lmz5pJ3pF/v8KyfWdLkB5XkSI/QwkzY3L6MMHLo3l8sXtyd6R6pSWK70UozWeVLGaBwcocWBzDXNWP15UkeAH56nWbwMJQ4vFmRth6Qk4S4aRSR2h/cbH+o7Uzu/6zt7BN0XOPClF3Z+zEykPPl7qZKRIgXquMdVuDBovg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EawtPnbC4NEYyamcT5rKqd03crbH3tsBexhuOQB7Lks=;
 b=yIC1jTfXcUQC2bmKcmC55RXzS37Ri0LrTOk6rCcEfzsXlzF1tL2+lwgTV/kMOFUoCdFONHnoo6VNlyv10wTZfI0JZEtBisA2kL5DisLcMYptg14muHo06ii30gkQsSqzzdMlOGkNLg8afn5UiJfvW4YF7FcVSBESvn+WucfTJzs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SN7PR12MB7836.namprd12.prod.outlook.com (2603:10b6:806:34e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Thu, 16 Mar 2023 01:08:18 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%8]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 01:08:18 +0000
Message-ID: <8a579bdc-1e8a-a0a3-9788-f8736e66e95b@amd.com>
Date:   Wed, 15 Mar 2023 18:08:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v4 net-next 11/13] pds_core: add the aux client API
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-12-shannon.nelson@amd.com>
 <20230314121452.GC36557@unreal>
 <398bef7a-795b-d105-d8e5-57ef1c39049c@amd.com>
 <20230315082122.GM36557@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230315082122.GM36557@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::43) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SN7PR12MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: 4090242b-c13e-4a5d-8f7d-08db25baed93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pcptZAT1liPu1BMSi1fEmvvWqVWT69YOmngwYVAF/n5Q581+3inA60rKJT5DbBVvPDIlhSYhwf5b+FSrdSfM7gxpuxLrlCZ6ibtPJ9Kr7ke38eEp+VuK7mXoh+q4Gm/Oe4voBH6aeA/ZmdN8E0V8wlHZgBQXiexIQqayTJ4eik/rKzG6b3R54lGcj5VWyxvqzM1p3nlwEYinSvzECLchZ0z+RnCQ01vPFkCIzwPBizZL6XRqbDfuK4XKvJS8xe5tNjRP8zt9dMZfSHeSdZTgG6rlVps1kqQpSJT5/rKBOqqQ5ZL5jkpYdJu7rPaolmMrIGYEPvAMSySHyGRu5ya+craQ5+rXWiQcyG7JdRrQGcP88bGMJ7RcH9YnqHY7TFENGp+fcA6vxYQxCoTdSlG8v61evSpro4lLldaJE7nwrWYWcWIrJBFbFNwu9CZf8EA0eRFVz7SLGJf+kKjM4lGz5D/encN+fZZ7LZqIJQxQjWRrwaJNTj4cGp7BMEH9CliCmivc+wyohDDdlJW+Gg3O7GIYjErM/iqNHpmsBgcuhzbmVNFvI8G9lDJfch2Thca26kYHkCYJonSv/CS+CgoOQji/gmPsM7D++eVMuSxdaPdJXwdKpM1eYC8NK9l1D0JT2wWy5sXA/++GV8/cl4vvLaKC6YvdqDFMawSXfNkmcN+RJRUUlt+0awVpovF+EbqqLS1nrKm4fJmVtuZp2aAzp2FREZemw7oSlKodaLlSLlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199018)(86362001)(66476007)(66556008)(8676002)(6916009)(41300700001)(83380400001)(44832011)(5660300002)(186003)(66946007)(6486002)(8936002)(6506007)(53546011)(6512007)(2616005)(478600001)(6666004)(4326008)(36756003)(26005)(38100700002)(2906002)(31686004)(31696002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3Y2bGxuUG95MUd3YXpCbFEzTTNnQjVCYjV5VlE0eDR4SCtWUDRYOFJrd1Jp?=
 =?utf-8?B?NzB1UzhmYkl4emk0WlNmNDRsc1RnWjhPL1kwQm51R0tYMWNTYklNaW1icERH?=
 =?utf-8?B?cmlYNjhlQlNNeVJZc05xeFJ3V3JqU3l6MDRhb2c3VGtuUkk1SGp5YjJHWXd2?=
 =?utf-8?B?WVRibWZpcEtJSjJpNllwZ3czU1pSMWltNVZtU2MrdTBIcEZNQlR1ZjNiSWNo?=
 =?utf-8?B?Um9mT1hFWjhkc1RNcVBuQjFVUTlyLzBKWDUycmZVYUg3ejJSQTNhazNLd2wv?=
 =?utf-8?B?aWF1YzNWU0JTdUpzVXlwU2FKTVdXVUlwbXgyQTBTQk41cmdRNk9EWUhaUlRI?=
 =?utf-8?B?YWRhbG1YcUlvSWFxYXdEeElHVEdIblZDZ1pnSFNaOTZKb0puVjRBZnpTMERw?=
 =?utf-8?B?amhoVGJpQjYxaXdPaVdjMFdRQlpGWkx1SllvOVh0U0tTdXQvSnZNaXdjMjNE?=
 =?utf-8?B?NERsK3gwanFxK2RyZXhoRGR6M00xTjN6YmhJUHVHQzBQWjhGYUV3ejA3Q2hv?=
 =?utf-8?B?b0FFS29PZHV1eVk2dnVEM0lJcWdVYVRzaDdNQ1dsMS9mWDJaZUtPMk5oNWwx?=
 =?utf-8?B?ZzYvWVFWK3RieGVnQWVjcTljalpoQ2JxUHBnaC8rK0V4SHhKb2NUWFIwWHhr?=
 =?utf-8?B?K3NhbWZJWFVwbDFkTVdCTmlKKzM0cmVpNk5yNU1BV21VYTVlMzdDNnpMd3pz?=
 =?utf-8?B?ZzFxMHZ5UStxYWNGWTVXOXhUN2wxV0c0aC9rZzZQLzE2UmdPQUFoU2dFNWsz?=
 =?utf-8?B?eFBzaVM5YkxLZG14VTdSUm8vUTFnaDJ5TVNPQ01uSlBwRnpROGRyRXkxeWdl?=
 =?utf-8?B?ek1iaGk0Mm0yTjI4WUdCQWJrSWY0OU5vZzZJTHgzOUhRNGpjSGF0VEx5ZVFF?=
 =?utf-8?B?RUh6NkEzMXU5QWh1RXRvZnR1LzlnWWRKV3VPZk5zeS9hbzc5RTR4dXI5QWRP?=
 =?utf-8?B?dzhSZjdqcDV3NzZuQ05CRml0cTU3SkdrRVJsZUk2U3h2WXhCQTMzdVRGWTFp?=
 =?utf-8?B?c0VFSzNBQUhJYkwxby9MVk4xSDBHZGUrMko0NUJSRS9TVXo1NFhHcjgyOWNt?=
 =?utf-8?B?UWZuL2plVmZnT2Q3ZUw5Und3Snk5Z1JUMHcrOS9MZEhCNU95bmRRN3JEM3o2?=
 =?utf-8?B?SjFqT0lqdmE5QzcydkRJOWZXQU1kbmgxTURoeUFRSHNJR1A3eTNuSU1uTXhl?=
 =?utf-8?B?ektYNzdhd2lZYkRzRkxoczJJYW9aZjc2bUJZRWQrRWpCTEszRlE4OVl3WVgv?=
 =?utf-8?B?dVhHUWxvTzlyLzFtYXJHRTBKK1dmemMySFF0WDBjNk9DSWROeGRjMnJQdE1M?=
 =?utf-8?B?OE5wSnloVWhIQUJrS3hZMEp5Q0hUeE12MFZBbE02VHpXOU5LYWpLdjgzZ1VC?=
 =?utf-8?B?WlE5OGs0Vml1ZDZmdzJYcEFuTjZkdlF2YUhsVU03cTFRSGhBNmF3dHVpclVK?=
 =?utf-8?B?SDF3VHR6NjFxRGh5VU5MK1Z5TmxxelNOdUZrN1UreEhWd0NiSnhBMjFoZDgx?=
 =?utf-8?B?OFlyY1ZPNk5JS1QvWDYrTGw5c0crd29OUW9FeG5nSDBmbXMyaWh2cVdHR29J?=
 =?utf-8?B?Uk5xNnVpSkJlS0R2ZHc0Zlh4Nnl5UEJyczk3eU5SVXBoU1hRS0pRd3ZhbHFp?=
 =?utf-8?B?RFNGTFdTUm1BbzV0OCtFWnU0OTdOdUNxNC9GYTFObGhtNDlpRVpBNWVJMHZW?=
 =?utf-8?B?RW41RUdMQkpuaWJRU1BPVDJ3OHhEekc4K0JETHlleE1CVEMrcFFTMG9rcnMy?=
 =?utf-8?B?UVRYTnQ1KzZmTzZsTU5uaFVxT3B5cWFIRUg3SmJKeEgxcWFtU0dlbTk0Wklp?=
 =?utf-8?B?WVhRZXkzelNLVytySlVXcmlMNjQ1eHB2eVpzUEN0M2tjK09VQUsyd2k0SWMy?=
 =?utf-8?B?Vm5MbERxa0YzTEd1S25Hem1PeTUxZTRUTFdEck9yN2VRNTJsNkxLcTZLMHE3?=
 =?utf-8?B?QTdBdTRHZE1OYUdBbmhlM1FDVDF1QTF4T1NIUXZwNFg1TDdlcUlwNUV1TS85?=
 =?utf-8?B?QzFKNFZjdjdVSmUvdU5wdHlNYjZyc203TGlCRzVoMkhRVEpmNGZUOUZ6QjlS?=
 =?utf-8?B?QVZhdmFSVHQvQzErOFdxeG5NaXNOdm9EVmgrdEU3K20rOXBIZloxcHEzandu?=
 =?utf-8?Q?cqwhhSfhNAAWRLkKr31UqCyG8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4090242b-c13e-4a5d-8f7d-08db25baed93
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 01:08:18.4947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o+Z49bv3qOwI0RjNlOinYUYmLgY/QIc1t3GyewZZlbrbTFHv84zkr4CnxU0jkXNR/KpWOTuhuFKNT01jG+9yRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7836
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 1:21 AM, Leon Romanovsky wrote:
> On Tue, Mar 14, 2023 at 09:53:25AM -0700, Shannon Nelson wrote:
>> On 3/14/23 5:14 AM, Leon Romanovsky wrote:
>>> On Tue, Mar 07, 2023 at 09:13:08PM -0800, Shannon Nelson wrote:
>>>> Add the client API operations for registering, unregistering,
>>>> and running adminq commands.  We expect to add additional
>>>> operations for other clients, including requesting additional
>>>> private adminqs and IRQs, but don't have the need yet,
>>>>
>>>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>>>> ---
>>>>    drivers/net/ethernet/amd/pds_core/auxbus.c | 134 ++++++++++++++++++++-
>>>>    include/linux/pds/pds_auxbus.h             |  42 +++++++
>>>>    2 files changed, 174 insertions(+), 2 deletions(-)
>>>
>>> <...>
>>>
>>>> +static struct pds_core_ops pds_core_ops = {
>>>> +     .register_client = pds_client_register,
>>>> +     .unregister_client = pds_client_unregister,
>>>> +     .adminq_cmd = pds_client_adminq_cmd,
>>>> +};
>>>
>>> <...>
>>>
>>>> +/*
>>>> + *   ptrs to functions to be used by the client for core services
>>>> + */
>>>> +struct pds_core_ops {
>>>> +     /* .register() - register the client with the device
>>>> +      * padev:  ptr to the client device info
>>>> +      * Register the client with the core and with the DSC.  The core
>>>> +      * will fill in the client padrv->client_id for use in calls
>>>> +      * to the DSC AdminQ
>>>> +      */
>>>> +     int (*register_client)(struct pds_auxiliary_dev *padev);
>>>> +
>>>> +     /* .unregister() - disconnect the client from the device
>>>> +      * padev:  ptr to the client device info
>>>> +      * Disconnect the client from the core and with the DSC.
>>>> +      */
>>>> +     int (*unregister_client)(struct pds_auxiliary_dev *padev);
>>>> +
>>>> +     /* .adminq_cmd() - process an adminq request for the client
>>>> +      * padev:  ptr to the client device
>>>> +      * req:     ptr to buffer with request
>>>> +      * req_len: length of actual struct used for request
>>>> +      * resp:    ptr to buffer where answer is to be copied
>>>> +      * flags:   optional flags defined by enum pds_core_adminq_flags
>>>> +      *          and used for more flexible adminq behvior
>>>> +      *
>>>> +      * returns 0 on success, or
>>>> +      *         negative for error
>>>> +      * Client sends pointers to request and response buffers
>>>> +      * Core copies request data into pds_core_client_request_cmd
>>>> +      * Core sets other fields as needed
>>>> +      * Core posts to AdminQ
>>>> +      * Core copies completion data into response buffer
>>>> +      */
>>>> +     int (*adminq_cmd)(struct pds_auxiliary_dev *padev,
>>>> +                       union pds_core_adminq_cmd *req,
>>>> +                       size_t req_len,
>>>> +                       union pds_core_adminq_comp *resp,
>>>> +                       u64 flags);
>>>> +};
>>>
>>> I don't expect to see any register/unregister AUX client code at all.
>>>
>>> All clients are registered and unregistered through
>>> auxiliary_driver_register()/auxiliary_driver_unregister() calls and
>>> perform as standalone drivers.
>>>
>>> Maybe client, register and unregister words means something else in this
>>> series..
>>
>> Yeah, I'm not thrilled with the overlap in nomenclature either.  In this
>> case we're talking about the logic in the pds_vdpa module connecting to the
>> services needed in the device FW, and getting a client_id from the FW that
>> is used for tracking client context in the FW.  Maybe these names can change
>> to something like "fw_client_reg" and "fw_client_unreg" - would that make it
>> more clear?
> 
> I feel that such ops are not needed at all. Once you create aux devices
> (vdpa, eth, e.t.c), you would be able to connect only one driver with one
> such device. It means context is already known at that point. In addition,
> user controls if he/she wants aux specific devices by relevant devlink *_enable
> knob.
> 
> Thanks

As this code matures here, as well as the internal gyrations happening, 
this makes more and more sense.  Some of the original work was there for 
greater flexibility in what we might need "soon", but much has gone 
away.  This is one of those things that we can whittle down.  The 
registration is still needed to tell the FW about the client, but can be 
moved out of the clients' responsibility and into the VF startup.

Thanks,
sln

