Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E67422DB6
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhJEQTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:19:36 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:29315
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235259AbhJEQTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:19:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDGjOQ4+rD/DlKum+X5yoIpMRnvgw8TfRzxVfOflFc+liC/uoB9XPKtFlnFZHOxB1OizJr63BZTG2S2wN5YirqaBvZHEUFSHJeGEEAdyGnT7hzmIGLglP6W4y8RGrHdEivuYcZ99btAdpfYLOFfsMJzei4fDi3D23juvp2Ox+HLjSWIuY/1hd/9X2teyxnp1jAUoCIrDeE8CX0jlOP7LYOjtIc1kLHw/4wBlQy4hvrI1RPTljnd4wd7OGmQyg06lkiaPEdQzo/k8KaAoj9mMx+cVgopx1FdJgHeqr5cR3V1Z/FXVjpRKEJjJV8nUMlnz1OlMH4rCO50H+aXuFBtdFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qG4HzC8+34uWdPyXpPyapNSb8JU3foDoHW71OdGwj5k=;
 b=dSji8rhSwef6UTXjIf4idjyY509MPG3USoqdVp6teZ+zRwJYEyRd2mhGrSl2H6wKUo1iEbQx5yT8pZFR6k64/9YqepgDP1EnlA4oNkx236gOXs8RuCPA0aq6eaF5czr59yFrKNrv08iV42fkku85M/TMw4P3f+JdiVjej+AroM+zzcMlnD/J3w29Ug1bJ1eSLzG2Kyfp3PPE3KLWyJBViEdDSNSwU/r/A2tqdDHVKMwu7CQRJ4QIPNu7sJyOfLyl5HAaCRzfrtPG6TR4gsrZnblmxE6etBR2l0wjjEHxhU3qxAHiTbz3Bu6Hbt3ESx5wfT3LNiu8tIJaflHsR4k6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qG4HzC8+34uWdPyXpPyapNSb8JU3foDoHW71OdGwj5k=;
 b=3OP3mZ8wxj5APDzb0TvOmYLAY6xgnOVaRRK5tCZXvGVzS/hw1cQvEmDdWrMTvy24LqeHsuuVCmX9FOXhBCU8SXQZcxVQNu4lClAw250b1dgpKHAl1okvwrmDLUPHKI7/LqMEaslFbFTj7WY+9l1k/CqIipEK1HSGhIe2LmXlmfw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3659.eurprd03.prod.outlook.com (2603:10a6:5:4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.13; Tue, 5 Oct 2021 16:17:42 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 16:17:42 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 06/16] net: phylink: Add function for
 optionally adding a PCS
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-7-sean.anderson@seco.com>
 <YVwgKnxuOeZC6IxW@shell.armlinux.org.uk> <YVxWaif9jE/fCE0O@lunn.ch>
