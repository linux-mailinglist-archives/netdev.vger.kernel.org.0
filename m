Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B2551EB57
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 06:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiEHDtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 23:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiEHDtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 23:49:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED758DF29
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 20:45:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=av1QNe+vQSNs2oZ/9RmpeY8qBxiZamtM7zLphx5pzIlD6iYdBhMGtb2r8YU52lqir3VNkOysHyH9KXGZyeWcoTGMY+tpCg5y5mMhunr+3MRZx3tsPTtJHMHd9nfBoju4u2X7V+uRH0/vx6BOmRbJ3JsjzjcbyQjxgCIBP0bdFNndghOG3c4rkegCD0CktMuokf77mTdzqVrC+o4XR7AzeJvFNL8R+hLyvL4wpVAYqz7Ynl+JuCQjEE2yeatJ3fFudRtsXtV5xoUZJoe2kBfEGqLvI4uREwCv2TAcxqfETnvSb7Pr1Aj+TxeStP4FnY4doahsKthLVhY/feKEOvXpQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilE+GtKs7kdTKnFD1zVVBgdJvqV981FkMFDroz1RhdQ=;
 b=C7TfeVnb5S1uDCLpFUn4tSjvNWVPGDv4EIoUKtOpPK6Fjddpvru/wXlTytpIE5uX6XnE0C2PWqAvAig57v1ABlCTqfUy7wG8/akJ2TCwfLMh3huNDLtOpsGcr3udmjIPj59zAO6iAyyblCSBZpE/v3cbjgQvdchTK1M57zWgn5s5Ek/GmbVBlt6TIviKiDSc0lXzUpmrDvSdJ2n4vYrvs8eSBphVXyUuwicZUfLTY9kQRldaKB45RyLlleNV+QWuSk0ycF0u4+t7jpjL5MZMxAquLS2tUOLptZJD3k0/7g+H34qja10HL9QizAfEBkLN3Wgw08vlgMiv2coajhSYxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilE+GtKs7kdTKnFD1zVVBgdJvqV981FkMFDroz1RhdQ=;
 b=lV1gTdBa32SIQ+HQXzX3BkjkO5S+8TtQw0XCOQb98h6JYuuaG+eu/p3x5/xS5P6KCoIasEvMCRJBOUBjKwIU01cwlzwGe3T7/90P2+GYEFNbwSfq2Vs4DfLBvLSKjEFkebwQ6M1tvqN6HlAbZ+/jF9sWex+Y85PvGEtaCcs0jKj6Pn9ElX4B0Ej+b7o8NIfLZ1QxPBuB5+pjndcqw7RPKSaZKLhARmXIcwWjyDOKxnojCpZ/3ih4fchE/shrAQsQUB60rD7oGuu9MB2pVf9u96WHiA6P/rbll2ok15Sw+8R8KPtkzoocFC+FMEJSYQgCTLrW23hddl5s/4J8C+IHwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by BYAPR12MB3624.namprd12.prod.outlook.com (2603:10b6:a03:aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 03:45:49 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%6]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 03:45:49 +0000
Message-ID: <062ff145-1175-5523-bb3e-3b615fc5538d@nvidia.com>
Date:   Sat, 7 May 2022 20:45:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2 net-next 0/3] support for vxlan vni filtering
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        razor@blackwall.org
References: <20220501001205.33782-1-roopa@nvidia.com>
 <9278f614-9994-362c-75ae-5a0fe009ef01@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <9278f614-9994-362c-75ae-5a0fe009ef01@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::17) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d2352a7-2380-4fa5-9365-08da30a53e20
