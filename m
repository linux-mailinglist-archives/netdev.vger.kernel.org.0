Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B665E5595DC
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 10:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiFXI4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 04:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiFXI43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 04:56:29 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2574EDE6;
        Fri, 24 Jun 2022 01:56:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZSXOVMHS9iZ7Hd/kcPKNwFViKzBymAhEghvZozl1tn08/TWH5qARpGoLvEGADjjrOv++VWC3yv8jBCr6gg9HN9IYm2Dt9WkHmTrydcuHuIVZi47l4EVeVKq9L7Bw+Oirij9fcBH+hkNi591nFU497QTGSZYkDtgGeW2ecb92ZD0Zo/ftXATpFYvH0rFnDr+108Dy/bRaUaPa0+DHRegdcMXCVyl18v9vxx7TLHAKB1EMQT8nFgR28dUX/EkT1DgtVAuJCJVnH8ulUDBaXbMQnKuRnX9Ifcad4JY1PrRFCabuXGrnyGn3TP/VIHmjwzDooohFhNjyFTWpfRRGjV71Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3261B+mqlLn3k8lcWVF/b2xcR21pLmCfebWsgbBAK9U=;
 b=jdxgCFdgYeOcH14A8bCgJSJL7sCRoExy6rpcOV++cnBrhRTpfOzYuvUiKv4shr9ZqcSEIYtkXjiCPhcYiXP6vI1WH/EmmIy5I4bmFIgE2JZsxRLVQ0CFFwVfdTkQ9AJiiIwpw0cFndKS0bokYbw1wSHtqsDX1A0sfuee3TBaOc221eDuZcpSZwR75hHSajHV37GUW+TuGwGnGky30LPB7fhOoMUPwdC72wxvr6wYwO23WLYjCy/ndP/o7eIcmL5FDdzGMEE1l4mh3qcGaHfAe0FDIxYVGJ7cPkUAMmZPdlTjgdkM1CLAxhFJCnOIKb+ZZsk00USCaXHxFvKG/TWeqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3261B+mqlLn3k8lcWVF/b2xcR21pLmCfebWsgbBAK9U=;
 b=UL+eaXYOqee9r41sRqhZpeTZ3XwJhG6tUPmAX4XguWYOp9SHnjW6AeOE/7WMqR923oaMmqCKFdcIKI3fBadEltNTN3kqE2QvQRohbZRqSi0YtoUcOtNsBApl8QGFGxrGelHC0tf/rzRcA95pVRGnC+D85YtcTET9LQ2u2K0/seM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by SJ0PR03MB5840.namprd03.prod.outlook.com (2603:10b6:a03:2d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 08:56:27 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5353.022; Fri, 24 Jun 2022
 08:56:27 +0000
Subject: Re: [PATCH 2/2] net/cdc_ncm: Add ntb_max_rx,ntb_max_tx cdc_ncm module
 parameters
From:   Lukasz Spintzyk <lukasz.spintzyk@synaptics.com>
To:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     ppd-posix@synaptics.com
References: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
 <20220613080235.15724-3-lukasz.spintzyk@synaptics.com>
 <99a069df-6146-a85c-5fed-acffc4c4d2d3@suse.com>
 <56b92643-62f1-856b-9587-62b3aed4151f@synaptics.com>
Message-ID: <b96cd386-3c5c-80ac-7124-7ea1ed128c5d@synaptics.com>
Date:   Fri, 24 Jun 2022 10:56:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <56b92643-62f1-856b-9587-62b3aed4151f@synaptics.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::14) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9a2d275-257d-4bbe-3659-08da55bf6c27
X-MS-TrafficTypeDiagnostic: SJ0PR03MB5840:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/Zwg+gHmDQ5DpnKLyIgJ/siJwWjTySG6jvB0yLNVvGgofcxAqJ7hTug9uqCCyEyQkMyb7xupaZmkSRE0HT3dkNSC75FCzHhM/ESuC5dKvoH24BUSL0hdD+SbMmIPBWDEEL6Mf2sxmTuAnVz07ynmeN6+CBeiZDrgzt5aZF0Tl3s8crSZ4/KerrBiK1ro8sMrvEbPSX868b1XrZ+tAr7HGs6Ep4nWrxI8FqGcpIjtHXFVbMZFFn1SQheyM3Kr1PfkDj/Uu8yIvBy+zcbkXgLQ/DmO9NMvGpu4QVaKuwEL5vRPxfm9zC+dGaQV1oEhRtaibt3S970+7Z74GkQJXvS+hvpwUHu5UAm+Pz0bx0tULA6y2yGBdINPjlKf+qp3YocU0LUX9JqpECyVhtmjVqHELwH7G7c55sfQSYIX/F5tYnbPALLtbut4WnS/8wvg5FdbYcbCxJwd2pRYAd7UNehZf9kknzfA/+LCyC7P8j+56TmQhHorHeNfHyva8AnQkkJr79DDHHPzGDtDIsKqcuqGhNU3Uq32szULrSDXW1eJ40dVlZBQ8j2HUFIjJr+uV6zmQAObkj/b5/20tVmzt4MXoJmkmCWXlVh2iYQtlk2wpBYUljgoGW1V6is0WnYiXzGJApQt+Z3+tRnb7UhAPAfJffY/C2XDg6G+0UmQMxIdOn3ixc3zPWCJQQOuOFtM31o4QHzkej7ibeuNBSKXIls4VmktgIAjM0d9CF1VXY5SzMMaSZbXvnoPUEGsIt8JBnLxbnEKEC732C0BlC3fcg3tlM1f/byQGQMTUwuiOLUKwIMUvK6YdgFWpmGZtn36aIc8ix6RCJHL8j07LsbjdUH7ctN5U4Szpp8/UuBpsMJ4pE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(376002)(346002)(136003)(44832011)(66946007)(4326008)(66556008)(66476007)(2616005)(8676002)(31696002)(107886003)(86362001)(5660300002)(186003)(8936002)(53546011)(52116002)(6506007)(83380400001)(31686004)(38100700002)(38350700002)(6512007)(6666004)(41300700001)(26005)(36756003)(478600001)(316002)(6486002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGIyeUF1Y0ZwZyswTjZmWENIRnRTZENUeXV3c0Q4bXh0SzdVeVJmbUhzREs0?=
 =?utf-8?B?cGtSRzhDbFpjNk5SVHFOai95UDIyODFEcHU5ck1xSGh0WWFTSTNJQnpQbmsw?=
 =?utf-8?B?R3VjSmxBTGgvbWFkQ1lmVTRlR1RINVdoU2kvdlNHU3ZUd0xxL0Y1Z21veW1y?=
 =?utf-8?B?VGJpck5QN0IwT1VMZHNKNUsrTWZQTXB3WUNLYVVDU3djREY0MXZVWFJueXpX?=
 =?utf-8?B?VjlTekJrSG0vWmxJSGlmUStReE9FZWk1MlpnNkplc1JMeHJmZUZwUWVQa1Fx?=
 =?utf-8?B?UndwK2M5eTNRM2E1MjZvSXlwWjExRGs3U1pnNjNkNEJnaTRQUUpFNzNQN3RO?=
 =?utf-8?B?YUkrZDc4ZkZjTm1kSzVDQnhDbzNkKzJRcHB6eTZadDlwZ2kySFkzRE53ekZr?=
 =?utf-8?B?bFdwZzJLeUQwOG9tMk5UbE5OSXFMNlJEOWx1R0V1cDU3SFgrYVFZRll2NXZu?=
 =?utf-8?B?SFY2VVJNT2JwTnFkb1Q4RG9YNjlvMCtTZ003aWJEM0N4TGx2STFqek4xeGxx?=
 =?utf-8?B?c1A0c0p3VWJSQkxZUlEvNmZvVWJuVVZIWXVzUHpSaGxzcVBlY2Y3NUk4ZXEz?=
 =?utf-8?B?aUFpLzBHdEJpUXhjTWdLckFJUUsvN2dENzRhS0pocVFLRUZMSWpLZlFpbnYv?=
 =?utf-8?B?WWN5VnhUWFFFTWozOGhNMXFpUUpJOFU1dmpDY0VRQkUzSzFuV2lGOEo5Z1Bz?=
 =?utf-8?B?alJkNHI2NFJ2NFpJMmFzTXBhSHhnZmxEb2QrSWtxZTZ0VURqbGU4cXRrUU10?=
 =?utf-8?B?aEVlc3BYdVN3eWwxc3JjZ0RNZUxSNTJqaXBlMlZwdnVUZTJDNkhBaEs5UGEy?=
 =?utf-8?B?NGJySGpYUThmWEp6NlBLanR1L3FpUXBwSzlFQ3p1S2txS2p6N0JFSjZRQm9P?=
 =?utf-8?B?b1NLOVVlSjlvbzJmdGJESklJYktnL0t3T1pxRVdpRTRIWVhnLzlnQTBybUtn?=
 =?utf-8?B?V1dqeUJUQjVyc0RGZFIzN0lzcmhUMVdxYTZ6SUVMOWExY2hZTVJKOXluZDNC?=
 =?utf-8?B?WGdnN0J0c0cyUHJNdVFEZGhwVFJVRHVSNlEzZ01UbU1OSkpJNGJkVFczVm5k?=
 =?utf-8?B?dWxudHRXSzVKcmQzRmIxQUoreFJJRU9xNVh6Y1lNeUNvM2dxcmt6Q3g4clpo?=
 =?utf-8?B?MVRjL2NWdDV6SU5ualRSWTM4Vm5EaWhFcE9vcE1nWlBuWUhxazhTTUFlOHdB?=
 =?utf-8?B?ZnMvWWVaQ3hXdnpWa0RhM1pxY2JucjREUDQzZ3FTVThRdkt0MnhHRVA1S2ZL?=
 =?utf-8?B?MlZmamFRYllJZE04R01SR3VZWmh2V1QzQnl4eFRzbXJpdDBCMmsyRjF0RnpV?=
 =?utf-8?B?NXlMVnI0eEVwUDN0M1VJdVZTNXc0MXFzWTlhbTN5NU1wZ1ZwbElkV1ZwaG16?=
 =?utf-8?B?UjJXUmRacCsxeVprUHJOOGNyeDR2WHEzUUptSEFqdFN6VUxQWUg5Zi9LdXdu?=
 =?utf-8?B?VHU5WmJoTzBPQndrYk5PUjJDbmtuSzFIQ2lBRll1YUhTRXVLZTkwVkxOQnBP?=
 =?utf-8?B?a0JaRGxZbGJQVkx5elpPSERhOWovYlI0aXlXRHJCWUVCTDBCVEZzR0JMb1NK?=
 =?utf-8?B?WGYrZk1wQjJXRzBZTEFtWUhSaUxhV2JiT1k0N0hsdGpKNG0yTTd5d3gzNWEr?=
 =?utf-8?B?K1o3bEJJYlNEeFpWR1JHUTkzdVlwQVZKeUYvZ0orQ21LYlBIbS94cWE3NXpW?=
 =?utf-8?B?VjFTbkgxaXl1dmJsMklIbDhnMlNEejBldFlvZXE0ZzM4ak50OTY5Z2Mya0lq?=
 =?utf-8?B?aDZ5Yi9CT1hCaVZBbGxFNVkyUkRybk1RRThaWW0wS2VpR1ZoaEh0akM0ZzBG?=
 =?utf-8?B?M0Fyb3hHSzhidXFET0VTSDFrclJCQ2FqOWdPRm8wc1owdEd0THE1NlJWRG9v?=
 =?utf-8?B?OVBIaWdFWUF0QkI1QjZtUTNOR0gvOTk3SjZOU2JsTTF5Y28xMFFocktiOHAv?=
 =?utf-8?B?VE9Hdm5NY2p0TWFUTWExT0pkUjRzVkRKQUQ5RnB6cTh4dW5xdmZCS2NPQmhW?=
 =?utf-8?B?MGpzZ1JNM0JXcWN5N3h6UFRNQlpWcTV2UWtLRjRYWC9yLzdOS2ZXNlA5NDI4?=
 =?utf-8?B?OFE3VWxUakcwaTd0WVhQRzZmQUZNZDE3clBneHozcU1CNmtobUxxVnlsblVs?=
 =?utf-8?B?amR6MXd2azVyMXRQSThwWFp1ZGdycGdKQXVadm1RZmxOdlJpT0I5Y3hITmNW?=
 =?utf-8?B?Y3c9PQ==?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a2d275-257d-4bbe-3659-08da55bf6c27
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 08:56:27.0469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5u/kVhk24nESpMEUE2cHVvEzaEuc3sSntDWrTFzn6/O0SpXJgXedlgqraVUkSo5eHNeDPsnnlF+sDsEVkspFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5840
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2022 12:24, Lukasz Spintzyk wrote:
> On 13/06/2022 16:54, Oliver Neukum wrote:
>> CAUTION: Email originated externally, do not click links or open 
>> attachments unless you recognize the sender and know the content is safe.
>>
>>
>> On 13.06.22 10:02, Łukasz Spintzyk wrote:
>>> This change allows to optionally adjust maximum RX and TX NTB size
>>> to better match specific device capabilities, leading to
>>> higher achievable Ethernet bandwidth.
>>>
>> Hi,
>>
>> this is awkward a patch. If some devices need bigger buffers, the
>> driver should grow its buffers for them without administrative
>> intervention.
>>
>>          Regards
>>                  Oliver
>>
> 
> This is true,
> Some of DisplayLink USB ethernet devices require values of TX and RX NTB 
> size higher then 32kb and this is more then defined 
> CDC_NCM_NTB_MAX_SIZE_TX/RX
> I wanted to be careful and not increase limit of NTB size for all 
> devices. But it would also by ok to me if we could increase 
> CDC_NCM_NTB_MAX_SIZE_TX/RX to 64kb.
> 
> Regards
> Lukasz Spintzyk

Hi guys,

Is there anything I could do to proceed with that patchset?

It is improving the experience for users of millions of 
DisplayLink-based docking stations that are in the wild.
That tweaks of NTB TX/RX results in approximately 4-5x available 
bandwidth improvement in extreme cases.

I think this is worth to have it upstream.

regards
Lukasz Spintzyk
