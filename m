Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9585E68A792
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 02:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbjBDBe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 20:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjBDBez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 20:34:55 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2065.outbound.protection.outlook.com [40.107.104.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B391F8C1DF;
        Fri,  3 Feb 2023 17:34:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CT5OCE0UVdQ7lvynuywn8xKjp3pwBtmxK5bdLzYpWFabHhEhb+SKz3OGrN5g76m77uFEshAdHtSZ9AcTnth2lym7vCg9v6x+zU/wK6FJQ0VJhVlD8zpqheVp16YDrGiy3ow7BfROdZ+YdagLpqEzrjF3nYRA2oqSwEVUbhpclBUkh5o3wScq7ChkXaQEXtoomIewRIA2qYLggslg4LJFFk9nDuS+Hwbi2ntW8YjdizRYGGjaKD/zwatmsQA5E4NWnOwI5oGdukmFJxYsBZEloQYy0E8g125pyKwyBsUt2dLU36f+wfMhgOumYawI2xtmBfgpdmFApIkFYr0SPYoZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwZzeUbvg2JtKRwzeE8h3BHlz/ASoo1ktXIm9MAqgyY=;
 b=BisaToqV+WaxOzxBiqRvDDuaAca8VzVirGdBOuXoPsWl4oDaGxBt7uU+nx1oZvQcNCKcEm1PilpDE6NxAI0R24LSzXc1clwwe+y6ZkeB9Q0PRGvZt6bz9Wbx32yTrCVqiI/9G583a3QpQUm4l5k9gcSK0E/N4085ubia3opQGGosETisxwPDxEFCD8hmgM7Re34W+4k7g89J8PE45lF4c3H5XxDVL8lQVC6uMbCXv7f9UumIcN5XF4Mm+GEJ2QNOoINbVbtWkPs4VrbXrvIEWeXAlARpdzKmsFOjnkf6gRQ7QiM1r2iI5DZ6e2IQpz5wqiD8P9dgPXJinzElWTDZ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwZzeUbvg2JtKRwzeE8h3BHlz/ASoo1ktXIm9MAqgyY=;
 b=bfSHdPntQHgfVSb4is3hog36IRqUEL52lgL2Rq9gpms0ySA0TaQv8CDeCYC4BnAMBb+fpdlTWkOifG+XE13QRQCdeDOxR/hwBwW3xyTMhxiTqcVerWQnnfLKvi86ct1TFtexv94tp2C6DxYLrknXuuxYSQ6MzJgPyJD62MEaLJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8121.eurprd04.prod.outlook.com (2603:10a6:10:24b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 01:34:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.031; Sat, 4 Feb 2023
 01:34:43 +0000
Date:   Sat, 4 Feb 2023 03:34:39 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next] net: mscc: ocelot: un-export unused regmap
 symbols
Message-ID: <20230204013439.4vfag2kbrwpwvnpr@skbuf>
References: <20230204001211.1764672-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204001211.1764672-1-colin.foster@in-advantage.com>
X-ClientProxiedBy: FR2P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 454e1d72-9a00-41a4-60ca-08db064ffd4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUkRhH02REbwn0I4CxXMjh9SnouXigflw7qPKdcFGmc8quZwkozm4ubdFkZ6dNPfFcpqI8PS56WxMjFYtFTBAlxKzPV91uBPUqjTGVdsXmspqAe6m2JjaBEcU/p4MHeB6r20dP+wxukM+M9yZPD7MWrDiKKA8XSQQOopCMGEqNiQi+uBy0g51dC78SdBrumisBppEHuYK4kUUnyf4dhhNKCqzNxcbSCbL0DDloY3rLONy1Gt4xKFx6QhQyDUlBVrLertT5XHTLi0uZioA+t0rE4Q2gJTAaNd3+tKGg5qHrUMKaiATOmEniPFuc7zcySSwrSTB9Hwjmp9X4HSwyiF1p9Jwp2t6NcRFoxnoFJ5jebWSmTlXNB8rIfIghce//atMpPweFAYHjvp4rWE8druY1wp/jquVvwg8Bs0OBAFu19GOLvdy7rKc3Ti5VoLxuygLmq9drGCUhkqNUG9deM5YuwUSZ4NVjRrApjlonXf+OxhMR78B+f87La45GrlQ/RxS3aojMcnD3QlnViAfk1PWqNnj30rWuaVKCpAYgeJIPDLEeW7Kmjfy+KSX0whLtE/b6uVy4mgemD6mhqj8H7C4xQNwcP3JRi1Y+rFd3hShOVxOxUzjVhNaGABbCud9r5zNftlrFtb2VrpgRHzTDhN/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199018)(33716001)(86362001)(38100700002)(6486002)(316002)(6666004)(2906002)(478600001)(8936002)(5660300002)(44832011)(41300700001)(7416002)(4326008)(6916009)(66556008)(8676002)(66946007)(66476007)(1076003)(9686003)(26005)(6512007)(186003)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kdX4IaQhBoBA9iGexaWisKbkLu6+zRCTwhXYW+wFeIo2hw1IoxL7CNDOj03j?=
 =?us-ascii?Q?MZJP1Dw3/hD7b+olcnM8pPES8CL5xG5rksQZqvvtQ1W2EGMElAGgE4FuiW18?=
 =?us-ascii?Q?oWswxiOSKmhnZgbjUkgK0hstz0HFTGL3rZjtOHz1OEqtYBWd8b7OLbm2lRk4?=
 =?us-ascii?Q?lM5I1o+ZIMgdrqlF7bKsqwv1R0WeRavFbOi3yPqeTGD0Q52i+WOSSNN1aOe4?=
 =?us-ascii?Q?jMcDRVI5WMU0JZ/iB8V49GgKg9c4MzwFozeOVWoKBTche/ZgYqs/BbvUpa1O?=
 =?us-ascii?Q?W1qR4q6PrXy6uM4z2kA+d3K2hPY4aWdLVVoB6HxKqmp5fKI28j5qdqZxZdaY?=
 =?us-ascii?Q?jzVwrZeXS+VI5kJmCskcKH/Jb1SeJaPURxOX1RgeD9ZRQrrfevxtdaRdCq9i?=
 =?us-ascii?Q?eBANTKSkJG7EPNEsIrM7wlv9HLryo5zDih0ulofcHBw7IlFwL8p7f5CNt9je?=
 =?us-ascii?Q?dyheIs9dZt3ojJnXSH0p3p7BR5zHcpYxPTedy7mRM29LeJF1sKHYdNrZgBuH?=
 =?us-ascii?Q?mZut0QiHp2yPk3FaRHK71jjBBjtBB6VHyLzgYgFLRQPxJexPyIBVmjDG+QyS?=
 =?us-ascii?Q?Z4r8roYS6MdyG8l7Kqbf4lEqU9xnq9tkuCdYlgsV2PtgYVamF2p9CrYc26Tl?=
 =?us-ascii?Q?TFIXNwisPDIa8a2Faado82qZw1kVkG12x01Hz7V48ZyYDVRclEe+GjbDqptX?=
 =?us-ascii?Q?kjH96WKEpG4MsEg67yTxBSReC0D6xLunKv4dkX1Afc+3X+Ga3mTgSGV/yw7U?=
 =?us-ascii?Q?Rm18vryLhVwxbE7SlB+9RPgqRDc930mwIAsEahdag6q9JRVmyBJan4ljE5cR?=
 =?us-ascii?Q?52Xinva+k7zMLZmSe5/Ms52KtV7AQtTdiZjNs5BhYfAA5rvNvphftBRotC7l?=
 =?us-ascii?Q?VTw15yyRYNXZWfCMM+dYUHkzENwHV7gEI/46T//fgf6AL1qgOkx2OUvjsuV/?=
 =?us-ascii?Q?Wf3GkoSjBEhFzNX7BvNp/wg1AZnoXb00O5jZk/VgafX7tiVpeg3tqLS3oSl8?=
 =?us-ascii?Q?9BHuBK0MCIwcEZYRF6PB1XuKU4fbCLsgyEJMDUJHwcIddNTO2EssBR2e6rn6?=
 =?us-ascii?Q?1cYjv4XIj2u1gvM3AsCPRfjbYKfxxVgv5j8I520JZPknMsowBpGjITSI8Af3?=
 =?us-ascii?Q?RQE3U9jIffiCSWSIYRgMWz+Gr2phTRrE80NjmqaEZAAnkyuptQr2Ct0f5qB5?=
 =?us-ascii?Q?rHmXDP9flEugUxbS7skNa5q4vY4klGYobkMWXVz2nW/VgAd/muBAp4SzqFkd?=
 =?us-ascii?Q?RuV+3AZHLvvKFzCbTctJnbExVBdam75WL1e2RnK84uz8YP/wluvh60wAdZ1n?=
 =?us-ascii?Q?tLFqtZ2Bh86doDVuh3gmq/0fk9a1qtA0MTbD+SH2W7MDRdrp81L9y3oiM0WJ?=
 =?us-ascii?Q?VkHqEnfHTbcRhrGgpgPEr9DZGe6okrFwZQ5Yu7/7YU9XzgGrNQzLsEUORSe/?=
 =?us-ascii?Q?PnLx01vKzSTMtWgg7KuvGc4iASFHFo+5Xk9+xQASeO9mobSI811xddFkBexw?=
 =?us-ascii?Q?DOFMy6d9EIw0Ccu/v8SH5rUeuqgo80F+9Tkl2qw3yu9bbS5vliEpetA1AtqU?=
 =?us-ascii?Q?rGeqTDBHwR/z1+4IbPNVsqS673Bd3RE9bUThHzQwaaL2Gg8X9lkRi5rMVzWF?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454e1d72-9a00-41a4-60ca-08db064ffd4f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 01:34:42.9765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13u3wfndRuPgv0AjyEja+yJbWBrEk+TCoCCbi/KIwKlrloeYj4wvkDxsFAHNzqqrbIkhIIrHaL9PbWrC9RGD2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 04:12:11PM -0800, Colin Foster wrote:
> There are no external users of the vsc7514_*_regmap[] symbols. They were
> exported in commit 32ecd22ba60b ("net: mscc: ocelot: split register
> definitions to a separate file") with the intention of being used, but the
> actual structure used in commit 2efaca411c96 ("net: mscc: ocelot: expose
> vsc7514_regmap definition") ended up being all that was needed.
> 
> Bury these unnecessary symbols.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

These can be unexported too:

extern const struct vcap_field vsc7514_vcap_es0_keys[];
extern const struct vcap_field vsc7514_vcap_es0_actions[];
extern const struct vcap_field vsc7514_vcap_is1_keys[];
extern const struct vcap_field vsc7514_vcap_is1_actions[];
extern const struct vcap_field vsc7514_vcap_is2_keys[];
extern const struct vcap_field vsc7514_vcap_is2_actions[];

I guess we make exceptions for the 24 hour reposting rule when the patch
has been reviewed?
