Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D996283B0
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiKNPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbiKNPTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:19:31 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70055.outbound.protection.outlook.com [40.107.7.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752436462;
        Mon, 14 Nov 2022 07:19:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J78bmI84hSR+FYB7lfA1RW7+Bx3E6op2K2fzekItCA/ZfsWnd7AbaaEV1Vhd9za40ACDRdoMZS+kI8wg7xivKStCbvyjTzYsSt4oYHOke/oyawfnAstIyuXTq++4Q/bv4gsYvjkVx7eLAciH+Kuz/LonBgFxX8+NKR5DjiOwRAQ82mO+Y7lqhYch7LStGKim7xkaVo79W5bs5tj8kQ56S/nAWfbXXEkUkbTxMY05/GnHREJOKfpQxg96ABgbpuxEz9xtRhvv+nSoMTxWgFW8Pcogl76rhRY20zwyGoGg6iSaIAB7uKiy9FNuQ6k2E4EzCwisi8iA04Z+rvEj0a3jXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8O7/1dr53hCg3e6BoEG4BPxoO45XinR6+crkpI6544=;
 b=H6LXp38qV8+CzmYX5Rba5E3sJFX8Sa1LpgI+jtLVsqibk5769UApx9fK9xAihqyRSyh8uE3JmTZvIjR67CL5fEe0uOKwDnXfz1+/ACbkeJU6OiZGBJ+PgL0WW1wulURnBigCv0C6La1W1vMqzs55MHdSRTHhG8hmMcraLL5BCXLFn7g9OtjEwuDHJHVeDlZGzTU5sJz8y2Rk+RWkCq67eDDsNWJp5SYwLMKx9f+ku+48P52o05mMsxVRUjI0PngpYR44z63o8t312EBIinFwSmF6kpcVNkTvB7Gs8Nx6hQAcV69dhA2A0pvmhH0+MauLzOplpsDrJbMWJ0j7Z7Jlwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8O7/1dr53hCg3e6BoEG4BPxoO45XinR6+crkpI6544=;
 b=KHKPr6h1JXU5FK1M9SfhhqYVoG5sUCj4aavNQJvAvEMzC0vrTywb9fEx5c9siZTP+M1eDJjJK3QEfbB5fsGUpq60BRbU+WTjfc4MflgI4ys6SBAEtwH9vhlMdFS9eotVvI7VD+XsBW2YaBqb6AN8WeMU3uvle96fScinRERuwhM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7484.eurprd04.prod.outlook.com (2603:10a6:102:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 15:19:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:19:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 2/2] net: mscc: ocelot: remove unnecessary
 exposure of stats structures
Thread-Topic: [PATCH v1 net-next 2/2] net: mscc: ocelot: remove unnecessary
 exposure of stats structures
Thread-Index: AQHY9g8hhRmuyCZfD0i0QF9ebvchX64+jNeA
Date:   Mon, 14 Nov 2022 15:19:26 +0000
Message-ID: <20221114151925.p35ynwi7ejmr6zhc@skbuf>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
 <20221111204924.1442282-3-colin.foster@in-advantage.com>
In-Reply-To: <20221111204924.1442282-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PR3PR04MB7484:EE_
x-ms-office365-filtering-correlation-id: 232e9bfe-5139-49dd-1c6c-08dac6539e4d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iVE2u8jS2pdWXeJXgut1cB8iReDt41/LWrSUBnVGO4F0tmviXQ9ZSdwnQyHoFt2prtyfj3dvWB/kqdRmIHJbLqy5rIdtfA3uGFFUcBw4IsJ/WOjfBwpw2F1UqrN9RdNESkxIOz+afzKZ2Oi7itvfvLMERLCbyNuWl+hTkDLS+yjam46vOGsR38U8PW/khzqPzqnJut0rDyY28BrqeMr/5BshjeI9lzXMBFCdgA0puWJt/7T3Qy0gRwdBUH0AIRFDCgzogDTno59xQBLReJ4N5bEh1a6ccHdLx18qkFqNAzmBAgCf9FCwtiVxf86xNwaDMkwf2JE2VGzg2IFeP7Oq7Ayv4zWS7UlIiWG+NN2KovvJEEKp6Htjj89N0Y2JuKH3ggE4Xs1mqFnkQiAZHFGmE7ne75X9Jf2e5WZY8H/9qs6xO6OWQ85WYXsCCpiSRf/7C7ifDsdDW/j4sBto1v8uozI/DnLVHt6jduaCTVejAjDBj2oU1cOWk9bRh3Z0ooQup/C1chYmlsM3FOuXkHid2dLpEUqloa3aqgrNF5cc1AbNKCXk66ypRQAUh5ofxxyRn+sw2sR+gtArL9JWZf9gLt2xO+OHgJ54aEnv0HOKZzAMrsqW7VjfApADoddVepkk3y4fA7i1oPuuprzGHAHGw1n75XqZJEvcyNfCeBFLLopzTGNQohkpoLGc54EWS+iSyYEhdXPaPCE/DMxcUsKNV4Giwx+uXhCVvv9/nTPpNV676f9h1g5pwJDVKAQX8eBjJLHOi7QxZM7h7CQWL2q0rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199015)(86362001)(2906002)(122000001)(44832011)(8936002)(38100700002)(38070700005)(83380400001)(186003)(1076003)(91956017)(6916009)(54906003)(316002)(478600001)(6486002)(33716001)(8676002)(5660300002)(66556008)(66476007)(66946007)(41300700001)(76116006)(64756008)(66446008)(4326008)(26005)(9686003)(71200400001)(6512007)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FrkXKy/huT1Ke8XhzVzviXXb6QiXOe57b48pvTP3N6hm/clgxs1BySK9WBCp?=
 =?us-ascii?Q?ZzS7QKHAoHQC4Xe/yR+/ISTk5GXSdm3K5AeMbOX/yKYzGtmFsapacrjvqPU9?=
 =?us-ascii?Q?aZwNIteh3ojAEGIkJs1c5LAzql5arJvp6nwGj2T771q7y8sF+62ub0OrO5Qg?=
 =?us-ascii?Q?xgNYOpqs9kfbMQNiCbfp1zDlO1yVljRNGCrd7zxq4HMWQjsIbl8uduBsFLwe?=
 =?us-ascii?Q?KMqPT95EVAa8A7l9KWbRegTrjOJiQ+pkC8PQloRtw7UORwYE9yTii4S+fgKy?=
 =?us-ascii?Q?ni7V97HNVumxGVv2PUNA951nSvPM31dgwMES6rUXmZTNXKa1OYf0voGFPYUy?=
 =?us-ascii?Q?84PflwameHqqDGVPpikO3qegWe42mB1gASBvEfGcwEWiiss8QvCq6GFCRnZU?=
 =?us-ascii?Q?t6VU26nXcTlqqh5XN6cHpDlZzta1vGcoPxpSbhAZchQwqnW43T6CTKwlRbeo?=
 =?us-ascii?Q?A27zpwWzrpu6eR1E5zFT24eO65a8cwx0jyukmWF9PA7/qGEq7SYAPDBHeg3D?=
 =?us-ascii?Q?rV3PVftfhqyzV0aIxAyO4trPSgRXqiNL0CvxzOCGZJVgODaKaNuHBU2GdtEN?=
 =?us-ascii?Q?pI3sNhlv/CqW0q2scPUQS0adCfal/ijjjUiW3Ttb76H1yhuF8fbTaSq9wtAe?=
 =?us-ascii?Q?ylrpWh6fY4Xeoavk83W9X1Vm1v3p8LOFt1i3BahitcqT4LDRZiyeBrmeuhGf?=
 =?us-ascii?Q?GM6egetyeUkCTrSHis9y17tAH1mJ1syNfk/N3jywsfnqRiQe7m5MSPCTwiWr?=
 =?us-ascii?Q?59Q7JVw7EHWUNke8WqJ1n1BNl2fHQVK0xANHFHngM7GbGwsgu+aWSkqwayH6?=
 =?us-ascii?Q?mA8gPltx4JzNiMBGb+PCpSIWEuNItktC5S00Csg4nWnlSNIzxhLH8Dr5eEoy?=
 =?us-ascii?Q?LMSFsI1a6DaPc2ScJyguCDwPcL9wmliOFZDom9bw14e2r0yFQ/wVoqt4Lrj1?=
 =?us-ascii?Q?9Qb7EcH2oiPuyMNx6uwSgnTK4T9HE4EXamz6QDxu5u+4l6U8BHWaiQ/zalRT?=
 =?us-ascii?Q?x5flgDdIZpGlILQw4bDDoE7Ix5Rf0MSvLE2YLKaOmpVbPFEqM06OfzoljgmD?=
 =?us-ascii?Q?MnPXUeheXTtO6ffX4FqhCJCzNttU+bbOsLtGg3Kz2FOlmvDgq8n9ljXrY3BO?=
 =?us-ascii?Q?lzHGF+mz8OlqgXAecAY1aj55LcXlq7OhGkgg3EPvoVxg/5IDd4tG7moCVMz2?=
 =?us-ascii?Q?wfgaun7FgDY1/zxqtrAdN+q8xvxdxK3iTtaFqTDsACJYQYI6X+s6kZ6ixQKt?=
 =?us-ascii?Q?Sm0mCsQ4Uqc3uw+0yf+WjQS7COpDLGMhDPhAHIamDBDKUhgXnV6AJGYGTVuF?=
 =?us-ascii?Q?5BeuFQPauW/qPXaxmAlinFRJQmQemjIQNs4b7PEMXws25YwIUUp9Bnei+sy+?=
 =?us-ascii?Q?F++X0zqRYhKcR0D49K9wtF+Zws/h+zpIBZBeuyiLrFODq1FPxwMTMkDRTcGO?=
 =?us-ascii?Q?o8cWpGK6lV3cYoFOZ9Zq6LIGc2s4OciIWFe4hQSkap5BZ2GEm87GJpaS3m9A?=
 =?us-ascii?Q?TS3uIBwiw2KDrXro539AB2LNB7vUl9Lq9ytBjlfMc+c3VSUsEr62ikWeb1k+?=
 =?us-ascii?Q?REDU/KdPKrUs1hcT5SvgN9ipVkwJwnZWQwIDnK/KOeEsY1idcgv9OcBNUaGA?=
 =?us-ascii?Q?DQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CDA39FA65497A54D97873D3508BB699F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232e9bfe-5139-49dd-1c6c-08dac6539e4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 15:19:26.6316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihmtn0wo4GgPYS8Z8Om7lBwXtkQhmMZRbRYGpaDao760KgamgCEiRZrOAqONMkTgbcZgftwWdmA11a0Ph/5hUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7484
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 12:49:24PM -0800, Colin Foster wrote:
> +#define OCELOT_COMMON_STATS \
> +	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"), \
> +	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"), \
> +	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"), \
> +	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"), \
> +	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"), \
> +	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"), \
> +	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"), \
> +	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"), \
> +	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"), \
> +	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"), \
> +	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"), \
> +	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"), \
> +	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"), \
> +	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"), \
> +	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"), \
> +	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"), \
> +	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"), \
> +	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"), \
> +	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"), \
> +	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"), \
> +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"), \
> +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"), \
> +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"), \
> +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"), \
> +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"), \
> +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"), \
> +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"), \
> +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"), \
> +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"), \
> +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"), \
> +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"), \
> +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"), \
> +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"), \
> +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"), \
> +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"), \
> +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"), \
> +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"), \
> +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"), \
> +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"), \
> +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"), \
> +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"), \
> +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"), \
> +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"), \
> +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"), \
> +	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"), \
> +	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"), \
> +	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"), \
> +	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"), \
> +	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"), \
> +	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"), \
> +	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"), \
> +	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"), \
> +	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"), \
> +	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"), \
> +	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"), \
> +	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"), \
> +	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"), \
> +	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"), \
> +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"), \
> +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"), \
> +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"), \
> +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"), \
> +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"), \
> +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"), \
> +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"), \
> +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"), \
> +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"), \
> +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"), \
> +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"), \
> +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"), \
> +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"), \
> +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"), \
> +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"), \
> +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"), \
> +	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"), \
> +	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"), \
> +	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"), \
> +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"), \
> +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"), \
> +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"), \
> +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"), \
> +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"), \
> +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"), \
> +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"), \
> +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"), \
> +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"), \
> +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"), \
> +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"), \
> +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"), \
> +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"), \
> +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"), \
> +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"), \
> +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7")

If we're moving these anyway, and stopping providing anything *but*
common stats, we could as well move them to ocelot_stats_layout and
delete the OCELOT_COMMON_STATS macro?=
