Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1856DCD4A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 00:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjDJWM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 18:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjDJWMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 18:12:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AABE51
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 15:12:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1iGKTVb4MF/FopolyZAk4pXGHcLgYBaoserhavNDrMqFohcw7xUKq4i01CKfsWPbDz5tVp66i3zSJI1ynb5FibAZVz64gHpsx5U/vHjiy5RAFZBUZR9WUBo8Q40d3Y5hRdCu2N0KARTw2p0BWTtrNoYg9TM4w9R0kK3noR8A34p0ivavvXj13pma65fARSbd18OoXr3SOIcHxf8+FOL6qRWjbFPFBUBpVVssxiOACi0kzAOAwnJQJfF/X8FwYKyh863kyuu97u2yQ1YX54bKzSU4EClFFYzmsuYzjmuVRayug4Yp9MzyKr+cnKMGYHENpVb0gR06BmVXl0fmpzwBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qskSCK/vbzU5Q3v8wzkkk36CY4wLaT+sAVL4H2pRyp8=;
 b=axlNyCe8Opxa5qfBbZhjSFYJ3jQd3UfBP6oZt9zg3iX2FZ+REQup/KqjMRpcVCy4uTc19Fbj7o/bJb82v/DX6veI3Ym1fRHGOCAznTvui+ubH3Pj2XdL2zDTIzQhbvxPdW2Xly4E309TdOOU3JToKlhm1xYFFI6Hw/H1z5eMh3VSMVgdmR3MVV3GhIy0U5Gvv7+8ytfjkcRh59sejoiuRBKMHGtzdGE77gFSqzyGrGsBazJ0LGgwR5EsGsxUCJyCiF9VZ0aaH8idXWA+1Wf/pUVrH4qXMv6Sted6bwYN4NjOduo3toZO0A1QQBtskiGkdtG/1KzKCHe7T8TE288Y1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qskSCK/vbzU5Q3v8wzkkk36CY4wLaT+sAVL4H2pRyp8=;
 b=rg6knvuRYXHOv8xZWxQVwNv8tbUv7IvM9/beTzYem2AKncWyMKTI4qAwskRirIbAZRK13gErrLUAU8Wi0RirNhFRBl43/CIt7ApEb/NSnc2LYidK8q3id0B2WO3QGDqjB+710LYMqlqe8WxUm3tvvTs5NSfcbdSIpW5rQ/7/tNw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH0PR12MB5630.namprd12.prod.outlook.com (2603:10b6:510:146::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 22:12:50 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 22:12:50 +0000
Message-ID: <f7c7c691-d173-73ab-c24a-79c22e6ef3b0@amd.com>
Date:   Mon, 10 Apr 2023 15:12:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Content-Language: en-US
To:     "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, shiraz.saleem@intel.com,
        emil.s.tantilov@intel.com, willemb@google.com, decot@google.com,
        joshua.a.hay@intel.com, sridhar.samudrala@intel.com,
        Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-2-pavan.kumar.linga@intel.com>
 <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
 <a5b7f1e4-8f14-d5fb-8f88-458d7070825d@intel.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <a5b7f1e4-8f14-d5fb-8f88-458d7070825d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::22) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH0PR12MB5630:EE_
