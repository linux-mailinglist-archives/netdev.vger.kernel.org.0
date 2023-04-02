Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082B16D3801
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 15:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjDBNCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 09:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBNCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 09:02:09 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39C810A89
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 06:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9dM4xPyhrPx28368mVOJDDlv1gHJ/wnAHtQXpOjn1NiQso3iMGbxB+lv0a280MkMj6AQ7Yk1o7fRNYPwi7cFEgoqG07d+olzyJM/6tvSiUqI9HiugZOw1ds3HOGBSTQqPrj1Qf3s1zAH2nSRiX/+a6m/IyYBhZiR0pBjY96ypzYAnDnvf95hyTS6SBl7DDzx8LD76TUBRfyk4kKbEKA4ItR+cGH6ElVWlddZHXaZwdBd1kyw0V2dyoQ5Qq8Lh8ryi4A8XqigjVx8jq5zIFLJdgWtC88y8KleDMVe3WmGzgbXC/v6fcDZfNL+7JoZXddluzZH072ulfzKm+ljRDeIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sgzE68GSwKiwRpiz4WOeKQMcuHMbi+iFec+6hJQJXM=;
 b=TByVsj+TH+uevtUzSOTEXsUISWaIMF3bHzdscsGX9FIQr7Bkw9bUlSUfFQTNCAKQdV6awVXC7c/P+WinnxbhOgwv1YlAN6syr5Ssd8RFerQoZLpl2wr2ttqs4QfYyF6oZhVFodqpSPT8vIwPfAOhZEFmNTsjcYNgJGoXir8emYxqVZdzkRZZqd5NfS+cC5UHiUOh3V3r2+GiPOCGefm1Q9q7wy5msZFR/3VywMk3/XeyvO7GxMHetg8efjPWGBUnlX8DHY1B/SjnG/18/Ir+3OLiYkvFSnZgQtz0zaV31OG1ZPB2pOsXGNGBEgsbzwyIYydxiXqEat+p7Rvp2+jOMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sgzE68GSwKiwRpiz4WOeKQMcuHMbi+iFec+6hJQJXM=;
 b=HnvlOfyDrCIqBG0MP2aQj9oZMu9RmwBgiJJevDeO+y9JxpJKeRPyg8JokNHCSrJV12c2Jq/nmBeQKdaY4KfOU9XVE9Jzl1fx/ONYAkX5EhB5orW5zyrp9F6gxr/e9ZgZ2pczUEwXLFyb7ww6y7/nwZtwnjF04QRsyliyXBdUC+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9422.eurprd04.prod.outlook.com (2603:10a6:102:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 13:02:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 13:02:03 +0000
Date:   Sun, 2 Apr 2023 16:01:59 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next 3/7] net: promote SIOCSHWTSTAMP and
 SIOCGHWTSTAMP ioctls to dedicated handlers
Message-ID: <20230402130159.xwacksnmymmthxtm@skbuf>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
 <20230402123755.2592507-4-vladimir.oltean@nxp.com>
 <915c64ca-bbea-bfe9-3898-cd65791c3e5d@gmail.com>
 <20230402125328.wf5tkov3hhdvqjkm@skbuf>
 <cab59e73-5006-4558-d4db-a393d9e8d02c@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cab59e73-5006-4558-d4db-a393d9e8d02c@gmail.com>
