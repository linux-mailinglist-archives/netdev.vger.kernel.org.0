Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDC1477C18
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbhLPTAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:00:41 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:8960
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240764AbhLPTAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 14:00:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+8kCdw3WeatPGzugJxgB2GM5nfbRYS8l3lgIQ43MksRIUz/ewZKLIm2KujW/ex1uGz4LPj/h5sHuZ5DBM4u0WYcxVEGxxpmvCj11lRG11OKxya2ezpnRGKU3433g1aC5d337rtmmIoIDCYxEHdEFS/Np+FCv38Y4KldMHP2yKDrPMGj2fvJ20jnTKT14KSe1kbnKJbKpvOTR7XTNH5fnW1AMvbBSRmtIEKgS86EzuuaR9vpvYFRIn5hYBy66UXFJQ8O9pnl8DHno589tRw7dK4r6NWvpritittLfX+8ZGchOUfe/Ch0aMF/mB0fBK5oSPvHlHgtD2KJdkGtQh1Sfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8f7+HmRItDPbNk7Y58LQ6hTxBd+aqu8yA0/Kwt5TTjc=;
 b=I81a7+MABP4Img1JFFtgxx3BxTSYhLuVZ6esRy0c/pZjXNrDmXiAaPAXHoXBVdEVvEL5Y07O8HWepGH9oY9pUHIDeb7VmDOTXzXED0rDjFAp5ibpuMMdAc3rUk+4s75mrGHXX1+Gv/RAXRtyAci+2nRLBgwuYXL0OuoGZ26CxPKzIcXI34hOcXaeBFg1kMPBCHHvvu86DJ160PAD22HzYeCdLaRrCqp4TGbLbp6++XopDEwEaGKqj31/o5UWCSZSCweGHd+h7WCmceGumkh2WnYbAx5N4YEiBrsWg60TTjVC4ZUthjBqQswl9PFVurnYPQkcltupYtpUVJ9/fT0JHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8f7+HmRItDPbNk7Y58LQ6hTxBd+aqu8yA0/Kwt5TTjc=;
 b=oKV4fSNGIP6qlXlttX0MrKMWJsZJjPkE0k2r4DV4yT/RP4fOqwDbBZz+4MWtyW1UbI17uaf/fNt/o2SmqTgPQSYQQpmQl7Ka4WCw4TBwqIYBgtEyQrhuauE60G1uNhBokkYGkJTtPN7N24fg88H2iVV1d0eK4hhxxCrz9peGeLw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7516.eurprd03.prod.outlook.com (2603:10a6:10:22a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 19:00:37 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 19:00:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH] net: phylink: Pass state to pcs_config
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20211214233450.1488736-1-sean.anderson@seco.com>
 <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
 <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
 <Ybk7iuxdin69MjTo@shell.armlinux.org.uk>
 <YblA4E/InIAa0U1U@shell.armlinux.org.uk>
 <1a9de385-1eb9-510b-25f5-d970adfb124b@seco.com>
 <Ybt2syzCpjVDGQy7@shell.armlinux.org.uk>
 <9ce793d7-8361-be07-e6b9-1ecc4e3ff8e5@seco.com>
 <Ybt/9Kc+XJYYecQF@shell.armlinux.org.uk>
 <26875713-a024-b848-24fb-bbd772446f49@seco.com>
