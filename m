Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE96A6D3960
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 19:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjDBRNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 13:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDBRM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 13:12:59 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2073.outbound.protection.outlook.com [40.107.249.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411EC448B;
        Sun,  2 Apr 2023 10:12:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUBGpPpr509HyB3LFNpLAEKvSwrtFsSf4mdqs+h/r3+dTEf1i7I5eigVKNUg2cFSgpUE/Kwj1BiT2+4xSpod3eokTcjsEDlXwDCkqeDFiFrmTF+vgEZ+OaX5QMD5UPP/LKu4DTNwYIBwVkzRrjljzvJPS85I4tOZGs8vhbClpFBCCfMl9PNpBVhmGN+WPu9zd9cHzfKMIkqQOloEiM7qKaX3n4l0KFzh4j0kqh/pnmKBDBmkwjghJzVQVEnwinzZtH0A+uHb8CSoOLZNZ5fWLCA/7hsC+ZN+Kf23U4C4taH5gSc64U/ki0fmwV6v+UBTrVkya6Nxd6vpFkbUe8F6CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGhz0eNrN/UJvzwoo7TGLMncW1RQPnXBdJVKe/Wpha0=;
 b=Gpx2imjJFfmIPj/4pxGCnIhbh9G6lwiyw0PR9YJ0mK+xh4Yixh3IR8aqUdOXhVP0hYvCi2NbS+g3bVVaLn+FE+1PBI0uaPdDrx21yupyQpEnPQYeVmR8Z1jpXAN2Eq6v4CMUzMm0mp8n4ECLPMisDl2orW+KWu3LvEWh51CzlDNWdkkoxQ/EtaO+OXqj2MZ7Gw/71Hc17yUwbzT/Jq4M1TaQqFsM1WA0/InGI5NtaaiWhxEvdwz2kaUofEGaZii3KhV4KXXmnL7SXKzareozIM7PIlrFSf+kzc9gj1tbpLFWQANiifVMX9lx7YtyG+RLEtYJKgRWaQgzZEsLvlZZNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGhz0eNrN/UJvzwoo7TGLMncW1RQPnXBdJVKe/Wpha0=;
 b=hEZtkmtNfmSErcFY2FdqINLidpylzGUlr7YKnI2BtJSdsNzMf8B4P8jfj7NQ4wNRe7LI7AAQP5NBAX3PLz5uAQJz9+mw3BBU/LfDfj9e4Zx9NAy/+sD7cTg71YB50m+Dd3qdxcGFLH23+NKi87FKemgIUtuxC6FHh4Y99itU28w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9397.eurprd04.prod.outlook.com (2603:10a6:102:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 17:12:54 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 17:12:54 +0000
Date:   Sun, 2 Apr 2023 20:12:49 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     Max Georgiev <glipus@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Message-ID: <20230402171249.ntszn3wwvkjuyesg@skbuf>
References: <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
 <20230313084059.GA11063@pengutronix.de>
 <20230316160920.53737d1c@kmaincent-XPS-13-7390>
 <20230317152150.qahrr6w5x4o3eysz@skbuf>
 <20230317120744.5b7f1666@kernel.org>
 <CAP5jrPHep12hRbbcb5gXrZB5w_uzmVpEp4EhpfqW=9zC+zcu9A@mail.gmail.com>
 <20230330143824.43eb0c56@kmaincent-XPS-13-7390>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230330143824.43eb0c56@kmaincent-XPS-13-7390>
X-ClientProxiedBy: FR0P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9397:EE_
X-MS-Office365-Filtering-Correlation-Id: fc13f564-263c-4016-ac50-08db339d7f78
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NltjaVtHE2gpRXn551ALbcHgq+d2eXaptmD5LkHuTLeEfrRzcL2BUC6appjQ2EbHoV+35oxKX3I7DCCY/17dXEDP9a2thr+siMkwm36Hiz2Y7+GyRjAI1WAC7Frfc5BlzahskvvtFHdZF+tbG/jEwy9+FBFdq3rvzyqAgejH+2TwMuxhQqe+lTnvKr10X5bknmbxE/5KtPXBTgq1iUHX2Ck65bUfBEiSH5dxMhjIovhfqiIdfcPZLROb0F2s0f9LO0QlAIdqqdtqEDJbqLTjwGmi5cOq0bmO0kmjKC44yjiZ/wTL4CbYDuA5cm7TLsHgFJ1yb7OfD7DfrdUnafqmK7gw36FLbaC9IsKyDLGagLV9I/w4ytviNGCaZIgODezDqd/P2tvm0bBw71Mh0cwpWcizsRrr7CDpGsQ/sQsn0R2wDlYbx+RA88JpmH2D3SJsxheIpbf8fT46wmMR2qR84te2zLZkLdnpWbmb6XW4wcv0re3yOhQpqaLkfnUrozqZfC+9I/K5E7BqX3Ox83XHiLj7ilqx2kLmE5Uupa1xKhEDNRHr3FrBMhUqGVUWHaN2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199021)(6486002)(478600001)(6506007)(6512007)(26005)(33716001)(1076003)(316002)(6666004)(54906003)(86362001)(186003)(9686003)(5660300002)(7416002)(7406005)(44832011)(38100700002)(4744005)(2906002)(66946007)(66476007)(66556008)(4326008)(6916009)(8676002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?6lpm1fe13pnhsR+bX7ArG1deqcmgSggqvUsNyqmEsFzjp46a4EqkiGk3u2?=
 =?iso-8859-1?Q?9bHrHwFOOdD74ctnwoDNX1KCT8R/mjOIRLHiGApWmeO4H66jqIsMsgw2aH?=
 =?iso-8859-1?Q?2L06EuvkLFgRzOZ5o6vJRmUrioHdcl2ftiz0PT7h1pyvc4qlJTPYn8RCdD?=
 =?iso-8859-1?Q?UL7Y26HbmV8zpYOtylcyVoSKqEji4ySu3nOR4bvxFsUXY7RoOn3PdBa+SB?=
 =?iso-8859-1?Q?3F2RTRTSZR14joltyA8hO6OSx3qJjy3JDQlg/qeNADjIzZVOHedW91+sh/?=
 =?iso-8859-1?Q?xUhlLyhDCUYZKN3pcX0A/qKXyT7Sl/ZkTm+6uCnZG8EawDC4utinMavpTc?=
 =?iso-8859-1?Q?yL9+/DZgD2P0cOZXGQoddQJGao0Yeyz0sJUvc/PX9LLbdj/EffS0tjOnOz?=
 =?iso-8859-1?Q?5dTxqGkO1f/zYRPmT/cP7SS1vsdiGt/aqVCFswNV4P0pn71y2iA2BoCP5G?=
 =?iso-8859-1?Q?CCjtqmaPD6rn5sRYxxWG89hj4ICzixR7IUtGTHA6qexFYmdCCMiTIl16Az?=
 =?iso-8859-1?Q?N4eO1cRP9IwqZb/XL2RrFg1AMf1+RqMKqhhvV6PTwx9xeO8+lu5tzXfVpM?=
 =?iso-8859-1?Q?JINNVlRP0aXUWT08XWycrBnjs4SWj0KgkO9joK+z0S+TkaxeTrsQ2RQujc?=
 =?iso-8859-1?Q?UV3wsqTDg2w7A1JO6n6Ox4xbBMouDn0VfrW/WObjWIV2vkK9q3x34FoaY4?=
 =?iso-8859-1?Q?XN2NzlD3KdACb2rlGmSHqpuPJvg/PMujxGsi/Iw8bG1WnE3c7O+FIXu7dG?=
 =?iso-8859-1?Q?LGl8B2WdzfChc4AnH9Pwf6BepGamqUnTfCRyKtCxk78k0NhqQNEWXi81ug?=
 =?iso-8859-1?Q?x4AYJt7AhqA57WUb29R37wbGZDM9qf+MKudHV1VKoktCQpqruitP3S1nGh?=
 =?iso-8859-1?Q?ezrPeBilZI3aAPFwGkLqcJ6BKqhp3YH3xypf52w4izlQFz9f3Uc9UgGVS2?=
 =?iso-8859-1?Q?Qjoa3BgB7jcg/p7lr7yFeLgS6Z4gMp5NoYGEPSVVyOq+Tg6omm2H4F8rsw?=
 =?iso-8859-1?Q?jz1YwCzjThNAKGmc2V1VglcOCfX4YlrAaLc3rbOjZpK70jj58h26YsDKHI?=
 =?iso-8859-1?Q?bP03RVmWjjLr4yAkkD1WyFjs/m8NMFHTmSjDhVKhQ2PE+rCjfj9/8wejMu?=
 =?iso-8859-1?Q?6yY9j5JUYcRC4DXUXnd8AC+ilpW9LKpoUkM1Ceb25mwdPqzzQimu3w5kM5?=
 =?iso-8859-1?Q?hdNwiG0ud16fb2L1ZBC+DzXmZDWeJSKagcJcFcng1rx4Wkvh07hWhfeUmL?=
 =?iso-8859-1?Q?h7JbPN71wHxHLXRVC++NVtHOnYNFmPBYB4Iw5A8Bx3fuZ/MhgE5gjJGilw?=
 =?iso-8859-1?Q?dqn7dFy6UUsbyGkkwa4sZjwVQHS+lFHqS+jxM/1zqaGEnxpnaIOBWr8eWi?=
 =?iso-8859-1?Q?y7P3wVpTY2DJknfSs0mFpo/q32GNzOhn+Tgrx1M/kaQGW1IxXbcJxLuIeg?=
 =?iso-8859-1?Q?8xSyo9gXJAL6jTJ1BuBVJQwz90QgDv9wevxBAHAZztFW/dfIC8UckqXoHq?=
 =?iso-8859-1?Q?kJaq8T9+8ojmTknxZ2j/34N4QTOphWS4cYWwTaMXIO+A1hDVn1oT/xeb7s?=
 =?iso-8859-1?Q?J2bzuRIBh1J0h9/DZDL7igxCAeNan+jOt9CxQHuIZlG3UVMTA9T59dZY8T?=
 =?iso-8859-1?Q?r7J9hPMzT3THQwU+M7BaLTT0q5jP2xiPud6+ftbGmoKN98Ky4ZNLiHWw?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc13f564-263c-4016-ac50-08db339d7f78
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 17:12:54.6351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3gzH64gNHK/WlStH+P9v62ULkV0f9V6tAd+AigTyTcS65dtTkLfK+cB5uCCzsdFXe3WdgHn15dmC0/i3CrcNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9397
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 02:38:24PM +0200, Köry Maincent wrote:
> Hello Max,
> 
> On Fri, 17 Mar 2023 13:43:34 -0600
> Max Georgiev <glipus@gmail.com> wrote:
> 
> > Jakub,
> > 
> > I started working on a patch introducing NDO functions for hw
> > timestamping, but unfortunately put it on hold.
> > Let me finish it and send it out for review.
> 
> What is your timeline for it? Do you think of sending it in the followings
> weeks, months, years? If you don't have much time ask for help, I am not really
> a PTP core expert but I would gladly work with you on this.

Köry, I believe you can start looking at that PHY driver whitelist
(for changing the default timestamping layer) in parallel with Maxim's
ndo_hwtstamp_set() effort, since they shouldn't depend on each other?
