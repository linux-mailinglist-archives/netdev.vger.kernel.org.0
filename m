Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A25455FA9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhKRPkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:40:07 -0500
Received: from mail-eopbgr50069.outbound.protection.outlook.com ([40.107.5.69]:5174
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232490AbhKRPkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 10:40:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyU5vnU3UCwR8YLvQmlAC+BglfbBVA8QGGFCmtDEjeXnGXUPLwER9lWoNI/uwRSnd9J6Vu7Tj15C+ajLqS0ZH6Pla9Gs05G/z5xIvGPjuk7pwfjXmaP+DYtzmfy1zLjk9f/5JToPfRFEF+PccGrGTaT8toUUPUjHXkAFIhTxpPB57YfOTqjQ/y0i1ZBVQZPxNeP7Wy/rb3I+35jvVLztrBwa1/w6mLCiaslvARXnCYGW/VM9LllbT6zVnDb2eGH9GmpL28fR4m3uN9wvebN3n1KgyN3x5NCC3Ok/DSk17NRI9xJYO1QfIUygww4JaGRi5IYE8eNBBnvwduTJdRhRqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gcJNnWjdS4Kdn0m2hhvaD3qeBOuIsu/KGMW/eqqmoQ=;
 b=DdoHXLhHkZIvmGRi0RA52l9AjEE+E8b/S2YzrclOL0i0cetx4xyK8xJLGHl4gRKVVwkQ/5nSjv3AN8FilQqn2oSc6zITbo/wq1B7NF8FhNpmGc2AfJ95droGRnS4VeQOAHDA7Fv38fAbREQA8YoBiPnoPyDWa6PzYVivIUl5wd+ty5ySBrhkZRMaaOhYCMO9nsilIlDCXgI1MgeYPcZaupHr2vA1r7YTeD45hYL3Nmo+ajf6D2htRS0snVpX8U4E90mAPlMB8+cU9m4niGJbuSwDh8SyAOjiupcVwDMMneVuekbrQ2/mBHUkHq/toPlKMgU3IKq0vT4fz3suCwsCxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gcJNnWjdS4Kdn0m2hhvaD3qeBOuIsu/KGMW/eqqmoQ=;
 b=mrPfJe9bokcHXl47AdBL34dozRnNyPC1zqh3XntKGf+FmKudkNk0Jq6DMcstIBjOO54RhbTIlhu5128UszZYLq7IdthfW30Y78hakYYMHV9ob83NtCe1SAhJRzckRImeVqV73lzlD/vmqA4ew10NpAO//LQAfZhopSN4nsY1nTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4618.eurprd03.prod.outlook.com (2603:10a6:10:18::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 18 Nov
 2021 15:37:03 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 15:37:03 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        p.zabel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
 <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
 <20211118095703.owsb2nen5hb5vjz2@soft-dev3-1.localhost>
 <YZYj9fwCeWdIZJOt@shell.armlinux.org.uk>
 <20211118125928.tav7k5xlbnhrgp3o@soft-dev3-1.localhost>
 <YZZVn6jve4BvSqyX@shell.armlinux.org.uk>
Message-ID: <e973b8e6-f8ca-eec9-f5ac-9ae401deea81@seco.com>
Date:   Thu, 18 Nov 2021 10:36:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YZZVn6jve4BvSqyX@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:2d::35) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR03CA0022.namprd03.prod.outlook.com (2603:10b6:208:2d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 15:37:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79de68a8-776f-48e4-882e-08d9aaa94508
X-MS-TrafficTypeDiagnostic: DB7PR03MB4618:
X-Microsoft-Antispam-PRVS: <DB7PR03MB46188BBB18612F3402278DBE969B9@DB7PR03MB4618.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZaX1hpbwzIrjWaF1V/6f4hLZ3+ZCdgoMsagwXj4BKBfRi3oxLTSbeYnX9TcONT7y09/9DBtQ60OW63VY99gf1dhHPATIVveGjuFsP1B1XUuVHvipLY9z7RSyMd6uPqnn8R0zeQitrOyP0td6y2Jy6CfAfZlrf9MCy2J/GaT0Ire/j8MTbQxPBgZIL9z0T+o2IByLbUiPP77tbgjT/wgEhtD/Rav6bRpdcGvH8q+v7XKANhxv6R/bclhHL3TpvcGjh+kFVKBzGWUpCW6LHBAkOAQNUXSnufEJB1azC9FVievelSiQRHwkpfxL3bc42zDpwbOWhrIlycr87T20uXAkqQyBP66S8btjhBDRcB7AMm+DtCdlH2UXvQN1RcSWLmenA/Gp3LcfGx5uipD3UT7VcOiG53Ma0YnivtlzOhaTcvrMTi/Tvn+wVuiEuihJeY7CY+f7Tgbedk4EuNOXS8w4klcx1/Acp8ccpFEN4WmhPm6cGUbHrOfLKu7q1twEYQKEvU8ABXODkR62nWZA9ZLkP1QOwaBCk8afpwEcsBys7K4pgWsajCUQun+Bs5kpevuw6Cd3y8+wQZmiG6bqG5I3HpfrmTEJ+eXa6i8ad3wApclDivs1zEM7eLKqK3Pq140fFfz0X6zHJXF9CnSpi0IkQJz04qtodo5gHRgDbntQs7nn8fozlDEa9WfAPgrvdGB2D01iubjcuCE2ZfOwcXpvYRit1WSg74/eR8HiPUUenYnI5pJQmNul6Sp9hD2FuWNtZ8kw+KgXLXQ+y2UbKVsCLF1D3tTd+KoYjHjoL5JraXbLzKepnJPehxRP7PkOXZTyLNEjYbQx7R1GOE5RrmuFrLuQ5BQMIDY4DQ3WqPPtIvU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(2906002)(316002)(8676002)(16576012)(38350700002)(5660300002)(52116002)(956004)(8936002)(186003)(83380400001)(2616005)(38100700002)(36756003)(66556008)(44832011)(66946007)(66476007)(86362001)(6486002)(53546011)(31686004)(26005)(4326008)(6666004)(966005)(508600001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlVQaWFnQ2NVaFJJTjZ1N0tHNk9uWTBabFdsTEtvSkgvaHJCRmJQY3F2citj?=
 =?utf-8?B?Ry81dWp1UlFyRVZ1clFjTkROL1VOMHptS3hrSGt4WkZHZk9wdStPamgwMks0?=
 =?utf-8?B?clhiMGVqNXFOczA2eGVvbEU0RFVGdzZJTnlFWSs3MVNSNmc0dENZNWg4RG5T?=
 =?utf-8?B?cmQyZHBORFBNN2dMZ2FVbDFKeWhzZGt4dEFLaEo2bis0QkdrbjdsbHRtWHVi?=
 =?utf-8?B?UzNZNEg3OTBmL3NoL1RhNUlTek5mK3dSaFpYTHh6bHpkZk13WjJwZjJOWmJ1?=
 =?utf-8?B?U01XZzE5OHNyWEtqek5QZ2R1R2xxWm45bDdQck5UR1RoTnVKUjJ1Rlo4NzlP?=
 =?utf-8?B?U2djc25Qd3V3UE1WTmU1UVNOSUMzMXc2ZnZvNytBM1BoM3B2RXZHOUJTaHRK?=
 =?utf-8?B?dTJLeVJQSlUxMWVSQ2hYSWhmclRPOHM4TVExTWtNREpNZUFjSW5zNDhYaG1S?=
 =?utf-8?B?R3FWYzhtb0dIZTFuUzZNcWlkK2U0am1WdUhMN1JlN0phWVc1VXFWaUIwZVIz?=
 =?utf-8?B?WkRQRTZvL1cxSkN1K2MwZ011TkpBaVE3OTBRRENHTGJpNTVhM3p3OUJjNytN?=
 =?utf-8?B?REVpeTAzSjluKzFXODduZkFnZE9HbHNwdkZyY290eWNIM0RwNzNMYW5vK21P?=
 =?utf-8?B?L2pOR2RwNjEweE1lZEFEamVtQWpkVFNiT0MxTkl3bFp6UWg5MXZJOGdaaTl4?=
 =?utf-8?B?Rmsxa3YzMDg5Q2FCZjFEOUlBTW04ZmhvdHJqSVpSc2F1c2l5OStUQXUrN1g1?=
 =?utf-8?B?WDVvbEc4dDVlYjFEZW5Ca2IzNWVtaCtwbFp5K1pNOTRVQStMVlh0bmo2U09Q?=
 =?utf-8?B?KzBRejFaTnFyQmtPb002cXcxYk16QVY1cnVxbVpzZE9EMWsvQUdHUUV6cHZy?=
 =?utf-8?B?NFBScHowdW14c1NFL3Q1cWRCTEFNLzhHR2hpTFF5bU0wVVBBTjBoWFBjZHIx?=
 =?utf-8?B?aUNSL05tZnd6azZYMjE3QmJ1OVlrckg0QnlxcHQwaXV4T0ljbDJKK1ZwbXNJ?=
 =?utf-8?B?bks1OGlmT1g0K3h2d0krZmorWmxNVXQzWjBxUlhmMFFnbms1NkpkbjhaNWpY?=
 =?utf-8?B?eWR2OEZlRTFuR1FlNEtQRmNZbklRTzR4emd4WDVYSnlPMml5cWtzYmY2S2tL?=
 =?utf-8?B?OUJnS3hReFJ5ek5mYjVxeG5yQ2pKVS83ZWRQU253NzlreDY3ZXV0bkNxa0xW?=
 =?utf-8?B?RFZybzZYbjg2a1A1NlFGMDlRVWdqQjVLaU1GYkVSWUFBS0pUSk5qY1pQK0Jn?=
 =?utf-8?B?WjdXd2ZIUzMyWTR5MHdPZmVyc0ZMbnJVdzNNbE80ZnhIcTBiZXFndlVVVG1o?=
 =?utf-8?B?L0FmMk92QTJJamY0MDRTdStkRkNYU05RTzJBUTZvWnBCL2tuTVNLMzVHSEk1?=
 =?utf-8?B?WVpIQUR6c1ZIeC9hUVZSemF5dW00ZTduNStoa3Nmc093am9jWmRiWExGRjlG?=
 =?utf-8?B?MndqWFNzeUdUZFZIVUFPYnd1K0ZNQnZnV3pWU2g5cjRKdU5LWjFpRnljR0dD?=
 =?utf-8?B?a21ZZjlKRDFlYmM2UGxDSUtqNUFQUDdpc09DSFcwYUFwbkJQRGhOWmFqNnhW?=
 =?utf-8?B?WEh5ZEl4c29ybWVSN2tZcXBBS3k2QitKZG03YS9ad0JucDcrbmJkVUI0SHZu?=
 =?utf-8?B?bzhVcDBrVzd4MW82Tmx0N05pN3l1dWxGMndmRWxXbTlsMGVqQ05zNmppU0ll?=
 =?utf-8?B?TW0zYWNSWVNaenNTQXk5blpjcVBrNVJFT2x0MVA4RCtjSlNkcE0wSjZla2N0?=
 =?utf-8?B?RUYzRTh0aVNlbG9pa3Q0YUJpeGs5ZEZVVy85YlRwdTJhQTRYdGQ0aGtOOGVs?=
 =?utf-8?B?VkRvZUlUaDk1bjhmRWY2dHM5cXJkK050ZEw2TWo3UEplWXFxakJuam55L1A3?=
 =?utf-8?B?dWoxT1Y1OXFxS2c4QVNXbVJxTVZURmw5OXpReTI0U2NETFhjZ0RiMkFpVFhI?=
 =?utf-8?B?c2ErRjZTM2w1MzE2dkJIUzg1TDh3NjZFS0pTR3FSNFA2cldRK0V4b21RRkd4?=
 =?utf-8?B?dWlnVkVpWTkrdkszVFlFMnZ0OUJ4aC9RTGQzZjcyRmQ4SWZ0ZGMvYzJiR3RC?=
 =?utf-8?B?bnZhVU5yOVAvTWhBN0hSNXVRbUdSVnZzZHlQK3dmQ0lsWFF4c01OclV2RzNG?=
 =?utf-8?B?RzVScldHelNRdEQ4TFJvY0ZHSW1CSUErZjUwZDlMUUJpN2hCLzF2eURoM2s3?=
 =?utf-8?Q?Y/DcQVlW37W4TP7pt5xsAjo=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79de68a8-776f-48e4-882e-08d9aaa94508
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 15:37:03.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Xx3kCLC2gkLJsF75ZR92w2TpUIWyuJlwv9bLgYpsJb0lAlEsr3jgtP6qEnvPbUNN321mwjM5Ma8nNiPknk55A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4618
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 11/18/21 8:31 AM, Russell King (Oracle) wrote:
> On Thu, Nov 18, 2021 at 01:59:28PM +0100, Horatiu Vultur wrote:
>> The 11/18/2021 09:59, Russell King (Oracle) wrote:
>> > Another approach would be to split phylink_mii_c22_pcs_decode_state()
>> > so that the appropriate decode function is selected depending on the
>> > interface state, which may be a better idea.
>>
>> I have tried to look for phylink_mii_c22_pcs_decode_state() and I
>> have found it only here [1], and seems that it depends on [2]. But not
>> much activity happened to these series since October.
>> Do you think they will still get in?
>
> I don't see any reason the first two patches should not be sent. I'm
> carrying the second one locally because I use it in some changes I've
> made to the mv88e6xxx code - as I mentioned in the patchwork entry you
> linked to. See:
>
>   http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue
>
>   "net: phylink: Add helpers for c22 registers without MDIO"
>
> Although I notice I committed it to my tree with the wrong author. :(
>
> Sean, please can you submit the mdiodev patch and this patch for
> net-next as they have general utility? Thanks.

The mdiodev patch is already in the tree as 0ebecb2644c8 ("net: mdio:
Add helper functions for accessing MDIO devices"). The c22 patch is
submitted as [1].

--Sean

[1] https://lore.kernel.org/netdev/20211022160959.3350916-1-sean.anderson@seco.com/
