Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2584935E063
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245641AbhDMNo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:44:29 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:16769
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230293AbhDMNo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:44:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWk041nhpWYvyBz4wmonu6A//uP2b8upop+LwwWoG5o8t0RGbQuOoJUUdzYDlRQn/aR3z7E7Z/BnqeY4vWcMijUuZqv09t+Ie3ONLz5Rb4nWD/z8mjLvHZtjB20LLMEF8740J3+exIM+gNEq+FPb/tOElB2nbIMqUU4dVGu1rd71XAKqbHIZpsoHrIyADkGwiHktOLBwOouHu3wN/u/li7fflvy8TPE6Ru1IRVnb0VwuU4GD7Qf9qMO6AF53SkPKJITiIgHEWBXc/sy0P2nzNRUeU85NaCNTxAshh/wJFXAhsHUOvXZyxC/qvcmmBZF6jwoKx/IipSNFOf8OubqnyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBVYt8q622fwvQD0oT3+aVUerSEAFy2AE/psRRKlnbE=;
 b=GWW4BXlsRJeAj4NU4wTU3nmRyCLmFD8cQ/6Qtf5CZIq9yHouiBaa7Q4vw5KamxpesvKbt2DUgfUZ7ctG1DT8U7tCGtRmPy9CDwWlQhcxx9Jq3OYoPK67aCMpouNTNlnwVddvKrORV8/JPCW1qWiO2TJxUSIav/ST4UTAJZG08nsbx4tEeCJcIvNZ+ADXB3s8xnPgA+jOGWel3G0k76l+NKGmTRiyMZDUIlK8+JYdwHwuPeRR6Uc22iQAyAB1zdxKTrGcNTCe2rXW7Uleq76L/ox0OCXR8WIcPZ0P6Bn0wquNvPnPo4gp69VXXo/6nMpSHpu0pPK/gUSDVfqzZ+nukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBVYt8q622fwvQD0oT3+aVUerSEAFy2AE/psRRKlnbE=;
 b=Gu4EK4A9zacnxuruJNNEf6ANuJe6Gkz9ZollXoXYpF2qybuMpSQpNbPrQefLETn2l93wax3gb9txUAa08T9TRbF7I+4ioMBVLNUhJWAxBNU831s0bsELBq1MOv0hvLqhdiJgpGcxxnhl9C0+MpziqGk43X6O4FequoMFrXDY9YE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13)
 by AM0PR04MB5892.eurprd04.prod.outlook.com (2603:10a6:208:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Tue, 13 Apr
 2021 13:44:05 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::3419:69b2:b9a3:cb69]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::3419:69b2:b9a3:cb69%9]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 13:44:05 +0000
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Radu-nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
 <YHCsrVNcZmeTPJzW@lunn.ch>
 <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
 <YHRDtTKUI0Uck00n@lunn.ch>
 <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
 <YHRX7x0Nm9Kb0Kai@lunn.ch>
 <82741edede173f50a5cae54e68cf51f6b8eb3fe3.camel@oss.nxp.com>
 <YHR6sXvW959zY22K@lunn.ch> <d44a2c82-124c-8628-6149-1363bb7d4869@oss.nxp.com>
 <YHWc/afcY3OXyhAo@lunn.ch>
