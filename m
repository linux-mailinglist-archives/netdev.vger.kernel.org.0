Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2869630BD4A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 12:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhBBLlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 06:41:19 -0500
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:3650
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229883AbhBBLlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 06:41:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=topicbv.onmicrosoft.com; s=selector2-topicbv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpEd1Obn3ROSML8zSAWBsgttbAvf7GPC5n/D8Matea0=;
 b=vhX0wZoWa+VJLnd36g+UlvzG1ZBd7nUKVFw9an+hmbjbI1uz8BxZ5lxNz9dI7Cctv37t/6ZsoMvREQg5XL3e5jxrxKa33pFvaIiif2S+mVdCisPvfexu5gGygFZKwr2eETdWHI+Pd0unC86CfsFDriiDbDbZY44g9jKCVkHjqGA=
Received: from DB6PR0301CA0065.eurprd03.prod.outlook.com (2603:10a6:4:54::33)
 by DB8PR04MB6905.eurprd04.prod.outlook.com (2603:10a6:10:113::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 11:40:22 +0000
Received: from DB5EUR01FT019.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:4:54:cafe::21) by DB6PR0301CA0065.outlook.office365.com
 (2603:10a6:4:54::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend
 Transport; Tue, 2 Feb 2021 11:40:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.68.112.65)
 smtp.mailfrom=topicproducts.com; vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=topic.nl;
