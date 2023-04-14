Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9F76E1889
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 02:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjDNAAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 20:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDNAAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 20:00:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF703C06
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:00:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JevpucOsbZjWNFbbjdK88raCVYo9+GVPOYuEITuRt2TBo/CHA80HwU1Q7R2LkNGQOxcQv0VLozhFn3G+aXwCPOk7zI98K/1HTwATx/JpGnVeNm6H2asPHiFTfFPsg9CJlyporvt6094cfRmcx7H8z8cIC6g3p5COT0OTTKbd8+xZI0q30jM6nS1juaBVmwTmjAy0cRsB4i9S9atqqn4cjBoOe5HZc4CCb4AF/YsH7hiRzwSBn5scVaHbU0Lk6wOE8uhuSNtxCX46ge0KwAskldPY5OCbpEyIzeFowgOYbTROw/zFpMxL7wmVU60wTZ0lut5TQG8r0t+5vj+I8zvsuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytqzS9uE+HmUmvBTybPZi44CPT7TBbsQvn1ABboFj3o=;
 b=gYxa7xuoX8cuSxfd6/c0vhIfktWyeKzYD/FenXnOgx+C6NHgfMkHrLGuhtn68aJlbh2Np99PiVYb7SaG1frXYmkCEJoKYuz6EaPrLs5KhxDJa6LUDi2gPaCpiH0TF6BGIT7I3xPbqySdXGNoZrziIVPuv7swjpVFqMJgkHtpS0EwegPxaiTO7xGY8Jl0RUnrEG2EB91ule9pqUCAwrGM8Pf+4SMOJMWGtzqo8vHjG7RkPoUMjod2JBvJkLRrvTODqFnCPHNe7nA4vDMPoCFGzXsJAPxGATRh3yd5Bs9tVud9QJ+UKJo2OcXfepaHe880/cWCd8EkXFH/nGTayHFS6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytqzS9uE+HmUmvBTybPZi44CPT7TBbsQvn1ABboFj3o=;
 b=mgXqIHESkDTm1y4Cti7+zBcB5lHTqqY4IOxX3kwQ36IaMjMQpo/RvCRcx68+z5cpJwGTXm46vW2xtkwtftJuEdoTP0c3EMfwieHCf8/1rYgzeOSS6HSubdV83diA8AX64kNB+QQ7kpkHVChe+CB4vzO9Q706qzUoalZ7w0aKNPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB8986.namprd12.prod.outlook.com (2603:10b6:806:375::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.43; Fri, 14 Apr 2023 00:00:05 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 00:00:05 +0000
Message-ID: <d2d567db-f823-2ee3-48ff-abc9b375d484@amd.com>
Date:   Thu, 13 Apr 2023 17:00:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 02/14] pds_core: add devcmd device interfaces
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-3-shannon.nelson@amd.com>
 <20230409114608.GA182481@unreal>
 <5394cb12-05fd-dcb9-eea1-6b64ff0232d6@amd.com>
 <20230413083325.GD17993@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230413083325.GD17993@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB8986:EE_