From:   Christian Herber <christian.herber@oss.nxp.com>
Message-ID: <b4f05b61-34f5-e6bf-4373-fa907fc7da4d@oss.nxp.com>
Date:   Tue, 13 Apr 2021 15:44:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <YHWc/afcY3OXyhAo@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [217.111.68.82]
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB7041.eurprd04.prod.outlook.com
 (2603:10a6:208:19a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [165.114.161.25] (217.111.68.82) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 13:44:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4df0562-0044-4822-64f1-08d8fe82342a
X-MS-TrafficTypeDiagnostic: AM0PR04MB5892:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB589200DC0AA9BFA2C0940165C74F9@AM0PR04MB5892.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qIS9IyYeDnFVCoWd6yrLdzIFoli36YJRVxdzGNg/b+PHpSKyclogqweMsTMbS4sbNVz184XJLvtQsLu9Z3HjxsOZLs07Ft+bLiGn+Bzkg/Dn7Uw0u5fpDIQp+23dagwC+lUhIkD6oJwQdqp6xoND2wF9kbX5+YbDZR+Kmb4AjHFc30epLYXYq3F/06RXLHSUuLrI3ALjJq9hvwNH2enqyHJue33yfVsOWchiNwspeC6f0/YRM18cdJZnzdNW8NjUrbK2EeH9G9DgpGh3em6FxWk5DmSpy1EvAXXS04CJO+W2qDTRXcnrq4ZhciGW67CF/clLwTxjt2w0hH5ArhG35KWNIp9E84HsAWw4jZMfHnAxxWpnU8KHbLOW12tAocBuR4RBLZbgEzCB15ysxFlf1ZlqjMYJ9Ok9anbC8lc6we6MnPIzbgNNDhb9kCa9RMnRa248i8agzyGwxoLV3jdgockpGP1OmZzOvm6CXRtRga5UltcKUdOC6nWuXX3VGWJTgF1qR9pFzdDHRuNEZomeOnqKTnNGhkc2OKaXCdf5vyzuG97IdDLPlSd1WoFjYlY5QeQvCbR7ys4uqawpqu7T/3KPYESz0Z2el65UTiCR5OyOZ8AI+MCFU9GwoM7nH6Jkk4dxitokvO4wCK95Ow6YQF+S5wqYe26wa2uTaQBzEkUpc1aZrU/cyt09lpCHMqSlbhLAYXU2BPdmD476JXutpHjxhMLgsP5d+b7B7uCdpSpqhNhXpwxnZEl0Lyx33U+2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB7041.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(498600001)(6706004)(38350700002)(2616005)(38100700002)(8936002)(83380400001)(53546011)(66556008)(6916009)(31686004)(44832011)(16576012)(4326008)(54906003)(956004)(26005)(66946007)(186003)(52116002)(6486002)(5660300002)(55236004)(2906002)(31696002)(8676002)(16526019)(66476007)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QXNPeUVRaFBkakJHQjlTaEs0azVtSWxEeWFER3d4M1dCUU1nOU1iZk92UGd1?=
 =?utf-8?B?Uit2bm84T3ErTy9kQjdKZ1hLYlNpYnFwS0hWVnAyMjNjTEJUNUpRSDdsc09p?=
 =?utf-8?B?RXBmWUJqd1hnUzF0ZXlJOU1ISTJiVzBFdVREWTk4VjFFaVM4Rmc1bnBOT0tW?=
 =?utf-8?B?QW0xUjNkQnFxdWdqRlNNdXppanZycTVBcEx6NUNxVXdWRDYyekErYThEbWZU?=
 =?utf-8?B?bnJqK2k5UjdSQ0V5dVRDSzlmL3o0T01neEpVS1JnaEV4UWtScnB3cXlnWGd2?=
 =?utf-8?B?am1KL25PU1paeXN4UnRhZ0hWK0JTWXVwTFBOSDBKZTRkd1VKWVNsZFVnS2pX?=
 =?utf-8?B?RjlaWmxBNWJkRnAwc1pjaUZ2SERrVmNLOG01YU9YRjdCTUFYOWd4d1RYR1RN?=
 =?utf-8?B?bGJRSGZPSm5udklYZ3NaUXpXMzVzZ0tlaE5qNnprMStXT09uR21oR1Bha3dF?=
 =?utf-8?B?cHMxR1BySFA0Y0RhUVNaWjBibUowOFQ3aGtrZ2N5Znk5MlBNQ2JjdS9ZSlpG?=
 =?utf-8?B?UkZzOEs4WS9pODFvK05XU1JiY2tkdmhYdHhJS0pZRkYwMHhoYnVsUWx3SUJo?=
 =?utf-8?B?U2ZBY0NaVVE2eG16eXFTTDhXR0QxU1BzdFM3TWMvOFBzOFArMm1DNjBZRjA2?=
 =?utf-8?B?MkJPZnpJSWFGYkFGNHNnREs3bUNvTWZ0clNCT2ppWUxTTU1yUjlqNVNnQTFU?=
 =?utf-8?B?cEhubDdGdGd6TTBZYWJKRVh5MllzTUR6TmJPbEVsQ1djMDBvU3hoQ0cxNE9O?=
 =?utf-8?B?YlJUclhkUVlUNnoxaEJRamovd2dtcVBZR2FzcTN4Y1BVN2FFbXNqYllQSjZu?=
 =?utf-8?B?M1NWelRwWXNvaXZFWjRUV28vRnFJTXduanpVaXhvR0NrNjVlQW5memVGS3hZ?=
 =?utf-8?B?aDRFaFhHQmhyZy84Ym5xL0UyaEdOK0tQZGJxMTZDQWlGV2NlWHZPeUhldEFl?=
 =?utf-8?B?TFZWTG4rb2drdGFGc3ZjNG5nQnQ0RmJKY1pNWVpINkdtKzRTOEZ6OGhMRjBV?=
 =?utf-8?B?aXU3cWNXdkRtODdRRU9mL3U1TnBaRE1KMFJUdTg1Z2oxUXhNTi9Cd3pLdzNm?=
 =?utf-8?B?VUtLeEdWTHh2N0VrMGpPUDJQNjA2N0NVQ1pKK255S09yUi9QUlhPTkMvRGp4?=
 =?utf-8?B?aHFoajJxdVpDMHByM0F4TytPQ3hlT1oxT0FCVXlkb1NRejUrbkxhS0RIbHFy?=
 =?utf-8?B?NmlmRWx5a1Z3ZlpyNTg2dklhWVBCbWVOaUg5YjZWcWthTGhhWSsxZUx6am91?=
 =?utf-8?B?Zzljc1NuZ1l4ZEtQYVd3dVBORHkwZVlmZS9LdHRrTUVGSW8vdkVwcXpPZWtE?=
 =?utf-8?B?UHJMT0xpUzhEU0N5NzNFb1dhclRZU1hpZE5iUkFHUkZLZG1SNGNYV0dabTly?=
 =?utf-8?B?UG84SzBoQk1NV2lVdEc0ak9Ncy9XMTFRWnJkUjlsQlhobVRiUEV2RmJaZFJN?=
 =?utf-8?B?c0VuK0JXVWx6YkhvN3lrVDFKYWlvYVdBWWJHTnVjQUhhLzlWSTVJUFo4M20w?=
 =?utf-8?B?aGZ5RzI4SHEzUkR6QzFLTnMweGQ4K2NDdG8zUGVsQXkxclFKcjVlUlphL0c4?=
 =?utf-8?B?ejV3d05kcXNnZnMyUE9QRThZbGFMR3JibndndWNjdWxiNDJHU1h1QlRDVUlY?=
 =?utf-8?B?M1VKbWFGVm5OSG1tWkt4NzJBd1JXWklKWGg1cVU5K0F1NkZrTHlKRi85R3VU?=
 =?utf-8?B?YndXVURlZ0V3UUJnSFhpemM5UzNaOTJPdFhVL1RmQ1JWUzBxaXZDeklHYUl1?=
 =?utf-8?Q?m2czfxRcaEnjllLlPjvoLWvCI+0uvuuoeFE+1Xh?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4df0562-0044-4822-64f1-08d8fe82342a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB7041.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 13:44:04.9662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXXOPKom4knn0Wex9YcX7UN65UG1sZA912gpLxHvtAJKaOHyqAM0mEcqBPs95TVBVBr7A4gmOYq95Ni+N7ZGhU5ixBtlTN2dPlXdPRot5cI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2021 3:30 PM, Andrew Lunn wrote:
> On Tue, Apr 13, 2021 at 08:56:30AM +0200, Christian Herber wrote:
>> Hi Andrew,
>>
>> On 4/12/2021 6:52 PM, Andrew Lunn wrote:
>>>
>>> So what you are say is, you don't care if the IP is completely
>>> different, it all goes in one driver. So lets put this driver into
>>> nxp-tja11xx.c. And then we avoid all the naming issues.
>>>
>>>        Andrew
>>>
>>
>> As this seems to be a key question, let me try and shed some more light on
>> this.
>> The original series of BASE-T1 PHYs includes TJA110, TJA1101, and TJA1102.
>> They are covered by the existing driver, which has the unfortunate naming
>> TJA11xx. Unfortunate, because the use of wildcards is a bit to generous.
> 
> Yes, that does happen.
> 
> Naming is difficult. But i really think nxp-c45.c is much worse. It
> gives no idea at all what it supports. Or in the future, what it does
> not support, and you actually need nxp-c45-ng.c.
> 
> Developers are going to look at a board, see a tja1XYZ chip, see the
> nxp-tja11xx.c and enable it. Does the chip have a big C45 symbol on
> it? Anything to give the idea it should use the nxp-c45 driver?
> 
> Maybe we should actually swing the complete opposite direction. Name
> it npx-tja1103.c. There are lots of drivers which have a specific
> name, but actually support a lot more devices. The developer sees they
> have an tja1XYZ, there are two drivers which look about right, and
> enable them both?
> 
>         Andrew
> 

Ok, we can agree that there will not be a perfect naming. Would it be a 
possibility to rename the existing TJA11xx driver to TJA1100-1-2 or is 
that unwanted?

I agree that it should be easy to find the right driver. Right now, 
there is another device called the SJA1110, which has a very similar IP 
integrated. It would be possible to use the driver for that device also, 
even if this is outside of the scope of this submission. Going for 
wildcards, we get to xJA11xx, which is really undesirable to me.

In the end my hope was that people will look up the correct driver 
through LKDDb or similar and will find the matching devices from there.

I am open to any suggestion that leads to users finding the right driver 
and that also work for future devices.

Using your example of an NG device: My assumption is that the things 
that change are covered by IEEE standardized registers, and thus should 
be implemented as part of generic helper functions. The things that are 
outside of the IEEE scope, e.g xMII interface configuration are generic 
and can be contained in a single driver if the registers are kept 
software compatible which we intend to do.

If nxp-c45.c is to generic (I take from your comments that' your 
conclusion), we could at least lean towards nxp-c45-bt1.c? 
Unfortunately, the product naming schemes are not sufficiently 
methodical to have a a good driver name based on product names.

Christian
