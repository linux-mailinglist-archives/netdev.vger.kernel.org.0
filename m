Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E813F46A093
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350994AbhLFQGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:06:02 -0500
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:5985
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1388201AbhLFQDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:03:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVjyK3Tny/Ux09NG/jjtOTn6judjunuOoKhS2qaqrIgiPGrVQa29zcA8XRFgeBuM3Bzwn9fnbMGnYBkL/FT6vzR8XqcZrgLeHaEBEXEfAE6jp2UGqeT+mQSiY6Kip4LF/f5u8KrKq0u6tiCL5FFdzctR0GuTP/Xn28bS8IFo34A3UMNHoVpIlg0pPiZVd+a7xOIhAMqXs0Kq5XAb/h7NbeiPn09gWcDIX1NToA+fAFDqChqR6PEINKrrgmViJCEGRZNrZixMm1C7q531E3jID4CUJQjiD1cMBGaojcd70l5gb6uTOezUCC6cY+gvEucHGTpy5uMZpQsQsvkIQj3Qfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lCZffNMhommzefJ8ixhEo/p//KjFJvc+aXXLbuVAh4=;
 b=nrnhhIh5WiRFBf8ww2ApMN6Em/mqmePAU+Db6MqEZXhoGq9hAnWf0KGgYHuPunkzOGb+t47lJPKOYW4lnx09VJ6SlogbHRMz/yY/7NNHFo76C2cgHHKNy9zHEwZlNmItiCnR/svYSnArjXT28+SAuJkdYF1x22kQJEInrblCAx2Dl9s/fKm+htcr9++RGIxPPCbCOYaBzJ4TodNP1x8DDdOxFFymYhXTZLfxHBrabtwqlkx3Cic9f1VOSZyCI7JN68b8eLOKDKYVGZZl33r+q2grf50XTa7t6oXPHbqiOlj60VVp5wzazQG8TH+7ZKBGusA3aX78/VX+LHaa76e1jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lCZffNMhommzefJ8ixhEo/p//KjFJvc+aXXLbuVAh4=;
 b=0R8QR8e0LO8djSuZpSzBauxmRKyv/7yNWB+bdrx/4Sav1v6G1PUCF+2fXIGN5O6m41902XLVHOMqCDu9oDi7tL0814iTH+c6afwkSe6V8dvhn71S209BitGwbGQkHGD+TlivWrKfqKpBotpRFW8waEySoI4on4g72GWNFhuMMKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 6 Dec
 2021 15:59:51 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Mon, 6 Dec 2021
 15:59:51 +0000
Subject: Re: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
 <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
 <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <24f210a9-54c9-eb0b-af88-a7ad75ce26aa@amd.com>
