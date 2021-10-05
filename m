Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC581423464
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 01:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbhJEXSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 19:18:37 -0400
Received: from mail-eopbgr140083.outbound.protection.outlook.com ([40.107.14.83]:18817
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236799AbhJEXSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 19:18:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhL0j+HGUjyn1EUYjqbArg05T3//PjhY7fPrE5slbNpStBRtAXCa70tgJA5xChBkyNvcuW2grfoLnODVyfVht9dEhM7VUZdJt+gnxcPp/9VhMuq9sT54p+E9Ci7cDbVRgT30Ily3MBlb5jrPpRSdCp4ZCoipg05HYVYL1kl8Ny4DnHvKYvyw5L519N4NIuVrulpI6xj6bzTejEIuxVV3Kd1ch48HUxBMPAwh2QRNME9fByA6ht53AQ1uIjAt52icAGATWoTfxiH4flFCxYWZUtd7ht1tb/V4u+98s50re6cr8fUE+5gmw1MaBiT/0o+0/Dw1/UkhmwAHkAENMIPnyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L13FPkVL+k+vQj8BaX2OAaV67mphkEcorckba9Ieol0=;
 b=bu5+1mRMn9SRXK8/6fdZzttTv9eW3PcLiabsNfF0u59W7i+DXKmsQmfylWc4YR4xcCoLm1Hg4zlxfQoyg5HaNTp3II9XC2kC2Oc21cTI+zV5vONhlBISjZ4V+hiN20bj9XmR22PN6IgecaTlG5cUUSJQhrvK3YYqv3TosCnu6EfrexjjRXrEPrW7Ho2msZuFYMtuI/knGMmQobiqgF9NnMPCY5Ee+xBQ+gG8FnVPH8hqPlXAlMpeiWMLmNOBHOqKWBo/3eRfIcva3kdL9M/X+Ben+QzzY+kPO5d6CodR1DGIp3n2DEv/BByMoYXOCLnESEPZ4jilj2y27VrERMCK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L13FPkVL+k+vQj8BaX2OAaV67mphkEcorckba9Ieol0=;
 b=yoiEqFzLqWarmrF/MtTB9bd50tgnOMa5llM6DXqCK+2eL3v8UjXmDU2FTvXKysetDXCQGg1bgBPNOIRMwtXi8c+OBSsaX08dTdccOuLmkazJJWkoK8WIHI6iwlkEnXkG95yS7BGQT9K8NsNkg/MhA4HJNCuIQRzz+dRSL05P2Eg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB7129.eurprd03.prod.outlook.com (2603:10a6:10:206::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 5 Oct
 2021 23:16:42 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 23:16:41 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 16/16] net: sfp: Add quirk to ignore PHYs
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-17-sean.anderson@seco.com>
 <YVwp9R40r0ZWJzTa@shell.armlinux.org.uk>
 <66fd0680-a56b-a211-5f3e-ac7498f1ff9b@seco.com>
 <YVyjj64t2K7YOiM+@shell.armlinux.org.uk>
 <55f6cec4-2497-45a4-cb1a-3edafa7d80d3@seco.com>
 <YVzO5vrg7sZkZVKO@shell.armlinux.org.uk>
Message-ID: <4fee71bd-1f8b-44f9-3bde-37d59c5f0087@seco.com>
Date:   Tue, 5 Oct 2021 19:16:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVzO5vrg7sZkZVKO@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49)
 To DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 23:16:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 576b7eb5-db49-48df-869a-08d9885630cb
X-MS-TrafficTypeDiagnostic: DBBPR03MB7129:
X-Microsoft-Antispam-PRVS: <DBBPR03MB712958A2B93291B4E2A2947096AF9@DBBPR03MB7129.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gX9k6YOfClC0Osw4css+NkePxQh7Ktfi7oEh6QcJ8iI3H+Hqy7enB2eXJB6AjncJ2RQdvVA4tBA6LdgNBS37vVQ4qHCvNsBFB0r3tzs8qAh7fYLWKMC9gFljZ9sCEgbSM+vbrW7wYuYcpslZsv9dw+dwgO3i0J3+8SucCiccMwycoFp1KuikF15ez4hMKuuozM9UmNJyJr1HOIWpCCCHJC+AAivJAF8ZpGlwNxBkOGP3Vaw7+i5dzb5hUZJoyu5SWZxJwNLrykLLS1S08MyNh7QeAq/YzoJo2FooeFkPelaWvYPTcIiV1HILx2Vahy7tnSbWc20GbLRhD0ySVwO8xWWnEFr1llGKiXGWetXT27g4YMR6xzh6TnMmqOrRuS7zcDwSaxnFvv8x8nGaku+TFVCl4LHpEZukkGB7bj/F75TBmCHsKFf3mtJeiHLcfUIO6zCBqIcrQjTgdcrnULtynPyseihn2WiQHQGkhNT52XFeQukgU6XL623r46+L7hGcmsxCKdh629t64g9ebJCOAzmCPw4OFY2uHOM7oJBBybPpi2W2MNO8hL9Vyjp7w6G2BtOFfddsBPRU3Uhl+TGbnuPmeoIa2mfESBEcxi0cvSeEHxXu+iTHELsdAAgeqtrekkMC6UYy8Op5D7C+t9F9SrhZdBOS/5N4hMwshu08wlfSAmOZ8sAQ2V2MCOnAaYMVhYOB4UsZrxRswhycvxEW4r7JpUvykwfoPOaVjz8B0trnSXr5sjXBuyZ9l/35iZRzpokH49WKP4RcSHIJRi+ZU4MiVvk9DFbNbQ4L6m8sotw2870qExtdqKtgIdBdGamI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(31686004)(31696002)(83380400001)(6666004)(86362001)(186003)(966005)(38350700002)(38100700002)(4326008)(36756003)(2906002)(2616005)(44832011)(54906003)(66556008)(52116002)(16576012)(66946007)(6486002)(316002)(956004)(8936002)(53546011)(8676002)(6916009)(66476007)(26005)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1h1K1V4THNhdlJTbU9RZjhZbmo3M011VGNZVmkyWHdFRk9BSmFxVWZubU9D?=
 =?utf-8?B?Y2MvSHl2Y05aanp5UkVPOEpxZHdWbEQ3U1pQbzlyRTI1aDRDNnMvUDd2Yml0?=
 =?utf-8?B?cjE4RUFlQ01QQjZ4emVTLzVmL1FsbkRBdkFtY3daZlUyeTdpVks2SkFIa1h1?=
 =?utf-8?B?YmFnbm94QTZ0alBhZ3RNTGtzNi9ieUV0UllwUkFIUUkvR3NGUGtNVnRENmJx?=
 =?utf-8?B?OUhmdWN4TDI3ZUdhSlp6eXJ6QnBXa0dkOGpudXdTMUVmeUNHQ0RIcEg2RVlN?=
 =?utf-8?B?cnBTUFNjbTVpVTJNVDBrd2Q2M3NFbm9kYzJkQ3lVSmc3b0h0NWlUUVRMZG1z?=
 =?utf-8?B?djRmZXl6R1RsS0dtQ1BlVlQ0SzhOem1xVWZUbW9WbEpLemJEUmkwNC9aRGZ6?=
 =?utf-8?B?SitZRGpKV2tYdzcyeDVBUzRKTVVWRFZMVC9GS1oraVpGL3FmK3N3bXZYeUg4?=
 =?utf-8?B?TjZLWGRYK0lwMllNdi9hL0tmY0ZKcW1NdUFQdTl0Ylk1MVZ3NUZxYkQ0Z3pF?=
 =?utf-8?B?a1ZkNkdpNnpldlBpa1BzYnhvMVUrUGlOZFdTaWlJK2dERlhjQjdETm9kUEl0?=
 =?utf-8?B?ZEkveEZyZUxKd2cvSTZKZC9OekJHWlZpaDJ0TkhSY3VDR0VTcVFQblREMDZt?=
 =?utf-8?B?RTIrYkZQaStvUVFFYXU5SWFwR2NsSy92MTNUN0daNUdJOWxsVWk4ZC80Q0pw?=
 =?utf-8?B?M2EwNFVUTzFzMG10MktRLzNFbm1WZTJ5MVVzMksyTzZSME5HMWZnMzB5SGph?=
 =?utf-8?B?bG0rNGxYQTFlMWZGNXFhenBIdzhhMGRON3d0WEgweis2SmJyREZzQlpUeGhy?=
 =?utf-8?B?dGRtWit6S3NqMDR1UWdKY3BKblNWR3hVNGE5d3hKUk5qditsWm8ySStjSzdX?=
 =?utf-8?B?eVpLNnhmTzdzNGFBVGJHK2lKVHBkaTFLUlROUXlFMm53ZWIxSU5Yd1B5MjlR?=
 =?utf-8?B?WlRIbi9CdU1ZS1puTWQvUTdGcjlLVWorU3V5bVo5MEQzTlhNd1lITHhrbk1p?=
 =?utf-8?B?Zk1KbzZGU2tkOG5XMTY4ZXhLMnRnc0c0RTJpYWRoZmV2VFVOU1Y0T2t2Tk5v?=
 =?utf-8?B?L21mblcrN1lHQVdTTitOZ25GY3YvYzdvTDgrckg4T09pblVBZ1ZDTHVmVm1F?=
 =?utf-8?B?bUc4SUZ3OE1raGxkM0Jyb1drK3hMemVqbGlyMWxxbk45cGJOeXNmSVh0Nkk5?=
 =?utf-8?B?NGRzNklZLzFRdW9tcGNRRkg5V2s4OHRlZlkweGxYYVJweFlWSzNOMGJmcnZX?=
 =?utf-8?B?UkVMUjZscnhydDI4MC9JOHhpSU56TlBOQ3NjZVl1YXFNM3dHdFlOOThwOXh2?=
 =?utf-8?B?S0QwNm02c0NPa0NaaFpheVc2M1g0OWpyeUhXeEh6YnBiQmI4NWc3b3RHMnMw?=
 =?utf-8?B?cUtwZE4vamVHS3E3bjFPNFhNN05DTFBLUTFObnZNWmZzS0N5V1NhQ0RJZ1d2?=
 =?utf-8?B?dGhSelhkSXJLbFlOWGVzVE5DdFJTVm5rLzB0Q0RQdE1oMU03ZGo5QWJqbzEv?=
 =?utf-8?B?UDQ1eUkzaDlGUVdZdDRiSGVBOXk1d3d0UFd4VGN3K1diUjQ5bkMxQ1JVQVA3?=
 =?utf-8?B?WGUxbHgxMGRSZ3JXbnFWRTFadmdMcnNnRkdMTUwyRmJ4MWp0a3lYcGtYK0kw?=
 =?utf-8?B?dDY2Sll4S2tNbTFPMGRRSUhaMGh4cFllbTlsQlduaTU3WnlZVkRsTWxGdytt?=
 =?utf-8?B?NVVDU0U1TkVpWDk4RlpuMzRUU0c2SnhkczNZRmZ1UDZkdEY1TzdOWFNubXhJ?=
 =?utf-8?Q?q8l+VfcPJRE79fmg6wXa+t6EHLX4vALNqoJq0lc?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576b7eb5-db49-48df-869a-08d9885630cb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 23:16:41.7993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNwOmnPpczkPbX35hy8prkfdj4HtsF3EC3+Br3YKnp1odq1fVrQtanNUAYPihNvUAeNxPMXACrpnRm5TrzkieQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/21 6:17 PM, Russell King (Oracle) wrote:
> On Tue, Oct 05, 2021 at 04:38:23PM -0400, Sean Anderson wrote:
>> There is a level shifter. Between the shifter and the SoC there were
>> 1.8k (!) pull-ups, and between the shifter and the SFP there were 10k
>> pull-ups. I tried replacing the pull-ups between the SoC and the shifter
>> with 10k pull-ups, but noticed no difference. I have also noticed no
>> issues accessing the EEPROM, and I have not noticed any difference
>> accessing other registers (see below). Additionally, this same error is
>> "present" already in xgbe_phy_finisar_phy_quirks(), as noted in the
>> commit message.
>
> Hmm, thanks for checking. So it's something "weird" that this module
> is doing.
>
> As I say, the 88E1111 has a native I2C mode, it sounds like they're not
> using it but have their own, seemingly broken, protocol conversion from
> the I2C bus to MDIO. I've opened and traced the I2C connections on this
> module - they only go to an EEPROM and the 88E1111, so we know this is
> a "genuine" 88E1111 in I2C mode we are talking to.

Well, I had a look inside mine and it had a "Custom Code/Die Revision"
of B2. Nothing else unusual. Just the PHY, magnetics, EEPROM, crystal,
and a regulator.

>> First, reading two bytes at a time
>> 	$ i2ctransfer -y 2 w1@0x56 2 r2
>> 	0x01 0xff
>> This behavior is repeatable
>> 	$ i2ctransfer -y 2 w1@0x56 2 r2
>> 	0x01 0xff
>> Now, reading one byte at a time
>> 	$ i2ctransfer -y 2 w1@0x56 2 r1
>> 	0x01
>> A second write/single read gets us the first byte again.
>> 	$ i2ctransfer -y 2 w1@0x56 2 r1
>> 	0x41
>
> I think you mean you get the other half of the first word.

Yes.