X-MS-Office365-Filtering-Correlation-Id: 427b4690-90e2-4e09-6562-08db3a10b93f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xj5A6MLf+D4g8dnFMNGkAH8zlpL2Wj+3nhNJ7jVOyr2DgOE4SQaNJ0WdbaJqrXPI23Jqlt1J39x6MxENGrMVue9suGNEaQaLGIdDB09O82vZdiUCgSI4VJNUCg/+YcTAyc34W0ULJBbK4LFxcWpXFUr2pLR+5vaPPjSoXNPyDwoJl7EbsE6GJAtxODckdbE9McyM1FP89/labUtBOylyBAU8Tu9V7VZsZ8PKdqAVkUTzhUVXqP5nzx3H0RKQxC0SDXNUahofODoOWHGOmt9YrHkOIRSLSwNF149UPbPUxEHLwtSM1AMTrEThSY2hlvSVAnye6KAaa3kK5gmTPIve51DQoW0MzN2XcYqwGhRZy0c+tBLfSEdtzZws41SVmWcGQzTNnofb5BfXa94qRgi83YXoPv8gzDEeEBNncqK4I5UgWy4A8xuh279CSBEmL2EesUZooYH84n9Xj8apfd27f0I9M+XUdnu+OJLwMsTN+MOVUNcU0VEJgVWddiXjCzEHhxOGZGbD6k8bpzNn7rlDF2pru97BTbNSnY+41BPlC18/EYoAAg75oHgMyDFKK4GQuOsKSSNoqGFS7tj3fD5toHes32zASo2CdZrRWPdfye3f3xbeV7MwePgT+uxuwvR1bKRnadNo/E9kCdjHoQRgew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199021)(31686004)(6486002)(478600001)(54906003)(66476007)(66556008)(8676002)(4326008)(66946007)(41300700001)(316002)(86362001)(31696002)(36756003)(83380400001)(2616005)(6512007)(6506007)(26005)(6666004)(53546011)(8936002)(7416002)(44832011)(2906002)(5660300002)(38100700002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzRUbHVBUDQrRVBzZUhDSVhMaVl5anlqSk9ZZEFmRjRiMkEwWE5mVG51Q3ow?=
 =?utf-8?B?S2g3akhjaHhDdkVXaGsvUFZqT0FBUUxlUzRVc0F5SUpGbHcwN2l1K2RZTG5Z?=
 =?utf-8?B?dUtMaXl3WVk2eHdpZDBPMlNuWU5jNThDa1pBaStuNjlMS2xQU0lhZ25MbE9p?=
 =?utf-8?B?L3QwWWJDS3o0MmpiN0RlU0k0akw4VytLUUdZTGY2cURPbzBVL2o3WCt6QjI3?=
 =?utf-8?B?bW9LaWRiaFRIeGJ4NTRNVzZueEFRSnY5WmJONEVJMFJTTVhxT052K2RoczdP?=
 =?utf-8?B?SmpmUkRDMGVmUWlEeXpkK2VwaVFZK0svL0RJcEt2aUJHOEtUbWNiN3pBSEFo?=
 =?utf-8?B?eStGWmFCSFlRWkxBenZjZXdOWU9lT0lva2JSUUg5SE8xZk9HWk1kcmVNUUpH?=
 =?utf-8?B?Z2Q5cTFycW9Ndmd1VHpZYkViVjhLYUgvT29GYUpPNXJlOVBMRTRHejZFT0Y3?=
 =?utf-8?B?SW5BNGwxQXc3SG85Y3RndUU2T0c1L2F4ODc3ZmtEcDdBOE13d0FQSUdEc2xa?=
 =?utf-8?B?L2MyeGhqVGpiTnBuc0dnaWQrNkFvWDlUb2V1Rkp3RFVwRTR0MmticXJPNGI4?=
 =?utf-8?B?UVFiVTVGbGdxbHQ3UnI0bDZUMHFCNUpGcDA5WVJtM0pieFRST0FtcG92VnVp?=
 =?utf-8?B?U1diYStrUWpEaTA0cTY0SnpYTVJhc0FZREhZVURpNDlGdWZCbWhoUWxsRlp6?=
 =?utf-8?B?bzlGM1IxTmMzOXYwdm42dmJPaTQ1SDRZWm9xcGtFZm9OclBUczB2c25jK1gz?=
 =?utf-8?B?OG9PODhTcEpURmhmNEQyM3dYd2E4Zm1NOTFENFF5MUgwaWxFSGZySXY2NHRT?=
 =?utf-8?B?U3V2TWo3d3N3RFNXRU9UTm9lVStHTHpsWXJKVkRnRXVSK2xRb0ZyWEtnYzlH?=
 =?utf-8?B?UUZ1NHRPaXZSWUZyWW5GK0Fka1hVejhrNmFnRlNIMHFCN2U4c3QwQ2NjTmRO?=
 =?utf-8?B?NFQyWG9jc01YV2sxY2VPT1k5aU9pR01oQVh5SjF4blNYT2NTLzRzdGZPeTMw?=
 =?utf-8?B?dkkvL2p0YW9nMTczUDhWMlpTejFWbEkxSGVZNEwxY0V3MndpeElUODAzRmtl?=
 =?utf-8?B?dXdOKzZhUkM4SEFmelBiNmZOMTFtOFFWc3dBOHBCRkJ3MEtveGhsOFo0U04r?=
 =?utf-8?B?WllQVVhHRTF1QWJhc3k4MUhXczQvL3hVdGpyOVp1Ym0xcWJFWG85dnpXTW1O?=
 =?utf-8?B?SlJJdmdPaGs5L0JMK3hRWWR6QkdRVGZhQTJPVTdHNDg4UFBwWTRYRDUrMzln?=
 =?utf-8?B?aDRKS3BSV3RMMnB1enViVzVscEhRaktLbUxJTDdtdW5yMWZtbjdyaWNSYzhy?=
 =?utf-8?B?enBib0p0RVJQeXdoRWpQNURMcjVZdENkWU1TYVF3d2RiYTlEL3dtWUFjVU5n?=
 =?utf-8?B?T0wrWVFlQ2NZK2w2Y0tLanlBL21mR1pPbzB3dmZFNm5GYUVpYzdwV1U4ZW1w?=
 =?utf-8?B?OUlQajU4bmplOHRic0xYTEVWc0U5MiswVTdjazFYVXZ3Umpsb21VWFI4QVN4?=
 =?utf-8?B?UFhVVzlRMUNjbmVZcWw1UElQMHdaN1NWZ0RWTGhWYmVkNm9ibkwwSFdla1ht?=
 =?utf-8?B?N3RKdlRBWTZPY1htOG9zZENkTm52Vy8zUllkc3ZEYmtHcGsrd0lUcDdmaVlR?=
 =?utf-8?B?STljT3RFeWU5U2VRekJKVnh2VkU1QmxPVFRwd1QxZU96Y1dmdlBkYlNvS29n?=
 =?utf-8?B?bUNuQmdLZm4xbXdlY1E3UHJoY1pveGhsKzNud2J0OXd1NnZzZDRxMzVSV2wz?=
 =?utf-8?B?VDVmUEVMSE5oVFBuSVM2eXVuTmZYSG9FcnVvWkVETHdpTUM2WjN2VHRnS0Vs?=
 =?utf-8?B?bnljODZrbWRtMFlyUmZ1bjc1SFZXRklySzR1ZzFQczZFVFBKUDljMFhJWk1n?=
 =?utf-8?B?c1pIZ3RrOVVLTGUvbkpjeTAyZy9hQWlNcHJzTmRwVXRzMk54RkcvMFFid3gr?=
 =?utf-8?B?UXNaZGJrUHA5Myt4akNNMjBiRExja013Njc1VlpsYUNuTG5BWnlLS1VNQnBM?=
 =?utf-8?B?QU5GNURXQUR1MjNXTU94bFUyWXQwT1hIZlU1aDFqRVR1TjRpLzBmKzVaN3R6?=
 =?utf-8?B?L2Y0WGw4OHdkckJqZWJSRTBZUWJhbVNkTzdScUJFN2dyTCtVaXhqc1ZGVjZy?=
 =?utf-8?Q?Q23tDOauUpUhtH0EKV8m/Hzsq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427b4690-90e2-4e09-6562-08db3a10b93f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 22:12:50.6456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uuJZilaAuvQeLzg3txj7zefmye8/IObc3C8PeTkBetCuWP65LgmTMfUWFzH32jhcp98CMcoG5OIwhz/NF9YU+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5630
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/23 1:27 PM, Linga, Pavan Kumar wrote:
> 
> On 4/4/2023 3:31 AM, Shannon Nelson wrote:
>> On 3/29/23 7:03 AM, Pavan Kumar Linga wrote:
>>>
>>> Virtchnl version 1 is an interface used by the current generation of
>>> foundational NICs to negotiate the capabilities and configure the
>>> HW resources such as queues, vectors, RSS LUT, etc between the PF
>>> and VF drivers. It is not extensible to enable new features supported
>>> in the next generation of NICs/IPUs and to negotiate descriptor types,
>>> packet types and register offsets.
>>>

[...]

>>> +
>>> +#include "virtchnl2_lan_desc.h"
>>> +
>>> +/* VIRTCHNL2_ERROR_CODES */
>>> +/* Success */
>>> +#define VIRTCHNL2_STATUS_SUCCESS       0
>>
>> Shouldn't these be enum and not #define?
>>
> 
> This header file is describing communication protocol with opcodes,
> error codes, capabilities etc. that are exchanged between IDPF and
> device Control Plane. Compiler chooses the size of the enum based on the
> enumeration constants that are present which is not a constant size. But
> for virtchnl protocol, we want to have fixed size no matter what. To
> avoid such cases, we are using defines whereever necessary.

The field size limitations in an API are one thing, and that can be 
managed by using a u8/u16/u32 or whatever as necessary.  But that 
doesn't mean that you can't define values to be assigned in those fields 
as enums, which are preferred when defining several related constants.


[...]

> 
>>> +
>>> +/* VIRTCHNL2_OP_GET_EDT_CAPS
>>> + * Get EDT granularity and time horizon
>>> + */
>>> +struct virtchnl2_edt_caps {
>>> +       /* Timestamp granularity in nanoseconds */
>>> +       __le64 tstamp_granularity_ns;
>>> +       /* Total time window in nanoseconds */
>>> +       __le64 time_horizon_ns;
>>> +};
>>> +
>>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_edt_caps);
>>
>> Don't put a space between the struct and the check.
>>
> 
> Checkpatch reports a warning (actually a 'Check') when the newline is
> removed. Following is the checkpatch output when the newline is removed:
> 
> "CHECK: Please use a blank line after function/struct/union/enum
> declarations"

