Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C512A302EC2
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732139AbhAYV7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:59:24 -0500
Received: from mail-eopbgr10101.outbound.protection.outlook.com ([40.107.1.101]:1507
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732996AbhAYVhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 16:37:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfmzBMgevGIioQHMjMujbV9kJgrJZQJd9ULd+pKU49trWp47lXgF3eov+m0tSGNuG3Arq9zp2n1Scv9dF8bbOfD5s2sKnDG3zT0vP0eH9jsPlTlq3yzMge+5eVpx6Df/V2dpw2QcLlCFhdjE4vDOryJSJJEo2k/wureRdI7g7aYyp9GDIXX0NbWrpiri1EeHAqmv3g3/tizQNtnRePDJMgBsHVd61/+B79qC5jj5I3emlh39qit9+ntKJ58HIKrf0dRRiyhYNLB4RiCwfWXLBoHRfFCPLI8xSVu05muhXZDzfBsmKAXYxRuuVoBXhYO/hlsTPGYTAR+aMd6EF4N6Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeE9PIWmK8ZtnPPsM5maKWOUEmzyBru4XDJdBahPyPA=;
 b=kLJUDl0MMS/TSDZsdrDjxlkc2cMNQnS7mdiq9so/7Wcmc5VGtgjzMX0UzcRpemuIkT4aL6u5T+tm7Mr/Tp4rbGk1G0uA4O1BOFSMHmybk1YZRfbBC9C1Ylbyl9JuokW43M6eaP96v7lGBtVIsmICqEjo8250b4QKS4BwHlbQpsUF9tEnB4a2J+kn2GF6mF50Q0bvRESrjY1x6eV7VB8gkkCoK0JXgoqxeMZ1Rq9H/bTJABnekpnyE1AoHm+P89iPdBg9S9EGUAu4Q+EtFW/UxXf7YxHrketN13qLjjXPa8E8zr9I8X1wvee9uacsx4YpkTsIzRlh1hbWCSS1XLybmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeE9PIWmK8ZtnPPsM5maKWOUEmzyBru4XDJdBahPyPA=;
 b=QqCb9hPPSXOLo1mz9e1IGbXkOVb/Hf6pbmpsh8HRzQROiR3N/4Qhuq1Vl5qYMIxtSgcl/95lcT4kyslT4e4bZKI5e1ye1Ef14YjW8K2Y9Maj8OGPLl8ivENGSX2yKJX/IvoQgAISO30PV4YsEsKO41jMCH4iRWAWC2/wdE7w5YA=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM9PR10MB4499.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:266::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 21:36:50 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 21:36:50 +0000
Subject: Re: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
To:     Andrew Lunn <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
 <20210118185618.75h45rjf6qqberic@soft-dev3.localdomain>
 <20210118194632.zn5yucjfibguemjq@skbuf>
 <20210118202036.wk2fuwa3hysg4dmj@soft-dev3.localdomain>
 <20210118212735.okoov5ndybszd6m5@skbuf>
 <20210119083240.37cxv3lxi25hwduj@soft-dev3.localdomain>
 <YAcAIcwfp8za9JUo@lunn.ch>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <6770bb94-e615-8f14-f83b-8bf95b5739de@prevas.dk>
Date:   Mon, 25 Jan 2021 22:36:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YAcAIcwfp8za9JUo@lunn.ch>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR0202CA0056.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::33) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR0202CA0056.eurprd02.prod.outlook.com (2603:10a6:20b:3a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 21:36:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6d4fcb3-9bed-4cb1-bb8d-08d8c179531b
X-MS-TrafficTypeDiagnostic: AM9PR10MB4499:
X-Microsoft-Antispam-PRVS: <AM9PR10MB4499D39CFE81A3AE529772C593BD0@AM9PR10MB4499.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fdgM/wmPSN5CggfcpJPfeOlvIsWphcgPQZC5ue+0fTI8XEep+/QQElOfdAX1jUug0JlgzuudAJUOGioWRQsy9qlHcmqogrMz+yBLGJ5BBf8Zy1/cSNH8cHUwPsH8sKYJm2uMbE45iRzN8HLMBpkLSmWBdiYalwSRmF9QdehqC+NJ+y5nuyR5IFVlv+7YrnnU7Lea8Gvjxj/uyLgqzYryxHlXB2hCReRMC643BYhbF+Aw4T/hr9DH0mfM+DvF75lEiu5Gm8WIhJNfnuP/rG5GlXOXOfxfct5sLEUjEDk66Xx7IIzp7QAAPOefJ5TyzDp0JsS9Y0dlfVpb5kPyYQWxgSGuux8pCf6XPIHNtDsXXrDtwKo98l0ShKa9fgTdEmMd4z5bbKxyypkfeEpuerWHydbsrXRCgDIGarOTH7DOKQfA/S1skH/W11LMwq9RLxTnF26h/MzUVqBc8xVNT2XYRseiv2eX7kE4EcynsLixlvQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(39840400004)(366004)(16526019)(6486002)(2906002)(44832011)(26005)(36756003)(16576012)(5660300002)(316002)(86362001)(956004)(2616005)(8676002)(110136005)(31686004)(66476007)(7416002)(186003)(31696002)(66556008)(8976002)(54906003)(8936002)(52116002)(66946007)(478600001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?C2T2cQC47TZthj6jRPSxE43srCbdLe8GKAWXWxgLuYQbzHXRpjGujy5X?=
 =?Windows-1252?Q?ggiZDF9WkSo68LKdSLLsjtb9caENB34mRpN2WsD5o+1KLYDEfLznA6m7?=
 =?Windows-1252?Q?QvnzDc1ed2ja26QkO4iZhmvEwe+MsbXYSOoFKAfecMs2lO9FIfYNmKkR?=
 =?Windows-1252?Q?t3aWxNvmiyqXTzNSgaQ42xBCEopVGItyg6l6B6do4fXhlJndjs6TScK/?=
 =?Windows-1252?Q?696f61oMqA7DZoiIxrE9yF9olNFErSE4YQXf/cI+iVALUx2zuG2iL+70?=
 =?Windows-1252?Q?u8XK8wZ/FtMdwKgh3IMrqsnPMEH4uiSujRPr8VXBvWKfwM/veZrMoRuZ?=
 =?Windows-1252?Q?lg1F+4qPDyRl9yn8p1hM5sHR3vWfjqmQk00ocdYQS6uDTX2aWwqYoU+i?=
 =?Windows-1252?Q?+rSiZZrea3fXS5itwnmKL01B1fkpdbs8lU3k2IKF3BVAvYmrTkiEb/J8?=
 =?Windows-1252?Q?eb8aS16N/Ip3TZQeH3RCR0kYqBAQQWaVt+HExtMjgx7norxa9CVcEfHY?=
 =?Windows-1252?Q?KaAzPB0eU7Y+qCdXRySMr2RMUMbvz1nGOAfq6Ec4HqEGtvdGTAp+6OIp?=
 =?Windows-1252?Q?hED6vPpQlwge8g01tuWERnxGzHjjW/TSI6EHkoyeEqarDW7CahSN/xlk?=
 =?Windows-1252?Q?kGTNVLFO4p+cH0/9bxCAloPKkHMfuUUGBwFM45C1haSjho1MW65Jx13T?=
 =?Windows-1252?Q?YedMiQ3qO4eYhZgtZnd3H36KCT/EnFphBqT/uYQ7kTd3UaDdkLC4DUo5?=
 =?Windows-1252?Q?CYKp1mmA/AJnEeCx5aDj4OETqitqCqGnJkHNNda9j8LUXS2KSrlUHHsK?=
 =?Windows-1252?Q?V+NIEXSZhd32XvUPafbZdxgd4TSDG/rRoQpCYX5BoW/q2GujHFaIVS3l?=
 =?Windows-1252?Q?joMyz+u/8aa3emX5H6JnFE73WKEBQTlj/KCA8h1swb6QZ208qeknplZ8?=
 =?Windows-1252?Q?4+TupOW6ecaNTVEC+XMM/jMpmLK5WGurkvOTfwU9L0z/zUcbULFvagAd?=
 =?Windows-1252?Q?BQMOvTcMPx5wB2GAX/r9F6mjPd1AGyBPMP/28Jp5lPt2n+0u7D7NZN/1?=
 =?Windows-1252?Q?dkBlgNuwnv6olf2t+8+UiOdP7pdWXM/Ri8Ds/Yy174O8+Pw1Zlu58Czn?=
 =?Windows-1252?Q?73UAjLmlGyzQSq6JXHGliy8g?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d4fcb3-9bed-4cb1-bb8d-08d8c179531b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 21:36:50.4374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFiU0pU9yH8kfOt+7iimFGEYdqLYwAQDrqP4TplPm5Ds+sHEfQ0F8iAM4X7lXJV5ZaUN++zS6VOf4TKdfHO6XXzdMeQHJxHXheLc+pObmfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2021 16.52, Andrew Lunn wrote:
> On Tue, Jan 19, 2021 at 09:32:40AM +0100, Horatiu Vultur wrote:
>> The 01/18/2021 21:27, Vladimir Oltean wrote:
>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>>
>>> On Mon, Jan 18, 2021 at 09:20:36PM +0100, Horatiu Vultur wrote:
>>>> The 01/18/2021 19:46, Vladimir Oltean wrote:
>>>>>
>>>>> On Mon, Jan 18, 2021 at 07:56:18PM +0100, Horatiu Vultur wrote:
>>>>>> The reason was to stay away from STP, because you can't run these two
>>>>>> protocols at the same time. Even though in SW, we reuse port's state.
>>>>>> In our driver(which is not upstreamed), we currently implement
>>>>>> SWITCHDEV_ATTR_ID_MRP_PORT_STATE and just call the
>>>>>> SWITCHDEV_ATTR_ID_PORT_STP_STATE.
>>>>>
>>>>> And isn't Rasmus's approach reasonable, in that it allows unmodified
>>>>> switchdev drivers to offload MRP port states without creating
>>>>> unnecessary code churn?
>>>>
>>>> I am sorry but I don't see this as the correct solution. In my opinion,
>>>> I would prefer to have 3 extra lines in the driver and have a better
>>>> view of what is happening. Than having 2 calls in the driver for
>>>> different protocols.
>>>
>>> I think the question boils down to: is a MRP-unaware driver expected to
>>> work with the current bridge MRP code?
>>
>> If the driver has switchdev support, then is not expected to work with
>> the current bridge MRP code.
> 
>>
>> For example, the Ocelot driver, it has switchdev support but no MRP
>> support so this is not expected to work.
> 
> Then ideally, we need switchdev core to be testing for the needed ops
> and returning an error which prevents MRP being configured when it
> cannot work.

Why are we now discussing crippling switchdev code instead of making it
work? Yeah, this is not all that is needed to make MRP work with
existing switchdev/dsa drivers, but it's certainly part of the puzzle.
The patch at the beginning of this thread did that.

Another approach that I'd probably prefer even more, given that Horatiu
said that even in the only driver (and an out-of-tree at that) currently
knowing about SWITCHDEV_ATTR_ID_MRP_PORT_STATE actually just translates
that to the equivalent SWITCHDEV_ATTR_ID_PORT_STP_STATE, is to simply do
that translation back in br_mrp_port_switchdev_set_state() (i.e., not
having the translation as a fallback). We'd keep the netlink
IFLA_BRIDGE_MRP_PORT_STATE_STATE because that's already uapi, and there
_might_ be some future driver that would need to do something different,
but until then I don't see the point of duplicating code down the call
stack.

Rasmus
