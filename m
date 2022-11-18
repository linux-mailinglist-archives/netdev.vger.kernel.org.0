Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C4662F8F1
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241719AbiKRPLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiKRPLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:11:18 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2051.outbound.protection.outlook.com [40.107.20.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A328BF69
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:11:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxNfdmxxf2Sfx0AUIJZ9lmwwr6lsZmeoXzV9MzLe6dIHudg8Y4eRFjwMwWTsYZvGGSgCBOO/sXy0VngFf6pJfob+yKcuiCwnVgkJTGyyW+2KNkCHqsSbnnbGYlN0xZ/+4FDolcv/x79GdKSAYKzKNBI11IGJP4ggXG6w53HGPmSTMiiAY5v/JEE2tfbNnZK6Z7Hcc8shhrhh55+rgtw6aKZIuD4IiR0B9RI0GWc8jPnqJpZlVltnQO2MMM+h0DWgchHCqT36PDlsg6fBg8pZvJqybFsHSrr6cH5852ZjqXXPw0GcwSrw0NEosaalAcCtLNx4aFEgFlEKolzjL2sVKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQSIVvRPns4p/PnkLZcZE0WkA1bRElJqFHdQ38T7ahg=;
 b=JdUF7PUNyrZGDjLyZO729VT+BG8AifEQR2uCWBKxQsM5p1LYfFEOGFTPFdz+3kcRjElVUfW0Szm8YmfdFQ+PzgFTK01++Z/1VMtTV6EcQexZNNiKQXVp/2BlxvXzOaa5gF6wveZlxNkHHdqknE8Dscw6B/OwettmlFBy2RjHU1kBG3VmLNMkL8cMitkbdjoenEc3P+2Rth2X4/rVyuqKLLUHn3tl4Z0i5MathJftH2KTDJBKh9AL7hf8rljyevLNzFRPYfrztQGoEGIYkGFZyIiq20sfk/xw0SAVHPP46Cvz5PUqbr4fSwCoKNREwYxlknh+jiJRJqFUsd3Xom6/Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQSIVvRPns4p/PnkLZcZE0WkA1bRElJqFHdQ38T7ahg=;
 b=qrh/NddA0q0WGHuaxHXwP3s+4x9DFoEVGwnPPDc0B+7u26CI0DzyAEcnex5X3KyqyXNYFUb2FLwPV43d57NdA2LSKLbHeprZi2b64FKfqP0S4SsX40aIpLwc43O0Yc2YrxTbepQ4EsF7CJiUT8AHKNjtYE2n1Eb2K5v/og56GnIXgL/hJe4PodxNy05sz4AQNrLnFiyU8tz/CMOdsDn8ivi+2+ocQzKZj6NXQHta/3TGBkjLTPJzaEVz80cTIg4WonQRpg89ZhZ4wsuAIm8eWgBSqcEmiuZk1rwOrK1ZuLRTxO2zPjwrxm4UgQrSBpE3woObQX1BOil4H6zerXQfGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PAXPR03MB8252.eurprd03.prod.outlook.com (2603:10a6:102:23e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Fri, 18 Nov
 2022 15:11:12 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 15:11:12 +0000
Message-ID: <4a039a07-ab73-efa3-96d5-d109438f4575@seco.com>
Date:   Fri, 18 Nov 2022 10:11:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 net-next 2/8] net: phylink: introduce generic method to
 query PHY in-band autoneg capability
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221118000124.2754581-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0060.namprd15.prod.outlook.com
 (2603:10b6:208:237::29) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PAXPR03MB8252:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d39d02b-283d-4bde-86d8-08dac9772148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kD9IeLhJCTs3At7pQRkVZPXalA37Tt4eldMxTEfPWKxRDiOOj4CqDoAS86L48hETaO5UKRzPLqOqZSyZnXBeZAJ2YlWPOWTpqiKdxLK+KZSyNE/9ieVYDHiprYnfgAdyOk2DcvkZHo7TpuU0/uLa/CiaELbnY1VX8cs6I4XUSYM0Ws4fSXLKdA0WeaUdKVMM+O8gGdlh1fCP/9zFBaYJCSKn6IyNcLl/otY4Yo8oukylOl4xP3fYXIQeioWBTDD2HXRtp1vGnsY37XMONyOTttyLYnDEggB+NN+TJKpZcoPqmXChdePQRisjT2sXMyAny9ZqvE2y+7AwpoyBcV71GRCw7o63GEbdFdyQQUX/CO09TEC3BoCstq2gHEySlYetwFc8uGu6Jfr97gD+EDt1JxBC+0Y8irbKEvi2IhBtjhy/8jI4qjHRXDzo5dajOSBiba8mxF82rAbhZAKF9ENBcdxl+KzGpU+rmwTrAEl8hrG7ZNlmZFe2Xr3NbdZVjk3FxySXkzRClDRK6tyuB3Y0hjQFJp4IuyJSIBhQ16hFZq0pMQ9q0ZZvEez5a3vGW22Xgmso6WQH8ZHVUYi3XwxPla1xClxRPli3NQTCRjOjedCAH/PruwlSTYsih8k69+Dy4RZY/3HqeeHyZXaG99uo0ORVUY7L+HNysIuZI+K9CUxQZnyX4wauTgY5GWFSpJ59aM5XdE4OD+GzLt9yS1Lpyum/lHuIThcGzdQ49+pMnkz15mbrzjEfqOgfqXFDWj3kbBrOMV8JS1Yvh/HZtiUl0Am5rG+s0XcTWCFs3wh5KVU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(136003)(376002)(366004)(346002)(396003)(451199015)(38100700002)(38350700002)(54906003)(5660300002)(31696002)(86362001)(6666004)(6486002)(8936002)(66946007)(8676002)(2906002)(41300700001)(316002)(4326008)(66556008)(66476007)(7416002)(2616005)(186003)(83380400001)(44832011)(6506007)(478600001)(26005)(6512007)(53546011)(36756003)(31686004)(52116002)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE1BQ1RkZjlkYWp0dDh4NzhhU1VWN2VIUXdTbkRvbk5GVER0aUhVWlVOMzRz?=
 =?utf-8?B?Z1hwYmRMZGdUQzFiaTJ5OU8rT21zV1lPTnluWTFMc2VVaTNxTlloTjYySk9X?=
 =?utf-8?B?QlVyelJxNTVoa1M0WVhwQkJhOFpQYXhVcUtzWG5zQjhzVTBpd3RSaDVHekdZ?=
 =?utf-8?B?YnRmTUdYZEMvbjRRN2hrU3QzUWlGaFZlckVFRXhqdlNtaE0vQ1Vuc0NRRkRn?=
 =?utf-8?B?WWdMQ0thYXYzR1BlNjd4dGJNRWRtNG1ZZGs5QlVlVFRtOHJTMGpRYkxQMDdO?=
 =?utf-8?B?TXlCNE9UV2pwc09yWWJxZVZtbm95TjZMKzJIdUZIcVgvRytXc3JodS92d29R?=
 =?utf-8?B?MlFhWVJqMVdTTkxIT1MwRlhqK21ucWJqYmFaWm95NFFXZEk2OTliME5OQzIz?=
 =?utf-8?B?SDVVYTh1SURCZXJGM1RsRVRKMlBaYTYrNVdBS2N0MlFuTGFiY2xsc0xpRkNw?=
 =?utf-8?B?SHYrRHdaTUxHbVBTUlI2VEJXbVR3R0J4Q3lFbkE5YWRJZm1Ic3RKbWZCNUkx?=
 =?utf-8?B?NmZqQ3hSRm5NZEMwU3ZZYWl5RUlYWUJldmwwdHNhOTh3amVueUJYcUxCNjNn?=
 =?utf-8?B?N3Y4dGJXaVRWRktyYkRFcElIZW9LTUZkOXFXbHBVOEFqcWp3L3dNWEtrZk9v?=
 =?utf-8?B?YnlCRlVEdmpyeDhkV05aM2VpUVpGcSsvMWJwRENCMlVRc01aS3F6M0pwSVFS?=
 =?utf-8?B?aTlVcnh0dEIwNE13K2xPYVBMTjlxNVJTTWdIOWozcFppejZ6dmtsbVZKbWQv?=
 =?utf-8?B?RkhiYkhVRkQwbE0zQWhQN1lPTzBtWEhwUHhEOVdmV2c2RFlDN2tnUlV4TUxZ?=
 =?utf-8?B?VGhpcE1yaHVqRndmb25Xa2hIOGxVMG93K2RXcTRKbi9IbTgxWHlWMFRoL001?=
 =?utf-8?B?b2h4ZlB5NmE0NWtJM1FlNDZWeTl5Z202QTRzOWcwbTVmckxwOERrL080MnZm?=
 =?utf-8?B?eWUweXB3NmoxSjMzWm5QdE0yemRmQnZOSG9BSkxTQ05mMzkrR0FmVDlBUmlt?=
 =?utf-8?B?aFhScXNhM3ZVZ0lQVGJuSHd1bFI3QnhJVU5rRXBqMHNrdnhmdjV1dG5sQ1N0?=
 =?utf-8?B?TjlGdWZ6VGQxdWFuUnhGaldVam9tYmxnZmVsT0dibjJlWWEzRnNpWFZsYTRN?=
 =?utf-8?B?QnlVclBrcXdrcXdiR2xvUjY4ZG55S2dvNm85eUw3Z0w1OTZteTJ6clVZM2FE?=
 =?utf-8?B?Znh3VHBremdQVWdRcXZncDBHZWY1NEhBVnQ2ZmREMGtFMU45bkZnUFBVR3B6?=
 =?utf-8?B?WUJaYkJvdDNMZDc5Vms4VHowVXBEanl0YnFLWnE2LzgvbU85WDBXWUhCaXZ0?=
 =?utf-8?B?cEpOemZTa05zSFFnZ2MwNjMzdGE1MGROYk1VYVNzUUdTaS9SKzMzZDI4SDZ5?=
 =?utf-8?B?VEozZHY0RFM5cDdwNFZ4U0k3Wk4rVTJzNGdESnprVjRpWGNiTVF5U0djaTNt?=
 =?utf-8?B?SHpWRkg1RTZXNWdXbDFqMjh2MmI0d0dvNmZEZFJVYXVWYmJmZFpLeDBjREhW?=
 =?utf-8?B?MXJjRU5DYmI5MVVsMXpBZjRML1FyRi9OL3BCdFJtQXBqcTdkdllVdXhiSU1M?=
 =?utf-8?B?eVRlSEFsZVljN3U1a2FDbldYZU9kZ3d1b0tJTXZoaHFuTjdwSDdLbzQ1ZWNz?=
 =?utf-8?B?VUMzc1d0bmZVN1pFNWtMUUFNL1dlMVRWL1VLRUhoWkdiRGZvcmNNRTFOTzBi?=
 =?utf-8?B?VDVhVGszK05jSDhXRzN6WUZBT2lBMVhTTTRXTU45NjA5dmdGUHpldWZBN3NI?=
 =?utf-8?B?RjlVVnk0UEZBU1hmU0xacEU1SkFXaFF6ckZDemkrU3VVMXpqQ2V1SEhYVHJj?=
 =?utf-8?B?cHpDTS81WkRyS2NCSTE4VHo1Mjh6U0JKZ3VqaGpsdFk5QlNpMWUzYjBoeG40?=
 =?utf-8?B?ZU4wV1I5aVRrQWluNGNLUUxRM015TEZUL0FscEc3ODZaYWtRNkMrNld1VTl3?=
 =?utf-8?B?MUlVVVNXYi84YlZoTDQrYXZ5ZmM4Y2RxZWRkaFBkQ2hlb0FyWWJPTWlNeWht?=
 =?utf-8?B?cm1YeThVUTdTbDhCTlloa0NCSlcySkVIaksxbW1WaE45a05nLzFsQjduV3Rn?=
 =?utf-8?B?bTlFc3FSWHVzWENLcWswbVBKRkU3NjNkdU8xWW5uVFhVcU9vMC9wQzR6ZmEv?=
 =?utf-8?B?SXlGR1JVeE1XREV3bVV5YzlZWHdKdGJVaDJYN1JjUW1oUjB1VUI4VitHOGx3?=
 =?utf-8?B?bUE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d39d02b-283d-4bde-86d8-08dac9772148
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 15:11:12.3992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMJVKFY9pDHs2FyYUB7rbY63zrK4rYAmXKIftAXU0Oez9h0E9SgTch+QwAsfnpxCn0b5UfUw/PArq8b3fxqjcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8252
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/22 19:01, Vladimir Oltean wrote:
> Currently, phylink requires that fwnodes with links to SFP cages have
> the 'managed = "in-band-status"' property, and based on this, the
> initial pl->cfg_link_an_mode gets set to MLO_AN_INBAND.
> 
> However, some PHYs on SFP modules may have broken in-band autoneg, and
> in that case, phylink selects a pl->cur_link_an_mode which is MLO_AN_PHY,
> to tell the MAC/PCS side to disable in-band autoneg (link speed/status
> will come over the MDIO side channel).
> 
> The check for PHY in-band autoneg capability is currently open-coded
> based on a PHY ID comparison against the BCM84881. But the same problem
> will also be need to solved in another case, where syncing in-band
> autoneg will be desired between the MAC/PCS and an on-board PHY.
> So the approach needs to be generalized, and eventually what is done for
> the BCM84881 needs to be replaced with a more generic solution.
> 
> Add new API to the PHY device structure which allows it to report what
> it supports in terms of in-band autoneg (whether it can operate with it
> on, and whether it can operate with it off). The assumption is that
> there is a Clause 37 compatible state machine in the PHY's PCS, and it
> requires that the autoneg process completes before the lane transitions
> to data mode. If we have a mismatch between in-band autoneg modes, the
> system side link will be broken.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v3->v4:
> - split the SFP cur_link_an_mode fixup to separate patch (this one)
> - s/inband_aneg/an_inband/ to be more in line with phylink terminology
> - clearer documentation, added kerneldocs
> - don't return -EIO in phy_validate_an_inband(), this breaks with the
>   Generic PHY driver because the expected return code is a bit mask, not
>   a negative integer
> 
>  drivers/net/phy/phy.c     | 25 +++++++++++++++++++++++++
>  drivers/net/phy/phylink.c | 20 +++++++++++++++++---
>  include/linux/phy.h       | 17 +++++++++++++++++
>  3 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e5b6cb1a77f9..2abbacf2c7cb 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -733,6 +733,31 @@ static int phy_check_link_status(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +/**
> + * phy_validate_an_inband - validate which in-band autoneg modes are supported
> + * @phydev: the phy_device struct
> + * @interface: the MAC-side interface type
> + *
> + * Returns @PHY_AN_INBAND_UNKNOWN if it is unknown what in-band autoneg setting
> + * is required for the given PHY mode, or a bit mask of @PHY_AN_INBAND_OFF (if
> + * the PHY is able to work with in-band AN turned off) and @PHY_AN_INBAND_ON
> + * (if it works with the feature turned on). With the Generic PHY driver, the
> + * result will always be @PHY_AN_INBAND_UNKNOWN.
> + */
> +int phy_validate_an_inband(struct phy_device *phydev,
> +			   phy_interface_t interface)
> +{
> +	/* We may be called before phy_attach_direct() force-binds the
> +	 * generic PHY driver to this device. In that case, report an unknown
> +	 * setting rather than -EIO as most other functions do.
> +	 */
> +	if (!phydev->drv || !phydev->drv->validate_an_inband)
> +		return PHY_AN_INBAND_UNKNOWN;
> +
> +	return phydev->drv->validate_an_inband(phydev, interface);
> +}
> +EXPORT_SYMBOL_GPL(phy_validate_an_inband);
> +
>  /**
>   * _phy_start_aneg - start auto-negotiation for this PHY device
>   * @phydev: the phy_device struct
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 9e4b2dfc98d8..40b7e730fb33 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2936,10 +2936,24 @@ static int phylink_sfp_config_phy(struct phylink *pl, struct phy_device *phy)
>  		return -EINVAL;
>  	}
>  
> -	if (phylink_phy_no_inband(phy))
> -		mode = MLO_AN_PHY;
> -	else
> +	/* Select whether to operate in in-band mode or not, based on the
> +	 * capability of the PHY in the current link mode.
> +	 */
> +	ret = phy_validate_an_inband(phy, iface);
> +	if (ret == PHY_AN_INBAND_UNKNOWN) {
> +		if (phylink_phy_no_inband(phy))
> +			mode = MLO_AN_PHY;
> +		else
> +			mode = MLO_AN_INBAND;
> +
> +		phylink_dbg(pl,
> +			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
> +			    phylink_autoneg_inband(mode) ? "true" : "false");
> +	} else if (ret & PHY_AN_INBAND_ON) {
>  		mode = MLO_AN_INBAND;
> +	} else {
> +		mode = MLO_AN_PHY;
> +	}
>  
>  	config.interface = iface;
>  	linkmode_copy(support1, support);
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 9a3752c0c444..56a431d88dd9 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -761,6 +761,12 @@ struct phy_tdr_config {
>  };
>  #define PHY_PAIR_ALL -1
>  
> +enum phy_an_inband {
> +	PHY_AN_INBAND_UNKNOWN		= BIT(0),

Shouldn't this be something like

	PHY_AN_INBAND_UNKNOWN		= 0,

? What does it mean if a phy returns e.g. 0b101?

--Sean

> +	PHY_AN_INBAND_OFF		= BIT(1),
> +	PHY_AN_INBAND_ON		= BIT(2),
> +};
> +
>  /**
>   * struct phy_driver - Driver structure for a particular PHY type
>   *
> @@ -845,6 +851,15 @@ struct phy_driver {
>  	 */
>  	int (*config_aneg)(struct phy_device *phydev);
>  
> +	/**
> +	 * @validate_an_inband: Report what types of in-band auto-negotiation
> +	 * are available for the given PHY interface type. Returns a bit mask
> +	 * of type enum phy_an_inband. Returning negative error codes is not
> +	 * permitted.
> +	 */
> +	int (*validate_an_inband)(struct phy_device *phydev,
> +				  phy_interface_t interface);
> +
>  	/** @aneg_done: Determines the auto negotiation result */
>  	int (*aneg_done)(struct phy_device *phydev);
>  
> @@ -1540,6 +1555,8 @@ void phy_stop(struct phy_device *phydev);
>  int phy_config_aneg(struct phy_device *phydev);
>  int phy_start_aneg(struct phy_device *phydev);
>  int phy_aneg_done(struct phy_device *phydev);
> +int phy_validate_an_inband(struct phy_device *phydev,
> +			   phy_interface_t interface);
>  int phy_speed_down(struct phy_device *phydev, bool sync);
>  int phy_speed_up(struct phy_device *phydev);
>  

