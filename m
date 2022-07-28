Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF64584528
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiG1Rey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 13:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiG1Reu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 13:34:50 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60129.outbound.protection.outlook.com [40.107.6.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8E1743F9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 10:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNO05qLymugh+sXDyzy1uVofbrCbkNhmK6s2skRajuQ6K4GMoaILwXa27F2sOFKZ1LHYhAwoWq4lgDIo9fhNubfLFWHvjdSKGuFmCgje9ThPZa0ko83xWt1BiS6f0c6jvFBAFlZOo6/aYfetvp5u631YR0ope3dUkc6Qb++x7jqRfd9itXbzeDqwd/is6zYY+gcF56c+dc9uc9A5/HQnIYmbv+1cF3jHAHECYMKKPq2yRKiw8J/TRg6Enyt88+Sqp0ZZVK9N2ZGH0GDscxMHEWjilIOrQHb3B+ZsDg3cezlVJ+hxn5xoxiswq206fFsSbg1WsD2OoVeWu8xjV/Fp5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qj7tbiMrfbB7+hoFACm78Q1OCElDqhO/UtslFDc6op0=;
 b=i2bGU6saVwOsHETjjK4TrTobH4L83N5cchmD22GldX7V71QTKR4TuN+N1vtduYXi4jkg+dfd2LYcyYQ6hPAOUza7WTs2xpJchpO/9XXrj5EzDT8SLhemCOAuMKKLSV6OfoBiezUHjJE8MivMxd3tsgw/AnUS7UZbGp4vbd6IzNTpENPTOVoduFVgCnZuToWEq+JigZHIVDujTozytyN1/UfIYNbyIQlXiNjwSYAbtfjp09ompAtDf8diiNh0pvbzQtITecWNozkoMfJa8LjCNYANwPJUYqsg3vbhHkxV8mYUKl2Y0SSjQ7twVSCHuHAGSb7cqFkOMo2FUswAcD7X/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.com; dmarc=pass action=none header.from=kontron.com;
 dkim=pass header.d=kontron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj7tbiMrfbB7+hoFACm78Q1OCElDqhO/UtslFDc6op0=;
 b=K9yQSzp3WDGaTrkT5gRcCd/5zfSNbSN9a5EZBuGdjZTMzLGka9bx1njW/dhyCmG+ntXyeYqwFzg7v9d/c1X1QwIpPz+7U3Li/lZOSC9FRCS4oHk/b8UM4z+9dLyi5t6YNTXbnqk0VdS0E3UBH+oLa1cSVQA9PTGSoC5WW+bWAf4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.com;
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:3ef::11)
 by AS2PR10MB6709.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:55d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Thu, 28 Jul
 2022 17:34:46 +0000
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::88c1:4797:9d1a:97a5]) by DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::88c1:4797:9d1a:97a5%7]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 17:34:46 +0000
Subject: Re: Marvell 88E1512 PHY LED2 mode mismatch with Elkhartlake pin mode
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <3f6a37ab-c346-b53c-426c-133aa1ce76d7@kontron.com>
 <YtcjpofgVhSRyo+t@lunn.ch> <e6a883e4-0635-7683-cbfe-b4504c9da893@kontron.com>
 <YuAOao5X5kj87dt2@lunn.ch>
