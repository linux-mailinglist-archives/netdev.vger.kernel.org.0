Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C944614E75
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiKAPgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiKAPgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:36:33 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2056.outbound.protection.outlook.com [40.107.105.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598A119027
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 08:36:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVeFwTajwvcGYzn35Nr1oeurWpHXjnTWHEiUXjzSmiuT7/SD9KD6IFKqf5Uo97aJihjUgV/T/mdrrojPLXFlkBkiinZxRkWOR3S8qLf4PxsaSCH6y7ukIsj+qjIBuNuR0vLoyhmEoECfGOyFic+thPBwIE1j3M49AipguyItlxREnMfCOV+rYWWkijhgyTw8j1PWIcDGWAVnltCxpELhdIOnmSz0nDksus1KkSEKa30kFe/Bl0PxGlNEnAGbEBD22Lf8G+3PJF+vftlR8lSIF7MdSOoMGjxz+6Mbcjm2FeeOyQBmrQGfLHUKrvxwIADN8S/W0CXyRt98WE7ucbgqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIohYX2coXu6PRSAH4g4a2XeSKoNb2OeoD214zkoM/M=;
 b=T84wGh4AnW0GnAI/R8lq3ScKZHw/wFIiAY9o9s9fYwZ4X+HrrejnWG+iKhV4JHEJIya9UCwM+Oi9kd2+CuToDdg/7q0P4374p4H7XXQK/8G3YFxwAQ+Dj0RrkxmZY/TAijMTcHYAONnvoRxM/jOZBhl4IIW/Lj+FCOax7w4mzL1pwZLdKzaT41IGXUJCgTUqM8cPlbY6t/vijGV8JUzgjAgg4JvA6tzAMcdQcWlhzgTZhZFmt9J2thqUHHpyLT5fN5B1aK9UkNNRtVzZFvJ6s8izgZMryvlzD2/T5QPCo1w7wOPgCGdadmLpuICHqNUUjLtaLuRLFNMnAVvwQ4Fn0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIohYX2coXu6PRSAH4g4a2XeSKoNb2OeoD214zkoM/M=;
 b=fIbqPuvg0oU2CTjrZUienZYMtHazIMsJCI0b6nn2JsfWupToBmZucP87hPGXFrvjQmVXGS6GhNtDDq0a5U2siuVDI5QOhLZWaVe6L7wmjVIKUxsmTyOFjYQw2OfDADTVY2Kw6sw9W+oLnZ/k0uUFFAMQQcxFv43uAPtXK1Bsaba614SP6+9tnlt0a9hctxbOJY6RWifcJ18VdvOM2O9Q0vQv3BpOUVzEZh68My3Fz+viyhLy1krSfwmav3EYdZjLdbM6QwUVl2t/6kZh+mH0FM4lnKYwLvAPGs9wn6/gKCQzOBacfAhdITNniiXBWflUdcvQSk4J2bitbfd4PYdAvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB6699.eurprd03.prod.outlook.com (2603:10a6:10:20b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Tue, 1 Nov
 2022 15:36:28 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::9489:5192:ea65:b786]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::9489:5192:ea65:b786%7]) with mapi id 15.20.5769.015; Tue, 1 Nov 2022
 15:36:28 +0000
