Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523D95814B3
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbiGZN7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 09:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbiGZN7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 09:59:54 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2097.outbound.protection.outlook.com [40.107.22.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0031C25290
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:59:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpyi5ibYVNVyBC29yI25hZIuIgHxHtiurr48q5ch339s8Qfs0HuqwevmcmaMNcTu0Dn+ANuvrzLZPh7FgsUcYh1kmQJrHkQ5Ix3WSa33Fv3cnTQHlKqxht+RKdiIA2jzdaDhNc09iDrIzUXNFjKEYAypdZRxch4+X4O9qtWhSCIVCzb60L9akyBpwGOu8zfOVgeE/YDbSqc31LiV+4tBo9bxhD9z4/r82AIvTdMcL3Z6bP+D1tlXxqk6MxuKDVXohyYLMZz+kjK68K4dBmGfoKFxOG7O+NlWxdlwHJjLxlSJARrhlRJlrLR9hc7LNGrRRbND5YOb1AzT6+p4ANyYNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lB4VFHLODOhYYHkrZhdVfR2lS17ryS5oe2aBn7nq7Oo=;
 b=SVPc++ggth6lc+eaQ0//5v7utRCKAOUtFdLT3K1fTbpo9/fOSHzYNnWPHUvE7O+jDIG79IKpBCjYkbf+Xj1b7EiHtI1wc5gnKZcNUlS8laiP2qbSB7QuE23j+iSWHwOI4ZJgeJ4riHWZU3Ys1CIq98EgS2kKyemQXJZ9aFhXJzaPLn+BrYRec8qrcuaYpxy0mFPsuHV3jxOHkJO3ndj3xIUUoYNQsB9/OLYI4ioKFKGYVKwbryNWKY/AlZoXZHg31NrP0CY1H+4hwKCTM6uZ/K0g5zO0xt71YBQai0RXnTU+iTr80SNWh61O84kSM8+thzddtGTyBzF/z4WIiCzDaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.com; dmarc=pass action=none header.from=kontron.com;
 dkim=pass header.d=kontron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB4VFHLODOhYYHkrZhdVfR2lS17ryS5oe2aBn7nq7Oo=;
 b=cvpeYh/Q7EzTcNEL3BYkzpCEE45iTMr6A7DVaKeFs6nZx4iWJusrU2TF7lM3nt+oWk72usUA9M3IowPijh+fDAjlmN++/da1984+PrRIjWat6XgRGymFUZfcHKqaGKwaH6wgRSCzuJjEwy8DE9/m8OKE68iGOxd1s16fBzZm7ok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.com;
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:3ef::11)
 by PR3PR10MB4175.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 13:59:50 +0000
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::112:efcf:6621:792c]) by DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::112:efcf:6621:792c%4]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 13:59:50 +0000
Subject: Re: Marvell 88E1512 PHY LED2 mode mismatch with Elkhartlake pin mode
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <3f6a37ab-c346-b53c-426c-133aa1ce76d7@kontron.com>
 <YtcjpofgVhSRyo+t@lunn.ch>
