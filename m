Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3626342DECA
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhJNQDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:03:38 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:32421
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230359AbhJNQDh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 12:03:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD4u5SO9bUa9zuek/KX5dwYTRgsfvn+KGwUFUFPIvA2glv8w0DAeP7W86jPjMIopha+FBFhfQLIjDW4yYeROcZ3r3LWBu6xgl60/CoEf/1434WuXNzp1BRsbglkZq+K3horWrm9BXd3VYXtZyDmCeBnlVrtsHYJQXRr2Vrem6kgHv5wX4fVzh2gHwS2b+iN4HfllfP3cpHU3lf4MAk0mw/MpAXUJRF6nEedcM4502dy4fweQt8a+drlLeU2BpRKae0cg2iMWqDzzzPNZkRsjM0W/3xznSJutpgMUP5TcFxJMG9BD/tHGAkPiHqhP082NCH3+wvxhfj8y2uZgIxWSlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEKvcUprMjap+wh2qeMR0T3wmP4/FdWl+e3e4OvWwSg=;
 b=Eus6OjLgfkFMkSLr/THEmwGmAz45P85OFcCiQVjU1CH+qcVZZtCaItEAiEcZXQ8m8+dD8MjeS4Xft6lEZtoeLbctE5juV6l4ySD3FIkZEmwClXDaegh9B6DDraQf6/DTZ41J+4DtW79ThpidnRWXLLyiWavVRpKNG7eu7eJrYeg3cDkZKA3nFyJ5YrTuVd9QbrYacJi/c2ng9nL8ARTqYCLktf45UuaelsXozcHoW69UkXria9DiEecC2kcBkOM3vS0x/gxW97oPJGzH77pYvQfq4akgtdI9uSzx+IYpZ0Pni24JOd5IFHq+dwxSBiLE4UYdb7JZ4trU2FV4VSCeiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEKvcUprMjap+wh2qeMR0T3wmP4/FdWl+e3e4OvWwSg=;
 b=0oAuIQpdNTLmC0rzcD8fkLB49oeGW27j4gr10EjgQVHuaqvy3MN5FCDJSTg6afowvjISkbCPN6WKRo8Db+tkOB+SlGbxykgfIHOxaiZ4IJPYV7+L1wMYb8tlHkXgyBVpVEbku9coDWtMm0voYJr4CKrvwpDkvlyYrvTHj5Hmzhc=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=seco.com;
Received: from AM0PR03MB4514.eurprd03.prod.outlook.com (2603:10a6:208:d0::10)
 by AM0PR0302MB3362.eurprd03.prod.outlook.com (2603:10a6:208:3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 16:01:30 +0000
Received: from AM0PR03MB4514.eurprd03.prod.outlook.com
 ([fe80::5039:758e:c5a:b1c3]) by AM0PR03MB4514.eurprd03.prod.outlook.com
 ([fe80::5039:758e:c5a:b1c3%4]) with mapi id 15.20.4587.025; Thu, 14 Oct 2021
 16:01:30 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v3 2/2] net: macb: Clean up macb_validate
To:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Russell King <linux@armlinux.org.uk>
References: <20211012194644.3182475-1-sean.anderson@seco.com>
 <20211012194644.3182475-2-sean.anderson@seco.com>
 <163411375475.451779.17785363770684815611@kwain>
