Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF6A30542B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhA0HNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:13:18 -0500
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:36607
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232816AbhA0HJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 02:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=topicbv.onmicrosoft.com; s=selector2-topicbv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2CxBMYWWE207p5mSWB/ojYUQI0DMyfEsI7RtZmADiI=;
 b=WfhJ4uvfO4mLUa7sftSaj6j0WbtjecyupvMHc851uAF+Msy3aGvIqqXMuMarUxHQXuN2e8nkWqtlymPyhJvyCBuy2d6l3AtZ5W3GH6jNrez/2aUGUYKBFWvadjOYlWhTPb4r5+osr2WP87aSKruOPw1N+2wevQW6gLu3oAWQhxY=
Received: from AM5PR0201CA0004.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::14) by AM0PR04MB4708.eurprd04.prod.outlook.com
 (2603:10a6:208:cc::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Wed, 27 Jan
 2021 07:08:37 +0000
Received: from HE1EUR01FT044.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:203:3d:cafe::c2) by AM5PR0201CA0004.outlook.office365.com
 (2603:10a6:203:3d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend
 Transport; Wed, 27 Jan 2021 07:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.68.112.65)
 smtp.mailfrom=topicproducts.com; vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=topic.nl;
Received-SPF: Pass (protection.outlook.com: domain of topicproducts.com
 designates 40.68.112.65 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.68.112.65; helo=westeu12-emailsignatures-cloud.codetwo.com;
Received: from westeu12-emailsignatures-cloud.codetwo.com (40.68.112.65) by
 HE1EUR01FT044.mail.protection.outlook.com (10.152.0.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11 via Frontend Transport; Wed, 27 Jan 2021 07:08:36 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (104.47.14.58) by westeu12-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Wed, 27 Jan 2021 07:08:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixo13QSMOVR0fU+fbmfp8l2sogW/SWlit+spzyVymFi4BoJOotgbQr40HUBnrCWs6A396IgdTW/qtcVm+VNtYj5BiZQILBBql2RWFMu0s3wyF04RLoDHOkskAr3Qf2mKbkwAFZdZ4gtySoS7+PnqPygIe9Mjq2fsw62GPb5Tv5Wik2jOqOIyPfPzJ4ASWFPOUvV5tD2AR6HqY0JXwrH9YiBUIvr2xFvlDSas7PCRp8jgBjJKF9L30ldku6Ng4G+hzklIgmEsgwXBK8t4E4CNNE78lnkFYAkcuIEkakln1QEPEHyPr7cQ76M/ywBgtgAa3OLHLFRBOyuIt+W/uHdZkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Q4pQ8mM50XIW3ylAtcWNkEly6XuK2vpaJPVfK3PlpA=;
 b=jgsNTS46T3AdXaAmyW5hnriev5YD+zUhdYUPpwO6TJn8iRNDzdw0bOtbLP8AEfra6j6N3A2NReo+ZDGPN9ZzrsG3Nyc8qOzCeMpF0zcCgL39f3zdUAJ1a09hPypWJ9Blmmr5fLXWTvLNhf/M3sSrqyZeU/gjLbaXvAziYxEUmcZRCquK1qcp96/ru8JeNp6YuOqgiF3Vuivcfc6ua2HEdEozsKwxEa0V0yomWLAP4DCT9o/NnkvcD+sjBFY6K5P8V4mUDqko+yA+r13eK9PnNP0RBxtkk2arBRf8KyFxR5Gh+/M4d71j4rIkDK9aaNeQhnkrdJuV9D6kMoBMplJCfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=topicproducts.com; dmarc=pass action=none header.from=topic.nl;
 dkim=pass header.d=topic.nl; arc=none
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=topic.nl;
Received: from DB8PR04MB6523.eurprd04.prod.outlook.com (2603:10a6:10:10f::26)
 by DB7PR04MB5099.eurprd04.prod.outlook.com (2603:10a6:10:18::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Wed, 27 Jan
 2021 07:08:32 +0000
Received: from DB8PR04MB6523.eurprd04.prod.outlook.com
 ([fe80::792a:b2ef:ed50:a1a2]) by DB8PR04MB6523.eurprd04.prod.outlook.com
 ([fe80::792a:b2ef:ed50:a1a2%4]) with mapi id 15.20.3784.017; Wed, 27 Jan 2021
 07:08:31 +0000
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
CC:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
 <YBAVwFlLsfVEHd+E@lunn.ch> <20210126134937.GI1551@shell.armlinux.org.uk>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.949ef384-8293-46b8-903f-40a477c056ae.b4d05392-d8bb-4828-9ac6-5a63736d3625@emailsignatures365.codetwo.com>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.0d2bd5fa-15cc-4b27-b94e-83614f9e5b38.23e4b566-2e4d-4160-a40f-4bf79ef86f8a@emailsignatures365.codetwo.com>
From:   Mike Looijmans <mike.looijmans@topic.nl>
Organization: Topic
Message-ID: <c640eb02-fe31-d460-521b-c7e5b85f016f@topic.nl>
Date:   Wed, 27 Jan 2021 08:08:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210126134937.GI1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [83.128.90.119]
X-ClientProxiedBy: AM8P192CA0028.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::33) To DB8PR04MB6523.eurprd04.prod.outlook.com
 (2603:10a6:10:10f::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.130] (83.128.90.119) by AM8P192CA0028.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 07:08:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b220b1d-0b93-41f4-195c-08d8c2925da0
X-MS-TrafficTypeDiagnostic: DB7PR04MB5099:|AM0PR04MB4708:
X-Microsoft-Antispam-PRVS: <AM0PR04MB470857710F176F0D47E02DA596BB0@AM0PR04MB4708.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: naUtpIjttO+yhWFUXF7FwLg8QVgPiUSD+QmZX7Av03Wnb5dFlJ9/qXSf1kR3iV3yaIWwoLqgAA5hPpK0vI+TBhQ9cPzf7UPWHLhkJKXQ+JfqT2agKt4rKgFbYBnOokcZiZdpC3zkso5tqcu12spMVAAbs65LqIQXXWH8lX20O9EYMrPaBDuNjyffecCEdW6ldGvkoOB+bIy4rl4OHRmORf2McajIVUxSEUo/lqROCOYbQ+ofVP3UGlyt1Kw1jZdq5c8n8XJUSVjbHc68DBVxK67741XejEGx/Mb/BGiQNPZ04qJ6m9yj3qRt088dlhYnpLryoXU6iRbT55lkjaGah997jRpOlJegUiDDLWAWDSYCltXVZq/CvJdu2/yL6R7NFPf07MM3yAH1UFOqY8Y/+qmDzSwpGXd90FuHRYAPd/4fjyJIi8al1w0sWzEzZIb4gevXYua60tOFzHR6sYlQREwW7maiDxCISBpxEXXRtECXFPrk0qZH4U7lxdBoJMipEeQwtJP9ILw3D6t6QSas4HjdcfnS1Rm6iLnpvWr3nOS9t/Gb7fFyZyfUEpTvhGlfILkli/n9aaYxqR8v1ZS9PRmKiZPMfNHkaOQWKcVRiT4=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6523.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(136003)(346002)(396003)(376002)(366004)(26005)(16526019)(83380400001)(31696002)(316002)(186003)(16576012)(4326008)(83170400001)(31686004)(42882007)(2906002)(5660300002)(956004)(52116002)(36916002)(110136005)(66556008)(8676002)(8936002)(2616005)(66476007)(36756003)(53546011)(6486002)(44832011)(478600001)(54906003)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VDBKbTZrTGROV2x5WHo2UzlFNkx0YzV3Z2hjdlZCaEsvRDgvMTkyOGhCRVk2?=
 =?utf-8?B?TlYvaEV5L3UrZjR0OWpnNEtiS1NGUTBqZkxVd1BWSlhOeGFBd3JrTWZRdWNT?=
 =?utf-8?B?a2MyTy9vSUFpZ1FvQU1mRTlqam82NVpSdGxrMXBuUjEzQ1VjTU9NbURiZmRH?=
 =?utf-8?B?NjhEOFU3OXJwNTlhOXpNQlhhWWpjUjVHWkJTUFUxN3JMV3hpT0lzWDlBWEJo?=
 =?utf-8?B?MzBGSTc0QlpLbE5Kelc0OVcwQzYyb29Fb1RQcW5oNHA0SU1GeW03Z29CYkgv?=
 =?utf-8?B?eVNpeVpVNllHdWpMSlNMaGxjK3NwQm5LMzVyZXYzeW1PaHZBcThGQzVwSkRk?=
 =?utf-8?B?TUY4bU1zbVlMeVplcHVqUzlvNUk0TTlnV1YyMDduRDRZSUlEYnlDaFE2enRL?=
 =?utf-8?B?N0RGbzlaN283YUtGaFJBUW9mRmdPVHhKUFRkLzhzRE1VUU9BT3NhSS9zb01l?=
 =?utf-8?B?eDB0aVByNXFzMjluYTdacDlGTVpwbkNhR1crdm5rSUNqU2MwQmtaSDl2QVAz?=
 =?utf-8?B?TzZXaE4xM3ZaUVJCbjJqOFpQMHZEa3p5MVhmY0lHL2ovMHcvVnBZOGFxTUhE?=
 =?utf-8?B?VmNneW81MmJoeEpxQndEeEYvRUh0bllUNWNuTjcyOXZGS3M5R0hzZGJJd3NJ?=
 =?utf-8?B?TWNmWXVTYWEzZ08yNnhQM092eUI2THZjN1A1YlJES0NSZlBzUFN0UVR2d0wz?=
 =?utf-8?B?ajhSbW54OUkxYW1PbkdBWVJRVzJDamtkUEtBUnBqdmswdHNPakpMQUxkY2hP?=
 =?utf-8?B?UW1kZWNlVGJ2dGNseGJ1bE5JcWlXckRBZkJ6UVh0NWUrQkdRaUNKY2gzNVEv?=
 =?utf-8?B?WkhxdlFXb0piTXR2bk9PME5kaHpQV3ZEWG1LQ2tDVm1BS0dEeDdESXZRWUVm?=
 =?utf-8?B?dG9MRVB4YWJvWTJ6M2hoSEdmTm13UndGR2lNTUdTUXEyNlBsOWxlU0dEVVMv?=
 =?utf-8?B?ditBTUxoelZhOFB3cUJxbWpucGhDVGw3S1dmLzc2R1NYYXpyT1ozTzM1aTla?=
 =?utf-8?B?U2RyaStrVS9PYmRVQytnZkFrNTVzTTZDZm9WSG5xN1hMUnZpUGZFWThjQ2ph?=
 =?utf-8?B?cDg5SThNTTdXMXE0VU1xYUlRTFVsc2FBZEJzYlhmamRrR2dFTWJrYUJROXlj?=
 =?utf-8?B?TVRISER6cEdZdjJVQklSeUV2RGF1R1krMklSSEFiRnZvdjNtdFJPc2hTK2Y4?=
 =?utf-8?B?RnovNDhJR2VudFpZbEMvbnArNnN6MzJZbEg4OHR0MWRMejdrb1EzeTJEcEY2?=
 =?utf-8?B?S3pqb0lyRGdGMnpUcThSL1E2aVBBblNtTGJqZWpUNU9mcEI1R09pb2hjbndC?=
 =?utf-8?B?dUtaSFNRcTJLSTJ5VlFRL21JVitYT2VTLzdiSDFDd2djZkE5K1FGbURnTGJG?=
 =?utf-8?B?YWx1Z2IyOVdmYXVvcUVhMU1tRk54L2RVMCtLYU5FcXR6WWE1d0VISTdBTzhl?=
 =?utf-8?Q?Iuk/u+UQ?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5099
X-CodeTwo-MessageID: bc024f64-9bcf-4c7a-8dfd-a4b294762598.20210127070834@westeu12-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: HE1EUR01FT044.eop-EUR01.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 588ee1e6-3b43-4de6-9d79-08d8c2925a73
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZxgwupjmbKX0p3QwJlQddhm175IGkUaA8yd8EWcR3fYTIp/Kf7ePTBB3yR9dAlEV1pEoAHVNGA2rqlZ8jWHi/lUqTmg1U6n3UoCVsh5yEeWeeoAbEEihEOtvq3h08aJ1S1ukwHezfXEvEgQ4XfLf5RFw7FWjn41aouK8/sMOE5Y6YLBNPRXEdFleOq3/QDWmTmbtE/PIfPxtJ10TIfMilAF19WIjQHdBPCf3YzeP3GJspWag1BDKDHl4aEwOt6p8izTXMj881bK7WU0V/UfvGW3+3JQll1RHMSrLGNbcdlGc8VP8ZF3II3/Llc8LJ7NLcgWIdtk0TzcYQ616UeIiRU17RCrlDnoDu2VZts/npiwuu11DuLNIy/Qz9K9cEQkjMunq70Bvo92iLmzbecM0PLioV/+A2nYR4ZPVxI2X3bLL3FucNI2W+1aL/E/Yadb91ICGuhgIElKG0tayJm1gaEsRYQzyfEC/sEZcxf854vg9LXT/QiWFCCtoqcHhcnLj4ExFXAPjJmnsEZmCa6IiQ89mqe4OY+rrD6htt39Yhh4lsByaRqzP7aT8ByZaA0l+KUG8zFe2Vj+ZIJO8z2UHYH1waxPxTGwILGhyPnTWK4qE+CvEeR8k8H/+QbEKR1h0i4YoPvOhEMCwf8Zn3yEJDNraJ1f6Y7UwjfFCFnQSaUBSEU3CJm/LkQ/BHD4kRB+9A9PCud6KHBo5XuaGJeCYQ==
X-Forefront-Antispam-Report: CIP:40.68.112.65;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu12-emailsignatures-cloud.codetwo.com;PTR:westeu12-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39830400003)(46966006)(110136005)(53546011)(82310400003)(31696002)(2616005)(36756003)(83380400001)(2906002)(31686004)(26005)(42882007)(316002)(47076005)(83170400001)(356005)(54906003)(6486002)(36916002)(16526019)(8936002)(186003)(4326008)(7636003)(5660300002)(478600001)(7596003)(8676002)(336012)(956004)(44832011)(70206006)(70586007)(15974865002)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: topic.nl
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 07:08:36.2713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b220b1d-0b93-41f4-195c-08d8c2925da0
X-MS-Exchange-CrossTenant-Id: 449607a5-3517-482d-8d16-41dd868cbda3
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=449607a5-3517-482d-8d16-41dd868cbda3;Ip=[40.68.112.65];Helo=[westeu12-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT044.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4708
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

See below.


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
On 26-01-2021 14:49, Russell King - ARM Linux admin wrote:
> On Tue, Jan 26, 2021 at 02:14:40PM +0100, Andrew Lunn wrote:
>> On Tue, Jan 26, 2021 at 08:33:37AM +0100, Mike Looijmans wrote:
>>> The mdio_bus reset code first de-asserted the reset by allocating with
>>> GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
>>> the reset signal defaulted to asserted, there'd be a short "spike"
>>> before the reset.
>>>
>>> Instead, directly assert the reset signal using GPIOD_OUT_HIGH, this
>>> removes the spike and also removes a line of code since the signal
>>> is already high.
>> Hi Mike
>>
>> This however appears to remove the reset pulse, if the reset line was
>> already low to start with. Notice you left
>>
>> fsleep(bus->reset_delay_us);
>>
>> without any action before it? What are we now waiting for?  Most data
>> sheets talk of a reset pulse. Take the reset line high, wait for some
>> time, take the reset low, wait for some time, and then start talking
>> to the PHY. I think with this patch, we have lost the guarantee of a
>> low to high transition.
>>
>> Is this spike, followed by a pulse actually causing you problems? If
>> so, i would actually suggest adding another delay, to stretch the
>> spike. We have no control over the initial state of the reset line, it
>> is how the bootloader left it, we have to handle both states.
> Andrew, I don't get what you're saying.
>
> Here is what happens depending on the pre-existing state of the
> reset signal:
>
> Reset (previously asserted):   ~~~|_|~~~~|_______
> Reset (previously deasserted): _____|~~~~|_______
>                                    ^ ^    ^
>                                    A B    C
>
> At point A, the low going transition is because the reset line is
> requested using GPIOD_OUT_LOW. If the line is successfully requested,
> the first thing we do is set it high _without_ any delay. This is
> point B. So, a glitch occurs between A and B.
>
> We then fsleep() and finally set the GPIO low at point C.
>
> Requesting the line using GPIOD_OUT_HIGH eliminates the A and B
> transitions. Instead we get:
>
> Reset (previously asserted)  : ~~~~~~~~~~|______
> Reset (previously deasserted): ____|~~~~~|______
>                                     ^     ^
>                                     A     C
>
> Where A and C are the points described above in the code. Point B
> has been eliminated.
>
> Therefore, to me the patch looks entirely reasonable and correct.
>
Thanks, excellent explanation.

As a bit of background, we were using a Marvell PHY where the datasheet=20
states that thou shallt not release the reset within 50 ms of power-up.=20
A pull-down on the active-low reset was thus added. Looking at the reset=20
signal with a scope revealed a short spike, visible only because it was=20
being controlled by an I2C GPIO expander. So it's indeed point "B" that=20
we wanted to eliminate.


--=20
Mike Looijmans

