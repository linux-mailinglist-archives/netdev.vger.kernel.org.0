Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11AE6CFD32
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjC3HoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjC3HoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:44:03 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3224681
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 00:44:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7ID9l9/TxH7myqFz/ZDXeuXgHF21sjh+CBAI9loFrqlJrsyO7CJDEal58cx7fmbD+9jYkUDBoIQ9xD11NJxzlBuVRwc33OBWMiVZUvgcavoK1dqIFLZgxjLwtlzOn+dFjyEH3YVHhhkRRwXN9I1RvWGUwci0/xZxQFISd6mIngREAOvJ6itrEYII1cezDkdG9Jd1glMoaPm+1SfTxyzU06smIylRtAmnk1dLRnOqB7l/Us1ZixzzdqQ3G9YYyH7KYdMTkWbbrrU1tpBGz1iMAmv1TOcuW+ufKgP7KOQlnrv2tT5r4sJlXZQhxBA17PjifztLjgjLO3Z73OvhiITZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRob7AuLbZ+0u6f1YlVSlXmPHr3MbVj8K6gjfiTHPFk=;
 b=gG4aLzGpfa0FtWCdzKhyH69b2PEghgB1AP0igE6BgiLF+X19b13hp2DRLscKxp8ng4gaps5YyxTjz1I4XU/LwwR2DNtfWtfoCMuQWYSrDwm7MR6ojJjlp7YvVxbN2lonDcra3OOxVuenDVeLJAMp8xXHwqjuJDc7xqVuAoqYk3VrTk+o6zFaz+6NG26yhbYpkphOqCDxWxTNiyui45QYAznX2vLNO4h2pOMkkoA4I9lI8dwOlsilLiChDylyefqjJrKnVjxHvcMfeZgUOYnxK0GPAqy7TI4w1qC9Mm3fiGyvqO0vA+M5PU9n16sbt8QMJ3J4tGKiByMYirEyDbYtQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRob7AuLbZ+0u6f1YlVSlXmPHr3MbVj8K6gjfiTHPFk=;
 b=myDA1g34t0JGMC5rwR9B7o/HVo5HXXIa2i5oEgDnddHU92z/0tm4aPVurvEaVoC2BYuRp8nvp6EonMURmflMVtQvjdwyjqV17uLVa8zBFt/YTPOcoHduSIDKCe5++VkQmVcGjOV1lJKxBIBIKHbQfSMscmpB0WobGzFQZY55/6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SN7PR12MB7811.namprd12.prod.outlook.com (2603:10b6:806:34f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 07:44:00 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6222.029; Thu, 30 Mar 2023
 07:44:00 +0000
Message-ID: <90284b4a-0e81-441b-5d28-547992dab274@amd.com>
Date:   Thu, 30 Mar 2023 00:43:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
References: <20230324190243.27722-1-shannon.nelson@amd.com>
 <20230324190243.27722-2-shannon.nelson@amd.com>
 <20230325163952.0eb18d3b@kernel.org>
 <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
 <20230327174347.0246ff3d@kernel.org>
 <822ec781-ce1e-35ef-d448-a3078f68c04f@amd.com>
 <20230328151700.526ea042@kernel.org>
 <45c28c76-688c-5f49-4a30-f6cb6eab0dce@amd.com>
 <20230329192733.7473953c@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230329192733.7473953c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0041.namprd07.prod.outlook.com
 (2603:10b6:a03:60::18) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SN7PR12MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 4997478e-e98f-499b-31bc-08db30f2861f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jxaJR2fLjDJM8aMKDit8UUnXMcH9sI1UAmtK6UKwVJUnW54NsmnhlOfWLrLiTEz3yp1EP2fHTT55imaXZy0e8wgR1Zv3rfGi1dTsx4G/tO6zb80ZGleec3f04ARro1AXfCI5QN3VYII1lbwQ/FcMucNOG4CkZRQWDi6Hqu4DCjbJ3GjKpl/KChimbh9aBEaJuvw1hl8uh6HRXii7OhM0iEYGaYWZaRChCO9KAVS1lM5cSTB1xxgLObAt8Wp8wWcr2lv7NudBmabPl1KYeuWn/a7VJaSaBdSJWcCHlmEKZjm8mwrWy7F6lwbZZi8pmAapgtpGAaumdMxgX8hMqbhfgzsMD255ILRLikdg27rkdYSeJy874fqGn/X6XgMyZFI6z8jldksJOHVLh+5mYYkozRs/TRDX6RmN57NbMVOybsON1LgOw2Xf0asBKa9vrxSMhU7qIYo6xDakLbXBUT3XhrOyvUZ/U4Ixd5UkQ9rZXeF/kol+N5Udz6YR6qauL18HCYbRzrAPTK+lWVNaxlpf77XKW6zDwPIQ+idUsO5viA0SXw4T2BEvVdwHIHDQWJDaKL4Ha0guv+e1lvuFEVn3GfxHeouw/GX6urC3ISdYIRWaEGkxMfQEpoEZCsMUgMeSc2RtXMQM2ph2NItTIAKAYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199021)(66899021)(4326008)(6916009)(66946007)(66556008)(8676002)(316002)(66476007)(41300700001)(26005)(6512007)(6506007)(186003)(53546011)(83380400001)(2616005)(31686004)(6666004)(6486002)(478600001)(31696002)(86362001)(36756003)(44832011)(2906002)(38100700002)(5660300002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlhHa2dTa1EzeFI5aG9oMVZGYXlzRXcwUzFUN0Ivc082aVlIYU9pYnVHdHNo?=
 =?utf-8?B?akJ0RnpGQ1MxanVxM29KbFIvMDhQcTE0amRRQlBiZG5DUEZFSTJPZ1hoeUlp?=
 =?utf-8?B?dkNnWDhIajVOWXMyRkpPS2ZiTU83Y0M1SHIvMGtMV3BZckM5Zm5ENEx5aGtJ?=
 =?utf-8?B?Mzl6QW93azhwTDYwYkIzWHNMdmRlSUpQbDVpaTkrb2dGQllIcDh3MGJXZFNC?=
 =?utf-8?B?UXV5MTdienM5WHIxUThqbjhSMEFOa2h4SHg3WG9nc1B2UzZoeTRDMVVJWTVM?=
 =?utf-8?B?aU4zUGNBU21DQ3ZCL1o0dWUyTkNkaml5cFhRc05rY0p4c2FGaXBjMFdmNFVI?=
 =?utf-8?B?M0w3V21JUFNqOGpVd0d6RnFsUGJ1Vm9LQXVZNlI3N0VkWHJNZWZXQ3BudkRI?=
 =?utf-8?B?enM3OHo1Tms2dmN2THlXMjVNWEpoOUNkY0VtNE9ubmw4VTZEdnJFeG4yYlBy?=
 =?utf-8?B?eWdUakordjJCOU9KSmdMNXFualVvbnVhWTJiTjd4dVE3QmloazBrcURWbjQv?=
 =?utf-8?B?RVdtMC9hbi9xQkExdXhQNmRaMVpLM1pRcmliUUI0blEyZE1Mb0dzYW5lRk10?=
 =?utf-8?B?RjV2NXoyd3ptR0JJVmpKSllFK3BPNFVQcjhOd3R5aXMvTmJVamk4MUFQdmxI?=
 =?utf-8?B?NmJVVHFDSkU5d1h3RXFsK05WNnZlSlBYNjVmOGc2OFhBcXBkTkwyZTFOQnNQ?=
 =?utf-8?B?NHNaaEpqR21mdmo0YTJZK1ZLREJzRVMrZ0tKUXFPaENaYysrVm02ZlRtaVBr?=
 =?utf-8?B?UzNSL1VMR3IwaHBrSnNyWlovOVEyanFiRjZUMVpRMzczQnNFaUxVNklnQlVT?=
 =?utf-8?B?OXc1VGFqeGFxK2IxTTBocThPdkd3T0ZEUHhhak5PQUtaRnRDYVl6VmtheWpI?=
 =?utf-8?B?MVErTXpqeittcUtmMnlESTZDck9wM1ZDTGI3UndPYWpsZVZoS3M2RDM0aEZM?=
 =?utf-8?B?QnNXTmZCSDRXaW5IVlZ4eDE3MzR5eDVjclpUdkVGTjBueWlFWGUzcm5tYm5O?=
 =?utf-8?B?N2NzM2JzYUM0czVISVczM0M0MmZDM0ZRcCtiYmkxc3lVQnhSSktpWWEzc0Vi?=
 =?utf-8?B?bFV4bUdRdUREZ1lPZTFUd3RDR2t6bGFOWS91cXRGd09yQVNJd1g1c2lCVk95?=
 =?utf-8?B?ZnFub3lqYlZBdk1aZEQ4QjRsRDQ4MlFhbXRpREhZUTYrRDUrR1Z5U1VWaG9S?=
 =?utf-8?B?YzBZaHM0TnczdkJJcmxNMkhnSU1DR2tHcVlpTnlqSWk5SVlkNTJxMlhvUVFo?=
 =?utf-8?B?T3FnajdEN1l4dWM5UWIrejNiTkdpK2JIQmNGQVM0MVFJV0xBVndONjJNMXpi?=
 =?utf-8?B?OUo4Y2ptMncwc05wUkNydzZJaXRIcmZjNElnODcyRCtRelJGUWYvbm9UZVBw?=
 =?utf-8?B?cXQ2cEw0cTRaSzUzOWJabjhBdzF0dW12VjN3SDBHUStER1laUzY1ZHhyNXZB?=
 =?utf-8?B?YWZjdC9WWjBvME8waVNpR1lOTWovV0xNNjY2Z3RCWXFrNWJLZGtua0J1NzJE?=
 =?utf-8?B?TlJYL01xUHNrQ2tjVytTVTc2a1I0R0JzcFl6TWRTaHp2MmgxcnJ2bnRVaHBM?=
 =?utf-8?B?UUcxZkZMdm1FVVNzZ2RqTWg1YTY0a2J0b1ZDdFB0T2w3bG12THFnMmVMWHJM?=
 =?utf-8?B?cEJRN0J3bWh1ZzBKVVgySHorVUV3V09lZUROMnFkRFRsMEI1cE9sMXM4Z1A5?=
 =?utf-8?B?ZVNBcndUN05mbGxFZGxBYVkrN0oreVNhMWp5bWpIeUk4VCtETnp0dnBkTSsy?=
 =?utf-8?B?Tnd5cnBTVDUya1F3U0xrVzJDRFVmdmYrdEVjc0ttSTFmZWZQY3gycnVKMHVE?=
 =?utf-8?B?MXp3bkpud2FNS0xXSFoxdTE3dlRCWkpmRzRsS3FDcUhaVngvcHFMSEhnZXF4?=
 =?utf-8?B?MEZqa0s4UmJxTDk4c0tWc1BBbXNLSWRJeTRRU1NVTzZqcG9KTGtIOFVNRk5z?=
 =?utf-8?B?M3JmYjh1Q3BrMXpzdUFNdnhGUlY2L2tyOGZ2dlgyRUxFTVdSWXBYNFNkUVVi?=
 =?utf-8?B?U0lqaFQyUXVpTU5hc2p2b2IzbSsreThZVnE2RFRlMUEzOStxUFNyb1BRSHF4?=
 =?utf-8?B?bjIvVzdMNDNRNkRrNktTN0p1NEpCZ0xmTTVkM1l5U04xRkNqQWNoVU5zWlBv?=
 =?utf-8?Q?aRHFwcQphSPFzlGQqJ5K9PIY8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4997478e-e98f-499b-31bc-08db30f2861f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 07:43:59.7109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aX5H93N8n4sjr23z8mxlGPWjdVqT5YyryozJr4xT1xEOHdYTzdmhiUwbeDUYXB2XyRpK4ycVXAcJHI4XkfFGyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7811
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 7:27 PM, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 13:53:23 -0700 Shannon Nelson wrote:
>> The devlink alloc and registration are obviously a part of the probe and
>> thus device control setup, so I’m not sure why this is an issue.
>>
>> As is suggested in coding style, the smaller functions make for easier
>> reading, and keeps the related locking in a nice little package.  Having
>> the devlink registration code gathered in one place in the devlink.c
>> file seems to follow most conventions, which then allows the helper
>> functions to be static to that file.  This seems to be what about half
>> the drivers that use devlink have chosen to do.
> 
> It is precisely the painful experience of dealing with those drivers
> when refactoring devlink code which makes me ask you to do it right.

Is there a useful place where such guidance can be put to help future 
folks from falling into the same traps?

> 
>> Sure, I could move that function into main.c and make the helper
>> functions more public if that is what you’re looking for.  This seems to
>> be the choice for a few of the other drivers.
>>
>> Or are you looking to have all of the devlink.c code get rolled into main.c?
> 
> Not all of the code, but don't wrap parts of probe/remove into
> out-of-sight helpers. It will lead to other devlink code collecting
> in the same functions regardless of whether it's the right stage of
> initialization. Having devlink.c as an entry point for the ops is
> perfectly fine, OTOH.

I started playing with this earlier today to see what it would look like 
with some reorganization.  Because the amount of code in devlink.c by 
the end of the patchset is not too huge, it doesn't hurt main.c much to 
include most of the code there.  The devlink.c file might just evaporate 
all together.

I'll try to have the patchset reposted by this weekend in time for your 
Monday morning entertainment. :-)

sln