X-ClientProxiedBy: VI1PR06CA0147.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::40) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc19bd7-8168-4f86-c0f1-08db337a7441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SOYSjZFJuqXCHBljCVU5tIXY/0ZqAqGgv4+tb1twT/mwao6xVlv28gZ14S3AV9JyGBxmj12h1dGGXt54gP+qE9YHZdPxsaUEEwsFafIv4J6xTY64U3F1Vrh/djklsqxHL9GekVCFCbh2SnpfWfh18mFYzyibgFR/9sFABlQCKj2aIzyzJTdrENFg7gJndaIwEtgJ9IM/l+eY6UC0fiWeIKtEKPxs0rbE9UZIBaqOSJR0iEVGEXX9L3H0qtE7Q6jC52n/RIjPCWcfpDnhc+8xOsO5v8aF49ERWM0Wq+IJKuu3+0Q8tXoHs4By26xeeZ4WA48RHvSyMBj5lSnCyLdT2s0J/dIvIG6i/JSFSIrZoHthKyb5zJRaoHBP3XLDDsHTSY3CCaxY5HLsx+2VNWyIaVmLC+fcaS5JkhGDblGnHZcJ4cuHb7wz7Xy4qXFT9OrUqQbRWwZeiF0wSpSu3lkVSYyYoHAvwuojNumNjqgyynp+jbJaj7WBmxtdJRYkwpHdT75z3uC0IWj+RQXA+XUaKEGOIJw/h2XiovJq8By03B8TAJ04LztkZTXnmxtiWNlj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(6512007)(9686003)(186003)(53546011)(8936002)(8676002)(5660300002)(41300700001)(4326008)(66476007)(66556008)(66946007)(6916009)(2906002)(4744005)(6486002)(3716004)(6666004)(44832011)(7416002)(316002)(54906003)(478600001)(86362001)(38100700002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OKmZC03ZSEzMPvjDCEZK5mk8I8g1RtAPbk1XFD7kJAp7zYUiMUi8ZROZ0LCo?=
 =?us-ascii?Q?IjVXK7HU/LTg8xSy9i6eDAdycMY9uv4b0vaErhi3hnZmz1OQJlVAmSBmK74E?=
 =?us-ascii?Q?KlllstpKJKTaRKjnqv3JPdSm7gJTbAOAJCGF6fcmcXIomNX/qJpHZADb99Ms?=
 =?us-ascii?Q?aRFnpXQd51EjNemHMgixIZn8O1J3qA/UUBEhnAY6OLuSldHWpgV+V9UxWCOo?=
 =?us-ascii?Q?/7k0ZJ67tdP0fVmpO1OQ5L5TIwldukQNtWOeuzp8OqQaGwDj6PmANL/KQpbb?=
 =?us-ascii?Q?Vz1H0LGd+OZ/mr5sBPVtu+Vw6FVgo3WqI5gjQpVBRJj/2UePChoNw6ObZKAh?=
 =?us-ascii?Q?QhiZrH7jDv/ZsJj7PpgWMSUuAWp/OgbUtth6kQW9mj0G9zoi71Ffgz8VgyCE?=
 =?us-ascii?Q?RzDPflEBjU4/5CqMDUdU8tDQ4KLVtUIxOsqJmFOkvLXlKOm/wPW92+QrRQqC?=
 =?us-ascii?Q?JA4qRfRpwTVodIYBYlqqoRtNerX05Yjd4lY97+3xJXkgu/Nkz3F3+2g3vTCk?=
 =?us-ascii?Q?r/CzRknCRuQgSze5eWbOgh9cLKtxZNKnRBqMNAVlQ5Zx1c5UHT3YfayhMGrT?=
 =?us-ascii?Q?bXFmZFr5E4wTEnDNtQ0IS6WKtGBWN9D3vIfFNzAT2wr3/Uu3uTYnlDWg+UbY?=
 =?us-ascii?Q?lNVNeuf1nqe5pTkSdqjZASLjewqfRZCjCB0bUkj5OH6878e2ZQtCiSDas6F2?=
 =?us-ascii?Q?EdotI8Trx2XYlYFSPoYVAIeAA5z8ELIsKvC755EvPIsWbk4aTWQnpQ0b+LQX?=
 =?us-ascii?Q?pVqa4EL017cE+kOfBsUeBkU4/t7o+8tLFXUU12J9zKqyQMD0vH11I/lS0yJR?=
 =?us-ascii?Q?IRA6bFGBsShb4rBZARA/ZmRVKdXyY93cjMwG6XNbfArcFia50VFDX/mvfKmv?=
 =?us-ascii?Q?rZMsjP/7FJDVsmhHu0Zkw7MAMRUGg+NNQKFUKbldNxes3GXh4apH/hPtSzO5?=
 =?us-ascii?Q?eq7AFxHJjpc+hlR1kEcmXnxEJnCBirEeSdGhTapPK+I3G2qQ8+179N5o3/8v?=
 =?us-ascii?Q?VioJ1DTZ1oaG8Vvkq3HJ8n4QbtCEMFFMgGmnFDI8vF3eV0iq+VtwFMwCP3kp?=
 =?us-ascii?Q?JKJNTdBV3irdpSLkhIV4+MGHNWDwBZ6piAVvLyzgoi4XMPupxYzMR9URROnl?=
 =?us-ascii?Q?/AQCf0FjUGYf4it7YIFk7bevlH7158TUGdLBIXgOD/EP7FXF2JmExp7mcFE3?=
 =?us-ascii?Q?hft8K2RI37gbDsCm9TCV0JuVj1Rl2N4gNzI+V4beW7C8k7LTxS8JYFeU/Ja/?=
 =?us-ascii?Q?V+JcFtKpM8+3FS3k8zlxJbLTO+CZgHIRpwvKTwPyYYM1iNh4z9d61Sd3Ow7f?=
 =?us-ascii?Q?Zql1qbkJAF8Lsd13jk8syTVeyooTSqxjCdLKJ4OLe+/zxWwZTnNn/Ry37OPc?=
 =?us-ascii?Q?061jV1IAInlVbPS5GlMQqJoR+HvWDl/vXsVXqhZLsz5H7hbhk/OccgXB2x67?=
 =?us-ascii?Q?+c+2IWvRxVVCose+ys2aawy4aEdFaF6fQBSDDkAUvbFtpT6Guc7GjCVrY82C?=
 =?us-ascii?Q?JvVsWTuZ4wscZl61agC4FM1m4ZAUTu+TH1k4T+dv4TS6nZU08ZyXmbiNDg7O?=
 =?us-ascii?Q?/oZ1ZCNhF2++A6kMxpIN3jMj15S8XH6F//McMH/pdWbrzHxRWX7CSZEMt6Oa?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc19bd7-8168-4f86-c0f1-08db337a7441
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 13:02:03.6691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJU5wkHwrq1SFS00pRJts6hIquiGftqtpDimZMAs3uMm4MHZXCLREw1OogimAVbnX1DfgXVdj2aZRiy3SStgkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9422
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:56:33AM -0700, Florian Fainelli wrote:
> 
> 
> On 4/2/2023 5:53 AM, Vladimir Oltean wrote:
> > On Sun, Apr 02, 2023 at 05:52:29AM -0700, Florian Fainelli wrote:
> > > PS: there could be some interesting use cases with SIO(S|G)MII(REG|PHY) to
> > > be explored, but not for now.
> > 
> > You mean with DSA intercepting them on the master? Details?
> 
> Humm, maybe this is an -ENOTENOUGHCOFFEE situation, if we have a fixed-link,
> we would not do anything of value. If we have a PHY-less configuration same
> thing. So it would only be a sort of configuration where the switch side has
> a PHY and the MAC connects to it that would be of any value.

But the last case could be handled directly through a phy_mii_ioctl()
issued by the DSA master's own ndo_eth_ioctl() handler, no need for DSA
to intervene, right?
