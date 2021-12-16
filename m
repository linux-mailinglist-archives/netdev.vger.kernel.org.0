Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6247A477B0D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhLPRvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:51:43 -0500
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:11233
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233248AbhLPRvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 12:51:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3P3+qi5NdguTkRph5HV5hy+lwew1xFVp3PSPluYyuRNe+G0RhttUCpgx6ALuZFbbLg8fy0cDgtxmPmQNi5hsBXELyUuc5sPNr4PpMffFwC4BblKJ6DuPWToa4thvvvQ0dxNAbXR7939Ir+kGHUCXtJmnSsAjm2n5DmN0ENDPSYCLYmdnHCLoM23pAAn4+q85w8gd4qeK3+6gw21OnBLnrtlxpEtOk5yWGveFb+LbY2hGwBPSBk3h6drqFHDY5sRIu8pgdckxDemd7SjwDP4r5fH+Qxho4PDwMbziDw+ZWSe/ZLzQUQHAQcCVdJxV6bTpe6Ec1JlBAmbAA+GR6Edtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aauZnjdjGc7kUz61pwaVEw+iLE30I017ERYqQjwQqw=;
 b=dIjWGYmt4oOVzhQbC/odUSU+7/f6nsI/IhpTwLyyubHZzH33eeSbwo9eWOlK3uamshSyOowAPECrjvGpo/t42yuFOAGeeMPiqr/F8lPUF5ce1bDaw6tSwo36ye599ZoI/KnxsDcnbwLOk7y5HeoaT+cNacwrMEZF4xaPB9mvLv1hgoC9vlll9Ugp5k7QSBx8FifyHXDgXTv5czSpJef+yKihcIG1aQJYU/lJWr9f4USsLULXQYEq1bWqODJSzeXKyVvvMSUahvSndgncWwkdvzqJ0FXaETvcg1qaYQe2RrqrYWRymDGyA/Dp75Gc4E/eQKvOTBQFBxGNugLwbxz5Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+aauZnjdjGc7kUz61pwaVEw+iLE30I017ERYqQjwQqw=;
 b=fn5as8PcrseJNivEVzE8OAMsgWCsx4WWFfN6YXgy2sy47UrHsNqKxz6Z6l1cfJhdSnCjusLnJ459Y2g6LOsWbRI9c58qCA2XaEyZtrwYQLeBPNkDccBU5Nud69gtIW6EAsC+TyueopFWr896jWXpJizTM95wO/vsGkOgGr0xP9U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR03MB3048.eurprd03.prod.outlook.com (2603:10a6:6:37::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 17:51:38 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 17:51:38 +0000
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
Message-ID: <9ce793d7-8361-be07-e6b9-1ecc4e3ff8e5@seco.com>
Date:   Thu, 16 Dec 2021 12:51:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Ybt2syzCpjVDGQy7@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0066.namprd16.prod.outlook.com
 (2603:10b6:208:234::35) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a173892-100b-43b6-af18-08d9c0bcb5ae
X-MS-TrafficTypeDiagnostic: DB6PR03MB3048:EE_
X-Microsoft-Antispam-PRVS: <DB6PR03MB30481A5040F7C20D39C2884B96779@DB6PR03MB3048.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oz8E4clxxOP1yYyq7YCWoanOPt2S7BknTBvJ13YN3zPVtb9vXThVynG2Dc3JkG8+FPxUFWDqOxsbyQVNYkMbuzo+TqVQdot9hfPJrI9rvow94Db1JjYIHbKJrPT4VHAogLRvbP+0plZeuw8N9f6Nk/u/r39HbVkMOWV4PZ3nIyjNyWG+YtNJT3/DKf4GeaONgJFd7+bc/HDVw6CABJ/UY7zszA0RUQSbxhetx7tYe7wbm9c6fdSHFYFoAkikXrrUbxZXFfwI84WkIj4wxJMXS7vBtwNnvwJu21bxe0srAD6WTHZ0sYo290PWKGgescOSifgd7M0/aMVBHqbC691WF5Qu50QzlRZyr+2xJAGOwj3zr9EOHpfANzDO7y60G2vimDKv4aqbHSKcsK+DIf/rrNmHPxkEScRfs+Nixzi6UpemGIkOeuFqfOD/yrWnY/6r4iXn+zc1TEukQs527vCH7wo+Tj2SjQ8ei+v2bMUuqEvg/MhLz7mMt9mdainFYRhkR0vxgqecqte7UDgHrisC7TAsPjP+R+vqX8SZwEE0/R7NBRtnENyDlwM1XL7fJO2qocysPhWKzk4IuK3haVD8ARw/fqI3asAiuOGeqqrJmcOoj+0MuiZ75aoBx3Rj/y7gF9gBrD+WSqc84E42sznIu6VtTXJO3UrAR4XvpSwQnEIkqppAyzugAqh6QDu0B0wuPOcNnAyidVpNrzw4Mi4/X90mwfTM5a6xYi4tIpUUwVvs5ZIz9/GiS0yhOBTNSKjbvk3BGF3pi0HFJkn6G28UcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(26005)(36756003)(6916009)(52116002)(31696002)(508600001)(6512007)(6486002)(8676002)(53546011)(316002)(4326008)(2616005)(54906003)(83380400001)(6506007)(44832011)(2906002)(8936002)(31686004)(38350700002)(38100700002)(7416002)(66946007)(86362001)(66476007)(6666004)(66556008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWZUN1RvajNDeGV3Ri9SRWozWXVPNjYyMkN3dllHVkVReklLbE1zc3ZpZnBi?=
 =?utf-8?B?bFRYOXVTb3VQdE9RSno1QkxqcXgxMnprNlZabWQ0YnhhRGhobnhVSXU1SXVN?=
 =?utf-8?B?TTJ4KzJiY2NIaC9zRzVmM0s0MW9YR0ZlWUdMSUJLUVpFRTZjeDV1M3plZmR3?=
 =?utf-8?B?dENpbWFUVE9RbHAydElReTY0ZUFRUHN1b0V1Mno2WVZZK0hNM1RSM0M4L0pG?=
 =?utf-8?B?ZlhhRWppOUZFT29DbzNzbVNyc29VNERkYXlHWDlSUjBxZU1zY21OZzMvanBU?=
 =?utf-8?B?cmZzaWhxdzlTWnBNcnE5NkErcFI3N0JtM1BiTXRyR3hkdHg2dkFOV1hzbE9z?=
 =?utf-8?B?VStJV3B6aGpUejRtSHp1NFM1L2dDWEdOWUpoeU84MzFvdUZucExSYzVpelN5?=
 =?utf-8?B?T2tROFNyb0JxT0ZmNTdTdm5jU1NSNlZIUEJmV21td051ZEFCNlgzYS9qL2lH?=
 =?utf-8?B?b1FQOUJZTXVqeStNU09rVmd5bVMwaUJZWWJmSGxUVmxNVG1XV1g0MDlSOUlR?=
 =?utf-8?B?Rndna0E4aHk1Z0prLzFKRUNQblQ0Uno3ams2VHpiMWtubnVkTG9xWEZtWWJK?=
 =?utf-8?B?ZXgyclU0eWtZYnlrWmxhMzBPUUZiQ0JZNmpOMnI4dFJ1bE9NbXhtalMvbnhQ?=
 =?utf-8?B?UUtCeGNSczdVOEZEdkNIWFFmL1V1MVNmelB2Y1ByTUN4RVBHanZvaEhVQ2JH?=
 =?utf-8?B?Y2xrbk9ocnNFMDFEQjdZb2VoemRFdXVYaldDSHJHM3YyNkNuQU1vMjRWd3dy?=
 =?utf-8?B?WERxbGRUbUU4S0lVMEFIUU5Ock4vQzU4SituQ2JhdHVpam1QUFA5K0xRTDgy?=
 =?utf-8?B?dDVvK09YcTN6UUhQblRzOWRaekkyakRqREdqN3Y0eFZ0U1M5T2FlQUNuUzF6?=
 =?utf-8?B?NlNFRFdEdGRFYy94TFl0ZlVFbU1wNVB1bFp4enlyZi9qeVdzOWpYL1pjbkV2?=
 =?utf-8?B?QzlFYmJhVzdLZGJJd0dDVnRmRksxTmJ4eXRoVThCbnFUa2JrUmo1bEV5TlhX?=
 =?utf-8?B?LzNFNHdxbXR6bjdRUW5aaVdVYlVWaEJ5OHQzblRvL3AwR29uSUI2TW5HVjNk?=
 =?utf-8?B?dUlEZlF3eFp5SGYveE5zQ1VhVFdZZzNTM2Zla05MVGtLcGtGalpsT2lHVkVm?=
 =?utf-8?B?a052YmdEcURqQVpZN2dBMEp1MXZyaGdqVXliL3pFbjJIUFcxbjd2ZWxZSTV5?=
 =?utf-8?B?YlZ5RTRIdG85djZDQXhiRjhjK1RVM3BzM2JmWjFhalhreE1SRmk0K0lqcEI4?=
 =?utf-8?B?MEV4bTNwenhPK0xaOS9vUzc0a3J3VUZZQkJ5bm01VlkyN05Xd0kwVmlhdkdW?=
 =?utf-8?B?L1crSkFUMlJSSDZVQmxmMTdHOU5ETHBuODQ2N2VhZStEYzVXZEZMSzl6allE?=
 =?utf-8?B?UEdHcDQ1S05lcm1wVXJmbU84dktMSjVGSDV6cSt6WlpIaG4veDFvZFdGbEJN?=
 =?utf-8?B?VTRWTEhvSmJZYWV1dU9PMnF1WjBSc2VIckViRE5pZ1VURnhQVXVlV0t3Qnpx?=
 =?utf-8?B?TnJCOUZER2dpVTNMVnhINnNPanVucmpsNmlhNDl2clFNVk9zL3ZNekpNL214?=
 =?utf-8?B?SUxyUHNEbUhMWXV1djhGQnhlVDQyTGZhWGoxWXk0NnhTek8za2ROTnhPYm5i?=
 =?utf-8?B?NStsZ0tRMG9XSjU0VFN4UCtIRWtJZUZhS3FQYTZRY1cxamEzYWRSdU02U1J4?=
 =?utf-8?B?eVRCaUpuTUpOU3VBTDhDb0NueUtEZ1drTXB3UWtITlVuSFlEcFBmU0RmUFRu?=
 =?utf-8?B?TWdGTGd5bmJzUzU4SWVzVnNBWnVQUURJWUZ6VzgvOWhqR1BlampHb2hxS25u?=
 =?utf-8?B?djVhU2JMYzVRajdnZWs1WmdyS1ZPUWdQV2MwT3NJSnVSYmRZNGJ0T0dYL3RL?=
 =?utf-8?B?QUVhMTU3VGZxVzFFOUVYVVJ3TE5NSVRMWDR1UFFJdTRqVG0xM2VReU44RWVu?=
 =?utf-8?B?RGR6UVpqUDFUOVNVZzJRbFEzUDAyWUU3bGpBSTZjOG9tWW9wM3gwTUJHdkxF?=
 =?utf-8?B?WFZXUk5wNjFjcXI2d29RVFRHemVIZEJQdDMrQVVnYUdLTkJGSzhuRTBoMVBh?=
 =?utf-8?B?UUNDZGR3ZDgrMkczaTl2d2FQNy9IOEo3QjlNUG1sTTFQbjNJMWcyQmFnZmox?=
 =?utf-8?B?R241MjdvcWFra2hLZS93ek1yMXVkTWF5NTlnVElSeDlrQ0tDZWVlSWtNcjly?=
 =?utf-8?Q?32sY8zEWrx/zYALe0GqM7kc=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a173892-100b-43b6-af18-08d9c0bcb5ae
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 17:51:38.5693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvp4nH8fEAosIrgJ0YfARbMj5G0MQN+OF3/3IQ/WJCoADb+xAXyiJC4/3xFkg8v1wyTEGh9gk0kMmbBu/ihFWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/21 12:26 PM, Russell King (Oracle) wrote:
> On Thu, Dec 16, 2021 at 12:02:55PM -0500, Sean Anderson wrote:
>> On 12/14/21 8:12 PM, Russell King (Oracle) wrote:
>> > On Wed, Dec 15, 2021 at 12:49:14AM +0000, Russell King (Oracle) wrote:
>> > > On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
>> > > > Ok, so let me clarify my understanding. Perhaps this can be eliminated
>> > > > through a different approach.
>> > > >
>> > > > When I read the datasheet for mvneta (which hopefully has the same
>> > > > logic here, since I could not find a datasheet for an mvpp2 device), I
>> > > > noticed that the Pause_Adv bit said
>> > > >
>> > > > > It is valid only if flow control mode is defined by Auto-Negotiation
>> > > > > (as defined by the <AnFcEn> bit).
>> > > >
>> > > > Which I interpreted to mean that if AnFcEn was clear, then no flow
>> > > > control was advertised. But perhaps it instead means that the logic is
>> > > > something like
>> > > >
>> > > > if (AnFcEn)
>> > > > 	Config_Reg.PAUSE = Pause_Adv;
>> > > > else
>> > > > 	Config_Reg.PAUSE = SetFcEn;
>> > > >
>> > > > which would mean that we can just clear AnFcEn in link_up if the
>> > > > autonegotiated pause settings are different from the configured pause
>> > > > settings.
>> > >
>> > > Having actually played with this hardware quite a bit and observed what
>> > > it sends, what it implements for advertising is:
>> > >
>> > > 	Config_Reg.PAUSE = Pause_Adv;
>>
>> So the above note from the datasheet about Pause_Adv not being valid is
>> incorrect?
>>
>> > > Config_Reg gets sent over the 1000BASE-X link to the link partner, and
>> > > we receive Remote_Reg from the link partner.
>> > >
>> > > Then, the hardware implements:
>> > >
>> > > 	if (AnFcEn)
>> > > 		MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
>> > > 	else
>> > > 		MAC_PAUSE = SetFcEn;
>> > >
>> > > In otherwords, AnFcEn controls whether the result of autonegotiation
>> > > or the value of SetFcEn controls whether the MAC enables symmetric
>> > > pause mode.
>> >
>> > I should also note that in the Port Status register,
>> >
>> > 	TxFcEn = RxFcEn = MAC_PAUSE;
>> >
>> > So, the status register bits follow SetFcEn when AnFcEn is disabled.
>> >
>> > However, these bits are the only way to report the result of the
>> > negotiation, which is why we use them to report back whether flow
>> > control was enabled in mvneta_pcs_get_state(). These bits will be
>> > ignored by phylink when ethtool -A has disabled pause negotiation,
>> > and in that situation there is no way as I said to be able to read
>> > the negotiation result.
>>
>> Ok, how about
>>
>> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> index b1cce4425296..9b41d8ee71fb 100644
>> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> @@ -6226,8 +6226,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>>                          * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
>>                          * manually controls the GMAC pause modes.
>>                          */
>> -                       if (permit_pause_to_mac)
>> -                               val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
>> +                       val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
>>
>>                         /* Configure advertisement bits */
>>                         mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
>> @@ -6525,6 +6524,9 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>>                 }
>>         } else {
>>                 if (!phylink_autoneg_inband(mode)) {
>> +                       bool cur_tx_pause, cur_rx_pause;
>> +                       u32 status0 = readl(port->base + MVPP2_GMAC_STATUS0);
>> +
>>                         val = MVPP2_GMAC_FORCE_LINK_PASS;
>>
>>                         if (speed == SPEED_1000 || speed == SPEED_2500)
>> @@ -6535,11 +6537,18 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>>                         if (duplex == DUPLEX_FULL)
>>                                 val |= MVPP2_GMAC_CONFIG_FULL_DUPLEX;
>>
>> +                       cur_tx_pause = status0 & MVPP2_GMAC_STATUS0_TX_PAUSE;
>> +                       cur_rx_pause = status0 & MVPP2_GMAC_STATUS0_RX_PAUSE;
>
> I think you haven't understood everything I've said. These status bits
> report what the MAC is doing. They do not reflect what was negotiated
> _unless_ MVPP2_GMAC_FLOW_CTRL_AUTONEG was set.
>
> So, if we clear MVPP2_GMAC_FLOW_CTRL_AUTONEG, these bits will follow
> MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN and MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN.
>
> Let's say we apply this patch. tx/rx pause are negotiated and enabled.
> So cur_tx_pause and cur_rx_pause are both true.
>
> We change the pause settings, forcing tx pause only. This causes
> pcs_config to be called which sets MVPP2_GMAC_FLOW_CTRL_AUTONEG, and
> then link_up gets called with the differing settings. We clear
> MVPP2_GMAC_FLOW_CTRL_AUTONEG and force the pause settings. We now
> have the status register containing MVPP2_GMAC_STATUS0_TX_PAUSE set
> but MVPP2_GMAC_STATUS0_RX_PAUSE clear.
>
> The link goes down e.g. because the remote end has changed and comes
> back. We read the status register and see MVPP2_GMAC_STATUS0_TX_PAUSE
> is set and MVPP2_GMAC_STATUS0_RX_PAUSE is still clear. tx_pause is
> true and rx_pause is false. These agree with the settings, so we
> then set MVPP2_GMAC_FLOW_CTRL_AUTONEG.
>
> If the link goes down and up again, then this cycle repeats - the
> status register will now have both MVPP2_GMAC_STATUS0_TX_PAUSE and
> MVPP2_GMAC_STATUS0_RX_PAUSE set, so we clear
> MVPP2_GMAC_FLOW_CTRL_AUTONEG. If the link goes down/up again, we flip
> back to re-enabling MVPP2_GMAC_FLOW_CTRL_AUTONEG.

The toggling is not really a problem, since we always correct the pause
mode as soon as we notice. The real issue would be if we don't notice
because the link went down and back up in between calls to
phylink_resolve. That could be fixed by verifying that the result of
pcs_get_state matches what was configured.

But perhaps the solution is to move this parameter to mac_link_up. That
would eliminate this toggling. And this parameter really is about the
MAC in the first case.

> And we will toggle between these two states.
>
> Sorry, but this can't work.
>
>> When we have MLO_PAUSE_AN, this is the same as before. For the other
>> case, consider the scenario where someone disables pause
>> autonegotiation, and then plugs in the cable. Here, we get the
>> negotiated pause from pcs_get_state, but it is overridden by
>
> In mvneta and mvpp2, pcs_get_state() can only read the current settings
> that the PCS/MAC are currently using. There is no way to read purely
> the results of negotiation with this hardware.
>
> E.g., if you force speed to 100Mbps, then pcs_get_state() will tell you
> that you're doing 100Mbps. If you force duplex, pcs_get_state() will
> tell you what's being forced. If you force pause, pcs_get_state() will
> tell you what pause settings are being forced.
>
> Sadly, this is the way Marvell designed this hardware, and it sucks,
> but we have to support it.
>
>> > permit_pause_to_mac exists precisely because of the limitions of this
>> > hardware, and having it costs virtually nothing to other network
>> > drivers... except a parameter that others ignore.
>> >
>> > If we don't have permit_pause_to_mac in pcs_config() then we need to
>> > have it passed to the link_up() methods instead. There is no other
>> > option (other than breaking mvneta and mvpp2) here than to make the
>> > state of ethtool -A ... autoneg on|off known to the hardware.
>>
>> Well, the original patch is primarily motivated by the terrible naming
>> and documentation regarding this parameter. I was only able to determine
>> the purpose of this parameter by reading the mvpp2 driver and consulting
>> the A370 datasheet. I think if it is possible to eliminate this
>> parameter (such as with the above patch), we should do so, since it will
>> make the API cleaner and easier to understand. Failing that, I will
>> submit a patch to improve the documentation (and perhaps rename the
>> parameter to something more descriptive).
>
> I don't like having it either, but I've thought about it for a long
> time and haven't found any other acceptable solution.
>
> To me, the parameter name describes _exactly_ what it's about. It's
> about the PCS being permitted to forward the pause status to the MAC.
> Hence "permit" "pause" "to" "mac" and the PCS context comes from the
> fact that this is a PCS function. I really don't see what could be
> clearer about the name... and I get the impression this is a bit of
> a storm in a tea cup.

Well first off, the PCS typically has no ability to delegate/permit
anything to the MAC. So it is already unclear what the verb is. Next,
since this is pcs_config, one would think this has something to do with
pause advertisement. But in fact it has nothing to do with it. In fact,
this parameter only has an effect once mac_link_up comes around. I
suggest something like use_autonegotiated_pause. This makes it clear
that this is about the result of autonegotation.

--Sean
