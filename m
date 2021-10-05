Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907A842322E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhJEUkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:40:22 -0400
Received: from mail-am6eur05on2072.outbound.protection.outlook.com ([40.107.22.72]:31104
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235134AbhJEUkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 16:40:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tx+vaRPaajaA5hPovF3diquVpfn9otxs/hnJNGLYKx1OH2Sp8xQlOnJ/uhjPYF6vIEzPdRUmtR4gu4IM5G8EdR95E5Om5Bor+cbJger/83kHXY9CWHujxUYZbJmHgyaYlxlUvDhu1rKdIFTsxLmvkpxSIAToc3vU5Xi/RoZBUIwQQFzpca/dOUIvvt2dpwYPr+2NQEo0IAWGqySYlZa1A5gqGuLLRWGi4sBvg+0zTlqD/ghaR/E9RHb3I3GM2uSNa7Ilij2uX+I+q71emd5xI5mpfW2V4sBRdSthnTlNQZuu6aNYoSD9Nt+mHweKRVuVN90nJwAR7nWdqoso6pyM+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kthHAm4d2A/grWTxyqOtV1Pe0DY6HJqaqqsW2+nj0hk=;
 b=kNIpQ9YaKKv97fuEqkJX5q/MM4LLWrmWnmVBy145zPtOqXXRcGJS9L6FbhC3/gKVyL6v3mZeKVqHALFzpyi98bBTZrMz0gPhoWXqtaLhyPzEPrevR/UowdJfUMZ/I0JQ6QR3FKjIZjk1T9HrfFQljYA+e14wIKgs5BlevzZVZ/GCBXt/ZCp4oqT3HJU4r5zV9LgjUUxic+9N4Rdy6flMgCgAdIbkfBJbBBZKfg792fhCkHZNTCr83I6Vk2Sd6X9xjZ0ZM05VqmiCk2KO5peKLyuJFHvf1NKVSVzs0/J9C/M20U0kKDoJXDqbK57PqS7D22SkV6w0LG5QN2L8IeOE3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kthHAm4d2A/grWTxyqOtV1Pe0DY6HJqaqqsW2+nj0hk=;
 b=slikGWIiEVLWmYj1XWR8JM3rkMdSvSZ+4+++hXN1hw38FUCCbWA3IFMinARYtTkOf0PD/S3sU+NSEPI6ODPdgH+vRW/ycVQKrLp/h5IPHeiz8fEayQPd+Z4OlZBB6MInxDxOmwE1JmqMX6p+CxX7dbqrjg1v30l8biYaORCtCKQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0301MB2439.eurprd03.prod.outlook.com (2603:10a6:4:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 20:38:28 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 20:38:27 +0000
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
Message-ID: <55f6cec4-2497-45a4-cb1a-3edafa7d80d3@seco.com>
Date:   Tue, 5 Oct 2021 16:38:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVyjj64t2K7YOiM+@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:208:32e::35) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BLAPR03CA0150.namprd03.prod.outlook.com (2603:10b6:208:32e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Tue, 5 Oct 2021 20:38:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e948cc99-4ede-4fc6-1e91-08d9884015e4
X-MS-TrafficTypeDiagnostic: DB6PR0301MB2439:
X-Microsoft-Antispam-PRVS: <DB6PR0301MB243987CA8605D862E0D3DDAC96AF9@DB6PR0301MB2439.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nrwcRS2tCDEDlfBYwWItcoYaP4VdSAyjz09cy3P37TjIDVfOQmji+Hpq6ob5slx6q3ASC5ZvmPFJu2xhtv785u7sz++mxTN2mSHM+w96ddhtTsbefAqwuQE+Nv/Al/iwUwEYJ2Mywo/o8jVwUqGAkUFvjKglgvrLmsHYN0ThUw6KZq0vUiVLZ2puaYYiR7tqXDZ0WM2OgvFTzg3PU3+mmHkUnvCmAPha6vufC3Y1oceBoSC8OKn3x/ILvEzAMJsHdKGLdInoEy3W8qk9/o2/DRvCWESzFxD7Kj67PQkfe5zMPXAjoZHGrm8NY4ESsVTYBOVoUyAWq4r9Izj/uYQBtulCh7bJ8KCKvMsKT9WFIUYIGKT5Dcgsg9+4TR4EZwHpmskNuSrfN0BXbDxy+k3akrz09cPfV8Oht7cVDmxu7ZHAB5ZAPwPnvjMu09Q5eNUZayR9nULDntvxI8z925ehoI7PJEtKar3+dC4ErlY1YJkSAS6wSO0q7zM3rQUY2e3SEhvc43xMYWO2qINgbfiFPoR3aUvxWby2WiPAUsrSV5WqIY8qjB5yfth7oi1S8rzTTxbVxW4Q/0Fz3fSSEocjK9tft9XAJVcgml72aPDv89xdEocD0z4rFiZY9JIC5i7IIu9YL5lxtNkwZaBvhOoAhorl2cH1xQ83HRrFYJIs6vhlHgA+s6EV6u5CkTMg77+2cZu98ogLXFQQ7WujUm2mtz/aIXc8SmPmSCtHRDFfgVLbifpCayUdsY4idI2wY9HebcVtBfrVEBVm2PCzdDpaTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(186003)(31686004)(8936002)(31696002)(956004)(83380400001)(2906002)(66476007)(6666004)(508600001)(5660300002)(66946007)(66556008)(36756003)(44832011)(86362001)(52116002)(26005)(2616005)(38350700002)(6916009)(54906003)(316002)(38100700002)(6486002)(4326008)(16576012)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zi9EY1pYUSsrUkpQWjlrY2Z4NXk5Y0xRaVRVWHg2WURuSWlncjE3emRVU3cz?=
 =?utf-8?B?Z09hRkRESUhmNGkwQ2NjU3ltK0p5T3QrczYzaWUreXFWaWsyU0VzVVF1Y0hr?=
 =?utf-8?B?NFRIN1RheVFMRUFCbG9uME5mSEpCMDVHRjhqTDM4bVlMRXNvaTh0QWowblhO?=
 =?utf-8?B?cm5Tc1dlWkE2WjhsVldUOUs3M1ZBaW5TTythM1pidjBIRGllYmwrMEpzOHcy?=
 =?utf-8?B?NTlTRkt5MllKZXBIVjB3NUJjb0pqeCt1am0yUUlHZmovT2QvN0NWNncyZ3Yx?=
 =?utf-8?B?OU1xS0VJSm1qZ0tZbE04bXJzUzhveW5VcHpBUmhNRE1MdFV5MXVYRDE2Mm1t?=
 =?utf-8?B?SU93YWxaZWZaUGxHbmFvWXY0VXM1VW9FMG1hRWMrZ2NzQzRITExvb3BlMVM2?=
 =?utf-8?B?ajdlTTFhYzhkNzF1Mit0cG5kTkZFMi8ydEdXNUJVZHlFWjlPTzdwK2lHa2pB?=
 =?utf-8?B?dmkwQVFMWldoalZwbUw5ZUgrWFMvc3RQcjlmZkEweSsrdTNUa1lJU0JkRzhz?=
 =?utf-8?B?STAvbkxXRFVIQTRFakhJWnJJbXQ3K0JrdlFqOVpGcXQvUFE5aGhNd3NOc1BI?=
 =?utf-8?B?c2tsRlptNEg4ZEJkR2FJejVDZ1VhUEFDTTVqeldQbW9pRHhRVVVieWpRbmRz?=
 =?utf-8?B?RlpRT1dhMXRaelF6VHpQbTlmT05yRWl1TVZ5eGVoakFOTVRaYmZ4eEExWnd6?=
 =?utf-8?B?d2o5UlNKTVJZMDlWWUo3NVBaNEdWSWRjMDRzejFCd05LZ1AvZlplY2lJUDM5?=
 =?utf-8?B?OTFHeDVpcXk3a1Y2Qk93QjJsMU52bFRQQmMxOVdJM1NHc2srd0cwdE8zMlNo?=
 =?utf-8?B?OXhLM1c4TW11bTBCN2Exd0hodHhOWEFRKytVelFyNHF3MDdWS0VXWER4NENE?=
 =?utf-8?B?anoxSGlkcHk3R3NrQXROT2hvL0NHMC9UOG9Ydzd2WkVWd2x2MXZBbDhxNVc0?=
 =?utf-8?B?LzFIREc2ekQyNCtyY0dNMmVmZVBRTW1IRitUeTNPMGloNGd0MXAvV25DdkVl?=
 =?utf-8?B?ZEtTVXptY2FqWE1ERVorWndPUEhWWmEzVUQxNmZRcWF2OHlMMXQzcXRSbCsy?=
 =?utf-8?B?WWxhVXc4K1FhK0xSRUQ5ckNXVCtNWU5SekxxSW1zdUpqMm9yTzFMWXFnUkh1?=
 =?utf-8?B?Z2V0dEdORnN2S25FS2JoRlhhS0hxV0xnVitnQTdLZTg1VW9DaUxhSU1ya0ds?=
 =?utf-8?B?ZnpWN3RSTFBsRHB0dWxETnBJVER1TlZmMEk0d05KTU42amJPSW51ejB0a0lG?=
 =?utf-8?B?dEdCeS8xOFBNdVhNdFpueWx1MEE4MzlCWWtNTUFQSEF3QktJOGlaQ3c3bUNk?=
 =?utf-8?B?M25UeEo4NWs3VUc3L1ljQ3JMckNrbWNGdWh6TWNXMnZ0T29adTMreHp3QUhH?=
 =?utf-8?B?VFNEekdSc1c3akFqSWdWVHBVcCsvbTJNRlJDalVHejZCU3lDSHVsdjRpdUFw?=
 =?utf-8?B?Z21ocGxHb0NlOVdEQThLQm1FeWRwV2hpaVdGVkpnMFo4emJWUWJSd0U1MXBE?=
 =?utf-8?B?WHZGWWZ3MWlya2xabm0wWGpjY3pVb1ljQ2NQMjU0YmxEcGIyMHMzTjlXVkph?=
 =?utf-8?B?ejZtTHUwQnM0MitFYkhsdFhnMmFHT0F3dEIra21hUTRlRjlCaWVvR2g2SkJM?=
 =?utf-8?B?TklNeHVlblE2dGptUmE2T3Y3dEZXbnAxdm8xcmxXeE8vVmhnc2V5UnE3Ym9Y?=
 =?utf-8?B?b0pEWndIbk1IN1ZHdUhkNUEzS1FLaVFlUnUvQU9SMWw2SGF5dTlLYi9TeVE2?=
 =?utf-8?Q?qDB8vN1cvRdjLerDWytebB4gnoCrKmT2sLV4CAF?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e948cc99-4ede-4fc6-1e91-08d9884015e4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 20:38:27.8128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vc7BPESB+9vIgzvLzvpOi/0bkBsxbwJfde0NQzLJ/MFDmCZXW9FpO7h6r2C1MhEkbZrTqn/SP2hCiNjIguw/jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2439
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/21 3:12 PM, Russell King (Oracle) wrote:
> On Tue, Oct 05, 2021 at 12:45:28PM -0400, Sean Anderson wrote:
>>
>>
>> On 10/5/21 6:33 AM, Russell King (Oracle) wrote:
>> > On Mon, Oct 04, 2021 at 03:15:27PM -0400, Sean Anderson wrote:
>> > > Some modules have something at SFP_PHY_ADDR which isn't a PHY. If we try to
>> > > probe it, we might attach genphy anyway if addresses 2 and 3 return
>> > > something other than all 1s. To avoid this, add a quirk for these modules
>> > > so that we do not probe their PHY.
>> > >
>> > > The particular module in this case is a Finisar SFP-GB-GE-T. This module is
>> > > also worked around in xgbe_phy_finisar_phy_quirks() by setting the support
>> > > manually. However, I do not believe that it has a PHY in the first place:
>> > >
>> > > $ i2cdump -y -r 0-31 $BUS 0x56 w
>> > >      0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
>> > > 00: ff01 ff01 ff01 c20c 010c 01c0 0f00 0120
>> > > 08: fc48 000e ff78 0000 0000 0000 0000 00f0
>> > > 10: 7800 00bc 0000 401c 680c 0300 0000 0000
>> > > 18: ff41 0000 0a00 8890 0000 0000 0000 0000
>> >
>> > Actually, I think that is a PHY. It's byteswapped (which is normal using
>> > i2cdump in this way).The real contents of the registers are:
>> >
>> > 00: 01ff 01ff 01ff 0cc2 0c01 c001 000f 2001
>> > 08: 48fc 0e00 78ff 0000 0000 0000 0000 f000
>> > 10: 0078 bc00 0000 1c40 0c68 0003 0000 0000
>> > 18: 41ff 0000 000a 9088 0000 0000 0000 0000
>>
>> Ah, thanks for catching this.
>>
>> > It's advertising pause + asym pause, 1000BASE-T FD, link partner is also
>> > advertising 1000BASE-T FD but no pause abilities.
>> >
>> > When comparing this with a Marvell 88e1111:
>> >
>> > 00: 1140 7949 0141 0cc2 05e1 0000 0004 2001
>> > 08: 0000 0e00 4000 0000 0000 0000 0000 f000
>> > 10: 0078 8100 0000 0040 0568 0000 0000 0000
>> > 18: 4100 0000 0002 8084 0000 0000 0000 0000
>> >
>> > It looks remarkably similar. However, The first few reads seem to be
>> > corrupted with 0x01ff. It may be that the module is slow to allow the
>> > PHY to start responding - we've had similar with Champion One SFPs.
>>
>> Do you have an an example of how to work around this? Even reading one
>> register at a time I still get the bogus 0x01ff. Reading bytewise, a
>> reasonable-looking upper byte is returned every other read, but the
>> lower byte is 0xff every time.
>
> I think the Champion One modules just don't respond to the I2C
> transactions, so we keep retrying for a while. We try every
> 50ms for 12 retries, which seems to be long enough for their
> modules.
>
>> > It looks like it's a Marvell 88e1111. The register at 0x11 is the
>> > Marvell status register, and 0xbc00 indicates 1000Mbit, FD, AN
>> > resolved, link up which agrees with what's in the various other
>> > registers.
>>
>> That matches some supplemental info on the manufacturer's website
>> (which was frustratingly not associated with the model number of
>> this particular module).
>
> The interesting thing is, many modules use 88e1111, which is about
> the only PHY that I'm aware that supports I2C access mode natively.
> So, it's really surprising that you're getting corrupted data,
> unless...
>
> There's been a history of using too strong pull-ups on the SFP I2C
> lines. The SFP MSA gives a minimum value of the resistors (4.7k).
> SFP+ lowers the minimum value and raises the maximum clock frequency.
> Some SFP modules are unable to drive the I2C bus low against the
> lower resistances resulting in corrupted data (or worse, it can
> corrupt the EEPROMs.)

There is a level shifter. Between the shifter and the SoC there were
1.8k (!) pull-ups, and between the shifter and the SFP there were 10k
pull-ups. I tried replacing the pull-ups between the SoC and the shifter
with 10k pull-ups, but noticed no difference. I have also noticed no
issues accessing the EEPROM, and I have not noticed any difference
accessing other registers (see below). Additionally, this same error is
"present" already in xgbe_phy_finisar_phy_quirks(), as noted in the
commit message.

> Other problems on some platforms have been with I2C level shifters
> locking up, but that doesn't look like what's happening here - they
> lockup at logic low not logic high. Even so-called "impossible to
> lockup" level shifters have locked up despite their manufacturer
> stating that it is impossible.
>
> Is it always the same addresses?

Yes.

> What if you read from a different offset?

Same thing.

> What if you re-read after it seems to have cleared?

Here are some various transfers which hopefully will clarify the
behavior:

First, reading two bytes at a time
	$ i2ctransfer -y 2 w1@0x56 2 r2
	0x01 0xff
This behavior is repeatable
	$ i2ctransfer -y 2 w1@0x56 2 r2
	0x01 0xff
Now, reading one byte at a time
	$ i2ctransfer -y 2 w1@0x56 2 r1
	0x01
A second write/single read gets us the first byte again.
	$ i2ctransfer -y 2 w1@0x56 2 r1
	0x41
And doing it for a third time gets us the first byte again.
	$ i2ctransfer -y 2 w1@0x56 2 r1
	0x01
If we start another one-byte read without writing the address, we get
the second byte
	$ i2ctransfer -y 2 r1@0x56
	0x41
And continuing this pattern, we get the next byte.
	$ i2ctransfer -y 2 r1@0x56
	0x0c
This can be repeated indefinitely
	$ i2ctransfer -y 2 r1@0x56
	0xc2
	$ i2ctransfer -y 2 r1@0x56
	0x0c
But stopping in the "middle" of a register fails
	$ i2ctransfer -y 2 w1@0x56 2 r1
	Error: Sending messages failed: Input/output error
We don't have to immediately read a byte:
	$ i2ctransfer -y 2 w1@0x56 2
	$ i2ctransfer -y 2 r1@0x56
	0x01
	$ i2ctransfer -y 2 r1@0x56
	0x41
We can read two bytes indefinitely after "priming the pump"
	$ i2ctransfer -y 2 w1@0x56 2 r1
	0x01
	$ i2ctransfer -y 2 r1@0x56
	0x41
	$ i2ctransfer -y 2 r2@0x56
	0x0c 0xc2
	$ i2ctransfer -y 2 r2@0x56
	0x0c 0x01
	$ i2ctransfer -y 2 r2@0x56
	0x00 0x00
	$ i2ctransfer -y 2 r2@0x56
	0x00 0x04
	$ i2ctransfer -y 2 r2@0x56
	0x20 0x01
	$ i2ctransfer -y 2 r2@0x56
	0x00 0x00
But more than that "runs out"
	$ i2ctransfer -y 2 w1@0x56 2 r1
	0x01
	$ i2ctransfer -y 2 r1@0x56
	0x41
	$ i2ctransfer -y 2 r4@0x56
	0x0c 0xc2 0x0c 0x01
	$ i2ctransfer -y 2 r4@0x56
	0x00 0x00 0x00 0x04
	$ i2ctransfer -y 2 r4@0x56
	0x20 0x01 0xff 0xff
	$ i2ctransfer -y 2 r4@0x56
	0x01 0xff 0xff 0xff
However, the above multi-byte reads only works when starting at register
2 or greater.
	$ i2ctransfer -y 2 w1@0x56 0 r1
	0x01
	$ i2ctransfer -y 2 r1@0x56
	0x40
	$ i2ctransfer -y 2 r2@0x56
	0x01 0xff

Based on the above session, I believe that it may be best to treat this
phy as having an autoincrementing register address which must be read
one byte at a time, in multiples of two bytes. I think that existing SFP
phys may compatible with this, but unfortunately I do not have any on
hand to test with.

--Sean