Message-ID: <b7683eb0-89af-33b3-f8ab-4bfbe0825cbe@seco.com>
Date:   Tue, 1 Nov 2022 11:36:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next 1/4] net: phy: aquantia: add AQR112 and AQR412
 PHY IDs
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-2-vladimir.oltean@nxp.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221101114806.1186516-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0185.namprd13.prod.outlook.com
 (2603:10b6:208:2be::10) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DBBPR03MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ba571f-168d-4902-f6b0-08dabc1ed78a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pnGR/2GF7JQbw3AQCM1qaiqUrdjPt3ojv6vVnl3b+TI512dVzAyHf+Q+VefRzwDHxrE29yPjrS8wswTQCjRX7O9COd+43zbH95Li1uAaYU3unK6dEg6sNCZDEF8AEm9YzyZ0NqpS+XjnN1pNp//K57YNBS/IUqUTzJ8OFJ1YPddK+youjUYARYwaVNoTY73pn0IK4yUHALu4/q3wlfWVDZWF25iQh91yMc/IWDNhUxiRzUKx5c2mQukzrsS4mPu22UWr1jhAAyS1szq+ikqvG6isOvcuYlOHSB9dYPHMlTRKCzOHRLoi0c5Yz6+3D5fFKS1Gl4JBC01oeU5g9cBuelOWT7f7s+86s9rjw4eSc8ZQfhnUf29s8IcdT78ysUf48UtwggTFSXkBqfGvboBkS/mWhUWsMRMpKWxWdDcU3T8Lla7ZtnmkKdWR2JO//BkTTayPZoErx9kBdd1pfSO4XoEfvkEuudpS+bUVYHqXlR836IzD8lXyAU2MgE6cN1HtFFneWVDHa+UNjY82UvQgmA/dpSg/3wZc9DeNuRn68CU5iuaaRCokejXRZX1l/Jj6Ph/R1avRfl3AP4/VmQ2zmh8L3y+GanxOqWpm7DgN48yZ7vFrzzBuGblHwhaeeDPjFJGmK0Yzx40rPuD/oiM19BpmFAziCxtlSVfFHP7heX7e3dYRgUVF63rOnQgB1c+t3J3610pQPoDbI2Yh0hhyBi0TJsu/2npq7xa/u1Bfipg8eDpZ1jxsEhMCivHArHKvlvx2YO64Gq30mbdKiTP7ppOVOe2OzBVlrvvswgA8Yvpg9oPZPGXGoDzdyKKfJDsMmlL1MurVd5c92ZW0h42BvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39840400004)(366004)(451199015)(31696002)(86362001)(36756003)(186003)(2616005)(52116002)(38100700002)(6666004)(83380400001)(6506007)(6512007)(38350700002)(53546011)(26005)(5660300002)(7416002)(2906002)(44832011)(41300700001)(8936002)(6486002)(478600001)(66476007)(66556008)(4326008)(316002)(66946007)(54906003)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0M5YzNFRmpUUFdiampiK1E3RGlMRGRJaDFESkZQVG01ZGFTRllQQ0hmNnF2?=
 =?utf-8?B?TmV1cXl5NmpLRFFpUTQ1bXpMZnFJRFBzd2JQRCtDSHFNUmJaZ1dmSzMwV012?=
 =?utf-8?B?b1JRQllIWDh3UitScjdFNCt0Q1l0dGNHMjlnUnRCSmkyVGZlNE8vU1JhS3VX?=
 =?utf-8?B?bTlYTXZKNkNFTE9tTmhWMEVtZHBHM3p3OW5Lb25xZHJDbjBrRkdHZ2tmeWxk?=
 =?utf-8?B?YUZuRXdUZHVWRHdCRXpDWW9lSlVHNks1UnhFc2hNNDBCL0FZUkZPMGYyaUtk?=
 =?utf-8?B?RzFVcHRPcUJiUlZQYzc2MUNrdzZSKzVwZUVXNVdYY1pIVEd3RlV5WkRCdjZi?=
 =?utf-8?B?dWQyeFZSU3dsbkZ5Vy81MDJ5aDRnT1R5WWF0U09zQ2JoR0l0UTdJRzQ5Z1A0?=
 =?utf-8?B?YmNJNzV5MDBkY05BT055RENLV2ovbThtd25tS3lSL0VXYUoyZ0NPYjZxSS9B?=
 =?utf-8?B?U3VleXdFQ3pjSXZQUWxrWVdVWGJ2eTBuNi9pUW9BQWptR01RNFBDOUZHN01i?=
 =?utf-8?B?TDVpM3YxazRPcFczKzQ1Zk9HQWhEVDJjT3VPekhwblNaY2Q2OTcwV0hjdkdt?=
 =?utf-8?B?RERnajk3QVMvNDNXV2tQWGxhS05GaHlwNWZmTWgxRFI3VFQ1dlprdjBjUmZj?=
 =?utf-8?B?ZzU0VFFiQjdPZjRXQ3QrS2FlN09iVDBZamk3bWlSRUJJNUJ6aFk4NFpJa2pk?=
 =?utf-8?B?K3BUMW1EU2JGdFV5eE1sc2wwWkNZclROdjE5eTVzUHVSaEhCWktpdy9QRnBY?=
 =?utf-8?B?dHVzNDYvc3pEV1dqMklqQkczM1V1djR6MjlxRjE2Mm90R0N3aE1EM2twVXQw?=
 =?utf-8?B?VTV0S1p1WGxLdjBlNjhmcloxWk4wbjB1OCt4UTZlZ3M1ZUFaL1R1RDNkN2ZS?=
 =?utf-8?B?WldYTHFxa1FMUm5nOUZLOFgvTS9tVWhKUlN6RHZkYXUwYTZsdG11UG0wZE4y?=
 =?utf-8?B?cmpkSWUyUWhLcXZqbFZOZktxbGhFZnpCREFCN2M4N284UHd5ZzQwbk1pOGtD?=
 =?utf-8?B?OXNoaWtGQ25qWkMyUkd3ekhQOTY3dk8wSXQvUEQzbEZSL1BDTm80cHEvSGI3?=
 =?utf-8?B?biswRjdRUStSbkF6Tm9sakFMbGNIMGhseEtSU0E4Z3JIaFY1RWZ5QkZXM1Mz?=
 =?utf-8?B?V3JYZ0N6Tk5BWUppbzFKdUZNZi9HZWlLYTkyYlRxcm8zeTdsVWdIcXVSWVRw?=
 =?utf-8?B?OEJEVi9kY0NUbmNUaW1Wa3YzdThmR1N5VzN0UURiMy9MZktSc2dmT0RGZXgy?=
 =?utf-8?B?RHh0ZGUxUkZTY1FveUJVY0R4Y0R4TlpjM2N4eStONGxLR0FQVFBra0ppbUd5?=
 =?utf-8?B?U0F6cEJOaHdnclcvN1prdk1OdjBvOHloT1lPc3ZtUzdtajBRNGhEQUVNKzV3?=
 =?utf-8?B?ekpWNFBxNjg3cDFUeGV6RVhvRWJSNlgwREJTM3VpdGswVURZeFpaT1E0eUo1?=
 =?utf-8?B?OGdna2tiZXpmeEhoOUxKb1EwTG5jd3RqQXhPRnQraGRHUXhQdWlNRi8vUk5p?=
 =?utf-8?B?TWdyV3FQdURXcGIvSTBSL0pHWnhyMGwzY3NvTWYxYUxEQXVPVldncmRHUkwr?=
 =?utf-8?B?dTBLT0NId2xvRzAzQWxoRUFZTnhuc1pzN2h6dWo0TklvL05YU1Z4NWZSeHp4?=
 =?utf-8?B?QnR6TlorbEZnbE9zY2EyVlovZWZWSHUvQ043Wk5HNUVmT0NCQnZDcjdwRVFR?=
 =?utf-8?B?ZVZWcGdLUjZsUXd5MHpxYXhWekJWT0RRU3IvanE1L0MvWFpQNENDS3lKNlQw?=
 =?utf-8?B?RHRDcCtBUDVLNzNkWXBic2NxU3o1V1R2OGFHNFpNVXRRQXhCQUdZUVJJUUJj?=
 =?utf-8?B?cHgrL05QTmJkRnR2dENPYlgxY0ZmY216aThTOGJqaFQ5M0EwOWZKOTRYeWND?=
 =?utf-8?B?dFBpZzBtWC9wL2JLMVNlalR0UkJrVEwxRXRIM3B5MG9ndjdLK0ZUYXAwenVG?=
 =?utf-8?B?bVZvUE5ORW1COGNhUDdBRE1FV1lYQ3JjOFNEbVYvVTYwcXBSMXhhck1qNGly?=
 =?utf-8?B?TnJDM2hjYVpQeEFsWnN5VGlzQzdqd3BkNTFpQjk0ZmFtaTlFV0NuNlV1SnJt?=
 =?utf-8?B?R2dJV1dDbEM5Ti84alZudUZRVENGOFVDeFdZLzJrY0cvTnVXaUZCQkUydks4?=
 =?utf-8?B?ZjZEVThzdzJ2QTRDNlJ6dUp5YzFjeVVGcjEwQnM5a1kvdHlnNjRlQmJlK0w0?=
 =?utf-8?B?M1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ba571f-168d-4902-f6b0-08dabc1ed78a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 15:36:28.0720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TzoLWJ8NAKyxwpJ7KY3jPyZXIHXVmg/H8P6SRs11ZcA77091XNX7EVMebTImisLjthah0kTUA6Y4hCR79Y2C2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6699
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/22 07:48, Vladimir Oltean wrote:
> These are Gen3 Aquantia N-BASET PHYs which support 5GBASE-T,
> 2.5GBASE-T, 1000BASE-T and 100BASE-TX (not 10G); also EEE, Sync-E,
> PTP, PoE.
> 
> The 112 is a single PHY package, the 412 is a quad PHY package.
> 
> The system-side SERDES interface of these PHYs selects its protocol
> depending on the negotiated media side link speed. That protocol can be
> 1000BASE-X, 2500BASE-X, 10GBASE-R, SGMII, USXGMII.
> 
> The configuration of which SERDES protocol to use for which link speed
> is made by firmware; even though it could be overwritten over MDIO by
> Linux, we assume that the firmware provisioning is ok for the board on
> which the driver probes.
> 
> For cases when the system side runs at a fixed rate, we want phylib/phylink
> to detect the PAUSE rate matching ability of these PHYs, so we need to
> use the Aquantia rather than the generic C45 driver. This needs
> aqr107_read_status() -> aqr107_read_rate() to set phydev->rate_matching,
> as well as the aqr107_get_rate_matching() method.
> 
> I am a bit unsure about the naming convention in the driver. Since
> AQR107 is a Gen2 PHY, I assume all functions prefixed with "aqr107_"
> rather than "aqr_" mean Gen2+ features. So I've reused this naming
> convention.

