Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB6B59896C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344672AbiHRQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbiHRQzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:55:13 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60052.outbound.protection.outlook.com [40.107.6.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6ABB5E68;
        Thu, 18 Aug 2022 09:55:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEtZk4tdjoxfBpxcQbR4PwPTLVHmj0uoiCzjP311iUgH2U0gvMCC1dbNRViXuuNY6/YZbsalDdFLmGhoSLEvkemodxSGLhyjNaSHD18KDxDukhjVVikdFqOXVTs1r963RGe8Nfj3TSebZ9NBVtv3KPL6dE5m+T1HyGPRya3B66UAqW/Xsofs8OFuCibIJ4O0ggDoh671u34WwAlaJbWl8pbkjmvPmD8344PpMiUb9R5NzdeB9TNy30KhE+FegLAjzFMyrKjxvbIBsdmobVqZ+0p622lh3JQV+xFCyk8F4elyUGyUuxpbK/7mvF6WMIelenLjVXO82O+S2iOPA7at6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZyG/vCLXiNer2qia6L2KLFugdEnaX8ljkv79RP1Cseg=;
 b=QKLLOVQ6XvzmIeoHzYhHvQdP15DgttGqTpmOu2mgSBI2MLEdt8FBvxbV+WKE5zCYKvMNPClto6iOnAAJ88CpWcSExAGZvIHc011pwFBbd42BnehmbylXzBFWU+pC3sm+IKr/NuV3aXk65zRJ9cfusB2wBGL/M0EmnumCPAxVvZhbjrK9x1OhwA9NbTY2jzt13z0Tvd9T6vDt01sv51EbRH9XVLu2LoNz+jZNcEBkRcBzZ75ww89xzJ15bbjdiValtoUVa9Hy1RGtX+Gg5hDPamDpCqLfoAv5KVYl9OiSRWVCP+2WUvhJ+UCgDzu0XMslzFlPftpd30EXZKeZm0za0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZyG/vCLXiNer2qia6L2KLFugdEnaX8ljkv79RP1Cseg=;
 b=QV3REYSXaa3R6aTOeyaAJkDyXkfyI59RKxFyNk+i/Npccb+OqoWS1BtLaU7ictO3m25eMFGPxQAMg0NtPF17Qi9/VoldxkEPEI26FyLvX01M8oq0ulTAPEPMZ5DZT3KULo442FjXJmT11Er1Y0SCfxxIPZC4fHxt25fbiG7vizkRHqn1BajMNQ3vFFnJP5Bm/MR9Kqvh8RUVd50Yp5bzWVWSZfW2m0awQWqHRnc4lAEK22t6SoTcdNk98RLCCKGBiCrbAii4N5j+Zt9Z91nppfJDMY+Zk6yaVriQvkt5bUvEBUprnt3DQ4AImovxyDGyiAPJEm1qgjsoez5Nso6CQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7603.eurprd03.prod.outlook.com (2603:10a6:20b:34e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Thu, 18 Aug
 2022 16:55:08 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:55:08 +0000
Subject: Re: [PATCH net-next v4 05/10] net: phylink: Add some helpers for
 working with mac caps
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
 <20220818164616.2064242-6-sean.anderson@seco.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <965bdb53-834b-2e53-f272-b338cebe08be@seco.com>
Date:   Thu, 18 Aug 2022 12:55:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220818164616.2064242-6-sean.anderson@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:91::18) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa2c9d90-02df-4925-46c1-08da813a6837
X-MS-TrafficTypeDiagnostic: AS8PR03MB7603:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FIOqvbkNg65lTWkMlMT40g57Vr3h8EOT1PqghJyoUPdGWWcbK1/9anhblRvkrHQiOUSIkdHpvH+kSTUZH+oyYcFNhn3hbsga5WL7eyoT76ZfqsILg/29YSeMlDSkIjvexdTyXTQxHSdREytGliKTL6a3C58VM9eBP+jq8c7krAtAlz2YLTHEchtwJxcoyGUqLATLDbeQj3koFF0Q48Z3SgCqBHVaI5fhZ3rB3eEtOZnkn2FF6TzEaoTkhuD96LFDg9zDCOR5XPPkRIw4QXi95AW6P9HNUvwsI1+JeYZrEWGDElBRpMKT5GIqwfTqlNK7xqFzQ9gru4JK8S6jWlpjZ1gZU7CL269TBezpofbvthIIB12IzFXOlltFPMv7ZIljc0eQfxs1N1O/4gkNVCmOOzrzxqyKIseHFr5aO8M/O6UtXncg2xAzWZKnE3sHNzHAeFfkAm0hEt0flpEUQ6PyNH8N0Maq4mEXb2WcBx8OnFYozM6Z1QVT77rEC16Unzh24j1+zcXOUEfLFakbet6iwjSR1Uiwtt9bgER5d09srQlG7Arrnzy8h5JieMZwF5LDfJtjVykRhcfsMbmGjvqN1DmB3YaOJ0ylXViS0kG1RTTC/BWesnWKpWwI8AbIU5NH3Q3fsqwsg5VOS7IRa2Z4Iyhw8xcee3q6ey2y+39bZ6WLhpjj28mpxNMQCzktEoJfJWvhgEMDz9EOrtoqy0iG+gWLpJs+/Oqm2WREqspvo4+zQWNq353YOLEaef+71sMBx06g2DS7mt+zTK6MQVu54y2KJ2Rv3GNwBxnPwFCigBUrQPmUyRUUiLycZ2WDKctM5IQo5qVfZpOGKR1vTHOU3pBc2za08rNlpOgqk3/k/lg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(346002)(136003)(396003)(366004)(376002)(83380400001)(41300700001)(966005)(6486002)(6506007)(5660300002)(53546011)(7416002)(52116002)(186003)(478600001)(44832011)(2906002)(6666004)(2616005)(86362001)(6512007)(31696002)(26005)(8936002)(316002)(54906003)(110136005)(31686004)(66476007)(36756003)(66556008)(66946007)(8676002)(38100700002)(4326008)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVBTeXV1RHR4YmdacVR2ODBlK3FObWpLSEV1S1paN2JFVFI2cDdCY3VLS1N4?=
 =?utf-8?B?VDcwZWtrajd6TW9LMXRUMHY4N2ZDdUcvMW9EaWVFZjhXdms1YUJYRmhTSzlF?=
 =?utf-8?B?Q3JwOVdEU2JIOXNWbkZ4RFgrKzVEY25iMXJUUXBGUU9pdFh5c0dzQUVMbW8r?=
 =?utf-8?B?S3Q0SmVQVGF2ZjlENzgwbzk2RzM3dzY3UXhyQyttd0NIZUNURmZuaVRRTlRK?=
 =?utf-8?B?Q1hzaEJ3eGQxS0JRZXFqRXovc0FHQTJPaVVYNkNXbUVIWFNFWmZjVGlaTFZM?=
 =?utf-8?B?eGVZL1NjZEQzK090TWRYcUEyN1FhN2RSRW9VWENIMkRGZjFTanVmaVAvY3o4?=
 =?utf-8?B?T2d3SVArYlhXMGgrKzFlaVJrUTlEVXNOcWF3bkdkQU1jNnhZYXl5cmtlRExM?=
 =?utf-8?B?MWVDODVyaUN1QjZCTXdTelptTXFTOFMzNWRNRk8wVkZoM0NlT2tJVEZKWkxN?=
 =?utf-8?B?eUJMK3VtVkpJRE9PVDdzekN1R1JUaE9ncWNXZWs2UHlTc1p1dDJ1Z1g4NjBF?=
 =?utf-8?B?QzlhaWg4VEowbGV0UENiNk5qb0UvR1Q1a1AzS0NIMy9xa09wdlhrcXNuOFhk?=
 =?utf-8?B?eloyZ3Mram4wa2JNV3krdWowemNxZEYza1FzREJ2QWxsSlRVa3RtWlNZY1pa?=
 =?utf-8?B?MnY4dUk4RlM1R1FjNTJpMHgwWXFObkxxemxkb25McjhFak1Rb0hhSmt0YmRT?=
 =?utf-8?B?Nnd2TEthQXErblg5alVsTDVvMS9ySUYzbTdxNy9FbE9XYXZFeWNJd1k2Uk5U?=
 =?utf-8?B?RFpMVVlHRlFtWWRIeE9Oc3p6Y2VUZUhUbFFTeS81TjEwMGltQis5NFRaa2lO?=
 =?utf-8?B?UC9Xc0xEV1lDNHh1ZHpJS2NicUEzbVY5MkU3S2lkV1FsZkdtLzcveGZ0c21Z?=
 =?utf-8?B?bDFHSzhGY3FVRnlPajhNK1hINzF4MzZLMFpWY1o0dkVrL01BTy9IbnJ1WjVX?=
 =?utf-8?B?bXpFTVBFZXprWXVXbFJuWm1XaHBubGlwNXFvYzBmVkNWOWM3UkRzdGFqOXp5?=
 =?utf-8?B?Y3Y2QU4rb08xdkl6UlZmY1ozR1V0ckNBZDhMM1BQL2dZSlpubW8yQVBhYVF0?=
 =?utf-8?B?Ung4NlJybXkrR0htRURCRjNYRkQwa0xPbUdpVmlidnBPVzFsRnI4WEVOaG1S?=
 =?utf-8?B?a3hXNWZjb2YwZHArbmcyYklUeFh5MEg4MGk5VWZMVVBLOFQwVmU5Zy9hdU5L?=
 =?utf-8?B?cGYvcVo2a1ROQ0VlL3F1YWJoM2paOHp3Z29BZ1EzMXd3Zk10cmVNdXdIa3lx?=
 =?utf-8?B?TjdsQ0RaQTRuUit0YW1HMi9oVENNd0JzUzQvaVZwNUFwQkZNS2tXeGpMWjhV?=
 =?utf-8?B?N0VqN2ViOEt2eXdSMUkzK1BDL3piRmRNOEtkb0JPa2tlTy9QaGVDY2J1MjRD?=
 =?utf-8?B?S3NHQndRSUhESHdPajhubG9HaUNEVFZGWnVrUktrWDVTeUc2b2NjK0wzaXJt?=
 =?utf-8?B?MGd3OTdCaHVyZEMxaG50VFhDWDNsYXlaMjczTlVvVGl2dXNkbUZScGNwc3BW?=
 =?utf-8?B?eXVxVTE5Nm9KKzI4aFdiN0RUVDI3Tm83V210RTUvSE9UdHJEZlAwUFU5bXI2?=
 =?utf-8?B?ZTdlQlhjVDFHWkhpdW1iTkg1a3ZEVURXYjN6aTkwZVphN1dEbzREcDNSOUFS?=
 =?utf-8?B?QjdYL3hQeG9oaElXSFhJUFd6aW5HNndNdW9mLzFaUFdMcjNnSjF5c2VyVEVz?=
 =?utf-8?B?NUZqOWx2bnhvMFpKd3JRdnRHNzlUZnl1OUF5Vk9HaDQ5ODVBRmY3ZGNjKzI1?=
 =?utf-8?B?SkVjc25NTWpVS2tUYlNZdStXTFdLRzRXYlRycnNtbCtjQm5YenBoWXBvcUtP?=
 =?utf-8?B?UUxIc1FtbUhLbUVJdGVJV2dxTVNPUmQyelhQWlhDWGxVbEtnY0FxcVJ4cUt0?=
 =?utf-8?B?SEI3ODNDOG8zcGcxa3Flc1h2Y2xLVG15T2xNenFnbWFyelUvNFJVYXhwZWQv?=
 =?utf-8?B?Z3FHOE91SVU5TDYzZzNpTE5OeDNBR3RGVmN3Q2gvNVZvc0FPTlVGL01qdTY5?=
 =?utf-8?B?L2o1dVgxZjIyaExmbTVyS2xoYytpWFAwZ0dGZ0l1WGpiaHQ1NDFYeXo0V3RF?=
 =?utf-8?B?MnpHT3BqYXppQVBYdDRLbEZKbDdGN204T0luSTZFTWVBdFBuSmlIWU84UlBQ?=
 =?utf-8?B?cVZjelQxUTBINFFxSmk4MmlaeXZBc3FUMVpsdEQ5ZldtZXBLTjExdjQ2Uy83?=
 =?utf-8?B?R1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2c9d90-02df-4925-46c1-08da813a6837
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:55:08.4604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5N+O6UFSewt48EFjqkd4pgsBXeBXBaj5sn67ahRGX/g7lh4ZkQftLatKlaL0gGSVc9GQyEZ3FRPquK2yp6ewQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7603
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/22 12:46 PM, Sean Anderson wrote:
> This adds a table for converting between speed/duplex and mac
> capabilities. It also adds a helper for getting the max speed/duplex
> from some caps. It is intended to be used by Russell King's DSA phylink
> series. The table will be used directly later in this series.
> 
> Co-developed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> [ adapted to live in phylink.c ]
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This is adapted from [1].
> 
> [1] https://lore.kernel.org/netdev/E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk/
> 
> Changes in v4:
> - Wrap docstring to 80 columns
> 
> Changes in v3:
> - New
> 
>  drivers/net/phy/phylink.c | 57 +++++++++++++++++++++++++++++++++++++++
>  include/linux/phylink.h   |  2 ++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 68a58ab6a8ed..8a9da7449c73 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -304,6 +304,63 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
>  }
>  EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
>  
> +static struct {
> +	unsigned long mask;
> +	int speed;
> +	unsigned int duplex;
> +} phylink_caps_params[] = {
> +	{ MAC_400000FD, SPEED_400000, DUPLEX_FULL },
> +	{ MAC_200000FD, SPEED_200000, DUPLEX_FULL },
> +	{ MAC_100000FD, SPEED_100000, DUPLEX_FULL },
> +	{ MAC_56000FD,  SPEED_56000,  DUPLEX_FULL },
> +	{ MAC_50000FD,  SPEED_50000,  DUPLEX_FULL },
> +	{ MAC_40000FD,  SPEED_40000,  DUPLEX_FULL },
> +	{ MAC_25000FD,  SPEED_25000,  DUPLEX_FULL },
> +	{ MAC_20000FD,  SPEED_20000,  DUPLEX_FULL },
> +	{ MAC_10000FD,  SPEED_10000,  DUPLEX_FULL },
> +	{ MAC_5000FD,   SPEED_5000,   DUPLEX_FULL },
> +	{ MAC_2500FD,   SPEED_2500,   DUPLEX_FULL },
> +	{ MAC_1000FD,   SPEED_1000,   DUPLEX_FULL },
> +	{ MAC_1000HD,   SPEED_1000,   DUPLEX_HALF },
> +	{ MAC_100FD,    SPEED_100,    DUPLEX_FULL },
> +	{ MAC_100HD,    SPEED_100,    DUPLEX_HALF },
> +	{ MAC_10FD,     SPEED_10,     DUPLEX_FULL },
> +	{ MAC_10HD,     SPEED_10,     DUPLEX_HALF },
> +};
> +
> +/**
> + * phylink_caps_find_max_speed() - Find the max speed/duplex of mac capabilities
> + * @caps: A mask of mac capabilities
> + * @speed: Variable to store the maximum speed
> + * @duplex: Variable to store the maximum duplex
> + *
> + * Find the maximum speed (and associated duplex) supported by a mask of mac
> + * capabilities. @speed and @duplex are always set, even if no matching mac
> + * capability was found.
> + *
> + * Return: 0 on success, or %-EINVAL if the maximum speed/duplex could not be
> + *         determined.
> + */
> +int phylink_caps_find_max_speed(unsigned long caps, int *speed,
> +				unsigned int *duplex)
> +{
> +	int i;
> +
> +	*speed = SPEED_UNKNOWN;
> +	*duplex = DUPLEX_UNKNOWN;
> +
> +	for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
> +		if (caps & phylink_caps_params[i].mask) {
> +			*speed = phylink_caps_params[i].speed;
> +			*duplex = phylink_caps_params[i].duplex;
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(phylink_caps_find_max_speed);
> +
>  /**
>   * phylink_get_capabilities() - get capabilities for a given MAC
>   * @interface: phy interface mode defined by &typedef phy_interface_t
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 661d1d4fdbec..a5a236cfacb6 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -535,6 +535,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
>  #endif
>  
>  void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
> +int phylink_caps_find_max_speed(unsigned long caps, int *speed,
> +				unsigned int *duplex);
>  unsigned long phylink_get_capabilities(phy_interface_t interface,
>  				       unsigned long mac_capabilities);
>  void phylink_generic_validate(struct phylink_config *config,
> 

...and it looks like I removed the wrong helper function

(that is, phylink_cap_from_speed_duplex was removed instead of
 phylink_caps_find_max_speed)

Will be fixed in v5

--Sean
