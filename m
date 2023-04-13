Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D50C6E1649
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjDMVDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDMVDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:03:14 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1368B59C6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:03:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kA5IXhrcAUVQ6Oj8faLmFIU6xX+L2E76XQa46P5cNzSPh2WYu/MTapnzEWuYDu3+DRHTa6alUm/oBKmKnkTGTa7zPy7xdX1q1po6HXP3cJ2fBXTCxOohoB6lrxP89SscQ0WFn+DNv5L7L3UMywY7zPooBBdVO7xLrTJQsYa3SDm9fm647O7FQjJvN7GhI2aDKI+SdlPnc3R59GgQJb+/8JdnguWJrH7nCM2Hihs/Hs8dx7wczmpKj5aISPkZEyJanNfoW2Ebul51VMWpfkNAs/2kFcVRM0siaccqjE1e6puIHz6DDlKEz0/zLODD0M+fe4Ta4uAEXFOzxqaOGnZNTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y07GllS5v7qUf0nrsxKP1QcbEjtj2S4b4Z4sZy12oSc=;
 b=FVbAoPkruqOI2/KHl8YOuNUo3daWjQQ1z57ZLxGUOqARvDpLw1aMbaHfsEC/P2xC05VCSv99rKxSb79/SM+tizmbuxRyefpG7EQFtxfdoGpY0w9jdXQ9l2IOmfx4u4RZWln9H8fi2GzGbbc2kFGfi7ZYl9rPX85e+uQMFeQEh8kkMYcRP8tQdPFWcCW/qZy0CH4hqUmN4Uw1hrRKr7qcX9ZH4/NnAxarjicGk7J79teii1MAZQOY62FufVSKrosMB8dEXF7NK64bxFg3mBh0YstAW+NfxrNKOqEEooJ4MR6R+k0Q66AAq8H+pfJNoCPaulfH2q2xqBmFEQM7GvMNWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y07GllS5v7qUf0nrsxKP1QcbEjtj2S4b4Z4sZy12oSc=;
 b=ntyhiDVIkFaJdUeAighLM6JdqNXIotDvOPi+Cw1N9XD3UGP7ZVj/iprasHl6+l7jtyTlh7oD4NTvrwB88D18AltJm82sOr2MaTY7g4V5RihGv0R+NyqJBzWfBerUsGfF9McRKlZ/oqW9ebY4tZQ9+ORHbqszudhQt/1Ql0OXZTo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM4PR12MB6011.namprd12.prod.outlook.com (2603:10b6:8:6b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Thu, 13 Apr 2023 21:03:05 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 21:03:05 +0000
Message-ID: <15ca06c3-8344-0396-1bb4-38f219a31369@amd.com>
Date:   Thu, 13 Apr 2023 14:03:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Content-Language: en-US
To:     "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, shiraz.saleem@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-2-pavan.kumar.linga@intel.com>
 <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
 <a5b7f1e4-8f14-d5fb-8f88-458d7070825d@intel.com>
 <f7c7c691-d173-73ab-c24a-79c22e6ef3b0@amd.com>
 <ffd66203-4349-0986-2130-f8b156f1923a@intel.com>
 <ffe43a28-641c-c263-2ea2-67882b476cde@amd.com>
 <aeb969e0-b829-d869-a93c-1d15755367ce@intel.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <aeb969e0-b829-d869-a93c-1d15755367ce@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:254::9) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM4PR12MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: efb9ce54-4481-420e-78f1-08db3c6279a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2shO46CjI+ksh78qMZxVy2olHmArB7X4JMJW+6sWt80af1pNMaly4jraN5jxclGoVQ0NId21lT2Ls8iB8tKQi5Q6DUH7hhEVrkmhv7PxBtcpr1MkYfpw9Tf+5emfZp4TGlbjFb+C93PrFzNWruGqFem19mf3Hy3tI/NusEPmLUc194Xt+b9AvcZkD67a+mR8pZbDizIMpaJXAuKxqwxvAsXdwxzvliLJZ3RALFvheN7NGsh6i5o7rFiHhFMONTVim3kB5R2W1aKxd6fDQQ5twIZe2AQ/hW9WoiM3nFRocm1C5KA3nMZGnzRZFeUDYOv/6LbHS2Li96wHA49GA4X9nQGL5gXsyWmR5VkgtLDeBjM4BtCscfeGV1d/dxr94pCnQ0fIKjIavcaIVdpOUiAW8nbN5SO7rjdURMUCrEW+UxztwImbV8tlD5In0Uh68Xb7SpNq3U882t7xdZGPtFHvMN1dM2qdOZHEGoRpIC//7vo/wubbEsS2JNx9FqNrMg/S0OGcy2Qqh5730lcOyAQGawLGU0/pJCvSU4iz5N8hhQL/I5li42fs0mOeaEiMj3+Ij2jsr06udeAyO+rNdkyTgTuIChryAPxdox8QJenDWtiwfl+zGsbTYm776e4ajzt0R2H4KDgSqwvmaNxViYahQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(4326008)(7416002)(53546011)(6506007)(6512007)(26005)(6666004)(38100700002)(6486002)(83380400001)(186003)(2616005)(44832011)(36756003)(2906002)(8936002)(31696002)(66946007)(86362001)(66556008)(110136005)(478600001)(54906003)(66476007)(8676002)(5660300002)(316002)(41300700001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2RheVNGT3B2Q0dYSmpuTFI1ODczT3NyNmtZeG5TZ0FTQ3V0SEU3M2cyYkJk?=
 =?utf-8?B?c0FYQzJ1dmN1THVMZ2c0R1FuNkVqUTJ0MFBrZnJCMG9zelEza0ZTUlh3R3FY?=
 =?utf-8?B?a0JxdmpPVG83NjZPM0JLTmNGcGRyeWsvRlQrWVhKVXl6ald6aFFTSHhNNWRx?=
 =?utf-8?B?SmFFOEtod1phM3l6b3hoZHo5MmJqWGJPUUxKTFpQcHVIZnlWV1h2Q1k5dlc5?=
 =?utf-8?B?aExOUlZGRDhucWpPRGxiTjY2SHQzNDAxRlBlM2E0aHdVZmMrYUNQUXp6OU5Q?=
 =?utf-8?B?Uy9KTWNoVEh3a0JMais5ODM0VEZvZmdZUGIyd2o3Vm9SdG0ycFNGRHRrNXdB?=
 =?utf-8?B?WVZ6aE0rSGkxOTNDNFZZNUFXVVZSZjFpZ1lmY1lONDdhUEErU2RlMDNyU202?=
 =?utf-8?B?QytlTGJoU0RmSExIeGQvQ2RrKzA2NFEvK09ESHpkOXFsQWloSUx5NEo1a3kx?=
 =?utf-8?B?SUZ2NFNFVHgzQTY3MlVVZlNXZ1dWRU1VSXJzNUZjWWVuOFJmSFI4Q05ZZ0lq?=
 =?utf-8?B?SUdQUFNLQVRCL2tDQkxTOGtkMmxOaDZock4rME9pVzdRN1VTQzArRWlrUkdK?=
 =?utf-8?B?Y0V2b1BZVmhLYXErcGJqZGpnTUNkOFB2Z0xuTWNxZzgwdVN1YTdla0hsbitQ?=
 =?utf-8?B?Q1ZHcWsrakVhMmJaSllPb3pPY2J1TXNhcnFvbFhyaXJiS2twRkVaNi9xVzFk?=
 =?utf-8?B?cFpjYjBhWDhIOGh6VUp2VEZreXhES0VQZmViZlFaNldKUUcxanVJNFJrQ21Z?=
 =?utf-8?B?ZklxNytmVmZSZ0dRcXNuUElHRytFQnpobXlUY2h6OE9CN2hHMldEd2JNVUxR?=
 =?utf-8?B?Tk92dzZ0S1RJbHFFQ0pSNFN5YUR0ajJxbG10a3h3YnpJVlMyN3FGY2xrOWJN?=
 =?utf-8?B?UzhOOWdIWWJVL0RzaVY3a3QvK1ltNWtld2ppTzlBSkFUNDNyK1dBczM3S3Fz?=
 =?utf-8?B?aVdBb2U5eFloRFJPa3plUEMrbk8rbDJ1VElCR24rM1RUVXJCMGlaUzJBbC8w?=
 =?utf-8?B?dC9xTkNNZFlEcEdGZzFyT0xSWGJzRGxWQXBkNjVoSnQ1Uml6akl4Q2FNMEs5?=
 =?utf-8?B?MW91SHRKVW1jTWxoMmMybFNwUU1scUxvUXVCZ2wwTmF6RndWL0dVcDZITHJG?=
 =?utf-8?B?Q0pzUGNGZzY2V3N3UTRPd1dPZWFNRWM0eWluWERJZlVaVGN1YzNaekl4S3Vv?=
 =?utf-8?B?Y2ZzejZoVVBDOUpwZU0xazgrcElwT3BOd05sNjZaKzlnSTJNRWV4NnUwQ2xk?=
 =?utf-8?B?NjFRc1NRcHJiWC9uWURLR1hvcDhSNzE0ZlJZNmpPbExBSWY2d2hxWWJrTlJM?=
 =?utf-8?B?OHJpMk1GUXVxZit1SnBUdjlMU3BCc2crRTVlSUkxV25EVFo5NEVndHUvOFhR?=
 =?utf-8?B?NkNybFU0bFZlSGZJdWR6N2tNWW1oUkNCOXF4dmVpVWYwbkh4bTFDK1h2bUV1?=
 =?utf-8?B?MzV5K2IvdzIxdkpQZTJnTnFORDR1SElTaEQrbVFVSnljSTl5ZjdHV0RNUFp2?=
 =?utf-8?B?cFJuTGNTMDVPUUdNL24vdHRDTXVYcUQ4U29oUzZNL0hDVDRFSEJSTml6c1hm?=
 =?utf-8?B?TXR5L1ZyZktCNW1LQ0F5T3NkWDJLRUxWN1VqZE04a043bDRZVlpuMHQyMGpP?=
 =?utf-8?B?VVIvWE9WYk1DY3NrV1FrU0pndW51NWJQemFLY2d6TURLR3k2NmNVdnJ3bnVT?=
 =?utf-8?B?Q2QwelJ6VWVoNHlkb2hTNHdDWUpBbm53S016d3lIMThZWTY1RTVCL1FOcy9D?=
 =?utf-8?B?ZnV3VWNqZ3podncrcTNwdTd3Q2V1Y0wrYi9PMkx0aXV5cXV4M0hzZ1hmdEdz?=
 =?utf-8?B?RjQ2VXZoS3Rld3ZhU0psbjVWWk1FNkVYNndDL0M1dkM2WUxlb2hHR2o2WmxH?=
 =?utf-8?B?L3lvTlgrU2lrL3NQcHZuN2xtT1dOcU0yTkxzdDArTVRXYUhGbEgrdlB5U01D?=
 =?utf-8?B?MlRaaTJLWEphdHRrOUpGY3RvcFhVSE9wN1IvWTlQSE4xUEFSbUJ2Q1Jhb2Ji?=
 =?utf-8?B?WS9YR3c2SGdxTWw2QWk4c0NjcjVyekRna21KMmJSek5BYlVIL0dwTzNkMVJR?=
 =?utf-8?B?UEhKMldFVitGT05UK0JiN2tKUG9sTmtwbTVvaUFpVUEvSWVNUC9lT2tlUUVq?=
 =?utf-8?Q?RM0seebhFPCX2JaDNNlnmPFbE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb9ce54-4481-420e-78f1-08db3c6279a9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 21:03:05.1115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOwDSiy87qpLngeTwe8l0MIFY2C7cAJyhfLefkOTA/TVZWGI7lemgBSrCmMEk7jZg7RCwHaWB88EHJeHJZQskA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6011
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/23 11:54 AM, Tantilov, Emil S wrote:
> 
> On 4/12/2023 2:36 PM, Shannon Nelson wrote:
>> On 4/12/23 9:58 AM, Tantilov, Emil S wrote:
>>>
>>> On 4/10/2023 3:12 PM, Shannon Nelson wrote:
>>>> On 4/10/23 1:27 PM, Linga, Pavan Kumar wrote:
>>>>>
>>>>> On 4/4/2023 3:31 AM, Shannon Nelson wrote:
>>>>>> On 3/29/23 7:03 AM, Pavan Kumar Linga wrote:
>>>>>>>
>>>>>>> Virtchnl version 1 is an interface used by the current generation of
>>>>>>> foundational NICs to negotiate the capabilities and configure the
>>>>>>> HW resources such as queues, vectors, RSS LUT, etc between the PF
>>>>>>> and VF drivers. It is not extensible to enable new features 
>>>>>>> supported
>>>>>>> in the next generation of NICs/IPUs and to negotiate descriptor
>>>>>>> types,
>>>>>>> packet types and register offsets.
>>>>>>>
>>>>
>>>> [...]
>>>>
>>>>>>> +
>>>>>>> +#include "virtchnl2_lan_desc.h"
>>>>>>> +
>>>>>>> +/* VIRTCHNL2_ERROR_CODES */
>>>>>>> +/* Success */
>>>>>>> +#define VIRTCHNL2_STATUS_SUCCESS       0
>>>>>>
>>>>>> Shouldn't these be enum and not #define?
>>>>>>
>>>>>
>>>>> This header file is describing communication protocol with opcodes,
>>>>> error codes, capabilities etc. that are exchanged between IDPF and
>>>>> device Control Plane. Compiler chooses the size of the enum based on
>>>>> the
>>>>> enumeration constants that are present which is not a constant size.
>>>>> But
>>>>> for virtchnl protocol, we want to have fixed size no matter what. To
>>>>> avoid such cases, we are using defines whereever necessary.
>>>>
>>>> The field size limitations in an API are one thing, and that can be
>>>> managed by using a u8/u16/u32 or whatever as necessary.  But that
>>>> doesn't mean that you can't define values to be assigned in those 
>>>> fields
>>>> as enums, which are preferred when defining several related constants.
>>>>
>>> We can certainly look into it, but for the purpose of this series it
>>> doesn't seem like a meaningful change if it only helps with the grouping
>>> since the define names already follow a certain pattern to indicate that
>>> they are related.
>>
>> I was trying not to be overly pedantic, but the last words of that
>> paragraph are copied directly from section 12 of the coding-style.rst.
>> We should follow the wisdom therein.
>>
>> Look, whether we like this patchset or not, it is going to get used as
>> an example and a starting point for related work, so we need to be sure
>> it serves as a good example.  Let's start from the beginning with clean
>> code.
> 
> Got it. Will convert to enums in v3.