Message-ID: <9891e1bd-7d42-8181-b874-e1d3cc64f21c@seco.com>
Date:   Thu, 16 Dec 2021 14:00:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <26875713-a024-b848-24fb-bbd772446f49@seco.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::29) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af66d74c-dc43-43bb-2843-08d9c0c65883
X-MS-TrafficTypeDiagnostic: DB9PR03MB7516:EE_
X-Microsoft-Antispam-PRVS: <DB9PR03MB75168FC638D79F93FD0CAB3896779@DB9PR03MB7516.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVnktQQE6lGkREWOCBHhIXhJv8R/9XqNtTWe0srIz9MdGSzpD8Mw8EBq7BdjJUukKiaCbAjLCosY2km798XuFF0MCK0cTzPwzl5vjqYLQpo57yhgx6e1eFHKaskumwL/W2M/IsL5I4OFhZBLdjNCZZofVeJsdT5Fdn18yaHgv9mN9StCh25UzM4kw30I0HvpsPYoj7p+r4N8DqC+GODbeosVbEVCS5JFHd53hPe/RpWHgrjdY0YDbacHjNpbX4SNKBYj0uT8t24evXMvwspl1W1gtre9qTI9MPVcMTEpmixqmaZABPq9Vx2KRuqimESvmgatZTw5NXMI4P8mJZKbB7buSTPvQ2laxiZ1Zb3I0tSUj7nX3Y3kvLNWrNyQRO+Cz1ar3Afn8hWddyVDiJ1ckv9oY4gfZlydEGR7WKSY1fDGG51SFebBUkzFZvn0dB0wvKP3gqOf493MvE6P+wrC1NwwG3rMdq2TVpi168iXLXJm0e1OqLFksj0JlVBKtM1sFPG0uwZxsFg3myFyvKSPVOvCZHU0DDHp/B7EHf926MVTgttAyU7nnffbWK1gtROzBoYBxF/sLg3xM6QE20SiEpZowqS9tde6bR0KzxmZ/5iOoTEdF9nJTbFNauipERvQ+HhV/hcJ4TNq7ZT8F9ffjR7mIQZw9zff3I8Er61m8ZgUov94kSswCyYDbQHf00qwYzEbdnqnpdtfUpQP3RYaN+Wogr/AOJ5lUfjO4Yw9IT9tlRccq4NEN1iWmcnKkKJnP6XWjRuEjLhLrLWeD1TGTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(44832011)(316002)(508600001)(8936002)(53546011)(7416002)(31686004)(31696002)(38350700002)(6486002)(52116002)(86362001)(2906002)(38100700002)(6916009)(54906003)(36756003)(5660300002)(6506007)(6512007)(8676002)(2616005)(4326008)(66556008)(26005)(6666004)(66946007)(66476007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2lGMTZPQVlmZGFDSlk5anVPbDFnVmRXUmx4djM0N2o4SDhTNFE4ank2YnJZ?=
 =?utf-8?B?T1UyeVVOWS9zMWdoM3E1a3o5dUZ5YUliWHFaY254VUNkME1ad2ZBcXRSa0JS?=
 =?utf-8?B?R1FIOWNqTFpKUVJSVTl6MmxBQlNUNzlmVTVUZ3c0UUtXUVU4TGtDb1NLY0Zl?=
 =?utf-8?B?QldBU056K2V4UW0xWk00eHRVRWt5ekRFcHBHWVUyakFGYjFEbS9vR2dKZjQ4?=
 =?utf-8?B?bHRHOFBRc3ZFRVdDMnlSV1FwbHl4N1E5b2s2d0MxTmVmbVRWWXVpdEtRdjRx?=
 =?utf-8?B?TkZ1YkZwREs4S3BGVXJ6dk0zd09JdDB6dXk3K0tCY1RTS0VDa3k1QUg5RlBM?=
 =?utf-8?B?OTg0dW5zYkV2YmV4anVCUzU0SGFWdVNVLzVSdElRWEhveG5TV2RKMEx1Ukx4?=
 =?utf-8?B?Wmh3YlEyeGMzOXA2WGRvL2lFUVY0Q2hHMWh2dC9wUGIxeVNSbHZnc0g0WjFt?=
 =?utf-8?B?QlVVbTBKNU9TUFRRYVk3QUdIL09uR2VOZDUwZW1UUnE4aHFEYjY3ZG5IYlVG?=
 =?utf-8?B?c05UMDhFamVHN3NhK3hJaXJ1MUVaNURxUTcxRHgya3lvRjRJTlNXS2g5dUlI?=
 =?utf-8?B?QUI3c2IyaCt4VnRDRk1tMFRPU2VpK21sL2ptdm5XRjJpZEFGTk4vOUxuckt0?=
 =?utf-8?B?SC8vT3FKLzl3M05DR0drOXlTU0IrejNVa0tMZ1BpMHBCUTJlRXBtTTQzWUtB?=
 =?utf-8?B?MWZZaUlONnFteVo5STZ5eGRMdmh6S2x0MUJiVlRCMjhudG90TDFJOUNnY0ZO?=
 =?utf-8?B?Z3JoNEdRQ0hYeGhOSHBXWkNwaTZOcDcwQ2JyWnFxZHpkR2ZOcHhxbllORFlS?=
 =?utf-8?B?dkpIalhHeWlFVUFxdHlPRkVwN0RLM0hseEJVcmNXOUZzbVlVby9lRHhEeHlN?=
 =?utf-8?B?WVU4ZmhIbDJsUUF1cG1Vc3kwOVFEKzEvMUdmWXJKTkxwU2VSb1B1MnBncEZa?=
 =?utf-8?B?QksyQVpVQUhydTZlSG81UzhrRnBoaFFhL0M2Qit1U0RpR2dtV0RoNHRaTFdN?=
 =?utf-8?B?QnYrTU01Z1ZxYnpKYXdvd0V5VGl5TGdkU1ZYbjVRK2ZNOEd6OUVEQzNsMW1l?=
 =?utf-8?B?MFpEVVV1YU9TV2dtUjdDd2VUL29XMENQRFY0dU1Hclg2NDF5MFR1K0hQamdP?=
 =?utf-8?B?bExzV1RhM05rUS9aNkxyUUFMWmMwS1JXUkhheGJTUW42bmFjb2FRVWxCUkFT?=
 =?utf-8?B?KzFaVUFnTVNmbDBuSlBIWWtST0l1NHRQRTYxKzVTMFI2WFlYU1ZBS3BnRmFZ?=
 =?utf-8?B?SjZjckpXOGpadlFxM0kvais5THFIdXBmMjV4NWpDVnY5YnVmUExEbU53RUxR?=
 =?utf-8?B?ZUZDT2g3aEpuZWNDbGUvV1FibHVVYkl6SzIyR2NhUWJNYW5UWFpLam9QRXk1?=
 =?utf-8?B?ZndhRFlwdHZrQ1JybTVrckEwRFcrMDBmZktML2xNY1c2a2UxdlR6bWxUWEhO?=
 =?utf-8?B?ZEE2UTRIUVdlOGg5dzVlbVdEbEdVcm9aYUJWcmRyUk5KV245N3VOczBXcFRa?=
 =?utf-8?B?UFZwM1JuaVg4dmVKZlZvS2tZeVZmTXZaYVRxY2JrL25EM2lhRXZlc3hYelRr?=
 =?utf-8?B?R2Vub1VucU5helIxRm1sWVF0MGhKZTJ2Mzd6MDZkWDRkVGhEOEQ1L0JTcjBu?=
 =?utf-8?B?WHhPOEhkUDFlR3VHSDk2WWlJWnYrK2dJVGlmd005L3pVb2hnZ2gxRnRGYk9E?=
 =?utf-8?B?NytSYUdSazFsckg2MUF3VkxneGZ1djgvSEJiR2QvNnpIWUVUWFgvQmZSRklM?=
 =?utf-8?B?NURPQzFWeUlxUlIvUkR5ajhWMWNxYW42WVRGUmdqT1ZIS0xhOXR4NTVTQW5N?=
 =?utf-8?B?SjZyWkp6bHplOFhPd3NObnRXclM0NGxkWTdXcVh2MmtUWHNuK2NDUE42cHdw?=
 =?utf-8?B?MU4xWnpjemxyOWF1eWRhb09NMmZwSEl5M0V2RGErVDBtbCszb21HZjl1NVZv?=
 =?utf-8?B?dGgxdlBnQXoxMFMwWVR1bU1ud2lMTWR3RGtDTG1mU2xlU2FLREZWU3E3bTZE?=
 =?utf-8?B?R1J2dW1qbHBCWVErZVJya01OVlhGMUI3MlgyaE5jOVlveThpaWFjMGlMRGJM?=
 =?utf-8?B?Ti9KdTFKZUlncWN0RTN6RjFpcitlUGp3TCtKazNmVE5YQXk1eVZEUUhGM3Nj?=
 =?utf-8?B?NVdwYnZ2NzdydnBWTVhXa3dOb3J0MUEyWHVINEpHa0FhMU9GYU9rWmVBQUhE?=
 =?utf-8?Q?d54e5eHOVHfsux69Z7PlFO8=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af66d74c-dc43-43bb-2843-08d9c0c65883
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 19:00:37.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dGhKPsfHAHc1/WU/16PC5AATUMqU+Nw/IyxEf5Ibr5q638kb3fPnOZDzcs2rfrRR1DTU1CJlDe2mRmbVl5MBOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7516
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/21 1:29 PM, Sean Anderson wrote:
>
>
> On 12/16/21 1:05 PM, Russell King (Oracle) wrote:
>> On Thu, Dec 16, 2021 at 12:51:33PM -0500, Sean Anderson wrote:
>>> On 12/16/21 12:26 PM, Russell King (Oracle) wrote:
>>> > On Thu, Dec 16, 2021 at 12:02:55PM -0500, Sean Anderson wrote:
>>> > > On 12/14/21 8:12 PM, Russell King (Oracle) wrote:
>>> > > > On Wed, Dec 15, 2021 at 12:49:14AM +0000, Russell King (Oracle) wrote:
>>> > > > > On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
>>> > > > > > Ok, so let me clarify my understanding. Perhaps this can be eliminated
>>> > > > > > through a different approach.
>>> > > > > >
>>> > > > > > When I read the datasheet for mvneta (which hopefully has the same
>>> > > > > > logic here, since I could not find a datasheet for an mvpp2 device), I
>>> > > > > > noticed that the Pause_Adv bit said
>>> > > > > >
>>> > > > > > > It is valid only if flow control mode is defined by Auto-Negotiation
>>> > > > > > > (as defined by the <AnFcEn> bit).
>>> > > > > >
>>> > > > > > Which I interpreted to mean that if AnFcEn was clear, then no flow
>>> > > > > > control was advertised. But perhaps it instead means that the logic is
>>> > > > > > something like
>>> > > > > >
>>> > > > > > if (AnFcEn)
>>> > > > > >     Config_Reg.PAUSE = Pause_Adv;
>>> > > > > > else
>>> > > > > >     Config_Reg.PAUSE = SetFcEn;
>>> > > > > >
>>> > > > > > which would mean that we can just clear AnFcEn in link_up if the
>>> > > > > > autonegotiated pause settings are different from the configured pause
>>> > > > > > settings.
>>> > > > >
>>> > > > > Having actually played with this hardware quite a bit and observed what
>>> > > > > it sends, what it implements for advertising is:
>>> > > > >
>>> > > > >     Config_Reg.PAUSE = Pause_Adv;
>>> > >
>>> > > So the above note from the datasheet about Pause_Adv not being valid is
>>> > > incorrect?
>>> > >
>>> > > > > Config_Reg gets sent over the 1000BASE-X link to the link partner, and
>>> > > > > we receive Remote_Reg from the link partner.
>>> > > > >
>>> > > > > Then, the hardware implements:
>>> > > > >
>>> > > > >     if (AnFcEn)
>>> > > > >         MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
>>> > > > >     else
>>> > > > >         MAC_PAUSE = SetFcEn;
>>> > > > >
>>> > > > > In otherwords, AnFcEn controls whether the result of autonegotiation
>>> > > > > or the value of SetFcEn controls whether the MAC enables symmetric
>>> > > > > pause mode.
>>> > > >
>>> > > > I should also note that in the Port Status register,
>>> > > >
>>> > > >     TxFcEn = RxFcEn = MAC_PAUSE;
>>> > > >
>>> > > > So, the status register bits follow SetFcEn when AnFcEn is disabled.
>>> > > >
>>> > > > However, these bits are the only way to report the result of the
>>> > > > negotiation, which is why we use them to report back whether flow
>>> > > > control was enabled in mvneta_pcs_get_state(). These bits will be
>>> > > > ignored by phylink when ethtool -A has disabled pause negotiation,
>>> > > > and in that situation there is no way as I said to be able to read
>>> > > > the negotiation result.
>>> > >
>>> > > Ok, how about
>>> > >
>>> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>>> > > index b1cce4425296..9b41d8ee71fb 100644
>>> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>>> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>>> > > @@ -6226,8 +6226,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>>> > >                          * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
>>> > >                          * manually controls the GMAC pause modes.
>>> > >                          */
>>> > > -                       if (permit_pause_to_mac)
>>> > > -                               val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
>>> > > +                       val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
>>> > >
>>> > >                         /* Configure advertisement bits */
>>> > >                         mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
>>> > > @@ -6525,6 +6524,9 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>>> > >                 }
>>> > >         } else {
>>> > >                 if (!phylink_autoneg_inband(mode)) {
>>> > > +                       bool cur_tx_pause, cur_rx_pause;
>>> > > +                       u32 status0 = readl(port->base + MVPP2_GMAC_STATUS0);
>>> > > +
>>> > >                         val = MVPP2_GMAC_FORCE_LINK_PASS;
>>> > >
>>> > >                         if (speed == SPEED_1000 || speed == SPEED_2500)
>>> > > @@ -6535,11 +6537,18 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>>> > >                         if (duplex == DUPLEX_FULL)
>>> > >                                 val |= MVPP2_GMAC_CONFIG_FULL_DUPLEX;
>>> > >
>>> > > +                       cur_tx_pause = status0 & MVPP2_GMAC_STATUS0_TX_PAUSE;
>>> > > +                       cur_rx_pause = status0 & MVPP2_GMAC_STATUS0_RX_PAUSE;
>>> >
>>> > I think you haven't understood everything I've said. These status bits
>>> > report what the MAC is doing. They do not reflect what was negotiated
>>> > _unless_ MVPP2_GMAC_FLOW_CTRL_AUTONEG was set.
>>> >
>>> > So, if we clear MVPP2_GMAC_FLOW_CTRL_AUTONEG, these bits will follow
>>> > MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN and MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN.
>>> >
>>> > Let's say we apply this patch. tx/rx pause are negotiated and enabled.
>>> > So cur_tx_pause and cur_rx_pause are both true.
>>> >
>>> > We change the pause settings, forcing tx pause only. This causes
>>> > pcs_config to be called which sets MVPP2_GMAC_FLOW_CTRL_AUTONEG, and
>>> > then link_up gets called with the differing settings. We clear
>>> > MVPP2_GMAC_FLOW_CTRL_AUTONEG and force the pause settings. We now
>>> > have the status register containing MVPP2_GMAC_STATUS0_TX_PAUSE set
>>> > but MVPP2_GMAC_STATUS0_RX_PAUSE clear.
>>> >
>>> > The link goes down e.g. because the remote end has changed and comes
>>> > back. We read the status register and see MVPP2_GMAC_STATUS0_TX_PAUSE
>>> > is set and MVPP2_GMAC_STATUS0_RX_PAUSE is still clear. tx_pause is
>>> > true and rx_pause is false. These agree with the settings, so we
>>> > then set MVPP2_GMAC_FLOW_CTRL_AUTONEG.
>>> >
>>> > If the link goes down and up again, then this cycle repeats - the
>>> > status register will now have both MVPP2_GMAC_STATUS0_TX_PAUSE and
>>> > MVPP2_GMAC_STATUS0_RX_PAUSE set, so we clear
>>> > MVPP2_GMAC_FLOW_CTRL_AUTONEG. If the link goes down/up again, we flip
>>> > back to re-enabling MVPP2_GMAC_FLOW_CTRL_AUTONEG.

Ok, so I think I see what you're getting at here. If we set
MVPP2_GMAC_FLOW_CTRL_AUTONEG after examining the pause mode, then the
pause mode will revert to what was negotiated. But since this platform
uses interrupts, we can clear it in link_up and set it in link_down.

  --Sean