In Aquantia's BSP there are references to 6 generations of phys (where
the "first" generation is the first 28nm phy; implicitly making the 40nm
phys generation zero). As far as I can tell these are completely
different from the generations of phys you refer to, which seem to me
marketing names. Unfortunately, they don't have a mapping of phys to
generations, so I'm not even sure which phys are which generations. The
datasheets for all but the latest phys seem to have gone missing...

In any case, if it works, then I think it's reasonable to use these
functions.

> I've tested PHY "SGMII" statistics as well as the .link_change_notify
> method, which prints:
> 
> Aquantia AQR412 mdio_mux-0.4:00: Link partner is Aquantia PHY, FW 4.3, fast-retrain downshift advertised, fast reframe advertised
> 
> Tested SERDES protocols are usxgmii and 2500base-x (the latter with
> PAUSE rate matching). Tested link modes are 100/1000/2500 Base-T
> (with Aquantia link partner and with other link partners). No notable
> events observed.
> 
> The placement of these PHY IDs in the driver is right before AQR113C,
> a Gen4 PHY.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/phy/aquantia_main.c | 40 +++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
> index 47a76df36b74..334a6904ca5a 100644
> --- a/drivers/net/phy/aquantia_main.c
> +++ b/drivers/net/phy/aquantia_main.c
> @@ -22,6 +22,8 @@
>  #define PHY_ID_AQR107	0x03a1b4e0
>  #define PHY_ID_AQCS109	0x03a1b5c2
>  #define PHY_ID_AQR405	0x03a1b4b0
> +#define PHY_ID_AQR112	0x03a1b662
> +#define PHY_ID_AQR412	0x03a1b712
>  #define PHY_ID_AQR113C	0x31c31c12
>  
>  #define MDIO_PHYXS_VEND_IF_STATUS		0xe812
> @@ -800,6 +802,42 @@ static struct phy_driver aqr_driver[] = {
>  	.handle_interrupt = aqr_handle_interrupt,
>  	.read_status	= aqr_read_status,
>  },
> +{
> +	PHY_ID_MATCH_MODEL(PHY_ID_AQR112),
> +	.name		= "Aquantia AQR112",
> +	.probe		= aqr107_probe,
> +	.config_aneg    = aqr_config_aneg,
> +	.config_intr	= aqr_config_intr,
> +	.handle_interrupt = aqr_handle_interrupt,
> +	.get_tunable    = aqr107_get_tunable,
> +	.set_tunable    = aqr107_set_tunable,
> +	.suspend	= aqr107_suspend,
> +	.resume		= aqr107_resume,
> +	.read_status	= aqr107_read_status,
> +	.get_rate_matching = aqr107_get_rate_matching,
> +	.get_sset_count = aqr107_get_sset_count,
> +	.get_strings	= aqr107_get_strings,
> +	.get_stats	= aqr107_get_stats,
> +	.link_change_notify = aqr107_link_change_notify,
> +},
> +{
> +	PHY_ID_MATCH_MODEL(PHY_ID_AQR412),
> +	.name		= "Aquantia AQR412",
> +	.probe		= aqr107_probe,
> +	.config_aneg    = aqr_config_aneg,
> +	.config_intr	= aqr_config_intr,
> +	.handle_interrupt = aqr_handle_interrupt,
> +	.get_tunable    = aqr107_get_tunable,
> +	.set_tunable    = aqr107_set_tunable,
> +	.suspend	= aqr107_suspend,
> +	.resume		= aqr107_resume,
> +	.read_status	= aqr107_read_status,
> +	.get_rate_matching = aqr107_get_rate_matching,
> +	.get_sset_count = aqr107_get_sset_count,
> +	.get_strings	= aqr107_get_strings,
> +	.get_stats	= aqr107_get_stats,
> +	.link_change_notify = aqr107_link_change_notify,
> +},
>  {
>  	PHY_ID_MATCH_MODEL(PHY_ID_AQR113C),
>  	.name           = "Aquantia AQR113C",
> @@ -831,6 +869,8 @@ static struct mdio_device_id __maybe_unused aqr_tbl[] = {
>  	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR107) },
>  	{ PHY_ID_MATCH_MODEL(PHY_ID_AQCS109) },
>  	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR405) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR112) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR412) },
>  	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR113C) },
>  	{ }
>  };

Reviewed-by: Sean Anderson <seanga2@gmail.com>