> When I try this with a 88E1111 directly connected to the I2C bus, I
> get:
>
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r2
> 0x01 0x41
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r2
> 0x01 0x41
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r1
> 0x01
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r1
> 0x01
>
> So a completely different behaviour. Continuing...
>
>> And doing it for a third time gets us the first byte again.
>> 	$ i2ctransfer -y 2 w1@0x56 2 r1
>> 	0x01
>> If we start another one-byte read without writing the address, we get
>> the second byte
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0x41
>
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r1
> 0x01
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
>
> Again, different behaviour.
>
>> And continuing this pattern, we get the next byte.
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0x0c
>> This can be repeated indefinitely
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0xc2
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0x0c
>
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x41
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
>
> Here we eventually start toggling between the high and low bytes of
> the word.
>
>> But stopping in the "middle" of a register fails
>> 	$ i2ctransfer -y 2 w1@0x56 2 r1
>> 	Error: Sending messages failed: Input/output error
>
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r1
> 0x01
>
> No error for me.
>
>> We don't have to immediately read a byte:
>> 	$ i2ctransfer -y 2 w1@0x56 2
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0x01
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0x41
>
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
>
> Again, no toggling between high/low bytes of the word.
>
>> We can read two bytes indefinitely after "priming the pump"
>> 	$ i2ctransfer -y 2 w1@0x56 2 r1
>> 	0x01
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0x41
>> 	$ i2ctransfer -y 2 r2@0x56
>> 	0x0c 0xc2
>> 	$ i2ctransfer -y 2 r2@0x56
>> 	0x0c 0x01
>> 	$ i2ctransfer -y 2 r2@0x56
>> 	0x00 0x00
>> 	$ i2ctransfer -y 2 r2@0x56
>> 	0x00 0x04
>> 	$ i2ctransfer -y 2 r2@0x56
>> 	0x20 0x01
>> 	$ i2ctransfer -y 2 r2@0x56
>> 	0x00 0x00
>
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
> root@clearfog21:~# i2ctransfer -y 1 r2@0x56
> 0x01 0x41
> root@clearfog21:~# i2ctransfer -y 1 r2@0x56
> 0x01 0x41
> root@clearfog21:~# i2ctransfer -y 1 r2@0x56
> 0x01 0x41
> root@clearfog21:~# i2ctransfer -y 1 r2@0x56
> 0x01 0x41
> root@clearfog21:~# i2ctransfer -y 1 r2@0x56
> 0x01 0x41
> root@clearfog21:~# i2ctransfer -y 1 r2@0x56
> 0x01 0x41
>
> No auto-increment of the register.
>
>> But more than that "runs out"
>> 	$ i2ctransfer -y 2 w1@0x56 2 r1
>> 	0x01
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0x41
>> 	$ i2ctransfer -y 2 r4@0x56
>> 	0x0c 0xc2 0x0c 0x01
>> 	$ i2ctransfer -y 2 r4@0x56
>> 	0x00 0x00 0x00 0x04
>> 	$ i2ctransfer -y 2 r4@0x56
>> 	0x20 0x01 0xff 0xff
>> 	$ i2ctransfer -y 2 r4@0x56
>> 	0x01 0xff 0xff 0xff
>
> root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
> root@clearfog21:~# i2ctransfer -y 1 r1@0x56
> 0x01
> root@clearfog21:~# i2ctransfer -y 1 r4@0x56
> 0x01 0x41 0x0c 0xc2
> root@clearfog21:~# i2ctransfer -y 1 r4@0x56
> 0x01 0x41 0x0c 0xc2
> root@clearfog21:~# i2ctransfer -y 1 r4@0x56
> 0x01 0x41 0x0c 0xc2
> root@clearfog21:~# i2ctransfer -y 1 r4@0x56
> 0x01 0x41 0x0c 0xc2
>
>> However, the above multi-byte reads only works when starting at register
>> 2 or greater.
>> 	$ i2ctransfer -y 2 w1@0x56 0 r1
>> 	0x01
>> 	$ i2ctransfer -y 2 r1@0x56
>> 	0x40
>> 	$ i2ctransfer -y 2 r2@0x56
>> 	0x01 0xff
>>
>> Based on the above session, I believe that it may be best to treat this
>> phy as having an autoincrementing register address which must be read
>> one byte at a time, in multiples of two bytes. I think that existing SFP
>> phys may compatible with this, but unfortunately I do not have any on
>> hand to test with.
>
> Sadly, according to my results above, I think your module is doing
> something strange with the 88E1111.
>
> You say that it's Finisar, but I can only find this module in
> Fiberstore's website: https://www.fs.com/uk/products/20057.html
> Fiberstore commonly use "FS" in the vendor field.

So you are correct. I had seen the xgbe fixup for the same phy_id and
assumed that FS meant the same thing in both cases. You may also notice
that nowhere on their site do they spell out their name.

> You have me wondering what they've done to this PHY to make it respond
> in the way you are seeing.

You may notice on their site that there are different "compatible"
options for e.g. "FS", "Dell", "Cisco", and around 50 other
manufacturers. I wonder if I've come across a module which supports
autoincrementing byte reads in order to be compatible with some
manufacturer's hardware. And perhaps this change has inadvertently
broken the two-byte read capability, but only for the first 3 registers.

--Sean
