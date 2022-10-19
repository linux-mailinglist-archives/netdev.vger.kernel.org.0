Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44993604AD6
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiJSPMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiJSPLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:11:33 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60056.outbound.protection.outlook.com [40.107.6.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EAE1DDF5;
        Wed, 19 Oct 2022 08:04:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlXEL0RF4ZKkwerBMEHoQsjvCArJj2MVHRZ/DJbVvNBr8KwWD5UcHAv2uvpdYE72FD8AMhhy9L3MItHQ17cIz3tmusJ+vVDOmulzp9SX5sOl9TpjHcINBPiV3Ab3/9tXZ4LJ4bBWpno8iR8uY5oU0UsnzoEs+HNfkL+JPl9hy0me9AFmBVl9JCJ+TPHxIHUxelsfS8NcoB2JB5tugK1B5A9QsJbTTHcT5piJQ/AeayNg8EBQAcRWyxMXWIqGZraakoJJa+rXPTOLVHQKyyiTE2LdvuRC3l31WF1/F3PWh7uZbw31MDrISMhweSPkd6aXZkLr42QzUAl2woN66a1URA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKSPhljhweYK5iXJ2U+dGRcWtzAMKM4TwJQHR+J/NnE=;
 b=NodFlg1EW6mBu3axFkWe27SGgiavCpmXGFofjIsKrQJ2wrih5sjGvQnPkJtcWv2RbrXoh64aTcmJxxjmEEoAWMJMZK1HQzTYwUZKIRzpUt5Gl37vhM2RR3BC89NecjOF+OCgfZ4gw3gSO7sZSiSBsNuaXGySZCnzP7H5CFth333Ex1X0+CLJ7bYjdfqp1A0NNU642rwzH6mai7WfRkl81cGkgRp994soLmtnkBj7cZkRUKAB1FQSgHPNWLbtAyI4qKSvpZrOIiEkhLGSMW5rZ6X9i2khp90s5gVSGwuSSvPrJNWTmzPQRiY+ING9W5CzP4e5zFrg8Kmu+3TmtNgXCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKSPhljhweYK5iXJ2U+dGRcWtzAMKM4TwJQHR+J/NnE=;
 b=MgmID/LErbrC3D7GI3zMWqeVNN9DyPmuAtACPpsYoipX5GoxNvY5EyTinaI+TXsbeOf38Q1PX93MaC5jqwiSwJlugIoftB3KR0U99T1HwRcq/U6ttnn7l91IMgO1yAR/m0psDoOCo8FpqIG5Y09ruJDNFMAl1J4YYwNnX42mh+vK+6g3QF280/XDm71YQ5K2BF+Cb/fnIZGEMK82UMIMWSqyJWPS8DjQ1TjnYIkTlQrh7oIpQL8NiPoBYe08+dS8T+xkZZ4tFfgQz2u8x2x+Bvf43AssCM29+CNRte/JOK2pM+8bJ+BNuYU4fiWzgI/s8Qs7WBAW64Ogt3OMpZUR7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAVPR03MB9800.eurprd03.prod.outlook.com (2603:10a6:102:31b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 15:04:39 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.034; Wed, 19 Oct 2022
 15:04:39 +0000
Message-ID: <2d5ddd26-1054-5a23-4fcb-4df7edbbbe75@seco.com>
Date:   Wed, 19 Oct 2022 11:04:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: fman: Use physical address for userspace
 interfaces
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Andrew Davis <afd@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
 <Y07guYuGySM6F/us@lunn.ch> <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
 <97aae18e-a96c-a81b-74b7-03e32131a58f@ti.com> <Y08dECNbfMc3VUcG@lunn.ch>
 <595b7903-610f-b76a-5230-f2d8ad5400b4@seco.com>
 <AM0PR04MB39729CFDBB20C133C269275AEC2B9@AM0PR04MB3972.eurprd04.prod.outlook.com>
 <CAMuHMdUZKQFWV8QAKmwxuhWz0ZbFmcsUuf4OUzS_C31maP5+Yg@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <CAMuHMdUZKQFWV8QAKmwxuhWz0ZbFmcsUuf4OUzS_C31maP5+Yg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR17CA0023.namprd17.prod.outlook.com
 (2603:10b6:208:15e::36) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAVPR03MB9800:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ef819f-ee16-4ebc-289d-08dab1e33e71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a0O1vJVL2Z/TNRjI/8ScywLgXNHG7vAytzIthUTwWS77hpPgwx1WqiF7wo3fPr/KZQp13DBweEgZpRCRpGZpUb9YgH1nW3wGak5A7YbD+cgAEA+NsGere2DG9PA9vdsI1Oy57zeIpQqWw99ZFmYGVtU0HzZUYGWolWneE2o5LTpLvBumAwFuSzfbWkNen1koUpgssSfBk6WOXO26l3LklFW1DASJyforNGDuMuFSfoqRBPDnk1YYKkFvMO3RJAB43mqlJWeCyVIhATsYNhn6uje2xkuY3YZ5A2wMgXTrCxsPTgcNaDjd7h1V0+dKLvNqGE05MmozvUaGKXl+l/CdHoFihyPbTn7xFTlKIZFSdCLq0rAc7tF+Q56jj8clB0J4twXRXMtaeIp/GnufcJhq5KZrQogOVpQWdMCD7Chyxhjv99iOVOjW+wfEDpqDMXGF8AIMjDLfiOL2XOZWfKGC+gIWuoqQWzWttm4JdpqMyf0jmyY3AzFaFQBktv1HA/NavCL/29qx5pxhxV+TZf/gSzif2VseD0FNBxw0timHlJyWEbGAjRz9vgevGZIfvJqjEBd7z3zF1oZz9oJv3BiYzRK+qYAoDxrgrfykBr3hwZqzvOK+YIEmPgnD72WRrxR8vvsE3wqGlc6bjmK/2ta259Sa9BKCPyiYSm03koN41Wj/BVMLmr4jRyBFWc0lTxQnHrM15voNBKPJwHHn+zDI74WbPTLd6rF7Tolm4DpHeU9MYZ+Gpgkx918+eINbUgBlR6zFWC7QnWglsM4NbcEnGXhmpvC8/93JC1GNP/jOBUUk2Ey+0MISsspY5suFfNRlwA3gw/fla4CtZRJu1OC4Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(39850400004)(366004)(451199015)(86362001)(36756003)(31696002)(2906002)(41300700001)(8936002)(44832011)(5660300002)(7416002)(316002)(6486002)(54906003)(110136005)(8676002)(4326008)(478600001)(66946007)(66476007)(66556008)(6666004)(38100700002)(38350700002)(2616005)(6512007)(52116002)(53546011)(26005)(83380400001)(6506007)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZC9qR1BzZ2k1Rkkzd2syYjc0ekpqMXdBZEI0RHVOVEJYSWhzamNxTTJITDZK?=
 =?utf-8?B?NWtmcGQ0TFRmQ3RqRHlkMnRiRmozRGM1WVFDbkQra05GcVc0SmpDeldpTDQ3?=
 =?utf-8?B?SU1wSXRWTVdxV2MrY0VBcUlmLzM5UEEyOHh2ZW9nTjR2c2pHcy9hVmJhcUlo?=
 =?utf-8?B?aWhnT0J3eG9mcjdCbDZrdjVHUUE4WU9VdkdtU25VdUJUblVBWllKdVozelVv?=
 =?utf-8?B?MDF4VWhidDg0ajlVWS9qNWhSTCtUUTQ0UlNnd3M2anY1Q3lJYkhvajhpT3Rq?=
 =?utf-8?B?eEJoNVo5dWprVmRBYi9MYU0valA0V3cyNXRBdk4wWFlzYVZqMi9lbVVhKzE5?=
 =?utf-8?B?N21KWTVpZVcxakRYOVBGRHVPQ2t6akx6WS9jN0xjQms3VWF5ajVXajQrOTd1?=
 =?utf-8?B?U0s1M2l5aHl0ckp5ekV5bmdDSW1zLzhaeEsvcDF6ZWRNa2x3Y3MweVovOWJN?=
 =?utf-8?B?V1F1RFE1RWpkZWJzMVVOSnUvZmNlSkduUld2LzgzM1pHOEVtY0Z3QnNGcStP?=
 =?utf-8?B?Q1JBRWdWNEFiQk9Eb0R3dVJhZ3lWWFNjUVVoby9oSjk2WlVRRlRBVDR1Um5r?=
 =?utf-8?B?ZUxjRm1kSHN6QzdBMTBBeW0wVE8xMStPVDF6L1ErY0hhYzZ3NmhnTHlnUGI1?=
 =?utf-8?B?eDcwNk0zcmNxYmJVdi9jSzBhRmRvQlhtM2kyaFlkMCtHMFNzbzZVVUJaR3ZX?=
 =?utf-8?B?SG1zR1dKV3N2OXBoUkwxVG56K0hIU2lhaFJRL0JmcjdCcktkUGJZbGFGdFBQ?=
 =?utf-8?B?Y0Y3SDNrMUdsakxMZks1WENIeVFkR0lwMWRhR3N1dUl2dVByRkNYdHVIYWxO?=
 =?utf-8?B?UDhvUkFFSmlWSDJvcjR5RGhxMFYyVHlnQWRaalRKdWpSUy9VMFV4b2FIVlNu?=
 =?utf-8?B?YWNwWC9XUDZYU0dsNVpML1JlZEE1LzVIY3ZFUGpDUlY1UndWVEpxekY1ZWVU?=
 =?utf-8?B?V2NEVG16dkxKaDFJOFJKV20rL0V3dXMvdlc5Q0EwT2FpdU1pcVUyNFBxZnJT?=
 =?utf-8?B?NThWc2pHQkZGQ3J0WDQ3enZJV2xwT1RQSTBuWUh0K2k5NlFQNGovSXFNcURi?=
 =?utf-8?B?M29LUTBkS0hldlZieno2ZTJ4SU81Y05xVEZZWDNEVHBWSGFnNm5NNVJZR2Y4?=
 =?utf-8?B?VmpUUXprVFpzL09nUklYR1BmRStmbzJUbjFUTndJVHVjcDJQV1F4U0RMM2gy?=
 =?utf-8?B?NnpaUnNncnNiY200cGVSRG9rWWNpT2tMenRxUElEc0JURS9CRm5YSzNmVW9T?=
 =?utf-8?B?QVc4TkJjWFR6cXp3N09ac0p5em1qSFRBWEwvV2pjcUtNcjJ1TFRyQzZMbkZp?=
 =?utf-8?B?WFE1ZGwxRUhrbkx3YkpwTjdrK0tyVVM5WW9OcEFENDcwUVlncXhUVUdNUWtB?=
 =?utf-8?B?ZXRqQ3NxUW1uYUloUTRGdzdWZWRLR3Y4SU50R0FHOXIrOHYvU0w0anoyUzYr?=
 =?utf-8?B?OG9Nc0gwM1R0TjJMV0lGSGFtQ3NUeTlPSFNvVkxiRHZaRW1OTXI2c1Zya1Nk?=
 =?utf-8?B?TndhdmNPVG9kWnJvdHdEZWxKSmI4d1RabktxYUlET0J6S0tmV2JoUk8zdzlT?=
 =?utf-8?B?RittRUtDWGdyVUdETmVVR2crSkpTWWJOV1NDdEZWaDNGenVhQWoybWdpbmxM?=
 =?utf-8?B?akM2WlhqaXZFL2V5dFAxMDNLQlNPSkNlMzd5VGJ3SG1Sa0NWUU5MSDFmWW5i?=
 =?utf-8?B?OGlOK3ROQkZOYkFRdmVrZ1VLNHlWeVB4WWgwKzd4SnZYeWpZS3YrUjNqWUl3?=
 =?utf-8?B?L3Ayejdic0RHejJhSUg5YmxVOGRIV1l0WEthRExuTWt5RS9RNGJwWjJJaFZK?=
 =?utf-8?B?eFFJNmJ3SHhVblhqL3NvWXlFbjc3Q3JXMlphWFI2Q2E1TkhGUy9hQ0lNeEk1?=
 =?utf-8?B?M3JRTVRDdzNtUDlIQWJVRHpuRmtTZy92ZWF5K3JUMFZ6S3ZpTVBPWE8xZ2dN?=
 =?utf-8?B?VTNMdFhiK0gwMlhCZFZHanJVSVFiemI1SlB0TGtrdFBJTlRZTTErekdZZktN?=
 =?utf-8?B?M0NYZ2lqYWxRYzFucmQ2Q1BVS1NNWlViZklCMWc4eE95Vjd6STdFTTl3bURE?=
 =?utf-8?B?VDBtSnQ3U3U3aFZtUzdFaG9EbjY3eng1L0dlOXNYWE9pa3VKK2JxUGY3bmJZ?=
 =?utf-8?B?eE5pZTQrc0oxdHFXNGFRQlFOVzhuQU5JaXc1WjY4dUZnSllTSkxZVTVyMVBj?=
 =?utf-8?B?Nmc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ef819f-ee16-4ebc-289d-08dab1e33e71
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 15:04:39.1517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDBadyP4f77lpGuWSXsJ5zxmh9qYths8XmZcBX4NAecYPdJhaHDnsTvQXIq0gcecdEe0B5xSpOmnOsrSCXQNZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9800
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/22 02:46, Geert Uytterhoeven wrote:
> Hi Madalin,
> 
> On Wed, Oct 19, 2022 at 7:20 AM Madalin Bucur <madalin.bucur@nxp.com> wrote:
>>> -----Original Message-----
>>> From: Sean Anderson <sean.anderson@seco.com>
>>> Sent: 19 October 2022 00:47
>>> To: Andrew Lunn <andrew@lunn.ch>; Andrew Davis <afd@ti.com>
>>> Cc: David S . Miller <davem@davemloft.net>; netdev@vger.kernel.org;
>>> linux-kernel@vger.kernel.org; Madalin Bucur <madalin.bucur@nxp.com>;
>>> Jakub Kicinski <kuba@kernel.org>; Eric Dumazet <edumazet@google.com>;
>>> Paolo Abeni <pabeni@redhat.com>; Camelia Alexandra Groza
>>> <camelia.groza@nxp.com>; Geert Uytterhoeven <geert@linux-m68k.org>
>>> Subject: Re: [PATCH net] net: fman: Use physical address for userspace
>>> interfaces
>>>
>>>
>>>
>>> On 10/18/22 5:39 PM, Andrew Lunn wrote:
>>>> On Tue, Oct 18, 2022 at 01:33:55PM -0500, Andrew Davis wrote:
>>>>> On 10/18/22 12:37 PM, Sean Anderson wrote:
>>>>>> Hi Andrew,
>>>>>>
>>>>>> On 10/18/22 1:22 PM, Andrew Lunn wrote:
>>>>>>> On Mon, Oct 17, 2022 at 12:28:06PM -0400, Sean Anderson wrote:
>>>>>>>> For whatever reason, the address of the MAC is exposed to
>>> userspace in
>>>>>>>> several places. We need to use the physical address for this
>>> purpose to
>>>>>>>> avoid leaking information about the kernel's memory layout, and
>>> to keep
>>>>>>>> backwards compatibility.
>>>>>>>
>>>>>>> How does this keep backwards compatibility? Whatever is in user
>>> space
>>>>>>> using this virtual address expects a virtual address. If it now
>>> gets a
>>>>>>> physical address it will probably do the wrong thing. Unless there
>>> is
>>>>>>> a one to one mapping, and you are exposing virtual addresses
>>> anyway.
>>>>>>>
>>>>>>> If you are going to break backwards compatibility Maybe it would
>>> be
>>>>>>> better to return 0xdeadbeef? Or 0?
>>>>>>>
>>>>>>>          Andrew
>>>>>>>
>>>>>>
>>>>>> The fixed commit was added in v6.1-rc1 and switched from physical to
>>>>>> virtual. So this is effectively a partial revert to the previous
>>>>>> behavior (but keeping the other changes). See [1] for discussion.
>>>>
>>>> Please don't assume a reviewer has seen the previous
>>>> discussion. Include the background in the commit message to help such
>>>> reviewers.
> 
>>>>> I see it asked in that thread, but not answered. Why are you exposing
>>>>> "physical" addresses to userspace? There should be no reason for that.
>>>>
>>>> I don't see anything about needing physical or virtual address in the
>>>> discussion, or i've missed it.
>>>
>>> Well, Madalin originally added this, so perhaps she has some insight.
>>>
>>> I have no idea why we set the IFMAP stuff, since that seems like it's for
>>> PCMCIA. Not sure about sysfs either.
>>>
>>>> If nobody knows why it is needed, either use an obfusticated value, or
>>>> remove it all together. If somebody/something does need it, they will
>>>> report the regression.
>>>
>>> I'd rather apply this (or v2 of this) and then remove the "feature" in
>>> follow-up.
>>>
>>> --Sean
>>
>>
>> root@localhost:~# grep 1ae /etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules
>> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae0000", NAME="fm1-mac1"
>> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae2000", NAME="fm1-mac2"
>> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae4000", NAME="fm1-mac3"
>> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae6000", NAME="fm1-mac4"
>> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae8000", NAME="fm1-mac5"
>> SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1aea000", NAME="fm1-mac6"
> 
> So you rely on the physical address.
> It's a pity this uses a custom sysfs file.
> Can't you obtain this information some other way?
> Anyway, as this is in use, it became part of the ABI.

In my udev rules I use ID_PATH. Since this is a devicetree platform, the path name includes
the device address by convention.

--Sean

>> root@localhost:~# grep 1ae  /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@*/net/fm1-mac*/device_addr
>> /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@2/net/fm1-mac3/device_addr:1ae4000
>> /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@3/net/fm1-mac4/device_addr:1ae6000
>> /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@4/net/fm1-mac5/device_addr:1ae8000
>> /sys/devices/platform/soc/soc:fsl,dpaa/soc:fsl,dpaa:ethernet@5/net/fm1-mac6/device_addr:1aea000
> 
> 
> Gr{oetje,eeting}s,
> 
>                          Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds

