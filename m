Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769FE422FB9
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhJESMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:12:18 -0400
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:64261
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234144AbhJESMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 14:12:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCzwxSl7np2sj4QBzlwvezwCj5e5LnYQkAEYcxYdI1LX/hZLa+1czAfxOYjNAD4kdt4disF0a034ynnbGCFyD54jJdJZopAkzTU609R1HPNKuHnTw3r4oxVxcQk16kb7MoUMx/jKzXme3IQuFlcRek6ghOExLGP0Gpuxw7PQuYmUQCl3SbJrtVgc3jfbUQ/Wsdhb2q30NILjsPykwf4CmvFZSveLZ12vdjCFEjkh/lYBdeizws5a8GWXtm4WTEzTgEQiFE1oIUd3rAomIqO+Rm/6AELnIjq5QmKvZmwxPrqtMwRU6an9RQ1n/Dw0nw/3VFO1MXbPEftcB2NX4IsFiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QawOZVNIBrFftuQFB8L18/OZRRUwvX7yi/2qfclNBDQ=;
 b=R3YWOBu8WFrjPM/uIOSGURemNTHA5ik0jgEGafLsqh82Q8a0EhYnp38obF4dFYM3gl0eTRBD6PWe+KRmuFrfo4JL03HrQf4PtCdDp6hsNpPvhTcgH0HSAlS+hLnl2MW6M2b6TCuCnUqHqoUkgdw/OO7xdvDc25b95/tDXPnZI9KvdOEz/BPzMKZsDYIvEDGytc6SY0fPbmVig0MRVov0x5pGzrZYdl+miSG8TVNOdpBujX1cowXOw2cWpaLLyOIBwmMwcwiM+4Lo++HfBIGhG5hEuqjfffAT22qOtZWtQc8RXfcyTmF6PHvQZz/TtRuEu3E705kwxJYqqH/mLYMscQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QawOZVNIBrFftuQFB8L18/OZRRUwvX7yi/2qfclNBDQ=;
 b=TkiWbHx8Qm/siJ+jeNl7ao9GiQchDYzLnhZssSO0kPNEf587Qq/4rwVQ4rO+qTMdWY+3sJBnC2jdI1vkiwIEu+2lfn5f0AyHnbAoinVGU/CMoRumu+rO78y5MW20XCJeGWxCtqGqylRyV+tOjeo3iX3PSY7cOi7/8ZCVKzBltnM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5366.eurprd03.prod.outlook.com (2603:10a6:10:f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 18:10:21 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 18:10:21 +0000
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
Message-ID: <83797503-6459-c589-f7e5-63a4d83610cf@seco.com>
Date:   Tue, 5 Oct 2021 14:10:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <66fd0680-a56b-a211-5f3e-ac7498f1ff9b@seco.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::17) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Tue, 5 Oct 2021 18:10:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbb75bff-0bf0-484d-a227-08d9882b6577
X-MS-TrafficTypeDiagnostic: DBBPR03MB5366:
X-Microsoft-Antispam-PRVS: <DBBPR03MB5366A433188D94F77CDC676596AF9@DBBPR03MB5366.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2AHtSstLw+32RFjEixWeLAiFCY5/NiU3kW604TxwUAlvCHh1uuhEUKMVDRckmaC4hpTsZRR/UpJSoIYi/gtc1t1jvILfC7GoAZjkhL6c1ER4c9dQKQQ0KEhYE9MAu3/CMPJRxCcVzpWePjETfAtuU60vIT49eeCSqwR91yqeYinaYmmaKK48Gcs3itZmA/K971E7ETv529Uk5uS+tuUhkEI2BpyqVLs4XVecF71VCyseFEoc0ThyLX4cfbS5BVcWHUqbLMuf/NCjxKYlYnydDLir2B4hB32LZJ3qfV7vkKn/NXMKRuDwbl7eBffaGWhQDJOpDbze4bqtCoFDUR5JkerYHn4RkD7P1KUDU1ALBBXsm5rbhSGNsQ1Ell07obgf8Np5+ogtFa8AQ6Y+WqCnOzYFb9jHpmhRdw9ATaYHUkPc9q+ZEuG++kl/zcmrojlnNFKhMDC0IRejYNEBJV+vLzWCxYEvSU5O5HfWlMAqer76XsK/nY/TglmfMxW9iwFFLGTYF7Zid9PaS66g1mEx/mngVJlmVyD5BKtOX4cuPpWTDdvakTwBxN2rk0mmdDQywJrZlAePtbghSFy2LV/laAQVzToFf8Ef2j3PtIo2YfH6TXU4pDaR4gGU/w/Hp42U+s+rF3zkEa6zlFIIIta+DF0yGQHq7WKQ2KR24Vs30rTXf1giFTv558JtfpXMRQcGB9UPTU4u/NcWnfzKWOmBVnFhJbM69xTyRmb90wOLXb4e9mMNkVC5WGUH9qf6rY10kL6F1xjHhWwOtAo10rm40Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(52116002)(508600001)(44832011)(16576012)(36756003)(8676002)(6916009)(2616005)(53546011)(316002)(8936002)(2906002)(66476007)(54906003)(956004)(6486002)(86362001)(31686004)(38100700002)(83380400001)(6666004)(38350700002)(31696002)(186003)(26005)(66946007)(66556008)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzZYMnpZZ2xGNjhxZHdlY3g4R25BRXdYSS8rZWd4R3lES0N4UndpanZsdFM2?=
 =?utf-8?B?em1ncWlrYlR0clBTcERuZmdTRWFVRWlkRC9Fak9NVWVEOU13R1Zja3p3bzN1?=
 =?utf-8?B?RDB2MlNwa0k3TmRYRGg3dXJtclVWZmxZTm83Q1dNQmxCeUVzWHFOTDdha1Rv?=
 =?utf-8?B?Z0VVeFdvN3FER0g3azJ5RVJwdklPZ0pNTTI1UGNUY2VvWXJ1VGhOYWtoRWds?=
 =?utf-8?B?NEVMZDIvL0xaOUJUMlU1OHdVa1I0K1NPOXFUV0RadTRQY3dJd1FhQlA3ckNO?=
 =?utf-8?B?cUNVK01HTStIS1BkaTNkSXV4U1JYd0pOczdzMkNBS1dYaTc1RTE2NGJDWDhC?=
 =?utf-8?B?QlZwb2hlMTFwWXdBUjdkdG54aXI0VGhXWGVPRDRQUlJvTUtSQVQwUG9QYXVG?=
 =?utf-8?B?M1R1RjBXUmlrczBLN2ZrKzhwWGNBdnpJSmt0eUFEUHhKWEVXeEdVOVJPeUNa?=
 =?utf-8?B?eWU4bFR5VGFvOGEwYXIxeFFkRHFuL0RyTWlJL1VIb0dUNHdXYm9jNFNtRllJ?=
 =?utf-8?B?eEM4SEJFaE45eHhRNlBzZ0Fya0JvQ0loeHc1bmRUZWNlNXhTTFUxVmkwRks5?=
 =?utf-8?B?eVBFc05uOHNuODJydkNpVHE2RGFQTXNnU0xzR01POHBlQVpNNWVNdzJtcVB5?=
 =?utf-8?B?Mm4yUnpmRWwvdUYyblZqd3NSSWNQcTdTRjRwRS92QUtmelF5TUVaSUdveS9J?=
 =?utf-8?B?UGpvM01tSUxKR0Y2UmE0VEZQK3huRGpFeXF6cFhNcnZjOEljRjF4NEhoZi9J?=
 =?utf-8?B?T1pxNFZaZmRybUR2djlrWWc2T0pRVk5yQk0rc3VhTzdQcWhMcGFCbXVVTVp4?=
 =?utf-8?B?QzU2WHUzSThLYkxJcWh1KzVJQWo5R0NTZlFneG84ZFQvSkMyRFNnTWZzSzFV?=
 =?utf-8?B?S3pzTW55VU9oZFltZkZQYVBrd0FncE4wVE1yRXRqR01JSVk0T1k5KzlvNllB?=
 =?utf-8?B?ckI4Qk10QWl4TXBrNCt5N0htRDd5Zi9vcVN4d0tQQ3NJY25Zemttb1VRM1ox?=
 =?utf-8?B?aTlIYUJQU3RSL1U3RkF2SnBCL1lLZU90S0lPc0RoNmRtZndaNVVBWEQ1cmZ2?=
 =?utf-8?B?Z0l2dG9mUURHUWlSdGdVMUd2RFU4V1dHMVZaVHZOcU9kNlI0VFhNTzFtSGI2?=
 =?utf-8?B?ZXRUaytsV0JpRnFCNHdjN1VOYkFnbzBnLysycVlxV1NPQjBEQzVPYXpJZHdx?=
 =?utf-8?B?VGZ1R0lsb0ZaMmRMWFpJNTd0eXQzVlRiWVZWYjBQOStSMHdtbUc0OXNoVHFn?=
 =?utf-8?B?emEybFhkaVdRaTExU3M0U2dRMlBzQ1EvVlFMbmZURGtlWnZCZkc5M2YrSCth?=
 =?utf-8?B?a2ZvQWFIS1hDT3locU5BYmtMRlhIV1d0S1JSSlgwTi9wSGFZVzcwWGJ1OFFT?=
 =?utf-8?B?WHh6dncyaEhXSkJKK202dFVjUFJVbE9oWmxHeS9yZjU4TG51NExCeXZCZ2I4?=
 =?utf-8?B?d2pwaHZOTmQzNzl1c2h0M2gwUktIMUFxb0JQWERkZFRkZG9yZE92c2ZFOGp6?=
 =?utf-8?B?Y0ZKTWgrQjV5N3dxSDlrSk5GQjVIMFRhRXNFRFd1blNEcjhZeS9OWVNUSGFq?=
 =?utf-8?B?MDBIUEM4Y0dXeXNPY1BlU1gybm1FMGUrNDdKT2gyaHl4QU9NNzV0Sk0wc1RO?=
 =?utf-8?B?YUpZeDdwbUFJVU53SEpFV1IxajVRcmFWdkhCSmtWYXl6VFhOcHVpeHBvSlBT?=
 =?utf-8?B?TlRqU0xKeXhJaUV1VWtIL2RBdFhFak5SeERLdEpMZTNCZXNNR0dMUHc3RzBD?=
 =?utf-8?Q?zh9iVrjeNnmr0qGrBwnQSRa7UeCAi+CGu9vQwlT?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb75bff-0bf0-484d-a227-08d9882b6577
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 18:10:21.7944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYqxjFxYRbwYNqNw4riXtD/oszW1Rw2riAh/uvHyVyVEA13CmeZhviNQV8KMcyibpiX5gI+PTnNwZ06AMsl2yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/21 12:45 PM, Sean Anderson wrote:
>
>
> On 10/5/21 6:33 AM, Russell King (Oracle) wrote:
>> On Mon, Oct 04, 2021 at 03:15:27PM -0400, Sean Anderson wrote:
>>> Some modules have something at SFP_PHY_ADDR which isn't a PHY. If we try to
>>> probe it, we might attach genphy anyway if addresses 2 and 3 return
>>> something other than all 1s. To avoid this, add a quirk for these modules
>>> so that we do not probe their PHY.
>>>
>>> The particular module in this case is a Finisar SFP-GB-GE-T. This module is
>>> also worked around in xgbe_phy_finisar_phy_quirks() by setting the support
>>> manually. However, I do not believe that it has a PHY in the first place:
>>>
>>> $ i2cdump -y -r 0-31 $BUS 0x56 w
>>>      0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
>>> 00: ff01 ff01 ff01 c20c 010c 01c0 0f00 0120
>>> 08: fc48 000e ff78 0000 0000 0000 0000 00f0
>>> 10: 7800 00bc 0000 401c 680c 0300 0000 0000
>>> 18: ff41 0000 0a00 8890 0000 0000 0000 0000
>>
>> Actually, I think that is a PHY. It's byteswapped (which is normal using
>> i2cdump in this way).The real contents of the registers are:
>>
>> 00: 01ff 01ff 01ff 0cc2 0c01 c001 000f 2001
>> 08: 48fc 0e00 78ff 0000 0000 0000 0000 f000
>> 10: 0078 bc00 0000 1c40 0c68 0003 0000 0000
>> 18: 41ff 0000 000a 9088 0000 0000 0000 0000
>
> Ah, thanks for catching this.
>
>> It's advertising pause + asym pause, 1000BASE-T FD, link partner is also
>> advertising 1000BASE-T FD but no pause abilities.
>>
>> When comparing this with a Marvell 88e1111:
>>
>> 00: 1140 7949 0141 0cc2 05e1 0000 0004 2001
>> 08: 0000 0e00 4000 0000 0000 0000 0000 f000
>> 10: 0078 8100 0000 0040 0568 0000 0000 0000
>> 18: 4100 0000 0002 8084 0000 0000 0000 0000
>>
>> It looks remarkably similar. However, The first few reads seem to be
>> corrupted with 0x01ff. It may be that the module is slow to allow the
>> PHY to start responding - we've had similar with Champion One SFPs.
>
> Do you have an an example of how to work around this? Even reading one
> register at a time I still get the bogus 0x01ff. Reading bytewise, a
> reasonable-looking upper byte is returned every other read, but the
> lower byte is 0xff every time.

Ok, upon further experimentation, I can read out something reasonable by using the "consecutive byte" mode

# i2cdump -y -r 0-0x3f 2 0x56 c
      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 01 40 01 6d 01 41 0c c2 0c 01 c5 e1 00 0d 20 01    ?@?m?A??????.? ?
10: 59 f9 0e 00 78 00 00 00 00 00 00 00 00 00 f0 00    Y??.x.........?.
20: 00 78 ac 40 00 00 00 00 0c 68 00 00 00 00 00 00    .x?@....?h......
30: 41 00 00 00 00 0a 90 88 00 00 00 00 00 00 00 00    A....???........

I believe this is just doing i2c_smbus_write_byte+i2c_smbus_read_byte

S Addr Wr [A] Phyaddr [A] P
S Addr Rd [A] [DataHigh] NA P
S Addr Rd [A] [DataLow] NA P

as opposed to i2c_smbus_read_word_data

S Addr Wr [A] Phyaddr [A]
S Addr Rd [A] [DataHigh] A [DataLow] NA P

or i2c_smbus_read_word_data

S Addr Wr [A] Phyaddr [A]
S Addr Rd [A] [DataHigh] NA P
S Addr Wr [A] Phyaddr [A]
S Addr Rd [A] [DataLow] NA P

So now I suppose the question is whether replacing the existing i2c
logic with something like

	i2c_smbus_write_byte(i2c, i2c_mii_phy_addr(phy_id));
	i2c_smbus_read_byte(i2c);
	i2c_smbus_read_byte(i2c);

will break everyone else's SFP phys. If it does, this could be difficult
to do as a quirk because the MII-I2C bus is created before we read the
SFP EEPROM.

--Sean