Message-ID: <9545e6d4-7d0b-736f-cb0c-a95d62aba6c3@seco.com>
Date:   Tue, 5 Oct 2021 12:17:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVxWaif9jE/fCE0O@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:208:256::14) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0009.namprd13.prod.outlook.com (2603:10b6:208:256::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Tue, 5 Oct 2021 16:17:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5345833b-51ad-49a9-c32e-08d9881ba8a5
X-MS-TrafficTypeDiagnostic: DB7PR03MB3659:
X-Microsoft-Antispam-PRVS: <DB7PR03MB36599DAAE120C4BCB87BF26196AF9@DB7PR03MB3659.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: us9lSXcll9wqAX8PUieOjVFXRsHBxp6kjjhi9KQZFxDvKROEzXM+PyllGx73LSh943s4sJRd2aASYKTUbDsCrvtF6r1nPSSXrevl5Yp8kFMHFva2h0Twj7jkuaEmu+7m39Z2ymgVltKEwurtQvhF/5cBgXdWAF1R+5SE+PahG/ZGoPzsRjTA9S4nftcNjnnqnN9j68r2C9+fndrHBsj8nkN+vzSbx2yDiO0hNqzeFLkSmelYx+Kdas1yeSicT+nZoJjvn9Nf0Tq/MjScb+El8MPSzGE0fRrUgSkn8qkLVqCKhtpPwW56KcCCe66bKki0kBAI23IJKBE198ikO2I8Ni5fZgdW8lUMXkNNQUYeB+uPIQ/K6Qa5AYPTnxOjtECNimdHvQDfe9928qq6fI832Yz3AH7Gn8U3wDkHdhHFjvOaX340xbwdhK8uTU+imNsp+zozNbvMmmD9kIeJQ3oJX3ryOkVr4OWd6MQ+Wfx+7m8AHNNT9yYEyYV5MFs2VhWP6/BHjwBxEQ7ykdXQ9G/C4fLhBLXFBHKMfJkN+NQC0jh2J1OVbuqAM+8Zbvmi3dkzKUsHKDD89pxohKXmKmHh9nBeV47jlJ5EVBsxkMwTo3BLNlRnWmZ46Yn3HXcNFoWlQSuCZBfjknrwrrNHasZSEco8VEZHKDqYRwTcL9/IDec17zu3m08Xg2jMRoVqAKt0PWemxIZhM/uANpaOBdSJlH1mSiR+fVA7rie6UwnRM2/G2TuL/lDfvgyh6gnUCr0H7VreQbfHzjsfOI9zwLByyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(956004)(44832011)(2616005)(4326008)(26005)(31696002)(53546011)(36756003)(186003)(2906002)(66946007)(6666004)(508600001)(86362001)(52116002)(5660300002)(54906003)(8936002)(8676002)(38100700002)(31686004)(110136005)(16576012)(316002)(83380400001)(38350700002)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3dSbjBpN25aSEdpS0p5NXNlcUJ6dml0MHc4UjBaOVpuRlovTDEyZFJCczdu?=
 =?utf-8?B?ZGhCM3ZMZW5ta0cyN3ZnSzdjZmM3TjlmZkRXMHdzWUg4ZGtWelcvYW1BMjlL?=
 =?utf-8?B?NmNjbS9Ec0xRVi96bjdMLzJGY0RmakhpeVdSMllxblpBS2Y0VnE5eUN3MTkw?=
 =?utf-8?B?NHBKaWJYeHhYVldDMHFnbHpxNWMzbHo1L2d3WFJYeWhQRWFmZ1hJY0l6VWlr?=
 =?utf-8?B?RUtsL0JtK1hCYTZYYXhQeVdycTdVSFI2TVZNbEVGT2xyNHBReEY0OU1YVUIx?=
 =?utf-8?B?emNiQU9Pd0VmLzVpRzM1UmhCMmdBcE5mTWFBVnJyTUNzaWVCYng2YkFwZ01a?=
 =?utf-8?B?V2VTSDFISHJjK1J0alpGVUM3Q3pIR3k2Y0R4ZW56SnBYTDBXNFI0SlE2M3pL?=
 =?utf-8?B?L1ZGektQT0JkYW5zb0phSXhwaWxCbnE2MXpROElRaUU4ei9rVWl0U3hCTmc5?=
 =?utf-8?B?UWFPNEhCTEE1VjdNaHYzcnJWbnpvUERXY2UybWd6YkF5dXJaeU45cGxlbThJ?=
 =?utf-8?B?a0t6cU9ySDhYaFU1cHl1dFJqeXZxWTB2eUI0UEtqTzA0N3lnOVFxb2ZPMjBY?=
 =?utf-8?B?bitjRVpZUmxvS1VKeThucUkyMlg4TE56K2M1b1NPekVPMHpyWkFleEdVNEdz?=
 =?utf-8?B?UWU0Q1hHVXlNNlBmbUpDWUNYejdNYlRYRERac3Y3U2ZkeFMxZzRnWVV2RFNI?=
 =?utf-8?B?UDIxZUNIbEdFSFZtYmhNU1UyT3c4RFFyNUxwZHN0SUlLcTd2cGpNdVY5N1lm?=
 =?utf-8?B?c01mN2swb3g3Y1VnMnY2bGxQMHdCcFhnZCtRSllCR2FESS96RGZ5M2dKWExo?=
 =?utf-8?B?bWUxSnNhdytxNWV1QlZYUGQ1Z1Y3V25LNU8rdEFxdll1VERxaDdBSllyWHFq?=
 =?utf-8?B?anNTZm1jbE5kVlBDVkN4UklVSE40ZUYydEFCZ1JQQ0U1YndVcmFqRFdDNUlp?=
 =?utf-8?B?b3EwVFd2ZXcxN21rMVRQblh4dlEvMGs3U0szUVBGSVVNZGpSTWpyeDZEeC84?=
 =?utf-8?B?VEhIYjVHd0lnRGR6NlVCOTh2NDdWallrM2VYRys5V2hUdEU1dmh0bWNUSDRF?=
 =?utf-8?B?NXhhL1NkMlRESE1KVVZrQmxGbWFqVkRGcUlTRUxUY1lJcFNQV0dUR3BIVXJl?=
 =?utf-8?B?eWRma1NiY0RYQ0g0ODJ1di9QOS9iczdsU255WjZLVWxqcGd4U3A5NEJnWE9k?=
 =?utf-8?B?NzRocmc1VExHL0FlbFg5ZHVwWlhPajJJNm1NUm5nWjIyOTNkbkhoYUM0M092?=
 =?utf-8?B?QU5VWUt0YUdKN2F6TFE0bWNtQng1eGNuVmk4K2NjVWpIWXEreklsa25GdUlB?=
 =?utf-8?B?V3Y5dWFRbEdMOE1IcnhHYm1xd2I3bUx6QXhNbFpiZEppNyswWENQSitrTDgv?=
 =?utf-8?B?OW5odWpFbVVaaGtOTTVsNEJRTlh2b2tNRnRwbVgvelFDNlExcVE5ZkR0UDY0?=
 =?utf-8?B?SW1tbVV6SlRYd0RLQW9PVVlwV2ZNVTFndTVvRDF2RkRSeGdrbW5VcUZZeXB2?=
 =?utf-8?B?aXUxUGQ2b2YxVWEyNEQwM2pEQ3BGRzFBV0xZVUJXZGNNcXhSNHV3Z0ZTVlFZ?=
 =?utf-8?B?RnVuc2pvYWZDN25CbG5aSzVtbW04M0VISDhReTB4bzNzU0gvUVRqN0t5d3Bt?=
 =?utf-8?B?ZG8rZlhCYks0M0JwNm56N2hJQ0tLMkhON2xqOHFrVForRmxyYm5EZmdRc1JJ?=
 =?utf-8?B?TWtYdlFUZUtpVWRYczRqSXdjZStwYmJjYmdOMVZjUHFMTExpNUxyV08zMTRV?=
 =?utf-8?Q?DypCy3iSPF3wuhNbPe4Ppgy9y59kR8H8JprdSWO?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5345833b-51ad-49a9-c32e-08d9881ba8a5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 16:17:42.5429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WH3moYvC9rdlqVjtsuBE6nEzjbnRF7SNLRh5SlmhH2tvVIG4uycCCGC08ZSi7BLf6x8y3edZwidWFdiS8XfeJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3659
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/21 9:43 AM, Andrew Lunn wrote:
> On Tue, Oct 05, 2021 at 10:51:38AM +0100, Russell King (Oracle) wrote:
>> On Mon, Oct 04, 2021 at 03:15:17PM -0400, Sean Anderson wrote:
>> > This adds a function to set the PCS only if there is not one currently
>> > set. The intention here is to allow MAC drivers to have a "default" PCS
>> > (such as an internal one) which may be used when one has not been set
>> > via the device tree. This allows for backwards compatibility for cases
>> > where a PCS was automatically attached if necessary.
>>
>> I'm not sure I entirely like this approach. Why can't the network
>> driver check for the pcs-handle property and avoid using its
>> "default" if present?
>
> And that would also be in line with
>
> ethernet/freescale/dpaa2/dpaa2-mac.c:	node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);
>
> We need a uniform meaning of pcs-handle. And dpaa2-mac.c has set the
> precedent that the MAC uses it, not phylink. That can however be
> changed, if it make sense, but both users should do the same.

The tricky bit here happens when drivers set the PCS in mac_prepare()
depending on the interface. So you have to remember during probe()
whether you are supposed to set the PCS for later. I would like to leave
more of this to phylink to ensure that the process is done in a uniform
way.

--Sean