X-MS-Office365-Filtering-Correlation-Id: 6914c115-931f-468d-2a3b-08db3c7b33e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RtbswOxQiOYnePycQ9SIDcXjI/JSEArBCv7j3xbVuR+8LWOp+hUXqgbsqKFgKT997W8aQpgHw/VlX42A5JblZ9ZPmhFXUh3RV6u4xvk443015FFfbSYqncsK5oY46+OW8lc2a8HqIp1Qg6XT7OsVPqS0vyrYlapGSDQ0iB568FCZU42NuHeMnY4hwzzFlJ3V0U+x4hAvpx6bL6VPA/jkt6SZh9Fb29/thLJ9UzEjH7OPME+cie3rV7jc9nrghbHV6NEku87AhHGYIuiD6R1rDDCDRxPhkmu4rLnoSYtAcHzknpQ10Vns28G9Y3wUvlAE7HCDGQ1Vjx1+J0NV1cATcNgUueR1zg42HmRWQYpmtx+qp2yYUp7XZtasw8uxLp58A13UWdfpuxUy+OYTDkrn4b4wopSo/5dA1vTJ1+tY3a0zdE0geEDtz/mLzt4DMapIRdog4QUXB7qWlnv9HcfhYDYb2e7a0ZvA1tedxARmdqTTwnpIvDA+eBQCTlxeXOApD3Yt+m2kGpaVuRR6TaPu174rFm3FRpqARVmYHiHNxqGnloricOX35MFIc0iSaAHYdB/cm2Z5etRqwABt80DpgavVHOCrJtj3xAFo+iAijgjWeW7tQR3h71TllgkQVvBaA1MoktCMTXnUkzM7LgW+Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199021)(8936002)(186003)(53546011)(26005)(6512007)(6506007)(6666004)(5660300002)(44832011)(478600001)(86362001)(38100700002)(31686004)(316002)(83380400001)(41300700001)(31696002)(2906002)(66476007)(36756003)(2616005)(66556008)(6486002)(66946007)(4326008)(8676002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWxaRk5hNFRqeG9qSEdpaS9zQW9IdXF1Q3pDMGNFdFl0bXN4YzBpdkhoK0FD?=
 =?utf-8?B?ZUcxdmU3ZkpSU2UzcG0xMGRuWW5IbTU1Rlg3MDNuSExlZVhWd25mUW51UGNV?=
 =?utf-8?B?Zi9paWVrSHU0dkQxNk9oWTBsY1BtMERKTVcrek45b05JVlA0aTc1YkVEL3B6?=
 =?utf-8?B?M2JaSWFrTGtDWHIvRGZnQW90WFlVZC9BNTVqSHRWcE01a0NqU2xTb3dweDRt?=
 =?utf-8?B?RVhxaXBZMWxISndnbjA5OFdHaGJrZnE1MlozbVhhOENRZmdUanRHOFRNV1Mx?=
 =?utf-8?B?eThBVXNIZjhScElvVkQ3S3BQc3E1K1FlaGZvRDlhd21JMFUvVm1palJrNFBs?=
 =?utf-8?B?NWZkb25EMUhUQkVyMEx5UkZ1SmZ5Z2NscGFTVExnb0xYTmVCR0JzdkN4Ynox?=
 =?utf-8?B?bFhDdklVRENsaEdFNko0Q25lTkVWRmJLWUs3ZXpYRnNSd0MwRDY1cFoxNnpB?=
 =?utf-8?B?eDVwSktNKzB1b3FuNDQyVldGV3RkV1lxZHNObVZBVjdMb3h4ZFFaWElITUsr?=
 =?utf-8?B?Z3lPUzl1N1dOVVBWQmZNWlFvYUdwVFZ4cWdpN2hXUVhmNGRxRlZ5aVZKeEQw?=
 =?utf-8?B?L2xtL2lXOURnaTd4Sno5R0pnVFlzWWVlMkdjKytSUElLcGNwRWY1aTJiV3BH?=
 =?utf-8?B?aFlwNUpDUUswWllxSTNlSFViTi9BdzlsSXEyMmdQRk9WZFJ4Wk00am41dTZ1?=
 =?utf-8?B?RGExT056NW5BM0hrTXdOaVZta09JYjBQMW5QQXowRzhtdXNzVHJpNnJnZnhw?=
 =?utf-8?B?NDdBb0lWSHhsNVJ6MFBUOUdDbVJnc1lxcEhnU0FqNXRvWndIMXZiOUkyVGFU?=
 =?utf-8?B?M0duRDBwWi94UGo4NHlYNDRJTGJQcmlzZURpVmRQRnNrL0dQckxKQi9ocHNK?=
 =?utf-8?B?VW1mNXJXZytjTlZ2OW9Ea0ZaMG5VY29mNGZuaUNkRnRWS2hUOWt5MVRid1dy?=
 =?utf-8?B?ZUc3NnRlVVFFNkg5b1lCMDB5bWo4bzZ1VHhBaTJWeXNFajJjckJsVCtLSzg4?=
 =?utf-8?B?b2dQc2JEVGk0RGU2dk03QTI3K3FjRWU1bWhhM2xGalBvU1lKcEwzZ0h1QTR3?=
 =?utf-8?B?dG95bUZtQjNkZ0lyUFZIc2hlMGxVZ0pqRzdFb3BCcU5zcEhEZEtYWWc0MUk4?=
 =?utf-8?B?WjZWZm1KRmNseW5aUE0zWlBZY3BKZk0rTGxEb3NKOS9OOGMwV3djL29aTE14?=
 =?utf-8?B?a3RvRGxvZzlwaElHbXRhYUlFN3NFbGdpNkFKNmpSWllVenBoWENhOWt4aWVo?=
 =?utf-8?B?akhHNGJNY3g0LzBRa3Q1T0FtM0ZydDBFRjJQVXdNZFhwVUNlcHNJdWR1Vmpk?=
 =?utf-8?B?LzBaemZsTmZ3WEJiQmFKSmFGWmdwTUpPekN5SmptZ3BrV3FzU1ZSTnVLUStH?=
 =?utf-8?B?UmsxaXRZZkl3Qno0S0JCOEdLMXNLaWtWekx3WFpYNHVBaElTbEwvd3pSNGFX?=
 =?utf-8?B?Ykw4MmVieDhUQm9vNTNmRW1lUFdVcWdsYVlMVXRvSGF1dVMycFZKc2F4RGw1?=
 =?utf-8?B?WGZnSzgzQzBXQ3lFTGlVM2YzU3QwaHRuSXM4VlJnZzkxVHA2OUh3ZjBHNFRi?=
 =?utf-8?B?NkY5Tk1xS0ZpNklJR3pQbEFZNGZIL2FWdm1xS1FlTjNMVWZOWWZaaUpQSlhI?=
 =?utf-8?B?dExiTVdUS2s0alFieXlraUhmOTZVK2tvbStZY1laaFNYNFRXd2llOHFZWFpU?=
 =?utf-8?B?V09sQUh5QXBaT2Y1Tm1uVGlScEhPUEZvSHQ4WGMzd1JHZ2YwMEVmR1hMdHky?=
 =?utf-8?B?dXJ4TThmUThFYnpPVnphZGtyaUhJc2poS1hGVEtaMWEzMHoydjlLcHJrY2xZ?=
 =?utf-8?B?YkN3eUdxZy9YTVNxZEVKcGpvSURSRm9GaHNQOWVPM1IzU3MvSnFKcnhIeEtk?=
 =?utf-8?B?V2prWTlqdmpkUjlEdVJSd1EzMUFTc0RBNUxjRy9JRkZGMGN0SkZhWlBhOGZG?=
 =?utf-8?B?ZE1xK0ZjZDhLV2lNSFkxditIazlwR09DZHpnZnZvTThJMG9EdS9ITTBHUEFo?=
 =?utf-8?B?eUtPZGhSZyt6Ly9FdUpuWmdra284YUIyOGhodzNOcHhJb0d5clRVd1FLQ2FB?=
 =?utf-8?B?VzVHZ2lKYWlPV2QwL1l6dEFEcnJGVkIwdmpHQ1VIcmMvL0UxN21LYVNTWVND?=
 =?utf-8?Q?RQwS+hi6y9AJxhpwgXqqFCFw7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6914c115-931f-468d-2a3b-08db3c7b33e1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 00:00:05.7223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsNio7wEgwc2C45wEKZB0xrnArIjAZ/NN4WBS7KnxgEyWltwKV/w3T8xb/LHGnCj84+1dlEAtc2gr50D85Im8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8986
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/23 1:33 AM, Leon Romanovsky wrote:
> 
> On Mon, Apr 10, 2023 at 12:05:20PM -0700, Shannon Nelson wrote:
>> On 4/9/23 4:46 AM, Leon Romanovsky wrote:
>>>
>>> On Thu, Apr 06, 2023 at 04:41:31PM -0700, Shannon Nelson wrote:
>>>> The devcmd interface is the basic connection to the device through the
>>>> PCI BAR for low level identification and command services.  This does
>>>> the early device initialization and finds the identity data, and adds
>>>> devcmd routines to be used by later driver bits.
>>>>
>>>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

[...]


> 
>>>> +/*
>>>> + * enum pds_core_status_code - Device command return codes
>>>> + */
>>>> +enum pds_core_status_code {
>>>> +     PDS_RC_SUCCESS  = 0,    /* Success */
>>>> +     PDS_RC_EVERSION = 1,    /* Incorrect version for request */
>>>> +     PDS_RC_EOPCODE  = 2,    /* Invalid cmd opcode */
>>>> +     PDS_RC_EIO      = 3,    /* I/O error */
>>>> +     PDS_RC_EPERM    = 4,    /* Permission denied */
>>>> +     PDS_RC_EQID     = 5,    /* Bad qid */
>>>> +     PDS_RC_EQTYPE   = 6,    /* Bad qtype */
>>>> +     PDS_RC_ENOENT   = 7,    /* No such element */
>>>> +     PDS_RC_EINTR    = 8,    /* operation interrupted */
>>>> +     PDS_RC_EAGAIN   = 9,    /* Try again */
>>>> +     PDS_RC_ENOMEM   = 10,   /* Out of memory */
>>>> +     PDS_RC_EFAULT   = 11,   /* Bad address */
>>>> +     PDS_RC_EBUSY    = 12,   /* Device or resource busy */
>>>> +     PDS_RC_EEXIST   = 13,   /* object already exists */
>>>> +     PDS_RC_EINVAL   = 14,   /* Invalid argument */
>>>> +     PDS_RC_ENOSPC   = 15,   /* No space left or alloc failure */
>>>> +     PDS_RC_ERANGE   = 16,   /* Parameter out of range */
>>>> +     PDS_RC_BAD_ADDR = 17,   /* Descriptor contains a bad ptr */
>>>> +     PDS_RC_DEV_CMD  = 18,   /* Device cmd attempted on AdminQ */
>>>> +     PDS_RC_ENOSUPP  = 19,   /* Operation not supported */
>>>> +     PDS_RC_ERROR    = 29,   /* Generic error */
>>>> +     PDS_RC_ERDMA    = 30,   /* Generic RDMA error */
>>>> +     PDS_RC_EVFID    = 31,   /* VF ID does not exist */
>>>> +     PDS_RC_BAD_FW   = 32,   /* FW file is invalid or corrupted */
>>>> +     PDS_RC_ECLIENT  = 33,   /* No such client id */
>>>> +};
>>>
>>> We asked from Intel to remove custom error codes and we would like to
>>> ask it here too. Please use standard in-kernel errors.
>>
>> These are part of the device interface defined by the device firmware and
>> include some that aren't in the errno set.  This is why we use
>> pdsc_err_to_errno() in pdsc_devcmd_wait() and pdsc_adminq_post(), so that we
>> can change these status codes that we get from the device into standard
>> kernel error codes.  We try to report both in error messages, but only
>> return the kernel errno.
> 
> You don't really need to create separate enum for that and place
> it in include/linux/pds/pds_common.h like you did.
> 
> You FW returns u8 status, which you can feed to pdsc_err_to_errno().
> In the latter function, you will declare this translation enum.
> Such core reorg will esnure that you still have meaningful FW statuses
> while keeping them in limited code namespace.

Yes, I can see moving it down into the decode function itself can work 
and keep it limited in scope.  I'll take care of that.

Thanks,
sln