Thanks

> 
>>
>>>
>>>>
>>>> [...]
>>>>
>>>>>
>>>>>>> +
>>>>>>> +/* VIRTCHNL2_OP_GET_EDT_CAPS
>>>>>>> + * Get EDT granularity and time horizon
>>>>>>> + */
>>>>>>> +struct virtchnl2_edt_caps {
>>>>>>> +       /* Timestamp granularity in nanoseconds */
>>>>>>> +       __le64 tstamp_granularity_ns;
>>>>>>> +       /* Total time window in nanoseconds */
>>>>>>> +       __le64 time_horizon_ns;
>>>>>>> +};
>>>>>>> +
>>>>>>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_edt_caps);
>>>>>>
>>>>>> Don't put a space between the struct and the check.
>>>>>>
>>>>>
>>>>> Checkpatch reports a warning (actually a 'Check') when the newline is
>>>>> removed. Following is the checkpatch output when the newline is
>>>>> removed:
>>>>>
>>>>> "CHECK: Please use a blank line after function/struct/union/enum
>>>>> declarations"
>>>>
>>>> Since it has to do directly with the finished definition, one would
>>>> think it could follow the same rule as EXPORT... does.  It might not be
>>>> a bad idea at some point for static_assert() to be added to that 
>>>> allowed
>>>> list.  For now, though, since it is only a CHECK and not WARN or ERROR,
>>>> you might be able to ignore it.  It might be easier to ignore if you
>>>> just used the existing static_assert() rather than definigin your own
>>>> synonym.
>>>
>>> OK, we'll remove it.
>>
>> I'm not sure 'it' means your synonym or the actual check.  The check is
>> a useful thing to help make sure no one screws up the API message
>> layout, so don't remove the check itself.  If you can't get away with
>> ignoring the checkpatch.pl CHECK complaint about the line spacing, I'm
>> fine with leaving it alone.  Some other day we can look at teaching
>> checkpatch.pl to allow static_assert() after a struct.
>>
> 
> I should have been more specific. I was referring to removing the blank
> line as I think we can live with the CHECK. Your call I guess.

