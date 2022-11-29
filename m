Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A4463C6E5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiK2R5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiK2R5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:57:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1348443AF6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:57:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aa3gO2hsU0VQfreusj9LFC556sPV8WuxoATs73Ec//xIE7TjGa1GP+UOiqyat4vhe3AerGZgFqRgijbZ57pnCYVXBVd3O2uZP31wj5Ha2vsmhIPQlyTpgf6FGaJuPjpDPN9rgmwZbaZMhI3GbPeRwqQXhpRgtNW647TBDEqdGMMfHEe+/8LpGwy94ysjWfwOsKQERkJFczrpA4hml/WBFgPGbnEfPJ8W9aVrtd3+f/ry7fs3MorqPnAjnDpHeh1hkzwurZ52AWilsrnFd3m3XYR6tQGuiVbYR6kDQIYf/x+cfqta3Ssp/7JGOURe5pxA/D0zndguVx/+9KR+Fm3IvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agUt1z/v2oEiEMpX2g9M11OkTAJW5gaIkME/Rtgx5o8=;
 b=Na0SxDrnzRkIprK0irlW7nXYi13VbVBoB2ULAMXNGbS8uGHo9E8ulsWhXANCI3UXsU0Z796yq9UbiT8b570AzemAaZzBffh/cTEh61C6JBy01Eu1AoXFynOdGktYJ0Hs2GtgWdKRMQ8wrRuz7HqllXP6ReuvAoaeGChheIGpo3CYDzhBZTGaTL16D5/Qe/LjA6Oiuq78TJSTBo8Qs8jkv1v02QubsT+Hb12537k62Ravlg1f69Cp2H0iiVayvGHz2OSuAEe6MI9JX3W/iHJ6iSCXmF1lZtwMgySFgD9qNv5Y05AJb2IUarcQlnl/J1AJk5ididfZ9QixxSOGqkYszA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agUt1z/v2oEiEMpX2g9M11OkTAJW5gaIkME/Rtgx5o8=;
 b=KxUTCz0+wxNSZQI1NLyhfxNZBOlL8j0chS0YOFxZtKufFNIXCz7dF8ohnLZzGC7+1QFPrEc9f1ZhMvTn7Dl2K+QdthBwm3jdRxvr5nhJm0JnISC7eCWs5qvCK1EY6vAEBmhR6RojKGTNINyHdSYR0qFbAkO+RgmMVrB27Mbb8+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BN9PR12MB5337.namprd12.prod.outlook.com (2603:10b6:408:102::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 17:57:29 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 17:57:28 +0000
Message-ID: <fbf3266c-f125-c01a-fcc3-dc16b4055ed5@amd.com>
Date:   Tue, 29 Nov 2022 09:57:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-9-snelson@pensando.io>
 <20221128102828.09ed497a@kernel.org>
 <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
 <20221128153719.2b6102cc@kernel.org>
 <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
 <20221128165522.62dcd7be@kernel.org>
 <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
 <20221128175448.3723f5ee@kernel.org>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221128175448.3723f5ee@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:a03:255::30) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BN9PR12MB5337:EE_