Since it has to do directly with the finished definition, one would 
think it could follow the same rule as EXPORT... does.  It might not be 
a bad idea at some point for static_assert() to be added to that allowed 
list.  For now, though, since it is only a CHECK and not WARN or ERROR, 
you might be able to ignore it.  It might be easier to ignore if you 
just used the existing static_assert() rather than definigin your own 
synonym.


[...]

>>> +/* Queue to vector mapping */
>>> +struct virtchnl2_queue_vector {
>>> +       __le32 queue_id;
>>> +       __le16 vector_id;
>>> +       u8 pad[2];
>>> +
>>> +       /* See VIRTCHNL2_ITR_IDX definitions */
>>> +       __le32 itr_idx;
>>> +
>>> +       /* See VIRTCHNL2_QUEUE_TYPE definitions */
>>> +       __le32 queue_type;
>>> +       u8 pad1[8];
>>> +};
>>
>> Why the end padding?  What's wrong with the 16-byte size?
>>
> 
> The end padding is added for any possible future additions of the fields
> to this structure. Didn't get the ask for 16-byte size, can you please
> elaborate?

Without the pad1[8], this struct is an even 16 bytes, seems like a 
logical place to stop.  24 bytes seems odd, if you're going to pad for 
the future it makes some sense to do it to an even 32 bytes 
(power-of-2).  And please add a comment for this future thinking.

sln