I'd prefer to live with the CHECK as long as Jakub and friends are good 
with it.

sln


> 
>>>
>>>>
>>>>
>>>> [...]
>>>>
>>>>>>> +/* Queue to vector mapping */
>>>>>>> +struct virtchnl2_queue_vector {
>>>>>>> +       __le32 queue_id;
>>>>>>> +       __le16 vector_id;
>>>>>>> +       u8 pad[2];
>>>>>>> +
>>>>>>> +       /* See VIRTCHNL2_ITR_IDX definitions */
>>>>>>> +       __le32 itr_idx;
>>>>>>> +
>>>>>>> +       /* See VIRTCHNL2_QUEUE_TYPE definitions */
>>>>>>> +       __le32 queue_type;
>>>>>>> +       u8 pad1[8];
>>>>>>> +};
>>>>>>
>>>>>> Why the end padding?  What's wrong with the 16-byte size?
>>>>>>
>>>>>
>>>>> The end padding is added for any possible future additions of the
>>>>> fields
>>>>> to this structure. Didn't get the ask for 16-byte size, can you please
>>>>> elaborate?
>>>>
>>>> Without the pad1[8], this struct is an even 16 bytes, seems like a
>>>> logical place to stop.  24 bytes seems odd, if you're going to pad for
>>>> the future it makes some sense to do it to an even 32 bytes
>>>> (power-of-2).  And please add a comment for this future thinking.
>>>
>>> We can change the name to reserved to make it clearer, but the size
>>> cannot be changed because it's an ABI already.
>>
>> That's fine - just make sure it is clear this was intended.
> 
> Right.
> 
> Thanks for the review,
> Emil
> 
>>
>> sln
