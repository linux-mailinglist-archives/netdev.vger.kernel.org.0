Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87F963B6DA
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbiK2BIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbiK2BIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:08:37 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464CB23EBD
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 17:08:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLa691VCPOrT4H1U+mzpm9VCuNgxsNKCH12JersJ7rWTUolPcPTYLKICdEMpPg/puw5tCKh7y6njYhax6WslgR/EtrswKtVlvPuB9O9s9/0t1lzgB9Gf4E9IjbPYKgZcMJyvq536S8FfXGwJN8ElFp337Oi+liaKazvwGLGEu2PMkuhWDuwicn65zfHZdqyFFmVuyHCSEqDat7QAw3/Z1ZBWpeBFf9VMt10TRAvISanak31WRqdP6qtRqpaTx1VmUbkev+OmsrDVjsvQP4sxXuHFCCLXGvKbzUhci3Mioi4yV2wCzVb76oqVpzSwYG5oU1Gg6U/UatgRVB/4rOtJsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahMA2YUDPVc8v+JczyV1HLGAbd0tVu7v8UAk3RfEOOQ=;
 b=A4fVpLRs6VU7rN3ObTxurrtAgtwN7SWL+GwdzSZYO1A3Va6t5NjIaiI9lh/cZNQICaZgYKz96V7KH3Ib3bS4WRogjvD5Oz+fjZvc5nPOQB8G45OrZrD0DCREfZTdo6AfK8WYhEsxBOsvzY2W9er8pXDElBDD62hRItmcvd4+z2i5DcqF3FiejUZMusTMOjYLKg6RNM+hCwfaVUIuo4+Qxurn7EcjTEhLrsUacpRVUBMx3susZadS6dRc1qNHbXvZTzYYEWOVTbkfvboinDZP5VnRihQp6ANFnMkMJe0IUVeJUPp4+LtYqirW4m9e3nk0QzIZSR24ndHqck41FrB0sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahMA2YUDPVc8v+JczyV1HLGAbd0tVu7v8UAk3RfEOOQ=;
 b=2XVlb6z/pMg5xkucrUGXD9aXvb0D0+DfhGi/uw9iNaOLdVT2qWOEm26fhY2D8q38bq7a3oHvwnjKwGClWd0Pop910EkdPkTwSwH1u7NnGzoYQ2dHlSg0aKLJq+5O74oYELDazA20GAVOdnT5k+Y80waCml0n7CDqcObqyMCfr3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MW4PR12MB7288.namprd12.prod.outlook.com (2603:10b6:303:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 01:08:31 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 01:08:30 +0000
Message-ID: <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
Date:   Mon, 28 Nov 2022 17:08:28 -0800
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
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221128165522.62dcd7be@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::25) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MW4PR12MB7288:EE_
X-MS-Office365-Filtering-Correlation-Id: de3efcae-a764-4fb5-b912-08dad1a63ab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: InyhxFyiYT+PqISCL2r5jTvRw0bF+Wsbb5zHtgQeRsBklP7KGD+Hd/gcH6Ij0bQlN52abatNW+4cpbfeBWMsBNf8U2iU5BXGew5XsXHz/LesjZY9BFDaW1LcUoBCN3GJRDcHb34J4IH0gEHaF5RK3u3zGoXHKp/0AfxyT8N/QXcOQtPS9e63EwzDB9HOIgwTqgNhCAUhHEvGLca94uBDIb7OJBAymATuNQmh040tfumUGDSEfc2oh11xi2Ln/KWEyJZFq43AYv4k6geN/ixZwSb0gOQUiRW46u7T/xcqylQ/gSgRANwwnCRmr8U1BrA1rtNAOefBD3qoSA8IsF7iWwlCVYfPb71VP4GxY1RAqZ6Y88b5aervOI+2XeKlhAVdeQ8F+NOpsQGCXODFTYwcFipiKI9AwPVOySJjmoivLs4ZNxrH3g0gx4zEY2LtBrAxKLjGY+OuFzQxIPRq6qzRl46KkImwXeNywFzG3UpqwRVuMoel2X6jVniM+729P/oALKBEwywaQAFCk7J4ZO2H4qvyKqcTiXZ5dbY6SuPnMlgWf2u4Ve2Omz26ZdpDvvsFYqPnZxQoHAlnuBvqV+jxWu3aSChCcJuIgVUj6TtboHWduh+JcswAPSywNIvbz4guhvIZz/+58iHgBdRPQP7ARkYY7t+FSBDwAnp1DzCvLa+vFsQ4GMUiiYnuDxCUPDaJF590+qhy9SfaW3ZB0AkFI+Z8qH6N4Gs6y9xMROX2prsiRIGNXouMeFjDzzJNQfHu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199015)(36756003)(26005)(6486002)(478600001)(316002)(6916009)(31696002)(6512007)(53546011)(2906002)(2616005)(6506007)(31686004)(83380400001)(5660300002)(66574015)(8936002)(186003)(38100700002)(66946007)(41300700001)(4326008)(8676002)(66556008)(66476007)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVMzNUxvWWdLZ3c4KzliUXFYMHR5UmQ2dVkyY1Fza1N6dkJvMkhSTzlSWXdz?=
 =?utf-8?B?YmRSdnR2YWZKQ05vRHh1SWRXQ1NQS1cxYmZ3Q3IzVGRlcVliWk5zV0JLTDB6?=
 =?utf-8?B?c2Zyak9xc3lieElUMGh4N2d5Y2tVUC8wYnNBK25rMjFtdUFXeXhyaGNoNkk2?=
 =?utf-8?B?cW1SMnZNallvVGZ4L0Zzc1VUN0lmbjVBbGFaUlJwaWlFQ01SL3crYkJTVGVp?=
 =?utf-8?B?TWEvZ2N1MEVVbm5mdU00UVF0WFMwVFNNalVlSEU2VDZ4eElMdUx0NVV6Yi9M?=
 =?utf-8?B?RElyY3hSUmFxN1o1VitBSUE0bmgranRVQ0J3bXdDbXFrTUtGeisxdk1TSEN6?=
 =?utf-8?B?OHZkNDJyMmI4ZlBBZ21FZzlBYUQ5cGJJQzhyd0ZKTU1DbFpvaTJMdVJ1VENv?=
 =?utf-8?B?dlVYSURFYytUYStsMWZxR3QwdDYza0huZHFBekpFNTlFb0czYnlnT1ZrdG9N?=
 =?utf-8?B?OEY5QnRNMlRrdFQvekNSUDNJZWI0cnNQSnN0eG5EYXhyTjRRU1RmVm9RZXk3?=
 =?utf-8?B?dlVoYnZWK20xSWJYYUN4KzltY2tJV01CSUZteWZMektoZEM0M2NCU0t0eVQz?=
 =?utf-8?B?UHhkR3lPNXFUeU9OMUFnbnJLUDg0L3d3NUl6ZmVRY0RGM0szUzlzTFdOSFZU?=
 =?utf-8?B?Zy9KU3psUkVrOHNFNzFHRTFPalg1bWExTzBzS3VSUCtJalpRQ3E0Kzgxbno3?=
 =?utf-8?B?VFlKZ0RDaHQ1eEQ3UHl5M085djM4VGpyeUM4aDlPbGxweG5CZko3WndPcFUy?=
 =?utf-8?B?Z045Y1hWUVJuYVI5QjVwZ0tJMC9IMzZsV1NsaVFIcTI5K1c1aTlWL3hLeS9Y?=
 =?utf-8?B?UGw2UlZEUURYZWVtQ21aN0xReWhMb2plcTRLcndyM3FoTjV0a0FLTWp2SCtB?=
 =?utf-8?B?OFRzWmxweTRETnhSYjB5aVZXOHZTbSt5dUd1VERkV3U4NW1Vb2pIVjhQTFMy?=
 =?utf-8?B?WitIdEN5TWxVTUpKcjJ0d013dDY3ZFFMYThQVXJvYW5oUlF5R2kwQ25ZdVdn?=
 =?utf-8?B?WUQxV09oT0xDRDZzT1dMdTVwaHhidlQxdDl5SmZ6emd2Qy9oZCtxb01XdDMw?=
 =?utf-8?B?eXc0SEVZdXNTRzlxYW1zdVhxcnNaNVZiUHp3TjhSQ2RoYWFOYzhTSTdqS2R0?=
 =?utf-8?B?S2pKZVpCQkd6SGRPV0tTOGN6S2ZacS9YUHVDTExSQm05dWpaL21WWWVPa0xQ?=
 =?utf-8?B?MWVvdHRqZTdCRnpMbGVrdm53ME1Ta0k5N1dVRXhCa1YrektUZmZlRnFmcnlt?=
 =?utf-8?B?dmM5L2t1LzVzeE5JRDJYQ1FpempOL0Qxb2RiNy9mVGoyZXNGd1Vxelp2WGJK?=
 =?utf-8?B?SmJPeEJITnEwbEZ3V3NzM0JzNk1keVdTVU9abFdFZUNYLzZCZ1JSM3liSjBY?=
 =?utf-8?B?NGxJbHlvRG5pSkIzZFR6TEg5RlZZWVhOa2ppb3VrTXZScnh6SXNZb3hKbkN2?=
 =?utf-8?B?NGg5bDhJODdFMWV3S3BSUlpOMm1mR21hMjFVL1hKalR4Ukx5SnZYNm8vSlNN?=
 =?utf-8?B?STNmOFFDRks2ZzU4RzFLVUFqNjJha01jYmpzNUJKeWJkZzlVbXhnQTNwSTNV?=
 =?utf-8?B?NHhMeVRtYy8xeEoySzZUSjlIRm9mcGR2YktyRXMrb08rYWFISnlwRVArZW1R?=
 =?utf-8?B?TzQrWFBVSU5LbExPVXk4MDJMaERQazlzUzlMN1h6M29USU1zTi96OThRMHkv?=
 =?utf-8?B?Ty9iNGlYNEVPWmJ4SldVNXBPa1VzbWRRSUVQTEIxUzZ2N3ZqRi9DK2JlbDFJ?=
 =?utf-8?B?Y0JEMkVyUTNTV3dxZ3RaZTF0UEEyNHhRUGZLNXZtZGdWY2I4eWJpWldzNVk2?=
 =?utf-8?B?akx2aExTMWRxTlJBV2MzU0t5QW9nVzJtSzl2eTdYb3RpQ1Bvc0RqTzZhUzNX?=
 =?utf-8?B?TDMvamdrM2FJQlc0WGJjSkwrbnlkaEhDUFRIU1VyS2FKU3BLYVRQb1kvZTFQ?=
 =?utf-8?B?cXVqZEtXZHVobXNTSnJGM01JTEtEVm40bnFqUzBWYkR1Ni9pcW5la2tSeVgw?=
 =?utf-8?B?T0VPWm1sV2NsV2tkZC9RYm51L1lyZFg0RC9ERDkzcldkdVN1bmVlanhyWUl6?=
 =?utf-8?B?OWFHZElweS9PdW55d2NSc2V1OFUvci90KzZxS3BoUkVRTlROZzBiNlp1TFBC?=
 =?utf-8?Q?byIG1O0qiZgBdG4Sb5/FkwyH9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3efcae-a764-4fb5-b912-08dad1a63ab8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 01:08:30.8025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgFKXLP6eyTPbdOdZL5glmwRFbilAoHCjEj+s83mssaQiMEGEvLSUWeNCaLXfFAKZeRYlPtQkbvo9LljVMHVBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7288
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 4:55 PM, Jakub Kicinski wrote:
> On Mon, 28 Nov 2022 16:37:45 -0800 Shannon Nelson wrote:
>>> If this is a "SmartNIC" there should be alternative solution based on
>>> representors for each of those callbacks, and the device should support
>>> forwarding using proper netdev constructs like bridge, routing, or tc.
>>>
>>> This has been our high level guidance for a few years now. It's quite
>>> hard to move the ball forward since all major vendors have a single
>>> driver for multiple generations of HW :(
>>
>> Absolutely, if the device presented to the host is a SmartNIC and has
>> these bridge and router capabilities, by all means it should use the
>> newer APIs, but that's not the case here.
>>
>> In this case we are making devices available to baremetal platforms in a
>> cloud vendor setting where the majority of the network configuration is
>> controlled outside of the host machine's purview.  There is no bridging,
>> routing, or filtering control available to the baremetal client other
>> than the basic VF configurations.
> 
> Don't even start with the "our device is simple and only needs
> the legacy API" line of arguing :/

I'm not sure what else to say here - yes, we have a fancy and complex 
piece of hardware plugged into the PCI slot, but the device that shows 
up on the PCI bus is a very constrained model that doesn't know anything 
about switchdev kinds of things.

> 
>> The device model presented to the host is a simple PF with VFs, not a
>> SmartNIC, thus the pds_core driver sets up a simple PF netdev
>> "representor" for using the existing VF control API: easy to use,
>> everyone knows how to use it, keeps code simple.
>>
>> I suppose we could have the PF create a representor netdev for each
>> individual VF to set mac address and read stats, but that seems
> 
> Oh, so the "representor" you mention in the cover letter is for the PF?

Yes, a PF representor simply so we can get access to the .ndo_set_vf_xxx 
interfaces.  There is no network traffic running through the PF.

sln
