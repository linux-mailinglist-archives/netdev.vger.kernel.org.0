Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5204D6B161B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 00:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCHXFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 18:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCHXEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 18:04:37 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01FBD4607;
        Wed,  8 Mar 2023 15:04:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecrLBOV1DbAOyeLEm5bUTImg5Juz07Dfuex+gGPoAl4puG8ehnWFuae3hcd0ueE9hdGGxX6WFnr9t07ThcKpvrtyPFpyxu8enbFBDDxExAq0ujwEQYokXq1dohkQ0j5z2ziDUOilieXVPDW85MJEgALQBcWlA/+3+d/fqXDcSIJLHX7BKOBGLqQBlNE5GhEhbzPbZOjICrJo0wqFW+Tui/IkmmG4Gq6Q65yQk/PBNvoNlCHXimJ8bcET64zQiXuJXe94BmjqcMmetsJjsISKKqrmKfP7xjB11Cdb1855qbC2inaie6+kf34chuFakQ/jL06jKARf/32k/PBHrtv4/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3XYVHWXpBZxYeOC8I2IP1AmFgW1RKgDGv1y9ioZYW8=;
 b=S7sPMkgErxdf653TCCtb6mIfvOumRTuPBwbS5GWCveiDNMDvUq8dls+wAhKNdm0HzysUkJ1Ly8hb1nGioIJN1aIc71f7XhbBhiGN8+8fhiey14Q4I47jxqg4rP8Dx/Xds9tLMiMPhOBsuFWLT8CJksToCScdl+tm9h0aNKjggAy6h1xbnd1BjF8eTlGZHPJYnVUSPIxOkfVFcFLlIihIpWK0Bj0jqMlSMqDVqnJ/bv7L9Dq4f6zC2+3I1Sz2r4eASLv2JZD/cMNN5YlAXZbUxpOZNhApaR/5v/raEgX2DpKjPgESNzMp0QxjZU6Z9KdI1JJ3RrYuCkOEHqHuOTllmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3XYVHWXpBZxYeOC8I2IP1AmFgW1RKgDGv1y9ioZYW8=;
 b=L29OjOxyxRE4f9vDWkt+oYT7LBCZ6xELkBfAlh9x1BjVPIx/+9Qwni1WGZsIC5mHMUDcsoZzJQL4VSwCIycsvn12iLItnu4IL+fQYCT5/cZyegIHdP89pA0tiVlHwepgDZC9o3MELeZEgUvd/nKBCSgAh7PzZCWOINscHsEaErM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB6783.eurprd04.prod.outlook.com (2603:10a6:803:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 23:03:26 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 23:03:26 +0000
Date:   Thu, 9 Mar 2023 01:03:21 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230308230321.liw3v255okrhxg6s@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
X-ClientProxiedBy: BE1P281CA0102.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::15) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: 01c2af35-6109-41a4-404d-08db20295323
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VcA+VPibUrnxSeUW7OxcyQVHL45dtPlxOxR6fjbj4HtOznxDZwem2hyjCoU4mNHFehxit+mHCS5MYkEIdS9CY530BQW6qaKXNFUYK3cV+RxWvQsqlMnhm3bosYrnMSkPNovbET/P9SN6rvJtHuGXbMlG1MBWuXSUDbSRghAi8AcijZwyoaVzXxc7zdCfEvLIXJ1VXLZJxnDBQuCDzdSjG+s0FOuzvXkTEhXgr8AvkGcdJTwfG9aM3je0HJ/iUIDnM4USI2ozvy8kPzBNbrFfzg/0b/J1sYeWZLIu8V6VqpPoPG1OsKGxi/CUsGpm7NoXVzoFCm5DA6WxhmdyN/WsPivPBZ+w3OPz+r6CHDEgHD5U7Ay2o4jra+jsoiLEVnZk1Ky0vREi1EwggDdrwAda5PpA4jO4OqrcDqjBALrUa8/kDxphWPmqcGM++C6/31EyBEDV5gUmEbpKEzSgGHB+XEseK+247kKpRKaJLTaPJDvnxxLe6C0i/LtznCyzn8vnEPzQHvGywXId0HSTSF+SAebhvB0ZBncnW18g1gGQhn4qy6LoT4ZnSa/WAafxZCXak2iEmBR4NY2VAa1L+BLpWWXx5ZHz4EmBJXh25dtwNN/j5lfdfoXoKzr0C1/eI/AUmi86kGRB+Zz5qqFXOoUz5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199018)(83380400001)(66574015)(6506007)(1076003)(26005)(41300700001)(186003)(478600001)(6486002)(6666004)(6512007)(6916009)(66476007)(66556008)(86362001)(8676002)(4326008)(8936002)(2906002)(66946007)(7406005)(7416002)(9686003)(5660300002)(44832011)(38100700002)(316002)(54906003)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?I3i57d201tTOHT0YPU1kVqchozqhvNyTTTPbdDiw7uqUkMVa+TZek5wwfq?=
 =?iso-8859-1?Q?EE+h+4UKkVXeSNM/4zuV3Ou7RCLL1GNM30+qBmZ8W+eZ3Lm8LP26YP9zen?=
 =?iso-8859-1?Q?haV4qk1RezRxnrQJGkh6Ru4VN4L7cG2kz5damZeYLNpUwFnGuafVHr7gF7?=
 =?iso-8859-1?Q?Y37HMfG+zKt//VIUJ5dj5J8QG4/UcDrZ9wUmg7YEAS1tUtrMHKuYWdk8Pb?=
 =?iso-8859-1?Q?H3zXTFPjrIXcBrXQLYUr0KjMHbs7mZlx1lgfoQkR+wNOw+L0IrcLC5xSVJ?=
 =?iso-8859-1?Q?XCgcY3WRHo+Av4seRG6AsWnjmh3MIIvghmqMT8SotafFguNUo0URC4sG0A?=
 =?iso-8859-1?Q?scPefOUaMJ9DaR9D+UMtt14LHNnkNAIsIqpNHYFFbANb0iJebsgAoVWYyl?=
 =?iso-8859-1?Q?5tV1FKXrJ4VbGRyb465gv2U9jizb5Y8h1ct8JaMrOFPLAdfYT1s/7x1c36?=
 =?iso-8859-1?Q?ebOK71X4kDaFKKg7Or+fVudZC6BY8xQ/OJMrmth2cR48YH0TvNemXUA6Cn?=
 =?iso-8859-1?Q?I7Nex4gM/rcdF3KqZxGKT2iwDw6za3FkbfOfM0pYRHQC0WZ+nzn9zTrgKH?=
 =?iso-8859-1?Q?BjXaUkiBJ47n3v5GBk1m0ghIEq1loBPhD1HC58rP4vBQV1qgwJ3UgxKrO7?=
 =?iso-8859-1?Q?rsODmiE6xwjODTvEFGZohcw6paiLVeOhbRhowYj5NVyKYvXe2xCQMzfapX?=
 =?iso-8859-1?Q?czCiWiPZm2QIVWP03XpO4nGOJA8Q/9WxZjZze1hAB1GNeHz+TxOlAPbzH9?=
 =?iso-8859-1?Q?PWGCiP7comG6yqcMHgu+MrQP7aIeUP8zDwfwC96+mv8mwf6Js8ADB2+vWT?=
 =?iso-8859-1?Q?zC5C1LUayYiOmqTU4a6Z6EQjR/IoEht19Z06gOkhe4uTHXsIAuyk8jRtBh?=
 =?iso-8859-1?Q?HfBcp5cMU1UNBgso6JAYWHIxLy/+C3VdOKicgjlBTjNEhTvPFDW6woMy6p?=
 =?iso-8859-1?Q?eV/QSkoCXIrjxH3xBzVcw84H60zn14j4xALbt1aduPm+rZcp6ZwaVk6RO6?=
 =?iso-8859-1?Q?8A6TdN/m9wosptmEOozGJlbpl+EeZyerh6kBnWzW4Ux4omnVwO0isgEV6K?=
 =?iso-8859-1?Q?ZDeCY4S55aYojX30mymiODpiQXTO1iOmp1FP3zXjB5algyly6HmbL0ghJt?=
 =?iso-8859-1?Q?69U6Bif/NnOx9cVdcqXE4J/11wE9Jznq+Qwzo6HNWCKk1TNrw53C3/KyYL?=
 =?iso-8859-1?Q?P6ndbRgGuDfd5OLT2HEqDe+BBSOaz3vpr0MA/ZYLwn1IKjV3GsQgd/3Ump?=
 =?iso-8859-1?Q?Pp8Y4CM0x/fdnJYRANv8Flt/dha1ceXUqlvtUUtPFfzo+gBkq1nTnTs0iz?=
 =?iso-8859-1?Q?eVo94iMv/D3TASgd9jquge1OAH9UoTVex1RUuQV1xfW3r+XbgEBzSHbbch?=
 =?iso-8859-1?Q?c4sbek72MFz6ekpWnGQ4peOrC3GKzn5lQarvaQaHapvtdf3a43NXhX/yzf?=
 =?iso-8859-1?Q?6nxirezSzZa11+KOgqNOUwKE3JMvOwXKdW5Ym3KVFHFHyeL2VofUA4DQu6?=
 =?iso-8859-1?Q?0D+ndgI9oMCpTyk/Ch9KNda/p4Rir6UYJsv18mCtKnvH5TSwLtw0Jj/q4w?=
 =?iso-8859-1?Q?6tltQl6ih19NhSK/raR4oW7UctLbazUk9ZOtulcHjIJzAUMGg1P+UFaW8n?=
 =?iso-8859-1?Q?MXa87tKsSq64ElRCuLBpCQEmF42SVst3yAjqnREa+g7C8lzozCXRXiOw?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c2af35-6109-41a4-404d-08db20295323
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 23:03:26.5967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxQyCSHtvNDmnJnn0xaRCPIXmReLzKhjuW9NVS8cqMEkRLXR5mW4yZA2yhbF8CkEKd4Z5njp9qal5lSzLEvM7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6783
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(trimmed CC list of bouncing email addresses)