Date:   Mon, 6 Dec 2021 09:59:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0356.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::31) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL1PR13CA0356.namprd13.prod.outlook.com (2603:10b6:208:2c6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 6 Dec 2021 15:59:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 091b7825-7e88-413c-d578-08d9b8d16f42
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB52295061E1864A0819A41B63EC6D9@DM4PR12MB5229.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/0fWXVgY5qk/+DJMFIK8izF5ygObiYfJ4/Sldb2cxXbwrbdn022HM6PkedKXyMvUn+xer7k2mm2exmyp9LCWlGcxboPk3B0PAwlA728fZfr/IgZA44gwM9jpCJlGER+ic5bnmBsrakqqLaLSNTk3NoxAjrKSeN+OjCh4om/Fe17ZWQSZlzKQUE7R6VgPJXmJW9ECgho0MzzmfxOLhcvwyPHzFd5IkzylYJblXCpMzPIh7AQGlzMjrky9OIVBmeahey9+CwBPAmvtsGCtDp8jRkSmSS5t0RIkvGK8OAZUEohLLN956Vwb21yAH6PTNYjkezZmUoINW497e2BOzOZwbdrtWTxYy45GGQKt9FFvbmuKy1D3ECtC5BSZK3urojP2SXBrE9Wwd3HdYa2l6QNVX0/9deLlf6GXbrfMAHf4DdjROEJ9wtP28/GTIlCb+bFIq0bL0D/YzUaViJu1YaTQGvfkfl5JRaCVjJt5boPNFyye9WbG64ml7kcWQDKd8vIRQz2Mgs/3Zw80fJaO9MfQpWfgk91dRAFg82E1b9ssNHBbvs9yS00jnWEpB42yrzO57yPqpoIvTPS6AZxSHzQf6GnUCRrQ1Bvqg7nV8Dgd8HD9/Xz61ZDy92WfwlYptcq31nA1KGlGvpSyawEL8dyokaQWOTf3aUim9fn7iM6pLfKZ6Plvy6VkSs7OTlWZOvb92n1iv4X8oVs3y1R2HxjK8LAoJC792dSfIRfUX/RFLhSFd5hnd9xgrwSd/ovAL5DCjkyvI2eAKH58ogBKYn51A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(8936002)(5660300002)(508600001)(16576012)(186003)(86362001)(8676002)(26005)(53546011)(31686004)(110136005)(54906003)(31696002)(36756003)(66476007)(2906002)(66946007)(38100700002)(83380400001)(66556008)(2616005)(956004)(7416002)(4326008)(316002)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzlnYlQ1TWE4Z1loT2dyTVFkMERTZkNGUTVpeSs3T0hZditkemFBcnNWRHZD?=
 =?utf-8?B?cjRXVCtlNGZpNHdNdURpQklQa0wxYXRtSlpwY21kTk01VExJcTVLY2FTalpR?=
 =?utf-8?B?TnN4VzRWVDF6dlpPUWNZNGQrY2lvOVQvZDk1RW11a2Z4bmR0MDJHZXFyWTV5?=
 =?utf-8?B?SkNUbWFaSndWYzEzL1RkSi90cEo1YzdacmtPWXZ0aENVaEdvMThwTVR2eGNX?=
 =?utf-8?B?RlFLdnBTM1pSMmo3M3h6M01QTFVYWHJQUTFoYUtoZWk0NkltaHZQYXdDOGtZ?=
 =?utf-8?B?MGlQZ1FWbjQzQ0h0Q1NyMGZzdTJMOThmdkpyM1pSZ0c0eE5MN05Oa3FSaU5h?=
 =?utf-8?B?UE4yRU1CczMvZVUrODQ5V3E2TE5CbW9CbmNlcThoVkU2Q1pMMlIxcm4yVTFS?=
 =?utf-8?B?NGdzYTVBTHVUMy9tOG11Y2w4L2ZXNXRsc1FzVHJEZjQ2RzVqMGxpVUVVRmtR?=
 =?utf-8?B?ZDhtUS90VzVSZGc1Q1RSbU0yK1lROEtQWnEwek9qZ3MxWVhMOCtvYUhKTXFh?=
 =?utf-8?B?SlZ5YWpydWpVb2JrVkV1L3UrUm9FOWR0V1MxMWlVTUlzYzduNSsyU2RWU0tO?=
 =?utf-8?B?NXdwaEZWemd0ZGs4cGxtMGhUd1M4eWxnZk5DMVlid2ZHcmFYSFFhQ09CM0N0?=
 =?utf-8?B?WWRodm93bWQrVWwvQ1IwQjhqeEd6THNDMGJMWWtvSy9EUy9rT0xnMHBjVHVE?=
 =?utf-8?B?SXloTmtYVXdKNEVUR1lrSXhVbm95djJUS3RJWWcxdjRnNlNjbTZFMCtBOXJv?=
 =?utf-8?B?eGFDWFlrN0FUVmcyY3ZQM0lsWnNyTkNpcm1BK0Rza0hvSldHQVdncVh4Y25L?=
 =?utf-8?B?czFQbEg1Z2prbS9wS0FkZWx3eHpITnRWR2VjSDI3TnlHMkhDRTBzek9GY2Fm?=
 =?utf-8?B?QW1EV2VTTUFMTlloZG10dmh1aUVwdWNXSXV0UVBjVFFEbThWMzFUVGxHeDJ2?=
 =?utf-8?B?azNLM09QRkJlWjVRQW9RYjYrUGlCZDBYY3BvVFdPTnFXeFZFUkwzUHJIbmRz?=
 =?utf-8?B?WUVxOXA2ZGp5Zm0zTUxzWGRQNHpERUo2WEVUc2JQRHhCUzZHN2I2aUJHR1hk?=
 =?utf-8?B?bnU5S256NXVTNkdSV0NET1pHakpOSHF2R3NYVFRIRFhDU0QzMlQvZzVoOG1a?=
 =?utf-8?B?NG1vL0VBTkRxMjlPYWp4MURrVVl2TDRYK3RMQ1l4b1p1YU1UUXpPTjRDNGZy?=
 =?utf-8?B?NFBiY2MzT1k2akJZVEtSdHVieW5zaUxYc09ZN1BncVpmOGZuRkhkRkxtQlBz?=
 =?utf-8?B?VkdIV0VRdlJwdFpLanNkbUxMelhHZUR2V01FaThQekRaK2xiMzVSTVU4SGoy?=
 =?utf-8?B?ZXQ4RjMrcHh1L2hFb0ZiVDIvUXNxdCtYTkJORVVUdHB4RGsrUmQwL1l1a0t6?=
 =?utf-8?B?R2Y4c1lvWDdZRnJwZWR6ZWxGMHBHYWJ1Wld0cUwyZG1kZ01URWJVM1htNmlT?=
 =?utf-8?B?NzJQUVdZOS9jK21IY3RBZWM1TnV4WUowV1Y3cHI1eGVYOTBmbFpGYWZicFd3?=
 =?utf-8?B?VWF0RDZTcnBrQlY4RjZMc2d5SFdENktnT2RnYWVLR3FzKzBlR0NvMFFwYW9y?=
 =?utf-8?B?Y1I2OGtsUHVDOWdBZm9lenVEQ0xOSTlSMEpNUGZLek1kN2pZTlJYT0tuRUVM?=
 =?utf-8?B?QUgzUzBZT01WbU95RVd0Rk1EaTllTG9tWHhaZjlDaU1zYVlSaUpoMHN1Nk9E?=
 =?utf-8?B?aU96VGdPeGZMZ1RISmlnTTFiL2dPWXBaQkNiSWhDWm50YzllWTJqZS8wQzdx?=
 =?utf-8?B?RUllSHhZSEVyZFNsQ2xtUm1kbktNcGY1WU5Hbm9PYk5XTkJIRXZwOHlYTEJS?=
 =?utf-8?B?ZTVndTJzVzdPb2xTcXp5M1lweXJzRzVPdTJVWGVmaURQcGwvZlF0TkNSM2lD?=
 =?utf-8?B?OUhxcUUrUnIrM09wMDFISGpDWG13dDh0aTAwWmt1ZjUxMFRvdHRtNGNsWGhk?=
 =?utf-8?B?WFIrRUJuV1hJV3Y2OVJMby9URHBXcHBEUWI4N3NDTkhHTzhrZUxOdmhtOU5r?=
 =?utf-8?B?akRnV2ZmS3hGcGJySzlxWXJUM1RoV3hjNVQ2cnFVZGd6RlRycjdSaTJmb0Z4?=
 =?utf-8?B?OGdFb0pSZUZ3aXZ4bldjbk16L282VUZDUnVhVm82VG5pbXoxdU9IRUZsZXZ5?=
 =?utf-8?B?bXJtRk52Y0laOTh6ckk2SHBFUHNvSXlqejdqcGttRWdqRzhCOU1hM1Y3QlVQ?=
 =?utf-8?Q?X7sIeg5zXajMszaLvjvoi5g=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091b7825-7e88-413c-d578-08d9b8d16f42
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 15:59:51.2783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5P3M9j+gt8xu2u4JXlv2Wd6vxsAcV4VRQT5EqsUxbLWIJD/KbPw33hmv6BVux0XQZPkQ+G/T6dOQ4LRpgRNqTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5229
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/21 8:52 AM, Russell King (Oracle) wrote:
> On Sat, Dec 04, 2021 at 08:59:12AM +0000, Russell King (Oracle) wrote:
>> On Fri, Dec 03, 2021 at 08:18:22PM -0800, Florian Fainelli wrote:

> 
> Here's a patch for one of my suggestions above. Tom, I'd appreciate
> if you could look at this please. Thanks.

I think it's fine to move the setting down. The driver that I was working 
on at the time only advertised 1000baseKX_Full for 1gpbs (which wasn't in 
the array and why I added it), so I don't see an issue with moving it down.

A quick build and test showed that I was able to successfully connect at 1 
gbps. I didn't dive any deeper than that.

Thanks,
Tom

> 
> 8<===
> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> Subject: [PATCH net-next] net: phy: prefer 1000baseT over 1000baseKX
> 
> The PHY settings table is supposed to be sorted by descending match
> priority - in other words, earlier entries are preferred over later
> entries.
> 
> The order of 1000baseKX/Full and 1000baseT/Full is such that we
> prefer 1000baseKX/Full over 1000baseT/Full, but 1000baseKX/Full is
> a lot rarer than 1000baseT/Full, and thus is much less likely to
> be preferred.
> 
> This causes phylink problems - it means a fixed link specifying a
> speed of 1G and full duplex gets an ethtool linkmode of 1000baseKX/Full
> rather than 1000baseT/Full as would be expected - and since we offer
> userspace a software emulation of a conventional copper PHY, we want
> to offer copper modes in preference to anything else. However, we do
> still want to allow the rarer modes as well.
> 
> Hence, let's reorder these two modes to prefer copper.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/phy/phy-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 2870c33b8975..271fc01f7f7f 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -162,11 +162,11 @@ static const struct phy_setting settings[] = {
>   	PHY_SETTING(   2500, FULL,   2500baseT_Full		),
>   	PHY_SETTING(   2500, FULL,   2500baseX_Full		),
>   	/* 1G */
> -	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
>   	PHY_SETTING(   1000, FULL,   1000baseT_Full		),
>   	PHY_SETTING(   1000, HALF,   1000baseT_Half		),
>   	PHY_SETTING(   1000, FULL,   1000baseT1_Full		),
>   	PHY_SETTING(   1000, FULL,   1000baseX_Full		),
> +	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
>   	/* 100M */
>   	PHY_SETTING(    100, FULL,    100baseT_Full		),
>   	PHY_SETTING(    100, FULL,    100baseT1_Full		),
> 