From:   Gilles BULOZ <gilles.buloz@kontron.com>
Organization: Kontron Modular Computers SA
Message-ID: <e3369d04-67e0-734f-4604-f66a84a3b9af@kontron.com>
Date:   Thu, 28 Jul 2022 19:34:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <YuAOao5X5kj87dt2@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR1P264CA0012.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19e::17) To DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:3ef::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ad41cf9-12fc-4248-718c-08da70bf7702
X-MS-TrafficTypeDiagnostic: AS2PR10MB6709:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +kZQOsFUbMYxBnc/0RWI6seeju6NiYGKRPQstSMgT2mURkL9m9RBEk31FT0e95oUjy1WtPCqmPDR7EFxvWNst+g8EhmYvy1SSbxftbdYyvz+Nd6fbj+vsiI/zCs4gUHO0TmGArqKJXUva5gC3vVfOluoRrJw809ONahq3zTSKcUkJHwh8o3KaeNndRsIjFJ3cnFtfsnTtVn9CwIp091UeQDgyRRZSa31jbVdc9WCnUQGuIE3E0vaEcBWhsmSJZIILh/lv1PPkDAadHaGLGjns/lGY/dzFLoMKMLJhwjhgGKRm11tVcTsVHpZsn5BEaJpUc68YFYDdIsqNYD9HJub6T4UySgku9vuPPDa1/39ujz0gpsHcuq2ru3yEIBuKckuHXzvu5LVrZbH6+7GpX09ojba/EtXA+D7P7i8FmIUhQ0/XeC/NG6KfsNmjYGbWhCv0HRLQzdKsgyLfNB2tTLIxBdY+0VkZKErQOncUMqrx4wADrwvVavzwIXg2uq8vbytyv4rZ9ULyhl9dz79pP65sQtm2gEKTvynaTqYouqcBbkCVtlxD3SdKaxE1WQbgERbjOxYnVENmurFjZVYmGV2D7jjhDId4ReuKpNkDPMjzPvTKtwoSKSqBgSkPHj1cDvLud2Utz6CtpNEPI9rlRooElRy2cjlo7Nr+nqH2KtrVpRcIQIYwz/WWDwgdmGxgNn8pLIerlpm2/AUI/tDOhl+kP6K1gb+You+MOX6bVV9NZoLeCK6D/R+XZayhUTKS4ygzRkyLDEkWNEaluMwM4oygkaNhhroEDMPj4I4neJ5jru+k8NZ6O4/YF6C1ByKc6wCAMTG7QRBVyaC//1QLoXRK51otjRzEwaCzyxlLhEzXywXE6CeMx/Uoi2KFBw8cbeF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(38100700002)(83380400001)(186003)(66574015)(66476007)(8936002)(5660300002)(66556008)(4326008)(66946007)(8676002)(2906002)(2616005)(41300700001)(6512007)(966005)(6486002)(478600001)(26005)(31696002)(36916002)(6506007)(6916009)(45080400002)(316002)(36756003)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFljSXNzakl2Q2xTOG9qQytyYnQreWxEeWxYZ2NNaUVKNlRSQ0hiYmFhVER3?=
 =?utf-8?B?bWdWa1dCNUhVYXlLaXNJWldHSDNrZWZmb0FhdmsyQnpWT1JnMVc2NzhWbFcv?=
 =?utf-8?B?d3FMMlVtZm1JZG0weGV2REdwVGFKM2Y1LzV3MGxYb3I3aHUrQUFsNE9SSzAr?=
 =?utf-8?B?eEw1NFBDejU3K1Rpa1NuNEdjZUJTRGViSXZGeHp6K2hQNExXc1RTZEV1UjFm?=
 =?utf-8?B?TWV6Z0M4SjlFcytvdzBaL0Jsb1NiVFEzUFBodG5RemZvMGswNHJGcGQrKzV1?=
 =?utf-8?B?UFpwQ20yYkR4eW0yUGU1SzNOWnRwMGZicGtIV0xBL3NxVWhzVG1seXl5cnl1?=
 =?utf-8?B?dFB2MExUK25jcVpBaFM3NTc0MnU0TTI4Ty9wZThLRVI2RmZ2aVZoR1ZzQnV5?=
 =?utf-8?B?eWxOb3JWRXVBZXpMTElTZ3lxMFhmdm1SK0VwUzZNUFhLQlJnYTZPWFo4VUhr?=
 =?utf-8?B?ODhhb2grMkdaZ3JVbGpOaEtMUWprcnRFM1N0VWZUVzBlNzZOOStvemdGZjMx?=
 =?utf-8?B?aWRhUzYwWUM3dlBoVFVsNzlzNEtMVWVpejBlNy96bUxSMHhEamhPdjJVa1VQ?=
 =?utf-8?B?MWgxY3RQcDJmbU84QTg3WFN1MTNGOUt5Z3JMbHd6NkFRK1A3UEFxVDhKU2F5?=
 =?utf-8?B?cTdQTmwwODRTRnNWZlhFZG9JeVV3VkQvVzNkUWhjTzY2Lzdma21oKzRBM2Fa?=
 =?utf-8?B?NjF4d1RtRk1BaVlzNjVFbTdhV0RZQitsZ3hlUERCdHhqblJyUzRHeDZnRlpw?=
 =?utf-8?B?Q3hNbFJSSVFQZTNMeWRacGZHRnFLQ0Z5TWJuVmpCc0ZTQ2xmOXNYTjNJMjRX?=
 =?utf-8?B?YzVvRHlvVk5hNGhPWUMrUTVLL2tGclkydkpVenFtbEozSDN5TEV1aGUybTJU?=
 =?utf-8?B?R2h4OEZpVVRpNFpCbVYwSEc2eWQ4YUhjY3ZYb09zajNvNjl1RTc3VTNDcVZC?=
 =?utf-8?B?eWFyd3VZNjFvMHBqdzAxM2lIbHlNTVRyZ2VxeXZHWU11RTF2WXZ0dU5VRmVL?=
 =?utf-8?B?eEUyYWREQnBjNVU2UXNFOStlZStEbFU2UEY5VDlyWVRkcDZQWWxTSlhjQ1Yv?=
 =?utf-8?B?RlE5RU5Lelk4dS9qS2E5d0x6ZlU1UEg3N2xoeDZIWWtnNkpQQUQvRnBpT1k1?=
 =?utf-8?B?NmNUWnA0REZRMld3TWROeFpzQmY5SDkvVi9WZE85bGRtQWRtTmQvQXIzZWlx?=
 =?utf-8?B?QlNCc2JIYnlNZVdGcWFTUUVXSk9ZZElhS25PVkc4VGVqbGpBcHJWTjUrMTdL?=
 =?utf-8?B?UEFxZXZFaFVTazhzK052b1N0dFVUS3ovZW1ZeW5FV2hBN1J2MWFIcDdmRm1N?=
 =?utf-8?B?SS8zRnpycDdIdk8zVTlHM2cvYytVUkE2S0VJVTFuTUE1N3BQN0hHZEFPa2tl?=
 =?utf-8?B?aGExY294clRWdVMvK01Dbm9JWWZSWFNDSnNvOUd2MHQzZ1ZoY3dLbkFCajhU?=
 =?utf-8?B?eUh5aWpCam1iNGxtVkdwdjRWWFNGMVAxYjVXYlhBRXJCdXlHbVlTbUVOdkx0?=
 =?utf-8?B?dGFHRjJ6c0haZE1nYkNxVkxqb3RKdWVpTVJnVXMwVkZFMURnNzhVN2FMekdl?=
 =?utf-8?B?WEdLZlltcFJONTROeVhIbjI1c3Z4cmZHdktadk12bXArVHN4UUlINFowV21p?=
 =?utf-8?B?cENvNEN5bzVRVzA3aWMyT0w1MHl0eldVUFJjai90T2RtYVdjQWx3SU5XdHVt?=
 =?utf-8?B?cUlzMVZMb3BsamtQRjJpVVYzaFc3b3YvL2k4Q210NHYxYVlkWjZBb0NuNm9s?=
 =?utf-8?B?dUhUM1RpMWxXYWw3WXc4Vy9heWhuMVJnMzNuc01VMDVLbXpGbkZQankwcWZq?=
 =?utf-8?B?aFErSU9kbkJ6Wk42RDVRcW16MFFjdFJkVnFLNVBUN08xTVRkMkFuZERHTlNm?=
 =?utf-8?B?emNKbzEwVXlhL3NVS0dsNWJpaEd6ckRNZTFLTWxBSHo2Y3VLYkEyWG9HTWp3?=
 =?utf-8?B?QmFpRUVXd3dUejVNUDZvVXRUR3JoMFlOSUsxT0dYb1JwWEEvK0ROZUM3SEp4?=
 =?utf-8?B?Rkxid05EWTFZdVdDLzN6cFBVUlhLSStPZmlIZWNnRENmNll5M1J1aFRYZmJU?=
 =?utf-8?B?OW1Bd0QxdENURmxVb0gvcGM5a2gzdjFVcCtId3NNWXlIUEY4ZENEUkJzaU9t?=
 =?utf-8?B?Nmxxckg0ejEwRG9DNWNhbm8xVVZrSHdselduMUlJRDIrYzVYYVo2Q1FjcVVw?=
 =?utf-8?B?SVE9PQ==?=
