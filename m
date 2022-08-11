Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC476590713
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiHKTnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 15:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiHKTnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 15:43:42 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150088.outbound.protection.outlook.com [40.107.15.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7296B23BF5;
        Thu, 11 Aug 2022 12:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBZbiAc9f5eUABV9h6io1+OkdplX4y2fb0QCx067AdixSHLGPXQHcs9BMA6dSmrVEVULs+h/ee/uE/Pz2pJM1JRURVUl7mkFF0Bp+zXOAfGxfCabbOEZZcbh6lmz81jXds6hPJg0hGfFPB2LrIP49C8FN/1cjrGiciKoiL0K2kH/ghqVJLPzpPp7iQtz5vDFFs6cRPySRBC7qet0rCWJr/At7qgTfRT/ylD5YciSVRY85wygIYEa4Bdgnjzm4X5pbhzvqH2j7o1EvK2hD7rdjN8YIPuCUmmsTAAugvkLEHg/6BY+uxD/wwGUivPJM6/PekseBuTzoofD/SA+U3PHog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TTzqXW3KZcB3nONxTlQ8knvVIBS/cyiIpbrziw3FRY=;
 b=Rf0TYOrUL/4hXVZwbAIBFdcayBZcCQm2oeRTBmmRt7bKAG9VntNVhAn6cf88rVdXJveR0pBD2IBLD5LgA0XyAONjoeM2xZ5ZADa1XbHhb288q07672jufFTqC+AcvKtwnScKFR/WgKLH6rKqMZJxnHTT4QcHIVmUBCDufVxfTqOJpQG5vFbIY4wgTqPzWQJTcgpaHIQfH8iPPEzdQQl3pp2k1/rbYXJF3mwz6w9r+HSttQNNsyEgd6XnZ3GMD3rGZShWw/MgATGJ6WZ5Z2ViQSbb/vlBSEDk52GrRlXyL3ibHhvG+R8LDXJUJFtgQqJUdKEEbmX6Q7ja1kyYDE1LjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TTzqXW3KZcB3nONxTlQ8knvVIBS/cyiIpbrziw3FRY=;
 b=i4Y1xPQdvI/G8pOrQPtMvslmyAh3IGcIIgM/GTlYqcX2XZt+xdwN8Yyrgee1j3lev6fZl9yU/jMMZCZMxROXzArSZZE1oGpfvvTlvS6S178y/PUhePfOpIIdW2pRtV3YFZPF2rGtT2/GH6Lb/E+O+7Y+pdvGQOTWHdae6iyZFEf6es4jfKFefvQ9ZVtzqkpY+AHOabbiUXlpBRk3TxOKjn7KEqQEzprYxDL40S3I1m6wrzlcPVKRJsilM40Hxi0S4+xCAk/6H+VRAmnHauwNcaQMsSMfpTsGpNn52qzO+WHDAYLzPbvTYMCNTyLii1AL05oUwFwCUDWBNfrnhvPxjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7149.eurprd03.prod.outlook.com (2603:10a6:102:e2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 11 Aug
 2022 19:43:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 11 Aug 2022
 19:43:37 +0000
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com>
 <20220809214207.bd4o7yzloi4npzf7@pali>
 <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com>
 <20220809224535.ymzzt6a4v756liwj@pali>
 <CAJ+vNU2xBthJHoD_-tPysycXZMchnXoMUBndLg4XCPrHOvgsDA@mail.gmail.com>
 <YvMF1JW3RzRbOhlx@lunn.ch> <20220810071603.GR17705@kitsune.suse.cz>
 <YvPMJLSuG3CBC//n@lunn.ch> <20220810153510.GS17705@kitsune.suse.cz>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <140c3841-51fc-6874-b497-4ead9a623d34@seco.com>
Date:   Thu, 11 Aug 2022 15:43:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220810153510.GS17705@kitsune.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0185.namprd13.prod.outlook.com
 (2603:10b6:208:2be::10) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e98665c-76e9-4a33-480a-08da7bd1c8cb
X-MS-TrafficTypeDiagnostic: PA4PR03MB7149:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zse01NLVOOWSgazxyyky0aDMDe68ST8FSrepA3pg9j+7VcXMxJy2PNe4PWvIsRQ+vQ0ZTn+GABxAH+V0cf8R39PEdw0ocoptAg2WaqPAOoxJGYjpMpnqpezCvTvEUUISgAgzoPxKv7HMlb0JBqGUM2QR48l9Wxpu4tOJIXqgjDNYMKp60sL+MmPgJECQlq24iAymu+jWq9V8/MXq/A+Z86bllxT0V//oPft4RavxTp3hfC8yE0AIJVDMLzvj+oyPk8Jj6nNb6ynBvNGxMFBA0zNcoLPg96Dx36eAgxqxMIYKAr6i46tMl72p1lEnCerhOO8ga//nfNC3cn70f6pSvCZNE7Sy0XNcu0vd+L5uAxLnlRTrylIOKQQPBV9RE2zIriS5u0IWyqr+ta/77ZfcPE6A1pyZoSS/g0ENN9ZcZEFVjFuR8dvbyc9CBwN207CHv9o8EdMHpJGNg8PoLG5Bk0NKFVATPN7U4nGU0ZlfutzlUaEHuy8I0KHHuZzoRub3vTez4ZLQoIwnVnUUyRsz2Gd4ZM+4zpBa07HmleSPp5n5pXW4nEhahME+JSnmHq6fupCPpMPUnlz+mA/BrXmi9WMa7x69Uleq1vSUeneb/hjEXyJA0fr9VzgcB080ufJioAJCTRt9MdWCwflOxoPsmjYyL1xocdGNa8CVogWjngP1mAS2lXcOfbgDZ/3lt4dhKVnrRikhGy9BlIgfwdV3jw7v3vXEYOkb3McnGn8I95UPH4y4OnM5CGPUr9njH+xTcj1gYhd/YaVJ6UJk7/qJa7VsMihqQMrhNVUeQW/MuCKSBSK1qXJLxYGhvBNOsSIvJRgj/+HVRT5qCdxqsVG66id8AV/L+borqbGckSbQd5pEdmEaCpN+7d3WQHQUt538
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(136003)(366004)(346002)(396003)(66556008)(66946007)(8676002)(83380400001)(41300700001)(6666004)(4326008)(2906002)(316002)(54906003)(2616005)(36756003)(110136005)(66574015)(31686004)(186003)(38350700002)(38100700002)(26005)(66476007)(86362001)(8936002)(5660300002)(52116002)(478600001)(6506007)(31696002)(6486002)(6512007)(53546011)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjMwckI2c2pzcVlqOTUxRndUQUJ6Sng3UTlHcFRsM1hkbnN0RGl6LzQvQUxa?=
 =?utf-8?B?QXdFcU1YRkNxL0U0MXV2Wmc4a0JOT3FWeExhM0FjajRoQk5sZ1JmY3FMeStB?=
 =?utf-8?B?SmpWQWpCSE16c01LK2RQejh4MGVFTWJpNjBlSk9VRVlJeWJ6L0EwTWk5Kzdw?=
 =?utf-8?B?MXpQVnNZaW12YktjY1N5L3ZYSXFSMWlyZk1YcmlFRDBISVpWYUF2dWdGQUx0?=
 =?utf-8?B?NXB6S1JlaFFia1NDZDA1RW5nTXBLSC9qQVpUR3Yxb2xydVZGUG54NjZoK3RR?=
 =?utf-8?B?Q1RPZ1krOUdBcDlaTG8yRE5KT0NLMUs0dkdWRWs4d0hsaFpzam5QZjFHS3hs?=
 =?utf-8?B?R0t0ZjZ6WE1DSGFjVGNhamhYTENxbytyN0lPS0RxbE9yVTVDbk93czBWZ1R0?=
 =?utf-8?B?WWdsY0h0U1pOeWR2T1AyTE1mNjZuc2Z2d0JINFA2eHBpQmxrbjFhWWxVQnkx?=
 =?utf-8?B?d2Z5ZTdoaDJmMEtoT1pCVVIyYnVCSHBLVmFnZlZ1MEEyYm9QZ0toNFNPNnVu?=
 =?utf-8?B?WVppaGs3ajhoZ0lIT1MzZUtRSUZEOVNkK3M3NFB2TFFRR0pRcDdJN1JEd2V2?=
 =?utf-8?B?OWljZnBySHl6aDMyR0xvanBBblkxdVY4YlRpNHFQVyswdEJGbGZJUE04Q1Fx?=
 =?utf-8?B?MGs4R09nUG92V1RkbXBrV3NaNUpIY0NuSklCMnR1UjN5T21kUzZRTkkyS1Jl?=
 =?utf-8?B?K3gySm9aK2lGZVRoTHd0K3BEK2JCSnllWE1vU2NSS1VLZWlSRjRKODNxcU8y?=
 =?utf-8?B?eUZFUzVMQlcvWExBSzhwbE1uR2pJQWpZR0xNUXkySGsrY3ZlNkRPRmtQSmx0?=
 =?utf-8?B?Ukt4bFJMSkZ1RUpzUlBEbDRXbjNqbmxVeHQrYzN3S3lBN3pTUS9PRUdoWmlR?=
 =?utf-8?B?VkxRWDNEMDc3TTFOdG5nanVqNGRLck5oZ1Y1NU5nZVd0NjY1elpTam95ajFp?=
 =?utf-8?B?Mm1sM2ZFNFJYRUp5NHNlcENBTG41TlBxR0tXd1diSjZPUkdwcVREd0IvOHAy?=
 =?utf-8?B?Qm1lZStwOUwrdE9mblBxdVRFMit2YXdpaWs3c1BXTkdETnliRitQZVp4aEdy?=
 =?utf-8?B?MzgrSjY0Vk5nTzVjWkxqNlFaYzljVXlTZWU0ZVRVZktOVU9iY1U4dDhLTDNv?=
 =?utf-8?B?S3NKSXRJNDBxU2JoVXQ0aHI1M0M5aGwwdVBOTGZJRytNNGlZeFVjNmZOTzZG?=
 =?utf-8?B?R1IzK2taOVJPVDhjenhobHhBWVEzUHB2cDRWWkpudHorN2RIK1JqNU5nYXQ5?=
 =?utf-8?B?a2ZiaEtCcDBqSjA0M3dNZFJrbEFtd2NGRUVKRVhMTXNpRXZQSktmK0pLb081?=
 =?utf-8?B?VUpIdXdUai9xTVVqTGZjbEowVGF0UTlkRXUyemJWaWUzS09xR283emVhYmxF?=
 =?utf-8?B?dktBVVE3eDJBREFCNi90Q2FSZW92ZDNkbGZuT0FtZktiWnhRSkNVQVRDa09h?=
 =?utf-8?B?MjNCdzFaNWtCS25VVEdoUUJsVzlNbXM4eFpuOU9tU3MxYXRiUXFEVFBrOU1y?=
 =?utf-8?B?VHVtd0Z0Q3lCWUlaNXQybitZUDN5NVVWQytWWWhHZm9TYlhrS2JNREtobWpU?=
 =?utf-8?B?VU1RTWFIRkJDb3lFTGJoR0JQSHF0aDhoa1VwWXlyc280ckI1TW8wdFkzdXVO?=
 =?utf-8?B?eFpzUDJaWXgxWFU4WUc4dFVOa2dDV3dUYjRacHRESWVrQ0tyQ2g0YUNjRjF6?=
 =?utf-8?B?WW15YitlZ1VtaTVvZTBTcWtIQ2s2TTdzL3BGTlJ3WnlOcmNwR3h3NTdNMEJH?=
 =?utf-8?B?VndPdEJjaG9LdTdDZzB3QnZLMVd3a3Q5OXJGU0ovbnZLRHJlUXlxNWdMK1dr?=
 =?utf-8?B?Zk1NaEN3NmVMNG85UXlOZFA1dWl2amNudVpZWllwYVh1ZVI1UlNYYW9nOXNR?=
 =?utf-8?B?MENsTGgxd2l4TUFOd2lOZVR2WDlMaXJpMkM0WDdPMG9hd3d3ZnpyRFVlTVo4?=
 =?utf-8?B?V3puSGYvaWxKc21yelVqdzg5alJSZVhwQWQxVEthdExCZWpwNlhHc3ZyZHl6?=
 =?utf-8?B?U0VFNWNFYnpNMFpRUnR2anhqTG5WL2FqQU02SWU5V1ZRSUNhTHZnNFpHRHps?=
 =?utf-8?B?bmdtV1Y1WFpHOGNHSGhpOFdWSHhoem95S1hEZEhHallLcitYS2UrdDFDLzVs?=
 =?utf-8?B?YVNnczNXSkYxOTRxbTRkVnA2WTkzYm9KZzZVOVFyVGhyM3BuTFpCcTYzbGRW?=
 =?utf-8?B?dkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e98665c-76e9-4a33-480a-08da7bd1c8cb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 19:43:37.5055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ib7ohIhKoxRYEH0f/BJF4T7DldKl1bPH1eQZt7wD5nlbCQJBgczi5DfVJCVuQAGSPS4Ch0b5IjK/95+20ddnbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7149
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/22 11:35 AM, Michal Suchánek wrote:
> On Wed, Aug 10, 2022 at 05:17:56PM +0200, Andrew Lunn wrote:
>> > > I guess you are new to the netdev list :-)
>> > > 
>> > > This is one of those FAQ sort of things, discussed every
>> > > year. Anything like this is always NACKed. I don't see why this time
>> > > should be any different.
>> > > 
>> > > DSA is somewhat special because it is very old. It comes from before
>> > > the times of DT. Its DT binding was proposed relatively earl in DT
>> > > times, and would be rejected in modern days. But the rules of ABI mean
>> > > the label property will be valid forever. But i very much doubt it
>> > > will spread to interfaces in general.
>> > 
>> > And if this is a FAQ maybe you can point to a summary (perhaps in
>> > previous mail discusssion) that explains how to provide stable interface
>> > names for Ethernet devices on a DT based platform?
>> 
>> As far so the kernel is concerned, interface names are unstable. They
>> have never been truly stable, but they have got more unstable in the
>> past decade with multiple busses being probed in parallel, which did
>> not happen before so much.
>> 
>> > On x86 there is a name derived from the device location in the bus
>> > topology
>> 
>> This is nothing to do with x86. That is userspace, e.g. systemd,
>> renaming the interfaces. This applies for any architecture for which
>> systemd runs on.
>> 
>> > which may be somewhat stable but it is not clear that it
>> > cannot change, and there is an optional BIOS provided table that can
>> > asssign meaningful names to the interfaces.
>> 
>> I doubt the kernel is looking at ACPI tables. It is user space which
>> does that.
>> 
>> The kernel provides udev with a bunch of information about the
>> interface, its bus location, MAC address, etc. Userspace can then
>> decide what it wants to call it, and what its alternative names are,
>> etc.
>> 
>> Also, this is not just a network interface name problem. Any device
>> with a number/letter in it is unstable. I2C bus devices: i2c0,
>> i2c1... SPI bus deviceS: spi0, spi1...,
> 
> Thees do have numbered aliases in the DT. I don't know if the kernel
> uses them for anything.

This is an issue for serial devices IMO. The only way to specify a
stable console is to use its address! Things like /dev/ttyS0 can
easily be reordered just by plugging/unplugging a card. You can of
course add a udev rule to create some stable symlinks, but that's
too late.

>> Block devices, sda, sdb, sdc,
> 
> These too, at least mmc.


Which I am very grateful exists. While the block device situation is
not as bad due to e.g. /dev/block/by-foo, it's still nice to be able
to have a consistent name.

--Sean