From:   Gilles BULOZ <gilles.buloz@kontron.com>
Organization: Kontron Modular Computers SA
Message-ID: <e6a883e4-0635-7683-cbfe-b4504c9da893@kontron.com>
Date:   Tue, 26 Jul 2022 15:59:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <YtcjpofgVhSRyo+t@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR3P191CA0010.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::15) To DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:3ef::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cb0e576-0359-4ce3-5ac4-08da6f0f1ba3
X-MS-TrafficTypeDiagnostic: PR3PR10MB4175:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJnWfxmiDLKkmcO3Y6i4dPYfbBZnj6mPQzaw7VNoNPJaN2s0qrfJXwG7aaFPnRywuMBWoQ7geZDIc1SPs6xeMeeSlSI9MBbApX1sjqPLH82cm0s3YjIIWhV+ayku6OhDNZi40jAt0h0CJ0YPr2zqXBGDnAkbCUrXctfNkOaodyGtuRVSDwD7vxGy7N7leB2BnXcMD7KRxR99nAAyrEMQZ0nXWRE1dBghEVIBn8AkoFJNUzc27ZCgcaHI9q24wNq53LxRkR9J4QQ65rSsCW6DHsbZut/xjVG52/vNkUcKKXINOAIQRYpRVYGSzrQFZ+FEbnekkZcoOernjuPBBLVy8ZcHNV5lR90p240KMkoPl43gjTT/P406Dv2658iKVJQuakYb6steN6I5KogjpBBqacoiW9csWLVKi1f/XJ9qXrortDHjomeoWXqlocIZNJh/cYzZu60EEB3UBLv7HmIpVBtgoiHgiox1G/OXzs/meuQERVjguRY42kGQEHRsmoF5UpXXYb4+wZvruCBHBvTL+vH6SHndRQg+wmAkj1eGrqJnJMKNAxjuNj8psCYuPUclROD+N5WG3qEHzLq1MouBh2BCdnuS4WM9irzKIHxSq4H3A7CGRIS/q8d27MNU4dwo+wP6Nsyqi4W7sEQxuSfmK35vD5aABmbYUy+b4BephRegBfVvxp/hiQzydMrfswX5zzU1j/vA9r0V7SeejcnBxCTTcyGVkSGrITsOtBBKP8cBzF+lY9WVuatEdBq1OJsJq/SLmNb1GLpXqrNBhzXKiBCfNNlwJBkY3EqspqPwBUq0n8EzJUlrlH4/HTc3aXn+j71DcZNfYeBVChW1FdsEi+afS7QJPzgWO+9h/LtxZiwcA8GzDJXwgZWPweVBbrNd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(6916009)(6506007)(45080400002)(2616005)(316002)(26005)(31686004)(36756003)(38100700002)(83380400001)(2906002)(66574015)(36916002)(8936002)(478600001)(5660300002)(66476007)(66556008)(4326008)(8676002)(41300700001)(66946007)(31696002)(6512007)(6486002)(966005)(86362001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmlwM3lKUGZWZ0xYejF4TjhmMk9MZnlSd3ppSUtYbzdyeDJObkR4ZGZnVTVD?=
 =?utf-8?B?bmdHU2h1TmJMcDNDdWlPQy9RajRWT2p5Y1hLRmhZU2owT1owVlZ0VEt1S21O?=
 =?utf-8?B?RDhXZVBsVE1QaVpNQWQyM2QzdFFqWmxVOEdidmtTRjBsNFBCWXhLSVVSM05X?=
 =?utf-8?B?bHBTTnVDQnhPUU1DanpoNmlnY2RXcE1NSm02UmdKZGdEZEU2bnJPNmlwUUow?=
 =?utf-8?B?ZE02dDV3TmNUMVYvZjRSdWx3RERaMzFvRlVUQVZoaGxXL3BVODVwQ2RIeFY3?=
 =?utf-8?B?aTl6ZWN6Z0lNR3ZXMTZoZGpZWjU1Y0VIUXJUOStucmoveVVqVzQrc3pQcVBu?=
 =?utf-8?B?K2I0Y3NuWE82QVVOckNxK1ZWSmk1ZlVkL2V5UzYwQ3F1L2lqTUdDSEFYUlFw?=
 =?utf-8?B?WkR0ZzVCUHA3OFptUFU4dkFTYTB2Z25IQjZ6UDZSWDZjQVVwdWE2UnpYWFF3?=
 =?utf-8?B?N01kV0t5b2VGUklxYVZhc21sWmNtSVNSNElGa3VFWDIxclREeVpwcWFTalUv?=
 =?utf-8?B?YkZMZVhDNEtjVWZuTlJ3eUs1OVB4cGorenhEWG9XK0FxMHJFZWU2NEdjMDBZ?=
 =?utf-8?B?ajV2MnZYUWd4K01NZCtvS1pqRnFveGJudHZTNFNmNzB1WmlRQ2NEbnRmZEw0?=
 =?utf-8?B?dE1vVkVuSTltVzgvVUNVQVpYZXcxOGVpWWtCMnNFWkh3aHI5bDFVdE9TRTdO?=
 =?utf-8?B?bm5OOHhBMlhQUFZybXBLcnBDYlU4bU1qN1VhZ0lGRDl2cjMvTlBJc2YzbWRK?=
 =?utf-8?B?eXdWV2VkeWNUV1VKdXFXVndVMjBQS1dHNzliR3RlREFjV0lWbkxUUDF2ZVB2?=
 =?utf-8?B?a0hkS25CeEs0SVJkSHZiQ1Qxd2hnYXBSTGFGRDZSajYxdzE1eFR2eTRYL0Vu?=
 =?utf-8?B?RWtmN2tpVXdMMlcxUWlaWHFZK3kwMnJRRyszNWFidnRLYlpxNENnQ2VsQXc5?=
 =?utf-8?B?a3pqd2xnWGV0V2ZuY2pwZXJmdTFpbEJtNUNBUU5idWFDdStrUUxYeEJDd1NT?=
 =?utf-8?B?aFA0VEdXTEVYbTVoZytpQnZNTWRWZjNadTB6YjYwR096R3lRaDRBK2gyOFZo?=
 =?utf-8?B?YlJaY0tZQldra0ppV3N2bXd2YUtQWi9SNytTN3JEMnU5TzJTQ1V0Sm12UWJF?=
 =?utf-8?B?ZU1rVEd6OFJsbVlFRGdLaXdDYWlFSi8rSWhwbFpDT2NmSVJrZUZZOU1Kdk9L?=
 =?utf-8?B?YW5tbVNXTmsxemtLZ0dRb1BpQ1hHNmpPZDRvaGUyNlhkL0J6Y1I3THlXNlFz?=
 =?utf-8?B?N0xQSm5IZXU1U0luMWZPdEVZRG84QU4rMStCUHV6QkxrM21aVkMzbXlMQnAz?=
 =?utf-8?B?YklxOEpSTVFFVG9Ha3JpeXdPK2xUQm45Qk1FdUxzK3RTazJaT2ZGaTlGbG5I?=
 =?utf-8?B?V3RFWDh6RGgxR3M0L3ZxM3V1UmxLT2FXem9pNjlhVWFONERMWjArbDVwUlAw?=
 =?utf-8?B?bGtBUGpWSWlqSDFJSHF2NWtFL2pnNWF0SXg5bmxBSEdTVUJ1b0hENnR6aXdV?=
 =?utf-8?B?bnpXTFBZU2tHdC8xYmFHbjl0T2w0TFZKZExlY1pYQnlkcy9wcnRvVTlOTWcr?=
 =?utf-8?B?aDQyUC8zYWVlL2xjSWZiN1doMzRQcm5jZjNXTmdJRWNSTHhtZmd3UEYxYmJx?=
 =?utf-8?B?akNENFNOemZKM1lwVE9raS81K08zY1Q0d2FkQWNxNEZ0V1hSTG95SDBVRjZx?=
 =?utf-8?B?blo0Vkp5NEpSUjBVUnlRdE1yOVJFUm9PbWVEWVAxamN1bmJZVUc5cVBoY3lL?=
 =?utf-8?B?emRtTU9SamRQd0RHVGpqWEhCSk5lTzV1dk85NUl3MHF1c1Uwb0lWM3hZeUxF?=
 =?utf-8?B?RStxMTdxV2ljU0xOeGprOTd2ZWxQSnM3WFptQnRNeXdiQlpkejBxM3I0bHVN?=
 =?utf-8?B?SXVWdTRaUXN3RVhpNmdPNXpObENoUE5NUzdOeUpzWW5pTUl5YUg3WEVJc1ov?=
 =?utf-8?B?ODZXWUs3Rm9rRkt5MTRHZm1NNjZhMDNOZ2JEbUNXUi9ZK0xTL2IxMEU4TzRB?=
 =?utf-8?B?VnNxNjVXTzlRck9rSUhGNkJwMGVlZzBVYjd3Wm90ZElXcWIrMjV1aUF0SE1z?=
 =?utf-8?B?TEFIYWtNc05JOW5Lc0FURHNpZ0dVblI3TmNaM2JsUFl4enB4ZWE4L2UxMHhD?=
 =?utf-8?B?bzRnR3B4bXk0YktBU3BCZ1dSclZ0VFAwbksrY3I0MUlaVU16WkV1TFE0Y0da?=
 =?utf-8?B?V0E9PQ==?=
X-OriginatorOrg: kontron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb0e576-0359-4ce3-5ac4-08da6f0f1ba3
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 13:59:50.6166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOX7Pd7JUGmFtMPtf0CM1cTAlSccvOUK/6RK4kxeJ2gt9N/hY4ZUyr0Jzl2qCneC7twTiGRwKD3FUQh5TsRQq0HUCsdBYCNSW7gTBPxfjGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR10MB4175
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 19/07/2022 à 23:35, Andrew Lunn a écrit :
> On Tue, Jul 19, 2022 at 06:36:20PM +0200, Gilles BULOZ wrote:
>> Dear developers,
>>
>> On a custom Elkhartlake board based on the Intel CRB, it turns out I have
>> the 88E1512 PHY configured in polled mode ("intel-eth-pci 0000:00:1e.4 eno1:
>> PHY [stmmac-1:01] driver [Marvell 88E1510] (irq=POLL)" in dmesg) and the
>> LED2/INT# pin is configured in LED2 mode by marvell_config_led() in
>> drivers/net/phy/marvell.c (MII_88E1510_PHY_LED_DEF written to
>> MII_PHY_LED_CTRL). This pin is connected as on the CRB to an Elkhartlake pin
>> for a PHY interrupt but for some reason the interrupt is enabled on the
>> Elkhartlake.
>> So when I shutdown the system (S5), any activity on link makes LED2/INT# toggle and power the system back on.
>>
>> I tried to force  phydev->dev_flag to use
>> MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE instead of MII_88E1510_PHY_LED_DEF but
>> I've been unable to find how to force this flag. And I discovered that the
>> value of MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE = 0x1040 is not OK for me
>> because LED2 is set to "link status" so if I use this value the system is
>> back "on" on link change (better than on activity but still not OK).
>>
>> As a final workaround I've patched drivers/net/phy/marvell.c at
>> marvell_config_led() to have "LED0=link LED1=activity LED2=off" by writing
>> 0x1840 to MII_PHY_LED_CTRL, but I know this is a ugly workaround.
>>
>> So I'm wondering if PHY "irq=POLL" is the expected operating mode ?
>> In this case what should disable the interrupt on the Elkhartlake pin ?
>> Is wake on Lan supported if PHY is set to "irq=POLL" ?
> This sounds a bit like:
>
> https://eur04.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2FYelxMFOiqnfIVmyy%40lunn.ch%2FT%2F&amp;data=05%7C01%7Cgilles.buloz%40kontron.com%7C3c6eef4b24214d5c7a8408da69ce9e4b%7C8c9d3c973fd941c8a2b1646f3942daf1%7C0%7C0%7C637938633398700195%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=%2FIM7eVVfMfpjNCDpJaMZTXejNWENIHZWKExGmSTz%2FFQ%3D&amp;reserved=0
>
> If you comment out marvell_config_led(), and read back the registers,
> does it look like the firmware has setup the LEDs to something
> sensible?
The value programmed by the BIOS to MII_PHY_LED_CTRL is 0x0030 meaning LED2=link, LED1=activity, and LED0=link (and reserved bit 12 
is set to 0 instead of keeping it to its default 1). So this is also not something OK if the interrupt is enabled on the Elkartlake 
side for LED2/INT#
>
> Is the IRQ described in ACPI?
OK, I'm going to check for it
> Maybe you could wire it up. Set
> phydev->irq before connecting the PHY,
OK do you do that (set phydev->irq) ?
> and then phylib will use the
> IRQ, not polling. That might also solve your wakeup problem, in that
> when the interrupt is disabled at shutdown, it should disable it in
> the PHY.
Is the PHY interrupt needed to support WakeOnLan ?
And is the PHY POLL mode what we have on the EHL CRB (I don't have the CRB here so I can't check that) ?
Thanks
Gilles
>
>      Andrew
> .