X-OriginatorOrg: kontron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad41cf9-12fc-4248-718c-08da70bf7702
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 17:34:46.5621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uv554ddrUcptHZrvxo+Hf4qkyosTfdBDZahHwrgRFB4AemtHYKS+gTJ6qAwL9cMJSwUddAoQ1tuwyl9TXfkyDx40FV7Scgy2p8kkM65wSwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR10MB6709
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Andrew for the explainations.

Having a look to the Intel ElkhartLake CRB schematics, the three 88E1512 have their LED2/INT# pin connected to the Elkhartlake so It 
seems this board is using architecture 1)
I'm currious to see if booting this CRB with a Fedora 36 would give the same issue than the one I have on my custom board based on 
the CRB : PHY in POLL mode with LED2/INT# set to link/activity by marvell.ko, but Elkhartlake pin with interrupt enabled, leading to 
a spurious power-on on link activity when in off state (S5)
I'm going to ask Intel support for the status on the CRB or try to get a CRB to test by myself.

Today, I discovered that if I blacklist or remove marvell.ko, a generic PHY driver is used instead (phy-generic.ko). This driver 
seems to keep the state of the LED2/INT# pin set by the BIOS that is "link up". So I n this case I get a spurious power-on when the 
link goes down then up.
Regardless of the PHY driver, shutting down the interface with "ifconfig <ethname> down" before shutting down the system is a 
working workaround (no toggle on LED2/INT# so no spurious power on)

Gilles

Le 26/07/2022 à 17:55, Andrew Lunn a écrit :
>> The value programmed by the BIOS to MII_PHY_LED_CTRL is 0x0030 meaning
>> LED2=link, LED1=activity, and LED0=link (and reserved bit 12 is set to 0
>> instead of keeping it to its default 1). So this is also not something OK if
>> the interrupt is enabled on the Elkartlake side for LED2/INT#
> O.K, so it is a different situation to the link i gave.
>
>>> Is the IRQ described in ACPI?
>> OK, I'm going to check for it
>>> Maybe you could wire it up. Set
>>> phydev->irq before connecting the PHY,
>> OK do you do that (set phydev->irq) ?
>>> and then phylib will use the
>>> IRQ, not polling. That might also solve your wakeup problem, in that
>>> when the interrupt is disabled at shutdown, it should disable it in
>>> the PHY.
>> Is the PHY interrupt needed to support WakeOnLan ?
>> And is the PHY POLL mode what we have on the EHL CRB (I don't have the CRB here so I can't check that) ?
> Needing the interrupt will depend on how power management works on
> your device.
>
> There are two basic architectures which can be used.
>
> 1) The interrupt controller is kept running on suspend, and it can
> wake the system up when an interrupt happens. You need to call
> enable_irq_wake() to let the interrupt core code know this. Picking a random example:
>
> https://eur04.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Flatest%2Fsource%2Fdrivers%2Fnet%2Fethernet%2Fbroadcom%2Fbcmsysport.c%23L546&amp;data=05%7C01%7Cgilles.buloz%40kontron.com%7C8bf9a027f842497e93ce08da6f1f3fec%7C8c9d3c973fd941c8a2b1646f3942daf1%7C0%7C0%7C637944477262739726%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=xSQxiM3lLrYyeKEbCS%2BRGI%2BdhCl7fqngYCIyBU0OOEs%3D&amp;reserved=0
>
> 2) The output from the PHY is connected to PMIC. The pin changing
> state causes the PMIC to turn the power back on. The SoC itself is not
> involved. And the driver does not need to use interrupts, in fact it
> cannot use interrupts, if the pin is connected to the PMIC and not the
> SoC.
>
> It sounds like you have 1), so yes, you should be using the interrupt
> for WOL to work.
>
>      Andrew
>
> .

