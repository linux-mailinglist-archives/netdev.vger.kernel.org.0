Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F82439A6A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhJYP27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:28:59 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:34739
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233706AbhJYP26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 11:28:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6zaSv6suUqvto3IBBuUqT28MakuigovokV/kXJegxkj36Pic+OEpwA0gtUPu2eceMy11+knkOft1fGeBrV2pCVhjC2P9T+qDT3X635Cgcv1wxWJCHvWt4NaHlK9P1ZXv8niRGMmuHDagIRNS7M5wXQjpf6AVmFEUzyT4CpIFC1BVmIuzDzvqBR6Tldf31IPVqYnf+4GN7vszEWGbLi/qMLAIN4Cc2+budvyRAhhFqGgp9T4qQzqrrbzRHxz3gN+wu9C/zuTUE5X4ENBroRaA69TM15WFrRJrsHc76ZuRZ24wyZptAIatJYw0rAeGpGnOh9eziK5p8k4nR5r03lkEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wq3ox4mw6LQdFPlpyg3Aqua8cax1thn9V6rPNO9nBJg=;
 b=Ayb3kOUzs68GQIuWWNl43TPJjaQnJW8hYZLsIXWVowfqf8Qe5+sTQzyuLFAR5Bu7H77A4eHVWvwW+8Wv/CJaFgNU0X9JVaU+hcyL/qZOrsra+dj8z8/QwCvcvDxiIJ5vQ5G38blBZQZcLdOqum3PiyxTXBuJEO+q6IHzFzU3NZh140pB2e33GkP+YC84kl+vlQz2jtUFJGCUzVu03RrpmONsyBoND8jUF7FMLopAbmjjo4de7L952SOa+ohdu26Zq88ZYOltm5P6z2RRp43mhFy3byDTAp1z/6TAWwebberMeLakswA3qeGSG9cDEso98WM5eUoz68yTOhD/EEMXIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wq3ox4mw6LQdFPlpyg3Aqua8cax1thn9V6rPNO9nBJg=;
 b=apEs3cGeaMeYzZteP0BtH1oMm0ZbbZiEnsbcaOQI9pl0RFmmN43yti8ItMAPHKV07hdln29wMPOxYgQTTqUxp3gkO9lDmqWV85xr3Yu+/ejOOZkENVPCr0iq+vJuihjB4OiTCgWmpvB8yRoLrvUS4P6t4MKfCE9694No0Pe54rE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB5673.eurprd03.prod.outlook.com (2603:10a6:10:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Mon, 25 Oct
 2021 15:26:33 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 15:26:33 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
 <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
 <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
 <YWi4a5Jme5IDSuKE@shell.armlinux.org.uk>
 <95defe0f-542c-b93d-8d66-745130fbe580@seco.com>
 <YWoFAiCRZJGnkBJB@shell.armlinux.org.uk>
 <YW7d+qm/hnTZ80Ar@shell.armlinux.org.uk>
 <24d336d7-9c6f-55bc-34dd-ddd796ef8234@seco.com>
 <YXaIWFB8Kx9rm/j9@shell.armlinux.org.uk>
Message-ID: <fb672897-92dd-4311-eed2-1cd5a7f6e591@seco.com>
Date:   Mon, 25 Oct 2021 11:26:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YXaIWFB8Kx9rm/j9@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0117.namprd02.prod.outlook.com
 (2603:10b6:208:35::22) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR02CA0117.namprd02.prod.outlook.com (2603:10b6:208:35::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Mon, 25 Oct 2021 15:26:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d66a3021-8204-42b6-1d7f-08d997cbd38a
X-MS-TrafficTypeDiagnostic: DB8PR03MB5673:
X-Microsoft-Antispam-PRVS: <DB8PR03MB56731AC31DAB74C1591A033896839@DB8PR03MB5673.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpx94k5r6zVsTjv/dTDrrtgxCkcAgDovNEnW1Qkv9yY2PKvZd6GiWs8lt1zNNfLCfqyn0xZPJiZYuOqZwqB7HImCgS5XeW4fKq3j5bpZsOJQRPvvU634JftiDyMsNzQT9JfS/QQ+E8Sj7ODgcxaPX+4wuj0CcljYVpTEQ4qCI7MdZrz/GqDZuUBN6VxIQ/Vhg6s9/GBbDXFWu4Ptgz91pGrZr9m+lPEh8kpbJJSTe64/zz515n4tIQBAevLm3sOSiQKJAqAz5O0qzfStclQF5jROuA2XyCLkBBRTFX2Ayv8+gIGPAVoyhZv4S61/WFketAjyiR4PAiaX8vinQNsToflSBk/s5OohtilUpvWoZUhm7QOomv+t8/PpQhji1Sr5GZh0pIe5Qde407FYpyt3SYsElwHGY1ZspJ8p69MVZdI43dOKXB6iOqO+yxT1UBF+lAf5LJi82CqBJC97O6DJJj9LRyva8f/ti6CPLl+dtroK/x/sUhQKwg0n+2RMaMMwzT5FPb0sVaFMYPf59yb4g+SUkhrzwPhlRAkOeD5BLetVU8N1+Qup41XnAyPVjIfYx7qs/jhub8bum7eJdUWEKXhG0C2o/hReBUkozHP3nQ2pppHCa040wua9HCVuxFwiZxrzJEehhUDsdh7WK+D+H6jwJS+j838OrUl7cMDBN5MCvEJ9WDkdkw09A3AHWtw6TLMnCx7CgMol0vBLU77o9rOs34hZTmYCwVGx2F9EWk7NAkiwOMOwR83DykzMlfM7GRJafzTsCogy+EAvm2NwIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(54906003)(31696002)(6666004)(83380400001)(53546011)(86362001)(5660300002)(186003)(508600001)(38350700002)(4326008)(38100700002)(52116002)(66946007)(44832011)(66556008)(6486002)(8676002)(66476007)(31686004)(316002)(956004)(2616005)(6916009)(16576012)(36756003)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVc0ZDV5cGUyWHZEMmdGL2VobzV2ODBxbEhYUnIzZUZKWVVmeUowWitjSzk3?=
 =?utf-8?B?RytSU1ExMFFuSjJxSzNIK3FZeG14YStLc3JDTDhobTQxa2Foc0lFcEMwSDJr?=
 =?utf-8?B?UXpOUDdQR3ozaENubnF0MkROY3lEOVdGNm94ZXAyb1dNNjV6UElRWCtrY3ZZ?=
 =?utf-8?B?RHlMUS9KSFpGdUw3eWxZVm0xZDMzUkx4ZzJzNlBTM3Zhd1pNY3hzWnFXSktH?=
 =?utf-8?B?c3d1Mjh2N1JoUHZOcUg1NE9qY3g1MG10eWRjM05xdW1UbDFrUG9sKzE1MnVa?=
 =?utf-8?B?S3NrOEV0K0pKYVRXUVRtTXQzREtKL3JjdWdFODREZVA1enRMUnZQSFh0SHAz?=
 =?utf-8?B?M1lxaUNsL1czREhTSCtTVGNQMmNyT3Y0dHZqdVphbm1FMHF6T0RkWEVwTWtq?=
 =?utf-8?B?dmdCUTRlb3JwU2llRGNaVnNPVkVlYThnNHRPZmxqb3NKbitubSt2OU1ZMnBx?=
 =?utf-8?B?b28xWDVoVmUyN3cwV0Q3eUNUYXJPNWNPVGZNK256UnJPVFR5eG5JMTdqSml6?=
 =?utf-8?B?eXRqTGFYVUt3bUtNYXpmdzUzcWVUdFNqWEFZb3RCTXMyZUtUN2dZOHV4aW5Q?=
 =?utf-8?B?TTdDSnozQ3ZFK2xKMjg0QVk3MEZRUXVSZUx3cmtKc21CL0dHM2tBQm5HWWVT?=
 =?utf-8?B?SWxUbUJINkkyTHBUdThDYTJZSnVaZFBOaEpyZUhWMU5GM240UHU4NG5YaVVG?=
 =?utf-8?B?NktoOUZJeGttMktNWldCdFVqYjBBb0hPTEozTmxNSlZsZ1hmWUNwQ2RRcVU3?=
 =?utf-8?B?ak85OU1raVVlRmFPNjNPcmlLMllSd3lRY3ZqSzVwUGlwazdiUmZSVDVYakV6?=
 =?utf-8?B?NGsvMUdtdEN2Tjg5VkpPcEtqSkEwQm9ua1lXdlFBampyczZsbHg4S1dpcFBE?=
 =?utf-8?B?Sm53a250NkZDQW9rMXByUFYrNW5tQjRmd3lVMXZHNWNwdFQ4cjAvakNEQnlr?=
 =?utf-8?B?NXFIWEJDcCtjd0hJLzNUTGlBT3A3UEE4OXl3NCsxV0gyejVyV2ZROWNyRm9O?=
 =?utf-8?B?a2hEbnVKN3pNcEN3WUNITnFTU3pOM29nWEFqMXc4a1ZyTmZVUDVwa0ZDM3dP?=
 =?utf-8?B?UXRwd0t0Y3h2bEtOZDV2SXorRUIxODZOdWVuN3lPZy8vN0wyMUd3L0h6ZWY0?=
 =?utf-8?B?MlpEN2VoYzlKZGl5TVFOQ3VJY2o1eGZLMVRsTWF0UUtxQXBESjBaanp6TzdP?=
 =?utf-8?B?ZnB4ZnFZUGk2c3FYZmR3WmhaZWFTN1FFaVQ5MmEyUWd2b2Z3Q1hGMkcxdE1m?=
 =?utf-8?B?N0tjYTRoTXQ3NWRoWTdGUUx2R3hTNzEwTjBLV2UyMjZROGFMbzNjdFRxcXlZ?=
 =?utf-8?B?bmRDNnk5M1ZuZHU4TnR6NUV1ZnhYekY1WUo2TGZMT096RCtlL1YyZitQWUhM?=
 =?utf-8?B?MS8zeWl2YjE5TThOeHFsS2xrVWptWk9sWXNUU3NDWDFjZ0Q3c3NNdVpMRlpl?=
 =?utf-8?B?SUNvL3VEb2FZKy9XM2RTVkgza2ZrWjFOWjBqSWhDMGJrai9IYnJybE5nd013?=
 =?utf-8?B?elhaNFNDL2x0MnF1SmdpWExpcnAvNWNpWWJCWi9qTnJjQUh3MU1TVUZGQ0Q4?=
 =?utf-8?B?cEU1QTdQMGlZaWRIWFdrNHlhQlB5SGNKL3daR1pvaU1xc3V0eHh3MFRHMS9V?=
 =?utf-8?B?N2Z5anJrSm5hTWhkM0RYKzVOVDM0Q3NKamJIeE5nTlNkRDJCQkRIRFZzMlRS?=
 =?utf-8?B?VlJUK1pnMGd3QUZaQUhvZ3BBRExwYno1eW9kaEEzeXdSWTMrNGROazZwRG5x?=
 =?utf-8?B?QVpCZk1KUFYxcDRJMm16bmRFZHRHQXJKZkV2NlNoSGpGWXI4Ui9JdnJZeFZH?=
 =?utf-8?B?WjR5WG0rQ3BDa09oTi9yaVVkbUl2UzJVOWpCQjZTREdyM0YzRzVLVWh4WVlC?=
 =?utf-8?B?WnEzbjFTU2FJZ3lxcVdOaGl3N0x1YWt3U1hzK2ozMCtIV1d2ZDc2aDZWL05p?=
 =?utf-8?B?OG9qNlBQVER0NkthL1k0a1MveXR5MDFYcEVQZlAwK0lUQUJRejRJRDhsVk9P?=
 =?utf-8?B?SHBEOE5wUXN0bVFQMlRlVTUrTSs4Nk5JTDNQa3NscUNlMmoyNy81RmVvb1FR?=
 =?utf-8?B?clNuRlpxVVIrQXo5ZjNkK2dNa2hwR3RSeEdOV1BQVDBPRitSNlVVYlphWm9l?=
 =?utf-8?B?VnRRUGtIcTBnR3dKQW5zZTUvMExLbmhFTTZWR1pzUENlWUd3TFB2Nnh0OXdZ?=
 =?utf-8?Q?Ga+KqMfR7wPuGrXpMAGZVH4=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d66a3021-8204-42b6-1d7f-08d997cbd38a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 15:26:33.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxhTS4pcM1IAqr9x7TcpWXA2XQ6Kj6pr1IDuxMzHnUIcoy8UMH/HN7xYjgCn1q/eONVcp3oPt0n6lF+7wyzdnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5673
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/21 6:35 AM, Russell King (Oracle) wrote:
> On Fri, Oct 22, 2021 at 01:37:34PM -0400, Sean Anderson wrote:
>> Hi Russell,
>>
>> For "net: phy: add phy_interface_t bitmap support", phylink_or would be
>> nice as well. I use it when implementing NA support for PCSs.
>
> I think you actually mean phy_interface_or(). Given that we will need
> MAC drivers to provide the union of their PCS support, I think that
> would be a sensible addition. Thanks.
>
>> For "net: sfp: augment SFP parsing with phy_interface_t bitmap",
>> drivers/net/phy/marvell.c also needs to be converted. This is due to
>> b697d9d38a5a ("net: phy: marvell: add SFP support for 88E1510") being
>> added to net-next/master.
>>
>> (I think you have fixed this in your latest revision)
>
> I haven't - but when I move the patch series onto net-next, that will
> need to be updated.
>
>> "net: phylink: use supported_interfaces for phylink validation" looks
>> good. Though the documentation should be updated. Perhaps something
>> like
>
> Yes, I haven't bothered with the doc updates yet... they will need to
> be done before the patches are ready. Thanks for the suggestions though.
>
>> I think "net: macb: populate supported_interfaces member" is wrong.
>> Gigabit modes should be predicated on GIGABIT_MODE_AVAILABLE.
>
> It is a conversion of what macb_validate() does - if the conversion is
> incorrect, then macb_validate() is incorrect.
>
> If MACB_CAPS_GIGABIT_MODE_AVAILABLE isn't set, but MACB_CAPS_HIGH_SPEED
> and MACB_CAPS_PCS are both set, macb_validate() will not zero the
> supported mask if e.g. PHY_INTERFACE_MODE_10GBASER is requested - it
> will indicate 10baseT and 100baseT speeds are supported. So the current
> macb_validate() code basically tells phylink that
> PHY_INTERFACE_MODE_10GBASER supports 10baseT and 100baseT speeds!
>
> This probably is not what is intended, but this is what the code does,
> and I'm maintaining bug-compatibility with the current macb_validate()
> implementation. Any changes to the behaviour should be a separate
> patch - either fixing it before this patch, or fixing it afterwards.
> As the series is currently based on v5.14, it may be that this has
> already been fixed.

Ugh. This sort of thing is what I wanted to address in the first place.
The current logic lends itself well to these sorts of errors.

--Sean
