Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502AF3071E7
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 09:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhA1Iqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:46:43 -0500
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:13664
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229785AbhA1IqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 03:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=topicbv.onmicrosoft.com; s=selector2-topicbv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nihGsWYiW1w2E27qYD7DOs2gYxz+FHQtC66z4OQsotc=;
 b=PUSiTfkFCpV1y1yz/c8tJOPt5tYvHSKdFsfc2KK+XISgzeZyQlh2/t25aXMw9pUyKwLndeDBUmb39+2QkWHHqS/k3lc/svQ6wt6uXctzJRIsT2gq011qcZTNX5YzHVWyCtxZmcZeyt+EAcWgM0HoL0qDA9JSzr2Umdy+cweRuRI=
Received: from AM6P191CA0074.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::15)
 by AM0PR04MB5604.eurprd04.prod.outlook.com (2603:10a6:208:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 28 Jan
 2021 08:45:49 +0000
Received: from VE1EUR01FT019.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::5e) by AM6P191CA0074.outlook.office365.com
 (2603:10a6:209:8a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend
 Transport; Thu, 28 Jan 2021 08:45:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.68.112.65)
 smtp.mailfrom=topicproducts.com; vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=topic.nl;
Received-SPF: Pass (protection.outlook.com: domain of topicproducts.com
 designates 40.68.112.65 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.68.112.65; helo=westeu12-emailsignatures-cloud.codetwo.com;
Received: from westeu12-emailsignatures-cloud.codetwo.com (40.68.112.65) by
 VE1EUR01FT019.mail.protection.outlook.com (10.152.2.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11 via Frontend Transport; Thu, 28 Jan 2021 08:45:45 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (104.47.17.109) by westeu12-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Thu, 28 Jan 2021 08:45:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCuXONj7vX7rg5whgF9LKcuZII3o7ZTnhHRIe//NSduTJXAfgEEUmvbRW57C76bFCRfUn6+pHJPXa8EEoeQcPdEpDPG3z3ILkCSrNJfmswb6/02xWAc80UxrtY6C6qPOsGHqfwZywqklTzKCOvUumssoj1tis33VLvVWTLl3QWBBLApKQ+g0lOAYNeqEqfE1YzjnmN6b4TUR4dP9qqCX6z/QRQsgF8Qg79R17Mmx+Zg1pIXgKhMcetr1dxpOGSU/C8w805PDkc2A3r6te869zx2ZKrVo5xlGpksD5r7VxEy/DRsLhR9spLCVHCh4Ku7OuOT6ozsVuecfhx5OITaR4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ofpb55ZYe5uztT/Gyj2gjoy2wTsly/VnLIoyKj73zsU=;
 b=LZgRU7kVPpj+AA2tXuYlFG10vpv2R99ouxxt+7TcIeGWjum6iPZtrTKLUDv8qJXq/BI+I20GZI36uGcbJC7eJHaHsecJxdPQZjd+OB3Xrll1lW5ponT0kt4SJXch91oVsN3nnFKDtkJAAqbTlTq2pfGd9PUCQQGVc95Iyayx1Rn0143ErlpiXZa+c90kGA4PAl5ZLWW3g+4W4DLE9M5LC0SxM+0pCDG27yilnnmHiD/cuToHGtB3Y7OYP+MBL2MOpNgeUMoqSDb3HRqPeYBkF+dAKkpygdyXl5uAHA2BtxZX3pTjc/wGiy5n4QJAJAmnzshU3ZExljn6rjXpGiqlgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=topicproducts.com; dmarc=pass action=none header.from=topic.nl;
 dkim=pass header.d=topic.nl; arc=none
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=topic.nl;
Received: from DB8PR04MB6523.eurprd04.prod.outlook.com (2603:10a6:10:10f::26)
 by DB8PR04MB5673.eurprd04.prod.outlook.com (2603:10a6:10:a6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 08:45:42 +0000
Received: from DB8PR04MB6523.eurprd04.prod.outlook.com
 ([fe80::792a:b2ef:ed50:a1a2]) by DB8PR04MB6523.eurprd04.prod.outlook.com
 ([fe80::792a:b2ef:ed50:a1a2%4]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 08:45:42 +0000
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
 <YBIZyWZNoQeJ7Bt4@lunn.ch>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.949ef384-8293-46b8-903f-40a477c056ae.7228ddf2-6794-42a0-8b0b-3821446cdb40@emailsignatures365.codetwo.com>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.0d2bd5fa-15cc-4b27-b94e-83614f9e5b38.7855d092-e2c3-4ba5-a029-2a0bbce637e1@emailsignatures365.codetwo.com>
From:   Mike Looijmans <mike.looijmans@topic.nl>
Organization: TOPIC
Message-ID: <956acc58-6ec8-c3d5-1310-7305c3b5a471@topic.nl>
Date:   Thu, 28 Jan 2021 09:45:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YBIZyWZNoQeJ7Bt4@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [81.173.50.109]
X-ClientProxiedBy: AM8P189CA0010.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::15) To DB8PR04MB6523.eurprd04.prod.outlook.com
 (2603:10a6:10:10f::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.80.121] (81.173.50.109) by AM8P189CA0010.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Thu, 28 Jan 2021 08:45:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36b091a1-68fb-4519-48c9-08d8c3691a6c
X-MS-TrafficTypeDiagnostic: DB8PR04MB5673:|AM0PR04MB5604:
X-Microsoft-Antispam-PRVS: <AM0PR04MB560405E0C28E7F74079E466196BA9@AM0PR04MB5604.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 1Fk3ZklZ6hEYks9UqTx7ylhETisGQuUztFJiFAO4fWVcpgWqhoAEaY8wt+WyvIkYC2lAd97Zr5Pj1O4rqqECHk3SMO77jU4z/3r/f74u3j+iBeJkPcITDw7dEzoMtOD9PwYf86wF7a8vE/1zXV61bRn9MNTscktaGKjj/Jc1NaKvOvBPeZGQ2taOhHSa7BqpyKRLgWiP+kkDJb125fUSb+2xn2g6GLUIjj2uD03ioDT7KcpzEsvhdaK66dtLOaKEVsxr14RSi2kENPZpomYGi6U+FHVb9UBIcS9RM/Xa8ns6VKZNIDdZd2j+FK6R6Z0qLw5rRWBhiwEplIIRla4wDv5SbqFfXTzD8mpC0+5GFguNMhDKYpmgwV5xBG0XpPAPU1z/RekA13omo3kcApD7+tOvvuBCTl+YOlARbn3lh3boIyT+eO6Ew6n0bpl7BWUFxIwd1nfsu6x1bwwn4opyI7eGP0eCIVh9FWTC06FGsecHN60A4WfLZNMFVykDUucrIq6aSSOMtVIAlfj2N+yuNoH444xMDYXfeXfoAapO3eos6yJ+n0uoA7NuT0KvQkOW8+hrrySie8yClH+w4E/yOzrmxYKDv2V91+KMhiIBakI=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6523.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(39830400003)(136003)(8676002)(6486002)(478600001)(6916009)(53546011)(5660300002)(4326008)(26005)(66476007)(66556008)(66946007)(31686004)(83380400001)(54906003)(52116002)(83170400001)(16576012)(36916002)(316002)(42882007)(36756003)(2906002)(956004)(2616005)(44832011)(8936002)(186003)(16526019)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OXdUSFlIUm9FTjQ1Ym1xYUxoeXpPejRuZGIwaEs5VFFlMEozdG5vUWd5cUQ3?=
 =?utf-8?B?MGozcUhXVkRISHFoeUpiL1d3ZGZGcEpsM0lkaXNJVkhIN2xWa0pXNkZueDlP?=
 =?utf-8?B?d21DOVdzY3dKZVp1Y21sWlgxM2JkYnRnWExBVE5sejQ1bGVoWWZXeGI4YlNX?=
 =?utf-8?B?TEtIVWZxREZOUk5FTUIxZjdRZzJ0OWhZczhOM1E0ZlFRZ05VUmJOYW00aTZZ?=
 =?utf-8?B?N3NPNXo4cm52dStraVovbUFGUUFpR2YzQTdETTE2a1p6U0Q2Uk0yVks1N1Bv?=
 =?utf-8?B?dU9VbjZORWY0bjFwME1td2VMcGtCblZjTkE3ek1qS0dRazBYdWd4Q083UVlp?=
 =?utf-8?B?TFgzeG9yRlJXZm1hYjI4LzJrbWtiT3ErR2ZBOXoyWFdKZmwvZDdzRzlwR0w3?=
 =?utf-8?B?ZmRxaFNqb0IwbERDcGdhT05hUUxsYXBEeWhzUDNhUTNYVWpPUEF1ZWpNK1R2?=
 =?utf-8?B?TjVDd3Qwc1dldlV4MnhRSk1SeTAwaUlrYXdFZjdxTkYrb2U0bXJ5STZJT09V?=
 =?utf-8?B?ajdrT1hCenJ4RkQxVzFzSmtxZGJubjkyN2pEQStwaVNockVKeHllSkFHTzNV?=
 =?utf-8?B?WUFWSjN1aHNaWW5TMThnYktPbHNMNVZqSEwrMzc3T0hiVmI1ZHREMGVHb0x5?=
 =?utf-8?B?T2wxalkvVjM5czc3amNEVG9RcWw4THRRNGZiTGxrd2g5Y2taOWVKWWVpeHhh?=
 =?utf-8?B?alczZVVRK3dnN0lJYTUxSUloQ1FESEQ3ZlJoaFRmQm5XUmVFUFdrVjZUa1A1?=
 =?utf-8?B?UFZiK2FOdmduYUZxOTM1Mk5KOWVqYlNBTXlIZFR4TFdlRW1lZ3BpMW4yaHAv?=
 =?utf-8?B?Wk5yU280dlgwQWpwSWZvZDhLMGFqbS9LYmU4Q0wyMGZsZXROZXJ5endRVkRt?=
 =?utf-8?B?MVoxNGpVdkFqempsWXdLeUszWlFudklFTGkwSjBCS1pJZjd4UWQ2MW04TURX?=
 =?utf-8?B?dHdESVRtZ1lTUk1jM2xHcUlNaThyeXpURlpEK1d6YjN1Ukl0cjU3R0lmTzVX?=
 =?utf-8?B?UDVLMEpDWklESEtibk1oM1RaTElqVlIvMmF4S3laVUVOTjZVOGYzdFNKTGJL?=
 =?utf-8?B?SURlZzFCd2V5dUVBOFlZM04rV1ZValkwUC9mY29NT0g4aGpqaHVBWFdTZzJa?=
 =?utf-8?B?OGtmdGtDeEUzQzJmbm52cFZSOW56OUtmcXdnMGlqYzdKWFhmYkhoYjhGdlR5?=
 =?utf-8?B?c3QwZ0o1UFJ6Q2kvczM5eUxkQlBHYXlacEx3Y3hJazFZQUVpdUVuUU81cmw3?=
 =?utf-8?B?S3FFQ1F1NitqWHgxU1pvS3dDWTlvRVlYVTN3UTM1WVlZQVhIeWF3M2EremhF?=
 =?utf-8?B?YmpUSmJYSElCcS8xblp4S1JNbk5iN2E2eDBRRzhQRnRhNFpwUWdjUmhRREZk?=
 =?utf-8?B?QUllWlBCbUh3Mk5OdW5aOForUEx3ZmthaGpORGpDeHhpdVNITGpVYlljZjds?=
 =?utf-8?Q?sOcAEqZG?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5673
X-CodeTwo-MessageID: 7a5edbd1-27f8-4a60-95bc-634a77f54f4e.20210128084544@westeu12-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR01FT019.eop-EUR01.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 51392e92-9984-47b0-37b4-08d8c36918a5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RkWes6JHQfdUD3OZ6cSzdKZLMwosn7L/9IMEiNGr31QtgzYnkSKdAS+7gA9fQiq4/FL6ARte2FwW14+j+BLgU2OSi5eq0d0RuC18ei7WdH8jg4fVvFSFEHekDidkIjhKZuuT1iCWyXiw5QNdtIGNFi+eUwfXfEaTeWwFQ5IYJLUecB3oRjwAV+Do7nwV2P65YvgsWAp8JFlx7T2nwC5WN88lddd6QHjP9pgzaEB+/uuHfrons8eLj8o11ipNslCLASxNrHgrgzu3tXT1b/Td0c12jNpLuUIWpmxlap7kljfzrh3VxrLa8jhtSSsLLZLEimbnvHNO7m5ZB8pkdm7mYNuljCRqcQWIj/TV9skmul2mr9EzxRnGgdUnq74bncqgICgVQOI+FjPZqVgzrDcNW26+9sFzUIjkO7ZHTGvboIcNAFKthI6UGO5pJ84iJWHgCOMlHNCOyQOm1jT9/ZKE0DBLfI4YSnM2twJ2LFtFeDEEfgdi/aexbBQbS2Lc6eUccfUG52kLm2NSGiQrSrPF/NS1KJNb+bFFZOeb57e7CM/P1YqiBN/5VjTdbhJciunvQtbZbbCdMjj+rpNaNk+zKwDJJsSQiP2EiYNTiQUXLC4JrqSZ+HHeRuRu/6YIGkwciPJFVNJoziyaCstTttAJSbPXSrM+But+p8kF34oTIYFriXCTCjGWTyzojcjxO2o3EkIS5tjDCv0QBCV6ErubLw==
X-Forefront-Antispam-Report: CIP:40.68.112.65;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu12-emailsignatures-cloud.codetwo.com;PTR:westeu12-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(39830400003)(46966006)(47076005)(26005)(31686004)(15974865002)(53546011)(70206006)(6916009)(83380400001)(42882007)(36756003)(70586007)(82310400003)(6486002)(336012)(2616005)(83170400001)(356005)(5660300002)(7636003)(8936002)(36916002)(956004)(16576012)(31696002)(54906003)(2906002)(316002)(4326008)(16526019)(478600001)(186003)(44832011)(7596003)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: topic.nl
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 08:45:45.3362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b091a1-68fb-4519-48c9-08d8c3691a6c
X-MS-Exchange-CrossTenant-Id: 449607a5-3517-482d-8d16-41dd868cbda3
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=449607a5-3517-482d-8d16-41dd868cbda3;Ip=[40.68.112.65];Helo=[westeu12-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT019.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5604
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Response below...


Met vriendelijke groet / kind regards,=0A=
=0A=
Mike Looijmans=0A=
System Expert=0A=
=0A=
=0A=
TOPIC Embedded Products B.V.=0A=
Materiaalweg 4, 5681 RJ Best=0A=
The Netherlands=0A=
=0A=
T: +31 (0) 499 33 69 69=0A=
E: mike.looijmans@topicproducts.com=0A=
W: www.topicproducts.com=0A=
=0A=
Please consider the environment before printing this e-mail=0A=
On 28-01-2021 02:56, Andrew Lunn wrote:
> On Tue, Jan 26, 2021 at 08:33:37AM +0100, Mike Looijmans wrote:
>> The mdio_bus reset code first de-asserted the reset by allocating with
>> GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
>> the reset signal defaulted to asserted, there'd be a short "spike"
>> before the reset.
>>
>> Instead, directly assert the reset signal using GPIOD_OUT_HIGH, this
>> removes the spike and also removes a line of code since the signal
>> is already high.
>=20
> Hi Mike
>=20
> Did you look at the per PHY reset? mdiobus_register_gpiod() gets the
> GPIO with GPIOD_OUT_LOW. mdiobus_register_device() then immediately
> sets it high.
>=20
> So it looks like it suffers from the same problem.

Well, now that I have your attention...

The per PHY reset was more broken, it first probes the MDIO bus to see if t=
he=20
PHY is there, and only after that it controls the reset line. So if the res=
et=20
defaults to "asserted", the PHY will not work because it didn't respond whe=
n=20
the MDIO went looking for it. I haven't quite figured out how this was=20
supposed to work, but at least for the case of one MDIO bus, one PHY=20
configured through devicetree it didn't work as one would expect. I added a=
=20
few printk statements to reveal that this was indeed the case.

This issue also makes the PHY hardware reset useless - if the PHY is in som=
e=20
non-responsive state, the MDIO won't get a response and report the PHY as=20
missing before even attempting to assert/de-assert the reset line.

This was with a 5.4 kernel, but as far as I could see this hasn't changed=20
since then.

My solution to that was to move to the MDIO bus reset, since that at least=
=20
happened before interrogating the devices on the bus. This revealed the iss=
ue=20
with the extra "spike" while evaluating that, which is something that I cou=
ld=20
easily solve and upstream.

Probably these issues were never dicovered because usually there's a pull-u=
p=20
of some kind on the (active-low) reset signal of the PHYs. That hides the=20
spike and also hides the fact that the per-phy reset doesn't actually work.=
 We=20
only discovered the issue when we changed that to a pull-down and suddenly =
the=20
phy failed to probe.

The way that the MDIO bus is being populated seemed rather complex to me, s=
o=20
chances of breaking things are quite high there...