Received-SPF: Pass (protection.outlook.com: domain of topicproducts.com
 designates 40.68.112.65 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.68.112.65; helo=westeu12-emailsignatures-cloud.codetwo.com;
Received: from westeu12-emailsignatures-cloud.codetwo.com (40.68.112.65) by
 DB5EUR01FT019.mail.protection.outlook.com (10.152.4.249) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11 via Frontend Transport; Tue, 2 Feb 2021 11:40:22 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (104.47.14.50) by westeu12-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Tue, 02 Feb 2021 11:40:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+kpJ3FtWbu8HK9GrQ78PkqZkvaJh9gaHPfnAYFyCkCMC9jEpaTPDmwafQKE9XJnKQjrLJ9D0PsPZo0eIE1tJr7EgKWQ5Va4bJ1G+rbV7DZQLh1CD6Xq8MUmsKE8P3lE3L8SCqE7nS4OmETr80ZfSGRXtviNKVJQ95W51rcTLsIGH1kb86BhL8m9VbQXPdTP5TbLkBnqGOigeIRwLn7RrHmbQnK0x8i9Jzv+eraNxxkR4WKn8twgFHOAL7GJK1KPtDx8NwlCo4gFoK3H4AePFH0mwzVSot1lo4t/fHzI2rg7ouZ4SkuBmWlNcO9tzNxv7TT/vHXG+F90hMPdNFUqCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbpoizplCu5SYv82B1AM8VvzJ2tjbEo2z/iNEdGaLow=;
 b=f6+DLf5r7Az8j7tyhiLqDenp20gT5sYxBs7u/jbipbpOjud8dWF+1sjJ5OLvh74gKJN1ZOXsp4FFNlf07K91oxaKHtm0qJ61ItRIpMzPunkMulcYp7ctY0DGZNFU8qKEZ7S1s8Y7JuRZeCPDKDb0HTuylHkvg2enrcwxLpk24YgdJdQC3O7OTg/3TBsgKww1vUakGcjRK457WU2Wu/8fwNIHKFoamioTh8cWyW3mq+HdPTZkWpkusV6sOl8Ul4Ja+iz0k7W8pChs5plL5VJRMeWvgHhSmse0U+Y6lBaARQRNrHtu3R1s2rc6snV01fWuzRM8kZ2YnEcIt3TDd9qQNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=topicproducts.com; dmarc=pass action=none header.from=topic.nl;
 dkim=pass header.d=topic.nl; arc=none
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=topic.nl;
Received: from DB8PR04MB6523.eurprd04.prod.outlook.com (2603:10a6:10:10f::26)
 by DBBPR04MB7708.eurprd04.prod.outlook.com (2603:10a6:10:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Tue, 2 Feb
 2021 11:40:14 +0000
Received: from DB8PR04MB6523.eurprd04.prod.outlook.com
 ([fe80::792a:b2ef:ed50:a1a2]) by DB8PR04MB6523.eurprd04.prod.outlook.com
 ([fe80::792a:b2ef:ed50:a1a2%4]) with mapi id 15.20.3805.024; Tue, 2 Feb 2021
 11:40:14 +0000
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
 <YBAVwFlLsfVEHd+E@lunn.ch> <20210126134937.GI1551@shell.armlinux.org.uk>
 <YBH+uUUatjfwqFWq@lunn.ch> <20210128002555.GQ1551@shell.armlinux.org.uk>
 <YBIPj+3QhWLr9zjT@lunn.ch>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.949ef384-8293-46b8-903f-40a477c056ae.47109184-a5be-4b1d-bb22-724baf83e536@emailsignatures365.codetwo.com>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.0d2bd5fa-15cc-4b27-b94e-83614f9e5b38.a2a17a1f-7cb0-46c3-bdd8-65266e08a153@emailsignatures365.codetwo.com>
From:   Mike Looijmans <mike.looijmans@topic.nl>
Organization: Topic
Message-ID: <7cbe00ba-d762-7e18-6936-ae8cbd493ade@topic.nl>
Date:   Tue, 2 Feb 2021 12:40:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YBIPj+3QhWLr9zjT@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [83.128.90.119]
X-ClientProxiedBy: AM9P191CA0019.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::24) To DB8PR04MB6523.eurprd04.prod.outlook.com
 (2603:10a6:10:10f::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.130] (83.128.90.119) by AM9P191CA0019.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 2 Feb 2021 11:40:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95356cf6-7f7d-45c8-1745-08d8c76f532b
X-MS-TrafficTypeDiagnostic: DBBPR04MB7708:|DB8PR04MB6905:
X-Microsoft-Antispam-PRVS: <DB8PR04MB69055268DD2B2E426BAE068696B59@DB8PR04MB6905.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: XuLenDUzayeZ+R/lJSCNfkluxU9Jrmw/rBP8WfSFkzYI/5N3p27L0fpwrljCGQCHI7XJSey7BvZvUhHDHR7ECCboFSz6DFFzZzswz7gjuIF5sP75ABE5JCTn2cZqEnXJdkDSQ42xwsScGG9y7oA0PRtxmpWog+zcMFBasH7/pIS5XAhdyZbE2Lb2aW1w3VitYHEFBC8eJz7dpd7euOSxS5O/dXb0IINDLLHAPCowuNcKvLi1oYJLYgMjR0tfB1TX8wqCf0ptx5/Ok9C0ydF5Z8D8buMkVPGUaa+1JHIf4Xqgqjto3n6MEVCgpM51M26t+6yGHnEZd3wJnH5Uw2XW/qTIXcvZCjdPZATgeMw2UgdGNvG93AnUTmPm61Y2FHTNKkZJILVTc1SU/LWfKVsPq2s/MLqko+yaX5GMsLKLugFByX5U7v63JMbAuxTOI1hzr/PBjF6/zBsM706mB+BDAjzGNQXJd5uiPDCDrP6K0OxjAUxp7jL/5gzQMA+qRiOzii53csHADRLdl+wZBR/CT04gttgS6/NftDg7IA37QpSZV4VA3R205hWeVJ/O3Gzc4Sm4hDuWZ4T2ZJmnTf2U4YwpRZ1Y7euhyikdzqGwjuw=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6523.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(136003)(396003)(376002)(366004)(346002)(44832011)(66476007)(956004)(66946007)(4326008)(2616005)(36916002)(52116002)(83170400001)(42882007)(186003)(16526019)(8936002)(16576012)(31686004)(66556008)(5660300002)(54906003)(110136005)(31696002)(478600001)(316002)(83380400001)(53546011)(36756003)(8676002)(26005)(2906002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d2VXZEJhSUNuN0hJU0RUNFRCTkIxWHRLbjRtQ2oybXhtOWJqTE9EdUxzRnkr?=
 =?utf-8?B?UHl0NXU0MkZ3NS9ULzN3cFZHT3pTSGdrQXVzMy8xbU9YTysrejU0UzY2VzM4?=
 =?utf-8?B?cWkwSTVFaHBYbDMxcDZDM2twbFV4Rm1wOHFtaGNJamc4NHlRODlHdG5KcFVL?=
 =?utf-8?B?a05zSDNMVE1GSHBOTTUvclNHdjJMTDlOSWxqVlVuaDBja0VHazJST1lCOEcr?=
 =?utf-8?B?SVh0ZnlhUzFCNWZZREkvd3BOeFh3MmoySU5IYWpyWTV3MDkwNmJySzFGbmZT?=
 =?utf-8?B?Q0FhN091dlY4MFNFSTQwOHBReWllaGgvVHBWUXJzdTRzSFY2WVFLUzQvRDd4?=
 =?utf-8?B?bDFmM0ZoNVpPTTZOY1lpNXVKaW1OcWFHWUtEUUExVWtBNUR0UWxNY1Z2UVBo?=
 =?utf-8?B?TUhGYUt0MFUvOW5kV0VzS3B5dVZBZmJqS0xaM2tXR2JoNy83allIcUFlZmwr?=
 =?utf-8?B?akxFaHdvbzNEUDRHTHJrV1VlVHZIYnJsaDFUSnJ3bWg4N2NOWnNxOTJVa3RW?=
 =?utf-8?B?cjdWNmdNbCtodGZBMnJDamprb3Frd1hoRjZ2Z0RmcVBzOE1SVDAzVGM3TVZp?=
 =?utf-8?B?RnNkcDRBNDhHNTlIWkh4OTFocHR1ZDJkZ2JPMUJuYXVhUExZRmF4OEJMeTZu?=
 =?utf-8?B?Q1UvSFFDYWVTNk1DUVYzZ2gwSXVFelRmT09ielJ6ZHEyYXZRdmxxT056NStR?=
 =?utf-8?B?T0dLUkdnUkZPMmlNVkplUUJMRWFDR2t4ZTk4RmtpZ0JuZjNPOUFvaFlNUDV5?=
 =?utf-8?B?QzIyUFlKdWZwZ3lzRzAzb2N3b2N0QU5Kb3ZVTk5XWENiQWNIdjh0bDBTNlNi?=
 =?utf-8?B?N3JpTXhjMTVKbHkxeDV4aWJoeWYrc2tMTFFQMDFNWVh0ZmM1VGJXeE5LcGg0?=
 =?utf-8?B?dkZEZlRBbXdKbmZxQkQ4dUxPWVo4K21XZlpnQ05ENDlnSzlvYWhESyt3TGY0?=
 =?utf-8?B?QlRERTYvWUFQQmpjV1dzTFJyeVlSdlk1ai81NVFvbW5BekwyYWF1cUNkdFdm?=
 =?utf-8?B?WTZkTDhtc1owVWNtREZQVW1IY0lSdlpUUU5tZTJXcFJWeFdCU2w1MmI2NW5P?=
 =?utf-8?B?V1orVGVidFIrV3RnWnU2bWdlNU8vaXQ0ZW8rTFJodk4xM2lwV2pqMFV6RExU?=
 =?utf-8?B?M2xFNzArNHIzT0xtc0xSaGZuYXEwbjJrMXZWQUtHbHBnd0UyeXgxSFN3SE52?=
 =?utf-8?B?UmFJNWRGT1FCY0pkSkxlRjZIM2JmSFpoelU3VVdjUGdIM21IZ3RxQ2FJazkx?=
 =?utf-8?B?blc3ck9zNFJ2Y3VaT1NQYmthU2ZVOXduTDBKVDBWSStHd2c1ZVNSR1RRZWJn?=
 =?utf-8?B?ZFhaQ1R3aWRlcG1YMy9rbktnN3dWZHc3dkJua256d3RQM2kyRGFycndzRXdn?=
 =?utf-8?B?Y0pINWN2MHFIRXc3VW81VUhMN1RKVjhmRnlaYUZNMExkSS9jSWpuczFCYzlr?=
 =?utf-8?Q?FHnRQRTe?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7708
X-CodeTwo-MessageID: 66bc30e9-e921-4574-9991-e8e0256c1925.20210202114017@westeu12-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR01FT019.eop-EUR01.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 635ae30b-2a35-4e4f-a294-08d8c76f4e53
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 67D3N1OMSNWZLcX5tPaNOlVFNGoabM3bT/oxLWDUbllP6Murv4kztw8pq6KaGh2HGSPRp5D2MItwIKFESmQSvUVLldt40DcVPQdEyagBsZcWc5ytzbnDn/Qsq0y4cqQWUWZ+HyPGMfF2lfgX9nJ/XTE2+i9MCLUMn8h/RzfKV1wgsIOmMX9+nFapFyHjzkC0lJtTbBcNJHjY7150SyHjmTfC+uYAELylmhFH7wL4KrPNyQhFxJXyYhERPVG5fw296Q1hl8i40LEVOE5d7cwdRfk5yod1ehUiGjxKB7Bu3vvLqdhVfXY9L8PCgEB7bEBL4VpxmV+GDfI2r6W6QCgEnV6Ul8VFCp4BF3OOYtQRn7MabtGD29P1AmNTvt43IJuViv8EFWOQ8nk+MHurVm8JlkSGIsjTlH0Z13GOcqy7GRSsX6jSqBe91N9ucGeXRy+dQ0o9fywS++YlZmYyBPwdCUwzh90+otjPt9KnuXKSWITSl4x+QDUhMeIBfGeI9lKYBeX2TS+TKXLsrPl1kuxtEM7xno5XxTF4v5tyxVu8z/w0BpD+D7/WCOFhpkcS+ipPnX+cidiVumle211JOohUL7uAOaXwupixJgVKAbjyl1kTjVXnmXfD+ANWcYAqbhiOi0ILo6SmaSQm/a9ObvQW8BcHlnRuLq69fY6Rvdv5epaJaAhgskZW6ENj+sr3VFOnemRxRlWPQqPsc6+0bImlOc/abATIuKS0MzpGo7c8/0xNN7xwC/HML44nf2CvvHI551P0cw3JueT6OAEzPQAzjg==
X-Forefront-Antispam-Report: CIP:40.68.112.65;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu12-emailsignatures-cloud.codetwo.com;PTR:westeu12-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(376002)(346002)(396003)(39840400004)(136003)(46966006)(36840700001)(53546011)(7596003)(2906002)(70206006)(70586007)(186003)(15974865002)(478600001)(47076005)(83170400001)(36860700001)(31696002)(336012)(5660300002)(26005)(356005)(2616005)(8676002)(4326008)(956004)(7636003)(44832011)(316002)(36756003)(16526019)(54906003)(83380400001)(110136005)(31686004)(16576012)(82310400003)(8936002)(42882007)(6486002)(36916002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: topic.nl
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 11:40:22.0246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95356cf6-7f7d-45c8-1745-08d8c76f532b
X-MS-Exchange-CrossTenant-Id: 449607a5-3517-482d-8d16-41dd868cbda3
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=449607a5-3517-482d-8d16-41dd868cbda3;Ip=[40.68.112.65];Helo=[westeu12-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT019.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


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
On 28-01-2021 02:12, Andrew Lunn wrote:
> On Thu, Jan 28, 2021 at 12:25:55AM +0000, Russell King - ARM Linux admin =
wrote:
>> On Thu, Jan 28, 2021 at 01:00:57AM +0100, Andrew Lunn wrote:
>>> On Tue, Jan 26, 2021 at 01:49:38PM +0000, Russell King - ARM Linux admi=
n wrote:
>>>> On Tue, Jan 26, 2021 at 02:14:40PM +0100, Andrew Lunn wrote:
>>>>> On Tue, Jan 26, 2021 at 08:33:37AM +0100, Mike Looijmans wrote:
>>>>>> The mdio_bus reset code first de-asserted the reset by allocating wi=
th
>>>>>> GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, =
if
>>>>>> the reset signal defaulted to asserted, there'd be a short "spike"
>>>>>> before the reset.
>>>>>>
>>>>>> Instead, directly assert the reset signal using GPIOD_OUT_HIGH, this
>>>>>> removes the spike and also removes a line of code since the signal
>>>>>> is already high.
>>>>> Hi Mike
>>>>>
>>>>> This however appears to remove the reset pulse, if the reset line was
>>>>> already low to start with. Notice you left
>>>>>
>>>>> fsleep(bus->reset_delay_us);
>>>>>
>>>>> without any action before it? What are we now waiting for?  Most data
>>>>> sheets talk of a reset pulse. Take the reset line high, wait for some
>>>>> time, take the reset low, wait for some time, and then start talking
>>>>> to the PHY. I think with this patch, we have lost the guarantee of a
>>>>> low to high transition.
>>>>>
>>>>> Is this spike, followed by a pulse actually causing you problems? If
>>>>> so, i would actually suggest adding another delay, to stretch the
>>>>> spike. We have no control over the initial state of the reset line, i=
t
>>>>> is how the bootloader left it, we have to handle both states.
>>>> Andrew, I don't get what you're saying.
>>>>
>>>> Here is what happens depending on the pre-existing state of the
>>>> reset signal:
>>>>
>>>> Reset (previously asserted):   ~~~|_|~~~~|_______
>>>> Reset (previously deasserted): _____|~~~~|_______
>>>>                                    ^ ^    ^
>>>>                                    A B    C
>>>>
>>>> At point A, the low going transition is because the reset line is
>>>> requested using GPIOD_OUT_LOW. If the line is successfully requested,
>>>> the first thing we do is set it high _without_ any delay. This is
>>>> point B. So, a glitch occurs between A and B.
>>>>
>>>> We then fsleep() and finally set the GPIO low at point C.
>>>>
>>>> Requesting the line using GPIOD_OUT_HIGH eliminates the A and B
>>>> transitions. Instead we get:
>>>>
>>>> Reset (previously asserted)  : ~~~~~~~~~~|______
>>>> Reset (previously deasserted): ____|~~~~~|______
>>>>                                     ^     ^
>>>>                                     A     C
>>>>
>>>> Where A and C are the points described above in the code. Point B
>>>> has been eliminated.
>>>>
>>>> Therefore, to me the patch looks entirely reasonable and correct.
>>> I wonder if there are any PHYs which actually need a pulse? Would it
>>> be better to have:
>>>
>>>   Reset (previously asserted):   ~~~|____|~~~~|_______
>>>   Reset (previously deasserted): ________|~~~~|_______
>>>                                     ^    ^    ^    ^
>>>                                     A    B    C    D
>>>
>>> Point D is where we actually start talking to the PHY. C-D is
>>> reset-post-delay-us, and defaults to 0, but can be set via DT.  B-C is
>>> reset-delay-us, and defaults to 10us, but can be set via DT.
>>> Currently A-B is '0', so we get the glitch. But should we make A-B the
>>> same as B-C, so we get a real pulse?
>> I do not see any need for A-B - what is the reason for it?
> If level is all that matters, then it is not needed. If a PHY needs an
> actual pulse, both a raising and a falling edge, we potentially don't
> get the rising edge now.

We only caught the "spike" because the reset GPIO was controlled by a=20
GPIO expander, so it took about a millisecond to toggle it. With a=20
"local" GPIO controller, the pulse duration would be below the=20
microsecond range and most PHYs would never see it.

> But the datasheets you have looked at all seem to talk about level,
> not pulse. So lets go with this.
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>      Andrew

Just wondering, now, a v2 patch isn't needed? Or should I amend the=20
commit text?


--=20
Mike Looijmans

