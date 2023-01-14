Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B6E66AEC2
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 00:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjANXW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 18:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjANXWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 18:22:24 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2074.outbound.protection.outlook.com [40.107.6.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD72E9EC9;
        Sat, 14 Jan 2023 15:22:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbqbZP8Xr1D86RWZv2YZBmKkZZ6U5YwUsBdHd5tDZRLGXvu69FwvGKfhvq8MJ1Z/D08HysmseS3x7FwkVSc26OrIJ5Y1yUx10yq6eIqs0plZL4NfcxrRaTiXCzHhokklHbScrH3SuMTtyJ6+04l6NOzh0XTp5uHCPi2ZMJqOyXX+7GvFZL+Ai6xDLdjKoVbD4NvAWyVsJ4YeV2UiZd256LxWjxyyM0eMN9zNPWCSA0YkcQWCe3SE8tYaHVNzC1bg7nD/34jF+d1o9F7OGnNombX0x3d9Ilh+j6tyR7/hoI/WSlOP1tnkSPrFEZVX/Oy2RTaE5g0A1xy/a4G6hl1ZQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlH7vbGQYL42yRhYv6m0DxQijC/tiHD2xZBFLNDCcn8=;
 b=GC2W61fJQPTjZN3gL9kPcnkXu/ML0Ytf8d6Vgm6xKmGwz1tSkQ8UDATSxwSk4SajNiL/BA0PysN22+WMoQawjzCbftNsMmPYhULVx9OXxBGxOR/4r9j+s2AIbncouvBaNf7NfiVEP3nWEsIMEoM0C8crz/bI6cvMdlcaTsaKqARIortOs4vBfEmPb5LtkSC9GqQ77u0/kHy+KQZEoqipMy3aEw67KQKD412sBko5tJt1P0PSwEgJKLUrvOCHjIXZ3LXw0VNgK0nRNTf2zDsbWyhjXsFJxqH4l10lkdKZH7tcTVRdGcDUxFn4n2ENUPahpFDJBKaglLI6MWhx40XOxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlH7vbGQYL42yRhYv6m0DxQijC/tiHD2xZBFLNDCcn8=;
 b=FUGrBVqIFckQnZP5myc6gfDBUnWJ1FXl4WRl4qsFnL1n8xocOoWHyjpf1RWOLVXthu59FIHsuWKPKwhHLGKjZdbdZZ6hic9j71PKJc5FKlnGADA2sBWvq2MbB8oCkRQ6Y2gFc7QzasAZBCs0yKreTmGBYxYh0Is+rpAw2iM8/SM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7147.eurprd04.prod.outlook.com (2603:10a6:10:126::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Sat, 14 Jan
 2023 23:22:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Sat, 14 Jan 2023
 23:22:20 +0000
Date:   Sun, 15 Jan 2023 01:22:14 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 04/12] net: ethtool: netlink: retrieve stats
 from multiple sources (eMAC, pMAC)
Message-ID: <20230114232214.tj6bsfhmhfg3zjxw@skbuf>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
 <20230111161706.1465242-5-vladimir.oltean@nxp.com>
 <20230113204336.401a2062@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113204336.401a2062@kernel.org>
X-ClientProxiedBy: FR3P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7147:EE_
X-MS-Office365-Filtering-Correlation-Id: 0141a9ff-56fc-4cc9-da89-08daf6862e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lb1E2VyGvv4fC90lufArG5XJGBUG8LXth7c8kCdVX6p0CAv6a3lrYdQC/lFz26B8RGSOPTnrqwes8JODGQ6RTXYEr2fv52SE7WniR8NBPrVZdppAG07RKYSrgs9aGWvjzmQdol3fvDqODNaQkXh7BVmGEvPW9fp9YMu9dlhWp5HNzdp8mwbZgFQvMu906vALRL6+2OSKzPImor0bWjNUU/dR8IEKtVaTt3crGof8edUPgF28IpBy+nWGwveto0k8MCXE11jaWfq6DSOkvpuE95ORR9eoNz07nUFzDagWh6rjZyDcM4sykSHQB3VfVT4+AmAPeAA254BwmG7vAYiuAA4CplazCEkwJRtfMOatVLuBilfxObB1trNPM4OrySneJZma2GYnqAr8G+wMvHk6KzljLhG0GIqMEZO8kMujPe+8DWoBKUvgpZ58ixwi5ay5BWyTGxULR+GFlU16JY+aSoMceYq4tObyTjTSDmXonsnB2cifrvKme2tGuTDuxRdatYoya8BlhUEUGgCZ/pAt1kMo8qRvo6j0kV0PJIs1+BjtXO3XVquB5zSz4Ijgb5HA7NF+nyaMY50Z1SINKceyTAHNWELwyXrQNQPloZvnnMSOZrl2PjiowXZRTCbRdOCX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(38100700002)(86362001)(8936002)(44832011)(7416002)(41300700001)(5660300002)(316002)(6916009)(4326008)(66946007)(66556008)(66476007)(8676002)(33716001)(2906002)(1076003)(54906003)(478600001)(9686003)(6506007)(26005)(6512007)(6666004)(186003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6x1qDvXOTBFgrU9do9hkTSe17q5J1tRS/HiYM4F5Tdj1FxR6/0TJh+FcGAc?=
 =?us-ascii?Q?yMUALahtHpXjLCQdE2DJNX/mHVUwoJs6/Af0G5ESUUcmaRQlJtfGE2yt9F1m?=
 =?us-ascii?Q?/cVeM1wD5xobvH/8ONfka1JeQXdOMYPFIN7viVG1wtP8J5xkmcJIWbP6o9pO?=
 =?us-ascii?Q?eOGDIrFL8MCGDhob8jSbRmxsUYfFDcsu/mMJp6Rfmpv/bpo4LgVapm0v5XYo?=
 =?us-ascii?Q?enVcChEk8pYZjFxOt5B3vzEdL+lFtyZGPg2L06hri0DoCaeW1IBEreU7dY5k?=
 =?us-ascii?Q?UTQ3B4aUCtTCONCW4hKkR9xURjzVjgMOcYuzjyVjMlJgL/wIHmD03M9qm8iJ?=
 =?us-ascii?Q?I6QdgGAAm98H2RHg+9Vfj6sJ2z0F3bHNfTkHHDJUs30l+1Uj3JWFyCyUFip5?=
 =?us-ascii?Q?sFavXfgE2KD+C37QTUy4xgdf4yGu7bofvRbb7PzoQq5+WpX+KJ1CXjuwu0k1?=
 =?us-ascii?Q?mrHP0oocou1FGDJeu7AXx41A/zlPWyp8MeIWkwfyZC0qoNgwmWPQx6YilrUm?=
 =?us-ascii?Q?xE0rZJ0e/bI/LG+8IHwoJQtf+n5soSNqz9WvGkWkFsK0sQOxZgusrLRyBtI2?=
 =?us-ascii?Q?eeD8olb1yRcp6N97fzyLgcK9kSecstIzgcK1KELGk8BjIM2Uk1jwirEetkfE?=
 =?us-ascii?Q?7O75f7qygAUMKQyKyfiWsNTdq1lkhRQ5btKoO+0tfuy2m8H+DrGG5x3cUGyb?=
 =?us-ascii?Q?6jGSvFbKvSUrz/WhRlW6Fb6EU3u8fjs9MtLL+jkElurlJAFm1YISHwkbOjdp?=
 =?us-ascii?Q?VGR4DXFyra/gHuteyx4XiZhHXALUxbbkpsxf5urFX63u1v6YIRS9TB1nD7Ja?=
 =?us-ascii?Q?bGWvvmiChUGKwweybk7uXFmTKgZ0wu4s7q/cFn3JXw095Xgz9QxWunsid7ES?=
 =?us-ascii?Q?dhfrrfzDaAtiJHfSv1EGXUmesYVX1BKj1cI3Q0KiknKGf8lti7bS+7H62YeL?=
 =?us-ascii?Q?1uztg/5qTnyt3KkqMp7/A5DhCEey6k796ZIzK0TkLGYPynqj7aze2ftAsSdp?=
 =?us-ascii?Q?vBdqD23oyulxGPWkkv6l1C3vjPWC+3b08nbRdSQ275tPe68EccZlnwaMm+Iu?=
 =?us-ascii?Q?oHH7bTqg6zju9+l8vniOO7wTaEBhKNGmP+ciXrVBQw/ipKVy3SSXSUnllWiW?=
 =?us-ascii?Q?w4275i7gOqdMh3nLm25A0rhAmOq/UpqTPWOtt/JVZP9erhXqotbXzcItA2xj?=
 =?us-ascii?Q?ExE7wDsSm1x38vYg8HHt0b2rpC6bWyI6NMr0fNT9W8d6TxPI5+j/JHrcqEi/?=
 =?us-ascii?Q?5dmJm420wHTHrlj5GFuBBgaNk8lqliCOZe7FP7RB14CHKGVRT0fVrKy4PXez?=
 =?us-ascii?Q?k336KMJS7Ug5EVjooe8CCSROqzqV4oLWrEXamcmeQWu/wZQ9t6Esj6vNthwi?=
 =?us-ascii?Q?JVjQqwcG6cab2z6MJWqS1YoM45hP7ZTa5LLMf01qD0Nm8088Uqq8guJOR0JX?=
 =?us-ascii?Q?kUn6okM3waBpRmrqb4FHVuHYpgjJAaz04qITy9Hcg9F4+jtJPtCntAbGlqbt?=
 =?us-ascii?Q?5uFcH/h6Uf7kGOktDmcLNt2j3Lj7oK2reryGvoO0D6mA81G3iHVg7Io7OW4t?=
 =?us-ascii?Q?7XGklzvY9lZteRexpS4sKx55KfPV9Pe5t7L8N9ey5b4aWoKUixRWxEVzUkcd?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0141a9ff-56fc-4cc9-da89-08daf6862e3d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2023 23:22:19.7108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+GZ+5JQzROqFESUddTrvarurIKnMs800863dnxG6/+d95KcAKXEziIdBUKL6EdTmg0Lbr8/uST8oLlBFvvqog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7147
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 08:43:36PM -0800, Jakub Kicinski wrote:
> On Wed, 11 Jan 2023 18:16:58 +0200 Vladimir Oltean wrote:
> > +/**
> > + * enum ethtool_stats_src - source of ethtool statistics
> > + * @ETHTOOL_STATS_SRC_AGGREGATE:
> > + *	if device supports a MAC merge layer, this retrieves the aggregate
> > + *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
> > + *	statistics of the single (express) MAC.
> > + * @ETHTOOL_STATS_SRC_EMAC:
> > + *	if device supports a MM layer, this retrieves the eMAC statistics.
> > + *	Otherwise, it retrieves the statistics of the single (express) MAC.
> > + * @ETHTOOL_STATS_SRC_PMAC:
> > + *	if device supports a MM layer, this retrieves the pMAC statistics.
> > + */
> > +enum ethtool_stats_src {
> > +	ETHTOOL_STATS_SRC_AGGREGATE,
> > +	ETHTOOL_STATS_SRC_EMAC,
> > +	ETHTOOL_STATS_SRC_PMAC,
> > +};
> 
> Should we somehow call it "MAC stats"?
> 
> Right now its named like a generic attribute, but it's not part of 
> the header nest (ETHTOOL_A_HEADER_*).
> 
> I'm not sure myself which way is better, but feels like either it
> should be generic, in the header nest, and parsed by the common code;
> or named more specifically and stay in the per-cmd attrs.

Considering that I currently have separate netlink attributes for
ETHTOOL_MSG_STATS_GET (ETHTOOL_A_STATS_SRC) and for
ETHTOOL_MSG_PAUSE_GET (ETHTOOL_A_PAUSE_STATS_SRC), I'm going to add just
a single attribute right under ETHTOOL_A_HEADER_FLAGS for v3 and go from
there. Is it ok if I keep naming it ETHTOOL_A_STATS_SRC, or would you
prefer something else?