Message-ID: <08913b53-0960-d8f4-9209-51a059b62fa2@seco.com>
Date:   Thu, 14 Oct 2021 12:01:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <163411375475.451779.17785363770684815611@kwain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0028.prod.exchangelabs.com (2603:10b6:208:71::41)
 To AM0PR03MB4514.eurprd03.prod.outlook.com (2603:10a6:208:d0::10)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR01CA0028.prod.exchangelabs.com (2603:10b6:208:71::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Thu, 14 Oct 2021 16:01:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58d80a07-2e7b-44df-40d7-08d98f2be2dd
X-MS-TrafficTypeDiagnostic: AM0PR0302MB3362:
X-Microsoft-Antispam-PRVS: <AM0PR0302MB3362F8EAB410012A49E4541096B89@AM0PR0302MB3362.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnHz1dJeCSlB4N4Hu30xxTUjOMB3/C7Xnrz5K595JQeUCaaHcmiFtpcucKdwIUJLBINa1HUIYBAHumqERNAzHdv3K5WGROo+Fw3L/C8j8LfXg/Ww6d8GxW6FsZl9p6yFdc43dKv71OynjFrXTram8pnz3AGsCpQUcRPp58nxAWTBc5GIkbdesHMgfccodF4SvICDsO18nOXzAyskO41rdkTBSOIWJyV4GJ0CQa80EmZjSRWi0G61x4s+pdK0ncha5FBprAbaDsfqcIEXlj9gXIKZbIuqLaCFwgBL5YFKoFtUvuVM8YR5YkXodXzXkXwx8GsJHcMWuoaqmECIaQ/56m+aiJUOM7otOtp8rtKRFD5crnnM62pKxoauB22SK4LRkOSL5O3Gs4JMr6eC1fftOJrUo6rYZMq7x7PxUe0XbyatGpO9r1ioOYZlD85cmr+477agD2Xc0uESbm31vdGsEZBWjA6ummu46ShuusI/rcb9idjakRt98LXJnp25gb675BtXCfJMNojUZ5maQNsuGZIPxHpl/PilttK2AIev7mUaP9O3wi+i8+QfQs1oaKnhlqsZ8VT9Iad95D3Y/Yb7iB+bDc2GlvbJJ3YLOWJy9qyflfYCUj6LKSfeuh9FDP8V4YWvJ/m4Jxte1q0p/07mtXTyWgKldPVwBCzFzkhkYsfPZzsskNt7KdNvrnyAtBc4piovqEiamjhCOlgrtqUTnrUskCH1rK69NlZ5ffJ6Bf9B2ET6vMANqVjOsSUiYbIJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR03MB4514.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(6486002)(4001150100001)(26005)(86362001)(186003)(44832011)(956004)(31696002)(2616005)(52116002)(66556008)(508600001)(4326008)(38350700002)(36756003)(38100700002)(5660300002)(83380400001)(16576012)(8676002)(6666004)(110136005)(8936002)(316002)(31686004)(54906003)(66946007)(66476007)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDFqUjJQRTdqSnlXK2hoR3hCNDd0eUpLNjk4SFBndW9WOFpNeUxTbDVRMmR5?=
 =?utf-8?B?R3pXeGxIdnREd0E3SWRjcWVJQ24zZUo0Rmk5V3NCbkVMNldPQTBFdHlES2Vy?=
 =?utf-8?B?QTAyRUpBK3BoTEVsZ3RieCsrTHVMSTBWeGlIanNVTExKTnU3UWhOM2RwVFVG?=
 =?utf-8?B?OGJGTlZIY0VNTS91RzUyRkU0WlRlQ1pCekQxUXhMeHQ0a0M1M05hSkppV0Zr?=
 =?utf-8?B?V3ZsdHBUdXNRTXdrUlBjQ2c2UmZIOFU2U1lsNGxEenRKTnpVNjhqd1hLWjNQ?=
 =?utf-8?B?dzBIR01lOEtObzM5bUhvNWN5aTF3Z0x0VjRnamkwOUJMMWY3Mm1CTTZjK0Nr?=
 =?utf-8?B?eHU3Y3hPUlp2SzN2Z2ZwcHBpclpmbEpNc3c5VUErb2xtQlRsZStOTjBLSEtX?=
 =?utf-8?B?OVByWlRsUzlldm1TSlEvWFlnWGt3NUlzV2tHb21yWGFPcEVucXFlMTJBTkRq?=
 =?utf-8?B?QW9uVFBqS3k0dVhVa2MyT3h4Zk54MlE3c0tDeTM4d0xMNVVIQUVFdWR1Tmw5?=
 =?utf-8?B?L2VheXd2MlZXWTh3eUJuaEFsYVBKMUZaRVFuZWpyNnkrbXQwbFJaT1hLc3lj?=
 =?utf-8?B?c0kyaC9XS0NiUHdjRlpqZEhUQk5sWmt0RUJDMW5mUWV6SmFLOE82VlQrZ1Er?=
 =?utf-8?B?YU91ZW95T1ZncnVYenEraFJIQVhiUWxhRE40R05ZSElsYk05TGsxUHIxeStJ?=
 =?utf-8?B?SEFZZEFyb25nUXJFM2lmdy9TZTA4MWorYVZQaTJXVUIzd1hxNGIyMUxQUDUx?=
 =?utf-8?B?L3NhZWhIY0JvZDkzdnFqUXhlUGFzSXJEVTB0VGNFWWJXWXRYTmRMY211eTl6?=
 =?utf-8?B?WlhlMG14VGlhWWI5STVRQ0s1RXQvQjhqTlYrWTAyVGxieG82OEtZYS8wTXdS?=
 =?utf-8?B?MTNubk5sK0FlVGxnQktqbUN2bEV2ZFdQTUNrUWV3OFJaeFZYcGxxcWxKTEp0?=
 =?utf-8?B?MitIVS92RlhFTUtYR0Fjb01KV1RvV2M1S0w3aEVnc3J1S1AzcTRMUnk1TVBP?=
 =?utf-8?B?bENHUVFweGFuUW54YklyRzU2V3hGYTR1WDJUaHBjMHlqQmN2elVORmVPdmlQ?=
 =?utf-8?B?ZlFWQ3o0cDJUdDlPRVpFTjl6Nlo4SGtmaHBaVk4vL2Yya3VXSnhTcW80RVN4?=
 =?utf-8?B?Qm5LdElNRG1VRENMWUYxY2p3V3E1VG90VXMrbnd3TGdSZ0s2MUJqRHVVNXhk?=
 =?utf-8?B?eEtvSEJHMUdteVBiU29tNDlINlQ2TUFYWnlHSWYwRkdjc2lkWlR3Qm9TL3lj?=
 =?utf-8?B?c0w5UmtiUFhVajBqT3lSd0J6RVVSSW1JVDRuSkxxZmJGWGVnQzBUQUVBVENu?=
 =?utf-8?B?T3lvVCtQK3pqUXJrcnlJQVlZdzlYbnQvdTgvOUNYbjBhQ3pLRWlEeVRudzZt?=
 =?utf-8?B?OHh3d0JIUlN1SThPOEtwZ0g1V1Z6UHJrclVvMUxSaTRsN1g4aVdMbDhkMlI1?=
 =?utf-8?B?ZE9YenVmYktRY0Nqd051NkthbEwwQ0hZOTdLNFl6Rkl5dnpkNzh6OFN1a2RD?=
 =?utf-8?B?cDlKK3k4bWo3cTlhNUJVbURvNitmWjVtd0YrckNtcVc5NGlBVFlaY01TWk8y?=
 =?utf-8?B?RjZWRXVCdDNwc0NnZ1ZyNHJiZVFsRXRyeUtHRUNVNEZxNE83RUI3ZklpSUVo?=
 =?utf-8?B?TTZ4Vjc1a0hkOW5TdDJud2RsYWdwM2RUdE9HUUFsL3JXMVllTGpnMzYvcktP?=
 =?utf-8?B?VUQ4bkJ5MURSSFhOd3c3dDlway9sQlJBNGw4S2tKZEc1bFlVNWlvK2RUaFQ2?=
 =?utf-8?Q?4UIPkt0i2MtqWnOC/cNtlUdhzAymrgO/QFtbTpv?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d80a07-2e7b-44df-40d7-08d98f2be2dd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR03MB4514.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 16:01:30.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0H+vvUbY+5TZGSogjjTs6N8lZRll+v9iY7+7GnjgT/Fq5TvCT2DUz0/GfQ1PsCt6ChpRWynfBTSSIF69IrvhpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0302MB3362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/21 4:29 AM, Antoine Tenart wrote:
> Quoting Sean Anderson (2021-10-12 21:46:44)
>> +       /* There are three major types of interfaces we support:
>> +        * - (R)MII supporting 10/100 Mbit/s
>> +        * - GMII, RGMII, and SGMII supporting 10/100/1000 Mbit/s
>> +        * - 10GBASER supporting 10 Gbit/s only
>> +        * Because GMII and MII both support 10/100, GMII falls through to MII.
>> +        *
>> +        * If we can't support an interface mode, we just clear the supported
>> +        * mask and return. The major complication is that if we get
>> +        * PHY_INTERFACE_MODE_NA, we must return all modes we support.  Because
>> +        * of this, NA starts at the top of the switch and falls all the way to
>> +        * the bottom, and doesn't return early if we don't support a
>> +        * particular mode.
>> +        */
>> +       switch (state->interface) {
>> +       case PHY_INTERFACE_MODE_NA:
>> +       case PHY_INTERFACE_MODE_10GBASER:
>> +               if (bp->caps & MACB_CAPS_HIGH_SPEED &&
>> +                   bp->caps & MACB_CAPS_PCS &&
>> +                   bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>> +                       phylink_set_10g_modes(mask);
>> +                       phylink_set(mask, 10000baseKR_Full);
>> +               } else if (one) {
>> +                       bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>> +                       return;
>> +               }
>> +               if (one)
>> +                       break;
>
> This can go in the first if block.

OK.

>> +               fallthrough;
>> +       case PHY_INTERFACE_MODE_GMII:
>> +       case PHY_INTERFACE_MODE_RGMII:
>> +       case PHY_INTERFACE_MODE_RGMII_ID:
>> +       case PHY_INTERFACE_MODE_RGMII_RXID:
>> +       case PHY_INTERFACE_MODE_RGMII_TXID:
>> +       case PHY_INTERFACE_MODE_SGMII:
>> +               if (macb_is_gem(bp)) {
>> +                       if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>
> Is not having MACB_CAPS_GIGABIT_MODE_AVAILABLE acceptable here, or
> should the two above checks be merged?

As I understand it, macb_is_gem does not imply GIGABIT_MODE. I'm not
sure if GIGABIT_MODE implies macb_is_gem. The logic here is mostly to
match that in prepare()/config(). From what I can gather, all accesses
to GEM registers are protected by macb_is_gem.

--Sean

>> +                               phylink_set(mask, 1000baseT_Full);
>> +                               phylink_set(mask, 1000baseX_Full);
>> +                               if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
>> +                                       phylink_set(mask, 1000baseT_Half);
>> +                       }
>> +               } else if (one) {
>> +                       bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>> +                       return;
>> +               }
>> +               fallthrough;
>> +       case PHY_INTERFACE_MODE_MII:
>> +       case PHY_INTERFACE_MODE_RMII:
>> +               phylink_set(mask, 10baseT_Half);
>> +               phylink_set(mask, 10baseT_Full);
>> +               phylink_set(mask, 100baseT_Half);
>> +               phylink_set(mask, 100baseT_Full);
>> +               break;
>> +       default:
>>                 bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>>                 return;
>>         }
>
> (For readability, it's not for me to decide in the end).
>
> Thanks,
> Antoine
>