On Wed, Mar 08, 2023 at 02:59:27PM +0100, Köry Maincent wrote:
> +void of_set_timestamp(struct net_device *netdev, struct phy_device *phydev)
> +{
> +	struct device_node *node = phydev->mdio.dev.of_node;
> +	const struct ethtool_ops *ops = netdev->ethtool_ops;
> +	const char *s;
> +	enum timestamping_layer ts_layer = 0;
> +
> +	if (phy_has_hwtstamp(phydev))
> +		ts_layer = PHY_TIMESTAMPING;
> +	else if (ops->get_ts_info)
> +		ts_layer = MAC_TIMESTAMPING;
> +
> +	if (of_property_read_string(node, "preferred-timestamp", &s))
> +		goto out;
> +
> +	if (!s)
> +		goto out;
> +
> +	if (phy_has_hwtstamp(phydev) && !strcmp(s, "phy"))
> +		ts_layer = PHY_TIMESTAMPING;
> +
> +	if (ops->get_ts_info && !strcmp(s, "mac"))
> +		ts_layer = MAC_TIMESTAMPING;
> +
> +out:
> +	netdev->selected_timestamping_layer = ts_layer;
> +}

From previous discussions, I believe that a device tree property was
added in order to prevent perceived performance regressions when
timestamping support is added to a PHY driver, correct?

I have a dumb question: if updating the device trees is needed in order
to prevent these behavior changes, then how is the regression problem
addressed for those device trees which don't contain this new property
(all device trees)?
