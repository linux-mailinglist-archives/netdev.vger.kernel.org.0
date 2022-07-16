Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509A35771E8
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 00:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiGPWaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 18:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGPWaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 18:30:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6261A071;
        Sat, 16 Jul 2022 15:30:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dplyq4NMZOU6dG1T99yvJdhZrZdGL7/roDYF6+kMcTKzUOP06lXO664jEKHgPfYq02xllELoTEmFsy7pYtAsLPmkAQMyuA35Og70wqVbLFFDx9gYgzYA65N+EGxHbCJSupi9Ol91Ep22KFFA6oIv3K6SeLgjwwss1FcusmJpaGT/NdSxlxAN21QlNR6BN6V9VVuv7TdcbMMQmjbm+Jzp+0qWSRnt5QGglsOh/HMw6Vs4SZ2q3yL1NP2csJW3t4dFZHVn2rm3/TFSaSVEIXkRmohM2++YTjXa+jKYHrLfHSJFUk5tL1Qvfu27dCpiJzL/BrGEMCsE+54yDPO2cY4Klg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JELPQGmS6JwoYXFBkIxOete9bKx4iZRba9BCVAxLKCY=;
 b=m9aukRq/xX7fiz5LYbA2C0leh6/Rr8gqRI2Xl54UNsPCGtY+ePWcwXcHEv362GloyucKVFMlhPzM+misV6CtSOPp4WbCkRKlxRub87b6jjWkrwy4XiJVWQhujhlM5V7/CNOs83qHkB7GMpMP49JHyTV7/JOuq1kO0JHY9UcTD/py39oaylQl2W5LPBSMojcdRlkXpBMfy9AQjodh9n7nElJl6rFoXJ4XE2lcVGDyEPVgEL2m4XZkyGFSLdrMEosxy9Nj4+G/EDVO5SNrA8IZJqSEkoTTWOXA92vE2j7U08yC8qihj0XCffk7RZ4mQZhxE5kDsJZYHTr3PfFpgNMHlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JELPQGmS6JwoYXFBkIxOete9bKx4iZRba9BCVAxLKCY=;
 b=Jaj0NAcyQfqBljsd8Ik9q0XdKuK7J4RCrQOo3Mc+KtXSwI7kGwloMPJBITulcA6WPsvbY290R1SIMzMhNRCGbyW/UZQ2MepOsqaOqs1ztaTSrzGx4m6VMWVZ2jf4Yx1NkXQYt/ZtyaVU3pw6fW8ooRWYNb008OM+nWqLcjJEm+fuDiS6eNc+ZwZ1odV16gcdC07RzR9NbjtqGfUICmcqCW+FAU3wlaTAHlCvr17euAaXm2qVWxvh9z8KqPRaTEwom7Vuwg+BH59bMXo4b3ZJkXiNFLjI/1a0N7R7hWyZNqiXt8kCrYuNW7uBKS3mcnjXWkZDXLouyEbsLhbyh+yDSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7684.eurprd03.prod.outlook.com (2603:10a6:102:204::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Sat, 16 Jul
 2022 22:29:58 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.022; Sat, 16 Jul 2022
 22:29:58 +0000
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com> <YtMaKWZyC/lgAQ0i@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <984fec49-4c08-9d5a-d62f-c59f106f8fe5@seco.com>
Date:   Sat, 16 Jul 2022 18:29:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YtMaKWZyC/lgAQ0i@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:2d::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 147ec962-d967-42c1-6305-08da677ab72c
X-MS-TrafficTypeDiagnostic: PAXPR03MB7684:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QeDJiGQp37Tifl8oB4hnsPMI8WS8RgiG0KGApGACi3zDOPjDq4I9ySOhHtAKLmjaeFL91XkScRsxuM767X8RmwA0h3lidsR/RSbHtToYhrPvnfr+edrr9wZp8IHhR45wXeQwOGg/36cLrCKHMXbmirP0napZEkw4HIttLsBJWs9Q8Hr18mNiqMSavdYkdooR8vJH6T2mKmVjUhWrynb/GBRF+4Q9WE/aW58wG4OXVm3Da9AWQqwr2ycF6inJWJAhDu6q/SMWAZTJU5FlY42L3NGP+WoiWvjMkDGlGmA8a7EduFEVwudtfyAwwcC/v9pDQNEpXJi141TpjkprefbP+LqtCltkowxebX0POihN3f7ZpczUtGApf8Ds2YOnYvCe9Ak2egg+NZ2XVF1F4fzYplbv0yhDBguTaP9XCPEb1lzynmxhK4VFYZUPKbuU8Kq8ZOZFBF/bcKhAO3fPyZ96gEBzFTrgEw9NG33U0/xH7OFxAGBVzTmgKYLe4SuscHP7xTuFhcjjA8UdmJcBF/2iu3WSbu+kDbHV/2mjdYIJLQDZamxNJ2AbWlawcXeqSWSFWUiHL1F5XTIe/6HcSjN6TcUhKMKg1vsqxSeZnddUwpEaz87urXMqsH6VR1rss/8q82dedJGq36J0AH3ftuPuIWCUBu0S55BhlJMxybuoBSUaSKIGIAm0A48C790ItVFnNzBVVk0+VVt41mWX9VREoJAN4Av+XjlCYDOIlQOY14A5J/U8A0PlOluRnLXqX0JXDKxYbDSX1FLGDJmJskVNJr778ISc31DpAoxdCb9IyFAiHCeVUi5JRU3Yb37Qotk6BYDH8MVwAI3HW+201+otOqu4mrmUUwRKiF+QHlaOi48sly1gnEf/NbZjw2B4EC8Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39840400004)(396003)(346002)(376002)(136003)(366004)(6486002)(6916009)(83380400001)(41300700001)(2906002)(7416002)(44832011)(31696002)(478600001)(8936002)(6666004)(54906003)(5660300002)(86362001)(2616005)(53546011)(6506007)(52116002)(38100700002)(38350700002)(36756003)(26005)(6512007)(31686004)(186003)(8676002)(316002)(4326008)(66476007)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1FqQ09jZEN1OTRIK3IvQVJ5V1lMVEYvamFpYm9hdUpnVXFwU0tCejZMQ2pO?=
 =?utf-8?B?dEZUQkg5eVNqdXZxK3puWUk4dGlVdlowY1dJY2NZMUZxNjZzazk2N3gzb1RP?=
 =?utf-8?B?aGt6Y2dWMlJZK2F4WXVNVU1yVXZxeUIxZlFkYVRYVDBzVXVhU0J6cjk0WTlJ?=
 =?utf-8?B?K2d1MGduZ2RBdjBWTk5ya29ENE5aTFJMRXZ1NWJOWDdNYU1hM0FBeE4zaVNS?=
 =?utf-8?B?QjV1cG5rZGpxTW1TZjFDcHBsc3BUYlRiQ3d5aTRhZko5bXVpMFFPWGZZY0pO?=
 =?utf-8?B?VHdsUklCVkJQclJucURXaFovbG5HL3VjVHRVd2RIY3lNbElFY2FHK05aTzI2?=
 =?utf-8?B?SUxVSzF3bUw5aDUyRXVSaVFqTCsxTU1POXZvN2dxS1pjMTZkYTA5c2xEUDFD?=
 =?utf-8?B?MGZrWXFlcFlsOFE1WVVkY3cvY2R2b3gwQW9lcHQxZDNqRHp2YXRBbVFiOVRn?=
 =?utf-8?B?WmxNMysxRE1VUmIrZElDNWpITFpQd0swQ2lQMW9lazJKbU9lMVZILzRQcU5N?=
 =?utf-8?B?TWdQTUlMb0h4MkdlQk01TndJemoxUE5mQ0VLUURiN3plQ1JhamlzblIyQ05P?=
 =?utf-8?B?eEkzQWNjSmNqSGtDc083L3ZvK3ZSNDFQU0dkek1GT3I4YlBDQ2xNSzdiUE9P?=
 =?utf-8?B?TVprYXdpeFUzK201TGkzbVFseW4wQjVvRUlVMnhqVnJyMk9SZkQrelhjR0Za?=
 =?utf-8?B?MEFtL1NBckkrQm93NHhpZDcyTnJEbFd1T2xET3oxZTBGYjYrSUo4VnpwUGow?=
 =?utf-8?B?RzhGQm5PN2xaeHVuSU5ZMGFLdXpNemhqQUp5dkFjdHhTTURwSGlCMXEzZXR4?=
 =?utf-8?B?UlFwenBkeG01aS9CbWZLMWNpMG1kazBxL29OZ01YU3FZUklDZmFoMGVLbjVh?=
 =?utf-8?B?em43YmthTjFVSUxPcWFNaE83Z3F4VFVOY2plclkxNmp0VTdvRDJqYS93Vit5?=
 =?utf-8?B?alBkV0FDcG1HdWFmci9VRUpTZ0paTk94UzBFak5XcUp0RWVlcG5UNGhnZjFL?=
 =?utf-8?B?RWVscFc2MzJ0RFgzOTBac1d3S2c2WW5ybG1TQ251YzBGcWlwcDhaZUExUWk0?=
 =?utf-8?B?N2llaWc5cE96SHV1RE93U3FnM21IVVhxVlNqNmI1ZGlTdFl3Z2M4Ti9tckxU?=
 =?utf-8?B?YzY0RExhVmVsSVNibkg2emhZOVpDREFiUlJOcVNvV3h0K0RMeTV4d0dmTjI1?=
 =?utf-8?B?ekNrNiszRzJja2NNRlI5b20vamV6ZEJsSEViMzFRRklCSTdPaUVFeCtoYUt2?=
 =?utf-8?B?THdjaU9jYXh3VkVVRzAvVFBHU0VvOTBoeXNCUkszcm1HZ0lBTDJtSzAvSnBZ?=
 =?utf-8?B?YXowb1ZBdzU1SFJsczE0cnJRYTJySjgvQ0tPRUxEZmhSWjBLUjZDbCtQRlpz?=
 =?utf-8?B?b0RvZHcxY3JqK2ZnZ1ZES2U2NTFPcitFR1pTVHdoeFB2alQvcmlqMVFHdEw4?=
 =?utf-8?B?VkpNVDRsa0xRT25BY1cwcmZwVW4zZ1FIK3hKK04vMmt6dVBHa29RRk9pUk5w?=
 =?utf-8?B?TTd5eDUzL0xVSHpVeHJpSHVJVzQ0OVN5TlFJczc0cC9abVFYclB5d3VoVi9Z?=
 =?utf-8?B?Y0tSTmpZUmFyUmkzclArRkN3cFpVNVJTdUJDcTBuMEV0dzYvN2ZpcHNjckVn?=
 =?utf-8?B?Q1UrWEQvdUtVNS9CSHh5UW9XNEpBQythRnFZMGc5cGl1TU5uT05PMllUMjdx?=
 =?utf-8?B?QVhSM2wyN2U1SGNiNFJVZVRZRkkrVGk2aUVXRmovNTIzWTNCUDZvTlJZVEVV?=
 =?utf-8?B?V1NFUmNKa1lrZWxYM0pBcDhWQmo5M2RjbDJOelhvUVN3UTJHSktnQWtrNSsw?=
 =?utf-8?B?b0doUUE1R3MvSGwxd3dNanJhZDJ1RlNpVWdIY2hEM3RCR1RqWWUyS3BiR0tR?=
 =?utf-8?B?cjhxQzFRV3RSMzlNZStlSTVHYzE5VjNHM2RJZTZxUkJRSzFjMVZwVTFRWHhI?=
 =?utf-8?B?c1YzTC9NOWwvTnVydlh4cG1ybENNcHM5VzBHRVdZZUkxSFk4MEVjU254MTFT?=
 =?utf-8?B?U3ZlYmVUalVZVUJLT1VWQmJkSVF5VkN4d29KY1RPTTZmL3VoY3FhREJHUHRH?=
 =?utf-8?B?a0EvdkhOcHdwUlVTMnBYM292ZkI5NXRQOFhJR2ZITUpzRytoOEVadjNWRUxw?=
 =?utf-8?Q?KTgvvlvmTbX3fDFAM01z8bWST?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147ec962-d967-42c1-6305-08da677ab72c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 22:29:58.4563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1LnvfE4oRcf2MSzVouF20YjhSAD++eWsmg5f0dpM1X0+hrjdHk4bb8QBnsz5VHtc2Eh/pRRdRJWfP/4k7kgA0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7684
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/22 4:06 PM, Andrew Lunn wrote:
>> +/**
>> + * phy_interface_speed() - get the speed of a phy interface
>> + * @interface: phy interface mode defined by &typedef phy_interface_t
>> + * @link_speed: the speed of the link
>> + *
>> + * Some phy interfaces modes adapt to the speed of the underlying link (such as
>> + * by duplicating data or changing the clock rate). Others, however, are fixed
>> + * at a particular rate. Determine the speed of a phy interface mode for a
>> + * particular link speed.
>> + *
>> + * Return: The speed of @interface
>> + */
>> +static int phy_interface_speed(phy_interface_t interface, int link_speed)
>> +{
>> +	switch (interface) {
>> +	case PHY_INTERFACE_MODE_100BASEX:
>> +		return SPEED_100;
>> +
>> +	case PHY_INTERFACE_MODE_TBI:
>> +	case PHY_INTERFACE_MODE_MOCA:
>> +	case PHY_INTERFACE_MODE_RTBI:
>> +	case PHY_INTERFACE_MODE_1000BASEX:
>> +	case PHY_INTERFACE_MODE_1000BASEKX:
>> +	case PHY_INTERFACE_MODE_TRGMII:
>> +		return SPEED_1000;
>> +
>> +	case PHY_INTERFACE_MODE_2500BASEX:
>> +		return SPEED_2500;
>> +
>> +	case PHY_INTERFACE_MODE_5GBASER:
>> +		return SPEED_5000;
>> +
>> +	case PHY_INTERFACE_MODE_XGMII:
>> +	case PHY_INTERFACE_MODE_RXAUI:
>> +	case PHY_INTERFACE_MODE_XAUI:
>> +	case PHY_INTERFACE_MODE_10GBASER:
>> +	case PHY_INTERFACE_MODE_10GKR:
>> +		return SPEED_10000;
>> +
>> +	case PHY_INTERFACE_MODE_25GBASER:
>> +		return SPEED_25000;
>> +
>> +	case PHY_INTERFACE_MODE_XLGMII:
>> +		return SPEED_40000;
>> +
>> +	case PHY_INTERFACE_MODE_USXGMII:
>> +	case PHY_INTERFACE_MODE_RGMII_TXID:
>> +	case PHY_INTERFACE_MODE_RGMII_RXID:
>> +	case PHY_INTERFACE_MODE_RGMII_ID:
>> +	case PHY_INTERFACE_MODE_RGMII:
>> +	case PHY_INTERFACE_MODE_QSGMII:
>> +	case PHY_INTERFACE_MODE_SGMII:
>> +	case PHY_INTERFACE_MODE_GMII:
>> +	case PHY_INTERFACE_MODE_REVRMII:
>> +	case PHY_INTERFACE_MODE_RMII:
>> +	case PHY_INTERFACE_MODE_SMII:
>> +	case PHY_INTERFACE_MODE_REVMII:
>> +	case PHY_INTERFACE_MODE_MII:
>> +	case PHY_INTERFACE_MODE_INTERNAL:
>> +		return link_speed;
>> +
>> +	case PHY_INTERFACE_MODE_NA:
>> +	case PHY_INTERFACE_MODE_MAX:
>> +		break;
>> +	}
>> +
>> +	return SPEED_UNKNOWN;
> 
> This seem error prone when new PHY_INTERFACE_MODES are added. I would
> prefer a WARN_ON_ONCE() in the default: so we get to know about such
> problems.

Actually, this is the reason I did not add a default: clause to the
switch (and instead listed everything out). If a new interface mode is
added, there will be a warning (as I discovered when preparing this
patch). I can still add a warning here if you'd like; the return there
should effectively be dead code.

> I'm also wondering if we need a sanity check here. I've seen quite a
> few boards a Fast Ethernet MAC, but a 1G PHY because they are
> cheap. In such cases, the MAC is supposed to call phy_set_max_speed()
> to indicate it can only do 100Mbs. PHY_INTERFACE_MODE_MII but a
> link_speed of 1G is clearly wrong. Are there other cases where we
> could have a link speed faster than what the interface mode allows?

AFAIK the phy must report SPEED_100 here, since many MACs set their
configuration based on the resolved speed. So if a phy reported
SPEED_1000 then the MAC would be confused.

> Bike shedding a bit, but would it be better to use host_side_speed and
> line_side_speed? When you say link_speed, which link are your
> referring to? Since we are talking about the different sides of the
> PHY doing different speeds, the naming does need to be clear.
When I say "link" I mean the thing that the PMD speaks. That is, one of
the ethtool link mode bits. I am thinking of a topology like


MAC (+PCS) <-- phy interface mode (MII) --> phy <-- link mode --> far-end phy

The way it has been done up to now, the phy interface mode and the link
mode have the same speed. For some MIIs, (such as MII or GMII) this is
actually the case, since the data clock changes depending on the data
speed. For others (SGMII/USXGMII) the data is repeated, but the clock
rate stays the same. In particular, the MAC doesn't care what the actual
link speed is, just what configuration it has to use (so it selects the
right clock etc).

The exception to the above is when you have no phy (such as for
1000BASE-X):

MAC (+PCS) <-- MDI --> PMD <-- link mode --> far-end PMD

All of the phy interface modes which can be used this way are
"non-adaptive." That is, in the above case they have a fixed speed.

That said, I would like to keep the "phy interface mode speed" named
"speed" so I don't have to write up a semantic patch to rename it in all
the drivers.

---

One thing I thought about is that it might be better to set this based
on the phy adaptation as well. Something like

static void phylink_set_speed(struct phylink_link_state *state)
{
	if (state->rate_adaptation == RATE_ADAPT_NONE) {
		state->speed = state->link_speed;
		return;
	}

	switch (state->interface) {
	case PHY_INTERFACE_MODE_REVRMII:
	case PHY_INTERFACE_MODE_RMII:
	case PHY_INTERFACE_MODE_SMII:
	case PHY_INTERFACE_MODE_REVMII:
	case PHY_INTERFACE_MODE_MII:
	case PHY_INTERFACE_MODE_100BASEX:
		state->speed = SPEED_100;
		return;

	case PHY_INTERFACE_MODE_RGMII_TXID:
	case PHY_INTERFACE_MODE_RGMII_RXID:
	case PHY_INTERFACE_MODE_RGMII_ID:
	case PHY_INTERFACE_MODE_RGMII:
	case PHY_INTERFACE_MODE_QSGMII:
	case PHY_INTERFACE_MODE_SGMII:
	case PHY_INTERFACE_MODE_GMII:
	case PHY_INTERFACE_MODE_TBI:
	case PHY_INTERFACE_MODE_MOCA:
	case PHY_INTERFACE_MODE_RTBI:
	case PHY_INTERFACE_MODE_1000BASEX:
	case PHY_INTERFACE_MODE_1000BASEKX:
	case PHY_INTERFACE_MODE_TRGMII:
		state->speed = SPEED_1000;
		return;

	case PHY_INTERFACE_MODE_2500BASEX:
		state->speed = SPEED_2500;
		return;

	case PHY_INTERFACE_MODE_5GBASER:
		state->speed = SPEED_5000;
		return;

	case PHY_INTERFACE_MODE_USXGMII:
	case PHY_INTERFACE_MODE_XGMII:
	case PHY_INTERFACE_MODE_RXAUI:
	case PHY_INTERFACE_MODE_XAUI:
	case PHY_INTERFACE_MODE_10GBASER:
	case PHY_INTERFACE_MODE_10GKR:
		state->speed = SPEED_10000;
		return;

	case PHY_INTERFACE_MODE_25GBASER:
		state->speed = SPEED_25000;
		return;

	case PHY_INTERFACE_MODE_XLGMII:
		state->speed = SPEED_40000;
		return;

	case PHY_INTERFACE_MODE_INTERNAL:
		state->speed = link_speed;
		return;

	case PHY_INTERFACE_MODE_NA:
	case PHY_INTERFACE_MODE_MAX:
		state->speed = SPEED_UNKNOWN;
		return;
	}

	WARN();
}

The reason being that this would allow for rate adaptation for "rate
adapting" phy interface modes such as MII. This would be necessary for
things like RATE_ADAPT_CRS modes like 10PASS-TS which always use 100M
MII, but have a variable link speed.

--Sean
