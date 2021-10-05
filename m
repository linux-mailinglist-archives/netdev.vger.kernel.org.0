Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936CF422E3F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhJEQr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:47:28 -0400
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:39810
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236533AbhJEQr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:47:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntfS4+Wmam1tlYwIXSEOzUI45qEQZcax77RjPHOOO9R8O6C0yOw26hV6P+FTVh+jYEftl3QOVvhxWOaKCkr6SM6U/IrojEovGQEU0iBjdJBs8RIudQHzmdV8NxKL0KKO7zpBi0v7XNYqQJJOlY32rvlo0m5AG+bRiF2Z5IRU2CfKL6Ztx59HkbK8CxrVmnySoNeSV3tWxcv/GL/RVKNBvFyCejiOszR20SMB11c4KDWJGf3kuTcwnkCE7pcYDo8kX773yCNQhbyiKgmMxZ3fM6Z2hK9ghznsZ3QDzWJdtJO/NuAkH+HJcvt5BmE5A9AQKcg6RszmQYnZvLZQlJsx9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taB5L3GpdNMwl/n+raYIQslwKvqzkq6sqwTjxAVH0kw=;
 b=WpsmduEp/F72xYgxNGuF1dF0JPDD7izUvMW4H/aWsujhCcZ9Huc0aKFpknRc1cWHjzEpITXyBcCpsR69Y2rVo2T16M5DB23DGmC366cCAXojF/ZiUhfwo96a0XtnKblEsk06vpihHyQbBh+986bPvovxry+MzyNkm1JAHXHzYNcotOhbDfNUvFU5LW7HOvrSut58yiSzKNVAIESTASB1TZVk2wzKz43nd5nCnZGfEmHg8YRm3HwRXnFBIBu1NJKJn65cx/21WSQuM6T8LJ3XBBLC27WM8OlhZp/pMQx4toN8ur78/AD0M+JHAKPdsEgeRoDfAjmFVUa7iSlYhz+qCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taB5L3GpdNMwl/n+raYIQslwKvqzkq6sqwTjxAVH0kw=;
 b=WlgrjI7rFpFt6V8wHBs+gWSB0uEhKoIZodLS5OW2qzIlPojCehq76xpm5a4N1BDySiOzodQWDJQugXsG9WgXqIwI/Hahq7qeN/Uutc3Fr4mbdOc2xCstv+1niMxXMw0xZ02bBgUlVEBjLuNZX98s0cRubpxTE7ks+lU63c8U2V8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB5674.eurprd03.prod.outlook.com (2603:10a6:10:10e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 16:45:33 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 16:45:33 +0000
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
Message-ID: <66fd0680-a56b-a211-5f3e-ac7498f1ff9b@seco.com>
Date:   Tue, 5 Oct 2021 12:45:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVwp9R40r0ZWJzTa@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:208:236::22) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR05CA0053.namprd05.prod.outlook.com (2603:10b6:208:236::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Tue, 5 Oct 2021 16:45:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d8fe197-1bf3-4081-8a0a-08d9881f8c77
X-MS-TrafficTypeDiagnostic: DB8PR03MB5674:
X-Microsoft-Antispam-PRVS: <DB8PR03MB5674233DEC1F67051D1E731896AF9@DB8PR03MB5674.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oe/lOqAtDyaRCIp2+fS7Xcpp9sarnZcIQ3Gl1hXN09rfJ7FJqxiIwX+QCsp20X4gp5yLYgtdowZW+QojH0aFosodODhResaItUlJS4KflMeiFxQW45kutd6WOC/LAJxQTwGcRyg0deHmfY70xdKWggaVthdN9iFOvbvzh+BBj2kM8yvVi/6YyHVCr4+nR+oG6sADuIBUST1q0nr17UCyRuID2gj4gur8rYeOqw/4rhfyfKjmkZE59Scv6zHtHrbDEhLJN4ZnY5PzKC5nMaCCgO9fvQhMcM5rmibLQuRICwb2PMeHzN2u8nWRPW+TTEHgV44+y5xiFZWtEYF8xWYAUChH4L/LJDJ2bDzFw9cX87D3/tzpjzwngMQtvYDKmE49smJfCZ9G4zniaDhkGmwxhs3nquv210gNeUGR7Y8v5hHaX4U2ygyaSXc7DecVTocQRy6c8WVss56ovWfFrdrOeZzGCMOPB/cphatlyZ973KtYVWHbw4hKNpbPXQcEXYDRdDHQT7KRlj3mw9zKf0bpNOJudNK4YorKFQOwE/ieo+rfdSXT8szLn4vj5fmC9kmHPPhWWBtylWZXUgGYqhNEiBlGx/4tWRpB1tOF8DH+Czy3VQlUEw5kzI3IN05Mh0qOoyRrzLlWvuXTRr7jgHNxqxwzLrJxBS5hkOlGWyfGjRa0V7R/Gxws4YqfkPDFI99eDmI+5pR0vE4lNv6qpjmKIylLajZOIaJygwAa/IrMoiyAkCkGA0aKXcgt9VjusV7w1KGyPqRlqMPbfFKp7mKOOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(53546011)(38100700002)(6666004)(316002)(6486002)(66946007)(66556008)(16576012)(8676002)(36756003)(83380400001)(66476007)(6916009)(2616005)(508600001)(26005)(44832011)(8936002)(5660300002)(31696002)(31686004)(4326008)(52116002)(54906003)(86362001)(956004)(2906002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWJrYjhjNWNDY3kzNmNHRVZ3WFBMRmlleVpzdUlZa204WWppczR3SElpSVJP?=
 =?utf-8?B?ek1pWU9Ka1UvdWE4MGZJa1VERzBHQUt0eWR5RG9JcWsydnhteit4NFY1dnJT?=
 =?utf-8?B?VkM2L1dKRnArSlprVFY4R3dmZW5sK0RVWEZlVnAxdHBmbkw5ZTdPWW9yNGxn?=
 =?utf-8?B?bHdOa0w2Yi9kc01McnFHT0ZJYWpmNTZlL05SS2VuVk1vQ1JGNml5ZFRjenBL?=
 =?utf-8?B?akUxVzJkdWk1ZDFHbTdTQkJkWDk1VjY0TDAwdEdnbVdkQjdldzdhckVzWGpt?=
 =?utf-8?B?THNsYVpvV1dnQjRTVjdBdHk3cXBwVjhlcWp4dVpiU3dsYk1kcUhCNlpXY1hp?=
 =?utf-8?B?VXcyN2JPR2dLVmFsM2syb0F1Wk1qS1lRSE1OU1RENEtzNkR1N01uNkUreHp3?=
 =?utf-8?B?Y2FYZTIwWENBWGhxcWdEVFU1cWNQZ09TQzhnN0dESTZSUjF4TG9tNXdnYnRq?=
 =?utf-8?B?V3dWVXcwaUxMdU9xNzZhenYzMmErbGhFaVRxUWFUMmRVY1Nkbm4xYUVtR08w?=
 =?utf-8?B?TER6cituSkYySkdhTzNuSlR3Z2ZpZ0tOaFFtdmg2Rm4yUVNBNU4vRUF3UFpj?=
 =?utf-8?B?WXZQTzRJZ3QzUFVOanVnNEtyU2ljVkF1b1p1N0hKTHdaZmJrMkg2TmUvNEF6?=
 =?utf-8?B?bW96N3A4S3IrL1RTRDB1NGRYRFozcVdvL3VaS25UZkdzY3hsT3BabmlpNC9H?=
 =?utf-8?B?UEJOM3EvUllGaHQ1allrdUR4ZXpGMFI1WnBKVTlLeGREMXhnek9YclIydSt0?=
 =?utf-8?B?Tmd5SFh4MWZHUVlYejZXMWlhZG1IL0E1eFNuL3lmeUpqT2xYZWp0MlpSUk5n?=
 =?utf-8?B?Vk1hTjU5QUVSMkFWTE9tdmdVYjluZDhkeFJZWHczN2pra1FveWFQTitDbXlu?=
 =?utf-8?B?Z2pXSDNOQ3lLNTlIRU1IRVN3V1FCSW1JWW5DUnhQWXltWVBTZ2V4YWNSYkZT?=
 =?utf-8?B?MlpxSi9QemRSS3U0K0k2UitnQnNLeHVRcENrbVNnOXZHSW52ekxJV3RCQitK?=
 =?utf-8?B?em5mZ1NiQjA2a1hvQ2Q4QU1UMG8rei9STGdVTGxlZWd2cUFSNHg4M29uTTRG?=
 =?utf-8?B?MmsxMS9rYUVvc2pJN2RjQ0VucitOMXJUaW02TzVscndYNUJnMXBtRDd3eDBN?=
 =?utf-8?B?RnlPVGhtRDhQZGFZS2NnS2lMYy9yK2VzNWkzVzNoaHJiTkNiS0lvZ1U5aDRx?=
 =?utf-8?B?NDRzWWZ3SE9YYWZjQTBta0x1Ti8vT1QxcEZ0UTBIS0lETUM4c2dTZEc2V1dX?=
 =?utf-8?B?c3dHVktBYkp3K2VoSU5JeTF2eUxXZUZuUjgxbHoweDBFMWtjaW9ZSjZhcUpX?=
 =?utf-8?B?UnF6UUhnT3ZNc0ZCaHBMb0UvSENoN29sRkt6TXhtcmphSGQ2QWhoZksrUW1a?=
 =?utf-8?B?OGZ0NFppdWllNDhhMjBKTmphbWIxNTkreVJRVDVyYjFCU2VXTlBNbU5KeG10?=
 =?utf-8?B?MVFiQTBxZ0dCeXhLU1pYNTNXQnBxd2pEQkVjc0wvVGdnVW9OdFVyZmpIRzVH?=
 =?utf-8?B?YnNHN0hkTDlNWkZCSXV2Z1JGNytXWENRSjF0Nk9tNlF1OWM5aG9UYmdOM3F6?=
 =?utf-8?B?RThLb3BIbkZ4OWozV2dMYXB5bFFpeTN2VVg3TEdsTXk5NEp3a05WWEtGTjhR?=
 =?utf-8?B?c0VaZWJPV3RjZEdNdTl2akV2V1M2a1I5b0JJNlNYT3lPaUh3LzNFNXZWblly?=
 =?utf-8?B?ZUkwd0ZvUkJiM1ZIR2VYK0pqTmFvQmllbzc5RU1oWjkzOG9KbjBTZWhCcEdH?=
 =?utf-8?Q?7K0PtxSz4U9pt4evE9wsUBNucIztxWOhOkZsApk?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8fe197-1bf3-4081-8a0a-08d9881f8c77
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 16:45:33.2497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAabfvKrJI5RFZI9aRgb/XdvWrZmoxPLAX8FKornkRBX46r/OsAHFokNEGnjVvm9uUQPv+74KJlrKVrFzqoDGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/21 6:33 AM, Russell King (Oracle) wrote:
> On Mon, Oct 04, 2021 at 03:15:27PM -0400, Sean Anderson wrote:
>> Some modules have something at SFP_PHY_ADDR which isn't a PHY. If we try to
>> probe it, we might attach genphy anyway if addresses 2 and 3 return
>> something other than all 1s. To avoid this, add a quirk for these modules
>> so that we do not probe their PHY.
>>
>> The particular module in this case is a Finisar SFP-GB-GE-T. This module is
>> also worked around in xgbe_phy_finisar_phy_quirks() by setting the support
>> manually. However, I do not believe that it has a PHY in the first place:
>>
>> $ i2cdump -y -r 0-31 $BUS 0x56 w
>>      0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
>> 00: ff01 ff01 ff01 c20c 010c 01c0 0f00 0120
>> 08: fc48 000e ff78 0000 0000 0000 0000 00f0
>> 10: 7800 00bc 0000 401c 680c 0300 0000 0000
>> 18: ff41 0000 0a00 8890 0000 0000 0000 0000
>
> Actually, I think that is a PHY. It's byteswapped (which is normal using
> i2cdump in this way).The real contents of the registers are:
>
> 00: 01ff 01ff 01ff 0cc2 0c01 c001 000f 2001
> 08: 48fc 0e00 78ff 0000 0000 0000 0000 f000
> 10: 0078 bc00 0000 1c40 0c68 0003 0000 0000
> 18: 41ff 0000 000a 9088 0000 0000 0000 0000

Ah, thanks for catching this.

> It's advertising pause + asym pause, 1000BASE-T FD, link partner is also
> advertising 1000BASE-T FD but no pause abilities.
>
> When comparing this with a Marvell 88e1111:
>
> 00: 1140 7949 0141 0cc2 05e1 0000 0004 2001
> 08: 0000 0e00 4000 0000 0000 0000 0000 f000
> 10: 0078 8100 0000 0040 0568 0000 0000 0000
> 18: 4100 0000 0002 8084 0000 0000 0000 0000
>
> It looks remarkably similar. However, The first few reads seem to be
> corrupted with 0x01ff. It may be that the module is slow to allow the
> PHY to start responding - we've had similar with Champion One SFPs.

Do you have an an example of how to work around this? Even reading one
register at a time I still get the bogus 0x01ff. Reading bytewise, a
reasonable-looking upper byte is returned every other read, but the
lower byte is 0xff every time.

> It looks like it's a Marvell 88e1111. The register at 0x11 is the
> Marvell status register, and 0xbc00 indicates 1000Mbit, FD, AN
> resolved, link up which agrees with what's in the various other
> registers.

That matches some supplemental info on the manufacturer's website (which
was frustratingly not associated with the model number of this
particular module).

--Sean
