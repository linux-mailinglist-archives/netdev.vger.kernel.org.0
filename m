Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3F16CD37F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjC2HnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2HnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:43:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50758196
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 00:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YivMCCFogPwG82rmhmdoNdRnKmclDfq8XlVLxVhtigeMQWRsSyNKaS0Z5fAOo4+0sZ1d1buHtBDb7u0XvcVO57e8ZiLVuieO7LfYN3lgu1yN4kU6rjmCuY2AJqY9lSG03V3x7w9Tp0boU4pzj1Pdtupmwx7DGWigExRuu8iN4VuaTdPsp+sFx+eKLhrmZP55p+VuUDNq8pUcZ1+pFeM9rf3HC/5o0n2WHl9UsyKejQlIrSd4Z9SJWObgMVilJjuoQrbiKQUadGOwZwTX6DIM2AV4oC+Saglmhfy75qJ3lzAM75ZHbAB2xxHRddTBWWtHGc7FIN4L5P/jnIXDkXh7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5n2a6P+HHwmIoFLSpcxN8+sOthcOwPaC03DXm+bkTZM=;
 b=Dcts3xOplc7KSH0qIJjne0cjvbR+gA+LrnDND1AGc+QsTI3/TzKCKUY82gb+g5orHgSquPOhae+71cNkHIjQ5oY+ZVH7KPNVJZzbeBwksVfCEN1c4D/J8JH8NS5yzfV0jNRZFc+sEJgSHYL4sOgY8fPh6hTwsmtltu26FSU7WXWs7Kugix/A7uT/kvvJ52gIdf64XrOFEN0FOqb9YtysijL5C4iMKQlVIecAdacibi1Ti3PiU6UhaG9Ot3cRIUyLr9iA0dLE1bN7xOnz3rAf1//vPXbNvPAbg3CmS1LGLeD86C07klvf+GjyguOC2qJSOaAwxzbSdkCn0ewN4xgFpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5n2a6P+HHwmIoFLSpcxN8+sOthcOwPaC03DXm+bkTZM=;
 b=s2ZEKSGRD99E2uhrEm+xxAmoIEEQhormtt4Vs+FrX2VKptm7CDuU4xkXUYNvIe6X8Y0eMnTyimhHwMsnU4EqFYqevI78v+254/AH5dAnk5VuHytv39vlhf40zaaJWeoyVCTicVT/WIAzMAK/hbFBC2M1/vuGvuWpO0ie9jb5/G+ASJMOkEOBZSX9O2GMxCaM58bbEKij3IpAeqlB1od14T8K6nHK1XE2hmfVGvh4SsMH/xuqHiob/AUF2uwLcxlpm0XeGerggJfaiBiTz4tlDvkpIoJDJ3y8do71stvLcVvz0td2eXXgyZrRD70dJVMBHJLCkwiTllFLCJnh6F6yaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3725.namprd12.prod.outlook.com (2603:10b6:208:162::14)
 by MW3PR12MB4588.namprd12.prod.outlook.com (2603:10b6:303:2e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 07:42:57 +0000
Received: from MN2PR12MB3725.namprd12.prod.outlook.com
 ([fe80::7be7:b27d:4bd4:4053]) by MN2PR12MB3725.namprd12.prod.outlook.com
 ([fe80::7be7:b27d:4bd4:4053%7]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 07:42:57 +0000
Message-ID: <93f74c83-d2e9-3448-9f07-64214cc0f7f8@nvidia.com>
Date:   Wed, 29 Mar 2023 09:42:51 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 0/4] devlink: Add port function attributes to
 enable/disable IPsec crypto and packet offloads
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
References: <20230323111059.210634-1-dchumak@nvidia.com>
 <20230323102331.682ac5d6@kernel.org>
Content-Language: en-US
From:   Dima Chumak <dchumak@nvidia.com>
In-Reply-To: <20230323102331.682ac5d6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0437.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::10) To MN2PR12MB3725.namprd12.prod.outlook.com
 (2603:10b6:208:162::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3725:EE_|MW3PR12MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a2fddf8-94b1-4943-4eeb-08db3029366f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 93pikueC6OdtoxoN+cDf78EKoCP40IG/ifIJhmgFpllZeGLpJPVYPRh52p+cv3XXNEvZjlBS2Q3Tn0omw2YFeh/qC/+A5CzczWcaknznH1GPdSoywa52h2fs7hnWnM++k7UlP92KtrcE7a6h1hkRR034dQ1gAVepbisRpF318c+5lTAJSJwqGP0yZlQlDQNipn++O0C696AhmBQYY1VkExkHmt5YJzGQ2UhA1LTB1Q9/Uc1td2uYJlWuVDEbiDhI3NpztV7snFnrd8higdmEolV779UHWJr4FEQIl/dWhBO8iunryAM/sb/3EiGCF1pkm+Ydaz+u3oJO94F9xPtBfuqrDZtKL+0L6ikvh2deNb7KapTI0sIdbG/iheWYvNn4pfHpuReFwT3f14qFFkLsJsgPLmEiJt7Dp71UaQU6D4RvYjnuvqEOhneXgu/qTVFiTFAXnvknpoct1AaygX9rXH3b3JdfZdGw67Mo0UeamGmV/fm3Tjl1syTY2WwoadQMH5D6ZY6JO65WQm6zTWTz1GA0Mp/eSzzahwi3cAEyCRXS8Tw2MyiqRS0zTbovruzvpZgaw9F8DMAPdpZ6iIBa2TrjVNnnGiyN1OqtfaeacUyf3YMAv0S4MwPGO25Ao2Mj+euEMTdk0cu3Zz682GgXDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3725.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199021)(26005)(6666004)(53546011)(6486002)(38100700002)(2616005)(186003)(2906002)(5660300002)(8936002)(6512007)(6506007)(36756003)(54906003)(478600001)(316002)(86362001)(41300700001)(4326008)(31696002)(6916009)(66556008)(66946007)(66476007)(8676002)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzgrNm9CaEswd3FVeFRyYk1YQm5TanlUNlFDcVBkOVRobjRiZjRaOGt3Tjdp?=
 =?utf-8?B?TTllUWlGQm1hY2RENk50R1liL2p6Y2FNRlE1eGJOay9SQk5WQ3NDdzNaRTNn?=
 =?utf-8?B?QlZwR3JGZlR1SWp2cmFFSENZajRseHRyd3dJb0VxYmtiQkcxKzFkQ1M0ME1P?=
 =?utf-8?B?VWszeEVSRTNHRHZKZmU5K1F6R1lrL2d3N1NhMkJVSUFvSzQ4RDk5UUtKY09D?=
 =?utf-8?B?bWlFeGZ1a1RaWEVJNVd4RnI1bG5WZUpwM2QxLzhOc1FZSS8vSGtRR0g2bTdN?=
 =?utf-8?B?T2FlSVpYZE1RVzlzZnR5cGFmTndOSkt3cSsrQkJtckt1OCtuUW02MGI4VzI0?=
 =?utf-8?B?eDZ6Vm9oV056VEZ4WHN2TDhPcFVoVGp3eVl0NThpWU5JK2xPRExWeVMrMERx?=
 =?utf-8?B?MTEwdXJaZW1JQVkycWJQU2VjSndYa1kvVlJCVDJaSlpyWmFoWloxNWhYbE9m?=
 =?utf-8?B?UDBBL1NpdEZWUmNzTTNYcWQ0N21heWF4b1MvMEVWYUdhcTJEeVpnNUNyY1NO?=
 =?utf-8?B?T044QlE3andSYlJyR3pNQS9ZUEFSb1JuZGlBbldzeldiYTI1KzZWV1QydDZR?=
 =?utf-8?B?b09MaGZuVGtOQ1dNcVpMMVJ3VkFLanFidnBHbkZVYTErd1lrK08ybWFTWGlM?=
 =?utf-8?B?dHcvb3dwcDBKTldNaDArQ0ducm1VWU5YYnliVTgydGJSOWxweGxpWndmU3Vm?=
 =?utf-8?B?NUUxQXVwL3lnR3JKalA4azc1VjBDM0NGaGY3NG8rb0F3Um9yRFVMWlFqTktO?=
 =?utf-8?B?YnlLMVl1eEs0NXBJL2VCWnMwYlEyQ1lhSkNzY3ZHWFpsQ2Y2Tys4R25BYkM1?=
 =?utf-8?B?VVdqUEswOWN1VzV4N2hsU2ZEbDF5eVNIV2c3aUhZVVVtYlRNci8wZkZqUXJs?=
 =?utf-8?B?K3NPYm5yYTRhN0ZHMEJMdmtlNTVRNGdxeWlmRzYzRkk2SDVaSERWa05VOGEw?=
 =?utf-8?B?REdtNU96a2x4eXA1eW85ckVIRGNRRE1NZk1PRmFKRXA2eXVkTXd3SkZaWnk0?=
 =?utf-8?B?N2VUUnZnM2dySVowM2d3cWI2REk3cExJSWpKdVRTdU5oYnN5bUh0bjAvdGhV?=
 =?utf-8?B?U2syeWNOc2FpNWlZenR2NExFVW91RmNGOFNPaU1uYXJkTU82K2xMWDh6VWVh?=
 =?utf-8?B?d0pqNE1xOVNiZGFiMmJaMS9YRkp2aE5rRENKbzQ4MmJ2bTdnUzJ1YXdiNkF4?=
 =?utf-8?B?NnhzVjZwVUZhRE0zenBFZk5QY3h4Z2JoUDRsWCtiY2VhUDVUSEVKdEpISHpx?=
 =?utf-8?B?R2ZBLzZPbG15RThhZlIwMTEvY25sSFEvSVBJd095cFJtbnFJQmlhTExRRmxr?=
 =?utf-8?B?dktxZnNDcVkvZ1RrUmtvY3IyRnRIS3BzeERWWDdmSTI0Z0MwZFlXb1FCelcw?=
 =?utf-8?B?bHgzVHNhczZNOEFpNUtpUm95eFNMWjVZOWJVdUFlaWRXcXB3L2hVZUZpcHBx?=
 =?utf-8?B?ZE0yZlYrRUJSZjRRMnZPMTZBckxEQVBjTDBEakp2U3dvcHErdE54SjFEM3Jj?=
 =?utf-8?B?eHFZNzF4dCtjS0VldTJPS0R2dWp1a1Mzd3hPbG5kcEFhV28wTi9ucHN1bzJu?=
 =?utf-8?B?WHdTR3ZYNUNQbWg3OUhzK0ppNmRIek9aTEp2SVAxRXl6V0tHa1drK0ZFVDha?=
 =?utf-8?B?WFBGN1pXTWhRdTNvd2V5L2d4NlZUc3FhM0NEVmgwMXVlS0tWZWNtajlVN0dt?=
 =?utf-8?B?cTFZUnpCY0NpNEhJRnhVUWFoKzhrckpTbFR4N01haC8xNlIrd05SS3MzQ1dR?=
 =?utf-8?B?SHRDN3F0WElOb2dETVd4cFExc2VKTEswaXowVldVZDZabitQam94a2dZR0hz?=
 =?utf-8?B?RDV3dzUxT0VKTFJLcUEyRnkrd1RvYW1wcHB6eHBGRmVLSm5talJ0MVlDd3Nm?=
 =?utf-8?B?S2tWV2xaMFpmc2pqM1JIdGJpcVdYMmgwNWlBR0FQWTFvTzlxY3NuOGxBUElo?=
 =?utf-8?B?V1doOEpQNEpVcTNOM3hkbnJiYVM4THZoQU9KNEhnRGpMalJ6Q3k1Nk5NTVU1?=
 =?utf-8?B?RGFoQm8yTlE5cHpqN0VRMjBqajE4T3lpdjMwQk5BZXJ0RDg4eVdnY0ZYbWhG?=
 =?utf-8?B?OUx3M3VIcUZwR3haVnp0bEZqWjdUcW1lV2o2dmduaE1BTmsrZFREWC9Qdm5C?=
 =?utf-8?Q?alAYlpQ7hcgIe3jWdxHqmBHhI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2fddf8-94b1-4943-4eeb-08db3029366f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3725.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 07:42:57.0027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vXoELVg4/qbqcnfahAo6tMZYrfTGiUNlZlr6v/LY41Xy3fxP0FJIoq1mfsIog3/1EuGMlLPS67RZiZ6TQfk4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4588
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 6:23 PM, Jakub Kicinski wrote:
> On Thu, 23 Mar 2023 13:10:55 +0200 Dima Chumak wrote:
>> Currently, mlx5 PCI VFs are disabled by default for IPsec functionality.
>> A user does not have the ability to enable IPsec support for a PCI VF
>> device.
>>
>> It is desirable to provide a user with a fine grained control of the PCI
>> VF device IPsec capabilities.
> 
> Is it fine grained? How many keys can each VF allocate?

