Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB6545604C
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhKRQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:21:19 -0500
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:48448
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232656AbhKRQVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:21:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyCNKzixG2lD71IEmxX0xg7uvMDRLYLzWcQDjqeOXyzG5Z0aJSIeG5307r/uMRKi4GvuOK7vltTeJhMgIWDFiHy2BsNDS0RPTCsCMsjYyMX/6qDjXkI2zrhKNPY9VPUp5AzjZvSZVkDm5OFhsABlbGMyPOvRp0BUJRRgnWS9fF3L//Shh8UrVg5Sqfy+M0yF+/Vcm1LahXLCvWCyELlOabyPjkGQdwag2QbO8Ff/qD0KJFqnof+rSEcHiS7A4m4A1TdX9XI+Q4+B/WYujZSGFtSFVCHi790rvYFSk+5eiE9KUOo1Z/P+2YIBSHLPX6UETuw1U0BK0nmi4P3+F4be1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTV7eVQn8PNxF/iLlkK+7GnEzNR3ZhnS2R1dRwYAiuo=;
 b=kCavLnBKTFUu2Ft7v8/Bdl1HIt/y1VMTploMhxnlX403rGg6s3i9bL3UZoupP9g8AAGsEbAh3f/e/jbcxd7OCmwO9vdUzcHXucP28NxJUxBG/t7+0ky3E4MI35dNiD29t49BHQgpH/BK4MHpH0DygFIjQVDag2Rn9c9Ti9FSdnEORGIUWw8/SoXbLP0+m/gDuVtKSvG3CjVrsxKjqnsyoOz7RbVUSEwGsWje+0LAXloc04AgBqpoxi+b0WdANXzoNIR/R/I41sLos4iuj6DrZqJnBye35n5iUEb9+szES/mdB2BxfF7NPT0miTXz6Gd3J8GkH/hp/TSBvU/QuYen+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTV7eVQn8PNxF/iLlkK+7GnEzNR3ZhnS2R1dRwYAiuo=;
 b=4Rz0e/iNpgZsxoZCM7L6yVU2h7TByAunJ50a04FEHSiSW6JQ27nOKfpSipJfLO1MT8LwOLR62qJzIyyfHrSXSI7W6P2hvoIxOhGYxtAwmF4M3lUnjkws4nB2IQ4m5G+YiVw/PZ7gohgZomskmnF16lpB6Qvc8g22XiGik7ejbFQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB6331.eurprd03.prod.outlook.com (2603:10a6:10:133::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 16:18:16 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 16:18:16 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
 <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
 <20211118095703.owsb2nen5hb5vjz2@soft-dev3-1.localhost>
 <YZYj9fwCeWdIZJOt@shell.armlinux.org.uk>
 <20211118125928.tav7k5xlbnhrgp3o@soft-dev3-1.localhost>
 <YZZVn6jve4BvSqyX@shell.armlinux.org.uk>
 <e973b8e6-f8ca-eec9-f5ac-9ae401deea81@seco.com>
 <YZZ7KwKw8i6EPcFL@shell.armlinux.org.uk>
Message-ID: <5768b2bb-b417-0ea8-5d80-3e8872ee9ad3@seco.com>
Date:   Thu, 18 Nov 2021 11:18:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YZZ7KwKw8i6EPcFL@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0366.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::11) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0366.namprd13.prod.outlook.com (2603:10b6:208:2c0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.17 via Frontend Transport; Thu, 18 Nov 2021 16:18:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75270414-6637-49d3-80ea-08d9aaaf06bb
X-MS-TrafficTypeDiagnostic: DB8PR03MB6331:
X-Microsoft-Antispam-PRVS: <DB8PR03MB6331225C037CBB78400E6DD1969B9@DB8PR03MB6331.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0v6gh1eEfN1OejoEjkZzz04cuxEEQUKWeTe3WWGvvoKxqzgPvEnbSX5lyIEItqmEhBgdlg4SJuwiXF56pbM46D7RlLbv1yRSP1IrvoEpwFp1vRQbXjmljV3WIWQZfKrp5of8b+1zSuyfrKRLwHoW59sQCpCIaT++UZipX8g/LGC8xL6i3ovVedMu213BP98Th7mGjoatQaCgOhcGR/5IvOwYWnM1X2I+zw655ppYydueVFR9ve5oNoEVVecmfUwAPQ7hnOrGO5HMApLKQbiFS3Jb5W5yLdiaw+e/K5Dm0oDIwUA3+PXHF/9wsPja1MyXvmpe3WtFXHjtK0NK4VGYjl7b5M7tb8ltg/BocYu8Aw8DSPIxwAWNW0CnQwcu0bp3bxqJ8+GBQF8uHDicsbyd/ak2Kt6Qxy2cG8rY3ODEBZtbpyDGqsTGHq+ObRDQ5Yb7IEox1S/S1jqMSZXXyvS/xtSpnllBg1HzK6Qypv7rdZT/iA2jj06z9G95vd0FEz+fVPDZmh49wCHqEaM3SmIYReNkk/NzFXv2ea0+T0UOQaMWbQF2fMYbq+FEQTs9jzzcMi6gMkXqzzS/WZv/KwXJm0HRXQp9AL3V+B7tQvE/56100fQnOLoWpPRAnBnLf4ZvKtP7fLUIVUNOp93Q39rGhpa6TyWRIq9MtpSr20rePwVLsdobQ/yTiEpHTg1uZ0HmYYWV1EZRptPUPGWMipGou5luB9H1PHUuhxTv9lK3E86/CLobI/syBZVbMPSpmiQ14rCdek73W/AUbyUKO4V0fslY/LaEiYTccQ52kObkzhUQfhGwE1BwBlbV0LwGhRqzAC2gahKeTperG6vl8TVuw90O19LQIWfUXhqCM5NG6V4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(53546011)(66476007)(508600001)(16576012)(2616005)(86362001)(956004)(66556008)(2906002)(6916009)(31696002)(966005)(66946007)(38100700002)(8936002)(83380400001)(38350700002)(8676002)(31686004)(5660300002)(26005)(6666004)(36756003)(316002)(4326008)(52116002)(6486002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUxJNUJMZlZNbmN0NXJjdUJkanRmUzJyYkh0QUdVVFNhYTl3ZmlER3FlbWFj?=
 =?utf-8?B?WnhKWEdXUXZveVpBMWlNRnVrU2prYi9Jbi9WcEFtUEhsSHZQbG9uUDlSU0tk?=
 =?utf-8?B?TXA2RUkrYm02cC9DYk5KKzN3WFNqbUc4NGtiSWwyd05sR0sxVTlyRG1zNUpv?=
 =?utf-8?B?OFZGdU4xdWN3eW4rZDl0TndhRVY0RGpaQ0hRWHV3K25ZeEthN0VNeGZEV1Vm?=
 =?utf-8?B?QUljYVBGeVJKeGpLNG1Yb0xyZjZ1Yk9RbEdxVnJxSExoSTZDRHFmc0k2RHdS?=
 =?utf-8?B?OExkU1FmbXk2SEsweFBGaW9LdmVyTlY2ZHVNakp5VW5RVGdnQW5xNHNtd1ow?=
 =?utf-8?B?VlpUUlRjU3lzS2o1bUV1blp2b2RDa1RtY1pxd0pPZGJYVk8zL25aZFYxSTdK?=
 =?utf-8?B?TzdvVXVHaklrS24vaXBLbjQ4VUx4NDlmc25qQkFPME9jRzNnRTFwSTF6R0VQ?=
 =?utf-8?B?bEZGOTZKNStnVGxlSjAwSlEzK1NkV2p5dXBDTlMyeFkwaGI4ZDBzT1QzY3By?=
 =?utf-8?B?Y2xZYUgrbUlLalhjTmJ0WlFXa2FWeDVZYS9iU09rc2g1QTJwWUlqOE05bzRs?=
 =?utf-8?B?UmxKRXlSZ0JpYjllS3hVWUNRZ21Xa3BIUVh3RFVLTjh6V2l3M2NvNEIyeEMw?=
 =?utf-8?B?Y0doeGljZEp4Wmh6djcrYzNFMnNidzRsdkxDOGsyWkRuUHluejMrS0ZvV1Fr?=
 =?utf-8?B?eGk2WjBsRVptOVB4TENxK0crZUxtSUZORUtGdmtaaGwxa0Z6KzFXVUxSelE2?=
 =?utf-8?B?Q2cxcDR3WUhaR2JTdGI3RE8vaXJKNnczR2tXSURhNlY5c1hzcFFCaDNXWTIr?=
 =?utf-8?B?V0NjYy94bWZBemM2ZVVpZWhIcEtJWkJDMi91UGNHR2o3bEcxVW5zRUNvem5R?=
 =?utf-8?B?cXpuZHJnTSs2U3kyYmU0SmNDdSsvckpRT3Q0aDBQNTFSdGtnR0ViNFBCbVRS?=
 =?utf-8?B?ZnJvQWx6RzB4U0lzaGYvNEN2aHRFYTBvZE84NVZYQ3pWNll1QU5tVGtJUkw3?=
 =?utf-8?B?WGhTdGpMZk1BRFEvQWFtVkxWdEVPM1ZDaTlWbVlhK1RDN0prbGF2NW1QT2o5?=
 =?utf-8?B?dFNFVXZxVTk5VG5MbGoraHFITHZTY2tEVmdtOXlRT2l1VjN6bDEwSXdUeWJQ?=
 =?utf-8?B?SHVlZ3ZLSU1lWEo5MVBFSFhSUUtJR3ZXL3Azc09IMEZsUEwyYU1vdXN2UmhL?=
 =?utf-8?B?RmZ2VHFnZ1pDdFNyY2M1RU9IaE1KdkZjUkcvTmI4aW5OQWxjYTJUZGF5MndF?=
 =?utf-8?B?VmUwbG44NTJIWnA5ZDF6VnJvaUxLL3JDQlhOcU1BUENPZFJtSjhub0FNRTll?=
 =?utf-8?B?Y2MvNStlMFRwTENRdlNDaXdGOFZFOVo3MXU1SjVPbmFrSEFCYmZDakN6bjcy?=
 =?utf-8?B?WTZ0VTRvUjhDRDF3d05TUXFxZU1wSlRGcXo0WU1HU2M2dENIVFVPcXNEaFpW?=
 =?utf-8?B?b2YyQjBFRWxER1VveWxHdFcvYzVJRjNyaE42NkwzU3FnNVQwMHZtUGUvL3o2?=
 =?utf-8?B?U0l2S0ltaENkRWpMbm5ycWExQzlFc3E5R3NpT0FhVjd4WDBza0ZUQWk3YjR5?=
 =?utf-8?B?SStTUElSSXl1OUlBcEp4Y25IOERBRUhQUDliaE5GemZYQ2gwZ2ZwcXB1M1h3?=
 =?utf-8?B?b2ZxYkpISU5EVkVEc0hqUThuY0ZTcm1KZitrYmhubFBuMk1RbmRMdTdmalhO?=
 =?utf-8?B?aXpXaEhFZWROSTNhdkNnSlhIY1pjNFdGOVNNODZaL0Q5UDI2by8wUVFwbFFV?=
 =?utf-8?B?SUNrSStWMk9lOUoyTmlhT05VMkVvcWxYWXd0OThvK1B2eHhYQmVTSzNpZ0R3?=
 =?utf-8?B?cG0vNVV0OHE3RW44MWNHYmlHakdQRHMzU0RROThqWERjdHVvNEdZTy9WYWxk?=
 =?utf-8?B?SDJ3WFI2OVY1cmh4YzYzYkdNaGtFeXFkZU1GSzc0SWFlcCtROTZmbSs3OGx3?=
 =?utf-8?B?czBUc1FNQ3hvTGZkMk9HeFRsbTRMOW53V3VScDQrMk1wS1lsWVdQQlJiZWVl?=
 =?utf-8?B?VUowQmJEZGVYZDV2OXhQeGlRQWltaUhzSmljQ0xIekE3VzA5VisvU21XdnFJ?=
 =?utf-8?B?bGRWMU5hR2RYdXVCSUZjQU9OS00wOUxER1hEZlRIaGV1SE5BTWZDb2JqeTVU?=
 =?utf-8?B?R2ZzY2VvcmRXMnRSTnRyd1RWT3FKRlY3d0FkMm9sTVVGaC9rdHJqcHVvOHox?=
 =?utf-8?Q?9erBr9/oNMl6oL13+dLbtlY=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75270414-6637-49d3-80ea-08d9aaaf06bb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 16:18:15.9735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIV+RxF3+CJys2mzQP5FrYuP9aSxD8Sl2cs6czKCf7xHrCWbMV/wIT9JsJEWrQkxZUJ6t+Sd+1O9K/SFSZrg4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/21 11:11 AM, Russell King (Oracle) wrote:
> On Thu, Nov 18, 2021 at 10:36:58AM -0500, Sean Anderson wrote:
>> Hi Russell,
>>
>> On 11/18/21 8:31 AM, Russell King (Oracle) wrote:
>> > On Thu, Nov 18, 2021 at 01:59:28PM +0100, Horatiu Vultur wrote:
>> > > The 11/18/2021 09:59, Russell King (Oracle) wrote:
>> > > > Another approach would be to split phylink_mii_c22_pcs_decode_state()
>> > > > so that the appropriate decode function is selected depending on the
>> > > > interface state, which may be a better idea.
>> > >
>> > > I have tried to look for phylink_mii_c22_pcs_decode_state() and I
>> > > have found it only here [1], and seems that it depends on [2]. But not
>> > > much activity happened to these series since October.
>> > > Do you think they will still get in?
>> >
>> > I don't see any reason the first two patches should not be sent. I'm
>> > carrying the second one locally because I use it in some changes I've
>> > made to the mv88e6xxx code - as I mentioned in the patchwork entry you
>> > linked to. See:
>> >
>> >   http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue
>> >
>> >   "net: phylink: Add helpers for c22 registers without MDIO"
>> >
>> > Although I notice I committed it to my tree with the wrong author. :(
>> >
>> > Sean, please can you submit the mdiodev patch and this patch for
>> > net-next as they have general utility? Thanks.
>>
>> The mdiodev patch is already in the tree as 0ebecb2644c8 ("net: mdio:
>> Add helper functions for accessing MDIO devices"). The c22 patch is
>> submitted as [1].
>>
>> --Sean
>>
>> [1] https://lore.kernel.org/netdev/20211022160959.3350916-1-sean.anderson@seco.com/
>
> Patchwork says its deferrred:
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20211022160959.3350916-1-sean.anderson@seco.com/
>
> However, it does apply to current net-next, but Jakub did ask for
> it to be resubmitted.

Well, he suggested that I would have to resubmit it. But I ordered the
patches such that they would apply cleanly in what I thought was the
most likely scenario (which indeed come to pass). So I didn't think it
was necessary to resend.

> Given that patches are being quickly applied to net-next, I suggest
> resubmission may be just what's neeeded!

Resent.

--Sean
