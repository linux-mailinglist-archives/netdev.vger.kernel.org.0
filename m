Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B776D397A
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 19:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjDBRhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 13:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBRhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 13:37:04 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2047.outbound.protection.outlook.com [40.107.7.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9641A974F;
        Sun,  2 Apr 2023 10:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkhDpTNXK2aEd+DKPTRtOUB0H1y19jlXneEYAGmQFKZD/IW/ppVIjx6x7Xtr1CT8k9vzwoNhp9f8z8QwGwTR5E5DjGo7UDIb5TJ6sVsuz8rT8OHsHFrlsF9tiZTVMKvXVaKe9tQ9G5Eqj2z5gBdXyFI+eAadXQ5B72iy4p4g/dyn1HtHdoO+k/LpzBP7k/WPSZQx/UY4nPS+bAFk3DQsqUVHHXW7+BfSiLtcdc5Mm/HoWamGtnLDbzNqmnHKPCsH00feR87ErJtgjTL/bH/yZq9yJvFcspxTUv4qsICIdX+/+Yr3r7jYL/AWLx7nDXtfBX9PpkMTkwflPC2WnOWW8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQe1KLcU9WJhwSyIS9iip/ilK0zsh+X2MFd84/Gh8v8=;
 b=g7bsUESDmErncShg4N9WZnb3ppufUAOfVUicC5TrlrONO7NWCq8RfNyPpXSXbUnu/9AvAGoopeABfB0MYkeoZuh2+Vwp2g1v/6uMmrUTcbDopSpyp05+K4dZJfayyFSbuYe4FYkDqpuEtgNPmO1us3GV27rfZGgXLaZBTr07Cszuy2UbM1mVx9Rs7SM+qCJVWvmLl4h0vOcTxWLzxeszMIkczttfuvTyW6uBz3nogemdE8ucZKAV6CJrNznKK/NMqtlQEvFbgUrUoLXtrdhdCia0QSIehXH5xBmKpQNzRnJqKBeC3UBuL3q2cn+vIiCAQyqZkTv8naorB1Kq16EZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQe1KLcU9WJhwSyIS9iip/ilK0zsh+X2MFd84/Gh8v8=;
 b=II4rgRCxN2LKl6eVOJ03/JPNAKKgVOdNouhFZJd3sV7xKLRI9TCCwqnafeXHcDRJ3ZWsDMaC5t4/BVUf1XAMTsPwQ2ogfts7F9/57pzQVOmjrcm9Rch76OByYAohNFwQNasjgRx4STEfr9zqCXE+RCI3vrYMRSzOI9Jx1mQo3B4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB9857.eurprd04.prod.outlook.com (2603:10a6:800:1d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Sun, 2 Apr
 2023 17:36:58 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 17:36:58 +0000
Date:   Sun, 2 Apr 2023 20:36:53 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
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
Message-ID: <20230402173653.io626sjyslppp7fd@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <20230324112541.0b3dd38a@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324112541.0b3dd38a@pc-7.home>
X-ClientProxiedBy: VI1PR0501CA0033.eurprd05.prod.outlook.com
 (2603:10a6:800:60::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB9857:EE_
X-MS-Office365-Filtering-Correlation-Id: a121f733-a8c8-4668-ba4e-08db33a0dbec
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LS2wxjBSCqG9n9bAVkQJGm2A8pd29UNyBfIWWIOxsNP3XioXTF0tpA0HMT4+3vhSfYHAL99IwQjA+vtQvfiZHC9I+YXZpard4a79TM7iRuywc6NRYRolPvMggKeJobqdWy6fp6FA75L4EQ5GgQnw938Fnmf/smLSO9w8cWzuK2rNiEPjkqNNFoft3Rz2byuOkkwX9VupNe/CovQ6UYPM3jK44bRpwtJ0+e3OMFdP6iV+XOjuaO8ZgiRK5gu7ivhnV2QYR0F5RcnGEq3kUrPrtCn+RWuNh6twYvnHkkXNMK/Ab9b+NY3LRVIpMYvyUsagtK86ZIqwnXrzUrEd5cG0ZKc82O+8ThTzs2HZqjtq8Vul3GVz7fc8NCBIjPKVjrE+o3JwmPmsroDsTUfMbQkpuox5oE4J2Aqm4P1S/pRUr9vBgQf2xiTpdHeE5pEHKLeQDzfbb7X7UkM3tj14qkehdPZNxHt5MkaATlP0WxyqDeQZwPdt1d9Azd7oLmwmvPzVODtMGvU8jNAJlnDXcp15xvhRxZCNwxdfWDaGXyNPV1ybNAwRuwV/MxzylXUtM7tQ7hqe0c/FEFCxRtG5VqrzUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(136003)(39850400004)(376002)(346002)(366004)(451199021)(38100700002)(966005)(6486002)(9686003)(83380400001)(6506007)(6666004)(186003)(1076003)(6512007)(26005)(44832011)(2906002)(7406005)(5660300002)(8936002)(7416002)(54906003)(478600001)(8676002)(6916009)(4326008)(66476007)(66556008)(66946007)(41300700001)(316002)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n41K+EYzxhyFrclsvsXzRzbc0kMI9l1dZV+pk9+RThrspsTcs8GDuzcbdE46?=
 =?us-ascii?Q?IW7Ib+cPQQ5gWXpj96yW9q8jUXzzduOJidyQGbL7DsPL8UDRw+4b5F1hXiOg?=
 =?us-ascii?Q?gW/TqPi+c1ssNgI5jKTf1iteaLTf2Z0GIK+fqkx6N83RY64MNbZDCvCNqub4?=
 =?us-ascii?Q?k4HvL58p7JEu36KUUrxnOn1GvETu/9qZ25xH4sLMiYk6sDF4r1UYivFWFCya?=
 =?us-ascii?Q?TkyZFZMFhNSNVB5Voxwgy3FROlFHwhDVRrBzUQGr753t8YXSu/Du/tdtcWH/?=
 =?us-ascii?Q?Oxiyz4dFJ82doKR7VwLY/B7K99utv/fvFWzFsvVpaPVaYzqiCjp/XhwpbvIV?=
 =?us-ascii?Q?ajmIJK14Q92m2xyUdJZZn46ynYCv/qpy3vhOSDIYBJckaW6RdZOZFeptcxl8?=
 =?us-ascii?Q?Ue5XJiE29eajoLK/0jaDSVuoWqkqCPeiKQzyXQo51ZtHG8Ndpbxq0O8hO3zQ?=
 =?us-ascii?Q?FXvT6oNt2RJoLMzleAna0oTq6TTfjOaQulv9kIqB4HrEmgtJqXwNkm/Mh+8V?=
 =?us-ascii?Q?hKkRfXzScGoLwCschP38wi4D5nIWuWNuRyepnROkTc+FCOCiDDJV/1Tc42cL?=
 =?us-ascii?Q?uggnCjhasxuwOyVcB9P+f3QXVrYFTiokBGTW2+LwRf+k3SmwVaSpdNBIvb6D?=
 =?us-ascii?Q?sFH1BWh9H5lCdGGVGZqMZX5q185V0h1ooUm8+Rp1zbIerrs2gZ3k6DH9kDFH?=
 =?us-ascii?Q?k2eXP+v+lKqVqJ4WamOtrAaHd/y1JFgc8AS5y2k0WTfz2C2N6TEiKEaH+xhr?=
 =?us-ascii?Q?lVuM31V4J0TpB/+VCqfl9x7hqD2jtFogvO8CDrNqiWj676rdz5H69Dr5tBR2?=
 =?us-ascii?Q?nUJDQObu1mvoRjBX3ZpNV+MhIX/G5dFLAFwFpYjtPRsRRpNSHRhDmKkALIK1?=
 =?us-ascii?Q?7QH/HEXBtSey1z1Gi8ekXdbs/0n8LVKP3f2nX8UMXtgEAtEyyAaNZb4X9cOo?=
 =?us-ascii?Q?NperfeRxQHpccKAbaJ0F4yYlqEWuOSLJLlvvcRSvsh+f8R/SJg61Wg8wNVwa?=
 =?us-ascii?Q?gimUSKC5L1gO6FcibpSoT+lNJQIcbn8qZmJWpG9fcB7Kvrttg2axyh5HUj4z?=
 =?us-ascii?Q?x02QlCdHm7FtYlS4UsTmK8Cfmq1OYz3ljmPSBbV69HTtv9nLrrA7oW3F8A/T?=
 =?us-ascii?Q?BbN0cIOBFYOR4L6IF3jPBAmQZ/7INmLFhEX8Z2ZNbTrrnde/p8rGkp+bHERM?=
 =?us-ascii?Q?fsbHVx8gwt1jrmyEQyGS03Ci403ypOFqxY632oL+KK7A9qK/Jmg6R0JjPvGB?=
 =?us-ascii?Q?vYRlhMYggMbwHRCm5kJ5sHM/P1qNGZzXuRdF41TkuWuC+m23/ICvRq7Q5C25?=
 =?us-ascii?Q?3hb0nO44rRAHqhdwYY3MRse1y6n5DSY0JdpU4WGWiwsOauC+RfngXFa9VfaM?=
 =?us-ascii?Q?ysInBObWnBi3wfmUK9s12VYc0ORj98SJn0Q+jhnpUPocaWM2DWL6Z9vaqNf+?=
 =?us-ascii?Q?yYfSmPDwaomWwjMfez1z9muTI8naffQuBwMk1tSJs9+HUmSYa+UP+hNgpdgt?=
 =?us-ascii?Q?McypP90Ns6T1701/N2ljLj4HhtIWjKNcoyVyjEYFN5ox877FVFa7duLVlkwv?=
 =?us-ascii?Q?XTtKcLDDBclO4Smq+BsdU2dDniRENEZJ1vt1y2IVC0qeFePCth/m6LMRa1Ni?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a121f733-a8c8-4668-ba4e-08db33a0dbec
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 17:36:58.2717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/BGOm2Po/3PTL7+Nb4k1t+A0f89ivze0jntPxNa7Px5tXDpxSbYCwgup2pY/zVL/XyBvLRxcqnk9Hj8PwTHHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9857
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Maxime,

On Fri, Mar 24, 2023 at 11:25:41AM +0100, Maxime Chevallier wrote:
> I'd like to point out a series sent a while ago :
> 
> https://lore.kernel.org/netdev/3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.com/
> 
> Here, the MAC's timestamping unit can be configured in 2 ways, which
> boils down to either more accurate timestamps, or better accuracy in
> frequency adjustments for the clock.
> 
> The need is to be able to change this mode at runtime, as we can change
> the clock source for the timestamping unit to a very precise-one,
> therefore using the "accurate timestamps mode" working as a
> grand-master, or switching to slave mode, where we would sacrifice a
> little bit the timestamping precision to get better frequency
> precision.
> 
> So, we can consider here that not only the MAC's timestamping unit has
> a non-fixed precision, but if we go through the route a a new API,
> maybe we can also take this case into account, allowing for a bit of
> configuration of the timestamping unit from userspace?

How would you suggest that this API looks like, what would be there to
configure on the timestamping unit? You're not looking for something
specific like "fine vs coarse" to be accepted, I hope?

Perhaps the stmmac is patched to expose 2 PHCs, one for fine mode and
one for coarse mode, and the timestamping PHC selection enables one more
or the other? In other words, if we expressed this stmmac specific thing
in vendor-agnostic terminology that we already understand, would that work?

The ability of a single MAC to register 2 PHCs might be useful for TSN
switches as well. Long story short, sometimes those expose a free
running clock (uncorrectable in offset and frequency), as well as a
correctable one, and they give the option for PTP hardware timestamps to
sample one clock or the other. TSN offloads (tc-taprio, tc-gate etc)
always use the correctable clock, and 802.1AS / gPTP has the option to
use the free running clock. I'm not interested in this personally, but
there were some talks about the value of doing this some time ago, and I
thought it would be worth mentioning it in this context, as something
else that could benefit from a more generic UAPI.

> > Is it plausible that over time, when PTP timestamping matures and,
> > for example, MDIO devices get support for PTP_SYS_OFFSET_EXTENDED
> > (an attempt was here: https://lkml.org/lkml/2019/8/16/638), the
> > relationship between PTP clock qualities changes, and so does the
> > preference change?
> 
> I'm not exactly familiar with PTP_SYS_OFFSET_EXTENDED, but it looks a
> bit similar in purpose to the above-mentionned use-case.

Nope, not similar at all.