X-MS-TrafficTypeDiagnostic: BYAPR12MB3624:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB36244C1CC5E6C8F022B7C891CBC79@BYAPR12MB3624.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jdnrRjEc2BrVjU2cnRBYExHNH+y8eqQWbEd1z0HjajpXECXRsBZ3RXbTAMKan3F+3R1r75ddV3fQYJJQbE32PlwSY1xb9Fy+APDf/9ONLCj+3efM404FbTvVCrxk722OTnC2+fFawi+J1p2pt3bfI8ugkvB1F5hXQEfW66O8M2EA2dm6m6NtD+2S/UVsJaBhwDkKlIPqJ4ggtMLQHho8FdPKUj4/HhM6ry8jFoW6dh+o6/bfEn3a/BF0xGWLdefL3bcME09UnoBHl0tyQGKUnLxl8i0BKrJfedF1ewiXiHfDdA45U42e2RR0Y6NrITppMlczrYLYQQrdOOZmHs+OpAOlD3pq3U9tzjdBo7Yz3kzKtF/lJaga8gM1V2ar57bQnylLsn+Mv57Q2ju7iiKmOzJf2RMyt+z+HQe6EvV5AptEkIoT6oYdkzWOTNjxRTuCFhusC8XIv7HNWSE9l6J0Sp6bptjWC9G65CmoHB8I5aWrl4l5HWU30BMUTd+VCUXbSxT+YVdZ25B3r9Ax6FwuAzobjxmF9JJXdcOYNr6vbM2pl98WI7pK9MzELiz3pfBAmInaQdsWpL2gwhsmPg04RAZyo5dCiHZRd3qQo9CQHMDyg7tgX2FkxExbFbO8/rVASZSZmaYDEo4bdMAmG810uCvhlJjRGY6kpJg6HgkdQgmprew4AHj+lx54sdeQhH8EERS9+XlCkGjyi6n68pUx901yr0zgnE0EOCn4O0o9DVQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66946007)(66556008)(31686004)(4326008)(8676002)(6506007)(316002)(53546011)(6666004)(83380400001)(36756003)(6916009)(8936002)(86362001)(31696002)(5660300002)(2906002)(6512007)(4744005)(2616005)(508600001)(186003)(38100700002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnRrSWZJajA5MEd0aVNuUHV4S3p1U0Nmb3pXNGxoOVBjVjZYR2xwWXFMcVB4?=
 =?utf-8?B?bnR6eDBDN0YvVUZXTlhhUFZVayswWkduNWl0VVArYTlyZTRhSlVxQkF5Ykhr?=
 =?utf-8?B?ZVRmL2VDV3RNc2dQVHhvcUIzclk5eWdSeTJ2SkdoeUZRa1p0WjhickxiU0tv?=
 =?utf-8?B?cTBkTzRBN2dIZDk5UjRxakR4VnR0QzdkN0JPWWtDTFlWaVlxT09PY2NONVdp?=
 =?utf-8?B?c3dMbnJISUlDV2Z3Sk9ZWTZkVkRaU2hKLzJZRWlwVysrcUQxcHNzbHRCNUp5?=
 =?utf-8?B?dGppVnpXb3R5Yk41TXNOcEhuMDFPenVkQ3hwNmlmdWRYZ0NqWnduT21aNkhk?=
 =?utf-8?B?R3A4c243dVcyNnRnYzFKOVUwVzI5a3dIUDZqa1pxZW5zTGlha0Q0OVBTS2du?=
 =?utf-8?B?Vnc2MzhEZVRCM3JtWHpES0xCUFcvTG1SUmVhK0FxUGlTdEFJbjNsV1FEVDRX?=
 =?utf-8?B?a3FsbmI4VjJGVTN5U3pNUnNBbWlxVjlvemVoWisrYWt2a0RORDV1OHJueEtp?=
 =?utf-8?B?VFpob1VEYUExMGdwenFDTHdSMzFOTGkxaEk4Tnk2VEE5dnVCUW5CUnJPUGFM?=
 =?utf-8?B?Q2pFQlJwN0o4Smg0V1I4WDVQYWpyTUJxZ05ScGNmeXlWc1dWa0t5c0NYZnZY?=
 =?utf-8?B?b0lBK3YrNFplZ2tMbUNCd3o2R1lTYTJuczRMY0pLYUhQanhlcXAybkh3ZFcr?=
 =?utf-8?B?aU82WHFCZlduRm9xNldOSUM0aTVzakVQa1lzYTlYTjN3c2FQcjJvc1dYanZq?=
 =?utf-8?B?b2htNUNBQ2xLSUZOYXRSTzFTSUR4cVBGZzdDRGNLTnNRT2RaWXluWHRRc2hD?=
 =?utf-8?B?czNxWTlNeVNZWTI4aDBhMGNsRDNoQkJiaWJCNjJDZ05iSHgvaFRISGZic2hF?=
 =?utf-8?B?QmFnTjZISlJ1aUtnc3R0ZFpjd04rc2xZRjlBZWNvZHhPelpQc3NHbjBXYmxV?=
 =?utf-8?B?VUIyT0UvOUdaenJjOTliVjZxbGQvQlJ5bzhoK1VPcFIrbWJoTC9yWi9VZnJJ?=
 =?utf-8?B?K0VxT3A4UVdhR05qcDBnV3c4YVJFTUhtT3phOUVsa253U2RGbzExNnBlNmxX?=
 =?utf-8?B?OXdsRGw1bFZNTENJdEs0R2tsRjBmWDlLVk9xSUJsN0MvaGdBTExEdVd4R2Vw?=
 =?utf-8?B?dzR2dDhPUkVoamtDb1NOUnI2TW5Gb2ZDbnllTG94b3M4QS9yTTgyaDJETDU3?=
 =?utf-8?B?MkpJeEVUUnArdDBrVU50ZlZXWnVFV0dLTWs1SUxueWcxVGs5M0lQVWpjNFJj?=
 =?utf-8?B?cnlZK3dzRzVpdklOOFpvbWU2UjR0MmlGV0x1VFhlZngrMVhCYmJWMVNndzlV?=
 =?utf-8?B?TzNXT1dZSXdrQXNwYjZCMmsvWWxhSlFSUDFudlo4YlNwY3lPL1NoVTBNWE9q?=
 =?utf-8?B?c1JHSzVsYUs2ZzU3RlFDWDNEMmpjQzdIeE1zZGs1bHdRaXFOMG83YXhiS2F2?=
 =?utf-8?B?blMrbVdCTjhKZlNFc3E3SVJIcElRYnpRSEFyWDdia2dwSHZmalp3WGNtZkQv?=
 =?utf-8?B?Q3RjTDY5OXEwd2FENngxVThQN29EeXovYWlvTWdIclQ5dEJ0a2xOVDZ2RzIw?=
 =?utf-8?B?RFdWdk43ZkJrZ2JHc3oxQ2dEUWdZb3Z2OHd5eW1DRm1MSmJGaVlDSUhhcjhz?=
 =?utf-8?B?VWxGUkJxNWl1T3BDSWRrT1M5R3kxdDJDdVZrMUFBOGJHQTJoMEtXQkt6NW1v?=
 =?utf-8?B?QzZxcXZTTFoxRGpNblEyaTQydkRWZEtpdVlMNjlQWUhPVmNkb1JJNldRVGFV?=
 =?utf-8?B?bTY1OEdrV2dnS0IwSElzdVR1UDhPN2ExVjdUREs4dVBGWTNmZ0FoQ2FZdy9V?=
 =?utf-8?B?Vk42YmR4MDhSSzY2SFlvdzVQMEFGTCtoZlljTFhYbkRzcTFYZ1BhaVJNNXg2?=
 =?utf-8?B?QVlJMk5zNkhFNkQxMHhxNk84Nm9FSlhtSVNLYWNMT0xVcWdtVWxaejRxRnl4?=
 =?utf-8?B?cmRJdTUxSXBsV3FRNzF1bGR5YUttdENNMEd3MG16eW1jTjNCSFNmbVA1ZFRU?=
 =?utf-8?B?TGFSK1B1ckhjSi9CY3VFMFlPd1pVM2VqK29rSXJDMGlGZzBpa1pOMEw3UnZO?=
 =?utf-8?B?ai9iNVNQaGM3RzdmZnFwaG5JOXd1d2s4ZDh5V1dVYSt2eHRyaXlvNUZseFJO?=
 =?utf-8?B?NDVBckFJa05lZzFBaXhXdGg2VUx4b3duZkd1OGNqenN1OWVQRmtGNTQyc3ZK?=
 =?utf-8?B?ZWVLMFFScHA0bWx2b2VMa1pnTFY3M3VNVk12Ylk5MkJhRVZvU0ZNREtiRjA2?=
 =?utf-8?B?VDlsSk9jZFZBZGtWQlhpWHRjcW8wQ241eDdXU2tSRkFvazNkc2Nvekl5dXpX?=
 =?utf-8?B?ajltdEVxKzI0azBvaE54WGVvazJIZXEwOCsxcm5WR0R4Q1hjd2NLd0RPUlJG?=
 =?utf-8?Q?hhAWvYLO1X329K+Y98bnVufzbPmzamuWtuUKUOeerc6Hc?=
X-MS-Exchange-AntiSpam-MessageData-1: m+OIFQQEnzjYMA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2352a7-2380-4fa5-9365-08da30a53e20
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 03:45:49.7811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fx07F591rtpVoiIAZZplCS45XMZhJW6LquFHRgddIsIBF3hXdzXgCkIYfMTasl/VOvj3YS4f+a5nxi5yFNB0kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3624
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/5/22 20:26, David Ahern wrote:
> On 4/30/22 5:12 PM, Roopa Prabhu wrote:
>> This series adds bridge command to manage
>> recently added vnifilter on a collect metadata
>> vxlan (external) device. Also includes per vni stats
>> support.
>>
>> examples:
>> $bridge vni add dev vxlan0 vni 400
>>
>> $bridge vni add dev vxlan0 vni 200 group 239.1.1.101
>>
>> $bridge vni del dev vxlan0 vni 400
>>
>> $bridge vni show
>>
>> $bridge -s vni show
>>
>>
> hey Roopa: sorry for the delay; traveling. The patches have a number of
> new uses of matches(). We are not taking any more of those; please
> convert to strcmp. The rest looks fine to me.
>
will do, thanks David