X-MS-Office365-Filtering-Correlation-Id: 880c0c4b-e386-4da4-00dc-08dad2332e30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tI5MrLx+z+5B/uyKMkCtWIoLSzO2SRgC7w/yuWhWIdosV4WME/bdp/bCzINPmhnGz2vq+NeLsCTIWnS4lQU0O4FOnjosx+uZDEQCRtCPUM2HX/HdFd2axA335CIiy+j4tHLiCQN7TJb069yCff6lPT7HR1Pa/fUcw3B613ozf/VcTX7sXkcLHXmfbGuIuRL4L5d5bUK/V3r7hkgu0g5+nU8eKVo5lLuHRjW11iexjQMa3j04FBtd91xiJx0zevZW0BWcndcarWF2bmEs47n6K1aWeQgG+RU8XSKpsGeof/pFJIE52GvGRki5jyq/qNWDlhFsEyjvI8vTif7itulwiNmZtSDOdcztzurfkng29jsQXS2wD7FsFESjSdDT4Sj1WL3jUeSx3SxH9wjfaSAzNtf+weBax2RqsAqbJxdpdNWg+cKSlSQf759GIGb+dEbYEshQgoO29B/Ku1FmcVbThx1OfqU4wveHZCGk00mjy3LoSS1ZCo5NYNpfYtLA1WuXIoB+NVHnDJU0ckLRge+aXbX8l4XylfWnr5K1WG4jdpA5OwUvsQshRkT9U8cedLQd09FFMqe1ZA3kVJWYWRZHr3zxgVPTkMMvZselXpTnp2cbLYo/xIE997rMRRtJwot/NhzxQijURGO/DJjiSgbMlstiSwGKv2GH7QgQ0I6ERF5ZM1vFgDtgekFoXvukCb1dO703Lku0+BG3vY3VzCLnSQ8itaNeiwVWv18HHMSP8V5ulr61rAjuvB380fndR9Ms
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(2906002)(186003)(31696002)(36756003)(6486002)(478600001)(6666004)(6506007)(2616005)(8676002)(66476007)(53546011)(41300700001)(4326008)(66556008)(5660300002)(8936002)(26005)(6916009)(316002)(83380400001)(6512007)(38100700002)(66946007)(31686004)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkNTVmNtMjEyeEs0MnBkZldqZmNudUdmZUU4Z3BnWEh6blJhK24rY0RaQWkr?=
 =?utf-8?B?OExtT2wxei9Oejg5a2FqTG1Xa29rclp3YVZ6aHZCOWpQRmJjem1QcFlWLzJN?=
 =?utf-8?B?UW1vWTNZV3RTQ2c1YUZVdUVRdlRVbmRtZTJTQ0o3amRDY2J6bGNxanphMVlh?=
 =?utf-8?B?ZUY2SHZ6NFpsNDFtbE5UMXpLSXl3RmNKUXEwTDFlUUl6cW05UnE2ZnEwK3FC?=
 =?utf-8?B?bDVNMnZnYVBEK0NWQTJtTWR0MW9SemM5RDdhUGNvQUQ1VWxjMVVuMUd2QUxL?=
 =?utf-8?B?M3ZveWRmaC9hWmhtRVpzNTRHZlZSdmR4QVFqTVYrRHl2SE1qajBQY0lqNlV2?=
 =?utf-8?B?WENpN0pRcnU2ZE5SRXhQNDAxbGY2R05BOVlhNmVJZk13b1ZaMUpYU0NhSVVS?=
 =?utf-8?B?TmtGUTdJZnV2QnlqKzJCcnV3ZXhLbE5melUrQTlLYWRLWlFNcGp1cnMwemg1?=
 =?utf-8?B?TTNRRWs2M0dmY0dpTlR1TG5heFExL0pqWFdMYys1TjJFcHluY2RjLzBrVFhn?=
 =?utf-8?B?UC9Hci94Tjk3L2ovS1k1L2tYTURNRU1nVkRzS0J1QXJFK252S3VEZ2VpL09s?=
 =?utf-8?B?Z3pGeENydVdzdFpleHg4TDFmTHVzaWdWVnRRNjJoY0xpZENGYzFrR1ZSa2Fl?=
 =?utf-8?B?NFZmcmp1UHZySWlqSGZhbFBKZTZqRzFMMjRvd0dnT0V6VHQwci9uKzZTMGVV?=
 =?utf-8?B?MnZCeHByOTJpTW9QK1FUQU1jRTZqSFoyTis3OVdOWTAzRTlOREZCZmNPbDdQ?=
 =?utf-8?B?dzVrMTN2QUJIT1FCMGFJUmJhN1p5WXh4L0FLejhiaGdDM2c5dXdBRDJ0TjN4?=
 =?utf-8?B?dFhHbW9Eb1EreERZTnZwSGRQdFhiTDF5WkYxcmp4L1FBbENEZjgycXR4RUxK?=
 =?utf-8?B?Q0VDaHJQQ09YTE1zQVJDY1lNNE1IeDdGR1BPZUdXL0lTYXdGWVViUVkrN1pJ?=
 =?utf-8?B?bTVXWE0vWnFyNS9MdmZhT3MxUzBqVWZTMG1oL2FzWnM0V3FxS0k5ejFrV3Np?=
 =?utf-8?B?dS9GbUJ2dU5SZXBMQmlNZ0EvdjVGNEdZQnFCWjcvaS9pamUvVmhhY1ZpMmR3?=
 =?utf-8?B?Q1pReUh4bUlJUVZSOGplNGVRMm9CRE5yY0FvaU9UZVpSbmVJeU9lckRITWth?=
 =?utf-8?B?MkpLV0l0dkJZS0RlNUJmK1FRNXMrTzlndGJmSXJvWWVZYk9NZmZENTBjOWZv?=
 =?utf-8?B?dzNHaDhJUE1XVmtieVpkVGw1bjFKZkRtL3dHOEJnRTJnNU56aGIybWpPYjhq?=
 =?utf-8?B?M1FEQmVtWklKQlBXaFVkdUpMY2ZkWFQzeEFKenUvWlVTWTEwZmVxUU9wOUdr?=
 =?utf-8?B?eTRQQ3hvMkJoZE9JNXdzcFBzMVV6a2k2UVZqQncwQmhFQjRiQVB4NGxoR3cz?=
 =?utf-8?B?QnBnNGxZK3JsdC9nYWtKUTBaR3BEamRSMjB6RzdpaFhrNmZVbTQ1UnRmS3hC?=
 =?utf-8?B?VFdsdG83eElNb2t6RS9pMXgzMHlYSFRVd1FZRzBkWVdBWFl3RTd4WEQ1OWdK?=
 =?utf-8?B?RDViVjYxbXhMUzhERi9WeGZoR0hNYnVxNUpIN2J3M1g4V0gvV0dHKzA3MTFk?=
 =?utf-8?B?ZlgrZlVQb050V2p4VEdIQ0NGamNTN24wOVRPenE3NlhSb3NlL3FQL1I4cEwv?=
 =?utf-8?B?WGJ2Y1FibGpOVVlNb0RtS0hBR1lHUVZVRVFkL2VuT04xMW82QzcyTkdGZ2g3?=
 =?utf-8?B?bzhPVjVRTnZYQjhTN1lGUGJTZlJ1eUUvSWNJamdvN0Y3UlZGTjFaMEVzME11?=
 =?utf-8?B?TWhtSjlzR0hmOC9aYjVETG9lU2ZNOStyck40OVJrT0UySlFlWStwbVBXRWIz?=
 =?utf-8?B?NEpmby9tcGh0dGpwWjVYWmJpU3FRVVIyVWQxZW5wRi9BbFBSL1Z4QkFrWG9C?=
 =?utf-8?B?Ny9vUGhybmJ0aW9GN2M1Q3VINllMSk83TjVtZmNrek9KbTFCeE1MSlpVUzla?=
 =?utf-8?B?M0hUWnJxMlBObEl3RmRldW5aMmdWWHdkSDJGRVNPdE9oSmtYWFBxT1J4QTBm?=
 =?utf-8?B?ODlUZGpPRjNPUUJESEx0M0ZmU1c0ZFg1QUNqcEQyc3pmU0FmeXlhQUovZjBv?=
 =?utf-8?B?RkE3NDhkOFNoTldXMnpuRnhWdDdNSW4vU0R2QlBxbVByU0hWTUdBdDJOWUFh?=
 =?utf-8?Q?t2Yg/nBuTqjjqScxcPbLznjtE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880c0c4b-e386-4da4-00dc-08dad2332e30
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 17:57:28.8127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +w2XZfAUuQhtiPlFqlsMzP23gq5+FqmE5/je5Y3HfQErxqt9/YP+EqfIQ/lGNk9vHzcC7wiZVK/RR55BMKD2lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5337
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 5:54 PM, Jakub Kicinski wrote:
> On Mon, 28 Nov 2022 17:08:28 -0800 Shannon Nelson wrote:
>>> Don't even start with the "our device is simple and only needs
>>> the legacy API" line of arguing :/
>>
>> I'm not sure what else to say here - yes, we have a fancy and complex
>> piece of hardware plugged into the PCI slot, but the device that shows
>> up on the PCI bus is a very constrained model that doesn't know anything
>> about switchdev kinds of things.
> 
> Today it is, but I presume it's all FW underneath. So a year from now
> you'll be back asking for extensions because FW devs added features.