When I referred to "fine grained" control, I was talking about the
different types of IPsec offload (crypto and packet offload) in the
software stack. Specifically, the ip xfrm command has sub-commands for
"state" and "policy" that have an "offload" parameter. With ip xfrm
state, both crypto and packet offload types are supported, while ip xfrm
policy can only be offloaded in packet mode.

The goal is to provide a similar level of granularity for controlling VF
IPsec offload capabilities, which would be consistent with the software
model. This will allow users to decide if they want both types of
offload enabled for a VF, just one of them, or none at all (which is the
default).

>> The above are a hypervisor level control, to set the functionality of
>> devices passed through to guests.
>>
>> This is achieved by extending existing 'port function' object to control
>> capabilities of a function. It enables users to control capability of
>> the device before enumeration.
>>
>> The series introduces two new boolean attributes of port function:
>> ipsec_crypto and ipsec_packet. They can be controlled independently.
>> Each to provide a distinct level of IPsec offload support that may
>> require different system and/or device firmware resources.
> 
> On a quick read I have no idea what the difference between the two
> knobs is :S

At a high level, the difference is that with ipsec_crypto, only XFRM
state can be offloaded, specifically only the crypto operation
(Encrypt/Decrypt) is offloaded. With ipsec_packet, both XFRM state and
policy can be offloaded, furthermore, in addition to crypto operation
offload also IPsec encapsulation is offloaded. For XFRM state, it's
possible to choose between crypto and packet offload types. From HW
perspective different resources may be required for each type of
offload, and this gives more options for HW resource allocation.