Sure, and that will be the time to add the APIs and code for handling 
the more complex switching and filtering needs.  We leave it out for now 
so as to not have unneeded code waiting for future features that might 
never actually appear, as driver writers are often reminded.

> 
>>>> The device model presented to the host is a simple PF with VFs, not a
>>>> SmartNIC, thus the pds_core driver sets up a simple PF netdev
>>>> "representor" for using the existing VF control API: easy to use,
>>>> everyone knows how to use it, keeps code simple.
>>>>
>>>> I suppose we could have the PF create a representor netdev for each
>>>> individual VF to set mac address and read stats, but that seems
>>>
>>> Oh, so the "representor" you mention in the cover letter is for the PF?
>>
>> Yes, a PF representor simply so we can get access to the .ndo_set_vf_xxx
>> interfaces.  There is no network traffic running through the PF.
> 
> In that case not only have you come up with your own name for
> a SmartNIC, you also managed to misuse one of our existing terms
> in your own way! It can't pass any traffic it's just a dummy to hook
> the legacy vf ndos to. It's the opposite of what a repr is.

Sorry, this seemed to me an reasonable use of the term.  Is there an 
alternative wording we should use for this case?

Are there other existing methods we can use for getting the VF 
configurations from the user, or does this make sense to keep in our 
current simple model?

Thanks,
sln
